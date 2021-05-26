require 'rails_helper'

describe "merchants requests" do
  it "returns 3 merchant json objects" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.error?).to eq(false)

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
    expect(response.error?).to eq(false)

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
    expect(response.error?).to eq(false)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(1)
  end

  it "returns a subset of merchants based on desired page limitation" do
    merchant_collection = create_list(:merchant, 25)
    twenty_first_merchant_id = merchant_collection[20].id

    get '/api/v1/merchants', params: {page: 2}

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.error?).to eq(false)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data][0][:id].to_i).to eq(twenty_first_merchant_id)
  end

  it "returns one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.error?).to eq(false)

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
    expect(response.error?).to eq(false)

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
end
