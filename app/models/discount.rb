class Discount < ApplicationRecord
  belongs_to :merchant

  enum status: [:active, :inactive]
end
