tableextension 50060 "BBG Check Ledger Entry Ext" extends "Check Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Mes-Seema';
        }
        field(50001; "Issuing Bank"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Mes-Seema';
        }
        field(50002; "Cheque No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Mes-Seema';
        }
        field(50244; "Cheque No.1"; Code[20])
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Cheque No.1" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
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