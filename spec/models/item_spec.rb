require 'rails_helper'

RSpec.describe Item, type: :model do
  it { is_expected.to have_fields(:external_code, :title).of_type(String) }
  it { is_expected.to have_fields(:sub_items).of_type(Array) }
  it { is_expected.to validate_uniqueness_of(:external_code) }
  it { is_expected.to validate_presence_of(:external_code) }
  it { is_expected.to validate_presence_of(:order_item) }
  describe 'Methods =>' do
    before(:each) do
      @shipment_payload = build(:a_complete_shipmet_payload)
      @item = @shipment_payload.order_items.first.item
    end

    context 'Map Methods =>' do
      it 'should return :externalCode, :name and :subItems keys when calling map_attributes to an instance' do
        keys = @item.map_attributes.keys
        expect(keys).to match_array(%i[externalCode name subItems])
      end

      it "should return all Item fields attributes mapped when calling instance method 'map_attributes' but subItems" do
        params = {
          "id": 'IT4801901403',
          "title": 'Produto de Testes'
        }

        fields = Item.fields.keys.map(&:to_sym)
        fields.delete(:_id)
        fields.delete(:created_at)
        fields.delete(:updated_at)
        fields.delete(:order_item_id)
        fields.delete(:sub_items)
        mapped_attributes = Item.map_attributes(params).keys
        expect(mapped_attributes).to match_array(fields)
      end
    end
  end
end
