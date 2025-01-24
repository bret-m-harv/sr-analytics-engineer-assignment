/*

Questions to Answer:

- Who has been assigned as owners to dashboards and/or datasets?
- How many dashboards and/or datasets do they own?
- What is their job title?

*/

select 
    -- Extract the entity type, username, and title from the JSON structure
    a.entity_type,
    json_extract_string(b.entity_details, '$.username') as username,
    json_extract_string(b.entity_details, '$.title') as title,
    count(distinct a.urn) as cnt
from
    stg_datahub_entities a,
    unnest(json_extract(owners, '$.owners')::json[]) c(owner_urn)
left outer join 
    stg_datahub_entities b
    on json_extract_string(c.owner_urn, '$.owner') = b.urn
group by 1, 2, 3
order by username asc, cnt desc
;


/*

Query Output:

┌─────────────┬───────────────────────┬─────────────────────────┬───────┐
│ entity_type │       username        │          title          │  cnt  │
│   varchar   │        varchar        │         varchar         │ int64 │
├─────────────┼───────────────────────┼─────────────────────────┼───────┤
│ dataset     │ chris@longtail.com    │ Data Engineer           │   218 │
│ dataset     │ eddie@longtail.com    │ Analyst                 │   360 │
│ dataset     │ melina@longtail.com   │ Analyst                 │    24 │
│ dashboard   │ mitch@longtail.com    │ Software Engineer       │    21 │
│ dataset     │ mitch@longtail.com    │ Software Engineer       │    97 │
│ dataset     │ phillipe@longtail.com │ Fulfillment Coordinator │    96 │
│ dataset     │ roselia@longtail.com  │ Analyst                 │    73 │
│ dataset     │ shannon@longtail.com  │ Analytics Engineer      │   300 │
│ dataset     │ terrance@longtail.com │ Fulfillment Coordinator │    32 │
└─────────────┴───────────────────────┴─────────────────────────┴───────┘

New Query Output: cnt desc

┌─────────────┬───────────────────────┬─────────────────────────┬───────┐
│ entity_type │       username        │          title          │  cnt  │
│   varchar   │        varchar        │         varchar         │ int64 │
├─────────────┼───────────────────────┼─────────────────────────┼───────┤
│ dataset     │ eddie@longtail.com    │ Analyst                 │   360 │
│ dataset     │ shannon@longtail.com  │ Analytics Engineer      │   300 │
│ dataset     │ chris@longtail.com    │ Data Engineer           │   218 │
│ dataset     │ mitch@longtail.com    │ Software Engineer       │    97 │
│ dataset     │ phillipe@longtail.com │ Fulfillment Coordinator │    96 │
│ dataset     │ roselia@longtail.com  │ Analyst                 │    73 │
│ dataset     │ terrance@longtail.com │ Fulfillment Coordinator │    32 │
│ dataset     │ melina@longtail.com   │ Analyst                 │    24 │
│ dashboard   │ mitch@longtail.com    │ Software Engineer       │    21 │
└─────────────┴───────────────────────┴─────────────────────────┴───────┘

Optional: order by username asc, cnt desc (easier to show mitch owns both datasets and dashboards)

┌─────────────┬───────────────────────┬─────────────────────────┬───────┐
│ entity_type │       username        │          title          │  cnt  │
│   varchar   │        varchar        │         varchar         │ int64 │
├─────────────┼───────────────────────┼─────────────────────────┼───────┤
│ dataset     │ chris@longtail.com    │ Data Engineer           │   218 │
│ dataset     │ eddie@longtail.com    │ Analyst                 │   360 │
│ dataset     │ melina@longtail.com   │ Analyst                 │    24 │
│ dataset     │ mitch@longtail.com    │ Software Engineer       │    97 │
│ dashboard   │ mitch@longtail.com    │ Software Engineer       │    21 │
│ dataset     │ phillipe@longtail.com │ Fulfillment Coordinator │    96 │
│ dataset     │ roselia@longtail.com  │ Analyst                 │    73 │
│ dataset     │ shannon@longtail.com  │ Analytics Engineer      │   300 │
│ dataset     │ terrance@longtail.com │ Fulfillment Coordinator │    32 │
└─────────────┴───────────────────────┴─────────────────────────┴───────┘

*/