{{ config(
    materialized = 'table',
    cluster_by = [
            'country'
        ]
) }}

{%- for country in var('countries') %}

{{ 'WITH ' if loop.first -}} source_{{ country }} AS ( -- noqa: disable=L003,L014

SELECT
    * EXCEPT (Dt_Customer),
    PARSE_DATE('%d-%m-%Y', Dt_Customer) as Dt_Customer,
    "{{ country }}" AS country,
FROM {{ source('marketing_campaign_source_%s' % country, 'mar_camp') }}

),

{% endfor -%}

union_sources AS (

    {% for country in var('countries') -%}
    SELECT * FROM source_{{ country }}
{{ 'UNION ALL' if not loop.last }}
    {% endfor %}
)

SELECT *
FROM union_sources