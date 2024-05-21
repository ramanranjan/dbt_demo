{% macro usd_to_gbp(column_name) -%}
ROUND(1.2 * {{ column_name }},2)
{%- endmacro %}

