codeunit 97728 "Application Reverse"
{
    Permissions = TableData "G/L Entry" = rim,
                  TableData "Bank Account Ledger Entry" = rim,
                  TableData "Dimension Set ID Filter Line" = rim;

    trigger OnRun()
    begin
    end;

    var
        GenJnlLine: Record "Gen. Journal Line" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        UserSetup: Record "User Setup";
        UnitOfficeCode: Code[20];
        CounterCode: Code[20];
        DiscAmount: Decimal;
        PeriodicInterestAmt: Decimal;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        MonthlyInstallment: Decimal;
        BondMgmt: Codeunit "Unit Post";
        LineNo: Integer;
        Text001: Label 'Please clear Bonus posting buffer for the Bond No %1.';
        GetDescription: Codeunit GetDescription;


    procedure ApplicationReverse(ApplicationNo: Code[20])
    var
        Application: Record Application;
        BondPaymentEntry: Record "Unit Payment Entry";
        BondReversalEntries: Record "Unit Reversal Entries";
        BonusPostingBuffer: Record "Bonus Posting Buffer";
        BondSetUp: Record "Unit Setup";
    begin
        BondSetUp.GET;
        Application.GET(ApplicationNo);
        /*
        BonusPostingBuffer.SETCURRENTKEY("Bond No.");
        BonusPostingBuffer.SETRANGE("Bond No.",Application."Bond No.");
        IF NOT BonusPostingBuffer.ISEMPTY THEN
          ERROR(Text001,Application."Bond No.");
        */

        IF UserSetup.GET(Application."User ID") THEN BEGIN
            UnitOfficeCode := UserSetup."Shortcut Dimension 2 Code";
            CounterCode := UserSetup."Shortcut Dimension 2 Code";
        END;

        ValidateSetup(Application);

        //Application Journal Reversal
        CreateGenJnlLines(Application);

        //Bonus
        BonusReversal(Application."Unit No.", Application."Posted Doc No.");

        //Posting
        PostGenJnlLines;

        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::Application);
        BondPaymentEntry.SETRANGE("Document No.", Application."Application No.");
        BondPaymentEntry.SETRANGE(Posted, TRUE);
        BondPaymentEntry.MODIFYALL(Posted, FALSE);
        IF Application."With Cheque" = TRUE THEN BEGIN
            Application."With Cheque" := FALSE;
            Application."Cheque Cleared" := FALSE;
        END;

        BondReversalEntries.SETRANGE("Document Type", BondReversalEntries."Document Type"::Application);
        BondReversalEntries.SETRANGE("Document No.", Application."Posted Doc No.");
        IF BondReversalEntries.FINDLAST THEN
            LineNo := BondReversalEntries."Line No." + 10000
        ELSE
            LineNo := 10000;

        BondReversalEntries.INIT;
        BondReversalEntries."Document Type" := BondReversalEntries."Document Type"::Application;
        BondReversalEntries."Document No." := Application."Posted Doc No.";
        BondReversalEntries."Line No." := LineNo;
        BondReversalEntries."Application No." := Application."Application No.";
        BondReversalEntries."Unit No." := Application."Unit No.";
        BondReversalEntries."Posted. Doc. No." := Application."Posted Doc No.";
        BondReversalEntries."Posting date" := Application."Posting Date";
        BondReversalEntries."Document Date" := Application."Document Date";
        BondReversalEntries."User ID" := UserSetup."User ID";
        BondReversalEntries."Reverse Date" := GetDescription.GetDocomentDate;
        BondReversalEntries."Reverse Time" := TIME;

        BondReversalEntries.INSERT;
        ReleaseBondApplication.InsertBondHistory(Application."Unit No.", 'Application Released Reversed.', 0, Application."Application No.");

        Application.Status := Application.Status::Open;
        //Application."Posted Doc No." := '';
        Application.MODIFY;

        COMMIT;

    end;


    procedure CreateGenJnlLines(Application: Record Application)
    var
        BondPaymentEntry: Record "Unit Payment Entry";
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "ID 2 Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        CashFromBonus: Decimal;
        BondSetUp: Record "Unit Setup";
    begin
        BondSetUp.GET;
        GenJnlLine.DELETEALL;
        LineNo := 10000;
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::Application);
        BondPaymentEntry.SETRANGE("Document No.", Application."Application No.");
        BondPaymentEntry.SETRANGE(Posted, TRUE);
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::Cash)) THEN BEGIN
                    IF BondPaymentEntry."Cheque Status" = BondPaymentEntry."Cheque Status"::Cleared THEN
                        CreateGenJnlLinesForClChq(BondPaymentEntry, Application)
                    ELSE BEGIN
                        PaymentMethod.GET(BondPaymentEntry."Payment Method");
                        GenJnlLine.INIT;
                        GenJnlLine."Line No." := LineNo;
                        GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
                        GenJnlLine.VALIDATE("Document Date", Application."Document Date");

                        IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"G/L Account" THEN
                            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account")
                        ELSE
                            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");

                        GenJnlLine.VALIDATE("Account No.", PaymentMethod."Bal. Account No.");
                        GenJnlLine.VALIDATE(Amount, -BondPaymentEntry.Amount);
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                        GenJnlLine."Document No." := Application."Posted Doc No.";
                        GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                        GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                        IF BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::Cash THEN BEGIN
                            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::"Bank Account");
                            GenJnlLine.VALIDATE("Source No.", BondPaymentEntry."Deposit/Paid Bank");
                        END ELSE BEGIN
                            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
                            GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
                        END;
                        GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                        GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                        GenJnlLine."Introducer Code" := Application."Associate Code";
                        GenJnlLine."Unit No." := Application."Unit No.";
                        GenJnlLine."Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";
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
                                    GenJnlLine.Description := 'D.D. Received';

                        GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                        GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                        GenJnlLine."Do Not Show" := TRUE;
                        GenJnlLine.INSERT;
                    END;
                    LineNo := LineNo + 10000;
                END;
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash)) THEN BEGIN
                    CashPmtMethod.GET(BondPaymentEntry."Payment Method");
                    CashAmount += BondPaymentEntry.Amount;
                END;
            UNTIL BondPaymentEntry.NEXT = 0;

        //CASH Cr
        IF CashAmount <> 0 THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Line No." := LineNo;
            GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Application."Document Date");

            CASE CashPmtMethod."Bal. Account Type" OF

                CashPmtMethod."Bal. Account Type"::"G/L Account":
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");

                CashPmtMethod."Bal. Account Type"::"Bank Account":
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");

            END;

            GenJnlLine.VALIDATE("Account No.", CashPmtMethod."Bal. Account No.");
            GenJnlLine.VALIDATE(Amount, -CashAmount);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := Application."Posted Doc No.";
            GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
            GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
            GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
            GenJnlLine."Introducer Code" := Application."Associate Code";
            GenJnlLine."Unit No." := Application."Unit No.";
            GenJnlLine."Installment No." := 1;
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
            GenJnlLine.Description := 'Cash Received';
            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
            GenJnlLine."Do Not Show" := TRUE;
            GenJnlLine.INSERT;
        END;

        LineNo += 10000;
        //Discount Credit
        IF Application."Discount Amount" > 0 THEN BEGIN
            PaymentMethod.GET(BondSetUp."Discount Allowed on Bond A/C");
            GenJnlLine.INIT;
            GenJnlLine."Line No." := LineNo;
            GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Application."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", PaymentMethod."Bal. Account No.");
            GenJnlLine.VALIDATE(Amount, -Application."Discount Amount");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := Application."Posted Doc No.";
            BondPostingGroup1.GET(Application."Bond Posting Group");
            GenJnlLine."Bond Posting Group" := BondPostingGroup1."Product Group Code";
            GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
            GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
            GenJnlLine."Introducer Code" := Application."Associate Code";
            GenJnlLine."Unit No." := Application."Unit No.";
            GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
            GenJnlLine."Do Not Show" := TRUE;
            GenJnlLine.INSERT;
            LineNo := LineNo + 10000;
        END;

        //Bond Entry Debit
        GenJnlLine.INIT;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
        GenJnlLine.VALIDATE("Document Date", Application."Document Date");
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        BondPostingGroup1.GET(Application."Bond Posting Group");
        GenJnlLine.VALIDATE("Account No.", BondPostingGroup1."Product Group Code");
        GenJnlLine.VALIDATE("Debit Amount", Application."Investment Amount" + Application."Discount Amount");
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := Application."Posted Doc No.";
        GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
        GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
        GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
        GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
        GenJnlLine."Introducer Code" := Application."Associate Code";
        GenJnlLine."Unit No." := Application."Unit No.";
        GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
        GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
        GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
        GenJnlLine."Do Not Show" := TRUE;
        GenJnlLine.INSERT;
        LineNo := LineNo + 10000;

        //Service Charge
        PaymentMethod.GET(BondSetUp."Service Charge Account");
        GenJnlLine.INIT;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
        GenJnlLine.VALIDATE("Document Date", Application."Document Date");
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Account No.", PaymentMethod."Bal. Account No.");
        GenJnlLine.VALIDATE("Debit Amount", Application."Service Charge Amount");
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := Application."Posted Doc No.";
        BondPostingGroup1.GET(Application."Bond Posting Group");
        GenJnlLine."Bond Posting Group" := BondPostingGroup1."Product Group Code";
        GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
        GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
        GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
        GenJnlLine."Introducer Code" := Application."Associate Code";
        GenJnlLine."Unit No." := Application."Unit No.";
        GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
        GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
        GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
        GenJnlLine."Do Not Show" := TRUE;
        GenJnlLine.INSERT;
    end;


    procedure PostGenJnlLines()
    var
        GLEntry: Record "G/L Entry";
        GenJournalLine2: Record Application temporary;
    begin
        CLEAR(GenJournalLine2);
        GenJnlLine.RESET;
        GenJnlLine.FINDFIRST;
        REPEAT
            IF NOT GenJournalLine2.GET(GenJnlLine."Document No.") THEN BEGIN
                GenJournalLine2.INIT;
                GenJournalLine2."Application No." := GenJnlLine."Document No.";
                GenJournalLine2.INSERT;
                GLEntry.SETCURRENTKEY("Document No.", "BBG Do Not Show");
                GLEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
                GLEntry.SETRANGE("BBG Do Not Show", FALSE);
                GLEntry.MODIFYALL("BBG Do Not Show", TRUE);
            END;
            GenJnlPostLine.RUN(GenJnlLine);
        UNTIL GenJnlLine.NEXT = 0;
        GenJnlLine.DELETEALL;
        CLEAR(GenJnlPostLine);
    end;


    procedure ValidateSetup(var Application: Record Application)
    var
        PaymentPerMonth: Decimal;
        BondSetup: Record "Unit Setup";
    begin
        DiscAmount := 0;
        BondSetup.GET;
        BondSetup.TESTFIELD("Commission A/C");
        BondSetup.TESTFIELD("Bonus A/c");
        BondSetup.TESTFIELD("Interest A/C");
        BondSetup.TESTFIELD(BondSetup."Service Charge Amount");
        BondSetup.TESTFIELD("Discount Allowed on Bond A/C");
    end;


    procedure CreateGenJnlLinesForClChq(var BondPaymentEntry: Record "Unit Payment Entry"; Application: Record Application)
    var
        PaymentMethod: Record "Payment Method";
        BankAccount: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        BondPostingGroup1: Record "ID 2 Group";
        BondPaymentEntry2: Record "Unit Payment Entry";
        RDPmtSchBuff: Record "Template Field";
        RDPaymentScheduleBuffer: Record "Template Field";
    begin
        //CreateGenJnlLinesForClChq
        IF (BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Cheque Status" = BondPaymentEntry."Cheque Status"::Cleared) THEN BEGIN
            PaymentMethod.GET(BondPaymentEntry."Payment Method");
            BankAccount.GET(BondPaymentEntry."Deposit/Paid Bank");
            BankAccountPostingGroup.GET(BankAccount."Bank Acc. Posting Group");
            GenJnlLine.INIT;
            GenJnlLine."Line No." := LineNo;
            IF BondPaymentEntry."Document Type" = BondPaymentEntry."Document Type"::Application THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
                GenJnlLine.VALIDATE("Document Date", Application."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.VALIDATE("Account No.", BondPaymentEntry."Deposit/Paid Bank");
                GenJnlLine.VALIDATE("Credit Amount", BondPaymentEntry.Amount);
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := Application."Posted Doc No.";
                GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                GenJnlLine."Introducer Code" := Application."Associate Code";
                GenJnlLine."Unit No." := Application."Unit No.";
                GenJnlLine."Cheque No." := BondPaymentEntry."Cheque No./ Transaction No.";
                GenJnlLine."Cheque Date" := BondPaymentEntry."Cheque Date";
                GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
                GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                GenJnlLine."Do Not Show" := TRUE;
                GenJnlLine.INSERT;
                LineNo := LineNo + 10000;
            END
            //ZEE
            /*
            ELSE IF "Document Type" = "Document Type"::RD THEN BEGIN
              RDPaymentScheduleBuffer.SETCURRENTKEY("Posted Doc. No.");;
              RDPaymentScheduleBuffer.SETRANGE("Posted Doc. No.",BondPaymentEntry."Document No.");
              RDPaymentScheduleBuffer.FINDFIRST;
              GenJnlLine.VALIDATE("Posting Date",RDPaymentScheduleBuffer."Posting Date");
              GenJnlLine.VALIDATE("Document Date",RDPaymentScheduleBuffer."Document Date");
              GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"Bank Account");
              GenJnlLine.VALIDATE("Account No.","Deposit/Paid Bank");
              GenJnlLine.VALIDATE("Credit Amount",Amount);
              GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
              GenJnlLine."Document No." := BondPaymentEntry."Document No.";
              GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
              GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
              GenJnlLine."Cheque No." := "Cheque No.";
              GenJnlLine."Cheque Date" := "Cheque Date";
              GenJnlLine."Loan Code" := TRUE;
              GenJnlLine.INSERT;
              LineNo := LineNo + 10000;

              //Debit
              RDPaymentScheduleBuffer.SETCURRENTKEY("Posted Doc. No.");;
              RDPaymentScheduleBuffer.SETRANGE("Posted Doc. No.",BondPaymentEntry."Document No.");
              RDPaymentScheduleBuffer.FINDFIRST;

              PaymentMethod.GET("Payment Method");
              GenJnlLine.INIT;
              GenJnlLine."Line No." := LineNo;
              GenJnlLine.VALIDATE("Posting Date",RDPaymentScheduleBuffer."Posting Date");
              GenJnlLine.VALIDATE("Document Date",RDPaymentScheduleBuffer."Document Date");
              GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"G/L Account");
              GenJnlLine.VALIDATE("Account No.",PaymentMethod."Bal. Account No.");
              GenJnlLine.VALIDATE("Debit Amount",Amount);
              GenJnlLine.Description := Description;
              GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
              GenJnlLine."Document No." := BondPaymentEntry."Document No.";
              GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
              GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
              GenJnlLine."Cheque No." := "Cheque No.";
              GenJnlLine."Cheque Date" := "Cheque Date";
              GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
              GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
              GenJnlLine."Loan Code" := TRUE;
              GenJnlLine.INSERT;
              LineNo := LineNo + 10000;
            END;
            */
        END;
        BondPaymentEntry."Cheque Status" := BondPaymentEntry."Cheque Status"::" ";
        BondPaymentEntry.MODIFY;

    end;


    procedure BonusReversal(BondNo: Code[20]; DocumentNo: Code[20])
    var
        BonusEntry: Record "Bonus Entry";
        BonusEntryPosted: Record "Bonus Entry Posted";
        UserSetup: Record "User Setup";
        BonusAmount: Decimal;
        PostPayment: Codeunit PostPayment;
        BondSetUp: Record "Unit Setup";
        BonusPostingBuffer: Record "Bonus Posting Buffer";
    begin
        BondSetUp.GET;
        BonusEntry.SETRANGE("Unit No.", BondNo);
        BonusEntry.DELETEALL;

        BonusEntryPosted.SETCURRENTKEY("Unit No.", "Installment No.");
        BonusEntryPosted.SETRANGE("Unit No.", BondNo);
        IF BonusEntryPosted.FINDSET THEN BEGIN
            REPEAT
                BonusAmount += BonusEntryPosted."Bonus Amount";
                BonusEntryAdjustmentFromPosted(BonusEntryPosted);
            UNTIL BonusEntryPosted.NEXT = 0;
            BonusEntryPosted.DELETEALL;
        END;

        BonusPostingBuffer.SETCURRENTKEY("Unit No.");
        BonusPostingBuffer.SETRANGE("Unit No.", BondNo);
        BonusPostingBuffer.SETRANGE(Status, BonusPostingBuffer.Status::Posted);
        IF BonusPostingBuffer.FINDSET THEN BEGIN
            REPEAT
                BonusAmount += BonusPostingBuffer."Bonus Amount";
                BonusEntryAdjustmentFromBuffer(BonusPostingBuffer);
            UNTIL BonusPostingBuffer.NEXT = 0;
            BonusPostingBuffer.SETRANGE(Status);
            BonusPostingBuffer.DELETEALL;
        END;

        BondSetUp.GET;
        BondSetUp.TESTFIELD("Bonus Reversal A/c");
        BondSetUp.TESTFIELD("Bonus A/c");
        UserSetup.GET(USERID);
        IF BonusAmount > 0 THEN BEGIN
            //Suspense Account
            LineNo += 10000;
            GenJnlLine.INIT;
            GenJnlLine."Line No." := LineNo;
            GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.VALIDATE("Document No.", DocumentNo);
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetUp."Bonus Reversal A/c");
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
            GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", UserSetup."Shortcut Dimension 2 Code");
            GenJnlLine.VALIDATE(Amount, BonusAmount);
            GenJnlLine."Do Not Show" := TRUE;
            GenJnlLine.INSERT;

            //Bonus Account
            LineNo += 10000;
            GenJnlLine.INIT;
            GenJnlLine."Line No." := LineNo;
            GenJnlLine.VALIDATE("Document No.", DocumentNo);
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", GetDescription.GetDocomentDate);
            GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetUp."Bonus A/c");
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
            GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", UserSetup."Shortcut Dimension 2 Code");
            GenJnlLine.VALIDATE("Credit Amount", BonusAmount);
            GenJnlLine."Do Not Show" := TRUE;
            GenJnlLine.INSERT;
        END;
    end;


    procedure BonusEntryAdjustmentFromBuffer(BonusPostingBuffer: Record "Bonus Posting Buffer")
    var
        BonusEntryPostedAdjustment: Record "Bonus Entry Posted Adjustment";
    begin
        BonusEntryPostedAdjustment.INIT;
        BonusEntryPostedAdjustment."Entry No." := BonusPostingBuffer."Entry No.";
        BonusEntryPostedAdjustment."Unit No." := BonusPostingBuffer."Unit No.";
        BonusEntryPostedAdjustment."Associate Code" := BonusPostingBuffer."Associate Code";
        BonusEntryPostedAdjustment."Base Amount" := BonusPostingBuffer."Base Amount";
        BonusEntryPostedAdjustment."Bonus Amount" := BonusPostingBuffer."Bonus Amount";
        BonusEntryPostedAdjustment."Installment No." := BonusPostingBuffer."Installment No.";
        BonusEntryPostedAdjustment."Business Type" := BonusPostingBuffer."Business Type";
        BonusEntryPostedAdjustment."Introducer Code" := BonusPostingBuffer."Introducer Code";
        BonusEntryPostedAdjustment.Duration := BonusPostingBuffer.Duration;
        BonusEntryPostedAdjustment."Paid To" := BonusPostingBuffer."Paid To";
        BonusEntryPostedAdjustment."Posted Doc. No." := BonusPostingBuffer."Posted Doc. No.";
        BonusEntryPostedAdjustment."Shortcut Dimension 1 Code" := BonusPostingBuffer."Shortcut Dimension 1 Code";
        BonusEntryPostedAdjustment."Shortcut Dimension 2 Code" := BonusPostingBuffer."Shortcut Dimension 2 Code";
        BonusEntryPostedAdjustment."Unit Office Code(Paid)" := BonusPostingBuffer."Unit Office Code(Paid)";
        BonusEntryPostedAdjustment."Counter Code(Paid)" := BonusPostingBuffer."Counter Code(Paid)";
        BonusEntryPostedAdjustment."Associate Rank" := BonusPostingBuffer."Associate Rank";
        BonusEntryPostedAdjustment."Pmt Received From Code" := BonusPostingBuffer."Pmt Received From Code";
        BonusEntryPostedAdjustment."Document Date" := BonusPostingBuffer."Document Date";
        BonusEntryPostedAdjustment."G/L Posting Date" := BonusPostingBuffer."G/L Posting Date";
        BonusEntryPostedAdjustment."G/L Document Date" := BonusPostingBuffer."G/L Document Date";
        BonusEntryPostedAdjustment."Token No." := BonusPostingBuffer."Token No.";
        BonusEntryPostedAdjustment.INSERT;
    end;


    procedure BonusEntryAdjustmentFromPosted(BonusEntryPosted: Record "Bonus Entry Posted")
    var
        BonusEntryPostedAdjustment: Record "Bonus Entry Posted Adjustment";
    begin
        BonusEntryPostedAdjustment.INIT;
        BonusEntryPostedAdjustment.TRANSFERFIELDS(BonusEntryPosted);
        BonusEntryPostedAdjustment.INSERT;
    end;
}

