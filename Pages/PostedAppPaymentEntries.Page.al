page 50151 "Posted App Payment Entries"
{
    Caption = 'Posted Receipts';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Application Pmt Devlop. Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    Editable = false;
                    OptionCaption = ' ,Cash,Bank,D.D.,Transfer,D.C./C.C./Net Banking,Refund Cash,Refund Cheque,AJVM,Debit Note,JV,Negative Adjmt.';

                    trigger OnValidate()
                    begin
                        IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN BEGIN
                            ChequeNoTransactionNoEditable := FALSE;
                            "Cheque DateEditable" := FALSE;
                            "Cheque Bank and BranchEditable" := FALSE;
                            "Deposit/Paid BankEditable" := FALSE;
                        END ELSE BEGIN
                            ChequeNoTransactionNoEditable := TRUE;
                            "Cheque DateEditable" := TRUE;
                            "Cheque Bank and BranchEditable" := TRUE;
                            "Deposit/Paid BankEditable" := TRUE;
                        END;
                    end;
                }
                field("User Branch Name"; Rec."User Branch Name")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                    Caption = 'Transaction Status';
                    Editable = false;
                }
                field("Cheque No./ Transaction No."; Rec."Cheque No./ Transaction No.")
                {
                    Editable = ChequeNoTransactionNoEditable;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    Editable = "Cheque DateEditable";
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                    Editable = "Cheque Bank and BranchEditable";
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                    Editable = "Deposit/Paid BankEditable";
                }
                field("Deposit / Paid Bank Name"; Rec."Deposit / Paid Bank Name")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Posting date"; Rec."Posting date")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    Editable = false;
                }
                field("Chq. Cl / Bounce Dt."; Rec."Chq. Cl / Bounce Dt.")
                {
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                }
                field(Narration; Rec.Narration)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
        BBGOnAfterGetCurrRecord;
    end;

    var
        TotalApplAmt2: Decimal;
        TotalRcvdAmt2: Decimal;

        ChequeNoTransactionNoEditable: Boolean;

        "Cheque DateEditable": Boolean;

        "Cheque Bank and BranchEditable": Boolean;

        "Deposit/Paid BankEditable": Boolean;


    procedure UpdatePAGE2()
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
    end;


    procedure ChequeBounce()
    var
        AppPayEntry: Record "Application Payment Entry";
        PostPayment: Codeunit PostPayment;
        Text001: Label 'Do you want to Bounce the Cheque No. %1 ?';
    begin
        CLEAR(AppPayEntry);
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document Type", Rec."Document Type");
        AppPayEntry.SETRANGE("Document No.", Rec."Document No.");
        AppPayEntry.SETRANGE("Line No.", Rec."Line No.");
        AppPayEntry.SETRANGE("Cheque No./ Transaction No.", Rec."Cheque No./ Transaction No.");
        AppPayEntry.SETFILTER("Payment Mode", '%1|%2', AppPayEntry."Payment Mode"::Bank,
        AppPayEntry."Payment Mode"::"Refund Bank");
        AppPayEntry.SETFILTER("Cheque Status", '<>%1', AppPayEntry."Cheque Status"::Bounced);
        AppPayEntry.SETRANGE(Posted, TRUE);
        IF AppPayEntry.FINDFIRST THEN BEGIN
            IF CONFIRM(Text001, TRUE) THEN
                PostPayment.NewChequeBounce(AppPayEntry, AppPayEntry."Posting date");
        END ELSE
            ERROR('Entry does not exist to bounce');
    end;


    procedure NavigateEntry()
    var
        Navigate: Page Navigate;
    begin
        CLEAR(Navigate);
        Navigate.SetDoc(Rec."Posting date", Rec."Posted Document No.");
        Navigate.RUN;
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
    end;

    local procedure OnBeforePutRecord()
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
    end;
}

