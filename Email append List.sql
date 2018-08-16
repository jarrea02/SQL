select
records.CONSTITUENT_ID,
records.FIRST_NAME,
records.LAST_NAME,

REPLACE(REPLACE(addr.ADDRESS_BLOCK, CHAR(13), '|'), CHAR(10), '|') as address_block,
addr.[Preferred City],
addr.[Preferred State],
addr.[Preferred ZIP]

from  dbo.records
left join
(
select * from constit_address


join
(select CONSTIT_ADDRESS_PHONES.CONSTITADDRESSPHONESID,
CONSTIT_ADDRESS_PHONES.CONSTITADDRESSID,
CONSTIT_ADDRESS_PHONES.PHONESID,
e.num,
e.LONGDESCRIPTION


 from dbo.constit_address_phones

join
(SELECT 
QCONSTITPHONES2.PHONESID,
QCONSTITPHONES2.NUM,
TABLEENTRIES.LONGDESCRIPTION

FROM 
DBO.QCONSTITPHONES2
join dbo.TABLEENTRIES on TABLEENTRIES.TABLEENTRIESID = QCONSTITPHONES2.PHONETYPEID

WHERE lower(tableentries.longdescription) like '%email%') e

on e.PHONESID = CONSTIT_ADDRESS_PHONES.PHONESID) em

on em.CONSTITADDRESSID = CONSTIT_ADDRESS.ID)has_email

on has_email.CONSTIT_ID = records.id

left join (select * from dbo.CONSTITUENT_SOLICITCODES
where CONSTITUENT_SOLICITCODES.SOLICIT_CODE in (3660,16811))
s

on s.RECORDSID = records.ID

left join(SELECT 
 ConstituentAttributes.TABLEENTRIESID,
  ConstituentAttributes.PARENTID,
TABLEENTRIES.LongDESCRIPTION, 
TABLEENTRIES.SEQUENCE

FROM 
DBO.ConstituentAttributes LEFT OUTER JOIN DBO.TABLEENTRIES ON ConstituentAttributes.TABLEENTRIESID = TABLEENTRIES.TABLEENTRIESID

WHERE 
ATTRIBUTETYPESID  =  123 
and ConstituentAttributes.TABLEENTRIESID = 15558)pe

on pe.PARENTID = records.ID

left join (select CAPreferred.CONSTIT_ID,
address.id,address.ADDRESS_BLOCK,

 address.CITY "Preferred City",
 STATEs.LONGDESCRIPTION "Preferred State",
 address.POST_CODE "Preferred ZIP"
 

from ADDRESS

join CAPreferred  on CAPreferred.ADDRESS_ID = ADDRESS.ID 
left join dbo.states on states.SHORTDESCRIPTION = address.STATE) addr
on addr.CONSTIT_ID = RECORDS.id

where has_email.num is null
and s.RECORDSID is null
and pe.PARENTID is null
and addr.ADDRESS_BLOCK is not null
and records.IS_CONSTITUENT = -1
and records.KEY_INDICATOR = 'I'
and records.DECEASED = 0
and records.NO_VALID_ADDRESSES = 0