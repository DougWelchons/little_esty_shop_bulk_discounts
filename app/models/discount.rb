class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items

  validates_presence_of :percent, :threshold
  validates_numericality_of :percent, greater_than: 0, less_than: 100
  validates_numericality_of :threshold, greater_than_or_equal_to: 1

  enum status: [:active, :inactive]

  def pending_invoice_items?
    invoice_items
    .pending
    .where('quantity >= ?', threshold)
    .any?
  end
end
