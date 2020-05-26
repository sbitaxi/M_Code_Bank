let
    // Navigate to source and tables
    Source = WideWorldImporters,
    // Navigate to source and tables
    Fact_Sale = Source{[
            Schema="Fact",
            Item="Sale"]}[Data],
    // Select required columns
    SelCols = Table.SelectColumns(Fact_Sale,
                        {"Sale Key", "Salesperson Key", 
                        "Description", "Dimension.Customer(Bill To Customer Key)"}),

    Expand_Dim_Customer = Table.ExpandRecordColumn(SelCols, 
            "Dimension.Customer(Bill To Customer Key)", 
            {"Bill To Customer"}, 
            {"Bill To Customer"}),
    // Add sort key for custom sort
    SortKey = Table.AddColumn(Expand_Dim_Customer, 
                "SortKey", 
                each if [Bill To Customer] = "N/A" 
                then 1 
                else 0),

    // Sort N/A last, then by Bill To Customer
    Sort_Sortkey_Then_BillTo = Table.Sort(SortKey,      
                {{"SortKey", Order.Ascending}, 
                {"Bill To Customer", Order.Ascending}}),
                
    #"Removed Columns" = Table.RemoveColumns(Sort_Sortkey_Then_BillTo,{"SortKey"})
in
    #"Removed Columns"