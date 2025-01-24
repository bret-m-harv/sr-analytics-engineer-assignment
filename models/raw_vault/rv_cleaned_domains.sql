-- Consolidates domain metadata from raw staging
with

domain_details as (
    select
        urn as domain_urn,
        entity_details->>'name'        as domain_name,
        entity_details->>'description' as domain_description,
        entity_created_at              as domain_created_at,
        entity_created_by              as domain_created_by
    from {{ ref('stg_datahub_entities') }}
    where entity_type = 'domain'
)

select distinct
    domain_urn,
    domain_name,
    domain_description,
    domain_created_at,
    domain_created_by
from domain_details
