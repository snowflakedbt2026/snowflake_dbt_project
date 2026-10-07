{{ config(materialized='ephemeral') }}

SELECT AVG(salary) AS avg_salary
FROM RAW_DATA.employee
