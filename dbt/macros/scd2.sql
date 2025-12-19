{% macro scd2_snapshot(
    unique_key,
    updated_at,
    tracked_columns
) %}
    
    {{
        config(
            unique_key=unique_key,
            strategy='check',
            check_cols=tracked_columns,
            updated_at=updated_at,
            invalidate_hard_deletes=True
        )
    }}

{% endmacro %}
