-- Shows how many times each domain is applied to datasets/dashboards, along with domain descriptions
with

domain_entity_counts as (
    select
        d.domain_hk,
        sd.domain_name,
        sd.domain_description,
        count(distinct e.entity_hk) as entity_count
    from {{ ref('lnk_domains_entities') }} l
    join {{ ref('hub_domains') }} d
        on d.domain_hk = l.domain_hk
    join {{ ref('sat_domains') }} sd
        on sd.domain_hk = d.domain_hk
    join {{ ref('hub_entities') }} e
        on e.entity_hk = l.entity_hk
    join {{ ref('sat_entities') }} se
        on se.entity_hk = e.entity_hk
    where se.entity_type in ('dataset','dashboard')
    group by
        d.domain_hk,
        sd.domain_name,
        sd.domain_description
)

select
    domain_hk,
    domain_name,
    domain_description,
    entity_count as total_entities,
    rank() over (order by entity_count desc) as usage_rank
from domain_entity_counts
