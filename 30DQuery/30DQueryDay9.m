let
    // Table 1 columns
    Table_1_Cols = {"OrderQuantity", "DimCustomer"},

    // Table 2 columns
    Table_2_Cols = {"Gender", "EnglishEducation", "CommuteDistance"},

    // Connect to the database
    Source = Sql.Database(".", "AdventureWorksDW2017"),

    // Navigate to the table(s)
    dbo_FactInternetSales = Source{[Schema="dbo",
                    Item="FactInternetSales"]}[Data],

    // Select required columns (get rid of unnecessary data)
    RequiredColumns = Table.SelectColumns(dbo_FactInternetSales, 
                        Table_1_Cols),
    
    // Expand customer record
    Expand_Customer = Table.ExpandRecordColumn(RequiredColumns, 
                        "DimCustomer", Table_2_Cols),

// Sort Key values
Key_Values = Table.Sort(

	// Convert the list of records to a table
	Table.FromRecords(
		List.Transform(
	
		// Distinct list of new column names
		List.Distinct(Expand_Customer[CommuteDistance]), 
		
		// create a record, label is the original value
		each [label = _, 

		// convert the text to a number
		value = Number.FromText(
		
		// remove the +
			Text.Replace(
			
		// Split by - and keep the {0} position item
				Text.Split(
		
		// split by " " and  keep the {0} position item
					Text.Split(_, " "){0},"-"){0},
						"+",""))])),
	"value")[label],

    // Pivot Commute Distance
    Pivot_Distance = Table.Pivot(Expand_Customer, 
            Key_Values, "CommuteDistance", 
            "OrderQuantity", List.Sum),

    // Sort Education Descending and Gender Asending
    Edu_Gender_Sort = Table.Sort(Pivot_Distance,
                {{"EnglishEducation", Order.Descending}
                ,{"Gender", Order.Ascending}})
in
    Edu_Gender_Sort