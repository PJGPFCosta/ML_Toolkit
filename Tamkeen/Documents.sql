-- How to know that this is a document and from where
with cte as(
	select  anno.ObjectTypeCode as annoObtc, anno.Subject, anno.ObjectId as objectIdAnno, anno.IsDocument,--annoations
			potc.ObjectTypeCode as potcObtcm, potc.PrivilegeId as potcPrivilegeId, --PrivilegeObjectTypeCodes
			pb.PrivilegeId,pb.Name -- Privilege
	from AnnotationBase anno
	join PrivilegeObjectTypeCodes potc on potc.ObjectTypeCode=anno.ObjectTypeCode
	join PrivilegeBase pb on pb.PrivilegeId=potc.PrivilegeId
)
select distinct cte.Name
from cte


-- Document Library Base
Select dlb.tmkn_documentlibraryId,dlb.tmkn_name,ib.tmkn_FirstName -- 90624
from tmkn_documentlibraryBase dlb
join tmkn_identityBase ib on ib.tmkn_identityId=dlb.tmkn_Identity