let
    // Required output columns
    FinalColumns = {"Stock Item Key", "Stock Item", "Color"},

    // Connect to SQL Server
    Source = Sql.Database(".", "WideWorldImportersDW"),

    // Navigate to the Table(s)
    Dim_StockItem = Source{[Schema="Dimension",Item="Stock Item"]}[Data],

    // Select output columns
    SelCols = Table.SelectColumns(Dim_StockItem, FinalColumns),

    // Filter by color IS NOT N/A
    Has_Colour = Table.SelectRows(SelCols, each [Color] <> "N/A"),


    


    // Mod of Stock Item Key
    Mod_Stock_Item_Col = Table.AddColumn(Has_Colour, "Mod_of_Item_Key",
                        each Number.Mod([Stock Item Key], 2)),


    // Reorder columns
    Reorder = Table.ReorderColumns(Mod_Stock_Item_Col,
                {"Mod_of_Item_Key", "Stock Item Key", 
                    "Stock Item", "Color"}),











    // Filter where [Stock Item Key] is an even number
    Number_Is_Even = Table.SelectRows(Has_Colour, 
                        each Number.IsEven([Stock Item Key])),

    // Filter where [Stock Item Key] is an even number Using Mod
    Mod_Even_Number = Table.SelectRows(Has_Colour, 
                        each Number.Mod([Stock Item Key], 2) = 0)
in
    Mod_Even_Number