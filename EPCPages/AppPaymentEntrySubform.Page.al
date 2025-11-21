page 97946 "App Payment Entry Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Application Payment Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment Mode"; Rec."Payment Mode")
                {
                    Editable = "Payment ModeEditable";
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
                    end;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = true;
                    Visible = false;
                }
                field("Provisional Rcpt. No."; Rec."Provisional Rcpt. No.")
                {
                    Visible = true;
                }
                field("User Branch Name"; Rec."User Branch Name")
                {
                    Editable = false;
                }
                field("Order Ref No."; Rec."Order Ref No.")
                {
                    Visible = false;
                }
                field("Explode BOM"; Rec."Explode BOM")
                {
                    Caption = 'Explode ';
                    Editable = false;
                    Visible = false;
                }
                field("Posting date"; Rec."Posting date")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = AmountEditable;

                    trigger OnValidate()
                    var
                        BondPaymentEntry: Record "Unit Payment Entry";
                    begin
                        AmountOnAfterValidate;
                    end;
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
                }
                field(Approved; Rec.Approved)
                {
                }
                field("Approved By"; Rec."Approved By")
                {
                }
                field("Approved Date"; Rec."Approved Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
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

    trigger OnDeleteRecord(): Boolean
    var
        Application: Record Application;
    begin
        Rec.TESTFIELD(Posted, FALSE);
    end;

    trigger OnInit()
    begin
        AmountEditable := TRUE;
        "Payment ModeEditable" := TRUE;
        "Deposit/Paid BankEditable" := TRUE;
        "Cheque Bank and BranchEditable" := TRUE;
        "Cheque DateEditable" := TRUE;
        ChequeNoTransactionNoEditable := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.GetAmounts(TotalApplAmt, TotalRcvdAmt);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF Rec."Not Refundable" THEN
            ERROR(Text0001);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.GetAmounts(TotalApplAmt, TotalRcvdAmt);
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN BEGIN
            ChequeNoTransactionNoEditable := FALSE;
            "Cheque DateEditable" := FALSE;
            "Cheque Bank and BranchEditable" := FALSE;
            "Deposit/Paid BankEditable" := FALSE;
        END ELSE BEGIN
            ChequeNoTransactionNoEditable := NOT Rec.Posted;
            "Cheque DateEditable" := NOT Rec.Posted;
            "Cheque Bank and BranchEditable" := NOT Rec.Posted;
            "Deposit/Paid BankEditable" := NOT Rec.Posted;
        END;
    end;

    var
        Text0001: Label 'You cannot change the detail payment line with Service Charge Amount.';
        Text0002: Label 'Please enter a valid check date.';
        Application: Record Application;
        TotalApplAmt: Decimal;
        TotalRcvdAmt: Decimal;
        BondPaymentEntry: Record "Application Payment Entry";
        Text0003: Label 'There is no cheque to clear';
        Cnt: Integer;

        ChequeNoTransactionNoEditable: Boolean;

        "Cheque DateEditable": Boolean;

        "Cheque Bank and BranchEditable": Boolean;

        "Deposit/Paid BankEditable": Boolean;

        "Payment ModeEditable": Boolean;

        AmountEditable: Boolean;


    procedure ChangeEditMode(Mode: Boolean; ForChqClearing: Boolean)
    begin
        "Payment ModeEditable" := Mode;
        //CurrPAGE.Description.EDITABLE := Mode;
        "Deposit/Paid BankEditable" := Mode;
        AmountEditable := Mode;
        ChequeNoTransactionNoEditable := Mode;
        "Cheque DateEditable" := Mode;
        "Cheque Bank and BranchEditable" := Mode;
        //CurrPAGE."Cheque Clearance Date".EDITABLE(ForChqClearing);
    end;


    procedure UpdatePAGE()
    begin
        Rec.GetAmounts(TotalApplAmt, TotalRcvdAmt);
    end;

    local procedure AmountOnAfterValidate()
    begin
        Rec.GetAmounts(TotalApplAmt, TotalRcvdAmt);
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN BEGIN
            ChequeNoTransactionNoEditable := FALSE;
            "Cheque DateEditable" := FALSE;
            "Cheque Bank and BranchEditable" := FALSE;
            "Deposit/Paid BankEditable" := FALSE;
        END ELSE BEGIN
            ChequeNoTransactionNoEditable := NOT Rec.Posted;
            "Cheque DateEditable" := NOT Rec.Posted;
            "Cheque Bank and BranchEditable" := NOT Rec.Posted;
            "Deposit/Paid BankEditable" := NOT Rec.Posted;
        END;
        Rec.GetAmounts(TotalApplAmt, TotalRcvdAmt);
    end;
}

