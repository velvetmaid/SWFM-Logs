select
    *
from
    wfm_schema.tx_user_mobile_management tum
where
    cluster_id = cluster_id
    and(
        nop_id is null
        or nop_id = ''
    )
    and (
        cluster_id is not null
        and cluster_id <> 0
    );

select
    *
from
    wfm_schema.tm_mapping_cluster_nop tmcn;

-- update user nop
update
    wfm_schema.tx_user_management b
set
    nop_id = a.nop_id
from
    wfm_schema.tm_mapping_cluster_nop a
where
    b.cluster_id = a.cluster_id
    and(
        b.nop_id is null
        or b.nop_id = ''
    )
    and (
        b.cluster_id is not null
        and b.cluster_id <> 0
    );

select
    *
from
    wfm_schema.tm_mapping_cluster_nop tmcn
where
    cluster_id = 438;

select
    b.nop_id,
    b.cluster_id a.nop_id,
    a.cluster_id
from
    wfm_schema.tx_user_mobile_management a
    inner join wfm_schema.tm_mapping_cluster_nop b on a.cluster_id = b.cluster_id
where
    (
        a.nop_id is null
        or a.nop_id = ''
    )
    and (
        a.cluster_id is not null
        and a.cluster_id <> 0
    )