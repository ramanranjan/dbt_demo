WITH
CUSTOMERS AS (

    SELECT * FROM {{ ref('stg_tech_store__customers') }}

),

CUSTOMERS_AND_LOCATIONS_JOINED AS (

    SELECT * FROM {{ ref('int_customers_and_locations_joined') }}

),

EMPLOYEES AS (

    SELECT * FROM {{ ref('stg_tech_store__employees') }}

),

ORDER_AMOUNTS_BY_CUSTOMER AS (

    SELECT * FROM {{ ref('int_order_amounts_agg_by_customer') }}

),

FINAL AS (

    SELECT
        CUSTOMERS.CUSTOMER_ID,
        CUSTOMERS.CUSTOMER_NAME,
        CUSTOMERS_AND_LOCATIONS_JOINED.CITY_NAME,
        CUSTOMERS_AND_LOCATIONS_JOINED.STATE_NAME,
        CUSTOMERS_AND_LOCATIONS_JOINED.ZIP_CODE,
        EMPLOYEES.FULL_NAME AS MAIN_EMPLOYEE,
        EMPLOYEES.IS_ACTIVE AS MAIN_EMPLOYEE_IS_ACTIVE,
        COALESCE(ORDER_AMOUNTS_BY_CUSTOMER.TOTAL_REVENUE_IN_USD, 0)
            AS TOTAL_REVENUE_IN_USD,
        COALESCE(ORDER_AMOUNTS_BY_CUSTOMER.TOTAL_QUANTITY, 0) AS TOTAL_QUANTITY,
        CUSTOMERS.CREATED_AT,

        {{ utc_to_est('customers.created_at') }} AS CREATED_AT_EST,

        CUSTOMERS.UPDATED_AT,
        {{ utc_to_est('customers.updated_at') }} AS UPDATED_AT_EST,

        CUSTOMERS.IS_ACTIVE

    FROM CUSTOMERS

    LEFT JOIN CUSTOMERS_AND_LOCATIONS_JOINED
        ON CUSTOMERS.CUSTOMER_ID = CUSTOMERS_AND_LOCATIONS_JOINED.CUSTOMER_ID

    LEFT JOIN EMPLOYEES
        ON CUSTOMERS.MAIN_EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID

    LEFT JOIN ORDER_AMOUNTS_BY_CUSTOMER
        ON CUSTOMERS.CUSTOMER_ID = ORDER_AMOUNTS_BY_CUSTOMER.CUSTOMER_ID

)

SELECT * FROM FINAL
