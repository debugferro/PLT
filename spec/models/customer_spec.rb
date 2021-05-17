require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to belong_to(:shipment_payloads).of_type(ShipmentPayload).as_inverse_of(:customer) }
  it { is_expected.to have_fields(:external_code, :nickname, :email, :phone_number, :first_name, :last_name, :doc_type, :doc_number).of_type(String) }
  it { is_expected.to have_field(:phone_area_code).of_type(Integer) }
  it { is_expected.to validate_presence_of(:shipment_payloads) }
  it { is_expected.to validate_numericality_of(:doc_number) }
  it { is_expected.to validate_numericality_of(:external_code) }
  it { is_expected.to validate_numericality_of(:phone_number) }
  it { is_expected.to validate_inclusion_of(:doc_type).to_allow(DOC_TYPES) }

  describe 'Methods =>' do
    before(:each) do
      @shipment_payload = build(:a_complete_shipmet_payload)
      @customer = @shipment_payload.customer
    end

    context 'Map Methods =>' do
      it 'should return :externalCode, :name, :email and :contact keys when calling map_attributes to an instance' do
        keys = @customer.map_attributes.keys
        expect(keys).to match_array(%i[externalCode name email contact])
      end

      it "should return all Customer fields attributes mapped when calling instance method 'map_attributes'" do
        params = {
          "id": 136_226_073,
          "nickname": 'JOHN DOE',
          "email": 'john@doe.com',
          "phone": {
            "area_code": 41,
            "number": '999999999'
          },
          "first_name": 'John',
          "last_name": 'Doe',
          "billing_info": {
            "doc_type": 'CPF',
            "doc_number": '09487965477'
          }
        }

        fields = Customer.fields.keys.map(&:to_sym)
        fields.delete(:_id)
        fields.delete(:created_at)
        fields.delete(:updated_at)
        fields.delete(:shipment_payloads_id)
        mapped_attributes = Customer.map_attributes(params).keys
        expect(mapped_attributes).to match_array(fields)
      end
    end

    context 'Other Methods =>' do
      it "should return phone_area_code and phone_number concatenated when calling 'contact' method" do
        contact = @customer.contact
        expect(contact).to eq("#{@customer.phone_area_code}#{@customer.phone_number}")
      end
    end
  end
end
