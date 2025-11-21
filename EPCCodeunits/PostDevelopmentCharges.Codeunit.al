codeunit 97765 "Post Development Charges"
{
    // ALLETDK021112-- Modified code to create single entry for Bank and Cash. And modified to create single entry for clearing cheque.
    //              -- Added code to create single bank/cheque entry for Cheque bounce.
    // 
    // BBG1.00 ALLEDK 050313 Code commented for dim-3
    // BBG1.00 250613 Added code for SMS
    // ALLEPG 180714 : Code modify for password.
    // 
    // BBG080914 Added code for check the Payment plan details.
    // BBG2.01 090115 Added new function for Associate payment window 'PostAssociatePayment'
    // //120816 Added code for not creation of buffer entries in case of commission not reversed.
    // 061016 DK CreateTDSENTRy Added new function for Special Payment.
    // 
    // ALLEDK 10112016  Added code for flow of Receipt Line No.

    TableNo = Application;

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Application Released.';
        GenJnlLine: Record "Gen. Journal Line" temporary;
        UserSetup: Record "User Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Text002: Label 'Order No %1, Installment No. %2 has already been posted.';
        Text003: Label 'Amount due must be zero.';
        Text004: Label 'Clearance Date %1, cannot be less than Cheque Date %2, for Cheque No. %3.';
        Text005: Label 'Posting to Cash/Cheque A/C   #2######\';
        Text006: Label 'Posting to Order A/C          #3######\';
        Text007: Label 'Creating Buffers             #4######\';
        Text008: Label 'Moving Payment Lines         #5######';
        Text009: Label 'Order No %1, Installment No. %2 has already been posted.';
        Text010: Label 'Entry No. %1 is already Posted.';
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        GetDescription: Codeunit GetDescription;
        Text011: Label 'Status Must not be %1';
        Text012: Label 'Payment is Pending against Order No. %1';
        Text013: Label 'Cheque No %1  is Pending against Order No. %2';
        UMaster: Record "Unit Master";
        JnlPostingDocNo: Code[20];
        //PostPayment1: Codeunit 97821;
        GenJnlBatch: Record "Gen. Journal Batch";
        AJVM1: Boolean;
        GenJnlLine1: Record "Gen. Journal Line";
        GLSetup: Record "General Ledger Setup";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        Dim2Code: Code[20];
        JVPostedDocNo: Code[20];
        CompInfo: Record "Company Information";
        PostDate: Date;
        ComHoldDate: Date;
        UnitMaster: Record "Unit Master";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CompanyGLAccount: Record "Company wise G/L Account";
        GenJnlLineDevCharge: Record "Gen. Journal Line";
        vAppPaymentEntry: Record "Application Pmt Devlop. Entry";
        UnitSetup: Record "Unit Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        ApplyAmount: Decimal;


    procedure InitVoucherNarration(JnlTemplate: Code[10]; JnlBatch: Code[10]; DocumentNo: Code[20]; GenJnlLineNo: Integer; NarrationLineNo: Integer; LineNarrationText: Text[50])
    var
        GenJnlNarration: Record "Gen. Journal Narration"; //"Gen. Journal Narration";
        LineNo: Integer;
        PayToName: Text[50];
        Cust: Record Customer;
        Vend: Record Vendor;
        OldGenJnlNarration: Record "Gen. Journal Narration";
    begin
        OldGenJnlNarration.RESET;
        OldGenJnlNarration.SETRANGE("Journal Template Name", JnlTemplate);
        OldGenJnlNarration.SETRANGE("Journal Batch Name", JnlBatch);
        OldGenJnlNarration.SETRANGE("Document No.", DocumentNo);
        OldGenJnlNarration.SETRANGE("Gen. Journal Line No.", GenJnlLineNo);
        OldGenJnlNarration.SETRANGE("Line No.", NarrationLineNo);
        IF NOT OldGenJnlNarration.FINDFIRST THEN BEGIN
            GenJnlNarration.INIT;
            GenJnlNarration."Journal Template Name" := JnlTemplate;
            GenJnlNarration."Journal Batch Name" := JnlBatch;
            GenJnlNarration."Document No." := DocumentNo;
            GenJnlNarration."Gen. Journal Line No." := GenJnlLineNo;
            GenJnlNarration."Line No." := NarrationLineNo;
            GenJnlNarration.Narration := LineNarrationText;
            GenJnlNarration.INSERT;
        END;
    end;


    procedure PostCustomerDevChargeEntry(D_ApplicationPaymentEntry: Record "Application Pmt Devlop. Entry")
    var
        D_ConfOrder: Record "New Confirmed Order";
        PostedDocNo: Code[20];
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
    begin
        D_ConfOrder.GET(D_ApplicationPaymentEntry."Document No.");
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Pmt Sch. Posting No. Series");
        UnitSetup.TESTFIELD("GST Group Code");
        UnitSetup.TESTFIELD("HSN/SAC Code");
        UnitSetup.TESTFIELD("GST Place of Supply");

        PostedDocNo := '';
        PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", TODAY, TRUE);
        NarrationText1 := 'Appl. Received - ' + COPYSTR(D_ConfOrder."Member Name", 1, 30);

        GenJnlLineDevCharge.RESET;
        GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLineDevCharge.DELETEALL;

        Line := 10000;

        IF ((D_ApplicationPaymentEntry.Amount > 0) AND (D_ApplicationPaymentEntry."Payment Mode" IN [D_ApplicationPaymentEntry."Payment Mode"::Bank, D_ApplicationPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking",
  D_ApplicationPaymentEntry."Payment Mode"::"D.D."])) THEN BEGIN
            IF PaymentMethod.GET(D_ApplicationPaymentEntry."Payment Method") THEN;
            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLineDevCharge."Line No." := Line;
            GenJnlLineDevCharge.VALIDATE("Posting Date", D_ApplicationPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
            GenJnlLineDevCharge.VALIDATE("Document Date", D_ApplicationPaymentEntry."Posting date");
            GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Account No.", D_ConfOrder."Customer No.");
            GenJnlLineDevCharge.VALIDATE(Amount, D_ApplicationPaymentEntry.Amount * -1);
            GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Payment;
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge."Bill-to/Pay-to No." := D_ConfOrder."Customer No.";
            GenJnlLineDevCharge.VALIDATE("Source Type", GenJnlLineDevCharge."Source Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Source No.", D_ConfOrder."Customer No.");
            BondPostingGroup1.GET(D_ConfOrder."Bond Posting Group");
            GenJnlLineDevCharge."Posting Group" := D_ConfOrder."Bond Posting Group";
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := D_ConfOrder."Shortcut Dimension 1 Code";
            //GenJnlLineDevCharge."Source Code" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Advance;
            GenJnlLineDevCharge."Order Ref No." := D_ApplicationPaymentEntry."Document No.";
            GenJnlLineDevCharge."Unit No." := D_ConfOrder."Unit Code";
            GenJnlLineDevCharge."Cheque No." := D_ApplicationPaymentEntry."Cheque No./ Transaction No.";
            GenJnlLineDevCharge."Cheque Date" := D_ApplicationPaymentEntry."Cheque Date";
            GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
            IF D_ApplicationPaymentEntry."Payment Mode" = D_ApplicationPaymentEntry."Payment Mode"::Bank THEN
                GenJnlLineDevCharge.Description := 'Cheque Received'
            ELSE
                IF D_ApplicationPaymentEntry."Payment Mode" = D_ApplicationPaymentEntry."Payment Mode"::"D.D." THEN
                    GenJnlLineDevCharge.Description := 'D.D. Received'
                ELSE
                    IF D_ApplicationPaymentEntry."Payment Mode" = D_ApplicationPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking" THEN
                        GenJnlLineDevCharge.Description := 'D.C./C.C./Net Banking';

            GenJnlLineDevCharge."Payment Mode" := D_ApplicationPaymentEntry."Payment Mode"; //ALLEDK 030313
            GenJnlLineDevCharge."Paid To/Received From" := GenJnlLineDevCharge."Paid To/Received From"::"Marketing Member";
            GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
            GenJnlLineDevCharge."Receipt Line No." := D_ApplicationPaymentEntry."Receipt Line No."; //ALLEDK 10112016
            GenJnlLineDevCharge."Development Application No." := D_ApplicationPaymentEntry."Document No.";
            GenJnlLineDevCharge."Development Appl. Rcpt LineNo." := D_ApplicationPaymentEntry."Receipt Line No.";
            GenJnlLineDevCharge.VALIDATE("Location Code", D_ApplicationPaymentEntry."Shortcut Dimension 1 Code");
            //GenJnlLineDevCharge.VALIDATE("GST Group Type",GenJnlLineDevCharge."GST Group Type"::Service);
            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Bal. Account Type"::"Bank Account");
            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", D_ApplicationPaymentEntry."Deposit/Paid Bank");
            GenJnlLineDevCharge.VALIDATE("GST Group Code", UnitSetup."GST Group Code");
            GenJnlLineDevCharge.VALIDATE("HSN/SAC Code", UnitSetup."HSN/SAC Code");
            //GenJnlLineDevCharge.VALIDATE("GST Place of Supply",UnitSetup."GST Place of Supply");
            GenJnlLineDevCharge.VALIDATE("GST on Advance Payment", TRUE);
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", D_ConfOrder."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
        END;
        PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
        IF vAppPaymentEntry.GET(D_ApplicationPaymentEntry."Document Type", D_ApplicationPaymentEntry."Document No.", D_ApplicationPaymentEntry."Line No.") THEN BEGIN
            vAppPaymentEntry.Posted := TRUE;
            vAppPaymentEntry."Posted Document No." := PostedDocNo;
            vAppPaymentEntry.MODIFY;
        END;
    end;


    procedure PostGenJnlLinesDevCharge(GenJournalLine_2: Record "Gen. Journal Line")
    begin
        CLEAR(GenJnlPostLine);
        CLEAR(GenJnlPostBatch);
        UserSetup.GET(USERID);
        UnitSetup.GET;
        //GenJournalLine_2.RESET;
        GenJournalLine_2.SETRANGE("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJournalLine_2.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        IF GenJournalLine_2.FINDFIRST THEN BEGIN
            REPEAT
                //GenJnlPostLine.SetDocumentNo(GenJournalLine_2."Document No.");
                GenJnlPostLine.RunWithCheck(GenJournalLine_2);
            UNTIL GenJournalLine_2.NEXT = 0;
        END;
        //GenJnlPostBatch.DeleteGenJournalNarration(GenJournalLine_2);
        GenJournalLine_2.DELETEALL;
    end;


    procedure PostDevChargeInLLP(P_ApplicationDevelopmentLine: Record "New Application DevelopmntLine")
    var
        BondPaymentEntry: Record "NewApplication Payment Entry";
        Line: Integer;
        CashAmount: Decimal;
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        NewApplication: Record "New Confirmed Order";
        PostedDocNo: Code[20];
        OldApplicationDevelopmentLine: Record "New Application DevelopmntLine";
    begin
        NewApplication.GET(P_ApplicationDevelopmentLine."Document No.");
        NarrationText1 := 'Appl. Charge Received - ' + COPYSTR(NewApplication."Member Name", 1, 30);
        UnitSetup.GET;
        PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", TODAY, TRUE);

        GenJnlLineDevCharge.RESET;
        GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLineDevCharge.DELETEALL;

        Line := 10000;
        IF ((P_ApplicationDevelopmentLine.Amount > 0) AND (P_ApplicationDevelopmentLine."Payment Mode" IN [P_ApplicationDevelopmentLine."Payment Mode"::Bank, P_ApplicationDevelopmentLine."Payment Mode"::"D.C./C.C./Net Banking",
P_ApplicationDevelopmentLine."Payment Mode"::"D.D."])) THEN BEGIN
            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLineDevCharge."Line No." := Line;
            GenJnlLineDevCharge.VALIDATE("Posting Date", P_ApplicationDevelopmentLine."Posting date"); //BBG1.00 ALLEDK 120313
            GenJnlLineDevCharge.VALIDATE("Document Date", P_ApplicationDevelopmentLine."Document Date");
            GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::"Bank Account");
            GenJnlLineDevCharge.VALIDATE("Account No.", P_ApplicationDevelopmentLine."Deposit/Paid Bank");
            GenJnlLineDevCharge.VALIDATE(Amount, P_ApplicationDevelopmentLine.Amount);
            GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Payment;
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge.VALIDATE("Source Type", GenJnlLineDevCharge."Source Type"::"Bank Account");
            GenJnlLineDevCharge.VALIDATE("Source No.", P_ApplicationDevelopmentLine."Deposit/Paid Bank");
            GenJnlLineDevCharge."Posting Group" := NewApplication."Bond Posting Group";
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := NewApplication."Shortcut Dimension 1 Code";
            GenJnlLineDevCharge."Shortcut Dimension 2 Code" := NewApplication."Shortcut Dimension 2 Code";
            GenJnlLineDevCharge."Source Code" := UnitSetup."Cr. Source Code";
            GenJnlLineDevCharge."System-Created Entry" := TRUE;
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Running;
            GenJnlLineDevCharge."Order Ref No." := P_ApplicationDevelopmentLine."Document No.";
            GenJnlLineDevCharge."Unit No." := NewApplication."Unit Code";
            GenJnlLineDevCharge."Cheque No." := P_ApplicationDevelopmentLine."Cheque No./ Transaction No.";
            GenJnlLineDevCharge."Cheque Date" := P_ApplicationDevelopmentLine."Cheque Date";
            GenJnlLineDevCharge."Installment No." := P_ApplicationDevelopmentLine."Installment No.";
            GenJnlLineDevCharge.Description := NewApplication."Customer No.";
            GenJnlLineDevCharge."Payment Mode" := P_ApplicationDevelopmentLine."Payment Mode"; //ALLEDK 030313
            GenJnlLineDevCharge."Paid To/Received From" := GenJnlLineDevCharge."Paid To/Received From"::"Marketing Member";
            GenJnlLineDevCharge."Paid To/Received From Code" := NewApplication."Received From Code";
            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Account Type"::"G/L Account");
            CompanywiseGLAccount.RESET;
            CompanywiseGLAccount.SETRANGE("Company Code", NewApplication."Company Name");
            IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Receivable Account");
            END;

            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Receivable Account");
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", NewApplication."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge."Receipt Line No." := P_ApplicationDevelopmentLine."Line No."; //ALLEDK 10112016
            GenJnlLineDevCharge."Development Application No." := P_ApplicationDevelopmentLine."Document No.";
            GenJnlLineDevCharge."Development Appl. Rcpt LineNo." := P_ApplicationDevelopmentLine."Line No.";

            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", NewApplication."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
        END;
        PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
        OldApplicationDevelopmentLine.RESET;
        OldApplicationDevelopmentLine.SETRANGE("Document No.", P_ApplicationDevelopmentLine."Document No.");
        OldApplicationDevelopmentLine.SETRANGE("Line No.", P_ApplicationDevelopmentLine."Line No.");
        IF OldApplicationDevelopmentLine.FINDFIRST THEN BEGIN
            OldApplicationDevelopmentLine."LLP Posted Document No." := PostedDocNo;
            OldApplicationDevelopmentLine."Receipt Post in LLP Company" := TRUE;
            OldApplicationDevelopmentLine."Receipt Post in LLP Comp Date" := TODAY;
            OldApplicationDevelopmentLine.MODIFY;
        END;
    end;


    procedure PostRefundDevChargeInLLP(P_ApplicationDevelopmentLine: Record "New Application DevelopmntLine")
    var
        BondPaymentEntry: Record "NewApplication Payment Entry";
        Line: Integer;
        CashAmount: Decimal;
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        NewApplication: Record "New Confirmed Order";
        PostedDocNo: Code[20];
    begin
        NewApplication.GET(P_ApplicationDevelopmentLine."Document No.");
        NarrationText1 := 'Appl. Charge Received - ' + COPYSTR(NewApplication."Member Name", 1, 30);

        PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", TODAY, TRUE);

        UnitSetup.GET;

        GenJnlLine.RESET;
        GenJnlLine.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;

        Line := 10000;
        IF ((P_ApplicationDevelopmentLine.Amount < 0) AND (P_ApplicationDevelopmentLine."Payment Mode" IN [P_ApplicationDevelopmentLine."Payment Mode"::"Refund Bank"])) THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := Line;
            GenJnlLine.VALIDATE("Posting Date", P_ApplicationDevelopmentLine."Posting date"); //BBG1.00 ALLEDK 120313
            GenJnlLine.VALIDATE("Document Date", P_ApplicationDevelopmentLine."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
            GenJnlLine.VALIDATE("Account No.", P_ApplicationDevelopmentLine."Deposit/Paid Bank");
            GenJnlLine.VALIDATE(Amount, P_ApplicationDevelopmentLine.Amount);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
            GenJnlLine."Document No." := PostedDocNo;
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::"Bank Account");
            GenJnlLine.VALIDATE("Source No.", P_ApplicationDevelopmentLine."Deposit/Paid Bank");
            GenJnlLine."Posting Group" := NewApplication."Bond Posting Group";
            GenJnlLine."Shortcut Dimension 1 Code" := NewApplication."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := NewApplication."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := UnitSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Order Ref No." := P_ApplicationDevelopmentLine."Document No.";
            GenJnlLine."Unit No." := NewApplication."Unit Code";
            GenJnlLine."Cheque No." := P_ApplicationDevelopmentLine."Cheque No./ Transaction No.";
            GenJnlLine."Cheque Date" := P_ApplicationDevelopmentLine."Cheque Date";
            GenJnlLine."Installment No." := P_ApplicationDevelopmentLine."Installment No.";
            GenJnlLine.Description := NewApplication."Customer No.";
            GenJnlLine."Payment Mode" := P_ApplicationDevelopmentLine."Payment Mode"; //ALLEDK 030313
            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
            GenJnlLine."Paid To/Received From Code" := NewApplication."Received From Code";
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
            CompanywiseGLAccount.RESET;
            CompanywiseGLAccount.SETRANGE("Company Code", NewApplication."Company Name");
            IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Payable Account");
            END;

            GenJnlLine.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Payable Account");
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", NewApplication."Shortcut Dimension 1 Code");
            GenJnlLine."Receipt Line No." := P_ApplicationDevelopmentLine."Line No."; //ALLEDK 10112016
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", NewApplication."Shortcut Dimension 1 Code");
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
        END;
        PostGenJnlLinesDevCharge(GenJnlLine);
    end;


    procedure PostDevChargeInDevlopmentComp(P_ApplicationPayEntry: Record "Application Payment Entry")
    var
        BondPaymentEntry: Record "NewApplication Payment Entry";
        Line: Integer;
        CashAmount: Decimal;
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        NewApplication: Record "New Confirmed Order";
        PostedDocNo: Code[20];
    begin

        NewApplication.GET(P_ApplicationPayEntry."Document No.");
        NarrationText1 := 'Appl. Charge Received - ' + COPYSTR(NewApplication."Member Name", 1, 30);

        PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", TODAY, TRUE);

        UnitSetup.GET;

        GenJnlLine.RESET;
        GenJnlLine.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;

        Line := 10000;
        IF ((P_ApplicationPayEntry.Amount > 0) AND (P_ApplicationPayEntry."Payment Mode" IN [P_ApplicationPayEntry."Payment Mode"::Bank, P_ApplicationPayEntry."Payment Mode"::"D.C./C.C./Net Banking",
P_ApplicationPayEntry."Payment Mode"::"D.D."])) THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := Line;
            GenJnlLine.VALIDATE("Posting Date", P_ApplicationPayEntry."Posting date"); //BBG1.00 ALLEDK 120313
            GenJnlLine.VALIDATE("Document Date", P_ApplicationPayEntry."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", NewApplication."Customer No.");
            GenJnlLine.VALIDATE(Amount, P_ApplicationPayEntry.Amount);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := PostedDocNo;
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", NewApplication."Customer No.");
            GenJnlLine."Posting Group" := NewApplication."Bond Posting Group";
            GenJnlLine."Shortcut Dimension 1 Code" := NewApplication."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := NewApplication."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := UnitSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Advance;
            GenJnlLine."Order Ref No." := P_ApplicationPayEntry."Document No.";
            GenJnlLine."Unit No." := NewApplication."Unit Code";
            GenJnlLine."Cheque No." := P_ApplicationPayEntry."Cheque No./ Transaction No.";
            GenJnlLine."Cheque Date" := P_ApplicationPayEntry."Cheque Date";
            GenJnlLine."Installment No." := P_ApplicationPayEntry."Installment No.";
            GenJnlLine.Description := NewApplication."Customer No.";
            GenJnlLine."Payment Mode" := P_ApplicationPayEntry."Payment Mode"; //ALLEDK 030313
            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
            GenJnlLine."Paid To/Received From Code" := NewApplication."Received From Code";
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
            CompanywiseGLAccount.RESET;
            CompanywiseGLAccount.SETRANGE("Company Code", NewApplication."Company Name");
            IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Payable Account");
            END;

            GenJnlLine.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Payable Account");
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", NewApplication."Shortcut Dimension 1 Code");
            GenJnlLine."Receipt Line No." := P_ApplicationPayEntry."Line No."; //ALLEDK 10112016

            GenJnlLineDevCharge.VALIDATE("GST Group Type", GenJnlLineDevCharge."GST Group Type"::Service);
            GenJnlLineDevCharge.VALIDATE("GST Group Code", UnitSetup."GST Group Code");
            GenJnlLineDevCharge.VALIDATE("HSN/SAC Code", UnitSetup."HSN/SAC Code");
            GenJnlLineDevCharge.VALIDATE("GST Place of Supply", UnitSetup."GST Place of Supply");
            GenJnlLineDevCharge.VALIDATE("GST on Advance Payment", TRUE);
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", NewApplication."Shortcut Dimension 1 Code");
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
        END;
        PostGenJnlLinesDevCharge(GenJnlLine);
    end;


    procedure CreateDevlopmentCustomerRefundInv(D_ApplicationPaymentEntry: Record "Application Pmt Devlop. Entry"; ApplyDocNo: Code[20])
    var
        D_ConfOrder: Record "New Confirmed Order";
        PostedDocNo: Code[20];
        BondPaymentEntry: Record "Application Pmt Devlop. Entry";
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
        ApplicationDevelopmntLine: Record "New Application DevelopmntLine";
    begin
        D_ConfOrder.GET(D_ApplicationPaymentEntry."Document No.");
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Pmt Sch. Posting No. Series");
        UnitSetup.TESTFIELD("GST Group Code");
        UnitSetup.TESTFIELD("HSN/SAC Code");
        UnitSetup.TESTFIELD("GST Place of Supply");

        PostedDocNo := '';
        PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
        NarrationText1 := 'Appl. Received - ' + COPYSTR(D_ConfOrder."Member Name", 1, 30);

        GenJnlLineDevCharge.RESET;
        GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLineDevCharge.DELETEALL;

        Line := 10000;
        IF ((D_ApplicationPaymentEntry.Amount < 0) AND (D_ApplicationPaymentEntry."Payment Mode" IN [D_ApplicationPaymentEntry."Payment Mode"::"Refund Bank"])) THEN BEGIN
            IF PaymentMethod.GET(D_ApplicationPaymentEntry."Payment Method") THEN;
            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLineDevCharge."Line No." := Line;
            GenJnlLineDevCharge.VALIDATE("Posting Date", D_ApplicationPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
            GenJnlLineDevCharge.VALIDATE("Document Date", D_ApplicationPaymentEntry."Posting date");
            GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Account No.", D_ConfOrder."Customer No.");
            GenJnlLineDevCharge.VALIDATE(Amount, D_ApplicationPaymentEntry.Amount * -1);
            GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Refund;
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge."Bill-to/Pay-to No." := D_ConfOrder."Customer No.";
            GenJnlLineDevCharge.VALIDATE("Source Type", GenJnlLineDevCharge."Source Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Source No.", D_ConfOrder."Customer No.");
            BondPostingGroup1.GET(D_ConfOrder."Bond Posting Group");
            GenJnlLineDevCharge."Posting Group" := D_ConfOrder."Bond Posting Group";
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := D_ApplicationPaymentEntry."Shortcut Dimension 1 Code";
            //GenJnlLineDevCharge."Source Code" := 'BANKPYMTV';
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Running;
            GenJnlLineDevCharge."Order Ref No." := D_ApplicationPaymentEntry."Document No.";
            GenJnlLineDevCharge."Unit No." := D_ConfOrder."Unit Code";
            GenJnlLineDevCharge."Cheque No." := D_ApplicationPaymentEntry."Cheque No./ Transaction No.";
            GenJnlLineDevCharge."Cheque Date" := D_ApplicationPaymentEntry."Cheque Date";
            GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
            GenJnlLineDevCharge.Description := 'Refund to Customer';
            GenJnlLineDevCharge.VALIDATE("Location Code", D_ApplicationPaymentEntry."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge."Payment Mode" := D_ApplicationPaymentEntry."Payment Mode"; //ALLEDK 030313
            GenJnlLineDevCharge."Development Application No." := D_ApplicationPaymentEntry."Document No.";
            GenJnlLineDevCharge."Development Appl. Rcpt LineNo." := D_ApplicationPaymentEntry."Receipt Line No.";
            GenJnlLineDevCharge."Paid To/Received From" := GenJnlLineDevCharge."Paid To/Received From"::"Marketing Member";
            GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
            GenJnlLineDevCharge."Receipt Line No." := D_ApplicationPaymentEntry."Receipt Line No."; //ALLEDK 10112016
            GenJnlLineDevCharge."GST Reason Type" := GenJnlLineDevCharge."GST Reason Type"::Others;
            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Bal. Account Type"::"Bank Account");
            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", D_ApplicationPaymentEntry."Deposit/Paid Bank");
            GenJnlLineDevCharge.VALIDATE("Applies-to Doc. Type", GenJnlLineDevCharge."Applies-to Doc. Type"::Payment);
            GenJnlLineDevCharge."Applies-to Doc. No." := ApplyDocNo;
            GenJnlLineDevCharge.UpdateOpenonLookup;
            GenJnlLineDevCharge.VALIDATE("Applies-to Doc. No.", ApplyDocNo);
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", D_ApplicationPaymentEntry."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
        END;
        PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
        IF vAppPaymentEntry.GET(D_ApplicationPaymentEntry."Document Type", D_ApplicationPaymentEntry."Document No.", D_ApplicationPaymentEntry."Line No.") THEN BEGIN
            vAppPaymentEntry.Posted := TRUE;
            vAppPaymentEntry."Posted Document No." := PostedDocNo;
            vAppPaymentEntry.MODIFY;
        END;
    end;


    procedure PostCustRefundBankReco(D_ApplicationPaymentEntry: Record "Application Pmt Devlop. Entry")
    var
        D_ConfOrder: Record "New Confirmed Order";
        PostedDocNo: Code[20];
        BondPaymentEntry: Record "Application Payment Entry";
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
    begin
        D_ConfOrder.GET(D_ApplicationPaymentEntry."Document No.");
        UnitSetup.GET;
        PostedDocNo := '';
        PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
        NarrationText1 := 'Appl. Received - ' + COPYSTR(D_ConfOrder."Member Name", 1, 30);

        GenJnlLineDevCharge.RESET;
        GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLineDevCharge.DELETEALL;

        Line := 10000;
        IF ((D_ApplicationPaymentEntry.Amount > 0) AND (D_ApplicationPaymentEntry."Payment Mode" IN [D_ApplicationPaymentEntry."Payment Mode"::Bank])) THEN BEGIN
            IF PaymentMethod.GET(D_ApplicationPaymentEntry."Payment Method") THEN;
            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLineDevCharge."Line No." := Line;
            GenJnlLineDevCharge.VALIDATE("Posting Date", D_ApplicationPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
            GenJnlLineDevCharge.VALIDATE("Document Date", D_ApplicationPaymentEntry."Posting date");
            GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Account No.", D_ConfOrder."Customer No.");
            GenJnlLineDevCharge.VALIDATE(Amount, D_ApplicationPaymentEntry.Amount);
            GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Refund;
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge."Bill-to/Pay-to No." := D_ConfOrder."Customer No.";
            GenJnlLineDevCharge.VALIDATE("Source Type", GenJnlLineDevCharge."Source Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Source No.", D_ConfOrder."Customer No.");
            BondPostingGroup1.GET(D_ConfOrder."Bond Posting Group");
            GenJnlLineDevCharge."Posting Group" := D_ConfOrder."Bond Posting Group";
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := D_ApplicationPaymentEntry."Shortcut Dimension 1 Code";
            GenJnlLineDevCharge."Source Code" := UnitSetup."Cr. Source Code";
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Running;
            GenJnlLineDevCharge."Order Ref No." := D_ApplicationPaymentEntry."Document No.";
            GenJnlLineDevCharge."Unit No." := D_ConfOrder."Unit Code";
            GenJnlLineDevCharge."Cheque No." := D_ApplicationPaymentEntry."Cheque No./ Transaction No.";
            GenJnlLineDevCharge."Cheque Date" := D_ApplicationPaymentEntry."Cheque Date";
            GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
            GenJnlLineDevCharge.VALIDATE("Location Code", D_ApplicationPaymentEntry."Shortcut Dimension 1 Code");
            IF D_ApplicationPaymentEntry."Payment Mode" = D_ApplicationPaymentEntry."Payment Mode"::Bank THEN
                GenJnlLineDevCharge.Description := 'Cheque Received'
            ELSE
                IF D_ApplicationPaymentEntry."Payment Mode" = D_ApplicationPaymentEntry."Payment Mode"::"D.D." THEN
                    GenJnlLineDevCharge.Description := 'D.D. Received'
                ELSE
                    IF D_ApplicationPaymentEntry."Payment Mode" = D_ApplicationPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking" THEN
                        GenJnlLineDevCharge.Description := 'D.C./C.C./Net Banking';

            GenJnlLineDevCharge."Payment Mode" := D_ApplicationPaymentEntry."Payment Mode"; //ALLEDK 030313
            GenJnlLineDevCharge."Paid To/Received From" := GenJnlLineDevCharge."Paid To/Received From"::"Marketing Member";
            GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
            GenJnlLineDevCharge."Receipt Line No." := D_ApplicationPaymentEntry."Receipt Line No."; //ALLEDK 10112016
            GenJnlLineDevCharge."Development Application No." := D_ApplicationPaymentEntry."Document No.";
            GenJnlLineDevCharge."Development Appl. Rcpt LineNo." := D_ApplicationPaymentEntry."Receipt Line No.";

            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Bal. Account Type"::"Bank Account");
            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", D_ApplicationPaymentEntry."Deposit/Paid Bank");
            GenJnlLineDevCharge.VALIDATE("Applies-to Doc. Type", GenJnlLineDevCharge."Applies-to Doc. Type"::Payment);
            GenJnlLineDevCharge."GST Reason Type" := GenJnlLineDevCharge."GST Reason Type"::Others;
            GenJnlLineDevCharge."Applies-to Doc. No." := D_ApplicationPaymentEntry."Posted Document No.";
            GenJnlLineDevCharge.UpdateOpenonLookup;
            GenJnlLineDevCharge.VALIDATE("Applies-to Doc. No.", D_ApplicationPaymentEntry."Posted Document No.");
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", D_ApplicationPaymentEntry."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
        END;
        PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
    end;


    procedure PostCustomerDevChargeInterCompVarita(D_ApplicationPaymentEntry: Record "Application Pmt Devlop. Entry")
    var
        D_ConfOrder: Record "New Confirmed Order";
        PostedDocNo: Code[20];
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        V_CompanyInformation: Record "Company Information";
    begin
        D_ConfOrder.GET(D_ApplicationPaymentEntry."Document No.");
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Pmt Sch. Posting No. Series");
        UnitSetup.TESTFIELD("GST Group Code");
        UnitSetup.TESTFIELD("HSN/SAC Code");
        UnitSetup.TESTFIELD("GST Place of Supply");

        PostedDocNo := '';
        PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
        NarrationText1 := 'Appl. Received - ' + COPYSTR(D_ConfOrder."Member Name", 1, 30);

        GenJnlLineDevCharge.RESET;
        GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLineDevCharge.DELETEALL;

        Line := 10000;
        IF ((D_ApplicationPaymentEntry.Amount > 0) AND (D_ApplicationPaymentEntry."Payment Mode" IN [D_ApplicationPaymentEntry."Payment Mode"::Bank, D_ApplicationPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking",
  D_ApplicationPaymentEntry."Payment Mode"::"D.D."])) THEN BEGIN
            IF PaymentMethod.GET(D_ApplicationPaymentEntry."Payment Method") THEN;
            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLineDevCharge."Line No." := Line;
            GenJnlLineDevCharge.VALIDATE("Posting Date", D_ApplicationPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
            GenJnlLineDevCharge.VALIDATE("Document Date", D_ApplicationPaymentEntry."Posting date");
            GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Account No.", D_ConfOrder."Customer No.");
            GenJnlLineDevCharge.VALIDATE(Amount, D_ApplicationPaymentEntry.Amount * -1);
            GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Payment;
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge."Bill-to/Pay-to No." := D_ConfOrder."Customer No.";
            GenJnlLineDevCharge.VALIDATE("Source Type", GenJnlLineDevCharge."Source Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Source No.", D_ConfOrder."Customer No.");
            BondPostingGroup1.GET(D_ConfOrder."Bond Posting Group");
            GenJnlLineDevCharge."Posting Group" := D_ConfOrder."Bond Posting Group";
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := D_ApplicationPaymentEntry."Shortcut Dimension 1 Code";
            //GenJnlLineDevCharge."Source Code" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Advance;
            GenJnlLineDevCharge."Order Ref No." := D_ApplicationPaymentEntry."Document No.";
            GenJnlLineDevCharge."Development Application No." := D_ApplicationPaymentEntry."Document No.";
            GenJnlLineDevCharge."Development Appl. Rcpt LineNo." := D_ApplicationPaymentEntry."Receipt Line No.";

            GenJnlLineDevCharge."Unit No." := D_ConfOrder."Unit Code";
            GenJnlLineDevCharge."Cheque No." := D_ApplicationPaymentEntry."Cheque No./ Transaction No.";
            GenJnlLineDevCharge."Cheque Date" := D_ApplicationPaymentEntry."Cheque Date";
            GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
            IF D_ApplicationPaymentEntry."Payment Mode" = D_ApplicationPaymentEntry."Payment Mode"::Bank THEN
                GenJnlLineDevCharge.Description := 'Cheque Received'
            ELSE
                IF D_ApplicationPaymentEntry."Payment Mode" = D_ApplicationPaymentEntry."Payment Mode"::"D.D." THEN
                    GenJnlLineDevCharge.Description := 'D.D. Received'
                ELSE
                    IF D_ApplicationPaymentEntry."Payment Mode" = D_ApplicationPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking" THEN
                        GenJnlLineDevCharge.Description := 'D.C./C.C./Net Banking';

            GenJnlLineDevCharge."Payment Mode" := D_ApplicationPaymentEntry."Payment Mode"; //ALLEDK 030313
            GenJnlLineDevCharge."Paid To/Received From" := GenJnlLineDevCharge."Paid To/Received From"::"Marketing Member";
            GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
            GenJnlLineDevCharge."Receipt Line No." := D_ApplicationPaymentEntry."Receipt Line No."; //ALLEDK 10112016
            GenJnlLineDevCharge."Development Application No." := D_ApplicationPaymentEntry."Document No.";
            GenJnlLineDevCharge."Development Appl. Rcpt LineNo." := D_ApplicationPaymentEntry."Receipt Line No.";
            GenJnlLineDevCharge.VALIDATE("Location Code", D_ApplicationPaymentEntry."Shortcut Dimension 1 Code");
            V_CompanyInformation.RESET;
            V_CompanyInformation.CHANGECOMPANY(D_ConfOrder."Company Name");
            IF V_CompanyInformation.GET THEN BEGIN
                V_CompanyInformation.TESTFIELD("Development Company Name");
                CompanywiseGLAccount.RESET;
                CompanywiseGLAccount.SETRANGE("Company Code", V_CompanyInformation."Development Company Name");
                IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                    CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Receivable Account");
                END;
            END;
            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Bal. Account Type"::"G/L Account");
            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Receivable Account");
            GenJnlLineDevCharge.VALIDATE("GST Group Code", UnitSetup."GST Group Code");
            GenJnlLineDevCharge.VALIDATE("HSN/SAC Code", UnitSetup."HSN/SAC Code");
            GenJnlLineDevCharge.VALIDATE("GST on Advance Payment", TRUE);
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", D_ApplicationPaymentEntry."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
        END;
        PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
        IF vAppPaymentEntry.GET(D_ApplicationPaymentEntry."Document Type", D_ApplicationPaymentEntry."Document No.", D_ApplicationPaymentEntry."Line No.") THEN BEGIN
            vAppPaymentEntry.Posted := TRUE;
            vAppPaymentEntry."Posted Document No." := PostedDocNo;
            vAppPaymentEntry."Cheque Status" := vAppPaymentEntry."Cheque Status"::Cleared;
            vAppPaymentEntry.MODIFY;
        END;
    end;


    procedure CustomerChange(ConfirmedOrder: Record "Confirmed Order")
    begin
    end;


    procedure ProjectChange(ConfirmedOrder: Record "Confirmed Order")
    var
        ApplicationDevelopmentLine: Record "New Application DevelopmntLine";
        TotalAmt: Decimal;
        N_ConfirmedOrder: Record "New Confirmed Order";
        PostedDocNo: Code[20];
    begin


        ApplicationDevelopmentLine.RESET;
        ApplicationDevelopmentLine.SETRANGE("Document No.", ConfirmedOrder."No.");
        IF ApplicationDevelopmentLine.FINDSET THEN BEGIN
            TotalAmt := 0;
            REPEAT
                TotalAmt := TotalAmt + ApplicationDevelopmentLine.Amount;
            UNTIL ApplicationDevelopmentLine.NEXT = 0;
            UnitSetup.GET;
            GenJnlLineDevCharge.RESET;
            GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
            GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
            GenJnlLineDevCharge.DELETEALL;
            PostedDocNo := '';
            PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Cheque Bounce JV No. Series", WORKDATE, TRUE);

            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLineDevCharge."Line No." := 10000;
            GenJnlLineDevCharge.VALIDATE("Posting Date", TODAY); //ALLETDK
            GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Account No.", ConfirmedOrder."Customer No.");
            GenJnlLineDevCharge.VALIDATE(Amount, TotalAmt);
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge."Bond Posting Group" := ConfirmedOrder."Bond Posting Group";
            GenJnlLineDevCharge."Bill-to/Pay-to No." := ConfirmedOrder."Customer No.";
            //BondPostingGroup1.GET(ConfirmedOrder."Bond Posting Group");
            GenJnlLineDevCharge."Posting Group" := ConfirmedOrder."Bond Posting Group";
            GenJnlLineDevCharge."Order Ref No." := ConfirmedOrder."No.";
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Running;
            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Bal. Account Type"::"G/L Account");
            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", UnitSetup."Project Change JV Account");
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := ConfirmedOrder."Shortcut Dimension 1 Code";
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", ConfirmedOrder."Shortcut Dimension 1 Code"); //INS1.0
            GenJnlLineDevCharge."Payment Mode" := GenJnlLineDevCharge."Payment Mode"::JV;
            GenJnlLineDevCharge."Branch Code" := UserSetup."User Branch";
            GenJnlLineDevCharge."Source Code" := UnitSetup."Cr. Source Code";
            GenJnlLineDevCharge."Paid To/Received From Code" := ConfirmedOrder."Received From Code";
            GenJnlLineDevCharge."Paid To/Received From" := GenJnlLineDevCharge."Paid To/Received From"::"Marketing Member";
            GenJnlLineDevCharge."Paid To/Received From Code" := ConfirmedOrder."Received From Code";
            GenJnlLineDevCharge.Description := 'Project Change';
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge.Description);
            CreateNegativeJVEntry(ConfirmedOrder, TotalAmt, PostedDocNo);

            PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
            PostedDocNo := '';
            UnitSetup.GET;
            GenJnlLineDevCharge.RESET;
            GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
            GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
            GenJnlLineDevCharge.DELETEALL;

            N_ConfirmedOrder.GET(ConfirmedOrder."No.");
            PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Cheque Bounce JV No. Series", WORKDATE, TRUE);

            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLineDevCharge."Line No." := 20000;
            GenJnlLineDevCharge.VALIDATE("Posting Date", TODAY); //ALLETDK
            GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::"G/L Account");
            GenJnlLineDevCharge.VALIDATE("Account No.", UnitSetup."Project Change JV Account");
            GenJnlLineDevCharge.VALIDATE(Amount, TotalAmt);
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge."Bond Posting Group" := ConfirmedOrder."Bond Posting Group";
            GenJnlLineDevCharge."Bill-to/Pay-to No." := ConfirmedOrder."Customer No.";
            //BondPostingGroup1.GET(ConfirmedOrder."Bond Posting Group");
            GenJnlLineDevCharge."Posting Group" := ConfirmedOrder."Bond Posting Group";
            GenJnlLineDevCharge."Order Ref No." := ConfirmedOrder."No.";
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Running;
            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Bal. Account Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", ConfirmedOrder."Customer No.");
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := N_ConfirmedOrder."Shortcut Dimension 1 Code";
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", N_ConfirmedOrder."Shortcut Dimension 1 Code"); //INS1.0
            GenJnlLineDevCharge."Payment Mode" := GenJnlLineDevCharge."Payment Mode"::JV;
            GenJnlLineDevCharge."Branch Code" := UserSetup."User Branch";
            GenJnlLineDevCharge."Source Code" := UnitSetup."Cr. Source Code";
            GenJnlLineDevCharge."Paid To/Received From Code" := ConfirmedOrder."Received From Code";
            //IF "Payment Mode" = "Payment Mode"::JV THEN
            GenJnlLineDevCharge."Paid To/Received From" := GenJnlLineDevCharge."Paid To/Received From"::"Marketing Member";
            GenJnlLineDevCharge."Paid To/Received From Code" := ConfirmedOrder."Received From Code";
            GenJnlLineDevCharge.Description := 'Project Change';
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge.Description);
            CreatePostiveJVEntry(ConfirmedOrder, TotalAmt, PostedDocNo, N_ConfirmedOrder."Shortcut Dimension 1 Code");

            PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
        END;
    end;

    local procedure CreateNegativeJVEntry(P_ConfirmedOrder: Record "Confirmed Order"; P_TotalAmount: Decimal; P_PostedDocNo: Code[20])
    var
        AppPayEntry: Record "Application Payment Entry";
        OldAppPaymentEntry: Record "Application Payment Entry";
        LineNo: Integer;
    begin
        CLEAR(AppPayEntry);
        OldAppPaymentEntry.RESET;
        OldAppPaymentEntry.SETRANGE("Document No.", P_ConfirmedOrder."No.");
        IF OldAppPaymentEntry.FINDLAST THEN
            LineNo := OldAppPaymentEntry."Line No.";

        AppPayEntry.RESET;
        AppPayEntry.INIT;
        AppPayEntry."Document Type" := AppPayEntry."Document Type"::BOND;
        AppPayEntry."Document No." := P_ConfirmedOrder."No.";
        AppPayEntry."Line No." := LineNo + 10000;
        AppPayEntry.INSERT;
        AppPayEntry.VALIDATE("Payment Mode", AppPayEntry."Payment Mode"::JV);
        AppPayEntry."Payment Method" := 'D_OUTCASH';
        AppPayEntry.Description := 'Project Change';
        AppPayEntry."Location Code" := P_ConfirmedOrder."Shortcut Dimension 1 Code";
        AppPayEntry.Amount := -1 * P_TotalAmount;
        AppPayEntry."Posting date" := TODAY;
        AppPayEntry."Document Date" := TODAY;
        AppPayEntry."Shortcut Dimension 1 Code" := P_ConfirmedOrder."Shortcut Dimension 1 Code";
        AppPayEntry."Application No." := P_ConfirmedOrder."No.";
        AppPayEntry."User ID" := USERID;
        AppPayEntry.Posted := TRUE;
        AppPayEntry."Posted Document No." := P_PostedDocNo;
        AppPayEntry.MODIFY;
    end;

    local procedure CreatePostiveJVEntry(P_ConfirmedOrder: Record "Confirmed Order"; P_TotalAmount: Decimal; P_PostedDocNo: Code[20]; P_ProjectCode: Code[20])
    var
        AppPayEntry: Record "Application Payment Entry";
        OldAppPaymentEntry: Record "Application Payment Entry";
        LineNo: Integer;
        vConfirmedOrder: Record "Confirmed Order";
    begin
        CLEAR(AppPayEntry);

        OldAppPaymentEntry.RESET;
        OldAppPaymentEntry.SETRANGE("Document No.", P_ConfirmedOrder."No.");
        IF OldAppPaymentEntry.FINDLAST THEN
            LineNo := OldAppPaymentEntry."Line No.";
        AppPayEntry.RESET;
        AppPayEntry.INIT;
        AppPayEntry."Document Type" := AppPayEntry."Document Type"::BOND;
        AppPayEntry."Document No." := P_ConfirmedOrder."No.";
        AppPayEntry."Line No." := LineNo + 10000;
        AppPayEntry.INSERT;
        AppPayEntry.VALIDATE("Payment Mode", AppPayEntry."Payment Mode"::JV);
        AppPayEntry."Payment Method" := 'D_OUTCASH';
        AppPayEntry.Description := 'Project Change';
        AppPayEntry."Location Code" := P_ProjectCode;
        AppPayEntry.Amount := P_TotalAmount;
        AppPayEntry."Posting date" := TODAY;
        AppPayEntry."Document Date" := TODAY;
        AppPayEntry."Shortcut Dimension 1 Code" := P_ProjectCode;
        AppPayEntry."Application No." := P_ConfirmedOrder."No.";
        AppPayEntry."User ID" := USERID;
        AppPayEntry.Posted := TRUE;
        AppPayEntry."Posted Document No." := P_PostedDocNo;
        AppPayEntry.MODIFY;

        vConfirmedOrder.GET(P_ConfirmedOrder."No.");
        vConfirmedOrder."Shortcut Dimension 1 Code" := P_ProjectCode;
        vConfirmedOrder.MODIFY;
    end;


    procedure CustomerSalesInvoice(P_ConfirmedOrder: Record "Confirmed Order"; SalesAmount: Decimal)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
        GLAccount: Record "G/L Account";
        v_SalesLine: Record "Sales Line";
        v_ConfirmedOrder: Record "Confirmed Order";
        BAseAmount: Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        v_SalesHdr: Record "Sales Header";
        L_SalesLines: Record "Sales Line";
        Customer: Record Customer;
    begin
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Varita Sales GL Account No.");
        IF GLAccount.GET(UnitSetup."Varita Sales GL Account No.") THEN
            GLAccount.TESTFIELD("Gen. Prod. Posting Group");
        Customer.GET(P_ConfirmedOrder."Customer No.");
        Customer.TESTFIELD("GST Customer Type");
        Customer.TESTFIELD("State Code");
        v_SalesHdr.RESET;
        v_SalesHdr.SETRANGE("Sell-to Customer No.", P_ConfirmedOrder."Customer No.");
        v_SalesHdr.SETRANGE("External Document No.", P_ConfirmedOrder."No.");
        IF v_SalesHdr.FINDFIRST THEN BEGIN
            SalesHeader := v_SalesHdr;
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Invoice);
            SalesLine.SETRANGE(SalesLine."Document No.", v_SalesHdr."No.");
            IF SalesLine.FINDFIRST THEN BEGIN
                SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
                SalesLine.VALIDATE("No.", UnitSetup."Varita Sales GL Account No.");
                SalesLine.VALIDATE(Quantity, 1);
                SalesLine.VALIDATE("Unit Price", SalesAmount);
                SalesLine.VALIDATE("GST Group Code", UnitSetup."GST Group Code");
                SalesLine.VALIDATE("HSN/SAC Code", UnitSetup."HSN/SAC Code");
                SalesLine.MODIFY;
            END ELSE BEGIN
                SalesLine.INIT;
                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                SalesLine."Document No." := v_SalesHdr."No.";
                SalesLine."Line No." := 10000;
                SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
                SalesLine.VALIDATE("No.", UnitSetup."Varita Sales GL Account No.");
                SalesLine.VALIDATE(Quantity, 1);
                SalesLine.VALIDATE("Unit Price", SalesAmount);
                SalesLine.VALIDATE("GST Group Code", UnitSetup."GST Group Code");
                SalesLine.VALIDATE("HSN/SAC Code", UnitSetup."HSN/SAC Code");
                SalesLine.INSERT;
            END;
        END ELSE BEGIN
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            SalesHeader.INSERT(TRUE);
            SalesHeader.VALIDATE("Sell-to Customer No.", P_ConfirmedOrder."Customer No.");
            SalesHeader.VALIDATE("Shortcut Dimension 1 Code", P_ConfirmedOrder."Shortcut Dimension 1 Code");
            SalesHeader."External Document No." := P_ConfirmedOrder."No.";
            //SalesHeader.VALIDATE(Structure, 'GST');
            SalesHeader.VALIDATE("Location Code", P_ConfirmedOrder."Shortcut Dimension 1 Code");
            SalesHeader."Assigned User ID" := USERID;
            SalesHeader."Applies-to ID" := USERID;
            SalesHeader.MODIFY;
            SalesLine.INIT;
            SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine."Line No." := 10000;
            SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
            SalesLine.VALIDATE("No.", UnitSetup."Varita Sales GL Account No.");
            SalesLine.VALIDATE(Quantity, 1);
            SalesLine.VALIDATE("Unit Price", SalesAmount);
            SalesLine.VALIDATE("GST Group Code", UnitSetup."GST Group Code");
            SalesLine.VALIDATE("HSN/SAC Code", UnitSetup."HSN/SAC Code");
            SalesLine.INSERT;
        END;
        ApplyAmount := SalesAmount;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETCURRENTKEY("Customer No.", "Document Type", Open);
        CustLedgerEntry.SETRANGE("Customer No.", SalesHeader."Sell-to Customer No.");
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment);
        CustLedgerEntry.SETFILTER("Applies-to ID", '<>%1', '');
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry."Applies-to ID" := '';
                CustLedgerEntry.MODIFY;
            UNTIL CustLedgerEntry.NEXT = 0;


        CustLedgerEntry.RESET;
        CustLedgerEntry.SETCURRENTKEY("Customer No.", "Document Type", Open);
        CustLedgerEntry.SETRANGE("Customer No.", SalesHeader."Sell-to Customer No.");
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment);
        CustLedgerEntry.SETRANGE(Open, TRUE);
        CustLedgerEntry.SETFILTER("Remaining Amount", '<>%1', 0);
        CustLedgerEntry.SETRANGE(CustLedgerEntry."BBG App. No. / Order Ref No.", P_ConfirmedOrder."No.");
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry.CALCFIELDS("Remaining Amount");
                IF ApplyAmount > 0 THEN BEGIN
                    IF ApplyAmount > CustLedgerEntry."Remaining Amount" THEN BEGIN
                        CustLedgerEntry."Amount to Apply" := CustLedgerEntry."Remaining Amount";
                        ApplyAmount := ApplyAmount + CustLedgerEntry."Amount to Apply";
                    END ELSE BEGIN
                        CustLedgerEntry."Amount to Apply" := ApplyAmount;
                        ApplyAmount := 0;
                    END;
                END;
                CustLedgerEntry."Applies-to ID" := USERID;
                CustLedgerEntry.MODIFY;
            UNTIL CustLedgerEntry.NEXT = 0;


        // SalesSetup.GET;
        // SalesHeader.CALCFIELDS("Price Inclusive of Taxes");
        // IF SalesSetup."Calc. Inv. Discount" AND (NOT SalesHeader."Price Inclusive of Taxes") THEN BEGIN
        //     SalesHeader.CalcInvDiscForHeader;
        //     COMMIT;
        // END;
        // IF SalesHeader."Price Inclusive of Taxes" THEN BEGIN
        //     v_SalesLine.InitStrOrdDetail(SalesHeader);
        //     v_SalesLine.GetSalesPriceExclusiveTaxes(SalesHeader);
        //     v_SalesLine.UpdateSalesLinesPIT(SalesHeader);
        //     COMMIT;
        // END;

        // IF SalesHeader.Structure <> '' THEN BEGIN
        //     v_SalesLine.CalculateStructures(SalesHeader);
        //     v_SalesLine.AdjustStructureAmounts(SalesHeader);
        //     v_SalesLine.UpdateSalesLines(SalesHeader);
        //     v_SalesLine.CalculateTCS(SalesHeader);
        //     v_SalesLine.UpdateSalesLines(SalesHeader);
        //     COMMIT;
        // END ELSE BEGIN
        //     v_SalesLine.CalculateTCS(SalesHeader);
        //     v_SalesLine.UpdateSalesLines(SalesHeader);
        //     COMMIT;
        // END;
        SalesPost.RUN(SalesHeader);

        v_ConfirmedOrder.GET(P_ConfirmedOrder."No.");
        v_ConfirmedOrder."Sales Invoice booked" := TRUE;
        v_ConfirmedOrder.MODIFY;
    end;


    procedure OpeningPostCustomerDevChargeEntry(D_ApplicationPaymentEntry: Record "Application Payment Entry")
    var
        D_ConfOrder: Record "New Confirmed Order";
        PostedDocNo: Code[20];
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
    begin
        D_ConfOrder.GET(D_ApplicationPaymentEntry."Document No.");
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Pmt Sch. Posting No. Series");
        UnitSetup.TESTFIELD("GST Group Code");
        UnitSetup.TESTFIELD("HSN/SAC Code");
        UnitSetup.TESTFIELD("GST Place of Supply");

        PostedDocNo := '';
        PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", TODAY, TRUE);
        NarrationText1 := 'Appl. Received - ' + COPYSTR(D_ConfOrder."Member Name", 1, 30);

        GenJnlLineDevCharge.RESET;
        GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLineDevCharge.DELETEALL;

        Line := 10000;
        IF (D_ApplicationPaymentEntry.Amount > 0) THEN BEGIN
            IF PaymentMethod.GET(D_ApplicationPaymentEntry."Payment Method") THEN;
            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLineDevCharge."Line No." := Line;
            GenJnlLineDevCharge.VALIDATE("Posting Date", D_ApplicationPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
            GenJnlLineDevCharge.VALIDATE("Document Date", D_ApplicationPaymentEntry."Posting date");
            GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Account No.", D_ConfOrder."Customer No.");
            GenJnlLineDevCharge.VALIDATE(Amount, D_ApplicationPaymentEntry.Amount * -1);
            GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Payment;
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge."Bill-to/Pay-to No." := D_ConfOrder."Customer No.";
            GenJnlLineDevCharge.VALIDATE("Source Type", GenJnlLineDevCharge."Source Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Source No.", D_ConfOrder."Customer No.");
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := D_ConfOrder."Shortcut Dimension 1 Code";
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Advance;
            GenJnlLineDevCharge."Order Ref No." := D_ApplicationPaymentEntry."Document No.";
            GenJnlLineDevCharge."Unit No." := D_ConfOrder."Unit Code";
            GenJnlLineDevCharge.Description := 'Opening';
            GenJnlLineDevCharge."Receipt Line No." := D_ApplicationPaymentEntry."Receipt Line No."; //ALLEDK 10112016
            GenJnlLineDevCharge.VALIDATE("Location Code", D_ApplicationPaymentEntry."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Bal. Account Type"::"G/L Account");
            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", '999999');
            GenJnlLineDevCharge.VALIDATE("GST Group Code", UnitSetup."GST Group Code");
            GenJnlLineDevCharge.VALIDATE("HSN/SAC Code", UnitSetup."HSN/SAC Code");
            GenJnlLineDevCharge.VALIDATE("GST on Advance Payment", TRUE);
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", D_ConfOrder."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
        END;
        PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
        IF vAppPaymentEntry.GET(D_ApplicationPaymentEntry."Document Type", D_ApplicationPaymentEntry."Document No.", D_ApplicationPaymentEntry."Line No.") THEN BEGIN
            vAppPaymentEntry.Posted := TRUE;
            vAppPaymentEntry."Posted Document No." := PostedDocNo;
            vAppPaymentEntry.MODIFY;
        END;
    end;


    procedure OpeningRefundPostCustDevChargeEntry(D_ApplicationPaymentEntry: Record "Application Payment Entry"; ApplyDocNo: Code[20])
    var
        D_ConfOrder: Record "New Confirmed Order";
        PostedDocNo: Code[20];
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
    begin
        D_ConfOrder.GET(D_ApplicationPaymentEntry."Document No.");
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Pmt Sch. Posting No. Series");
        UnitSetup.TESTFIELD("GST Group Code");
        UnitSetup.TESTFIELD("HSN/SAC Code");
        UnitSetup.TESTFIELD("GST Place of Supply");

        PostedDocNo := '';
        PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", TODAY, TRUE);
        NarrationText1 := 'Appl. Received - ' + COPYSTR(D_ConfOrder."Member Name", 1, 30);

        GenJnlLineDevCharge.RESET;
        GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLineDevCharge.DELETEALL;

        Line := 10000;
        IF (D_ApplicationPaymentEntry.Amount < 0) THEN BEGIN
            IF PaymentMethod.GET(D_ApplicationPaymentEntry."Payment Method") THEN;
            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLineDevCharge."Line No." := Line;
            GenJnlLineDevCharge.VALIDATE("Posting Date", D_ApplicationPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
            GenJnlLineDevCharge.VALIDATE("Document Date", D_ApplicationPaymentEntry."Posting date");
            GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Account No.", D_ConfOrder."Customer No.");
            GenJnlLineDevCharge.VALIDATE(Amount, D_ApplicationPaymentEntry.Amount * -1);
            GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Refund;
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge."Bill-to/Pay-to No." := D_ConfOrder."Customer No.";
            GenJnlLineDevCharge.VALIDATE("Source Type", GenJnlLineDevCharge."Source Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Source No.", D_ConfOrder."Customer No.");
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := D_ConfOrder."Shortcut Dimension 1 Code";
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Advance;
            GenJnlLineDevCharge."Order Ref No." := D_ApplicationPaymentEntry."Document No.";
            GenJnlLineDevCharge."Unit No." := D_ConfOrder."Unit Code";
            GenJnlLineDevCharge.Description := 'Opening';
            GenJnlLineDevCharge."Receipt Line No." := D_ApplicationPaymentEntry."Receipt Line No."; //ALLEDK 10112016
            GenJnlLineDevCharge.VALIDATE("Location Code", D_ApplicationPaymentEntry."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Bal. Account Type"::"G/L Account");
            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", '999999');
            GenJnlLineDevCharge.VALIDATE("GST Reason Type", GenJnlLineDevCharge."GST Reason Type"::Others);
            //    GenJnlLineDevCharge.VALIDATE("GST Group Code",UnitSetup."GST Group Code");
            //  GenJnlLineDevCharge.VALIDATE("HSN/SAC Code",UnitSetup."HSN/SAC Code");
            //GenJnlLineDevCharge.VALIDATE("GST on Advance Payment",TRUE);
            IF ApplyDocNo <> '' THEN BEGIN
                GenJnlLineDevCharge.VALIDATE("Applies-to Doc. Type", GenJnlLineDevCharge."Applies-to Doc. Type"::Payment);
                GenJnlLineDevCharge."Applies-to Doc. No." := ApplyDocNo;
                GenJnlLineDevCharge.UpdateOpenonLookup;
                GenJnlLineDevCharge.VALIDATE("Applies-to Doc. No.", ApplyDocNo);
            END;
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", D_ConfOrder."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
        END;
        PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
        IF vAppPaymentEntry.GET(D_ApplicationPaymentEntry."Document Type", D_ApplicationPaymentEntry."Document No.", D_ApplicationPaymentEntry."Line No.") THEN BEGIN
            vAppPaymentEntry.Posted := TRUE;
            vAppPaymentEntry."Posted Document No." := PostedDocNo;
            vAppPaymentEntry.MODIFY;
        END;
    end;


    procedure CreateDevlopmentCustomerMJVEntry(P_ApplicationDevelopmentLine1: Record "New Application DevelopmntLine"; ApplyDocNo: Code[20])
    var
        D_ConfOrder: Record "New Confirmed Order";
        PostedDocNo: Code[20];
        AppPayDevlpEntry: Record "Application Pmt Devlop. Entry";
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
        ApplicationDevelopmntLine: Record "New Application DevelopmntLine";
        NewConforder: Record "New Confirmed Order";
        LineNo: Integer;
        Amt: Decimal;
        AppPaymentEntryNew: Record "New Application DevelopmntLine";
    begin

        NewConforder.RESET;
        NewConforder.GET(P_ApplicationDevelopmentLine1."Document No.");

        CLEAR(AppPayDevlpEntry);
        LineNo := 0;
        AppPayDevlpEntry.RESET;
        AppPayDevlpEntry.SETRANGE("Document No.", P_ApplicationDevelopmentLine1."Document No.");
        IF AppPayDevlpEntry.FINDLAST THEN
            LineNo := AppPayDevlpEntry."Line No.";
        AppPayDevlpEntry.INIT;
        AppPayDevlpEntry."Document Type" := AppPayDevlpEntry."Document Type"::BOND;
        AppPayDevlpEntry."Document No." := P_ApplicationDevelopmentLine1."Document No.";
        AppPayDevlpEntry."Line No." := LineNo + 10000;
        AppPayDevlpEntry.Type := AppPayDevlpEntry.Type::Received;
        AppPayDevlpEntry.INSERT;
        AppPayDevlpEntry.VALIDATE("Payment Mode", AppPayDevlpEntry."Payment Mode"::MJVM);
        AppPayDevlpEntry."Payment Method" := P_ApplicationDevelopmentLine1."Payment Method";
        AppPayDevlpEntry.Description := P_ApplicationDevelopmentLine1.Description;
        AppPayDevlpEntry."Location Code" := NewConforder."Shortcut Dimension 1 Code";
        AppPayDevlpEntry."User Branch Code" := P_ApplicationDevelopmentLine1."User Branch Code";
        AppPayDevlpEntry.VALIDATE(Amount, P_ApplicationDevelopmentLine1.Amount);
        AppPayDevlpEntry.VALIDATE("Posting date", P_ApplicationDevelopmentLine1."Posting date");
        AppPayDevlpEntry.VALIDATE("Document Date", P_ApplicationDevelopmentLine1."Posting date");
        AppPayDevlpEntry.VALIDATE("Shortcut Dimension 1 Code", NewConforder."Shortcut Dimension 1 Code");
        AppPayDevlpEntry."MSC Post Doc. No." := P_ApplicationDevelopmentLine1."Posted Document No.";
        AppPayDevlpEntry."Application No." := P_ApplicationDevelopmentLine1."Document No.";
        AppPayDevlpEntry."Bank Type" := P_ApplicationDevelopmentLine1."Bank Type";
        AppPayDevlpEntry."User ID" := P_ApplicationDevelopmentLine1."User ID";
        AppPayDevlpEntry."Entry From MSC" := TRUE;
        AppPayDevlpEntry.Narration := P_ApplicationDevelopmentLine1.Narration;
        AppPayDevlpEntry."Receipt Line No." := P_ApplicationDevelopmentLine1."Line No."; //ALLEDK 10112016
        AppPayDevlpEntry.MODIFY;

        D_ConfOrder.GET(AppPayDevlpEntry."Document No.");
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Pmt Sch. Posting No. Series");
        UnitSetup.TESTFIELD("GST Group Code");
        UnitSetup.TESTFIELD("HSN/SAC Code");
        UnitSetup.TESTFIELD("GST Place of Supply");
        UnitSetup.TESTFIELD("Transfer Control Account");

        PostedDocNo := '';
        PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
        NarrationText1 := 'Appl. Received - ' + COPYSTR(D_ConfOrder."Member Name", 1, 30);

        GenJnlLineDevCharge.RESET;
        GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLineDevCharge.DELETEALL;

        Line := 10000;
        IF ((P_ApplicationDevelopmentLine1.Amount < 0) AND (P_ApplicationDevelopmentLine1."Payment Mode" IN [P_ApplicationDevelopmentLine1."Payment Mode"::MJVM])) THEN BEGIN
            IF PaymentMethod.GET(P_ApplicationDevelopmentLine1."Payment Method") THEN;
            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLineDevCharge."Line No." := Line;
            GenJnlLineDevCharge.VALIDATE("Posting Date", AppPayDevlpEntry."Posting date"); //BBG1.00 ALLEDK 120313
            GenJnlLineDevCharge.VALIDATE("Document Date", AppPayDevlpEntry."Posting date");
            GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Account No.", D_ConfOrder."Customer No.");
            GenJnlLineDevCharge.VALIDATE(Amount, P_ApplicationDevelopmentLine1.Amount * -1);
            GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Refund;
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge."Bill-to/Pay-to No." := D_ConfOrder."Customer No.";
            GenJnlLineDevCharge.VALIDATE("Source Type", GenJnlLineDevCharge."Source Type"::Customer);
            GenJnlLineDevCharge.VALIDATE("Source No.", D_ConfOrder."Customer No.");
            BondPostingGroup1.GET(D_ConfOrder."Bond Posting Group");
            GenJnlLineDevCharge."Posting Group" := D_ConfOrder."Bond Posting Group";
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := AppPayDevlpEntry."Shortcut Dimension 1 Code";
            //GenJnlLineDevCharge."Source Code" := 'BANKPYMTV';
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Running;
            GenJnlLineDevCharge."Order Ref No." := AppPayDevlpEntry."Document No.";
            GenJnlLineDevCharge."Unit No." := D_ConfOrder."Unit Code";
            GenJnlLineDevCharge."Cheque No." := P_ApplicationDevelopmentLine1."Cheque No./ Transaction No.";
            GenJnlLineDevCharge."Cheque Date" := P_ApplicationDevelopmentLine1."Cheque Date";
            GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
            GenJnlLineDevCharge.Description := 'Refund to Customer';
            GenJnlLineDevCharge.VALIDATE("Location Code", AppPayDevlpEntry."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge."Payment Mode" := P_ApplicationDevelopmentLine1."Payment Mode"; //ALLEDK 030313
            GenJnlLineDevCharge."Development Application No." := AppPayDevlpEntry."Document No.";
            GenJnlLineDevCharge."Development Appl. Rcpt LineNo." := AppPayDevlpEntry."Receipt Line No.";
            GenJnlLineDevCharge."Paid To/Received From" := GenJnlLineDevCharge."Paid To/Received From"::"Marketing Member";
            GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
            GenJnlLineDevCharge."Receipt Line No." := AppPayDevlpEntry."Receipt Line No."; //ALLEDK 10112016
            GenJnlLineDevCharge."GST Reason Type" := GenJnlLineDevCharge."GST Reason Type"::Others;
            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Bal. Account Type"::"G/L Account");
            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", UnitSetup."Transfer Control Account");
            GenJnlLineDevCharge.VALIDATE("Applies-to Doc. Type", GenJnlLineDevCharge."Applies-to Doc. Type"::Payment);
            GenJnlLineDevCharge."Applies-to Doc. No." := ApplyDocNo;
            GenJnlLineDevCharge.UpdateOpenonLookup;
            GenJnlLineDevCharge.VALIDATE("Applies-to Doc. No.", ApplyDocNo);
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", AppPayDevlpEntry."Shortcut Dimension 1 Code");
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
        END;
        PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
        IF vAppPaymentEntry.GET(AppPayDevlpEntry."Document Type", AppPayDevlpEntry."Document No.", AppPayDevlpEntry."Line No.") THEN BEGIN
            vAppPaymentEntry.Posted := TRUE;
            vAppPaymentEntry."Posted Document No." := PostedDocNo;
            vAppPaymentEntry."Cheque Status" := vAppPaymentEntry."Cheque Status"::Cleared;
            vAppPaymentEntry."Chq. Cl / Bounce Dt." := TODAY;
            vAppPaymentEntry.MODIFY;
        END;


        IF (ABS(P_ApplicationDevelopmentLine1.Amount) - P_ApplicationDevelopmentLine1."MJV Transfer Amount") > 0 THEN BEGIN
            Amt := 0;
            Amt := ABS(P_ApplicationDevelopmentLine1.Amount) - P_ApplicationDevelopmentLine1."MJV Transfer Amount";
            CLEAR(AppPayDevlpEntry);
            LineNo := 0;
            AppPayDevlpEntry.RESET;
            AppPayDevlpEntry.SETRANGE("Document No.", P_ApplicationDevelopmentLine1."Document No.");
            IF AppPayDevlpEntry.FINDLAST THEN
                LineNo := AppPayDevlpEntry."Line No.";
            AppPayDevlpEntry.INIT;
            AppPayDevlpEntry."Document Type" := AppPayDevlpEntry."Document Type"::BOND;
            AppPayDevlpEntry."Document No." := P_ApplicationDevelopmentLine1."Document No.";
            AppPayDevlpEntry."Line No." := LineNo + 10000;
            AppPayDevlpEntry.Type := AppPayDevlpEntry.Type::Received;
            AppPayDevlpEntry.INSERT;
            AppPayDevlpEntry.VALIDATE("Payment Mode", AppPayDevlpEntry."Payment Mode"::MJVM);
            AppPayDevlpEntry."Payment Method" := P_ApplicationDevelopmentLine1."Payment Method";
            AppPayDevlpEntry.Description := P_ApplicationDevelopmentLine1.Description;
            AppPayDevlpEntry."Location Code" := NewConforder."Shortcut Dimension 1 Code";
            AppPayDevlpEntry."User Branch Code" := P_ApplicationDevelopmentLine1."User Branch Code";
            AppPayDevlpEntry.VALIDATE(Amount, Amt);
            AppPayDevlpEntry.VALIDATE("Posting date", P_ApplicationDevelopmentLine1."Posting date");
            AppPayDevlpEntry.VALIDATE("Document Date", P_ApplicationDevelopmentLine1."Posting date");
            AppPayDevlpEntry.VALIDATE("Shortcut Dimension 1 Code", NewConforder."Shortcut Dimension 1 Code");
            AppPayDevlpEntry."MSC Post Doc. No." := P_ApplicationDevelopmentLine1."Posted Document No.";
            AppPayDevlpEntry."Application No." := P_ApplicationDevelopmentLine1."Document No.";
            AppPayDevlpEntry."Bank Type" := P_ApplicationDevelopmentLine1."Bank Type";
            AppPayDevlpEntry."User ID" := P_ApplicationDevelopmentLine1."User ID";
            AppPayDevlpEntry."Entry From MSC" := TRUE;
            AppPayDevlpEntry.Narration := P_ApplicationDevelopmentLine1.Narration;
            AppPayDevlpEntry."Receipt Line No." := P_ApplicationDevelopmentLine1."Line No."; //ALLEDK 10112016
            AppPayDevlpEntry.MODIFY;

            PostedDocNo := '';
            PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
            NarrationText1 := 'Appl. Received - ' + COPYSTR(D_ConfOrder."Member Name", 1, 30);

            GenJnlLineDevCharge.RESET;
            GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
            GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
            GenJnlLineDevCharge.DELETEALL;

            Line := 10000;

            IF (Amt > 0) THEN BEGIN
                D_ConfOrder.GET(AppPayDevlpEntry."Document No.");
                IF PaymentMethod.GET(AppPayDevlpEntry."Payment Method") THEN;
                GenJnlLineDevCharge.INIT;
                GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                GenJnlLineDevCharge."Line No." := Line;
                GenJnlLineDevCharge.VALIDATE("Posting Date", AppPayDevlpEntry."Posting date"); //BBG1.00 ALLEDK 120313
                GenJnlLineDevCharge.VALIDATE("Document Date", AppPayDevlpEntry."Posting date");
                GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::Customer);
                GenJnlLineDevCharge.VALIDATE("Account No.", D_ConfOrder."Customer No.");
                GenJnlLineDevCharge.VALIDATE(Amount, -1 * Amt);
                GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Payment;
                GenJnlLineDevCharge."Document No." := PostedDocNo;
                GenJnlLineDevCharge."Bill-to/Pay-to No." := D_ConfOrder."Customer No.";
                GenJnlLineDevCharge.VALIDATE("Source Type", GenJnlLineDevCharge."Source Type"::Customer);
                GenJnlLineDevCharge.VALIDATE("Source No.", D_ConfOrder."Customer No.");
                BondPostingGroup1.GET(D_ConfOrder."Bond Posting Group");
                GenJnlLineDevCharge."Posting Group" := D_ConfOrder."Bond Posting Group";
                GenJnlLineDevCharge."Shortcut Dimension 1 Code" := AppPayDevlpEntry."Shortcut Dimension 1 Code";
                //GenJnlLineDevCharge."Source Code" := 'BANKPYMTV';
                GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Running;
                GenJnlLineDevCharge."Order Ref No." := AppPayDevlpEntry."Document No.";
                GenJnlLineDevCharge."Unit No." := D_ConfOrder."Unit Code";
                GenJnlLineDevCharge."Cheque No." := AppPayDevlpEntry."Cheque No./ Transaction No.";
                GenJnlLineDevCharge."Cheque Date" := AppPayDevlpEntry."Cheque Date";
                GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
                GenJnlLineDevCharge.Description := 'Refund to Customer';
                GenJnlLineDevCharge.VALIDATE("Location Code", AppPayDevlpEntry."Shortcut Dimension 1 Code");
                GenJnlLineDevCharge."Payment Mode" := AppPayDevlpEntry."Payment Mode"; //ALLEDK 030313
                GenJnlLineDevCharge."Development Application No." := AppPayDevlpEntry."Document No.";
                GenJnlLineDevCharge."Development Appl. Rcpt LineNo." := AppPayDevlpEntry."Receipt Line No.";
                GenJnlLineDevCharge."Paid To/Received From" := GenJnlLineDevCharge."Paid To/Received From"::"Marketing Member";
                GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
                GenJnlLineDevCharge."Receipt Line No." := AppPayDevlpEntry."Receipt Line No."; //ALLEDK 10112016
                GenJnlLineDevCharge."GST Reason Type" := GenJnlLineDevCharge."GST Reason Type"::Others;
                GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Bal. Account Type"::"G/L Account");
                GenJnlLineDevCharge.VALIDATE("Bal. Account No.", UnitSetup."Transfer Control Account");
                GenJnlLineDevCharge.VALIDATE("GST Group Code", UnitSetup."GST Group Code");
                GenJnlLineDevCharge.VALIDATE("HSN/SAC Code", UnitSetup."HSN/SAC Code");
                //GenJnlLineDevCharge.VALIDATE("GST Place of Supply",UnitSetup."GST Place of Supply");
                GenJnlLineDevCharge.VALIDATE("GST on Advance Payment", TRUE);
                GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", AppPayDevlpEntry."Shortcut Dimension 1 Code");
                GenJnlLineDevCharge.INSERT;
                InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
                  GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
            END;
            PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
            IF vAppPaymentEntry.GET(AppPayDevlpEntry."Document Type", AppPayDevlpEntry."Document No.", AppPayDevlpEntry."Line No.") THEN BEGIN
                vAppPaymentEntry.Posted := TRUE;
                vAppPaymentEntry."Posted Document No." := PostedDocNo;
                vAppPaymentEntry."Cheque Status" := vAppPaymentEntry."Cheque Status"::Cleared;
                vAppPaymentEntry."Chq. Cl / Bounce Dt." := TODAY;
                vAppPaymentEntry.MODIFY;
                CreateNewAppDevelopmentLines(vAppPaymentEntry);
            END;
        END;

        IF P_ApplicationDevelopmentLine1."MJV Transfer Amount" > 0 THEN BEGIN
            CLEAR(NewConforder);
            NewConforder.GET(P_ApplicationDevelopmentLine1."Order Ref No.");
            CLEAR(AppPayDevlpEntry);
            LineNo := 0;
            AppPayDevlpEntry.RESET;
            AppPayDevlpEntry.SETRANGE("Document No.", P_ApplicationDevelopmentLine1."Order Ref No.");
            IF AppPayDevlpEntry.FINDLAST THEN
                LineNo := AppPayDevlpEntry."Line No.";
            AppPayDevlpEntry.INIT;
            AppPayDevlpEntry."Document Type" := AppPayDevlpEntry."Document Type"::BOND;
            AppPayDevlpEntry."Document No." := P_ApplicationDevelopmentLine1."Order Ref No.";
            AppPayDevlpEntry."Line No." := LineNo + 10000;
            AppPayDevlpEntry.Type := AppPayDevlpEntry.Type::Received;
            AppPayDevlpEntry.INSERT;
            AppPayDevlpEntry.VALIDATE("Payment Mode", AppPayDevlpEntry."Payment Mode"::MJVM);
            AppPayDevlpEntry."Payment Method" := P_ApplicationDevelopmentLine1."Payment Method";
            AppPayDevlpEntry.Description := P_ApplicationDevelopmentLine1.Description;
            AppPayDevlpEntry."Location Code" := NewConforder."Shortcut Dimension 1 Code";
            AppPayDevlpEntry."User Branch Code" := P_ApplicationDevelopmentLine1."User Branch Code";
            AppPayDevlpEntry.VALIDATE(Amount, P_ApplicationDevelopmentLine1."MJV Transfer Amount");
            AppPayDevlpEntry.VALIDATE("Posting date", P_ApplicationDevelopmentLine1."Posting date");
            AppPayDevlpEntry.VALIDATE("Document Date", P_ApplicationDevelopmentLine1."Posting date");
            AppPayDevlpEntry.VALIDATE("Shortcut Dimension 1 Code", NewConforder."Shortcut Dimension 1 Code");
            AppPayDevlpEntry."MSC Post Doc. No." := P_ApplicationDevelopmentLine1."Posted Document No.";
            AppPayDevlpEntry."Application No." := P_ApplicationDevelopmentLine1."Document No.";
            AppPayDevlpEntry."Bank Type" := P_ApplicationDevelopmentLine1."Bank Type";
            AppPayDevlpEntry."User ID" := P_ApplicationDevelopmentLine1."User ID";
            AppPayDevlpEntry."Entry From MSC" := TRUE;
            AppPayDevlpEntry.Narration := P_ApplicationDevelopmentLine1.Narration;
            AppPayDevlpEntry."Receipt Line No." := P_ApplicationDevelopmentLine1."Line No."; //ALLEDK 10112016
            AppPayDevlpEntry.MODIFY;


            PostedDocNo := '';
            PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
            NarrationText1 := 'Appl. Received - ' + COPYSTR(D_ConfOrder."Member Name", 1, 30);

            GenJnlLineDevCharge.RESET;
            GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
            GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
            GenJnlLineDevCharge.DELETEALL;

            Line := 10000;

            IF (P_ApplicationDevelopmentLine1."MJV Transfer Amount" > 0) THEN BEGIN
                D_ConfOrder.GET(AppPayDevlpEntry."Document No.");
                IF PaymentMethod.GET(AppPayDevlpEntry."Payment Method") THEN;
                GenJnlLineDevCharge.INIT;
                GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                GenJnlLineDevCharge."Line No." := Line;
                GenJnlLineDevCharge.VALIDATE("Posting Date", AppPayDevlpEntry."Posting date"); //BBG1.00 ALLEDK 120313
                GenJnlLineDevCharge.VALIDATE("Document Date", AppPayDevlpEntry."Posting date");
                GenJnlLineDevCharge.VALIDATE("Account Type", GenJnlLineDevCharge."Account Type"::Customer);
                GenJnlLineDevCharge.VALIDATE("Account No.", D_ConfOrder."Customer No.");
                GenJnlLineDevCharge.VALIDATE(Amount, -1 * P_ApplicationDevelopmentLine1."MJV Transfer Amount");
                GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Payment;
                GenJnlLineDevCharge."Document No." := PostedDocNo;
                GenJnlLineDevCharge."Bill-to/Pay-to No." := D_ConfOrder."Customer No.";
                GenJnlLineDevCharge.VALIDATE("Source Type", GenJnlLineDevCharge."Source Type"::Customer);
                GenJnlLineDevCharge.VALIDATE("Source No.", D_ConfOrder."Customer No.");
                BondPostingGroup1.GET(D_ConfOrder."Bond Posting Group");
                GenJnlLineDevCharge."Posting Group" := D_ConfOrder."Bond Posting Group";
                GenJnlLineDevCharge."Shortcut Dimension 1 Code" := AppPayDevlpEntry."Shortcut Dimension 1 Code";
                //GenJnlLineDevCharge."Source Code" := 'BANKPYMTV';
                GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Running;
                GenJnlLineDevCharge."Order Ref No." := AppPayDevlpEntry."Document No.";
                GenJnlLineDevCharge."Unit No." := D_ConfOrder."Unit Code";
                GenJnlLineDevCharge."Cheque No." := AppPayDevlpEntry."Cheque No./ Transaction No.";
                GenJnlLineDevCharge."Cheque Date" := AppPayDevlpEntry."Cheque Date";
                GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
                GenJnlLineDevCharge.Description := 'Refund to Customer';
                GenJnlLineDevCharge.VALIDATE("Location Code", AppPayDevlpEntry."Shortcut Dimension 1 Code");
                GenJnlLineDevCharge."Payment Mode" := AppPayDevlpEntry."Payment Mode"; //ALLEDK 030313
                GenJnlLineDevCharge."Development Application No." := AppPayDevlpEntry."Document No.";
                GenJnlLineDevCharge."Development Appl. Rcpt LineNo." := AppPayDevlpEntry."Receipt Line No.";
                GenJnlLineDevCharge."Paid To/Received From" := GenJnlLineDevCharge."Paid To/Received From"::"Marketing Member";
                GenJnlLineDevCharge."Paid To/Received From Code" := D_ConfOrder."Received From Code";
                GenJnlLineDevCharge."Receipt Line No." := AppPayDevlpEntry."Receipt Line No."; //ALLEDK 10112016
                GenJnlLineDevCharge."GST Reason Type" := GenJnlLineDevCharge."GST Reason Type"::Others;
                GenJnlLineDevCharge.VALIDATE("Bal. Account Type", GenJnlLineDevCharge."Bal. Account Type"::"G/L Account");
                GenJnlLineDevCharge.VALIDATE("Bal. Account No.", UnitSetup."Transfer Control Account");
                GenJnlLineDevCharge.VALIDATE("GST Group Code", UnitSetup."GST Group Code");
                GenJnlLineDevCharge.VALIDATE("HSN/SAC Code", UnitSetup."HSN/SAC Code");
                GenJnlLineDevCharge.VALIDATE("GST on Advance Payment", TRUE);
                GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", AppPayDevlpEntry."Shortcut Dimension 1 Code");
                GenJnlLineDevCharge.INSERT;
                InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
                  GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
            END;
            PostGenJnlLinesDevCharge(GenJnlLineDevCharge);
            IF vAppPaymentEntry.GET(AppPayDevlpEntry."Document Type", AppPayDevlpEntry."Document No.", AppPayDevlpEntry."Line No.") THEN BEGIN
                vAppPaymentEntry.Posted := TRUE;
                vAppPaymentEntry."Posted Document No." := PostedDocNo;
                vAppPaymentEntry."Cheque Status" := vAppPaymentEntry."Cheque Status"::Cleared;
                vAppPaymentEntry."Chq. Cl / Bounce Dt." := TODAY;
                vAppPaymentEntry.MODIFY;
                CreateNewAppDevelopmentLines(vAppPaymentEntry);
            END;
        END;

        AppPaymentEntryNew.RESET;
        IF AppPaymentEntryNew.GET(P_ApplicationDevelopmentLine1."Document Type", P_ApplicationDevelopmentLine1."Document No.", P_ApplicationDevelopmentLine1."Line No.") THEN BEGIN
            AppPaymentEntryNew.Posted := TRUE;
            AppPaymentEntryNew."Receipt Post in Devlp. Comp." := TRUE;
            AppPaymentEntryNew."Create from MSC Company" := FALSE;
            AppPaymentEntryNew."Cheque Status" := AppPaymentEntryNew."Cheque Status"::Cleared;
            AppPaymentEntryNew."Chq. Cl / Bounce Dt." := TODAY;
            AppPaymentEntryNew.MODIFY;
        END;
    end;

    local procedure CreateNewAppDevelopmentLines(P_ApplicationPmtDevEntry: Record "Application Pmt Devlop. Entry")
    var
        NewApplicationDevelopmntLine: Record "New Application DevelopmntLine";
        LineNo: Integer;
    begin
        LineNo := 0;
        NewApplicationDevelopmntLine.RESET;
        NewApplicationDevelopmntLine.SETRANGE("Document No.", P_ApplicationPmtDevEntry."Document No.");
        IF NewApplicationDevelopmntLine.FINDLAST THEN
            LineNo := NewApplicationDevelopmntLine."Line No.";

        NewApplicationDevelopmntLine.RESET;
        NewApplicationDevelopmntLine.INIT;
        NewApplicationDevelopmntLine."Document Type" := NewApplicationDevelopmntLine."Document Type"::BOND;
        NewApplicationDevelopmntLine."Document No." := P_ApplicationPmtDevEntry."Document No.";
        NewApplicationDevelopmntLine."Line No." := LineNo + 10000;
        NewApplicationDevelopmntLine."Payment Mode" := P_ApplicationPmtDevEntry."Payment Mode";
        NewApplicationDevelopmntLine."Payment Method" := P_ApplicationPmtDevEntry."Payment Method";
        NewApplicationDevelopmntLine.Amount := P_ApplicationPmtDevEntry.Amount;
        NewApplicationDevelopmntLine."Posting date" := P_ApplicationPmtDevEntry."Posting date";
        NewApplicationDevelopmntLine."Document Date" := P_ApplicationPmtDevEntry."Document Date";
        NewApplicationDevelopmntLine."Shortcut Dimension 1 Code" := P_ApplicationPmtDevEntry."Shortcut Dimension 1 Code";
        NewApplicationDevelopmntLine.Posted := TRUE;
        NewApplicationDevelopmntLine."Create from MSC Company" := FALSE;
        NewApplicationDevelopmntLine."Receipt Post in Devlp. Comp." := TRUE;
        NewApplicationDevelopmntLine."Development Company Name" := COMPANYNAME;
        NewApplicationDevelopmntLine."Cheque Status" := NewApplicationDevelopmntLine."Cheque Status"::Cleared;
        NewApplicationDevelopmntLine."Chq. Cl / Bounce Dt." := TODAY;
        NewApplicationDevelopmntLine.INSERT;
    end;
}

