select distinct

records.CONSTITUENT_ID,
case when has_no_email_sol.RECORDSID is null then 'N' else 'Y' end as REQUESTED_NO_EMAIL_BEFORE_2015, 
isnull(records.FIRST_NAME,'') as FIRST_NAME,
isnull(records.LAST_NAME,'') as LAST_NAME,
isnull(records.ORG_NAME,'') as ORG_NAME,

isnull(ct.PRIMARY_CONTACT_FIRST_NAME,'') as ORG_CONTACT_FIRST_NAME,
isnull(ct.PRIMARY_CONTACT_LAST_NAME,'') as ORG_CONTACT_LAST_NAME,
isnull(cast(year(getdate()) -  year(cast(case	when len(RECORDS.BIRTH_DATE) < 5 then  cast (RECORDS.BIRTH_DATE as varchar) + '0101' 	
		when len(RECORDS.BIRTH_DATE) < 8 then  cast (RECORDS.BIRTH_DATE as varchar) + '01' else RECORDS.BIRTH_DATE end AS date))as varchar),'') as AGE,

gd1.LONGDESCRIPTION as GENDER,
cons.constituent_code1 as CONSTITUENT_CODE1,
cons.constituent_code2 as CONSTITUENT_CODE2,
cons.constituent_code3 as CONSTITUENT_CODE3,
isnull(ss.SOLICITOR1_NAME,'') as SOLICITOR1_NAME,
isnull(ss.SOLICITOR1_TYPE,'') as SOLICITOR1_TYPE,
isnull(ss.SOLICITOR2_NAME,'') as SOLICITOR2_NAME,
isnull(ss.SOLICITOR2_TYPE,'') as SOLICITOR2_TYPE,
isnull(ss.SOLICITOR3_NAME,'') as SOLICITOR3_NAME,
isnull(ss.SOLICITO3R_TYPE,'') as SOLICITOR3_TYPE,
addr.[Preferred City] as PREFERRED_CITY,
addr.[Preferred State] as PREFERRED_STATE,
addr.[Preferred County] as PREFERRED_COUNTY,
addr.[Preferred ZIP] as PREFERRED_ZIP,

has_email.email1 as EMAIL1,
has_email.email_type1 as EMAIL_TYPE1 ,
has_email.email2 as EMAIL2,
has_email.email_type2 as EMAIL_TYPE2,
has_email.email3 as EMAIL3,
has_email.email_type3 as EMAIL_TYPE3,
has_email.email4 as EMAIL4,
has_email.email_type4 as EMAIL_TYPE4,
has_email.email5 as EMAIL5,
has_email.email_type5 as EMAIL_TYPE5,
has_email.email6 EMAIL6,
has_email.email_type6 as EMAIL_TYPE6,

isnull(convert(nvarchar(MAX),CAST(lg.Amount AS DECIMAL(12,2)), 101),'') as LAST_GIFT_AMOUNT,
isnull(convert(nvarchar(MAX),lg.DTE, 101),'') as LAST_GIFT_DATE,
isnull(convert(nvarchar(MAX),lg.APPEAL_ID, 101),'')  as LAST_GIFT_APPEAL_ID,
isnull(convert(nvarchar(MAX),lg.appeal_description, 101),'')   as LAST_GIFT_APPEAL_DESC,
isnull(convert(nvarchar(MAX),lg.appeal_category, 101),'')  as LAST_GIFT_APPEAL_CATEGORY,
isnull(convert(nvarchar(MAX),lg.appeal_type, 101),'')  as LAST_GIFT_APPEAL_TYPE,
isnull(convert(nvarchar(MAX),lg.CAMPAIGN_ID, 101),'')   as LAST_GIFT_CAMPAIGN_ID,
isnull(convert(nvarchar(MAX),lg.campaign_description, 101),'')  as LAST_GIFT_CAMPAIGN_DESC,
isnull(convert(nvarchar(MAX),lg.FUND_ID, 101),'')   as LAST_GIFT_FUND_ID,
isnull(convert(nvarchar(MAX),lg.fund_description, 101),'')   as LAST_GIFT_FUND_DESC,
isnull(convert(nvarchar(MAX),lg.[Gift Payment Type], 101),'')   as LAST_GIFT_PAYMENT_TYPE,




isnull(convert(nvarchar(MAX),CAST(lrg.Amount AS DECIMAL(12,2)), 101),'') as LARGEST_GIFT_AMOUNT,
isnull(convert(nvarchar(MAX),lrg.DTE, 101),'') as LARGEST_GIFT_DATE,
isnull(convert(nvarchar(MAX),lrg.APPEAL_ID, 101),'')  as LARGEST_GIFT_APPEAL_ID,
isnull(convert(nvarchar(MAX),lrg.appeal_description, 101),'')   as LARGEST_GIFT_APPEAL_DESC,
isnull(convert(nvarchar(MAX),lrg.appeal_category, 101),'')  as LARGEST_GIFT_APPEAL_CATEGORY,
isnull(convert(nvarchar(MAX),lrg.appeal_type, 101),'')  as LARGEST_GIFT_APPEAL_TYPE,
isnull(convert(nvarchar(MAX),lrg.CAMPAIGN_ID, 101),'')   as LARGEST_GIFT_CAMPAIGN_ID,
isnull(convert(nvarchar(MAX),lrg.campaign_description, 101),'')  as LARGEST_GIFT_CAMPAIGN_DESC,
isnull(convert(nvarchar(MAX),lrg.FUND_ID, 101),'')   as LARGEST_GIFT_FUND_ID,
isnull(convert(nvarchar(MAX),lrg.fund_description, 101),'')   as LARGEST_GIFT_FUND_DESC,
isnull(convert(nvarchar(MAX),lrg.[Gift Payment Type], 101),'')   as LARGEST_GIFT_PAYMENT_TYPE,




