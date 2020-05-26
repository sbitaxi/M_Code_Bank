let
    // List of final columns
    Final_Columns = {"City Key", "City", 
                    "State Province", "Sales Territory"},
    
    s = Value.NativeQuery(WideWorldImporters,"SELECT [City Key], [City] COLLATE SQL_Latin1_General_CP1_CS_AS AS City, 
                    [State Province], [Sales Territory] FROM Dimension.City ;"),
    
    t = Table.ColumnNames(s),
    // Navigate to Tables
    Dim_City = WideWorldImporters{[Name="Dimension.City"]}[Data],

    // Test PositionOf for Case Sensitivity
    Test_Pos = [ exists = Text.PositionOf("Donuted-O","n") >= 0, 
                not_exists = Text.PositionOf("Donuted-O","N") >= 0],

    // Position Of A, d and C in City is >= 0
    City_Pos_A_d_C = Table.SelectRows(Dim_City, each 
                    Text.PositionOf([City], "A") >= 0
                    and
                    Text.PositionOf([City], "d") >= 0
                    and
                    Text.PositionOf([City], "C") >= 0
                ),
    // Cities
    Cities = List.Distinct(Dim_City[City]),

    // Filter List
    Contains_A_d_C = List.Select(Cities, each
                 Text.Contains(_, "A", Comparer.Ordinal) 
        and Text.Contains(_, "d", Comparer.Ordinal) 
        and Text.Contains(_, "C", Comparer.Ordinal)),

    // Filter Table
    Filter_City = Table.SelectRows(Dim_City, 
        each List.Contains(Contains_A_d_C, [City])),

    r = [filt_list = Table.RowCount(Filter_City), Pos = Table.RowCount(City_Pos_A_d_C)],
    // Select required columns
    SelCols = Table.SelectColumns(Filter_City,
                    Final_Columns)
in
    SelCols