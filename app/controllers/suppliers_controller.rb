class SuppliersController < AuthenticatedController
  before_action :set_nav
  before_action :set_vendor, except: %i(index create new)
  before_action :set_vendors, only: :index

  def index
    @vendors = @vendors.order(:company_name).paginate(page: (params[:page] || 1))
  end

  def new
    @vendor = Vendor.new payment_methods_cc_type: 'percentage',
      company_type: 'Retail', order_submission_type: 'order_submission_email'
    @vendor.lead_times.build if @vendor.lead_times.blank?
    @vendor.po_emails = ['', '', '']
    @vendor.sub_brands = ['']
    @vendor.categories = ['']
  end

  def create
    @vendor = Vendor.new vendor_params
    if @vendor.save
      redirect_to suppliers_path
    end
  end

  def edit
    @vendor.lead_times.build if @vendor.lead_times.blank?
    @vendor.sub_brands = [''] if @vendor.sub_brands.length.zero?
    @vendor.categories = [''] if @vendor.categories.length.zero?
    (3 - @vendor.po_emails.length).times do |_|
      @vendor.po_emails << ''
    end
  end

  def update
    if @vendor.update vendor_params
      redirect_to suppliers_path
    end
  end

  def destroy
    @vendor.destroy
    redirect_to suppliers_path
  end

  def status
    @vendor.update enabled: params[:status]
    head :ok
  end

  def get_sub_brands
    # respond_to do |format|
    #   format.js { render :layout => false }
    # end
    # render :layout => false

    options_html = ''
    @vendor.sub_brands.each do |sb|
      options_html += "<option value='#{sb}'>#{sb}</option>"
    end
    render json: { response: options_html }
  end

  private

  def set_vendors
    @keyword = params[:keyword]&.strip
    @vendors = Vendor.all
    return if params[:keyword].blank?

    query = "company_name like :q or product_contact_name like :q or "\
      "sub_brands like :q or categories like :q"
    @vendors = @vendors.where query, q: "%#{@keyword}%"
  end

  def vendor_params
    params.require(:vendor).permit(
      :company_name, :product_contact_name, :website,
      :product_phone_number, :product_contact_email,
      :billing_contact_name, :company_address_line_1, :company_address_line_2,
      :billing_contact_phone_number, :billing_contact_email, :payment_methods_cc_type,
      :company_address_city, :company_address_state,
      :company_address_zipcode, :net_payment_terms, :net_terms_custom,
      :payment_methods_check, :payment_methods_cc, :payment_methods_cc_fees,
      :payment_methods_ach, :payment_methods_custom, :payment_methods_custom_field,
      :order_submission_type, :order_submission_portal_link,
      :order_submission_portal_login, :order_submission_portal_password,
      :order_submission_comment, :shipping_notes, :enabled, :private_notes,
      :category, :payment_notes, :third_shipping, :payment_primary, :dropship_unit_type,
      :custom_net_term_description, :standard_production_lead_time_range, :international_supplier,
      :third_shipping_fee, :company_type, :vendor_type, :assigned_agent_name, :assigned_agent_email,
      :company_type_custom, :pricing_status, :pricing_status_other,
      :dropship_fee_per_item_per_location,
      :company_contact_email, :custom_service_phone_number, :third_party_shipping_fee_type,
      po_emails: [], sub_brands: [], categories: [],
      lead_times_attributes: [
        :id, :_destroy, :min_qty, :max_qty, :min_days, :max_days, :period_type
      ]
    ).tap do |vp|
      if vp[:po_emails].present?
        vp[:po_emails].delete_if {|x| x.blank?}
      end
      if vp[:sub_brands].present?
        vp[:sub_brands].delete_if {|x| x.blank?}
      end
      if vp[:categories].present?
        vp[:categories].delete_if {|x| x.blank?}
      end
    end
  end

  def set_vendor
    @vendor = Vendor.find params[:id]
  end

  def set_nav
    @nav_str = 'Vendors'
  end
end
