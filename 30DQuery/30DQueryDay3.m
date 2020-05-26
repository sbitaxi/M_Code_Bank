let
    FinalColumns = {"ProductKey", "EnglishProductName", "TotalRevenue"},
    
    Source = Sql.Database(".", "AdventureWorksDW2017"),
    
    dbo_FactResellerSales = Source{[Schema="dbo",Item="FactResellerSales"]}[Data],

    RequiredColumns = Table.SelectColumns(dbo_FactResellerSales, 
                        {"ProductKey","DimProduct","OrderQuantity","UnitPrice"}),
    
    ProdName = Table.ExpandRecordColumn(RequiredColumns, "DimProduct", {"EnglishProductName"}),

    Total_Unit_Price = Table.AddColumn(ProdName, "TotalUnitPrice", 
                                    each [OrderQuantity] * [UnitPrice]),
    
    Total_Revenue = Table.Group(Total_Unit_Price, {"ProductKey", "EnglishProductName"}, 
                        {{"TotalRevenue", each List.Sum([TotalUnitPrice]), type number}}),

    Over1M = Table.SelectRows(Total_Revenue, each [TotalRevenue] > 1000000)
in
    Over1M