isnull(CAST(lf.lifetime_gift_amt AS DECIMAL(12,2)),0) AS LIFETIME_GIFT_AMOUNT,
isnull(CAST(lf.lifetime_gift_count AS DECIMAL(12,2)),0) AS LIFETIME_GIFT_COUNT,

case when og.Constit_ID is null then  'N' else 'Y' end as HAS_MADE_ONLINE_GIFT,
case when dr.Constit_ID is null then  'N' else 'Y' end as HAS_MADE_DIRECT_RESPONSE_GIFT,
case when eg.Constit_ID is null then  'N' else 'Y' end as HAS_MADE_EMAIL_GIFT,
case when ev.Constit_ID is null then  'N' else 'Y' end as HAS_MADE_EVENT_GIFT,
case when ptp.Constit_ID is null then  'N' else 'Y' end as HAS_MADE_P2P_GIFT,
case when mg.Constit_ID is null then  'N' else 'Y' end as HAS_MADE_PM_GIFT,

--s.LONGDESCRIPTION as suspect_source,
---s.attributedate as suspect_source_date,
--fg.appeal_description,
--fg.DTE,
isnull(px.LONGDESCRIPTION,'') as PATIENT_EXPERIENCE_LOCATION,
ISNULL( case when s.attributedate is null and fg.dte is not null then 'Gift'
	 when fg.dte is null and s.attributedate is not null then 'Suspect List'
	 when s.attributedate <= fg.dte then 'Suspect List'
	 when fg.dte < s.attributedate then 'Gift'
	else '' end,'') as RECORD_SOURCE_TYPE,

ISNULL(case when s.attributedate is null and fg.dte is not null then fg.appeal_description
	 when fg.dte is null and s.attributedate is not null then s.LONGDESCRIPTION
	 when s.attributedate <= fg.dte then s.LONGDESCRIPTION
	 when fg.dte < s.attributedate then fg.appeal_description
	else '' end,'') as RECORD_SOURCE_DESC,

ISNULL(case when s.attributedate is null and fg.dte is not null then  convert(nvarchar(MAX),fg.dte, 101)
	 when fg.dte is null and s.attributedate is not null then  convert(nvarchar(MAX),s.attributedate, 101)
	 when s.attributedate <= fg.dte then convert(nvarchar(MAX),s.attributedate, 101)
	 when fg.dte < s.attributedate then convert(nvarchar(MAX),fg.dte, 101)
	else '' end,'') as RECORD_SOURCE_DATE,

ISNULL(case when s.attributedate is null and fg.dte is not null then fg.appeal_category
	 when fg.dte is null and s.attributedate is not null then ''
	 when s.attributedate <= fg.dte then ''
	 when fg.dte < s.attributedate then fg.appeal_category
	else '' end,'') as RECORD_SOURCE_CATEGORY,

ISNULL(case when s.attributedate is null and fg.dte is not null then fg.appeal_type
	 when fg.dte is null and s.attributedate is not null then ''
	 when s.attributedate <= fg.dte then ''
	 when fg.dte < s.attributedate then fg.appeal_type
	else '' end,'') as RECORD_SOURCE_CATEGORY_TYPE,

isnull(CAST(hlf.lifetime_gift_amt AS DECIMAL(12,2)),0) AS HARD_CREDIT_LIFETIME_GIFT_AMOUNT,
isnull(CAST(hlf.lifetime_gift_count AS DECIMAL(12,2)),0) AS HARD_CREDIT_LIFETIME_GIFT_COUNT,

Case when qr.IS_HEADOFHOUSEHOLD = -1 then 'Y' else 'N' end as IS_HEADOFHOUSEHOLD	

from RECORDS



join TABLEENTRIES gd1 on gd1.TABLEENTRIESID = records.Gender



----Remove No Contact, HIPAA Opt Out and One Solicitation per Year
left join(select distinct CONSTITUENT_SOLICITCODES.*, 
sc1.LONGDESCRIPTION

from CONSTITUENT_SOLICITCODES

join TABLEENTRIES sc1 on sc1.TABLEENTRIESID = CONSTITUENT_SOLICITCODES.SOLICIT_CODE

where CONSTITUENT_SOLICITCODES.SOLICIT_CODE in (3660,16811,20700)) nc

on nc.RECORDSID = RECORDS.ID

----- Remove Spouse No Contact, HIPAA Opt Out and One Solicitation per Year
left join (select 

CONSTIT_RELATIONSHIPS.ID,
CONSTIT_RELATIONSHIPS.CONSTIT_ID,

r1.LONGDESCRIPTION as relationship,

r2.LONGDESCRIPTION as recip_relationship,
CONSTIT_RELATIONSHIPS.relation_id





from CONSTIT_RELATIONSHIPS

join TABLEENTRIES r1 on r1.TABLEENTRIESID = RELATION_CODE
join TABLEENTRIES r2 on r2.TABLEENTRIESID = RECIP_RELATION_CODE

join(select distinct CONSTITUENT_SOLICITCODES.*, 
sc1.LONGDESCRIPTION

from CONSTITUENT_SOLICITCODES

join TABLEENTRIES sc1 on sc1.TABLEENTRIESID = CONSTITUENT_SOLICITCODES.SOLICIT_CODE

where CONSTITUENT_SOLICITCODES.SOLICIT_CODE in (3660,16811,20700)) nc

on nc.RECORDSID = CONSTIT_RELATIONSHIPS.relation_id


Where IS_SPOUSE = -1)snc

