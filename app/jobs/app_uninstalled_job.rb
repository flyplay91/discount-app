class AppUninstalledJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    if shop.nil?
      logger.error("#{self.class} failed: cannot find shop with domain '#{shop_domain}'")
      return
    end

    shop.with_shopify_session do
    	shop.products.destroy_all
    	shop.collections.destroy_all
      shop.rules.destroy_all
    end
  end
end
