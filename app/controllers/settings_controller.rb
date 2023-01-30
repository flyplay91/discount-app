class SettingsController < AuthenticatedController
  before_action :set_nav
  before_action :set_shop

  def show
    if @shop.staff_accounts.length.zero?
      @shop.staff_accounts = [
        {
          email: '', name: ''
        }
      ]
    end
    if @shop.categories.length.zero?
      @shop.categories = ['']
    end
  end

  def update
    if @shop.update setting_params
      redirect_to settings_path
    end
  end

  private

  def set_nav
    @nav_str = 'Settings'
  end

  def set_shop
    @shop = Shop.first
  end

  def setting_params
    params.require(:shop).permit(
      :processing_fee, :from_email, :from_name, :customer_info_description,
      :shipping_details_description, :single_address_description,
      :dropship_address_description, :dropship_noaddress_description,
      :address_attachment_type_description, :delivery_needed_by_date_description, :disclaimers, :filter_collections,
      :dropship_fee_charge, :terms_and_conditions, :tax_rate, :bcc_email, :bcc_name,
      draft_order_statuses: [], purchase_order_statuses: [], categories: [],
      purchase_order_stages: [], purchase_order_next_actions: [],
      staff_accounts: [:name, :email],
      default_agents: [:name, :email]
    ).tap do |sp|
      if sp[:staff_accounts].present?
        sp[:staff_accounts].delete_if {|x| x[:email].blank? || x[:name].blank?}
      end
      if sp[:default_agents].present?
        sp[:default_agents].delete_if {|x| x[:email].blank? || x[:name].blank?}
      end
      if sp[:purchase_order_statuses].present?
        sp[:purchase_order_statuses].delete_if {|x| x.blank?}
      end
      if sp[:purchase_order_stages].present?
        sp[:purchase_order_stages].delete_if {|x| x.blank?}
      end
      if sp[:purchase_order_next_actions].present?
        sp[:purchase_order_next_actions].delete_if {|x| x.blank?}
      end
      if sp[:categories].present?
        sp[:categories].delete_if {|x| x.blank?}
      end
    end
  end
end
