page 98016 "App PEntry Adjust  Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Application Payment Entry";
    SourceTableView = WHERE("Payment Mode" = FILTER("Negative Adjmt."));
    ApplicationArea = All;
    UsageCategory = Documents;

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
                    OptionCaption = ' ,,,,,,,,,,,Negative Adjmt.';

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
                field("Payment Method"; Rec."Payment Method")
                {
                    Editable = false;
                }
                field("Adjmt. Line No."; Rec."Adjmt. Line No.")
                {
                    Caption = 'Apply from Entry No.';

                    trigger OnValidate()
                    begin
                        IF AppPayEntryRec.GET(Rec."Document Type", Rec."Document No.", Rec."Adjmt. Line No.") THEN BEGIN
                            IF AppPayEntryRec."Payment Mode" = AppPayEntryRec."Payment Mode"::AJVM THEN
                                AssociateTransferAmountEditabl := TRUE
                            ELSE
                                AssociateTransferAmountEditabl := FALSE;
                        END;
                    end;
                }
                field(Description; Rec.Description)
                {
                }
                field(Narration; Rec.Narration)
                {
                    Visible = true;
                }
                field("Associate Transfer Amount"; Rec."Associate Transfer Amount")
                {
                    Caption = 'Associate Amount Including TDS/Club9';
                    Editable = AssociateTransferAmountEditabl;
                }
                field(Amount; Rec.Amount)
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
                    Editable = ChequeNoTransactionNoEditable;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    Editable = "Cheque DateEditable";
                    Visible = false;
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                    Editable = "Cheque Bank and BranchEditable";
                    Visible = false;
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                    Editable = "Deposit/Paid BankEditable";
                    Visible = false;
                }
                field("Deposit / Paid Bank Name"; Rec."Deposit / Paid Bank Name")
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
                field("Posting date"; Rec."Posting date")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    Visible = false;
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                    Editable = false;
                    Visible = false;
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
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        AssociateTransferAmountEditabl := TRUE;
        "Deposit/Paid BankEditable" := TRUE;
        "Cheque Bank and BranchEditable" := TRUE;
        "Cheque DateEditable" := TRUE;
        ChequeNoTransactionNoEditable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        AssociateTransferAmountEditabl := FALSE;
    end;

    var
        TotalApplAmt2: Decimal;
        TotalRcvdAmt2: Decimal;
        AppPayEntryRec: Record "Application Payment Entry";

        ChequeNoTransactionNoEditable: Boolean;

        "Cheque DateEditable": Boolean;

        "Cheque Bank and BranchEditable": Boolean;

        "Deposit/Paid BankEditable": Boolean;

        AssociateTransferAmountEditabl: Boolean;


    procedure UpdatePAGE2()
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
    end;
}

