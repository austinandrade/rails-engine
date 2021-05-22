class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
end
