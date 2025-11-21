tableextension 50048 "BBG Res. Journal Template Ext" extends "Res. Journal Template"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Timesheet Template"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'DDS EHS';
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