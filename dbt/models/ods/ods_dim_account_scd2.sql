{{ config(materialized='snapshot') }}

{% snapshot ods_dim_account_scd2 %}
    {{
        config(
            target_schema='ods',
            target_table='ods_dim_account_scd2',
            unique_key='account_id',
            strategy='check',
            check_cols=['status','daily_transfer_limit','closed_at']
        )
    }}

select
    account_id,
    account_number,
    customer_id,
    currency_code,
    opened_at,
    closed_at,
    status,
    daily_transfer_limit,
    is_deleted,
    loaded_at
from {{ ref('raw_account') }}

{% endsnapshot %}
