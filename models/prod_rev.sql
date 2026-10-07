{{ config(
    materialized='table',
    alias='revenue_tbl_permanent',
    transient=false
) }}

SELECT name,sum(price*units_sold) as revenue
from RAW_DATA.products p inner join RAW_DATA.sales s
on p.prod_id=s.PROD_ID
group by name