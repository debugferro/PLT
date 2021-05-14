class ShipmentPayload
  include Mongoid::Document
  include Mongoid::Timestamps

  field :external_code, type: Integer
  field :store_id, type: Integer
  field :total_amount, type: Float
  field :total_shipping, type: Float
  field :total_amount_with_shipping, type: Float
  field :paid_amount, type: Float
  field :total_shipping, type: Float
  field :status, type: String
  field :date_created, type: String
  field :date_closed, type: String
  field :last_updated, type: String
  field :expiration_date, type: String

  has_many :order_items
  has_many :payments
  has_one :customer
  has_one :shipment

  validates :external_code, uniqueness: true, presence: true

  accepts_nested_attributes_for :order_items
  accepts_nested_attributes_for :payments
  accepts_nested_attributes_for :shipment
  accepts_nested_attributes_for :customer

  def map_attributes
    {
      externalCode: external_code,
      storeId: store_id,
      subTotal: total_amount,
      deliveryFee: total_shipping,
      total_shipping: total_shipping.to_f,
      total: total_amount_with_shipping,
      dtOrderCreate: date_created,
      customer: customer.map_attributes,
      items: order_items.map(&:map_attributes),
      payments: payments.map(&:map_attributes)
    }.merge(shipment.address.map_attributes)
  end
end
