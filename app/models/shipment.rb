class Shipment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :external_id, type: Integer
  field :shipment_type, type: String
  field :date_created, type: String

  belongs_to :shipment_payloads, class_name: 'ShipmentPayload', inverse_of: :shipment
  has_one :address
  accepts_nested_attributes_for :address

  def self.map_attributes(shipment)
    {
      external_id: shipment[:id],
      shipment_type: shipment[:shipment_type],
      date_created: shipment[:date_created],
      address_attributes: Address.map_attributes(shipment[:receiver_address])
    }
  end
end
