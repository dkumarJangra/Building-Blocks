page 50009 "Posted General Ledger Entries"
{
    // //NDALLE 240108 Code to Update Global Dimension in GL objects
    // ALLERP 03-09-2010: Menu Item added for applying HF1 on 6.0 SP1.

    Caption = 'General Ledger Entries';
    DataCaptionExpression = GetCaption;
    Editable = false;
    PageType = Card;
    SourceTable = "G/L Entry";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    DrillDown = false;
                    Visible = true;
                }
                field(Description; Rec.Description)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Posting Type"; Rec."BBG Posting Type")
                {
                    Visible = false;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                }
                // field("Location Code"; Rec."BBG Location Code")
                // {
                //     Visible = false;
                // }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    Visible = false;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    Visible = false;
                }
                field("Source Code"; Rec."Source Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Source No."; Rec."Source No.")
                {
                    Visible = false;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field(Narration; Rec."BBG Narration")
                {
                    Visible = false;
                }
                field(Reversed; Rec.Reversed)
                {
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    Visible = false;
                }
                field("User ID"; Rec."User ID")
                {
                    Visible = true;
                }
                field("Verified By"; Rec."BBG Verified By")
                {
                    Visible = false;
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    Visible = false;
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    Visible = false;
                }
                field("FA Entry Type"; Rec."FA Entry Type")
                {
                    Visible = false;
                }
                field("FA Entry No."; Rec."FA Entry No.")
                {
                    Visible = false;
                }
                field("TO Region code"; Rec."BBG TO Region code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("TO Region Name"; Rec."BBG TO Region Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    Visible = false;
                }
                field("Additional-Currency Amount"; Rec."Additional-Currency Amount")
                {
                    Visible = false;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Prior-Year Entry"; Rec."Prior-Year Entry")
                {
                    Visible = false;
                }
                field("Cheque No."; Rec."BBG Cheque No.")
                {
                }
                field("Cheque Date"; Rec."BBG Cheque Date")
                {
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                    Visible = false;
                }
                field("Order Ref No."; Rec."BBG Order Ref No.")
                {
                    Editable = false;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                        CurrPage.SAVERECORD;
                    end;
                }
                action("G/L Dimension Overview")
                {
                    Caption = 'G/L Dimension Overview';

                    trigger OnAction()
                    begin
                        PAGE.RUN(PAGE::"G/L Entries Dimension Overview", Rec);
                    end;
                }
                action("Value Entries")
                {
                    Caption = 'Value Entries';
                    Image = ValueLedger;

                    trigger OnAction()
                    begin
                        Rec.ShowValueEntries;
                    end;
                }
                action("&Narration")
                {
                    Caption = 'Narration';
                    RunObject = Page "Posted Narration";// "Posted Narrations";// 16578;
                    RunPageLink = "Entry No." = FILTER(0),
                                  "Transaction No." = FIELD("Transaction No.");
                }
                action("Line Narration")
                {
                    Caption = 'Line Narration';
                    RunObject = Page "Posted Narration";// 16578;
                    RunPageLink = "Entry No." = FIELD("Entry No."),
                                  "Transaction No." = FIELD("Transaction No.");
                }
                action("Print Voucher")
                {
                    Caption = 'Print Voucher';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                        GLEntry.SETRANGE("Document No.", Rec."Document No.");
                        GLEntry.SETRANGE("Posting Date", Rec."Posting Date");
                        IF GLEntry.FINDFIRST THEN
                            REPORT.RUNMODAL(REPORT::"Posted Voucher", TRUE, TRUE, GLEntry);
                    end;
                }
                action("Update Posted Dimesion")
                {
                    Caption = 'Update Posted Dimesion';

                    trigger OnAction()
                    begin
                        // ALLEAA Begin
                        IF AccountingPeriod.GET(DMY2DATE(1, DATE2DMY(Rec."Posting Date", 2), DATE2DMY(Rec."Posting Date", 3))) AND AccountingPeriod.Closed THEN
                            ERROR(Text50000);
                        // ALLEAA End
                        // ALLE MM Code Commented as Member of table has been removed in NAV 2016
                        /*
                         Memberof.RESET;
                         Memberof.SETRANGE("User ID",USERID);
                         Memberof.SETFILTER("Role ID",'DIMCORRECT');
                         IF NOT Memberof.FINDFIRST THEN
                            BEGIN
                             ERROR('Sorry you are not authorised to run this Process');
                            END;
                            */
                        // ALLE MM Code Commented as Member of table has been removed in NAV 2016
                        //NDALLE 240108
                        //    CLEAR(UpdateGlobalDimensionReport);
                        //   UpdateGlobalDimensionReport.SetEntryNo("Document No.","Posting Date","Entry No.");
                        //  UpdateGlobalDimensionReport.RUNMODAL;
                        //NDALLE 240108

                    end;
                }
                action("Bank Charges")
                {
                    Caption = 'Bank Charges';
                    RunObject = Page "Posted Journal Bank Charges";// 16521;
                    RunPageLink = "GL Entry No." = FIELD("Entry No.");
                    RunPageView = SORTING("GL Entry No.", "Bank Charge");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Reverse Transaction")
                {
                    Caption = 'Reverse Transaction';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                    begin
                        CLEAR(ReversalEntry);
                        IF Rec.Reversed THEN
                            ReversalEntry.AlreadyReversedEntry(Rec.TABLECAPTION, Rec."Entry No.");
                        IF Rec."Journal Batch Name" = '' THEN
                            ReversalEntry.TestFieldError;
                        Rec.TESTFIELD("Transaction No.");
                        ReversalEntry.ReverseTransaction(Rec."Transaction No.")
                    end;
                }
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF "TO Region code" <> '' THEN BEGIN
            DimValRec.RESET;
            DimValRec.SETFILTER(DimValRec."Dimension Code", 'TO REGION');
            DimValRec.SETFILTER(DimValRec.Code, "TO Region code");
            IF DimValRec.FINDFIRST THEN
                Rec."BBG TO Region Name" := DimValRec.Name;
        END;
    end;

    trigger OnOpenPage()
    begin
        Rec.SETRANGE("User ID", USERID); //BBG1.00 050413
    end;

    var
        GLAcc: Record "G/L Account";
        Navigate: Page Navigate;
        "TO Region Code": Code[20];
        DimValRec: Record "Dimension Value";
        AccountingPeriod: Record "Accounting Period";
        Text50000: Label 'Posting date lies in the closed fiscal year. You can''t change the dimension.';

    local procedure GetCaption(): Text[250]
    begin
        IF GLAcc."No." <> Rec."G/L Account No." THEN
            IF NOT GLAcc.GET(Rec."G/L Account No.") THEN
                IF Rec.GETFILTER("G/L Account No.") <> '' THEN
                    IF GLAcc.GET(Rec.GETRANGEMIN("G/L Account No.")) THEN;
        EXIT(STRSUBSTNO('%1 %2', GLAcc."No.", GLAcc.Name))
    end;
}

