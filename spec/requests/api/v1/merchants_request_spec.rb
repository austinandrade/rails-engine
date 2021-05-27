require 'rails_helper'

describe "merchants requests" do
  it "returns 3 merchant json objects" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.server_error?).to eq(false)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)
    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_an(Array)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_an(Object)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "returns one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.server_error?).to eq(false)

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to have_key(:data)
    expect(merchant[:data]).to be_a(Hash)
    expect(merchant[:data][:attributes]).to be_a(Hash)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data][:id].to_i).to eq(id)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_an(Object)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it "returns a subset of merchants based on per_page limitation" do
    create_list(:merchant, 3)

    get '/api/v1/merchants', params: {per_page: 1}

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.server_error?).to eq(false)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(1)
  end

  it "returns a subset of merchants based on desired page limitation" do
    merchant_collection = create_list(:merchant, 25)
    twenty_first_merchant_id = merchant_collection[20].id

    get '/api/v1/merchants', params: {page: 2}

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.server_error?).to eq(false)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data][0][:id].to_i).to eq(twenty_first_merchant_id)
  end

  it "returns one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.server_error?).to eq(false)

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to have_key(:data)
    expect(merchant[:data]).to be_a(Hash)
    expect(merchant[:data][:attributes]).to be_a(Hash)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data][:id].to_i).to eq(id)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_an(Object)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it "returns a single merchant's items by their id" do
    merchant = create(:merchant)
    items    = create_list(:item, 3, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.server_error?).to eq(false)

    merchant_response = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_response[:data][0]).to have_key(:id)
    expect(merchant_response[:data][0][:id]).to be_a(String)

    expect(merchant_response[:data][0]).to have_key(:type)
    expect(merchant_response[:data][0][:type]).to be_an(Object)

    expect(merchant_response[:data][0]).to have_key(:attributes)
    expect(merchant_response[:data][0][:attributes]).to be_an(Hash)

    expect(merchant_response[:data][0][:attributes]).to have_key(:name)
    expect(merchant_response[:data][0][:attributes][:name]).to be_a(String)

    expect(merchant_response[:data][0][:attributes]).to have_key(:description)
    expect(merchant_response[:data][0][:attributes][:description]).to be_a(String)

    expect(merchant_response[:data][0][:attributes]).to have_key(:unit_price)
    expect(merchant_response[:data][0][:attributes][:unit_price]).to be_a(Float)

    expect(merchant_response[:data][0][:attributes]).to have_key(:merchant_id)
    expect(merchant_response[:data][0][:attributes][:merchant_id]).to be_an(Integer)
  end

  describe 'top n merchants endpoint' do
    it "successfully returns top 5 merchants by total revenue generated" do
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

      quantity_params = ({
                      quantity: 5,
                    })
      headers = {"CONTENT_TYPE" => "application/json"}
      get "/api/v1/revenue/merchants", headers: headers, params: quantity_params

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.server_error?).to eq(false)

      top_5_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(top_5_merchants).to have_key(:data)
      expect(top_5_merchants[:data].count).to eq(5)
      expect(top_5_merchants[:data]).to be_an(Array)

      top_5_merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)
        expect(merchant[:attributes]).to be_a(Hash)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq("merchant_name_revenue")

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end

      # returns the top 5 merchants in order of their total revenue generated.
      # Doesn't include merchant_4 as they didn't make the top 5 cut.
      expect(top_5_merchants[:data].first[:attributes][:name]).to eq(merchant_3.name)
      expect(top_5_merchants[:data].second[:attributes][:name]).to eq(merchant_7.name)
      expect(top_5_merchants[:data].third[:attributes][:name]).to eq(merchant_2.name)
      expect(top_5_merchants[:data].fourth[:attributes][:name]).to eq(merchant_6.name)
      expect(top_5_merchants[:data].fifth[:attributes][:name]).to eq(merchant_5.name)
    end

    it "returns 400 error when no quantity param is passed" do
      get "/api/v1/revenue/merchants"
      expect(response.successful?).to eq(false)
      expect(response.status).to eq(400)
      expect(response.server_error?).to eq(false)
    end
  end

  describe 'single merchant revenue endpoint' do
    it "successfully returns a single merchants total revenue" do
      merchant = create :merchant
      item = create :item, merchant: merchant
      customer = create :customer

      # generates 60 dollars in revenue for our merchant
      invoice = customer.invoices.create!(status: 'shipped', merchant: merchant)
      invoice.transactions.create!(result: 'success', credit_card_number: '12345', credit_card_expiration_date: '12/7')
      invoice.invoice_items.create!(item: item, quantity: 20, unit_price: 3)

      get "/api/v1/revenue/merchants/#{merchant.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.server_error?).to eq(false)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to have_key(:data)
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_an(String)
      expect(merchant[:data][:attributes]).to be_a(Hash)

      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to eq("merchant_revenue")

      expect(merchant[:data][:attributes]).to have_key(:revenue)
      expect(merchant[:data][:attributes][:revenue]).to be_a(Float)
    end
  end
end
