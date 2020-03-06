--Detects and deletes duplicate rows

select *
from (
  select *, rn=row_number() over (partition by Groupname order by groupid)
  from dbo.tGroups  
) x
where rn > 1;

--use rollback if unsure

Delete x
from (
  select *, rn=row_number() over (partition by Groupname order by groupid)
  from dbo.tGroups  
) x
where rn > 1;
