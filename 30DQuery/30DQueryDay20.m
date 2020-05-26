let
    // Connect to SQL Server
    Source = Sql.Database(".", "WideWorldImportersDW"),
    
    // Navigate to Tables
    Dimension_StockItem = Source{[Schema="Dimension", 
                Item="Stock Item"]}[Data],

    // List Text Type columns
    Final_Columns = Table.ColumnsOfType(Dimension_StockItem, 
                        {Text.Type}),

    // Select Required Columns
    SelCols = Table.SelectColumns(Dimension_StockItem, 
                        Final_Columns)

in
    SelCols