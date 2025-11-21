tableextension 50050 "BBG Job Journal Template Ext" extends "Job Journal Template"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Daily Progress"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETG RIL0100 15-06-2011';
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