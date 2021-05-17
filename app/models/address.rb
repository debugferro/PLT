class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  field :address_line, type: String
  field :external_id, type: Integer
  field :street_name, type: String
  field :comment, type: String
  field :zip_code, type: String
  field :city_name, type: String
  field :street_number, type: String
  field :state, type: String
  field :country, type: String
  field :country_id, type: String
  field :neighborhood, type: String
  field :latitude, type: Float
  field :longitude, type: Float

  belongs_to :shipments, class_name: 'Shipment', inverse_of: :address

  validates_presence_of :shipments
  validates :external_id, uniqueness: true, presence: true, numericality: { only_integer: true }
  validates :zip_code, numericality: { only_integer: true }
  validates :street_number, numericality: { only_integer: true }
  validates :state, inclusion: { in: STATES.flatten }

  def self.map_attributes(address)
    keys = %i[address_line street_name street_number comment zip_code latitude longitude]
    address_mapped = {}
    keys.each do |key|
      address_mapped[key] = address[key]
    end
    address_mapped.merge!({ external_id: address[:id],
                            city_name: address[:city][:name],
                            state: address[:state][:name],
                            country: address[:country][:name],
                            country_id: address[:country][:id],
                            neighborhood: address[:neighborhood][:name] })
    address_mapped
  end

  def map_attributes
    {
      country: country_id,
      state: state_initials.flatten.second,
      city: city_name,
      district: neighborhood,
      street: street_name,
      complement: comment,
      latitude: latitude,
      longitude: longitude,
      postalCode: zip_code,
      number: street_number
    }
  end

  def state_initials
    STATES.filter { |st| st[0].downcase == state.downcase }
  end
end
