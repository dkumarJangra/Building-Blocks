tableextension 50078 "BBG Analysis View Entry Ext" extends "Analysis View Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Document No."; Code[20])
        {
            AutoFormatType = 1;
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 220509';
        }
        field(50001; "Item Description"; Text[30])
        {
            AutoFormatType = 1;
            Caption = 'Debit Amount';
            DataClassification = ToBeClassified;
        }
        field(50002; "Item Code"; Code[20])
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