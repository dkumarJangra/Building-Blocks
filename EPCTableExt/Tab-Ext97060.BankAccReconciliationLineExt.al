tableextension 97060 "EPC Bank Acc Recon Line Ext" extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        // Add changes to table fields here
        field(50003; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = true;
        }
        field(50029; "External Doc. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
            Editable = false;
        }
        field(50002; "Cheque No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = true;
        }
        field(50025; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(50028; BouncedEntryPosted; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
        }
        field(50031; "Bounce Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
            OptionCaption = ' ,Tech,Non';
            OptionMembers = " ",Tech,Non;

            trigger OnValidate()
            begin
                TESTFIELD(Bounced, FALSE);
            end;
        }
        field(50026; Bounced; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';

            trigger OnValidate()
            begin
                TESTFIELD(BouncedEntryPosted, FALSE);
                TESTFIELD("Value Date");
                TESTFIELD("Bounce Type");
                VLE.RESET;
                VLE.SETRANGE("Document No.", "Document No.");
                VLE.SETRANGE("Document Type", VLE."Document Type"::Payment);
                IF VLE.FINDFIRST THEN
                    ReversalEntry.CheckVendLedgerEntryforRev(VLE);

                BLE.RESET;
                BLE.SETRANGE("Bank Account No.", "Bank Account No.");
                BLE.SETRANGE("Statement No.", "Statement No.");
                BLE.SETRANGE("Statement Line No.", "Statement Line No.");
                IF BLE.FINDFIRST THEN
                    ReversalEntry.CheckBankAccReverse(BLE);
                IF NOT Bounced THEN
                    CLEAR("Bounce Type");
            end;
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
        VLE: Record "Vendor Ledger Entry";
        BLE: Record "Bank Account Ledger Entry";
        ReversalEntry: Record "Reversal Entry";
}