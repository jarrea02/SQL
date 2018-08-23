

select distinct 
r.id,r.CONSTITUENT_ID,r.FIRST_NAME,r.LAST_NAME,r.ORG_NAME

from records r

join (select cs.CONSTIT_ID from CONSTIT_SOLICITORS cs

where cs.SOLICITOR_TYPE IN (6374,8735,20100,16743,2491,6620,6013)

AND cs.DATE_TO is null)active on active.CONSTIT_ID = r.ID

left join( select g.dte,a.APPEAL_ID,
bc.Constit_ID as cid from gift g
join CONSTIT_GIFTS_BC bc on bc.Gift_ID = g.ID
left join GiftSplit gs on gs.GiftId = g.ID
left join APPEAL a on a.ID = gs.AppealId

where g.dte between CAST('01/01/16' as datetime) and cast('01/01/17' as datetime)
and a.AppealCategoryID = '7705'
and (g.TYPE not in ('28','32','33') or g.type is null))drg on drg.cid = r.ID

left join (select *

from

(select ss.* ,drg.DTE,

case when drg.dte between CAST(ss.DATE_from as datetime) and cast(case when ss.date_to is null then '99990101' else ss.date_to end as datetime)

then 'Y' end as drg_man

from

--DATE FROM AND TO IN DATE RANGE
(select cs.CONSTIT_ID, cs.DATE_FROM,cs.DATE_TO from CONSTIT_SOLICITORS cs
where cs.SOLICITOR_TYPE IN (6374,8735,7517,20100,20268,2491,7525,6620,5500,6013,17882,16743)

and cs.DATE_FROM between '20160101' and '20171231'
AND cs.DATE_TO between '20160101' and '20171231'


union

--LONG TERM PROSPECT, BEFORE AND AFTER DATE RANGE(THRU)
select cs.CONSTIT_ID, cs.DATE_FROM,cs.DATE_TO from CONSTIT_SOLICITORS cs

where cs.SOLICITOR_TYPE IN (6374,8735,7517,20100,20268,2491,7525,6620,5500,6013,17882,16743)
and cs.DATE_FROM < '20160101'
AND cs.DATE_TO is null

union

--LONG TERM PROSPECT, BEFORE AND AFTER DATE RANGE(THRU)
select cs.CONSTIT_ID, cs.DATE_FROM,cs.DATE_TO from CONSTIT_SOLICITORS cs

where cs.SOLICITOR_TYPE IN (6374,8735,7517,20100,20268,2491,7525,6620,5500,6013,17882,16743)
and cs.DATE_FROM < '20160101'
AND cs.DATE_TO > '20160101'

union

--OLD PROSPECT, DATE FROM BEFORE RANGE, DATE TO IN RANGE
select cs.CONSTIT_ID, cs.DATE_FROM,cs.DATE_TO from CONSTIT_SOLICITORS cs

where cs.SOLICITOR_TYPE IN (6374,8735,7517,20100,20268,2491,7525,6620,5500,6013,17882,16743)
and cs.DATE_FROM < '20160101'
AND cs.DATE_TO between '20160101' and '20171231'

union

--- DATE FROM DURING DATE RANGE, DATE TO AFTER RANGE
select cs.CONSTIT_ID, cs.DATE_FROM,cs.DATE_TO from CONSTIT_SOLICITORS cs

where cs.SOLICITOR_TYPE IN (6374,8735,7517,20100,20268,2491,7525,6620,5500,6013,17882,16743)
and cs.DATE_FROM   between '20160101' and '20171231'
AND cs.DATE_TO is null

union

--- DATE FROM DURING DATE RANGE, DATE TO AFTER RANGE
select cs.CONSTIT_ID, cs.DATE_FROM,cs.DATE_TO from CONSTIT_SOLICITORS cs

where cs.SOLICITOR_TYPE IN (6374,8735,7517,20100,20268,2491,7525,6620,5500,6013,17882,16743)
and cs.DATE_FROM   between '20160101' and '20171231'
AND cs.DATE_TO is not null


union

--DATE FROM BEFORE DATE RANGE, DATE TO IN DATE RANGE
select cs.CONSTIT_ID, cs.DATE_FROM,cs.DATE_TO from CONSTIT_SOLICITORS cs

where cs.SOLICITOR_TYPE IN (6374,8735,7517,20100,20268,2491,7525,6620,5500,6013,17882,16743)
and cs.DATE_FROM < '20160101'
AND cs.DATE_TO between '20160101' and '20171231'







)ss

join( select g.dte,a.APPEAL_ID,
bc.Constit_ID as cid from gift g
join CONSTIT_GIFTS_BC bc on bc.Gift_ID = g.ID
left join GiftSplit gs on gs.GiftId = g.ID
left join APPEAL a on a.ID = gs.AppealId

where g.dte between CAST('01/01/16' as datetime) and cast('01/01/17' as datetime)
and a.AppealCategoryID = '7705'
and (g.TYPE not in ('28','32','33') or g.type is null))drg on drg.cid = ss.CONSTIT_ID)z

where z.drg_man =  'Y'


)y on y.CONSTIT_ID = r.ID

where y.CONSTIT_ID is null
and drg.cid is not null
