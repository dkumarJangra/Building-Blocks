page 50030 "Auto Reverse Entries"
{
    // BBG 2.01 140814 Added code for create commission and TA in case of Regular.

    Caption = 'Reverse Entries';
    DataCaptionExpression = Rec.Caption;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    Permissions = TableData "Commission Entry" = rimd,
                  TableData "Assoc Pmt Voucher Header" = rimd,
                  TableData "Travel Payment Entry" = rimd;
    SourceTable = "Reversal Entry";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction No."; Rec."Transaction No.")
                {
                    Editable = false;
                }
                field(EntryTypeText; EntryTypeText)
                {
                    CaptionClass = Rec.FIELDCAPTION("Entry Type");
                    Editable = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    Editable = false;
                }
                field("Account Name"; Rec."Account Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    DrillDown = false;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = DescriptionEditable;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    Editable = false;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    Editable = false;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    Editable = false;
                    Visible = false;
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Source Code"; Rec."Source Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    Editable = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    Editable = false;
                }
                field("Source No."; Rec."Source No.")
                {
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = false;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    Editable = false;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("FA Posting Category"; Rec."FA Posting Category")
                {
                    Editable = false;
                }
                field("FA Posting Type"; Rec."FA Posting Type")
                {
                    Editable = false;
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
                action("General Ledger")
                {
                    Caption = 'General Ledger';
                    Image = GLRegisters;

                    trigger OnAction()
                    begin
                        ReversalEntry.ShowGLEntries;
                    end;
                }
                action("Customer Ledger")
                {
                    Caption = 'Customer Ledger';
                    Image = CustomerLedger;

                    trigger OnAction()
                    begin
                        ReversalEntry.ShowCustLedgEntries;
                    end;
                }
                action("Vendor Ledger")
                {
                    Caption = 'Vendor Ledger';
                    Image = VendorLedger;

                    trigger OnAction()
                    begin
                        ReversalEntry.ShowVendLedgEntries;
                    end;
                }
                action("Bank Account Ledger")
                {
                    Caption = 'Bank Account Ledger';
                    Image = BankAccountLedger;

                    trigger OnAction()
                    begin
                        ReversalEntry.ShowBankAccLedgEntries;
                    end;
                }
                action("Fixed Asset Ledger")
                {
                    Caption = 'Fixed Asset Ledger';
                    Image = FixedAssetLedger;

                    trigger OnAction()
                    begin
                        ReversalEntry.ShowFALedgEntries;
                    end;
                }
                action("Maintenance Ledger")
                {
                    Caption = 'Maintenance Ledger';
                    Image = MaintenanceLedgerEntries;

                    trigger OnAction()
                    begin
                        ReversalEntry.ShowMaintenanceLedgEntries;
                    end;
                }
                action("VAT Ledger")
                {
                    Caption = 'VAT Ledger';

                    trigger OnAction()
                    begin
                        ReversalEntry.ShowVATEntries;
                    end;
                }
            }
            group("Re&versing")
            {
                Caption = 'Re&versing';
                action(Reverse)
                {
                    Caption = 'Reverse';
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Post(FALSE);
                    end;
                }
                action("Reverse and &Print")
                {
                    Caption = 'Reverse and &Print';
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        Post(TRUE);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BBGOnAfterGetCurrRecord;
        EntryTypeText := FORMAT(Rec."Entry Type");
        //EntryTypeTextOnFormat(EntryTypeText);
    end;

    trigger OnClosePage()
    begin
        Post(FALSE);
    end;

    trigger OnInit()
    begin
        DescriptionEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        Rec.FIND('-');
        ReversalEntry := Rec;
        IF Rec."Reversal Type" = Rec."Reversal Type"::Transaction THEN BEGIN
            CurrPage.CAPTION := Text000;
            ReversalEntry.SetReverseFilter(Rec."Transaction No.", Rec."Reversal Type");
        END ELSE BEGIN
            CurrPage.CAPTION := Text001;
            ReversalEntry.SetReverseFilter(Rec."G/L Register No.", Rec."Reversal Type");
        END;
        CurrPage.CLOSE;
    end;

    var
        Text000: Label 'Reverse Transaction Entries';
        Text001: Label 'Reverse Register Entries';
        ReversalEntry: Record "Reversal Entry";
        Text002: Label 'Do you want to reverse the entries?';
        Text003: Label 'The entries were successfully reversed.';
        Text004: Label 'To reverse these entries, the program will post correcting entries.';
        Text005: Label 'Do you want to reverse the entries and print the report?';
        Text006: Label 'There is nothing to reverse.';
        Text007: Label '\There are one or more FA Ledger Entries. You should consider using the fixed asset function Cancel Entries.';
        Text008: Label 'Changes have been made to posted entries after the window was opened.\Close and reopen the window to continue.';
        VendLE: Record "Vendor Ledger Entry";
        CommPayVoucher: Record "Assoc Pmt Voucher Header";
        VoucherLine: Record "Voucher Line";
        PurchInvHead: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        ExtDocNo: Code[20];
        VendNo: Code[20];
        UnitSetup: Record "Unit Setup";
        CommEntry: Record "Commission Entry";
        CommEntry2: Record "Commission Entry";
        LastEntryNo: Integer;
        TravelPaymentEntry: Record "Travel Payment Entry";
        TravelPaymentEntry2: Record "Travel Payment Entry";
        TPE: Record "Travel Payment Entry";
        APEntry: Record "Application Payment Entry";
        IncentiveSummary: Record "Incentive Summary";
        LineNo2: Integer;
        ReverseAssPmtHdr: Record "Associate Payment Hdr";

        DescriptionEditable: Boolean;

        EntryTypeText: Text[1024];


    procedure Post(PrintRegister: Boolean)
    var
        GLReg: Record "G/L Register";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Txt: Text[250];
        WarningText: Text[250];
        Number: Integer;
        NewAppPayEntry: Record "NewApplication Payment Entry";
    begin
        Rec.RESET;
        Rec.SETRANGE("Entry Type", Rec."Entry Type"::"Fixed Asset");
        IF Rec.FINDFIRST THEN
            WarningText := Text007;
        Rec.SETRANGE("Entry Type");
        IF PrintRegister THEN
            Txt := Text004 + WarningText + '\' + Text005
        ELSE
            Txt := Text004 + WarningText + '\' + Text002;
        IF NOT Rec.FIND('-') THEN
            ERROR(Text006);
        IF CONFIRM(Txt, FALSE) THEN BEGIN
            ReversalEntry.CheckEntries;
            Rec.GET(1);
            IF Rec."Reversal Type" = Rec."Reversal Type"::Register THEN
                Number := Rec."G/L Register No."
            ELSE
                Number := Rec."Transaction No.";
            IF NOT ReversalEntry.VerifyReversalEntries(Rec, Number, Rec."Reversal Type") THEN
                ERROR(Text008);
            //  GenJnlPostLine.Reverse(ReversalEntry,Rec);
            IF PrintRegister THEN BEGIN
                GenJnlTemplate.VALIDATE(Type);
                IF GenJnlTemplate."Posting Report ID" <> 0 THEN BEGIN
                    IF GLReg.FIND('+') THEN BEGIN
                        GLReg.SETRECFILTER;
                        REPORT.RUN(GenJnlTemplate."Posting Report ID", FALSE, FALSE, GLReg);
                    END;
                END;
            END;



            //201016
            ReverseAssPmtHdr.RESET;
            ReverseAssPmtHdr.SETRANGE("Posted Document No.", Rec."Document No.");
            IF ReverseAssPmtHdr.FINDSET THEN
                REPEAT
                    IF ReverseAssPmtHdr."Company Name" = COMPANYNAME THEN BEGIN
                        ReverseAssPmtHdr."Reversal done in LLP Companies" := TRUE;
                    END;
                    ReverseAssPmtHdr."Payment Reversed" := TRUE;
                    ReverseAssPmtHdr.MODIFY;
                UNTIL ReverseAssPmtHdr.NEXT = 0;

            //201016


            NewAppPayEntry.RESET;
            NewAppPayEntry.SETCURRENTKEY("Posted Document No.");
            NewAppPayEntry.SETRANGE(NewAppPayEntry."Posted Document No.", Rec."Document No.");
            IF NewAppPayEntry.FINDFIRST THEN BEGIN
                NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Cancelled;
                NewAppPayEntry.MODIFY;
            END ELSE BEGIN

                CLEAR(ExtDocNo);
                CLEAR(VendNo);
                VendLE.RESET;
                VendLE.SETRANGE("Document No.", Rec."Document No.");
                VendLE.SETRANGE("Document Type", VendLE."Document Type"::Invoice);
                VendLE.SETRANGE(Reversed, TRUE);
                IF VendLE.FINDFIRST THEN BEGIN
                    //IF CommPayVoucher.GET(VendLE."External Document No.") THEN BEGIN
                    //CommPayVoucher.GET(VendLE."External Document No.");  //BBG2.00 050814
                    CommPayVoucher.SETRANGE("Document No.", VendLE."External Document No."); //BBG2.00 050814
                    IF CommPayVoucher.FINDFIRST THEN BEGIN
                        IF NOT CommPayVoucher."Invoice Reversed" THEN BEGIN
                            ExtDocNo := VendLE."External Document No.";
                            VendNo := VendLE."Vendor No.";
                            UnitSetup.GET;
                            IF (CommPayVoucher.Type IN [CommPayVoucher.Type::Commission, CommPayVoucher.Type::ComAndTA]) THEN BEGIN
                                IF CommPayVoucher."Sub Type" = CommPayVoucher."Sub Type"::Regular THEN BEGIN  //BBG 2.01 140814
                                    CLEAR(VoucherLine);
                                    VoucherLine.RESET;
                                    VoucherLine.SETRANGE("Voucher No.", VendLE."External Document No.");
                                    VoucherLine.SETRANGE(Type, VoucherLine.Type::Commission);

                                    IF VoucherLine.FINDFIRST THEN BEGIN
                                        CommEntry.RESET;
                                        IF CommEntry.FINDLAST THEN
                                            LastEntryNo := CommEntry."Entry No.";
                                        CommEntry2.INIT;
                                        CommEntry2."Entry No." := LastEntryNo + 1;
                                        CommEntry2."Application No." := ExtDocNo;
                                        CommEntry2."Associate Code" := VendNo;
                                        CommEntry2."Posting Date" := CommPayVoucher."Posting Date";
                                        CommEntry2."Base Amount" := VoucherLine.Amount;
                                        CommEntry2."Commission Amount" := VoucherLine.Amount;
                                        CommEntry2."Business Type" := CommEntry2."Business Type"::SELF;
                                        CommEntry2."First Year" := TRUE;
                                        CommEntry2."Introducer Code" := VendNo;
                                        CommEntry2.CreditMemo := TRUE;
                                        CommEntry2.INSERT;
                                    END;
                                END;
                            END; //BBG 2.01 140814
                            IF (CommPayVoucher.Type IN [CommPayVoucher.Type::TA, CommPayVoucher.Type::ComAndTA]) THEN BEGIN
                                IF CommPayVoucher."Sub Type" = CommPayVoucher."Sub Type"::Regular THEN BEGIN  //BBG 2.01 140814
                                    CLEAR(VoucherLine);
                                    VoucherLine.RESET;
                                    VoucherLine.SETRANGE("Voucher No.", VendLE."External Document No.");
                                    VoucherLine.SETRANGE(Type, VoucherLine.Type::TA);
                                    IF VoucherLine.FINDFIRST THEN BEGIN
                                        TPE.RESET;
                                        TPE.SETRANGE("Sub Associate Code", VendNo);
                                        IF TPE.FINDLAST THEN BEGIN
                                            TravelPaymentEntry2.RESET;
                                            TravelPaymentEntry2.SETRANGE("Document No.", TPE."Document No.");
                                            IF TravelPaymentEntry2.FINDLAST THEN BEGIN
                                                TravelPaymentEntry.INIT;
                                                TravelPaymentEntry."Document No." := TPE."Document No.";
                                                TravelPaymentEntry.VALIDATE("Team Lead", VendNo);
                                                TravelPaymentEntry.VALIDATE("Sub Associate Code", VendNo);
                                                TravelPaymentEntry."Line No." := TravelPaymentEntry2."Line No." + 10000;
                                                TravelPaymentEntry."Amount to Pay" := VoucherLine.Amount;
                                                TravelPaymentEntry.CreditMemo := TRUE;
                                                TravelPaymentEntry."CreditMemo No." := ExtDocNo;
                                                TravelPaymentEntry."Creation Date" := CommPayVoucher."Posting Date";
                                                TravelPaymentEntry."Sent for Approval" := TRUE;
                                                TravelPaymentEntry.Approved := TRUE;
                                                TravelPaymentEntry."Approver Name" := USERID;
                                                TravelPaymentEntry."Approval Sender  Name" := USERID;
                                                TravelPaymentEntry."Approved By" := USERID;
                                                TravelPaymentEntry."Sent By for Approval" := USERID;
                                                TravelPaymentEntry.INSERT;
                                            END;
                                        END;
                                    END;
                                END;//BBG2.01 140814
                            END;
                        END;
                        CommPayVoucher."Invoice Reversed" := TRUE;
                        CommPayVoucher.MODIFY;
                    END;//BBG2.00 050814
                        /*
                          END
                          ELSE BEGIN
                            PurchInvHead.RESET;
                            PurchInvHead.SETRANGE("Vendor Invoice No.",VendLE."External Document No.");
                            IF PurchInvHead.FINDFIRST THEN BEGIN
                              PurchInvLine.RESET;
                              PurchInvLine.SETRANGE("Document No.",PurchInvHead."No.");
                              IF PurchInvLine.FINDFIRST THEN BEGIN
                                CommEntry.RESET;
                                IF CommEntry.FINDLAST THEN
                                  LastEntryNo :=CommEntry."Entry No.";
                                CommEntry2.INIT;
                                CommEntry2."Entry No." :=LastEntryNo+1;
                                CommEntry2."Application No." :=VendLE."External Document No.";
                                CommEntry2."Associate Code" := VendNo;
                                CommEntry2."Posting Date" :=PurchInvHead."Posting Date";
                                CommEntry2."Base Amount" := PurchInvLine."Direct Unit Cost";
                                CommEntry2."Commission Amount" :=PurchInvLine."Direct Unit Cost";
                                CommEntry2."Business Type" := CommEntry2."Business Type"::SELF;
                                CommEntry2."First Year" := TRUE;
                                CommEntry2."Introducer Code" := VendNo;
                                CommEntry2.CreditMemo := TRUE;
                                CommEntry2.INSERT;
                             END;
                           END;
                         END;
                        */
                        //BBG2.00 050814
                    APEntry.RESET;
                    APEntry.SETCURRENTKEY("Posted Document No.");
                    APEntry.SETRANGE("Posted Document No.", VendLE."External Document No.");
                    APEntry.SETRANGE("Reverse AJVM Invoice", TRUE);
                    IF APEntry.FINDFIRST THEN BEGIN
                        IF APEntry."AJVM Transfer Type" = APEntry."AJVM Transfer Type"::Commission THEN BEGIN
                            CommEntry.RESET;
                            IF CommEntry.FINDLAST THEN
                                LastEntryNo := CommEntry."Entry No.";
                            CommEntry2.INIT;
                            CommEntry2."Entry No." := LastEntryNo + 1;
                            CommEntry2."Application No." := APEntry."Posted Document No.";
                            CommEntry2."Associate Code" := VendLE."Vendor No.";
                            CommEntry2."Posting Date" := APEntry."Posting date";
                            CommEntry2."Base Amount" := APEntry."Associate Transfer Amount";
                            CommEntry2."Commission Amount" := APEntry."Associate Transfer Amount";
                            CommEntry2."Business Type" := CommEntry2."Business Type"::SELF;
                            CommEntry2."First Year" := TRUE;
                            CommEntry2."Introducer Code" := VendLE."Vendor No.";
                            CommEntry2.CreditMemo := TRUE;
                            CommEntry2.INSERT;
                        END;
                        UnitSetup.GET;
                        IF UnitSetup."Incentive elegiblity App. AJVM" THEN BEGIN
                            IF APEntry."AJVM Transfer Type" = APEntry."AJVM Transfer Type"::Incentive THEN BEGIN
                                IncentiveSummary.RESET;
                                IF IncentiveSummary.FINDLAST THEN
                                    LineNo2 := IncentiveSummary."Line No.";
                                IncentiveSummary.INIT;
                                LineNo2 += 10000;
                                IncentiveSummary."Incentive Application No." := '';
                                IncentiveSummary."Line No." := LineNo2;
                                IncentiveSummary.INSERT(TRUE);
                                IncentiveSummary.Year := DATE2DMY(Rec."Posting Date", 3);
                                IncentiveSummary.Month := DATE2DMY(Rec."Posting Date", 2);
                                IncentiveSummary."Associate Code" := VendLE."Vendor No.";
                                IncentiveSummary."Plot Incentive Amount" := ABS(VendLE.Amount);
                                IncentiveSummary."Payable Incentive Amount" := ABS(VendLE.Amount);
                                IncentiveSummary.Type := IncentiveSummary.Type::Direct;
                                IncentiveSummary."Incentive Scheme" := '';
                                IncentiveSummary."No. of plot" := 0;
                                IncentiveSummary."BSP1_BSP3 Amount" := 0;  //BBG1.00 280713
                                IncentiveSummary.MODIFY;
                            END;
                        END;
                        APEntry."Reverse AJVM Invoice" := FALSE;
                        APEntry."Reversed AJVM Invoice" := TRUE;
                        APEntry.MODIFY;
                    END;
                    //BBG2.00 050814
                END;

                /*//040316
                    CLEAR(VendLE);
                    VendLE.RESET;
                    VendLE.SETRANGE("Document No.","Document No.");
                    VendLE.SETRANGE("Document Type",VendLE."Document Type"::Payment);
                    VendLE.SETRANGE(Reversed,TRUE);
                    IF VendLE.FINDFIRST THEN BEGIN
                    // IF  CommPayVoucher.GET(VendLE."External Document No.") THEN
                    //  CommPayVoucher.GET(VendLE."External Document No.");
                      //  IF NOT CommPayVoucher."Payment Reversed" THEN BEGIN
                          CommPayVoucher."Payment Reversed" := TRUE;
                          CommPayVoucher.MODIFY;
                      //END;
                    END;
                   */
            END;

            Rec.DELETEALL;
            CurrPage.UPDATE(FALSE);
            MESSAGE(Text003);
            CurrPage.CLOSE;
        END ELSE
            EXIT;

    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        DescriptionEditable := Rec."Entry Type" <> Rec."Entry Type"::VAT;
    end;

    local procedure EntryTypeTextOnPageat(var Text: Text[1024])
    var
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        FALedgEntry: Record "FA Ledger Entry";
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        VATEntry: Record "VAT Entry";
    begin
        IF Rec."Entry Type" = Rec."Entry Type"::"G/L Account" THEN
            Text := GLEntry.TABLECAPTION;
        IF Rec."Entry Type" = Rec."Entry Type"::Customer THEN
            Text := CustLedgEntry.TABLECAPTION;
        IF Rec."Entry Type" = Rec."Entry Type"::Vendor THEN
            Text := VendLedgEntry.TABLECAPTION;
        IF Rec."Entry Type" = Rec."Entry Type"::"Bank Account" THEN
            Text := BankAccLedgEntry.TABLECAPTION;
        IF Rec."Entry Type" = Rec."Entry Type"::"Fixed Asset" THEN
            Text := FALedgEntry.TABLECAPTION;
        IF Rec."Entry Type" = Rec."Entry Type"::Maintenance THEN
            Text := MaintenanceLedgEntry.TABLECAPTION;
        IF Rec."Entry Type" = Rec."Entry Type"::VAT THEN
            Text := VATEntry.TABLECAPTION;
    end;
}

