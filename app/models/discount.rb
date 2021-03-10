class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items

  validates_presence_of :percent, :threshold

  enum status: [:active, :inactive]

  def pending_invoice_items?
    invoice_items
    .pending
    .where('quantity >= ?', threshold)
    .any?
  end
end
