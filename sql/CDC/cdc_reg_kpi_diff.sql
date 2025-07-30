-- Query Site Reguler CDC:
select 
        sum(down_duration) as down_dur, sum(denum) as denum, sum(power_duration) as power_duration,
       (1 - (sum(power_duration)/ sum(denum))) *100 as avail, {inap_avail_ne_base_site_level_daily_recon}.[site_id] as site_id,
        {inap_avail_ne_base_site_level_daily_recon}.[site_class] as site_class
from {inap_avail_ne_base_site_level_daily_recon}
where {inap_avail_ne_base_site_level_daily_recon}.[site_id] IN (@SiteID)
AND {inap_avail_ne_base_site_level_daily_recon}.[month_period] IN (@DateFilter)
AND {inap_avail_ne_base_site_level_daily_recon}.[regional] IN (@Regional)
GROUP BY 
{inap_avail_ne_base_site_level_daily_recon}.[denum], {inap_avail_ne_base_site_level_daily_recon}.[site_id], 
{inap_avail_ne_base_site_level_daily_recon}.[site_class]

-- Query KPI Reguler:
SELECT 
    ((1-(sum(bh_down)/sum(denum_bh)))*avg(bh_weight)) + ((1-(sum(non_bh_down)/sum(denum_non_bh)))*avg(non_bh_weight)),
    (1-(sum(bh_down)/sum(denum_bh)))*100,
    (1-(sum(non_bh_down)/sum(denum_non_bh)))*100,
    sum(bh_down),
    sum(denum_bh),
    sum(non_bh_down),
    sum(denum_bh),
    avg(bh_weight),
    avg(non_bh_weight)
FROM {inap_avail_ne_base_site_level_daily_recon}
WHERE {inap_avail_ne_base_site_level_daily_recon}.[networksite] = @networksite
AND month_period = @month_period
AND site_class = @class

-- 
select 
        sum(down_duration) as down_dur, sum(denum) as denum, sum(power_duration) as power_duration,
       (1 - (sum(power_duration)/ sum(denum))) *100 as avail, {inap_avail_ne_base_site_level_daily_recon}.[site_id] as site_id,
        {inap_avail_ne_base_site_level_daily_recon}.[site_class] as site_class
from {inap_avail_ne_base_site_level_daily_recon}
where {inap_avail_ne_base_site_level_daily_recon}.[site_id] IN ('OKI407')
AND {inap_avail_ne_base_site_level_daily_recon}.[month_period] IN ('202507')
AND {inap_avail_ne_base_site_level_daily_recon}.[regional] IN ('R02')
GROUP BY 
{inap_avail_ne_base_site_level_daily_recon}.[denum], {inap_avail_ne_base_site_level_daily_recon}.[site_id], 
{inap_avail_ne_base_site_level_daily_recon}.[site_class]