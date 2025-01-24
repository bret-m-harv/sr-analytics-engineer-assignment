-- Consolidates dataset/dashboard metadata and retains JSON references to domains
with

entity_details as (
    select
        urn                             as entity_urn,
        entity_type,
        entity_details->>'name'         as entity_name,
        entity_details->>'platform'     as platform,
        entity_details->>'origin'       as origin,
        domains,
        entity_created_at,
        entity_created_by
    from {{ ref('stg_datahub_entities') }}
    where entity_type IN ('dataset', 'dashboard') 
    -- focus is on dataset/dashboard for the domain usage questions.
)

select distinct
    entity_urn,
    entity_type,
    entity_name,
    platform,
    origin,
    domains,
    entity_created_at,
    entity_created_by
from entity_details
