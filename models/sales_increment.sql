{{ config(
    materialized='incremental',
    alias='sales_incremental',
    unique_key='order_id',
    transient=false
) }}

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.quantity,
    p.price * o.quantity AS amount
FROM RAW_DATA.orders o
LEFT JOIN RAW_DATA.products_tbl p
    ON o.product_id = p.prod_id

{% if is_incremental() %}
  and o.order_date > (SELECT MAX(order_date) FROM {{ this }})
{% endif %}
