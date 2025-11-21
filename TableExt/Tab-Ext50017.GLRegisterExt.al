tableextension 50017 "BBG G/L Register Ext" extends "G/L Register"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "BBG Creation Time"; Time)
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