page 50260 "Posted Land Expens SubPage"
{
    AutoSplitKey = true;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Land Agreement Expense";
    SourceTableView = WHERE("JV Posted" = CONST(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Job Master Code"; Rec."Job Master Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field("Account No."; Rec."Account No.")
                {
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                }
                field("Bal. Account Name"; Rec."Bal. Account Name")
                {
                }
                field("TDS Nature of Deduction"; Rec."TDS Nature of Deduction")
                {
                }
                field("GST Group Code"; Rec."GST Group Code")
                {
                }
                field("GST Group Type"; Rec."GST Group Type")
                {
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Land Document Dimension"; Rec."Land Document Dimension")
                {
                }
                field("JV Posted"; Rec."JV Posted")
                {
                    Editable = false;
                }
                field("Posted JV Document No."; Rec."Posted JV Document No.")
                {
                    Editable = false;
                }
                field("JV Reversed"; Rec."JV Reversed")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function")
            {
                action("Item Revaluation")
                {

                    trigger OnAction()
                    var
                        TotalAmt: Decimal;
                    begin
                        IF CONFIRM('Do you want to Post Revaluation Journal Entry') THEN BEGIN
                            LandAgreementExpense.RESET;
                            LandAgreementExpense.SETRANGE("Document No.", Rec."Document No.");
                            LandAgreementExpense.SETRANGE("JV Posted", TRUE);
                            LandAgreementExpense.SETRANGE("JV Reversed", FALSE);
                            LandAgreementExpense.SETRANGE("Amount Load on Inventory", FALSE);
                            LandAgreementExpense.SETRANGE("Amount Proces Load on Invt.", FALSE);
                            IF LandAgreementExpense.FINDFIRST THEN BEGIN
                                CLEAR(PurchPost);
                                //PurchPost.PostRevaluationJournal(Rec."Document No.", TRUE, Rec."Document Line No.");
                                COMMIT;
                                MESSAGE('Posting Done');
                            END ELSE
                                MESSAGE('Record not found');
                        END ELSE
                            MESSAGE('Nothing to Post');
                    end;
                }
                action(ReverseTransaction)
                {
                    Caption = 'Reverse Transaction';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                        GLEntry: Record "G/L Entry";
                        VendorLedgerEntry: Record "Vendor Ledger Entry";
                        UserSetup: Record "User Setup";
                    begin
                        UserSetup.RESET;
                        IF UserSetup.GET(USERID) THEN
                            UserSetup.TESTFIELD("Allow Gold/Silver Restriction");

                        CLEAR(ReversalEntry);
                        Rec.TESTFIELD("JV Reversed", FALSE);
                        Rec.TESTFIELD("Posted JV Document No.");
                        GLEntry.RESET;
                        GLEntry.SETCURRENTKEY("Document No.");
                        GLEntry.SETRANGE("Document No.", Rec."Posted JV Document No.");
                        IF GLEntry.FINDFIRST THEN BEGIN
                            IF Reversed THEN
                                ReversalEntry.AlreadyReversedEntry(Rec.TABLECAPTION, GLEntry."Entry No.");
                            //IF "Journal Batch Name" = '' THEN
                            //ReversalEntry.TestFieldError;
                            GLEntry.TESTFIELD("Transaction No.");
                            ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");

                        END;

                        VendorLedgerEntry.RESET;
                        VendorLedgerEntry.SETCURRENTKEY("Document No.");
                        VendorLedgerEntry.SETRANGE("Document No.", Rec."Posted JV Document No.");
                        VendorLedgerEntry.SETRANGE(Reversed, TRUE);
                        IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                            Rec."JV Reversed" := TRUE;
                            Rec.MODIFY;
                        END;
                    end;
                }
            }
            action(Navigate)
            {

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    CLEAR(Navigate);
                    Navigate.SetDoc(Rec."Posting Date", Rec."Posted JV Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        PurchPost: Codeunit "Purch.-Post";
        PurchaseHeader: Record "Purchase Header";
        LandAgreementExpense: Record "Land Agreement Expense";
        Reversed: Boolean;
}

