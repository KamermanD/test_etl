{% snapshot snap_account %}
    {{
      config(
        target_schema='snapshots',
        target_database='bank_dwh',
        unique_key='account_id',
        strategy='check',
        check_cols=['account_number', 'status', 'daily_transfer_limit', 'closed_at']
      )
    }}

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
    from {{ ref('raw_account') }}

{% endsnapshot %}
