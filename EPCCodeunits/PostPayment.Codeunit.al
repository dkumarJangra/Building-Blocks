codeunit 97725 PostPayment
{
    TableNo = Application;

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Application Released.';
        GenJnlLine: Record "Gen. Journal Line" temporary;
        //GenJnlLine: Record "Gen. Journal Line";

        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        BondSetup: Record "Unit Setup";
        UserSetup: Record "User Setup";
        UnitOfficeCode: Code[20];
        CounterCode: Code[20];
        DiscAmount: Decimal;
        PeriodicInterestAmt: Decimal;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        MonthlyInstallment: Decimal;
        Text002: Label 'Order No %1, Installment No. %2 has already been posted.';
        Text003: Label 'Amount due must be zero.';
        BondMgmt: Codeunit "Unit Post";
        Text004: Label 'Clearance Date %1, cannot be less than Cheque Date %2, for Cheque No. %3.';
        Text005: Label 'Posting to Cash/Cheque A/C   #2######\';
        Text006: Label 'Posting to Order A/C          #3######\';
        Text007: Label 'Creating Buffers             #4######\';
        Text008: Label 'Moving Payment Lines         #5######';
        Text009: Label 'Order No %1, Installment No. %2 has already been posted.';
        Text010: Label 'Entry No. %1 is already Posted.';
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        Cust: Record Customer;
        Vend: Record Vendor;
        GetDescription: Codeunit GetDescription;
        RecievedAmt: Decimal;
        TotalAmount: Decimal;
        BondPost: Codeunit "Unit Post";
        Text011: Label 'Status Must not be %1';
        Text012: Label 'Payment is Pending against Order No. %1';
        Text013: Label 'Cheque No %1  is Pending against Order No. %2';
        ChequeAmount: Decimal;
        ClChequeNo: Code[10];
        UMaster: Record "Unit Master";
        RecPostPayment: Codeunit PostPayment;
        BondInvestmentAmt: Decimal;
        UnitReversal: Codeunit "Unit Reversal";
        JnlPostingDocNo: Code[20];
        ByCheque: Boolean;
        PostPayment1: Codeunit PostPayment;
        UnitSetup: Record "Unit Setup";
        PaymentTermLines: Record "Payment Terms Line Sale";
        BondpaymentEntry: Record "Unit Payment Entry";
        LastUnitpayEntry: Record "Unit Payment Entry";
        LastLineNo: Integer;
        GenJnlBatch: Record "Gen. Journal Batch";
        AJVM1: Boolean;
        GenJnlLine1: Record "Gen. Journal Line";
        RoundOff: Decimal;
        PDocNo: Code[20];
        LineNo: Integer;
        GLSetup: Record "General Ledger Setup";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        Dim2Code: Code[20];
        JVPostedDocNo: Code[20];
        ConfOrder: Record "Confirmed Order";
        AppPaymentEntry: Record "Application Payment Entry";
        InsertAppLines: Record "Application Payment Entry";
        NewLineNo: Integer;
        Amt: Decimal;
        UnitLastLineNo: Integer;
        CompInfo: Record "Company Information";
        PostDate: Date;
        ComHoldDate: Date;
        UnitMaster: Record "Unit Master";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CompanyGLAccount: Record "Company wise G/L Account";
        NewInsertAppLines: Record "NewApplication Payment Entry";
        WithoutTDSAmt: Decimal;
        TDSDeductAmt: Decimal;
        BBPEntryExists: Boolean;
        INVAmt: Decimal;
        InvClubAmt: Decimal;
        InvTDS: Decimal;
        TDSEnt: Record "TDS Entry";  //13729;
        "------SMS---------": Integer;
        HttpWebRequest: HttpRequestMessage;// DotNet HttpWebRequest;
        HttpWebResponse: HttpResponseMessage;// DotNet HttpWebResponse;
        TextString: Text;// DotNet String;
        Bytes: Text; //DotNet Array;
        Encoding: TextEncoding;

        // StreamReader: DotNet StreamReader;
        ResText: Text;
        StringBuilder: Text;// DotNet StringBuilder;
                            // StringWriter: DotNet StringWriter;
        JSON: text;//  DotNet String;
        JSONTextWriter: JsonObject;// DotNet JsonTextWriter;
                                   // StreamWriter: DotNet StreamWriter;
        CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";
        ExitMessage: Boolean;
        WebAppService: Codeunit "Web App Service";


    procedure PostPayment(var Rec: Record Application; Description: Text[50]; FromJobBatch: Boolean)
    begin
        GenJnlLine.DELETEALL;
        IF UserSetup.GET(USERID) THEN BEGIN
            UnitOfficeCode := UserSetup."Shortcut Dimension 2 Code";
            CounterCode := UserSetup."Shortcut Dimension 2 Code";
        END;
        ValidateSetup(Rec);
        IF FromJobBatch THEN
            InterComCreateApplGenJnlLines(Rec, Description)   //061214
        ELSE
            CreateApplicationGenJnlLines(Rec, Description); //051214

        ReleaseBondApplication.InsertBondHistory(Rec."Unit No.", 'Application Released.', 0, Rec."Application No.");
    end;


    procedure ValidateSetup(var Application: Record Application)
    var
        PaymentPerMonth: Decimal;
    begin
        DiscAmount := 0;
        BondSetup.GET;
        BondSetup.TESTFIELD("Commission A/C");
        BondSetup.TESTFIELD("Bonus A/c");
        BondSetup.TESTFIELD("Interest A/C");
        BondSetup.TESTFIELD(BondSetup."Service Charge Amount");
        BondSetup.TESTFIELD("Discount Allowed on Bond A/C");
        BondSetup.TESTFIELD("Cr. Source Code");
        BondSetup.TESTFIELD("Dr. Source Code");
    end;


    procedure CreateGenJnlLines(Application: Record Application; Description: Text[50])
    var
        BondPaymentEntry: Record "Unit Payment Entry";
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
    begin
        IF Vend.GET(Application."Associate Code") THEN;
        NarrationText1 := 'Appl. Received - ' + COPYSTR(Application."Customer Name", 1, 30);
        NarrationText2 := 'MM Code(' + Application."Associate Code" + ') ' + COPYSTR(Vend.Name, 1, 30);

        GenJnlLine.DELETEALL;
        Line := 10000;
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::Application);
        BondPaymentEntry.SETRANGE("Document No.", Application."Application No.");
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::MJVM)) THEN BEGIN
                    CashPmtMethod.GET(BondPaymentEntry."Payment Method");
                    CashAmount += BondPaymentEntry.Amount;

                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
                    GenJnlLine.VALIDATE("Document Date", Application."Document Date");
                    CASE CashPmtMethod."Bal. Account Type" OF
                        CashPmtMethod."Bal. Account Type"::"G/L Account":
                            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        CashPmtMethod."Bal. Account Type"::"Bank Account":
                            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    END;
                    GenJnlLine.VALIDATE("Account No.", CashPmtMethod."Bal. Account No.");
                    GenJnlLine.VALIDATE(Amount, -BondPaymentEntry.Amount);
                    GenJnlLine."Document No." := Application."Posted Doc No.";
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                    GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
                    GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::Customer);
                    BondPostingGroup1.GET(Application."Bond Posting Group");
                    GenJnlLine.VALIDATE("Bal. Account No.", Application."Customer No.");
                    GenJnlLine."Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Order Ref No." := BondPaymentEntry."Order Ref No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Introducer Code" := Application."Associate Code";
                    GenJnlLine."Unit No." := Application."Unit No.";
                    GenJnlLine."Installment No." := 1;
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    IF (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash) THEN
                        GenJnlLine.Description := 'Cash Received'
                    ELSE
                        GenJnlLine.Description := 'Amount transferred';

                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine.INSERT;
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                    Line := Line + 10000;

                END;
            UNTIL BondPaymentEntry.NEXT = 0;
        //ALLETDK021112--BEGIN
        IF ApplBankAmount <> 0 THEN BEGIN
            PaymentMethod.GET(BondPaymentEntry."Payment Method");
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := Line;
            GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Application."Document Date");
            IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"G/L Account" THEN
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account")
            ELSE
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
            GenJnlLine.VALIDATE("Account No.", PaymentMethod."Bal. Account No.");
            GenJnlLine.VALIDATE(Amount, ApplBankAmount);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := Application."Posted Doc No.";
            GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
            GenJnlLine."Branch Code" := BondPaymentEntry."Branch Code"; //ALLETDK141112
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::"Bank Account");
            GenJnlLine.VALIDATE("Source No.", BondPaymentEntry."Deposit/Paid Bank");
            BondPostingGroup1.GET(Application."Bond Posting Group");
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::Customer); //ALLETDK
            GenJnlLine.VALIDATE("Bal. Account No.", Application."Customer No.");                            //ALLETDK
            GenJnlLine."Posting Group" := Application."Bond Posting Group";
            GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Application."Associate Code";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
            GenJnlLine."Unit No." := Application."Unit Code";   //ALLETDK141112
            GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10); //ALLE-AM
            GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
            GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
            GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
            IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash THEN
                GenJnlLine.Description := 'Cash Received'
            ELSE
                IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN
                    GenJnlLine.Description := 'Cheque Received'
                ELSE
                    IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.D." THEN
                        GenJnlLine.Description := 'D.D. Received'
                    ELSE
                        IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking" THEN
                            GenJnlLine.Description := 'D.C./C.C./Net Banking';
            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
            GenJnlLine.INSERT;
            Line := Line + 10000;    //ALLETDK
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
        END;
        IF CashAmount <> 0 THEN BEGIN
            CashPmtMethod.GET(BondPaymentEntry."Payment Method");
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := Line;
            GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Application."Document Date");
            CASE CashPmtMethod."Bal. Account Type" OF
                CashPmtMethod."Bal. Account Type"::"G/L Account":
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                CashPmtMethod."Bal. Account Type"::"Bank Account":
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
            END;
            GenJnlLine.VALIDATE("Account No.", CashPmtMethod."Bal. Account No.");
            GenJnlLine.VALIDATE(Amount, CashAmount);
            GenJnlLine."Document No." := Application."Posted Doc No.";
            GenJnlLine."Branch Code" := BondPaymentEntry."Branch Code"; //ALLETDK141112
            GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
            GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
            BondPostingGroup1.GET(Application."Bond Posting Group");
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::Customer);//ALLETDK
            GenJnlLine.VALIDATE("Bal. Account No.", Application."Customer No.");                           //ALLETDK
            GenJnlLine."Posting Group" := Application."Bond Posting Group";
            GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
            GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Introducer Code" := Application."Associate Code";
            GenJnlLine."Unit No." := Application."Unit Code";   //ALLETDK141112
            GenJnlLine."Installment No." := 1;
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
            IF (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash) THEN
                GenJnlLine.Description := 'Cash Received'
            ELSE
                GenJnlLine.Description := 'Amount transferred';
            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
            GenJnlLine.INSERT;
            Line := Line + 10000;    //ALLETDK
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
        END;
        //ALLETDK021112--END
        Line += 10000;
        //Discount Debit
        IF Application."Discount Amount" > 0 THEN BEGIN
            PaymentMethod.GET(BondSetup."Discount Allowed on Bond A/C");
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := Line;
            GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Application."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", PaymentMethod."Bal. Account No.");
            GenJnlLine.VALIDATE(Amount, Application."Discount Amount");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := Application."Posted Doc No.";
            BondPostingGroup1.GET(Application."Customer No.");
            GenJnlLine."Bond Posting Group" := Application."Customer No.";
            GenJnlLine."Posting Group" := Application."Bond Posting Group";
            GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
            GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;

            GenJnlLine."Introducer Code" := Application."Associate Code";
            GenJnlLine."Unit No." := Application."Unit No.";
            GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
            GenJnlLine.INSERT;
            Line := Line + 10000;
        END;
    end;


    procedure PostGenJnlLines(PreDocNo: Code[20])
    begin
        CLEAR(GenJnlPostLine);
        CLEAR(GenJnlPostBatch);
        UserSetup.GET(USERID);
        GenJnlLine.RESET;
        GenJnlLine.SetRange("Document No.", PreDocNo);
        IF GenJnlLine.FINDFIRST THEN BEGIN
            REPEAT
                //GenJnlPostLine.SetDocumentNo(GenJnlLine."Document No.");
                GenJnlPostLine.RunWithCheck(GenJnlLine);  //301224
                                                          //GenJnlPostLine.RunWithoutCheck(GenJnlLine1)  // ALLE AKUL 050225
                                                          //Message('%1', GetLastErrorText);

            UNTIL GenJnlLine.NEXT = 0;
        END;
        //GenJnlPostBatch.DeleteGenJournalNarration(GenJnlLine);

        GenJnlLine.DELETEALL;  //301224
        //JournalLineDimension.DELETEALL;//ALLEDK 310113
    end;


    procedure CreateGenJnlLinesForClChq(var BondPaymentEntry: Record "Unit Payment Entry"; Description2: Text[50]; ReceiveFromType: Option " ","Marketing Member","Bond Holder"; ClearanceDate: Date)
    var
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        BondPostingGroup1: Record "Customer Posting Group";
        Application: Record Application;
        BondPaymentEntry2: Record "Unit Payment Entry";
        RDPmtSchBuff: Record "Template Field";
        RDPaymentScheduleBuffer: Record "Template Field";
        BondPaymentEntry3: Record "Unit Payment Entry";
        BondPaymentEntryCount: Integer;
        BondPmtEntXChqQ: Record "Quote Properties";
        Bond: Record "Confirmed Order";
        AmountRecd: Decimal;
        AppPaymentEntry: Record "Application Payment Entry";
    begin
        //CreateGenJnlLinesForClChq
        BondSetup.GET;
        UnitSetup.GET;
        BondSetup.TESTFIELD("Cr. Source Code");
        Line := 10000;
        BondPaymentEntryCount := BondPaymentEntry.COUNT;
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                BondPaymentEntry.CALCFIELDS(Reversed);
                BondPaymentEntry.TESTFIELD(Reversed, FALSE);
                IF ClearanceDate < BondPaymentEntry."Cheque Date" THEN
                    ERROR(Text004, ClearanceDate, BondPaymentEntry."Cheque Date", BondPaymentEntry."Cheque No./ Transaction No.");
                //ALLETDK021112..BEGIN
                IF (BondPaymentEntry.Amount > 0) AND (ClChequeNo <> BondPaymentEntry."Cheque No./ Transaction No.") THEN BEGIN
                    ClChequeNo := BondPaymentEntry."Cheque No./ Transaction No.";
                    GetChequeAmount(BondPaymentEntry);
                    //ALLETDK021112..END
                    PaymentMethod.GET(BondPaymentEntry."Payment Method");
                    BankAccount.GET(BondPaymentEntry."Deposit/Paid Bank");
                    BankAccountPostingGroup.GET(BankAccount."Bank Acc. Posting Group");
                    GenJnlLine.INIT;
                    GenJnlLine."Line No." := Line;
                    IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application THEN BEGIN
                        Application.GET(BondPaymentEntry."Document No.");
                        GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                        GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";

                        IF Application."Posting Date" < 20120407D THEN BEGIN
                            GenJnlLine.VALIDATE("Posting Date", ClearanceDate);
                            GenJnlLine.VALIDATE("Document Date", TODAY);
                        END ELSE BEGIN
                            GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
                            GenJnlLine.VALIDATE("Document Date", Application."Document Date");
                        END;

                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                        GenJnlLine.VALIDATE("Account No.", BondPaymentEntry."Deposit/Paid Bank");
                        //ALLETDK021112..BEGIN
                        GenJnlLine.VALIDATE("Debit Amount", ChequeAmount);
                        //ALLETDK021112..END
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No." := Application."Posted Doc No.";
                        GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                        GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                        GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                        GenJnlLine."Branch Code" := BondPaymentEntry."Branch Code"; //ALLETDK141112
                        GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                        GenJnlLine."System-Created Entry" := TRUE;

                        GenJnlLine."Introducer Code" := Application."Associate Code";
                        GenJnlLine."Unit No." := Application."Unit Code";//ALLETDK141112
                        GenJnlLine.VALIDATE("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Manual Check"); //ALLETDK061212
                        GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10); //ALLE-AM
                        GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                        GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                        GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                        GenJnlLine."Paid To/Received From" := ReceiveFromType;
                        GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                        GenJnlLine.INSERT;
                        Line := Line + 10000;

                        //Credit
                        PaymentMethod.GET(BondPaymentEntry."Payment Method");
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                        GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                        GenJnlLine."Line No." := Line;

                        IF Application."Posting Date" < 20120407D THEN BEGIN
                            GenJnlLine.VALIDATE("Posting Date", ClearanceDate);
                            GenJnlLine.VALIDATE("Document Date", TODAY);
                        END ELSE BEGIN
                            GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
                            GenJnlLine.VALIDATE("Document Date", Application."Document Date");
                        END;

                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        GenJnlLine.VALIDATE("Account No.", PaymentMethod."Bal. Account No.");
                        //ALLETDK021112..BEGIN
                        GenJnlLine.VALIDATE("Credit Amount", ChequeAmount);
                        //ALLETDK021112..END
                        GenJnlLine.Description := BondPaymentEntry.Description;
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No." := Application."Posted Doc No.";
                        BondPostingGroup1.GET(Application."Bond Posting Group");
                        GenJnlLine."Bond Posting Group" := Application."Customer No.";
                        GenJnlLine."Posting Group" := Application."Bond Posting Group";
                        GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                        GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                        GenJnlLine."Branch Code" := BondPaymentEntry."Branch Code"; //ALLETDK141112
                        GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                        GenJnlLine."System-Created Entry" := TRUE;

                        GenJnlLine."Introducer Code" := Application."Associate Code";
                        GenJnlLine."Unit No." := Application."Unit Code";   //ALLETDK141112
                        GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10); //ALLE-AM
                        GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No."; //ALLE-AM
                        GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                        GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                        GenJnlLine."Paid To/Received From" := ReceiveFromType;
                        GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                        GenJnlLine.INSERT;
                        Line := Line + 10000;
                    END ELSE
                        IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::BOND THEN BEGIN
                            Bond.GET(BondPaymentEntry."Document No.");
                            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";

                            IF Bond."Posting Date" < 20120407D THEN BEGIN
                                GenJnlLine.VALIDATE("Posting Date", ClearanceDate);
                                GenJnlLine.VALIDATE("Document Date", TODAY);
                            END ELSE BEGIN
                                GenJnlLine.VALIDATE("Posting Date", Bond."Posting Date");
                                GenJnlLine.VALIDATE("Document Date", Bond."Document Date");
                            END;

                            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                            GenJnlLine.VALIDATE("Account No.", BondPaymentEntry."Deposit/Paid Bank");
                            //ALLETDK021112..BEGIN
                            GenJnlLine.VALIDATE("Debit Amount", ChequeAmount);
                            //ALLETDK021112..END
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                            GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                            GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
                            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                            GenJnlLine."System-Created Entry" := TRUE;

                            GenJnlLine."Introducer Code" := Bond."Introducer Code";
                            GenJnlLine."Unit No." := Bond."Unit Code"; //ALLETDK141112
                            GenJnlLine.VALIDATE("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Manual Check"); //ALLETDK061212
                            GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10); //ALLE-AM
                            GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No."; //ALLE-AM
                            GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                            GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                            GenJnlLine."Paid To/Received From" := ReceiveFromType;
                            GenJnlLine."Paid To/Received From Code" := Bond."Received From Code";
                            GenJnlLine.INSERT;
                            Line := Line + 10000;

                            //Credit
                            PaymentMethod.GET(BondPaymentEntry."Payment Method");
                            GenJnlLine.INIT;
                            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                            GenJnlLine."Line No." := Line;

                            IF Bond."Posting Date" < 20120407D THEN BEGIN
                                GenJnlLine.VALIDATE("Posting Date", ClearanceDate);
                                GenJnlLine.VALIDATE("Document Date", TODAY);
                            END ELSE BEGIN
                                GenJnlLine.VALIDATE("Posting Date", Bond."Posting Date");
                                GenJnlLine.VALIDATE("Document Date", Bond."Document Date");
                            END;

                            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                            GenJnlLine.VALIDATE("Account No.", PaymentMethod."Bal. Account No.");
                            //ALLETDK021112..BEGIN
                            GenJnlLine.VALIDATE("Credit Amount", ChequeAmount);
                            //ALLETDK021112..END
                            GenJnlLine.Description := BondPaymentEntry.Description;
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                            GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                            BondPostingGroup1.GET(Bond."Bond Posting Group");
                            GenJnlLine."Bond Posting Group" := Bond."Customer No.";
                            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
                            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                            GenJnlLine."System-Created Entry" := TRUE;

                            GenJnlLine."Introducer Code" := Bond."Introducer Code";
                            GenJnlLine."Unit No." := Bond."Unit Code";//ALLETDK141112
                            GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10); //ALLE-AM
                            GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No."; //ALLE-AM
                            GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                            GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                            GenJnlLine."Paid To/Received From" := ReceiveFromType;
                            GenJnlLine."Paid To/Received From Code" := Bond."Received From Code";
                            GenJnlLine.INSERT;
                            Line := Line + 10000;
                        END;
                    //ALLETDK021112..BEGIN
                    IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application THEN BEGIN
                        UpdateStagingtableChq(Application."Application No.", BondPaymentEntry."Cheque No./ Transaction No.",
                        BondPaymentEntry."Cheque Date");
                        AmountRecd := Application.AmountRecdAppl(Application."Application No.");
                        IF AmountRecd >= Application."Min. Allotment Amount" THEN
                            UpdateStagingtable(Application."Application No.");
                    END ELSE
                        IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::BOND THEN
                            UpdateStagingtableChq(Bond."Application No.", BondPaymentEntry."Cheque No./ Transaction No.",
                            BondPaymentEntry."Cheque Date");
                    //ALLETDK021112..END


                    BondPaymentEntry2.RESET;
                    BondPaymentEntry2.SETRANGE("Document Type", BondPaymentEntry."Document Type");
                    BondPaymentEntry2.SETRANGE("Document No.", BondPaymentEntry."Document No.");
                    BondPaymentEntry2.SETFILTER("Line No.", '<>%1', BondPaymentEntry."Line No.");
                    BondPaymentEntry2.SETRANGE(BondPaymentEntry2."Payment Mode", 2, 3);//Cheque,DD
                    BondPaymentEntry2.SETFILTER("Cheque Status", '<>%1', BondPaymentEntry2."Cheque Status"::Cleared);
                    IF BondPaymentEntry2.ISEMPTY THEN BEGIN
                        IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application THEN BEGIN
                            Application.GET(BondPaymentEntry."Application No.");
                            Application."Cheque Cleared" := TRUE;
                            Application.MODIFY;
                            ReleaseBondApplication.InsertBondHistory(Application."Unit No.", 'Cheque Cleared.', 0, Application."Application No.");
                        END;
                    END;
                END;

                BondPaymentEntry2.RESET;
                BondPaymentEntry2.SETRANGE("Document Type", BondPaymentEntry."Document Type");
                BondPaymentEntry2.SETRANGE("Document No.", BondPaymentEntry."Document No.");
                BondPaymentEntry2.SETRANGE("Line No.", BondPaymentEntry."Line No.");
                IF BondPaymentEntry2.FINDFIRST THEN BEGIN
                    BondPaymentEntry2."Cheque Status" := BondPaymentEntry2."Cheque Status"::Cleared;
                    BondPaymentEntry2."Chq. Cl / Bounce Dt." := ClearanceDate;
                    BondPaymentEntry2.MODIFY;
                    // ALLEPG 080812 Start
                    AppPaymentEntry.RESET;
                    AppPaymentEntry.SETRANGE("Document No.", BondPaymentEntry2."Document No.");
                    AppPaymentEntry.SETRANGE("Cheque No./ Transaction No.", BondPaymentEntry2."Cheque No./ Transaction No.");
                    IF AppPaymentEntry.FINDFIRST THEN BEGIN
                        AppPaymentEntry."Cheque Status" := AppPaymentEntry."Cheque Status"::Cleared;
                        AppPaymentEntry."Chq. Cl / Bounce Dt." := ClearanceDate;
                        AppPaymentEntry.MODIFY;
                    END;
                    // ALLEPG 080812 End
                    IF Bond.GET(BondPaymentEntry."Document No.") THEN BEGIN
                        AmountRecd := Bond.AmountRecdAppl(Bond."No.");
                        IF AmountRecd >= Bond."Min. Allotment Amount" THEN
                            UpdateStagingtable(Bond."No.");
                    END;

                    IF BondPaymentEntry2."Posting date" <= 20120406D THEN BEGIN
                        BondPmtEntXChqQ.INIT;
                        BondPmtEntXChqQ.TRANSFERFIELDS(BondPaymentEntry2);
                        IF BondPmtEntXChqQ.INSERT THEN;
                    END;

                    IF BondPaymentEntry2."Document Type" = BondPaymentEntry2."Document Type"::Application THEN BEGIN
                        IF BondPaymentEntry3.GET(BondPaymentEntry3."Document Type"::BOND, BondPaymentEntry2."Unit Code", BondPaymentEntry2."Line No."
                 )
                         THEN BEGIN
                            BondPaymentEntry3."Cheque Status" := BondPaymentEntry2."Cheque Status";
                            BondPaymentEntry3."Chq. Cl / Bounce Dt." := ClearanceDate;
                            BondPaymentEntry3.MODIFY;
                        END;
                    END;
                END;
                BondPaymentEntryCount -= 1;
                IF BondPaymentEntryCount > 0 THEN
                    IF BondPaymentEntry.NEXT = 0 THEN;
            UNTIL BondPaymentEntryCount = 0;

        PostGenJnlLines(GenJnlLine."Document No.");
    end;


    procedure GeneratePaymentScheduleForRD(Application: Record Application)
    var
        StartDate: Date;
        DueDate: Date;
        BondDuration: Integer;
        Counter: Integer;
        InstallmentNo: Integer;
        YearCode: Integer;
        RDPaymentSchedule: Record Terms;
        DiscountPercent: Decimal;
        DiscountAmount: Decimal;
    begin
    end;


    procedure GeneratePaymentScheduleForMIS(Application: Record Application)
    var
        StartDate: Date;
        DueDate: Date;
        BondDuration: Integer;
        Counter: Integer;
        InstallmentNo: Integer;
        YearCode: Integer;
    begin
    end;


    procedure GeneratePaymentScheduleNewBusi(Application: Record Application; InstallmentNo: Integer; YearCode: Integer; User: Code[50])
    var
        //PaymentSchedulePostedFD: Record 97762;
        Vendor: Record Vendor;
    begin
    end;


    procedure CalcForMonthlyInstallment(Application: Record Application)
    begin
        IF Application."Investment Frequency" = Application."Investment Frequency"::Monthly THEN
            MonthlyInstallment := Application."Investment Amount" + Application."Discount Amount"
        ELSE
            IF Application."Investment Frequency" = Application."Investment Frequency"::Quarterly THEN
                MonthlyInstallment := (Application."Investment Amount" + Application."Discount Amount") / 3
            ELSE
                IF Application."Investment Frequency" = Application."Investment Frequency"::"Half Yearly" THEN
                    MonthlyInstallment := (Application."Investment Amount" + Application."Discount Amount") / 6
                ELSE
                    IF Application."Investment Frequency" = Application."Investment Frequency"::Annually THEN
                        MonthlyInstallment := (Application."Investment Amount" + Application."Discount Amount") / 12;
    end;


    procedure CalcForInvestmentFreq(InvestmentFrequency: Option " ",Monthly,Quarterly,"Half Yearly",Annually): Integer
    begin
        //CalcForInvestmentFreq
        CASE InvestmentFrequency OF
            InvestmentFrequency::Monthly:
                EXIT(1);
            InvestmentFrequency::Quarterly:
                EXIT(3);
            InvestmentFrequency::"Half Yearly":
                EXIT(6);
            InvestmentFrequency::Annually:
                EXIT(12);
        END;
    end;


    procedure CreateBond(ApplicationNo: Code[20])
    var
        Bond: Record "Confirmed Order";
        BondPaymentEntry: Record "Unit Payment Entry";
        ApplPaymentEntry: Record "Unit Payment Entry";
        BondHistory: Record "Unit History";
        ApplicationHistory: Record "Unit History";
        ApplCommentLine: Record "Comment Line";
        BondCommentLine: Record "Comment Line";
        Application: Record Application;
        ComissionPostingBuffer: Record "Unit & Comm. Creation Buffer";
    begin
        //Bond Creation;
        Application.GET(ApplicationNo);
        IF (NOT Application."With Cheque") OR (Application."Cheque Cleared") THEN BEGIN
            Bond.INIT;
            Bond."No." := Application."Unit No.";
            Bond."Scheme Code" := Application."Scheme Code";
            Bond."Project Type" := Application."Project Type";
            Bond.Duration := Application.Duration;
            Bond."Customer No." := Application."Customer No.";
            Bond."Introducer Code" := Application."Associate Code";
            Bond."Maturity Date" := Application."Maturity Date";
            Bond."Maturity Amount" := Application."Maturity Amount";
            Bond."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
            Bond."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
            Bond."Application No." := Application."Application No.";
            Bond.Status := Bond.Status::Open;
            Bond."User Id" := USERID;
            Bond.Amount := Application."Amount Received" - Application."Service Charge Amount";
            Bond."Posting Date" := Application."Posting Date";
            Bond."Document Date" := Application."Document Date";
            Bond."Investment Frequency" := Application."Investment Frequency";
            Bond."Return Frequency" := Application."Return Frequency";
            Bond."Service Charge Amount" := Application."Service Charge Amount";
            Bond."Bond Category" := Application.Category;
            Bond."Posted Doc No." := Application."Posted Doc No.";
            Bond."Discount Amount" := Application."Discount Amount";
            Bond."Return Payment Mode" := Application."Return Payment Mode";
            Bond."Received From" := Bond."Received From"::"Marketing Member";
            Bond."Received From Code" := Application."Received From Code";
            Bond."Version No." := Application."Scheme Version No.";
            Bond."Maturity Bonus Amount" := Application."Maturity Bonus Amount";
            Bond."Bond Posting Group" := Application."Bond Posting Group";
            Bond."Creation Time" := TIME;
            Bond."Investment Type" := Application."Investment Type";
            Bond.INSERT;
            ReleaseBondApplication.InsertBondHistory(Application."Unit No.", 'Bond Created.', 0, Application."Application No.");

            //Comment Line Creation;
            ApplCommentLine.RESET;
            ApplCommentLine.SETRANGE("Table Name", ApplCommentLine."Table Name"::"Activity Master");
            ApplCommentLine.SETRANGE("No.", Application."Application No.");
            IF ApplCommentLine.FINDSET THEN
                REPEAT
                    BondCommentLine.INIT;
                    BondCommentLine.TRANSFERFIELDS(ApplCommentLine);
                    BondCommentLine."Table Name" := BondCommentLine."Table Name"::"Confirmed order";
                    BondCommentLine."No." := Application."Unit No.";
                    BondCommentLine.INSERT;
                UNTIL ApplCommentLine.NEXT = 0;

            //Payment Schedule Creation
            IF Application."Investment Type" = Application."Investment Type"::RD THEN BEGIN
                GeneratePaymentScheduleForRD(Application);
            END ELSE
                IF Application."Investment Type" = Application."Investment Type"::MIS THEN BEGIN
                    GeneratePaymentScheduleForMIS(Application);
                END;
            GeneratePaymentScheduleNewBusi(Application, 1, 1, USERID);
            //Bond Ledger Creation
            CreateBondLedger(Application, 1, TRUE);

            ComissionPostingBuffer.GET(Application."Unit No.", 1);
            ComissionPostingBuffer."Bond Created" := TRUE;
            ComissionPostingBuffer.MODIFY;

            ReleaseBondApplication.InsertBondHistory(Application."Unit No.", 'Payment Schedule Created.', 0, Application."Application No.");
            Application.Status := Application.Status::Converted;
            Application.MODIFY;
        END;
    end;


    procedure CalcDiscount(InvestmentFreq: Option " ",Monthly,Quarterly,"Half Yearly",Annually; BondType: Code[20]; PostingDate: Date): Integer
    var
        DiscountChart: Record "User Res. Center Setup";
        DiscountPercent: Decimal;
    begin
    end;


    procedure CreateStagingTableApplication(Application: Record Application; InstallmentNo: Integer; YearCode: Integer)
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
    begin
        //CreateStagingTableApplication
        IF InitialStagingTab.GET(Application."Unit No.", InstallmentNo) THEN
            EXIT;

        InitialStagingTab.INIT;
        InitialStagingTab."Unit No." := Application."Unit No.";
        InitialStagingTab."Installment No." := InstallmentNo;
        InitialStagingTab."Posting Date" := Application."Posting Date";
        InitialStagingTab.VALIDATE("Introducer Code", Application."Associate Code");
        InitialStagingTab."Base Amount" := Application."Amount Received" - Application."Service Charge Amount";
        InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
        InitialStagingTab.Duration := Application.Duration;
        InitialStagingTab."Year Code" := YearCode;
        InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
        InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
        InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
        InitialStagingTab."Application No." := Application."Application No.";
        InitialStagingTab."Paid by cheque" := Application."With Cheque";
        InitialStagingTab."Bond Created" := Bond.GET(InitialStagingTab."Unit No.");
        CommEntry.RESET;
        CommEntry.SETCURRENTKEY("Application No.", "Installment No.");
        CommEntry.SETRANGE("Application No.", InitialStagingTab."Unit No.");
        CommEntry.SETRANGE("Installment No.", InitialStagingTab."Installment No.");
        InitialStagingTab."Commission Created" := NOT CommEntry.ISEMPTY;
        InitialStagingTab.INSERT;
    end;


    procedure CreateBondLedger(Application: Record Application; InstallmentNo: Integer; FirstYear: Boolean)
    var
        BondLedgerEntry: Record "Unit Ledger Entry";
    begin
        BondLedgerEntry.INIT;
        BondLedgerEntry."Line No." := GetLastEntryNo(50013);
        BondLedgerEntry."Document No." := Application."Posted Doc No.";
        BondLedgerEntry."Posting Date" := Application."Posting Date";
        BondLedgerEntry."Document Date" := Application."Document Date";
        BondLedgerEntry."Due Date" := Application."Posting Date";
        BondLedgerEntry."Unit No." := Application."Unit No.";
        BondLedgerEntry."Project Type" := Application."Project Type";
        BondLedgerEntry."Scheme Code" := Application."Scheme Code";
        BondLedgerEntry."Version No." := Application."Scheme Version No.";
        BondLedgerEntry."Bond Category" := Application.Category;
        BondLedgerEntry."Associate Code" := Application."Associate Code";
        BondLedgerEntry.Duration := Application.Duration;
        BondLedgerEntry."Installment No." := InstallmentNo;
        BondLedgerEntry."Original Amount" := Application."Amount Received" - Application."Service Charge Amount";
        BondLedgerEntry."Discount Amount" := Application."Discount Amount";
        BondLedgerEntry."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
        BondLedgerEntry."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
        BondLedgerEntry."User ID" := USERID;
        BondLedgerEntry.INSERT;
    end;


    procedure GetLastEntryNo(TableNo: Integer): Integer
    var
        EntryNoSetup: Record "Entry No. Setup";
        EntryNo: Integer;
    begin
        EntryNoSetup.SETRANGE(TableNo, TableNo);
        EntryNoSetup.FINDFIRST;
        EntryNoSetup."Entry No." += 1;
        EntryNo := EntryNoSetup."Entry No.";
        EntryNoSetup.MODIFY;
        EXIT(EntryNo);
    end;


    procedure ChequeBounceEntry(var BondPaymentEntry: Record "Unit Payment Entry"; Description2: Text[30])
    var
        Line: Integer;
        BounceAmount: Decimal;
        Application: Record Application;
        LastAppNo: Code[20];
        RDPmtSchBuff: Record "Template Field";
        DiscountAmount: Decimal;
        BondPaymentEntry3: Record "Unit Payment Entry";
    begin
        BondSetup.GET;
        BondSetup.TESTFIELD("Cr. Source Code");

        GenJnlLine.DELETEALL;
        Line := 10000;
        IF BondPaymentEntry.FINDSET THEN BEGIN
            LastAppNo := BondPaymentEntry."Document No.";
            REPEAT
                BondPaymentEntry.TESTFIELD(Reversed, FALSE);
                IF BondPaymentEntry.Amount > 0 THEN BEGIN
                    IF (LastAppNo <> BondPaymentEntry."Document No.") AND (BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application) THEN BEGIN
                        //Bond Entry Credit
                        Application.GET(LastAppNo);
                        SubChequeBounceEntry1(Line, Application, BounceAmount, BondPaymentEntry."Installment No.", Description2);
                        IF (Application."Discount Amount" > 0) AND (Application.Status <> Application.Status::Cancelled) THEN BEGIN
                            Line += 10000;
                            DiscountOnChequeBounceNewBond(Line, Application);
                        END;
                        PostGenJnlLines(Application."Posted Doc No.");
                        ReleaseBondApplication.InsertBondHistory(Application."Unit No.", 'Cheque Bounce.', 0, Application."Application No.");
                        Application.Status := Application.Status::Cancelled;
                        Application.MODIFY;
                        CreateStagingTableApplication(Application, 1, 1);
                        BounceAmount := 0;
                        Line := 10000;
                        LastAppNo := BondPaymentEntry."Document No.";
                        IF BondPaymentEntry3.GET(BondPaymentEntry3."Document Type"::BOND, BondPaymentEntry."Unit Code", BondPaymentEntry.
              "Line No."
              )
                          THEN BEGIN
                            BondPaymentEntry3."Cheque Status" := BondPaymentEntry3."Cheque Status"::Bounced;
                            BondPaymentEntry3.MODIFY;
                        END;
                    END;

                    //Cheque in hand Credit
                    SubChequeBounceEntry2(BondPaymentEntry, Line);
                    BounceAmount += BondPaymentEntry.Amount;
                    Line += 10000;
                    //zee
                END;
            UNTIL BondPaymentEntry.NEXT = 0;

            //Bond Entry Credit
            IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application THEN BEGIN
                Application.GET(LastAppNo);
                SubChequeBounceEntry1(Line, Application, BounceAmount, BondPaymentEntry."Installment No.", Description2);
                IF (Application."Discount Amount" > 0) AND (Application.Status <> Application.Status::Cancelled) THEN BEGIN
                    Line += 10000;
                    DiscountOnChequeBounceNewBond(Line, Application);
                END;

                //PostGenJnlLines;
                PostGenJnlLines(Application."Posted Doc No.");
                ReleaseBondApplication.InsertBondHistory(Application."Unit No.", 'Cheque Bounce.', 0, Application."Application No.");
                Application.Status := Application.Status::Cancelled;
                Application.MODIFY;
                // //GenJnlLine.DELETEALL;
                IF BondPaymentEntry3.GET(BondPaymentEntry3."Document Type"::BOND, BondPaymentEntry."Unit Code", BondPaymentEntry."Line No.")
                  THEN BEGIN
                    BondPaymentEntry3."Cheque Status" := BondPaymentEntry3."Cheque Status"::Bounced;
                    BondPaymentEntry3.MODIFY;
                END;
            END;
            BondPaymentEntry.MODIFYALL("Cheque Status", BondPaymentEntry."Cheque Status"::Bounced);
        END;
    end;


    procedure CreateMaturityGenJnlLines(var Bond: Record "Confirmed Order"; Description: Text[50]; var BondMaturity: Record "Unit Maturity"; var GenJnlLine: Record "Gen. Journal Line" temporary; var LineNo: Integer)
    var
        BondPostingGroup: Record "Customer Posting Group";
        MISPaymentScheduleBuffer: Record "Project Budget Line Buffer";
        EntryType: Option " ",Payment,Interest,Principal,"Interest + Principal";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        Cust: Record Customer;
        Vend: Record Vendor;
        CashPosting: Boolean;
    begin
        //Bank/Cash A/c Credit
        UserSetup.GET(USERID);
        LineNo += 10000;
        BondSetup.GET;
        BondSetup.TESTFIELD("Interest Payable A/C");
        BondSetup.TESTFIELD("Bonus on Mat. Payable A/c");
        BondSetup.TESTFIELD("Dr. Source Code");

        IF BondMaturity."Paid To" = BondMaturity."Paid To"::"Marketing Member" THEN
            IF Vend.GET(BondMaturity."Paid To Code") THEN
                NarrationText2 := Vend.Name;
        IF BondMaturity."Paid To" = BondMaturity."Paid To"::"Bond Holder" THEN
            IF Cust.GET(BondMaturity."Paid To Code") THEN
                NarrationText2 := Cust.Name;
        NarrationText1 := 'Maturity Paid(' + BondMaturity."Paid To Code" + ') ' + COPYSTR(NarrationText2, 1, 30);

        IF (BondMaturity."Return Payment Mode" = BondMaturity."Return Payment Mode"::Cash) AND (GenJnlLine.FINDFIRST) THEN BEGIN
            GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount - BondMaturity.Amount);
            GenJnlLine.MODIFY;
            NarrationText2 := '';
        END ELSE BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := 'MATPMT';
            GenJnlLine."Journal Batch Name" := 'MATPMT';
            GenJnlLine.VALIDATE("Posting Date", BondMaturity."Posting Date");
            GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
            GenJnlLine."Line No." := LineNo;
            IF BondMaturity."Return Payment Mode" = BondMaturity."Return Payment Mode"::Cash THEN BEGIN
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", BondSetup."Cash A/c No.");
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.VALIDATE("Account No.", BondMaturity."Bank Code");
            END;
            GenJnlLine.VALIDATE(Amount, -BondMaturity.Amount);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := BondMaturity."Posted Doc. No.";
            GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            IF BondMaturity."Return Payment Mode" <> BondMaturity."Return Payment Mode"::Cash THEN BEGIN
                GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::"Bank Account");
                GenJnlLine.VALIDATE("Source No.", BondMaturity."Bank Code");
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
                GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
            END;
            GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
            GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
            GenJnlLine."Branch Code" := UserSetup."User Branch";
            GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Cheque No." := BondMaturity."Cheque No.";
            GenJnlLine."Cheque Date" := BondMaturity."Cheque Date";
            GenJnlLine."Paid To/Received From" := BondMaturity."Paid To";
            GenJnlLine."Paid To/Received From Code" := BondMaturity."Paid To Code";
            GenJnlLine.Description := Description;
            GenJnlLine.INSERT;
            LineNo += 10000;
            //Line Narration
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
            GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
        END;

        //"Interest Payable A/c"
        IF BondMaturity."Interest Amount" > 0 THEN BEGIN
            BEGIN
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := 'MATPMT';
                GenJnlLine."Journal Batch Name" := 'MATPMT';
                GenJnlLine.VALIDATE("Posting Date", BondMaturity."Posting Date");
                GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
                GenJnlLine."Line No." := LineNo;
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", BondSetup."Interest Payable A/C");
                GenJnlLine.VALIDATE(Amount, BondMaturity."Interest Amount");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := BondMaturity."Posted Doc. No.";
                GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
                GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
                GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
                GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
                GenJnlLine."Branch Code" := UserSetup."User Branch";
                GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
                GenJnlLine."System-Created Entry" := TRUE;

                GenJnlLine."Introducer Code" := Bond."Introducer Code";
                GenJnlLine."Unit No." := Bond."No.";
                GenJnlLine."Paid To/Received From" := BondMaturity."Paid To";
                GenJnlLine."Paid To/Received From Code" := BondMaturity."Paid To Code";
                GenJnlLine.INSERT;
                LineNo += 10000;
            END;
        END;

        //Bond Entry
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := 'MATPMT';
        GenJnlLine."Journal Batch Name" := 'MATPMT';
        GenJnlLine.VALIDATE("Posting Date", BondMaturity."Posting Date");
        GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
        GenJnlLine."Line No." := LineNo;
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        BondPostingGroup.GET(Bond."Bond Posting Group");
        GenJnlLine."Bond Posting Group" := Bond."Customer No.";    //ZEE
        GenJnlLine."Posting Group" := Bond."Bond Posting Group";
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
        GenJnlLine.VALIDATE(Amount, BondMaturity.Amount - BondMaturity."Bonus Amount" - BondMaturity."Interest Amount");  //ayan
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := BondMaturity."Posted Doc. No.";
        GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
        GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
        GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
        GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        GenJnlLine."Branch Code" := UserSetup."User Branch";
        GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
        GenJnlLine."System-Created Entry" := TRUE;

        GenJnlLine."Introducer Code" := Bond."Introducer Code";
        GenJnlLine."Unit No." := Bond."No.";
        GenJnlLine."Paid To/Received From" := BondMaturity."Paid To";
        GenJnlLine."Paid To/Received From Code" := BondMaturity."Paid To Code";
        GenJnlLine.INSERT;
        LineNo += 10000;
        EntryType := EntryType::Principal;

        //"Bonus Payable A/c"
        IF BondMaturity."Bonus Amount" > 0 THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := 'MATPMT';
            GenJnlLine."Journal Batch Name" := 'MATPMT';
            GenJnlLine.VALIDATE("Posting Date", BondMaturity."Posting Date");
            GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
            GenJnlLine."Line No." := LineNo;
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."Bonus on Mat. Payable A/c");
            GenJnlLine.VALIDATE(Amount, BondMaturity."Bonus Amount");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := BondMaturity."Posted Doc. No.";
            GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
            GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
            GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
            GenJnlLine."Branch Code" := UserSetup."User Branch";
            GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;

            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Paid To/Received From" := BondMaturity."Paid To";
            GenJnlLine."Paid To/Received From Code" := BondMaturity."Paid To Code";
            GenJnlLine.INSERT;
            LineNo += 10000;
        END;

        CreatePaymentSchedulePosted(Bond, BondMaturity);
        InsertBondentryLine(BondMaturity);

        Bond.Status := Bond.Status::Matured;
        Bond.MODIFY;
    end;


    procedure SubChequeBounceEntry1(Line: Integer; Application: Record Application; BounceAmount: Decimal; InstallmentNo: Integer; Description2: Text[30])
    var
        BondPostingGroup1: Record "Customer Posting Group";
    begin
        UnitSetup.GET;
        GenJnlLine.INIT;
        GenJnlLine."Line No." := Line;
        GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";

        IF Application."Posting Date" < 20120407D THEN BEGIN
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", TODAY);
        END ELSE BEGIN
            GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Application."Document Date");
        END;

        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        BondPostingGroup1.GET(Application."Bond Posting Group");
        GenJnlLine.VALIDATE("Account No.", Application."Customer No.");
        IF Application.Status <> Application.Status::Cancelled THEN
            GenJnlLine.VALIDATE("Debit Amount", BounceAmount + Application."Discount Amount")
        ELSE
            GenJnlLine.VALIDATE("Debit Amount", BounceAmount);
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := Application."Posted Doc No.";
        GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
        GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
        GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
        GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
        GenJnlLine."Branch Code" := UserSetup."User Branch";
        GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
        GenJnlLine."System-Created Entry" := TRUE;

        GenJnlLine."Introducer Code" := Application."Associate Code";
        GenJnlLine."Unit No." := Application."Unit No.";
        GenJnlLine."Installment No." := InstallmentNo;
        GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
        GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
        GenJnlLine.INSERT;
    end;


    procedure SubChequeBounceEntry2(BondPaymentEntry: Record "Unit Payment Entry"; Line: Integer)
    var
        PaymentMethod: Record "Payment Method";
        Application: Record Application;
        BondPostingGroup: Record "Customer Posting Group";
        RDPaymentScheduleBuffer: Record "Template Field";
    begin
        UnitSetup.GET;
        PaymentMethod.GET(BondPaymentEntry."Payment Method");
        GenJnlLine.INIT;
        GenJnlLine."Line No." := Line;
        IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application THEN BEGIN
            Application.GET(BondPaymentEntry."Document No.");
            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";

            IF Application."Posting Date" < 20120407D THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", TODAY);
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
                GenJnlLine.VALIDATE("Document Date", Application."Document Date");
            END;

            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", PaymentMethod."Bal. Account No.");
            GenJnlLine.VALIDATE("Credit Amount", BondPaymentEntry.Amount);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := Application."Posted Doc No.";
            BondPostingGroup.GET(Application."Bond Posting Group");
            GenJnlLine."Bond Posting Group" := BondPostingGroup."Receivables Account";
            GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::"Bank Account");
            GenJnlLine.VALIDATE("Source No.", BondPaymentEntry."Deposit/Paid Bank");
            GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
            GenJnlLine."Branch Code" := UserSetup."User Branch";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;

            GenJnlLine."Introducer Code" := Application."Associate Code";
            GenJnlLine."Unit No." := Application."Unit No.";
            GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10);//ALLE-AM
            GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
            GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
            GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
        END;
        GenJnlLine.Description := BondPaymentEntry.Description;
        GenJnlLine.INSERT;
    end;


    procedure SubChequeBounceEntry3(BondPaymentEntry: Record "Unit Payment Entry"; RDPmtSchBuff: Record "Template Field"; Line: Integer; Description2: Text[30])
    var
        BondPostingGroup: Record "Customer Posting Group";
        RDPaymentScheduleBuffer: Record "Template Field";
    begin
        //zee
    end;


    procedure PostTMISInterest(TotalAmount: Decimal; PostedDocNo: Code[20]; ReceivedFromType: Option " ","Marketing Member","Bond Holder"; ReceivedFrom: Code[20]; ReceivedFromName: Text[50]; var MISPaymentScheduleBuffertemp: Record "Project Budget Line Buffer" temporary)
    var
        LineNo: Integer;
        Bond: Record "Confirmed Order";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
    begin
    end;


    procedure InsertMISPaymentScheduleBuffer(var MISPaymentScheduleBuffertemp: Record "Project Budget Line Buffer" temporary; PostedDocNo: Code[20]; ReceivedFromType: Option " ","Marketing Member","Bond Holder"; ReceivedFrom: Code[20])
    var
        BondPaymentEntry: Record "Unit Payment Entry";
        Bond: Record "Confirmed Order";
        OverrideMIS: Record "Job Allocation";
        LineNo: Integer;
    begin
    end;


    procedure InsertBondentryLine(var BondMaturity: Record "Unit Maturity")
    var
        BondPaymentEntry: Record "Unit Payment Entry";
        LineNo: Integer;
        BondSetup: Record "Unit Setup";
        UserSetup: Record "User Setup";
        Bond: Record "Confirmed Order";
    begin
        BondSetup.GET;
        UserSetup.GET(USERID);
        Bond.GET(BondMaturity."Unit No.");
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
        BondPaymentEntry.SETRANGE("Document No.", BondMaturity."Unit No.");
        IF BondPaymentEntry.FINDLAST THEN
            LineNo := BondPaymentEntry."Line No." + 10000;

        BondPaymentEntry.RESET;
        BondPaymentEntry.INIT;
        BondPaymentEntry.VALIDATE("Document Type", BondPaymentEntry."Document Type"::BOND);
        BondPaymentEntry.Type := BondPaymentEntry.Type::"Interest + Principal";
        BondPaymentEntry."Document No." := BondMaturity."Unit No.";
        BondPaymentEntry.VALIDATE("Unit Code", BondMaturity."Unit No.");
        BondPaymentEntry."Line No." := LineNo;
        BondPaymentEntry.VALIDATE("Payment Mode", BondMaturity."Return Payment Mode");
        BondPaymentEntry.Amount := BondMaturity.Amount;
        BondPaymentEntry."Application No." := Bond."Application No.";
        BondPaymentEntry.Posted := TRUE;
        IF BondMaturity."Return Payment Mode" = BondMaturity."Return Payment Mode"::Cash THEN BEGIN
            BondPaymentEntry.VALIDATE("Payment Mode", BondPaymentEntry."Payment Mode"::Cash);
            BondPaymentEntry.VALIDATE("Payment Method", BondSetup."Cash A/c No.");
        END ELSE BEGIN
            BondPaymentEntry.Description := 'Cheque Paid(' + BondMaturity."Cheque No." + ')';
            BondPaymentEntry."Cheque No./ Transaction No." := BondMaturity."Cheque No.";
            BondPaymentEntry."Cheque Date" := BondMaturity."Cheque Date";
            BondPaymentEntry."Deposit/Paid Bank" := BondMaturity."Bank Code";
        END;
        BondPaymentEntry."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        BondPaymentEntry."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        BondPaymentEntry.INSERT;
    end;


    procedure CreatePaymentSchedulePosted(Bond: Record "Confirmed Order"; BondMaturity: Record "Unit Maturity")
    var
        MISPaymentScheduleBuffer: Record "Project Budget Line Buffer";
        RDPaymentScheduleBuffer: Record "Template Field";
        FDPaymentSchedulePosted: Record "FD Payment Schedule Posted";
        LineNo: Integer;
    begin
        //ZEE
        IF Bond."Investment Type" = Bond."Investment Type"::FD THEN BEGIN
            FDPaymentSchedulePosted.SETRANGE("Unit No.", Bond."No.");
            IF FDPaymentSchedulePosted.FINDLAST THEN
                LineNo := FDPaymentSchedulePosted."Line No." + 10000;

            FDPaymentSchedulePosted.RESET;
            FDPaymentSchedulePosted.INIT;
            FDPaymentSchedulePosted.VALIDATE("Unit No.", Bond."No.");
            FDPaymentSchedulePosted."Line No." := LineNo;
            FDPaymentSchedulePosted.VALIDATE("Scheme Code", Bond."Scheme Code");
            FDPaymentSchedulePosted.VALIDATE("Project Type", Bond."Project Type");
            FDPaymentSchedulePosted.VALIDATE("Customer No.", Bond."Customer No.");
            FDPaymentSchedulePosted.Duration := Bond.Duration;
            FDPaymentSchedulePosted.VALIDATE("Bond Posting Group", Bond."Bond Posting Group");
            IF BondMaturity."Return Payment Mode" = BondMaturity."Return Payment Mode"::Cash THEN
                FDPaymentSchedulePosted.VALIDATE("Payment Mode", FDPaymentSchedulePosted."Payment Mode"::Cash)
            ELSE BEGIN
                FDPaymentSchedulePosted.VALIDATE("Payment Mode", FDPaymentSchedulePosted."Payment Mode"::Cheque);
                FDPaymentSchedulePosted.VALIDATE("Payment A/C Code", BondMaturity."Bank Code");
            END;
            FDPaymentSchedulePosted."Due Date" := BondMaturity."Effective Date";
            FDPaymentSchedulePosted.Amount := BondMaturity.Amount - BondMaturity."Interest Amount" - BondMaturity."Bonus Amount";
            FDPaymentSchedulePosted."Original Amount" := BondMaturity.Amount;
            FDPaymentSchedulePosted."Interest Amount" := BondMaturity."Interest Amount";
            FDPaymentSchedulePosted.VALIDATE("Introducer Code", Bond."Introducer Code");
            FDPaymentSchedulePosted."Posted Doc. No." := BondMaturity."Posted Doc. No.";
            FDPaymentSchedulePosted."Posting Date" := BondMaturity."Posting Date";
            FDPaymentSchedulePosted."Bond Category" := Bond."Bond Category";
            FDPaymentSchedulePosted.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Sales Resp. Ctr. Filter");
            FDPaymentSchedulePosted.VALIDATE("Shortcut Dimension 2 Code", UserSetup."Shortcut Dimension 2 Code");
            FDPaymentSchedulePosted.VALIDATE("Unit Office Code(Paid)", UserSetup."Sales Resp. Ctr. Filter");
            FDPaymentSchedulePosted.VALIDATE("Counter Code(Paid)", UserSetup."Shortcut Dimension 2 Code");
            FDPaymentSchedulePosted."Version No." := Bond."Version No.";
            FDPaymentSchedulePosted."Document Date" := GetDescription.GetDocomentDate;
            FDPaymentSchedulePosted."Posted By User ID" := USERID;
            FDPaymentSchedulePosted."Cheque Date" := BondMaturity."Cheque Date";
            FDPaymentSchedulePosted.VALIDATE("Cheque No.", BondMaturity."Cheque No.");
            FDPaymentSchedulePosted."Entry Type" := FDPaymentSchedulePosted."Entry Type"::"Interest + Principal";
            FDPaymentSchedulePosted.INSERT;
        END;
    end;


    procedure ReverseMISEntries(var MISDeathClaim: Record "EPC Job Task Archive")
    var
        LineNo: Integer;
        MISPaymentSchedulePosted: Record "FD Payment Schedule Posted";
    begin
    end;


    procedure PostCommissionVouchers(PaymentMode: Option Cash,Cheque; DocumentNo: Code[20]; var CommVoucherPostingBufferParam: Record "Comm. Voucher Posting Buffer"; PostingNoSeries: Code[10]; PaidTo: Code[20]; GLAmount: Decimal; GLAmtPayment: Decimal)
    var
        JnlBatch: Code[10];
        PaymentMethod: Record "Payment Method";
        Line: Integer;
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        Vend: Record Vendor;
        RoundingAmount: Decimal;
    begin
        UserSetup.GET(USERID);
        BondSetup.GET;
        BondSetup.TESTFIELD("Commission A/C");
        BondSetup.TESTFIELD("Commission Payable A/C");
        BondSetup.TESTFIELD("Rounding Account(Commission)");
        BondSetup.TESTFIELD("Dr. Source Code");

        IF DocumentNo = '' THEN
            ERROR('Document No. has not been generated.');

        IF Vend.GET(PaidTo) THEN;
        NarrationText1 := 'Comm. Paid(' + PaidTo + ') ' + COPYSTR(Vend.Name, 1, 30);
        //NarrationText2 := Vend.Name;
        GenJnlLine.DELETEALL;
        Line := 10000;
        IF CommVoucherPostingBufferParam.FINDSET THEN
            REPEAT
                IF CommVoucherPostingBufferParam."Commission Amount" > 0 THEN BEGIN
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := 'COMMPMT';
                    GenJnlLine."Journal Batch Name" := 'COMMPMT';

                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                    GenJnlLine.VALIDATE("Account No.", CommVoucherPostingBufferParam."Associate Code");
                    GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                    GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
                    GenJnlLine.VALIDATE("Document No.", DocumentNo);
                    GenJnlLine.VALIDATE("Posting No. Series", PostingNoSeries);
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                    GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Cheque No." := CommVoucherPostingBufferParam."Cheque No.";
                    GenJnlLine."Cheque Date" := CommVoucherPostingBufferParam."Cheque Date";
                    GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
                    GenJnlLine.VALIDATE("Debit Amount", CommVoucherPostingBufferParam."Commission Amount" - CommVoucherPostingBufferParam."TDS Amount");
                    GenJnlLine.INSERT;
                    Line := Line + 10000;

                    //Payment by cheque
                    IF PaymentMode <> PaymentMode::Cash THEN BEGIN
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := 'COMMPMT';
                        GenJnlLine."Journal Batch Name" := 'COMMPMT';
                        GenJnlLine."Line No." := Line;
                        GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                        GenJnlLine.VALIDATE("Account No.", CommVoucherPostingBufferParam."Payment A/C Code");
                        GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                        GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
                        GenJnlLine.VALIDATE("Document No.", DocumentNo);
                        GenJnlLine.VALIDATE("Posting No. Series", PostingNoSeries);
                        GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                        GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
                        GenJnlLine."Branch Code" := UserSetup."User Branch";
                        GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
                        GenJnlLine."System-Created Entry" := TRUE;

                        GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                        GenJnlLine."Cheque No." := CommVoucherPostingBufferParam."Cheque No.";
                        GenJnlLine."Cheque Date" := CommVoucherPostingBufferParam."Cheque Date";
                        GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
                        IF CommVoucherPostingBufferParam.Status <> 0 THEN
                            GenJnlLine.VALIDATE("Credit Amount", ((CommVoucherPostingBufferParam."Commission Amount" - CommVoucherPostingBufferParam."TDS Amount") - CommVoucherPostingBufferParam.Status))
                        ELSE
                            GenJnlLine.VALIDATE("Credit Amount", (CommVoucherPostingBufferParam."Commission Amount" - CommVoucherPostingBufferParam."TDS Amount"));
                        GenJnlLine.Description := FORMAT(PaymentMode) + ' Paid';
                        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                          GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                        GenJnlLine.INSERT;
                        Line := Line + 10000;
                    END ELSE
                        //CashAmount += "Commission Amount" - "TDS Amount";

                        //Cash payment
                        IF PaymentMode = PaymentMode::Cash THEN BEGIN
                            GenJnlLine.INIT;
                            GenJnlLine."Line No." := Line;
                            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                            PaymentMethod.GET(CommVoucherPostingBufferParam."Payment A/C Code");
                            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                            GenJnlLine.VALIDATE("Account No.", PaymentMethod."Bal. Account No.");
                            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                            GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
                            GenJnlLine.VALIDATE("Document No.", DocumentNo);
                            GenJnlLine.VALIDATE("Posting No. Series", PostingNoSeries);
                            GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                            GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
                            GenJnlLine."Branch Code" := UserSetup."User Branch";
                            GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
                            GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
                            GenJnlLine."System-Created Entry" := TRUE;

                            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                            GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
                            IF CommVoucherPostingBufferParam.Status <> 0 THEN
                                GenJnlLine.VALIDATE("Credit Amount", (CommVoucherPostingBufferParam."Commission Amount" - CommVoucherPostingBufferParam."TDS Amount" - CommVoucherPostingBufferParam.Status))
                            ELSE
                                GenJnlLine.VALIDATE("Credit Amount", CommVoucherPostingBufferParam."Commission Amount" - CommVoucherPostingBufferParam."TDS Amount");
                            GenJnlLine.Description := 'Cash Paid';
                            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                            GenJnlLine.INSERT;
                            Line := Line + 10000;
                        END;

                    DuplicateVoucherChecking(CommVoucherPostingBufferParam."Voucher No.");

                    //!Corpus Account
                    IF CommVoucherPostingBufferParam.Status <> 0 THEN BEGIN
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := 'COMMPMT';
                        GenJnlLine."Journal Batch Name" := 'COMMPMT';
                        GenJnlLine."Line No." := Line;
                        GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        BondSetup.TESTFIELD("Corpus A/C");
                        GenJnlLine.VALIDATE("Account No.", BondSetup."Corpus A/C");
                        GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                        GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
                        GenJnlLine.VALIDATE("Document No.", DocumentNo);
                        GenJnlLine.VALIDATE("Posting No. Series", PostingNoSeries);
                        GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                        GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
                        GenJnlLine."Branch Code" := UserSetup."User Branch";
                        GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
                        GenJnlLine."System-Created Entry" := TRUE;

                        GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                        GenJnlLine."Cheque No." := CommVoucherPostingBufferParam."Cheque No.";
                        GenJnlLine."Cheque Date" := CommVoucherPostingBufferParam."Cheque Date";
                        GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
                        GenJnlLine.VALIDATE("Credit Amount", CommVoucherPostingBufferParam.Status);
                        GenJnlLine.Description := FORMAT(PaymentMode) + ' Paid';
                        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                          GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                        GenJnlLine.INSERT;
                        Line := Line + 10000;
                    END;
                END;
            UNTIL CommVoucherPostingBufferParam.NEXT = 0;

        // Round Off only for cash payment
        IF GLAmtPayment <> GLAmount THEN BEGIN
            RoundingAmount -= GLAmount - GLAmtPayment;

            GenJnlLine.INIT;
            GenJnlLine."Line No." := Line;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."Rounding Account(Commission)");
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
            GenJnlLine.VALIDATE("Document No.", DocumentNo);
            GenJnlLine.VALIDATE("Posting No. Series", PostingNoSeries);
            GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
            GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
            GenJnlLine."Branch Code" := UserSetup."User Branch";
            GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
            GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
            GenJnlLine."System-Created Entry" := TRUE;

            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
            GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
            GenJnlLine.VALIDATE(Amount, GLAmtPayment - GLAmount);
            GenJnlLine.INSERT;
            Line := Line + 10000;
        END;

        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.", 0, 1,
          NarrationText1);

        CommVoucherPostingBufferParam.MODIFYALL("Posted Doc. No.", DocumentNo);
        CommVoucherPostingBufferParam.MODIFYALL(Status, CommVoucherPostingBufferParam.Status::Posted);

        PostGenJnlLines(DocumentNo);
    end;


    procedure DuplicateVoucherChecking(VoucherNoFilt: Code[20])
    var
        Divider: Text[30];
        CommVoucherPostingBuffer: Record "Comm. Voucher Posting Buffer";
    begin
        CommVoucherPostingBuffer.RESET;
        CommVoucherPostingBuffer.SETRANGE("Voucher No.", UPPERCASE(VoucherNoFilt));
        CommVoucherPostingBuffer.SETRANGE(Status, CommVoucherPostingBuffer.Status::Posted);
        IF NOT CommVoucherPostingBuffer.ISEMPTY THEN
            ERROR('The vouchers ' + VoucherNoFilt + ' has already been posted.');
    end;


    procedure PostBonusVoucher(DocumentNo: Code[20]; PostingNoSeries: Code[10]; PaidTo: Code[20]; GLAmount: Decimal; GLAmtPayment: Decimal; BaseAmount: Decimal; PaymentAccount: Code[20]; TokenNo: Code[20])
    var
        BonusPostingBuffer: Record "Bonus Posting Buffer";
        BonusPostingBuffer2: Record "Bonus Posting Buffer";
        Vendor: Record Vendor;
        LineNo: Integer;
        GLAmtDiff: Decimal;
        NarrationText1: Text[50];
        NarrationText2: Text[50];
    begin
        BondSetup.GET;
        BondSetup.TESTFIELD(BondSetup."Dr. Source Code");
        BondSetup.TESTFIELD("Bonus Dr. Source Code");
        UserSetup.GET(USERID);


        IF Vendor.GET(PaidTo) THEN;

        NarrationText1 := 'Bonus Paid(' + PaidTo + ') ' + COPYSTR(Vendor.Name, 1, 30);
        NarrationText2 := 'Token: ' + TokenNo + ', Base Amt: ' + FORMAT(BaseAmount);

        BonusPostingBuffer.SETCURRENTKEY("Token No.");
        BonusPostingBuffer.SETRANGE("Token No.", TokenNo);
        IF BonusPostingBuffer.FINDSET THEN
            REPEAT
                IF NOT Vendor.GET(BonusPostingBuffer."Associate Code") THEN;
                Vendor.TESTFIELD("BBG Status", Vendor."BBG Status"::Active);
                IF Vendor."BBG Suspended" THEN
                    ERROR('Marketing Member %1 is suspended.', BonusPostingBuffer."Associate Code");

            UNTIL BonusPostingBuffer.NEXT = 0;

        //Bonus Account
        LineNo += 10000;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := 'BONPMT';
        GenJnlLine."Journal Batch Name" := 'BONPMT';
        GenJnlLine."Line No." := LineNo;
        GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
        GenJnlLine.VALIDATE("Document No.", DocumentNo);
        GenJnlLine.VALIDATE("Posting Date", WORKDATE);
        GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Account No.", BondSetup."Bonus A/c");
        GenJnlLine.VALIDATE(Amount, GLAmount);
        GenJnlLine."Posting No. Series" := PostingNoSeries;
        GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        GenJnlLine."Source Code" := BondSetup."Bonus Dr. Source Code";
        GenJnlLine."System-Created Entry" := TRUE;

        GenJnlLine.VALIDATE("Paid To/Received From", GenJnlLine."Paid To/Received From"::"Marketing Member");
        GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
        GenJnlLine.INSERT;

        //Cash
        LineNo += 10000;
        GLAmtDiff := GLAmount - GLAmtPayment;
        GLAmount := GLAmtPayment;

        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := 'BONPMT';
        GenJnlLine."Journal Batch Name" := 'BONPMT';
        GenJnlLine."Line No." := LineNo;
        GenJnlLine.VALIDATE("Document No.", DocumentNo);
        GenJnlLine.VALIDATE("Posting Date", WORKDATE);
        GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Account No.", PaymentAccount);
        GenJnlLine.VALIDATE("Credit Amount", GLAmount);
        GenJnlLine."Posting No. Series" := PostingNoSeries;
        GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        GenJnlLine."Source Code" := BondSetup."Bonus Dr. Source Code";
        GenJnlLine."System-Created Entry" := TRUE;

        GenJnlLine.VALIDATE("Paid To/Received From", GenJnlLine."Paid To/Received From"::"Marketing Member");
        GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
        GenJnlLine.Description := 'Cash Payment';
        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
          GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
          GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText2);
        GenJnlLine.INSERT;

        //For Round Off a/c
        LineNo += 10000;
        IF GLAmtDiff <> 0 THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := 'BONPMT';
            GenJnlLine."Journal Batch Name" := 'BONPMT';

            GenJnlLine."Line No." := LineNo;
            GenJnlLine.VALIDATE("Document No.", DocumentNo);
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."RoundingOff(Bonus)");
            GenJnlLine.VALIDATE(Amount, -GLAmtDiff);
            GenJnlLine."Posting No. Series" := PostingNoSeries;
            GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
            GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Bonus Dr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;

            GenJnlLine.VALIDATE("Paid To/Received From", GenJnlLine."Paid To/Received From"::"Marketing Member");
            GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
            GenJnlLine.INSERT;
        END;

        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
        GenJnlLine."Line No.", GenJnlLine."Line No.",
          NarrationText1);
        //    InitVoucherNarration(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name",GenJnlLine."Document No.",0,2,
        //    NarrationText2);
    end;


    procedure DiscountOnChequeBounceRD(DiscountAmount: Decimal; LineNo: Integer; RDPaymentScheduleBuffer: Record "Template Field")
    begin
    end;


    procedure DiscountOnChequeBounceNewBond(LineNo: Integer; Application: Record Application)
    begin
        //Discount Debit
        BondSetup.GET;
        BondSetup.TESTFIELD("Discount Allowed on Bond A/C");
        BondSetup.TESTFIELD("Cr. Source Code");

        GenJnlLine.INIT;

        IF Application."Posting Date" < 20120407D THEN BEGIN
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", TODAY);
        END ELSE BEGIN
            GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Application."Document Date");
        END;

        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Account No.", BondSetup."Discount Allowed on Bond A/C");
        GenJnlLine."Line No." := LineNo;
        GenJnlLine.VALIDATE("Credit Amount", Application."Discount Amount");
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := Application."Posted Doc No.";
        GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
        GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
        GenJnlLine."System-Created Entry" := TRUE;

        GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
        GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
        GenJnlLine.INSERT;
    end;


    procedure RDPaymentPost1(var RDPaymentScheduleBuffer: Record "Template Field"; var BondPmtEntry: Record "Unit Payment Entry" temporary; PostedDocNo: Code[20]; Dim1: Code[20]; Dim2: Code[20]; PaymentRcvdFrom: Code[20]; PmtRcvd: Option " ","Marketing Member","Bond Holder")
    var
        Bond: Record "Confirmed Order";
        BondPostingGroup: Record "ID 2 Group";
        Paymentmethod: Record "Payment Method";
        OnHold: Boolean;
        Application: Record Application;
        RDPaymentScheduleBuff: Record "Template Field";
        TempRDPaymentScheduleBuff: Record "Template Field" temporary;
        ChequeNo: Code[20];
        ChequeDate: Date;
        BondPaymentEntry: Record "Unit Payment Entry";
        Window: Dialog;
        Cnt: Integer;
        DiscountAmt: Decimal;
        LateChargeAmt: Decimal;
        TotalPmt: Decimal;
        TotAmt: Decimal;
        RndOffAmt: Decimal;
        RDPaymentSchedule: Record Terms;
        RDPmtCons: Record "Insurance Detail";
        TempRDPmtCons: Record "Insurance Detail" temporary;
        Line: Integer;
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        PaymentRcvdFromName: Text[50];
        NarrationLine: Integer;
        VoucherNarrationPosted: Boolean;
        BonusEntry: Record "Bonus Entry" temporary;
        InsertBonus: Boolean;
    begin
    end;


    procedure InitVoucherNarration(JnlTemplate: Code[10]; JnlBatch: Code[10]; DocumentNo: Code[20]; GenJnlLineNo: Integer; NarrationLineNo: Integer; LineNarrationText: Text[50])
    var
        GenJnlNarration: Record "Gen. Journal Narration"; //"16549";
        LineNo: Integer;
        PayToName: Text[50];
        Cust: Record Customer;
        Vend: Record Vendor;
        OldGenJnlNarration: Record "Gen. Journal Narration";//"16549";
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


    procedure PostGenJnlLinesMaturity(var GenJnlLine: Record "Gen. Journal Line")
    begin
        //PostGenJnlLinesMaturity
        CLEAR(GenJnlPostLine);
        CLEAR(GenJnlPostBatch);
        GenJnlLine.RESET;
        GenJnlLine.FINDFIRST;
        REPEAT
            //GenJnlPostLine.SetDocumentNo(GenJnlLine."Document No.");
            GenJnlPostLine.RUN(GenJnlLine);
        UNTIL GenJnlLine.NEXT = 0;
        //GenJnlPostBatch.DeleteGenJournalNarration(GenJnlLine);
        //GenJnlLine.DELETEALL;
    end;


    procedure PostMISInterestCash(TotalAmount: Decimal; PostedDocNo: Code[20]; ReceivedFromType: Option " ","Marketing Member","Bond Holder"; ReceivedFrom: Code[20]; ReceivedFromName: Text[50]; var MISPaymentScheduleBuffer: Record "Project Budget Line Buffer")
    var
        LineNo: Integer;
        Bond: Record "Confirmed Order";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
    begin
    end;


    procedure InsertMISPmtScheduleBufferCash(var MISPaymentScheduleBuffer: Record "Project Budget Line Buffer"; PostedDocNo: Code[20]; ReceivedFromType: Option " ","Marketing Member","Bond Holder"; ReceivedFrom: Code[20])
    var
        BondPaymentEntry: Record "Unit Payment Entry";
        Bond: Record "Confirmed Order";
        OverrideMIS: Record "Job Allocation";
        LineNo: Integer;
    begin
    end;


    procedure PostBondPayment(Bond: Record "Confirmed Order"; FromBatchPost: Boolean)
    var
        Application: Record Application;
        BondPaymentEntry: Record "Unit Payment Entry";
        PostedDocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AmountRecd: Decimal;
        Application1: Record Application;
    begin
        BondSetup.GET;
        CheckPaymentPlanDetails(Bond); //BBG080914
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
        BondPaymentEntry.SETRANGE("Document No.", Bond."No.");
        BondPaymentEntry.SETRANGE(Posted, FALSE);
        IF BondPaymentEntry.FINDFIRST THEN BEGIN
            IF BondPaymentEntry."Posted Document No." = '' THEN BEGIN
                //ALLEDK 150113
                IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::AJVM THEN BEGIN
                    BondSetup.TESTFIELD(BondSetup."Transfer Member Temp Name");
                    BondSetup.TESTFIELD(BondSetup."Transfer Member Batch Name");
                    BondSetup.TESTFIELD(BondSetup."Associate to Member No. Series");
                    PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Associate to Member No. Series", WORKDATE, TRUE);
                END ELSE
                    IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::MJVM THEN BEGIN
                        BondSetup.TESTFIELD(BondSetup."Transfer Member Temp Name");
                        BondSetup.TESTFIELD(BondSetup."Transfer Member Batch Name");
                        BondSetup.TESTFIELD(BondSetup."Member to Member No. Series");
                        PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Member to Member No. Series", WORKDATE, TRUE);
                    END ELSE
                        //ALLEDK 150113
                        IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::JV THEN BEGIN
                            PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Cheque Bounce JV No. Series", WORKDATE, TRUE);
                        END ELSE BEGIN
                            PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
                        END;
                BondPaymentEntry."Posted Document No." := PostedDocNo;
                BondPaymentEntry.MODIFY;
            END;
        END;
        JnlPostingDocNo := PostedDocNo;   //ALLETDK
        CLEAR(BondPaymentEntry);
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
        BondPaymentEntry.SETRANGE("Document No.", Bond."No.");
        BondPaymentEntry.SETRANGE(Posted, FALSE);//ALLE PS
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                BondPaymentEntry."Unit Code" := Bond."Unit Code";//ALLETDK141112
                BondPaymentEntry."Installment No." := 1;
                BondPaymentEntry."Posted Document No." := PostedDocNo;
                BondPaymentEntry.MODIFY;
                IF (BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::Cash) AND
                  (BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::"Refund Cash") THEN
                    Bond."With Cheque" := TRUE
                ELSE
                    Bond."With Cheque" := FALSE;
            UNTIL BondPaymentEntry.NEXT = 0;
        CLEAR(BondMgmt);
        BondMgmt.InitTempBonusEntry;
        IF FromBatchPost THEN
            InterCreateBondGenJnlLines(Bond, 'Bond posted')   //071214  1806
        ELSE
            CreateBondGenJnlLines(Bond, 'Bond posted');       //ALLETDK

        BondPost.InsertBonusEntry(Bond."With Cheque");

        CLEAR(BondPaymentEntry);
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
        BondPaymentEntry.SETRANGE("Document No.", Bond."No.");
        BondPaymentEntry.SETRANGE(Posted, FALSE);//ALLE PS
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                BondPaymentEntry.Posted := TRUE;
                BondPaymentEntry.MODIFY;
            UNTIL BondPaymentEntry.NEXT = 0;
        //UpdateAppPaymentEntries(Bond."No.",PostedDocNo);
        UpdateAppPaymentEntries(Bond."No.", JnlPostingDocNo);
        AmountRecd := Bond.AmountRecdAppl(Bond."No.");
        IF AmountRecd >= Bond."Min. Allotment Amount" THEN
            UpdateStagingtable(Bond."No.");
    end;


    procedure CreateStagingTableAppBond(Application: Record "Confirmed Order"; InstallmentNo: Integer; YearCode: Integer; MilestoneCode: Code[10]; ChequeNo: Code[20]; CommTree: Boolean; DirectAss: Boolean; PostDate: Date; BaseAmount: Decimal; RecUPayEntry1: Record "Unit Payment Entry"; CommHold: Boolean; MilestoneProcess: Boolean)
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
        AmountRecd: Decimal;
        BaseAmt: Decimal;
        RespCenter: Record "Responsibility Center 1";
        NewminAmt: Decimal;
    begin
        //CreateStagingTableApplication
        Bond.GET(Application."No.");                                                              //ALLETDK
        AmountRecd := Bond.AmountRecdAppl(Application."No.");


        IF RespCenter.GET(Bond."Shortcut Dimension 1 Code") THEN
            IF RespCenter."Milestone Enabled" THEN
                MilestoneProcess := TRUE;


        IF MilestoneProcess THEN BEGIN    //230120
            BaseAmt := UpdateUnit_ComBufferAmt(RecUPayEntry1, FALSE);
        END ELSE
            IF Bond."Commission Hold on Full Pmt" THEN
                BaseAmt := NewUpdateUnit_ComBufferAmt(RecUPayEntry1, FALSE)
            ELSE BEGIN
                IF (RecUPayEntry1."Commision Applicable") THEN
                    BaseAmt := RecUPayEntry1.Amount;
                IF (RecUPayEntry1."Direct Associate") THEN    //120219
                    BaseAmt := RecUPayEntry1.Amount;
            END;

        IF BaseAmt <> 0 THEN BEGIN
            InitialStagingTab.INIT;
            InitialStagingTab."Unit No." := Application."No.";           //ALLETDk
            InitialStagingTab."Installment No." := InstallmentNo + 1;
            InitialStagingTab."Posting Date" := PostDate; //ALLEDK 130113
            InitialStagingTab.VALIDATE("Introducer Code", Application."Introducer Code");  //ALLETDK
            InitialStagingTab."Base Amount" := BaseAmt; //ALLEDK 211014
            InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
            InitialStagingTab.Duration := Application.Duration;
            InitialStagingTab."Year Code" := YearCode;
            InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
            InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
            InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
            InitialStagingTab."Application No." := Application."No."; //ALLETDK
            InitialStagingTab."Paid by cheque" := ByCheque;                   //ALLETDK
            InitialStagingTab."Cheque No." := ChequeNo;
            InitialStagingTab."Milestone Code" := MilestoneCode;
            InitialStagingTab."Bond Created" := TRUE;
            IF AmountRecd < Bond."Min. Allotment Amount" THEN
                InitialStagingTab."Min. Allotment Amount Not Paid" := TRUE;

            IF (CommTree = FALSE) AND (DirectAss = FALSE) THEN
                InitialStagingTab."Commission Created" := TRUE;

            IF InitialStagingTab."Paid by cheque" THEN BEGIN
                InitialStagingTab."Cheque not Cleared" := TRUE;
            END;

            IF MilestoneCode = '001' THEN BEGIN
                InitialStagingTab."Min. Allotment Amount Not Paid" := FALSE;
                InitialStagingTab."Cheque not Cleared" := FALSE;
            END;

            InitialStagingTab."Charge Code" := RecUPayEntry1."Charge Code";
            InitialStagingTab."Unit Payment Line No." := RecUPayEntry1."Line No.";
            InitialStagingTab."Creation Date" := TODAY;
            InitialStagingTab."Direct Associate" := DirectAss;
            //Code added Start 26092025

            NewminAmt := 0;
            NewminAmt := PPLANCommissonCalculate(Application);
            IF NewminAmt > 0 then begin
                IF RecUPayEntry1."Charge Code" = 'PPLAN' THEN
                    IF Application."Commission Hold on Full Pmt" then
                        InitialStagingTab."Comm Not Release after FullPmt" := True;
            end ELSE
                InitialStagingTab."Comm Not Release after FullPmt" := CommHold;

            //Code added END 26092025

            //InitialStagingTab."Comm Not Release after FullPmt" := CommHold;  //code commented 26092025
            InitialStagingTab.INSERT;
        END;
    end;


    procedure CreateStagingTableApplication1(Application: Record Application; InstallmentNo: Integer; YearCode: Integer; MilestoneCode: Code[10]; CommTree: Boolean; DirectAss: Boolean)
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
    begin
        //CreateStagingTableApplication
        IF InitialStagingTab.GET(Application."Unit No.", InstallmentNo) THEN
            EXIT;

        InitialStagingTab.INIT;
        InitialStagingTab."Unit No." := Application."Unit No.";
        InitialStagingTab."Installment No." := InstallmentNo;
        InitialStagingTab."Posting Date" := Application."Posting Date";
        InitialStagingTab.VALIDATE("Introducer Code", Application."Associate Code");
        InitialStagingTab."Base Amount" := Application."Investment Amount";
        InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
        InitialStagingTab.Duration := Application.Duration;
        InitialStagingTab."Year Code" := YearCode;
        InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
        InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
        InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
        InitialStagingTab."Application No." := Application."Application No.";
        InitialStagingTab."Paid by cheque" := Application."With Cheque";
        CommEntry.RESET;
        CommEntry.SETCURRENTKEY("Application No.", "Installment No.");
        CommEntry.SETRANGE("Application No.", InitialStagingTab."Unit No.");
        CommEntry.SETRANGE("Installment No.", InitialStagingTab."Installment No.");
        InitialStagingTab."Commission Created" := NOT CommEntry.ISEMPTY;
        InitialStagingTab."Milestone Code" := MilestoneCode;
        IF (CommTree = FALSE) AND (DirectAss = FALSE) THEN
            InitialStagingTab."Commission Created" := TRUE;
        IF MilestoneCode <> '001' THEN
            InitialStagingTab."Bond Created" := TRUE;
        InitialStagingTab."Direct Associate" := DirectAss;
        InitialStagingTab.INSERT;
    end;


    procedure CreateStagingTableAppCHQCL(Application: Record Application; InstallmentNo: Integer; YearCode: Integer)
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
    begin
        //CreateStagingTableApplication
        IF InitialStagingTab.GET(Application."Unit No.", InstallmentNo) THEN
            EXIT;

        InitialStagingTab.INIT;
        InitialStagingTab."Unit No." := Application."Unit No.";
        InitialStagingTab."Installment No." := InstallmentNo;
        InitialStagingTab."Posting Date" := Application."Posting Date";
        InitialStagingTab.VALIDATE("Introducer Code", Application."Associate Code");
        InitialStagingTab."Base Amount" := Application."Amount Received" - Application."Service Charge Amount";
        InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
        InitialStagingTab.Duration := Application.Duration;
        InitialStagingTab."Year Code" := YearCode;
        InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
        InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
        InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
        InitialStagingTab."Application No." := Application."Application No.";
        InitialStagingTab."Paid by cheque" := Application."With Cheque";
        InitialStagingTab."Bond Created" := Bond.GET(InitialStagingTab."Unit No.");
        CommEntry.RESET;
        CommEntry.SETCURRENTKEY("Application No.", "Installment No.");
        CommEntry.SETRANGE("Application No.", InitialStagingTab."Unit No.");
        CommEntry.SETRANGE("Installment No.", InitialStagingTab."Installment No.");
        InitialStagingTab."Commission Created" := NOT CommEntry.ISEMPTY;
        InitialStagingTab.INSERT;
    end;


    procedure CreateStagingTableBondCHQCL(Application: Record Application; InstallmentNo: Integer; YearCode: Integer)
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
    begin
        //CreateStagingTableApplication
        IF InitialStagingTab.GET(Application."Unit No.", InstallmentNo) THEN
            EXIT;

        InitialStagingTab.INIT;
        InitialStagingTab."Unit No." := Application."Unit No.";
        InitialStagingTab."Installment No." := InstallmentNo;
        InitialStagingTab."Posting Date" := Application."Posting Date";
        InitialStagingTab.VALIDATE("Introducer Code", Application."Associate Code");
        InitialStagingTab."Base Amount" := Application."Amount Received" - Application."Service Charge Amount";
        InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
        InitialStagingTab.Duration := Application.Duration;
        InitialStagingTab."Year Code" := YearCode;
        InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
        InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
        InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
        InitialStagingTab."Application No." := Application."Application No.";
        InitialStagingTab."Paid by cheque" := Application."With Cheque";
        InitialStagingTab."Bond Created" := Bond.GET(InitialStagingTab."Unit No.");
        CommEntry.RESET;
        CommEntry.SETCURRENTKEY("Application No.", "Installment No.");
        CommEntry.SETRANGE("Application No.", InitialStagingTab."Unit No.");
        CommEntry.SETRANGE("Installment No.", InitialStagingTab."Installment No.");
        InitialStagingTab."Commission Created" := NOT CommEntry.ISEMPTY;
        InitialStagingTab.INSERT;
    end;


    procedure RegisterBond(var pBond: Record "Confirmed Order")
    var
        UnitMaster: Record "Unit Master";
    begin
        //!Bond Registration
        UserSetup.GET(USERID);
        BondSetup.GET;
        BondSetup.TESTFIELD(BondSetup."Revenue A/C");
        BondSetup.TESTFIELD(BondSetup."Registration No. Series");
        CheckPaymentStatus(pBond);
        IF (pBond.Status IN [pBond.Status::Cancelled, pBond.Status::Registered]) THEN
            ERROR(Text011, pBond.Status);
        pBond.TESTFIELD("Registration No.");
        pBond.TESTFIELD("Registration Date");
        //  CreateGenJnlLinesForBondReg(pBond);  //ALLEDK 230213
        ReleaseBondApplication.InsertBondHistory(pBond."No.", 'UNIT REGISTERED.', 1, pBond."Application No.");
        pBond.Status := pBond.Status::Registered;
        pBond."Sales Invoice Applicable" := TRUE;
        pBond.MODIFY;
        UnitMaster.GET(pBond."Unit Code");
        UnitMaster.Status := UnitMaster.Status::Registered;
        UnitMaster.MODIFY;

        WebAppService.UpdateUnitStatus(UnitMaster);  //210624
    end;


    procedure CheckPaymentStatus(pBond: Record "Confirmed Order")
    var
        BondPaymentEntry: Record "Unit Payment Entry";
        CalculatedAmount: Decimal;
    begin
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
        BondPaymentEntry.SETRANGE("Document No.", pBond."No.");
        BondPaymentEntry.SETRANGE(Posted, TRUE);
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                CalculatedAmount += BondPaymentEntry.Amount;
                IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN BEGIN
                    IF BondPaymentEntry."Cheque Status" <> BondPaymentEntry."Cheque Status"::Cleared THEN
                        ERROR(Text013, BondPaymentEntry."Cheque No./ Transaction No.", pBond."No.");
                END;
            UNTIL BondPaymentEntry.NEXT = 0;
        IF (CalculatedAmount + 1) < pBond.Amount THEN  //ALLEDK 250113
            ERROR(Text012, pBond."No.");
    end;


    procedure CreateGenJnlLinesForBondReg(pBond: Record "Confirmed Order")
    var
        Cust: Record Customer;
        BondPostingGroup1: Record "Customer Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Line: Integer;
        NarrationText1: Text[50];
        NarrationText2: Text[50];
    begin
        UnitSetup.GET;
        IF Cust.GET(pBond."Customer No.") THEN;
        NarrationText1 := 'BOND REGISTERED. - ' + COPYSTR(Cust.Name, 1, 30);
        NarrationText2 := 'MM Code(' + pBond."Customer No." + ') ' + COPYSTR(Cust.Name, 1, 30);

        GenJnlLine.DELETEALL;
        Line := 10000;

        //!Bond Registration
        GenJnlLine.INIT;
        GenJnlLine."Line No." := Line;
        GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
        GenJnlLine.VALIDATE("Posting Date", WORKDATE);
        GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(BondSetup."Registration No. Series", WORKDATE, TRUE);
        ;
        GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", pBond."Customer No.");
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Posting No. Series", BondSetup."Registration No. Series");
        GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Revenue A/C");
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
        GenJnlLine."Bond Posting Group" := pBond."Bond Posting Group";
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
        GenJnlLine.VALIDATE("Source No.", pBond."Customer No.");
        GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        GenJnlLine."Branch Code" := UserSetup."User Branch";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Introducer Code" := pBond."Introducer Code";
        GenJnlLine."Unit No." := pBond."Unit Code";
        GenJnlLine.VALIDATE("Debit Amount", pBond.Amount);
        GenJnlLine.INSERT;

        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
          0, 1, NarrationText1);
        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
          0, 2, NarrationText2);

        Line := Line + 10000;
        PostGenJnlLines(GenJnlLine."Document No.");
    end;


    procedure UpdateAppPaymentEntries(AppNo: Code[20]; PostedDocumentNo: Code[20])
    var
        AppPaymentEntry: Record "Application Payment Entry";
        LBond: Record "Confirmed Order";
    begin
        AppPaymentEntry.RESET;
        IF LBond.GET(AppNo) THEN;
        AppPaymentEntry.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::BOND);
        AppPaymentEntry.SETRANGE("Document No.", AppNo);
        AppPaymentEntry.SETRANGE(Posted, FALSE);
        IF AppPaymentEntry.FINDSET THEN
            REPEAT
                AppPaymentEntry."Posted Document No." := PostedDocumentNo;
                AppPaymentEntry.Posted := TRUE;
                AppPaymentEntry.MODIFY;
            UNTIL AppPaymentEntry.NEXT = 0;
    end;


    procedure ChequeBounce(var BondPaymentEntry: Record "Unit Payment Entry")
    var
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        BondPostingGroup1: Record "Customer Posting Group";
        Application: Record Application;
        BondPaymentEntry2: Record "Unit Payment Entry";
        RDPmtSchBuff: Record "Template Field";
        RDPaymentScheduleBuffer: Record "Template Field";
        BondPaymentEntry3: Record "Unit Payment Entry";
        BondPaymentEntryCount: Integer;
        BondPmtEntXChqQ: Record "Quote Properties";
        Bond: Record "Confirmed Order";
        AppPaymentEntry: Record "Application Payment Entry";
        ApplicationAmount: Decimal;
        BondAmount: Decimal;
    begin
        //CreateGenJnlLinesForClChq
        BondSetup.GET;
        UnitSetup.GET;
        BondSetup.TESTFIELD("Cr. Source Code");
        Line := 10000;
        BondPaymentEntryCount := BondPaymentEntry.COUNT;
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                BondPaymentEntry.CALCFIELDS(Reversed);
                BondPaymentEntry.TESTFIELD(Reversed, FALSE);
                IF BondPaymentEntry.Amount > 0 THEN BEGIN
                    PaymentMethod.GET(BondPaymentEntry."Payment Method");
                    BankAccount.GET(BondPaymentEntry."Deposit/Paid Bank");
                    BankAccountPostingGroup.GET(BankAccount."Bank Acc. Posting Group");
                    GenJnlLine.INIT;
                    GenJnlLine."Line No." := Line;
                    IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application THEN BEGIN
                        //ALLETDK081112--BEGIN
                        ApplicationAmount += BondPaymentEntry.Amount;
                        /*
                        Application.GET("Document No.");
                        GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                        GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";

                        IF Application."Posting Date" < 070412D THEN BEGIN
                          GenJnlLine.VALIDATE("Posting Date",WORKDATE);
                          GenJnlLine.VALIDATE("Document Date",TODAY);
                        END ELSE BEGIN
                          GenJnlLine.VALIDATE("Posting Date",BondPaymentEntry."Posting date");
                          GenJnlLine.VALIDATE("Document Date",Application."Document Date");
                        END;
                        GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
                        GenJnlLine.VALIDATE("Account No.",Application."Customer No.");
                        GenJnlLine.VALIDATE("Debit Amount",Amount);
                        ApplicationAmount+=Amount;
                        //ALLETDK021112..END
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                        GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                        GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                        GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                        GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                        GenJnlLine."Branch Code" := UserSetup."Branch Code";
                        GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
                        GenJnlLine."System-Created Entry" := TRUE;
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type" ::Running; //ALLETDK081112
                        GenJnlLine."Introducer Code" := Application."Associate Code";
                        GenJnlLine."Unit No." := Application."Unit No.";
                        GenJnlLine."Cheque No." := "Cheque No./ Transaction No.";
                        GenJnlLine."Cheque Date" := "Cheque Date";
                        GenJnlLine."Installment No." := "Installment No.";
                        GenJnlLine.INSERT;
                        Line := Line + 10000;
                        */
                        //ALLETDK081112--END
                        //ALLETDK021112..COMMENT BEGIN
                        /*
                        //Credit
                        PaymentMethod.GET("Payment Method");
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                        GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                        GenJnlLine."Line No." := Line;

                        IF Application."Posting Date" < 070412D THEN BEGIN
                          GenJnlLine.VALIDATE("Posting Date",WORKDATE);
                          GenJnlLine.VALIDATE("Document Date",TODAY);
                        END ELSE BEGIN
                          GenJnlLine.VALIDATE("Posting Date",BondPaymentEntry."Posting date");
                          GenJnlLine.VALIDATE("Document Date",Application."Document Date");
                        END;

                        GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
                        GenJnlLine.VALIDATE("Account No.",Application."Customer No.");
                //        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type" ::Sale;
                        GenJnlLine.VALIDATE("Debit Amount",Amount);
                        GenJnlLine.Description := Description;
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                        GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type" ::Running;
                        BondPostingGroup1.GET(Application."Bond Posting Group");
                        GenJnlLine."Bond Posting Group" := Application."Customer No.";
                        GenJnlLine."Posting Group" := Application."Bond Posting Group";
                        GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                        GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                        GenJnlLine."Branch Code" := UserSetup."Branch Code";
                        GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                        GenJnlLine."Milestone Code" := BondPaymentEntry."Milestone Code";

                        GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                        GenJnlLine."System-Created Entry" := TRUE;

                        GenJnlLine."Introducer Code" := Application."Associate Code";
                        //GenJnlLine."Payment A/C No." := PaymentMethod."Bal. Account No.";
                        GenJnlLine."Unit No." := Application."Unit No.";
                        GenJnlLine."Cheque No." := "Cheque No./ Transaction No.";
                        GenJnlLine."Cheque Date" := "Cheque Date";
                        GenJnlLine."Installment No." := "Installment No.";
                        GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                        GenJnlLine.INSERT;
                        Line := Line + 10000;
                        */
                        //ALLETDK021112..COMMENT END
                    END ELSE
                        IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::BOND THEN BEGIN
                            //ALLETDK081112--BEGIN
                            BondAmount += BondPaymentEntry.Amount;
                            /*
                            Bond.GET("Document No.");
                            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";

                            IF Bond."Posting Date" < 070412D THEN BEGIN
                              GenJnlLine.VALIDATE("Posting Date",WORKDATE);
                              GenJnlLine.VALIDATE("Document Date",TODAY);
                            END ELSE BEGIN
                              GenJnlLine.VALIDATE("Posting Date","Posting date");
                              GenJnlLine.VALIDATE("Document Date","Document Date");
                            END;
                            //ALLETDK021112..BEGIN
                            {
                            GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"G/L Account");
                            GenJnlLine.VALIDATE("Account No.",PaymentMethod."Bal. Account No.");
                            }
                            GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
                            GenJnlLine.VALIDATE("Account No.",Bond."Customer No.");
                            BondAmount+=Amount;
                            //ALLETDK021112..END
                            GenJnlLine.VALIDATE("Debit Amount",Amount);
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                            GenJnlLine."Document No." := "Posted Document No.";
                            GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
                            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                            GenJnlLine."Branch Code" := UserSetup."Branch Code";
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type" ::Running; //ALLETDK021112
                            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                            GenJnlLine."System-Created Entry" := TRUE;

                            GenJnlLine."Introducer Code" := Bond."Introducer Code";
                            GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                            GenJnlLine."Milestone Code" := BondPaymentEntry."Milestone Code";

                            //GenJnlLine."Unit No." := Bond."No."; //ALLETDK141112
                            GenJnlLine."Unit No." := Bond."Unit No."; //ALLETDK141112
                            GenJnlLine."Cheque No." := "Cheque No./ Transaction No.";
                            GenJnlLine."Cheque Date" := "Cheque Date";
                            GenJnlLine."Installment No." := "Installment No.";
                            GenJnlLine."Paid To/Received From Code" := Bond."Received From Code";
                            GenJnlLine.INSERT;
                            Line := Line + 10000;
                            */
                            //ALLETDK021112..END
                            //ALLETDK021112..COMMENT CODE BEGIN
                            /*
                            //Credit
                            PaymentMethod.GET("Payment Method");
                            GenJnlLine.INIT;
                            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                            GenJnlLine."Line No." := Line;

                            IF Bond."Posting Date" < 070412D THEN BEGIN
                              GenJnlLine.VALIDATE("Posting Date",WORKDATE);
                              GenJnlLine.VALIDATE("Document Date",TODAY);
                            END ELSE BEGIN
                              GenJnlLine.VALIDATE("Posting Date","Posting date");
                              GenJnlLine.VALIDATE("Document Date","Document Date");
                            END;

                            GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
                            GenJnlLine.VALIDATE("Account No.",Application."Customer No.");
                    //        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type" ::Sale;
                            GenJnlLine.VALIDATE("Debit Amount",Amount);
                            GenJnlLine.Description := Description;
                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type" ::Running;
                            GenJnlLine."Document No." := "Posted Document No.";
                            BondPostingGroup1.GET(Bond."Bond Posting Group");
                            GenJnlLine."Bond Posting Group" := Bond."Customer No.";
                            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
                            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                            GenJnlLine."Branch Code" := UserSetup."Branch Code";
                            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                            GenJnlLine."System-Created Entry" := TRUE;

                            GenJnlLine."Introducer Code" := Bond."Introducer Code";
                            //GenJnlLine."Payment A/C No." := PaymentMethod."Bal. Account No.";
                            //GenJnlLine."Unit No." := Bond."No.";     //ALLETDK141112
                            GenJnlLine."Unit No." := Bond."Unit No."; //ALLETDK141112
                            GenJnlLine."Cheque No." := "Cheque No./ Transaction No.";
                            GenJnlLine."Cheque Date" := "Cheque Date";
                            GenJnlLine."Installment No." := "Installment No.";
                            GenJnlLine."Paid To/Received From Code" := Bond."Received From Code";
                            GenJnlLine.INSERT;
                            Line := Line + 10000;
                            */
                            //ALLETDK021112..COMMENT CODE END
                        END;

                    BondPaymentEntry2.RESET;
                    BondPaymentEntry2.SETRANGE("Document Type", BondPaymentEntry."Document Type");
                    BondPaymentEntry2.SETRANGE("Document No.", BondPaymentEntry."Document No.");
                    BondPaymentEntry2.SETFILTER("Line No.", '<>%1', BondPaymentEntry."Line No.");
                    BondPaymentEntry2.SETRANGE(BondPaymentEntry2."Payment Mode", 2, 3);//Cheque,DD
                    BondPaymentEntry2.SETFILTER("Cheque Status", '<>%1', BondPaymentEntry2."Cheque Status"::Bounced);
                    IF BondPaymentEntry2.ISEMPTY THEN BEGIN
                        IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application THEN BEGIN
                            Application.GET(BondPaymentEntry."Application No.");
                            Application."Cheque Cleared" := TRUE;
                            Application.MODIFY;
                            ReleaseBondApplication.InsertBondHistory(Application."Unit No.", 'Cheque Bounced.', 0, Application."Application No.");
                        END;
                    END;
                END;

                BondPaymentEntry2.RESET;
                BondPaymentEntry2.SETRANGE("Document Type", BondPaymentEntry."Document Type");
                BondPaymentEntry2.SETRANGE("Document No.", BondPaymentEntry."Document No.");
                BondPaymentEntry2.SETRANGE("Line No.", BondPaymentEntry."Line No.");
                IF BondPaymentEntry2.FINDFIRST THEN BEGIN
                    BondPaymentEntry2."Cheque Status" := BondPaymentEntry2."Cheque Status"::Bounced;
                    //BondPaymentEntry2."Cheque Clearance Date" := Workdate;
                    BondPaymentEntry2.MODIFY;
                    // ALLEPG 080812 Start
                    AppPaymentEntry.RESET;
                    AppPaymentEntry.SETRANGE("Document No.", BondPaymentEntry2."Document No.");
                    AppPaymentEntry.SETRANGE("Cheque No./ Transaction No.", BondPaymentEntry2."Cheque No./ Transaction No.");
                    IF AppPaymentEntry.FINDFIRST THEN BEGIN
                        REPEAT   //ALLETDK141112
                            AppPaymentEntry."Cheque Status" := AppPaymentEntry."Cheque Status"::Bounced;
                            AppPaymentEntry.MODIFY;
                        UNTIL AppPaymentEntry.NEXT = 0; //ALLETDK141112
                    END;
                    // ALLEPG 080812 End

                    DeleteStagingtableChq(BondPaymentEntry2."Document No.", BondPaymentEntry2."Cheque No./ Transaction No.");
                    //Bonus Creation Buffer for existing Chq Pmt Entry
                    /*IF BondPaymentEntry2."Posting date" <= 040612D THEN BEGIN
                      BondPmtEntXChqQ.INIT;
                      BondPmtEntXChqQ.TRANSFERFIELDS(BondPaymentEntry2);
                      IF BondPmtEntXChqQ.INSERT THEN;
                    END;
                     */
                    IF BondPaymentEntry2."Document Type" = BondPaymentEntry2."Document Type"::Application THEN BEGIN
                        IF BondPaymentEntry3.GET(BondPaymentEntry3."Document Type"::BOND, BondPaymentEntry2."Unit Code", BondPaymentEntry2."Line No."
                 )
                         THEN BEGIN
                            BondPaymentEntry3."Cheque Status" := BondPaymentEntry2."Cheque Status";
                            //BondPaymentEntry3."Cheque Clearance Date" := Workdate;
                            BondPaymentEntry3.MODIFY;
                        END;
                    END;
                END;
                BondPaymentEntryCount -= 1;
                IF BondPaymentEntryCount > 0 THEN
                    IF BondPaymentEntry.NEXT = 0 THEN;
            UNTIL BondPaymentEntryCount = 0;

        //ALLETDK021112..BEGIN
        //CREDIT
        IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application THEN BEGIN
            BankAccount.GET(BondPaymentEntry."Deposit/Paid Bank");
            BankAccountPostingGroup.GET(BankAccount."Bank Acc. Posting Group");
            GenJnlLine.INIT;
            GenJnlLine."Line No." := Line;
            Application.GET(BondPaymentEntry."Document No.");
            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            PaymentMethod.GET(BondPaymentEntry."Payment Method");
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := Line;
            IF Application."Posting Date" < 20120407D THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", TODAY);
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date");
                GenJnlLine.VALIDATE("Document Date", Application."Document Date");
            END;
            //ALLETDK081112..BEGIN
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", Application."Customer No.");
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Bal. Account No.", PaymentMethod."Bal. Account No.");
            GenJnlLine.VALIDATE("Debit Amount", ApplicationAmount);
            //ALLETDK081112..END
            GenJnlLine.Description := BondPaymentEntry.Description;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
            GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            BondPostingGroup1.GET(Application."Bond Posting Group");
            GenJnlLine."Bond Posting Group" := Application."Customer No.";
            GenJnlLine."Branch Code" := BondPaymentEntry."Branch Code"; //ALLETDK141112
            GenJnlLine."Posting Group" := Application."Bond Posting Group";
            GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
            GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
            GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Application."Associate Code";
            GenJnlLine."Unit No." := Application."Unit Code";//ALLETDK141112
            GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10);//ALLE-AM
            GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
            GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
            GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
            GenJnlLine.INSERT;
        END ELSE
            IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::BOND THEN BEGIN
                Bond.GET(BondPaymentEntry."Document No.");
                PaymentMethod.GET(BondPaymentEntry."Payment Method");
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := Line;
                IF Bond."Posting Date" < 20120407D THEN BEGIN
                    GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                    GenJnlLine.VALIDATE("Document Date", TODAY);
                END ELSE BEGIN
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date");
                    GenJnlLine.VALIDATE("Document Date", BondPaymentEntry."Document Date");
                END;
                //ALLETDK081112..BEGIN
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.VALIDATE("Account No.", Bond."Customer No.");
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Bal. Account No.", PaymentMethod."Bal. Account No.");
                GenJnlLine.VALIDATE("Debit Amount", BondAmount);
                //ALLETDK081112..END
                GenJnlLine.Description := BondPaymentEntry.Description;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                BondPostingGroup1.GET(Bond."Bond Posting Group");
                GenJnlLine."Bond Posting Group" := Bond."Customer No.";
                GenJnlLine."Posting Group" := Bond."Bond Posting Group";
                GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                GenJnlLine."Branch Code" := BondPaymentEntry."Branch Code"; //ALLETDK141112
                GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Introducer Code" := Bond."Introducer Code";
                GenJnlLine."Unit No." := Bond."Unit Code"; //ALLETDK141112
                GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10);//ALLE-AM
                GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                GenJnlLine."Paid To/Received From Code" := Bond."Received From Code";
                GenJnlLine.INSERT;
            END;
        //ALLETDK021112..END

        PostGenJnlLines(GenJnlLine."Document No.");

    end;


    procedure CreateStagingTableBondPayEntry(BondPaymentEntry: Record "Unit Payment Entry"; InstallmentNo: Integer; YearCode: Integer; MilestoneCode: Code[10]; CommTree: Boolean; DirectAss: Boolean; MilestoneProcess: Boolean)
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
        AppLicationRec: Record Application;
        AmountRecd: Decimal;
        BaseAmt: Decimal;
        RespCenter: Record "Responsibility Center 1";
    begin
        AppLicationRec.GET(BondPaymentEntry."Application No.");
        AmountRecd := AppLicationRec.AmountRecdAppl(BondPaymentEntry."Document No.");

        IF RespCenter.GET(AppLicationRec."Shortcut Dimension 1 Code") THEN
            IF RespCenter."Milestone Enabled" THEN
                MilestoneProcess := TRUE;


        //230120 code comment and new
        /*
        IF MilestoneProcess THEN
          BaseAmt := UpdateUnit_ComBufferAmt(BondPaymentEntry,TRUE)
        ELSE
          BaseAmt := NewUpdateUnit_ComBufferAmt(BondPaymentEntry,TRUE);
         */

        IF MilestoneProcess THEN BEGIN    //230120
            BaseAmt := UpdateUnit_ComBufferAmt(BondPaymentEntry, TRUE);
        END ELSE
            IF Bond."Commission Hold on Full Pmt" THEN
                BaseAmt := NewUpdateUnit_ComBufferAmt(BondPaymentEntry, TRUE)
            ELSE BEGIN
                IF (BondPaymentEntry."Commision Applicable") THEN
                    BaseAmt := BondPaymentEntry.Amount;
                IF (BondPaymentEntry."Direct Associate") THEN    //120219
                    BaseAmt := BondPaymentEntry.Amount;
            END;

        //230120 code comment and new

        IF BaseAmt <> 0 THEN BEGIN
            InitialStagingTab.INIT;
            InitialStagingTab."Unit No." := BondPaymentEntry."Document No.";
            InitialStagingTab."Installment No." := InstallmentNo;
            InitialStagingTab."Posting Date" := BondPaymentEntry."Posting date";
            InitialStagingTab.VALIDATE("Introducer Code", AppLicationRec."Associate Code");
            InitialStagingTab."Base Amount" := BaseAmt; //ALLEDK 211014
            InitialStagingTab.VALIDATE("Project Type", AppLicationRec."Project Type");
            InitialStagingTab.Duration := AppLicationRec.Duration;
            InitialStagingTab."Year Code" := YearCode;
            InitialStagingTab.VALIDATE("Investment Type", AppLicationRec."Investment Type");
            InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", AppLicationRec."Shortcut Dimension 1 Code");
            InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", AppLicationRec."Shortcut Dimension 2 Code");
            InitialStagingTab."Application No." := AppLicationRec."Application No.";
            IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN BEGIN
                InitialStagingTab."Paid by cheque" := TRUE;
                InitialStagingTab."Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";
            END ELSE
                InitialStagingTab."Paid by cheque" := FALSE;
            CommEntry.RESET;
            CommEntry.SETCURRENTKEY("Application No.", "Installment No.");
            CommEntry.SETRANGE("Application No.", InitialStagingTab."Unit No.");
            CommEntry.SETRANGE("Installment No.", InitialStagingTab."Installment No.");
            InitialStagingTab."Commission Created" := NOT CommEntry.ISEMPTY;
            InitialStagingTab."Milestone Code" := MilestoneCode;
            IF (BondPaymentEntry."Commision Applicable" = FALSE) AND (BondPaymentEntry."Direct Associate" = FALSE) THEN
                InitialStagingTab."Commission Created" := TRUE;
            IF AmountRecd < AppLicationRec."Min. Allotment Amount" THEN
                InitialStagingTab."Min. Allotment Amount Not Paid" := TRUE;
            IF InitialStagingTab."Paid by cheque" THEN BEGIN
                InitialStagingTab."Cheque not Cleared" := TRUE;
            END;

            IF MilestoneCode <> '001' THEN
                InitialStagingTab."Bond Created" := TRUE
            ELSE BEGIN
                InitialStagingTab."Min. Allotment Amount Not Paid" := FALSE;
                InitialStagingTab."Cheque not Cleared" := FALSE;
            END;

            InitialStagingTab."Charge Code" := BondPaymentEntry."Charge Code";
            InitialStagingTab."Unit Payment Line No." := BondPaymentEntry."Line No.";
            InitialStagingTab."Creation Date" := TODAY;


            InitialStagingTab."Direct Associate" := BondPaymentEntry."Direct Associate";
            InitialStagingTab.INSERT;
        END;

    end;


    procedure UpdateStagingtable(ApplicationNo: Code[20])
    var
        CommCreateBuffer: Record "Unit & Comm. Creation Buffer";
    begin
        CommCreateBuffer.RESET;
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Unit No.", ApplicationNo);
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Min. Allotment Amount Not Paid", TRUE);
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Cheque not Cleared", FALSE);
        IF CommCreateBuffer.FINDSET THEN
            REPEAT
                CommCreateBuffer."Min. Allotment Amount Not Paid" := FALSE;
                CommCreateBuffer.MODIFY;
            UNTIL CommCreateBuffer.NEXT = 0;
    end;


    procedure UpdateStagingtableChq(ApplicationNo: Code[20]; ChequeNo: Code[20]; ChClearedDate: Date)
    var
        CommCreateBuffer: Record "Unit & Comm. Creation Buffer";
    begin
        CommCreateBuffer.RESET;
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Unit No.", ApplicationNo);
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Paid by cheque", TRUE);
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Cheque No.", ChequeNo);
        IF CommCreateBuffer.FINDSET THEN
            REPEAT
                CommCreateBuffer."Cheque not Cleared" := FALSE;
                CommCreateBuffer."Cheque Cleared Date" := ChClearedDate; //ALLEDK 180113
                CommCreateBuffer.MODIFY;
            UNTIL CommCreateBuffer.NEXT = 0;
    end;


    procedure DeleteStagingtableChq(ApplicationNo: Code[20]; ChequeNo: Code[20])
    var
        CommCreateBuffer: Record "Unit & Comm. Creation Buffer";
    begin
        CommCreateBuffer.RESET;
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Unit No.", ApplicationNo);
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Min. Allotment Amount Not Paid", TRUE);
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Paid by cheque", TRUE);
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Cheque No.", ChequeNo);
        IF CommCreateBuffer.FINDSET THEN
            REPEAT
                CommCreateBuffer.DELETE;
            UNTIL CommCreateBuffer.NEXT = 0;
    end;


    procedure NewPostCommissionVouchers(PaymentMode: Option Cash,Cheque; DocumentNo: Code[20]; var CommVoucherPostingBufferParam: Record "Comm. Voucher Posting Buffer"; PostingNoSeries: Code[10]; PaidTo: Code[20]; GLAmount: Decimal; GLAmtPayment: Decimal; BankNo: Code[20]; ChequeNo: Code[20]; ChequeDate: Date)
    var
        JnlBatch: Code[10];
        PaymentMethod: Record "Payment Method";
        Line: Integer;
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        Vend: Record Vendor;
        RoundingAmount: Decimal;
    begin
        UserSetup.GET(USERID);
        BondSetup.GET;
        BondSetup.TESTFIELD("Commission A/C");
        BondSetup.TESTFIELD("Commission Payable A/C");
        BondSetup.TESTFIELD("Rounding Account(Commission)");
        BondSetup.TESTFIELD("Dr. Source Code");
        BondSetup.TESTFIELD("Travel A/C");

        IF DocumentNo = '' THEN
            ERROR('Document No. has not been generated.');

        IF Vend.GET(PaidTo) THEN;
        NarrationText1 := 'Comm. Paid(' + PaidTo + ') ' + COPYSTR(Vend.Name, 1, 30);

        GenJnlLine.DELETEALL;
        Line := 10000;
        IF CommVoucherPostingBufferParam.FINDSET THEN
            REPEAT
                IF CommVoucherPostingBufferParam."Commission Amount" > 0 THEN BEGIN
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := 'COMMPMT';
                    GenJnlLine."Journal Batch Name" := 'COMMPMT';

                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                    GenJnlLine.VALIDATE("Account No.", CommVoucherPostingBufferParam."Associate Code");
                    GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                    GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
                    GenJnlLine.VALIDATE("Document No.", DocumentNo);
                    GenJnlLine.VALIDATE("Posting No. Series", PostingNoSeries);
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                    GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Cheque No." := CommVoucherPostingBufferParam."Cheque No.";
                    GenJnlLine."Cheque Date" := CommVoucherPostingBufferParam."Cheque Date";
                    GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
                    GenJnlLine.VALIDATE("Debit Amount", CommVoucherPostingBufferParam."Commission Amount" - CommVoucherPostingBufferParam."TDS Amount");
                    GenJnlLine.INSERT;
                    Line := Line + 10000;

                    //Payment by cheque
                    IF PaymentMode <> PaymentMode::Cash THEN BEGIN
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := 'COMMPMT';
                        GenJnlLine."Journal Batch Name" := 'COMMPMT';
                        GenJnlLine."Line No." := Line;
                        GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                        GenJnlLine.VALIDATE("Account No.", BankNo);
                        GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                        GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
                        GenJnlLine.VALIDATE("Document No.", DocumentNo);
                        GenJnlLine.VALIDATE("Posting No. Series", PostingNoSeries);
                        GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                        GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
                        GenJnlLine."Branch Code" := UserSetup."User Branch";
                        GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
                        GenJnlLine."System-Created Entry" := TRUE;

                        GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                        GenJnlLine."Cheque No." := CopyStr(ChequeNo, 1, 10);//ALLE-AM
                        GenJnlLine."BBG Cheque No." := ChequeNo;//ALLE-AM
                        GenJnlLine."Cheque Date" := ChequeDate;
                        GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
                        IF CommVoucherPostingBufferParam.Status <> 0 THEN
                            GenJnlLine.VALIDATE("Credit Amount", ((CommVoucherPostingBufferParam."Commission Amount" - CommVoucherPostingBufferParam."TDS Amount") - CommVoucherPostingBufferParam.Status))
                        ELSE
                            GenJnlLine.VALIDATE("Credit Amount", (CommVoucherPostingBufferParam."Commission Amount" - CommVoucherPostingBufferParam."TDS Amount"));
                        GenJnlLine.Description := FORMAT(PaymentMode) + ' Paid';
                        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                          GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                        GenJnlLine.INSERT;
                        Line := Line + 10000;
                    END ELSE
                        //CashAmount += "Commission Amount" - "TDS Amount";

                        //Cash payment
                        IF PaymentMode = PaymentMode::Cash THEN BEGIN
                            GenJnlLine.INIT;
                            GenJnlLine."Line No." := Line;
                            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                            PaymentMethod.GET('CASH');
                            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                            GenJnlLine.VALIDATE("Account No.", PaymentMethod."Bal. Account No.");
                            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                            GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
                            GenJnlLine.VALIDATE("Document No.", DocumentNo);
                            GenJnlLine.VALIDATE("Posting No. Series", PostingNoSeries);
                            GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                            GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
                            GenJnlLine."Branch Code" := UserSetup."User Branch";
                            GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
                            GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
                            GenJnlLine."System-Created Entry" := TRUE;

                            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                            GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
                            IF CommVoucherPostingBufferParam.Status <> 0 THEN
                                GenJnlLine.VALIDATE("Credit Amount", (CommVoucherPostingBufferParam."Commission Amount" - CommVoucherPostingBufferParam."TDS Amount" - CommVoucherPostingBufferParam.Status))
                            ELSE
                                GenJnlLine.VALIDATE("Credit Amount", CommVoucherPostingBufferParam."Commission Amount" - CommVoucherPostingBufferParam."TDS Amount");
                            GenJnlLine.Description := 'Cash Paid';
                            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                            GenJnlLine.INSERT;
                            Line := Line + 10000;
                        END;

                    //  DuplicateVoucherChecking("Voucher No.");

                    //!Corpus Account
                    IF CommVoucherPostingBufferParam.Status <> 0 THEN BEGIN
                        GenJnlLine.INIT;
                        GenJnlLine."Journal Template Name" := 'COMMPMT';
                        GenJnlLine."Journal Batch Name" := 'COMMPMT';
                        GenJnlLine."Line No." := Line;
                        GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        BondSetup.TESTFIELD("Corpus A/C");
                        GenJnlLine.VALIDATE("Account No.", BondSetup."Corpus A/C");
                        GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                        GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
                        GenJnlLine.VALIDATE("Document No.", DocumentNo);
                        GenJnlLine.VALIDATE("Posting No. Series", PostingNoSeries);
                        GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                        GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
                        GenJnlLine."Branch Code" := UserSetup."User Branch";
                        GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
                        GenJnlLine."System-Created Entry" := TRUE;

                        GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                        GenJnlLine."Cheque No." := CommVoucherPostingBufferParam."Cheque No.";
                        GenJnlLine."Cheque Date" := CommVoucherPostingBufferParam."Cheque Date";
                        GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
                        GenJnlLine.VALIDATE("Credit Amount", CommVoucherPostingBufferParam.Status);
                        GenJnlLine.Description := FORMAT(PaymentMode) + ' Paid';
                        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                          GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                        GenJnlLine.INSERT;
                        Line := Line + 10000;
                    END;
                END;
            UNTIL CommVoucherPostingBufferParam.NEXT = 0;

        // Round Off only for cash payment
        IF GLAmtPayment <> GLAmount THEN BEGIN
            RoundingAmount -= GLAmount - GLAmtPayment;

            GenJnlLine.INIT;
            GenJnlLine."Line No." := Line;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."Rounding Account(Commission)");
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
            GenJnlLine.VALIDATE("Document No.", DocumentNo);
            GenJnlLine.VALIDATE("Posting No. Series", PostingNoSeries);
            GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
            GenJnlLine."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
            GenJnlLine."Branch Code" := UserSetup."User Branch";
            GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
            GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
            GenJnlLine."System-Created Entry" := TRUE;

            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
            GenJnlLine.VALIDATE("Paid To/Received From Code", PaidTo);
            GenJnlLine.VALIDATE(Amount, GLAmtPayment - GLAmount);
            GenJnlLine.INSERT;
            Line := Line + 10000;
        END;

        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.", 0, 1,
          NarrationText1);
        CommVoucherPostingBufferParam.MODIFYALL("Posted Doc. No.", DocumentNo);
        CommVoucherPostingBufferParam.MODIFYALL(Status, CommVoucherPostingBufferParam.Status::Posted);

        PostGenJnlLines(GenJnlLine."Document No.");
    end;


    procedure GetChequeAmount(UnitPayEntry: Record "Unit Payment Entry")
    var
        RUnitPayEntry: Record "Unit Payment Entry";
    begin
        //ALLETDK021112--BEGIN
        CLEAR(ChequeAmount);
        RUnitPayEntry.RESET;
        RUnitPayEntry.SETRANGE("Document Type", UnitPayEntry."Document Type");
        RUnitPayEntry.SETRANGE("Document No.", UnitPayEntry."Document No.");
        RUnitPayEntry.SETRANGE("Cheque No./ Transaction No.", UnitPayEntry."Cheque No./ Transaction No.");
        RUnitPayEntry.SETRANGE("Cheque Status", RUnitPayEntry."Cheque Status"::" "); //ALLETDK061212
        IF RUnitPayEntry.FINDSET THEN
            REPEAT
                ChequeAmount += RUnitPayEntry.Amount;
            UNTIL RUnitPayEntry.NEXT = 0;
        //ALLETDK021112--END
    end;


    procedure CreateApplicationGenJnlLines(Application: Record Application; Description: Text[50])
    var
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
        IF Vend.GET(Application."Associate Code") THEN;
        NarrationText1 := 'Appl. Received - ' + COPYSTR(Application."Customer Name", 1, 30);
        NarrationText2 := 'MM Code(' + Application."Associate Code" + ') ' + COPYSTR(Vend.Name, 1, 30);


        UnitSetup.GET;

        GenJnlLine.RESET;
        GenJnlLine.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        //IF GenJnlLine.Findset then
        GenJnlLine.DELETEALL;

        Line := 10000;
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::Application);
        BondPaymentEntry.SETRANGE("Document No.", Application."Application No.");
        //SETRANGE(Posted,FALSE);
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" IN [BondPaymentEntry."Payment Mode"::Bank, BondPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking",
                BondPaymentEntry."Payment Mode"::"D.D."])) THEN BEGIN
                    ApplBankAmount += BondPaymentEntry.Amount;
                    IF PaymentMethod.GET(BondPaymentEntry."Payment Method") THEN;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    // GenJnlLine.VALIDATE("Posting Date",Application."Posting Date");
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
                    GenJnlLine.VALIDATE("Document Date", Application."Document Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Account No.", BondPaymentEntry."Deposit/Paid Bank");
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := Application."Posted Doc No.";
                    GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                    GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Source No.", BondPaymentEntry."Deposit/Paid Bank");
                    BondPostingGroup1.GET(Application."Bond Posting Group");
                    GenJnlLine."Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Introducer Code" := Application."Associate Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    //GenJnlLine."Application No." :=Application."Application No.";
                    GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                    GenJnlLine."Unit No." := Application."Unit Code";
                    GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10);//ALLE-AM
                    GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                    GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                    GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash THEN
                        GenJnlLine.Description := 'Cash Received'
                    ELSE
                        IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN
                            GenJnlLine.Description := 'Cheque Received'
                        ELSE
                            IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.D." THEN
                                GenJnlLine.Description := 'D.D. Received'
                            ELSE
                                IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking" THEN
                                    GenJnlLine.Description := 'D.C./C.C./Net Banking';

                    GenJnlLine."Payment Mode" := BondPaymentEntry."Payment Mode"; //ALLEDK 030313
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                    Line := Line + 10000;
                END;
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash)) THEN BEGIN
                    CashPmtMethod.GET(BondPaymentEntry."Payment Method");
                    CashAmount += BondPaymentEntry.Amount;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    //GenJnlLine.VALIDATE("Posting Date",Application."Posting Date");
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
                    GenJnlLine.VALIDATE("Document Date", Application."Document Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", UnitReversal.GetCashAccountNo(BondPaymentEntry."User Branch Code"));
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := Application."Posted Doc No.";
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                    BondPostingGroup1.GET(Application."Bond Posting Group");
                    GenJnlLine."Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    //GenJnlLine."Application No." :=Application."Application No.";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Introducer Code" := Application."Associate Code";
                    GenJnlLine."Unit No." := Application."Unit Code";
                    GenJnlLine."Installment No." := 1;
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    IF (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash) THEN
                        GenJnlLine.Description := 'Cash Received'
                    ELSE
                        GenJnlLine.Description := 'Amount transferred';

                    GenJnlLine."Payment Mode" := BondPaymentEntry."Payment Mode"; //ALLEDK 030313
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                    Line := Line + 10000;
                END;

            UNTIL BondPaymentEntry.NEXT = 0;
        IF BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::AJVM THEN BEGIN  //ALLEDK 201212
            IF (ApplBankAmount + CashAmount) <> 0 THEN BEGIN
                PaymentMethod.GET(BondPaymentEntry."Payment Method");
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := Line;
                // GenJnlLine.VALIDATE("Posting Date",Application."Posting Date");
                GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
                GenJnlLine.VALIDATE("Document Date", Application."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.VALIDATE("Account No.", Application."Customer No.");
                GenJnlLine.VALIDATE(Amount, -(ApplBankAmount + CashAmount));
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := Application."Posted Doc No.";
                GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                GenJnlLine."Branch Code" := BondPaymentEntry."User Branch Code";
                //GenJnlLine."Application No." :=Application."Application No.";
                GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
                GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
                BondPostingGroup1.GET(Application."Bond Posting Group");
                GenJnlLine."Posting Group" := Application."Bond Posting Group";
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Introducer Code" := Application."Associate Code";
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10); //ALLE-AM
                GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No."; //ALLE-AM
                GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash THEN
                    GenJnlLine.Description := 'Cash Received'
                ELSE
                    IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN
                        GenJnlLine.Description := 'Cheque Received'
                    ELSE
                        IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.D." THEN
                            GenJnlLine.Description := 'D.D. Received'
                        ELSE
                            IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking" THEN
                                GenJnlLine.Description := 'D.C./C.C./Net Banking';
                GenJnlLine."Payment Mode" := BondPaymentEntry."Payment Mode"; //ALLEDK 030313
                GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                GenJnlLine.INSERT;
                InsertJnDimension(GenJnlLine);  //ALLEDK 310113
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            END;
        END;  //ALLEDK 201212
    end;


    procedure ChequeClearance(var AppPayEntry: Record "Application Payment Entry"; ChequeClearanceDate: Date)
    var
        BondPaymentEntry: Record "Unit Payment Entry";
    begin
        CreateChequeUnitPayEntries(AppPayEntry);
        CLEAR(BondPaymentEntry);
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document No.", AppPayEntry."Application No.");
        BondPaymentEntry.SETRANGE("App. Pay. Entry Line No.", AppPayEntry."Line No.");//ALLETDK2912
        BondPaymentEntry.SETRANGE("Cheque No./ Transaction No.", AppPayEntry."Cheque No./ Transaction No.");
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                RecPostPayment.UpdateChequeEntries(BondPaymentEntry, ChequeClearanceDate);
            UNTIL BondPaymentEntry.NEXT = 0;
    end;


    procedure UpdateChequeEntries(var BondPaymentEntry: Record "Unit Payment Entry"; ClearanceDate: Date)
    var
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        BondPostingGroup1: Record "Customer Posting Group";
        Application: Record Application;
        BondPaymentEntry2: Record "Unit Payment Entry";
        RDPmtSchBuff: Record "Template Field";
        RDPaymentScheduleBuffer: Record "Template Field";
        BondPaymentEntry3: Record "Unit Payment Entry";
        BondPaymentEntryCount: Integer;
        BondPmtEntXChqQ: Record "Quote Properties";
        Bond: Record "Confirmed Order";
        AmountRecd: Decimal;
        AppPaymentEntry: Record "Application Payment Entry";
        BondCreationBuffer: Record "Unit & Comm. Creation Buffer";
    begin
        BondSetup.GET;
        BondSetup.TESTFIELD("Cr. Source Code");
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                IF (BondPaymentEntry."Commision Applicable") OR (BondPaymentEntry."Direct Associate") THEN BEGIN  //130219
                    IF Bond.GET(BondPaymentEntry."Document No.") THEN;
                    BondPaymentEntry.CALCFIELDS(Reversed);
                    BondPaymentEntry.TESTFIELD(Reversed, FALSE);
                    IF ClearanceDate < BondPaymentEntry."Cheque Date" THEN
                        ERROR(Text004, ClearanceDate, BondPaymentEntry."Cheque Date", BondPaymentEntry."Cheque No./ Transaction No.");
                    IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application THEN BEGIN
                        Application.GET(BondPaymentEntry."Document No.");
                        IF NOT BondCreationBuffer.GET(BondPaymentEntry."Document No.", BondPaymentEntry."Line No." / 10000, BondPaymentEntry.Sequence) THEN
                            CreateStagingTableBondPayEntry(BondPaymentEntry, BondPaymentEntry."Line No." / 10000, 1, BondPaymentEntry.Sequence,
                              BondPaymentEntry."Commision Applicable", BondPaymentEntry."Direct Associate", Bond."Old Process");

                        UpdateStagingtableChq(Application."Application No.", BondPaymentEntry."Cheque No./ Transaction No.", ClearanceDate);
                        AmountRecd := Application.AmountRecdAppl(Application."Application No.");
                        IF AmountRecd >= Application."Min. Allotment Amount" THEN
                            UpdateStagingtable(Application."Application No.");
                    END ELSE
                        IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::BOND THEN BEGIN
                            Bond.GET(BondPaymentEntry."Document No.");           //ALLETDK151212
                            IF Bond.Type = Bond.Type::Normal THEN BEGIN
                                CLEAR(BondInvestmentAmt);
                                BondInvestmentAmt := BondPaymentEntry.Amount;
                                CLEAR(ByCheque);
                                IF (BondPaymentEntry."Payment Mode" IN [BondPaymentEntry."Payment Mode"::Bank, BondPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking", BondPaymentEntry."Payment Mode"::"D.D."]) THEN
                                    ByCheque := TRUE
                                ELSE
                                    ByCheque := FALSE;
                                IF (BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::Cash) OR
                                  (BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::"Refund Cash") THEN
                                    Bond."With Cheque" := TRUE;
                                CreateStagingTableAppBond(Bond, BondPaymentEntry."Line No." / 10000, 1, BondPaymentEntry.Sequence,
                                BondPaymentEntry."Cheque No./ Transaction No.", BondPaymentEntry."Commision Applicable", BondPaymentEntry."Direct Associate", BondPaymentEntry."Posting date", BondInvestmentAmt,
                                  BondPaymentEntry, FALSE, Bond."Old Process");
                            END;
                            UpdateStagingtableChq(Bond."Application No.", BondPaymentEntry."Cheque No./ Transaction No.", ClearanceDate);//DateAd18
                        END;                //ALLETDK151212

                    CLEAR(BondPaymentEntry2);
                    BondPaymentEntry2.RESET;
                    BondPaymentEntry2.SETRANGE("Document Type", BondPaymentEntry."Document Type");
                    BondPaymentEntry2.SETRANGE("Document No.", BondPaymentEntry."Document No.");
                    BondPaymentEntry2.SETRANGE("Cheque No./ Transaction No.", BondPaymentEntry."Cheque No./ Transaction No.");
                    BondPaymentEntry2.SETRANGE("Cheque Status", BondPaymentEntry2."Cheque Status"::" ");
                    IF BondPaymentEntry2.FINDSET THEN
                        REPEAT
                            BondPaymentEntry2."Cheque Status" := BondPaymentEntry2."Cheque Status"::Cleared;
                            BondPaymentEntry2."Chq. Cl / Bounce Dt." := ClearanceDate;
                            BondPaymentEntry2.MODIFY;
                        UNTIL BondPaymentEntry2.NEXT = 0;

                    CLEAR(AppPaymentEntry);
                    AppPaymentEntry.RESET;
                    AppPaymentEntry.SETRANGE("Document No.", BondPaymentEntry."Document No.");
                    AppPaymentEntry.SETRANGE("Line No.", BondPaymentEntry."App. Pay. Entry Line No.");
                    AppPaymentEntry.SETRANGE("Cheque No./ Transaction No.", BondPaymentEntry."Cheque No./ Transaction No.");
                    AppPaymentEntry.SETRANGE("Cheque Status", AppPaymentEntry."Cheque Status"::" ");
                    IF AppPaymentEntry.FINDFIRST THEN BEGIN
                        AppPaymentEntry."Cheque Status" := AppPaymentEntry."Cheque Status"::Cleared;
                        AppPaymentEntry."Chq. Cl / Bounce Dt." := ClearanceDate;
                        AppPaymentEntry.MODIFY;
                    END;

                    IF Bond.GET(BondPaymentEntry."Document No.") THEN BEGIN
                        AmountRecd := Bond.AmountRecdAppl(Bond."No.");
                        IF AmountRecd >= Bond."Min. Allotment Amount" THEN
                            UpdateStagingtable(Bond."No.");
                    END;
                END; //130219
                     //170719
                CLEAR(BondPaymentEntry2);
                BondPaymentEntry2.RESET;
                BondPaymentEntry2.SETRANGE("Document Type", BondPaymentEntry."Document Type");
                BondPaymentEntry2.SETRANGE("Document No.", BondPaymentEntry."Document No.");
                BondPaymentEntry2.SETRANGE("Cheque No./ Transaction No.", BondPaymentEntry."Cheque No./ Transaction No.");
                BondPaymentEntry2.SETRANGE("Cheque Status", BondPaymentEntry2."Cheque Status"::" ");
                IF BondPaymentEntry2.FINDSET THEN
                    REPEAT
                        BondPaymentEntry2."Cheque Status" := BondPaymentEntry2."Cheque Status"::Cleared;
                        BondPaymentEntry2."Chq. Cl / Bounce Dt." := ClearanceDate;
                        BondPaymentEntry2.MODIFY;
                    UNTIL BondPaymentEntry2.NEXT = 0;

                CLEAR(AppPaymentEntry);
                AppPaymentEntry.RESET;
                AppPaymentEntry.SETRANGE("Document No.", BondPaymentEntry."Document No.");
                AppPaymentEntry.SETRANGE("Line No.", BondPaymentEntry."App. Pay. Entry Line No.");
                AppPaymentEntry.SETRANGE("Cheque No./ Transaction No.", BondPaymentEntry."Cheque No./ Transaction No.");
                AppPaymentEntry.SETRANGE("Cheque Status", AppPaymentEntry."Cheque Status"::" ");
                IF AppPaymentEntry.FINDFIRST THEN BEGIN
                    AppPaymentEntry."Cheque Status" := AppPaymentEntry."Cheque Status"::Cleared;
                    AppPaymentEntry."Chq. Cl / Bounce Dt." := ClearanceDate;
                    AppPaymentEntry.MODIFY;
                END;
            //170719

            UNTIL BondPaymentEntry.NEXT = 0;
    end;


    procedure CreateBondGenJnlLines(Application: Record "Confirmed Order"; Description: Text[50])
    var
        BondPaymentEntry: Record "Application Payment Entry";
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        Application1: Record Application;
        BondBankAmount: Decimal;
        UnitPayEntry: Record "Unit Payment Entry";
        AVJMAmount: Decimal;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ReConOrd: Record "Confirmed Order";
        PaymentModeJV: Boolean;
        TotalInvAmount_1: Decimal;
        CompanyWiseGL_2: Record "Company wise G/L Account";
        VLEntry_2: Record "Vendor Ledger Entry";
        CalculateTax: Codeunit "Calculate Tax";
    begin
        IF Vend.GET(Application."Introducer Code") THEN;
        AJVM1 := FALSE;
        UserSetup.GET(USERID);
        UnitSetup.GET;
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;

        Line := 10000;
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
        BondPaymentEntry.SETRANGE("Document No.", Application."No.");
        BondPaymentEntry.SETRANGE(Posted, FALSE);
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                IF JnlPostingDocNo = '' THEN BEGIN
                    IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN                //ALLETDK070213
                        JnlPostingDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
                END;
                BondPaymentEntry."Posted Document No." := JnlPostingDocNo;
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" IN [BondPaymentEntry."Payment Mode"::Bank, BondPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking",
                BondPaymentEntry."Payment Mode"::"D.D."])) THEN BEGIN
                    BondBankAmount += BondPaymentEntry.Amount;
                    UnitSetup.GET;
                    PaymentMethod.GET(BondPaymentEntry."Payment Method");
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Account No.", BondPaymentEntry."Deposit/Paid Bank");
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                    GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Source No.", BondPaymentEntry."Deposit/Paid Bank");
                    BondPostingGroup1.GET(Application."Bond Posting Group");
                    GenJnlLine."Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Order Ref No." := Application."Application No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry."Milestone Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10);//ALLE-AM
                    GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                    GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                    GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash THEN
                        GenJnlLine.Description := 'Cash Received'
                    ELSE
                        IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN
                            GenJnlLine.Description := 'Cheque Received'
                        ELSE
                            IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking" THEN
                                GenJnlLine.Description := 'Cheque Received'
                            ELSE
                                IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.D." THEN
                                    GenJnlLine.Description := 'D.D. Received';
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", GenJnlLine.Description);
                    Line := Line + 10000;
                END;
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash)) THEN BEGIN
                    UnitSetup.GET;
                    CashPmtMethod.GET(BondPaymentEntry."Payment Method");
                    CashAmount += BondPaymentEntry.Amount;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", UnitReversal.GetCashAccountNo(BondPaymentEntry."User Branch Code"));
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    ;
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                    BondPostingGroup1.GET(Application."Bond Posting Group");
                    GenJnlLine."Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Order Ref No." := Application."Application No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry."Milestone Code";

                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    GenJnlLine."Installment No." := 1;
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    IF (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash) THEN
                        GenJnlLine.Description := 'Cash Received'
                    ELSE
                        GenJnlLine.Description := 'Cash transferred';
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", GenJnlLine.Description);
                END;
                Line := Line + 10000;


                //---------------Associate to Member Transger-------Start----261212
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::AJVM)) THEN BEGIN
                    PDocNo := '';
                    AJVM1 := TRUE;

                    IF BondPaymentEntry."Payment Mode New" = BondPaymentEntry."Payment Mode New"::"AJVM ADV" THEN BEGIN
                        UnitSetup.GET;
                        UnitSetup.TestField("AJVM Transfer BankAccount Code");
                        AVJMAmount += BondPaymentEntry.Amount;
                        GenJnlLine1.INIT;
                        GenJnlLine1."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                        GenJnlLine1."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                        GenJnlLine1."Line No." := Line;
                        GenJnlLine1."Document Type" := GenJnlLine1."Document Type"::Payment;
                        //GenJnlLine.VALIDATE("Posting Date",Application."Posting Date"); //ALLETDK
                        GenJnlLine1.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                                                                                               //GenJnlLine1.VALIDATE("Document Date",Application."Document Date");
                        GenJnlLine1.VALIDATE("Party Type", GenJnlLine1."Party Type"::Vendor);
                        GenJnlLine1.VALIDATE("Party Code", Application."AJVM Associate Code");
                        IF BondPaymentEntry."AJVM Transfer Type" = BondPaymentEntry."AJVM Transfer Type"::Commission THEN //ALLETDK290313
                            GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Commission;
                        IF BondPaymentEntry."AJVM Transfer Type" = BondPaymentEntry."AJVM Transfer Type"::Incentive THEN //ALLETDK290313
                            GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Incentive;
                        GenJnlLine1.VALIDATE("TDS Section Code", UnitSetup."TDS Nature of Deduction");
                        // GenJnlLine1.VALIDATE("Bal. Account Type", GenJnlLine1."Bal. Account Type"::"G/L Account");
                        GenJnlLine1.VALIDATE("Bal. Account Type", GenJnlLine1."Bal. Account Type"::"Bank Account");   //200225
                        GenJnlLine1.VALIDATE("Bal. Account No.", UnitSetup."AJVM Transfer BankAccount Code"); //UnitSetup."Transfer Control Account");  //200225
                        GenJnlLine1.VALIDATE("Vendor Cheque Amount", BondPaymentEntry.Amount);
                        GenJnlLine1."Document No." := BondPaymentEntry."Posted Document No.";
                        PDocNo := BondPaymentEntry."Posted Document No.";
                        GenJnlLine1."Order Ref No." := BondPaymentEntry."Document No.";
                        GenJnlLine1.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
                        GenJnlLine1."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                        GenJnlLine1."System-Created Entry" := false;
                        GenJnlLine1."Payment As Advance" := TRUE;
                        GenJnlLine1."Introducer Code" := Application."Introducer Code";
                        GenJnlLine1."Unit No." := Application."Unit Code";
                        GenJnlLine1."Posting No. Series" := GenJnlBatch."Posting No. Series";
                        GenJnlLine1."Installment No." := 1;
                        GenJnlLine1."Payment Mode" := GenJnlLine1."Payment Mode"::AJVM;
                        GenJnlLine1."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                        GenJnlLine1."Ref Document Type" := GenJnlLine1."Ref Document Type"::Order;
                        GenJnlLine1."Source Code" := 'GENJNL';
                        GenJnlLine1.INSERT;
                        CalculateTax.CallTaxEngineOnGenJnlLine(GenJnlLine1, GenJnlLine1);  //190225
                        InsertJnDimension(GenJnlLine1); //ALLEDK 310113
                        PostPayment1.CheckVendorChequeAmount(GenJnlLine1);  //240113

                        Line := Line + 10000;
                        GenJnlLine1.INIT;
                        GenJnlLine1."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                        GenJnlLine1."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                        GenJnlLine1."Line No." := Line;
                        GenJnlLine1."Document Type" := GenJnlLine1."Document Type"::Payment;
                        GenJnlLine1.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                        //GenJnlLine1.VALIDATE("Account Type", GenJnlLine1."Account Type"::"G/L Account");  200225
                        //GenJnlLine1.VALIDATE("Account No.", UnitSetup."Transfer Control Account");  200225

                        GenJnlLine1.VALIDATE("Account Type", GenJnlLine1."Account Type"::"Bank Account");   //200225
                        GenJnlLine1.VALIDATE("Account No.", UnitSetup."AJVM Transfer BankAccount Code"); //UnitSetup."Transfer Control Account");  //200225

                        GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Running;
                        GenJnlLine1.VALIDATE("Bal. Account Type", GenJnlLine1."Bal. Account Type"::Customer);
                        GenJnlLine1.VALIDATE("Bal. Account No.", Application."Customer No.");
                        GenJnlLine1.VALIDATE(Amount, BondPaymentEntry.Amount);
                        GenJnlLine1."Document No." := BondPaymentEntry."Posted Document No.";
                        GenJnlLine1."Order Ref No." := BondPaymentEntry."Document No.";
                        GenJnlLine1.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
                        GenJnlLine1."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                        GenJnlLine1."System-Created Entry" := TRUE;
                        GenJnlLine1."Introducer Code" := Application."AJVM Associate Code";  //ALLEDK 270113
                        GenJnlLine1."Unit No." := Application."Unit Code";
                        GenJnlLine1."Installment No." := 1;
                        GenJnlLine1."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                        GenJnlLine1."Ref Document Type" := GenJnlLine1."Ref Document Type"::Order;
                        GenJnlLine1.INSERT;
                        InsertJnDimension(GenJnlLine1); //ALLEDK 310113
                        InitVoucherNarration(GenJnlLine1."Journal Template Name", GenJnlLine1."Journal Batch Name", GenJnlLine1."Document No.",
                         GenJnlLine1."Line No.", GenJnlLine1."Line No.", 'Associate to Member Transfer');
                        Line := Line + 10000;
                    END ELSE BEGIN
                        UnitSetup.GET;
                        AVJMAmount += BondPaymentEntry.Amount;
                        GenJnlLine1.INIT;
                        GenJnlLine1."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                        GenJnlLine1."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                        GenJnlLine1."Line No." := Line;
                        GenJnlLine1."Document Type" := GenJnlLine1."Document Type"::Payment;
                        //GenJnlLine.VALIDATE("Posting Date",Application."Posting Date"); //ALLETDK
                        GenJnlLine1.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                                                                                               //GenJnlLine1.VALIDATE("Document Date",Application."Document Date");
                        GenJnlLine1.VALIDATE("Party Type", GenJnlLine1."Party Type"::Vendor);
                        GenJnlLine1.VALIDATE("Party Code", Application."AJVM Associate Code");
                        IF BondPaymentEntry."AJVM Transfer Type" = BondPaymentEntry."AJVM Transfer Type"::Commission THEN //ALLETDK290313
                            GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Commission;
                        IF BondPaymentEntry."AJVM Transfer Type" = BondPaymentEntry."AJVM Transfer Type"::Incentive THEN //ALLETDK290313
                            GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Incentive;
                        // GenJnlLine1.VALIDATE("TDS Nature of Deduction",UnitSetup."TDS Nature of Deduction");
                        GenJnlLine1.VALIDATE("Bal. Account Type", GenJnlLine1."Bal. Account Type"::"G/L Account");
                        GenJnlLine1.VALIDATE("Bal. Account No.", UnitSetup."Transfer Control Account");
                        //  GenJnlLine1.VALIDATE("Vendor Cheque Amount",Amount);    //ALLE261015
                        GenJnlLine1.VALIDATE(Amount, BondPaymentEntry.Amount); //ALLE261015
                        GenJnlLine1."Document No." := BondPaymentEntry."Posted Document No.";
                        PDocNo := BondPaymentEntry."Posted Document No.";
                        GenJnlLine1."Order Ref No." := BondPaymentEntry."Document No.";
                        GenJnlLine1.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
                        GenJnlLine1."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                        GenJnlLine1."System-Created Entry" := TRUE;
                        GenJnlLine1."Introducer Code" := Application."Introducer Code";
                        GenJnlLine1."Unit No." := Application."Unit Code";
                        GenJnlLine1."Posting No. Series" := GenJnlBatch."Posting No. Series";
                        GenJnlLine1."Installment No." := 1;
                        GenJnlLine1."Payment Mode" := GenJnlLine1."Payment Mode"::AJVM;
                        GenJnlLine1."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                        GenJnlLine1.INSERT;
                        InsertJnDimension(GenJnlLine1); //ALLEDK 310113

                        Line := Line + 10000;
                        GenJnlLine1.INIT;
                        GenJnlLine1."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                        GenJnlLine1."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                        GenJnlLine1."Line No." := Line;
                        GenJnlLine1."Document Type" := GenJnlLine1."Document Type"::Payment;
                        GenJnlLine1.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                        GenJnlLine1.VALIDATE("Account Type", GenJnlLine1."Account Type"::"G/L Account");
                        GenJnlLine1.VALIDATE("Account No.", UnitSetup."Transfer Control Account");
                        GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Running;
                        GenJnlLine1.VALIDATE("Bal. Account Type", GenJnlLine1."Bal. Account Type"::Customer);
                        GenJnlLine1.VALIDATE("Bal. Account No.", Application."Customer No.");
                        GenJnlLine1.VALIDATE(Amount, BondPaymentEntry.Amount); //ALLE261015
                        GenJnlLine1."Document No." := BondPaymentEntry."Posted Document No.";
                        GenJnlLine1."Order Ref No." := BondPaymentEntry."Document No.";
                        GenJnlLine1.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
                        GenJnlLine1."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                        GenJnlLine1."System-Created Entry" := TRUE;
                        GenJnlLine1."Introducer Code" := Application."AJVM Associate Code";  //ALLEDK 270113
                        GenJnlLine1."Unit No." := Application."Unit Code";
                        GenJnlLine1."Installment No." := 1;
                        GenJnlLine1."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                        GenJnlLine1.INSERT;
                        InsertJnDimension(GenJnlLine1); //ALLEDK 310113
                        InitVoucherNarration(GenJnlLine1."Journal Template Name", GenJnlLine1."Journal Batch Name", GenJnlLine1."Document No.",
                         GenJnlLine1."Line No.", GenJnlLine1."Line No.", 'Associate to Member Transfer');
                    END;
                    Line := Line + 10000;
                END;
                //---------------Associate to Member Transfer--------END-----261212
                //ALLETDK220213---JV TRANSACTION--BEGIN
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::JV)) THEN BEGIN
                    //JVAmt+=Amount;
                    PaymentModeJV := TRUE;   //211114
                    UnitSetup.GET;
                    PaymentMethod.GET(BondPaymentEntry."Payment Method");
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                    IF BondPaymentEntry."Deposit/Paid Bank" <> '' THEN BEGIN
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                        GenJnlLine.VALIDATE("Account No.", BondPaymentEntry."Deposit/Paid Bank");
                    END ELSE BEGIN
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        GenJnlLine.VALIDATE("Account No.", UnitSetup."Project Change JV Account");
                    END;
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    //GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                    //GenJnlLine.VALIDATE("Source Type",GenJnlLine."Source Type"::"Bank Account");
                    //GenJnlLine.VALIDATE("Source No.","Deposit/Paid Bank");
                    BondPostingGroup1.GET(Application."Bond Posting Group");
                    GenJnlLine."Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Order Ref No." := Application."Application No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry."Milestone Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::Customer);
                    GenJnlLine.VALIDATE("Bal. Account No.", Application."Customer No.");

                    GenJnlLine."Shortcut Dimension 1 Code" := BondPaymentEntry."Shortcut Dimension 1 Code";
                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", BondPaymentEntry."Shortcut Dimension 1 Code"); //INS1.0
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::JV;
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    //GenJnlLine."Posting Type" := GenJnlLine."Posting Type" ::Running;
                    GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10);//ALLE-AM
                    GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                    GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                    GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";

                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    //IF "Payment Mode" = "Payment Mode"::JV THEN
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    InsertJnDimension(GenJnlLine); //310113
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", GenJnlLine.Description);
                    Line := Line + 10000;
                END;
                //ALLETDK220213---JV TRANSACTION--END
                //ALLETDK170513---MJVM TRANSACTION--BEGIN
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::MJVM)) THEN BEGIN
                    UnitSetup.GET;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLEDK
                                                                                          //ALLE221015 Old Code comment Start----------
                                                                                          //  GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type":: Customer);
                                                                                          //   GenJnlLine.VALIDATE("Account No.",Application."Customer No.");
                                                                                          //   GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Bal. Account Type"::"G/L Account");
                                                                                          //   GenJnlLine.VALIDATE("Bal. Account No.",UnitSetup."Transfer Control Account");

                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", UnitSetup."Transfer Control Account");
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::Customer);
                    GenJnlLine.VALIDATE("Bal. Account No.", Application."Customer No.");

                    //ALLE221015 Old code Comment End------------
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    GenJnlLine."Unit No." := Application."Unit Code";
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
                    GenJnlLine."Installment No." := 1;
                    GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::MJVM;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    InsertJnDimension(GenJnlLine); //ALLEDK 310113

                    Line := Line + 10000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLEDK
                                                                                          //ALLE221015 Old Code comment Start----------
                                                                                          // GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"G/L Account");
                                                                                          // GenJnlLine.VALIDATE("Account No.",UnitSetup."Transfer Control Account");
                                                                                          //  GenJnlLine."Posting Type" := GenJnlLine."Posting Type" :: Running;
                                                                                          //  ReConOrd.GET("Order Ref No.");
                                                                                          //  GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Bal. Account Type"::Customer);
                                                                                          //  GenJnlLine.VALIDATE("Bal. Account No.",ReConOrd."Customer No.");
                    ReConOrd.RESET;
                    ReConOrd.GET(BondPaymentEntry."Order Ref No.");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.VALIDATE("Account No.", ReConOrd."Customer No.");
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Bal. Account No.", UnitSetup."Transfer Control Account");

                    //ALLE221015 Old Code comment END ----------
                    GenJnlLine.VALIDATE(Amount, ABS(BondPaymentEntry.Amount));
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    //  GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";  080915 code comment
                    GenJnlLine."Order Ref No." := BondPaymentEntry."Order Ref No."; //080915
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ReConOrd."Shortcut Dimension 1 Code");  //BBG2.01 261214
                    GenJnlLine."Shortcut Dimension 2 Code" := ReConOrd."Shortcut Dimension 2 Code";  //BBG2.01 261214
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Unit No." := Application."Unit Code";
                    GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::MJVM;
                    GenJnlLine."Installment No." := 1;
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    InsertJnDimension(GenJnlLine); //ALLEDK 310113
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                     GenJnlLine."Line No.", GenJnlLine."Line No.", 'Member to Member Transfer');
                END;
            //ALLETDK170513---MJVM TRANSACTION--END;
            UNTIL BondPaymentEntry.NEXT = 0;
        //IF ("Payment Mode" <> "Payment Mode"::AJVM) THEN BEGIN  //ALLEDK 281212
        IF NOT (BondPaymentEntry."Payment Mode" IN [BondPaymentEntry."Payment Mode"::AJVM, BondPaymentEntry."Payment Mode"::JV]) THEN BEGIN //ALLETDK220213
            IF (BondBankAmount + CashAmount) <> 0 THEN BEGIN
                UnitSetup.GET;
                Line += 10000;
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := Line;
                GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLEDK
                GenJnlLine.VALIDATE(Amount, -(BondBankAmount + CashAmount + AVJMAmount));
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.VALIDATE("Account No.", Application."Customer No.");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                GenJnlLine."Branch Code" := BondPaymentEntry."User Branch Code";
                GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
                GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
                BondPostingGroup1.GET(Application."Bond Posting Group");
                GenJnlLine."Posting Group" := Application."Bond Posting Group";
                GenJnlLine."Order Ref No." := Application."Application No.";
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Introducer Code" := Application."Introducer Code";
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Unit No." := Application."Unit Code"; //ALLETDK141112
                GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10); //ALLE-AM
                GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash THEN
                    GenJnlLine.Description := 'Cash Received'
                ELSE
                    IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN
                        GenJnlLine.Description := 'Cheque Received'
                    ELSE
                        IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking" THEN
                            GenJnlLine.Description := 'Cheque Received'
                        ELSE
                            IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.D." THEN
                                GenJnlLine.Description := 'D.D. Received';
                GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                GenJnlLine.INSERT;
                InsertJnDimension(GenJnlLine); //310113
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            END;
        END; //ALLEDK 281212

        //211114
        IF PaymentModeJV = FALSE THEN BEGIN  //211114
            IF Application.Type = Application.Type::Normal THEN BEGIN //ALLEDK 241212
                Application.CALCFIELDS(Application."Amount Received");
                UnitPayEntry.RESET;
                UnitPayEntry.SETRANGE("Document Type", UnitPayEntry."Document Type"::BOND);
                UnitPayEntry.SETRANGE("Document No.", Application."No.");
                UnitPayEntry.SETRANGE(Posted, FALSE);
                IF UnitPayEntry.FINDSET THEN
                    REPEAT
                        CLEAR(BondInvestmentAmt);
                        BondInvestmentAmt := UnitPayEntry.Amount;
                        CLEAR(ByCheque);
                        IF (UnitPayEntry."Payment Mode" IN [UnitPayEntry."Payment Mode"::Bank, UnitPayEntry."Payment Mode"::"D.C./C.C./Net Banking", UnitPayEntry."Payment Mode"::"D.D."]) THEN
                            ByCheque := TRUE
                        ELSE
                            ByCheque := FALSE;
                        IF (UnitPayEntry."Payment Mode" <> UnitPayEntry."Payment Mode"::Cash) OR
                          (UnitPayEntry."Payment Mode" <> UnitPayEntry."Payment Mode"::"Refund Cash") THEN
                            Application."With Cheque" := TRUE;

                        CreateStagingTableAppBond(Application, UnitPayEntry."Line No." / 10000, 1, UnitPayEntry.Sequence,
                        UnitPayEntry."Cheque No./ Transaction No.", UnitPayEntry."Commision Applicable", UnitPayEntry."Direct Associate",
                        UnitPayEntry."Posting date", BondInvestmentAmt, UnitPayEntry, FALSE, Application."Old Process");
                    UNTIL UnitPayEntry.NEXT = 0;
            END;  //ALLEDK 241212
        END;  //211114


        IF AJVM1 THEN
            PostGenJnlLines1
        ELSE
            PostGenJnlLines(GenJnlLine."Document No.");
    end;


    procedure NewChequeBounce(var BondPaymentEntry: Record "Application Payment Entry"; var CheqDate: Date)
    var
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        BondPostingGroup1: Record "Customer Posting Group";
        Application: Record Application;
        BondPaymentEntry2: Record "Unit Payment Entry";
        RDPmtSchBuff: Record "Template Field";
        RDPaymentScheduleBuffer: Record "Template Field";
        BondPaymentEntry3: Record "Unit Payment Entry";
        BondPaymentEntryCount: Integer;
        BondPmtEntXChqQ: Record "Quote Properties";
        Bond: Record "Confirmed Order";
        AppPaymentEntry: Record "Application Payment Entry";
        ApplicationAmount: Decimal;
        BondAmount: Decimal;
    begin
        UnitSetup.GET;
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;

        BondSetup.GET;
        BondSetup.TESTFIELD("Cr. Source Code");
        Line := 10000;
        IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN BEGIN
            BondPaymentEntry.CALCFIELDS(Reversed);
            BondPaymentEntry.TESTFIELD(Reversed, FALSE);
            IF BondPaymentEntry.Amount > 0 THEN BEGIN
                PaymentMethod.GET(BondPaymentEntry."Payment Method");
                BankAccount.GET(BondPaymentEntry."Deposit/Paid Bank");
                BankAccountPostingGroup.GET(BankAccount."Bank Acc. Posting Group");
                GenJnlLine.INIT;
                GenJnlLine."Line No." := Line;
                IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application THEN BEGIN
                    Application.GET(BondPaymentEntry."Document No.");
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine.VALIDATE("Posting Date", CheqDate);
                    //GenJnlLine.VALIDATE("Document Date",Application."Document Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.VALIDATE("Account No.", Application."Customer No.");
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    //GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Source Code" := BondSetup."Dr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine.Bounced := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Introducer Code" := Application."Associate Code";
                    GenJnlLine."Unit No." := Application."Unit No.";
                    GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10); //ALLE-AM
                    GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No."; //ALLE-AM
                    GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                    GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Bal. Account No.", BondPaymentEntry."Deposit/Paid Bank");
                    GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                    GenJnlLine.Description := 'Cheque Bounced';
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    Line := Line + 10000;
                END ELSE
                    IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::BOND THEN BEGIN
                        Bond.GET(BondPaymentEntry."Document No.");
                        GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                        GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                        GenJnlLine.VALIDATE("Posting Date", CheqDate);
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                        GenJnlLine.VALIDATE("Account No.", Bond."Customer No.");
                        GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                        //GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                        GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                        GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
                        GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                        GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                        GenJnlLine."Branch Code" := UserSetup."User Branch";
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                        GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                        GenJnlLine."System-Created Entry" := TRUE;
                        GenJnlLine.Bounced := TRUE;
                        GenJnlLine."Introducer Code" := Bond."Introducer Code";
                        GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                        GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10); //ALLE-AM
                        GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                        GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                        GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                        GenJnlLine."Paid To/Received From Code" := Bond."Received From Code";
                        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                        GenJnlLine.VALIDATE("Bal. Account No.", BondPaymentEntry."Deposit/Paid Bank");
                        GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                        GenJnlLine.Description := 'Cheque Bounced';
                        GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                        GenJnlLine.INSERT;
                        Line := Line + 10000;
                    END;
            END;
            AppPaymentEntry.RESET;
            AppPaymentEntry.SETRANGE("Document No.", BondPaymentEntry."Document No.");
            AppPaymentEntry.SETRANGE("Cheque No./ Transaction No.", BondPaymentEntry."Cheque No./ Transaction No.");
            AppPaymentEntry.SETFILTER("Cheque Status", '<>%1', AppPaymentEntry."Cheque Status"::Bounced);
            AppPaymentEntry.SETRANGE("Receipt Line No.", BondPaymentEntry."Receipt Line No."); //ALLEDK 10112016
            IF AppPaymentEntry.FINDFIRST THEN BEGIN
                AppPaymentEntry."Cheque Status" := AppPaymentEntry."Cheque Status"::Bounced;
                AppPaymentEntry."Chq. Cl / Bounce Dt." := CheqDate;  //190113
                AppPaymentEntry.MODIFY;
            END;
            InsertJnDimension(GenJnlLine);  //ALLEDK 040213
            PostGenJnlLines(GenJnlLine."Document No.");
        END;
        IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"Refund Bank" THEN BEGIN
            CreateJVApplicationPaymentLine(BondPaymentEntry, CheqDate);
            AppPaymentEntry.RESET;
            AppPaymentEntry.SETRANGE("Document No.", BondPaymentEntry."Document No.");
            AppPaymentEntry.SETRANGE("Cheque No./ Transaction No.", BondPaymentEntry."Cheque No./ Transaction No.");
            AppPaymentEntry.SETFILTER("Cheque Status", '<>%1', AppPaymentEntry."Cheque Status"::Bounced);
            AppPaymentEntry.SETRANGE("Receipt Line No.", BondPaymentEntry."Receipt Line No."); //ALLEDK 10112016
            IF AppPaymentEntry.FINDFIRST THEN BEGIN
                AppPaymentEntry."Cheque Status" := AppPaymentEntry."Cheque Status"::Bounced;
                AppPaymentEntry."Chq. Cl / Bounce Dt." := CheqDate;  //190113
                AppPaymentEntry.MODIFY;
            END;

            BondPaymentEntry2.RESET;
            BondPaymentEntry2.SETRANGE("Document Type", BondPaymentEntry."Document Type");
            BondPaymentEntry2.SETRANGE("Document No.", BondPaymentEntry."Document No.");
            BondPaymentEntry2.SETRANGE("App. Pay. Entry Line No.", BondPaymentEntry."Line No.");
            //BondPaymentEntry2.SETRANGE("Cheque No./ Transaction No.","Cheque No./ Transaction No.");
            //BondPaymentEntry2.SETFILTER("Cheque Status",BondPaymentEntry2."Cheque Status"::Cleared);
            IF BondPaymentEntry2.FINDSET THEN
                REPEAT
                    IF BondPaymentEntry3.GET(BondPaymentEntry2."Document Type", BondPaymentEntry2."Document No.",
                    BondPaymentEntry2."Line No.") THEN BEGIN
                        BondPaymentEntry3."Cheque Status" := BondPaymentEntry3."Cheque Status"::Bounced;
                        BondPaymentEntry3."Chq. Cl / Bounce Dt." := CheqDate;  //190113
                        BondPaymentEntry3.MODIFY;
                    END;
                UNTIL BondPaymentEntry2.NEXT = 0;

            /*
            Bond.GET("Document No.");
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            GenJnlLine.VALIDATE("Posting Date",WORKDATE);
            GenJnlLine.VALIDATE("Document Date",WORKDATE);
            GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.",Bond."Customer No.");
            //GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
            GenJnlLine."Document No." := JVPostedDocNo;
            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine."Order Ref No." := Bond."No.";
            GenJnlLine.VALIDATE(Amount,Amount);
            GenJnlLine.VALIDATE("Source Type",GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.",Bond."Customer No.");
            GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Account Type"::"Bank Account");
            BondPostingGroup1.GET(Bond."Bond Posting Group");
            GenJnlLine.VALIDATE("Bal. Account No.","Deposit/Paid Bank");
            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Order Ref No." := Bond."Application No.";
            //GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";
            //GenJnlLine."Cheque No." := "Cheque No./ Transaction No.";
            GenJnlLine."Branch Code" := UserSetup."User Branch";
            //GenJnlLine."Cheque Date" := "Cheque Date";
            //GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type" :: Running;
            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine.Bounced := TRUE;
            GenJnlLine.Description := 'Refund Amount';
            GenJnlLine.INSERT;
            //InitVoucherNarration(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name",GenJnlLine."Document No.",
              //GenJnlLine."Line No.",GenJnlLine."Line No.",NarrationText1);
            //InsertJnDimension(GenJnlLine); //310113
            //PostGenJnlLines;
            */
        END;

    end;


    procedure CreateClubChargesLine(var GenernalLine: Record "Gen. Journal Line")
    var
        JnlBankCharge: Record "Journal Bank Charges";// "16511";
        BankCharge: Record "Bank Charge";// "16510";
        UnitSetup: Record "Unit Setup";
        LineNo: Integer;
    begin
        //ALLEDK 281212
        LineNo := 0;
        //IF "Line No."=0 THEN
        //  LineNo := 10000
        //ELSE
        //  LineNo := "Line No.";
        JnlBankCharge.RESET;
        JnlBankCharge.SETRANGE("Journal Template Name", GenernalLine."Journal Template Name");//'APPL');
        JnlBankCharge.SETRANGE("Journal Batch Name", GenernalLine."Journal Batch Name");//'APPL');
        JnlBankCharge.SETRANGE("Line No.", GenernalLine."Line No.");
        IF NOT JnlBankCharge.FINDFIRST THEN BEGIN
            JnlBankCharge.INIT;
            JnlBankCharge."Journal Template Name" := GenernalLine."Journal Template Name";
            JnlBankCharge."Journal Batch Name" := GenernalLine."Journal Batch Name";
            JnlBankCharge."Line No." := GenernalLine."Line No.";
            BankCharge.RESET;
            BankCharge.SETRANGE(Club9, TRUE);
            IF NOT BankCharge.FINDFIRST THEN
                ERROR('Create Bank Charge Code for Club9 Charges');
            JnlBankCharge.VALIDATE("Bank Charge", BankCharge.Code);
            UnitSetup.GET;
            JnlBankCharge.VALIDATE(Amount, -ROUND((GenernalLine.Amount * UnitSetup."Corpus %" / 100), 0.01));
            JnlBankCharge.INSERT;
        END ELSE BEGIN
            UnitSetup.GET;
            JnlBankCharge.VALIDATE(Amount, -ROUND((GenernalLine.Amount * UnitSetup."Corpus %" / 100), 0.01));
            JnlBankCharge.MODIFY;
        END;
        //ALLEDK 281212
    end;


    procedure CalculateTDSPercentage(VendorCode: Code[20]; TDSCode: Code[20]; CompCode: Text[30]): Decimal
    var
        TDSPercent: Decimal;
        eCessPercent: Decimal;
        SheCessPercent: Decimal;
        RecTDSSetup: Record "TDS Setup"; // "13728";
                                         //RecNODHeader: Record 13786;//Need to check the code in UAT

        Vendor: Record Vendor;
        AllowedSection: Record "Allowed Sections";
        CodeunitEventMgt: Codeunit "BBG Codeunit Event Mgnt.";
    //RecNODLines: Record 13785;//Need to check the code in UAT
    begin
        IF CompCode = '' THEN BEGIN
            IF Vendor.Get(VendorCode) Then begin
                AllowedSection.Reset();
                AllowedSection.SetRange("Vendor No", Vendor."No.");
                AllowedSection.SetRange("TDS Section", TDSCode);
                IF AllowedSection.FindFirst() then begin
                    TDSPercent := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
                    exit(TDSPercent);
                end;
            end;
        End Else begin
            Vendor.Reset();
            Vendor.ChangeCompany(CompCode);
            IF Vendor.Get(VendorCode) Then begin
                AllowedSection.Reset();
                AllowedSection.ChangeCompany(CompCode);
                AllowedSection.SetRange("Vendor No", Vendor."No.");
                AllowedSection.SetRange("TDS Section", TDSCode);
                IF AllowedSection.FindFirst() then begin
                    TDSPercent := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
                    exit(TDSPercent);
                end;
            end;
        end;
        /*
                IF CompCode = '' THEN BEGIN
                    IF RecNODHeader.GET(RecNODHeader.Type::Vendor, VendorCode) THEN;

                    RecTDSSetup.RESET;
                    RecTDSSetup.SETRANGE("TDS Nature of Deduction", TDSCode);
                    RecTDSSetup.SETRANGE("Assessee Code", RecNODHeader."Assesse Code");
                    //RecTDSSetup.SETRANGE("TDS Group","TDS Group");
                    RecTDSSetup.SETRANGE("Effective Date", 0D, TODAY);
                    RecNODLines.RESET;
                    RecNODLines.SETRANGE(Type, RecNODLines.Type::Vendor);
                    RecNODLines.SETRANGE("No.", VendorCode);
                    RecNODLines.SETRANGE("NOD/NOC", TDSCode);
                    IF RecNODLines.FINDFIRST THEN BEGIN
                        IF RecNODLines."Concessional Code" <> '' THEN
                            RecTDSSetup.SETRANGE("Concessional Code", RecNODLines."Concessional Code")
                        ELSE
                            RecTDSSetup.SETRANGE("Concessional Code", '');
                        IF RecTDSSetup.FINDLAST THEN BEGIN
                            Vend.GET(VendorCode);
                            IF (Vend."P.A.N. Status" = Vend."P.A.N. Status"::" ") AND (Vend."P.A.N. No." <> '') THEN BEGIN
                                IF Vend."206AB" THEN   //Alledk 020721
                                    TDSPercent := RecTDSSetup."206AB %"    //Alledk 020721
                                ELSE
                                    TDSPercent := RecTDSSetup."TDS %"
                            END ELSE
                                TDSPercent := RecTDSSetup."Non PAN TDS %";

                            eCessPercent := RecTDSSetup."eCESS %";
                            SheCessPercent := RecTDSSetup."SHE Cess %";
                            EXIT(((10000 * TDSPercent) + (100 * TDSPercent * eCessPercent) + (100 * TDSPercent * SheCessPercent) +
                              (TDSPercent * eCessPercent * SheCessPercent)) / 10000);
                        END ELSE
                            ERROR('TDS Setup does not exist' + VendorCode);
                    END ELSE
                        ERROR('TDS Setup does not exist' + VendorCode);
                END ELSE BEGIN
                    RecNODHeader.RESET;
                    RecNODHeader.CHANGECOMPANY(CompCode);
                    IF RecNODHeader.GET(RecNODHeader.Type::Vendor, VendorCode) THEN;

                    RecTDSSetup.RESET;
                    RecTDSSetup.CHANGECOMPANY(CompCode);
                    RecTDSSetup.SETRANGE("TDS Nature of Deduction", TDSCode);
                    RecTDSSetup.SETRANGE("Assessee Code", RecNODHeader."Assesse Code");
                    //RecTDSSetup.SETRANGE("TDS Group","TDS Group");
                    RecTDSSetup.SETRANGE("Effective Date", 0D, TODAY);
                    RecNODLines.RESET;
                    RecNODLines.CHANGECOMPANY(CompCode);
                    RecNODLines.SETRANGE(Type, RecNODLines.Type::Vendor);
                    RecNODLines.SETRANGE("No.", VendorCode);
                    RecNODLines.SETRANGE("NOD/NOC", TDSCode);
                    IF RecNODLines.FINDFIRST THEN BEGIN
                        IF RecNODLines."Concessional Code" <> '' THEN
                            RecTDSSetup.SETRANGE("Concessional Code", RecNODLines."Concessional Code")
                        ELSE
                            RecTDSSetup.SETRANGE("Concessional Code", '');
                        IF RecTDSSetup.FINDLAST THEN BEGIN
                            Vend.CHANGECOMPANY(CompCode);
                            Vend.GET(VendorCode);
                            IF (Vend."P.A.N. Status" = Vend."P.A.N. Status"::" ") AND (Vend."P.A.N. No." <> '') THEN BEGIN
                                IF Vend."206AB" THEN    //ALLEDK020721
                                    TDSPercent := RecTDSSetup."206AB %"    //ALLEDK020721
                                ELSE
                                    TDSPercent := RecTDSSetup."TDS %"
                            END ELSE
                                TDSPercent := RecTDSSetup."Non PAN TDS %";

                            eCessPercent := RecTDSSetup."eCESS %";
                            SheCessPercent := RecTDSSetup."SHE Cess %";
                            EXIT(((10000 * TDSPercent) + (100 * TDSPercent * eCessPercent) + (100 * TDSPercent * SheCessPercent) +
                              (TDSPercent * eCessPercent * SheCessPercent)) / 10000);
                        END ELSE
                            ERROR('TDS Setup does not exist-' + VendorCode + ' ' + 'for company ' + ' ' + CompCode);
                    END ELSE
                        ERROR('TDS Setup does not exist-' + VendorCode + ' ' + 'for company ' + ' ' + CompCode);
                END;
                *///Need to check the code in UAT

    end;


    procedure CreateCreditBondGenJnlLines(Application: Record "Confirmed Order"; Description: Text[50])
    var
        CreditBondPaymentEntry: Record "Debit App. Payment Entry";
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        CreditAmt: Decimal;
        PostedDocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        //ALLEDK 090113

        IF Vend.GET(Application."Introducer Code") THEN;

        BondSetup.GET;
        BondSetup.TESTFIELD("Transfer Member Batch Name");
        BondSetup.TESTFIELD("Transfer Member Temp Name");
        BondSetup.TESTFIELD("Discount No. Sereies");
        UserSetup.GET(USERID);

        GenJnlLine.RESET;
        GenJnlLine.SETFILTER("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETFILTER("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;



        //WITH CreditBondPaymentEntry DO BEGIN
        CreditBondPaymentEntry.RESET;
        CreditBondPaymentEntry.SETRANGE("Document Type", CreditBondPaymentEntry."Document Type"::BOND);
        CreditBondPaymentEntry.SETRANGE("Document No.", Application."No.");
        CreditBondPaymentEntry.SETRANGE(Posted, FALSE);
        CreditBondPaymentEntry.SETRANGE("BBG Discount", FALSE);
        IF CreditBondPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Discount No. Sereies", WORKDATE, TRUE);   //ALLEDK 270113
                                                                                                          // IF NOT CreditBondPaymentEntry."BBG Discount" THEN BEGIN
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := CreditBondPaymentEntry."Line No.";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
                GenJnlLine."Document No." := PostedDocNo;
                GenJnlLine.VALIDATE("Posting Date", CreditBondPaymentEntry."Posting date"); //ALLETDK
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", CreditBondPaymentEntry."Introducer Code");
                GenJnlLine.VALIDATE(Amount, CreditBondPaymentEntry."Net Payable Amt");
                GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
                GenJnlLine."Order Ref No." := Application."Application No.";
                GenJnlLine."Branch Code" := UserSetup."User Branch";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Introducer Code" := CreditBondPaymentEntry."Introducer Code";
                GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := BondSetup."Commission A/C";
                CheckCostCode(BondSetup."Commission A/C");
                GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                GenJnlLine."External Document No." := PostedDocNo;
                GenJnlLine.INSERT;
                //BBG1.6 311213
                // END;
                /* ELSE BEGIN
                  GenJnlLine.INIT;
                  GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                  GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                  GenJnlLine."Line No." := CreditBondPaymentEntry."Line No.";
                  GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
                  GenJnlLine."Document No." := PostedDocNo;
                  GenJnlLine.VALIDATE("Posting Date",CreditBondPaymentEntry."Posting Date") ; //ALLEDK
                  GenJnlLine.VALIDATE("Shortcut Dimension 1 Code",Application."Shortcut Dimension 1 Code");
                  GenJnlLine.VALIDATE("Shortcut Dimension 2 Code",Application."Shortcut Dimension 2 Code");
                  GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
                  GenJnlLine.VALIDATE("Account No.",CreditBondPaymentEntry."Member Code");
                  GenJnlLine.VALIDATE(Amount,-1*CreditBondPaymentEntry."Net Payable Amt");
                  GenJnlLine."Posting No. Series" :=GenJnlBatch."Posting No. Series";
                  GenJnlLine."Order Ref No." := Application."Application No.";
                  GenJnlLine."Branch Code" := UserSetup."User Branch";
                  GenJnlLine."System-Created Entry" := TRUE;
                  GenJnlLine."Posting Type" := GenJnlLine."Posting Type" ::Running;
                  GenJnlLine."Introducer Code" := CreditBondPaymentEntry."Introducer Code";
                  GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                  GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                  GenJnlLine."Bal. Account No." := BondSetup."BBG Discount Account";
                  //CheckCostCode(BondSetup."Commission A/C");
                  GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                  GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                  GenJnlLine."External Document No." := PostedDocNo;
                  GenJnlLine.INSERT;
                END;
                */
                //BBG1.6 311213
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", 'Discount to Member');
                InsertJnDimension(GenJnlLine); //ALLEDK 310113
                GenJnlPostLine.RunWithCheck(GenJnlLine);  //ALLEDK 310113
                                                          //JournalLineDimension.DELETEALL; // ALLE MM
                                                          //GenJnlPostLine.RUN(GenJnlLine);  //ALLEDK 310113
                CreditBondPaymentEntry."Posted Document No." := PostedDocNo;
                CreditBondPaymentEntry.MODIFY;

            UNTIL CreditBondPaymentEntry.NEXT = 0;
            //CreditBondPaymentEntry.Posted := TRUE;
        END;
        //ALLEDK 090113

    end;


    procedure PostGenJnlLines1()
    begin
        CLEAR(GenJnlPostLine);
        CLEAR(GenJnlPostBatch);
        UserSetup.GET(USERID);
        GenJnlLine1.RESET;
        GenJnlLine1.SETRANGE("Document No.", PDocNo);
        IF GenJnlLine1.FINDFIRST THEN
            REPEAT

                GenJnlPostLine.RunWithoutCheck(GenJnlLine1)  // ALLE AKUL 050225
            UNTIL GenJnlLine1.NEXT = 0;


        //ALLEDK 310113
        GenJnlLine1.RESET;
        GenJnlLine1.SETRANGE("Document No.", PDocNo);
        IF GenJnlLine1.FINDFIRST THEN
            GenJnlLine1.DELETEALL;

    end;


    procedure "....................."()
    begin
    end;


    procedure CheckVendorChequeAmount(RecGnlJnlLine: Record "Gen. Journal Line")
    var
        JnlBankCharge: Record "Journal Bank Charges";// "16511";
        BankCharge: Record "Bank Charge"; // "16510";
        TCSEntry: Record "TDS Entry"; // "16514";
        TCSAmountApplied: Decimal;
        TDSAmount: Decimal;
        TCSAmount: Decimal;
        TotalAmount: Decimal;
        RoundAmt: Decimal;
        RecBankChrgAmt: Decimal;
        NewBankChrgAmt: Decimal;
        AdjmtAmt: Decimal;
        TDSPercent: Decimal;
    begin
        BankCharge.RESET;
        BankCharge.SETRANGE(Club9, TRUE);
        IF NOT BankCharge.FINDFIRST THEN
            ERROR('Create Bank Charge Code for Club9 Charges');
        NewBankChrgAmt := 0;
        RecBankChrgAmt := 0;
        AdjmtAmt := 0;
        TDSPercent := 0;
        UnitSetup.GET;
        //RecBankChrgAmt:=-ROUND((RecGnlJnlLine.Amount*UnitSetup."Corpus %"/100),1);
        IF RecGnlJnlLine."Payment Mode" <> RecGnlJnlLine."Payment Mode"::"Negative Adjmt." THEN
            RecBankChrgAmt := -(RecGnlJnlLine.Amount * UnitSetup."Corpus %" / 100)
        ELSE BEGIN
            RecGnlJnlLine.TESTFIELD("Account Type", RecGnlJnlLine."Account Type"::Vendor);
            RecGnlJnlLine.TESTFIELD("Account No.");
            TDSPercent := CalculateTDSPercentage(RecGnlJnlLine."Account No.", UnitSetup."TDS Nature of Deduction", '');
            AdjmtAmt := (100 * RecGnlJnlLine.Amount) / (100 - TDSPercent);
            //AdjmtAmt := (100*RecGnlJnlLine.Amount)/(100-TDSPercent-UnitSetup."Corpus %");
            RecBankChrgAmt := -ROUND((AdjmtAmt * UnitSetup."Corpus %" / 100), 1);
        END;

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
            //JnlBankCharge.VALIDATE("Bank Charge", BankCharge.Code); //Due to GST Validation 09012025
            JnlBankCharge.Validate("Bank Charge", BankCharge.Code);//Due to GST Validation 200225
            //JnlBankCharge."Bank Charge" := BankCharge.Code;//Due to GST Validation 200225

            JnlBankCharge."GST Document Type" := JnlBankCharge."GST Document Type"::"Credit Memo";
            JnlBankCharge."External Document No." := RecGnlJnlLine."Document No.";
            JnlBankCharge.Amount := RecBankChrgAmt; //Due to GST Validation 09012025
            JnlBankCharge."Amount (LCY)" := RecBankChrgAmt;//Due to GST Validation 09012025
            JnlBankCharge.INSERT;
            IF RecGnlJnlLine."Payment Mode" <> RecGnlJnlLine."Payment Mode"::"Negative Adjmt." THEN BEGIN
                CheckRoundAmount(RecGnlJnlLine, RecBankChrgAmt);
                NewBankChrgAmt := JnlBankCharge.Amount + RoundOff;
                JnlBankCharge.Amount := NewBankChrgAmt;//Due to GST Validation 09012025
                JnlBankCharge."Amount (LCY)" := NewBankChrgAmt;
                //Due to GST Validation 09012025
                JnlBankCharge.MODIFY;
            END;
        END ELSE BEGIN
            CheckRoundAmount(RecGnlJnlLine, RecBankChrgAmt);
            NewBankChrgAmt := RecBankChrgAmt + RoundOff;
            JnlBankCharge.Amount := NewBankChrgAmt;
            JnlBankCharge."Amount (LCY)" := NewBankChrgAmt;
            JnlBankCharge.MODIFY;
        END;
    end;


    procedure CheckRoundAmount(JnlLine: Record "Gen. Journal Line"; BankChargeAmt: Decimal)
    var
        JnlBankCharge: Record "Journal Bank Charges"; //"16511";
        BankCharge: Record "Bank Charge";// "16510";
        UnitSetup: Record "Unit Setup";
        TCSEntry: Record "TDS Entry"; // "16514";
        TCSAmountApplied: Decimal;
        TDSAmount: Decimal;
        TCSAmount: Decimal;
        TotalAmount: Decimal;
        RoundAmt: Decimal;
        TDSPercent: Decimal;
    begin

        CLEAR(TDSAmount);
        CLEAR(TCSAmount);
        CLEAR(TotalAmount);
        CLEAR(TCSAmountApplied);
        CLEAR(RoundOff);
        Clear(TDSPercent);
        UnitSetup.Get();
        TCSEntry.RESET;
        TCSEntry.SETRANGE("Document Type", JnlLine."Applies-to Doc. Type");
        TCSEntry.SETRANGE("Document No.", JnlLine."Applies-to Doc. No.");
        IF TCSEntry.FINDFIRST THEN
            REPEAT
                TCSAmountApplied += TCSEntry."TDS Amount" + TCSEntry."Surcharge Amount" + TCSEntry."eCESS Amount"
                 + TCSEntry."SHE Cess Amount";//TCS Amount
            UNTIL (TCSEntry.NEXT = 0);

        // IF JnlLine."TDS Nature of Deduction" <> '' THEN
        //     TDSAmount := JnlLine."Total TDS/TCS Incl. SHE CESS";
        // IF JnlLine."TCS Nature of Collection" <> '' THEN
        //     TCSAmount := JnlLine."Total TDS/TCS Incl. SHE CESS";
        TDSPercent := CalculateTDSPercentage(JnlLine."Account No.", UnitSetup."TDS Nature of Deduction", '');
        TDSAmount := Round(((JnlLine."Amount (LCY)" * TDSPercent) / 100), 1);
        TotalAmount := JnlLine."Amount (LCY)" - TDSAmount + TCSAmount + TCSAmountApplied + BankChargeAmt;
        //ALLETDK100213>>
        IF TotalAmount <> JnlLine."Vendor Cheque Amount" THEN
            RoundOff := JnlLine."Vendor Cheque Amount" - TotalAmount
        //Need to check the code in UAT

        /*
        IF TotalAmount < ROUND(TotalAmount,1) THEN
          RoundOff:=(ROUND(TotalAmount,1)-1)-TotalAmount
        ELSE
          RoundOff:=-(TotalAmount-(ROUND(TotalAmount,1)));
        */
        //ALLETDK100213<<

    end;


    procedure CreateChequeUnitPayEntries(var RecAppPayEntry: Record "Application Payment Entry")
    var
        AppPaymentEntry: Record "Application Payment Entry";
        TempBondPaymentEntry: Record "Application Payment Entry" temporary;
        DifferenceAmount: Decimal;
        LoopingDifferAmount: Decimal;
        BondPayLineAmt: Decimal;
        TotalBondAmount: Decimal;
        AppliPaymentAmount: Decimal;
        Unitmaster: Record "Unit Master";
        RecApplication: Record Application;
        CreateUnitPayEntry: Codeunit "Creat UPEry from ConfOrder/APP";
        RecConfOrd: Record "Confirmed Order";
    begin
        AppPaymentEntry := RecAppPayEntry;
        AppliPaymentAmount := AppPaymentEntry.Amount;
        TotalBondAmount := TotalBondAmount + AppPaymentEntry.Amount;

        IF RecAppPayEntry."Document Type" = RecAppPayEntry."Document Type"::Application THEN BEGIN
            RecApplication.GET(RecAppPayEntry."Document No.");
            Unitmaster.GET(RecApplication."Unit Code");
        END ELSE BEGIN
            RecConfOrd.GET(RecAppPayEntry."Document No.");
            IF RecConfOrd.Type = RecConfOrd.Type::Priority THEN BEGIN
                IF RecConfOrd."New Unit No." <> '' THEN
                    Unitmaster.GET(RecConfOrd."New Unit No.")  //ALLEDK 231112
                ELSE
                    Unitmaster.GET(RecConfOrd."Unit Code");
            END ELSE
                IF RecConfOrd.Status <> RecConfOrd.Status::Vacate THEN BEGIN//ALLETDK280313
                    Unitmaster.GET(RecConfOrd."Unit Code");
                END;
        END;
        //IF AppPaymentEntry.FINDSET THEN;
        GetLastLineNo(AppPaymentEntry);
        DifferenceAmount := 0;
        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", RecAppPayEntry."Application No.");
        IF RecConfOrd.Status <> RecConfOrd.Status::Vacate THEN //ALLETDK280313
            PaymentTermLines.SETRANGE("Payment Plan", Unitmaster."Payment Plan") //ALLEDK 231112
        ELSE
            PaymentTermLines.SETRANGE("Payment Plan", RecConfOrd."Payment Plan"); //ALLETDK280313
        IF PaymentTermLines.FINDSET THEN
            REPEAT
                PaymentTermLines.CALCFIELDS("Received Amt");
                DifferenceAmount := PaymentTermLines."Due Amount" - PaymentTermLines."Received Amt";
                LoopingDifferAmount := 0;
                REPEAT
                    IF DifferenceAmount < AppliPaymentAmount THEN BEGIN
                        IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                            BondPayLineAmt := AppliPaymentAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END ELSE BEGIN
                            BondPayLineAmt := DifferenceAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END;
                        TotalBondAmount := TotalBondAmount - BondPayLineAmt;//ALLE PS
                        LoopingDifferAmount := DifferenceAmount - BondPayLineAmt;
                    END ELSE
                        IF DifferenceAmount > AppliPaymentAmount THEN BEGIN
                            IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END ELSE BEGIN
                                BondPayLineAmt := AppliPaymentAmount - AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END;
                            TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            DifferenceAmount := DifferenceAmount - BondPayLineAmt;
                            LoopingDifferAmount := DifferenceAmount - TotalBondAmount;
                        END ELSE
                            IF DifferenceAmount = AppliPaymentAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            END;
                    IF BondPayLineAmt <> 0 THEN BEGIN
                        CreateUnitPayEntry.CreatePaymentEntryLine(BondPayLineAmt, AppPaymentEntry, LineNo, PaymentTermLines);
                        LineNo += 10000;
                    END;
                    IF AppliPaymentAmount = 0 THEN BEGIN
                        AppPaymentEntry."Explode BOM" := TRUE;
                        AppPaymentEntry.MODIFY;
                        //AppPaymentEntry.NEXT;
                        AppliPaymentAmount := AppPaymentEntry.Amount;
                    END;
                UNTIL (LoopingDifferAmount = 0) OR (TotalBondAmount = 0);
            UNTIL (PaymentTermLines.NEXT = 0) OR (TotalBondAmount = 0);
    end;


    procedure GetLastLineNo(BondPaymentEntryRec: Record "Application Payment Entry")
    var
        BPayEntry: Record "Unit Payment Entry";
    begin
        LineNo := 0;
        BPayEntry.RESET;
        BPayEntry.SETRANGE("Document Type", BondPaymentEntryRec."Document Type");
        BPayEntry.SETFILTER(BPayEntry."Document No.", BondPaymentEntryRec."Document No.");
        IF BPayEntry.FINDLAST THEN
            LineNo := BPayEntry."Line No." + 10000
        ELSE
            LineNo := 10000;
    end;


    procedure InsertJnDimension(RecGenLine: Record "Gen. Journal Line")
    begin
        GLSetup.GET;
        UserSetup.GET(USERID);
        //JournalLineDimension.DELETEALL; // ALLE MM

        /*
        //BBG1.00 ALLEDK 050313
        JournalLineDimension.INIT;
        JournalLineDimension."Table ID" := 81;
        JournalLineDimension."Journal Template Name" := RecGenLine."Journal Template Name";
        JournalLineDimension."Journal Batch Name" := RecGenLine."Journal Batch Name";
        JournalLineDimension."Journal Line No." := RecGenLine."Line No.";
        JournalLineDimension."Dimension Code" := GLSetup."Shortcut Dimension 3 Code";
        JournalLineDimension."Dimension Value Code" := UserSetup."User Branch";
        JournalLineDimension.INSERT;
        */
        //BBG1.00 ALLEDK 050313
        // ALLE MM Code Commented
        /*
        JournalLineDimension.INIT;
        JournalLineDimension."Table ID" := 81;
        JournalLineDimension."Journal Template Name" := RecGenLine."Journal Template Name";
        JournalLineDimension."Journal Batch Name" := RecGenLine."Journal Batch Name";
        JournalLineDimension."Journal Line No." := RecGenLine."Line No.";
        JournalLineDimension."Dimension Code" := GLSetup."Shortcut Dimension 1 Code";
        JournalLineDimension."Dimension Value Code" := RecGenLine."Shortcut Dimension 1 Code";
        JournalLineDimension.INSERT;

        IF Dim2Code <> '' THEN BEGIN
          JournalLineDimension.INIT;
          JournalLineDimension."Table ID" := 81;
          JournalLineDimension."Journal Template Name" := RecGenLine."Journal Template Name";
          JournalLineDimension."Journal Batch Name" := RecGenLine."Journal Batch Name";
          JournalLineDimension."Journal Line No." := RecGenLine."Line No.";
          JournalLineDimension."Dimension Code" := GLSetup."Shortcut Dimension 2 Code";
          JournalLineDimension."Dimension Value Code" := Dim2Code;
          JournalLineDimension.INSERT;
        END;
        */
        // ALLE MM Code Commented

    end;


    procedure CheckCostCode(GLAccount: Code[20])
    var
        DefaultDimension: Record "Default Dimension";
    begin
        //ALLEDK 170213
        GLSetup.GET;
        Dim2Code := '';
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", 15);
        DefaultDimension.SETRANGE("No.", GLAccount);
        DefaultDimension.SETFILTER("Value Posting", 'Same Code');
        DefaultDimension.SETFILTER(DefaultDimension."Dimension Code", '%1', GLSetup."Global Dimension 2 Code");
        DefaultDimension.SETFILTER(DefaultDimension."Dimension Value Code", '%1', '');
        IF DefaultDimension.FINDFIRST THEN BEGIN
            DefaultDimension.TESTFIELD(DefaultDimension."Dimension Value Code");
        END;

        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", 15);
        DefaultDimension.SETRANGE("No.", GLAccount);
        DefaultDimension.SETFILTER("Value Posting", 'Same Code');
        DefaultDimension.SETFILTER(DefaultDimension."Dimension Code", '%1', GLSetup."Global Dimension 2 Code");
        IF DefaultDimension.FINDFIRST THEN BEGIN
            Dim2Code := DefaultDimension."Dimension Value Code";
        END;

        //ALLEDK 170213
    end;


    procedure InsertRefundUnitPaymentLines(OrderNo: Code[20]; AppPayEntry: Record "Application Payment Entry")
    var
        UnitPayEntry: Record "Unit Payment Entry";
        Amt: Decimal;
        InsertUnitAppLines: Record "Unit Payment Entry";
        UnitAppPaymentEntry: Record "Unit Payment Entry";
        UnitLastLineNo: Integer;
        TotalAmt: Decimal;
        ApplyAmt1: Decimal;
        ApplyAmt: Decimal;
        RConfOrder: Record "Confirmed Order";
        AmountRecd: Decimal;
    begin
        RConfOrder.GET(AppPayEntry."Document No.");
        CLEAR(Amt);
        CLEAR(UnitLastLineNo);
        CLEAR(TotalAmt);
        CLEAR(ApplyAmt1);
        CLEAR(ApplyAmt);
        Amt := ABS(AppPayEntry.Amount);
        UnitAppPaymentEntry.RESET;
        UnitAppPaymentEntry.SETRANGE("Document No.", OrderNo);
        IF UnitAppPaymentEntry.FINDLAST THEN
            UnitLastLineNo := UnitAppPaymentEntry."Line No.";

        UnitAppPaymentEntry.RESET;
        UnitAppPaymentEntry.SETRANGE("Document No.", OrderNo);
        UnitAppPaymentEntry.SETFILTER("Cheque Status", '<>%1', UnitAppPaymentEntry."Cheque Status"::Bounced);
        UnitAppPaymentEntry.SETRANGE("Transfered MTM", FALSE);
        UnitAppPaymentEntry.ASCENDING(FALSE);
        IF UnitAppPaymentEntry.FINDFIRST THEN
            REPEAT
                TotalAmt := UnitAppPaymentEntry.Amount - UnitAppPaymentEntry."Transfered MTM Received";
                IF (Amt - ApplyAmt1) > TotalAmt THEN
                    ApplyAmt := TotalAmt
                ELSE
                    ApplyAmt := Amt - ApplyAmt1;
                IF ApplyAmt > 0 THEN BEGIN
                    InsertUnitAppLines.INIT;
                    InsertUnitAppLines.TRANSFERFIELDS(UnitAppPaymentEntry);
                    InsertUnitAppLines."Line No." := UnitLastLineNo + 10000;
                    InsertUnitAppLines.Amount := -ABS(ApplyAmt);
                    InsertUnitAppLines."Payment Mode" := AppPayEntry."Payment Mode";
                    InsertUnitAppLines."Payment Method" := AppPayEntry."Payment Method";
                    InsertUnitAppLines.Description := AppPayEntry.Description;
                    InsertUnitAppLines."Cheque No./ Transaction No." := AppPayEntry."Cheque No./ Transaction No.";
                    InsertUnitAppLines."Cheque Date" := AppPayEntry."Cheque Date";
                    InsertUnitAppLines."Cheque Bank and Branch" := AppPayEntry."Cheque Bank and Branch";
                    InsertUnitAppLines."Chq. Cl / Bounce Dt." := AppPayEntry."Chq. Cl / Bounce Dt.";
                    InsertUnitAppLines."Deposit/Paid Bank" := AppPayEntry."Deposit/Paid Bank";
                    InsertUnitAppLines."User ID" := AppPayEntry."User ID";
                    InsertUnitAppLines."Posted Document No." := AppPayEntry."Posted Document No.";
                    InsertUnitAppLines."Posting date" := AppPayEntry."Posting date";
                    InsertUnitAppLines."Shortcut Dimension 1 Code" := AppPayEntry."Shortcut Dimension 1 Code";
                    InsertUnitAppLines."Cheque Status" := AppPayEntry."Cheque Status";
                    InsertUnitAppLines."Explode BOM" := TRUE;
                    InsertUnitAppLines."App. Pay. Entry Line No." := AppPayEntry."Line No.";
                    InsertUnitAppLines."Transfered MTM" := TRUE;
                    InsertUnitAppLines.INSERT;
                    UnitLastLineNo := InsertUnitAppLines."Line No.";
                    UnitPayEntry.GET(UnitAppPaymentEntry."Document Type", UnitAppPaymentEntry."Document No.", UnitAppPaymentEntry."Line No.");
                    UnitPayEntry."Transfered MTM Received" += ABS(ApplyAmt);
                    //UnitAppPaymentEntry."Transfered MTM Received" := UnitAppPaymentEntry."Transfered MTM Received" + ABS(ApplyAmt);
                    IF UnitPayEntry.Amount = UnitPayEntry."Transfered MTM Received" THEN
                        UnitPayEntry."Transfered MTM" := TRUE;
                    UnitPayEntry.MODIFY;
                    ApplyAmt1 := ApplyAmt1 + ABS(InsertUnitAppLines.Amount);

                    IF (AppPayEntry."Commission Reversed" = FALSE) AND (AppPayEntry."Payment Mode" =
                                      AppPayEntry."Payment Mode"::"Refund Bank") THEN BEGIN //120816
                    END ELSE BEGIN //120816
                        IF AppPayEntry."Payment Mode" <> AppPayEntry."Payment Mode"::JV THEN
                            IF AppPayEntry."Payment Mode" <> AppPayEntry."Payment Mode"::MJVM THEN
                                CreateStagingTableAppBond(RConfOrder, InsertUnitAppLines."Line No." / 10000, 1, InsertUnitAppLines.Sequence,
                                InsertUnitAppLines."Cheque No./ Transaction No.", InsertUnitAppLines."Commision Applicable",
                                InsertUnitAppLines."Direct Associate", InsertUnitAppLines."Posting date", InsertUnitAppLines.Amount, InsertUnitAppLines, FALSE
                        ,
                                RConfOrder."Old Process");
                    END;
                    AmountRecd := RConfOrder.AmountRecdAppl(RConfOrder."No.");
                    IF AmountRecd < RConfOrder."Min. Allotment Amount" THEN
                        UpdateStagingtableRefund(RConfOrder."No.");
                END;
            UNTIL UnitAppPaymentEntry.NEXT = 0;
        CheckRefundCommissionLines(RConfOrder."No."); //ALLETDK230213
    end;


    procedure CreateJVApplicationPaymentLine(JVAppPayEntry: Record "Application Payment Entry"; PosDate: Date)
    var
        InsertAppLines: Record "Application Payment Entry";
        JVLastLineNo: Integer;
        CreatUPEryfromConfOrderAPP: Codeunit "Creat UPEry from ConfOrder/APP";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RConOrder: Record "Confirmed Order";
        FormConfimedOrder: Page "Confirmed Order";
        ExcessAmount: Decimal;
    begin
        RConOrder.GET(JVAppPayEntry."Document No.");
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Cheque Bounce JV No. Series");
        InsertAppLines.INIT;
        InsertAppLines.COPY(JVAppPayEntry);
        InsertAppLines.VALIDATE("Payment Mode", InsertAppLines."Payment Mode"::JV); //ALLEDK 110213
        InsertAppLines.VALIDATE("Payment Method", 'CHEQUE');
        InsertAppLines.Amount := ABS(JVAppPayEntry.Amount);
        InsertAppLines.Posted := FALSE;
        InsertAppLines."Posted Document No." := '';
        InsertAppLines.INSERT(TRUE);//ALLETDK180213
        InsertAppLines."Posting date" := PosDate;
        InsertAppLines."Cheque Status" := InsertAppLines."Cheque Status"::Bounced;
        InsertAppLines."Chq. Cl / Bounce Dt." := PosDate;
        InsertAppLines.MODIFY;
        CLEAR(ExcessAmount);
        ExcessAmount := CreatUPEryfromConfOrderAPP.CheckExcessAmount(RConOrder);
        IF ExcessAmount <> 0 THEN
            CreatUPEryfromConfOrderAPP.CreateExcessPaymentTermsLine(RConOrder."No.", ExcessAmount);

        CreatUPEryfromConfOrderAPP.SplitAppPayEntriesforDiscount(InsertAppLines, InsertAppLines."Line No.");
        /*
        BondPaymentEntry2.RESET;
        BondPaymentEntry2.SETRANGE("Document Type","Document Type");
        BondPaymentEntry2.SETRANGE("Document No.","Document No.");
        BondPaymentEntry2.SETRANGE("Cheque No./ Transaction No.","Cheque No./ Transaction No.");
        BondPaymentEntry2.SETFILTER("Cheque Status",BondPaymentEntry2."Cheque Status"::Cleared);
        IF BondPaymentEntry2.FINDSET THEN
        REPEAT
          AmountRecd := Bond.AmountRecdAppl(Bond."No.");
          IF AmountRecd >= Bond."Min. Allotment Amount" THEN
            UpdateStagingtable(Bond."No.");
          CreateStagingTableAppBond(Bond,UnitPayEntry."Line No."/10000,1,UnitPayEntry.Sequence,
          UnitPayEntry."Cheque No./ Transaction No.",UnitPayEntry."Commision Applicable",UnitPayEntry."Direct Associate",
          UnitPayEntry."Posting date",BondInvestmentAmt);

          IF BondPaymentEntry3.GET(BondPaymentEntry2."Document Type",BondPaymentEntry2."Document No.",
          BondPaymentEntry2."Line No.") THEN BEGIN
            BondPaymentEntry3."Cheque Status" := BondPaymentEntry3."Cheque Status"::Bounced;
            BondPaymentEntry3."Chq. Cl / Bounce Dt." := CheqDate;  //190113
            BondPaymentEntry3.MODIFY;
      END;
        UNTIL BondPaymentEntry2.NEXT=0;
        */
        PostBondPayment(RConOrder, FALSE);

    end;


    procedure UpdateStagingtableRefund(ApplicationNo: Code[20])
    var
        CommCreateBuffer: Record "Unit & Comm. Creation Buffer";
    begin
        CommCreateBuffer.RESET;
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Unit No.", ApplicationNo);
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Min. Allotment Amount Not Paid", FALSE);
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Cheque not Cleared", FALSE);
        IF CommCreateBuffer.FINDSET THEN
            REPEAT
                CommCreateBuffer."Min. Allotment Amount Not Paid" := TRUE;
                CommCreateBuffer.MODIFY;
            UNTIL CommCreateBuffer.NEXT = 0;
    end;


    procedure CheckRefundCommissionLines(ApplicationNo: Code[20])
    var
        CommCreateBuffer: Record "Unit & Comm. Creation Buffer";
        CommissionEntry: Record "Commission Entry";
        CreateCommission: Codeunit "Unit and Comm. Creation Job";
        MinAmt: Decimal;
        RecConfOrder: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
    begin
        CommCreateBuffer.RESET;
        CommCreateBuffer.SETRANGE(CommCreateBuffer."Unit No.", ApplicationNo);
        CommCreateBuffer.SETFILTER("Base Amount", '<%1', 0);
        //CommCreateBuffer.SETRANGE(CommCreateBuffer."Min. Allotment Amount Not Paid",FALSE);
        //CommCreateBuffer.SETRANGE(CommCreateBuffer."Cheque not Cleared",FALSE);
        IF CommCreateBuffer.FINDFIRST THEN BEGIN
            CommissionEntry.RESET;
            CommissionEntry.SETRANGE("Application No.", ApplicationNo);
            IF CommissionEntry.FINDFIRST THEN BEGIN
                MinAmt := 0;
                RecConfOrder.GET(CommCreateBuffer."Application No.");
                IF NOT RecConfOrder."Commission Not Generate" THEN BEGIN
                    MinAmt := CreateCommission.CheckMinAmount(CommCreateBuffer."Posting Date", '', CommCreateBuffer."Application No.");
                    CommEntry.RESET;
                    CommEntry.SETRANGE("Application No.", RecConfOrder."No.");
                    IF CommEntry.FINDSET THEN
                        REPEAT
                            MinAmt += CommEntry."Base Amount";
                        UNTIL CommEntry.NEXT = 0;
                    IF MinAmt >= RecConfOrder."Min. Allotment Amount" THEN BEGIN
                        CommCreateBuffer."Bond Created" := TRUE;
                        CommCreateBuffer.MODIFY;
                        IF CommCreateBuffer."Bond Created" THEN
                            CommCreateBuffer.MARK(TRUE);

                        //Commission Creation
                        IF NOT CommCreateBuffer."Commission Created" THEN
                            BondPost.CalculateComission(CommCreateBuffer);

                        //Subsequent RD Installments
                        IF CommCreateBuffer."Installment No." > 1 THEN
                            CommCreateBuffer.MARK(TRUE);
                        //ALLEDK 180113
                    END;
                END;
            END;
        END;
        //Clear Buffer Table
        CommCreateBuffer.MARKEDONLY(TRUE);
        CommCreateBuffer.DELETEALL;
    end;


    procedure CreateProjectChangeLines(JVAppPayEntry: Record "Application Payment Entry"; Positive: Boolean; TotalAmt: Decimal)
    var
        InsertAppLines: Record "Application Payment Entry";
        JVLastLineNo: Integer;
        CreatUPEryfromConfOrderAPP: Codeunit "Creat UPEry from ConfOrder/APP";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RConOrder: Record "Confirmed Order";
        FormConfimedOrder: Page "Confirmed Order";
        ExcessAmount: Decimal;
        CommentLine: Record "Comment Line";
    begin
        RConOrder.GET(JVAppPayEntry."Document No.");
        RConOrder.TESTFIELD("New Project");
        RConOrder.TESTFIELD("New Unit No.");
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Cheque Bounce JV No. Series");
        IF NOT Positive THEN BEGIN
            InsertAppLines.INIT;
            InsertAppLines.COPY(JVAppPayEntry);
            InsertAppLines.VALIDATE("Payment Mode", InsertAppLines."Payment Mode"::JV); //ALLEDK 110213
            InsertAppLines.VALIDATE("Payment Method", 'JV');
            InsertAppLines.VALIDATE(Amount, -TotalAmt);
            InsertAppLines.Posted := FALSE;
            InsertAppLines."Posted Document No." := '';
            //InsertAppLines."Posting date" := WORKDATE;

            //InsertAppLines."Associate Code For Disc" := CreditAppPayEntry."Introducer Code";
            InsertAppLines."Explode BOM" := FALSE;
            //InsertAppLines."Application No." := "Document No.";
            InsertAppLines."Cheque No./ Transaction No." := '';
            InsertAppLines."Cheque Date" := 0D;
            InsertAppLines."Cheque Bank and Branch" := '';
            InsertAppLines."Deposit/Paid Bank" := '';
            InsertAppLines."Deposit / Paid Bank Name" := '';
            InsertAppLines.INSERT(TRUE);//ALLETDK180213
            InsertAppLines."Shortcut Dimension 1 Code" := JVAppPayEntry."Shortcut Dimension 1 Code";
            InsertAppLines."Posting date" := WORKDATE;
            InsertAppLines."Chq. Cl / Bounce Dt." := 0D;
            InsertAppLines."Adjmt. Line No." := InsertAppLines."Line No.";
            InsertAppLines."Not Post JV Entry in MSC" := TRUE;
            CommentLine.RESET;
            CommentLine.SETRANGE("No.", InsertAppLines."Document No.");
            CommentLine.SETRANGE("Comment Type", CommentLine."Comment Type"::" ");
            CommentLine.SETRANGE(Date, WORKDATE);
            IF CommentLine.FINDFIRST THEN BEGIN
                InsertAppLines.Narration := CommentLine.Comment;
                CommentLine.DELETE;
            END ELSE
                InsertAppLines.Narration := '';
            InsertAppLines.MODIFY;
            UnitReversal.BondReverse(JVAppPayEntry."Document No.", FALSE, 0, FALSE);

        END;

        IF Positive THEN BEGIN
            InsertAppLines.RESET;
            InsertAppLines.INIT;
            InsertAppLines.COPY(JVAppPayEntry);
            InsertAppLines.VALIDATE("Payment Mode", InsertAppLines."Payment Mode"::JV); //ALLEDK 110213
            InsertAppLines.VALIDATE("Payment Method", 'JV');
            InsertAppLines.VALIDATE(Amount, TotalAmt);
            InsertAppLines.Posted := FALSE;
            InsertAppLines."Posted Document No." := '';
            //InsertAppLines."Posting date" := WORKDATE;
            InsertAppLines."Shortcut Dimension 1 Code" := RConOrder."New Project";
            //InsertAppLines."Associate Code For Disc" := CreditAppPayEntry."Introducer Code";
            //InsertAppLines."Explode BOM" := TRUE;
            //InsertAppLines."Application No." := "Document No.";
            InsertAppLines."Cheque No./ Transaction No." := '';
            InsertAppLines."Cheque Date" := 0D;
            InsertAppLines."Cheque Bank and Branch" := '';
            InsertAppLines."Deposit/Paid Bank" := '';
            InsertAppLines."Deposit / Paid Bank Name" := '';
            InsertAppLines."Chq. Cl / Bounce Dt." := 0D;
            InsertAppLines.INSERT(TRUE);//ALLETDK180213
            InsertAppLines."Posting date" := WORKDATE;
            InsertAppLines."Adjmt. Line No." := InsertAppLines."Line No." - 10000;
            InsertAppLines.Narration := '';
            InsertAppLines."Not Post JV Entry in MSC" := TRUE;
            InsertAppLines.MODIFY;

            CLEAR(ExcessAmount);
            ExcessAmount := CreatUPEryfromConfOrderAPP.CheckExcessAmount(RConOrder);
            IF ExcessAmount <> 0 THEN
                CreatUPEryfromConfOrderAPP.CreateExcessPaymentTermsLine(RConOrder."No.", ExcessAmount);
            //    CreatUPEryfromConfOrderAPP.RUN(RConOrder);  //BBG2.01 301214
            CreatUPEryfromConfOrderAPP.CreateJVUnitpaymentEntry(RConOrder);  //BBG2.01 301214

            PostBondPayment(RConOrder, FALSE);
            InterComJVEntry(RConOrder);
        END;
    end;


    procedure SendSMS(MobileNo: Text[30]; SMSText: Text[1000])
    var
        SMSUrl: Text[500];
        JSONString: Text;
        FinalJSON: Text;
        SendReceiptSMS: Codeunit "Send Receipt SMS";
        Vendor: Record Vendor;
        LJObject: JsonObject;
        LJArrayData: JsonArray;
        MJObject: JsonObject;
        MJObject2: JsonObject;
        Client: HttpClient;
        Headers: HttpHeaders;
        contentHeaders: HttpHeaders;
        Contant: HttpContent;
        JsonResponse: Text;
        RequestUrl: Text;
        JArray: JsonArray;
        cu: Codeunit Encoding;
        DotNetEncodeing: Codeunit DotNet_Encoding;
        DotNetArray: Codeunit DotNet_Array;
        DotNetArrayBytes: Codeunit DotNet_Array;
        Request: HttpRequestMessage;
        Content: HttpContent;
        RespMsg: Text;
    begin
        //SMSUrl := 'http://api.synapselive.vectramind.in/push.aspx?user=bbgindia1&pass=' + CompInfo."SMS Password" + '&type=1&message='
        //+ SMSText + '&lang=0&mobile=91' + MobileNo + '&senderid=BBGIND';


        //210224 Added new code for check mobile no.

        CLEAR(CheckMobileNoforSMS);
        ExitMessage := CheckMobileNoforSMS.CheckMobileNo(MobileNo, FALSE);
        IF ExitMessage THEN BEGIN
            /*
            CompInfo.GET;
            //StringBuilder := StringBuilder.StringBuilder;
            //StringWriter := StringWriter.StringWriter(StringBuilder);
            //JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);
            //JSONTextWriter.WriteStartObject;
            CreateJSONAttribute('userName', 'bbgindia1');
            CreateJSONAttribute('priority', '0');
            CreateJSONAttribute('referenceId', '1241547676');
            CreateJSONAttribute('msgType', '1');
            CreateJSONAttribute('senderId', 'BBGIND');
            CreateJSONAttribute('message', SMSText);
            JSONTextWriter.WritePropertyName('mobileNumbers');
            JSONTextWriter.WriteStartObject;
            JSONTextWriter.WritePropertyName('messageParams');
            JSONTextWriter.WriteStartArray;
            JSONTextWriter.WriteStartObject;
            CreateJSONAttribute('mobileNumber', '91' + MobileNo);
            JSONTextWriter.WriteEndObject;
            JSONTextWriter.WriteEndArray;
            JSONTextWriter.WriteEndObject;
            CreateJSONAttribute('password', CompInfo."SMS Password");
            JSONTextWriter.WriteEndObject;
            JSON := StringBuilder.ToString();
            JSONString := FORMAT(JSON);
            FinalJSON := JSONString;
            //MESSAGE(FinalJSON);

            //HttpWebRequest := HttpWebRequest.Create('http://api.synapselive.vectramind.in/v1/multichannel/messages/sendsms'); // ALLE AKUL COMENTED 261022
            HttpWebRequest := HttpWebRequest.Create('https://api.me.synapselive.com/v1/multichannel/messages/sendsms');  // ALLE AKUL ADD 261022
            HttpWebRequest.Method := 'POST';
            HttpWebRequest.ContentType := 'application/json';
            TextString := STRSUBSTNO(FinalJSON);
            Encoding := Encoding.UTF8();
            Bytes := Encoding.GetEncoding('iso-8859-1').GetBytes(TextString.ToString);
            HttpWebRequest.ContentLength := TextString.Length;
            HttpWebRequest.GetRequestStream.Write(Bytes, 0, Bytes.Length);
            HttpWebResponse := HttpWebRequest.GetResponse;
            StreamReader := StreamReader.StreamReader(HttpWebResponse.GetResponseStream);
            ResText := StreamReader.ReadToEnd();
            StreamReader.Close();
            *///Need to check the code in UAT

            Clear(JSONTextWriter);
            Clear(MJObject);
            Clear(LJArrayData);
            Clear(MJObject2);
            Clear(FinalJSON);
            CompInfo.GET;
            JSONTextWriter.Add('userName', 'bbgindia1');
            JSONTextWriter.Add('priority', '0');
            JSONTextWriter.Add('referenceId', '1241547676');
            JSONTextWriter.Add('msgType', '1');
            JSONTextWriter.Add('senderId', 'BBGIND');
            JSONTextWriter.Add('message', SMSText);
            MJObject.Add('mobileNumber', '91' + MobileNo);
            LJArrayData.Add(MJObject);
            MJObject2.Add('messageParams', LJArrayData);
            JSONTextWriter.Add('mobileNumbers', MJObject2);
            JSONTextWriter.Add('password', CompInfo."SMS Password");
            JSONString := Format(JSONTextWriter);
            FinalJSON := JSONString;
            Headers := Client.DefaultRequestHeaders();
            TextString := STRSUBSTNO(FinalJSON);
            Bytes := cu.Convert(1200, 28591, TextString);
            RequestUrl := 'https://api.me.synapselive.com/v1/multichannel/messages/sendsms';
            Request.Method := 'POST';
            Content.WriteFrom(Bytes);
            content.GetHeaders(Headers);
            Headers.Remove('Content-Type');
            Headers.Add('Content-Type', 'application/json; charset=utf-8');
            Client.Post(RequestUrl, Content, HttpWebResponse);
            if HttpWebResponse.IsSuccessStatusCode then begin
                HttpWebResponse.Content.ReadAs(RespMsg);
                //                Message(JsonResponse);
            End Else begin
                HttpWebResponse.Content.ReadAs(RespMsg);
                //              Message(RespMsg);
            end;

        END;
        //MESSAGE(ResText);


        // ALLE MM Code Commented
        /*
        //BBG1.00 250613
        IF ISCLEAR(XMLHTTP) THEN
          CREATE(XMLHTTP);
        CompInfo.GET;
        //ALLEDK 300914 Comment and Added code

        //SMSUrl:='http://www.smscountry.com/SAPSendSMS.asp?i=a&User=marami&passwd='+CompInfo."SMS Password"+'&mobilenumber=';
        //SMSUrl+=MobileNo+'&message='+SMSText;
        //SMSUrl+='&App=SAP&sid=bbgind';


        //SMSUrl:='http://mobile.vectramind.in/api/push1.aspx?user=bbgindia&pass='+ 190116 old code
        //SMSUrl:='http://sms.vectramind.in/api/push1.aspx?user=bbgindia&pass='+    old 160217

        //CompInfo."SMS Password"+'&senderid=BBGIND&mobile='+MobileNo+'&lang=0'+'&message='+SMSText+'&cat=2&dlr=0'; old 160217

        //SMSUrl:='https://mobile.vectramind.in/api/push1.aspx?user=bbgindia&pass='+      //New 160217
        //CompInfo."SMS Password"+'&senderid=BBGIND&mobile='+MobileNo+'&lang=0'+'&message='+SMSText+'&cat=2&dlr=1'; //New 160217

        //SMSUrl:= 'http://campaign.vectramind.in//push.aspx?user=bbgindia1&pass='+
        //CompInfo."SMS Password"+'&senderid=BBGIND&mobile='+MobileNo+'&lang=0&message='+SMSText+'&cat=1&dlr'; //old 161117

        //SMSUrl:= 'http://campaign.vectramind.in//push.aspx?user=bbgindia1&pass='+
        //CompInfo."SMS Password"+'&senderid=BBGIND&mobile='+MobileNo+'&lang=0&message='+SMSText+'&dlr=1';

          //ALLEDK 040718
        //SMSUrl:= 'http://synapse2.vectramind.com/push.aspx?user=bbgindia1&pass='+
        //CompInfo."SMS Password"+'&senderid=BBGIND&mobile='+'91'+MobileNo+'&lang=0&message='+SMSText+'&dlr=1';

        SMSUrl:= 'http://api.synapselive.vectramind.in/push.aspx?user=bbgindia1&pass='+CompInfo."SMS Password"+'&type=1&message='
        +SMSText+'&lang=0&mobile=91'+MobileNo+'&senderid=BBGIND';
          //ALLEDK 040718

        //ALLEDK 300914 Comment and Added code

        XMLHTTP.open('GET',SMSUrl,FALSE);
        XMLHTTP.send();
        CLEAR(XMLHTTP);
        //BBG1.00 250613

        */// ALLE MM Code Commented

    end;


    procedure CreateForfeitAppEntry(Application: Record "Confirmed Order"; Description: Text[50])
    var
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        CreditAmt: Decimal;
        PostedDocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UnitPayEntry: Record "Unit Payment Entry";
        Amt: Decimal;
        InsertUnitAppLines: Record "Unit Payment Entry";
        UnitAppPaymentEntry: Record "Unit Payment Entry";
        UnitLastLineNo: Integer;
        TotalAmt: Decimal;
        ApplyAmt1: Decimal;
        ApplyAmt: Decimal;
        AmountRecd: Decimal;
        NewAppPmtEntry: Record "NewApplication Payment Entry";
        OldAppPmtEntry: Record "NewApplication Payment Entry";
    begin
        //ALLEDK 090113

        IF Vend.GET(Application."Introducer Code") THEN;

        BondSetup.GET;
        BondSetup.TESTFIELD("Transfer Member Batch Name");
        BondSetup.TESTFIELD("Transfer Member Temp Name");
        BondSetup.TESTFIELD("Forfeit Account");
        BondSetup.TESTFIELD("Excess Payment Account");
        UserSetup.GET(USERID);

        GenJnlLine.RESET;
        GenJnlLine.SETFILTER("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETFILTER("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;


        PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Discount No. Sereies", WORKDATE, TRUE);
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
        GenJnlLine."Line No." := 1000;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := PostedDocNo;
        GenJnlLine.VALIDATE("Posting Date", WORKDATE); //ALLETDK
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", Application."Customer No.");
        GenJnlLine.VALIDATE(Amount, Application."Forfeiture / Excess Amount");
        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
        GenJnlLine."Order Ref No." := Application."Application No.";
        GenJnlLine."Branch Code" := UserSetup."User Branch";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
        GenJnlLine."Introducer Code" := Application."Introducer Code";
        GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        IF Application."Discount Payment Type" = Application."Discount Payment Type"::Forfeit THEN BEGIN
            GenJnlLine."Bal. Account No." := BondSetup."Forfeit Account";
            CheckCostCode(BondSetup."Forfeit Account");
        END ELSE BEGIN
            GenJnlLine."Bal. Account No." := BondSetup."Excess Payment Account";
            CheckCostCode(BondSetup."Excess Payment Account");
        END;

        GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
        GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
        GenJnlLine."External Document No." := PostedDocNo;
        GenJnlLine.INSERT;
        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", Description);
        InsertJnDimension(GenJnlLine);
        CLEAR(GenJnlPostLine);
        GenJnlPostLine.RunWithCheck(GenJnlLine);  //ALLEDK 310113
                                                  //JournalLineDimension.DELETEALL; // ALLE MM Code Commented

        LastLineNo := 0;
        NewLineNo := 0;
        CLEAR(AppPaymentEntry);
        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document No.", Application."No.");
        IF AppPaymentEntry.FINDLAST THEN
            LastLineNo := AppPaymentEntry."Line No.";

        InsertAppLines.INIT;
        InsertAppLines."Document Type" := InsertAppLines."Document Type"::BOND;
        InsertAppLines."Document No." := Application."No.";
        InsertAppLines."Line No." := LastLineNo + 10000;
        InsertAppLines.VALIDATE("Payment Mode", InsertAppLines."Payment Mode"::"Negative Adjmt."); //ALLEDK 110213
        InsertAppLines."Payment Method" := 'JV';
        InsertAppLines.Amount := -Application."Forfeiture / Excess Amount";   //ALLEDK 250113
        InsertAppLines.Posted := TRUE;
        InsertAppLines."Unit Code" := Application."Unit Code"; //ALLEDK 110213
        InsertAppLines."Posted Document No." := PostedDocNo;
        InsertAppLines."Posting date" := WORKDATE;
        InsertAppLines."Document Date" := TODAY;
        InsertAppLines."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
        InsertAppLines."Explode BOM" := TRUE;
        InsertAppLines."Application No." := Application."No.";
        NewLineNo := InsertAppLines."Line No.";
        InsertAppLines.Narration := Description;//ALLECK 130413
        InsertAppLines."Discount Payment Type" := Application."Discount Payment Type";
        InsertAppLines.INSERT;
        //  --Entry Create in Master company- START--------- 210115
        LastLineNo := 0;
        OldAppPmtEntry.RESET;
        OldAppPmtEntry.SETRANGE("Document No.", Application."No.");
        IF OldAppPmtEntry.FINDLAST THEN
            LastLineNo := OldAppPmtEntry."Line No.";

        NewAppPmtEntry.INIT;
        NewAppPmtEntry."Document Type" := NewAppPmtEntry."Document Type"::BOND;
        NewAppPmtEntry."Document No." := Application."No.";
        NewAppPmtEntry."Line No." := LastLineNo + 10000;
        NewAppPmtEntry."Payment Mode" := NewAppPmtEntry."Payment Mode"::"Negative Adjmt."; //ALLEDK 110213
        NewAppPmtEntry."Payment Method" := 'JV';
        NewAppPmtEntry.Amount := -Application."Forfeiture / Excess Amount";   //ALLEDK 250113
        NewAppPmtEntry."Document Date" := WORKDATE;
        NewAppPmtEntry."User ID" := USERID;
        NewAppPmtEntry.Posted := TRUE;
        NewAppPmtEntry."Cheque Status" := NewAppPmtEntry."Cheque Status"::Cleared;
        NewAppPmtEntry."Unit Code" := Application."Unit Code"; //ALLEDK 110213
        NewAppPmtEntry."Posted Document No." := PostedDocNo;
        NewAppPmtEntry."Posting date" := WORKDATE;
        NewAppPmtEntry."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
        NewAppPmtEntry."Explode BOM" := TRUE;
        NewAppPmtEntry."Application No." := Application."No.";
        NewAppPmtEntry."Create from MSC Company" := FALSE;
        NewAppPmtEntry."Discount Payment Type" := Application."Discount Payment Type";
        NewAppPmtEntry."Receipt post on InterComp" := TRUE;
        NewAppPmtEntry.INSERT;

        //  --Entry Create in Master company- END--------- 210115

        CLEAR(Amt);
        CLEAR(UnitLastLineNo);
        CLEAR(TotalAmt);
        CLEAR(ApplyAmt1);
        CLEAR(ApplyAmt);
        Amt := ABS(Application."Forfeiture / Excess Amount");
        UnitAppPaymentEntry.RESET;
        UnitAppPaymentEntry.SETRANGE("Document No.", Application."No.");
        IF UnitAppPaymentEntry.FINDLAST THEN
            UnitLastLineNo := UnitAppPaymentEntry."Line No.";

        UnitAppPaymentEntry.RESET;
        UnitAppPaymentEntry.SETRANGE("Document No.", Application."No.");
        UnitAppPaymentEntry.SETFILTER("Cheque Status", '<>%1', UnitAppPaymentEntry."Cheque Status"::Bounced);
        UnitAppPaymentEntry.SETRANGE("Transfered MTM", FALSE);
        UnitAppPaymentEntry.ASCENDING(FALSE);
        IF UnitAppPaymentEntry.FINDFIRST THEN
            REPEAT
                TotalAmt := UnitAppPaymentEntry.Amount - UnitAppPaymentEntry."Transfered MTM Received";
                IF (Amt - ApplyAmt1) > TotalAmt THEN
                    ApplyAmt := TotalAmt
                ELSE
                    ApplyAmt := Amt - ApplyAmt1;
                IF ApplyAmt > 0 THEN BEGIN
                    InsertUnitAppLines.INIT;
                    InsertUnitAppLines.TRANSFERFIELDS(UnitAppPaymentEntry);
                    InsertUnitAppLines."Line No." := UnitLastLineNo + 10000;
                    InsertUnitAppLines.Amount := -ABS(ApplyAmt);
                    InsertUnitAppLines."Payment Mode" := InsertUnitAppLines."Payment Mode"::"Negative Adjmt.";
                    InsertUnitAppLines."Payment Method" := 'JV';
                    InsertUnitAppLines.Description := Description;
                    InsertUnitAppLines."User ID" := USERID;
                    InsertUnitAppLines."Posted Document No." := PostedDocNo;
                    InsertUnitAppLines."Posting date" := WORKDATE;
                    InsertUnitAppLines."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    InsertUnitAppLines."Cheque Status" := InsertUnitAppLines."Cheque Status"::Cleared;
                    InsertUnitAppLines."Explode BOM" := TRUE;
                    InsertUnitAppLines."App. Pay. Entry Line No." := InsertAppLines."Line No.";
                    InsertUnitAppLines."Discount Payment Type" := Application."Discount Payment Type";
                    InsertUnitAppLines."Transfered MTM" := TRUE;
                    InsertUnitAppLines.INSERT;
                    UnitLastLineNo := InsertUnitAppLines."Line No.";
                    UnitPayEntry.GET(UnitAppPaymentEntry."Document Type", UnitAppPaymentEntry."Document No.", UnitAppPaymentEntry."Line No.");
                    UnitPayEntry."Transfered MTM Received" += ABS(ApplyAmt);
                    IF UnitPayEntry.Amount = UnitPayEntry."Transfered MTM Received" THEN
                        UnitPayEntry."Transfered MTM" := TRUE;
                    UnitPayEntry.MODIFY;
                    ApplyAmt1 := ApplyAmt1 + ABS(InsertUnitAppLines.Amount);
                    AmountRecd := Application.AmountRecdAppl(Application."No.");
                    IF AmountRecd < Application."Min. Allotment Amount" THEN
                        UpdateStagingtableRefund(Application."No.");
                END;
            UNTIL UnitAppPaymentEntry.NEXT = 0;
        //CheckRefundCommissionLines(RConfOrder."No."); //ALLETDK230213
    end;


    procedure CheckPaymentPlanDetails(RecConfirmOder: Record "Confirmed Order")
    var
        RecPayPlanDetails: Record "Payment Plan Details";
    begin
        RecPayPlanDetails.RESET;
        RecPayPlanDetails.SETRANGE("Document No.", RecConfirmOder."No.");
        IF NOT RecPayPlanDetails.FINDFIRST THEN
            ERROR('Payment Plan details not define for Application No.' + RecConfirmOder."No.");
    end;


    procedure UpdateUnit_ComBufferAmt(RecUnitPayEntry: Record "Unit Payment Entry"; FromApplication: Boolean): Decimal
    var
        PTLineSale: Record "Payment Terms Line Sale";
        PTLineSale1: Record "Payment Terms Line Sale";
        ProjectMilestoneLine: Record "Project Milestone Line";
        ProjectMilestoneHdr: Record "Project Milestone Header";
        RecApplication1: Record Application;
        UnitBufferAmt: Decimal;
        RecConforder1: Record "Confirmed Order";
        AppAmt: Decimal;
        AppPaymentEntry1: Record "Application Payment Entry";
        FullAmountRcvd: Boolean;
        UnitPEntry: Record "Unit Payment Entry";
        BalanceAmt: Decimal;
        OnFullPmt: Boolean;
        AssoBalanceAmt: Decimal;
        TotalBalAmt: Decimal;
        TotalAssBalAmt: Decimal;
        AppCharge: Record "Applicable Charges";
        UnitPmtEntry: Record "Unit Payment Entry";
        TotalAmt: Decimal;
        ExistCommAmt: Decimal;
        Firstmileston: Decimal;
        Secondmileston: Decimal;
        PaymentTermLineSale: Record "Payment Terms Line Sale";
        MilestonSequence: Code[10];
        DelUPEntry: Record "Unit Payment Entry";
        OldUnitPmtEntry: Record "Unit Payment Entry";
        OldUnitPmtEntry1: Record "Unit Payment Entry";
        RcptAmt_1: Decimal;
        UnitBufferAmt1: Decimal;
    begin
        CLEAR(ComHoldDate);
        CLEAR(PostDate);
        CLEAR(PTLineSale);
        CLEAR(RecApplication1);
        CLEAR(AppAmt);
        CLEAR(RecConforder1);
        CLEAR(BalanceAmt);
        FullAmountRcvd := FALSE;
        IF FromApplication THEN BEGIN
            IF RecApplication1.GET(RecUnitPayEntry."Application No.") THEN
                AppAmt := RecApplication1."Investment Amount";
            PostDate := RecApplication1."Posting Date";
        END ELSE BEGIN
            IF RecConforder1.GET(RecUnitPayEntry."Application No.") THEN
                AppAmt := RecConforder1.Amount;
            PostDate := RecConforder1."Posting Date";
        END;

        ComHoldDate := DMY2DATE(31, 10, 2014);

        IF PostDate > ComHoldDate THEN BEGIN

            AppPaymentEntry1.RESET;
            AppPaymentEntry1.SETCURRENTKEY(AppPaymentEntry1."Document No.", AppPaymentEntry1."Cheque Status");
            AppPaymentEntry1.SETRANGE("Document No.", RecUnitPayEntry."Application No.");
            AppPaymentEntry1.SETRANGE("Cheque Status", AppPaymentEntry1."Cheque Status"::Cleared);
            IF AppPaymentEntry1.FINDSET THEN BEGIN
                AppPaymentEntry1.CALCSUMS(AppPaymentEntry1.Amount);
                IF AppPaymentEntry1.Amount >= AppAmt THEN
                    FullAmountRcvd := TRUE;
            END;

            //NEW......................
            AppCharge.RESET;
            AppCharge.SETRANGE("Document No.", RecUnitPayEntry."Application No.");
            AppCharge.SETRANGE("Commision Applicable", TRUE);
            AppCharge.SETRANGE(Code, RecUnitPayEntry."Charge Code");
            IF AppCharge.FINDFIRST THEN BEGIN
                TotalAmt := 0;
                UnitBufferAmt1 := 0;
                Firstmileston := 0;
                Secondmileston := 0;
                CLEAR(PaymentTermLineSale);
                PaymentTermLineSale.RESET;
                PaymentTermLineSale.SETRANGE("Document No.", AppCharge."Document No.");
                PaymentTermLineSale.SETRANGE("Charge Code", AppCharge.Code);
                IF PaymentTermLineSale.FINDFIRST THEN BEGIN
                    Firstmileston := PaymentTermLineSale."First Milestone %";
                    Secondmileston := PaymentTermLineSale."Second Milestone %";
                    MilestonSequence := PaymentTermLineSale.Sequence;
                END;
                CLEAR(PaymentTermLineSale);
                PaymentTermLineSale.RESET;
                PaymentTermLineSale.SETRANGE("Document No.", AppCharge."Document No.");
                PaymentTermLineSale.SETRANGE("Commision Applicable", TRUE);
                //   PaymentTermLineSale.SETRANGE("Charge Code",AppCharge.Code);
                IF PaymentTermLineSale.FINDSET THEN
                    REPEAT
                        TotalAmt := TotalAmt + PaymentTermLineSale."Criteria Value / Base Amount";
                        IF (PaymentTermLineSale."First Milestone %" + PaymentTermLineSale."Second Milestone %") > 1 THEN
                            UnitBufferAmt1 := UnitBufferAmt1 + ((PaymentTermLineSale."Criteria Value / Base Amount") *
                               PaymentTermLineSale."First Milestone %" / 100)
                        ELSE
                            UnitBufferAmt1 := UnitBufferAmt1 + ((PaymentTermLineSale."Criteria Value / Base Amount"));

                    UNTIL PaymentTermLineSale.NEXT = 0;

                CLEAR(OldUnitPmtEntry1);
                OldUnitPmtEntry1.RESET;
                OldUnitPmtEntry1.SETRANGE("Document No.", AppCharge."Document No.");
                OldUnitPmtEntry1.SETFILTER("Line No.", '<=%1', RecUnitPayEntry."Line No.");
                OldUnitPmtEntry1.SETRANGE("Commision Applicable", TRUE);
                IF OldUnitPmtEntry1.FINDSET THEN
                    REPEAT
                        RcptAmt_1 := RcptAmt_1 + OldUnitPmtEntry1.Amount;
                    UNTIL OldUnitPmtEntry1.NEXT = 0;

                IF ((ROUND(UnitBufferAmt1, 1) - ROUND(RcptAmt_1, 1)) >= 0) THEN
                    UnitBufferAmt := RecUnitPayEntry.Amount
                ELSE BEGIN
                    UnitBufferAmt := RecUnitPayEntry.Amount + (UnitBufferAmt1 - RcptAmt_1);
                    IF UnitBufferAmt < 0 THEN
                        UnitBufferAmt := 0;

                    CLEAR(OldUnitPmtEntry1);
                    OldUnitPmtEntry1.RESET;
                    OldUnitPmtEntry1.SETRANGE("Document No.", AppCharge."Document No.");
                    OldUnitPmtEntry1.SETFILTER("Balance Amount", '<>%1', 0);
                    IF OldUnitPmtEntry1.FINDSET THEN
                        REPEAT
                            OldUnitPmtEntry1."Balance Amount" := 0;
                            OldUnitPmtEntry1.MODIFY;
                        UNTIL OldUnitPmtEntry1.NEXT = 0;


                    CLEAR(OldUnitPmtEntry1);
                    OldUnitPmtEntry1.RESET;
                    OldUnitPmtEntry1.SETRANGE("Document No.", AppCharge."Document No.");
                    OldUnitPmtEntry1.SETRANGE("Line No.", RecUnitPayEntry."Line No.");
                    IF OldUnitPmtEntry1.FINDFIRST THEN BEGIN
                        OldUnitPmtEntry1."Balance Amount" := ABS(RcptAmt_1 - UnitBufferAmt1);
                        OldUnitPmtEntry1.MODIFY;
                    END;
                END;
                //    UNTIL AppCharge.NEXT =0;
            END ELSE
                IF RecUnitPayEntry."Direct Associate" THEN //100219
                    UnitBufferAmt := RecUnitPayEntry.Amount;


            CLEAR(UnitPmtEntry);
            UnitPmtEntry.RESET;
            UnitPmtEntry.SETRANGE(UnitPmtEntry."Document No.", AppCharge."Document No.");
            UnitPmtEntry.SETFILTER("Line No.", '>%1', RecUnitPayEntry."Line No.");
            IF NOT UnitPmtEntry.FINDFIRST THEN BEGIN
                IF FullAmountRcvd THEN BEGIN
                    AssoBalanceAmt := 0;
                    CLEAR(UnitPEntry);
                    UnitPEntry.RESET;
                    UnitPEntry.SETCURRENTKEY("Document No.", "Charge Code");
                    UnitPEntry.SETRANGE(UnitPEntry."Document No.", RecUnitPayEntry."Document No.");
                    UnitPEntry.SETFILTER(UnitPEntry."Balance Amount", '<>%1', 0);
                    IF UnitPEntry.FINDSET THEN BEGIN
                        REPEAT
                            BalanceAmt := 0;
                            PTLineSale1.RESET;
                            PTLineSale1.SETCURRENTKEY("Document No.", "Charge Code");
                            PTLineSale1.SETRANGE("Document No.", RecUnitPayEntry."Application No.");
                            PTLineSale1.SETRANGE("Charge Code", UnitPEntry."Charge Code");
                            PTLineSale1.SETRANGE("Direct Associate", UnitPEntry."Direct Associate");
                            IF PTLineSale1.FINDFIRST THEN BEGIN
                                BalanceAmt := 0;
                                BalanceAmt := UnitPEntry."Balance Amount";
                                UnitPEntry."Balance Amount" := 0;
                                UnitPEntry.MODIFY;
                            END;

                            IF FromApplication THEN
                                CreateStaggingforBalAmt(UnitPEntry, BalanceAmt, TRUE)
                            ELSE
                                CreateStaggingforBalAmt(UnitPEntry, BalanceAmt, FALSE);
                        UNTIL UnitPEntry.NEXT = 0;
                    END;
                END;
            END;
        END ELSE BEGIN
            UnitBufferAmt := RecUnitPayEntry.Amount;
            EXIT(UnitBufferAmt);
        END;

        IF (RecUnitPayEntry."Payment Mode" = RecUnitPayEntry."Payment Mode"::JV) AND (RecUnitPayEntry.Amount < 0) THEN BEGIN
            EXIT(UnitBufferAmt);
        END ELSE
            EXIT(ABS(UnitBufferAmt));
    end;


    procedure CreateStaggingforBalAmt(RecUnitPayEntry1: Record "Unit Payment Entry"; PendingAmt: Decimal; FromAplication: Boolean)
    var
        RecInitialStagingTab: Record "Unit & Comm. Creation Buffer";
        RecInitialStagingTab1: Record "Unit & Comm. Creation Buffer";
        Application: Record Application;
        FromConfirmedOrder: Record "Confirmed Order";
        InstallationNo: Integer;
    begin

        RecInitialStagingTab1.RESET;
        RecInitialStagingTab1.SETRANGE("Unit No.", RecUnitPayEntry1."Document No.");
        IF RecInitialStagingTab1.FINDLAST THEN
            InstallationNo := RecInitialStagingTab1."Installment No.";

        IF FromAplication THEN BEGIN
            IF Application.GET(RecUnitPayEntry1."Document No.") THEN;
            RecInitialStagingTab.INIT;
            RecInitialStagingTab."Unit No." := Application."Application No.";
            RecInitialStagingTab."Installment No." := InstallationNo + 1;
            RecInitialStagingTab."Posting Date" := Application."Posting Date";
            RecInitialStagingTab.VALIDATE("Introducer Code", Application."Associate Code");
            RecInitialStagingTab."Base Amount" := PendingAmt;
            RecInitialStagingTab.VALIDATE("Project Type", Application."Project Type");
            RecInitialStagingTab.Duration := Application.Duration;
            //  RecInitialStagingTab."Year Code" := YearCode;
            RecInitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
            RecInitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
            RecInitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
            RecInitialStagingTab."Application No." := Application."Application No.";
            RecInitialStagingTab."Paid by cheque" := FALSE;
            //  RecInitialStagingTab."Bond Created" := Bond.GET(RecRecInitialStagingTab."Unit No.");
            RecInitialStagingTab."Commission Created" := FALSE;
            RecInitialStagingTab."Direct Associate" := RecUnitPayEntry1."Direct Associate";
            RecInitialStagingTab."Comm Not Release after FullPmt" := TRUE;
            RecInitialStagingTab.INSERT;
        END ELSE BEGIN
            IF FromConfirmedOrder.GET(RecUnitPayEntry1."Document No.") THEN;
            RecInitialStagingTab.INIT;
            RecInitialStagingTab."Unit No." := FromConfirmedOrder."No.";
            RecInitialStagingTab."Installment No." := InstallationNo + 1;
            RecInitialStagingTab."Posting Date" := FromConfirmedOrder."Posting Date";
            RecInitialStagingTab.VALIDATE("Introducer Code", FromConfirmedOrder."Introducer Code");
            RecInitialStagingTab."Base Amount" := PendingAmt;
            RecInitialStagingTab.VALIDATE("Project Type", FromConfirmedOrder."Project Type");
            RecInitialStagingTab.Duration := FromConfirmedOrder.Duration;
            //RecInitialStagingTab."Year Code" := YearCode;
            RecInitialStagingTab.VALIDATE("Investment Type", FromConfirmedOrder."Investment Type");
            RecInitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", FromConfirmedOrder."Shortcut Dimension 1 Code");
            RecInitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", FromConfirmedOrder."Shortcut Dimension 2 Code");
            RecInitialStagingTab."Application No." := FromConfirmedOrder."Application No.";
            RecInitialStagingTab."Paid by cheque" := FALSE;
            //  RecInitialStagingTab."Bond Created" := Bond.GET(RecRecInitialStagingTab."Unit No.");
            RecInitialStagingTab."Commission Created" := FALSE;
            RecInitialStagingTab."Direct Associate" := RecUnitPayEntry1."Direct Associate";
            RecInitialStagingTab."Comm Not Release after FullPmt" := FromConfirmedOrder."Commission Hold on Full Pmt";
            RecInitialStagingTab."Charge Code" := RecUnitPayEntry1."Charge Code";
            RecInitialStagingTab."Unit Payment Line No." := RecUnitPayEntry1."Line No.";
            RecInitialStagingTab."Creation Date" := TODAY;
            RecInitialStagingTab.INSERT;
        END;
    end;


    procedure "----posting from main comp.."()
    begin
    end;


    procedure NewCreateApplicationGenJnlLine(NewApplication: Record "New Application Booking"; Description: Text[50])
    var
        BondPaymentEntry: Record "NewApplication Payment Entry";
        Line: Integer;
        CashAmount: Decimal;
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
        CompanywiseGLAccount: Record "Company wise G/L Account";
    begin
        IF Vend.GET(NewApplication."Associate Code") THEN;
        NarrationText1 := 'Appl. Received - ' + COPYSTR(NewApplication."Customer Name", 1, 30);
        NarrationText2 := 'MM Code(' + NewApplication."Associate Code" + ') ' + COPYSTR(Vend.Name, 1, 30);


        UnitSetup.GET;

        GenJnlLine.RESET;
        GenJnlLine.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        //IF GenJnlLine.Findset then
        GenJnlLine.DELETEALL;

        Line := 10000;
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::Application);
        BondPaymentEntry.SETRANGE("Document No.", NewApplication."Application No.");
        //SETRANGE(Posted,FALSE);
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" IN [BondPaymentEntry."Payment Mode"::Bank, BondPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking",
                BondPaymentEntry."Payment Mode"::"D.D."])) THEN BEGIN
                    ApplBankAmount += BondPaymentEntry.Amount;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
                    GenJnlLine.VALIDATE("Document Date", NewApplication."Document Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Account No.", BondPaymentEntry."Deposit/Paid Bank");
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := NewApplication."Posted Doc No.";
                    GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Source No.", BondPaymentEntry."Deposit/Paid Bank");
                    GenJnlLine."Posting Group" := NewApplication."Bond Posting Group";
                    GenJnlLine."Shortcut Dimension 1 Code" := NewApplication."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := NewApplication."Shortcut Dimension 2 Code";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Introducer Code" := NewApplication."Associate Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                    GenJnlLine."Unit No." := NewApplication."Unit Code";
                    GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10);//ALLE-AM
                    GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                    GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                    GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                    GenJnlLine.Description := NewApplication."Customer No.";
                    GenJnlLine."Payment Mode" := BondPaymentEntry."Payment Mode"; //ALLEDK 030313
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := NewApplication."Received From Code";
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("Company Code", NewApplication."Company Name");
                    IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                        CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Payable Account");
                    END;

                    GenJnlLine.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Payable Account");
                    GenJnlLine."Shortcut Dimension 1 Code" := NewApplication."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := NewApplication."Shortcut Dimension 2 Code";
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Line No."; //ALLEDK 10112016

                    GenJnlLine.INSERT;
                    InsertJnDimension(GenJnlLine);
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                    Line := Line + 10000;
                END;
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash)) THEN BEGIN
                    CashAmount += BondPaymentEntry.Amount;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
                    GenJnlLine.VALIDATE("Document Date", NewApplication."Document Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", UnitReversal.GetCashAccountNo(BondPaymentEntry."User Branch Code"));
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := NewApplication."Posted Doc No.";
                    GenJnlLine."Bond Posting Group" := NewApplication."Bond Posting Group";
                    GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Introducer Code" := NewApplication."Associate Code";
                    GenJnlLine."Unit No." := NewApplication."Unit Code";
                    GenJnlLine."Installment No." := 1;
                    GenJnlLine.Description := NewApplication."Customer No.";
                    GenJnlLine."Payment Mode" := BondPaymentEntry."Payment Mode"; //ALLEDK 030313
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := NewApplication."Received From Code";
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("Company Code", NewApplication."Company Name");
                    IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                        CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Payable Account");
                    END;

                    GenJnlLine.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Payable Account");
                    GenJnlLine."Shortcut Dimension 1 Code" := NewApplication."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := NewApplication."Shortcut Dimension 2 Code";

                    GenJnlLine.INSERT;
                    InsertJnDimension(GenJnlLine);
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                    Line := Line + 10000;
                END;
            UNTIL BondPaymentEntry.NEXT = 0;

        PostGenJnlLines(GenJnlLine."Document No.");
        UnitMaster.GET(NewApplication."Unit Code");
        UnitMaster.VALIDATE(Status, UnitMaster.Status::Booked);
        UnitMaster.MODIFY;
        WebAppService.UpdateUnitStatus(UnitMaster);  //210624
    end;


    procedure NewPostBondPayment(Application: Record "New Confirmed Order"; Description: Text[50])
    var
        BondPaymentEntry: Record "NewApplication Payment Entry";
        Line: Integer;
        CashAmount: Decimal;
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        ApplBankAmount: Decimal;
        CompanywiseGLAccount: Record "Company wise G/L Account";
    begin
        UnitSetup.GET;
        CLEAR(BondPaymentEntry);
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
        BondPaymentEntry.SETRANGE("Document No.", Application."No.");
        BondPaymentEntry.SETRANGE(Posted, FALSE);//ALLE PS
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                IF (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash) OR
                   (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank) THEN
                    BondPaymentEntry."Posted Document No." := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
                IF (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"Refund Cash") OR
                   (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"Refund Bank") THEN
                    BondPaymentEntry."Posted Document No." := NoSeriesMgt.GetNextNo(UnitSetup."Refund No. Series", WORKDATE, TRUE);

                IF (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"Negative Adjmt.") THEN
                    BondPaymentEntry."Posted Document No." := NoSeriesMgt.GetNextNo(UnitSetup."Adjustment Entry No. Series", WORKDATE, TRUE);

                IF BondPaymentEntry."Bank Type" = BondPaymentEntry."Bank Type"::ProjectCompany THEN BEGIN
                    BondPaymentEntry.Posted := TRUE;
                END;
                BondPaymentEntry."BarCode No." := NoSeriesMgt.GetNextNo(UnitSetup."Bar Code no. Series", TODAY, TRUE);  //12122016
                BondPaymentEntry.MODIFY;
            UNTIL BondPaymentEntry.NEXT = 0;

        CLEAR(BondPaymentEntry);
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
        BondPaymentEntry.SETRANGE("Document No.", Application."No.");
        BondPaymentEntry.SETFILTER("Bank Type", '<>%1', BondPaymentEntry."Bank Type"::ProjectCompany);
        BondPaymentEntry.SETRANGE(Posted, FALSE);
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" IN [BondPaymentEntry."Payment Mode"::Bank, BondPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking",
                BondPaymentEntry."Payment Mode"::"D.D."])) THEN BEGIN
                    UnitSetup.GET;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Account No.", BondPaymentEntry."Deposit/Paid Bank");
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Source No.", BondPaymentEntry."Deposit/Paid Bank");
                    GenJnlLine."Order Ref No." := Application."Application No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry."Milestone Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10);//ALLE-AM
                    GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                    GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                    GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                    GenJnlLine.Description := Application."Customer No.";
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("Company Code", Application."Company Name");
                    IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                        CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Payable Account");
                    END;

                    GenJnlLine.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Payable Account");
                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    InsertJnDimension(GenJnlLine);
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", GenJnlLine.Description);
                    Line := Line + 10000;
                END;
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash)) THEN BEGIN
                    UnitSetup.GET;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", UnitReversal.GetCashAccountNo(BondPaymentEntry."User Branch Code"));
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    ;
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Order Ref No." := Application."Application No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry."Milestone Code";
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    GenJnlLine."Installment No." := 1;
                    GenJnlLine.Description := Application."Customer No.";
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                    Application.TESTFIELD(Application."Company Name");
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("Company Code", Application."Company Name");
                    IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                        CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Payable Account");
                    END;

                    GenJnlLine.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Payable Account");
                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";

                    GenJnlLine.INSERT;
                    InsertJnDimension(GenJnlLine);
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", GenJnlLine.Description);
                    Line := Line + 10000;
                END;
                IF ((BondPaymentEntry.Amount < 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"Refund Cash")) THEN BEGIN
                    UnitSetup.GET;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", UnitReversal.GetCashAccountNo(BondPaymentEntry."User Branch Code"));
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    ;
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Order Ref No." := Application."Application No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry."Milestone Code";
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    GenJnlLine."Installment No." := 1;
                    GenJnlLine.Description := Application."Customer No.";
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                    Application.TESTFIELD(Application."Company Name");
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("Company Code", Application."Company Name");
                    IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                        CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Payable Account");
                    END;

                    GenJnlLine.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Payable Account");
                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";

                    GenJnlLine.INSERT;
                    InsertJnDimension(GenJnlLine);
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", GenJnlLine.Description);
                    Line := Line + 10000;
                END;
                IF ((BondPaymentEntry.Amount < 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"Refund Bank")) THEN BEGIN
                    UnitSetup.GET;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Account No.", BondPaymentEntry."Deposit/Paid Bank");
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Source No.", BondPaymentEntry."Deposit/Paid Bank");
                    GenJnlLine."Order Ref No." := Application."Application No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry."Milestone Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10);//ALLE-AM
                    GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                    GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                    GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                    GenJnlLine.Description := Application."Customer No.";
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("Company Code", Application."Company Name");
                    IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                        CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Payable Account");
                    END;

                    GenJnlLine.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Payable Account");
                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    InsertJnDimension(GenJnlLine);
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", GenJnlLine.Description);
                    Line := Line + 10000;
                END;
                IF ((BondPaymentEntry.Amount < 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"Negative Adjmt.")) THEN BEGIN
                    UnitSetup.GET;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", UnitReversal.GetCashAccountNo(BondPaymentEntry."User Branch Code"));
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    ;
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Order Ref No." := Application."Application No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry."Milestone Code";
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    GenJnlLine."Installment No." := 1;
                    GenJnlLine.Description := Application."Customer No.";
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                    Application.TESTFIELD(Application."Company Name");
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("Company Code", Application."Company Name");
                    IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                        CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Payable Account");
                    END;

                    GenJnlLine.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Payable Account");
                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";

                    GenJnlLine.INSERT;
                    InsertJnDimension(GenJnlLine);
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", GenJnlLine.Description);
                    Line := Line + 10000;
                END;



                PostGenJnlLines(GenJnlLine."Document No.");
                BondPaymentEntry.Posted := TRUE;
                BondPaymentEntry.MODIFY;
            UNTIL BondPaymentEntry.NEXT = 0;
    end;


    procedure "-----Posting from Inter comp.."()
    begin
    end;


    procedure InterComCreateApplGenJnlLines(Application: Record Application; Description: Text[50])
    var
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
        IF Vend.GET(Application."Associate Code") THEN;
        NarrationText1 := 'Appl. Received - ' + COPYSTR(Application."Customer Name", 1, 30);
        NarrationText2 := 'MM Code(' + Application."Associate Code" + ') ' + COPYSTR(Vend.Name, 1, 30);


        UnitSetup.GET;

        GenJnlLine.RESET;
        GenJnlLine.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        //IF GenJnlLine.Findset then
        GenJnlLine.DELETEALL;

        Line := 10000;
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::Application);
        BondPaymentEntry.SETRANGE("Document No.", Application."Application No.");
        //SETRANGE(Posted,FALSE);
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                IF BondPaymentEntry.Amount > 0 THEN BEGIN
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    //GenJnlLine.INSERT(); // AKUL
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //BBG1.00 ALLEDK 120313
                    GenJnlLine.VALIDATE("Document Date", Application."Document Date");
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    CompanyGLAccount.RESET;
                    CompanyGLAccount.SETRANGE(CompanyGLAccount."MSC Company", TRUE);
                    IF CompanyGLAccount.FINDFIRST THEN;
                    GenJnlLine.VALIDATE("Account No.", CompanyGLAccount."Receivable Account");
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := Application."Posted Doc No.";
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                    GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Introducer Code" := Application."Associate Code";
                    GenJnlLine."Unit No." := Application."Unit Code";
                    GenJnlLine."Installment No." := 1;
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    IF (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash) THEN
                        GenJnlLine.Description := 'Cash Received'
                    ELSE
                        GenJnlLine.Description := 'Amount transferred';

                    GenJnlLine."Payment Mode" := BondPaymentEntry."Payment Mode"; //ALLEDK 030313
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.VALIDATE("Bal. Account No.", Application."Customer No.");

                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    //GenJnlLine.MODIFY; // AKUL
                    InsertJnDimension(GenJnlLine);
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                    Line := Line + 10000;
                END;
            UNTIL BondPaymentEntry.NEXT = 0;
    end;


    procedure InterCreateBondGenJnlLines(Application: Record "Confirmed Order"; Description: Text[50])
    var
        BondPaymentEntry: Record "Application Payment Entry";
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        Application1: Record Application;
        BondBankAmount: Decimal;
        UnitPayEntry: Record "Unit Payment Entry";
        AVJMAmount: Decimal;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ReConOrd: Record "Confirmed Order";
        PaymentModeJV: Boolean;
    begin
        IF Vend.GET(Application."Introducer Code") THEN;
        UserSetup.GET(USERID);
        UnitSetup.GET;
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;

        Line := 10000;
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
        BondPaymentEntry.SETRANGE("Document No.", Application."No.");
        BondPaymentEntry.SETRANGE(Posted, FALSE);
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                IF JnlPostingDocNo = '' THEN BEGIN
                    IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN                //ALLETDK070213
                        JnlPostingDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
                END;
                BondPaymentEntry."Posted Document No." := JnlPostingDocNo;
                IF BondPaymentEntry.Amount > 0 THEN BEGIN
                    UnitSetup.GET;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", BondPaymentEntry."Posting date"); //ALLETDK
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    CompanyGLAccount.RESET;
                    CompanyGLAccount.SETRANGE(CompanyGLAccount."MSC Company", TRUE);
                    IF CompanyGLAccount.FINDFIRST THEN;
                    GenJnlLine.VALIDATE("Account No.", CompanyGLAccount."Receivable Account");
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Order Ref No." := Application."Application No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry."Milestone Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10);//ALLE-AM
                    GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                    GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                    GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash THEN
                        GenJnlLine.Description := 'Cash Received'
                    ELSE
                        IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN
                            GenJnlLine.Description := 'Cheque Received'
                        ELSE
                            IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.C./C.C./Net Banking" THEN
                                GenJnlLine.Description := 'Cheque Received'
                            ELSE
                                IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"D.D." THEN
                                    GenJnlLine.Description := 'D.D. Received';
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.VALIDATE("Bal. Account No.", Application."Customer No.");
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Receipt Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    InsertJnDimension(GenJnlLine);
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", GenJnlLine.Description);
                    Line := Line + 10000;
                END;
                PostGenJnlLines(GenJnlLine."Document No.");
            UNTIL BondPaymentEntry.NEXT = 0;

        UnitPayEntry.RESET;                     //110219
        UnitPayEntry.SETRANGE("Document Type", UnitPayEntry."Document Type"::BOND);
        UnitPayEntry.SETRANGE("Document No.", Application."No.");
        UnitPayEntry.SETRANGE(Posted, FALSE);
        UnitPayEntry.SETRANGE("Commision Applicable", TRUE);
        IF UnitPayEntry.FINDSET THEN
            REPEAT
                CLEAR(BondInvestmentAmt);
                BondInvestmentAmt := UnitPayEntry.Amount;
                CLEAR(ByCheque);
                IF (UnitPayEntry."Payment Mode" IN [UnitPayEntry."Payment Mode"::Bank, UnitPayEntry."Payment Mode"::"D.C./C.C./Net Banking", UnitPayEntry."Payment Mode"::"D.D."]) THEN
                    ByCheque := TRUE
                ELSE
                    ByCheque := FALSE;
                IF (UnitPayEntry."Payment Mode" <> UnitPayEntry."Payment Mode"::Cash) OR
                  (UnitPayEntry."Payment Mode" <> UnitPayEntry."Payment Mode"::"Refund Cash") THEN
                    Application."With Cheque" := TRUE;

                CreateStagingTableAppBond(Application, UnitPayEntry."Line No." / 10000, 1, UnitPayEntry.Sequence,
                UnitPayEntry."Cheque No./ Transaction No.", UnitPayEntry."Commision Applicable", UnitPayEntry."Direct Associate",
                UnitPayEntry."Posting date", BondInvestmentAmt, UnitPayEntry, FALSE, Application."Old Process");
            UNTIL UnitPayEntry.NEXT = 0;

        UnitPayEntry.RESET;                     //110219
        UnitPayEntry.SETRANGE("Document Type", UnitPayEntry."Document Type"::BOND);
        UnitPayEntry.SETRANGE("Document No.", Application."No.");
        UnitPayEntry.SETRANGE(Posted, FALSE);
        UnitPayEntry.SETRANGE("Direct Associate", TRUE);
        IF UnitPayEntry.FINDSET THEN
            REPEAT
                CLEAR(BondInvestmentAmt);
                BondInvestmentAmt := UnitPayEntry.Amount;
                CLEAR(ByCheque);
                IF (UnitPayEntry."Payment Mode" IN [UnitPayEntry."Payment Mode"::Bank, UnitPayEntry."Payment Mode"::"D.C./C.C./Net Banking", UnitPayEntry."Payment Mode"::"D.D."]) THEN
                    ByCheque := TRUE
                ELSE
                    ByCheque := FALSE;
                IF (UnitPayEntry."Payment Mode" <> UnitPayEntry."Payment Mode"::Cash) OR
                  (UnitPayEntry."Payment Mode" <> UnitPayEntry."Payment Mode"::"Refund Cash") THEN
                    Application."With Cheque" := TRUE;

                CreateStagingTableAppBond(Application, UnitPayEntry."Line No." / 10000, 1, UnitPayEntry.Sequence,
                UnitPayEntry."Cheque No./ Transaction No.", UnitPayEntry."Commision Applicable", UnitPayEntry."Direct Associate",
                UnitPayEntry."Posting date", BondInvestmentAmt, UnitPayEntry, FALSE, Application."Old Process");
            UNTIL UnitPayEntry.NEXT = 0;
    end;


    procedure InterNewChequeBounce(var BondPaymentEntry: Record "NewApplication Payment Entry"; var CheqDate: Date)
    var
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        BondPostingGroup1: Record "Customer Posting Group";
        Application: Record Application;
        BondPaymentEntry2: Record "Unit Payment Entry";
        RDPmtSchBuff: Record "Template Field";
        RDPaymentScheduleBuffer: Record "Template Field";
        BondPaymentEntry3: Record "Unit Payment Entry";
        BondPaymentEntryCount: Integer;
        BondPmtEntXChqQ: Record "Quote Properties";
        Bond: Record "New Confirmed Order";
        AppPaymentEntry: Record "NewApplication Payment Entry";
        ApplicationAmount: Decimal;
        BondAmount: Decimal;
        CompanywiseGLAccount: Record "Company wise G/L Account";
    begin
        UnitSetup.GET;
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;

        BondSetup.GET;
        BondSetup.TESTFIELD("Cr. Source Code");
        Line := 10000;
        IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN BEGIN
            BondPaymentEntry.CALCFIELDS(Reversed);
            BondPaymentEntry.TESTFIELD(Reversed, FALSE);
            IF BondPaymentEntry.Amount > 0 THEN BEGIN
                PaymentMethod.GET(BondPaymentEntry."Payment Method");
                GenJnlLine.INIT;
                GenJnlLine."Line No." := Line;
                IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::BOND THEN BEGIN
                    Bond.GET(BondPaymentEntry."Document No.");
                    GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
                    GenJnlLine.VALIDATE("Posting Date", CheqDate);
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("Company Code", Bond."Company Name");
                    IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                        CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Payable Account");
                    END;
                    GenJnlLine.VALIDATE("Account No.", CompanywiseGLAccount."Payable Account");
                    GenJnlLine.VALIDATE(Amount, BondPaymentEntry.Amount);
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
                    GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                    GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                    GenJnlLine."Branch Code" := UserSetup."User Branch";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine.Bounced := TRUE;
                    GenJnlLine."Introducer Code" := Bond."Introducer Code";
                    GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                    GenJnlLine."Cheque No." := CopyStr(BondPaymentEntry."Cheque No./ Transaction No.", 1, 10);//ALLE-AM
                    GenJnlLine."BBG Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";//ALLE-AM
                    GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                    GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                    GenJnlLine."Paid To/Received From Code" := Bond."Received From Code";
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Bal. Account No.", BondPaymentEntry."Deposit/Paid Bank");
                    GenJnlLine."Order Ref No." := BondPaymentEntry."Document No.";
                    GenJnlLine.Description := 'Cheque Bounced';
                    GenJnlLine."Receipt Line No." := BondPaymentEntry."Line No."; //ALLEDK 10112016
                    GenJnlLine.INSERT;
                    Line := Line + 10000;
                END;
            END;
            InsertJnDimension(GenJnlLine);  //ALLEDK 040213
            PostGenJnlLines(GenJnlLine."Document No.");
            AppPaymentEntry.RESET;
            AppPaymentEntry.SETRANGE("Document No.", BondPaymentEntry."Document No.");
            AppPaymentEntry.SETRANGE("Cheque No./ Transaction No.", BondPaymentEntry."Cheque No./ Transaction No.");
            AppPaymentEntry.SETFILTER("Cheque Status", '%1', AppPaymentEntry."Cheque Status"::" ");  //2805 "" inplace of bounced
            AppPaymentEntry.SETRANGE("Line No.", BondPaymentEntry."Line No.");   //ALLEDK 10112016
            IF AppPaymentEntry.FINDFIRST THEN BEGIN
                AppPaymentEntry."Cheque Status" := AppPaymentEntry."Cheque Status"::Bounced;
                AppPaymentEntry."Chq. Cl / Bounce Dt." := CheqDate;  //190113
                AppPaymentEntry.MODIFY;
            END;
        END;
    end;


    procedure JVEntryinMSC(Bond: Record "New Confirmed Order"; TotalRcptAmt: Decimal)
    var
        PostedDocNo: Code[20];
        NarrationText1: Text[32];
        ExistNewAppLines: Record "NewApplication Payment Entry";
        LineNo: Integer;
        ExistAppLines: Record "Application Payment Entry";
    begin
        CompanyGLAccount.RESET;
        CompanyGLAccount.SETRANGE("MSC Company", TRUE);
        IF CompanyGLAccount.FINDFIRST THEN BEGIN
            IF COMPANYNAME = CompanyGLAccount."Company Code" THEN BEGIN
                BondSetup.GET;
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
                GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
                GenJnlLine.DELETEALL;

                BondSetup.GET;
                BondSetup.TESTFIELD("Project Change JV Account");
                PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Cheque Bounce JV No. Series", WORKDATE, TRUE); //ALLEDK 260113

                NarrationText1 := 'Proj Change JV- ' + COPYSTR(Bond."No.", 1, 30);
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := 10000;
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", WORKDATE);
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                CompanyGLAccount.RESET;
                CompanyGLAccount.SETRANGE("Company Code", Bond."Company Name");
                IF CompanyGLAccount.FINDFIRST THEN BEGIN
                    CompanyGLAccount.TESTFIELD("Payable Account");
                END;

                GenJnlLine.VALIDATE("Account No.", BondSetup."Project Change JV Account");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "; //ALLETDK061212
                GenJnlLine."Document No." := PostedDocNo;
                GenJnlLine."Order Ref No." := Bond."No.";
                GenJnlLine.VALIDATE(Amount, TotalRcptAmt);
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Bal. Account No.", CompanyGLAccount."Payable Account");
                GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::JV;
                GenJnlLine."Milestone Code" := BondpaymentEntry.Sequence;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine.Description := 'Adjustment Amount';

                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine); //310113
                PostGenJnlLines(GenJnlLine."Document No.");

                ExistNewAppLines.RESET;
                ExistNewAppLines.SETRANGE("Document No.", Bond."No.");
                IF ExistAppLines.FINDLAST THEN
                    LineNo := ExistNewAppLines."Line No.";
                NewInsertAppLines.INIT;
                NewInsertAppLines."Document Type" := NewInsertAppLines."Document Type"::BOND;
                NewInsertAppLines."Document No." := Bond."No.";
                NewInsertAppLines."Line No." := LineNo + 10000;
                NewInsertAppLines.VALIDATE("Payment Mode", NewInsertAppLines."Payment Mode"::JV); //ALLEDK 110213
                NewInsertAppLines.VALIDATE("Payment Method", 'JV');
                NewInsertAppLines.VALIDATE(Amount, TotalRcptAmt);
                NewInsertAppLines."Posted Document No." := PostedDocNo;
                NewInsertAppLines."Posting date" := WORKDATE;
                NewInsertAppLines."Application No." := Bond."No.";
                NewInsertAppLines.INSERT(TRUE);
                NewInsertAppLines."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                IF Bond."JV Posting Date" <> 0D THEN
                    NewInsertAppLines."Posting date" := Bond."JV Posting Date"
                ELSE
                    NewInsertAppLines."Posting date" := WORKDATE;
                NewInsertAppLines.Posted := TRUE;
                NewInsertAppLines."Create from MSC Company" := FALSE;
                NewInsertAppLines."Company Name" := COMPANYNAME;
                NewInsertAppLines.MODIFY;
            END;
        END;
    end;


    procedure InterComJVEntry(Bond: Record "Confirmed Order")
    var
        PostedDocNo: Code[20];
        NarrationText1: Text[32];
        ExistAppEntry: Record "Application Payment Entry";
        TotalAmt: Decimal;
    begin
        CompanyGLAccount.RESET;
        CompanyGLAccount.SETRANGE("MSC Company", TRUE);
        IF CompanyGLAccount.FINDFIRST THEN BEGIN
            IF COMPANYNAME <> CompanyGLAccount."Company Code" THEN BEGIN
                TotalAmt := 0;
                ExistAppEntry.RESET;
                ExistAppEntry.SETRANGE("Document No.", Bond."No.");
                ExistAppEntry.SETRANGE("Entry From MSC", TRUE);
                ExistAppEntry.SETFILTER("Bank Type", '<>%1', ExistAppEntry."Bank Type"::ProjectCompany);
                IF ExistAppEntry.FINDSET THEN
                    REPEAT
                        TotalAmt := TotalAmt + ExistAppEntry.Amount;
                    UNTIL ExistAppEntry.NEXT = 0;

                IF TotalAmt > 0 THEN BEGIN
                    CLEAR(ExistAppEntry);
                    ExistAppEntry.RESET;
                    ExistAppEntry.SETRANGE("Document No.", Bond."No.");
                    ExistAppEntry.SETRANGE("Payment Mode", ExistAppEntry."Payment Mode"::JV);
                    ExistAppEntry.SETFILTER(Amount, '<%1', 0);
                    IF ExistAppEntry.FINDLAST THEN;

                    BondSetup.GET;
                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
                    GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
                    GenJnlLine.DELETEALL;

                    BondSetup.GET;
                    BondSetup.TESTFIELD("Project Change JV Account");
                    PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Cheque Bounce JV No. Series", WORKDATE, TRUE); //ALLEDK 260113

                    NarrationText1 := 'Proj Change JV- ' + COPYSTR(Bond."No.", 1, 30);
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := 10000;
                    GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                    GenJnlLine.VALIDATE("Document Date", WORKDATE);
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", BondSetup."Project Change JV Account");
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "; //ALLETDK061212
                    GenJnlLine."Document No." := PostedDocNo;
                    GenJnlLine."Order Ref No." := Bond."No.";
                    GenJnlLine.VALIDATE(Amount, TotalAmt);
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Bal. Account No.", CompanyGLAccount."Receivable Account");
                    GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::JV;
                    GenJnlLine."Milestone Code" := BondpaymentEntry.Sequence;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Shortcut Dimension 1 Code" := ExistAppEntry."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := ExistAppEntry."Shortcut Dimension 2 Code";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine.Description := 'Adjustment Amount';

                    GenJnlLine.INSERT;
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                    InsertJnDimension(GenJnlLine); //310113

                    BondSetup.GET;
                    BondSetup.TESTFIELD("Project Change JV Account");
                    PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Cheque Bounce JV No. Series", WORKDATE, TRUE); //ALLEDK 260113

                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := 20000;
                    GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                    GenJnlLine.VALIDATE("Document Date", WORKDATE);
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", CompanyGLAccount."Receivable Account");
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "; //ALLETDK061212
                    GenJnlLine."Document No." := PostedDocNo;
                    GenJnlLine."Order Ref No." := Bond."No.";
                    GenJnlLine.VALIDATE(Amount, TotalAmt);
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Project Change JV Account");
                    GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::JV;
                    GenJnlLine."Milestone Code" := BondpaymentEntry.Sequence;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine.Description := 'Adjustment Amount';
                    GenJnlLine.INSERT;
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                    InsertJnDimension(GenJnlLine); //310113
                    PostGenJnlLines(GenJnlLine."Document No.");
                END;
            END;
        END;
    end;


    procedure MJVEntryinMSC(Bond: Record "New Confirmed Order"; TotalRcptAmt: Decimal; PostDate: Date; OrderNo: Code[20])
    var
        PostedDocNo: Code[20];
        NarrationText1: Text[32];
        ExistNewAppLines: Record "NewApplication Payment Entry";
        LineNo: Integer;
        ExistAppLines: Record "Application Payment Entry";
        FromConfOrder: Record "New Confirmed Order";
    begin
        CompanyGLAccount.RESET;
        CompanyGLAccount.SETRANGE("MSC Company", TRUE);
        IF CompanyGLAccount.FINDFIRST THEN BEGIN
            IF COMPANYNAME = CompanyGLAccount."Company Code" THEN BEGIN
                BondSetup.GET;
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
                GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
                GenJnlLine.DELETEALL;

                BondSetup.GET;
                BondSetup.TESTFIELD("Transfer Control Account");
                PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Member to Member No. Series", WORKDATE, TRUE);

                NarrationText1 := 'MtoM Transfer- ' + COPYSTR(Bond."No.", 1, 30);
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := 10000;
                GenJnlLine.VALIDATE("Posting Date", PostDate);
                GenJnlLine.VALIDATE("Document Date", PostDate);
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                CompanyGLAccount.RESET;
                CompanyGLAccount.SETRANGE("Company Code", Bond."Company Name");
                IF CompanyGLAccount.FINDFIRST THEN BEGIN
                    CompanyGLAccount.TESTFIELD("Payable Account");
                END;

                GenJnlLine.VALIDATE("Account No.", BondSetup."Transfer Control Account");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "; //ALLETDK061212
                GenJnlLine."Document No." := PostedDocNo;
                GenJnlLine."Order Ref No." := Bond."No.";
                GenJnlLine.VALIDATE(Amount, TotalRcptAmt);
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Bal. Account No.", CompanyGLAccount."Payable Account");
                GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::MJVM;
                GenJnlLine."Milestone Code" := BondpaymentEntry.Sequence;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine.Description := 'Adjustment Amount';

                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine); //310113

                IF FromConfOrder.GET(OrderNo) THEN;
                NarrationText1 := 'MtoM Transfer- ' + COPYSTR(OrderNo, 1, 30);
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := 20000;
                GenJnlLine.VALIDATE("Posting Date", PostDate);
                GenJnlLine.VALIDATE("Document Date", PostDate);
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                CompanyGLAccount.RESET;
                CompanyGLAccount.SETRANGE("Company Code", Bond."Company Name");
                IF CompanyGLAccount.FINDFIRST THEN BEGIN
                    CompanyGLAccount.TESTFIELD("Payable Account");
                END;

                GenJnlLine.VALIDATE("Account No.", CompanyGLAccount."Payable Account");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "; //ALLETDK061212
                GenJnlLine."Document No." := PostedDocNo;
                GenJnlLine."Order Ref No." := OrderNo;
                GenJnlLine.VALIDATE(Amount, TotalRcptAmt);
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Transfer Control Account");
                GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::MJVM;
                GenJnlLine."Milestone Code" := BondpaymentEntry.Sequence;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Shortcut Dimension 1 Code" := FromConfOrder."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := FromConfOrder."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine.Description := 'Adjustment Amount';

                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine); //310113
                PostGenJnlLines(GenJnlLine."Document No.");
            END;
        END;
    end;


    procedure PostAssociatePayment(var AssociatePaymentHdr: Record "Associate Payment Hdr")
    var
        PostedDocNo: Code[20];
        NarrationText1: Text[60];
        AssPmtHdr: Record "Associate Payment Hdr";
        TotalAssAmt: Decimal;
        AssPmtHeader: Record "Associate Payment Hdr";
        UpdateAssPmtHeader: Record "Associate Payment Hdr";
    begin
        GenJnlLine.RESET;
        GenJnlLine.DELETEALL;

        BondSetup.GET;
        BondSetup.TESTFIELD("Cash Voucher Template Name");
        BondSetup.TESTFIELD("Cash Voucher Batch Name");
        BondSetup.TESTFIELD("Bank Voucher Template Name");
        BondSetup.TESTFIELD("Bank Voucher Batch Name");

        BondSetup.TESTFIELD("Asso. Pmt Voucher No. Series");
        PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Asso. Pmt Voucher No. Series", WORKDATE, TRUE);
        LineNo := 0;
        TotalAssAmt := 0;

        AssPmtHeader.RESET;
        AssPmtHeader.SETCURRENTKEY("Associate Code", Post);
        AssPmtHeader.SETRANGE("Associate Code", AssociatePaymentHdr."Associate Code");
        AssPmtHeader.SETRANGE("Document No.", AssociatePaymentHdr."Document No.");
        AssPmtHeader.SETRANGE("User ID", USERID);
        AssPmtHeader.SETRANGE(Post, FALSE);
        AssPmtHeader.SETRANGE("Line Type", AssPmtHeader."Line Type"::Header);
        IF AssPmtHeader.FINDFIRST THEN;


        AssPmtHdr.RESET;
        AssPmtHdr.SETCURRENTKEY("Associate Code", Post);
        AssPmtHdr.SETRANGE("Associate Code", AssociatePaymentHdr."Associate Code");
        AssPmtHdr.SETRANGE("User ID", USERID);
        AssPmtHdr.SETRANGE("Rejected/Approved", AssPmtHdr."Rejected/Approved"::Approved);
        AssPmtHdr.SETRANGE(Post, FALSE);
        IF AssPmtHdr.FINDSET THEN BEGIN
            REPEAT
                IF AssPmtHdr."Amt applicable for Payment" > 0 THEN BEGIN
                    TotalAssAmt := TotalAssAmt + AssPmtHdr."Amt applicable for Payment";
                    NarrationText1 := 'Associate Payment ' + COPYSTR(AssPmtHdr."Associate Code", 1, 30);
                    GenJnlLine.INIT;
                    IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Cash THEN BEGIN
                        GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                        GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                    END ELSE BEGIN
                        GenJnlLine."Journal Template Name" := BondSetup."Bank Voucher Template Name";
                        GenJnlLine."Journal Batch Name" := BondSetup."Bank Voucher Batch Name";
                    END;
                    GenJnlLine."Line No." := LineNo + 10000;
                    GenJnlLine.VALIDATE("Posting Date", AssPmtHdr."Posting Date");
                    GenJnlLine.VALIDATE("Document Date", AssPmtHdr."Document Date");
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment; //ALLETDK061212
                    GenJnlLine."Document No." := PostedDocNo;

                    CompanyGLAccount.RESET;
                    CompanyGLAccount.SETRANGE("Company Code", AssPmtHdr."Company Name");
                    IF CompanyGLAccount.FINDFIRST THEN BEGIN
                        CompanyGLAccount.TESTFIELD("Receivable Account");
                    END;
                    IF AssPmtHdr."Company Name" = COMPANYNAME THEN BEGIN
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                        GenJnlLine.VALIDATE("Account No.", AssPmtHdr."Associate Code");
                        AssPmtHdr."Posted on LLP Company" := TRUE;
                    END ELSE BEGIN
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        GenJnlLine.VALIDATE("Account No.", CompanyGLAccount."Receivable Account");
                    END;
                    GenJnlLine.VALIDATE(Amount, AssPmtHdr."Amt applicable for Payment");
                    IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission
                    ELSE
                        IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance"
                        ELSE
                            IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Incentive
                            ELSE
                                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;

                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
                    GenJnlLine."Cheque Date" := AssociatePaymentHdr."Cheque Date";
                    GenJnlLine."Cheque No." := CopyStr(AssociatePaymentHdr."Cheque No.", 1, 10);//ALLE-AM
                    GenJnlLine."BBG Cheque No." := AssociatePaymentHdr."Cheque No.";//ALLE-AM
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine.Description := 'Associate Pmt';
                    GenJnlLine.INSERT;
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                    InsertJnDimension(GenJnlLine); //310113
                    LineNo := GenJnlLine."Line No.";
                END;
                AssPmtHdr."Posted Document No." := PostedDocNo;
                AssPmtHdr.MODIFY;
            UNTIL AssPmtHdr.NEXT = 0;
            GenJnlLine.INIT;
            IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Cash THEN BEGIN
                GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
            END ELSE BEGIN
                GenJnlLine."Journal Template Name" := BondSetup."Bank Voucher Template Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Bank Voucher Batch Name";
            END;
            GenJnlLine."Line No." := LineNo + 10000;
            GenJnlLine.VALIDATE("Posting Date", AssPmtHdr."Posting Date");
            GenJnlLine.VALIDATE("Document Date", AssPmtHdr."Document Date");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment; //ALLETDK061212
            GenJnlLine."Document No." := PostedDocNo;
            IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Cash THEN BEGIN
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", AssPmtHeader."Bank/G L Code");
            END;
            IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Bank THEN BEGIN
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.VALIDATE("Account No.", AssPmtHeader."Bank/G L Code");
                GenJnlLine."Cheque No." := CopyStr(AssPmtHeader."Cheque No.", 1, 10);//ALLE-AM
                GenJnlLine."BBG Cheque No." := AssPmtHeader."Cheque No.";//ALLE-AM
                GenJnlLine."Cheque Date" := AssPmtHeader."Cheque Date";
            END;
            GenJnlLine.VALIDATE(Amount, -1 * TotalAssAmt);
            IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission
            ELSE
                IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance"
                ELSE
                    IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Incentive
                    ELSE
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;

            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.Description := 'Associate Pmt';
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            InsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines(GenJnlLine."Document No.");
        END;
        IF PostedDocNo <> '' THEN BEGIN
            UpdateAssPmtHeader.RESET;
            UpdateAssPmtHeader.SETRANGE("User ID", USERID);
            UpdateAssPmtHeader.SETRANGE("Rejected/Approved", UpdateAssPmtHeader."Rejected/Approved"::Approved);
            UpdateAssPmtHeader.SETRANGE(Post, FALSE);
            UpdateAssPmtHeader.SETRANGE("Posted Document No.", PostedDocNo);
            IF UpdateAssPmtHeader.FINDSET THEN
                REPEAT
                    UpdateAssPmtHeader.Post := TRUE;
                    UpdateAssPmtHeader.MODIFY;
                UNTIL UpdateAssPmtHeader.NEXT = 0;
        END;
    end;


    procedure PostAssociatePaymentLLPS(var AssociatePaymentHdr: Record "Associate Payment Hdr")
    var
        PostedDocNo: Code[20];
        NarrationText1: Text[60];
        AssPmtHdr: Record "Associate Payment Hdr";
        TotalAssAmt: Decimal;
        AssPmtHeader: Record "Associate Payment Hdr";
        UpdateAssPmtHeader: Record "Associate Payment Hdr";
    begin
        GenJnlLine.RESET;
        GenJnlLine.DELETEALL;

        BondSetup.GET;
        BondSetup.TESTFIELD("Cash Voucher Template Name");
        BondSetup.TESTFIELD("Cash Voucher Batch Name");
        BondSetup.TESTFIELD("Bank Voucher Template Name");
        BondSetup.TESTFIELD("Bank Voucher Batch Name");

        BondSetup.TESTFIELD("Asso. Pmt Voucher No. Series");
        PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Asso. Pmt Voucher No. Series", WORKDATE, TRUE);
        LineNo := 0;
        TotalAssAmt := 0;

        UserSetup.GET(USERID);
        AssPmtHdr.RESET;
        AssPmtHdr.SETCURRENTKEY("Associate Code", Post);
        AssPmtHdr.SETRANGE("Associate Code", AssociatePaymentHdr."Associate Code");
        AssPmtHdr.SETRANGE("Rejected/Approved", AssPmtHdr."Rejected/Approved"::Approved);
        AssPmtHdr.SETRANGE(Post, TRUE);
        AssPmtHdr.SETRANGE("Posted on LLP Company", FALSE);
        AssPmtHdr.SETRANGE("Company Name", COMPANYNAME);
        AssPmtHdr.SETFILTER("Amt applicable for Payment", '>%1', 0);
        IF AssPmtHdr.FINDSET THEN BEGIN
            TotalAssAmt := 0;
            TotalAssAmt := AssPmtHdr."Amt applicable for Payment";
            NarrationText1 := 'Associate Payment ' + COPYSTR(AssPmtHdr."Associate Code", 1, 30);
            GenJnlLine.INIT;
            IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Cash THEN BEGIN
                GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
            END ELSE BEGIN
                GenJnlLine."Journal Template Name" := BondSetup."Bank Voucher Template Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Bank Voucher Batch Name";
            END;
            GenJnlLine."Line No." := LineNo + 10000;
            GenJnlLine.VALIDATE("Posting Date", AssPmtHdr."Posting Date");
            GenJnlLine.VALIDATE("Document Date", AssPmtHdr."Document Date");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment; //ALLETDK061212
            GenJnlLine."Document No." := PostedDocNo;

            CompanyGLAccount.RESET;
            CompanyGLAccount.SETRANGE("MSC Company", TRUE);
            IF CompanyGLAccount.FINDFIRST THEN
                CompanyGLAccount.TESTFIELD("Payable Account");

            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", AssPmtHdr."Associate Code");
            GenJnlLine.VALIDATE(Amount, AssPmtHdr."Amt applicable for Payment");
            IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission
            ELSE
                IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance"
                ELSE
                    IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Incentive
                    ELSE
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;

            GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
            GenJnlLine."External Document No." := AssPmtHdr."Document No.";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.Description := 'Associate Pmt';
            GenJnlLine."Cheque No." := CopyStr(AssPmtHdr."Cheque No.", 1, 10);//ALLE-AM
            GenJnlLine."BBG Cheque No." := AssPmtHdr."Cheque No.";//ALLE-AM
            GenJnlLine."Cheque Date" := AssPmtHdr."Cheque Date";
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Bal. Account No.", CompanyGLAccount."Payable Account");
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
            GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            InsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines(GenJnlLine."Document No.");
            AssPmtHdr."Posted on LLP Company" := TRUE;
            AssPmtHdr.MODIFY;
        END;
    end;


    procedure "-----Posting MJV intercomapny"()
    begin
    end;


    procedure MJVPost(Bond_1: Record "Confirmed Order"; RefPostDate_1: Date; TrfAmount_1: Decimal; RefOrderNo: Code[20])
    var
        NarrationText1: Text[100];
        BondPostingGroup1: Record "Customer Posting Group";
        CompanyWiseGL: Record "Company wise G/L Account";
        NewConfirmedOrder_1: Record "New Confirmed Order";
    begin

        NarrationText1 := 'MTM Adj. App No.- ' + COPYSTR(Bond_1."Application No.", 1, 30);
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
        GenJnlLine."Line No." := 10000;
        GenJnlLine.VALIDATE("Posting Date", RefPostDate_1);
        GenJnlLine.VALIDATE("Document Date", RefPostDate_1);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        NewConfirmedOrder_1.GET(RefOrderNo);
        CompanyWiseGL.RESET;
        CompanyWiseGL.SETRANGE("Company Code", NewConfirmedOrder_1."Company Name");
        IF CompanyWiseGL.FINDFIRST THEN
            GenJnlLine.VALIDATE("Account No.", CompanyWiseGL."Receivable Account");

        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "; //ALLETDK061212
        GenJnlLine."Document No." := Bond_1."Penalty Document No.";
        GenJnlLine."Bill-to/Pay-to No." := Bond_1."Customer No.";
        GenJnlLine."Order Ref No." := Bond_1."No.";
        GenJnlLine.VALIDATE(Amount, TrfAmount_1);
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::Customer);
        BondPostingGroup1.GET(Bond_1."Bond Posting Group");
        GenJnlLine.VALIDATE("Bal. Account No.", Bond_1."Customer No.");
        GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Negative Adjmt.";
        GenJnlLine."Posting Group" := Bond_1."Bond Posting Group";
        GenJnlLine."Order Ref No." := Bond_1."Application No.";
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Bond_1."Shortcut Dimension 1 Code");
        GenJnlLine."Shortcut Dimension 2 Code" := Bond_1."Shortcut Dimension 2 Code";
        GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Introducer Code" := Bond_1."Introducer Code";
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
        GenJnlLine."Unit No." := Bond_1."No.";
        GenJnlLine.Description := 'Adjustment Amount';
        GenJnlLine.INSERT;
        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
          GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
        InsertJnDimension(GenJnlLine); //310113
        PostGenJnlLines(GenJnlLine."Document No.");
    end;


    procedure "------Associate OD adjustment."()
    begin
    end;


    procedure PostAssODAdjustFromComp(AssociateAjustmentEntry_1: Record "Associate OD Ajustment Entry")
    var
        UpdateAssPmtHeader: Record "Associate OD Ajustment Entry";
        PostedDocNo: Code[20];
        NarrationText1: Text[250];
        CompanyGLAccount: Record "Company wise G/L Account";
    begin
        PostedDocNo := '';
        BondSetup.GET;
        AssociateAjustmentEntry_1.RESET;
        AssociateAjustmentEntry_1.SETRANGE("From Company Name", COMPANYNAME);
        AssociateAjustmentEntry_1.SETRANGE("Posted in From Company Name", FALSE);
        IF AssociateAjustmentEntry_1.FINDFIRST THEN BEGIN
            GenJnlLine.RESET;
            GenJnlLine.DELETEALL;
            BondSetup.TESTFIELD("Asso. Pmt Voucher No. Series");
            PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Asso. Pmt Voucher No. Series", WORKDATE, TRUE);
            LineNo := 0;
            IF AssociateAjustmentEntry_1."Adjust OD Amount" > 0 THEN BEGIN
                NarrationText1 := 'Associate Payment ' + COPYSTR(AssociateAjustmentEntry_1."Associate Code", 1, 30);
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                GenJnlLine."Line No." := LineNo + 10000;
                GenJnlLine.VALIDATE("Posting Date", AssociateAjustmentEntry_1."Posting Date");
                GenJnlLine.VALIDATE("Document Date", AssociateAjustmentEntry_1."Document Date");
                GenJnlLine."Document No." := PostedDocNo;
                CompanyGLAccount.RESET;
                CompanyGLAccount.SETRANGE("Company Code", AssociateAjustmentEntry_1."To Company Name");
                IF CompanyGLAccount.FINDFIRST THEN BEGIN
                    CompanyGLAccount.TESTFIELD("Payable Account");
                END;
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", CompanyGLAccount."Payable Account");
                GenJnlLine.VALIDATE(Amount, AssociateAjustmentEntry_1."Adjust OD Amount");
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission;
                GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                GenJnlLine."Payment Trasnfer from Other" := TRUE;
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine.Description := 'Associate Pmt';
                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine); //310113
                LineNo := GenJnlLine."Line No.";

                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                GenJnlLine."Line No." := LineNo + 10000;
                GenJnlLine.VALIDATE("Posting Date", AssociateAjustmentEntry_1."Posting Date");
                GenJnlLine.VALIDATE("Document Date", AssociateAjustmentEntry_1."Document Date");
                GenJnlLine."Document No." := PostedDocNo;
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", AssociateAjustmentEntry_1."Associate Code");
                GenJnlLine.VALIDATE(Amount, -1 * AssociateAjustmentEntry_1."Adjust OD Amount");

                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::CommAndTA;
                GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                GenJnlLine."Payment Trasnfer from Other" := TRUE;
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine.Description := 'Associate Pmt';
                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine); //310113
                PostGenJnlLines(GenJnlLine."Document No.");
                IF PostedDocNo <> '' THEN BEGIN
                    UpdateAssPmtHeader.RESET;
                    UpdateAssPmtHeader.SETRANGE("Document No.", AssociateAjustmentEntry_1."Document No.");
                    UpdateAssPmtHeader.SETRANGE("Line no.", AssociateAjustmentEntry_1."Line no.");
                    UpdateAssPmtHeader.SETRANGE("From Company Name", COMPANYNAME);
                    UpdateAssPmtHeader.SETRANGE("Posted in From Company Name", FALSE);
                    IF UpdateAssPmtHeader.FINDSET THEN
                        REPEAT
                            UpdateAssPmtHeader."Posted in From Company Name" := TRUE;
                            UpdateAssPmtHeader.MODIFY;
                        UNTIL UpdateAssPmtHeader.NEXT = 0;
                END;
            END;
        END;
    end;


    procedure PostAssODAdjustToComp(AssociateAjustmentEntry_1: Record "Associate OD Ajustment Entry")
    var
        UpdateAssPmtHeader: Record "Associate OD Ajustment Entry";
        PostedDocNo: Code[20];
        NarrationText1: Text[250];
        CompanyGLAccount: Record "Company wise G/L Account";
    begin
        PostedDocNo := '';
        BondSetup.GET;
        AssociateAjustmentEntry_1.RESET;
        AssociateAjustmentEntry_1.SETRANGE("To Company Name", COMPANYNAME);
        AssociateAjustmentEntry_1.SETRANGE("Posted in To Company Name", FALSE);
        IF AssociateAjustmentEntry_1.FINDFIRST THEN BEGIN
            GenJnlLine.RESET;
            GenJnlLine.DELETEALL;
            BondSetup.TESTFIELD("Asso. Pmt Voucher No. Series");
            PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Asso. Pmt Voucher No. Series", WORKDATE, TRUE);
            LineNo := 0;
            IF AssociateAjustmentEntry_1."Adjust OD Amount" > 0 THEN BEGIN
                NarrationText1 := 'Associate Payment ' + COPYSTR(AssociateAjustmentEntry_1."Associate Code", 1, 30);
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                GenJnlLine."Line No." := LineNo + 10000;
                GenJnlLine.VALIDATE("Posting Date", AssociateAjustmentEntry_1."Posting Date");
                GenJnlLine.VALIDATE("Document Date", AssociateAjustmentEntry_1."Document Date");
                GenJnlLine."Document No." := PostedDocNo;
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", AssociateAjustmentEntry_1."Associate Code");
                GenJnlLine.VALIDATE(Amount, AssociateAjustmentEntry_1."Adjust OD Amount");
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission;
                GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                GenJnlLine."Payment Trasnfer from Other" := TRUE;
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine.Description := 'Associate Pmt';
                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine); //310113
                LineNo := GenJnlLine."Line No.";

                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                GenJnlLine."Line No." := LineNo + 10000;
                GenJnlLine.VALIDATE("Posting Date", AssociateAjustmentEntry_1."Posting Date");
                GenJnlLine.VALIDATE("Document Date", AssociateAjustmentEntry_1."Document Date");
                GenJnlLine."Document No." := PostedDocNo;
                CompanyGLAccount.RESET;
                CompanyGLAccount.SETRANGE("Company Code", AssociateAjustmentEntry_1."From Company Name");
                IF CompanyGLAccount.FINDFIRST THEN BEGIN
                    CompanyGLAccount.TESTFIELD("Payable Account");
                END;
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", CompanyGLAccount."Payable Account");
                GenJnlLine.VALIDATE(Amount, -1 * AssociateAjustmentEntry_1."Adjust OD Amount");

                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::CommAndTA;
                GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Payment Trasnfer from Other" := TRUE;
                GenJnlLine.Description := 'Associate Pmt';
                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine); //310113
                PostGenJnlLines(GenJnlLine."Document No.");
                IF PostedDocNo <> '' THEN BEGIN
                    UpdateAssPmtHeader.RESET;
                    UpdateAssPmtHeader.SETRANGE("Document No.", AssociateAjustmentEntry_1."Document No.");
                    UpdateAssPmtHeader.SETRANGE("Line no.", AssociateAjustmentEntry_1."Line no.");
                    UpdateAssPmtHeader.SETRANGE("To Company Name", COMPANYNAME);
                    UpdateAssPmtHeader.SETRANGE("Posted in To Company Name", FALSE);
                    IF UpdateAssPmtHeader.FINDSET THEN
                        REPEAT
                            UpdateAssPmtHeader."Posted in To Company Name" := TRUE;
                            UpdateAssPmtHeader.MODIFY;
                        UNTIL UpdateAssPmtHeader.NEXT = 0;
                END;
            END;
        END;
    end;


    procedure PostAssociateAdvancePmt(AssociatePaymentHdr: Record "Associate Payment Hdr")
    var
        PostedDocNo: Code[20];
        NarrationText1: Text[60];
        AssPmtHdr: Record "Associate Payment Hdr";
        TotalAssAmt: Decimal;
        UpdateAssPmtHeader: Record "Associate Payment Hdr";
        CompanyWiseGL_1: Record "Company wise G/L Account";
        TotalInvAmount: Decimal;
        VLEntry: Record "Vendor Ledger Entry";
        WithTDSAmt: Decimal;
        WithoutTDSAmt: Decimal;
        CalculateTax: Codeunit "Calculate Tax";
    begin

        UserSetup.RESET;
        UserSetup.GET(USERID);

        GenJnlLine.RESET;
        GenJnlLine.DELETEALL;
        PDocNo := '';
        BondSetup.GET;
        BondSetup.TESTFIELD("Cash Voucher Template Name");
        BondSetup.TESTFIELD("Cash Voucher Batch Name");
        BondSetup.TESTFIELD("Bank Voucher Template Name");
        BondSetup.TESTFIELD("Bank Voucher Batch Name");

        BondSetup.TESTFIELD("Asso. Pmt Voucher No. Series");
        PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Asso. Pmt Voucher No. Series", WORKDATE, TRUE);
        LineNo := 0;
        TotalAssAmt := 0;
        TotalInvAmount := 0;
        /* //281015
        CompanyWiseGL_1.RESET;
        IF CompanyWiseGL_1.FINDSET THEN
          REPEAT
            VLEntry.RESET;
            VLEntry.CHANGECOMPANY(CompanyWiseGL_1."Company Code");
            VLEntry.SETCURRENTKEY("Vendor No.","Posting Date");
            VLEntry.SETFILTER("Vendor No.",AssociatePaymentHdr."Associate Code");
            VLEntry.SETRANGE("Posting Date",0D,TODAY);
            VLEntry.SETFILTER("Posting Type",'<>%1',VLEntry."Posting Type"::Incentive);
            IF VLEntry.FINDSET THEN
              REPEAT
                VLEntry.CALCFIELDS(VLEntry."Remaining Amt. (LCY)");
                TotalInvAmount := TotalInvAmount + VLEntry."Remaining Amt. (LCY)";
              UNTIL VLEntry.NEXT =0;
          UNTIL CompanyWiseGL_1.NEXT =0;
        *///281015
        WithTDSAmt := 0;
        WithoutTDSAmt := 0;

        PDocNo := PostedDocNo;
        AssPmtHdr.RESET;
        AssPmtHdr.SETCURRENTKEY("Associate Code", Post);
        AssPmtHdr.SETRANGE("Associate Code", AssociatePaymentHdr."Associate Code");
        AssPmtHdr.SETRANGE("Document No.", AssociatePaymentHdr."Document No.");
        AssPmtHdr.SETRANGE("User ID", USERID);
        AssPmtHdr.SETRANGE("Rejected/Approved", AssPmtHdr."Rejected/Approved"::Approved);
        AssPmtHdr.SETRANGE(Post, FALSE);
        IF AssPmtHdr.FINDFIRST THEN BEGIN
            IF TotalInvAmount < 0 THEN BEGIN
                IF (TotalInvAmount + AssPmtHdr."Amt applicable for Payment") >= 0 THEN BEGIN
                    WithTDSAmt := ABS(TotalInvAmount + AssPmtHdr."Amt applicable for Payment");
                    WithoutTDSAmt := ABS(TotalInvAmount);
                END ELSE
                    WithoutTDSAmt := AssPmtHdr."Amt applicable for Payment";
            END ELSE
                WithTDSAmt := AssPmtHdr."Amt applicable for Payment";

            NarrationText1 := 'Associate Payment ' + COPYSTR(AssPmtHdr."Associate Code", 1, 30);
            IF WithoutTDSAmt <> 0 THEN BEGIN
                GenJnlLine1.INIT;
                IF AssPmtHdr."Payment Mode" = AssPmtHdr."Payment Mode"::Cash THEN BEGIN
                    GenJnlLine1."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                    GenJnlLine1."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                END ELSE BEGIN
                    GenJnlLine1."Journal Template Name" := BondSetup."Bank Voucher Template Name";
                    GenJnlLine1."Journal Batch Name" := BondSetup."Bank Voucher Batch Name";
                END;
                GenJnlLine1."Line No." := LineNo + 10000;
                GenJnlLine1.VALIDATE("Posting Date", AssPmtHdr."Posting Date");
                GenJnlLine1.VALIDATE("Document Date", AssPmtHdr."Document Date");
                GenJnlLine1."Document Type" := GenJnlLine1."Document Type"::Payment; //ALLETDK061212
                GenJnlLine1."Document No." := PostedDocNo;
                GenJnlLine1.VALIDATE("Account Type", GenJnlLine1."Account Type"::Vendor);
                GenJnlLine1.VALIDATE("Account No.", AssPmtHdr."Associate Code");
                GenJnlLine1.VALIDATE(Amount, WithoutTDSAmt);
                IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                    GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Commission
                ELSE
                    IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                        GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::"Travel Allowance"
                    ELSE
                        IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                            GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Incentive
                        ELSE
                            IF AssPmtHdr.Type = AssPmtHdr.Type::ComAndTA THEN
                                GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::CommAndTA
                            ELSE
                                GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Incentive;

                GenJnlLine1."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                IF AssPmtHdr."Payment Mode" = AssPmtHdr."Payment Mode"::Cash THEN BEGIN
                    GenJnlLine1.VALIDATE("Bal. Account Type", GenJnlLine1."Bal. Account Type"::"G/L Account");
                    GenJnlLine1.VALIDATE("Bal. Account No.", AssPmtHdr."Bank/G L Code");
                END;
                IF AssPmtHdr."Payment Mode" = AssPmtHdr."Payment Mode"::Bank THEN BEGIN
                    GenJnlLine1.VALIDATE("Bal. Account Type", GenJnlLine1."Bal. Account Type"::"Bank Account");
                    GenJnlLine1.VALIDATE("Bal. Account No.", AssPmtHdr."Bank/G L Code");
                    GenJnlLine1."Cheque No." := CopyStr(AssPmtHdr."Cheque No.", 1, 10);//ALLE-AM
                    GenJnlLine1."BBG Cheque No." := AssPmtHdr."Cheque No.";//ALLE-AM
                    GenJnlLine1."Cheque Date" := AssPmtHdr."Cheque Date";
                END;
                GenJnlLine1."Tranasaction Type" := GenJnlLine1."Tranasaction Type"::Trading;
                GenJnlLine1."Payment As Advance" := TRUE;
                GenJnlLine1."System-Created Entry" := TRUE;
                GenJnlLine1.Description := 'Associate Pmt';
                GenJnlLine1.INSERT;
                InitVoucherNarration(GenJnlLine1."Journal Template Name", GenJnlLine1."Journal Batch Name", GenJnlLine1."Document No.",
                  GenJnlLine1."Line No.", GenJnlLine1."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine1); //310113
                LineNo := GenJnlLine1."Line No.";
                CalculateTax.CallTaxEngineOnGenJnlLine(GenJnlLine1, GenJnlLine1);
            END;
            IF WithTDSAmt <> 0 THEN BEGIN
                GenJnlLine1.INIT;
                IF AssPmtHdr."Payment Mode" = AssPmtHdr."Payment Mode"::Cash THEN BEGIN
                    GenJnlLine1."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                    GenJnlLine1."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                END ELSE BEGIN
                    GenJnlLine1."Journal Template Name" := BondSetup."Bank Voucher Template Name";
                    GenJnlLine1."Journal Batch Name" := BondSetup."Bank Voucher Batch Name";
                END;
                GenJnlLine1."Line No." := LineNo + 10000;
                GenJnlLine1.VALIDATE("Posting Date", AssPmtHdr."Posting Date");
                GenJnlLine1.VALIDATE("Document Date", AssPmtHdr."Document Date");
                GenJnlLine1."Document Type" := GenJnlLine1."Document Type"::Payment; //ALLETDK061212
                GenJnlLine1."Document No." := PostedDocNo;
                GenJnlLine1.VALIDATE("Party Type", GenJnlLine1."Party Type"::Vendor);
                GenJnlLine1.VALIDATE("Party Code", AssPmtHdr."Associate Code");
                GenJnlLine1.VALIDATE("TDS Section Code", BondSetup."TDS Nature of Deduction");
                IF AssPmtHdr."Payment Mode" = AssPmtHdr."Payment Mode"::Cash THEN BEGIN
                    GenJnlLine1.VALIDATE("Bal. Account Type", GenJnlLine1."Bal. Account Type"::"G/L Account");
                    GenJnlLine1.VALIDATE("Bal. Account No.", AssPmtHdr."Bank/G L Code");
                END;
                IF AssPmtHdr."Payment Mode" = AssPmtHdr."Payment Mode"::Bank THEN BEGIN
                    GenJnlLine1.VALIDATE("Bal. Account Type", GenJnlLine1."Bal. Account Type"::"Bank Account");
                    GenJnlLine1.VALIDATE("Bal. Account No.", AssPmtHdr."Bank/G L Code");
                    GenJnlLine1."Cheque No." := CopyStr(AssPmtHdr."Cheque No.", 1, 10);//ALLE-AM
                    GenJnlLine1."BBG Cheque No." := AssPmtHdr."Cheque No.";//ALLE-AM
                    GenJnlLine1."Cheque Date" := AssPmtHdr."Cheque Date";
                END;
                IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                    GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Commission
                ELSE
                    IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                        GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::"Travel Allowance"
                    ELSE
                        IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                            GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Incentive
                        ELSE
                            IF AssPmtHdr.Type = AssPmtHdr.Type::ComAndTA THEN
                                GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::CommAndTA;

                GenJnlLine1.VALIDATE("Vendor Cheque Amount", WithTDSAmt);
                GenJnlLine1."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                GenJnlLine1."Tranasaction Type" := GenJnlLine1."Tranasaction Type"::Trading;
                GenJnlLine1."System-Created Entry" := false;
                GenJnlLine1."Payment As Advance" := TRUE;
                GenJnlLine1.Description := 'Associate Pmt';
                GenJnlLine1."Source Code" := 'BANKPYMTV';
                GenJnlLine1.VALIDATE("TDS Section Code", BondSetup."TDS Nature of Deduction");

                GenJnlLine1.INSERT;

                PostPayment1.CheckVendorChequeAmount(GenJnlLine1); //For Testing
                // GenJnlLine1.Validate("Bank Charge", true);
                // GenJnlLine1.Modify();
                InitVoucherNarration(GenJnlLine1."Journal Template Name", GenJnlLine1."Journal Batch Name", GenJnlLine1."Document No.",
                  GenJnlLine1."Line No.", GenJnlLine1."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine1); //310113
                CalculateTax.CallTaxEngineOnGenJnlLine(GenJnlLine1, GenJnlLine1);

            END;
            PostGenJnlLines1;
        END;
        IF PostedDocNo <> '' THEN BEGIN
            UpdateAssPmtHeader.RESET;
            UpdateAssPmtHeader.SETRANGE("User ID", USERID);
            UpdateAssPmtHeader.SETRANGE("Rejected/Approved", UpdateAssPmtHeader."Rejected/Approved"::Approved);
            UpdateAssPmtHeader.SETRANGE("Document No.", AssociatePaymentHdr."Document No.");
            IF UpdateAssPmtHeader.FINDSET THEN
                REPEAT
                    UpdateAssPmtHeader.Post := TRUE;
                    UpdateAssPmtHeader."Posted on LLP Company" := TRUE;
                    UpdateAssPmtHeader."Posted Document No." := PostedDocNo; //1108
                    UpdateAssPmtHeader.MODIFY;
                UNTIL UpdateAssPmtHeader.NEXT = 0;
        END;

    end;


    procedure NewPostAssociatePayment(var AssociatePaymentHdr: Record "Associate Payment Hdr")
    var
        PostedDocNo: Code[20];
        NarrationText1: Text[60];
        AssPmtHdr: Record "Associate Payment Hdr";
        TotalAssAmt: Decimal;
        AssPmtHeader: Record "Associate Payment Hdr";
        UpdateAssPmtHeader: Record "Associate Payment Hdr";
    begin
        GenJnlLine.RESET;
        GenJnlLine.DELETEALL;

        BondSetup.GET;
        BondSetup.TESTFIELD("Cash Voucher Template Name");
        BondSetup.TESTFIELD("Cash Voucher Batch Name");
        BondSetup.TESTFIELD("Bank Voucher Template Name");
        BondSetup.TESTFIELD("Bank Voucher Batch Name");
        UnitSetup.GET;
        BondSetup.TESTFIELD("Asso. Pmt Voucher No. Series");
        PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Asso. Pmt Voucher No. Series", WORKDATE, TRUE);
        LineNo := 0;
        TotalAssAmt := 0;

        AssPmtHeader.RESET;
        AssPmtHeader.SETCURRENTKEY("Associate Code", Post);
        AssPmtHeader.SETRANGE("Associate Code", AssociatePaymentHdr."Associate Code");
        AssPmtHeader.SETRANGE("Document No.", AssociatePaymentHdr."Document No.");
        AssPmtHeader.SETRANGE("User ID", USERID);
        AssPmtHeader.SETRANGE(Post, FALSE);
        AssPmtHeader.SETRANGE("Line Type", AssPmtHeader."Line Type"::Header);
        IF AssPmtHeader.FINDFIRST THEN;


        AssPmtHdr.RESET;
        AssPmtHdr.SETCURRENTKEY("Associate Code", Post);
        AssPmtHdr.SETRANGE("Associate Code", AssociatePaymentHdr."Associate Code");
        AssPmtHdr.SETRANGE("User ID", USERID);
        AssPmtHdr.SETRANGE("Rejected/Approved", AssPmtHdr."Rejected/Approved"::Approved);
        AssPmtHdr.SETRANGE(Post, FALSE);
        IF AssPmtHdr.FINDSET THEN BEGIN
            REPEAT
                IF AssPmtHdr."Amt applicable for Payment" > 0 THEN BEGIN
                    TotalAssAmt := TotalAssAmt + AssPmtHdr."Amt applicable for Payment";
                    NarrationText1 := 'Associate Payment ' + COPYSTR(AssPmtHdr."Associate Code", 1, 30);
                    GenJnlLine.INIT;
                    IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Cash THEN BEGIN
                        GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                        GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                    END ELSE BEGIN
                        GenJnlLine."Journal Template Name" := BondSetup."Bank Voucher Template Name";
                        GenJnlLine."Journal Batch Name" := BondSetup."Bank Voucher Batch Name";
                    END;
                    GenJnlLine."Line No." := LineNo + 10000;
                    GenJnlLine.VALIDATE("Posting Date", AssPmtHdr."Posting Date");
                    GenJnlLine.VALIDATE("Document Date", AssPmtHdr."Document Date");
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment; //ALLETDK061212
                    GenJnlLine."Document No." := PostedDocNo;
                    GenJnlLine."Application No." := AssPmtHdr."Application No.";  //100924 code added
                    GenJnlLine."Special Incentive Bonanza" := AssPmtHdr."Special Incentive for Bonanza";  //100924 Code added

                    CompanyGLAccount.RESET;
                    CompanyGLAccount.SETRANGE("Company Code", AssPmtHdr."Company Name");
                    IF CompanyGLAccount.FINDFIRST THEN BEGIN
                        CompanyGLAccount.TESTFIELD("Receivable Account");
                    END;
                    IF AssPmtHdr."Company Name" = COMPANYNAME THEN BEGIN
                        BBPEntryExists := FALSE;
                        BBPEntryExists := TRUE;
                        INVAmt := 0;
                        InvClubAmt := 0;
                        InvTDS := 0;
                        INVAmt := AssPmtHdr."Eligible Amount";
                        InvClubAmt := AssPmtHdr."Club 9 Amount";
                        InvTDS := AssPmtHdr."TDS Amount";

                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                        GenJnlLine.VALIDATE("Account No.", AssPmtHdr."Associate Code");
                        AssPmtHdr."Posted on LLP Company" := TRUE;
                        GenJnlLine.VALIDATE(Amount, AssPmtHdr."Amt applicable for Payment");
                        IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission
                        ELSE
                            IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance"
                            ELSE
                                IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Incentive
                                ELSE
                                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;

                        GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                        GenJnlLine."Cheque Date" := AssociatePaymentHdr."Cheque Date";
                        GenJnlLine."Cheque No." := CopyStr(AssociatePaymentHdr."Cheque No.", 1, 10);//ALLE-AM
                        GenJnlLine."BBG Cheque No." := AssociatePaymentHdr."Cheque No.";//ALLE-AM
                        GenJnlLine."System-Created Entry" := TRUE;
                        GenJnlLine.Description := 'Associate Pmt';
                        GenJnlLine."Ref. External Doc. No." := AssociatePaymentHdr."Ref. External Doc. No.";  //Added new code 15122025

                        GenJnlLine.INSERT;
                    END ELSE BEGIN
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        GenJnlLine.VALIDATE("Account No.", CompanyGLAccount."Receivable Account");
                        GenJnlLine.VALIDATE(Amount, AssPmtHdr."Amt applicable for Payment");
                        IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission
                        ELSE
                            IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance"
                            ELSE
                                IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Incentive
                                ELSE
                                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;

                        GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                        GenJnlLine."Cheque Date" := AssociatePaymentHdr."Cheque Date";
                        GenJnlLine."Cheque No." := CopyStr(AssociatePaymentHdr."Cheque No.", 1, 10);//ALLE-AM
                        GenJnlLine."BBG Cheque No." := AssociatePaymentHdr."Cheque No.";//ALLE-AM
                        GenJnlLine."System-Created Entry" := TRUE;
                        GenJnlLine.Description := 'Associate Pmt';
                        GenJnlLine."Application No." := AssociatePaymentHdr."Application No.";
                        GenJnlLine."Special Incentive Bonanza" := AssociatePaymentHdr."Special Incentive for Bonanza";  //100924 Code added
                        LineNo := GenJnlLine."Line No.";
                        GenJnlLine."Ref. External Doc. No." := AssociatePaymentHdr."Ref. External Doc. No.";  //Added new code 15122025
                        GenJnlLine.INSERT;
                    END;
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                    InsertJnDimension(GenJnlLine); //310113
                    LineNo := GenJnlLine."Line No.";
                END;
                AssPmtHdr."Posted Document No." := PostedDocNo;
                AssPmtHdr.MODIFY;

            UNTIL AssPmtHdr.NEXT = 0;
            GenJnlLine.INIT;
            IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Cash THEN BEGIN
                GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
            END ELSE BEGIN
                GenJnlLine."Journal Template Name" := BondSetup."Bank Voucher Template Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Bank Voucher Batch Name";
            END;
            GenJnlLine."Line No." := LineNo + 10000;
            GenJnlLine.VALIDATE("Posting Date", AssPmtHdr."Posting Date");
            GenJnlLine.VALIDATE("Document Date", AssPmtHdr."Document Date");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment; //ALLETDK061212
            GenJnlLine."Document No." := PostedDocNo;
            IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Cash THEN BEGIN
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", AssPmtHeader."Bank/G L Code");
            END;
            IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Bank THEN BEGIN
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.VALIDATE("Account No.", AssPmtHeader."Bank/G L Code");
                GenJnlLine."Cheque No." := CopyStr(AssPmtHeader."Cheque No.", 1, 10);//ALLE-AM
                GenJnlLine."BBG Cheque No." := AssPmtHeader."Cheque No.";//ALLE-AM
                GenJnlLine."Cheque Date" := AssPmtHeader."Cheque Date";
            END;
            GenJnlLine.VALIDATE(Amount, -1 * TotalAssAmt);
            IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission
            ELSE
                IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance"
                ELSE
                    IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Incentive
                    ELSE
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.Description := 'Associate Pmt';
            GenJnlLine."Application No." := AssPmtHeader."Application No.";  //100924 code added
            GenJnlLine."Special Incentive Bonanza" := AssPmtHeader."Special Incentive for Bonanza";  //100924 Code added
            LineNo := GenJnlLine."Line No.";
            GenJnlLine."Ref. External Doc. No." := AssPmtHeader."Ref. External Doc. No.";  //Added new code 15122025
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);

            InsertJnDimension(GenJnlLine); //310113

            IF BBPEntryExists THEN BEGIN

                // Invoice Creation........................
                LineNo := GenJnlLine."Line No.";
                GenJnlLine.INIT;
                IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Cash THEN BEGIN
                    GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                END ELSE BEGIN
                    GenJnlLine."Journal Template Name" := BondSetup."Bank Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Bank Voucher Batch Name";
                END;
                GenJnlLine."Line No." := LineNo + 10000;
                GenJnlLine.VALIDATE("Posting Date", AssPmtHdr."Posting Date");
                GenJnlLine.VALIDATE("Document Date", AssPmtHdr."Document Date");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice; //ALLETDK061212
                GenJnlLine."Document No." := PostedDocNo;

                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", UnitSetup."Incentive A/C");
                GenJnlLine.VALIDATE(Amount, INVAmt);
                IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission
                ELSE
                    IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance"
                    ELSE
                        IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Incentive
                        ELSE
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Application No." := AssPmtHdr."Application No.";  //100924 added new code
                GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."External Document No." := PostedDocNo;
                GenJnlLine.Description := 'Incentive Invoice';
                GenJnlLine."Application No." := AssPmtHdr."Application No.";  //100924 Code added
                GenJnlLine."Special Incentive Bonanza" := AssPmtHdr."Special Incentive for Bonanza";  //100924 Code added
                GenJnlLine."Ref. External Doc. No." := AssPmtHdr."Ref. External Doc. No.";  //Added new code 15122025
                GenJnlLine.INSERT;
                LineNo := GenJnlLine."Line No.";
                GenJnlLine.INIT;
                IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Cash THEN BEGIN
                    GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                END ELSE BEGIN
                    GenJnlLine."Journal Template Name" := BondSetup."Bank Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Bank Voucher Batch Name";
                END;
                GenJnlLine."Line No." := LineNo + 10000;
                GenJnlLine.VALIDATE("Posting Date", AssPmtHdr."Posting Date");
                GenJnlLine.VALIDATE("Document Date", AssPmtHdr."Document Date");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice; //ALLETDK061212
                GenJnlLine."Document No." := PostedDocNo;

                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", '116400');
                GenJnlLine.VALIDATE(Amount, -1 * InvTDS);
                IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission
                ELSE
                    IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance"
                    ELSE
                        IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Incentive
                        ELSE
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;

                GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine.Description := 'Incentive Invoice';
                GenJnlLine."External Document No." := PostedDocNo;
                GenJnlLine."Application No." := AssPmtHdr."Application No.";  //110924 Code added
                GenJnlLine."Special Incentive Bonanza" := AssPmtHdr."Special Incentive for Bonanza";  //100924 Code added
                GenJnlLine."Ref. External Doc. No." := AssPmtHdr."Ref. External Doc. No.";  //Added new code 15122025
                GenJnlLine.INSERT;
                LineNo := GenJnlLine."Line No.";
                GenJnlLine.INIT;
                IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Cash THEN BEGIN
                    GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                END ELSE BEGIN
                    GenJnlLine."Journal Template Name" := BondSetup."Bank Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Bank Voucher Batch Name";
                END;
                GenJnlLine."Line No." := LineNo + 10000;
                GenJnlLine.VALIDATE("Posting Date", AssPmtHdr."Posting Date");
                GenJnlLine.VALIDATE("Document Date", AssPmtHdr."Document Date");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice; //ALLETDK061212
                GenJnlLine."Document No." := PostedDocNo;

                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", UnitSetup."Corpus A/C");
                GenJnlLine.VALIDATE(Amount, -1 * InvClubAmt);
                IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission
                ELSE
                    IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance"
                    ELSE
                        IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Incentive
                        ELSE
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;

                GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine.Description := 'Incentive Invoice';
                GenJnlLine."External Document No." := PostedDocNo;
                GenJnlLine."Application No." := AssPmtHdr."Application No.";  //110924 Code added
                GenJnlLine."Special Incentive Bonanza" := AssPmtHdr."Special Incentive for Bonanza";  //100924 Code added
                GenJnlLine."Ref. External Doc. No." := AssPmtHdr."Ref. External Doc. No.";  //Added new code 15122025
                GenJnlLine.INSERT;
                LineNo := GenJnlLine."Line No.";
                GenJnlLine.INIT;
                IF AssPmtHeader."Payment Mode" = AssPmtHeader."Payment Mode"::Cash THEN BEGIN
                    GenJnlLine."Journal Template Name" := BondSetup."Cash Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Cash Voucher Batch Name";
                END ELSE BEGIN
                    GenJnlLine."Journal Template Name" := BondSetup."Bank Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Bank Voucher Batch Name";
                END;
                GenJnlLine."Line No." := LineNo + 10000;
                GenJnlLine.VALIDATE("Posting Date", AssPmtHdr."Posting Date");
                GenJnlLine.VALIDATE("Document Date", AssPmtHdr."Document Date");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice; //ALLETDK061212
                GenJnlLine."Document No." := PostedDocNo;

                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", AssPmtHeader."Associate Code");
                GenJnlLine.VALIDATE(Amount, -1 * (INVAmt - InvClubAmt - InvTDS));
                IF AssPmtHdr.Type = AssPmtHdr.Type::Commission THEN
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission
                ELSE
                    IF AssPmtHdr.Type = AssPmtHdr.Type::TA THEN
                        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance"
                    ELSE
                        IF AssPmtHdr.Type = AssPmtHdr.Type::Incentive THEN
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Incentive
                        ELSE
                            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;

                GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."External Document No." := PostedDocNo;
                GenJnlLine."Application No." := AssPmtHeader."Application No.";  //110924 Code added
                GenJnlLine."Special Incentive Bonanza" := AssPmtHeader."Special Incentive for Bonanza";  //100924 Code added
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Payment;
                GenJnlLine."Applies-to Doc. No." := PostedDocNo;
                GenJnlLine.Description := 'Incentive Invoice';
                GenJnlLine."Ref. External Doc. No." := AssPmtHeader."Ref. External Doc. No.";  //Added new code 15122025
                GenJnlLine.INSERT;
                CreateTDSEntry(PostedDocNo, AssPmtHeader."Associate Code", ABS(InvTDS), ABS(INVAmt), AssPmtHdr."Posting Date");
                InsertJnDimension(GenJnlLine); //310113
            END;
            // Invoice Creation.........................

            PostGenJnlLines(GenJnlLine."Document No.");
        END;
        IF PostedDocNo <> '' THEN BEGIN
            UpdateAssPmtHeader.RESET;
            UpdateAssPmtHeader.SETRANGE("User ID", USERID);
            UpdateAssPmtHeader.SETRANGE("Rejected/Approved", UpdateAssPmtHeader."Rejected/Approved"::Approved);
            UpdateAssPmtHeader.SETRANGE(Post, FALSE);
            UpdateAssPmtHeader.SETRANGE("Posted Document No.", PostedDocNo);
            IF UpdateAssPmtHeader.FINDSET THEN
                REPEAT
                    UpdateAssPmtHeader.Post := TRUE;
                    UpdateAssPmtHeader.MODIFY;
                UNTIL UpdateAssPmtHeader.NEXT = 0;
        END;
    end;


    procedure CreateTDSEntry(DocNo: Code[20]; Ass_ID: Code[20]; TDS_Amt_1: Decimal; Base_Amt_1: Decimal; PostDate_1: Date)
    var
        TDSEntry: Record "TDS Entry"; // "13729";
        NextTDSEntryNo: Integer;
        Vend: Record Vendor;
    begin
        Vend.RESET;
        Vend.GET(Ass_ID);
        TDSEnt.RESET;
        IF TDSEnt.FINDLAST THEN
            NextTDSEntryNo := TDSEnt."Entry No.";
        TDSEntry.INIT;
        TDSEntry."Entry No." := NextTDSEntryNo + 1;
        TDSEntry."Document Type" := TDSEntry."Document Type"::Invoice;
        TDSEntry."Document No." := DocNo;
        TDSEntry."Posting Date" := PostDate_1;
        TDSEntry."Account Type" := TDSEntry."Account Type"::"G/L Account";
        //TDSEntry.Description := Vend.Name;
        TDSEntry."Account No." := '116400';
        TDSEntry."Party Type" := TDSEntry."Party Type"::Vendor;
        TDSEntry."Party Code" := Ass_ID;

        //TDSEntry."TDS Group" := TDSEntry."TDS Group"::Commission;
        TDSEntry.Section := 'Comm';
        TDSEntry."Assessee Code" := 'IND';
        //    TDSEntry."Transaction No." := NextTransactionNo;
        TDSEntry."TDS %" := 5;

        //TDSEntry.Section := TDSEntry.Section;

        TDSEntry."Source Code" := 'PURCHASES';
        IF TDSEntry."Party Type" = TDSEntry."Party Type"::Vendor THEN BEGIN
            //TDSEntry."Deductee P.A.N. No." := Vend."P.A.N. No.";
        END;
        IF TDSEntry."Party Type" = TDSEntry."Party Type"::Party THEN BEGIN
            //TDSEntry."Deductee P.A.N. No." := Vend."P.A.N. No.";
        END;
        TDSEntry."TDS Base Amount" := Base_Amt_1;
        TDSEntry."TDS Amount" := TDS_Amt_1;
        //    TDSEntry."Surcharge Base Amount" := ABS("TDS_Club Adj ElegVsOD".Amount);
        TDSEntry."TDS Amount Including Surcharge" := ABS(TDS_Amt_1);
        TDSEntry."Total TDS Including SHE CESS" := (TDS_Amt_1);
        TDSEntry."Bal. TDS Including SHE CESS" := ABS(TDS_Amt_1);
        TDSEntry."Invoice Amount" := Base_Amt_1;
        TDSEntry.INSERT;
    end;


    procedure "------------------------------"()
    begin
    end;


    procedure NewUpdateUnit_ComBufferAmt(RecUnitPayEntry: Record "Unit Payment Entry"; FromApplication: Boolean): Decimal
    var
        PTLineSale: Record "Payment Terms Line Sale";
        PTLineSale1: Record "Payment Terms Line Sale";
        ProjectMilestoneLine: Record "Project Milestone Line";
        ProjectMilestoneHdr: Record "Project Milestone Header";
        RecApplication1: Record Application;
        UnitBufferAmt: Decimal;
        RecConforder1: Record "Confirmed Order";
        AppAmt: Decimal;
        AppPaymentEntry1: Record "Application Payment Entry";
        FullAmountRcvd: Boolean;
        UnitPEntry: Record "Unit Payment Entry";
        BalanceAmt: Decimal;
        OnFullPmt: Boolean;
        AssoBalanceAmt: Decimal;
        TotalBalAmt: Decimal;
        TotalAssBalAmt: Decimal;
        AppCharge: Record "Applicable Charges";
        UnitPmtEntry: Record "Unit Payment Entry";
        TotalAmt: Decimal;
        ExistCommAmt: Decimal;
        Firstmileston: Decimal;
        Secondmileston: Decimal;
        PaymentTermLineSale: Record "Payment Terms Line Sale";
        MilestonSequence: Code[10];
        DelUPEntry: Record "Unit Payment Entry";
        OldUnitPmtEntry: Record "Unit Payment Entry";
        OldUnitPmtEntry1: Record "Unit Payment Entry";
        RcptAmt_1: Decimal;
        UnitBufferAmt1: Decimal;
        MinAmount: Decimal;
        FirstLineNo: Integer;
        NoncommissionAmt: Decimal;
        NewMinAmount: Decimal;
        UnitAndCommbuffers: Record "Unit & Comm. Creation Buffer";
    begin
        CLEAR(ComHoldDate);
        CLEAR(PostDate);
        CLEAR(PTLineSale);
        CLEAR(RecApplication1);
        CLEAR(AppAmt);
        CLEAR(RecConforder1);
        CLEAR(BalanceAmt);
        FullAmountRcvd := FALSE;
        MinAmount := 0;
        NewMinAmount := 0;
        IF FromApplication THEN BEGIN
            IF RecApplication1.GET(RecUnitPayEntry."Application No.") THEN
                AppAmt := RecApplication1."Investment Amount";
            PostDate := RecApplication1."Posting Date";
            MinAmount := RecApplication1."Min. Allotment Amount";
        END ELSE BEGIN
            IF RecConforder1.GET(RecUnitPayEntry."Application No.") THEN
                AppAmt := RecConforder1.Amount;
            PostDate := RecConforder1."Posting Date";
            MinAmount := RecConforder1."Min. Allotment Amount";
        END;
        //MinAmount := 777700.00;
        //Code Start 26092025 
        NewMinAmount := PPLANCommissonCalculate(RecConforder1);

        IF NewMinAmount > 0 then begin
            IF MinAmount > NewMinAmount then
                MinAmount := NewMinAmount;
        end;
        //Code END 26092025 
        ComHoldDate := DMY2DATE(31, 10, 2014);

        IF PostDate > ComHoldDate THEN BEGIN

            AppPaymentEntry1.RESET;
            AppPaymentEntry1.SETCURRENTKEY(AppPaymentEntry1."Document No.", AppPaymentEntry1."Cheque Status");
            AppPaymentEntry1.SETRANGE("Document No.", RecUnitPayEntry."Application No.");
            AppPaymentEntry1.SETRANGE("Cheque Status", AppPaymentEntry1."Cheque Status"::Cleared);
            IF AppPaymentEntry1.FINDSET THEN BEGIN
                AppPaymentEntry1.CALCSUMS(AppPaymentEntry1.Amount);
                IF AppPaymentEntry1.Amount >= AppAmt THEN
                    FullAmountRcvd := TRUE;
            END;

            //NEW......................
            AppCharge.RESET;
            AppCharge.SETRANGE("Document No.", RecUnitPayEntry."Application No.");
            AppCharge.SETRANGE("Commision Applicable", TRUE);
            AppCharge.SETRANGE(Code, RecUnitPayEntry."Charge Code");
            IF AppCharge.FINDFIRST THEN BEGIN
                TotalAmt := 0;
                UnitBufferAmt1 := 0;
                FirstLineNo := 0;
                NoncommissionAmt := 0;
                CLEAR(PaymentTermLineSale);
                PaymentTermLineSale.RESET;
                PaymentTermLineSale.SETRANGE("Document No.", AppCharge."Document No.");
                IF PaymentTermLineSale.FINDFIRST THEN
                    REPEAT
                        IF NOT PaymentTermLineSale."Commision Applicable" THEN
                            NoncommissionAmt := NoncommissionAmt + PaymentTermLineSale."Criteria Value / Base Amount";
                    UNTIL (PaymentTermLineSale.NEXT = 0) OR (PaymentTermLineSale."Commision Applicable");

                MinAmount := MinAmount - NoncommissionAmt;
                UnitBufferAmt1 := MinAmount;

                CLEAR(OldUnitPmtEntry1);
                OldUnitPmtEntry1.RESET;
                OldUnitPmtEntry1.SETRANGE("Document No.", AppCharge."Document No.");
                OldUnitPmtEntry1.SETFILTER("Line No.", '<=%1', RecUnitPayEntry."Line No.");
                IF NewMinAmount > 0 then  //26092025
                    OldUnitPmtEntry1.SetFilter("Charge Code", '<>%1', 'PPLAN');  //26092025
                OldUnitPmtEntry1.SETRANGE("Commision Applicable", TRUE);
                IF OldUnitPmtEntry1.FINDSET THEN
                    REPEAT
                        RcptAmt_1 := RcptAmt_1 + OldUnitPmtEntry1.Amount;
                    UNTIL OldUnitPmtEntry1.NEXT = 0;

                IF ((ROUND(UnitBufferAmt1, 1) - ROUND(RcptAmt_1, 1)) >= 0) THEN
                    UnitBufferAmt := RecUnitPayEntry.Amount
                ELSE BEGIN
                    UnitBufferAmt := RecUnitPayEntry.Amount + (UnitBufferAmt1 - RcptAmt_1);
                    // Code Start 26092025 
                    If NewMinAmount > 0 THEN begin
                        IF (RcptAmt_1 - UnitBufferAmt1) > 0 then BEGIN
                            UnitAndCommbuffers.RESET;
                            UnitAndCommbuffers.SetRange("Unit No.", RecUnitPayEntry."Application No.");
                            UnitAndCommbuffers.SetFilter("Balance CommissionAmt", '<>%1', 0);
                            If UnitAndCommbuffers.FindFirst() then begin
                                IF RecUnitPayEntry."Charge Code" = 'PPLAN' then
                                    UnitBufferAmt := ABS(RecUnitPayEntry.Amount)
                                else
                                    UnitBufferAmt := 0; //ABS(RecUnitPayEntry.Amount);
                            end ELSE begin
                                UnitBufferAmt := ABS(RecUnitPayEntry.Amount + (UnitBufferAmt1 - RcptAmt_1));
                                UnitAndCommbuffers.RESET;
                                UnitAndCommbuffers.SetRange("Unit No.", RecUnitPayEntry."Application No.");
                                If UnitAndCommbuffers.FindFirst() then begin
                                    UnitAndCommbuffers."Balance CommissionAmt" := (RcptAmt_1 - UnitBufferAmt1);
                                    UnitAndCommbuffers.Modify;
                                end;
                            end;
                        END ELSE BEGIN
                            UnitAndCommbuffers.RESET;
                            UnitAndCommbuffers.SetRange("Unit No.", RecUnitPayEntry."Application No.");
                            If UnitAndCommbuffers.FindFirst() then begin
                                UnitAndCommbuffers."Balance CommissionAmt" := 0;
                                UnitAndCommbuffers.Modify();
                            END;
                        END;

                        //Code END 26092025 
                    END ELSE
                        IF UnitBufferAmt < 0 THEN
                            UnitBufferAmt := 0;

                    CLEAR(OldUnitPmtEntry1);
                    OldUnitPmtEntry1.RESET;
                    OldUnitPmtEntry1.SETRANGE("Document No.", AppCharge."Document No.");
                    OldUnitPmtEntry1.SETFILTER("Balance Amount", '<>%1', 0);
                    IF OldUnitPmtEntry1.FINDSET THEN
                        REPEAT
                            OldUnitPmtEntry1."Balance Amount" := 0;
                            OldUnitPmtEntry1.MODIFY;
                        UNTIL OldUnitPmtEntry1.NEXT = 0;


                    CLEAR(OldUnitPmtEntry1);
                    OldUnitPmtEntry1.RESET;
                    OldUnitPmtEntry1.SETRANGE("Document No.", AppCharge."Document No.");
                    OldUnitPmtEntry1.SETRANGE("Line No.", RecUnitPayEntry."Line No.");
                    IF OldUnitPmtEntry1.FINDFIRST THEN BEGIN
                        OldUnitPmtEntry1."Balance Amount" := ABS(RcptAmt_1 - UnitBufferAmt1);
                        OldUnitPmtEntry1.MODIFY;
                    END;
                END;
                //    UNTIL AppCharge.NEXT =0;
            END ELSE
                IF RecUnitPayEntry."Direct Associate" THEN //100219
                    UnitBufferAmt := RecUnitPayEntry.Amount;


            CLEAR(UnitPmtEntry);
            UnitPmtEntry.RESET;
            UnitPmtEntry.SETRANGE(UnitPmtEntry."Document No.", AppCharge."Document No.");
            UnitPmtEntry.SETFILTER("Line No.", '>%1', RecUnitPayEntry."Line No.");
            IF NOT UnitPmtEntry.FINDFIRST THEN BEGIN
                IF FullAmountRcvd THEN BEGIN
                    AssoBalanceAmt := 0;
                    CLEAR(UnitPEntry);
                    UnitPEntry.RESET;
                    UnitPEntry.SETCURRENTKEY("Document No.", "Charge Code");
                    UnitPEntry.SETRANGE(UnitPEntry."Document No.", RecUnitPayEntry."Document No.");
                    UnitPEntry.SETFILTER(UnitPEntry."Balance Amount", '<>%1', 0);
                    IF UnitPEntry.FINDSET THEN BEGIN
                        REPEAT
                            BalanceAmt := 0;
                            PTLineSale1.RESET;
                            PTLineSale1.SETCURRENTKEY("Document No.", "Charge Code");
                            PTLineSale1.SETRANGE("Document No.", RecUnitPayEntry."Application No.");
                            PTLineSale1.SETRANGE("Charge Code", UnitPEntry."Charge Code");
                            PTLineSale1.SETRANGE("Direct Associate", UnitPEntry."Direct Associate");
                            IF PTLineSale1.FINDFIRST THEN BEGIN
                                BalanceAmt := 0;
                                BalanceAmt := UnitPEntry."Balance Amount";
                                UnitPEntry."Balance Amount" := 0;
                                UnitPEntry.MODIFY;
                            END;

                            IF FromApplication THEN
                                CreateStaggingforBalAmt(UnitPEntry, BalanceAmt, TRUE)
                            ELSE
                                CreateStaggingforBalAmt(UnitPEntry, BalanceAmt, FALSE);
                        UNTIL UnitPEntry.NEXT = 0;
                    END;
                END;
            END;
        END ELSE BEGIN
            UnitBufferAmt := RecUnitPayEntry.Amount;
            EXIT(UnitBufferAmt);
        END;

        IF (RecUnitPayEntry."Payment Mode" = RecUnitPayEntry."Payment Mode"::JV) AND (RecUnitPayEntry.Amount < 0) THEN BEGIN
            EXIT(UnitBufferAmt);
        END ELSE
            EXIT(ABS(UnitBufferAmt));
    end;

    procedure CreateJSONAttribute(AttributeName: Text; Value: Variant)
    begin
        /*
        JSONTextWriter.WritePropertyName(AttributeName);
        JSONTextWriter.WriteValue(Value);
        *///Need to check the code in UAT

    end;


    procedure SendSMS_DeActivate(MobileNo: Text[30]; SMSText: Text[1000])
    var
        SMSUrl: Text[500];
        JSONString: Text;
        FinalJSON: Text;
        SendReceiptSMS: Codeunit "Send Receipt SMS";
        Vendor: Record Vendor;
        LJObject: JsonObject;
        LJArrayData: JsonArray;
        MJObject: JsonObject;
        MJObject2: JsonObject;
        Client: HttpClient;
        Headers: HttpHeaders;
        contentHeaders: HttpHeaders;
        Contant: HttpContent;
        JsonResponse: Text;
        RequestUrl: Text;
        JArray: JsonArray;
        cu: Codeunit Encoding;
        DotNetEncodeing: Codeunit DotNet_Encoding;
        DotNetArray: Codeunit DotNet_Array;
        DotNetArrayBytes: Codeunit DotNet_Array;
        Request: HttpRequestMessage;
        Content: HttpContent;
        RespMsg: Text;

    begin
        //210224 Added new code for check mobile no.

        CLEAR(CheckMobileNoforSMS);
        ExitMessage := CheckMobileNoforSMS.CheckMobileNo(MobileNo, FALSE);
        IF ExitMessage THEN BEGIN
            CompInfo.GET;  //170225

            Clear(JSONTextWriter);
            Clear(MJObject);
            Clear(LJArrayData);
            Clear(MJObject2);
            Clear(FinalJSON);
            CompInfo.GET;
            JSONTextWriter.Add('userName', 'bbgindia1');
            JSONTextWriter.Add('priority', '0');
            JSONTextWriter.Add('referenceId', '1241547676');
            JSONTextWriter.Add('msgType', '8');
            JSONTextWriter.Add('senderId', 'BBGIND');
            JSONTextWriter.Add('message', SMSText);
            MJObject.Add('mobileNumber', '91' + MobileNo);
            LJArrayData.Add(MJObject);
            MJObject2.Add('messageParams', LJArrayData);
            JSONTextWriter.Add('mobileNumbers', MJObject2);
            JSONTextWriter.Add('password', CompInfo."SMS Password");
            JSONString := Format(JSONTextWriter);
            FinalJSON := JSONString;
            Headers := Client.DefaultRequestHeaders();
            TextString := STRSUBSTNO(FinalJSON);
            // Bytes := cu.Convert(1200, 28591, TextString);
            RequestUrl := 'https://api.me.synapselive.com/v1/multichannel/messages/sendsms';
            Request.Method := 'POST';
            //Content.WriteFrom(Bytes);
            Content.WriteFrom(TextString);
            content.GetHeaders(Headers);
            Headers.Remove('Content-Type');
            Headers.Add('Content-Type', 'application/json; charset=utf-8');
            Client.Post(RequestUrl, Content, HttpWebResponse);
            if HttpWebResponse.IsSuccessStatusCode then begin
                HttpWebResponse.Content.ReadAs(RespMsg);
                //                Message(JsonResponse);
            End Else begin
                HttpWebResponse.Content.ReadAs(RespMsg);
                //              Message(RespMsg);
            end;

        END;
    END;


    procedure SendSMS_DeActivate_2(MobileNo: Text[30]; SMSText: Text[1000])
    var
        SMSUrl: Text[500];
        JSONString: Text;

    //  SendReceiptSMS: Codeunit "Send Receipt SMS";
    begin
        /*
        StringBuilder := StringBuilder.StringBuilder;
        StringWriter := StringWriter.StringWriter(StringBuilder);
        JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);
        JSONTextWriter.WriteStartObject;
        CreateJSONAttribute('userName', 'bbgindia1');
        CreateJSONAttribute('priority', '0');
        CreateJSONAttribute('referenceId', '1241547676');
        CreateJSONAttribute('msgType', '8');
        CreateJSONAttribute('senderId', 'BBGIND');
        CreateJSONAttribute('message', SMSText);
        JSONTextWriter.WritePropertyName('mobileNumbers');
        JSONTextWriter.WriteStartObject;
        JSONTextWriter.WritePropertyName('messageParams');
        JSONTextWriter.WriteStartArray;
        JSONTextWriter.WriteStartObject;
        CreateJSONAttribute('mobileNumber', '91' + MobileNo);
        JSONTextWriter.WriteEndObject;
        JSONTextWriter.WriteEndArray;
        JSONTextWriter.WriteEndObject;
        CreateJSONAttribute('password', CompInfo."SMS Password");
        JSONTextWriter.WriteEndObject;
        JSON := StringBuilder.ToString();
        JSONString := FORMAT(JSON);
        FinalJSON := JSONString;
        //MESSAGE(FinalJSON);

        //HttpWebRequest := HttpWebRequest.Create('http://api.synapselive.vectramind.in/v1/multichannel/messages/sendsms');
        HttpWebRequest := HttpWebRequest.Create('https://api.me.synapselive.com/v1/multichannel/messages/sendsms');  // ALLE AKUL ADD 261022
        HttpWebRequest.Method := 'POST';
        HttpWebRequest.ContentType := 'application/json';
        TextString := STRSUBSTNO(FinalJSON);
        //MESSAGE(TextString);

        StreamWriter := StreamWriter.StreamWriter(HttpWebRequest.GetRequestStream);
        StreamWriter.Write(TextString);
        StreamWriter.Close();
        //Encoding := Encoding.UTF32();//UTF8();
        //Bytes := Encoding.GetEncoding('iso-8859-1').GetBytes(TextString.ToString);
        //HttpWebRequest.ContentLength := TextString.Length;
        //HttpWebRequest.GetRequestStream.Write(Bytes, 0, Bytes.Length);
        HttpWebResponse := HttpWebRequest.GetResponse;
        StreamReader := StreamReader.StreamReader(HttpWebResponse.GetResponseStream);
        ResText := StreamReader.ReadToEnd();
        MESSAGE('%1', ResText);
        StreamReader.Close();
        *///Need to check the code in UAT

        //        StreamReader.Close();
        //*///Need to check the code in UAT

    end;

    procedure PPLANCommissonCalculate(NewConfirmedOrder_2: Record "Confirmed Order"): Decimal;
    Var
        PmtTermsLines: Record "Payment Terms Line Sale";
        ProjectwisePPLanComm: Record "Project wise PPLAN Commission";
        RecNewConforder: Record "Confirmed Order";
        ProjCode: code[20];
        DOJ: Date;

        NewMinAllotment: Decimal;


    begin
        // 26092025 Start
        ProjCode := '';
        DOJ := 0D;
        NewMinAllotment := 0;
        RecNewConforder.Reset();
        If RecNewConforder.GET(NewConfirmedOrder_2."No.") THEN begin
            ProjCode := RecNewConforder."Shortcut Dimension 1 Code";
            DOJ := RecNewConforder."Posting Date";
        end;

        ProjectwisePPLanComm.RESET;
        ProjectwisePPLanComm.SETRANGE("Project Code", RecNewConforder."Shortcut Dimension 1 Code");
        ProjectwisePPLanComm.SetFilter("Effective From Date", '<=%1', DOJ);
        ProjectwisePPLanComm.SetFilter("Effective To Date", '>=%1', DOJ);
        IF ProjectwisePPLanComm.FindFirst() then begin
            PmtTermsLines.RESET;
            PmtTermsLines.SetRange("Document No.", RecNewConforder."No.");
            PmtTermsLines.Setfilter("Charge Code", '<>%1', 'PPLAN');
            PmtTermsLines.SetRange("Commision Applicable", true);
            PmtTermsLines.SetRange("Direct Associate", False);
            IF PmtTermsLines.FindSet() then
                repeat
                    NewMinAllotment := NewMinAllotment + PmtTermsLines."Criteria Value / Base Amount";
                until PmtTermsLines.next = 0;
        END;
        If NewMinAllotment > 0 then
            Exit(NewMinAllotment)
        ELSE
            Exit(0.00);

        //        26092025 END 



    end;

}

