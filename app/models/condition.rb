class Condition < ApplicationRecord
	belongs_to :rule, optional: true

	enum condition_type: { 
    vendor: 0,
    type: 1,
    tag: 2
  }
end
