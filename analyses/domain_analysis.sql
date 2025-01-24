/*

Questions to Answer:

- Which Domain is most commonly applied to datasets and/or dashboards?
- How many datasets and/or dashboards is that Domain applied to?
- What is the description of that Domain?

*/

select
  -- extract the domain name and description from the domain_details json structure
  json_extract_string(domain_details.entity_details, '$.name') as domain_name,
  json_extract_string(domain_details.entity_details, '$.description') as domain_description,
  count(distinct entity_with_domains.urn) as entity_count
from
  stg_datahub_entities as entity_with_domains,
  unnest(json_extract_string(entity_with_domains.domains, '$.domains')::string[]) as domain_flat(domain_urn)
left join
  stg_datahub_entities as domain_details
  on trim(both '"' from domain_flat.domain_urn) = domain_details.urn
where
  entity_with_domains.domains is not null
group by 1, 2
order by entity_count desc
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


New Query Output:

┌─────────────┬────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┬──────────────┐
│ domain_name │                                                 domain_description                                                 │ entity_count │
│   varchar   │                                                      varchar                                                       │    int64     │
├─────────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼──────────────┤
│ Finance     │ All data entities required for the Finance team to generate and maintain revenue forecasts and relevant reporting. │          285 │
└─────────────┴────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴──────────────┘

*/