class OrderItem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :unit_price, type: Float
  field :full_unit_price, type: Float
  field :quantity, type: Integer

  has_one :item
  belongs_to :shipment_payloads, class_name: 'ShipmentPayload', inverse_of: :order_items

  accepts_nested_attributes_for :item
  validates_presence_of :shipment_payloads

  def self.map_attributes(order_items)
    order_items.map do |order|
      {
        item_attributes: Item.map_attributes(order[:item]),
        quantity: order[:quantity],
        unit_price: order[:unit_price],
        full_unit_price: order[:full_unit_price]
      }
    end
  end

  def map_attributes
    {
      price: unit_price,
      quantity: quantity,
      total: full_unit_price
    }.merge(item.map_attributes)
  end
end
