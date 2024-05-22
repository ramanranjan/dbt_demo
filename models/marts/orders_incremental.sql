{{

    config
    (
        materialized = 'incremental',
        unique_key = 'order_id'
    )
}}

-- REQUIREMENT MUST BE MET:
-- 1. Cannot trigger as a full refresh
-- 2. Model must already exist
-- 3. Tables in db must already exist
-- 4. Materialized set to 'incremental'

WITH

ORDERS AS (

    SELECT * FROM {{ ref('stg_tech_store__orders') }}

    {% if  is_incremental() %}

        WHERE
            CREATED_AT >=
            (
                COALESCE((SELECT MAX(CREATED_AT) FROM {{ this }}), '1900-01-01')
            )

    {% endif%}

),

TRANSACTIONS AS (

    SELECT * FROM {{ ref('stg_payment_app__transactions') }}

),

PRODUCTS AS (

    SELECT * FROM {{ ref('stg_tech_store__products') }}

),

CUSTOMERS AS (

    SELECT * FROM {{ ref('stg_tech_store__customers') }}

),


FINAL AS (

    SELECT
        ORDERS.ORDER_ID,
        TRANSACTIONS.TRANSACTION_ID,
        CUSTOMERS.CUSTOMER_ID,
        CUSTOMERS.CUSTOMER_NAME,
        PRODUCTS.PRODUCT_NAME,
        PRODUCTS.CATEGORY,
        PRODUCTS.PRICE,
        PRODUCTS.CURRENCY,
        ORDERS.QUANTITY,
        TRANSACTIONS.COST_PER_UNIT_IN_USD,
        TRANSACTIONS.AMOUNT_IN_USD,
        TRANSACTIONS.TAX_IN_USD,
        TRANSACTIONS.TOTAL_CHARGED_IN_USD,
        ORDERS.CREATED_AT,
        {{ utc_to_est('orders.created_at') }} AS CREATED_AT_EST,
        {{ usd_to_gbp('transactions.amount_in_usd') }} AS AMOUNT_IN_GBP

    FROM ORDERS

    LEFT JOIN TRANSACTIONS
        ON ORDERS.ORDER_ID = TRANSACTIONS.ORDER_ID

    LEFT JOIN PRODUCTS
        ON ORDERS.PRODUCT_ID = PRODUCTS.PRODUCT_ID

    LEFT JOIN CUSTOMERS
        ON ORDERS.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID

)

SELECT * FROM FINAL
