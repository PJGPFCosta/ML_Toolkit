
-- This first two queries aim to get the name of each program and the number of application for each one


--List of programs in applicationformbase and it status and its number of applications
select pid.tmkn_ProductName as ProgramName,app.statecode, count(distinct app.tws_applicationformId) as number_of_app
from tws_applicationformBase as app
left join tmkn_pid pid on pid.tmkn_pidId=app.tws_Product
group by pid.tmkn_ProductName,app.statecode



--List of programs in applicationformbase and it status and its number of applications
select pid.tmkn_ProductName as ProgramName,app.statecode, count(distinct app.tws_enterpriseapplicationId) as number_of_app
from tws_enterpriseapplicationBase as app
left join tmkn_pid pid on pid.tmkn_pidId=app.tws_Product
group by pid.tmkn_ProductName,app.statecode









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





