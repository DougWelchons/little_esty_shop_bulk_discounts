class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :complete]

  def total_revenue
    invoice_items.sum do |ii|
      ii.revenue
    end
  end

  def revenue_before_discounts
    invoice_items.sum('quantity * unit_price')
  end

  def savings_amount
    revenue_before_discounts - total_revenue
  end
end

# invoice_items.left_joins(:discounts).sum("invoice_items.unit_price * invoice_items.quantity * (1 - discounts.percent)")
#
# invoice_items.left_joins(:discounts).select('invoice_items.*, discounts.*').sum("invoice_items.unit_price * invoice_items.quantity * (1 - discounts.percent)")
# # invoice_items.left_joins(:discounts).sum("invoice_items.unit_price * invoice_items.quantity * (1 - discounts.percent)")
