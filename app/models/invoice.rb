class Invoice < ApplicationRecord
  validates :customer_id, presence: true, numericality: true
  validates :merchant_id, presence: true, numericality: true
  validates :status, presence: true

  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
end
