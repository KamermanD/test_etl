{{ config(materialized='incremental', unique_key='customer_id') }}

select
    customer_id,
    customer_uuid,
    full_name,
    birth_date,
    email,
    phone,
    city,
    created_at,
    updated_at,
    is_deleted,
    now() as loaded_at
from {{ ref('stg_customer') }}

{% if is_incremental() %}
  where updated_at > (select max(loaded_at) from {{ this }})
{% endif %}
