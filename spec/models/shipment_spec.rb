require 'rails_helper'

RSpec.describe Shipment, type: :model do
  it { is_expected.to have_fields(:shipment_type, :date_created).of_type(String) }
  it { is_expected.to have_fields(:external_id).of_type(Integer) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to belong_to(:shipment_payloads).of_type(ShipmentPayload).as_inverse_of(:shipment) }
  it { is_expected.to accept_nested_attributes_for(:address) }
  it { is_expected.to validate_presence_of(:external_id) }
  it { is_expected.to validate_uniqueness_of(:external_id) }
  it { is_expected.to validate_numericality_of(:external_id) }

  describe 'Custom validations =>' do
    before(:each) do
      @shipment_payload = build(:a_complete_shipmet_payload)
    end

    context 'Date Validations =>' do
      it 'should have date_approved to be invalid when is not a valid DateTime format' do
        @shipment_payload.payments.first.date_created = '4fdsfksdfkslkast fdofsdkjflsd'
        expect(@shipment_payload).to_not be_valid
        expect(@shipment_payload.errors.size).to eq(1)
        expect(@shipment_payload.payments.first.errors.attribute_names).to include(:date_created)
      end
    end
  end

  describe 'Methods =>' do
    before(:each) do
      @shipment_payload = build(:a_complete_shipmet_payload)
      @shipment = @shipment_payload.shipment
    end

    context 'Map Methods =>' do
      it "should return all Shipment fields attributes mapped when calling instance method 'map_attributes'" do
        params = {
          "id": 43_444_211_797,
          "shipment_type": 'shipping',
          "date_created": '2019-06-24T16:45:33.000-04:00',
          "receiver_address": {
            "id": 1_051_695_306,
            "address_line": 'Rua Fake de Testes 3454',
            "street_name": 'Rua Fake de Testes',
            "street_number": '3454',
            "comment": 'teste',
            "zip_code": '85045020',
            "city": {
              "name": 'Cidade de Testes'
            },
            "state": {
              "name": 'São Paulo'
            },
            "country": {
              "id": 'BR',
              "name": 'Brasil'
            },
            "neighborhood": {
              "id": nil,
              "name": 'Vila de Testes'
            },
            "latitude": -23.629037,
            "longitude": -46.712689,
            "receiver_phone": '41999999999'
          }
        }
        fields = Shipment.fields.keys.map(&:to_sym)
        fields.delete(:_id)
        fields.delete(:created_at)
        fields.delete(:updated_at)
        fields.delete(:shipment_payloads_id)
        fields << :address_attributes
        mapped_attributes = Shipment.map_attributes(params).keys
        expect(mapped_attributes).to match_array(fields)
      end
    end
  end
end
