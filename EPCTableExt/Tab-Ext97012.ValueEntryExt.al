tableextension 97012 "EPC Value Entry Ext" extends "Value Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50002; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG 151012';
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