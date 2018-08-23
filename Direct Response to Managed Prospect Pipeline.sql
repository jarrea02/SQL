select distinct t1.*

from

(select distinct 
r.id,r.CONSTITUENT_ID,r.FIRST_NAME,r.LAST_NAME,r.ORG_NAME,gg.dte,
PS.DATE_FROM,
PS.DATE_TO,

case when gg.dte between CAST(ps.date_from as datetime) and --CAST(ps.date_to as datetime)

CAST(case when ps.DATE_to is null then '99990101'else ps.DATE_to end as datetime) 
then 'Y' else 'N'
 end as man_gift

from RECORDS r


join (select cs.CONSTIT_ID from CONSTIT_SOLICITORS cs

where cs.SOLICITOR_TYPE IN (6374,8735,20100,16743,2491,6620,6013)

AND cs.DATE_TO is null)active on active.CONSTIT_ID = r.ID

left join(select cs.CONSTIT_ID from CONSTIT_SOLICITORS cs

where cs.SOLICITOR_TYPE IN (6374,8735,20100,16743,2491,6620,6013)

AND cs.DATE_TO is null
and cs.DATE_FROM < '20160101'
)long on long.CONSTIT_ID = r.ID

join(select g.*,a.APPEAL_ID,
bc.Constit_ID as cid from gift g
join CONSTIT_GIFTS_BC bc on bc.Gift_ID = g.ID
left join GiftSplit gs on gs.GiftId = g.ID
left join APPEAL a on a.ID = gs.AppealId

where g.dte between CAST('01/01/16' as datetime) and cast('01/01/17' as datetime)
and a.AppealCategoryID = '7705')gg on gg.cid= r.ID

left join(select cs.* from CONSTIT_SOLICITORS cs

where cs.SOLICITOR_TYPE IN (6374,8735,20100,16743,2491,6620,6013)

AND cs.DATE_TO between '20160101' and '20171231'
or cs.DATE_FROM between '20160101' and '20171231')ps on ps.CONSTIT_ID = R.ID

where long.CONSTIT_ID is null

)t1

where t1.man_gift = 'Y'
--and t1.CONSTITUENT_ID = '9029'

--order by r.CONSTITUENT_ID
