class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percent, :threshold

  enum status: [:active, :inactive]
end
