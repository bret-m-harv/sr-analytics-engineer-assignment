-- The hub_entities model is a hub that stores the natural key of the entity.
with

src as (
    select
        entity_urn as entity_nk
    from {{ ref('rv_cleaned_entities') }}
),

hashes as (
    select
        entity_nk,
        {{ dbt_utils.generate_surrogate_key(['entity_nk']) }} as entity_hk
    from src
)

select
    entity_hk,
    entity_nk,
    current_localtimestamp() as load_date,
    'datahub_entities_raw' as record_source
from hashes
