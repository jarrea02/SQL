with t1 as
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
ATTRIBUTETYPESID  =  5  ),

t2 as

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
ATTRIBUTETYPESID  =  123)



SELECT 
 ORECORDS.CONSTITUENT_ID "Constituent ID",
 ORECORDS.ID "QRECID" 

FROM 
DBO.RECORDS AS ORECORDS  

WHERE 
EXISTS (SELECT 
 RECORDS.ID "QRECID" FROM 
DBO.RECORDS AS RECORDS 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 20226) AS RECORDS_V_QCONSTITPHONES2_24_20226 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_20226.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 20233)  AS RECORDS_V_QCONSTITPHONES2_24_20233 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_20233.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 7646)  AS RECORDS_V_QCONSTITPHONES2_24_7646 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_7646.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 3898)  AS RECORDS_V_QCONSTITPHONES2_24_3898 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_3898.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 7564)  AS RECORDS_V_QCONSTITPHONES2_24_7564 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_7564.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 15781)  AS RECORDS_V_QCONSTITPHONES2_24_15781 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_15781.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 707)  AS RECORDS_V_QCONSTITPHONES2_24_707 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_707.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 7523)  AS RECORDS_V_QCONSTITPHONES2_24_7523 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_7523.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 19487)  AS RECORDS_V_QCONSTITPHONES2_24_19487 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_19487.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 7518)  AS RECORDS_V_QCONSTITPHONES2_24_7518 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_7518.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 5453)  AS RECORDS_V_QCONSTITPHONES2_24_5453 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_5453.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 4800)  AS RECORDS_V_QCONSTITPHONES2_24_4800 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_4800.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 3081)  AS RECORDS_V_QCONSTITPHONES2_24_3081 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_3081.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 20479)  AS RECORDS_V_QCONSTITPHONES2_24_20479 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_20479.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 20599)  AS RECORDS_V_QCONSTITPHONES2_24_20599 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_20599.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 21998)  AS RECORDS_V_QCONSTITPHONES2_24_19798 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_19798.CONSTIT_ID 
LEFT OUTER JOIN (select * from dbo.QCONSTITPHONES2 where PHONETYPEID = 8711)  AS RECORDS_V_QCONSTITPHONES2_24_8711 ON RECORDS.ID = RECORDS_V_QCONSTITPHONES2_24_8711.CONSTIT_ID 
LEFT OUTER JOIN DBO.QSPOUSE AS Records_QSpouse ON RECORDS.SPOUSE_ID = Records_QSpouse.ID 
LEFT OUTER JOIN DBO.CONSTITUENT_CODES AS T_1 ON Records_QSpouse.ID = T_1.CONSTIT_ID 
LEFT OUTER JOIN t2 AS T_2_0_123 ON RECORDS.ID = T_2_0_123.PARENTID 
LEFT OUTER JOIN DBO.CONSTITUENT_CODES AS RECORDS_CONSTITUENT_CODES ON RECORDS.ID = RECORDS_CONSTITUENT_CODES.CONSTIT_ID 
LEFT OUTER JOIN DBO.CONSTITUENT_SOLICITCODES AS T_3 ON Records_QSpouse.ID = T_3.RECORDSID 
LEFT OUTER JOIN DBO.CONSTITUENT_SOLICITCODES AS T_4 ON RECORDS.ID = T_4.RECORDSID 
LEFT OUTER JOIN t1 AS T_5_0_5 ON RECORDS.ID = T_5_0_5.PARENTID 
LEFT OUTER JOIN DBO.CONSTIT_SOLICITORS AS T_6 ON RECORDS.ID = T_6.CONSTIT_ID
WHERE 
((((RECORDS_V_QCONSTITPHONES2_24_20226.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_20233.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_7646.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_3898.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_7564.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_15781.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_707.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_7523.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_19487.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_7518.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_5453.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_4800.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_3081.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_20479.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_20599.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_19798.NUM IS NOT NULL) 
OR (RECORDS_V_QCONSTITPHONES2_24_8711.NUM IS NOT NULL)) 
AND T_1.CODE IN (317,312,16873,16466,310,6532,17852,17853,17854,301,7613,309,297,7841,7842,20214,20314,17015,20570,16461,20569,20568,15760,16465,7843,299,15032,15033,6464,300,304,305,306,7703,7708,6465,16932,16456) 
OR T_2_0_123.TABLEENTRIESID  =  15558 
OR RECORDS_CONSTITUENT_CODES.CODE IN (317,312,16873,16466,310,6532,17852,17853,17854,301,7613,309,297,7841,7842,20214,20314,17015,20570,16461,20569,20568,15760,16465,305,306,7703,7708,6465,16932,16456,304,300,6464,15033,15032,299,7843) 
OR T_3.SOLICIT_CODE IN (3660,16811,7528) 
OR T_4.SOLICIT_CODE IN (3660,16811,7528) 
OR RECORDS.INACTIVE  =  -1 
OR RECORDS.DECEASED  =  -1 
OR T_5_0_5.TABLEENTRIESID  =  8802
OR T_6.SOLICITOR_TYPE IN (6374,2491))
AND (RECORDS.IS_CONSTITUENT  =  -1))   
AND ORECORDS.ID  =  RECORDS.ID)