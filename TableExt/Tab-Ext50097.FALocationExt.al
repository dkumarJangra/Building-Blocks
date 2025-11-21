tableextension 50097 "BBG FA Location Ext" extends "FA Location"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Use As In-Transit"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0021 08-08-2007';
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