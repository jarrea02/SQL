With tbl1 as
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
ATTRIBUTETYPESID  =  123  ),

gg as

(select Gift.* from Gift
join CONSTIT_GIFTS_DC on CONSTIT_GIFTS_DC.Gift_ID = GIFT.ID),


pp as
(Select t2.* from 

(select dbo.participants.*,
row_number() over (partition by RecordsID order by DateAdded desc) as r 

from dbo.Participants)t2

where t2.r = 1)






SELECT 
 RECORDS.CONSTITUENT_ID "Constituent ID",
 Records.IMPORT_ID,
 --DBO.Query_ConstitName(4,RECORDS.LAST_NAME,RECORDS.FIRST_NAME,RECORDS.MIDDLE_NAME,RECORDS.ORG_NAME,RECORDS.KEY_INDICATOR,RECORDS.CONSTITUENT_ID) "Name",
 T_1.EVENTID "Event ID",
 T_1.NAME "Event Name",
 RECORDS.ID "QRECID"

FROM 
DBO.RECORDS AS RECORDS 
LEFT OUTER JOIN gg AS RECORDS_GIFT ON RECORDS.ID = RECORDS_GIFT.CONSTIT_ID 
LEFT OUTER JOIN pp AS RECORDS_PARTICIPANTS ON RECORDS.ID = RECORDS_PARTICIPANTS.RECORDSID 
LEFT OUTER JOIN DBO.SPECIAL_EVENT AS T_1 ON RECORDS_PARTICIPANTS.EVENTID = T_1.ID 
LEFT OUTER JOIN DBO.CONSTITUENT_CODES AS RECORDS_CONSTITUENT_CODES ON RECORDS.ID = RECORDS_CONSTITUENT_CODES.CONSTIT_ID 
LEFT OUTER JOIN tbl1 AS T_2_0_123 ON RECORDS.ID = T_2_0_123.PARENTID

WHERE 

RECORDS_GIFT.Amount IS NULL 
AND T_1.ID IS NOT NULL
 AND RECORDS_CONSTITUENT_CODES.CODE  =  307 
 AND T_2_0_123.TABLEENTRIESID IS NULL
 AND (RECORDS.IS_CONSTITUENT  =  -1)
  