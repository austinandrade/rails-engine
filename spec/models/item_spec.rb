require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
		it { should belong_to(:merchant) }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
	  it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:merchant_id) }
    it { should validate_numericality_of(:unit_price) }
    it { should validate_numericality_of(:merchant_id) }
  end

  describe 'class methods' do
    describe '#top_items_by_revenue' do
      it "returns the top items by total revenue generated " do
        top_3 = 3

        merchant_1 = create :merchant
        merchant_2 = create :merchant
        merchant_3 = create :merchant
        merchant_4 = create :merchant

        customer = create :customer

        item_1 = create :item, merchant: merchant_1
        item_2 = create :item, merchant: merchant_2
        item_3 = create :item, merchant: merchant_3
        item_4 = create :item, merchant: merchant_4

        # 20 dollars in revenue generated for item_1
        invoice_2 = customer.invoices.create!(status: 'shipped', merchant: merchant_1)
        invoice_2.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_2.invoice_items.create!(item: item_1, quantity: 1, unit_price: 10)
        invoice_2.invoice_items.create!(item: item_1, quantity: 10, unit_price: 1)

        # 250 dollars generated for item_2
        invoice_3a = customer.invoices.create!(status: 'shipped', merchant: merchant_2)
        invoice_3b = customer.invoices.create!(status: 'shipped', merchant: merchant_2)
        invoice_3a.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_3b.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_3a.invoice_items.create!(item: item_2, quantity: 125, unit_price: 1)
        invoice_3b.invoice_items.create!(item: item_2, quantity: 125, unit_price: 1)

        # 650 dollars generated for item_3
        invoice_4a = customer.invoices.create!(status: 'shipped', merchant: merchant_3)
        invoice_4b = customer.invoices.create!(status: 'shipped', merchant: merchant_3)
        invoice_4a.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_4b.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_4a.invoice_items.create!(item: item_3, quantity: 500, unit_price: 1)
        invoice_4b.invoice_items.create!(item: item_3, quantity: 150, unit_price: 1)

        # 500 dollars generated for item_4
        invoice_5a = customer.invoices.create!(status: 'shipped', merchant: merchant_4)
        invoice_5b = customer.invoices.create!(status: 'shipped', merchant: merchant_4)
        invoice_5a.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_5b.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_5a.invoice_items.create!(item: item_4, quantity: 300, unit_price: 1)
        invoice_5b.invoice_items.create!(item: item_4, quantity: 200, unit_price: 1)

        actual = Item.top_items_by_revenue(top_3).map do |item|
          item
        end

        expected = [item_3, item_4, item_2]
        expect(actual).to eq(expected)
        expect(actual.count).to eq(3)
      end
    end
  end

  describe 'instance methods' do
    describe '#total_revenue' do
      it "returns the total revenue of a single item" do
        merchant = create :merchant
        item = create :item, merchant: merchant
        customer = create :customer

        invoice = customer.invoices.create!(status: 'shipped', merchant: merchant)
        invoice.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice.invoice_items.create!(item: item, quantity: 50, unit_price: 3)
        invoice.invoice_items.create!(item: item, quantity: 10, unit_price: 3)

        expect(item.total_revenue).to eq(180)
      end
    end
  end
end
