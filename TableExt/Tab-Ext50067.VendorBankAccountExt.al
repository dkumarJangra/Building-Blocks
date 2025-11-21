tableextension 50067 "BBG Vendor Bank Account Ext" extends "Vendor Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Default; Boolean)
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