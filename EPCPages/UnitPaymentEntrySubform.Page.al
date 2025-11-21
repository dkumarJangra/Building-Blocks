page 97947 "Unit Payment Entry  Subform"
{
    AutoSplitKey = true;
    Caption = 'Receipts';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Application Payment Entry";
    SourceTableView = WHERE("Payment Mode" = FILTER(Cash | Bank));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Receipts)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Visible = false;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    OptionCaption = ' ,Cash,Bank';

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
                        /*
                          AppPaymentEntry.RESET;
                          AppPaymentEntry.SETRANGE("Document No.","Document No.");
                          AppPaymentEntry.SETRANGE(Posted,FALSE);
                          IF AppPaymentEntry.FINDFIRST THEN BEGIN
                            IF (AppPaymentEntry."Payment Mode" <> "Payment Mode"::Cash) AND (AppPaymentEntry."Payment Mode" <> "Payment Mode"::Bank) THEN
                              ERROR('You have already created another entry. Please post or Delete that for Payment Mode ='+
                              FORMAT(AppPaymentEntry."Payment Mode"));
                          END;
                         */

                    end;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Visible = false;
                }
                field(Narration; Rec.Narration)
                {
                }
                field("Provisional Rcpt. No."; Rec."Provisional Rcpt. No.")
                {
                    Visible = true;
                }
                field("User Branch Name"; Rec."User Branch Name")
                {
                    Caption = 'User Branch Name';
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Order Ref No."; Rec."Order Ref No.")
                {
                    Visible = false;
                }
                field("Cheque No./ Transaction No."; Rec."Cheque No./ Transaction No.")
                {
                    Editable = ChequeNoTransactionNoEditable;
                    Visible = true;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    Editable = "Cheque DateEditable";
                    Visible = true;
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                    Editable = "Cheque Bank and BranchEditable";
                    Visible = true;
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                    Editable = "Deposit/Paid BankEditable";
                    Visible = true;
                }
                field("Deposit / Paid Bank Name"; Rec."Deposit / Paid Bank Name")
                {
                    Visible = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Posting date"; Rec."Posting date")
                {
                    Visible = true;
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    Visible = false;
                }
                field("Application No."; Rec."Application No.")
                {
                    Visible = false;
                }
                field("User Branch Code"; Rec."User Branch Code")
                {
                    Editable = false;
                }
                field("Service Tax Amount"; Rec."Service Tax Amount")
                {
                }
                field("Service Tax Group"; Rec."Service Tax Group")
                {
                }
                field("Service Tax Reg. No."; Rec."Service Tax Reg. No.")
                {
                }
                field("Advance Payment Service Tax"; Rec."Advance Payment Service Tax")
                {
                }
                field("Service Tax Base amount"; Rec."Service Tax Base amount")
                {
                }
                field("Explode BOM"; Rec."Explode BOM")
                {
                    Editable = false;
                    Visible = false;
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

    trigger OnInit()
    begin
        "Deposit/Paid BankEditable" := TRUE;
        "Cheque Bank and BranchEditable" := TRUE;
        "Cheque DateEditable" := TRUE;
        ChequeNoTransactionNoEditable := TRUE;
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
        AppPaymentEntry: Record "Application Payment Entry";
        Loc: Record Location;
        BName: Text[70];

        ChequeNoTransactionNoEditable: Boolean;

        "Cheque DateEditable": Boolean;

        "Cheque Bank and BranchEditable": Boolean;

        "Deposit/Paid BankEditable": Boolean;


    procedure UpdatePAGE2()
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
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

