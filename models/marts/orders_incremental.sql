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

with

orders as (

        select * from {{ ref('stg_tech_store__orders') }}

        {% if  is_incremental() %}

         where created_at >= 
         (
                coalesce((select max(created_at) from {{ this }}),'1900-01-01') 
          )

        {% endif%}

),

transactions as (

    select * from {{ ref('stg_payment_app__transactions') }}

),

products as (

    select * from {{ ref('stg_tech_store__products') }}

),

customers as (

    select * from {{ ref('stg_tech_store__customers') }}

),


final as (

    select
        orders.order_id,
        transactions.transaction_id,
        customers.customer_id,
        customers.customer_name,
        products.product_name,
        products.category,
        products.price,
        products.currency,
        orders.quantity,        
        transactions.cost_per_unit_in_usd,
        transactions.amount_in_usd,
        transactions.tax_in_usd,
        transactions.total_charged_in_usd,
        orders.created_at,
         {{ utc_to_est('orders.created_at') }} as created_at_est,
         {{ usd_to_gbp('transactions.amount_in_usd') }} as amount_in_gbp,

    from orders

    left join transactions
        on orders.order_id = transactions.order_id

    left join products
        on orders.product_id = products.product_id

    left join customers
        on orders.customer_id = customers.customer_id

)

select * from final