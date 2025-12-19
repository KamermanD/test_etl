{{ config(materialized='incremental', unique_key='card_id') }}

select
    card_id,
    card_number,
    account_id,
    status,
    opened_at,
    closed_at,
    created_at,
    updated_at,
    is_deleted,
    now() as loaded_at
from {{ ref('stg_card') }}

{% if is_incremental() %}
  where updated_at > (select max(loaded_at) from {{ this }})
{% endif %}
