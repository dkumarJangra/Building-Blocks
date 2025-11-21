table 97845 "Plot Configuration Setting"
{

    fields
    {
        field(1; ProjectID; Code[30])
        {
            TableRelation = "Responsibility Center 1";
        }
        field(2; DivFontSize; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(3; DivBordeWidth; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(4; FontWeight; Text[20])
        {
        }
        field(5; FontColor; Text[20])
        {
        }
        field(6; AvilablePlotColor; Text[20])
        {
        }
        field(7; BookedPlotColor; Text[20])
        {
        }
    }

    keys
    {
        key(Key1; ProjectID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

