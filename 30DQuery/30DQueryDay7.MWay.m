let
    // Connect to SQL Server
    Source = Sql.Database(".", "AdventureWorksDW2017"),
    
    // Navigate to the Table(s)
    dbo_DimEmployee = Source{[Schema="dbo",
                    Item="DimEmployee"]}[Data],

    // Retrieve Column Names
    Column_Names = Table.ColumnNames(dbo_DimEmployee),

    // Select all column names without Key in the name
    Columns_Without_Key = List.Select(Column_Names,
                            each not Text.Contains(_,"Key")),

    // Remove the extra columns from the Table
    SelCols = Table.SelectColumns(dbo_DimEmployee, 
                            Columns_Without_Key)
    
in
    SelCols