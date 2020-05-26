let
    // Connect to Foo
    Source = Sql.Database(".", "Foo"),

    // Navigate to the Bar Database
    dbo_Bar = Source{[Schema="dbo",
                Item="Bar"]}[Data],

    // Filter m, not M
    m_Filter = Table.SelectRows(dbo_Bar, each 
            Text.PositionOf([city], "m") >=0),

    // Filter M, not m
    M_Filter = Table.SelectRows(dbo_Bar, each 
            Text.PositionOf([city], "M") >=0)
in
    M_Filter