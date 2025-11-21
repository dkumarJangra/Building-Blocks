tableextension 97036 "EPC Cust. Ledger Entry Ext" extends "Cust. Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50007; "BBG Cheque No."; Code[20])
        {
            Caption = 'Cheque No.';
            DataClassification = ToBeClassified;
            Description = 'NAVIN';
        }
        field(50005; "BBG Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = ToBeClassified;
            Description = 'NAVIN';
        }
        field(90050; "BBG App. No. / Order Ref No."; Code[20])
        {
            Caption = 'App. No. / Order Ref No.';
            DataClassification = ToBeClassified;
            Description = 'Application No. / Payment with the Milestones';
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