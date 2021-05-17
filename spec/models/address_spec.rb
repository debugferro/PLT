require 'rails_helper'

RSpec.describe Address, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to belong_to(:shipments).of_type(Shipment).as_inverse_of(:address) }
  it { is_expected.to have_fields(:address_line, :street_name, :comment, :zip_code, :city_name, :street_number, :state, :country, :country_id, :neighborhood).of_type(String) }
  it { is_expected.to have_fields(:latitude, :longitude).of_type(Float) }
  it { is_expected.to have_field(:external_id).of_type(Integer) }
  it { is_expected.to validate_presence_of(:shipments) }
  it { is_expected.to validate_presence_of(:external_id) }
  it { is_expected.to validate_uniqueness_of(:external_id) }
  it { is_expected.to validate_numericality_of(:external_id) }
  it { is_expected.to validate_numericality_of(:zip_code) }
  it { is_expected.to validate_numericality_of(:street_number) }
  it { is_expected.to validate_inclusion_of(:state).to_allow([STATES]) }

  describe 'Methods =>' do
    before(:each) do
      @shipment_payload = build(:a_complete_shipmet_payload)
      @address = @shipment_payload.shipment.address
    end

    context 'Map Methods =>' do
      it 'should return :country, :state, :city, :district, :street, :complement, :latitude, :longitude, :postalCode and :number keys when calling map_attributes to an instance' do
        keys = @address.map_attributes.keys
        expect(keys).to match_array(%i[country state city district street complement latitude longitude postalCode number])
      end

      it "should return all Address fields attributes mapped when calling instance method 'map_attributes'" do
        params = {
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

        fields = Address.fields.keys.map(&:to_sym)
        fields.delete(:_id)
        fields.delete(:created_at)
        fields.delete(:updated_at)
        fields.delete(:shipments_id)
        mapped_attributes = Address.map_attributes(params).keys
        expect(mapped_attributes).to match_array(fields)
      end
    end
  end
end
