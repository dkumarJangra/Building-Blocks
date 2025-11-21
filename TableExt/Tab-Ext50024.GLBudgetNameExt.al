tableextension 50024 "BBG G/L Budget Name Ext" extends "G/L Budget Name"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Project Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
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