

select
r.CONSTITUENT_ID,
r.IMPORT_ID, 
r.DATE_LAST_CHANGED,
--r.ID,
ISNULL(r.org_name, r.first_name + ' '+ r.last_name) as constit_name,
r.KEY_INDICATOR,


pp.classification,
pp.status,
'PSC' + '-' + replace(convert(nvarchar(MAX), GETDATE(), 110),'-','')+'-' +  CAST(ROW_NUMBER() over (order by r.id) as varchar)  as new_action_import_ID,
'Task/Other' as new_action_category,
'Prospect Status Change' as new_action_type,
--pp.status as new_action_status,
convert(nvarchar(MAX), GETDATE(), 101) as new_action_date,
'Y' as new_action_is_complete,

'PSCP' + '-' + replace(convert(nvarchar(MAX), GETDATE(), 110),'-','')+'-' +  CAST(ROW_NUMBER() over (order by r.id) as varchar)  as new_action_prior_attribute_import_id,
'Prospect Status-Prior' as new_action_prior_status_category1,
a2.old_action_current_attribute_ACAttrDesc as new_action_prior_attribute,
'PSCC' + '-' + replace(convert(nvarchar(MAX), GETDATE(), 110),'-','')+'-' +  CAST(ROW_NUMBER() over (order by r.id) as varchar) as new_action_current_attribute_import_id,
'Prospect Status-Current' as new_action_prior_status_category2,
pp.status as new_action_current_attribute,
'00001-593-0000511720' as New_Action_Solicitor_ID,--This is the Import ID for Adrian Jarrett


a2.old_action_import_ID_ACImpID as old_action_import_ID  ,
a2.old_action_status_ACStatus as old_action_status,
case when a2.old_action_import_ID_ACImpID is null then null else 'Y' end as old_action_is_complete,
case when a2.old_action_import_ID_ACImpID is null then null else 
	case when a2.old_action_current_attribute_ACAttrDesc <> pp.status then convert(nvarchar(MAX), GETDATE(), 101)
		 when a2.old_action_current_attribute_ACAttrDesc is NULL and pp.status is not NULL then convert(nvarchar(MAX), GETDATE(), 101) 

		end end as old_action_completed_on,
convert(nvarchar(MAX),a2.old_action_date_ACDate,101) as old_action_date,



case when a2.old_action_prior_attribute_import_id_ACAttrImpID is null then null else 'PSCD' + '-' + replace(convert(nvarchar(MAX), GETDATE(), 110),'-','')+'-' +  CAST(ROW_NUMBER() over (order by r.id) as varchar) end as old_action_days_attribute_import_id ,
case when a2.old_action_prior_attribute_import_id_ACAttrImpID is null then null else 'Prospect Status-# Days' end as old_action_days_category,

DATEDIFF(DAY,a2.old_action_date_ACDate,GETDATE()) as old_action_days_attribute







from dbo.RECORDS as r

left join (select p.ID,p.CONSTIT_ID,t1.LONGDESCRIPTION as classification, 
t2.LONGDESCRIPTION as status
from PROSPECT p

left join TABLEENTRIES as t1 on t1.TABLEENTRIESID = p.CLASSIFICATION
left join TABLEENTRIES as t2 on t2.TABLEENTRIESID = p.STATUS
)pp 

on pp.CONSTIT_ID = r.id

left join( select aa.RECORDS_ID,
max(case when aa.rn = 1 then aa.IMPORT_ID else null end) as old_action_import_ID_ACImpID,
max(case when aa.rn = 1 then aa.status_desc else null end) as old_action_status_ACStatus,
max(case when aa.rn = 1 then aa.dte else null end) as old_action_date_ACDate,

max(case when aa.rn = 1 then aa.current_attribute_import_id else null end) as old_action_currrent_attribute_import_id_ACAttrImpID ,
max(case when aa.rn = 1 then aa.current_attribute_status else null end) as old_action_current_attribute_ACAttrDesc ,
max(case when aa.rn = 1 then aa.prior_attribute_import_id else null end) as old_action_prior_attribute_import_id_ACAttrImpID ,
max(case when aa.rn = 1 then aa.prior_atttibute_status else null end) as old_action_prior_attribute_ACAttrDesc 




from


(select 

a.RECORDS_ID,
a.IMPORT_ID,
a.DateAdded,
a.DateChanged,
a.LAST_CHANGED_BY,
u.NAME,
a.DTE,
a.TYPE,
t1.LONGDESCRIPTION as type_desc,
a.notes,
a.status,
t2.LONGDESCRIPTION as status_desc,
cat.IMPORTID as current_attribute_import_id,
cat.attribute_status  current_attribute_status,
pat.IMPORTID as prior_attribute_import_id,
pat.attribute_status prior_atttibute_status,
row_number() over (partition by a.records_id order by a.dte desc,a.dateadded desc) as rn

from dbo.ACTIONS as  a

left join dbo.USERS as u on u.user_ID = a.LAST_CHANGED_BY
join TABLEENTRIES as t1 on t1.TABLEENTRIESID = a.type
left join TABLEENTRIES as t2 on t2.TABLEENTRIESID = a.STATUS
left join(select att.TABLEENTRIESID,
 Att.IMPORTID, 
att.PARENTID,
aty.DESCRIPTION as attribute_type, 
s1.LONGDESCRIPTION as attribute_status


 from ActionAttributes att

left join TABLEENTRIES as s1 on s1.TABLEENTRIESID = att.TABLEENTRIESID
left join dbo.AttributeTypes aty on aty.ATTRIBUTETYPESID = att.ATTRIBUTETYPESID



where att.ATTRIBUTETYPESID = 185)cat

on cat.PARENTID = a.ID
left join(select att.TABLEENTRIESID,
 Att.IMPORTID, 
att.PARENTID,
aty.DESCRIPTION as attribute_type, 
s1.LONGDESCRIPTION as attribute_status


 from ActionAttributes att

left join TABLEENTRIES as s1 on s1.TABLEENTRIESID = att.TABLEENTRIESID
left join dbo.AttributeTypes aty on aty.ATTRIBUTETYPESID = att.ATTRIBUTETYPESID



where att.ATTRIBUTETYPESID = 184)pat

on pat.PARENTID = a.ID


where a.TYPE = 6290)aa
where aa.rn < 2


group by aa.records_id) a2 on a2.records_id = r.id

where r.IS_CONSTITUENT = -1
--and DATEADD(dd, DATEDIFF(dd, 0, getdate()-7), 0) =  DATEADD(dd, DATEDIFF(dd, 0, r.DATE_LAST_CHANGED), 0)

and pp.status is not null


and (pp.status <> a2.old_action_current_attribute_ACAttrDesc
or coalesce(a2.old_action_current_attribute_ACAttrDesc,a2.old_action_status_ACStatus) is NULL)

order by r.DATE_LAST_CHANGED desc

