select 
r.CONSTITUENT_ID,
r.IMPORT_ID,
r.LAST_NAME,
r.FIRST_NAME,
r.ORG_NAME,
ca.CONSTIT_ID as system_id,

ca.APPEAL_ID,
ca.DTE,
ca.Response,
t.LONGDESCRIPTION,
aa.DESCRIPTION,
aa.APPEAL_ID,
aa.appeal_site








from CONSTITUENT_APPEALS ca

join TABLEENTRIES t on t.TABLEENTRIESID = ca.Response
join RECORDS r on r.ID = ca.CONSTIT_ID

left join 
(SELECT 
 ConstituentAttributes.TABLEENTRIESID "TABLEENTRIESID",
 ConstituentAttributes.IMPORTID, 
ConstituentAttributes.PARENTID, 
ConstituentAttributes.ATTRIBUTEDATE, 
ConstituentAttributes.COMMENTS, 
TABLEENTRIES.LongDESCRIPTION, 
TABLEENTRIES.SHORTDESCRIPTION, 
TABLEENTRIES.SEQUENCE

FROM 
DBO.ConstituentAttributes LEFT OUTER JOIN DBO.TABLEENTRIES ON ConstituentAttributes.TABLEENTRIESID = TABLEENTRIES.TABLEENTRIESID

WHERE 
ATTRIBUTETYPESID  =  123)pe

on pe.PARENTID = r.id

join (select a.APPEAL_ID,
a.DESCRIPTION,
a.id,
a.START_DATE,
a.END_DATE,
a.AppealCategoryID,
a.DEFAULT_FUND,
t.LONGDESCRIPTION as appeal_site


 from DBO.APPEAL as a

join AppealAttributes at on at.PARENTID =  a.ID
join TABLEENTRIES t on t.TABLEENTRIESID = at.TABLEENTRIESID


where a.APPEAL_ID  like '%Q%'
and lower(a.DESCRIPTION) like '%patient%'
--and a.START_DATE >= cast('01/01/15' as date)
)aa

on aa.ID = ca.APPEAL_ID 


where pe.PARENTID is null
and r.KEY_INDICATOR = 'I'
and r.IS_CONSTITUENT = -1

order by ca.DTE