tableextension 50075 "BBG Tax Area Line Ext" extends "Tax Area Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Steel; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE PS Added field for Client Billing';
        }
        field(50001; "Non Steel"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE PS Added field for Client Billing';
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