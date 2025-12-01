
{% macro generate_meta_columns(data_source) %}
    dw_date_loaded AS current_timestamp(),
    dw_source AS '{{data_source}}',
    dw_date_updated AS NULL,
{% endmacro %}