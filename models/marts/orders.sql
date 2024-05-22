WITH

ORDERS AS (

    SELECT * FROM {{ ref('stg_tech_store__orders') }}

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
