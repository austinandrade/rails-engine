class InvoiceItem < ApplicationRecord
  validates :item_id, presence: true, numericality: true
  validates :invoice_id, presence: true, numericality: true
  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true

  belongs_to :invoice
  belongs_to :item
end
