{{ config(materialized='view') }}

with source as (
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
        is_deleted
    from {{ source('postgres', 'account') }}
)
select * from source;
