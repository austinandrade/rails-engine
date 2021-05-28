require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
		it { should have_many(:invoices).dependent(:destroy) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:invoice_items).through(:items) }
  end

  describe 'validations' do
	  it { should validate_presence_of(:name) }
  end

  describe 'class methods' do
    describe '#top_merchants_by_revenue' do
      it 'returns top n merchants by their revenue generated' do
        top_5 = 5

        merchant_2 = create :merchant
        merchant_3 = create :merchant
        merchant_4 = create :merchant
        merchant_5 = create :merchant
        merchant_6 = create :merchant
        merchant_7 = create :merchant

        customer = create :customer

        item_2a = create :item, merchant: merchant_2
        item_2b = create :item, merchant: merchant_2

        item_3a = create :item, merchant: merchant_3
        item_3b = create :item, merchant: merchant_3

        item_4a = create :item, merchant: merchant_4
        item_4b = create :item, merchant: merchant_4

        item_5a = create :item, merchant: merchant_5
        item_5b = create :item, merchant: merchant_5

        item_6a = create :item, merchant: merchant_6
        item_6b = create :item, merchant: merchant_6

        item_7 = create :item, merchant: merchant_7

        # 20 dollars in revenue for merchant 2
        invoice_2 = customer.invoices.create!(status: 'shipped', merchant: merchant_2)
        invoice_2.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_2.invoice_items.create!(item: item_2a, quantity: 1, unit_price: 10)
        invoice_2.invoice_items.create!(item: item_2b, quantity: 10, unit_price: 1)


        # 110 dollars in revenue for merchant 3
        invoice_3a = customer.invoices.create!(status: 'shipped', merchant: merchant_3)
        invoice_3b = customer.invoices.create!(status: 'shipped', merchant: merchant_3)
        invoice_3a.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_3b.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_3a.invoice_items.create!(item: item_3a, quantity: 10, unit_price: 10)
        invoice_3b.invoice_items.create!(item: item_3b, quantity: 10, unit_price: 1)

        # 2 dollars in revenue for merchant 4
        invoice_4a = customer.invoices.create!(status: 'shipped', merchant: merchant_4)
        invoice_4b = customer.invoices.create!(status: 'shipped', merchant: merchant_4)
        invoice_4a.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_4b.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_4a.invoice_items.create!(item: item_4a, quantity: 1, unit_price: 1)
        invoice_4b.invoice_items.create!(item: item_4b, quantity: 1, unit_price: 1)

        # 10 dollars in revenue for merchant 5
        invoice_5a = customer.invoices.create!(status: 'shipped', merchant: merchant_5)
        invoice_5b = customer.invoices.create!(status: 'shipped', merchant: merchant_5)
        invoice_5a.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_5b.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_5a.invoice_items.create!(item: item_5a, quantity: 5, unit_price: 1)
        invoice_5b.invoice_items.create!(item: item_5b, quantity: 1, unit_price: 5)

        # 12 dollars in revenue for merchant 6
        invoice_6a = customer.invoices.create!(status: 'shipped', merchant: merchant_6)
        invoice_6b = customer.invoices.create!(status: 'shipped', merchant: merchant_6)
        invoice_6a.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_6b.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_6a.invoice_items.create!(item: item_6a, quantity: 6, unit_price: 1)
        invoice_6b.invoice_items.create!(item: item_6b, quantity: 2, unit_price: 3)

        # 60 dollars for merchant 7
        invoice_7a = customer.invoices.create!(status: 'shipped', merchant: merchant_7)
        invoice_7a.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
        invoice_7a.invoice_items.create!(item: item_7, quantity: 20, unit_price: 3)

        actual = Merchant.top_merchants_by_revenue(top_5).map do |merchant|
          merchant
        end

        expected = [merchant_3, merchant_7, merchant_2, merchant_6, merchant_5]
        expect(actual).to eq(expected)
        expect(actual.count).to eq(5)
      end

      describe '#best_item_selling_merchants' do
        it "returns the top n merchants with the most items sold" do
          top_3 = 3

          merchant_1 = create :merchant
          merchant_2 = create :merchant
          merchant_3 = create :merchant
          merchant_4 = create :merchant

          customer = create :customer

          item_2a = create :item, merchant: merchant_1
          item_2b = create :item, merchant: merchant_1

          item_3a = create :item, merchant: merchant_2
          item_3b = create :item, merchant: merchant_2

          item_4a = create :item, merchant: merchant_3
          item_4b = create :item, merchant: merchant_3

          item_5a = create :item, merchant: merchant_4
          item_5b = create :item, merchant: merchant_4

          # 11 items sold for merchant_1
          invoice_2 = customer.invoices.create!(status: 'shipped', merchant: merchant_1)
          invoice_2.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
          invoice_2.invoice_items.create!(item: item_2a, quantity: 1, unit_price: 10)
          invoice_2.invoice_items.create!(item: item_2b, quantity: 10, unit_price: 1)

          # 250 items sold for merchant_2
          invoice_3a = customer.invoices.create!(status: 'shipped', merchant: merchant_2)
          invoice_3b = customer.invoices.create!(status: 'shipped', merchant: merchant_2)
          invoice_3a.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
          invoice_3b.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
          invoice_3a.invoice_items.create!(item: item_3a, quantity: 125, unit_price: 10)
          invoice_3b.invoice_items.create!(item: item_3b, quantity: 125, unit_price: 1)

          # 650 items sold for merchant_3
          invoice_4a = customer.invoices.create!(status: 'shipped', merchant: merchant_3)
          invoice_4b = customer.invoices.create!(status: 'shipped', merchant: merchant_3)
          invoice_4a.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
          invoice_4b.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
          invoice_4a.invoice_items.create!(item: item_4a, quantity: 500, unit_price: 1)
          invoice_4b.invoice_items.create!(item: item_4b, quantity: 150, unit_price: 1)

          # 500 items sold for merchant_4
          invoice_5a = customer.invoices.create!(status: 'shipped', merchant: merchant_4)
          invoice_5b = customer.invoices.create!(status: 'shipped', merchant: merchant_4)
          invoice_5a.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
          invoice_5b.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
          invoice_5a.invoice_items.create!(item: item_5a, quantity: 300, unit_price: 1)
          invoice_5b.invoice_items.create!(item: item_5b, quantity: 200, unit_price: 5)

          actual = Merchant.best_item_selling_merchants(top_3).map do |merchant|
            merchant
          end

          expected = [merchant_3, merchant_4, merchant_2]
          expect(actual).to eq(expected)
          expect(actual.count).to eq(3)
        end
      end
    end

    describe "instance methods" do
      describe "#total_revenue" do
        it "grabs total revenue for a merchant" do
          merchant = create :merchant
          item = create :item, merchant: merchant
          customer = create :customer

          invoice = customer.invoices.create!(status: 'shipped', merchant: merchant)
          invoice.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
          invoice.invoice_items.create!(item: item, quantity: 20, unit_price: 3)

          expect(merchant.total_revenue).to eq(60)
        end
      end

      describe '#total_items_sold' do
        it "returns the total items sold by a merchant" do
          merchant = create :merchant
          item = create :item, merchant: merchant
          customer = create :customer

          invoice = customer.invoices.create!(status: 'shipped', merchant: merchant)
          invoice.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
          invoice.invoice_items.create!(item: item, quantity: 75, unit_price: 3)
          invoice.invoice_items.create!(item: item, quantity: 75, unit_price: 3)

          expect(merchant.total_items_sold).to eq(150)
        end
      end
    end
  end
end
