require 'csv'

class ProductsController < AuthenticatedController
  before_action :set_nav
  before_action :set_products, only: [:index, :missing]
  skip_before_action :verify_authenticity_token, only: :create

  def index
    @products = @products.where.not(published_at: nil).order('products.title' => 'asc')
      .paginate(page: (params[:page] || 1))
    file = File.read 'upload.json'
    @json_variants = JSON.parse(file)
  end

  def edit
  end

  def update
  end

  def create
    # file = params[:attachment].read
    # @json_variants = JSON.parse(file)
    # puts @json_variants
    # respond_to do |format|
    #   format.js { render layout: false}
    # end
    
    csv_variants = CSV.parse(params[:file].read, headers: true)
    csv_variants.each do |csv_variant|
      product = Product.find_by_shopify_id csv_variant['Shopify Product ID']
      sku = csv_variant['Shopify SKU/Variant SKU'].presence || csv_variant['Shopify SKU']
      if product.present?
        variant = product.variants.find_by_sku sku
      else
        variant = Variant.find_by_sku sku
      end
      variant.update_from_csv csv_variant if variant.present?
    end

    redirect_to products_path
  end

  def missing
    missing_vendor_variant_ids = Variant.all.pluck(:vendor_ids, :id)&.select {|variant| variant[0].reject(&:blank?).blank?}&.map {|variant| variant[1]}
    price_error_variant_ids = PriceLevel.all.pluck(:id, :item_qty, :item_wholesale_cost, :item_sale_price, :variant_id)&.select {|pl| pl[1].blank? || pl[2].blank? || pl[3].blank?}&.map {|pl| pl[4]}
    price_missing_variant_ids = Variant.all.pluck(:id) - PriceLevel.all.pluck(:variant_id)&.uniq
    variant_ids = (missing_vendor_variant_ids + price_error_variant_ids + price_missing_variant_ids).uniq
    product_ids = Variant.where(id: variant_ids).pluck(:product_id)&.uniq

    @products = @products.where(id: product_ids).where.not(published_at: nil).order('products.title' => 'asc')
      .paginate(page: (params[:page] || 1))
    file = File.read 'upload.json'
    @json_variants = JSON.parse(file)
  end

  private

  def set_nav
    @nav_str = 'Products'
  end

  def set_product
    # @product = Product.find params[:id]
  end

  def set_products
    @keyword = params[:keyword]&.strip
    @products = Product.all
    return if params[:keyword].blank?
    query = "products.title like ? OR products.shopify_id like ? OR"\
      " products.vendor like ? OR products.product_type like ?"
    query += "OR variants.sku like ? OR variants.shopify_id like ?"
    key = "%#{@keyword}%"
    # @products = @products.joins(:variants).where query, key, key, key, key, key, key
    product_ids = @products.joins(:variants)
      .where(query, key, key, key, key, key, key)
      .pluck(:id)
    @products = @products.where id: product_ids
  end
end
