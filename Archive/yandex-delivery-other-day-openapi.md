# Яндекс Доставка — Доставка в другой день
# OpenAPI 3.0.3 спецификация
# Совместима с Swift OpenAPI Generator

openapi: 3.0.3
info:
  title: Яндекс Доставка – API «Доставка в другой день»
  version: 1.0.0
  description: |
    Спецификация «Доставка в другой день» построена по документации
    платформы `platform`[7][13][17]. API предназначено для плановых доставок
    с забором/самопривозом и последующей курьерской доставкой или выводом
    в ПВЗ.

servers:
  - url: https://b2b-authproxy.taxi.yandex.net/api/b2b/platform
    description: Продакшен-контур
  - url: https://b2b.taxi.tst.yandex.net/api/b2b/platform
    description: Тестовый контур

security:
  - bearerAuth: []

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: OAuth

  parameters:
    StationID:
      name: platform_station_id
      in: query
      required: true
      description: Уникальный идентификатор станции отгрузки
      schema:
        type: string

  schemas:
    # Сокращённый набор сущностей для примера
    DeliveryOptionRequest:
      type: object
      required: [address_from, address_to, weight_kg]
      properties:
        address_from:
          type: string
        address_to:
          type: string
        weight_kg:
          type: number
          format: double
        dimensions_cm:
          type: array
          items:
            type: integer
          minItems: 3
          maxItems: 3
        declared_value:
          type: number

    DeliveryOption:
      type: object
      required: [service_code, cost]
      properties:
        service_code:
          type: string
        cost:
          type: number
          format: double
        days_min:
          type: integer
        days_max:
          type: integer

paths:
  /offers/create:
    post:
      summary: Получение расчёта стоимости (pricing-calculator)
      operationId: createOffer
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/DeliveryOptionRequest'
      responses:
        '200':
          description: Список возможных вариантов доставки
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/DeliveryOption'
  /offers/info:
    get:
      summary: Интервалы отгрузок
      operationId: getOfferInfo
      parameters:
        - $ref: '#/components/parameters/StationID'
      responses:
        '200':
          description: Доступные интервалы

  /request/generate-labels:
    post:
      summary: Генерация ярлыков на посылки
      operationId: generateLabels
      responses:
        '200':
          description: PDF c ярлыками (base64)

