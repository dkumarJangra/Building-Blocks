tableextension 50055 "BBG Gen. Journal Batch Ext" extends "Gen. Journal Batch"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Refund Batch"; Boolean)
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