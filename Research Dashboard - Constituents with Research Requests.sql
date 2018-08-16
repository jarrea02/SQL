with tmp6015 as

(SELECT 
 RATINGS.*, 
TABLEENTRIES.LongDESCRIPTION, 
TABLEENTRIES.SHORTDESCRIPTION

FROM 
DBO.RATINGS LEFT OUTER JOIN DBO.TABLEENTRIES ON RATINGS.TABLEENTRY = TABLEENTRIES.TABLEENTRIESID

WHERE 
SOURCE = 6014 AND Category_Code  = 6015),

tmp5967 as

(SELECT 
 RATINGS.*, 
TABLEENTRIES.LongDESCRIPTION, 
TABLEENTRIES.SHORTDESCRIPTION

FROM 
DBO.RATINGS LEFT OUTER JOIN DBO.TABLEENTRIES ON RATINGS.TABLEENTRY = TABLEENTRIES.TABLEENTRIESID

WHERE 
SOURCE = 5912 AND Category_Code  = 5967  ),


v_first_res_req as

(select t1.*,

tmp5.solicitor_list

from

(SELECT 

 a.records_id,
 a.id,
 a.import_id,
 a.dateadded,
 a.datechanged,
 a.dte,
 a.type,
 a.category,
 a.completed_date,
 



row_number() over (partition by a.records_id order by a.DateAdded )first_req,
row_number() over (partition by a.records_id order by a.DateAdded desc)latest_req

 
 
  FROM 
DBO.ACTIONS a



WHERE 

a.TYPE  =  6336)t1

left Join ((select t1.action_id,


replace(rtrim (CONCAT(max(case when t1.rn = 1 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME) end),'  ',
		max(case when t1.rn = 2 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 3 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 4 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 5 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 6 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 7 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 8 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 9 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 10 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME) end))),'  ',', ')  solicitor_list



from

(select 
r2.id,
r2.CONSTITUENT_ID "Constituent ID",
 r2.FIRST_NAME,
 r2.LAST_NAME,
acs.ACTION_ID,
ROW_NUMBER() over (partition by acs.action_id order by  r2.last_name) rn
from records r2
left join ACTION_SOLICITOR acs on acs.RECORDS_ID = r2.ID

where acs.ACTION_ID is not null)t1

group by t1.ACTION_ID)

)tmp5 on tmp5.ACTION_ID = t1.id

Where t1.first_req = 1
)








SELECT 
 RECORDS.ID,
 RECORDS.CONSTITUENT_ID "Constituent ID",
 case when RECORDS.FIRST_NAME is null then records.ORG_NAME else concat(records.FIRST_NAME,' ',RECORDS.LAST_NAME) end as Name,
 records.KEY_INDICATOR,

 T_1.LONGDESCRIPTION "WE P2G Score WE P2G Score",
 T_2.LONGDESCRIPTION "WE Giving Capacity WE Giving Capacity",
 v_first_res_req.DateAdded "Research Request Date",
 v_first_res_req.solicitor_list


FROM 
DBO.RECORDS AS RECORDS 
LEFT OUTER JOIN DBO.PROSPECT AS RECORDS_PROSPECT ON RECORDS.ID = RECORDS_PROSPECT.CONSTIT_ID 
LEFT OUTER JOIN tmp6015 AS T_1 ON RECORDS_PROSPECT.ID = T_1.PROSPECT_ID 
LEFT OUTER JOIN tmp5967 AS T_2 ON RECORDS_PROSPECT.ID = T_2.PROSPECT_ID
left join v_first_res_req on v_first_res_req.RECORDS_ID = RECORDS.ID

WHERE 
RECORDS.IS_CONSTITUENT  =  -1  
and v_first_res_req.DateAdded is not null