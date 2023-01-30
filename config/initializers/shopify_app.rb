ShopifyApp.configure do |config|
  config.application_name = "Volume & Tiered Discounts"
  config.api_key = ENV['SHOPIFY_API_KEY']
  config.secret = ENV['SHOPIFY_API_SECRET']
  config.old_secret = ""
  config.scope = "read_products,read_content,write_products,write_content,read_inventory,write_inventory,read_locations,read_orders,write_orders,write_draft_orders,write_script_tags,write_fulfillments,read_product_listings,write_customers,write_themes,write_order_edits,read_merchant_managed_fulfillment_orders,write_third_party_fulfillment_orders,write_checkouts,write_reports,write_price_rules,write_discounts,write_shipping,write_merchant_managed_fulfillment_orders" # Consult this page for more scope options:
                                 # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
  config.embedded_app = false
  config.api_version = "2020-10"
  config.shop_session_repository = 'Shop'
  # config.allow_jwt_authentication = true
  config.after_authenticate_job = { job: "Shopify::AfterAuthenticateJob", inline: false }
  config.webhooks = [
    {topic: 'app/uninstalled', address: "https://#{ENV['APP_DOMAIN']}/webhooks/app_uninstalled", format: 'json'},
    {topic: 'collections/delete', address: "https://#{ENV['APP_DOMAIN']}/webhooks/collections_delete", format: 'json'},
    {topic: 'collections/update', address: "https://#{ENV['APP_DOMAIN']}/webhooks/collections_update", format: 'json'},
    {topic: 'collections/create', address: "https://#{ENV['APP_DOMAIN']}/webhooks/collections_create", format: 'json'},
    {topic: 'products/delete', address: "https://#{ENV['APP_DOMAIN']}/webhooks/products_delete", format: 'json'},
    {topic: 'products/update', address: "https://#{ENV['APP_DOMAIN']}/webhooks/products_update", format: 'json'},
    {topic: 'products/create', address: "https://#{ENV['APP_DOMAIN']}/webhooks/products_create", format: 'json'},
    {topic: 'orders/delete', address: "https://#{ENV['APP_DOMAIN']}/webhooks/orders_delete", format: 'json'},
    {topic: 'orders/update', address: "https://#{ENV['APP_DOMAIN']}/webhooks/orders_update", format: 'json'},
    {topic: 'orders/create', address: "https://#{ENV['APP_DOMAIN']}/webhooks/orders_create", format: 'json'},
    {topic: 'carts/update', address: "https://#{ENV['APP_DOMAIN']}/webhooks/carts_update", format: 'json'},
    {topic: 'carts/create', address: "https://#{ENV['APP_DOMAIN']}/webhooks/carts_create", format: 'json'},
  ]
end

# ShopifyApp::Utils.fetch_known_api_versions                        # Uncomment to fetch known api versions from shopify servers on boot
# ShopifyAPI::ApiVersion.version_lookup_mode = :raise_on_unknown    # Uncomment to raise an error if attempting to use an api version that was not previously known
