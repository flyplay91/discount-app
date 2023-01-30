class ApiController < ApplicationController
  protect_from_forgery with: :null_session, only: [:draft_order]
  skip_before_action :verify_authenticity_token, only: [:draft_order]

  def product
    product = Product.find_by shopify_id: params[:shopify_id]
    result = {
      processing_fee: Shop.first.processing_fee.to_f,
      variants: []
    }
    if product.present?
      result[:variants] = product.variants_data
    end
    render json: result.to_json
  end

  def multi_products
    products = Product.where shopify_id: params[:shopify_ids].split(',')
    shop = Shop.first
    result = {
      processing_fee: shop.processing_fee.to_f,
      products: [],
      customer_info_description: shop.customer_info_description,
      shipping_details_description: shop.shipping_details_description,
      single_address_description: shop.single_address_description,
      dropship_address_description: shop.dropship_address_description,
      dropship_noaddress_description: shop.dropship_noaddress_description,
      address_attachment_type_description: shop.address_attachment_type_description,
      delivery_needed_by_date_description: shop.delivery_needed_by_date_description,
      dropship_fee_charge: shop.dropship_fee_charge,
      terms_and_conditions: shop.terms_and_conditions,
      tax_rate: shop.tax_rate,
      disclaimers: shop.disclaimers
    }
    if products.present?
      products.each do |product|
        result[:products] << {
          shopify_id: product.shopify_id,
          variants: product.variants_data
        }
      end
    end
    render json: result.to_json
  end

  def draft_order
    formmated_cart = Variant.get_cart(cart_params)
    puts formmated_cart
    if formmated_cart.present?
      Shop.first.with_shopify_session do
        draft_order = ShopifyAPI::DraftOrder.create(formmated_cart)
        puts draft_order.inspect
        if draft_order&.invoice_url.present?
          render json: {invoice_url: draft_order&.invoice_url}, status: :ok
        else
          render json: {}.to_json, status: 404    
        end
      end
    else
      render json: {}.to_json, status: 404
    end
  end

  def cart
    cart = Cart.find_or_create_by(token: params[:token])
    if params[:attachment].present?
      cart.attachment = params[:attachment]
      cart.save
    else
      cart.update(full_json: params.to_json)
    end
    render json: {attachment: cart.attachment.presence&.url}.to_json, status: :ok
  end

  def filter_options
    collection = Collection.find_by(shopify_id: params[:collection_id])
    if collection.present?
      product_ids = collection.products.where.not(published_at: nil).pluck(:id)
      variants = Variant.where(product_id: product_ids)
      price_levels = PriceLevel.where(variant_id: variants.pluck(:id))
      response_data = {
        min_qtys: variants.order(:min_item_order_qty).pluck(:min_item_order_qty).uniq.reject(&:blank?),
        min_price: price_levels.minimum(:item_sale_price)&.to_f,
        max_price: price_levels.maximum(:item_sale_price)&.to_f
      }

      sizes = []
      ProductOption.where(product_id: product_ids, option_name: "Size").pluck(:option_values).each {|option_values| sizes += option_values}
      sizes.uniq!
      response_data.merge!(size: sizes) if sizes.present?

      colors = []
      ProductOption.where(product_id: product_ids, option_name: "Color").pluck(:option_values).each {|option_values| colors += option_values}
      colors.uniq!
      response_data.merge!(color: colors.sort) if colors.present?

      filter_collections = Shop.first.filter_collections.split(",").reject(&:blank?)
      if filter_collections.include? params[:collection_id].to_s
        response_data.merge!(business: ['Chase', 'J.P. Morgan'])

        styles = []
        ProductOption.where(product_id: product_ids, option_name: "Style").pluck(:option_values).each {|option_values| styles += option_values}
        styles.uniq!
        response_data.merge!(style: styles.sort) if styles.present?
      end
      render json: response_data.to_json, status: :ok
    else
      render json: {}.to_json, status: 404  
    end
  end

  private

  # def product_variants_data(product)
  #   product.variants.map do |variant|
  #     item = variant.slice :shopify_id, :inventory_available,
  #       :min_item_order_qty, :max_item_order_qty, :item_qty_per_case
  #     item[:price_levels] = []
  #     variant.price_levels.order(item_qty: :asc).each do |price_level|
  #       next if price_level.item_qty.blank? || price_level.item_sale_price.blank?
  #       sub_item = {
  #         item_qty: price_level.item_qty,
  #         item_total_markup_cost: price_level.item_sale_price.to_f * price_level.item_qty
  #       }
  #       item[:price_levels] << sub_item
  #     end
  #     item[:price_levels] << {item_qty: 1, item_total_markup_cost: variant.price} if item[:price_levels].blank?
  #     item
  #   end
  # end

  def cart_params
    params.permit(
      :token,
      :note, 
      { 
        items: [
          :quantity, :variant_id, :product_id, :taxable, :requires_shipping,
          properties: [:shipping_account_number, :reference_cost_center, :po_number, :internal_id, :address_name, :address_deliver_to, :address_street1, :address_city, :address_state, :address_zip, :country]
        ] 
      },
      attributes: [:CustomerInfo_FullName, :CustomerInfo_Title, :CustomerInfo_EmailAddress, :CustomerInfo_PhoneNumber, :CustomerInfo_CostCenter, :CustomerInfo_HomeOffice, :CustomerInfo_TeamProgramName, :CustomerInfo_SIDNumber, :Shipping_ShipType, :DeliveryNeededBy_Date, :DropShip_Addresses, :Total_Processing_Handling_Fee, :Total_DropShip_Fee, :Total_Taxes, :Single_ShipType, :SingleAddress_Address_Line_1, :SingleAddress_Address_Line_2, :Shipping_Name, :SingleAddress_City, :SingleAddress_StateProvince, :SingleAddress_CountryRegion, :SingleAddress_CountryCode, :SingleAddress_PostalCode, :DropShip_Address_Type, :Address_Attachment_Type, :DropShipAddress_Attachment_Text, :DropShipAddress_Attachment_File, :Disclaimers, :estimated_total],
      customer: [:id, :email]
    )
  end
end
