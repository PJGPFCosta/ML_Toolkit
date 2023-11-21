
-- This first two queries aim to get the name of each program and the number of application for each one


--List of programs in applicationformbase and it status and its number of applications
select pid.tmkn_ProductName as ProgramName,app.statecode, count(distinct app.tws_applicationformId) as number_of_app
from tws_applicationformBase as app
left join tmkn_pid pid on pid.tmkn_pidId=app.tws_Product
group by pid.tmkn_ProductName,app.statecode

--List of programs in tws_enterpriseapplicationBase and it status and its number of applications
select pid.tmkn_ProductName as ProgramName,app.statecode, count(distinct app.tws_enterpriseapplicationId) as number_of_app
from tws_enterpriseapplicationBase as app
left join tmkn_pid pid on pid.tmkn_pidId=app.tws_Product
group by pid.tmkn_ProductName,app.statecode

--List of programs in tws_jobapplicationBase and it status and its number of applications
select pid.tmkn_ProductName as ProgramName,app.statecode, count(distinct app.tws_jobapplicationId) as number_of_app
from tws_jobapplicationBase as app
left join tmkn_pid pid on pid.tmkn_pidId=app.tws_Product
group by pid.tmkn_ProductName,app.statecode

--List of programs in tws_employeeapplicationBase and it status and its number of applications
select pid.tmkn_ProductName as ProgramName,app.statecode, count(distinct app.tws_employeeapplicationId) as number_of_app
from tws_employeeapplicationBase as app
left join tmkn_pid pid on pid.tmkn_pidId=app.tws_Product
group by pid.tmkn_ProductName,app.statecode

--List of programs in tws_wagesubsidyBase and it status and its number of applications
select pid.tmkn_ProductName as ProgramName,app.statecode, count(distinct app.tws_wagesubsidyId) as number_of_app
from tws_wagesubsidyBase as app
left join tmkn_pid pid on pid.tmkn_pidId=app.tws_Product
group by pid.tmkn_ProductName,app.statecode

--List of programs in tws_wageincrementBase and it status and its number of applications
select pid.tmkn_ProductName as ProgramName,app.statecode, count(distinct app.tws_wageincrementId) as number_of_app
from tws_wageincrementBase as app
left join tmkn_pid pid on pid.tmkn_pidId=app.tws_Product
group by pid.tmkn_ProductName,app.statecode

--List of programs in mis_individualapplication and it status and its number of applications
select pid.tmkn_ProductName as ProgramName,app.statecode, count(distinct app.MIS_individualapplicationId) as number_of_app
from mis_individualapplication as app
left join tmkn_pid pid on pid.tmkn_pidId=app.tmkn_pid
group by pid.tmkn_ProductName,app.statecode






-- Sayed query for Basic Skills Training, Professional Certification Scheme,Individual Development Platform


SELECT 
	ISNULL(PID.tmkn_productname,Prod.MIS_name) AS [Product],
	SC.Name AS [Status],
	COUNT(*) AS [Count]
	FROM Tamkeen_MSCRM.dbo.MIS_individualapplication app
	INNER JOIN Tamkeen_MSCRM.dbo.MIS_individual ind ON ind.MIS_individualId = app.mis_individualid
	LEFT JOIN Tamkeen_MSCRM.dbo.mis_certificate cert ON cert.mis_certificateId = app.mis_certificatename
	LEFT JOIN Tamkeen_MSCRM.dbo.tmkn_pid PID ON PID.tmkn_pidId = app.tmkn_PID
	LEFT JOIN Tamkeen_MSCRM.dbo.mis_product Prod ON Prod.MIS_productId = app.mis_productid
	LEFT JOIN dbo.GetOptionSetValuel('MIS_individualapplication','statecode') SC ON SC.ID = app.statecode
WHERE 
(
app.mis_productid IN ('861C188B-A0F5-E111-9F11-02BFAC14025D','8DF92211-A3F5-E111-9F11-02BFAC14025D','2F300C32-426C-EB11-80EB-005056832EEE','47473F35-5ED5-E111-97C4-02BFAC14025D','480B6DCB-A64D-E211-96BC-02BFAC14025D','E1D16878-61D5-E111-97C4-02BFAC14025D','58CE2844-66D5-E111-97C4-02BFAC14025D')
or app.tmkn_PID IN ('2F300C32-426C-EB11-80EB-005056832EEE','2139B42A-62DA-EC11-B81A-00505683E76F','9B122BE8-1616-ED11-B824-00505683E76F','9AF3F423-C122-ED11-B826-00505683E76F','F4E41D10-97B0-EA11-80DB-005056832EEE','803640A0-2670-EB11-80EC-005056832EEE')
)
GROUP BY ISNULL(PID.tmkn_productname,Prod.MIS_name),SC.Name


