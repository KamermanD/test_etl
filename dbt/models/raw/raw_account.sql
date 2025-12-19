{{ config(materialized='incremental', unique_key='account_id') }}

select
    account_id,
    account_number,
    customer_id,
    currency_code,
    opened_at,
    closed_at,
    status,
    daily_transfer_limit,
    created_at,
    updated_at,
    is_deleted,
    now() as loaded_at
from {{ ref('stg_account') }}

{% if is_incremental() %}
  where updated_at > (select max(loaded_at) from {{ this }})
{% endif %}
