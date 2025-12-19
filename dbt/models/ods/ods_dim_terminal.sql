{{ config(materialized='table') }}

select
    terminal_id,
    terminal_code,
    city,
    country,
    latitude,
    longitude,
    is_working,
    is_deleted,
    max(loaded_at) as loaded_at
from {{ ref('raw_terminal') }}
group by terminal_id, terminal_code, city, country, latitude, longitude, is_working, is_deleted
