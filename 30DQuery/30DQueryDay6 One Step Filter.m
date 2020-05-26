let
        // Required output columns
    FinalColumns = {"Stock Item Key", "Stock Item", "Color"},

    // Connect to SQL Server
    Source = Sql.Database(".", "WideWorldImportersDW"),

    // Navigate to the Table(s)
    Dim_StockItem = Source{[Schema="Dimension",
                                Item="Stock Item"]}[Data],

    // Select output columns
    SelCols = Table.SelectColumns(Dim_StockItem, FinalColumns),

    // Select Rows Where Color IS NOT N/A and 
    // [Stock Item Key] is an even number
    Apply_Filters = Table.SelectRows(SelCols, 
                    each [Color] <> "N/A" 
                    and Number.Mod([Stock Item Key], 2) = 0)
in
    Apply_Filters