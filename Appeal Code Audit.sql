select 

a.Import_ID APPEAL_IMPORT_ID,
a.APPEAL_ID,
a.DESCRIPTION,
sit.IMPORTID APPEAL_SITE_IMPORT_ID,
sit.LONGDESCRIPTION as APPEAL_SITE,
--APPEAL SITE ATTRIBUTE
t1.LONGDESCRIPTION APPEAL_CATEGORY,





c.CAMPAIGN_ID,

f.FUND_ID DEFAULT_FUND_NUMBER,

a.START_DATE,
a.END_DATE,
a.NO_SOLICITED,
ur.IMPORTID as URL_IMPORT_ID,
ur.ATTRDESCRIPTION as URL_DESCRIPTION,
sanky.IMPORTID as SANKY_IMPORT_ID,
case when sanky.ATTRDESCRIPTION = 0 then 'No' 
	 when sanky.ATTRDESCRIPTION = -1 then 'Yes'
	 else '' 

end as MANAGED_BY_SANKY,
a.NOTES,
a.DATEADDED,
a.DATECHANGED



from appeal a

left join CAMPAIGN c on c.ID = a.CAMPAIGN_ID
left join FUND f on f.id = a.DEFAULT_FUND
left join TABLEENTRIES t1 on t1.TABLEENTRIESID = a.AppealCategoryID

left join (SELECT 
 APPEALATTRIBUTES.BOOLEAN "ATTRDESCRIPTION",
 APPEALATTRIBUTES.IMPORTID, 
APPEALATTRIBUTES.PARENTID, 
APPEALATTRIBUTES.ATTRIBUTEDATE, 
APPEALATTRIBUTES.COMMENTS 

FROM 
DBO.APPEALATTRIBUTES

WHERE 
ATTRIBUTETYPESID  =  448 )sanky on sanky.PARENTID = a.ID


left join
(SELECT 
 APPEALATTRIBUTES.TABLEENTRIESID "TABLEENTRIESID",
 APPEALATTRIBUTES.IMPORTID, 
APPEALATTRIBUTES.PARENTID, 
APPEALATTRIBUTES.ATTRIBUTEDATE, 
APPEALATTRIBUTES.COMMENTS, 
TABLEENTRIES.LongDESCRIPTION, 
TABLEENTRIES.SHORTDESCRIPTION, 
TABLEENTRIES.SEQUENCE

FROM 
DBO.APPEALATTRIBUTES LEFT OUTER JOIN DBO.TABLEENTRIES ON APPEALATTRIBUTES.TABLEENTRIESID = TABLEENTRIES.TABLEENTRIESID

WHERE 
ATTRIBUTETYPESID  =  427)sit on sit.PARENTID = a.ID

left join
(SELECT 
 APPEALATTRIBUTES.TEXT "ATTRDESCRIPTION",
 APPEALATTRIBUTES.IMPORTID, 
APPEALATTRIBUTES.PARENTID, 
APPEALATTRIBUTES.ATTRIBUTEDATE, 
APPEALATTRIBUTES.COMMENTS 

FROM 
DBO.APPEALATTRIBUTES

WHERE 
ATTRIBUTETYPESID  =  362 )ur on ur.PARENTID = a.ID

where a.DATEADDED >= cast('01/01/2018' as datetime)
and t1.LONGDESCRIPTION like '%Direct%'
and a.NO_SOLICITED = 0
and a.DESCRIPTION like '%Renewal%'

order by a.DATEADDED