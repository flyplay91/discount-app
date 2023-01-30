class InstallationController < AuthenticatedController
	def index
		@themes = ShopifyAPI::Theme.all
		@themes = @themes.sort_by {|theme| [theme.role, theme.created_at]}&.reverse
	end
end
