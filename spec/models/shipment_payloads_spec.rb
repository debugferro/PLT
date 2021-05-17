require 'rails_helper'

RSpec.describe ShipmentPayload, type: :model do
  it { is_expected.to have_fields(:status, :date_created, :date_closed, :last_updated, :expiration_date).of_type(String) }
  it { is_expected.to have_fields(:external_code, :store_id).of_type(Integer) }
  it { is_expected.to have_fields(:total_amount, :total_shipping, :total_amount_with_shipping, :paid_amount, :total_shipping).of_type(Float) }
  it { is_expected.to have_many(:order_items) }
  it { is_expected.to have_many(:payments) }
  it { is_expected.to have_one(:customer) }
  it { is_expected.to have_one(:shipment) }
  it { is_expected.to validate_presence_of(:store_id) }
  it { is_expected.to validate_presence_of(:external_code) }
  it { is_expected.to validate_uniqueness_of(:store_id) }
  it { is_expected.to validate_uniqueness_of(:external_code) }
  it { is_expected.to validate_numericality_of(:store_id) }
  it { is_expected.to validate_numericality_of(:external_code) }
  it { is_expected.to accept_nested_attributes_for(:order_items) }
  it { is_expected.to accept_nested_attributes_for(:payments) }
  it { is_expected.to accept_nested_attributes_for(:shipment) }
  it { is_expected.to accept_nested_attributes_for(:customer) }

  describe 'Custom validations =>' do
    before(:each) do
      @shipment_payload = build(:a_complete_shipmet_payload)
    end

    context 'Date Validations =>' do
      it 'should have date_approved to be invalid when is not a valid DateTime format' do
        @shipment_payload.date_created = '4fdsfksdfkslkast fdofsdkjflsd'
        expect(@shipment_payload).to_not be_valid
        expect(@shipment_payload.errors.size).to eq(1)
        expect(@shipment_payload.errors.attribute_names).to include(:date_created)
      end

      it 'should have date_closed to be invalid when is not a valid DateTime format' do
        @shipment_payload.date_closed = '4fdsfksdfkslkast fdofsdkjflsd'
        expect(@shipment_payload).to_not be_valid
        expect(@shipment_payload.errors.size).to eq(1)
        expect(@shipment_payload.errors.attribute_names).to include(:date_closed)
      end
    end
  end

  describe 'Methods =>' do
    before(:each) do
      @shipment_payload = build(:a_complete_shipmet_payload)
    end

    context 'Map Methods =>' do
      expected_keys = %i[externalCode storeId subTotal deliveryFee total_shipping total dtOrderCreate customer items payments country state city district street complement latitude longitude postalCode number]
      it 'should return :externalCode, :storeId, :subTotal, :deliveryFee, :total_shipping, :total, :dtOrderCreate, :customer, :items, :payments, :country, :state, :city, :district, :street, :complement, :latitude, :longitude, :postalCode, :number and all address keys for when calling map_attributes to an instance' do
        keys = @shipment_payload.map_attributes.keys
        expect(keys).to match_array(expected_keys)
      end
    end
  end
end
