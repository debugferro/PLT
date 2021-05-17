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

  validates :external_code, :store_id, uniqueness: true, presence: true, numericality: true
  validate :check_date_format

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

  def date_valid?(date)
    DateTime.parse(date) rescue false
  end

  def check_date_format
    date_created_status = date_valid?(date_created)
    date_closed_status = date_valid?(date_closed)
    return if date_created_status && date_closed_status

    message = 'tem o formato invalido.'
    unless date_created_status
      errors.add(:date_created,
                :date_format,
                message: message)
    end
    unless date_closed_status
      errors.add(:date_closed,
                :date_format,
                message: message)
    end
  end

  def map_errors
    main_message = { messages: errors.full_messages }
    full_messages = {}
    attributes_with_errors = errors.keys
    attributes_with_errors.each do |attribute_with_error|
      attribute = public_send(attribute_with_error)
      if attribute.is_a?(Array)
        full_messages[attribute_with_error] = attribute.map(&:errors).map(&:full_messages).flatten
      else
        full_messages[attribute_with_error] = attribute.errors.full_messages
      end
    end
    main_message.merge({ attributes: attributes_with_errors, full_messages: full_messages })
  end
end
