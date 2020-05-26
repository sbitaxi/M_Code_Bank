let
    Source = Sql.Database(".", "AdventureWorksDW2017"),
    dbo_DimEmployee = Source{[Schema="dbo",Item="DimEmployee"]}[Data],
    Born1974 = Table.SelectRows(dbo_DimEmployee, each Date.Year([BirthDate])= 1974),

    FullName = Table.AddColumn(Born1974, "FullName", 
            each [FirstName] & (if [MiddleName] = null then "" else " " & [MiddleName]) 
                    & " " & [LastName]),
    SelCols = Table.SelectColumns(FullName, {"EmployeeKey", "Gender", "BirthDate", "FullName"})
in
    SelCols