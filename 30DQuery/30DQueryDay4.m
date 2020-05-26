let
    // Required output columns
    FinalColumns = {"Order Key", "Description"},

    // Connect to SQL Server
    Source = Sql.Database(".", "WideWorldImportersDW"),

    // Navigate to the Table(s)
    Fact_Order = Source{[Schema="Fact",Item="Order"]}[Data],

    // Select output columns
    SelCols = Table.SelectColumns(Fact_Order, FinalColumns),

    // Calculate the Length of Description
    Apply_Modulo_And_Filter = Table.SelectRows(SelCols,
                each Number.Mod(Text.Length([Description]), 10) = 1)

in
    Apply_Modulo_And_Filter