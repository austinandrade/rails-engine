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
end
