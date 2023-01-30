# frozen_string_literal: true
module Shopify
  class AfterAuthenticateJob < ActiveJob::Base
    def perform(shop_domain:)
      shop = Shop.find_by(shopify_domain: shop_domain)

      shop.with_shopify_session do
      	# Save All Products
      	per_page = 250
        products = ShopifyAPI::Product.find(:all, params: { limit: per_page })
        while true do
          products.each do |product|
          	Product.save_shopify(product, 'api')
          end
          break unless products.next_page?
          sleep 1
          products = products.fetch_next_page
        end

        # Save All CustomCollections
			  sleep 1
			  collections = ShopifyAPI::CustomCollection.find(:all, params: { limit: per_page })
			  while true do
			    collections.each do |collection|
			      Collection.save_shopify(collection, 'api')
			    end
			    break unless collections.next_page?
			    sleep 1
			    collections = collections.fetch_next_page
			  end if collections.present?

			  # Save All SmartCollections
			  sleep 1
			  collections = ShopifyAPI::SmartCollection.find(:all, params: { limit: per_page })
			  while true do
			    collections.each do |collection|
			      Collection.save_shopify(collection, 'api')
			    end
			    break unless collections.next_page?
			    sleep 1
			    collections = collections.fetch_next_page
			  end if collections.present?
      end
    end
  end
end
