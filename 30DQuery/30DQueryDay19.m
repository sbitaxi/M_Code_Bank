let
    // List of final columns
    Final_Columns = {"SalesOrderNumber", "OrderDate", 
                    "ResellerKey", "EmployeeKey", 
                    "UnixTimeStamp"},
    
    // Connect to SQL Server
    Source = Sql.Database(".", "AdventureWorksDW2017"),
    
    // Navigate to Tables
    FactResellerSales = Source{[Schema="dbo", 
                    Item="FactResellerSales"]}[Data],
    // Variable for the Unix Epoch Date and Time
    UnixEpoch = #datetime(1970,01,01,0,0,0),

    d = #datetime(1970,01,30,0,0,1) - UnixEpoch,
    // Test the strategy
    TestUnixTime = Duration.TotalSeconds(
                #datetime(1970,01,01,0,0,1) - UnixEpoch),

    // Add the Epoch column
    Unix_TimeStamp = Table.AddColumn(FactResellerSales,
                "UnixTimeStamp", 
                each Duration.TotalSeconds([OrderDate] - UnixEpoch)),

    // Remove the extra columns
    SelCols = Table.SelectColumns(Unix_TimeStamp, Final_Columns)
in
    SelCols