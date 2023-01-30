require "render_anywhere"

class PurchaseOrderItem < ApplicationRecord
	belongs_to :shop, optional: true
	belongs_to :purchase_order
	belongs_to :vendor, optional: true
	has_many :purchase_order_line_items, dependent: :destroy

  validates :vendor_id, uniqueness: { scope: :purchase_order_id }
    
	enum status: { 
    opened: 0,
    invoice_sent: 1,
    completed: 2,
    declined: 3,
    paused: 4,
    stopped: 5
  }

  include RenderAnywhere

  def po_number(draft_order_name)
    formatted_po = "0000" + self.id.to_s
    formatted_po = formatted_po[(formatted_po.length-4)..(formatted_po.length-1)]
    "#{draft_order_name.gsub('#', '')}-#{formatted_po}"
  end

  def to_pdf(po, draft_order, vendor, cart_json)
    # kit = PDFKit.new( as_html(po, draft_order, vendor, cart_json) )
    kit = PDFKit.new( "https://#{ENV['APP_DOMAIN']}/purchase_order_items/#{self.id}/render_pdf" )
    # kit.to_file("tmp/#{self.po_number(draft_order.name)}.pdf")
    kit.to_pdf
  end

  private

  def as_html(po, draft_order, vendor, cart_json)
    render template: "purchase_order_items/contents",
      layout: "application",
      locals: { po: po, vendor: vendor, po_item: self, draft_order: draft_order, cart_json: cart_json }
  end
end