on snc.CONSTIT_ID = RECORDS.id

----- Remove All Trustee Types
left join(select CONSTITUENT_CODES.*,c1.LONGDESCRIPTION from CONSTITUENT_CODES


join TABLEENTRIES c1 on c1.TABLEENTRIESID = CONSTITUENT_CODES.CODE

where lower(c1.LONGDESCRIPTION) like '%trustee%'

or lower(c1.LONGDESCRIPTION) like '%staff%'

or lower(c1.LONGDESCRIPTION) like '%alumni%'

or lower(c1.LONGDESCRIPTION) like '%faculty%'

or lower(c1.LONGDESCRIPTION) like '%corporate%'
or lower(c1.LONGDESCRIPTION) like '%board%'
or lower(c1.LONGDESCRIPTION) like '%student%'
or lower(c1.LONGDESCRIPTION) like '%parent%'
or lower(c1.LONGDESCRIPTION) like '%trust%'
or lower(c1.LONGDESCRIPTION) like '%fund%'
or lower(c1.LONGDESCRIPTION) like '%mount%'

or c1.LONGDESCRIPTION in ('Organization','Foundation','Corporation')

)cc

on cc.CONSTIT_ID = RECORDS.ID

---- Remove Spouse Trustee Types
left join (select 

CONSTIT_RELATIONSHIPS.ID,
CONSTIT_RELATIONSHIPS.CONSTIT_ID,

r1.LONGDESCRIPTION as relationship,

r2.LONGDESCRIPTION as recip_relationship,
CONSTIT_RELATIONSHIPS.relation_id





from CONSTIT_RELATIONSHIPS

join TABLEENTRIES r1 on r1.TABLEENTRIESID = RELATION_CODE
join TABLEENTRIES r2 on r2.TABLEENTRIESID = RECIP_RELATION_CODE


join(select CONSTITUENT_CODES.*,c1.LONGDESCRIPTION from CONSTITUENT_CODES


join TABLEENTRIES c1 on c1.TABLEENTRIESID = CONSTITUENT_CODES.CODE

where lower(c1.LONGDESCRIPTION) like '%trustee%')nc

on nc.CONSTIT_ID = CONSTIT_RELATIONSHIPS.relation_id

Where IS_SPOUSE = -1)scc

on scc.CONSTIT_ID = RECORDS.ID


---------- Remove Patient Experience Negative
left join (select ca.*,
t.LONGDESCRIPTION,
at.DESCRIPTION

 from ConstituentAttributes as ca

left join TABLEENTRIES t on t.TABLEENTRIESID = ca.TABLEENTRIESID
left join AttributeTypes at on at.ATTRIBUTETYPESID = ca.ATTRIBUTETYPESID

where t.LONGDESCRIPTION = 'NEGATIVE')pe

on pe.PARENTID = RECORDS.ID

----------Remove Mount Sinai Senior Leadership

left join (
select ca.*,
t.LONGDESCRIPTION,
at.DESCRIPTION

 from ConstituentAttributes as ca

left join TABLEENTRIES t on t.TABLEENTRIESID = ca.TABLEENTRIESID
left join AttributeTypes at on at.ATTRIBUTETYPESID = ca.ATTRIBUTETYPESID

where lower(t.LONGDESCRIPTION) like '%mshs senior leadership'
)sl

on sl.PARENTID = RECORDS.ID


join (

select z.CONSTIT_ID,

max(case when z.r = 1 then z.num else '' end) as email1,
max(case when z.r = 1 then z.email_type else ''  end) as email_type1 ,

max(case when z.r = 2 then z.num else ''  end)as email2,
max(case when z.r = 2 then z.email_type else ''  end) as email_type2 ,

max(case when z.r = 3 then z.num else ''  end)as email3,
max(case when z.r = 3 then z.email_type else ''  end) as email_type3 ,

max(case when z.r = 4 then z.num else ''  end)as email4,
max(case when z.r = 4 then z.email_type else ''  end) as email_type4 ,

max(case when z.r = 5 then z.num else ''  end)as email5,
max(case when z.r = 5 then z.email_type else ''  end) as email_type5,

max(case when z.r = 6 then z.num else ''  end)as email6,
max(case when z.r = 6 then z.email_type else ''  end) as email_type6

from


(select f.*, ROW_NUMBER() over (partition by f.constit_id order by f.date_last_changed) as r

from

(select distinct CONSTIT_ADDRESS.CONSTIT_ID,em.NUM,em.LONGDESCRIPTION as email_type,em.DATE_LAST_CHANGED

from constit_address


join
(select CONSTIT_ADDRESS_PHONES.CONSTITADDRESSPHONESID,
CONSTIT_ADDRESS_PHONES.CONSTITADDRESSID,
CONSTIT_ADDRESS_PHONES.PHONESID,
e.num,
e.LONGDESCRIPTION,
e.DATE_LAST_CHANGED

from dbo.constit_address_phones

join
(SELECT 
QCONSTITPHONES2.PHONESID,
QCONSTITPHONES2.NUM,
QCONSTITPHONES2.DATE_LAST_CHANGED,
TABLEENTRIES.LONGDESCRIPTION

FROM 
DBO.QCONSTITPHONES2
join dbo.TABLEENTRIES on TABLEENTRIES.TABLEENTRIESID = QCONSTITPHONES2.PHONETYPEID

WHERE lower(tableentries.longdescription) like '%email%') e

on e.PHONESID = CONSTIT_ADDRESS_PHONES.PHONESID) em

on em.CONSTITADDRESSID = CONSTIT_ADDRESS.ID)f
)z

group by z.CONSTIT_ID
) has_email

