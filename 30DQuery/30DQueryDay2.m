let
    FinalColumns = {"ResellerKey","BusinessType","ResellerName", 
                    "NumberEmployees", "ProductLine", "AnnualRevenue",
                    "EnglishCountryRegionName"},
    
    Source = Sql.Database(".", "AdventureWorksDW2017"),
    
    dbo_DimReseller = Source{[Schema="dbo",Item="DimReseller"]}[Data],

    dbo_DimGeography = Source{[Schema="dbo",Item="DimGeography"]}[Data],
    
    BikeOrBicycle = Table.SelectRows(dbo_DimReseller, each Text.Contains([ResellerName],"bike")
                                                        or Text.Contains([ResellerName], "bicycle") 
                                                        ),

    NotDEorGB = Table.SelectRows(dbo_DimGeography, each not List.Contains({"DE", "GB"},[CountryRegionCode] )),

    JoinResellerGeography = Table.Join(BikeOrBicycle, "GeographyKey", 
                                        NotDEorGB, "GeographyKey", JoinKind.Inner),

    SelectCols = Table.SelectColumns(JoinResellerGeography, FinalColumns)

in
    SelectCols