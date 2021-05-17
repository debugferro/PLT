# Instalação

Clone o repositório:
```
git clone git@github.com:debugferro/PLT.git
```
Instale as gems:
```
bundle install
```
Inicie o servidor:
```
rails s
```
# Utilização
Testes foram feitos com o framework Rspec. No terminal digite para executar:
```
rspec
```

# Utilização

Envie uma post request para a url:
```
#{url_base}/api/shipment_payloads
```
<details>
  <summary>
    Exemplo de body:
  </summary>

```
{
  "id": 9987071,
  "store_id": 282,
  "date_created": "2019-06-24T16:45:32.000-04:00",
  "date_closed": "2019-06-24T16:45:35.000-04:00",
  "last_updated": "2019-06-25T13:26:49.000-04:00",
  "total_amount": 49.9,
  "total_shipping": 5.14,
  "total_amount_with_shipping": 55.04,
  "paid_amount": 55.04,
  "expiration_date": "2019-07-22T16:45:35.000-04:00",
  "total_shipping": 5.14,
  "order_items": [
    {
      "item": {
        "id": "IT4801901403",
        "title": "Produto de Testes"
      },
      "quantity": 1,
      "unit_price": 49.9,
      "full_unit_price": 49.9
    }
  ],
  "payments": [
    {
      "id": 12312313,
      "order_id": 9987071,
      "payer_id": 414138,
      "installments": 1,
      "payment_type": "credit_card",
      "status": "paid",
      "transaction_amount": 49.9,
      "taxes_amount": 0,
      "shipping_cost": 5.14,
      "total_paid_amount": 55.04,
      "installment_amount": 55.04,
      "date_approved": "2019-06-24T16:45:35.000-04:00",
      "date_created": "2019-06-24T16:45:33.000-04:00"
    }
  ],
  "shipping": {
    "id": 43444211797,
    "shipment_type": "shipping",
    "date_created": "2019-06-24T16:45:33.000-04:00",
    "receiver_address": {
      "id": 1051695306,
      "address_line": "Rua Fake de Testes 3454",
      "street_name": "Rua Fake de Testes",
      "street_number": "3454",
      "comment": "teste",
      "zip_code": "85045020",
      "city": {
        "name": "Cidade de Testes"
      },
      "state": {
        "name": "São Paulo"
      },
      "country": {
        "id": "BR",
        "name": "Brasil"
      },
      "neighborhood": {
        "id": null,
        "name": "Vila de Testes"
      },
      "latitude": -23.629037,
      "longitude": -46.712689,
      "receiver_phone": "41999999999"
    }
  },
  "status": "paid",
  "buyer": {
    "id": 136226073,
    "nickname": "JOHN DOE",
    "email": "john@doe.com",
    "phone": {
      "area_code": 41,
      "number": "999999999"
    },
    "first_name": "John",
    "last_name": "Doe",
    "billing_info": {
      "doc_type": "CPF",
      "doc_number": "09487965477"
    }
  }
}
```

</details>

# Utilização

Todo payload é armazenado no modelo ShipmentPayload, que guarda os dados principais. Dados mais específicos são armazenados nas relações de ShipmentPayload, que são: OrderItem, Payment, Customer e Shipment.

O external_code de ShipmentPayload é único, e não poderá haver outro igual. Ele é referência para a verificação da existência ou inexistência de um registro. Caso já exista um record com o mesmo external_code (vulgo ID), o programa não criará outro registro, apenas enviará o já existente para a API do delivery center.

# Personalização

Para trocar a API do delivery center, é preciso editar a variável 'processor_url' no arquivo config/secrets.yml

# Esquema Banco de Dados

O banco de dados utiliza mongodb. O esquema utilizado foi o seguinte:

![Captura de tela de 2021-05-14 02-27-30](https://user-images.githubusercontent.com/67886352/118225815-2bd06280-b45c-11eb-868d-324046244b89.png)

