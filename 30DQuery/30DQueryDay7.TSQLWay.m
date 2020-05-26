let

    // Select Column Names from INFORMATION_SCHEMA
    Info_Schema = Sql.Database(".", "AdventureworksDW2017", 
        [Query="SELECT [COLUMN_NAME] 
                FROM Information_schema.COLUMNS 
                WHERE [TABLE_NAME] = 'DimEmployee' 
                AND [COLUMN_NAME] NOT LIKE '%key%';"]),

    // Connect to SQL Server
    Source = Sql.Database(".", "AdventureWorksDW2017"),
    
    // Navigate to the Table(s)
    dbo_DimEmployee = Source{[Schema="dbo",Item="DimEmployee"]}[Data],

    // Remove the extra columns from the Table
    SelCols = Table.SelectColumns(dbo_DimEmployee, 
                            Info_Schema[COLUMN_NAME])

in
    SelCols