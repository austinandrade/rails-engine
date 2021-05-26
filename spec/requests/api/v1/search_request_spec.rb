require 'rails_helper'

describe "search requests" do
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
