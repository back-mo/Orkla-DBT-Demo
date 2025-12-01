
{% macro unfold_json_list_object(source_obj, table_path, path_to_list, json_prefix) %}
   
    {%- set json_content = run_query("SELECT content FROM " ~ source(source_obj, table_path) ) -%}
    {%- set statement_list = [] -%}
    {%- set return_statement = '' -%}
    {%- set key_list = [] -%}
    {%- set json_ns = namespace(j_content={}) -%}

    {%- set path_element_list = path_to_list.split('.') -%}

    {%- if execute -%}
    {# Return the first column #}
        {%- set content = json_content.columns[0].values() -%}
        {%- set parsed_json = fromjson(content[0]) -%}
        {%- set json_ns.j_content = parsed_json -%}
        {%- for key in path_element_list -%}
            {%- if key|int(-1) != -1 -%}
                {%- set key = key|int -%}
            {%- endif -%}
            {%- set json_ns.j_content = json_ns.j_content[key] -%}
        {%- endfor -%}
        {%- do log('The json content has now been parsed', info=True) -%}
    {%- endif -%}

    {%- set ns = namespace(prefix='') -%}

    {%- for key, value in json_ns.j_content.items() recursive -%}
        {%- if value is sameas true or value is sameas false -%}
            {%- do statement_list.append(json_prefix ~ '.' ~ ns.prefix + key ~ ' AS ' + ns.prefix|replace('.','_') +key) -%}
        {%- elif value is string -%}
            {%- do statement_list.append(json_prefix ~ '.' ~ ns.prefix + key ~ ' AS ' + ns.prefix|replace('.','_') +key) -%}
        {%- elif value is number -%}
            {%- do statement_list.append(json_prefix ~ '.' ~ ns.prefix + key ~ ' AS ' + ns.prefix|replace('.','_') +key) -%}
        {%- elif value is iterable and value is not string and value is not mapping -%}
            {%- do statement_list.append(json_prefix ~ '.' ~ ns.prefix + key ~ ' AS ' + ns.prefix|replace('.','_') +key) -%}
        {%- else -%}
            {%- set ns.prefix = ns.prefix + key + '.' -%}
            {{loop(value.items())}}
            {%- set test = ns.prefix.split('.') -%}
            {%- if test|length >= 3 %}
                {%- set ns.prefix = test[test|length - 3] + '.' -%}
            {%- else -%}
                {%- set ns.prefix = '' -%}
            {%- endif -%}
        {%- endif -%}
        {%- endfor -%}
    

   
    {%- set return_statement = statement_list|join(',\n') -%}
    {%- do log(return_statement, info=True) -%}
    {{return_statement}}
{% endmacro %}







