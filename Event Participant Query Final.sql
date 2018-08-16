with ccc as


(select 

r.ID,
r.CONSTITUENT_ID,
r.FIRST_NAME,
r.LAST_NAME,
r.KEY_INDICATOR,
r.sex,
r.IS_CONSTITUENT,

ccc.CONSTITUENT_CODE1,
ccc.CONSTITUENT_CODE2,
ccc.CONSTITUENT_CODE3,

pp.*

from RECORDS as r


left join(select

c2.CONSTIT_ID,
MAX(case when c2.SEQUENCE = 1 then c2. CONS_CODE END) as CONSTITUENT_CODE1,
MAX(case when c2.SEQUENCE = 2 then c2. CONS_CODE END)as CONSTITUENT_CODE2,
MAX(case when c2.SEQUENCE = 3 then c2. CONS_CODE END) as CONSTITUENT_CODE3

from

(select 
cc.CONSTIT_ID,
t3.LONGDESCRIPTION as CONS_CODE,
cc.DATE_FROM,
cc.DATE_TO,
cc.SEQUENCE

FROM CONSTITUENT_CODES as cc

left join TABLEENTRIES as t3 on t3.TABLEENTRIESID = cc.CODE)c2

group by c2.CONSTIT_ID)ccc

on ccc.CONSTIT_ID = r.ID

join (select 

p.RecordsID,
ee.eventid,
ee.category,
ee.type,
ee.DESCRIPTION,
ee.START_DATE,
ee.END_DATE,
ee.START_TIME,
ee.END_TIME,

CASE p.Invitation WHEN 1 THEN 'Do not invite' WHEN 2 THEN 'Not invited' WHEN 3 THEN 'Invited' ELSE '' END as Invitation,
t.LONGDESCRIPTION as Response,
CASE p.Registration WHEN 1 THEN 'Do not register' WHEN 2 THEN 'Not registered' WHEN 3 THEN 'Registered' ELSE '' END as Registration,
p.Attended,

p.AmountPaid,
p.DateAdded,
p.DateChanged


from participants as p

left join TABLEENTRIES as t on t.TABLEENTRIESID = p.Response



join (select 

se.ID,
se.EVENTID,
se.NAME,
CASE se.CATEGORY WHEN 1 THEN 'Sporting Event' WHEN 2 THEN 'Dinner' WHEN 3 THEN 'Class' WHEN 4 THEN 'Other' ELSE '' END as CATEGORY,
t2.LONGDESCRIPTION as TYPE,
se.DESCRIPTION,
se.START_DATE,
se.END_DATE,
se.START_TIME,
se.END_TIME


 from SPECIAL_EVENT as se

 left join TABLEENTRIES as t2 on t2.TABLEENTRIESID = se.TYPEID

 where se.EVENTID = '201805FBIB')ee

 on p.eventid = ee.id

 where p.Attended = -1)pp

on pp.recordsid = r.ID),


ggg as 
(select gift.id, cg.Constit_ID,
GiftSplit.Amount,
gift.DTE,
CAMPAIGN.CAMPAIGN_ID,
CAMPAIGN.DESCRIPTION as campaign_description,
fund.FUND_ID,
fund.DESCRIPTION as fund_description,
appeal.APPEAL_ID,
appeal.DESCRIPTION as appeal_description,
t.LONGDESCRIPTION as appeal_category,

CASE GIFT.PAYMENT_TYPE WHEN 1 THEN 'Cash' WHEN 2 THEN 'Personal Check' WHEN 3 THEN 'Business Check' WHEN 4 THEN 'Credit Card' WHEN 6 THEN 'Direct Debit' WHEN 8 THEN 'Other' ELSE '' END  "Gift Payment Type"

from GIFT

join CONSTIT_GIFTS_BC as cg on cg.Gift_ID = gift.ID

left join dbo.GiftSplit on GiftSplit.GiftId = gift.ID


left join FUND on FUND.id = giftsplit.FundId

left join appeal on appeal.ID = GiftSplit.AppealId

left join CAMPAIGN on CAMPAIGN.ID = GiftSplit.CampaignId

left join TABLEENTRIES t on t.TABLEENTRIESID = appeal.AppealCategoryID
left join TABLEENTRIES t2 on t2.TABLEENTRIESID = gift.PAYMENT_TYPE

where gift.TYPE in ('1','8','9','3','10','12','14','15','17','18','20','31')

and (gift.type not in ('28','32','33') OR (GIFT.TYPE IS NULL))

and CAMPAIGN.CAMPAIGN_ID <> 'NPR'
and appeal.APPEAL_ID  <> '-NPR'),

