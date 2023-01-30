class LeadTime < ApplicationRecord
  belongs_to :vendor
  enum period_type: {
    days: 0,
    weeks: 1,
    business_days: 2
  }
end
