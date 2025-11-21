page 97969 "Priority Unit Payment"
{
    // //SC : Write a code
    // //GKG : for open new record Ref Document Type 'Order'
    // ALLERP 03-09-2010: Control added for Include service tax base applying HF1 on 6.0 SP1.
    // ALLERP AlleHF 07-09-2010: Applying HF1 to HF5
    // ALLEPG 270711 : Added HotFix PS60184 for Service Tax.

    AutoSplitKey = true;
    Caption = 'General Journal';
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
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                    Visible = false;
                }
                // field("CWIP G/L Type"; "CWIP G/L Type")
                // {
                //     Visible = false;
                // }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Payment Mode"; Rec."Payment Mode")
                {

                    trigger OnValidate()
                    begin
                        IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN
                            "Bal. Account No.Editable" := FALSE
                        ELSE
                            "Bal. Account No.Editable" := TRUE;

                        IF Rec."Payment Mode" = Rec."Payment Mode"::" " THEN BEGIN
                            Rec."Bal. Account No." := '';
                            Rec."Bank Code" := '';
                        END;
                    end;
                }
                field("Bank Code"; Rec."Bank Code")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Bank Account List", BankAcc) = ACTION::LookupOK THEN BEGIN
                                Rec."Bank Code" := BankAcc."No.";
                                "Bank Name" := BankAcc.Name;
                            END;
                        END;
                    end;

                    trigger OnValidate()
                    begin
                        IF Rec."Bank Code" = '' THEN
                            "Bank Name" := ''
                        ELSE BEGIN
                            UnitSetup.GET;
                            IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN BEGIN
                                IF PaymentMethod.GET(UnitSetup."Cheque in Hand") THEN
                                    Rec."Bal. Account No." := PaymentMethod."Bal. Account No."
                                ELSE
                                    Rec."Bal. Account No." := '';
                            END;
                        END;
                        BankCodeOnAfterValidate;
                    end;
                }
                field("Bank Name"; "Bank Name")
                {
                    Caption = 'Bank Name';
                    Editable = false;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field(Extent; Rec.Extent)
                {
                    Editable = false;
                }
                field("Tran Type"; Rec."Tran Type")
                {
                    Visible = false;
                }
                field("Milestone Code"; Rec."Milestone Code")
                {
                    Visible = false;
                }
                field("Source Code"; Rec."Source Code")
                {
                    Visible = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Visible = false;
                }
                field(Correction; Rec.Correction)
                {
                    Visible = false;
                }
                field("Party Type"; Rec."Party Type")
                {
                    Visible = false;
                }
                field("Party Code"; Rec."Party Code")
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
                // field(PoT; PoT)
                // {
                //     Visible = false;
                // }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Account Type"; Rec."Account Type")
                {

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    Visible = true;
                }
                field("Account No."; Rec."Account No.")
                {

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);

                        Rec."Document Type" := Rec."Document Type"::Payment;
                    end;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                }
                field("TDS Certificate Receivable"; Rec."TDS Certificate Receivable")
                {
                    Visible = false;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                }
                // field("ST Pure Agent"; "ST Pure Agent")
                // {
                //     Visible = false;
                // }
                // field("Serv. Tax on Advance Payment"; "Serv. Tax on Advance Payment")
                // {
                //     Visible = false;
                // }
                // field("Service Tax Group Code"; "Service Tax Group Code")
                // {
                //     Visible = false;
                // }
                // field("Service Tax Registration No."; "Service Tax Registration No.")
                // {
                //     Visible = false;
                // }
                // field("Service Tax Type"; "Service Tax Type")
                // {
                //     Visible = false;
                // }
                // field("Service Type (Rev. Chrg.)"; "Service Type (Rev. Chrg.)")
                // {
                //     Visible = false;
                // }
                // field("Consignment Note No."; "Consignment Note No.")
                // {
                //     Visible = false;
                // }
                // field("Declaration Form (GTA)"; "Declaration Form (GTA)")
                // {
                //     Visible = false;
                // }
                field("T.C.A.N. No."; Rec."T.C.A.N. No.")
                {
                    Visible = false;
                }
                field("T.A.N. No."; Rec."T.A.N. No.")
                {
                    Visible = false;
                }
                // field("E.C.C. No."; "E.C.C. No.")
                // {
                //     Visible = false;
                // }
                field(Description; Rec.Description)
                {
                }
                field("TDS Nature of Deduction"; Rec."TDS Section Code")
                {
                    Visible = false;
                }
                field("TCS Nature of Collection"; Rec."TCS Nature of Collection")
                {
                    Caption = 'TCS Nature of Collection';
                    Visible = false;
                }
                // field("Assessee Code"; "Assessee Code")
                // {
                //     Visible = false;
                // }
                // field("TDS/TCS %"; "TDS/TCS %")
                // {
                //     Visible = false;
                // }
                // field("TDS/TCS Amount"; "TDS/TCS Amount")
                // {
                //     Visible = false;
                // }
                // field("Surcharge %"; "Surcharge %")
                // {
                //     Visible = false;
                // }
                // field("Surcharge Amount"; "Surcharge Amount")
                // {
                //     Visible = false;
                // }
                // field("eCESS %"; "eCESS %")
                // {
                //     Visible = false;
                // }
                // field("eCESS on TDS/TCS Amount"; "eCESS on TDS/TCS Amount")
                // {
                //     Visible = false;
                // }
                // field("SHE Cess % on TDS/TCS"; "SHE Cess % on TDS/TCS")
                // {
                //     Visible = false;
                // }
                // field("SHE Cess on TDS/TCS Amount"; "SHE Cess on TDS/TCS Amount")
                // {
                //     Visible = false;
                // }
                // field("Total TDS/TCS Incl. SHE CESS"; "Total TDS/TCS Incl. SHE CESS")
                // {
                //     Visible = false;
                // }
                field("Work Tax Nature Of Deduction"; Rec."Work Tax Nature Of Deduction")
                {
                    Visible = false;
                }
                // field("Work Tax Base Amount"; "Work Tax Base Amount")
                // {
                //     Visible = false;
                // }
                // field("Work Tax %"; "Work Tax %")
                // {
                //     Visible = false;
                // }
                // field("Work Tax Amount"; "Work Tax Amount")
                // {
                //     Visible = false;
                // }
                field("Business Unit Code"; Rec."Business Unit Code")
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
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
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
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    Editable = "Bal. Account No.Editable";

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
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
                field("Bill-to/Pay-to No."; Rec."Bill-to/Pay-to No.")
                {
                    Visible = false;
                }
                field("Ship-to/Order Address Code"; Rec."Ship-to/Order Address Code")
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
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    Visible = false;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    Visible = false;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    Visible = false;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    Visible = false;
                }
                field("On Hold"; Rec."On Hold")
                {
                    Visible = false;
                }
                field("Bank Payment Type"; Rec."Bank Payment Type")
                {
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    Visible = false;
                }
                // field("Service Tax Rounding Type"; "Service Tax Rounding Type")
                // {
                //     Visible = false;
                // }
                // field("Include Serv. Tax in TDS Base"; "Include Serv. Tax in TDS Base")
                // {
                //     Visible = false;
                // }
                field("Insurance No."; Rec."Insurance No.")
                {
                    Visible = false;
                }
                field("FA Posting Type"; Rec."FA Posting Type")
                {
                    Visible = false;
                }
                // field("Service Tax Rounding Precision"; "Service Tax Rounding Precision")
                // {
                //     Visible = false;
                // }
                field(Verified; Rec.Verified)
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
            }
            group(Group2)
            {
                field(AccName; AccName)
                {
                    Caption = 'Account Name';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(BalAccName; BalAccName)
                {
                    Caption = 'Bal. Account Name';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Shortcut Dimension 1 Code +' ' + CostCenterName"; Rec."Shortcut Dimension 1 Code" + ' ' + CostCenterName)
                {
                    Caption = 'Region';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("ShortcutDimCode3 + ' ' + CFDesc"; ShortcutDimCode[3] + ' ' + CFDesc)
                {
                    Caption = 'To Region';
                    Editable = false;
                }
                field(Narration; Rec.Narration)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Cheque No.+' dt. ' + FORMAT(Cheque Date)"; Rec."Cheque No." + ' dt. ' + FORMAT(Rec."Cheque Date"))
                {
                    Caption = 'Cheque No';
                    Editable = false;
                }
                field(AcBal; AcBal)
                {
                    Caption = 'Account Name';
                    Editable = false;
                }
                field(BAcBal; BAcBal)
                {
                    Caption = 'Bal. Account Name';
                    Editable = false;
                }
                field(Balance; Balance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                {
                    AutoFormatType = 1;
                    Caption = 'Balance';
                    Editable = false;
                    Visible = BalanceVisible;
                }
                field("Shortcut Dimension 2 Code+' ' + DeptName"; Rec."Shortcut Dimension 2 Code" + ' ' + DeptName)
                {
                    Caption = 'Cost Center';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Employee No. +' ' + EmpName"; Rec."Employee No." + ' ' + EmpName)
                {
                    Caption = 'FA';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(TotalBalance; TotalBalance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                {
                    AutoFormatType = 1;
                    Caption = 'Total Balance';
                    Editable = false;
                    Visible = TotalBalanceVisible;
                }
                field(BankChrgAmt; BankChrgAmt)
                {
                    Caption = 'Bank Charge Amount';
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
                    RunObject = Page "Gen. Journal Voucher Narration";//16573;
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
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                        CurrPage.SAVERECORD;
                    end;
                }
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
                separator("-")
                {
                    Caption = '-';
                }
                action("&Get Standard Journals")
                {
                    Caption = '&Get Standard Journals';
                    Ellipsis = true;
                    Image = GetStandardJournal;

                    trigger OnAction()
                    var
                        StdGenJnl: Record "Standard General Journal";
                    begin
                        StdGenJnl.FILTERGROUP := 2;
                        StdGenJnl.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                        StdGenJnl.FILTERGROUP := 0;

                        IF PAGE.RUNMODAL(PAGE::"Standard General Journals", StdGenJnl) = ACTION::LookupOK THEN BEGIN
                            StdGenJnl.CreateGenJnlFromStdJnl(StdGenJnl, CurrentJnlBatchName);
                            MESSAGE(Text000, StdGenJnl.Code);
                        END;

                        CurrPage.UPDATE(TRUE);
                    end;
                }
                action("&Save as Standard Journal")
                {
                    Caption = '&Save as Standard Journal';
                    Ellipsis = true;
                    Image = SaveasStandardJournal;

                    trigger OnAction()
                    var
                        GenJnlBatch: Record "Gen. Journal Batch";
                        GeneralJnlLines: Record "Gen. Journal Line";
                        StdGenJnl: Record "Standard General Journal";
                        SaveAsStdGenJnl: Report "Save as Standard Gen. Journal";
                    begin
                        GeneralJnlLines.SETFILTER("Journal Template Name", Rec."Journal Template Name");
                        GeneralJnlLines.SETFILTER("Journal Batch Name", CurrentJnlBatchName);
                        CurrPage.SETSELECTIONFILTER(GeneralJnlLines);
                        GeneralJnlLines.COPYFILTERS(Rec);

                        GenJnlBatch.GET(Rec."Journal Template Name", CurrentJnlBatchName);
                        SaveAsStdGenJnl.Initialise(GeneralJnlLines, GenJnlBatch);
                        SaveAsStdGenJnl.RUNMODAL;
                        IF NOT SaveAsStdGenJnl.GetStdGeneralJournal(StdGenJnl) THEN
                            EXIT;

                        MESSAGE(Text001, StdGenJnl.Code);
                    end;
                }
                action("Calculate TDS")
                {
                    Caption = 'Calculate TDS';

                    trigger OnAction()
                    begin
                        //CalcTDS('');
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



                        MemberOf.RESET;
                        MemberOf.SETRANGE("User Name", USERID);
                        MemberOf.SETFILTER("Role ID", 'DDS-G/L-JOURNAL POST');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('You don''t have permission Post the entries...');

                        //JPL60 START
                        GenJnlLineL.RESET;
                        GenJnlLineL.COPYFILTERS(Rec);
                        IF GenJnlLineL.FIND('-') THEN
                            REPEAT
                                IF GenJnlLineL."Order Ref No." <> '' THEN BEGIN
                                    GenJnlLineL.TESTFIELD("Posting Type");
                                    GenJnlLineL.TESTFIELD("Milestone Code");
                                    GenJnlLineL.TESTFIELD("Ref Document Type", GenJnlLineL."Ref Document Type"::Order);
                                END;
                                IF (GenJnlLineL."Account Type" = GenJnlLineL."Account Type"::Vendor) OR
                                   (GenJnlLineL."Bal. Account Type" = GenJnlLineL."Bal. Account Type"::Vendor) THEN;
                            //CheckLine.CheckPostingType(GenJnlLineL);
                            UNTIL GenJnlLineL.NEXT = 0;
                        //JPL06 STOP

                        LastNo := '';
                        GLEntry.RESET;
                        IF GLEntry.FIND('+') THEN
                            LastNo := GLEntry."Document No.";

                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);



                        GLEntry.RESET;
                        IF GLEntry.FIND('+') THEN BEGIN
                            IF LastNo <> GLEntry."Document No." THEN
                                MESSAGE('Last Voucher No Posted = %1', GLEntry."Document No.");

                        END;
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

        //SC ->>
        EmpName := '';
        IF Rec."Employee No." <> '' THEN BEGIN
            IF Emp.GET(Rec."Employee No.") THEN
                EmpName := Emp.FullName;
        END;

        CostCenterName := '';
        IF Rec."Shortcut Dimension 1 Code" <> '' THEN BEGIN
            IF Dimvalue.GET(GLSetup."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code") THEN
                CostCenterName := Dimvalue.Name;
        END;

        CFDesc := '';
        // ALLE MM Code Added
        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID", Rec."Dimension Set ID");
        DimSetEntry.SETRANGE("Dimension Code", 'EMPLOYEES');
        IF DimSetEntry.FINDFIRST THEN
            CFDesc := DimSetEntry."Dimension Value Code";

        // ALLE MM Code Added
        // ALLE MM Code Commented
        /*
        IF JLDim.GET(81,"Journal Template Name","Journal Batch Name","Line No.",0,GLSetup."Shortcut Dimension 3 Code")THEN BEGIN
           IF Dimvalue.GET(GLSetup."Shortcut Dimension 3 Code",JLDim."Dimension Value Code") THEN
              CFDesc := Dimvalue.Name;
        END;
        */
        // ALLE MM Code Commented
        DeptName := '';
        IF Rec."Shortcut Dimension 2 Code" <> '' THEN BEGIN
            IF Dimvalue.GET(GLSetup."Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code") THEN
                DeptName := Dimvalue.Name;
        END;

        AcBal := 0;
        IF Rec."Account No." <> '' THEN
            CASE Rec."Account Type" OF
                Rec."Account Type"::"G/L Account":
                    IF GLAcc.GET(Rec."Account No.") THEN BEGIN
                        GLAcc.CALCFIELDS(Balance);
                        AcBal := GLAcc.Balance;
                    END;
                Rec."Account Type"::Customer:
                    IF Cust.GET(Rec."Account No.") THEN BEGIN
                        Cust.CALCFIELDS(Balance);
                        AcBal := Cust.Balance;
                    END;
                Rec."Account Type"::Vendor:
                    IF Vend.GET(Rec."Account No.") THEN BEGIN
                        Vend.CALCFIELDS(Balance);
                        AcBal := Vend.Balance;
                    END;
                Rec."Account Type"::"Bank Account":
                    IF BankAcc.GET(Rec."Account No.") THEN BEGIN
                        BankAcc.CALCFIELDS(Balance);
                        AcBal := BankAcc.Balance;
                    END;
                Rec."Account Type"::"Fixed Asset":

                    AcBal := 0;
            END;

        BAcBal := 0;
        IF Rec."Bal. Account No." <> '' THEN
            CASE Rec."Bal. Account Type" OF
                Rec."Bal. Account Type"::"G/L Account":
                    IF GLAcc.GET(Rec."Bal. Account No.") THEN BEGIN
                        GLAcc.CALCFIELDS(Balance);
                        BAcBal := GLAcc.Balance;
                    END;
                Rec."Bal. Account Type"::Customer:
                    IF Cust.GET(Rec."Bal. Account No.") THEN BEGIN
                        Cust.CALCFIELDS(Balance);
                        BAcBal := Cust.Balance;
                    END;
                Rec."Bal. Account Type"::Vendor:
                    IF Vend.GET(Rec."Bal. Account No.") THEN BEGIN
                        Vend.CALCFIELDS(Balance);
                        BAcBal := Vend.Balance;
                    END;
                Rec."Bal. Account Type"::"Bank Account":
                    IF BankAcc.GET(Rec."Bal. Account No.") THEN BEGIN
                        BankAcc.CALCFIELDS(Balance);
                        BAcBal := BankAcc.Balance;
                    END;
                Rec."Bal. Account Type"::"Fixed Asset":

                    BAcBal := 0;
            END;

        //SC <<-
        BBGOnAfterGetCurrRecord;

    end;

    trigger OnInit()
    begin
        TotalBalanceVisible := TRUE;
        BalanceVisible := TRUE;
        "Bal. Account No.Editable" := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateBalance;
        Rec.SetUpNewLine(xRec, Balance, BelowxRec);
        CLEAR(ShortcutDimCode);
        CLEAR(AccName);
        //GKG
        Rec."Ref Document Type" := Rec."Ref Document Type"::Order;
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        BalAccName := '';
        OpenedFromBatch := (Rec."Journal Batch Name" <> '') AND (Rec."Journal Template Name" = '');
        IF OpenedFromBatch THEN BEGIN
            CurrentJnlBatchName := Rec."Journal Batch Name";
            GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            EXIT;
        END;
        GenJnlManagement.TemplateSelection(PAGE::"General Journal", 0, FALSE, Rec, JnlSelected);
        IF NOT JnlSelected THEN
            ERROR('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);

        GLSetup.GET;  //SC

        Rec."Document Type" := Rec."Document Type"::Payment;

        IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN
            "Bal. Account No.Editable" := FALSE
        ELSE
            "Bal. Account No.Editable" := TRUE;
    end;

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        GLReconcile: Page Reconciliation;
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        CurrentJnlBatchName: Code[10];
        AccName: Text[50];
        BalAccName: Text[50];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        Text000: Label 'General Journal lines have been successfully inserted from Standard General Journal %1.';
        Text001: Label 'Standard General Journal %1 has been successfully created.';
        OpenedFromBatch: Boolean;
        Text13700: Label 'Select the TDS payable account against payment is to be made.';
        Text13701: Label 'There are no tds entries for account %1.';
        Text13702: Label 'Select the Work Tax payable account against payment is to be made.';
        Text13703: Label 'There are no work tax entries for account %1.';
        Text13704: Label 'Select the Sales tax payable account against which payment is to be made.';
        Text13705: Label 'There are no Sales tax entries for Account %1.';
        Text13706: Label 'Select the Excise payable account against which payment is to be made.';
        Text13707: Label 'There are no excise entries for account %1.';
        Text16350: Label 'Select the VAT Payable Account against which payment is to be made.';
        Text16351: Label 'There are no VAT Entries for Account No. %1.';
        Text16352: Label 'There are no VAT Entries available for Refund.';
        Text16353: Label 'Account Type must be G/L Account or Bank Account,';
        GenJnlLineL: Record "Gen. Journal Line";
        Emp: Record Employee;
        EmpName: Text[200];
        Dimvalue: Record "Dimension Value";
        CostCenterName: Text[200];
        GLSetup: Record "General Ledger Setup";
        CFDesc: Text[120];
        GLJnlLine: Record "Gen. Journal Line";
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
        DeptName: Text[200];
        AcBal: Decimal;
        BAcBal: Decimal;
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        CheckLine: Codeunit "Gen. Jnl.-Check Line";
        MemberOf: Record "Access Control";
        BankChrgAmt: Decimal;
        "Bank Name": Text[50];
        UnitSetup: Record "Unit Setup";
        PaymentMethod: Record "Payment Method";
        BANKAccnt: Record "Bank Account";

        "Bal. Account No.Editable": Boolean;

        BalanceVisible: Boolean;

        TotalBalanceVisible: Boolean;
        DimSetEntry: Record "Dimension Set Entry";

    local procedure UpdateBalance()
    begin
        GenJnlManagement.CalcBalance(Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        //GenJnlManagement.UpdateBankCharges(Rec, BankChrgAmt);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    local procedure BankCodeOnAfterValidate()
    begin
        IF Rec."Bank Code" <> '' THEN
            IF BANKAccnt.GET(Rec."Bank Code") THEN
                "Bank Name" := BankAcc.Name
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
    end;
}

