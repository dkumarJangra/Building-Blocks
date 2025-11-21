page 50173 "MJV Developmnt Subform"
{
    AutoSplitKey = true;
    Caption = 'Receipt';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "New Application DevelopmntLine";
    SourceTableView = WHERE("Payment Mode" = FILTER(MJVM));
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
                field("Payment Mode"; Rec."Payment Mode")
                {
                    OptionCaption = ' ,,,,MJVM';

                    trigger OnValidate()
                    begin
                        ChequeNoTransactionNoEditable := FALSE;
                        "Cheque DateEditable" := FALSE;
                        "Cheque Bank and BranchEditable" := FALSE;
                        "Deposit/Paid BankEditable" := FALSE;
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
                field("User Branch Name"; Rec."User Branch Name")
                {
                    Caption = 'User Branch Name';
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                }
                field("MJV Transfer Amount"; Rec."MJV Transfer Amount")
                {
                }
                field("Apply to Document No."; Rec."Apply to Document No.")
                {

                    trigger OnValidate()
                    var
                        NewApplicationDevelopmntLine: Record "New Application DevelopmntLine";
                    begin
                    end;
                }
                field("Order Ref No."; Rec."Order Ref No.")
                {
                    Caption = 'Transfer to Application No.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Posting date"; Rec."Posting date")
                {
                    Editable = false;
                    Visible = true;
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

