{{ config(materialized='incremental', unique_key='terminal_id') }}

select
    terminal_id,
    terminal_code,
    city,
    country,
    latitude,
    longitude,
    created_at,
    updated_at,
    is_working,
    is_deleted,
    now() as loaded_at
from {{ ref('stg_terminal') }}

{% if is_incremental() %}
  where updated_at > (select max(loaded_at) from {{ this }})
{% endif %}
