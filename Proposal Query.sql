select 
records.CONSTITUENT_ID,
Proposal.IMPORT_ID,
Proposal.id,
Proposal.ORIGINAL_AMOUNT_ASKED,
PROPOSAL.AMOUNT_ASKED,
PROPOSAL.AMOUNT_EXPECTED,

convert(nvarchar(MAX),Proposal.ORIGINAL_DATE_ASKED,101) as original_date_asked,
convert(nvarchar(MAX),Proposal.DATE_ADDED,101) as orginial_date_added,
pp.IMPORTID as attribute_import_id,
pp.ATTRIBUTEDATE,
pp.CURRENCY,


u1.NAME as added_by,
U2.NAME as last_changed_by


from PROPOSAL

--Where DATE_ADDED >= convert(nvarchar(MAX),a2.old_action_date_ACDate,101)


left join(


select t2.*
from
(select t1.*,
ROW_NUMBER() over (partition by t1.parentid order by t1.sequence desc) as r
from
(select pa.*
from PROPOSALATTRIBUTES as pa


where pa.ATTRIBUTETYPESID = 531)t1
)t2

where t2.r = 1
)pp on pp.PARENTID = PROPOSAL.ID
join USERS as u1 on u1.USER_ID = PROPOSAL.ADDED_BY
join USERS as u2 on u2.USER_ID = Proposal.LAST_CHANGED_BY
join DBO.PROSPECT on PROSPECT.ID = Proposal.PROSPECT_ID
join records on RECORDS.ID = Prospect.CONSTIT_ID 

where PROPOSAL.DATE_ADDED >= convert(nvarchar(MAX),'01/01/2018',101)

and pp.PARENTID is not null
and pp.CURRENCY <> proposal.AMOUNT_ASKED
order by constituent_id,PROPOSAL.DATE_ADDED