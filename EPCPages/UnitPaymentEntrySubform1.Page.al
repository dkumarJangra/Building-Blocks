page 97950 "Unit Payment Entry  Subform1"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Application Payment Entry";
    SourceTableView = WHERE("Payment Mode" = FILTER(AJVM));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Visible = false;
                }
                field("Payment Mode New"; Rec."Payment Mode New")
                {
                    Caption = 'Payment Mode';
                    OptionCaption = ' ,AJVM ELEG,AJVM ADV';
                }
                field("AJVM Transfer Type"; Rec."AJVM Transfer Type")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                }
                field(Narration; Rec.Narration)
                {
                }
                field("User Branch Name"; Rec."User Branch Name")
                {
                    Editable = false;
                }
                field("Provisional Rcpt. No."; Rec."Provisional Rcpt. No.")
                {
                    Visible = false;
                }
                field("Associate Transfer Amount"; Rec."Associate Transfer Amount")
                {
                    Caption = 'Associate Amount Including TDS/Club9';
                    Editable = true;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount Excluding TDS/Club9';
                    Editable = true;
                }
                field("TDS %"; Rec."TDS %")
                {
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                }
                field("Club 9%"; Rec."Club 9%")
                {
                }
                field("Club 9 Amount"; Rec."Club 9 Amount")
                {
                }
                field("Order Ref No."; Rec."Order Ref No.")
                {
                    Visible = false;
                }
                field("Cheque No./ Transaction No."; Rec."Cheque No./ Transaction No.")
                {
                    Visible = false;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    Visible = false;
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                    Visible = false;
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    Visible = false;
                }
                field("Posting date"; Rec."Posting date")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                    Visible = false;
                }
                field("Chq. Cl / Bounce Dt."; Rec."Chq. Cl / Bounce Dt.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Explode BOM"; Rec."Explode BOM")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Deposit / Paid Bank Name"; Rec."Deposit / Paid Bank Name")
                {
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
        Rec."Payment Mode" := Rec."Payment Mode"::AJVM;
        Rec."Payment Method" := 'AJVM';
        Rec.VALIDATE("Payment Mode");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
        Rec."Payment Mode" := Rec."Payment Mode"::AJVM;
        Rec."Payment Method" := 'AJVM';
        Rec.VALIDATE("Payment Mode");
        BBGOnAfterGetCurrRecord;
    end;

    var
        TotalApplAmt2: Decimal;
        TotalRcvdAmt2: Decimal;


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

