let
    FinalColumns = {"ProductKey", "SalesOrderNumber", 
                "ShipDate", "SalesAmount"},
    FactResellerSales = AdventureWorks{[Schema="dbo", 
                        Item="FactResellerSales"]}[Data],

    // Calculate date 7 years before today
    EndDate = Date.From(Date.AddYears(
                DateTime.Date(DateTime.FixedLocalNow()),
                -7)),


    date_to_number = (d as date) as number =>
                let
                    MakeNumber = (Date.Year(d) * 10000) 
                    + (Date.Month(d) * 100)
                    + Date.Day(d)
                in
                    MakeNumber,

    // Date == 2020-10-31
    // Year * 10000 = 20200000
    // Month * 100 = 1000
    // Day = 31
    // Year + Month + Day = 20201031
    DateAsBigNumber = date_to_number(EndDate),

    Last_7 = Table.SelectRows(FactResellerSales,
                    each (Date.Year([ShipDate]) * 10000
                            +
                            Date.Month([ShipDate]) * 100
                            +
                            Date.Day([ShipDate]))
                     >= DateAsBigNumber),
    // Remove Time from Ship Date
    ConvertDate = Table.TransformColumnTypes(Last_7, 
                    {"ShipDate", type date}),
    SelCols = Table.SelectColumns(ConvertDate, FinalColumns)

in
    SelCols