let
    Source = {"ProductKey", "SalesOrderNumber", 
                "ShipDate", "SalesAmount"},
    FactResellerSales = AdventureWorks{[Schema="dbo", 
                        Item="FactResellerSales"]}[Data],

    // Calculate date 7 years before today
    EndDate = Date.From(Date.AddYears(
                DateTime.Date(DateTime.FixedLocalNow()),
                -7)),

    // Current date
    InitialDate = DateTime.Date(DateTime.LocalNow()),

    // 8 years before today
    DatePast8 = Date.AddYears(InitialDate, -8),

    // List all days from DatePast8 to Today
    ListOfDates = List.Dates(DatePast8, 
                Duration.TotalDays(InitialDate - DatePast8), 
                #duration(1, 0, 0, 0)),

    // Create records containing the date and T/F InPreviousNYears
    DateRecs = List.Transform(ListOfDates, 
            each [ d = _, 
                    InPrevN = Date.IsInPreviousNYears(_, 7)]),

    ListToTable = Table.FromRecords(DateRecs),
    
    DateList = Table.FromRecords(List.Transform(List.Dates(Date.AddYears(DateTime.Date(DateTime.LocalNow()),-8),365*8,#duration(1,0,0,0)), each [d = _, f = Date.IsInPreviousNYears(_, 7)])),




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

    // Remove Time from Ship Date
    ConvertDate = Table.TransformColumnTypes(FactResellerSales, 
                    {"ShipDate", type date}),

    Last_7a = Table.SelectRows(FactResellerSales,
                    each (Date.Year([ShipDate]) * 10000
                            +
                            Date.Month([ShipDate]) * 100
                            +
                            Date.Day([ShipDate]))
                     >= DateAsBigNumber),


    Last_7b = Table.SelectRows(ConvertDate,
                    each Date.IsInPreviousNYears([ShipDate], 7) 
                        ),

    // In Last 7 Years
    Last_7 = Table.SelectRows(ConvertDate,
                    each date_to_number([ShipDate]) 
                        >= DateAsBigNumber)


in
    Last_7