with tmp1 as
(SELECT 
 ActionAttributes.DATETIME "ATTRDESCRIPTION",
 ActionAttributes.IMPORTID, 
ActionAttributes.PARENTID, 
ActionAttributes.ATTRIBUTEDATE, 
ActionAttributes.COMMENTS

FROM 
DBO.ActionAttributes

WHERE 
ATTRIBUTETYPESID  =  425 ),

tmp2 as
(SELECT 
 ActionAttributes.CONSTITID "CONSTITID",
 ActionAttributes.IMPORTID, 
ActionAttributes.PARENTID, 
ActionAttributes.ATTRIBUTEDATE, 
ActionAttributes.COMMENTS, 
--DBO.BuildFullName2(ActionAttributes.CONSTITID) "ATTRDESCRIPTION"
CONCAT(rr.FIRST_NAME,' ',rr.LAST_NAME) as Name

FROM 
DBO.ActionAttributes INNER JOIN DBO.ACTIONS ON ActionAttributes.PARENTID = ACTIONS.ID
left join RECORDS rr on rr.ID = ActionAttributes.ConstitID

WHERE 
ATTRIBUTETYPESID  =  187),

tmp3 as
(SELECT 
 ActionAttributes.DATETIME "ATTRDESCRIPTION",
 ActionAttributes.IMPORTID, 
ActionAttributes.PARENTID, 
ActionAttributes.ATTRIBUTEDATE, 
ActionAttributes.COMMENTS 

FROM 
DBO.ActionAttributes

WHERE 
ATTRIBUTETYPESID  =  188  ),

tmp4 as
(SELECT 
 ActionAttributes.TABLEENTRIESID "TABLEENTRIESID",
 ActionAttributes.IMPORTID, 
ActionAttributes.PARENTID, 
ActionAttributes.ATTRIBUTEDATE, 
ActionAttributes.COMMENTS, 
TABLEENTRIES.LongDESCRIPTION, 
TABLEENTRIES.SHORTDESCRIPTION, 
TABLEENTRIES.SEQUENCE

FROM 
DBO.ActionAttributes LEFT OUTER JOIN DBO.TABLEENTRIES ON ActionAttributes.TABLEENTRIESID = TABLEENTRIES.TABLEENTRIESID

WHERE 
ATTRIBUTETYPESID  =  189  ),

tmp5 as

((select t1.action_id,


replace(rtrim (CONCAT(max(case when t1.rn = 1 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME) end),'  ',
		max(case when t1.rn = 2 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 3 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 4 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 5 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 6 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 7 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 8 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 9 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME)end),'  ',
		max(case when t1.rn = 10 then concat(t1.FIRST_NAME,' ',t1.LAST_NAME) end))),'  ',', ')  solicitor_list



from

(select 
r2.id,
r2.CONSTITUENT_ID "Constituent ID",
 r2.FIRST_NAME,
 r2.LAST_NAME,
acs.ACTION_ID,
ROW_NUMBER() over (partition by acs.action_id order by  r2.last_name) rn
from records r2
left join ACTION_SOLICITOR acs on acs.RECORDS_ID = r2.ID

where acs.ACTION_ID is not null)t1

group by t1.ACTION_ID)

)


SELECT
 ACTIONS_RECORDS.ID "Records System ID",
 ACTIONS_RECORDS.CONSTITUENT_ID "Constituent ID",
 ACTIONS.IMPORT_ID "Action Import ID",
 ACTIONS.DateAdded "Action Date Added",

 ACTIONS_TYPE.LONGDESCRIPTION "Action Type",


tmp5.solicitor_list as "Requested By",
 T_2_0_425.ATTRDESCRIPTION "Action Specific Attributes Research Req_ Deadline Description",

 T_3_0_187.Name "Res Assigned To",

T_4_0_188.ATTRDESCRIPTION "Res Assigned Date",
 T_5_0_189.LONGDESCRIPTION "Res Type Requested",

 ACTIONS.COMPLETED_DATE "Action Completed On",
 ACTIONS.ID "Action System ID"

FROM 
DBO.ACTIONS AS ACTIONS 
LEFT OUTER JOIN DBO.RECORDS AS ACTIONS_RECORDS ON ACTIONS.RECORDS_ID = ACTIONS_RECORDS.ID 
LEFT OUTER JOIN DBO.TABLEENTRIES AS ACTIONS_TYPE ON ACTIONS.TYPE = ACTIONS_TYPE.TABLEENTRIESID 
LEFT OUTER JOIN DBO.ACTION_SOLICITOR AS ACTIONS_ACTION_SOLICITOR ON ACTIONS.ID = ACTIONS_ACTION_SOLICITOR.ACTION_ID 
LEFT OUTER JOIN DBO.RECORDS AS T_1 ON ACTIONS_ACTION_SOLICITOR.RECORDS_ID = T_1.ID 
LEFT OUTER JOIN tmp1 AS T_2_0_425 ON ACTIONS.ID = T_2_0_425.PARENTID 
LEFT OUTER JOIN tmp2 AS T_3_0_187 ON ACTIONS.ID = T_3_0_187.PARENTID 
LEFT OUTER JOIN tmp3 AS T_4_0_188 ON ACTIONS.ID = T_4_0_188.PARENTID 
LEFT OUTER JOIN tmp4 AS T_5_0_189 ON ACTIONS.ID = T_5_0_189.PARENTID
left join tmp5 on tmp5.ACTION_ID = ACTIONS.ID


WHERE 
((ACTIONS.DTE >=  CAST('1/1/2017' AS DATETIME)))  

ORDER BY 
CAST(ACTIONS.DateAdded AS DATETIME), ACTIONS.DTE