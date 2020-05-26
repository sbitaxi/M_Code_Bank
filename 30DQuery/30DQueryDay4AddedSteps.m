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
    Description_Length = Table.AddColumn(SelCols, "DescriptionLength", 
                        each Text.Length([Description])),

    // Modulo of Length
    Modulo_Col = Table.AddColumn(Description_Length, "Modulo_Value", 
                        each Number.Mod([DescriptionLength],10)),

    // Select Rows
    Modulo_is_one = Table.SelectRows(Modulo_Col, each [Modulo_Value] = 1),

    // Remove the extra columns
    Final = Table.SelectColumns(Modulo_is_one, FinalColumns)
in
    Final