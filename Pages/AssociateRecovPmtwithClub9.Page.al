page 50004 "Associate Recov Pmt with Club9"
{
    // ALLERP AlleHF 07-09-2010: Applying HF1 to HF5
    // ALLERP BugFix 30-11-2010: Length of AccName and BAccName increased from 30 to 50
    // ALLEPG 270711 : Added HotFix PS60184 for Service Tax.

    AutoSplitKey = true;
    Caption = 'Associate Recov Pmt with Club9';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Card;
    SaveValues = true;
    SourceTable = "Gen. Journal Line";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SAVERECORD;
                    GenJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(FALSE);
                end;

                trigger OnValidate()
                begin
                    GenJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Group)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Party Type"; Rec."Party Type")
                {
                }
                field("Party Code"; Rec."Party Code")
                {
                }
                field("Account Type"; Rec."Account Type")
                {

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field("Account No."; Rec."Account No.")
                {

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description; Rec.Description)
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                }
                field("Order Ref No."; Rec."Order Ref No.")
                {
                    Visible = false;
                }
                field("Ref Document Type"; Rec."Ref Document Type")
                {
                    Visible = false;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    Editable = true;
                    Visible = false;
                }
                field(Verified; Rec.Verified)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Visible = false;
                }
                field("T.A.N. No."; Rec."T.A.N. No.")
                {
                    Visible = true;
                }
                field("T.C.A.N. No."; Rec."T.C.A.N. No.")
                {
                    Visible = false;
                }

                field("TCS Nature of Collection"; Rec."TCS Nature of Collection")
                {
                    Visible = false;
                }

                field("Work Tax Nature Of Deduction"; Rec."Work Tax Nature Of Deduction")
                {
                    Visible = false;
                }

                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    Visible = false;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    AssistEdit = true;
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            Rec.VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    Editable = false;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Vendor Cheque Amount"; Rec."Vendor Cheque Amount")
                {
                }
                field(Amount; Rec.Amount)
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    Visible = false;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    Visible = false;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    Visible = false;
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                    Visible = false;
                }
                field("Bal. VAT Amount"; Rec."Bal. VAT Amount")
                {
                    Visible = false;
                }
                field("Bal. VAT Difference"; Rec."Bal. VAT Difference")
                {
                    Visible = false;
                }
                field("Insurance No."; Rec."Insurance No.")
                {
                    Visible = false;
                }
                field("Bal. Gen. Posting Type"; Rec."Bal. Gen. Posting Type")
                {
                    Visible = false;
                }
                field("Bal. Gen. Bus. Posting Group"; Rec."Bal. Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Bal. Gen. Prod. Posting Group"; Rec."Bal. Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Bal. VAT Bus. Posting Group"; Rec."Bal. VAT Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Bal. VAT Prod. Posting Group"; Rec."Bal. VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    Visible = true;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    Visible = true;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    Visible = true;
                }
                field("Bank Payment Type"; Rec."Bank Payment Type")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    Visible = true;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    Visible = true;
                }
                field("Check Printed"; Rec."Check Printed")
                {
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    Visible = false;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    Visible = false;
                }
                field("Project Unit No."; Rec."Project Unit No.")
                {
                    Visible = false;
                }
                field(Reason; Rec.Reason)
                {
                    Visible = false;
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                    Visible = false;
                }
                field("Cheque clear Date"; Rec."Cheque clear Date")
                {
                    Visible = false;
                }
                field("LC/BG No."; Rec."LC/BG No.")
                {
                    Visible = false;
                }
                field("BG Charges Type"; Rec."BG Charges Type")
                {
                    Visible = false;
                }
                field("Club9 Charge Amount"; Rec."Club9 Charge Amount")
                {
                    Visible = false;
                }

            }
            group(Group2)
            {
                field(AccName; AccName)
                {
                    Caption = 'Account Name';
                    Editable = false;
                }
                label("1")
                {
                    CaptionClass = Text19060954;
                }
                field(BalAccName; BalAccName)
                {
                    Caption = 'Bal. Account Name';
                    Editable = false;
                }
                label("2")
                {
                    CaptionClass = Text19013901;
                }
                label("3")
                {
                    CaptionClass = Text19071799;
                }
                label("4")
                {
                    CaptionClass = Text19061417;
                }
                field(TotalDebitAmount; TotalDebitAmount)
                {
                    Editable = false;
                }
                field(Balance; Balance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                {
                    AutoFormatType = 1;
                    Caption = 'Balance';
                    Editable = false;
                    Visible = BalanceVisible;
                }
                field(TotalBalance; TotalBalance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                {
                    AutoFormatType = 1;
                    Caption = 'Total Balance';
                    Editable = false;
                    Visible = TotalBalanceVisible;
                }
                label("5")
                {
                    CaptionClass = Text19047064;
                }
                field(TotalCreditAmount; TotalCreditAmount)
                {
                    Editable = false;
                }
                field(BankChrgAmt; BankChrgAmt)
                {
                    Caption = 'BankCharg/Club9Charges';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Narration")
            {
                Caption = '&Narration';
                action("Line Narration")
                {
                    Caption = 'Line Narration';
                    RunObject = Page "Gen. Journal Voucher Narration";// 16572;
                    RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                  "Journal Batch Name" = FIELD("Journal Batch Name"),
                                  "Gen. Journal Line No." = FIELD("Line No."),
                                  "Document No." = FIELD("Document No.");
                    ShortCutKey = 'Shift+Ctrl+N';
                }
                action("Voucher Narration")
                {
                    Caption = 'Voucher Narration';
                    RunObject = Page "Gen. Journal Voucher Narration";// 16573;
                    RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                  "Journal Batch Name" = FIELD("Journal Batch Name"),
                                  "Document No." = FIELD("Document No."),
                                  "Gen. Journal Line No." = FILTER(0);
                    ShortCutKey = 'Shift+Ctrl+V';
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                action("Bank Charges")
                {
                    Caption = 'Bank Charges';
                    RunObject = Page "Journal Bank Charges";// 16520;
                    RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                  "Journal Batch Name" = FIELD("Journal Batch Name"),
                                  "Line No." = FIELD("Line No.");
                    RunPageView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.", "Bank Charge");
                }
            }
            group("A&ccount")
            {
                Caption = 'A&ccount';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    RunObject = Codeunit "Gen. Jnl.-Show Entries";
                    ShortCutKey = 'Ctrl+F7';
                }
            }
            group("&Payments")
            {
                Caption = '&Payments';
                action("Suggest Vendor Payments")
                {
                    Caption = 'Suggest Vendor Payments';
                    Ellipsis = true;
                    Image = SuggestVendorPayments;

                    trigger OnAction()
                    begin
                        CreateVendorPmtSuggestion.SetGenJnlLine(Rec);
                        CreateVendorPmtSuggestion.RUNMODAL;
                        CLEAR(CreateVendorPmtSuggestion);
                    end;
                }
                action("P&review Check")
                {
                    Caption = 'P&review Check';

                    trigger OnAction()
                    begin
                        //CalcTDS(Rec."Document No.");
                        PAGE.RUN(PAGE::"Check Preview", Rec);
                    end;
                }
                action("Print Check")
                {
                    Caption = 'Print Check';
                    Ellipsis = true;
                    Image = PrintCheck;

                    trigger OnAction()
                    begin
                        GenJnlLine.RESET;
                        GenJnlLine.COPY(Rec);
                        GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                        GenJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                        IF GenJnlLine.FINDFIRST THEN BEGIN
                            //GenJnlLine.CalcTDS(Rec."Document No.");
                            COMMIT;
                        END;
                        DocPrint.PrintCheck(GenJnlLine);
                        CODEUNIT.RUN(CODEUNIT::"Adjust Gen. Journal Balance", Rec);
                    end;
                }
                action("Void Check")
                {
                    Caption = 'Void Check';
                    Image = VoidCheck;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Bank Payment Type", Rec."Bank Payment Type"::"Computer Check");
                        Rec.TESTFIELD("Check Printed", TRUE);
                        IF NOT GLSetup."Activate Cheque No." THEN BEGIN
                            IF CONFIRM(Text000, FALSE, Rec."Document No.") THEN
                                CheckManagement.VoidCheck(Rec);
                        END ELSE BEGIN
                            IF CONFIRM(Text000, FALSE, Rec."Cheque No.") THEN
                                CheckManagement.VoidCheck(Rec);
                        END;
                    end;
                }
                action("Void &All Checks")
                {
                    Caption = 'Void &All Checks';

                    trigger OnAction()
                    begin
                        IF CONFIRM(Text001, FALSE) THEN BEGIN
                            GenJnlLine.RESET;
                            GenJnlLine.COPY(Rec);
                            GenJnlLine.SETRANGE("Bank Payment Type", Rec."Bank Payment Type"::"Computer Check");
                            GenJnlLine.SETRANGE("Check Printed", TRUE);
                            IF GenJnlLine.FIND('-') THEN
                                REPEAT
                                    GenJnlLine2 := GenJnlLine;
                                    CheckManagement.VoidCheck(GenJnlLine2);
                                UNTIL GenJnlLine.NEXT = 0;
                        END;
                    end;
                }
                group("Tax Payments")
                {
                    Caption = 'Tax Payments';
                    action(Excise)
                    {
                        Caption = 'Excise';

                        trigger OnAction()
                        begin
                            //PaymentofTaxes.PayExcise(Rec)
                        end;
                    }
                    action("Sales Tax")
                    {
                        Caption = 'Sales Tax';

                        trigger OnAction()
                        begin
                            // PaymentofTaxes.PaySalesTax(Rec)
                        end;
                    }
                    action(TDS)
                    {
                        Caption = 'TDS';

                        trigger OnAction()
                        begin
                            //PaymentofTaxes.PayTDS(Rec)
                        end;
                    }
                    action(TCS)
                    {
                        Caption = 'TCS';

                        trigger OnAction()
                        begin
                            //PaymentofTaxes.PayTCS(Rec)
                        end;
                    }
                    action(Worktax)
                    {
                        Caption = 'Worktax';

                        trigger OnAction()
                        begin
                            //PaymentofTaxes.PayWorkTax(Rec)
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Apply Entries")
                {
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    RunObject = Codeunit "Gen. Jnl.-Apply";
                    ShortCutKey = 'Shift+F11';
                }
                action("Insert Conv. LCY Rndg. Lines")
                {
                    Caption = 'Insert Conv. LCY Rndg. Lines';
                    RunObject = Codeunit "Adjust Gen. Journal Balance";
                }
                action("Calculate TDS")
                {
                    Caption = 'Calculate TDS';

                    trigger OnAction()
                    begin
                        //CalcTDS('');
                    end;
                }
                action("Update Club9 Charges")
                {
                    Caption = 'Update Club9 Charges';
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    var
                        GnlJnl: Record "Gen. Journal Line";
                    begin
                        GnlJnl.RESET;
                        GnlJnl.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                        GnlJnl.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                        IF GnlJnl.FINDSET THEN
                            REPEAT
                                IF GnlJnl."Vendor Cheque Amount" <> 0 THEN
                                    CheckVendorChequeAmount(GnlJnl);
                            UNTIL GnlJnl.NEXT = 0;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action(Reconcile)
                {
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';

                    trigger OnAction()
                    begin
                        GLReconcile.SetGenJnlLine(Rec);
                        GLReconcile.RUN;
                    end;
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintGenJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Rec.SETRANGE(Verified, TRUE);
                        IF Rec.COUNT = 0 THEN
                            ERROR('Please verify the documents');

                        GenJnlLine.RESET;
                        GenJnlLine.SETFILTER("Journal Template Name", Rec."Journal Template Name");
                        GenJnlLine.SETFILTER("Journal Batch Name", Rec."Journal Batch Name");
                        GenJnlLine.SETRANGE(Verified, TRUE);
                        IF GenJnlLine.FINDSET THEN
                            REPEAT
                                GenJnlLine.CALCFIELDS("Club9 Charge Amount");
                                UnitSetup.GET;
                                IF GenJnlLine."Club9 Charge Amount" = 0 THEN
                                    ERROR('Please update Club9 Charges before posting');
                                CheckRoundAmount(GenJnlLine, -(GenJnlLine.Amount * UnitSetup."Corpus %" / 100));
                                IF GenJnlLine."Club9 Charge Amount" <> (-(GenJnlLine.Amount * UnitSetup."Corpus %" / 100) + RoundOff) THEN
                                    ERROR('Please update Club9 Charges before posting');
                            UNTIL GenJnlLine.NEXT = 0;
                        //ALLE-PKS10

                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := Rec.GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        TotalBalanceVisible := TRUE;
        BalanceVisible := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateBalance;
        UpdateDebitCreditAmount;
        Rec.SetUpNewLine(xRec, Balance, BelowxRec);
        CLEAR(ShortcutDimCode);
        Rec."Posting Type" := Rec."Posting Type"::Commission;
        Rec."Bal. Account Type" := Rec."Bal. Account Type"::"G/L Account";
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
        GnlTemplate: Record "Gen. Journal Template";
    begin
        BalAccName := '';
        OpenedFromBatch := (Rec."Journal Batch Name" <> '') AND (Rec."Journal Template Name" = '');
        IF OpenedFromBatch THEN BEGIN
            CurrentJnlBatchName := Rec."Journal Batch Name";
            GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            EXIT;
        END;
        GnlTemplate.RESET;
        GnlTemplate.SETRANGE("Page ID", (PAGE::"Associate Recov Pmt with Club9"));
        IF NOT GnlTemplate.FINDFIRST THEN
            ERROR('Associate Recovery Journal Template setup does not exist');
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Assoc. Recov. Temp Name", GnlTemplate.Name);
        UnitSetup.TESTFIELD("Assoc. Recov. Batch Name");
        //GenJnlManagement.TemplateSelectionForVouchers(PAGE::"Bank Payment Voucher",FALSE,4,Rec,JnlSelected);
        GenJnlManagement.TemplateSelection(PAGE::"Associate Recov Pmt with Club9", 0, FALSE, Rec, JnlSelected);
        IF NOT JnlSelected THEN
            ERROR('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
        GLSetup.GET;
    end;

    var
        Text000: Label 'Void Check %1?';
        Text001: Label 'Void all printed checks?';
        ChangeExchangeRate: Page "Change Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GLReconcile: Page Reconciliation;
        CreateVendorPmtSuggestion: Report "Suggest Vendor Payments";
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        DocPrint: Codeunit "Document-Print";
        CheckManagement: Codeunit CheckManagement;
        GLSetup: Record "General Ledger Setup";
        CurrentJnlBatchName: Code[10];
        AccName: Text[50];
        BalAccName: Text[50];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        TotalCreditAmount: Decimal;
        TotalDebitAmount: Decimal;
        //PaymentofTaxes: Codeunit "Payment of Taxes";// 13705;
        OpenedFromBatch: Boolean;
        BankChrgAmt: Decimal;
        genline: Record "Gen. Journal Line";
        UnitSetup: Record "Unit Setup";
        RoundOff: Decimal;


        BalanceVisible: Boolean;

        TotalBalanceVisible: Boolean;
        Text19060954: Label 'Cheque No.';
        Text19013901: Label 'Debit Amount';
        Text19071799: Label 'Total Debit Amount';
        Text19061417: Label 'Credit Amount';
        Text19047064: Label 'Total Credit Amount';

    local procedure UpdateBalance()
    begin
        GenJnlManagement.CalcBalance(
          Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        //GenJnlManagement.UpdateBankCharges(Rec, BankChrgAmt);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    local procedure UpdateDebitCreditAmount()
    begin
        //GenJnlManagement.CalcTotDebitTotCreditAmount(Rec, TotalDebitAmount, TotalCreditAmount, FALSE);
    end;


    procedure CheckVendorChequeAmount(RecGnlJnlLine: Record "Gen. Journal Line")
    var
        JnlBankCharge: Record "Journal Bank Charges";// 16511;
        BankCharge: Record "Bank Charge";// 16510;
        TCSEntry: Record "TCS Entry";// 16514;
        TCSAmountApplied: Decimal;
        TDSAmount: Decimal;
        TCSAmount: Decimal;
        TotalAmount: Decimal;
        RoundAmt: Decimal;
        RecBankChrgAmt: Decimal;
        NewBankChrgAmt: Decimal;
    begin
        BankCharge.RESET;
        BankCharge.SETRANGE(Club9, TRUE);
        IF NOT BankCharge.FINDFIRST THEN
            ERROR('Create Bank Charge Code for Club9 Charges');
        NewBankChrgAmt := 0;
        RecBankChrgAmt := 0;
        UnitSetup.GET;
        //RecBankChrgAmt:=-ROUND((RecGnlJnlLine.Amount*UnitSetup."Corpus %"/100),1);
        RecBankChrgAmt := -(RecGnlJnlLine.Amount * UnitSetup."Corpus %" / 100);
        JnlBankCharge.RESET;
        JnlBankCharge.SETRANGE("Journal Template Name", RecGnlJnlLine."Journal Template Name");
        JnlBankCharge.SETRANGE("Journal Batch Name", RecGnlJnlLine."Journal Batch Name");
        JnlBankCharge.SETRANGE("Line No.", RecGnlJnlLine."Line No.");
        JnlBankCharge.SETRANGE("Bank Charge", BankCharge.Code);
        IF NOT JnlBankCharge.FINDFIRST THEN BEGIN
            JnlBankCharge.INIT;
            JnlBankCharge."Journal Template Name" := RecGnlJnlLine."Journal Template Name";
            JnlBankCharge."Journal Batch Name" := RecGnlJnlLine."Journal Batch Name";
            JnlBankCharge."Line No." := RecGnlJnlLine."Line No.";
            JnlBankCharge.VALIDATE("Bank Charge", BankCharge.Code);
            JnlBankCharge.VALIDATE(Amount, RecBankChrgAmt);
            JnlBankCharge.INSERT;
            CheckRoundAmount(RecGnlJnlLine, RecBankChrgAmt);
            NewBankChrgAmt := JnlBankCharge.Amount + RoundOff;
            JnlBankCharge.VALIDATE(Amount, NewBankChrgAmt);
            JnlBankCharge.MODIFY;
        END ELSE BEGIN
            CheckRoundAmount(RecGnlJnlLine, RecBankChrgAmt);
            NewBankChrgAmt := RecBankChrgAmt + RoundOff;
            JnlBankCharge.VALIDATE(Amount, NewBankChrgAmt);
            JnlBankCharge.MODIFY;
        END;
    end;


    procedure CheckRoundAmount(JnlLine: Record "Gen. Journal Line"; BankChargeAmt: Decimal)
    var
        JnlBankCharge: Record "Journal Bank Charges";// 16511;
        BankCharge: Record "Bank Charge";// 16510;
        UnitSetup: Record "Unit Setup";
        TCSEntry: Record "TCS Entry";// 16514;
        TCSAmountApplied: Decimal;
        TDSAmount: Decimal;
        TCSAmount: Decimal;
        TotalAmount: Decimal;
        RoundAmt: Decimal;
    begin
        CLEAR(TDSAmount);
        CLEAR(TCSAmount);
        CLEAR(TotalAmount);
        CLEAR(TCSAmountApplied);
        CLEAR(RoundOff);
        TCSEntry.RESET;
        TCSEntry.SETRANGE("Document Type", JnlLine."Applies-to Doc. Type");
        TCSEntry.SETRANGE("Document No.", JnlLine."Applies-to Doc. No.");
        IF TCSEntry.FINDFIRST THEN
            REPEAT
                TCSAmountApplied += TCSEntry."TCS Amount" + TCSEntry."Surcharge Amount" + TCSEntry."eCESS Amount"
                 + TCSEntry."SHE Cess Amount";
            UNTIL (TCSEntry.NEXT = 0);

        IF Rec."TDS Section Code" <> '' THEN
            TDSAmount := JnlLine."GST TDS/TCS Base Amount";//  "Total TDS/TCS Incl. SHE CESS";
        IF Rec."TCS Nature of Collection" <> '' THEN
            TCSAmount := JnlLine."GST TDS/TCS Base Amount";//"Total TDS/TCS Incl. SHE CESS";

        TotalAmount := JnlLine."Amount (LCY)" - TDSAmount + TCSAmount + TCSAmountApplied + BankChargeAmt;// - JnlLine."Work Tax Amount"
        //ALLETDK100213>>
        IF TotalAmount <> JnlLine."Vendor Cheque Amount" THEN
            RoundOff := JnlLine."Vendor Cheque Amount" - TotalAmount
        /*
        IF TotalAmount < ROUND(TotalAmount,1) THEN
          RoundOff:=(ROUND(TotalAmount,1)-1)-TotalAmount
        ELSE
          RoundOff:=-(TotalAmount-(ROUND(TotalAmount,1)));
        */
        //ALLETDK100213<<

    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SAVERECORD;
        GenJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        UpdateBalance;
        UpdateDebitCreditAmount;
    end;

    local procedure OnBeforePutRecord()
    begin
        UpdateBalance;
        UpdateDebitCreditAmount;
    end;
}

