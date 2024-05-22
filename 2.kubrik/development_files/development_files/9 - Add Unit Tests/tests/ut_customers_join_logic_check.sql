{{ config(tags=['unit-test']) }}

{% call dbt_unit_testing.test('customers', 'Check join logic and select statement layout for customers expected output') %}
  
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
  
  {% call dbt_unit_testing.mock_ref ('int_customers_and_locations_joined') %}
    select
        1 as customer_id,
        'New York' as city_name,
        'New York' as state_name,
        10039 as zip_code

        UNION ALL

        1 as customer_id,
        'Boston' as city_name,
        'Massachusetts' as state_name,
        02301 as zip_code
  {% endcall %}
  
  {% call dbt_unit_testing.mock_ref ('stg_tech_store__employees') %}
    select
        2 as employee_id,
        'Arran' as first_name,
        'Bayliss-Chalmers' as last_name,
        'Arran Bayliss-Chalmers' as full_name,
        '2018-11-05' as hired_at,
        '9999-01-01' as terminated_at,
        true as is_active
  {% endcall %}

  {% call dbt_unit_testing.mock_ref ('int_order_amounts_agg_by_customer') %}
    select
        1 as customer_id,
        20000 as total_revenue_in_usd,
        42 as total_quantity
  {% endcall %}

  {% call dbt_unit_testing.expect() %}
        select
        1 as customer_id,
        'Bav Malhi' as customer_name,
        'New York' as city_name,
        'New York' as state_name,
        10039 as zip_code,
        'Arran Bayliss-Chalmers' as main_employee,
        true as main_employee_is_active,
        20000 as total_revenue_in_usd,
        42 as total_quantity,
        '2024-04-22 00:00:00' as created_at,
        '2024-04-21 20:00:00' as created_at_est,
        '2024-05-22 00:00:00' as updated_at,
        '2024-04-21 20:00:00' as updated_at_est,
        true as is_active

        UNION ALL

        select
        1 as customer_id,
        'Bav Malhi' as customer_name,
        'Boston' as city_name,
        'Massachusetts' as state_name,
        02301 as zip_code,
        'Arran Bayliss-Chalmers' as main_employee,
        true as main_employee_is_active,
        20000 as total_revenue_in_usd,
        42 as total_quantity,
        '2024-04-22 00:00:00' as created_at,
        '2024-04-21 20:00:00' as created_at_est,
        '2024-05-22 00:00:00' as updated_at,
        '2024-04-21 20:00:00' as updated_at_est,
        true as is_active
  {% endcall %}
{% endcall %}