on has_email.CONSTIT_ID = records.id

left join (
select ca.*,
t.LONGDESCRIPTION,
at.DESCRIPTION

 from ConstituentAttributes as ca

left join TABLEENTRIES t on t.TABLEENTRIESID = ca.TABLEENTRIESID
left join AttributeTypes at on at.ATTRIBUTETYPESID = ca.ATTRIBUTETYPESID

where lower(at.DESCRIPTION) like '%solicit%'
and lower(t.LONGDESCRIPTION) like '%email%'
and (lower(ca.COMMENTS) not like '%sanky%'
or ca.ATTRIBUTEDATE >= convert(nvarchar(MAX), '01/01/16', 101))


)sd

on sd.PARENTID = RECORDS.ID

left join (select CONSTITUENT_SOLICITCODES.*


from CONSTITUENT_SOLICITCODES

join TABLEENTRIES sc1 on sc1.TABLEENTRIESID = CONSTITUENT_SOLICITCODES.SOLICIT_CODE

where CONSTITUENT_SOLICITCODES.SOLICIT_CODE in (7528,6426)) has_no_email_sol

on has_no_email_sol.RECORDSID = RECORDS.ID




----------------Most Recent gift-----------------------
left join (select z.*

from

(select g.*,
row_number() over (partition by g.constit_id order by g.dte desc) as r

from

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
case when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][E][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Email'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][M][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Mail'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][X][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Multi-Channel'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Peer 2 Peer' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Phone' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][S][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Social Media'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][S][0-9][A-Z]%',appeal.APPEAL_ID) is NULL then ''
	else ''
end as appeal_type,


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
and appeal.APPEAL_ID  <> '-NPR'

)g
)z

where z.r = 1)lg

on lg.Constit_ID = RECORDS.ID



--------Largest Gift---------------------------
left join (select z.*

from

(select g.*,
row_number() over (partition by g.constit_id order by g.amount desc) as r

from

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
case when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][E][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Email'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][M][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Mail'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][X][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Multi-Channel'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Peer 2 Peer' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Phone' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][S][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Social Media'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][S][0-9][A-Z]%',appeal.APPEAL_ID) is NULL then ''
	else ''
end as appeal_type,


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
and appeal.APPEAL_ID  <> '-NPR')g
)z

where z.r = 1)lrg

on lrg.Constit_ID = RECORDS.ID


left join (select z.*

from

(select g.Constit_ID,
sum(g.Amount) as lifetime_gift_amt,
count(g.id) as lifetime_gift_count

--row_number() over (partition by g.constit_id order by g.amount desc) as r

from

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
case when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][E][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Email'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][M][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Mail'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][X][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Multi-Channel'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Peer 2 Peer' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Phone' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][S][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Social Media'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][S][0-9][A-Z]%',appeal.APPEAL_ID) is NULL then ''
	else ''
end as appeal_type,


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
and appeal.APPEAL_ID  <> '-NPR')g
group by g.Constit_ID

)z
)lf

on lf.Constit_ID = records.ID

left join(select distinct z.Constit_ID

from

(select *

--row_number() over (partition by g.constit_id order by g.amount desc) as r

from

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

,case when ga.PARENTID is null then 'N' else 'Y' end as is_online_gift





 from GIFT

join CONSTIT_GIFTS_BC as cg on cg.Gift_ID = gift.ID

left join dbo.GiftSplit on GiftSplit.GiftId = gift.ID


left join FUND on FUND.id = giftsplit.FundId

left join appeal on appeal.ID = GiftSplit.AppealId

left join CAMPAIGN on CAMPAIGN.ID = GiftSplit.CampaignId

left join TABLEENTRIES t on t.TABLEENTRIESID = appeal.AppealCategoryID
left join TABLEENTRIES t2 on t2.TABLEENTRIESID = gift.PAYMENT_TYPE
left join (select * from GiftAttributes where GiftAttributes.ATTRIBUTETYPESID = 144)ga on ga.PARENTID = gift.ID

where gift.TYPE in ('1','8','9','3','10','12','14','15','17','18','20','31')

and (gift.type not in ('28','32','33') OR (GIFT.TYPE IS NULL))


and CAMPAIGN.CAMPAIGN_ID <> 'NPR'
and appeal.APPEAL_ID  <> '-NPR')g


)z


where z.is_online_gift = 'Y') og

on og.constit_id = records.id

left join (select distinct z.Constit_ID

from

(select *

--row_number() over (partition by g.constit_id order by g.amount desc) as r

from

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

,case when ga.PARENTID is null then 'N' else 'Y' end as is_online_gift





 from GIFT

join CONSTIT_GIFTS_BC as cg on cg.Gift_ID = gift.ID

left join dbo.GiftSplit on GiftSplit.GiftId = gift.ID


left join FUND on FUND.id = giftsplit.FundId

left join appeal on appeal.ID = GiftSplit.AppealId

left join CAMPAIGN on CAMPAIGN.ID = GiftSplit.CampaignId

left join TABLEENTRIES t on t.TABLEENTRIESID = appeal.AppealCategoryID
left join TABLEENTRIES t2 on t2.TABLEENTRIESID = gift.PAYMENT_TYPE
left join (select * from GiftAttributes where GiftAttributes.ATTRIBUTETYPESID = 144)ga on ga.PARENTID = gift.ID

where gift.TYPE in ('1','8','9','3','10','12','14','15','17','18','20','31')

and (gift.type not in ('28','32','33') OR (GIFT.TYPE IS NULL))


and CAMPAIGN.CAMPAIGN_ID <> 'NPR'
and appeal.APPEAL_ID  <> '-NPR')g


)z


