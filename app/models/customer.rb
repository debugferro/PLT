class Customer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :external_code, type: String
  field :nickname, type: String
  field :email, type: String
  field :phone_area_code, type: Integer
  field :phone_number, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :doc_type, type: String
  field :doc_number, type: String

  belongs_to :shipment_payloads, class_name: 'ShipmentPayload', inverse_of: :customer

  validates_presence_of :shipment_payloads
  validates :phone_number, numericality: { only_integer: true }
  validates :external_code, numericality: { only_integer: true }
  validates :doc_number, numericality: { only_integer: true }
  validates :doc_type, inclusion: { in: DOC_TYPES }

  def self.map_attributes(customer)
    {
      external_code: customer[:id],
      nickname: customer[:nickname],
      email: customer[:email],
      phone_area_code: customer[:phone][:area_code],
      phone_number: customer[:phone][:number],
      first_name: customer[:first_name],
      last_name: customer[:last_name],
      doc_type: customer[:billing_info][:doc_type],
      doc_number: customer[:billing_info][:doc_number]
    }
  end

  def map_attributes
    {
      externalCode: external_code,
      name: nickname,
      email: email,
      contact: contact
    }
  end

  def contact
    "#{phone_area_code}#{phone_number}"
  end
end
