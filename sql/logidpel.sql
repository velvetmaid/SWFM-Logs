select *  from wfm_schema.tx_site ts 
where site_id in ('EPC006', 'EPC008')

select * from wfm_schema.tm_regional tr 
where regional_id = 'R06'

select * from wfm_schema.tm_nop tn 
where nop_id = 'NOP56'

select * from wfm_schema.tm_cluster
where cluster_id = 537

select site_id, site_name, regional_id from wfm_schema.tx_site ts 
where site_name like '%SGE%'

select * from wfm_schema.tm_catalog tc 
where regional_id = 'R06'

select * from wfm_schema.tm_cluster
where cluster_id = 537

select * from wfm_schema.tm_power_pln_pelanggan_ipas tpppi 
where idpel = '143005729475'

select * from wfm_schema.tx_site ts 
where site_id in ('MQG003',
'MQG004',
'MQG006',
'MQG008',
'MQJ003',
'MXJ037',
'MXL002',
'MXN012',
'MXN020',
'MXO037',
'MXO039',
'MXO042',
'MXO048',
'MXO050',
'MXO058',
'MXO059',
'MXO060',
'MXO061',
'MXS045',
'MXS047',
'MXS048',
'MXT046',
'MXT048',
'MXU043',
'MXU045',
'MXU046',
'MXU047',
'MXU048',
'MXU050',
'MXU051',
'MXV001',
'MXV006',
'MXV007',
'MXW048',
'MXW075',
'MXW076',
'MXW078',
'MXW079',
'MXW090',
'MXW091',
'MXW097',
'MXW098',
'MXW099',
'MXW105',
'MXW112',
'MXW114',
'MXW115',
'MXW120',
'MXW124',
'MXW125',
'MXW130',
'MXW131',
'MXW132',
'MXW133',
'MXX122',
'MXX127',
'MXX132',
'MXY002',
'MXY003',
'MXY004',
'MXY005',
'MXY006',
'MXY007',
'MXY008',
'MXY009',
'UQH813',
'UXX123',
'UXX126',
'UXX134',
'MXO034')


select * from wfm_schema.tx_pengisian_token_listrik_header
where id_pelanggan = '311900396304'

select * from wfm_schema.tx_pengisian_token_listrik
where id_pelanggan = '311900396304'

where ref_ticket_no = 'PTL202408-409000000000107'


select * from wfm_schema.tx_pengisian_token_listrik tptl 
where id_pelanggan in ('124110247317',
'133323095736',
'133323095751',
'133353594260',
'133380080743',
'231411389775',
'235300071512',
'311900396304',
'312400565536',
'312400597106',
'312400657770',
'312700346118',
'315200316893',
'316104129269',
'317500407234',
'319300159875',
'319300341331',
'319400094710',
'323300795134',
'323600572106',
'325400916212',
'328300569586',
'329100418836',
'329100422130',
'329100711809',
'329100715690',
'329400453007',
'329400453023',
'329400453829',
'329400640487',
'329600194408',
'411420394345',
'411420394352',
'411600325433',
'411600325474',
'411600343053',
'411600343061',
'411890060698',
'412301476513',
'412301478214',
'412910023233',
'412910049873',
'412920037831',
'412920053701',
'412920053701',
'413100628426',
'413200032146',
'413200032431',
'413200036846',
'414100116852',
'415300120583',
'416100088276',
'416100115830',
'416200011051',
'416200042441',
'417200035343',
'423100494167',
'424200134643',
'425100246874',
'431600252609',
'431600252682',
'431600252690',
'431600414790',
'431600414803',
'431600414811',
'435000609640',
'435000647754',
'437600527999',
'437600549663',
'442400353964',
'443300417185')

select count(*) FROM wfm_admin_schema.tx_eventlog
where process_name = 'PTL' and "comment" = 'RECEIVE BY IPAS'

select * from wfm_schema.tx_user_management tum 
where tx_user_management_id = 104

select * from wfm_schema.tx_site ts 
where is_site_sam = true

select * from wfm_schema.tx_site ts 
where site_id = 'MXS047'

select * from wfm_schema.tx_site
where
    site_id in (
        'MQG003',
        'MQG004',
        'MQG006',
        'MQG008',
        'MQJ003',
        'MXJ037',
        'MXL002',
        'MXN012',
        'MXN020',
        'MXO037',
        'MXO039',
        'MXO042',
        'MXO048',
        'MXO050',
        'MXO058',
        'MXO059',
        'MXO060',
        'MXO061',
        'MXS045',
        'MXS047',
        'MXS048',
        'MXT046',
        'MXT048',
        'MXU043',
        'MXU045',
        'MXU046',
        'MXU047',
        'MXU048',
        'MXU050',
        'MXU051',
        'MXV001',
        'MXV006',
        'MXV007',
        'MXW048',
        'MXW075',
        'MXW076',
        'MXW078',
        'MXW079',
        'MXW090',
        'MXW091',
        'MXW097',
        'MXW098',
        'MXW099',
        'MXW105',
        'MXW112',
        'MXW114',
        'MXW115',
        'MXW120',
        'MXW124',
        'MXW125',
        'MXW130',
        'MXW131',
        'MXW132',
        'MXW133',
        'MXX122',
        'MXX127',
        'MXX132',
        'MXY002',
        'MXY003',
        'MXY004',
        'MXY005',
        'MXY006',
        'MXY007',
        'MXY008',
        'MXY009',
        'UQH813',
        'UXX123',
        'UXX126',
        'UXX134',
        'MXO034',
        'MXS049',
        'MXT006',
        'MXU049',
        'MXU053',
        'MXV009',
        'MXW005',
        'MXW019',
        'MXW067',
        'MXW108',
        'UXW108',
        'UYP141',
        'UQH817',
        'MXW129',
        'MXX121'
    )

    


