class CartsCreateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    if shop.nil?
      logger.error("#{self.class} failed: cannot find shop with domain '#{shop_domain}'")
      return
    end

    shop.with_shopify_session do
      cart = Cart.find_or_create_by(token: webhook[:token])
      cart.update(json_data: webhook.to_json) if cart.present?
    end
  end
end