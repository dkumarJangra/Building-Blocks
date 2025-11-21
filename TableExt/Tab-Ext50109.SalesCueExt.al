tableextension 50109 "BBG Sales Cue Ext" extends "Sales Cue"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Total Confirm Orders"; Integer)
        {
            CalcFormula = Count("Confirmed Order");
            FieldClass = FlowField;
        }
        field(50001; "Open Confirm Order"; Integer)
        {
            CalcFormula = Count("Confirmed Order" WHERE(Status = FILTER(Open)));
            FieldClass = FlowField;
        }
        field(50002; "Registered Confirm Orders"; Integer)
        {
            CalcFormula = Count("Confirmed Order" WHERE(Status = FILTER(Registered)));
            FieldClass = FlowField;
        }
        field(50003; "Vacated Confirm Orders"; Integer)
        {
            CalcFormula = Count("Confirmed Order" WHERE(Status = FILTER(Vacate)));
            FieldClass = FlowField;
        }
        field(50004; "Cancelled Confirm Orders"; Integer)
        {
            CalcFormula = Count("Confirmed Order" WHERE(Status = FILTER(Cancelled)));
            FieldClass = FlowField;
        }
        field(50005; "Total Inventory"; Decimal)
        {
            CalcFormula = Sum("Gold Coin Eligibility"."Total Unit Amount" WHERE(Status = FILTER(Normal)));
            FieldClass = FlowField;
        }
        field(50006; Eligibility; Integer)
        {
            CalcFormula = Count("Gold Coin Eligibility" WHERE(Status = FILTER(Normal)));
            FieldClass = FlowField;
        }
        field(50007; "Issued Gold_Silver"; Integer)
        {
            CalcFormula = Count("Gold Coin Eligibility" WHERE(Status = FILTER(Normal)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;


}