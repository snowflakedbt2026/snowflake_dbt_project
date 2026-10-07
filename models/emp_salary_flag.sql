
{{ config(materialized='table',alias='employee_tbl') }}


SELECT
    e.emp_id,
    e.emp_name,
    e.department,
    e.salary,
    CASE
        WHEN e.salary > (
            SELECT avg_salary
            FROM {{ ref('emp_avg') }}
        )
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_flag
FROM RAW_DATA.employee e
