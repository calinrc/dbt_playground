-- Custom macro to overwrite default behavior; update table prefix with country information
-- https://docs.getdbt.com/docs/build/custom-aliases
{% macro generate_alias_name(custom_alias_name=none, node=none) -%}
    {%- if custom_alias_name -%}
        {%- if var("id") -%}
            {{ var("country") ~ "_" ~ custom_alias_name ~ "_" ~ var("id") | trim }}
        {%- else -%}
            {{ var("country") ~ "_" ~ custom_alias_name | trim }}
        {%- endif -%}
    {%- elif node.version -%}
        {{ return(node.name ~ "_v" ~ (node.version | replace(".", "_"))) }}
    {%- elif var("id") is none -%}
        {{ var("country") ~ "_" ~ node.name }}
    {%- else -%}
        {{ var("country") ~ "_" ~ node.name ~ "_" ~ var("id") }}
    {%- endif -%}

{%- endmacro %}
