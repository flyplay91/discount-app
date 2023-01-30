# frozen_string_literal: true
class AppProxyController < ApplicationController
  include ShopifyApp::AppProxyVerification

  def index
  	@collection = Collection.find_by(shopify_id: params[:collection_id])
		@limit = (params[:limit] || 20).to_i
		@order = 'title ASC'
		@page = (params[:page] || 1).to_i
		offset = (@page - 1) * @limit
		case params[:sort_by]
		when 'title-ascending'
			@order = 'products.title ASC'
		when 'title-descending'
			@order = 'products.title DESC'
		when 'created-ascending'
			@order = 'products.p_created_at ASC'
		when 'created-descending'
			@order = 'products.p_created_at DESC'
		end if params[:sort_by].present?
		@products = @collection&.products.where.not(published_at: nil)
		if params[:tags].present?
			tags = params[:tags].strip&.split(',')
			query = tags.map {|tag| "tags LIKE '%#{tag}%'" }.join(' OR ')
			@products = @products.where(query)
		end
		if params[:size].present?
			product_ids = ProductOption.where(product_id: @products.pluck(:id), option_name: "Size").where("option_values like '%#{params[:size]}\\n%'").pluck(:product_id)
			@products = Product.where(id: product_ids)
		end
		if params[:color].present?
			product_ids = ProductOption.where(product_id: @products.pluck(:id), option_name: "Color").where("option_values like '%#{params[:color]}\\n%'").pluck(:product_id)
			@products = Product.where(id: product_ids)
		end
		if params[:style].present?
			product_ids = ProductOption.where(product_id: @products.pluck(:id), option_name: "Style").where("option_values like '%#{params[:style]}\\n%'").pluck(:product_id)
			@products = Product.where(id: product_ids)
		end
		if params[:min_qty_from].present? && params[:min_qty_to].present? && params[:price_from].present? && params[:price_to].present?
			variant_ids = PriceLevel.where(
				variant_id: Variant.where(product_id: @products.pluck(:id)).where('min_item_order_qty BETWEEN ? AND ?', params[:min_qty_from].to_i, params[:min_qty_to].to_i).pluck(:id)
			).where('item_sale_price BETWEEN ? AND ?', params[:price_from], params[:price_to]).pluck(:variant_id)
			product_ids = Variant.where(id: variant_ids).pluck(:product_id)
			@products = Product.where(id: product_ids)
		end
		@total_count = @products.count
		@total_pages = (@total_count / @limit.to_f).ceil
		if params[:sort_by] == 'price-ascending'
			pls = PriceLevel.where(product_id: @products.pluck(:id)).select(:product_id, :item_sale_price).group(:product_id, :item_sale_price).order(:item_sale_price => :asc).pluck(:product_id, :item_sale_price)
			product_ids = []
			pls.each do |pl|
				product_ids << pl[0] unless product_ids.include? pl[0]
			end
			@products = Product.where(id: product_ids).sort_by do |product|
			  product_ids.index(product.id)
			end
			@products = @products[offset..(offset+@limit-1)]
		elsif params[:sort_by] == 'price-descending'
			pls = PriceLevel.where(product_id: @products.pluck(:id)).select(:product_id, :item_sale_price).group(:product_id, :item_sale_price).order(:item_sale_price => :desc).pluck(:product_id, :item_sale_price)
			product_ids = []
			pls.each do |pl|
				product_ids << pl[0] unless product_ids.include? pl[0]
			end
			@products = Product.where(id: product_ids).sort_by do |product|
			  product_ids.index(product.id)
			end
			@products = @products[offset..(offset+@limit-1)]
		else
			@products = @products.order(@order).limit(@limit).offset(offset)
		end
  	
		@next_url = "https://jpmc.keeperscollective.com/apps/keepers?collection_id=#{params[:collection_id]}&grid=#{params[:grid]}&max_height=#{params[:max_height]}&show_vendor=#{params[:show_vendor]}&section_id=#{params[:section_id]}&limit=20&tags=#{params[:tags]}&sort_by=#{params[:sort_by]}&page=#{@page+1}&min_qty_from=#{params[:min_qty_from]}&min_qty_to=#{params[:min_qty_to]}&price_from=#{params[:price_from]}&price_to=#{params[:price_to]}&size=#{params[:size]}&color=#{params[:color]}&style=#{params[:style]}" if @page+1 <= @total_pages

  	# @next_url = "https://jpmc.keeperscollective.com/collections/#{@collection.handle}#{params[:tags].present? ? '/' + params[:tags] : ''}?sort_by=#{params[:sort_by]}&page=#{@page+1}&min_qty_from=#{params[:min_qty_from]}&min_qty_to=#{params[:min_qty_to]}&price_from=#{params[:price_from]}&price_to=#{params[:price_to]}" if @page+1 <= @total_pages
  	@grid = params[:grid]
  	@max_height = params[:max_height]
  	@show_vendor = params[:show_vendor]
  	@section_id = params[:section_id]
  	
    render(layout: false, content_type: 'application/liquid')
  end
end
