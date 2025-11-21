page 50144 "Posted Application Devlopment"
{
    AutoSplitKey = true;
    Caption = 'Posted Receipt';
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = "New Application DevelopmntLine";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    Visible = false;
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
                field(Type; Rec.Type)
                {
                    Editable = false;
                    Visible = false;
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
                field("Chq. Cl / Bounce Dt."; Rec."Chq. Cl / Bounce Dt.")
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

    var
        TotalApplAmt2: Decimal;
        TotalRcvdAmt2: Decimal;
        PAGERevEntries: Page "Auto Reverse Entries";
        ApplicationPayEntry: Record "Application Payment Entry";

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
        AppPayEntry: Record "NewApplication Payment Entry";
        PostPayment: Codeunit PostPayment;
        Text001: Label 'Do you want to Bounce the Cheque No. %1 ?';
    begin
        /*
        CLEAR(AppPayEntry);
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document Type","Document Type");
        AppPayEntry.SETRANGE("Document No.","Document No.");
        AppPayEntry.SETRANGE("Line No.","Line No.");
        AppPayEntry.SETRANGE("Cheque No./ Transaction No.","Cheque No./ Transaction No.");
        AppPayEntry.SETFILTER("Payment Mode",'%1|%2',AppPayEntry."Payment Mode"::Bank,
        AppPayEntry."Payment Mode"::"Refund Bank");
        AppPayEntry.SETFILTER("Cheque Status",'<>%1',AppPayEntry."Cheque Status"::Bounced);
        AppPayEntry.SETRANGE(Posted,TRUE);
        IF AppPayEntry.FINDFIRST THEN BEGIN
          IF CONFIRM(Text001,TRUE) THEN
            PostPayment.NewChequeBounce(AppPayEntry,AppPayEntry."Posting date");
        END ELSE
          ERROR('Entry does not exist to bounce');
         */

    end;


    procedure NavigateEntry()
    var
        Navigate: Page Navigate;
    begin
        CLEAR(Navigate);
        Navigate.SetDoc(Rec."Posting date", Rec."Posted Document No.");
        Navigate.RUN;
    end;


    procedure ReversalRcpt()
    var
        ReversalEntry: Record "Reversal Entry";
        GLEntry: Record "G/L Entry";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        ReversalEntry1: Record "Reversal Entry" temporary;
    begin
        IF Rec."Cheque Status" = Rec."Cheque Status"::Cancelled THEN
            ERROR('This entry is already cancelled');

        Rec.TESTFIELD("Receipt Post in Devlp. Comp.", FALSE);

        IF CONFIRM('Are you sure you want to cancel this receipt No. -' + Rec."Posted Document No." + ' ' + 'with Amount' + ' ' +
           FORMAT(Rec.Amount)) THEN BEGIN

            GLEntry.RESET;
            GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
            GLEntry.SETRANGE("Document No.", Rec."Posted Document No.");
            GLEntry.SETRANGE("Posting Date", Rec."Posting date");
            IF GLEntry.FINDFIRST THEN BEGIN
                CLEAR(ReversalEntry);
                IF GLEntry.Reversed THEN
                    ReversalEntry.AlreadyReversedEntry(Rec.TABLECAPTION, GLEntry."Entry No.");
                IF GLEntry."Journal Batch Name" = '' THEN
                    ReversalEntry.TestFieldError;
                GLEntry.TESTFIELD("Transaction No.");
                ReversalEntry.DELETEALL;
                ReversalEntry.AutoReverseTransaction(GLEntry."Transaction No.", Rec."Posting date");
                PAGERevEntries.RUN;
            END;
        END;
    end;
}

