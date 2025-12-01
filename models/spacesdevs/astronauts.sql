




{%- set test_path = 'results.0.image' -%}

{%- set test_select = unfold_json_list_object("spacedevs", "spacedevs_astronauts", test_path) -%}

SELECT 
{{ test_select }}



