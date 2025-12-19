{% snapshot snap_card %}
    {{
      config(
        target_schema='snapshots',
        target_database='bank_dwh',
        unique_key='card_id',
        strategy='check',
        check_cols=['card_number', 'status', 'account_id']
      )
    }}

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
    from {{ ref('raw_card') }}

{% endsnapshot %}
