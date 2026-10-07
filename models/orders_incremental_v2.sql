{{ config(
    materialized='incremental',
    alias='SALES_ORDER_INCREMENTAL_V2',
    unique_key='ORDER_ID',
    incremental_strategy='merge',
    transient=false
) }}

WITH source_orders AS (

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
        o.UPDATED_AT AS ORDER_UPDATED_AT,
        p.UPDATED_AT AS PRODUCT_UPDATED_AT

    FROM {{ source('raw_data', 'ORDERS_DEMO') }} o

    LEFT JOIN {{ source('raw_data', 'CUSTOMERS') }} c
        ON o.CUSTOMER_ID = c.CUSTOMER_ID

    LEFT JOIN {{ source('raw_data', 'PRODUCTS_DEMO') }} p
        ON o.PRODUCT_ID = p.PRODUCT_ID
)

{% if is_incremental() %}

SELECT *
FROM source_orders

WHERE
    ORDER_UPDATED_AT > (
        SELECT MAX(ORDER_UPDATED_AT)
        FROM {{ this }}
    )

    OR

    PRODUCT_UPDATED_AT > (
        SELECT MAX(PRODUCT_UPDATED_AT)
        FROM {{ this }}
    )

{% else %}

SELECT *
FROM source_orders

{% endif %}