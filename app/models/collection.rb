class Collection < ApplicationRecord
	validates_uniqueness_of :shopify_id
  belongs_to :shop, optional: true
  has_many :collection_products, dependent: :destroy
  has_many :products, through: :collection_products

  def self.save_shopify(scollection, object_type='webhook')
  	collection_data = Collection.make_data(scollection, object_type)
    collection = Collection.find_or_create_by(shopify_id: collection_data[:shopify_id])
    if collection.present?
    	if collection_data[:title].present?
	    	collection.update collection_data
	    	collection.update_products
	    else
	    	collection.destroy
	    end
    end
	end

	def self.make_data(scollection, object_type='webhook')
		if object_type=='api'
  		collection_data = {
  			shopify_id: scollection.id,
    		handle: scollection.handle,
      	title: scollection.title,
      	published_scope: scollection.published_scope,
      	body_html: scollection.body_html,
      	published_at: scollection.published_at,
      	shop_id: Shop.first.id
  		}
  	else
  		collection_data = {
  			shopify_id: scollection['id'],
    		handle: scollection['handle'],
      	title: scollection['title'],
      	published_scope: scollection['published_scope'],
      	body_html: scollection['body_html'],
      	published_at: scollection['published_at'],
      	shop_id: Shop.first.id
  		}
  	end
  	collection_data
	end

	def update_products
		Shop.first.with_shopify_session do
			shopify_product_ids = []
			client = ShopifyAPI::GraphQL.client
			query = <<-'GRAPHQL'
      query ($id: ID!) {
        node(id: $id) {
          ... on Collection {
            products(first: 250) {
              pageInfo {
	              hasNextPage
	            }
	            edges {
	              cursor
	              node {
	                id
	              }
	            }
            }
          }
        }
      }
      GRAPHQL
      variables = { 
        id: "gid://shopify/Collection/#{self.shopify_id}",
      }
      Kernel.const_set(:ProductQuery, client.parse(query))
      result = client.query(ProductQuery, variables: variables)
      shopify_product_ids += result.data&.node&.products&.edges&.map {|edge| edge.node.id.split('/').last}
      edges = result.data&.node&.products&.edges

      while true
        cursor = edges.last.cursor
        query = <<-'GRAPHQL'
        query ($id: ID!, $numProducts: Int!, $cursor: String){
        	node(id: $id) {
	          ... on Collection {
	            products(first: $numProducts, after: $cursor) {
		            pageInfo {
		              hasNextPage
		            }
		            edges {
		              cursor
		              node {
		                id
		              }
		            }
		          }
	          }
	        }
        }
        GRAPHQL
        variables = {id: "gid://shopify/Collection/#{self.shopify_id}", numProducts: 250, cursor: cursor }
        Kernel.const_set(:ProductQuery, client.parse(query))
        result = client.query(ProductQuery, variables: variables)     
        shopify_product_ids += result.data&.node&.products&.edges&.map {|edge| edge.node.id.split('/').last}
        break if result.data.present? && result.data.node.present? && result.data.node.products.present? && !result.data.node.products.page_info.has_next_page
        edges = result.data&.node&.products&.edges
      end if edges&.last&.cursor.present?
      product_ids = Product.where(shopify_id: shopify_product_ids).pluck(:id)
      self.product_ids = product_ids
		end
	end

  def self.ethos_ids
    ["164118200378", "161312964666", "161313161274", "161313095738", "162683125818", "162475769914", "161312669754", "162683289658"]
  end
end