where z.appeal_category like '%direct response%')dr

on dr.Constit_ID = records.ID

left join(select distinct z.Constit_ID

from

(select *

--row_number() over (partition by g.constit_id order by g.amount desc) as r

from

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

,case when ga.PARENTID is null then 'N' else 'Y' end as is_online_gift





 from GIFT

join CONSTIT_GIFTS_BC as cg on cg.Gift_ID = gift.ID

left join dbo.GiftSplit on GiftSplit.GiftId = gift.ID


left join FUND on FUND.id = giftsplit.FundId

left join appeal on appeal.ID = GiftSplit.AppealId

left join CAMPAIGN on CAMPAIGN.ID = GiftSplit.CampaignId

left join TABLEENTRIES t on t.TABLEENTRIESID = appeal.AppealCategoryID
left join TABLEENTRIES t2 on t2.TABLEENTRIESID = gift.PAYMENT_TYPE
left join (select * from GiftAttributes where GiftAttributes.ATTRIBUTETYPESID = 144)ga on ga.PARENTID = gift.ID

where gift.TYPE in ('1','8','9','3','10','12','14','15','17','18','20','31')

and (gift.type not in ('28','32','33') OR (GIFT.TYPE IS NULL))


and CAMPAIGN.CAMPAIGN_ID <> 'NPR'
and appeal.APPEAL_ID  <> '-NPR')g


)z


where z.appeal_category like '%event%')ev

on ev.constit_id = records.id

left join (select distinct z.Constit_ID

from

(select *

--row_number() over (partition by g.constit_id order by g.amount desc) as r

from

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

,case when ga.PARENTID is null then 'N' else 'Y' end as is_online_gift





 from GIFT

join CONSTIT_GIFTS_BC as cg on cg.Gift_ID = gift.ID

left join dbo.GiftSplit on GiftSplit.GiftId = gift.ID


left join FUND on FUND.id = giftsplit.FundId

left join appeal on appeal.ID = GiftSplit.AppealId

left join CAMPAIGN on CAMPAIGN.ID = GiftSplit.CampaignId

left join TABLEENTRIES t on t.TABLEENTRIESID = appeal.AppealCategoryID
left join TABLEENTRIES t2 on t2.TABLEENTRIESID = gift.PAYMENT_TYPE
left join (select * from GiftAttributes where GiftAttributes.ATTRIBUTETYPESID = 144)ga on ga.PARENTID = gift.ID

where gift.TYPE in ('1','8','9','3','10','12','14','15','17','18','20','31')

and (gift.type not in ('28','32','33') OR (GIFT.TYPE IS NULL))


and CAMPAIGN.CAMPAIGN_ID <> 'NPR'
and appeal.APPEAL_ID  <> '-NPR')g


)z


where z.appeal_category like '%p2p%')ptp

on ptp.constit_id = records.id

left join (select distinct z.Constit_ID

from

(select *

--row_number() over (partition by g.constit_id order by g.amount desc) as r

from

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

,case when ga.PARENTID is null then 'N' else 'Y' end as is_online_gift





 from GIFT

join CONSTIT_GIFTS_BC as cg on cg.Gift_ID = gift.ID

left join dbo.GiftSplit on GiftSplit.GiftId = gift.ID


left join FUND on FUND.id = giftsplit.FundId

left join appeal on appeal.ID = GiftSplit.AppealId

left join CAMPAIGN on CAMPAIGN.ID = GiftSplit.CampaignId

left join TABLEENTRIES t on t.TABLEENTRIESID = appeal.AppealCategoryID
left join TABLEENTRIES t2 on t2.TABLEENTRIESID = gift.PAYMENT_TYPE
left join (select * from GiftAttributes where GiftAttributes.ATTRIBUTETYPESID = 144)ga on ga.PARENTID = gift.ID

where gift.TYPE in ('1','8','9','3','10','12','14','15','17','18','20','31')

and (gift.type not in ('28','32','33') OR (GIFT.TYPE IS NULL))


and CAMPAIGN.CAMPAIGN_ID <> 'NPR'
and appeal.APPEAL_ID  <> '-NPR')g


)z


where z.appeal_category like '%managed%')mg

on mg.constit_id = records.id


 left join (select y.*

from

 (select ss.*,
row_number() over (partition by ss.parentid order by ss.attributedate) as r

from

(select ca.PARENTID,

case when ca.ATTRIBUTEDATE is null then CONVERT(datetime, '01.01.2100', 103) else
ca.attributedate end as attributedate,
t.LONGDESCRIPTION,
at.DESCRIPTION

 from ConstituentAttributes as ca

left join TABLEENTRIES t on t.TABLEENTRIESID = ca.TABLEENTRIESID
left join AttributeTypes at on at.ATTRIBUTETYPESID = ca.ATTRIBUTETYPESID


where lower(at.DESCRIPTION) like '%suspect s%'
--and lower(t.LONGDESCRIPTION) like '%email%'
--and lower(ca.COMMENTS) not like '%sanky%'
--and ca.ATTRIBUTEDATE >= convert(nvarchar(MAX), '01/01/16', 101)

)ss
)y
where y.r = 1)s

