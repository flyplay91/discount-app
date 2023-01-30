class PurchaseOrdersController < AuthenticatedController
  before_action :set_nav

  def index
  end

  def create
  	po = PurchaseOrder.find_or_initialize_by(draft_order_id: params[:draft_order_id])
  	if po.present?
  		if po.new_record?
	  		if po.save!
	  			flash[:notice] = 'A new purchase order is generated!'
		  		redirect_to action: 'show', id: po.id
		  	else
		  		flash[:error] = 'There is someting error.'
		  		redirect_to :back
	  		end
	  	else
	  		redirect_to action: 'show', id: po.id
	  	end
	  else
	  	flash[:error] = 'There is someting error.'
  		redirect_to :back
  	end
  end

  def create_po
  	po = PurchaseOrder.find_or_initialize_by(draft_order_id: params[:draft_order_id])
  	if po.present?
  		if po.new_record?
	  		if po.save!
	  			flash[:notice] = 'A new purchase order is generated!'
		  		redirect_to action: 'show', id: po.id
		  	else
		  		flash[:error] = 'There is someting error.'
		  		redirect_to :back
	  		end
	  	else
	  		redirect_to action: 'show', id: po.id
	  	end
	  else
	  	flash[:error] = 'There is someting error.'
  		redirect_to :back
  	end
  end

  def show
  	@po = PurchaseOrder.find(params[:id])
		@draft_order = @po.api_data
		@varinat_ids = @draft_order.line_items.edges.map {|line_item| PurchaseOrder.get_variant_id(line_item)} if @draft_order.line_items.present? && @draft_order.line_items.edges.present?
		@shop = Shop.first
		if @varinat_ids.present?
			@vendor_ids = []
			@varinat_ids.each {|variant_id| @vendor_ids += Variant.find_by(shopify_id: variant_id)&.real_vendor_ids }
			@vendor_ids.uniq!
		end
		if @po.purchase_order_items.blank? && @vendor_ids.present?
			@po.generate_po_items(@vendor_ids)
			@po.reload
		end
  end

  def update
		@po = PurchaseOrder.find(params[:id])
		@po.update(po_params)
		@draft_order = @po.api_data
		@varinat_ids = @draft_order.line_items.edges.map {|line_item| line_item.node.variant&.id&.split('/')&.last || line_item.node.custom_attributes.select{|c_attr| c_attr.key == 'variant_id' }&.first&.value } if @draft_order.line_items.present? && @draft_order.line_items.edges.present?
		@shop = Shop.first
		if @varinat_ids.present?
			@vendor_ids = []
			@varinat_ids.each {|variant_id| @vendor_ids += (Variant.find_by(shopify_id: variant_id)&.vendor_ids || []) }
			@vendor_ids.uniq!
			@vendor_ids.reject!(&:blank?)
		end
		
		redirect_to action: 'show', id: @po.id
  end

  def append_draft_order
  	@po = PurchaseOrder.find(params[:id])
  	@po.append_attributes custom_attributes
  	redirect_to :action => "show", :id => @po.id
  end

  def complete_draft_order
  	@po = PurchaseOrder.find(params[:id])
  	begin
  		@draft_order = @po.api_data
			Shop.first.with_shopify_session do
				draft_order = ShopifyAPI::DraftOrder.find(@draft_order.id.split('/').last)
				draft_order.complete(payment_pending: true)
			end
			render json: {}, status: :ok
  	rescue Exception => e
  		render json: {}, status: 400
  	end
  end

  private

  def set_nav
    @nav_str = 'PO\'s'
  end

  def custom_line_item_attributes
  	params.permit(:Additional_Packaging_Fees, :Additional_International_Fees, :Additional_DesignArtFee, :Additional_ThirdParty_ShippingFee, :Additional_ThirdParty_ShippingNumberFee, :Additional_SetupFee, :Additional_DigitizingFee, :Additional_AssemblyFee, :Additional_CardInsertFee, :Additional_BrokenBox_Fee)
  end

  def custom_attributes
  	params.permit(:Additional_Packaging_Fees, :Additional_International_Fees, :Additional_DesignArtFee, :Additional_ThirdParty_ShippingFee, :Additional_ThirdParty_ShippingNumberFee, :Additional_SetupFee, :Additional_DigitizingFee, :Additional_AssemblyFee, :Additional_CardInsertFee, :Additional_BrokenBox_Fee, :Tracking_Numbers, :Total_Taxes)
  end

  def po_params
  	params.require(:purchase_order).permit(:assigned_account, :draft_order_status)
  end
end
