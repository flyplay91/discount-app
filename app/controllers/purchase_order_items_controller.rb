class PurchaseOrderItemsController < ApplicationController
	protect_from_forgery with: :null_session, only: [:download_pdf]
  skip_before_action :verify_authenticity_token, only: [:download_pdf]

	def new
		@po = PurchaseOrder.find(params[:po_id])
		@draft_order = @po.api_data
		@vendor = Vendor.find(params[:vendor_id])
		@po_item = PurchaseOrderItem.new(shop: Shop.first, purchase_order: @po, vendor: @vendor)
		respond_to do |format|
      format.js { render :layout => false }
    end
	end

	def edit
		@po_item = PurchaseOrderItem.find(params[:id])
		@po = @po_item.purchase_order
		@draft_order = @po.api_data
		@vendor = @po_item.vendor
		@cart = Cart.find_by(token: @draft_order.custom_attributes.select{|c_attr| c_attr.key == 'token' }&.first&.value)
		@cart_json = JSON.parse(@cart.full_json) if @cart.present? && @cart.full_json.present?
		respond_to do |format|
      format.js { render :layout => false }
    end
	end

	def create
		@po_item = PurchaseOrderItem.create(po_item_params)
		params[:purchase_order_line_item].each do |po_l_item|
			po_line_item = PurchaseOrderLineItem.new(po_line_item_params(po_l_item))
			po_line_item.purchase_order_item = @po_item
			po_line_item.save!
		end
		flash[:notice] = 'Invoice Preview is created!'
		redirect_to purchase_order_path(id: po_item_params[:purchase_order_id])
	end

	def update
		@po_item = PurchaseOrderItem.find(params[:id])
		@po_item.update po_item_params
		params[:purchase_order_line_item].each do |po_l_item|
			po_line_item = PurchaseOrderLineItem.find_or_create_by(purchase_order_item: @po_item, variant_id: po_line_item_params(po_l_item)[:variant_id])
			# po_line_item = PurchaseOrderLineItem.find(po_line_item_params(po_l_item)[:id])
			po_line_item.update po_line_item_params(po_l_item)
		end
		if ActiveModel::Type::Boolean.new.cast(params[:send_invoice]) || ActiveModel::Type::Boolean.new.cast(params[:preview_invoice])
			if @po_item.purchase_order_line_items.present?
				MessageMailer.with(purchase_order_item_id: params[:id], preview: ActiveModel::Type::Boolean.new.cast(params[:preview_invoice])).send_invoice.deliver_later
				flash[:notice] = 'Purchase Order is approved and invoice is sent!'
			end
		else
			flash[:notice] = 'Invoice Preview is updated!'	
		end
		redirect_to purchase_order_path(id: po_item_params[:purchase_order_id])
	end

	def send_invoice
		@po_item = PurchaseOrderItem.find(params[:id])
		MessageMailer.with(purchase_order_item_id: params[:id]).send_invoice.deliver_later if @po_item.purchase_order_line_items.present?
		respond_to do |format|
      format.js { render :layout => false }
    end
	end

	def download_pdf
		@po_item = PurchaseOrderItem.find(params[:id])
		@po = @po_item.purchase_order
		@draft_order = @po.api_data
		@vendor = @po_item.vendor
		@cart = Cart.find_by(token: @draft_order.custom_attributes.select{|c_attr| c_attr.key == 'token' }&.first&.value)
		@cart_json = JSON.parse(@cart.full_json) if @cart.present? && @cart.full_json.present?
		respond_to do |format|
      format.pdf do
      	send_data @po_item.to_pdf(@po, @draft_order, @vendor, @cart_json)
      end
    end
	end

	def render_pdf
		@po_item = PurchaseOrderItem.find(params[:id])
		@po = @po_item.purchase_order
		@draft_order = @po.api_data
		@vendor = @po_item.vendor
		@cart = Cart.find_by(token: @draft_order.custom_attributes.select{|c_attr| c_attr.key == 'token' }&.first&.value)
		@cart_json = JSON.parse(@cart.full_json) if @cart.present? && @cart.full_json.present?
		render layout: "download"
	end

	private
	def po_item_params
		params.require(:purchase_order_item).permit(:shop_id, :purchase_order_id, :vendor_id, :status, :required_ship_date, :shipping_method, :shipping_address, :notes)
	end

	def po_line_item_params(raw_po_l_item)
		raw_po_l_item.permit(:id, :variant_id, :qty, :unit_cost, :setup_qty, :setup_unit_price, :run_qty, :run_unit_price, :purchase_order_item_id, :freight_cost)
	end

	def send_pdf
    send_file @po_item.to_pdf(@po, @draft_order, @vendor, @cart_json), download_attributes
  end

  def download_attributes
    {
      filename: @po_item.po_number(@draft_order.name) + '.pdf',
      type: "application/pdf",
      disposition: "inline"
    }
  end
end
