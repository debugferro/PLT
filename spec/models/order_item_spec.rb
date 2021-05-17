require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  it { is_expected.to have_fields(:unit_price, :full_unit_price).of_type(Float) }
  it { is_expected.to have_fields(:quantity).of_type(Integer) }
  it { is_expected.to have_one(:item) }
  it { is_expected.to belong_to(:shipment_payloads).of_type(ShipmentPayload).as_inverse_of(:order_items) }
  it { is_expected.to accept_nested_attributes_for(:item) }
  describe 'Methods =>' do
    before(:each) do
      @shipment_payload = build(:a_complete_shipmet_payload)
      @order_item = @shipment_payload.order_items.first
    end

    context 'Map Methods =>' do
      it 'should return :price, :quantity, :total and all Item keys when calling map_attributes to an instance' do
        keys = @order_item.map_attributes.keys
        expect(keys).to match_array(%i[price quantity total externalCode name subItems])
      end

      it "should return all OrderItem fields attributes mapped when calling instance method 'map_attributes'" do
        params = [
          {
            "item": {
              "id": 'IT4801901403',
              "title": 'Produto de Testes'
            },
            "quantity": 1,
            "unit_price": 49.9,
            "full_unit_price": 49.9
          }
        ]

        fields = OrderItem.fields.keys.map(&:to_sym)
        fields.delete(:_id)
        fields.delete(:created_at)
        fields.delete(:updated_at)
        fields.delete(:shipment_payloads_id)
        fields.delete(:items)
        fields << :item_attributes
        parsed_params = [params.first.transform_keys(&:to_sym)]
        mapped_attributes = OrderItem.map_attributes(parsed_params).first.keys
        expect(mapped_attributes).to match_array(fields)
      end
    end
  end
end