on s.parentid = records.id


left join (select z.*

from

(select g.*,
row_number() over (partition by g.constit_id order by g.dte) as r

from

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
case when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][E][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Email'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][M][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Mail'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][X][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Multi-Channel'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Peer 2 Peer' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Phone' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][S][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Social Media'
	else ''
end as appeal_type,


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
and appeal.APPEAL_ID  <> '-NPR'

)g
)z

where z.r = 1)fg

on fg.Constit_ID = records.ID

left join (select CAPreferred.CONSTIT_ID,
address.id,address.ADDRESS_BLOCK,

 address.CITY "Preferred City",
 STATEs.LONGDESCRIPTION "Preferred State",
 address.POST_CODE "Preferred ZIP",
 t.LONGDESCRIPTION "Preferred County"
 

from ADDRESS

join CAPreferred  on CAPreferred.ADDRESS_ID = ADDRESS.ID 
left join dbo.states on states.SHORTDESCRIPTION = address.STATE
left join TABLEENTRIES as t on t.TABLEENTRIESID =address.COUNTY ) addr
on addr.CONSTIT_ID = RECORDS.id

left join (select  distinct z.Constit_ID

from

(select *

--row_number() over (partition by g.constit_id order by g.amount desc) as r

from

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
case when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][E][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Email'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][M][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Mail'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][X][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Multi-Channel'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Peer 2 Peer' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Phone' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][S][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Social Media'
	else ''
end as appeal_type,

CASE GIFT.PAYMENT_TYPE WHEN 1 THEN 'Cash' WHEN 2 THEN 'Personal Check' WHEN 3 THEN 'Business Check' WHEN 4 THEN 'Credit Card' WHEN 6 THEN 'Direct Debit' WHEN 8 THEN 'Other' ELSE '' END  "Gift Payment Type"

,case when ga.PARENTID is null then 'N' else 'Y' end as is_online_gift





 from GIFT

join CONSTIT_GIFTS_BC as cg on cg.Gift_ID = gift.ID

left join dbo.GiftSplit on GiftSplit.GiftId = gift.ID


left join FUND on FUND.id = giftsplit.FundId

left join appeal on appeal.ID = GiftSplit.AppealId

left join CAMPAIGN on CAMPAIGN.ID = GiftSplit.CampaignId

left join TABLEENTRIES t on t.TABLEENTRIESID = appeal.AppealCategoryID
left join TABLEENTRIES t2 on t2.TABLEENTRIESID = gift.PAYMENT_TYPE
left join (select * from GiftAttributes where GiftAttributes.ATTRIBUTETYPESID = 144)ga on ga.PARENTID = gift.ID

where gift.TYPE in ('1','8','9','3','10','12','14','15','17','18','20','31')

and (gift.type not in ('28','32','33') OR (GIFT.TYPE IS NULL))


and CAMPAIGN.CAMPAIGN_ID <> 'NPR'
and appeal.APPEAL_ID  <> '-NPR')g


)z


where z.appeal_type like '%email%')eg on eg.constit_id = records.id

left join (select b.constit_id,
max(case when b.r= 1 then b.longdescription else '' end) constituent_code1,
max(case when b.r= 2 then b.longdescription else '' end) constituent_code2,
max(case when b.r= 3 then b.longdescription else '' end) constituent_code3

from

(select CONSTITUENT_CODES.*,c1.LONGDESCRIPTION,
row_number() over (partition by constit_id order by  constituent_codes.sequence) as r

 from CONSTITUENT_CODES


join TABLEENTRIES c1 on c1.TABLEENTRIESID = CONSTITUENT_CODES.CODE)b

group by b.CONSTIT_ID)cons

on cons.constit_id = records.id

left join (SELECT 
 T_1.RELATION_ID "PRIMARY_CONTACT_CONSTITUENT_ID",
 T_2.FIRST_NAME as PRIMARY_CONTACT_FIRST_NAME,
 T_2.LAST_NAME as PRIMARY_CONTACT_LAST_NAME,
 RECORDS.ID as r2

FROM 
DBO.RECORDS AS RECORDS INNER JOIN DBO.QUERY_IND_RELATIONSHIPS AS T_1 ON RECORDS.ID = T_1.CONSTIT_ID LEFT OUTER JOIN DBO.RECORDS AS T_2 ON T_1.RELATION_ID = T_2.ID

WHERE 
RECORDS.KEY_INDICATOR  =   'O'  

AND T_1.CONTACT_TYPE  =  4722 
AND T_1.IS_CONTACT  =  -1)ct 

 on ct.r2 = records.id

left join (select y.*

from

 (select ss.*,
row_number() over (partition by ss.parentid order by ss.attributedate) as r

from

(select ca.PARENTID,

case when ca.ATTRIBUTEDATE is null then CONVERT(datetime, '01.01.2100', 103) else
ca.attributedate end as attributedate,
t.LONGDESCRIPTION,
at.DESCRIPTION

 from ConstituentAttributes as ca

left join TABLEENTRIES t on t.TABLEENTRIESID = ca.TABLEENTRIESID
left join AttributeTypes at on at.ATTRIBUTETYPESID = ca.ATTRIBUTETYPESID


where lower(at.DESCRIPTION) like '%patient%'
and lower(t.LONGDESCRIPTION) like '%nega%'


)ss
)y)pxn

on pxn.PARENTID = RECORDS.ID