aaa as


(select  
a.RECORDS_ID,
a.ID,
a.dte,
a.DateAdded,
aan.LONGDESCRIPTION as CONTACT_REPORT

from ACTIONS as a


join (select an.NotesID,
an.ParentId,
an.NoteTypeId,
t.LONGDESCRIPTION

 from ActionNotepad as an


join TABLEENTRIES as t on t.TABLEENTRIESID = an.NoteTypeId

where lower(t.LONGDESCRIPTION )like '%fore%'
or  lower(t.LONGDESCRIPTION) like '%face%')aan

on aan.ParentId = a.ID),

ppp as

(select  
p.id,
pr.CONSTIT_ID,
p.PROSPECT_ID,
p.AMOUNT_ASKED,
p.AMOUNT_EXPECTED,
p.AMOUNT_FUNDED,
p.DATE_ASKED,
p.DATE_EXPECTED,
p.DATE_FUNDED,
p.DATE_ADDED,
t.LONGDESCRIPTION as status


from PROPOSAL as p

join PROSPECT as pr on pr.ID = p.PROSPECT_ID
join TABLEENTRIES as t on t.TABLEENTRIESID =  p.STATUS

where --lower(t.LONGDESCRIPTION) not like '%dead%'
--and 
lower(t.LONGDESCRIPTION) not like '%cancelled%'	
--and lower(t.LONGDESCRIPTION) not like '%declined%'
--and lower(t.LONGDESCRIPTION) not like '%closed%'
)








select * from ccc

left join (select g1.Constit_ID,
sum(g1.amount) gift_amount_in_six_months_after ,
count(g1.id) gift_count_in_six_months_after

from 

(select ggg.* from ggg

join ccc on ccc.id = ggg.Constit_ID
where ggg.DTE between ccc.START_DATE and dateadd(month,6,ccc.START_DATE) 

)g1

group by g1.Constit_ID)g2

on g2.Constit_ID = ccc.ID

left join (select g1.Constit_ID,
sum(g1.amount) gift_amount_in_six_months_prior ,
count(g1.id) gift_count_in_six_months_prior

from 

(select ggg.* from ggg

join ccc on ccc.id = ggg.Constit_ID
where ggg.DTE between dateadd(month,-6,ccc.START_DATE) and   ccc.START_DATE

)g1

group by g1.Constit_ID)g3

on g3.Constit_ID = ccc.ID



left join (select a1.RECORDS_ID,
--sum(a1.amount) gift_amount_in_six_months_after ,
count(a1.id) action_count_in_six_months_after

from 

(select aaa.* from aaa

join ccc on ccc.id = aaa.RECORDS_ID
where aaa.DTE between ccc.START_DATE and dateadd(month,6,ccc.START_DATE) 

)a1

group by a1.RECORDS_ID)a2

on a2.RECORDS_ID = ccc.ID

left join (select a1.RECORDS_ID,
--sum(a1.amount) gift_amount_in_six_months_prior ,
count(a1.id) action_count_in_six_months_prior

from 

(select aaa.* from aaa

join ccc on ccc.id = aaa.RECORDS_ID
where aaa.DTE between dateadd(month,-6,ccc.START_DATE) and   ccc.START_DATE

)a1

group by a1.RECORDS_ID)a3

on a3.RECORDS_ID = ccc.ID



left join (
select p1.constit_id,
sum(p1.AMOUNT_EXPECTED)prop_ex_amount_in_six_months_after,
count(p1.ID)prop_count_in_six_months_after

from


(select ppp.* from ppp

join ccc on ccc.ID = ppp.CONSTIT_ID
where ppp.DATE_ADDED between ccc.START_DATE and dateadd(month,6,ccc.START_DATE) 
)p1

group by p1.CONSTIT_ID)p2

on p2.CONSTIT_ID = ccc.ID


left join (
select p1.constit_id,
sum(p1.AMOUNT_EXPECTED)prop_ex_amount_in_six_months_prior,
count(p1.ID)prop_count_in_six_months_prior

from


(select ppp.* from ppp

join ccc on ccc.ID = ppp.CONSTIT_ID
where ppp.DATE_ADDED between   dateadd(month,-6,ccc.START_DATE) and ccc.START_DATE
)p1

group by p1.CONSTIT_ID)p3

on p3.CONSTIT_ID = ccc.ID




