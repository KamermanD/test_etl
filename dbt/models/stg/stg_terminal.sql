{{ config(materialized='view') }}

with source as (
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
        is_deleted
    from {{ source('postgres', 'terminal') }}
)
select * from source;
