tableextension 97035 "EPC Bank Acc. Ledg. Entry Ext" extends "Bank Account Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50244; "Cheque No.1"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90110; Bounced; Boolean)
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