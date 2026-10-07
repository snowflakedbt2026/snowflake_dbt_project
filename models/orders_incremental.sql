{{ config(
    materialized='incremental',
    alias='SALES_ORDERS_INCREMENTAL',
    unique_key='ORDER_ID',
    incremental_strategy='merge',
    transient=false
) }}

SELECT
    o.ORDER_ID,
    o.CUSTOMER_ID,
    c.CUSTOMER_NAME,
    c.CITY,
    o.PRODUCT_ID,
    p.PRODUCT_NAME,
    p.PRICE,
    o.ORDER_DATE,
    o.QUANTITY,
    p.PRICE * o.QUANTITY AS AMOUNT,
    o.ORDER_STATUS,
    o.UPDATED_AT

FROM {{ source('raw_data', 'ORDERS_DEMO') }} o

LEFT JOIN {{ source('raw_data', 'CUSTOMERS') }} c
    ON o.CUSTOMER_ID = c.CUSTOMER_ID

LEFT JOIN {{ source('raw_data', 'PRODUCTS_DEMO') }} p
    ON o.PRODUCT_ID = p.PRODUCT_ID

{% if is_incremental() %}

WHERE o.UPDATED_AT > (
    SELECT MAX(UPDATED_AT)
    FROM {{ this }}
)

{% endif %}
