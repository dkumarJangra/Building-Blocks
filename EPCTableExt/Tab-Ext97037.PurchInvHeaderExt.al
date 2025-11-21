tableextension 97037 "EPC Purch. Inv. Header Ext" extends "Purch. Inv. Header"
{
    fields
    {
        // Add changes to table fields here
        field(50107; "Cheque No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 081212';
        }
        field(50108; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 081212';
        }
        field(50114; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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