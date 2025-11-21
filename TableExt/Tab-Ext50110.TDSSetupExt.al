tableextension 50110 "BBG TDS Setup Ext" extends "TDS Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "206AB %"; Decimal)
        {
            DataClassification = ToBeClassified;
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