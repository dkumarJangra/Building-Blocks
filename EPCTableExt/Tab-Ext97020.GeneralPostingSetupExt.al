tableextension 97020 "EPC General Posting Setup Ext" extends "General Posting Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "MIN Chargeable Account"; Code[20])
        {
            DataClassification = ToBeClassified;
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