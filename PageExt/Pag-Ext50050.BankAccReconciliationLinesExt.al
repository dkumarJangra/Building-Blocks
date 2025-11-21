pageextension 50050 "BBG Bank Acc. Recon. Lines Ext" extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        // Add changes to page layout here
        modify("Check No.")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Value Date")
        {
            Visible = true;
            ApplicationArea = all;
        }
        addafter("Document No.")
        {
            field("Cheque No."; Rec."Cheque No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Cheque Date"; Rec."Cheque Date")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("External Doc. No."; Rec."External Doc. No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Receipt Line No."; Rec."Receipt Line No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
            field(Reversed; Rec.Reversed)
            {
                ApplicationArea = All;
            }
            field("Bounce Type"; Rec."Bounce Type")
            {
                ApplicationArea = All;
            }
            field(Bounced; Rec.Bounced)
            {
                ApplicationArea = All;
            }
            field("Application No."; Rec."Application No.")
            {
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

    PROCEDURE NavigateEntry()
    VAR
        Navigate: Page Navigate;
    BEGIN
        CLEAR(Navigate);
        Navigate.SetDoc(Rec."Transaction Date", Rec."Document No.");
        Navigate.RUN;
    END;
}