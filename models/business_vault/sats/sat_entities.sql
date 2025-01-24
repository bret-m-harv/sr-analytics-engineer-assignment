-- Stores descriptive attributes for each entity (name, type, platform, creation info)
with

src as (
    select
        entity_urn,
        entity_type,
        entity_name,
        platform,
        origin,
        entity_created_at,
        entity_created_by
    from {{ ref('rv_cleaned_entities') }}
),

join_hub as (
    select
        h.entity_hk,
        s.entity_urn,
        s.entity_type,
        s.entity_name,
        s.platform,
        s.origin,
        s.entity_created_at,
        s.entity_created_by,
        h.record_source
    from src s
    join {{ ref('hub_entities') }} h
      on h.entity_nk = s.entity_urn
)

select
    entity_hk,
    entity_type,
    entity_name,
    platform,
    origin,
    entity_created_at,
    entity_created_by,
    current_localtimestamp() as load_date,
    record_source
from join_hub
