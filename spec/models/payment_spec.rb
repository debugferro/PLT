require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { is_expected.to have_fields(:payment_type, :status, :date_approved, :date_created).of_type(String) }
  it { is_expected.to have_fields(:order_id, :payer_id, :installments).of_type(Integer) }
  it { is_expected.to have_fields(:transaction_amount, :taxes_amount, :shipping_cost, :total_paid_amount, :installment_amount).of_type(Float) }
  it { is_expected.to belong_to(:shipment_payloads).of_type(ShipmentPayload).as_inverse_of(:payments) }
  it { is_expected.to validate_presence_of(:order_id) }
  it { is_expected.to validate_presence_of(:payer_id) }
  it { is_expected.to validate_uniqueness_of(:order_id) }
  it { is_expected.to validate_uniqueness_of(:payer_id) }
  it { is_expected.to validate_numericality_of(:order_id) }
  it { is_expected.to validate_numericality_of(:payer_id) }
  describe 'Custom validations =>' do
    before(:each) do
      @shipment_payload = build(:a_complete_shipmet_payload)
    end

    context 'Date Validations =>' do
      it 'should have date_approved to be invalid when is not a valid DateTime format' do
        @shipment_payload.payments.first.date_approved = '4fdsfksdfkslkast fdofsdkjflsd'
        expect(@shipment_payload).to_not be_valid
        expect(@shipment_payload.errors.size).to eq(1)
        expect(@shipment_payload.payments.first.errors.attribute_names).to include(:date_approved)
      end

      it 'should have date_created to be invalid when is not a valid DateTime format' do
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
      @payment = @shipment_payload.payments.first
    end

    context 'Map Methods =>' do
      it 'should return :type and :value keys when calling map_attributes to an instance' do
        keys = @payment.map_attributes.keys
        expect(keys).to match_array(%i[type value])
      end

      it "should return all Payment fields attributes mapped when calling instance method 'map_attributes'" do
        params = [
          {
            "id": 12_312_313,
            "order_id": 9_987_071,
            "payer_id": 414_138,
            "installments": 1,
            "payment_type": 'credit_card',
            "status": 'paid',
            "transaction_amount": 49.9,
            "taxes_amount": 0,
            "shipping_cost": 5.14,
            "total_paid_amount": 55.04,
            "installment_amount": 55.04,
            "date_approved": '2019-06-24T16:45:35.000-04:00',
            "date_created": '2019-06-24T16:45:33.000-04:00'
          }
        ]

        fields = Payment.fields.keys.map(&:to_sym)
        fields.delete(:_id)
        fields.delete(:created_at)
        fields.delete(:updated_at)
        parsed_params = [params.first.transform_keys(&:to_sym)]
        mapped_attributes = Payment.map_attributes(parsed_params).first.keys
        expect(mapped_attributes).to match_array(fields)
      end
    end
  end
end
