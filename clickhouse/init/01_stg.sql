CREATE DATABASE IF NOT EXISTS bank_dwh;

-- CUSTOMER
CREATE TABLE IF NOT EXISTS bank_dwh.stg_customer
(
    customer_id UInt64,
    full_name String,
    birth_date Date,
    city String,
    created_at DateTime,
    updated_at DateTime
)
ENGINE = MergeTree
ORDER BY customer_id;

-- ACCOUNT
CREATE TABLE IF NOT EXISTS bank_dwh.stg_account
(
    account_id UInt64,
    customer_id UInt64,
    status String,
    city String,
    opened_at DateTime,
    closed_at Nullable(DateTime),
    updated_at DateTime
)
ENGINE = MergeTree
ORDER BY account_id;

-- CARD
CREATE TABLE IF NOT EXISTS bank_dwh.stg_card
(
    card_id UInt64,
    account_id UInt64,
    card_type String,
    status String,
    issued_at DateTime,
    expired_at Date,
    updated_at DateTime
)
ENGINE = MergeTree
ORDER BY card_id;

-- TERMINAL
CREATE TABLE IF NOT EXISTS bank_dwh.stg_terminal
(
    terminal_id UInt64,
    city String,
    terminal_type String,
    installed_at DateTime
)
ENGINE = MergeTree
ORDER BY terminal_id;

-- TRANSACTION
CREATE TABLE IF NOT EXISTS bank_dwh.stg_transaction
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
