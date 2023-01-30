class Product < ApplicationRecord
	validates_uniqueness_of :shopify_id
  belongs_to :shop, optional: true
  has_many :variants, dependent: :destroy
  has_many :product_options, dependent: :destroy

  has_many :collection_products, dependent: :destroy
  has_many :collections, through: :collection_products

  self.per_page = 50

  def self.save_shopify(sproduct, object_type='webhook')
  	product_data = Product.make_data(sproduct, object_type)
    product = Product.find_or_create_by(shopify_id: product_data[:shopify_id])
    if product.present?
    	if product_data[:title].present?
    		product.update product_data
	    	product.update_variants(sproduct, object_type)
	    	product.update_options(sproduct, object_type)
	    else
	    	product.destroy
    	end
    end
	end

	def self.make_data(sproduct, object_type='webhook')
		if object_type=='api'
  		product_data = {
  			shopify_id: sproduct.id,
    		handle: sproduct.handle,
    		featured_image: sproduct.images&.first&.src,
      	title: sproduct.title,
      	tags: sproduct.tags,
      	vendor: sproduct.vendor,
      	product_type: sproduct.product_type,
      	published_scope: sproduct.published_scope,
      	body_html: sproduct.body_html,
      	published_at: sproduct.published_at,
      	p_created_at: sproduct.created_at,
      	p_updated_at: sproduct.updated_at,
      	shop_id: Shop.first.id
  		}
  	else
  		product_data = {
  			shopify_id: sproduct['id'],
    		handle: sproduct['handle'],
    		featured_image: (sproduct['images'].present? ? sproduct['images'][0]['src'] : nil),
      	title: sproduct['title'],
      	tags: sproduct['tags'],
      	vendor: sproduct['vendor'],
      	product_type: sproduct['product_type'],
      	published_scope: sproduct['published_scope'],
      	body_html: sproduct['body_html'],
      	published_at: sproduct['published_at'],
      	p_created_at: sproduct['created_at'],
      	p_updated_at: sproduct['updated_at'],
      	shop_id: Shop.first.id
  		}
  	end
  	product_data
	end

	def update_variants(sproduct, object_type)
		variant_ids = []
		origin_ids = self.variants.pluck(:id)
		if object_type=='api'
			sproduct.variants.each do |s_variant|
				variant = Variant.find_or_create_by(shopify_id: s_variant.id)
				if variant.present?
					variant.update(
						shopify_product_id: sproduct.id,
			    	title: s_variant.title,
			    	price: s_variant.price&.to_f,
			    	compare_at_price: s_variant.compare_at_price&.to_f,
			    	sku: s_variant.sku,
			    	inventory_policy: s_variant.inventory_policy,
			    	fulfillment_service: s_variant.fulfillment_service,
			    	inventory_management: s_variant.inventory_management,
			    	option_1: s_variant.option1,
			    	option_2: s_variant.option2,
			    	option_3: s_variant.option3,
			    	barcode: s_variant.barcode,
			      inventory_item_id: s_variant.inventory_item_id,
			      shop_id: Shop.first.id,
			      product: self
					)
					variant_ids << variant.id
				end
			end if sproduct.variants.present?
		else
			sproduct['variants'].each do |s_variant|
				variant = Variant.find_or_create_by(shopify_id: s_variant['id'])
				if variant.present?
					variant.update(
						shopify_product_id: sproduct['id'],
			    	title: s_variant['title'],
			    	price: s_variant['price']&.to_f,
			    	compare_at_price: s_variant['compare_at_price']&.to_f,
			    	sku: s_variant['sku'],
			    	inventory_policy: s_variant['inventory_policy'],
			    	fulfillment_service: s_variant['fulfillment_service'],
			    	inventory_management: s_variant['inventory_management'],
			    	option_1: s_variant['option1'],
			    	option_2: s_variant['option2'],
			    	option_3: s_variant['option3'],
			    	barcode: s_variant['barcode'],
			      inventory_item_id: s_variant['inventory_item_id'],
			      shop_id: Shop.first.id,
			      product: self
					)
					variant_ids << variant.id
				end
			end if sproduct['variants'].present?
		end
		self.variant_ids = variant_ids
		origin_ids = origin_ids - variant_ids
		Variant.where(id: origin_ids).destroy_all if origin_ids.present?
	end

	def variants_data
		self.variants.map do |variant|
      item = variant.slice :shopify_id, :inventory_available,
        :min_item_order_qty, :max_item_order_qty, :item_qty_per_case
      item[:price_levels] = []
      variant.price_levels.order(item_qty: :asc).each do |price_level|
        next if price_level.item_qty.blank? || price_level.item_sale_price.blank?
        sub_item = {
          item_qty: price_level.item_qty,
          item_sale_price: price_level.item_sale_price.to_f,
          item_total_markup_cost: price_level.item_sale_price.to_f * price_level.item_qty
        }
        item[:price_levels] << sub_item
      end
      item[:price_levels] << {item_qty: 1, item_total_markup_cost: variant.price, item_sale_price: variant.price} if item[:price_levels].blank?
      item
    end
	end

	def update_options(sproduct, object_type)
		option_ids = []
		origin_ids = self.product_options.pluck(:id)
		if object_type=='api'
			sproduct.options.each do |s_option|
				option = ProductOption.find_or_create_by(shopify_id: s_option.id)
				if option.present?
					option.update(
						shopify_product_id: s_option.product_id,
			    	position: s_option.position,
			    	option_name: s_option.name,
			    	option_values: s_option.values,
			      shop_id: Shop.first.id,
			      product: self
					)
					option_ids << option.id
				end
			end if sproduct.options.present?
		else
			sproduct['options'].each do |s_option|
				option = ProductOption.find_or_create_by(shopify_id: s_option['id'])
				if option.present?
					option.update(
						shopify_product_id: s_option['product_id'],
			    	position: s_option['position'],
			    	option_name: s_option['name'],
			    	option_values: s_option['values'],
			      shop_id: Shop.first.id,
			      product: self
					)
					option_ids << option.id
				end
			end if sproduct['options'].present?
		end
		self.product_option_ids = option_ids
		origin_ids = origin_ids - option_ids
		ProductOption.where(id: origin_ids).destroy_all if origin_ids.present?
	end

	def product_card_info
		v_data = self.variants_data
		min_price = 10000000
		max_price = 0
		v_data.each do |v|
			v[:price_levels].each do |p_level|
				if p_level[:item_sale_price] > max_price
					max_price = p_level[:item_sale_price]
				end
				if p_level[:item_sale_price] < min_price
					min_price = p_level[:item_sale_price]
				end
			end
		end
		{
			min_item_order_qty: v_data.map {|v| (v[:min_item_order_qty] || 1) }.min,
			min_price: min_price,
			max_price: max_price
		}
	end

	def shopify_url
		"https://#{Shop.first.shopify_domain}/admin/products/#{self.shopify_id}"
	end

	def product_url
		"https://#{Shop.first.shopify_domain}/products/#{self.handle}"
	end

  def vendor_names
    Vendor.where(id: variants.pluck(:vendor_ids).flatten).pluck(:company_name)
  end

  def vendor_brands
    Vendor.where(id: variants.pluck(:vendor_ids).flatten)
      .pluck(:sub_brands).flatten.uniq
  end

  def variant_brands
    variants.pluck(:vender_sub_brands).flatten.uniq
  end
end
