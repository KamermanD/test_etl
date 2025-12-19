{{ config(materialized='view') }}

with source as (
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
        is_deleted
    from {{ source('postgres', 'customer') }}
)
select * from source;
