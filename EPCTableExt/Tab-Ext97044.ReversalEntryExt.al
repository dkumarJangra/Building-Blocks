tableextension 97044 "EPC Reversal Entry Ext" extends "Reversal Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50001; AutoReverse; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK060613';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        Text50000: Label '"You cannot reverse %1 No. %2 because the entry is either applied to an entry or has been changed by a batch job. "';
        PostApplied: Boolean;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Text012: Label 'You cannot reverse register No. %1 because it contains customer or vendor ledger entries that have been posted and applied in the same transaction.\\You must reverse each transaction in register No. %1 separately.';
        Text013: Label 'You cannot reverse %1 No. %2 because the entry has an associated Realized Gain/Loss entry.';
        Text006: Label 'You cannot reverse %1 No. %2 because the entry is closed.';
        Text003: Label 'You cannot reverse %1 No. %2 because the entry has a related check ledger entry.';

        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        FALedgEntry: Record "FA Ledger Entry";
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        VATEntry: Record "VAT Entry";
        TDSEntry: Record "TDS Entry";
        TCSEntry: Record "TCS Entry";
        GLEntry: Record "G/L Entry";
        Text009: Label 'The transaction cannot be reversed, because the %1 has been compressed or a %2 has been deleted.';

    PROCEDURE AutoReverseTransaction(TransactionNo: Integer; RevDate: Date);
    BEGIN
        InsertAutoReversalEntry(TransactionNo, 0, RevDate);
    END;

    LOCAL PROCEDURE InsertAutoReversalEntry(Number: Integer; RevType: Option Transaction,Register; RevDate: Date);
    VAR
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        TempRevertTransactionNo: Record Integer TEMPORARY;
        NextLineNo: Integer;
        AutoRevEntry: Record "Reversal Entry";
    BEGIN

        GLSetup.GET;
        AutoRevEntry.DELETEALL;
        PostApplied := FALSE;
        NextLineNo := 1;
        TempRevertTransactionNo.Number := Number;
        TempRevertTransactionNo.INSERT;
        SetReverseFilter(Number, RevType);

        IF CustLedgEntry.FIND('-') THEN
            REPEAT
                CLEAR(AutoRevEntry);
                IF RevType = RevType::Register THEN
                    AutoRevEntry."G/L Register No." := Number;
                AutoRevEntry."Reversal Type" := RevType;
                AutoRevEntry."Entry Type" := AutoRevEntry."Entry Type"::Customer;
                AutoRevEntry."Entry No." := CustLedgEntry."Entry No.";
                Cust.GET(CustLedgEntry."Customer No.");
                AutoRevEntry."Account No." := Cust."No.";
                AutoRevEntry."Account Name" := Cust.Name;
                //AutoRevEntry."Posting Date" := CustLedgEntry."Posting Date";
                AutoRevEntry."Posting Date" := RevDate;
                AutoRevEntry."Source Code" := CustLedgEntry."Source Code";
                AutoRevEntry."Journal Batch Name" := CustLedgEntry."Journal Batch Name";
                AutoRevEntry."Transaction No." := CustLedgEntry."Transaction No.";
                AutoRevEntry."Currency Code" := CustLedgEntry."Currency Code";
                AutoRevEntry.Description := CustLedgEntry.Description;
                CustLedgEntry.CALCFIELDS(Amount, "Debit Amount", "Credit Amount",
                  "Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
                AutoRevEntry.Amount := CustLedgEntry.Amount;
                AutoRevEntry."Debit Amount" := CustLedgEntry."Debit Amount";
                AutoRevEntry."Credit Amount" := CustLedgEntry."Credit Amount";
                AutoRevEntry."Amount (LCY)" := CustLedgEntry."Amount (LCY)";
                AutoRevEntry."Debit Amount (LCY)" := CustLedgEntry."Debit Amount (LCY)";
                AutoRevEntry."Credit Amount (LCY)" := CustLedgEntry."Credit Amount (LCY)";
                AutoRevEntry."Document Type" := CustLedgEntry."Document Type";
                AutoRevEntry."Document No." := CustLedgEntry."Document No.";
                AutoRevEntry."Bal. Account Type" := CustLedgEntry."Bal. Account Type";
                AutoRevEntry."Bal. Account No." := CustLedgEntry."Bal. Account No.";
                AutoRevEntry."Line No." := NextLineNo;
                AutoRevEntry.AutoReverse := TRUE;
                NextLineNo := NextLineNo + 1;
                AutoRevEntry.INSERT;

                CLEAR(DtldCustLedgEntry);
                DtldCustLedgEntry.SETCURRENTKEY("Transaction No.", "Customer No.", "Entry Type");
                DtldCustLedgEntry.SETRANGE(DtldCustLedgEntry."Transaction No.", CustLedgEntry."Transaction No.");
                DtldCustLedgEntry.SETRANGE(DtldCustLedgEntry."Customer No.", CustLedgEntry."Customer No.");
                DtldCustLedgEntry.SETFILTER(
                  DtldCustLedgEntry."Entry Type", '<>%1', DtldCustLedgEntry."Entry Type"::"Initial Entry");
                IF DtldCustLedgEntry.FIND('-') THEN BEGIN
                    IF RevType = RevType::Register THEN
                        ERROR(Text012, Number);
                    CLEAR(DtldCustLedgEntry);
                    DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
                    DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                    DtldCustLedgEntry.SETRANGE(Unapplied, TRUE);
                    IF DtldCustLedgEntry.FIND('-') THEN BEGIN
                        REPEAT
                            TempRevertTransactionNo.Number := DtldCustLedgEntry."Transaction No.";
                            IF TempRevertTransactionNo.INSERT THEN;
                        UNTIL DtldCustLedgEntry.NEXT = 0;
                    END;
                END;
            UNTIL CustLedgEntry.NEXT = 0;

        IF VendLedgEntry.FIND('-') THEN
            REPEAT
                CLEAR(AutoRevEntry);
                IF RevType = RevType::Register THEN
                    AutoRevEntry."G/L Register No." := Number;
                AutoRevEntry."Reversal Type" := RevType;
                AutoRevEntry."Entry Type" := AutoRevEntry."Entry Type"::Vendor;
                AutoRevEntry."Entry No." := VendLedgEntry."Entry No.";
                Vend.GET(VendLedgEntry."Vendor No.");
                AutoRevEntry."Account No." := Vend."No.";
                AutoRevEntry."Account Name" := Vend.Name;
                //AutoRevEntry."Posting Date" := VendLedgEntry."Posting Date";
                AutoRevEntry."Posting Date" := RevDate;
                AutoRevEntry."Source Code" := VendLedgEntry."Source Code";
                AutoRevEntry."Journal Batch Name" := VendLedgEntry."Journal Batch Name";
                AutoRevEntry."Transaction No." := VendLedgEntry."Transaction No.";
                AutoRevEntry."Currency Code" := VendLedgEntry."Currency Code";
                AutoRevEntry.Description := VendLedgEntry.Description;
                VendLedgEntry.CALCFIELDS(Amount, "Debit Amount", "Credit Amount",
                  "Amount (LCY)", "Debit Amount (LCY)", "Credit Amount (LCY)");
                AutoRevEntry.Amount := VendLedgEntry.Amount;
                AutoRevEntry."Debit Amount" := VendLedgEntry."Debit Amount";
                AutoRevEntry."Credit Amount" := VendLedgEntry."Credit Amount";
                AutoRevEntry."Amount (LCY)" := VendLedgEntry."Amount (LCY)";
                AutoRevEntry."Debit Amount (LCY)" := VendLedgEntry."Debit Amount (LCY)";
                AutoRevEntry."Credit Amount (LCY)" := VendLedgEntry."Credit Amount (LCY)";
                AutoRevEntry."Document Type" := VendLedgEntry."Document Type";
                AutoRevEntry."Document No." := VendLedgEntry."Document No.";
                AutoRevEntry."Bal. Account Type" := VendLedgEntry."Bal. Account Type";
                AutoRevEntry."Bal. Account No." := VendLedgEntry."Bal. Account No.";
                AutoRevEntry."Line No." := NextLineNo;
                AutoRevEntry.AutoReverse := TRUE;
                NextLineNo := NextLineNo + 1;
                AutoRevEntry.INSERT;

                CLEAR(DtldVendLedgEntry);
                DtldVendLedgEntry.SETCURRENTKEY("Transaction No.", "Vendor No.", "Entry Type");
                DtldVendLedgEntry.SETRANGE(DtldVendLedgEntry."Transaction No.", VendLedgEntry."Transaction No.");
                DtldVendLedgEntry.SETRANGE(DtldVendLedgEntry."Vendor No.", VendLedgEntry."Vendor No.");
                DtldVendLedgEntry.SETFILTER(
                  DtldVendLedgEntry."Entry Type", '<>%1', DtldVendLedgEntry."Entry Type"::"Initial Entry");
                IF DtldVendLedgEntry.FIND('-') THEN BEGIN
                    IF RevType = RevType::Register THEN
                        ERROR(Text012, Number);
                    CLEAR(DtldVendLedgEntry);
                    DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.");
                    DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
                    DtldVendLedgEntry.SETRANGE(Unapplied, TRUE);
                    IF DtldVendLedgEntry.FIND('-') THEN BEGIN
                        REPEAT
                            TempRevertTransactionNo.Number := DtldVendLedgEntry."Transaction No.";
                            IF TempRevertTransactionNo.INSERT THEN;
                        UNTIL DtldVendLedgEntry.NEXT = 0;
                    END;
                END;
            UNTIL VendLedgEntry.NEXT = 0;

        IF BankAccLedgEntry.FIND('-') THEN
            REPEAT
                CLEAR(AutoRevEntry);
                IF RevType = RevType::Register THEN
                    AutoRevEntry."G/L Register No." := Number;
                AutoRevEntry."Reversal Type" := RevType;
                AutoRevEntry."Entry Type" := AutoRevEntry."Entry Type"::"Bank Account";
                AutoRevEntry."Entry No." := BankAccLedgEntry."Entry No.";
                BankAcc.GET(BankAccLedgEntry."Bank Account No.");
                AutoRevEntry."Account No." := BankAcc."No.";
                AutoRevEntry."Account Name" := BankAcc.Name;
                //AutoRevEntry."Posting Date" := BankAccLedgEntry."Posting Date";
                AutoRevEntry."Posting Date" := RevDate;
                AutoRevEntry."Source Code" := BankAccLedgEntry."Source Code";
                AutoRevEntry."Journal Batch Name" := BankAccLedgEntry."Journal Batch Name";
                AutoRevEntry."Transaction No." := BankAccLedgEntry."Transaction No.";
                AutoRevEntry."Currency Code" := BankAccLedgEntry."Currency Code";
                AutoRevEntry.Description := BankAccLedgEntry.Description;
                AutoRevEntry.Amount := BankAccLedgEntry.Amount;
                AutoRevEntry."Debit Amount" := BankAccLedgEntry."Debit Amount";
                AutoRevEntry."Credit Amount" := BankAccLedgEntry."Credit Amount";
                AutoRevEntry."Amount (LCY)" := BankAccLedgEntry."Amount (LCY)";
                AutoRevEntry."Debit Amount (LCY)" := BankAccLedgEntry."Debit Amount (LCY)";
                AutoRevEntry."Credit Amount (LCY)" := BankAccLedgEntry."Credit Amount (LCY)";
                AutoRevEntry."Document Type" := BankAccLedgEntry."Document Type";
                AutoRevEntry."Document No." := BankAccLedgEntry."Document No.";
                AutoRevEntry."Bal. Account Type" := BankAccLedgEntry."Bal. Account Type";
                AutoRevEntry."Bal. Account No." := BankAccLedgEntry."Bal. Account No.";
                AutoRevEntry."Line No." := NextLineNo;
                AutoRevEntry.AutoReverse := TRUE;
                NextLineNo := NextLineNo + 1;
                AutoRevEntry.INSERT;
            UNTIL BankAccLedgEntry.NEXT = 0;

        IF FALedgEntry.FIND('-') THEN
            REPEAT
                CLEAR(AutoRevEntry);
                IF RevType = RevType::Register THEN
                    AutoRevEntry."G/L Register No." := Number;
                AutoRevEntry."Reversal Type" := RevType;
                AutoRevEntry."Entry Type" := AutoRevEntry."Entry Type"::"Fixed Asset";
                AutoRevEntry."Entry No." := FALedgEntry."Entry No.";
                FA.GET(FALedgEntry."FA No.");
                AutoRevEntry."Account No." := FA."No.";
                AutoRevEntry."Account Name" := FA.Description;
                //AutoRevEntry."Posting Date" := FALedgEntry."Posting Date";
                AutoRevEntry."Posting Date" := RevDate;
                AutoRevEntry."FA Posting Category" := FALedgEntry."FA Posting Category";
                AutoRevEntry."FA Posting Type" := FALedgEntry."FA Posting Type" + 1;
                AutoRevEntry."Source Code" := FALedgEntry."Source Code";
                AutoRevEntry."Journal Batch Name" := FALedgEntry."Journal Batch Name";
                AutoRevEntry."Transaction No." := FALedgEntry."Transaction No.";
                AutoRevEntry.Description := FALedgEntry.Description;
                AutoRevEntry."Amount (LCY)" := FALedgEntry.Amount;
                AutoRevEntry."Debit Amount (LCY)" := FALedgEntry."Debit Amount";
                AutoRevEntry."Credit Amount (LCY)" := FALedgEntry."Credit Amount";
                AutoRevEntry."VAT Amount" := FALedgEntry."VAT Amount";
                AutoRevEntry."Document Type" := FALedgEntry."Document Type";
                AutoRevEntry."Document No." := FALedgEntry."Document No.";
                AutoRevEntry."Bal. Account Type" := FALedgEntry."Bal. Account Type";
                AutoRevEntry."Bal. Account No." := FALedgEntry."Bal. Account No.";
                AutoRevEntry.AutoReverse := TRUE;
                IF FALedgEntry."FA Posting Type" <> FALedgEntry."FA Posting Type"::"Salvage Value" THEN BEGIN
                    AutoRevEntry."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 1;
                    AutoRevEntry.INSERT;
                END;
            UNTIL FALedgEntry.NEXT = 0;

        IF MaintenanceLedgEntry.FIND('-') THEN
            REPEAT
                CLEAR(AutoRevEntry);
                IF RevType = RevType::Register THEN
                    AutoRevEntry."G/L Register No." := Number;
                AutoRevEntry."Reversal Type" := RevType;
                AutoRevEntry."Entry Type" := AutoRevEntry."Entry Type"::Maintenance;
                AutoRevEntry."Entry No." := MaintenanceLedgEntry."Entry No.";
                FA.GET(MaintenanceLedgEntry."FA No.");
                AutoRevEntry."Account No." := FA."No.";
                AutoRevEntry."Account Name" := FA.Description;
                //AutoRevEntry."Posting Date" := MaintenanceLedgEntry."Posting Date";
                AutoRevEntry."Posting Date" := RevDate;
                AutoRevEntry."Source Code" := MaintenanceLedgEntry."Source Code";
                AutoRevEntry."Journal Batch Name" := MaintenanceLedgEntry."Journal Batch Name";
                AutoRevEntry."Transaction No." := MaintenanceLedgEntry."Transaction No.";
                AutoRevEntry.Description := MaintenanceLedgEntry.Description;
                AutoRevEntry."Amount (LCY)" := MaintenanceLedgEntry.Amount;
                AutoRevEntry."Debit Amount (LCY)" := MaintenanceLedgEntry."Debit Amount";
                AutoRevEntry."Credit Amount (LCY)" := MaintenanceLedgEntry."Credit Amount";
                AutoRevEntry."VAT Amount" := MaintenanceLedgEntry."VAT Amount";
                AutoRevEntry."Document Type" := MaintenanceLedgEntry."Document Type";
                AutoRevEntry."Document No." := MaintenanceLedgEntry."Document No.";
                AutoRevEntry."Bal. Account Type" := MaintenanceLedgEntry."Bal. Account Type";
                AutoRevEntry."Bal. Account No." := MaintenanceLedgEntry."Bal. Account No.";
                AutoRevEntry."Line No." := NextLineNo;
                AutoRevEntry.AutoReverse := TRUE;
                NextLineNo := NextLineNo + 1;
                AutoRevEntry.INSERT;
            UNTIL MaintenanceLedgEntry.NEXT = 0;

        TempRevertTransactionNo.FINDSET;
        REPEAT
            IF RevType = RevType::Transaction THEN
                VATEntry.SETRANGE("Transaction No.", TempRevertTransactionNo.Number);
            IF VATEntry.FINDSET THEN
                REPEAT
                    CLEAR(AutoRevEntry);
                    IF RevType = RevType::Register THEN
                        AutoRevEntry."G/L Register No." := Number;
                    AutoRevEntry."Reversal Type" := RevType;
                    AutoRevEntry."Entry Type" := AutoRevEntry."Entry Type"::VAT;
                    AutoRevEntry."Entry No." := VATEntry."Entry No.";
                    //AutoRevEntry."Posting Date" := VATEntry."Posting Date";
                    AutoRevEntry."Posting Date" := RevDate;
                    AutoRevEntry."Source Code" := VATEntry."Source Code";
                    AutoRevEntry."Transaction No." := VATEntry."Transaction No.";
                    AutoRevEntry.Amount := VATEntry.Amount;
                    AutoRevEntry."Amount (LCY)" := VATEntry.Amount;
                    AutoRevEntry."Document Type" := VATEntry."Document Type";
                    AutoRevEntry."Document No." := VATEntry."Document No.";
                    AutoRevEntry."Line No." := NextLineNo;
                    AutoRevEntry.AutoReverse := TRUE;
                    NextLineNo := NextLineNo + 1;
                    AutoRevEntry.INSERT;
                UNTIL VATEntry.NEXT = 0;
        UNTIL TempRevertTransactionNo.NEXT = 0;

        TempRevertTransactionNo.FINDSET;
        REPEAT
            IF RevType = RevType::Transaction THEN
                TDSEntry.SETRANGE("Transaction No.", TempRevertTransactionNo.Number);
            IF TDSEntry.FINDSET THEN
                REPEAT
                    CLEAR(AutoRevEntry);
                    IF RevType = RevType::Register THEN
                        AutoRevEntry."G/L Register No." := Number;
                    AutoRevEntry."Reversal Type" := RevType;
                    AutoRevEntry."Entry Type" := AutoRevEntry."Entry Type"::TDS;
                    AutoRevEntry."Entry No." := TDSEntry."Entry No.";
                    //AutoRevEntry."Posting Date" := TDSEntry."Posting Date";
                    AutoRevEntry."Posting Date" := RevDate;
                    AutoRevEntry."Source Code" := TDSEntry."Source Code";
                    AutoRevEntry."Transaction No." := TDSEntry."Transaction No.";
                    AutoRevEntry.Amount := TDSEntry."Total TDS Including SHE CESS";
                    AutoRevEntry."Amount (LCY)" := TDSEntry."Total TDS Including SHE CESS";
                    AutoRevEntry."Document Type" := TDSEntry."Document Type";
                    AutoRevEntry."Document No." := TDSEntry."Document No.";
                    AutoRevEntry."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 1;
                    AutoRevEntry.AutoReverse := TRUE;
                    AutoRevEntry.INSERT;
                UNTIL TDSEntry.NEXT = 0;
        UNTIL TempRevertTransactionNo.NEXT = 0;

        TempRevertTransactionNo.FINDSET;
        REPEAT
            IF RevType = RevType::Transaction THEN
                TCSEntry.SETRANGE("Transaction No.", TempRevertTransactionNo.Number);
            IF TCSEntry.FINDSET THEN
                REPEAT
                    CLEAR(AutoRevEntry);
                    IF RevType = RevType::Register THEN
                        AutoRevEntry."G/L Register No." := Number;
                    AutoRevEntry."Reversal Type" := RevType;
                    AutoRevEntry."Entry Type" := AutoRevEntry."Entry Type"::TCS;
                    AutoRevEntry."Entry No." := TCSEntry."Entry No.";
                    //AutoRevEntry."Posting Date" := TCSEntry."Posting Date";
                    AutoRevEntry."Posting Date" := RevDate;
                    AutoRevEntry."Source Code" := TCSEntry."Source Code";
                    AutoRevEntry."Transaction No." := TCSEntry."Transaction No.";
                    AutoRevEntry.Amount := TCSEntry."Total TCS Including SHE CESS";
                    AutoRevEntry."Amount (LCY)" := TCSEntry."Total TCS Including SHE CESS";
                    AutoRevEntry."Document Type" := TCSEntry."Document Type";
                    AutoRevEntry."Document No." := TCSEntry."Document No.";
                    AutoRevEntry.AutoReverse := TRUE;
                    AutoRevEntry."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 1;
                    AutoRevEntry.INSERT;
                UNTIL TCSEntry.NEXT = 0;
        UNTIL TempRevertTransactionNo.NEXT = 0;

        TempRevertTransactionNo.FINDSET;
        REPEAT
        // IF RevType = RevType::Transaction THEN
        //     PLAEntry.SETRANGE("Transaction No.", TempRevertTransactionNo.Number);
        // IF PLAEntry.FINDSET THEN
        //     REPEAT
        //         CLEAR(AutoRevEntry);
        //         IF RevType = RevType::Register THEN
        //             AutoRevEntry."G/L Register No." := Number;
        //         AutoRevEntry."Reversal Type" := RevType;
        //         AutoRevEntry."Entry Type" := AutoRevEntry."Entry Type"::PLA;
        //         AutoRevEntry."Entry No." := PLAEntry."Entry No.";
        //         //AutoRevEntry."Posting Date" := PLAEntry."Posting Date";
        //         AutoRevEntry."Posting Date" := RevDate;
        //         AutoRevEntry."Source Code" := PLAEntry."Source Code";
        //         AutoRevEntry."Transaction No." := PLAEntry."Transaction No.";
        //         AutoRevEntry.Amount := PLAEntry."BED Credit Amount" + PLAEntry."Other Duties Credit";
        //         AutoRevEntry."Amount (LCY)" := PLAEntry."BED Credit Amount" + PLAEntry."Other Duties Credit";
        //         AutoRevEntry."Document Type" := AutoRevEntry."Document Type"::Payment;
        //         AutoRevEntry."Document No." := PLAEntry."Document No.";
        //         AutoRevEntry."Line No." := NextLineNo;
        //         AutoRevEntry.AutoReverse := TRUE;
        //         NextLineNo := NextLineNo + 1;
        //         AutoRevEntry.INSERT;
        //     UNTIL PLAEntry.NEXT = 0;
        UNTIL TempRevertTransactionNo.NEXT = 0;

        TempRevertTransactionNo.FINDSET;
        REPEAT
        // IF RevType = RevType::Transaction THEN
        //     FBTEntry.SETRANGE("Transaction No.", TempRevertTransactionNo.Number);
        // IF FBTEntry.FINDSET THEN
        //     REPEAT
        //         CLEAR(AutoRevEntry);
        //         IF RevType = RevType::Register THEN
        //             AutoRevEntry."G/L Register No." := Number;
        //         AutoRevEntry."Reversal Type" := RevType;
        //         AutoRevEntry."Entry Type" := AutoRevEntry."Entry Type"::FBT;
        //         AutoRevEntry."Entry No." := FBTEntry."Entry No.";
        //         //AutoRevEntry."Posting Date" := FBTEntry."Posting Date";
        //         AutoRevEntry."Posting Date" := RevDate;
        //         AutoRevEntry."Source Code" := FBTEntry."Source Code";
        //         AutoRevEntry."Transaction No." := FBTEntry."Transaction No.";
        //         AutoRevEntry.Amount := FBTEntry.Amount;
        //         AutoRevEntry."Source Code" := FBTEntry."Source Code";
        //         AutoRevEntry."Document Type" := FBTEntry."Document Type";
        //         AutoRevEntry."Document No." := FBTEntry."Document No.";
        //         AutoRevEntry."Line No." := NextLineNo;
        //         AutoRevEntry.AutoReverse := TRUE;
        //         NextLineNo := NextLineNo + 1;
        //         AutoRevEntry.INSERT;
        //     UNTIL FBTEntry.NEXT = 0;
        UNTIL TempRevertTransactionNo.NEXT = 0;

        TempRevertTransactionNo.FINDSET;
        REPEAT
            IF RevType = RevType::Transaction THEN
                GLEntry.SETRANGE("Transaction No.", TempRevertTransactionNo.Number);
            IF GLEntry.FINDSET THEN
                REPEAT
                    CLEAR(AutoRevEntry);
                    IF RevType = RevType::Register THEN
                        AutoRevEntry."G/L Register No." := Number;
                    AutoRevEntry."Reversal Type" := RevType;
                    AutoRevEntry."Entry Type" := AutoRevEntry."Entry Type"::"G/L Account";
                    AutoRevEntry."Entry No." := GLEntry."Entry No.";
                    IF NOT GLAcc.GET(GLEntry."G/L Account No.") THEN
                        ERROR(Text009, GLEntry.TABLECAPTION, GLAcc.TABLECAPTION);
                    AutoRevEntry."Account No." := GLAcc."No.";
                    AutoRevEntry."Account Name" := GLAcc.Name;
                    //AutoRevEntry."Posting Date" := GLEntry."Posting Date";
                    AutoRevEntry."Posting Date" := RevDate;
                    AutoRevEntry."Source Code" := GLEntry."Source Code";
                    AutoRevEntry."Journal Batch Name" := GLEntry."Journal Batch Name";
                    AutoRevEntry."Transaction No." := GLEntry."Transaction No.";
                    AutoRevEntry."Source Type" := GLEntry."Source Type";
                    AutoRevEntry."Source No." := GLEntry."Source No.";
                    AutoRevEntry.Description := GLEntry.Description;
                    AutoRevEntry."Amount (LCY)" := GLEntry.Amount;
                    AutoRevEntry."Debit Amount (LCY)" := GLEntry."Debit Amount";
                    AutoRevEntry."Credit Amount (LCY)" := GLEntry."Credit Amount";
                    AutoRevEntry."VAT Amount" := GLEntry."VAT Amount";
                    AutoRevEntry."Document Type" := GLEntry."Document Type";
                    AutoRevEntry."Document No." := GLEntry."Document No.";
                    AutoRevEntry."Bal. Account Type" := GLEntry."Bal. Account Type";
                    AutoRevEntry."Bal. Account No." := GLEntry."Bal. Account No.";
                    AutoRevEntry."Line No." := NextLineNo;
                    AutoRevEntry.AutoReverse := TRUE;
                    NextLineNo := NextLineNo + 1;
                    AutoRevEntry.INSERT;
                UNTIL GLEntry.NEXT = 0;
        UNTIL TempRevertTransactionNo.NEXT = 0;


        IF AutoRevEntry.FIND('-') THEN;
    END;

    PROCEDURE CheckVendLedgerEntryforRev(VendLedgEntry: Record "Vendor Ledger Entry");
    VAR
        Vend: Record Vendor;
    BEGIN
        Vend.GET(VendLedgEntry."Vendor No.");
        CheckPostingDate(
          VendLedgEntry."Posting Date", VendLedgEntry.TABLECAPTION,
          VendLedgEntry."Entry No.");
        Vend.CheckBlockedVendOnJnls(Vend, VendLedgEntry."Document Type", FALSE);
        IF VendLedgEntry.Reversed THEN
            AlreadyReversedEntry(VendLedgEntry.TABLECAPTION, VendLedgEntry."Entry No.");
        CheckDtldVendLedgEntryforRev(VendLedgEntry);
    END;

    PROCEDURE CheckDtldVendLedgEntryforRev(VendLedgEntry: Record "Vendor Ledger Entry"): Boolean;
    VAR
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    BEGIN
        DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.");
        DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
        IF DtldVendLedgEntry.FIND('-') THEN
            REPEAT
                IF (DtldVendLedgEntry."Entry Type" <> DtldVendLedgEntry."Entry Type"::"Initial Entry") AND
                   (NOT DtldVendLedgEntry.Unapplied)
                THEN
                    ERROR(
                      Text50000, VendLedgEntry.TABLECAPTION, VendLedgEntry."Entry No.");
            UNTIL DtldVendLedgEntry.NEXT = 0;
    END;

    PROCEDURE CheckBankAccReverse(BankAccLedgEntry: Record "Bank Account Ledger Entry");
    VAR
        BankAcc: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        BankAccRecoLine: Record "Bank Acc. Reconciliation Line";
    BEGIN
        BankAcc.GET(BankAccLedgEntry."Bank Account No.");
        CheckPostingDate(
          BankAccLedgEntry."Posting Date", BankAccLedgEntry.TABLECAPTION,
          BankAccLedgEntry."Entry No.");
        BankAcc.TESTFIELD(Blocked, FALSE);
        IF BankAccLedgEntry.Reversed THEN
            AlreadyReversedEntry(BankAccLedgEntry.TABLECAPTION, BankAccLedgEntry."Entry No.");
        IF NOT BankAccLedgEntry.Open THEN
            ERROR(
              Text006, BankAccLedgEntry.TABLECAPTION, BankAccLedgEntry."Entry No.");
        CheckLedgEntry.SETCURRENTKEY("Bank Account Ledger Entry No.");
        CheckLedgEntry.SETRANGE("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
        IF CheckLedgEntry.FIND('-') THEN
            ERROR(
              Text003, BankAccLedgEntry.TABLECAPTION, BankAccLedgEntry."Entry No.");
    END;

}