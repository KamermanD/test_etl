-- CUSTOMER (тип 1)
CREATE TABLE IF NOT EXISTS bank_dwh.raw_customer
(
    customer_id UInt64,
    full_name String,
    birth_date Date,
    city String,
    created_at DateTime,
    updated_at DateTime,
    _loaded_at DateTime DEFAULT now()
)
ENGINE = MergeTree
ORDER BY (customer_id, updated_at);

-- ACCOUNT (SCD2)
CREATE TABLE IF NOT EXISTS bank_dwh.raw_account
(
    account_id UInt64,
    customer_id UInt64,
    status String,
    city String,
    opened_at DateTime,
    closed_at Nullable(DateTime),
    updated_at DateTime,
    _valid_from DateTime,
    _valid_to Nullable(DateTime),
    _is_current UInt8
)
ENGINE = ReplacingMergeTree(updated_at)
ORDER BY (account_id, _valid_from);

-- CARD (SCD2)
CREATE TABLE IF NOT EXISTS bank_dwh.raw_card
(
    card_id UInt64,
    account_id UInt64,
    card_type String,
    status String,
    issued_at DateTime,
    expired_at Date,
    updated_at DateTime,
    _valid_from DateTime,
    _valid_to Nullable(DateTime),
    _is_current UInt8
)
ENGINE = ReplacingMergeTree(updated_at)
ORDER BY (card_id, _valid_from);

-- TERMINAL
CREATE TABLE IF NOT EXISTS bank_dwh.raw_terminal
(
    terminal_id UInt64,
    city String,
    terminal_type String,
    installed_at DateTime,
    _loaded_at DateTime DEFAULT now()
)
ENGINE = MergeTree
ORDER BY terminal_id;

-- TRANSACTION (FACT)
CREATE TABLE IF NOT EXISTS bank_dwh.raw_transaction
(
    transaction_id UInt64,
    card_id UInt64,
    terminal_id UInt64,
    txn_type String,
    amount Decimal(18,2),
    currency String,
    txn_ts DateTime,
    status String,
    _loaded_at DateTime DEFAULT now()
)
ENGINE = MergeTree
ORDER BY transaction_id;
