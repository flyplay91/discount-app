class OrdersController < AuthenticatedController
  def index
  	client = ShopifyAPI::GraphQL.client
  	query = <<-'GRAPHQL'
		  {
		  	draftOrders(first: 50, reverse: true, sortKey: UPDATED_AT) {
			    pageInfo {
	          hasPreviousPage
	          hasNextPage
	        }
			    edges {
			    	cursor
			      node {
			        id
			        name
			        createdAt
			        invoiceUrl
			        invoiceSentAt
			        status
			        totalPrice
			        customer {
			        	firstName
			        	lastName
			        }
			        customAttributes {
		        		key
		        		value
		        	}
			        order {
			        	id
			        	name
			        }
			      }
			    }
			  }
			}
		GRAPHQL
		Kernel.const_set(:OrderQuery, client.parse(query))
    result = client.query(OrderQuery)
		@draft_orders = result.data.draft_orders
  end
end
