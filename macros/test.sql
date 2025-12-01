
{% macro append_to_input(str, counter) %}
    {% set strr = str + str%}
    {% if counter > 2%}
        {{ return(counter) }}
    {% else%}
        {% set current_count = counter + 1%}
        {% set strr = append_to_input(strr, current_count) %}
    {%endif%}
{% endmacro %}