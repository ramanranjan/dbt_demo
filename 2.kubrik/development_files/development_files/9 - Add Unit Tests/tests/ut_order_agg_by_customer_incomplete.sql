{{ config(tags=['unit-test']) }}

{% call dbt_unit_testing.test('customers', 'Test that total quantity and revenue are summed as expected based on order_agg_by_customer join logic') %}
  
  {% call dbt_unit_testing.mock_ref ('stg_tech_store__customers') %}
        select
            1 as customer_id,
            'Bav Malhi' as customer_name,
            10 as city_id,
            2 as main_employee_id,
            '2024-04-22 00:00:00' as created_at,
            '2024-04-21 20:00:00' as created_at_est,
            '2024-05-22 00:00:00' as updated_at,
            '2024-04-21 20:00:00' as updated_at_est,
            true as is_active
  {% endcall %}
  
  {% call dbt_unit_testing.mock_ref ('orders') %}

    select
        1001 as order_id,
        30491 as transaction_id,
        1 as customer_id,
        'Bav Malhi' as customer_name,
        'dbt Plushie XL' as product_name,
        'Soft Toys' as category,
        42.99 as price,
        'USD' as currency,
        2 as quantity,
        -- ...

        UNION ALL

    select
        1002 as order_id,
        30492 as transaction_id,
        1 as customer_id,
        'Bav Malhi' as customer_name,
        'Extra Strength Strepsils' as product_name,
        'Pharmacy' as category,
        6.49 as price,
        'USD' as currency,
        8 as quantity,
        -- ...


  {% endcall %}

  {% call dbt_unit_testing.expect() %}

      select
            -- ... Make sure to understand the expected output: Where are we looking for this?

  {% endcall %}
{% endcall %}