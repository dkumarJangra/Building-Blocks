tableextension 97059 "EPC Bank Acc. State. Line Ext" extends "Bank Account Statement Line"
{
    fields
    {
        // Add changes to table fields here
        field(50032; "User ID"; Code[50])
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