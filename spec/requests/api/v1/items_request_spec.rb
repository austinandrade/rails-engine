require 'rails_helper'

describe "items requests" do
  it "returns all item json objects" do
    merchant              = create(:merchant)
    merchant_2            = create(:merchant)
    merchant_1_items      = create_list(:item, 3, merchant: merchant)
    merchant_2_items      = create_list(:item, 3, merchant: merchant_2)

    get '/api/v1/items'

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.error?).to eq(false)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to have_key(:data)
    expect(items[:data].count).to eq(6)
    expect(items[:data]).to be_an(Array)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item[:attributes]).to be_a(Hash)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_an(Object)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it "returns a subset of items based on desired page number" do
    merchant              = create(:merchant)
    merchant_2            = create(:merchant)
    merchant_1_items      = create_list(:item, 20, merchant: merchant)
    merchant_2_items      = create_list(:item, 20, merchant: merchant_2)

    get '/api/v1/items', params: {page: 2}

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.error?).to eq(false)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data][0][:id].to_i).to eq(merchant_2_items[0].id)
  end

  it "returns a subset of item based on per_page limitation" do
    merchant              = create(:merchant)
    merchant_2            = create(:merchant)
    merchant_1_items      = create_list(:item, 20, merchant: merchant)
    merchant_2_items      = create_list(:item, 20, merchant: merchant_2)

    get '/api/v1/items', params: {per_page: 5}

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.error?).to eq(false)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(5)
  end

  it "returns one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.error?).to eq(false)

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item).to have_key(:data)
    expect(item[:data]).to be_a(Hash)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)
    expect(item[:data][:id].to_i).to eq(id)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_an(Object)

    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to be_a(Hash)


    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
  end

  it "creates then deletes an item" do
    merchant    = create(:merchant)
    item_params = ({
                    name:         'Yeah boi',
                    description:  'Im the fastest',
                    unit_price:   123.56,
                    merchant_id:  merchant.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(response.error?).to eq(false)

    expect(Item.count).to eq(1)
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])

    delete "/api/v1/items/#{created_item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(created_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe 'item update' do
    it "can update an existing item" do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: "Spider Man" }
      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("Spider Man")
    end

    it "attempts to update item with invalid merchant id" do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: "Spider Man", merchant_id: 25 }
      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response.status).to eq(404)
      expect(item.name).to eq(previous_name)
    end
  end

  it "returns a single item's merchant by their id" do
    merchant_1      = create(:merchant)
    merchant_2      = create(:merchant)
    merchant_3      = create(:merchant)
    merchant_1_item = create(:item, merchant: merchant_1)
    merchant_2_item = create(:item, merchant: merchant_2)
    merchant_3_item = create(:item, merchant: merchant_3)

    get "/api/v1/items/#{merchant_2_item.id}/merchant"

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(response.error?).to eq(false)

    merchant_response = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_response).to have_key(:data)
    expect(merchant_response[:data]).to be_a(Hash)

    expect(merchant_response[:data]).to have_key(:id)
    expect(merchant_response[:data][:id]).to be_a(String)

    expect(merchant_response[:data]).to have_key(:attributes)
    expect(merchant_response[:data][:attributes]).to be_an(Hash)

    expect(merchant_response[:data][:attributes]).to have_key(:name)
    expect(merchant_response[:data][:attributes][:name]).to be_a(String)
  end
end
