tableextension 97051 "EPC Job Setup Ext" extends "Jobs Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Job G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "G/L Account";
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