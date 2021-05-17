FactoryBot.define do
  factory :shipment_payload do
    date_closed { '2019-06-24T16:45:35.000-04:00' }
    date_created { '2019-06-24T16:45:32.000-04:00' }
    expiration_date { '2019-07-22T16:45:35.000-04:00' }
    external_code { rand(1_000_000...9_999_999) }
    last_updated { '2019-06-25T13:26:49.000-04:00' }
    paid_amount { 55.04 }
    status { 'paid' }
    store_id { 282 }
    total_amount { 49.9 }
    total_amount_with_shipping { 55.04 }
    total_shipping { 5.14 }
    customer { association :customer, shipment_payloads: instance }
    shipment { association :shipment, shipment_payloads: instance }

    factory :a_complete_shipmet_payload do
      transient do
        order_items_count { 1 }
        payments_count { 1 }
      end

      after(:build) do |shipment_payload, evaluator|
        create_list(:order_items, evaluator.order_items_count, shipment_payloads: shipment_payload)
        create_list(:payments, evaluator.payments_count, shipment_payloads: shipment_payload)
      end
    end
  end

  factory :order_items, class: OrderItem do
    full_unit_price { 49.9 }
    quantity { 1 }
    unit_price { 49.9 }
    association :shipment_payloads, factory: :shipment_payload, strategy: :build
    item { association :item, order_item: instance}
  end

  factory :item do
    external_code { 'IT4801901403' }
    title { 'Produto de Testes' }
    sub_items { [] }
  end

  factory :payments, class: Payment do
    date_approved { '2019-06-24T16:45:35.000-04:00' }
    date_created { '2019-06-24T16:45:33.000-04:00' }
    installment_amount { 55.04 }
    installments { 1 }
    order_id { 9_987_071 }
    payer_id { 414_138 }
    payment_type { 'credit_card' }
    shipping_cost { 5.14 }
    status { 'paid' }
    taxes_amount { 0.0 }
    total_paid_amount { 55.04 }
    transaction_amount { 49.9 }
    association :shipment_payloads, factory: :shipment_payload, strategy: :build
  end

  factory :customer do
    doc_number { '09487965477' }
    doc_type { 'CPF' }
    email { 'john@doe.com' }
    external_code { '136226073' }
    first_name { 'John' }
    last_name { 'Doe' }
    nickname { 'JOHN DOE' }
    phone_area_code { 41 }
    phone_number { '999999999' }
  end

  factory :shipment do
    date_created { '2019-06-24T16:45:33.000-04:00' }
    external_id { 43_444_211_797 }
    shipment_type { 'shipping' }
    address { association :address, shipments: instance }
  end

  factory :address do
    address_line { 'Rua Fake de Testes 3454' }
    city_name { 'Cidade de Testes' }
    comment { 'teste' }
    country { 'Brasil' }
    country_id { 'BR' }
    external_id { 1_051_695_306 }
    latitude { -23.629037 }
    longitude { -46.712689 }
    neighborhood { 'Vila de Testes' }
    state { 'São Paulo' }
    street_name { 'Rua Fake de Testes' }
    street_number { '3454' }
    zip_code { '85045020' }
  end
end
