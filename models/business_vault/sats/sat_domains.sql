-- Stores descriptive attributes for each domain (domain name, description, created by)
with

src as (
    select
        domain_urn,
        domain_name,
        domain_description,
        domain_created_at,
        domain_created_by
    from {{ ref('rv_cleaned_domains') }}
),

join_hub as (
    select
        h.domain_hk,
        s.domain_urn,
        s.domain_name,
        s.domain_description,
        s.domain_created_at,
        s.domain_created_by,
        h.record_source
    from src s
    join {{ ref('hub_domains') }} h
      on h.domain_nk = s.domain_urn
)

select
    domain_hk,
    domain_name,
    domain_description,
    domain_created_at,
    domain_created_by,
    current_localtimestamp() as load_date,
    record_source
from join_hub
