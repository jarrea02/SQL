select r.CONSTITUENT_ID,


case when r.org_name is null then CONCAT(r.FIRST_NAME,' ',r.LAST_NAME)
	else r.ORG_NAME end as NAME,


ga.GiftId,ga.AdjustmentId,g2.UserGiftId, 
g2.IMPORT_ID GIFT_IMPORT_ID,
g.IMPORT_ID ADJUSTMENT_IMPORT_ID,


g2.type as GIFT_TYPE,
g.type AS ADJUST_TYPE,
 
g2.dte as GIFT_DATE,
g.DTE as ADJUSTMENT_DATE,
gs.Amount as GIFT_SPLIT_AMOUNT,
c1.CAMPAIGN_ID ADJUSTMENT_CAMPAIGN,
f1.Fund_Id ADJUSTMENT_FUND,
a1.Appeal_Id ADJUSTMENT_APPEAL,
p1.Package_Id ADJUSTMENT_PACKAGE,
gps.Amount as OLD_AMOUNT,
c2.CAMPAIGN_ID OLD_CAMPAIGN,
f2.Fund_Id OLD_FUND,
a2.Appeal_Id OLD_APPEAL,
p2.Package_Id OLD_PACKAGE,
gps.Sequence




--gps.*


 from gift as g

join CONSTIT_GIFTS_BC bc on bc.Gift_ID =  g.ID

left join GiftSplit gs on gs.GiftId = g.ID
left join CAMPAIGN on CAMPAIGN.ID = gs.CampaignId
left join GiftPreviousSplit gps on gps.GiftId = g.ID
left join GiftAdjustment ga on ga.AdjustmentId = g.ID
left join GIFT g2 on g2.ID = ga.GiftId
left join CONSTIT_GIFTS_DC dc on dc.Gift_ID = g.ID
left join RECORDS r on r.ID = dc.Constit_ID

left join CAMPAIGN as c1 on c1.id = gs.CampaignId
left join FUND as f1 on f1.ID = gs.FundId
left join APPEAL as a1 on a1.ID = gs.AppealId
left join Package as p1 on p1.ID = gs.PackageId

left join CAMPAIGN as c2 on c2.id = gps.CampaignId
left join FUND as f2 on f2.ID = gps.FundId
left join APPEAL as a2 on a2.ID = gps.AppealId
left join Package as p2 on p2.ID = gps.PackageId  
left join USERS as u on u.USER_ID = g.ADDEDBYID
left join records as ur on u.CONSTITUENTID = ur.ID

left join (select g3.* from GIFT g3

join GiftSplit gs2 on gs2.GiftId = g3.ID

where gs2.PackageId is not null) x

on x.ID = ga.GiftId


where gs.PackageId is null
and gps.PackageId is not null
and gs.AppealId = gps.AppealId
and g.DTE >= Cast('01/01/18' as date)
and g.type in ('28')
and x.id is null
order by g.dte