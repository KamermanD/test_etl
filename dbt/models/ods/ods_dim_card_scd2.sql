{{ config(materialized='snapshot') }}

{% snapshot ods_dim_card_scd2 %}
    {{
        config(
            target_schema='ods',
            target_table='ods_dim_card_scd2',
            unique_key='card_id',
            strategy='check',
            check_cols=['status','closed_at']
        )
    }}

select
    card_id,
    card_number,
    account_id,
    status,
    opened_at,
    closed_at,
    is_deleted,
    loaded_at
from {{ ref('raw_card') }}

{% endsnapshot %}
