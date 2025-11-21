page 50092 "NewUnit PEntry Refund  Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "NewApplication Payment Entry";
    SourceTableView = WHERE("Payment Mode" = FILTER("Refund Cash" | "Refund Bank" | "Negative Adjmt."));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    OptionCaption = ' ,,,,,,Refund Cash,Refund Cheque,,,,Negative Adjmt.';

                    trigger OnValidate()
                    var
                        NewConfirmedOrder_L: Record "New Confirmed Order";
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

                        //291222
                        IF (Rec."Payment Mode" = Rec."Payment Mode"::"Refund Bank") OR (Rec."Payment Mode" = Rec."Payment Mode"::"Refund Cash") THEN BEGIN
                            NewConfirmedOrder_L.RESET;
                            IF NewConfirmedOrder_L.GET(Rec."Document No.") THEN BEGIN
                                UserSetup.RESET;
                                UserSetup.SETRANGE("User ID", USERID);
                                UserSetup.SETRANGE("Direct Refund", TRUE);
                                IF NOT UserSetup.FINDFIRST THEN
                                    NewConfirmedOrder_L.TESTFIELD(NewConfirmedOrder_L."Refund SMS Status", NewConfirmedOrder_L."Refund SMS Status"::Approved);
                            END;
                        END;
                        //291222
                    end;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = all;
                    //Editable = false;
                }
                field("Chq. Cl / Bounce Dt."; Rec."Chq. Cl / Bounce Dt.")
                {
                    Editable = false;
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
                field("Bank Type"; Rec."Bank Type")
                {
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                    //Editable = "Deposit/Paid BankEditable";
                    Visible = true;
                }
                field("Refund Amount"; Rec."Refund Amount")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Adjmt. Line No."; Rec."Adjmt. Line No.")
                {
                }
                field("User Branch Name"; Rec."User Branch Name")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                }
                field(Narration; Rec.Narration)
                {
                }
                field("Provisional Rcpt. No."; Rec."Provisional Rcpt. No.")
                {
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                }
                field("LD Amount"; Rec."LD Amount")
                {
                }
                field("Order Ref No."; Rec."Order Ref No.")
                {
                    Visible = false;
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                    Editable = "Cheque Bank and BranchEditable";
                    Visible = false;
                }
                field("Deposit / Paid Bank Name"; Rec."Deposit / Paid Bank Name")
                {
                    Visible = true;
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
                field("User Branch Code"; Rec."User Branch Code")
                {
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

        ChequeNoTransactionNoEditable: Boolean;

        "Cheque DateEditable": Boolean;

        "Cheque Bank and BranchEditable": Boolean;

        "Deposit/Paid BankEditable": Boolean;
        UserSetup: Record "User Setup";


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

