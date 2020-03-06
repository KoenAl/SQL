-- This SQL Query is created in order to upload backups to azure blob storage. However, it can be completely altered to do whatever you want as it gets the list of databases on the database engine and then runs your desired query against those databases.
-- Used this query due to SQL managed instance constraints, use it with a SQL job / agent to run daily. 
Declare @DatabaseName nvarchar(max); -- database name 
DECLARE db_cursor CURSOR READ_ONLY FOR  

SELECT name 
FROM master.sys.databases 
WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases
 OPEN db_cursor 

 
 WHILE @@FETCH_STATUS = 0   
BEGIN 

Declare @URLPlusTimeNow nvarchar(max);
Select @DatabaseName =  @DatabaseName;
Select @URLPlusTimeNow  = N'https://anothertest.blob.core.windows.net/30days/' + @DatabaseName + '_' + CONVERT(VarChar, GetDate(),121) + '.bak';
print @URLPlusTimeNow;
 
BACKUP DATABASE @DatabaseName TO URL = @URLPlusTimeNow WITH COPY_ONLY, 
INIT, FORMAT,MAXTRANSFERSIZE = 4194304, COMPRESSION, STATS = 10

FETCH NEXT FROM db_cursor INTO @DatabaseName 
END   
  deallocate db_cursor;