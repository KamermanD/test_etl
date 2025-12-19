{{ config(materialized='incremental', unique_key='txn_id') }}

select
    txn_id,
    card_id,
    terminal_id,
    txn_ts,
    amount,
    currency_code,
    txn_type,
    status,
    now() as loaded_at
from {{ ref('stg_transaction') }}

{% if is_incremental() %}
  where txn_ts > (select max(txn_ts) from {{ this }})
{% endif %}
