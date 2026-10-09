
{{
    config(
        materialized='table',
        alias='EMP_GT_TBL',

        pre_hook=[
            "USE WAREHOUSE SNOWFLAKE_LEARNING_WH"
        ],

        post_hook=[
            "GRANT SELECT ON TABLE {{ this }} TO ROLE SYSADMIN_EMP"
        ]
    )
}}

SELECT
    EMP_ID,
    EMP_NAME,
    DEPARTMENT,
    SALARY
FROM DEV.RAW_DATA.EMP_SOURCE