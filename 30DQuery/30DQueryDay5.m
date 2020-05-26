let
    // Required output columns
    FinalColumns = {"Employee Key", "Employee", "Is Salesperson",
                    "Valid From", "Valid To"},

    // Connect to SQL Server
    Source = Sql.Database(".", "WideWorldImportersDW"),

    // Navigate to the Table(s)
    Fact_Employee = Source{[Schema="Dimension",Item="Employee"]}[Data],

    // Select output columns
    SelCols = Table.SelectColumns(Fact_Employee, FinalColumns),

    // Non-Salespersons until 9999
    Non_SalesP_9999 = Table.SelectRows(SelCols, 
                each Date.Year([Valid To])= 9999 
                    and not [Is Salesperson]),
    
    // Salespersons where [Valid To] year is not 9999 and 365 Days
    SalesP_Not_9999_And_365 = Table.SelectRows(SelCols, 
                each [Is Salesperson]
                and Date.Year([Valid To]) <> 9999
                and Duration.TotalDays([Valid To] - [Valid From]) > 365),

    // Combine the two resultsets into one table
    Combine_ResultSets = Table.Combine({Non_SalesP_9999, 
                                    SalesP_Not_9999_And_365})

in
    Combine_ResultSets