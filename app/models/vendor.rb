class Vendor < ApplicationRecord
  has_many :lead_times, dependent: :destroy
  accepts_nested_attributes_for :lead_times,
    allow_destroy: true

  serialize :po_emails, Array
  serialize :sub_brands, Array
  serialize :categories, Array

  validates :company_name, presence: true, uniqueness: true

  enum net_payment_terms: {
    net_terms_net20: 0,
    net_terms_net30: 1,
    net_terms_net45: 7,
    net_terms_net60: 3,
    net_terms_net90: 4,
    net_terms_net120: 5,
    net_terms_custom: 6
  }

  enum order_submission_type: {
    order_submission_portal: 0,
    order_submission_email: 1,
    order_submission_other: 2
  }

  enum payment_methods_cc_type: {
    fee: 0,
    percentage: 1
  }

  enum third_party_shipping_fee_type: {
    per_item: 0,
    per_order: 1,
    per_box: 2
  }

  def cc_fee_label
    return if payment_methods_cc_fees.blank?
    fee? ? "($#{payment_methods_cc_fees})" : "(#{payment_methods_cc_fees}%)"
  end

  def third_shipping_fee_label
    return (third_shipping.present? ? "($#{third_shipping_fee || 0})" : "")
  end

  def dropship_fee_per_item_per_location_label
    "($#{dropship_fee_per_item_per_location || 0})"
  end

  def assigned_agent
    "#{assigned_agent_name}(#{assigned_agent_email})"
  end

  def payment_primary_string
    case payment_primary
    when 'payment_methods_check' then 'Check'
    when 'payment_methods_cc' then 'Credit Card'
    when 'payment_methods_ach' then 'ACH'
    when 'payment_methods_custom' then 'Custom'
    else ''
    end
  end
end
