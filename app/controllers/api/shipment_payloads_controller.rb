class Api::ShipmentPayloadsController < ApplicationController
  def create
    shipment = ShipmentPayload.where(external_code: params[:id])
    shipment = shipment.first_or_create(build_params)

    shipment.save
    return render json: { messages: shipment.errors.full_messages } unless shipment.persisted?

    shipment_data = shipment.map_attributes
    processor = Processor.new
    response = processor.send(shipment_data)
    render json: { messages: response.body }, status: response.status
  end

  private

  def build_params
    {
      order_items_attributes: map_order_items_params,
      payments_attributes: map_payments_params,
      shipment_attributes: map_shipping_params,
      customer_attributes: map_customer_params,
      external_code: params[:id]
    }.merge(shipment_params)
  end

  def shipment_params
    params.permit(:store_id, :date_created, :date_closed, :last_updated,
                  :total_amount, :total_shipping, :total_amount_with_shipping,
                  :paid_amount, :expiration_date, :total_shipping, :status)
  end

  def map_order_items_params
    OrderItem.map_attributes(params[:order_items])
  end

  def map_customer_params
    Customer.map_attributes(params[:buyer])
  end

  def map_payments_params
    Payment.map_attributes(params[:payments])
  end

  def map_shipping_params
    Shipment.map_attributes(params[:shipping])
  end
end
