class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items

  scope :find_match_by_name, ->(name) do
    where('name Ilike ?', "%#{name}%")
      .order('LOWER(name)')
    # Order should either be ascending or descending
    # eg.order(:asc) or .order(:desc)
  end

  class << self
    def top_merchants_by_revenue(quantity)
      joins(invoices: [:invoice_items, :transactions])
        .where('transactions.result = ?', 'success')
        .where('invoices.status = ?', 'shipped')
        .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
        .group(:id)
        .order('total_revenue desc')
        .limit(quantity)
    end

    def best_item_selling_merchants(quantity)
      joins(invoices: [:invoice_items, :transactions])
        .where('transactions.result = ?', 'success')
        .where('invoices.status = ?', 'shipped')
        .select('merchants.*, sum(invoice_items.quantity) as total_sold')
        .group(:id)
        .order('total_sold desc')
        .limit(quantity)
    end
  end

  def total_items_sold
    invoices.where('invoices.status = ?', 'shipped')
    .joins(:transactions)
    .where('transactions.result = ?', 'success')
    .joins(:invoice_items)
    .sum('invoice_items.quantity')
  end

  def total_revenue
    invoices.where('invoices.status = ?', 'shipped')
    .joins(:transactions)
    .where('transactions.result = ?', 'success')
    .joins(:invoice_items)
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
