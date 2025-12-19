{{ config(materialized='table') }}

select
    customer_id,
    customer_uuid,
    full_name,
    birth_date,
    email,
    phone,
    city,
    is_deleted,
    max(loaded_at) as loaded_at
from {{ ref('raw_customer') }}
group by customer_id, customer_uuid, full_name, birth_date, email, phone, city, is_deleted
