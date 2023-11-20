-- check duplicates for tmkn_companyBase

DECLARE @TableName NVARCHAR(128) = 'tmkn_companyBase';
--this list is the list of columns created by the system and the ID
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tmkn_companyId, CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OrganizationId,OverriddenCreatedOn,TimeZoneRuleVersionNumber';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Return the combination of values and the number of times that is duplicated
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);-- query for returning the values duplicated

EXEC(@SqlQuerySUM); -- sum of all duplicates









-- Check Duplicates for tws_enterpriseapplicationBase 

DECLARE @TableName NVARCHAR(128) = 'tws_enterpriseapplicationBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_enterpriseapplicationId,CreatedBy,CreatedOn,CreatedOnBehalfBy,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);-- query for returning the values duplicated

exec(@SqlQuerySUM); -- sum of all duplicates


-- check duplicates for tws_twsenterpriseapplicationstatushistoryBase
with all_data as (
	select 
		tws_Reference,
		statecode,
		statuscode,
		tws_Company,
		tws_name,
		tws_remarks,
		tws_status_report,
		VersionNumber
	from tws_twsenterpriseapplicationstatushistoryBase
	--order by tws_Reference
)
select count(*) as number_of_duplicates
from all_data
group by tws_Reference,
		statecode,
		statuscode,
		tws_Company,
		tws_name,
		tws_remarks,
		tws_status_report,
		VersionNumber
having count(*)>1







-- Check Duplicates for tws_applicationformBase 
DECLARE @TableName NVARCHAR(128) = 'tws_applicationformBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_applicationformId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId';
DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);
-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);
-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);
-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';
EXEC(@SqlQuery);
exec(@SqlQuerySUM);





-- tws_twsapplicationformhistorystatusBase

DECLARE @TableName NVARCHAR(128) = 'tws_twsapplicationformhistorystatusBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_twsapplicationformhistorystatusId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);



-- tws_jobapplicationBase


DECLARE @TableName NVARCHAR(128) = 'tws_jobapplicationBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_jobapplicationId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);



-- tws_twsjobapplicationstatushistoryBase


DECLARE @TableName NVARCHAR(128) = 'tws_twsjobapplicationstatushistoryBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_twsjobapplicationstatushistoryId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);



-- tws_employeeapplicationBase
DECLARE @TableName NVARCHAR(128) = 'tws_employeeapplicationBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_employeeapplicationId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);




--tws_employeeapplication_shBase


DECLARE @TableName NVARCHAR(128) = 'tws_employeeapplication_shBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_employeeapplication_shId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);



--tws_wagesubsidyBase

DECLARE @TableName NVARCHAR(128) = 'tws_wagesubsidyBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_wagesubsidyId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);




--tws_wagesubsidy_shBase
DECLARE @TableName NVARCHAR(128) = 'tws_wagesubsidy_shBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_wagesubsidy_shid,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);



--tws_wages_support_configurationBase

DECLARE @TableName NVARCHAR(128) = 'tws_wages_support_configurationBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_wages_support_configurationId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);




--tws_tws_wage_support_cap_tws_wages_support_Base


DECLARE @TableName NVARCHAR(128) = 'tws_tws_wage_support_cap_tws_wages_support_Base';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_tws_wage_support_cap_tws_wages_support_Id,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);







--tws_wagepaymentrequestBase
DECLARE @TableName NVARCHAR(128) = 'tws_wagepaymentrequestBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_wagepaymentrequestId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);


--tws_wagepaymentrequest_shBase
DECLARE @TableName NVARCHAR(128) = 'tws_wagepaymentrequest_shBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_wagepaymentrequest_shId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);









--tws_paysubsidyBase

DECLARE @TableName NVARCHAR(128) = 'tws_paysubsidyBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tws_paysubsidyId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);








--MIS_individualBase
DECLARE @TableName NVARCHAR(128) = 'MIS_individualBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'MIS_individualId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);






--tmkn_pidBase


DECLARE @TableName NVARCHAR(128) = 'tmkn_pidBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'tmkn_pidId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);




--DOCUMENTS

--AnnotationBase

DECLARE @TableName NVARCHAR(128) = 'AnnotationBase';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'AnnotationId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);






-- PrivilegeObjectTypeCodes

DECLARE @TableName NVARCHAR(128) = 'PrivilegeObjectTypeCodes';
DECLARE @ColumnsToExclude NVARCHAR(MAX) = 'PrivilegeObjectTypeCodeId,PrivilegeObjectTypeCodeRowId,CreatedBy,CreatedOn,CreatedOnBehalfBy,ExchangeRate,Identity_CreatedBy,Identity_CreatedOn,Identity_ModifiedBy,Identity_ModifiedOn,ImportSequenceNumber,ModifiedBy,ModifiedOn,ModifiedOnBehalfBy,OverriddenCreatedOn,OwnerId,OwnerIdType,OwningBusinessUnit,TimeZoneRuleVersionNumber,TransactionCurrencyId,UTCConversionTimeZoneCode,TransactionCurrencyId';

DECLARE @Columns NVARCHAR(MAX);
DECLARE @ColumnsForDups NVARCHAR(MAX);

-- Generate column list excluding specified columns
SELECT @Columns = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Generate column list for checking duplicates
SELECT @ColumnsForDups = STUFF(
    (
        SELECT ',' + QUOTENAME(COLUMN_NAME)
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = @TableName AND CHARINDEX(COLUMN_NAME, @ColumnsToExclude) = 0
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''
);

-- Execute the dynamic SQL query to get duplicates
DECLARE @SqlQuery NVARCHAR(MAX) = '
    SELECT ' + @ColumnsForDups + ',
           COUNT(*) AS DuplicateCount
    FROM ' + @TableName + '
    GROUP BY ' + @ColumnsForDups + '
    HAVING COUNT(*) > 1';
	

DECLARE @SqlQuerySUM NVARCHAR(MAX) = '
    with cte as (
		SELECT ' + @ColumnsForDups + ',
			   COUNT(*) AS DuplicateCount
		FROM ' + @TableName + '
		GROUP BY ' + @ColumnsForDups + '
		HAVING COUNT(*) > 1
	)
	Select sum(DuplicateCount)as NumDuplicates,count(*) DistinctDuplicates
	from cte';


EXEC(@SqlQuery);

exec(@SqlQuerySUM);

















