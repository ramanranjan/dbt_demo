WITH

CUSTOMERS AS (

    SELECT * FROM {{ ref('stg_tech_store__customers') }}

),

ORDERS AS (

    SELECT * FROM {{ ref('orders') }}

),

TOTAL_REVENUE_AND_UNITS_BY_CUSTOMER AS (

    SELECT
        CUSTOMERS.CUSTOMER_ID,
        SUM(ORDERS.AMOUNT_IN_USD) AS TOTAL_REVENUE_IN_USD,
        SUM(ORDERS.QUANTITY) AS TOTAL_QUANTITY

    FROM ORDERS

    LEFT JOIN CUSTOMERS
        ON ORDERS.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID

    GROUP BY 1

)

SELECT * FROM TOTAL_REVENUE_AND_UNITS_BY_CUSTOMER
