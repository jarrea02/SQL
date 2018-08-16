select

bc.Constit_ID,
sum(case when g.DTE >= v_first_res_req.DateAdded then gs.Amount else 0 end)Gift_amt_since_res_req,
sum(case when g.DTE >= v_first_res_req.DateAdded  then 1 else 0 end)gift_count_since_res_req




 from GIFT g

join CONSTIT_GIFTS_BC bc on bc.Gift_ID = g.ID
join GiftSplit gs on gs.GiftId = g.ID
left join (select t1.*,

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

Where t1.first_req = 1)v_first_res_req on v_first_res_req.RECORDS_ID = bc.CONSTIT_ID



where g.TYPE not in ('28','32','33','2','11','13','16','19','21','22','27','30')
and v_first_res_req.DateAdded is not null

group by bc.Constit_ID
