/*

Questions to Answer:

- Which Domain is most commonly applied to datasets and/or dashboards?
- How many datasets and/or dashboards is that Domain applied to?
- What is the description of that Domain?

*/

select
  -- entity_with_domains.entity_type
  -- , trim(both '"' from domain_flat.domain_urn) as domain_urn
  json_extract_string(domain_details.entity_details, '$.name') as domain_name
  , json_extract_string(domain_details.entity_details, '$.description') as domain_description
  , count(distinct entity_with_domains.urn) as entity_count
from
  stg_datahub_entities as entity_with_domains,
  unnest(json_extract_string(entity_with_domains.domains, '$.domains')::string[]) as domain_flat(domain_urn)
left join
  stg_datahub_entities as domain_details
  on trim(both '"' from domain_flat.domain_urn) = domain_details.urn
where
  entity_with_domains.domains is not null
group by 1, 2
order by 2 desc
limit 1
;


/*

Query Output:

┌─────────────┬────────────────────────────────────────────────────────────────────────────────────────────────┬──────────────┐
│ domain_name │                                       domain_description                                       │ entity_count │
│   varchar   │                                            varchar                                             │    int64     │
├─────────────┼────────────────────────────────────────────────────────────────────────────────────────────────┼──────────────┤
│ E-Commerce  │ The E-Commerce Data Domain within Datahub provides access to datasets related to online reta…  │           65 │
└─────────────┴────────────────────────────────────────────────────────────────────────────────────────────────┴──────────────┘

*/