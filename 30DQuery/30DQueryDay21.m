let
    // Connect to Source
    Source = WideWorldImporters{[Schema="Fact", 
                                Item="Order"]}[Data],
                                
    // List Required columns
    RequiredColumns = {"Order Key", "Description", 
                        "Quantity", "Category"},

    // Set up categories
    AddCategory = Table.AddColumn(Source,
            "Category", 
        each 
            if [Quantity] >= 100 and [Quantity] <= 250 
                then "Between 100 and 250" 
            else 
                if [Quantity] > 250 
                    then "Greater than 250" 
            else "Less than 100"),

    // Get rid of extra columns
    SelectRequiredColumns = Table.SelectColumns(
                AddCategory, RequiredColumns)
in
    SelectRequiredColumns