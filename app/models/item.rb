class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :external_code, type: String
  field :title, type: String
  field :sub_items, type: Array, default: []

  belongs_to :order_item, class_name: "OrderItem", inverse_of: :item

  validates :external_code, presence: true, uniqueness: true
  validates_presence_of :order_item

  def self.map_attributes(item)
    {
      external_code: item[:id],
      title: item[:title]
    }
  end

  def map_attributes
    {
      externalCode: external_code,
      name: title,
      subItems: sub_items
    }
  end
end
