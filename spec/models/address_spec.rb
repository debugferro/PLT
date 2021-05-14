require 'rails_helper'

RSpec.describe Address, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to belong_to(:shipments).of_type(Shipment).as_inverse_of(:address) }
end
