-- Select User List
SELECT 
    tx_user_management.username AS username,
    tx_user_management.email AS email,
    tx_user_management.employee_name AS employe_name,
    tm_regional.regional_name AS regional_name,
    tm_cluster.cluster_name AS cluster_name,
    tm_area.area_name AS area_name
FROM 
    tx_user_management
JOIN 
    tm_regional ON tx_user_management.regional_id = tm_regional.regional_id
JOIN 
    tm_cluster ON tx_user_management.cluster_id = tm_cluster.cluster_id
JOIN 
    tm_area ON tx_user_management.area_id = tm_area.area_id;

-- Select Absent
select a.absendate, a.userid, b.timein ,c.timeout,d.username, d.area_id, d.regional_id, d.network_service_name,d.cluster_name,d.rtp from wfm_schema.tx_absen a 
left join 
(select absendate, userid, min(absentime) timein from wfm_schema.tx_absen where absentype=true group by userid, absendate) b
on a.userid=b.userid and a.absendate=b.absendate
left join
(select absendate, userid, max(absentime) timeout from wfm_schema.tx_absen where absentype=false group by userid, absendate) c
on a.userid=c.userid and a.absendate=c.absendate
left join
(select a.ref_user_id,a.username, a.area_id, a.regional_id, a.ns_id,b.network_service_name,a.cluster_id,c.cluster_name,a.rtp from wfm_schema.tx_user_management a
left join wfm_schema.tm_network_service b on a.ns_id = b.network_service_id
left join wfm_schema.tm_cluster c on a.cluster_id = c.cluster_id
where a.is_active=true) d
on a.userid= d.ref_user_id
group by a.absendate, a.userid, b.timein, c.timeout, d.username,d.area_id, d.regional_id, d.network_service_name,d.cluster_name,d.rtp order by a.absendate desc;
