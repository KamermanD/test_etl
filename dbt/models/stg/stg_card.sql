{{ config(materialized='view') }}

with source as (
    select
        card_id,
        card_number,
        account_id,
        status,
        opened_at,
        closed_at,
        created_at,
        updated_at,
        is_deleted
    from {{ source('postgres', 'card') }}
)
select * from source;