left join (select y.*

from

 (select ss.*,
row_number() over (partition by ss.parentid order by ss.attributedate) as r

from

(select ca.PARENTID,

case when ca.ATTRIBUTEDATE is null then CONVERT(datetime, '01.01.2100', 103) else
ca.attributedate end as attributedate,
t.LONGDESCRIPTION,
at.DESCRIPTION

 from ConstituentAttributes as ca

left join TABLEENTRIES t on t.TABLEENTRIESID = ca.TABLEENTRIESID
left join AttributeTypes at on at.ATTRIBUTETYPESID = ca.ATTRIBUTETYPESID




where lower(at.DESCRIPTION) like '%patient%'
and lower(t.LONGDESCRIPTION) not like '%nega%'


)ss
)y
where y.r = 1)px

on px.parentid = records.id

left join (select 

d.CONSTIT_ID,
MAX(case when d.r = 1 then d.FIRST_NAME + ' '+ d.LAST_NAME end) as SOLICITOR1_NAME,
MAX(case when d.r = 1 then d.solicitor_type end) as SOLICITOR1_TYPE,
MAX(case when d.r = 2 then d.FIRST_NAME + ' '+ d.LAST_NAME end) as SOLICITOR2_NAME,
MAX(case when d.r = 2 then d.solicitor_type end) as SOLICITOR2_TYPE,
MAX(case when d.r = 3 then d.FIRST_NAME + ' '+ d.LAST_NAME end) as SOLICITOR3_NAME,
MAX(case when d.r = 3 then d.solicitor_type end) as SOLICITO3R_TYPE

from


(select 
cs.ID,
cs.CONSTIT_ID,
cs.DATE_FROM,
cs.DATE_TO,
cs.SOLICITOR_ID,
r1.FIRST_NAME,
r1.LAST_NAME,
t6.LONGDESCRIPTION as SOLICITOR_TYPE,
row_number() over (partition by cs.constit_id order by cs.date_from) as r


 from CONSTIT_SOLICITORS as cs

 left join TABLEENTRIES as t6 on t6.TABLEENTRIESID = cs.SOLICITOR_TYPE
 left join RECORDS as r1 on r1.id = cs.SOLICITOR_ID

 where lower(t6.LONGDESCRIPTION) not like '%former%'
 and lower(t6.LONGDESCRIPTION) not like '%lybunt%'
 and lower(t6.LONGDESCRIPTION) not like '%physician%'
 and lower(t6.LONGDESCRIPTION) not like '%potential%'
 )d

 group by d.CONSTIT_ID
 )ss

 on ss.constit_id = records.id

 left join  (select 

cs.CONSTIT_ID,
t5.LONGDESCRIPTION,
r3.FIRST_NAME,
r3.LAST_NAME


from CONSTIT_SOLICITORS cs

join records r3 on cs.SOLICITOR_ID = r3.ID

left join TABLEENTRIES t5 on t5.TABLEENTRIESID = cs.SOLICITOR_TYPE
where (cs.SOLICITOR_TYPE in (2491,6374,8735,6620)
and  cs.DATE_TO is null
)

)pm

on pm.constit_id = records.id

left join (select z.*

from

(select g.Constit_ID,
sum(g.Amount) as lifetime_gift_amt,
count(g.id) as lifetime_gift_count

--row_number() over (partition by g.constit_id order by g.amount desc) as r

from

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
case when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][E][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Email'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][M][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Mail'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][X][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Multi-Channel'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Peer 2 Peer' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][T][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Phone' 
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][S][0-9][A-Z]%',appeal.APPEAL_ID) = 1 then 'Social Media'
	when PATINDEX('[0-9][0-9][A-Z][A-Z][0-9][0-9][S][0-9][A-Z]%',appeal.APPEAL_ID) is NULL then ''
	else ''
end as appeal_type,


CASE GIFT.PAYMENT_TYPE WHEN 1 THEN 'Cash' WHEN 2 THEN 'Personal Check' WHEN 3 THEN 'Business Check' WHEN 4 THEN 'Credit Card' WHEN 6 THEN 'Direct Debit' WHEN 8 THEN 'Other' ELSE '' END  "Gift Payment Type"





 from GIFT

join CONSTIT_GIFTS_DC as cg on cg.Gift_ID = gift.ID

left join dbo.GiftSplit on GiftSplit.GiftId = gift.ID


left join FUND on FUND.id = giftsplit.FundId

left join appeal on appeal.ID = GiftSplit.AppealId

left join CAMPAIGN on CAMPAIGN.ID = GiftSplit.CampaignId

left join TABLEENTRIES t on t.TABLEENTRIESID = appeal.AppealCategoryID
left join TABLEENTRIES t2 on t2.TABLEENTRIESID = gift.PAYMENT_TYPE

where gift.TYPE in ('1','8','9','3','10','12','14','15','17','18','20','31')

and (gift.type not in ('28','32','33') OR (GIFT.TYPE IS NULL))

and CAMPAIGN.CAMPAIGN_ID <> 'NPR'
and appeal.APPEAL_ID  <> '-NPR')g
group by g.Constit_ID

)z
)hlf

on hlf.Constit_ID = records.ID

left join QUERY_IND_RELATIONSHIPS qr on qr.CONSTIT_ID = RECORDS.ID

