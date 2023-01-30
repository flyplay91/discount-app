class Rule < ApplicationRecord
	belongs_to :shop, optional: true
	has_many :conditions, dependent: :destroy
  accepts_nested_attributes_for :conditions,
    reject_if: proc { |c| c[:condition_str].to_s.strip.blank? },
    allow_destroy: true
	has_many :price_levels, dependent: :destroy
  accepts_nested_attributes_for :price_levels,
    reject_if: proc { |c| c[:break_number].to_i < 1 || c[:discount_amount].to_i < 1 },
    allow_destroy: true
	serialize :shopify_ids, Array

  has_many :rule_items, dependent: :destroy
  accepts_nested_attributes_for :rule_items, allow_destroy: true

  validates :name, presence: true, uniqueness: true

	enum rule_type: { 
    product: 0,
    variant: 1,
    collection: 2,
    cart: 3
  }
  enum select_cat: { 
    select_all: 0,
    custom: 1
  }
  enum filter_cat: { 
    filter_custom: 0,
    filter_any: 1,
    filter_all: 2
  }

  def with_defaults
    conditions.build if conditions.blank?
    price_levels.build if price_levels.blank?
    self
  end

  def show_conditions?
    product? && custom? && !filter_custom?
  end

  def show_selected_objects?
    !cart? && custom?
  end
end
