class MessageMailer < ApplicationMailer
	default from: 'tera.roeker@straightupinc.com'

	def send_invoice
		@po_item = PurchaseOrderItem.find(params[:purchase_order_item_id])
		@po = @po_item.purchase_order
		@vendor = @po_item.vendor
		shop = Shop.first
		assigned_email = @po.assigned_account.presence || @vendor&.assigned_agent_email.presence || shop.from_email
		assigned_account = shop.staff_accounts.select {|account| account["email"] == assigned_email}&.first
		assigned_name = (assigned_account.present? ? assigned_account["name"] : '').presence || shop.from_name
		mail(
			from: "#{assigned_name} <#{shop.from_email}>",
		  to: "#{@vendor&.product_contact_name} <#{params[:preview].present? ? assigned_email : @vendor&.product_contact_email}>",
		  reply_to: "#{assigned_name} <#{assigned_email}>",
		  bcc: "#{shop.bcc_name} <#{shop.bcc_email}>",
			subject: "Purchase Order Invoice"
		)
	end
end