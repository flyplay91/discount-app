class VariantsController < AuthenticatedController
  before_action :set_nav
  before_action :set_variant, except: :index
  before_action :set_variant_type, only: %i(edit)

  EDIT_VARIANTS = %i(pricing)

  def edit
  end

  def update
    if @variant.update variant_params
      redirect_to edit_variant_path @variant
    end
  end

  private

  def set_nav
    @nav_str = 'Variants'
  end

  def set_variant
    @variant = Variant.find params[:id]
    @product = @variant.product
    @shopify_product = ShopifyAPI::Product.find(@variant.product.shopify_id)
    @vendors = Vendor.where id: @variant.vendor_ids
    # if @vendors.blank?
    #   @variant.vendor_ids = ['']
    #   @variant.vender_sub_brands = ['']
    #   @variant.vendor_types = ['']
    # end
    @variant.adjust_vendors

    if @variant.price_levels.blank?
      @variant.price_levels.build
    end
  end

  def set_variant_type
    request.variant = EDIT_VARIANTS & [params[:data]&.to_sym].compact
  end

  def variant_params
    params.require(:variant).permit(
      :supplier_sku, :artwork_url, :inventory_available, :standard_lead_in_days,
      :min_item_order_qty, :max_item_order_qty, :item_qty_per_case,
      :supplier_type, :size, :color, :supplier_product_name,
      :one_time_setup_fee, :recurring_reorder_fee, :quote_number,
      :supplier_proof_link, :proof_photo_link, :su_proof_link, :decoration_location,
      :decoration_type, :logo_name, :logo_color, :logo_size,
      :inventory_on_hand, :enforced_multiple_quantity, :base_lead_time,
      :start_production, :lead_time_in_days, :additional_lead_time,
      :ship_to, :supplier_decoration, :blank_docorator, :dst_file,
      :su_comp, :different_cost_based_on_quantity, :proof_required,
      :end_production, :proof_number, :supplier_decorated,
      vendor_ids: [], vender_sub_brands: [], vendor_types: [],
      price_levels_attributes: [
        :id, :_destroy, :item_qty, :item_wholesale_cost, :vendor_cost_type,
        :item_markup_type, :item_markup_cost,
        :sale_price_quantity, :item_sale_price, :supplier_cost, :decorator_cost, :product_id,
        vendor_costs: []
      ]
    ).tap do |vp|
      # if vp[:vendor_ids].present?
      #   vp[:vendor_ids].delete_if {|x| x.blank?}
      #   vp[:vender_sub_brands] =
      #     vp[:vender_sub_brands][0..vp[:vendor_ids].length - 1]
      # end
    end
  end
end
