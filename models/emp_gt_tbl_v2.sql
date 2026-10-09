
{{
    config(
        materialized='table',
        alias='EMP_GT_TBL_V2',

        pre_hook=[
            "USE WAREHOUSE SNOWFLAKE_LEARNING_WH",
            "ALTER SESSION SET QUERY_TAG = 'DBT_EMPLOYEE_MODEL'"
        ],

        post_hook=[
            "GRANT SELECT ON TABLE {{ this }} TO ROLE SYSADMIN_EMP",
            "COMMENT ON TABLE {{ this }} IS 'Employee data created by dbt'"
        ]
    )
}}

SELECT
    EMP_ID,
    EMP_NAME,
    DEPARTMENT,
    SALARY
FROM DEV.RAW_DATA.EMP_SOURCE
