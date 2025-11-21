page 50262 "Posted Item Revalue on FG Item"
{
    Caption = 'Item Revaluation Jnl. on FG Item';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Land Agreement Expense";
    SourceTableView = WHERE("Document Line No." = CONST(0),
                            "JV Posted" = CONST(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    Editable = false;
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
                field(Amount; Rec.Amount)
                {

                    trigger OnValidate()
                    begin
                        InventorySetup.GET;
                        InventorySetup.TESTFIELD("Int. Post. Group Finished Item");
                        Rec."Inventory Posting group" := InventorySetup."Int. Post. Group Finished Item";
                        Rec."Entry for FG Item" := TRUE;
                    end;
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
                field("FG Item No."; Rec."FG Item No.")
                {
                }
                field("Amount Load on Inventory"; Rec."Amount Load on Inventory")
                {
                    Visible = false;
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
                action("FG Item Revaluation")
                {

                    trigger OnAction()
                    var
                        TotalAmt: Decimal;
                    begin
                        IF CONFIRM('Do you want to Post Revaluation Journal Entry') THEN BEGIN
                            Rec.TESTFIELD("JV Posted", TRUE);
                            Rec.TESTFIELD("Item Revaluation Processed", FALSE);
                            Rec.TESTFIELD("FG Item No.");

                            LandAgreementExpense.RESET;
                            LandAgreementExpense.SETRANGE("Document No.", Rec."Document No.");
                            LandAgreementExpense.SETRANGE("Item Revaluation Processed", TRUE);
                            LandAgreementExpense.SETRANGE("Amount Load on Inventory", FALSE);
                            LandAgreementExpense.SETRANGE("Amount Proces Load on Invt.", TRUE);
                            LandAgreementExpense.SETRANGE("Document Line No.", 0);
                            LandAgreementExpense.SETFILTER("FG Item No.", '<>%1', '');
                            IF LandAgreementExpense.FINDFIRST THEN BEGIN
                                CLEAR(PurchPost);
                                //PurchPost.PostFGItemRevaluationJournal(Rec."Document No.", TRUE, Rec."Line No.");
                                COMMIT;
                                MESSAGE('Posting Done');
                            END ELSE
                                MESSAGE('Record not found');
                        END ELSE
                            MESSAGE('Nothing to Post');
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        InventorySetup.GET;
        InventorySetup.TESTFIELD("Int. Post. Group Finished Item");
        Rec."Entry for FG Item" := TRUE;
    end;

    var
        PurchPost: Codeunit "Purch.-Post";
        PurchaseHeader: Record "Purchase Header";
        LandAgreementExpense: Record "Land Agreement Expense";
        Reversed: Boolean;
        InventorySetup: Record "Inventory Setup";
}

