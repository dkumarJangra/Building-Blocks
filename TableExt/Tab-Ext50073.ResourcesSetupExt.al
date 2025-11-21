tableextension 50073 "BBG Resources Setup Ext" extends "Resources Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Entimation hours / Km"; Integer)
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