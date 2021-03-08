class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :discounts, through: :merchant

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def valid_discount
    discounts.order(percent: :desc).where('threshold <= ?', "#{self.quantity}").first
  end

  def revenue
    return unit_price * quantity if valid_discount.nil?
    unit_price * quantity * (1 - valid_discount.percent)
  end
end
