let
    // Required output columns
    FinalColumns = {"Sale Key", "Customer Key",
                "Invoice Date Key", "Total Excluding Tax",
                "Tax Amount", "Profit"},

    // Connect to SQL Server
    Source = Sql.Database(".", "WideWorldImportersDW"),

    // Navigate to the Table(s)
    Fact_Sale = Source{[Schema="Fact",Item="Sale"]}[Data],

    // Select columns
    SelCols = Table.SelectColumns(Fact_Sale, FinalColumns),

    // Retrieve a list of dates in the Invoice Date Key
    Invoice_Dates = List.Distinct(SelCols[Invoice Date Key]),


/*
     // Add a column with the Invoice Date Key year
     Year_Col = Table.AddColumn(SelCols, "Year_Col", 
        each Date.Year([Invoice Date Key])),

    // Add a column with the Invoice Date Key month and increment by 1
    Month_Col = Table.AddColumn(Year_Col, "Month_Col", 
        each Date.Month([Invoice Date Key]) + 1),

    // Add a column to generate the End Of Month
    EOM_Col = Table.AddColumn(Month_Col, "EOM", 
        each Date.AddDays(#date([Year_Col], [Month_Col], 1), -1 )),

 // Filter table for dates that are in Last_Day List
    Last_Day_Inv = Table.SelectRows(EOM_Col, 
            each [Invoice Date Key] = [EOM]),
*/



    // Select dates that are only == End of month
    Last_Day = List.Select(Invoice_Dates, 
            each _ = Date.EndOfMonth(_)),

    // Filter table for dates that are in Last_Day List
    Last_Day_Invoices = Table.SelectRows(SelCols, 
            each List.Contains(Last_Day,[Invoice Date Key]))
in
    Last_Day_Invoices