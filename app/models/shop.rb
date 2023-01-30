# frozen_string_literal: true
class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorage

  has_many :products, dependent: :destroy
  has_many :variants, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :rules, dependent: :destroy
  has_many :purchase_orders, dependent: :destroy
  serialize :staff_accounts, Array
  serialize :default_agents, Array
  serialize :purchase_order_statuses, Array
  serialize :draft_order_statuses, Array
  serialize :purchase_order_stages, Array
  serialize :purchase_order_next_actions, Array
  serialize :categories, Array
  has_many :carts, dependent: :destroy

  def api_version
    ShopifyApp.configuration.api_version
  end

  def self.init_settings
    Shop.update_all purchase_order_statuses: ['OK', 'Follow Up'],
      purchase_order_stages: ['Submitted', 'Created'],
      purchase_order_next_actions: ['Awaiting Supplier Shipping Info', 'None Set']
  end

  def formatted_staff_accounts
    staff_accounts.map do |staff_account|
      label = "#{staff_account[:name]}(#{staff_account[:email]})"
      [label, label, {data: {name: staff_account[:name], email: staff_account[:email]}}]
    end
  end
end
