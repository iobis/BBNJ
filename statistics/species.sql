select
classification->>'speciesid' as id,
count(*) filter (where areas @> array[1]) as n_abnj,
count(*) as n_all
from obis.occurrence
left join obis.aphia on aphia.id = occurrence.aphia
group by classification->>'speciesid'
