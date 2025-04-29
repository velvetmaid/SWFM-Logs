select * from wfm_uso_schema.wf_activity wa 
order by id 

select * from wfm_uso_schema.wf_activity_action waa 
order by activityid 

select * from wfm_uso_schema.wf_activity_outcome wao 
order by activityid, id

select * from wfm_uso_schema.wf_activity_role war 
order by activityid, id

select * from wfm_uso_schema.wf_activity_rule war 

select * from wfm_uso_schema.tm_user_role tur 

select * from wfm_uso_schema.wf_activity wa 
left join wfm_uso_schema.tm_module tm 
on wa.moduleid = tm.id 
where tm.code = 'ASG' and wa.currentstatus = ''

select * from wfm_uso_schema.tm_module tm 

