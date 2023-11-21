
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





