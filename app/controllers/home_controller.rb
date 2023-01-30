# frozen_string_literal: true

class HomeController < AuthenticatedController
  before_action :set_products, only: %i(search_products search_variants)

  def index
    # @products = Product.order(title: :asc).paginate(page: (params[:page] || 1))
    @count = {
      product: Product.count,
      vendor: Vendor.count,
      po: PurchaseOrder.count,
      draft_order: ShopifyAPI::DraftOrder.count 
    }
  end

  def search_products
    page = params[:page]&.to_i || 1
    @products = @products&.order(title: :asc).paginate(page: page)
    if page * Product.per_page < @products.count
      @url = "#{search_products_path}?keyword=#{@keyword}&page=#{page + 1}"
    end
    
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def search_variants
    page = params[:page]&.to_i || 1
    @products = @products&.order(title: :asc).paginate(page: page)
      .includes(:variants)
    if page * Product.per_page < @products.count
      @url = "#{search_variants_path}?keyword=#{@keyword}&page=#{page + 1}"
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def search_collections
    @collections = Collection.all
    @keyword = params[:keyword]&.strip
    if params[:keyword].present?
      query = "title like ? OR shopify_id like ? OR handle like ? OR body_html like ?"
      @collections = @collections.where query, "%#{@keyword}%", "%#{@keyword}%",
        "%#{@keyword}%"
    end
    page = params[:page]&.to_i || 1
    @collections = @collections&.order(title: :asc).paginate(page: page)
    if page * Collection.per_page < @collections.count
      @url = "#{search_collections_path}?keyword=#{@keyword}&page=#{page + 1}"
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private

  def set_products
    @keyword = params[:keyword]&.strip
    @products = Product.all
    return if params[:keyword].blank?
    query = "title like ? OR shopify_id like ? OR handle like ? OR tags like ?"\
      " OR vendor like ? OR product_type like ?"
    key = "%#{@keyword}%"
    @products = @products.where query, key, key, key, key, key, key
  end
end
