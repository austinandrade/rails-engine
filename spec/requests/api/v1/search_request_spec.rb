require 'rails_helper'

describe "search requests" do
  describe 'single merchant search' do
    it "returns a single merchant when searching with partial name fragment" do
      merchant_1    = create(:merchant, name: 'Turing')
      merchant_2    = create(:merchant, name: 'Albert')
      merchant_3    = create(:merchant, name: 'during')

      search_params = ({
                      name: 'UrInG',
                      })
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/merchants/find', headers: headers, params: search_params

      found_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.error?).to eq(false)

      expect(found_merchant).to have_key(:data)
      expect(found_merchant[:data]).to be_a(Hash)

      expect(found_merchant[:data]).to have_key(:type)
      expect(found_merchant[:data][:type]).to be_an(Object)

      expect(found_merchant[:data]).to have_key(:attributes)
      expect(found_merchant[:data][:attributes]).to be_a(Hash)

      expect(found_merchant[:data][:attributes]).to have_key(:name)
      expect(found_merchant[:data][:attributes][:name]).to be_a(String)

      expect(found_merchant[:data][:attributes][:name]).to eq(merchant_3.name)
    end

    it "returns real object with all nil/null fields if search fragment doesn't match any records" do
      search_params = ({
                      name: 'UrInG',
                      })
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/merchants/find', headers: headers, params: search_params

      found_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.error?).to eq(false)

      expect(found_merchant).to have_key(:data)
      expect(found_merchant[:data]).to be_a(Hash)

      expect(found_merchant[:data]).to have_key(:id)
      expect(found_merchant[:data][:id]).to eq(nil)

      expect(found_merchant[:data]).to have_key(:type)
      expect(found_merchant[:data][:type]).to be_an(Object)

      expect(found_merchant[:data]).to have_key(:attributes)
      expect(found_merchant[:data][:attributes]).to be_a(Hash)

      expect(found_merchant[:data][:attributes]).to have_key(:name)
      expect(found_merchant[:data][:attributes][:name]).to eq(nil)
    end
  end

  describe 'all qualifying items search' do
    it "returns all items that qualify when searching with partial name fragment" do
      item_1    = create(:item, name: 'kurt')
      item_2    = create(:item, name: 'Albert')
      item_3    = create(:item, name: 'thomas')
      item_4    = create(:item, name: 'burt')
      item_5    = create(:item, name: 'frank')
      item_6    = create(:item, name: 'Ben')
      search_params = ({
                      name: 'Rt',
                      })
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find_all', headers: headers, params: search_params

      found_items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.error?).to eq(false)

      expect(found_items).to have_key(:data)
      expect(found_items[:data]).to be_an(Array)

      expect(found_items[:data].first[:attributes][:name]).to be_a(String)
      expect(found_items[:data].second[:attributes][:name]).to be_a(String)
      expect(found_items[:data].last[:attributes][:name]).to be_a(String)

      expect(found_items[:data].first[:attributes][:name]).to eq(item_2.name)
      expect(found_items[:data].second[:attributes][:name]).to eq(item_4.name)
      expect(found_items[:data].last[:attributes][:name]).to eq(item_1.name)
    end

    it "returns empty array if partial name fragment doesn't match any records" do
      search_params = ({
                      name: 'Rt',
                      })
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find_all', headers: headers, params: search_params

      found_items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.error?).to eq(false)

      expect(found_items).to have_key(:data)
      expect(found_items[:data]).to be_an(Array)
      expect(found_items[:data].empty?).to be(true)
    end
  end
end
