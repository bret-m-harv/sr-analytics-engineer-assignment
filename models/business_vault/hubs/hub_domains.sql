-- The hub_domains model is a hub that stores the natural key of the domain.
with

src as (
    select
        domain_urn as domain_nk  -- "natural key" for the domain
    from {{ ref('rv_cleaned_domains') }}
),

hashes as (
    select
        domain_nk,
        {{ dbt_utils.generate_surrogate_key(['domain_nk']) }} as domain_hk
    from src
)

select
    domain_hk,
    domain_nk,
    current_localtimestamp() as load_date,
    'datahub_entities_raw' as record_source
from hashes
