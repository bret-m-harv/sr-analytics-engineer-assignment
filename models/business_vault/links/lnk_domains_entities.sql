with

raw as (
    select
        e.entity_urn,
        -- if the domains JSON might include quoted strings, strip them
        trim(both '"' from domain_flat.domain_urn) as domain_urn
    from {{ ref('rv_cleaned_entities') }} e
         -- use DuckDB's unnest approach here
         , unnest(json_extract_string(e.domains, '$.domains')::string[]) as domain_flat(domain_urn)
    where e.domains is not null
      and e.entity_type in ('dataset','dashboard') 
),

join_hk as (
    select
        hent.entity_hk,
        hdom.domain_hk
    from raw r
    -- join to the hub for entities
    join {{ ref('hub_entities') }} hent
      on hent.entity_nk = r.entity_urn
    -- join to the hub for domains
    join {{ ref('hub_domains') }} hdom
      on hdom.domain_nk = r.domain_urn
)

select
    domain_hk,
    entity_hk,
    current_localtimestamp() as load_date,
    'datahub_entities_raw' as record_source
from join_hk
