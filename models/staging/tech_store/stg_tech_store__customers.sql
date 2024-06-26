WITH

CUSTOMERS AS (

    SELECT * FROM {{ source('tech_store', 'customer') }}

),

FINAL AS (

    SELECT
        ID AS CUSTOMER_ID,
        NAME AS CUSTOMER_NAME,
        CITYID AS CITY_ID,
        MAINSALESREPID AS MAIN_EMPLOYEE_ID,
        CREATEDATETIME AS CREATED_AT,
        UPDATEDATETIME AS UPDATED_AT,
        ACTIVE AS IS_ACTIVE

    FROM CUSTOMERS

)

SELECT * FROM FINAL
