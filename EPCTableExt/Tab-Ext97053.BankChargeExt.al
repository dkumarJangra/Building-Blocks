tableextension 97053 "BBG Bank Charge Ext" extends "Bank Charge"
{
    fields
    {
        // Add changes to table fields here
        field(50001; Club9; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
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