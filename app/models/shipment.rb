class Shipment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :external_id, type: Integer
  field :shipment_type, type: String
  field :date_created, type: String

  belongs_to :shipment_payloads, class_name: 'ShipmentPayload', inverse_of: :shipment
  has_one :address
  accepts_nested_attributes_for :address

  validates :external_id, presence: true, uniqueness: true, numericality: true
  validates_presence_of :address
  validate :check_date_format

  def date_valid?(date)
    DateTime.parse(date) rescue false
  end

  def self.map_attributes(shipment)
    {
      external_id: shipment[:id],
      shipment_type: shipment[:shipment_type],
      date_created: shipment[:date_created],
      address_attributes: Address.map_attributes(shipment[:receiver_address])
    }
  end

  def check_date_format
    date_created_status = date_valid?(date_created)
    return if date_created_status

    message = 'tem o formato invalido.'
    errors.add(:date_created,
               :date_format,
               message: message)
  end
end
