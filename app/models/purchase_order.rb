class PurchaseOrder < ApplicationRecord
	belongs_to :shop, optional: true
	validates :draft_order_id, presence: true, uniqueness: true
	has_many :purchase_order_items, dependent: :destroy

	def api_data
		Shop.first.with_shopify_session do
			client = ShopifyAPI::GraphQL.client
	  	query = <<-'GRAPHQL'
	    query ($id: ID!) {
	      node(id: $id) {
	        ... on DraftOrder {
	          id
		        name
		        createdAt
		        invoiceUrl
		        status
		        totalPrice
		        completedAt
		        lineItems(first: 50) {
		        	edges {
				        node {
				        	name
				        	discountedTotal
				        	discountedUnitPrice
				        	originalUnitPrice
				        	originalTotal
				        	product {
				        		id
				        	}
				        	customAttributes {
				        		key
				        		value
				        	}
				        	appliedDiscount {
				        		amount
				        		description
				        		title
				        		value
				        		valueType
				        	}
				        	quantity
				        	sku
				        	requiresShipping
				        	taxable
				        	title
				        	variant {
				        		id
				        	}
				        	variantTitle
				        	grams
				        	weight {
				        		unit
				        		value
				        	}
				        }
				      }
		        }
		        customAttributes {
	        		key
	        		value
	        	}
		        customer {
		        	firstName
		        	lastName
		        }
		        order {
		        	id
		        	name
		        }
	        }
	      }
	    }
	    GRAPHQL
	    variables = { 
	      id: "gid://shopify/DraftOrder/#{self.draft_order_id}",
	    }
	    Kernel.const_set(:OrderQuery, client.parse(query))
	    result = client.query(OrderQuery, variables: variables)
	    result.data&.node
	  end
	end

	def append_attributes(custom_attributes)
		draft_order = self.api_data
		client = ShopifyAPI::GraphQL.client
		query = client.parse <<-'GRAPHQL'
      mutation ($input: DraftOrderInput!, $id: ID!) {
        draftOrderUpdate(input: $input, id: $id) {
          userErrors {
            field
            message
          }
        }
      }
    GRAPHQL

    total_attributes = PurchaseOrder.make_custom_attributes(draft_order.custom_attributes, custom_attributes)

    variables = {
    	id: draft_order.id,
    	input: {
    		customAttributes: total_attributes,
    		lineItems: PurchaseOrder.make_line_items(draft_order, total_attributes)
	    }
	  }
	  puts PurchaseOrder.make_line_items(draft_order, total_attributes).inspect
    result = client.query(query, variables: variables)
    puts result.inspect
	end

	def generate_po_items(vendor_ids)
		shop = Shop.first
		vendor_ids.each do |vendor_id|
			PurchaseOrderItem.create(shop: shop, purchase_order: self, vendor_id: vendor_id)
		end
	end

	def self.make_custom_attributes(existings, additionals)
		excludes = [:CustomerInfo_FullName, :CustomerInfo_Title, :CustomerInfo_EmailAddress, :CustomerInfo_PhoneNumber, :CustomerInfo_CostCenter, :CustomerInfo_HomeOffice, :CustomerInfo_TeamProgramName, :CustomerInfo_SIDNumber, :Shipping_ShipType, :DeliveryNeededBy_Date, :DropShip_Addresses, :Single_ShipType, :SingleAddress_Address_Line_1, :SingleAddress_Address_Line_2, :Shipping_Name, :SingleAddress_City, :SingleAddress_StateProvince, :SingleAddress_CountryRegion, :SingleAddress_CountryCode, :SingleAddress_PostalCode, :DropShip_Address_Type, :Address_Attachment_Type, :DropShipAddress_Attachment_Text, :DropShipAddress_Attachment_File, :Disclaimers]
		existings = existings.to_a
		additionals.each do |key, value|
			existings.delete(existings.select{|c_attr| c_attr.key == key }&.first) if existings.present?
		end
		existings.select {|c_attr| !(excludes.include? c_attr.key.to_sym) }.map {|c_attr| {key: c_attr.key, value: c_attr.value} } + additionals.to_h.map { |k,v| {key: k, value: v} }
	end

	def self.make_line_items(draft_order, total_attributes)
		line_items = []
		po_line_items = draft_order.line_items&.edges

		PurchaseOrder.key_value.each do |key, value|
			line_item = po_line_items.select {|p_line| p_line.node.title == value}.first if po_line_items.present?
			selected_attr = total_attributes.select {|c_attr| c_attr[:key].to_sym == key.to_sym}.first
			if selected_attr.present?
				if line_item.present?
					new_item = {
						originalUnitPrice: selected_attr[:value].to_f,
						quantity: 1,
						title: line_item.node.title
					}
				elsif selected_attr[:value].present?
					new_item = {
						originalUnitPrice: selected_attr[:value].to_f,
						quantity: 1,
						title: value
					} 
				end
				line_items << new_item if new_item.present?
			end
		end

		po_line_items.each do |line_item|
			line_item = line_item.node
			next if line_item.title.present? && PurchaseOrder.key_value.select {|k, v| v == line_item.title}.present?
			if line_item.variant.present? && line_item.variant.id.present?
				data = {
					customAttributes: line_item.custom_attributes&.map {|c_attr| {key: c_attr.key, value: c_attr.value}},
					quantity: line_item.quantity,
					variantId: line_item.variant&.id
				}
			else
				data = {
					customAttributes: line_item.custom_attributes&.map {|c_attr| {key: c_attr.key, value: c_attr.value}},
					# grams: line_item.grams,
					originalUnitPrice: line_item.original_unit_price,
					quantity: line_item.quantity,
					# requiresShipping: line_item.requires_shipping,
					sku: line_item.sku,
					# taxable: line_item.taxable,
					title: line_item.title
				}
			end
			data.merge!(
				appliedDiscount: {
					amount: line_item.applied_discount.amount,
					description: line_item.applied_discount.description,
					title: line_item.applied_discount.title,
					value: line_item.applied_discount.value,
					valueType: line_item.applied_discount.value_type
				}
			) if line_item.applied_discount.present? 
			line_items << data
		end if po_line_items.present?
		line_items
	end

	def self.key_value
		{
			Total_Processing_Handling_Fee: 'Processing & Handling',
			Total_DropShip_Fee: 'Drop Ship Fee',
			Total_Taxes: 'Total Taxes',
			Additional_Packaging_Fees: 'Packaging Fees',
			Additional_International_Fees: 'International Fees',
			Additional_DesignArtFee: 'Design & Art Fees',
			Additional_ThirdParty_ShippingFee: '3rd Party Shipping Fees',
			Additional_ThirdParty_ShippingNumberFee: '3rd Party Shipping Number Fee',
			Additional_DigitizingFee: 'Digitizing Fee',
			Additional_AssemblyFee: 'Assembly Fee',
			Additional_CardInsertFee: 'Card Insert Fee',
			Additional_BrokenBox_Fee: 'Broken Box Fee',
			Additional_SetupFee: 'Additional Setup Fee'
		}
	end

	def self.maps
		{
			CustomerInfo_FullName: 'Name',
			CustomerInfo_Title: 'Position/Title',
			CustomerInfo_EmailAddress: 'Email Address',
			CustomerInfo_PhoneNumber: 'Phone Number',
			CustomerInfo_CostCenter: 'Reference Cost Center',
			CustomerInfo_HomeOffice: 'Home Office',
			CustomerInfo_TeamProgramName: 'Team Program Name',
			CustomerInfo_SIDNumber: 'Employee ID',
			Shipping_ShipType: 'Ship Type',
			Single_ShipType: 'Single Address Type',
			Shipping_Name: 'Shipping Full Name',
			SingleAddress_CountryRegion: 'Country/Region',
			DropShip_Address_Type: 'Dropship Address Type',
			Address_Attachment_Type: 'Attachment Type',
			SingleAddress_StateProvince: 'State',
			DeliveryNeededBy_Date: 'Delivery Date',
			SingleAddress_Address_Line_1: 'Address',
			SingleAddress_Address_Line_2: 'Apartment, Suite Number, etc.',
			SingleAddress_City: 'City',
			SingleAddress_CountryCode: 'Country Code',
			SingleAddress_PostalCode: 'Postal Code',
			DropShip_Addresses: 'Number of Addresses',
			DropShipAddress_Attachment_File: 'Attached File',
			token: 'Cart Token',
			Tracking_Numbers: 'Tracking Numbers',
			internal_id: 'Internal ID',
			po_number: 'Shopify Order PO'
		}
	end

	def self.get_variant_id(line_item)
		line_item.node.variant&.id&.split('/')&.last || line_item.node.custom_attributes.select{|c_attr| c_attr.key == 'variant_id' }&.first&.value || Variant.find_by(sku: line_item.node&.sku)&.shopify_id
	end
end
