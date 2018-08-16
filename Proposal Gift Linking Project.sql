with ggg as 
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

where gift.TYPE  in ('1','8','9','10','15','18','30','34')

and (gift.type not in ('28','32','33') OR (GIFT.TYPE IS NULL))

and CAMPAIGN.CAMPAIGN_ID <> 'NPR'
and appeal.APPEAL_ID  <> '-NPR'),


ppp as

(select pr.id,
pr.PROSPECT_ID,
pc.CONSTIT_ID,
pr.DATE_ADDED,
pr.Proposal_Name,
t1.LONGDESCRIPTION as STATUS,
pr.AMOUNT_EXPECTED,
pr.AMOUNT_ASKED,
pr.AMOUNT_FUNDED,
c.CAMPAIGN_ID,
c.DESCRIPTION as CAMPAIGN_DESC,

f.FUND_ID,
f.DESCRIPTION as FUND_DESC,
t3.LONGDESCRIPTION as GIFT_TYPE,
t2.LONGDESCRIPTION as REASON





from PROPOSAL as pr

join PROSPECT as pc on pc.ID = pr.PROSPECT_ID

left join TABLEENTRIES as t1 on t1.TABLEENTRIESID = pr.STATUS
left join TABLEENTRIES as t2 on t2.TABLEENTRIESID = pr.REASON
left join TABLEENTRIES as t3 on t3.TABLEENTRIESID = pr.GIFT_TYPE
left join CAMPAIGN as c on c.ID = pr.CAMPAIGN
left join FUND as f on f.ID = pr.FUND

where --lower(t1.LONGDESCRIPTION) not like '%closed%'
--and 
lower(t1.LONGDESCRIPTION) not like '%dead%'
and lower(t1.LONGDESCRIPTION) not like '%cancelled%'
and lower(t1.LONGDESCRIPTION) not like '%declined%'
--and pr.AMOUNT_FUNDED >= '01/01/18'
),
lll as 
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

join CONSTIT_GIFTS_DC as cg on cg.Gift_ID = gift.ID

left join dbo.GiftSplit on GiftSplit.GiftId = gift.ID


left join FUND on FUND.id = giftsplit.FundId

left join appeal on appeal.ID = GiftSplit.AppealId

left join CAMPAIGN on CAMPAIGN.ID = GiftSplit.CampaignId

left join TABLEENTRIES t on t.TABLEENTRIESID = appeal.AppealCategoryID
left join TABLEENTRIES t2 on t2.TABLEENTRIESID = gift.PAYMENT_TYPE

where gift.TYPE  in ('1','8','9','10','15','18','30','34')

and (gift.type not in ('28','32','33') OR (GIFT.TYPE IS NULL))

and CAMPAIGN.CAMPAIGN_ID <> 'NPR'
and appeal.APPEAL_ID  <> '-NPR')



----------------------------------------------------------------


select distinct r.CONSTITUENT_ID,
lg.CONSTITUENT_ID,

case when (floor(ggg.Amount) = floor(case when isnull(ppp.amount_funded,0) > 0 then ppp.amount_funded
							when isnull(ppp.amount_expected,0) > 0 then ppp.amount_expected
							when isnull(ppp.amount_asked,0) > 0 then ppp.amount_asked end))
							then 'Y' else 'N' end as match,


r.FIRST_NAME,r.LAST_NAME,r.ORG_NAME,ggg.*,sr.CONSTITUENT_ID as Solicitor_Cons_id,sr.FIRST_NAME,sr.LAST_NAME,

ppp.*,
lg.CONSTITUENT_ID

from ggg

join RECORDS as r on r.ID = ggg.Constit_ID
join GiftSolicitor as gs on gs.ParentId = ggg.ID
left join RECORDS as sr on sr.ID = gs.SolicitorId 
left join GiftProposal as gp on gp.GiftId = ggg.ID
left join ppp on ppp.CONSTIT_ID = r.ID
left join lll on lll.ID = ggg.ID
left join records as lg on lg.id = lll.Constit_ID



where ggg.DTE >= '01/01/18'
and ppp.DATE_ADDED >= '01/01/17'

and ggg.APPEAL_ID like'%-%'
and ggg.APPEAL_ID not like '%PG%'
and ggg.APPEAL_ID not like '%TRIBUTE%'
and gp.GiftId is null

order by ggg.DTE desc


