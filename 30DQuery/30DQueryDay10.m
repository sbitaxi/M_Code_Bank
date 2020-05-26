let
    // Required output columns
    FinalColumns = {"Employee", "TeamMate"},

    // Connect to SQL Server
    Source = Sql.Database(".", "WideWorldImportersDW"),

    // Navigate to the Table(s)
    Dim_Employee = Source{[Schema="Dimension",
                            Item="Employee"]}[Data],


    // Create two datasets for employees
    TeamMate1 = Table.Distinct(Table.SelectColumns(Dim_Employee, 
                                    {"Employee Key", "Employee"})),

    TeamMate2 = Table.Distinct(Table.SelectColumns(Dim_Employee, 
                                {"WWI Employee ID", "Employee"})),

    // Rename TeamMate2 Employee column to avoid collisions
    TeamMate2_RenameCol = Table.RenameColumns(TeamMate2, 
                            {"Employee", "TeamMate"}),

    // Join tables
    Join_Teammates = Table.Join(TeamMate1, "Employee Key", 
                            TeamMate2_RenameCol, "WWI Employee ID", 
                            JoinKind.Inner),

    // Remove extra columns
    SelCols = Table.SelectColumns(Join_Teammates, FinalColumns)
in
    SelCols