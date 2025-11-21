pageextension 50051 "BBG Aply Bnk Acc. Led. Ent Ext" extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document Type")
        {
            field("Cheque No."; Rec."Cheque No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Cheque No.1"; Rec."Cheque No.1")
            {
                Editable = false;
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        ChangeAmount: Boolean;

    PROCEDURE SetStmtLine(NewBankAccReconLine: Record "Bank Acc. Reconciliation Line");
    BEGIN
        BankAccReconLine := NewBankAccReconLine;
        ChangeAmount := BankAccReconLine."Statement Amount" = 0;
    END;
}