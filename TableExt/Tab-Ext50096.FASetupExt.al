tableextension 50096 "BBG FA Setup Ext" extends "FA Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "For SSPL"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 220509';
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