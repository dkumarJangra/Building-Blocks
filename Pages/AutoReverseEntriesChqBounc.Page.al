page 50031 "Auto Reverse Entries-Chq Bounc"
{
    Caption = 'Reverse Entries';
    DataCaptionExpression = Rec.Caption;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
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
        EntryTypeTextOnFormat(EntryTypeText);
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
        BLE: Record "Bank Account Ledger Entry";
        BankRecoPAGE: Page "Bank Acc. Reconciliation";
        BankRecLine: Record "Bank Acc. Reconciliation Line";
        BankAccRecoLine: Record "Bank Acc. Reconciliation Line";
        LineNo: Integer;
        StatementNo: Code[20];

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
        //IF CONFIRM(Txt,FALSE) THEN BEGIN
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

        BLE.RESET;
        BLE.SETRANGE("Document No.", Rec."Document No.");
        BLE.SETRANGE("Document Type", BLE."Document Type"::Payment);
        BLE.SETRANGE(Reversed, TRUE);
        IF BLE.FINDSET THEN BEGIN
            REPEAT
                IF BLE."Statement No." <> '' THEN BEGIN
                    BankRecLine.GET(BLE."Bank Account No.", BLE."Statement No.", BLE."Statement Line No.");
                    BankRecLine.BouncedEntryPosted := TRUE;
                    BankRecLine.MODIFY;
                    CLEAR(BankAccRecoLine);
                    CLEAR(LineNo);
                    BankAccRecoLine.RESET;
                    BankAccRecoLine.SETRANGE("Bank Account No.", BLE."Bank Account No.");
                    BankAccRecoLine.SETRANGE("Statement No.", BLE."Statement No.");
                    IF BankAccRecoLine.FINDLAST THEN BEGIN
                        LineNo := BankAccRecoLine."Statement Line No.";
                        StatementNo := BankAccRecoLine."Statement No."
                    END;
                END ELSE
                    EnterBankAccLine(BLE);
            UNTIL BLE.NEXT = 0;
            //   IF CommPayVoucher.GET(BLE."External Document No.") THEN BEGIN
            //  CommPayVoucher."Payment Reversed" := TRUE;
            //CommPayVoucher.MODIFY;
            // END;
        END ELSE
            ERROR('Check Bank Account Ledger Entry Details');

        Rec.DELETEALL;
        CurrPage.UPDATE(FALSE);
        //MESSAGE(Text003);
        CurrPage.CLOSE;
        //END ELSE
        //EXIT;
    end;


    procedure EnterBankAccLine(var BankAccLedgEntry2: Record "Bank Account Ledger Entry")
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        BankAccSetStmtNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
    begin
        LineNo := LineNo + 10000;
        BankAccReconLine.INIT;
        BankAccReconLine."Bank Account No." := BankAccLedgEntry2."Bank Account No.";
        BankAccReconLine."Statement No." := StatementNo;
        BankAccReconLine."Statement Line No." := LineNo;
        BankAccReconLine."Transaction Date" := BankAccLedgEntry2."Posting Date";
        BankAccReconLine.Description := BankRecLine.Description;
        BankAccReconLine."Document No." := BankAccLedgEntry2."Document No.";
        BankAccReconLine."Check No." := BankAccLedgEntry2."Cheque No.";//ALLETDK
        BankAccReconLine."Cheque No." := BankAccLedgEntry2."Cheque No.";//ALLETDK
        BankAccReconLine."Cheque Date" := BankRecLine."Cheque Date";//ALLETDK
        BankAccReconLine."Value Date" := BankRecLine."Value Date";//ALLETDK
        BankAccReconLine."External Doc. No." := BankRecLine."External Doc. No.";//ALLETDK
        BankAccReconLine."Statement Amount" := BankAccLedgEntry2."Remaining Amount";
        BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
        ///BankAccReconLine.Type := BankAccReconLine.Type::"Bank Account Ledger Entry";
        BankAccReconLine."User ID" := USERID; //ALLETDK
        BankAccReconLine."Applied Entries" := 1;
        BankAccSetStmtNo.SetReconNo(BankAccLedgEntry2, BankAccReconLine);
        BankAccReconLine.Bounced := TRUE;
        BankAccReconLine.BouncedEntryPosted := TRUE;
        BankAccReconLine.INSERT;
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        DescriptionEditable := Rec."Entry Type" <> Rec."Entry Type"::VAT;
    end;

    local procedure EntryTypeTextOnFormat(var Text: Text[1024])
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

