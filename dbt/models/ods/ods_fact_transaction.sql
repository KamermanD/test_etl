{{ config(materialized='table') }}

select
    t.txn_id,
    t.txn_ts,
    t.amount,
    t.currency_code,
    c.card_id,
    c.card_number,
    a.account_id,
    a.account_number,
    cust.customer_id,
    cust.city as customer_city,
    term.terminal_id,
    term.city as terminal_city,
    t.txn_type,
    t.status,
    t.loaded_at
from {{ ref('raw_transaction') t }}
left join {{ ref('raw_card') c }} on c.card_id = t.card_id
left join {{ ref('raw_account') a }} on a.account_id = c.account_id
left join {{ ref('raw_customer') cust }} on cust.customer_id = a.customer_id
left join {{ ref('raw_terminal') term }} on term.terminal_id = t.terminal_id
