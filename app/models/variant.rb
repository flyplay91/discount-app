class Variant < ApplicationRecord
	validates_uniqueness_of :shopify_id
	belongs_to :product, optional: true
	belongs_to :shop, optional: true
  belongs_to :vendor, optional: true
  has_many :price_levels, dependent: :destroy
  # accepts_nested_attributes_for :price_levels,
  #   reject_if: proc { |c| c[:item_qty].to_i < 1 || c[:item_wholesale_cost].to_i < 1 },
  #   allow_destroy: true

  accepts_nested_attributes_for :price_levels,
    allow_destroy: true

  serialize :vendor_ids, Array
  serialize :vender_sub_brands, Array
  serialize :vendor_types, Array

  # validates :supplier_sku, uniqueness: true, allow_blank: true

  enum supplier_type: {
    single_supplier: 0,
    decorator: 1
  }

  enum decoration_type: {
    _4cp: 0,
    screen_print: 1,
    tag: 2,
    embroidery: 3,
    laser_engraved: 4,
    debossed: 5,
    hot_stamped: 6,
    custom_tag: 7
  }

  enum ship_to: {
    eggers: 0,
    customer: 1,
    au: 2
  }

	self.per_page = 50

  def adjust_vendors
    if vendor_ids.length < 2
      (2 - vendor_ids.length).times.each do |i|
        self.vendor_ids << nil
        self.vender_sub_brands << nil
        self.vendor_types << 'single_supplier'
      end
    end
  end

  def common_attributes(csv_data)
    hash_decoration_type = {
      '4cp' => '_4cp',
      'Screen Print' => 'screen_print',
      'Tag' => 'tag',
      'Embroidery' => 'embroidery',
      'Laser Engraved' => 'laser_engraved',
      'Debossed' => 'debossed',
      'Hot Stamped' => 'hot_stamped',
      'Custom Tag' => 'custom_tag'
    }
    one_time_setup_fee = csv_data['One Time Set Up Fee'].to_s.strip
    one_time_setup_fee = one_time_setup_fee.blank? ? nil : one_time_setup_fee.to_d
    recurring_reorder_fee = csv_data['Recurring Set Up Fee'].to_s.strip
    recurring_reorder_fee = recurring_reorder_fee.blank? ? nil : recurring_reorder_fee.to_d
    attributes = {
      supplier_type: csv_data['Product Type'].to_s.strip == 'Single Supplier' ? 'single_supplier' : 'decorator',
      # size: csv_data['Variant Size'].to_s.strip,
      # color: csv_data['Variant Color'].to_s.strip,
      supplier_product_name: csv_data['Supplier Product Name'].to_s.strip,
      supplier_sku: csv_data['Supplier SKU'].to_s.strip,
      one_time_setup_fee: one_time_setup_fee,
      recurring_reorder_fee: recurring_reorder_fee,
      quote_number: csv_data['Quote Number'].to_s.strip,
      proof_photo_link: csv_data['Keepers Collective Product Shot Link'].to_s.strip,
      inventory_on_hand: csv_data['Inventory on Hand'].to_s.strip,
      enforced_multiple_quantity: csv_data['Enforced Multiple Quantity'].to_s.strip,
      item_qty_per_case: csv_data['Enforced Multiple Quantity'].to_s.strip,
      base_lead_time: csv_data['Base Lead Time'].to_s.strip,
      start_production: csv_data['Start Production'].to_s.strip,
      end_production: csv_data['End Production'].to_s.strip,
      additional_lead_time: csv_data['Additional Lead Time Notes'].to_s.strip,
      different_cost_based_on_quantity: csv_data['Different cost based on quantity?'].to_s.strip.downcase == 'yes',
      # ship_to: csv_data['Ship to (Eggers or Customer)'].to_s.strip == 'Customer' ? 'customer' : 'eggers',
      proof_number: csv_data['Proof Number'].to_s.strip,
      # supplier_proof_link: csv_data['Supplier Proof Link'].to_s.strip,
      logo_name: csv_data['Logo Name'].to_s.strip,
      logo_color: csv_data['Logo Color'].to_s.strip,
      logo_size: csv_data['Logo Size'].to_s.strip,
      decoration_location: csv_data['Decoration Location'].to_s.strip,
      decoration_type: hash_decoration_type[csv_data['Decoration Type'].to_s.strip],
      # artwork_url: csv_data['Artwork/Logo Vector URL'].to_s.strip,
      supplier_decorated: csv_data['Supplier Decorated or Blank Product'].to_s.strip,
      min_item_order_qty: csv_data['Minimum Order Quantity'].to_s.strip,
      max_item_order_qty: csv_data['Maximum Order Quantity'].to_s.strip
    }
  end

  def update_from_csv(csv_data)
    attributes = common_attributes csv_data
    attributes[:vendor_ids] = []
    attributes[:vender_sub_brands] = []
    attributes[:vendor_types] = []

    if attributes[:supplier_type] == 'single_supplier'
      attributes.merge! ship_to: (csv_data['Ship to (Eggers or Customer)'].to_s.strip == 'Customer' ? 'customer' : 'eggers'),
        supplier_proof_link: csv_data['Supplier Proof Link'].to_s.strip,
        artwork_url: csv_data['Artwork/Logo Vector URL'].to_s.strip
      v = Vendor.find_by_company_name csv_data['Supplier Name'].to_s.strip
      if v
        attributes[:vendor_ids] << v.id
        attributes[:vender_sub_brands] << csv_data['Supplier Sub Brands'].to_s.strip
        attributes[:vendor_types] << 'Supplier'
      end
      price_levels.destroy_all
      attributes[:price_levels_attributes] = []
      (1..5).each do |i|
        break if csv_data["Price Level/Volume Quantity_#{i}"].to_s.strip.blank?
        item_wholesale_cost = csv_data["Wholesale Cost Per Item_#{i}"].to_s.strip
        item_wholesale_cost = item_wholesale_cost.blank? ? nil : item_wholesale_cost.to_d

        item_sale_price = csv_data["Sale Price Per Volume_#{i}"].to_s.strip
        item_sale_price = item_sale_price.blank? ? nil : item_sale_price.to_d
        item = {
          item_qty: csv_data["Price Level/Volume Quantity_#{i}"].to_s.strip,
          item_wholesale_cost: item_wholesale_cost,
          item_sale_price: item_sale_price
        }
        attributes[:price_levels_attributes] << item
      end
    else
      attributes.merge! ship_to: (csv_data['Ship to (AU or Customer)'].to_s.strip == 'AU' ? 'au' : 'customer'),
        su_proof_link: csv_data['Straight Up/Keepers Collective Proof Link'].to_s.strip,
        artwork_url: csv_data['Artwork/Vector Link'].to_s.strip
      v = Vendor.find_by_company_name csv_data['Supplier Name - Vendor 1'].to_s.strip
      if v
        attributes[:vendor_ids] << v.id
        attributes[:vender_sub_brands] << csv_data['Vendor Sub Brand'].to_s.strip
        attributes[:vendor_types] << 'Supplier'
      end

      d = Vendor.find_by_company_name csv_data['Decorator Name - Vendor 2'].to_s.strip
      if d
        attributes[:vendor_ids] << d.id
        attributes[:vender_sub_brands] << ''
        attributes[:vendor_types] << 'Decorator'
      end

      attributes[:price_levels_attributes] = []
      (1..5).each do |i|
        break if csv_data["Volume Quantity_#{i}"].to_s.strip.blank?
        item_wholesale_cost = csv_data["Total Wholesale Cost Per Item_#{i}"].to_s.strip
        item_wholesale_cost = item_wholesale_cost.blank? ? nil : item_wholesale_cost.to_d

        decorator_cost = csv_data["Decorator Cost Per Item_#{i}"].to_s.strip
        decorator_cost = decorator_cost.blank? ? nil : decorator_cost.to_d

        supplier_cost = csv_data["Supplier Cost Per Item_#{i}"].to_s.strip
        supplier_cost = supplier_cost.blank? ? nil : supplier_cost.to_d

        item_sale_price = csv_data["Sale Price Per Item_#{i}"].to_s.strip
        item_sale_price = item_sale_price.blank? ? nil : item_sale_price.to_d
        item = {
          item_qty: csv_data["Volume Quantity_#{i}"].to_s.strip,
          item_wholesale_cost: item_wholesale_cost,
          item_sale_price: item_sale_price,
          decorator_cost: decorator_cost,
          supplier_cost: supplier_cost
        }
        attributes[:price_levels_attributes] << item
      end
    end
    price_levels.destroy_all
    
    puts "-----------------------------#{id}-----------------------------"
    puts attributes.inspect
    update! attributes
  end

  def clear_attrs
    update supplier_type: 'single_supplier', size: nil, color: nil, supplier_product_name: nil,
      supplier_sku: nil, one_time_setup_fee: nil, quote_number: nil, inventory_on_hand: nil,
      enforced_multiple_quantity: nil, item_qty_per_case: nil, base_lead_time: nil, start_production: nil,
      end_production: nil, additional_lead_time: nil, different_cost_based_on_quantity: false,
      proof_number: nil, supplier_proof_link: nil, logo_name: nil, logo_color: nil,
      logo_size: nil, decoration_location: '_4cp', artwork_url: nil, supplier_decorated: nil,
      min_item_order_qty: nil, max_item_order_qty: nil, vendor_ids: [], vender_sub_brands: [],
      vendor_types: []
    price_levels.destroy_all
  end

  def self.get_cart(cart_params)
    if cart_params.present? && cart_params[:items].present?
      line_items = cart_params[:items].map {|item| Variant.get_line_item(item) }.reject(&:blank?)
      # line_items << {
      #   title: "Processing fee",
      #   price: Shop.first.processing_fee.to_f,
      #   quantity: 1
      # }
      formatted_cart = {
        line_items: line_items,
        use_customer_default_address: true,
        note_attributes: cart_params[:attributes].to_h.map { |k,v| {name: k, value: v} }
      }
      formatted_cart.merge!(customer: { id: cart_params[:customer][:id] }) if cart_params[:customer].present? && cart_params[:customer][:id].present?
      formatted_cart
    else
      nil
    end
  end

  def self.get_line_item(item)
    variant = Variant.find_by(shopify_id: item[:variant_id])
    if variant.present?
      formatted_item = {
        quantity: item[:quantity],
        taxable: item[:taxable],
        requires_shipping: item[:requires_shipping],
        title: variant.title,
        sku: variant.sku,
        properties: item[:properties].to_h.map { |k,v| {name: k, value: v} }.push({name: 'variant_id', value: item[:variant_id]})
      }
      formatted_item.merge Variant.check_price_discount(variant, item[:quantity])
    else
      {}
    end
  end

  def self.check_price_discount(variant, qty)
    if variant.price_levels.present?
      price_rule = variant.get_price_rule(qty)
      price_rules = variant.price_levels.order(:item_qty => :asc)
      if price_rule.present?
        per_price = price_rule.item_total_markup_cost.to_f
        price_item = { price: per_price }
        if price_rule.id != price_rules.first.id
          first_per_price = price_rules.first.item_total_markup_cost.to_f
          value = first_per_price - per_price
          amount = value * qty
          if amount > 0
            price_item[:price] = first_per_price
            price_item.merge!(
              applied_discount: {
                description: 'Discount',
                value_type: 'fixed_amount',
                value: value,
                amount: amount,
                title: "Bulk Discount"
              }
            )
          end
        end
        price_item
      else
        {price: variant.price}  
      end
    else
      {price: variant.price}
    end
  end

  def get_price_rule(qty)
    price_rule = nil
    if self.price_levels.present?
      price_rules = self.price_levels.order(:item_qty => :asc)
      price_rule = price_rules&.first
      price_rules.reverse.each do |rule|
        if qty >= rule.item_qty
          price_rule = rule
          break
        end
      end
    end
    price_rule
  end

  def real_vendor_ids
    ids = (self.vendor_ids || [])
    ids.reject!(&:blank?)
    ids.uniq!
    ids&.map {|vendor_id| vendor_id.to_i}
  end

  def artwork_exist
    self.supplier_product_name.presence || self.proof_number.presence || self.supplier_proof_link.presence || self.proof_photo_link.presence || self.logo_name.presence || self.logo_size.presence || self.logo_color.presence || self.decoration_location.presence || self.decoration_type.presence || self.artwork_url.presence
  end
end