where records.IS_CONSTITUENT = -1
--and records.KEY_INDICATOR = 'I'
and records.DECEASED = 0
and nc.RECORDSID is null
and snc.CONSTIT_ID is null
and cc.CONSTIT_ID is null
and scc.CONSTIT_ID is null
and pe.PARENTID is null
and sl.PARENTID is null
and sd.PARENTID is null
and pxn.PARENTID is null
--and pm.CONSTIT_ID is null
and records.CONSTITUENT_ID in('51705',
'2927',
'7380',
'8966',
'906114',
'908882',
'23261',
'32207',
'35774',
'40339',
'42434',
'42978',
'324682',
'43053',
'53080',
'63650',
'409190',
'153326',
'169702',
'209830',
'352164',
'396214',
'368608',
'393518',
'398593',
'398594',
'425429',
'1923',
'2945',
'3653',
'3960',
'4247',
'8642',
'14579',
'586926',
'617753',
'621616',
'903001',
'402621',
'147807',
'325213',
'197155',
'29480',
'29800',
'30943',
'401000',
'31253',
'32788',
'147593',
'47596',
'398380',
'397600',
'147651',
'421124',
'69108',
'70020',
'120542',
'143204',
'153242',
'370226',
'168011',
'414923',
'188469',
'385365',
'191653',
'402579',
'195045',
'195067',
'195440',
'196097',
'397797',
'208715',
'208753',
'343895',
'345745',
'346303',
'396028',
'401325',
'349678',
'351544',
'353524',
'397172',
'397964',
'397968',
'399312',
'409803',
'408324',
'413106',
'13592',
'45813',
'64223',
'464',
'42697',
'357863',
'906231',
'413995',
'197069',
'49292',
'140751',
'170152',
'197176',
'229304',
'258576',
'338700',
'399554',
'153478',
'900970',
'900971',
'902500',
'903245',
'422371',
'18645',
'197151',
'18668',
'25332',
'26395',
'43290',
'401273',
'51039',
'121102',
'143709',
'168831',
'317148',
'413971',
'407021',
'13631',
'169289',
'402537',
'650055',
'905547',
'906884',
'907118',
'372864',
'30560',
'424833',
'35333',
'36622',
'41360',
'53298',
'65645',
'67758',
'69748',
'385920',
'334651',
'346676',
'370748',
'353165',
'397447',
'397950',
'397951',
'398271',
'401170',
'413100',
'421527',
'624886',
'22482',
'37631',
'53316',
'65398',
'160903',
'119295',
'140869',
'149935',
'167430',
'324961',
'335873',
'403105',
'338975',
'363416',
'404559',
'208746',
'632',
'9155',
'13547',
'70091',
'52160',
'67576',
'174413',
'419164',
'396535',
'143255',
'325164',
'419395',
'401267',
'147851',
'412924',
'398877',
'154759',
'411928',
'395528',
'419928',
'238399',
'419564',
'399965',
'403860',
'418130',
'825',
'6219',
'6424',
'8292',
'10176',
'40733',
'400076',
'521543',
'906469',
'18579',
'420323',
'324706',
'29711',
'29665',
'36944',
'38152',
'38745',
'45973',
'197103',
'196297',
'66488',
'67564',
'115299',
'355932',
'141186',
'427214',
'147873',
'160488',
'169512',
'174447',
'414556',
'187239',
'196041',
'197861',
'331785',
'342237',
'369007',
'385456',
'398237',
'412245',
'402280',
'406952',
'402473',
'403782',
'403877',
'404465',
'405047',
'413759',
'415192',
'417015',
'417019',
'417076',
'417080',
'417083',
'417086',
'419769',
'419789',
'420224',
'420225',
'420231',
'420233',
'427482',
'6217',
'16765',
'380238',
'620302',
'902456',
'903332',
'401283',
'16162',
'25531',
'116690',
'30390',
'197108',
'31169',
'35499',
'397805',
'35515',
'37308',
'412573',
'39906',
'40007',
'46558',
'62995',
'49577',
'51215',
'51843',
'57251',
'57156',
'64264',
'65650',
'413031',
'67774',
'197040',
'121999',
'140013',
'140233',
'415363',
'152902',
'154405',
'183508',
'195840',
'195841',
'208479',
'240550',
'321418',
'334507',
'339613',
'342654',
'392922',
'413199',
'413484',
'414470',
'417834',
'420708',
'407391',
'2855',
'3585',
'5795',
'7379',
'11092',
'15396',
'507866',
'540852',
'568805',
'577875',
'900875',
'900952',
'904452',
'904512',
'907020',
'909112',
'909873',
'197135',
'403215',
'356977',
'402488',
'23430',
'27804',
'34466',
'35627',
'38602',
'376603',
'50115',
'56131',
'356117',
'60181',
'423458',
'64816',
'64817',
'65658',
'141431',
'147409',
'154104',
'154791',
'161796',
'168858',
'171552',
'172194',
'173720',
'186852',
'418369',
'192342',
'195151',
'196390',
'212990',
'246341',
'272382',
'272383',
'315412',
'328856',
'329298',
'329599',
'333409',
'370613',
'339632',
'339828',
'342114',
'342409',
'342552',
'350424',
'351149',
'352696',
'353403',
'399448',
'364121',
'397512',
'409771',
'409810',
'412127',
'412128',
'413603',
'414096',
'415607',
'415881',
'415995',
'416520',
'418600',
'418843',
'419743',
'419999',
'420001',
'420235',
'420236',
'420431',
'420432',
'421024',
'421200',
'421244',
'421514',
'421725',
'422323',
'422472',
'425264',
'425269')
 


--and RECORDS.CONSTITUENT_ID = '568805'

--and lower(fg.appeal_description) like '%tribute%'
