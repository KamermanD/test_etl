{{ config(materialized='view') }}

with source as (
    select
        txn_id,
        card_id,
        terminal_id,
        txn_ts,
        amount,
        currency_code,
        txn_type,
        status
    from {{ source('postgres', 'transaction') }}
)
select * from source;
