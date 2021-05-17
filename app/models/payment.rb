class Payment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :order_id, type: Integer
  field :payer_id, type: Integer
  field :installments, type: Integer
  field :payment_type, type: String
  field :status, type: String
  field :transaction_amount, type: Float
  field :taxes_amount, type: Float
  field :shipping_cost, type: Float
  field :total_paid_amount, type: Float
  field :installment_amount, type: Float
  field :date_approved, type: String
  field :date_created, type: String

  belongs_to :shipment_payloads, class_name: 'ShipmentPayload', inverse_of: :payments

  validates :order_id, :payer_id, uniqueness: true, presence: true, numericality: true
  validate :check_date_format

  def self.map_attributes(payments)
    keys = Payment.attribute_names
    keys = keys.slice(3..keys.length).map(&:to_sym)
    payments.map do |payment|
      new_payment = {}
      keys.each do |key|
        new_payment[key] = payment[key]
      end
      new_payment
    end
  end

  def date_valid?(date)
    DateTime.parse(date) rescue false
  end

  def map_attributes
    {
      type: payment_type,
      value: total_paid_amount
    }
  end

  def check_date_format
    date_approved_status = date_valid?(date_approved)
    date_created_status = date_valid?(date_created)
    return if date_approved_status && date_created_status

    message = 'tem o formato invalido.'
    unless date_approved_status
      errors.add(:date_approved,
                 :date_format,
                 message: message)
    end
    unless date_created_status
      errors.add(:date_created,
                 :date_format,
                 message: message)
    end
  end
end