--Basic Skills
select mis_productidName,statecode,count(mis_productid)
from MIS_individualapplication
where mis_productidName like('%Basic%Skills%') 
group by mis_productidName,statecode

-- Professional Certification Scheme
select mis_productidName,statecode,count(mis_productid)
from MIS_individualapplication
where mis_productidName like('%Professional%Certification%Scheme%') 
group by mis_productidName,statecode




-- Business Development
with cte1 as (
	select PID.tmkn_productname as productName,app.statecode as statecode, count(*) as counts
	from tws_employeeapplicationBase app
	join tmkn_pidBase pid on  app.tws_Product=pid.tmkn_pidId
	where pid.tmkn_pidId IN ('F4E41D10-97B0-EA11-80DB-005056832EEE','803640A0-2670-EB11-80EC-005056832EEE')
	GROUP BY PID.tmkn_productname,app.statecode
),
cte2 as (
	select PID.tmkn_productname as productName,app.statecode as statecode, count(*) as counts
	from tws_wagesubsidyBase app
	join tmkn_pidBase pid on  app.tws_Product=pid.tmkn_pidId
	where pid.tmkn_pidId IN ('F4E41D10-97B0-EA11-80DB-005056832EEE','803640A0-2670-EB11-80EC-005056832EEE')
	GROUP BY PID.tmkn_productname,app.statecode
)
select *
from cte1--cte2

























-- check the names of the programs
/*
select pid.tmkn_ProductName, 
		count(distinct app.tws_employeeapplicationId),
		count(distinct app2.tws_trainingenrollmentId),
		count(distinct app3.tws_wagesubsidyId),
		count(distinct app4.tws_applicationformId),
		count(distinct app5.tws_jobapplicationId),
		count(distinct app6.tws_enterpriseapplicationId),
		count(distinct app7.tws_wageincrementId)
from tmkn_pid pid
left join tws_employeeapplicationBase app on app.tws_Product=pid.tmkn_pidId
left join tws_trainingenrollmentBase app2 on app2.tws_Product=pid.tmkn_pidId
left join tws_wagesubsidyBase app3 on app3.tws_Product=pid.tmkn_pidId
left join tws_applicationformBase app4 on app4.tws_Product=pid.tmkn_pidId
left join tws_jobapplicationBase app5 on app5.tws_Product=pid.tmkn_pidId
left join tws_enterpriseapplicationBase app6 on app6.tws_Product=pid.tmkn_pidId
left join tws_wageincrementBase app7 on app7.tws_Product=pid.tmkn_pidId
group by pid.tmkn_ProductName
*/







-- Returns a High level statistics about the Table and its FK: Column Name, Distinct count, Number of Nulls, total records
-- Update @TableName and @Columns with the the values that you need.
-- In the file Tamkeen Migration - Data Mapping.xlsx in the profilling sheet for each table the is a list of columns.
-- Just replace and run

DECLARE @TableName NVARCHAR(128) = 'tws_twsjobapplicationstatushistoryBase';
DECLARE @Columns NVARCHAR(MAX) = 'statecode,statuscode,tmkn_analyst_recommendation,tws_JobApplication,tws_name,tws_Remarks,tws_StatusReport,VersionNumber';

DECLARE @SqlQuery NVARCHAR(MAX) = '';

-- Create a table variable to store the split values
DECLARE @ColumnsTable TABLE (ColumnValue NVARCHAR(MAX));

-- Insert the split values into the table variable using XML
INSERT INTO @ColumnsTable (ColumnValue)
SELECT LTRIM(RTRIM(m.n.value('.[1]','varchar(8000)')))
FROM (
    SELECT CAST('<XMLRoot><RowData>' + REPLACE(@Columns, ',', '</RowData><RowData>') + '</RowData></XMLRoot>' AS XML) AS x
) t
CROSS APPLY x.nodes('/XMLRoot/RowData') m(n);

-- Concatenate SQL statements for each selected column
SELECT @SqlQuery = @SqlQuery +
    'SELECT ''' + ColumnValue + ''' AS ColumnName, ' +
	'COUNT(DISTINCT CASE WHEN ' + QUOTENAME(ColumnValue) + ' IS NOT NULL THEN ' + QUOTENAME(ColumnValue) + ' END) AS DistinctCount, '+
    'SUM(CASE WHEN ' + QUOTENAME(ColumnValue) + ' IS NULL THEN 1 ELSE 0 END) AS NumNulls, ' +
    'COUNT(*) AS TotalRecords ' +
    'FROM ' + @TableName + ' ' +
    'UNION ALL '
FROM @ColumnsTable;

-- Remove the trailing 'UNION ALL'
SET @SqlQuery = LEFT(@SqlQuery, LEN(@SqlQuery) - LEN('UNION ALL'));

-- Execute the dynamic SQL query
EXEC sp_executesql @SqlQuery;







