-- DIM CUSTOMER
CREATE TABLE IF NOT EXISTS bank_dwh.ods_dim_customer
(
    customer_id UInt64,
    full_name String,
    birth_date Date,
    city String
)
ENGINE = MergeTree
ORDER BY customer_id;

-- DIM ACCOUNT (SCD2)
CREATE TABLE IF NOT EXISTS bank_dwh.ods_dim_account
(
    account_id UInt64,
    customer_id UInt64,
    status String,
    city String,
    _valid_from DateTime,
    _valid_to Nullable(DateTime),
    _is_current UInt8
)
ENGINE = MergeTree
ORDER BY (account_id, _valid_from);

-- DIM CARD (SCD2)
CREATE TABLE IF NOT EXISTS bank_dwh.ods_dim_card
(
    card_id UInt64,
    account_id UInt64,
    status String,
    card_type String,
    _valid_from DateTime,
    _valid_to Nullable(DateTime),
    _is_current UInt8
)
ENGINE = MergeTree
ORDER BY (card_id, _valid_from);

-- DIM TERMINAL
CREATE TABLE IF NOT EXISTS bank_dwh.ods_dim_terminal
(
    terminal_id UInt64,
    city String,
    terminal_type String
)
ENGINE = MergeTree
ORDER BY terminal_id;

-- FACT TRANSACTION
CREATE TABLE IF NOT EXISTS bank_dwh.ods_fact_transaction
(
    transaction_id UInt64,
    card_id UInt64,
    terminal_id UInt64,
    txn_type String,
    amount Decimal(18,2),
    currency String,
    txn_ts DateTime,
    status String
)
ENGINE = MergeTree
ORDER BY transaction_id;
