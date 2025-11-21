codeunit 97729 "Unit Reversal"
{
    // 
    // BBG1.2 231213 Added code for Revers TA with Application Wise in new table.
    // BBG2.0 091014 Added new function and code not for reversal.
    // ALLE 030915 New function.(PostTACreditmemo,PostCommCreditMemo,TAInsertJnDimension)
    // 
    // ALLED 081015 This function (CreateProjectChangeEntriesTR) used for create project change entries in Trading
    // ALLEDK 081116 Code added
    // 280417 code added if application no. not find in Payment Entry
    // 
    // 251121 code comment
    // 130122 Code added
    // 160322 New Code in case of project change
    // 
    // (NOT Vend_2."Black List") AND 171022

    Permissions = tabledata "TDS Entry" = RIMD;


    trigger OnRun()
    begin
    end;

    var
        GenJnlLine: Record "Gen. Journal Line" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        Text001: Label 'Order with status %1 cannot be reversed.';
        Text002: Label 'Do you want to reverse the Order %1?';
        UserSetup: Record "User Setup";
        GetDescription: Codeunit GetDescription;
        BondSetup: Record "Unit Setup";
        BondMgmt: Codeunit "Unit Post";
        BondPost: Codeunit "Unit Post";
        Text003: Label 'The cheque the staus must either be cleared or bounced';
        RefundCashAmount: Decimal;
        RefundChequeAmount: Decimal;
        RefundCashAcNo: Code[20];
        RefundBankAcNo: Code[20];
        RefundChequeNo: Code[20];
        RefundChequeDate: Date;
        GLSetup: Record "General Ledger Setup";
        PostPayment: Codeunit PostPayment;
        AdjmtCashAmt: Decimal;
        AdjmtAJVMAmt: Decimal;
        GenJnlLine1: Record "Gen. Journal Line";
        Text004: Label 'TDS can not be Adjusted from here. Do you want to Continue ?';
        AJVMAssociateCode: Code[20];
        PDocNo: Code[20];
        NetADJAmt: Decimal;
        JVAmount: Decimal;
        TransferType: Option " ",Commission,Incentive;
        ProjectCode: Code[20];
        ContraAJVMAmt: Decimal;
        AssociateHierarcywithApp: Record "Associate Hierarcy with App.";
        LDAmount: Decimal;
        TAAppwiseDet: Record "TA Application wise Details";
        TAAppwiseDet1: Record "TA Application wise Details";
        LineNo: Integer;
        ReturnValue1: Boolean;
        NewInsertAppLines: Record "NewApplication Payment Entry";
        UnitReversal: Codeunit "Unit Reversal";
        CommEntry_4: Record "Commission Entry";
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        TravelPaymentEntry_1: Record "Travel Payment Entry";
        AssCode_1: Code[20];
        LineNo_1: Integer;
        TotAppAmt: Decimal;
        AppPaymentEntry: Record "Application Payment Entry";
        CommissionEntry: Record "Commission Entry";
        Text013: Label 'you sure you want to post the entries';
        Text014: Label 'Please check and confirm.\You are going to transfer\Amount            :%1\from Customer :%2 to %3\%4:%5\Posting Date    : %6.';
        Text006: Label 'Are you sure you want to post the entries';
        Text007: Label 'Posting Done';
        Text008: Label 'Do you want to register the Unit %1?';
        Text009: Label 'Registration Done';
        Text010: Label 'Do you want the reverse the Commision';
        Text011: Label 'Cancellation Done';
        Text012: Label 'Do you want to Vacate the Plot %1?';
        ProjChngJVAmt: Decimal;
        ExcessAmount: Decimal;
        AlltAmount: Decimal;
        TotalAmount: Decimal;
        TotalValue: Decimal;
        TotalFixed: Decimal;
        Sno: Code[10];
        PostEntry: Boolean;
        WebAppService: Codeunit "Web App Service";


    procedure BondReverse(BondNo: Code[20]; ReverseComm: Boolean; PenaltyAmount: Decimal; FromBatchJob: Boolean)
    var
        Bond: Record "Confirmed Order";
        RDPaymentScheduleBuffer: Record "Template Field";
        RDPaymentSchedulePosted: Record "Unit Pmt. Ent. Existing(Chq Q)";
        BondLedgerEntry: Record "Unit Ledger Entry";
        RDPaymentSchedule: Record Terms;
        MISPaymentSchedule: Record "MIS Payment Schedule";
        CommissionEntry: Record "Commission Entry";
        ApplicationReverse: Codeunit "Application Reverse";
        BondReversalEntries: Record "Unit Reversal Entries";
        LineNo: Integer;
        MISPaymentScheduleBuffer: Record "Project Budget Line Buffer";
        MISPaymentSchedulePosted: Record "FD Payment Schedule Posted";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UnitMaster: Record "Unit Master";
        AppPayEntry: Record "Application Payment Entry";
        UnitPayEntry: Record "Unit Payment Entry";
        AppPayEntry2: Record "Application Payment Entry";
        TDSP: Decimal;
        CommUnitBuffer: Record "Unit & Comm. Creation Buffer";
    begin
        UserSetup.GET(USERID);
        Bond.GET(BondNo);
        IF (Bond.Status = Bond.Status::Registered) OR (Bond.Status = Bond.Status::Cancelled) THEN
            ERROR('Bond status must not be %1..%2', Bond.Status, Bond."No.");
        CheckPaymentStatus(Bond);
        Bond."Commission Reversed" := ReverseComm;
        IF PenaltyAmount = 0 THEN BEGIN
            CLEAR(AppPayEntry);
            AppPayEntry.RESET;
            AppPayEntry.SETRANGE("Document Type", AppPayEntry."Document Type"::BOND);
            AppPayEntry.SETRANGE("Document No.", Bond."No.");
            AppPayEntry.SETRANGE("Explode BOM", FALSE);
            AppPayEntry.SETRANGE(Posted, FALSE);
            IF AppPayEntry.FINDSET THEN
                REPEAT
                    IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Cash" THEN BEGIN
                        RefundCashAmount := ABS(AppPayEntry.Amount);
                        RefundCashAcNo := GetCashAccountNo(AppPayEntry."User Branch Code");
                    END ELSE
                        IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Bank" THEN BEGIN
                            RefundChequeAmount := ABS(AppPayEntry.Amount) + ABS(AppPayEntry."LD Amount");
                            LDAmount := ABS(AppPayEntry."LD Amount");

                            RefundBankAcNo := AppPayEntry."Deposit/Paid Bank";
                            RefundChequeNo := AppPayEntry."Cheque No./ Transaction No.";
                            RefundChequeDate := AppPayEntry."Cheque Date";
                        END;
                    IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Negative Adjmt." THEN BEGIN
                        AppPayEntry.TESTFIELD("Adjmt. Line No.");
                        CLEAR(AppPayEntry2);
                        AppPayEntry2.GET(AppPayEntry."Document Type", AppPayEntry."Document No.", AppPayEntry."Adjmt. Line No.");
                        IF AppPayEntry2."Payment Mode" = AppPayEntry2."Payment Mode"::Cash THEN BEGIN
                            AdjmtCashAmt := ABS(AppPayEntry.Amount);
                            RefundCashAcNo := GetCashAccountNo(AppPayEntry."User Branch Code");
                        END;
                        IF AppPayEntry2."Payment Mode" = AppPayEntry2."Payment Mode"::AJVM THEN BEGIN
                            CLEAR(TransferType);  //ALLETDK290313
                            AppPayEntry2.CALCFIELDS("AJVM Associate Code");
                            AJVMAssociateCode := AppPayEntry2."AJVM Associate Code";
                            IF CONFIRM(Text004, FALSE) THEN BEGIN
                                BondSetup.GET;
                                TDSP := PostPayment.CalculateTDSPercentage(AJVMAssociateCode, BondSetup."TDS Nature of Deduction", '');
                                CLEAR(ContraAJVMAmt);
                                ContraAJVMAmt := ABS(AppPayEntry.Amount);
                                AdjmtAJVMAmt := ABS(AppPayEntry."Associate Transfer Amount") - (ABS(AppPayEntry."Associate Transfer Amount") * TDSP / 100
                   );
                                TransferType := AppPayEntry2."AJVM Transfer Type";      //ALLETDK290313
                                NetADJAmt := AdjmtAJVMAmt;
                            END ELSE
                                EXIT;
                        END;
                    END;
                    CLEAR(ProjectCode);
                    IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::JV THEN BEGIN
                        JVAmount := ABS(AppPayEntry.Amount);
                        ProjectCode := AppPayEntry."Shortcut Dimension 1 Code";
                        CommUnitBuffer.RESET;
                        CommUnitBuffer.SETRANGE("Unit No.", AppPayEntry."Document No.");
                        IF CommUnitBuffer.FINDSET THEN
                            CommUnitBuffer.DELETEALL;
                    END;
                    PostPayment.InsertRefundUnitPaymentLines(Bond."No.", AppPayEntry); //ALLETDK210213
                UNTIL AppPayEntry.NEXT = 0;

            IF RefundCashAmount + RefundChequeAmount <> 0 THEN BEGIN //ALLETDK061212
                BondSetup.GET;
                BondSetup.TESTFIELD("Refund No. Series");
                Bond."Penalty Document No." := NoSeriesMgt.GetNextNo(BondSetup."Refund No. Series", WORKDATE, TRUE); //ALLEDK 260113
            END;
            IF AdjmtCashAmt + AdjmtAJVMAmt <> 0 THEN BEGIN //ALLETDK061212
                BondSetup.GET;
                BondSetup.TESTFIELD("Adjustment Entry No. Series");
                Bond."Penalty Document No." := NoSeriesMgt.GetNextNo(BondSetup."Adjustment Entry No. Series", WORKDATE, TRUE); //ALLEDK 260113
            END;
            IF JVAmount <> 0 THEN BEGIN //ALLETDK061212
                BondSetup.GET;
                BondSetup.TESTFIELD("Cheque Bounce JV No. Series");
                BondSetup.TESTFIELD("Project Change JV Account");
                Bond."Penalty Document No." := NoSeriesMgt.GetNextNo(BondSetup."Cheque Bounce JV No. Series", WORKDATE, TRUE); //ALLEDK 260113
                ReverseComm := TRUE;
            END;
            IF FromBatchJob THEN
                InterPostBondReversal(Bond, ReverseComm, PenaltyAmount, AppPayEntry."Posting date")
            ELSE
                IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Bank") OR
            (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Cash") THEN
                    PostBondReversal(Bond, ReverseComm, PenaltyAmount, AppPayEntry."Posting date", AppPayEntry."Commission Reversed",
                                        AppPayEntry."Receipt Line No.")
                ELSE
                    PostBondReversal(Bond, ReverseComm, PenaltyAmount, AppPayEntry."Posting date", FALSE, AppPayEntry."Receipt Line No.");

            CLEAR(AppPayEntry);
            AppPayEntry.RESET;
            AppPayEntry.SETRANGE("Document Type", AppPayEntry."Document Type"::BOND);
            AppPayEntry.SETRANGE("Document No.", Bond."No.");
            AppPayEntry.SETRANGE("Explode BOM", FALSE);
            AppPayEntry.SETRANGE(Posted, FALSE);
            IF AppPayEntry.FINDSET THEN
                REPEAT
                    AppPayEntry."Posted Document No." := Bond."Penalty Document No.";
                    AppPayEntry."Explode BOM" := TRUE;
                    AppPayEntry.Posted := TRUE;
                    AppPayEntry.MODIFY;
                    CLEAR(UnitPayEntry);
                    UnitPayEntry.RESET;
                    UnitPayEntry.SETRANGE("Document No.", AppPayEntry."Document No.");
                    UnitPayEntry.SETRANGE("App. Pay. Entry Line No.", AppPayEntry."Line No.");
                    IF UnitPayEntry.FINDSET THEN
                        REPEAT
                            UnitPayEntry."Posted Document No." := AppPayEntry."Posted Document No.";
                            UnitPayEntry."Explode BOM" := TRUE;
                            UnitPayEntry.Posted := TRUE;
                            UnitPayEntry.MODIFY;
                        UNTIL UnitPayEntry.NEXT = 0;
                UNTIL AppPayEntry.NEXT = 0;
        END;
        //Bond Reversal entries
        CLEAR(BondReversalEntries);
        BondReversalEntries.SETRANGE("Document Type", BondReversalEntries."Document Type"::BOND);
        BondReversalEntries.SETRANGE("Document No.", Bond."Posted Doc No.");
        IF BondReversalEntries.FINDLAST THEN
            LineNo := BondReversalEntries."Line No." + 10000
        ELSE
            LineNo := 10000;

        BondReversalEntries.INIT;
        BondReversalEntries."Document Type" := BondReversalEntries."Document Type"::BOND;
        BondReversalEntries."Document No." := Bond."Penalty Document No.";
        BondReversalEntries."Line No." := LineNo;
        BondReversalEntries."Application No." := Bond."Application No.";
        BondReversalEntries."Unit No." := Bond."No.";
        BondReversalEntries."Posted. Doc. No." := Bond."Penalty Document No.";
        BondReversalEntries."Posting date" := Bond."Posting Date";
        BondReversalEntries."Document Date" := Bond."Document Date";
        BondReversalEntries."User ID" := UserSetup."User ID";
        BondReversalEntries."Reverse Date" := GetDescription.GetDocomentDate;
        BondReversalEntries."Reverse Time" := TIME;
        BondReversalEntries.INSERT;


        IF AdjmtAJVMAmt <> 0 THEN
            MESSAGE('Associate to Member Adjustment Entry has been posted. Please Adjust the TDS Amount using TDS Adjustment Journal');
    end;


    procedure PostGenJnlLines()
    begin
        CLEAR(GenJnlPostLine);
        CLEAR(GenJnlPostBatch);
        GenJnlLine.RESET;
        GenJnlLine.FINDFIRST;
        REPEAT
            //GenJnlPostLine.SetDocumentNo(GenJnlLine."Document No.");
            //  GenJnlPostLine.RUN(GenJnlLine);
            GenJnlPostLine.RunWithCheck(GenJnlLine);  //ALLEDK 090213
        UNTIL GenJnlLine.NEXT = 0;
        ///GenJnlPostBatch.DeleteGenJournalNarration(GenJnlLine);
        GenJnlLine.DELETEALL;
        //JournalLineDimension.DELETEALL; // ALLE MM
    end;


    procedure InitVoucherNarration(JnlTemplate: Code[10]; JnlBatch: Code[10]; DocumentNo: Code[20]; GenJnlLineNo: Integer; NarrationLineNo: Integer; LineNarrationText: Text[50])
    var
        GenJnlNarration: Record "Gen. Journal Narration";// "16549";
        LineNo: Integer;
        PayToName: Text[50];
        Cust: Record Customer;
        Vend: Record Vendor;
    begin
        GenJnlNarration.INIT;
        GenJnlNarration."Journal Template Name" := JnlTemplate;
        GenJnlNarration."Journal Batch Name" := JnlBatch;
        GenJnlNarration."Document No." := DocumentNo;
        GenJnlNarration."Gen. Journal Line No." := GenJnlLineNo;
        GenJnlNarration."Line No." := NarrationLineNo;
        GenJnlNarration.Narration := LineNarrationText;
        GenJnlNarration.INSERT;
    end;


    procedure PostBondReversal(Bond: Record "Confirmed Order"; ReverseComm: Boolean; PenaltyAmount: Decimal; RefPostDate: Date; RefundCheuqEntry: Boolean; ReceptLineNo_1: Integer)
    var
        Application: Record Application;
        BondPaymentEntry: Record "Unit Payment Entry";
        PostedDocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NarrationText1: Text[250];
        BondPostingGroup1: Record "Customer Posting Group";
        ApplicationPaymentEntry_1: Record "Application Payment Entry";
    begin
        BondSetup.GET;
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;
        IF (RefundCashAmount <> 0) AND (RefundChequeAmount <> 0) THEN BEGIN
            NarrationText1 := 'Refund Amount for Order- ' + COPYSTR(Bond."Application No.", 1, 30);
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            GenJnlLine.VALIDATE("Posting Date", RefPostDate);
            GenJnlLine.VALIDATE("Document Date", RefPostDate);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", Bond."Customer No.");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund; //ALLETDK061212
            GenJnlLine."Document No." := Bond."Penalty Document No.";
            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine."Order Ref No." := Bond."No.";
            GenJnlLine.VALIDATE(Amount, RefundCashAmount + RefundChequeAmount);
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
            BondPostingGroup1.GET(Bond."Bond Posting Group");
            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Order Ref No." := Bond."Application No.";
            GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            //  GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Receipt Line No." := ReceptLineNo_1;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine.Description := 'Refund Amount';
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 20000;
            GenJnlLine.VALIDATE("Posting Date", RefPostDate);
            GenJnlLine.VALIDATE("Document Date", RefPostDate);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", RefundCashAcNo);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund; //ALLETDK061212
            GenJnlLine."Document No." := Bond."Penalty Document No.";
            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Refund Cash";
            GenJnlLine."Order Ref No." := Bond."No.";
            GenJnlLine.VALIDATE(Amount, -RefundCashAmount);
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
            BondPostingGroup1.GET(Bond."Bond Posting Group");
            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Order Ref No." := Bond."Application No.";
            GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Receipt Line No." := ReceptLineNo_1;
            GenJnlLine.Description := 'Refund Amount';
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 30000;
            GenJnlLine.VALIDATE("Posting Date", RefPostDate);
            GenJnlLine.VALIDATE("Document Date", RefPostDate);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
            GenJnlLine.VALIDATE("Account No.", RefundBankAcNo);
            GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Refund Bank";
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund; //ALLETDK061212
            GenJnlLine."Document No." := Bond."Penalty Document No.";
            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine."Order Ref No." := Bond."No.";
            GenJnlLine.VALIDATE(Amount, -RefundChequeAmount);
            BondPostingGroup1.GET(Bond."Bond Posting Group");
            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Order Ref No." := Bond."Application No.";
            GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."Cheque No." := CopyStr(RefundChequeNo, 1, 10);//ALLE-AM
            GenJnlLine."BBG Cheque No." := RefundChequeNo;//ALLE-AM
            GenJnlLine."Cheque Date" := RefundChequeDate;
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Receipt Line No." := ReceptLineNo_1;
            GenJnlLine.Description := 'Refund Amount';
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);

            InsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines;
        END;

        IF (RefundCashAmount <> 0) AND (RefundChequeAmount = 0) THEN BEGIN
            NarrationText1 := 'Refund Amount for Order- ' + COPYSTR(Bond."Application No.", 1, 30);
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            GenJnlLine.VALIDATE("Posting Date", RefPostDate);
            GenJnlLine.VALIDATE("Document Date", RefPostDate);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", Bond."Customer No.");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund; //ALLETDK061212
            GenJnlLine."Document No." := Bond."Penalty Document No.";
            //GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine."Order Ref No." := Bond."No.";
            GenJnlLine.VALIDATE(Amount, RefundCashAmount);
            GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Refund Cash";
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
            BondPostingGroup1.GET(Bond."Bond Posting Group");
            GenJnlLine.VALIDATE("Bal. Account No.", RefundCashAcNo);
            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Order Ref No." := Bond."Application No.";
            GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            //GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine.Description := 'Refund Amount';
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            InsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines;
        END;

        IF (RefundCashAmount = 0) AND (RefundChequeAmount <> 0) THEN BEGIN

            NarrationText1 := 'Refund Amount for Order- ' + COPYSTR(Bond."Application No.", 1, 30);
            IF LDAmount = 0 THEN BEGIN
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := 10000;
                GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Refund);
                GenJnlLine.VALIDATE("Posting Date", RefPostDate);
                GenJnlLine.VALIDATE("Document Date", RefPostDate);
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.VALIDATE("Account No.", Bond."Customer No.");
                GenJnlLine."Document No." := Bond."Penalty Document No.";
                //GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
                GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                GenJnlLine."Order Ref No." := Bond."No.";
                GenJnlLine.VALIDATE(Amount, RefundChequeAmount);
                GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
                GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                BondPostingGroup1.GET(Bond."Bond Posting Group");
                GenJnlLine.VALIDATE("Bal. Account No.", RefundBankAcNo);
                GenJnlLine."Posting Group" := Bond."Bond Posting Group";
                GenJnlLine."Order Ref No." := Bond."Application No.";
                GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Refund Bank";
                // GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";
                GenJnlLine."Cheque No." := CopyStr(RefundChequeNo, 1, 10);//ALLE-AM
                GenJnlLine."BBG Cheque No." := RefundChequeNo;//ALLE-AM
                GenJnlLine."Cheque Date" := RefundChequeDate;
                GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Bond."Shortcut Dimension 1 Code");
                GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                //GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Introducer Code" := Bond."Introducer Code";
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Unit No." := Bond."No.";
                GenJnlLine."Receipt Line No." := ReceptLineNo_1;
                GenJnlLine.Description := 'Refund Amount';
                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine); //310113
                PostGenJnlLines;
            END ELSE BEGIN

                NarrationText1 := 'Refund Amount for Order- ' + COPYSTR(Bond."Application No.", 1, 30);
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := 10000;
                GenJnlLine.VALIDATE("Posting Date", RefPostDate);
                GenJnlLine.VALIDATE("Document Date", RefPostDate);
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.VALIDATE("Account No.", Bond."Customer No.");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                GenJnlLine."Document No." := Bond."Penalty Document No.";
                GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                GenJnlLine."Order Ref No." := Bond."No.";
                GenJnlLine.VALIDATE(Amount, (RefundChequeAmount - LDAmount));
                BondPostingGroup1.GET(Bond."Bond Posting Group");
                GenJnlLine."Posting Group" := Bond."Bond Posting Group";
                GenJnlLine."Order Ref No." := Bond."Application No.";
                GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Refund Bank";
                GenJnlLine."Cheque No." := CopyStr(RefundChequeNo, 1, 10);//ALLE-AM
                GenJnlLine."BBG Cheque No." := RefundChequeNo;//ALLE-AM
                GenJnlLine."Cheque Date" := RefundChequeDate;
                GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                //GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Introducer Code" := Bond."Introducer Code";
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Unit No." := Bond."No.";
                GenJnlLine.Description := 'Refund Amount';
                GenJnlLine."Receipt Line No." := ReceptLineNo_1;
                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                //InsertJnDimension(GenJnlLine); //310113

                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := 20000;
                GenJnlLine.VALIDATE("Posting Date", RefPostDate);
                GenJnlLine.VALIDATE("Document Date", RefPostDate);
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                BondSetup.GET;
                GenJnlLine.VALIDATE("Account No.", BondSetup."LD Account");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                GenJnlLine."Document No." := Bond."Penalty Document No.";
                //GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
                GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                GenJnlLine."Order Ref No." := Bond."No.";
                GenJnlLine.VALIDATE(Amount, LDAmount);
                BondPostingGroup1.GET(Bond."Bond Posting Group");
                GenJnlLine."Posting Group" := Bond."Bond Posting Group";
                GenJnlLine."Order Ref No." := Bond."Application No.";
                GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Refund Bank";
                GenJnlLine."Cheque No." := CopyStr(RefundChequeNo, 1, 10);//ALLE-AM
                GenJnlLine."BBG Cheque No." := RefundChequeNo;//ALLE-AM
                GenJnlLine."Cheque Date" := RefundChequeDate;
                GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                //GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Introducer Code" := Bond."Introducer Code";
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Unit No." := Bond."No.";
                GenJnlLine.Description := 'LD Amount';
                GenJnlLine."Receipt Line No." := ReceptLineNo_1;
                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                //InsertJnDimension(GenJnlLine); //310113

                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := 30000;
                GenJnlLine.VALIDATE("Posting Date", RefPostDate);
                GenJnlLine.VALIDATE("Document Date", RefPostDate);
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                GenJnlLine.VALIDATE("Account No.", RefundBankAcNo);
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                GenJnlLine."Document No." := Bond."Penalty Document No.";
                GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
                GenJnlLine."Order Ref No." := Bond."No.";
                GenJnlLine.VALIDATE(Amount, -(RefundChequeAmount));
                BondPostingGroup1.GET(Bond."Bond Posting Group");
                GenJnlLine."Posting Group" := Bond."Bond Posting Group";
                GenJnlLine."Order Ref No." := Bond."Application No.";
                GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Refund Bank";
                GenJnlLine."Cheque No." := CopyStr(RefundChequeNo, 1, 10);//ALLE-AM
                GenJnlLine."BBG Cheque No." := RefundChequeNo;//ALLE-AM
                GenJnlLine."Cheque Date" := RefundChequeDate;
                GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                //GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Introducer Code" := Bond."Introducer Code";
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Unit No." := Bond."No.";
                GenJnlLine."Receipt Line No." := ReceptLineNo_1;
                GenJnlLine.Description := 'Refund Amount';
                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine); //310113
                PostGenJnlLines;
            END;
        END;



        IF PenaltyAmount <> 0 THEN BEGIN
            NarrationText1 := 'Penalty Amount for Order- ' + COPYSTR(Bond."Application No.", 1, 30);
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            GenJnlLine.VALIDATE("Posting Date", RefPostDate);
            GenJnlLine.VALIDATE("Document Date", RefPostDate);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."Bond Reversal Control A/c");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Reminder;
            GenJnlLine."Document No." := Bond."Penalty Document No.";
            GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine."Order Ref No." := Bond."No.";
            GenJnlLine.VALIDATE(Amount, -PenaltyAmount);
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::Customer);
            BondPostingGroup1.GET(Bond."Bond Posting Group");
            GenJnlLine.VALIDATE("Bal. Account No.", Bond."Customer No.");
            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Order Ref No." := Bond."Application No.";
            GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine.Description := 'Penalty Amount';
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            InsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines;
        END;

        IF (AdjmtCashAmt <> 0) THEN BEGIN
            NarrationText1 := 'Adjustment Amount for Order- ' + COPYSTR(Bond."Application No.", 1, 30);
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            GenJnlLine.VALIDATE("Posting Date", RefPostDate);
            GenJnlLine.VALIDATE("Document Date", RefPostDate);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", Bond."Customer No.");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "; //ALLETDK061212
            GenJnlLine."Document No." := Bond."Penalty Document No.";
            //GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine."Order Ref No." := Bond."No.";
            GenJnlLine.VALIDATE(Amount, AdjmtCashAmt);
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
            BondPostingGroup1.GET(Bond."Bond Posting Group");
            GenJnlLine.VALIDATE("Bal. Account No.", RefundCashAcNo);
            GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Negative Adjmt.";
            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Order Ref No." := Bond."Application No.";
            GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine.Description := 'Adjustment Amount';
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            InsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines;
        END;

        IF (AdjmtAJVMAmt <> 0) THEN BEGIN
            PDocNo := '';
            GenJnlLine1.INIT;
            GenJnlLine1."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine1."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine1."Line No." := 10000;
            //GenJnlLine1."Document Type" := GenJnlLine1."Document Type"::Payment;
            GenJnlLine1.VALIDATE("Posting Date", WORKDATE); //ALLETDK
            GenJnlLine1.VALIDATE("Party Type", GenJnlLine1."Party Type"::Vendor);
            GenJnlLine1.VALIDATE("Party Code", AJVMAssociateCode);
            //ALLETDK290313 >>>
            IF TransferType = TransferType::Commission THEN
                GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Commission
            ELSE
                GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Incentive;
            //ALLETDK290313 <<<
            GenJnlLine1.VALIDATE("Bal. Account Type", GenJnlLine1."Bal. Account Type"::"G/L Account");
            GenJnlLine1.VALIDATE("Bal. Account No.", BondSetup."Transfer Control Account");
            GenJnlLine1."Payment Mode" := GenJnlLine1."Payment Mode"::"Negative Adjmt.";
            GenJnlLine1.VALIDATE(Amount, -NetADJAmt);

            GenJnlLine1."Document No." := Bond."Penalty Document No.";
            PDocNo := Bond."Penalty Document No.";
            GenJnlLine1."Order Ref No." := Bond."No.";
            GenJnlLine1."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine1."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine1."System-Created Entry" := TRUE;
            GenJnlLine1."Introducer Code" := Bond."AJVM Associate Code";  //ALLEDK 270113
            GenJnlLine1."Unit No." := Bond."Unit Code";
            GenJnlLine1."Installment No." := 1;
            GenJnlLine1.INSERT;
            //IF TransferType=TransferType::Commission THEN //ALLETDK290313
            PostPayment.CheckVendorChequeAmount(GenJnlLine1);  //240113

            GenJnlLine1.INIT;
            GenJnlLine1."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine1."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine1."Line No." := 20000;
            //GenJnlLine1."Document Type" := GenJnlLine1."Document Type"::Payment;
            GenJnlLine1.VALIDATE("Posting Date", RefPostDate); //ALLETDK
            GenJnlLine1.VALIDATE("Account Type", GenJnlLine1."Account Type"::"G/L Account");
            GenJnlLine1.VALIDATE("Account No.", BondSetup."Transfer Control Account");
            IF TransferType = TransferType::Commission THEN
                GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Commission
            ELSE
                GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type"::Incentive;
            GenJnlLine1.VALIDATE("Bal. Account Type", GenJnlLine1."Bal. Account Type"::Customer);
            GenJnlLine1.VALIDATE("Bal. Account No.", Bond."Customer No.");
            GenJnlLine1.VALIDATE(Amount, -ContraAJVMAmt);

            GenJnlLine1."Document No." := Bond."Penalty Document No.";
            GenJnlLine1."Order Ref No." := Bond."No.";
            GenJnlLine1."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine1."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine1."Introducer Code" := Bond."AJVM Associate Code";  //ALLEDK 270113
            GenJnlLine1."Unit No." := Bond."Unit Code";
            GenJnlLine1."Installment No." := 1;
            GenJnlLine1.INSERT;

            InsertJnDimension(GenJnlLine1); //ALLEDK 310113
            InitVoucherNarration(GenJnlLine1."Journal Template Name", GenJnlLine1."Journal Batch Name", GenJnlLine1."Document No.",
             GenJnlLine1."Line No.", GenJnlLine1."Line No.", 'Associate to Member Transfer Adjustment');
            PostGenJnlLines1;
            //  Line := Line + 10000;
        END;

        IF (JVAmount <> 0) THEN BEGIN
            NarrationText1 := 'Project Change JV Amount for Order- ' + COPYSTR(Bond."Application No.", 1, 30);
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", WORKDATE);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", Bond."Customer No.");
            GenJnlLine."Document No." := Bond."Penalty Document No.";
            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine."Order Ref No." := Bond."No.";
            GenJnlLine.VALIDATE(Amount, JVAmount);
            GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::JV;
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
            BondPostingGroup1.GET(Bond."Bond Posting Group");
            GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Project Change JV Account");
            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Order Ref No." := Bond."Application No.";
            GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            ApplicationPaymentEntry_1.RESET;
            ApplicationPaymentEntry_1.SETRANGE("Document No.", Bond."No.");
            IF ApplicationPaymentEntry_1.FINDLAST THEN;
            GenJnlLine."Shortcut Dimension 1 Code" := ApplicationPaymentEntry_1."Shortcut Dimension 1 Code";
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ApplicationPaymentEntry_1."Shortcut Dimension 1 Code");
            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine.Description := 'Project Change JV';
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            InsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines;
        END;

        IF RefundCheuqEntry THEN BEGIN
            IF ReverseComm THEN
                CommisionReverse(Bond."No.", TRUE);
            RefundCommisionGenerate(Bond."No.", RefPostDate);
            CreateCommCreditMemo(Bond."No.", TRUE);
            //CreateTACreditMemo(Bond."Introducer Code",0);
        END ELSE BEGIN
            IF ReverseComm THEN
                CommisionReverse(Bond."No.", FALSE);
        END;
    end;


    procedure CreateGenJnlLinesBond(Application: Record "Confirmed Order"; Description: Text[50])
    var
        BondPaymentEntry: Record "Unit Payment Entry";
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[50];
        NarrationText2: Text[50];
        Application1: Record Application;
        Vend: Record Vendor;
    begin
        IF Vend.GET(Application."Introducer Code") THEN;
        BondSetup.GET;
        BondSetup.TESTFIELD("Bond Reversal Control A/c");
        GenJnlLine.DELETEALL;
        Line := 10000;
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
        BondPaymentEntry.SETRANGE("Document No.", Application."No.");
        BondPaymentEntry.SETRANGE(Posted, TRUE);
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                //BondPaymentEntry.GetAmounts(TotalAmount,RecievedAmt);
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::Cash)) THEN BEGIN
                    PaymentMethod.GET(BondPaymentEntry."Payment Method");
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
                    GenJnlLine.VALIDATE("Document Date", Application."Document Date");
                    IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"G/L Account" THEN
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account")
                    ELSE
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Account No.", BondSetup."Bond Reversal Control A/c");
                    GenJnlLine.VALIDATE(Amount, -BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Reminder;
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                    IF BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::Cash THEN BEGIN
                        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::"Bank Account");
                        GenJnlLine.VALIDATE("Source No.", BondPaymentEntry."Deposit/Paid Bank");
                    END ELSE BEGIN
                        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
                        GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
                        //        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type" ::Sale;
                    END;
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::Customer);
                    BondPostingGroup1.GET(Application."Bond Posting Group");
                    GenJnlLine.VALIDATE("Bal. Account No.", Application."Customer No.");
                    GenJnlLine."Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Order Ref No." := Application."Application No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Unit No." := Application."No.";
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
                                GenJnlLine.Description := 'D.D. Received';
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";

                    GenJnlLine.INSERT;
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);

                END;
                IF ((BondPaymentEntry.Amount > 0) AND (BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Cash)) THEN BEGIN
                    CashPmtMethod.GET(BondPaymentEntry."Payment Method");
                    CashAmount += BondPaymentEntry.Amount;

                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := Line;
                    GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
                    GenJnlLine.VALIDATE("Document Date", Application."Document Date");
                    CASE CashPmtMethod."Bal. Account Type" OF
                        CashPmtMethod."Bal. Account Type"::"G/L Account":
                            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                        CashPmtMethod."Bal. Account Type"::"Bank Account":
                            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"Bank Account");
                    END;
                    GenJnlLine.VALIDATE("Account No.", BondSetup."Bond Reversal Control A/c");
                    GenJnlLine.VALIDATE(Amount, -BondPaymentEntry.Amount);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                    GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
                    ;
                    GenJnlLine."Bond Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Bill-to/Pay-to No." := Application."Customer No.";
                    GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
                    GenJnlLine.VALIDATE("Source No.", Application."Customer No.");
                    //  GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type" ::Sale;
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::Customer);
                    BondPostingGroup1.GET(Application."Bond Posting Group");
                    GenJnlLine.VALIDATE("Bal. Account No.", Application."Customer No.");
                    GenJnlLine."Posting Group" := Application."Bond Posting Group";
                    GenJnlLine."Order Ref No." := Application."Application No.";
                    GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;

                    GenJnlLine."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                    GenJnlLine."Introducer Code" := Application."Introducer Code";
                    GenJnlLine."Unit No." := Application."No.";
                    GenJnlLine."Installment No." := 1;
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine.Description := 'Cash Received';
                    GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
                    GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
                    GenJnlLine.INSERT;
                    InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                      GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                END;
                Line := Line + 10000;
                Application.CALCFIELDS(Application."Amount Received");
                Application1.INIT;
                Application1."Application No." := 'COMM';
                Application1."Unit No." := Application."No.";
                Application1."Posting Date" := WORKDATE;
                Application1."Associate Code" := Application."Introducer Code";
                Application1."Investment Amount" := BondPaymentEntry.Amount;
                Application1."Project Type" := Application."Project Type";
                Application1."Investment Type" := Application1."Investment Type"::FD;
                Application1."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                IF BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::Cash THEN
                    Application."With Cheque" := TRUE;

            UNTIL BondPaymentEntry.NEXT = 0;

        Line += 10000;
        //Discount Debit
        IF Application."Discount Amount" > 0 THEN BEGIN
            PaymentMethod.GET(BondSetup."Discount Allowed on Bond A/C");
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := Line;
            GenJnlLine.VALIDATE("Posting Date", Application."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Application."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", PaymentMethod."Bal. Account No.");
            GenJnlLine.VALIDATE(Amount, Application."Discount Amount");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := BondPaymentEntry."Posted Document No.";
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

            GenJnlLine."Introducer Code" := Application."Introducer Code";
            GenJnlLine."Unit No." := Application."No.";
            GenJnlLine."Installment No." := BondPaymentEntry."Installment No.";
            GenJnlLine."Paid To/Received From" := GenJnlLine."Paid To/Received From"::"Marketing Member";
            GenJnlLine."Paid To/Received From Code" := Application."Received From Code";
            GenJnlLine.INSERT;
            Line := Line + 10000;
        END;

        PostGenJnlLines;
    end;


    procedure CreateStagingTableAppBond(Application: Record Application; InstallmentNo: Integer; YearCode: Integer; MilestoneCode: Code[10])
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
    begin
        InitialStagingTab.INIT;
        InitialStagingTab."Unit No." := Application."Unit No.";
        InitialStagingTab."Installment No." := InstallmentNo;
        InitialStagingTab."Posting Date" := Application."Posting Date";
        InitialStagingTab.VALIDATE("Introducer Code", Application."Associate Code");
        //InitialStagingTab."Base Amount" := Application."Investment Amount" + Application."Discount Amount";
        InitialStagingTab."Base Amount" := -Application."Investment Amount";
        // Application."Investment Amount";
        InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
        InitialStagingTab.Duration := Application.Duration;
        InitialStagingTab."Year Code" := YearCode;
        InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
        InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
        InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
        InitialStagingTab."Application No." := Application."Application No.";
        InitialStagingTab."Paid by cheque" := Application."With Cheque";
        InitialStagingTab."Milestone Code" := MilestoneCode;
        InitialStagingTab."Bond Created" := TRUE;
        //InitialStagingTab."Bond Created" := Bond.GET(InitialStagingTab."Unit No.");
        InitialStagingTab.INSERT;
    end;


    procedure CommisionReverse(BondNo: Code[20]; FromRefunCheq: Boolean)
    var
        CommissionEntry: Record "Commission Entry";
        CommissionEntry2: Record "Commission Entry";
        LastentryNo: Integer;
        CommEntry: Record "Commission Entry";
    begin
        CommissionEntry2.RESET;
        IF CommissionEntry2.FINDLAST THEN
            LastentryNo := CommissionEntry2."Entry No."
        ELSE
            LastentryNo := +1;

        CommissionEntry.RESET;
        CommissionEntry.SETRANGE(CommissionEntry."Application No.", BondNo);
        CommissionEntry.SETRANGE(Reversal, FALSE);
        //CommissionEntry.SETRANGE(Posted,FALSE); //ALLETDK170213
        IF CommissionEntry.FINDSET THEN
            REPEAT
                CommissionEntry2.COPY(CommissionEntry);
                CommissionEntry2."Entry No." := LastentryNo + 1;
                CommissionEntry2."Base Amount" := -CommissionEntry."Base Amount";
                CommissionEntry2."Commission Amount" := -CommissionEntry2."Commission Amount";
                CommissionEntry2."Posting Date" := WORKDATE; //ALLETDK040513
                CommissionEntry2."Remaining Amount" := 0; //ALLETDK040513
                CommissionEntry2."Voucher No." := '';
                CommissionEntry2."Voucher Posting Date" := 0D;
                CommissionEntry2."Invoice Date" := 0D;
                CommissionEntry2."Invoice Post Date" := 0D;
                CommissionEntry2."Opening Entries" := FALSE;
                CommissionEntry2.Reversal := TRUE;
                CommissionEntry2.Posted := FALSE;
                IF FromRefunCheq THEN
                    CommissionEntry2."Commission Revs. by RefundCheq" := TRUE;
                LastentryNo := LastentryNo + 1;
                CommissionEntry2.INSERT;
                //ALLETDK170213
                CommEntry.GET(CommissionEntry."Entry No.");
                CommEntry.Reversal := TRUE;
                CommEntry.MODIFY;
            //ALLETDK170213
            UNTIL CommissionEntry.NEXT = 0;
    end;


    procedure ApplicationReverse(BondNo: Code[20])
    var
        Application: Record Application;
        RDPaymentScheduleBuffer: Record "Template Field";
        RDPaymentSchedulePosted: Record "Unit Pmt. Ent. Existing(Chq Q)";
        BondLedgerEntry: Record "Unit Ledger Entry";
        RDPaymentSchedule: Record Terms;
        MISPaymentSchedule: Record "MIS Payment Schedule";
        CommissionEntry: Record "Commission Entry";
        ApplicationReverse: Codeunit "Application Reverse";
        BondReversalEntries: Record "Unit Reversal Entries";
        LineNo: Integer;
        MISPaymentScheduleBuffer: Record "Project Budget Line Buffer";
        MISPaymentSchedulePosted: Record "FD Payment Schedule Posted";
    begin
        UserSetup.GET(USERID);
        Application.GET(BondNo);
        IF (Application.Status = Application.Status::Cancelled) THEN
            ERROR('Application status must not be %1', Application.Status);
        //Validation
        IF Application.Status > Application.Status::Printed THEN
            ERROR(Text001, Application.Status);

        //Bond."Penalty Amount" := PenaltyAmount;
        Application.Status := Application.Status::Cancelled;
        Application.MODIFY;
        //Bond Reversal entries
        BondReversalEntries.SETRANGE("Document Type", BondReversalEntries."Document Type"::Application);
        BondReversalEntries.SETRANGE("Document No.", Application."Posted Doc No.");
        IF BondReversalEntries.FINDLAST THEN
            LineNo := BondReversalEntries."Line No." + 10000
        ELSE
            LineNo := 10000;

        BondReversalEntries.INIT;
        BondReversalEntries."Document Type" := BondReversalEntries."Document Type"::BOND;
        BondReversalEntries."Document No." := Application."Posted Doc No.";
        BondReversalEntries."Line No." := LineNo;
        BondReversalEntries."Application No." := Application."Application No.";
        BondReversalEntries."Unit No." := Application."Application No.";
        BondReversalEntries."Posted. Doc. No." := Application."Posted Doc No.";
        BondReversalEntries."Posting date" := Application."Posting Date";
        BondReversalEntries."Document Date" := Application."Document Date";
        BondReversalEntries."User ID" := UserSetup."User ID";
        BondReversalEntries."Reverse Date" := GetDescription.GetDocomentDate;
        BondReversalEntries."Reverse Time" := TIME;
        BondReversalEntries.INSERT;
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
        BondPaymentEntry.SETRANGE(BondPaymentEntry."Payment Mode", BondPaymentEntry."Payment Mode"::Bank);
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                IF BondPaymentEntry."Cheque Status" = BondPaymentEntry."Cheque Status"::" " THEN
                    ERROR(Text003, BondPaymentEntry."Document No.");
            UNTIL BondPaymentEntry.NEXT = 0;
    end;


    procedure GetCashAccountNo(UserBranchCode: Code[20]): Code[20]
    var
        GLAccount: Record "G/L Account";
    begin
        //ALLETDK061212..BEGIN
        GLAccount.RESET;
        GLAccount.SETRANGE("BBG Cash Account", TRUE);
        GLAccount.SETRANGE("BBG Branch Code", UserBranchCode);
        IF GLAccount.FINDFIRST THEN
            EXIT(GLAccount."No.")
        ELSE
            ERROR('You must specify Cash Account for Branch Code %1', UserBranchCode);
        //ALLETDK061212..END
    end;


    procedure InsertJnDimension(RecGenLine: Record "Gen. Journal Line")
    begin
        // ALLE MM Code Commented
        /*
        CLEAR(JournalLineDimension)
        GLSetup.GET;
        UserSetup.GET(USERID);
        CLEAR(JournalLineDimension1);
        JournalLineDimension1.RESET;
        JournalLineDimension1.SETRANGE("Table ID", 81);
        JournalLineDimension1.SETRANGE("Journal Template Name" , RecGenLine."Journal Template Name");
        JournalLineDimension1.SETRANGE("Journal Batch Name" , RecGenLine."Journal Batch Name");
        JournalLineDimension1.SETRANGE("Journal Line No." , RecGenLine."Line No.");
        JournalLineDimension1.SETRANGE("Dimension Code" , GLSetup."Shortcut Dimension 1 Code");
        JournalLineDimension1.SETRANGE("Dimension Value Code" , RecGenLine."Shortcut Dimension 1 Code");
        IF NOT JournalLineDimension1.FINDFIRST THEN BEGIN
          JournalLineDimension.INIT;
          JournalLineDimension."Table ID" := 81;
          JournalLineDimension."Journal Template Name" := RecGenLine."Journal Template Name";
          JournalLineDimension."Journal Batch Name" := RecGenLine."Journal Batch Name";
          JournalLineDimension."Journal Line No." := RecGenLine."Line No.";
          JournalLineDimension."Dimension Code" := GLSetup."Shortcut Dimension 1 Code";
          JournalLineDimension."Dimension Value Code" := RecGenLine."Shortcut Dimension 1 Code";
         JournalLineDimension.INSERT;
        END;
        */
        // ALLE MM Code Commented

    end;


    procedure PostGenJnlLines1()
    begin
        CLEAR(GenJnlPostLine);
        CLEAR(GenJnlPostBatch);
        GenJnlLine1.RESET;
        GenJnlLine1.SETRANGE("Document No.", PDocNo);
        GenJnlLine1.FINDFIRST;
        REPEAT
            //GenJnlPostLine.SetDocumentNo(GenJnlLine1."Document No.");
            //  GenJnlPostLine.RUN(GenJnlLine);
            GenJnlPostLine.RunWithCheck(GenJnlLine1);  //ALLEDK 090213
        UNTIL GenJnlLine1.NEXT = 0;
        //GenJnlPostBatch.DeleteGenJournalNarration(GenJnlLine1);
        GenJnlLine1.DELETEALL;
    end;


    procedure CheckandReverseTA(AppNo: Code[20]; FromAssociateChange: Boolean): Boolean
    var
        ArchiveConfOrder: Record "Archive Confirmed Order";
        TravelPayDetails: Record "Travel Payment Details";
        TravelPaymentEntry: Record "Travel Payment Entry";
        TravelPaymentEntry1: Record "Travel Payment Entry";
        COrd: Record "Confirmed Order";
        LNo: Decimal;
        TravelDocumentNo: Code[20];
    begin
        COrd.GET(AppNo);
        TravelDocumentNo := '';
        TravelPayDetails.RESET;
        TravelPayDetails.SETRANGE("Application No.", AppNo);
        TravelPayDetails.SETRANGE(Approved, TRUE);
        TravelPayDetails.SETRANGE(Reverse, FALSE);
        IF TravelPayDetails.FINDLAST THEN
            TravelDocumentNo := TravelPayDetails."Document No.";

        IF FromAssociateChange THEN BEGIN
            CLEAR(TravelPayDetails);
            TravelPayDetails.RESET;
            TravelPayDetails.SETRANGE("Application No.", AppNo);
            TravelPayDetails.SETRANGE(Approved, TRUE);
            TravelPayDetails.SETRANGE(Reverse, FALSE);
            TravelPayDetails.SETRANGE("Document No.", TravelDocumentNo);
            IF TravelPayDetails.FINDLAST THEN BEGIN
                CLEAR(LNo);

                CLEAR(TravelPaymentEntry);
                TravelPaymentEntry.RESET;
                TravelPaymentEntry.SETRANGE("Document No.", TravelPayDetails."Document No.");
                IF TravelPaymentEntry.FINDLAST THEN
                    LNo := TravelPaymentEntry."Line No.";

                TravelPaymentEntry.RESET;
                TravelPaymentEntry.SETRANGE("Document No.", TravelPayDetails."Document No.");
                TravelPaymentEntry.SETRANGE(Approved, TRUE);
                TravelPaymentEntry.SETRANGE(Reverse, FALSE);
                TravelPaymentEntry.SETRANGE("Appl. Not Show on Travel Form", FALSE);
                TravelPaymentEntry.SETFILTER("Amount to Pay", '<>%1', 0);
                IF TravelPaymentEntry.FINDSET THEN
                    REPEAT
                        LNo := LNo + 1000;
                        TravelPaymentEntry1.RESET;
                        TravelPaymentEntry1.INIT;
                        TravelPaymentEntry1.COPY(TravelPaymentEntry);
                        TravelPaymentEntry1."Line No." := LNo;
                        TravelPaymentEntry1.INSERT;
                        TravelPaymentEntry1."Total Area" := TravelPayDetails."Saleable Area";
                        TravelPaymentEntry1."Amount to Pay" := -TravelPayDetails."Saleable Area" * TravelPaymentEntry1."TA Rate";
                        //  TravelPaymentEntry1."Amount to Pay" := -TravelPaymentEntry1."Amount to Pay"; 18/11/2014
                        TravelPaymentEntry1."Post Payment" := FALSE;
                        TravelPaymentEntry1."Application No." := AppNo;
                        TravelPaymentEntry1.Reverse := TRUE;
                        TravelPaymentEntry1."Remaining Amount" := 0;   //BBG1.00 040513
                        TravelPaymentEntry1."Voucher No." := '';
                        TravelPaymentEntry1.MODIFY;

                        TAAppwiseDet1.RESET;
                        TAAppwiseDet1.SETRANGE("Document No.", TravelPayDetails."Document No.");
                        TAAppwiseDet1.SETRANGE("TA Detail Line No.", TravelPayDetails."Line no.");
                        IF TAAppwiseDet1.FINDLAST THEN
                            LineNo := TAAppwiseDet1."Line No."
                        ELSE
                            LineNo := 0;

                        TAAppwiseDet.INIT;
                        TAAppwiseDet."Document No." := TravelPaymentEntry."Document No.";
                        TAAppwiseDet."Line No." := LineNo + 1000;
                        TAAppwiseDet."TA Detail Line No." := TravelPayDetails."Line no.";
                        TAAppwiseDet."Application No." := TravelPayDetails."Application No.";
                        TAAppwiseDet."Application Date" := TravelPayDetails."Posting Date";
                        TAAppwiseDet."Introducer Code" := TravelPayDetails."Associate Code";
                        TAAppwiseDet."Introducer Name" := TravelPayDetails."Associate Name";
                        TAAppwiseDet."Associate UpLine Code" := TravelPaymentEntry."Sub Associate Code";
                        TAAppwiseDet."Associate Name" := TravelPaymentEntry."Sub Associate Name";
                        TAAppwiseDet."TA Rate" := TravelPaymentEntry."TA Rate";
                        TAAppwiseDet."TA Generation Date" := TODAY;
                        TAAppwiseDet."TA Amount" := -TravelPayDetails."Saleable Area" * TravelPaymentEntry1."TA Rate";
                        ;
                        TAAppwiseDet."Saleable Area" := TravelPayDetails."Saleable Area";
                        TAAppwiseDet.INSERT;
                    //BBG1.2 231213

                    UNTIL TravelPaymentEntry.NEXT = 0;
                TravelPayDetails.Reverse := TRUE;
                TravelPayDetails.MODIFY;
                COrd."Travel Generate" := FALSE;
                COrd.MODIFY;
                AssociateHierarcywithApp.RESET;
                AssociateHierarcywithApp.SETRANGE("Application Code", AppNo);
                IF AssociateHierarcywithApp.FINDSET THEN
                    AssociateHierarcywithApp.MODIFYALL("Travel Generated", FALSE);
            END;

        END ELSE BEGIN
            IF NOT CheckForSameUnitArea(AppNo, TravelDocumentNo) THEN BEGIN
                CLEAR(TravelPayDetails);
                AssCode_1 := '';
                LineNo_1 := 0;
                TravelPayDetails.RESET;
                TravelPayDetails.SETRANGE("Application No.", AppNo);
                TravelPayDetails.SETRANGE(Approved, TRUE);
                TravelPayDetails.SETRANGE(Reverse, FALSE);
                TravelPayDetails.SETRANGE("Document No.", TravelDocumentNo);
                IF TravelPayDetails.FINDLAST THEN BEGIN
                    CLEAR(LNo);

                    CLEAR(TravelPaymentEntry);
                    TravelPaymentEntry.RESET;
                    TravelPaymentEntry.SETRANGE("Document No.", TravelPayDetails."Document No.");
                    IF TravelPaymentEntry.FINDLAST THEN
                        LNo := TravelPaymentEntry."Line No.";

                    TravelPaymentEntry_1.RESET;
                    TravelPaymentEntry_1.SETCURRENTKEY("Sub Associate Code");
                    TravelPaymentEntry_1.SETRANGE("Document No.", TravelPayDetails."Document No.");
                    TravelPaymentEntry_1.SETRANGE(Approved, TRUE);
                    TravelPaymentEntry_1.SETRANGE(Reverse, FALSE);
                    TravelPaymentEntry_1.SETFILTER("Amount to Pay", '>%1', 0);
                    IF TravelPaymentEntry_1.FINDSET THEN
                        REPEAT
                            IF AssCode_1 <> TravelPaymentEntry_1."Sub Associate Code" THEN BEGIN
                                LineNo_1 := TravelPaymentEntry_1."Line No.";
                                AssCode_1 := TravelPaymentEntry_1."Sub Associate Code";
                                TravelPaymentEntry.RESET;
                                TravelPaymentEntry.SETRANGE("Document No.", TravelPayDetails."Document No.");
                                TravelPaymentEntry.SETRANGE("Line No.", LineNo_1);
                                TravelPaymentEntry.SETRANGE(Approved, TRUE);
                                //        TravelPaymentEntry.SETRANGE(Reverse,FALSE);
                                //      TravelPaymentEntry.SETRANGE("Appl. Not Show on Travel Form",FALSE);
                                //    TravelPaymentEntry.SETFILTER("Amount to Pay",'>%1',0);
                                IF TravelPaymentEntry.FINDSET THEN
                                    REPEAT
                                        LNo := LNo + 1000;
                                        TravelPaymentEntry1.RESET;
                                        TravelPaymentEntry1.INIT;
                                        TravelPaymentEntry1.COPY(TravelPaymentEntry);
                                        TravelPaymentEntry1."Line No." := LNo;
                                        TravelPaymentEntry1.INSERT;
                                        TravelPaymentEntry1."Total Area" := TravelPayDetails."Saleable Area";
                                        TravelPaymentEntry1."Amount to Pay" := -TravelPayDetails."Saleable Area" * TravelPaymentEntry1."TA Rate";
                                        //  TravelPaymentEntry1."Amount to Pay" := -TravelPaymentEntry1."Amount to Pay"; 18/11/2014
                                        TravelPaymentEntry1."Post Payment" := FALSE;
                                        TravelPaymentEntry1."Application No." := AppNo;
                                        TravelPaymentEntry1.Reverse := TRUE;
                                        TravelPaymentEntry1."Remaining Amount" := 0;   //BBG1.00 040513
                                        TravelPaymentEntry1."Voucher No." := '';
                                        TravelPaymentEntry1.MODIFY;

                                        TAAppwiseDet1.RESET;
                                        TAAppwiseDet1.SETRANGE("Document No.", TravelPayDetails."Document No.");
                                        TAAppwiseDet1.SETRANGE("TA Detail Line No.", TravelPayDetails."Line no.");
                                        IF TAAppwiseDet1.FINDLAST THEN
                                            LineNo := TAAppwiseDet1."Line No."
                                        ELSE
                                            LineNo := 0;

                                        TAAppwiseDet.INIT;
                                        TAAppwiseDet."Document No." := TravelPaymentEntry."Document No.";
                                        TAAppwiseDet."Line No." := LineNo + 1000;
                                        TAAppwiseDet."TA Detail Line No." := TravelPayDetails."Line no.";
                                        TAAppwiseDet."Application No." := TravelPayDetails."Application No.";
                                        TAAppwiseDet."Application Date" := TravelPayDetails."Posting Date";
                                        TAAppwiseDet."Introducer Code" := TravelPayDetails."Associate Code";
                                        TAAppwiseDet."Introducer Name" := TravelPayDetails."Associate Name";
                                        TAAppwiseDet."Associate UpLine Code" := TravelPaymentEntry."Sub Associate Code";
                                        TAAppwiseDet."Associate Name" := TravelPaymentEntry."Sub Associate Name";
                                        TAAppwiseDet."TA Rate" := TravelPaymentEntry."TA Rate";
                                        TAAppwiseDet."TA Generation Date" := TODAY;
                                        TAAppwiseDet."TA Amount" := -TravelPayDetails."Saleable Area" * TravelPaymentEntry1."TA Rate";
                                        ;
                                        TAAppwiseDet."Saleable Area" := TravelPayDetails."Saleable Area";
                                        TAAppwiseDet.INSERT;
                                    //BBG1.2 231213
                                    UNTIL TravelPaymentEntry.NEXT = 0;
                            END;
                        UNTIL TravelPaymentEntry_1.NEXT = 0;
                    TravelPayDetails.Reverse := TRUE;
                    TravelPayDetails.MODIFY;
                    IF NOT ReturnValue1 THEN BEGIN
                        COrd."Travel Generate" := FALSE;
                        COrd.MODIFY;
                    END;
                    //BBG1.00 270513

                    AssociateHierarcywithApp.RESET;
                    AssociateHierarcywithApp.SETRANGE("Application Code", AppNo);
                    IF AssociateHierarcywithApp.FINDSET THEN
                        REPEAT
                            AssociateHierarcywithApp."Travel Generated" := FALSE;
                            AssociateHierarcywithApp.MODIFY;
                        UNTIL AssociateHierarcywithApp.NEXT = 0;
                END;
            END;
        END;
        exit(COrd."Travel Generate");
    end;


    procedure CheckForSameUnitArea(ConfirmedOrderNo: Code[20]; TravelDocNo: Code[20]): Boolean
    var
        ConfirmedOrder: Record "Confirmed Order";
        ArchiveConfirmedOrder: Record "Archive Confirmed Order";
        TravelSetupLine: Record "Travel Setup Line New";
        TravelSetupLine1: Record "Travel Setup Line New";
        ReturnValue: Boolean;
        TPEntry: Record "Travel Payment Entry";
        TPEntry1: Record "Travel Payment Entry";
        LNo: Integer;
        TrvlDetEntry: Record "Travel Setup Header1";
        TravelPaymentDet1: Record "Travel Payment Details";
        TravelPaymentDet: Record "Travel Payment Details";
        AppPayEntry: Record "Application Payment Entry";
        RcvdAmt: Decimal;
        TPHeader: Record "Travel Header";
        TACode: Code[20];
        RecordNotFind: Boolean;
    begin
        //BBG2.0
        ConfirmedOrder.GET(ConfirmedOrderNo);
        TACode := '';
        TPHeader.RESET;
        TPHeader.SETRANGE("Document No.", TravelDocNo);
        IF TPHeader.FINDFIRST THEN
            TACode := TPHeader."ARM TA Code";

        ReturnValue := FALSE;
        ArchiveConfirmedOrder.RESET;
        ArchiveConfirmedOrder.SETRANGE("No.", ConfirmedOrderNo);
        IF ArchiveConfirmedOrder.FINDLAST THEN BEGIN
            IF (ConfirmedOrder."Introducer Code" = ArchiveConfirmedOrder."Introducer Code") AND
               (ConfirmedOrder."Shortcut Dimension 1 Code" = ArchiveConfirmedOrder."Shortcut Dimension 1 Code") AND
               (ConfirmedOrder."Saleable Area" = ArchiveConfirmedOrder."Saleable Area")
              THEN
                ReturnValue := TRUE;
            RecordNotFind := FALSE;
            IF (ConfirmedOrder."Shortcut Dimension 1 Code" <> ArchiveConfirmedOrder."Shortcut Dimension 1 Code") THEN BEGIN
                TravelSetupLine.RESET;
                TravelSetupLine.SETRANGE("TA Code", TACode);
                TravelSetupLine.SETRANGE("Project Code", ConfirmedOrder."Shortcut Dimension 1 Code");
                IF TravelSetupLine.FINDFIRST THEN
                    ReturnValue := FALSE
                ELSE
                    RecordNotFind := TRUE;
            END;

            IF (NOT ReturnValue) AND (NOT RecordNotFind) THEN BEGIN
                RcvdAmt := 0;
                IF (ConfirmedOrder."Saleable Area" <= ArchiveConfirmedOrder."Saleable Area") THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE(AppPayEntry."Document No.", ConfirmedOrder."No.");
                    AppPayEntry.SETRANGE(AppPayEntry."Cheque Status", AppPayEntry."Cheque Status"::Cleared);
                    IF AppPayEntry.FINDSET THEN
                        REPEAT
                            RcvdAmt := RcvdAmt + AppPayEntry.Amount;
                        UNTIL AppPayEntry.NEXT = 0;
                    IF RcvdAmt >= ConfirmedOrder."Min. Allotment Amount" THEN BEGIN
                        CreateNewDocument(TRUE, TravelDocNo, ConfirmedOrder, ArchiveConfirmedOrder."No.");
                        ReturnValue1 := TRUE;
                    END ELSE
                        ReturnValue1 := FALSE;
                END;
            END;
        END;


        EXIT(ReturnValue);
    end;


    procedure CreateNewDocument(ForNewEntry: Boolean; OldDocumentNo: Code[20]; ConfOrder: Record "Confirmed Order"; OldAppNo: Code[20])
    var
        TPEntry: Record "Travel Payment Entry";
        OldTPEntry: Record "Travel Payment Entry";
        TravelHeader: Record "Travel Header";
        OldTravelHeader: Record "Travel Header";
        LNo: Integer;
        TravelPaymentDet1: Record "Travel Payment Details";
        TravelPaymentDet: Record "Travel Payment Details";
    begin
        OldTravelHeader.RESET;
        OldTravelHeader.SETRANGE("Document No.", OldDocumentNo);
        IF OldTravelHeader.FINDFIRST THEN BEGIN
            TravelHeader.INIT;
            TravelHeader."Document No." := '';
            TravelHeader.INSERT(TRUE);
            TravelHeader."Team Lead" := OldTravelHeader."Team Lead";
            TravelHeader."End Date" := OldTravelHeader."End Date";
            TravelHeader."Start Date" := OldTravelHeader."Start Date";
            TravelHeader."Top Person" := OldTravelHeader."Top Person";
            TravelHeader."ARM TA Code" := OldTravelHeader."ARM TA Code";
            TravelHeader."Project Rate" := OldTravelHeader."Project Rate";
            TravelHeader."Total Saleable Area" := ConfOrder."Saleable Area";
            TravelHeader."Associate Name" := OldTravelHeader."Associate Name";
            TravelHeader."Sent for Approval" := TRUE;
            TravelHeader.Approved := TRUE;
            TravelHeader.MODIFY;


            TravelPaymentDet1.RESET;
            TravelPaymentDet1.SETRANGE("Document No.", OldDocumentNo);
            TravelPaymentDet1.SETRANGE("Application No.", OldAppNo);
            IF TravelPaymentDet1.FINDFIRST THEN BEGIN
                TravelPaymentDet.INIT;
                TravelPaymentDet."Document No." := TravelHeader."Document No.";
                TravelPaymentDet."Line no." := 10000;
                TravelPaymentDet.INSERT;
                TravelPaymentDet."Project Code" := ConfOrder."Shortcut Dimension 1 Code";
                TravelPaymentDet."Associate Code" := TravelPaymentDet1."Associate Code";
                TravelPaymentDet."Sub Associate Code" := TravelPaymentDet1."Sub Associate Code";
                TravelPaymentDet."Application No." := TravelPaymentDet1."Application No.";
                TravelPaymentDet."Saleable Area" := ConfOrder."Saleable Area";
                TravelPaymentDet."Creation Date" := WORKDATE;
                TravelPaymentDet.Month := TravelPaymentDet1.Month;//MonthNo;
                TravelPaymentDet."ARM TA Code" := TravelPaymentDet1."ARM TA Code"; //BBG1.2 240114
                TravelPaymentDet.Year := TravelPaymentDet1.Year;
                TravelPaymentDet."Total Amount Area" := TravelPaymentDet1."Gross TA Rate" * ConfOrder."Saleable Area";
                TravelPaymentDet."ARM TA Code" := TravelPaymentDet1."ARM TA Code";
                TravelPaymentDet.Select := TRUE;
                TravelPaymentDet."Gross TA Rate" := TravelPaymentDet1."Gross TA Rate";
                TravelPaymentDet.Approved := TRUE;
                TravelPaymentDet."Sent for Approval" := TRUE;
                TravelPaymentDet."Associate Name" := TravelPaymentDet1."Associate Name";
                TravelPaymentDet."Sub Associate Name" := TravelPaymentDet1."Sub Associate Name";
                TravelPaymentDet.MODIFY;
            END;
            //25915

            OldTPEntry.RESET;
            OldTPEntry.SETRANGE("Document No.", OldDocumentNo);
            OldTPEntry.SETRANGE("Application No.", OldAppNo);
            OldTPEntry.SETRANGE(Reverse, FALSE);
            OldTPEntry.SETFILTER("Amount to Pay", '<>%1', 0);
            IF OldTPEntry.FINDFIRST THEN BEGIN
                REPEAT
                    TPEntry.INIT;
                    TPEntry.COPY(OldTPEntry);
                    TPEntry."Document No." := TravelHeader."Document No.";
                    TPEntry.INSERT;
                    TPEntry."Total Area" := ConfOrder."Saleable Area";
                    TPEntry."Amount to Pay" := OldTPEntry."TA Rate" * ConfOrder."Saleable Area";
                    TPEntry."Project Code" := ConfOrder."Shortcut Dimension 1 Code";  //300920 BBG2.0
                    TPEntry."TDS Amount" := 0;
                    TPEntry."Post Payment" := FALSE;
                    TPEntry."Voucher No." := '';
                    TPEntry.MODIFY;

                    TAAppwiseDet1.RESET;
                    TAAppwiseDet1.SETRANGE("Document No.", TravelPaymentDet."Document No.");
                    TAAppwiseDet1.SETRANGE("TA Detail Line No.", TravelPaymentDet."Line no.");
                    IF TAAppwiseDet1.FINDLAST THEN
                        LineNo := TAAppwiseDet1."Line No."
                    ELSE
                        LineNo := 0;

                    TAAppwiseDet.INIT;
                    TAAppwiseDet."Document No." := TravelPaymentDet."Document No.";
                    TAAppwiseDet."Line No." := LineNo + 1000;
                    TAAppwiseDet."TA Detail Line No." := TravelPaymentDet."Line no.";
                    TAAppwiseDet."Application No." := TravelPaymentDet."Application No.";
                    TAAppwiseDet."Application Date" := TravelPaymentDet."Posting Date";
                    TAAppwiseDet."Introducer Code" := TravelPaymentDet."Associate Code";
                    TAAppwiseDet."Introducer Name" := TravelPaymentDet."Associate Name";
                    TAAppwiseDet."Associate UpLine Code" := TravelPaymentDet."Sub Associate Code";
                    TAAppwiseDet."Associate Name" := TravelPaymentDet."Sub Associate Name";

                    TAAppwiseDet."TA Generation Date" := TODAY;
                    TAAppwiseDet."TA Amount" := TPEntry."Amount to Pay";
                    TAAppwiseDet."Saleable Area" := ConfOrder."Saleable Area";
                    TAAppwiseDet.INSERT;
                //BBG1.2 231213
                //25915
                UNTIL OldTPEntry.NEXT = 0;
            END ELSE BEGIN  //ALLEDK 280417 Start
                OldTPEntry.RESET;
                OldTPEntry.SETRANGE("Document No.", OldDocumentNo);
                OldTPEntry.SETRANGE(Reverse, FALSE);
                OldTPEntry.SETFILTER("Amount to Pay", '<>%1', 0);
                IF OldTPEntry.FINDFIRST THEN
                    REPEAT
                        TPEntry.INIT;
                        TPEntry.COPY(OldTPEntry);
                        TPEntry."Document No." := TravelHeader."Document No.";
                        TPEntry.INSERT;
                        TPEntry."Total Area" := ConfOrder."Saleable Area";
                        TPEntry."Amount to Pay" := OldTPEntry."TA Rate" * ConfOrder."Saleable Area";
                        TPEntry."Project Code" := ConfOrder."Shortcut Dimension 1 Code";  //300920
                        TPEntry."TDS Amount" := 0;
                        TPEntry."Post Payment" := FALSE;
                        TPEntry."Voucher No." := '';
                        TPEntry.MODIFY;

                        TAAppwiseDet1.RESET;
                        TAAppwiseDet1.SETRANGE("Document No.", TravelPaymentDet."Document No.");
                        TAAppwiseDet1.SETRANGE("TA Detail Line No.", TravelPaymentDet."Line no.");
                        IF TAAppwiseDet1.FINDLAST THEN
                            LineNo := TAAppwiseDet1."Line No."
                        ELSE
                            LineNo := 0;

                        TAAppwiseDet.INIT;
                        TAAppwiseDet."Document No." := TravelPaymentDet."Document No.";
                        TAAppwiseDet."Line No." := LineNo + 1000;
                        TAAppwiseDet."TA Detail Line No." := TravelPaymentDet."Line no.";
                        TAAppwiseDet."Application No." := TravelPaymentDet."Application No.";
                        TAAppwiseDet."Application Date" := TravelPaymentDet."Posting Date";
                        TAAppwiseDet."Introducer Code" := TravelPaymentDet."Associate Code";
                        TAAppwiseDet."Introducer Name" := TravelPaymentDet."Associate Name";
                        TAAppwiseDet."Associate UpLine Code" := TravelPaymentDet."Sub Associate Code";
                        TAAppwiseDet."Associate Name" := TravelPaymentDet."Sub Associate Name";

                        TAAppwiseDet."TA Generation Date" := TODAY;
                        TAAppwiseDet."TA Amount" := TPEntry."Amount to Pay";
                        TAAppwiseDet."Saleable Area" := ConfOrder."Saleable Area";
                        TAAppwiseDet.INSERT;
                    //BBG1.2 231213
                    //25915
                    UNTIL OldTPEntry.NEXT = 0;
            END;
            //ALLEDK 280417 END;
        END;
    end;


    procedure RefundCommisionGenerate(BondNo: Code[20]; CommissionBatchDate: Date)
    var
        CommissionEntry: Record "Commission Entry";
        CommissionEntry2: Record "Commission Entry";
        LastentryNo: Integer;
        CommEntry: Record "Commission Entry";
        ConfirmedOrder: Record "Confirmed Order";
        EntryNo: Integer;
        AppPayEntry_2: Record "Application Payment Entry";
        PTLSale_1: Record "Payment Terms Line Sale";
        BaseAmt: Decimal;
        Unit_CommBuffer_1: Record "Unit & Comm. Creation Buffer";
    begin
        CommissionEntry.RESET;
        IF CommissionEntry.FINDLAST THEN
            EntryNo := CommissionEntry."Entry No." + 1;

        ConfirmedOrder.RESET;
        IF ConfirmedOrder.GET(BondNo) THEN BEGIN
            ConfirmedOrder.CALCFIELDS(ConfirmedOrder."Amount Received");
            IF ConfirmedOrder."Amount Received" >= ConfirmedOrder."Min. Allotment Amount" THEN BEGIN

                BaseAmt := 0;
                PTLSale_1.RESET;
                PTLSale_1.SETRANGE("Document No.", BondNo);
                IF PTLSale_1.FINDSET THEN
                    REPEAT
                        BaseAmt := 0;
                        PTLSale_1.CALCFIELDS("Received Amt");
                        IF PTLSale_1."Commision Applicable" THEN BEGIN
                            BaseAmt := PTLSale_1."Received Amt";
                            IF PTLSale_1."First Milestone %" <> 0 THEN
                                BaseAmt := ROUND(BaseAmt * PTLSale_1."First Milestone %" / 100);

                            AssociateHierarcywithApp.RESET;
                            AssociateHierarcywithApp.SETCURRENTKEY("Rank Code", AssociateHierarcywithApp."Application Code");
                            AssociateHierarcywithApp.SETRANGE("Application Code", BondNo);
                            AssociateHierarcywithApp.SETRANGE(Status, AssociateHierarcywithApp.Status::Active);
                            AssociateHierarcywithApp.SETFILTER("Associate Code", '<>%1', 'IBA9999999');
                            IF AssociateHierarcywithApp.FINDSET THEN
                                REPEAT
                                    CommissionEntry.INIT;
                                    CommissionEntry."Entry No." := EntryNo;
                                    CommissionEntry.VALIDATE("Application No.", BondNo);
                                    CommissionEntry."Posting Date" := WORKDATE;
                                    CommissionEntry."Associate Code" := AssociateHierarcywithApp."Associate Code";
                                    CommissionEntry."Base Amount" := BaseAmt;
                                    CommissionEntry."Commission Amount" := ROUND(BaseAmt);
                                    CommissionEntry."Commission %" := AssociateHierarcywithApp."Commission %";
                                    CommissionEntry."Commission Amount" := ROUND(BaseAmt * (CommissionEntry."Commission %" / 100));
                                    CommissionEntry."Bond Category" := ConfirmedOrder."Bond Category";
                                    IF ConfirmedOrder."Introducer Code" = AssociateHierarcywithApp."Associate Code" THEN
                                        CommissionEntry."Business Type" := CommissionEntry."Business Type"::SELF
                                    ELSE
                                        CommissionEntry."Business Type" := CommissionEntry."Business Type"::CHAIN;
                                    CommissionEntry."Introducer Code" := ConfirmedOrder."Introducer Code";
                                    CommissionEntry."Scheme Code" := ConfirmedOrder."Scheme Code";
                                    CommissionEntry."Project Type" := ConfirmedOrder."Project Type";
                                    CommissionEntry."Commission Run Date" := CommissionBatchDate;
                                    CommissionEntry."Shortcut Dimension 1 Code" := ConfirmedOrder."Shortcut Dimension 1 Code";  //ALLEDK 040113
                                    CommissionEntry."Associate Rank" := AssociateHierarcywithApp."Rank Code";
                                    CommissionEntry."First Year" := TRUE;
                                    CommissionEntry."Commission Revs. by RefundCheq" := TRUE;
                                    CommissionEntry."Registration Bonus Hold(BSP2)" := ConfirmedOrder."Registration Bonus Hold(BSP2)";
                                    CommissionEntry.INSERT;

                                    EntryNo += 1;
                                UNTIL AssociateHierarcywithApp.NEXT = 0;
                        END ELSE
                            IF PTLSale_1."Direct Associate" THEN BEGIN
                                BaseAmt := PTLSale_1."Received Amt";
                                CommissionEntry.INIT;
                                CommissionEntry."Entry No." := EntryNo;
                                CommissionEntry.VALIDATE("Application No.", BondNo);
                                CommissionEntry."Posting Date" := WORKDATE;
                                CommissionEntry."Associate Code" := ConfirmedOrder."Introducer Code";
                                CommissionEntry."Base Amount" := BaseAmt;
                                CommissionEntry."Commission Amount" := ROUND(BaseAmt);
                                CommissionEntry."Commission %" := 0;
                                CommissionEntry."Commission Amount" := ROUND(BaseAmt);
                                CommissionEntry."Bond Category" := ConfirmedOrder."Bond Category";
                                CommissionEntry."Business Type" := CommissionEntry."Business Type"::SELF;
                                CommissionEntry."Introducer Code" := ConfirmedOrder."Introducer Code";
                                CommissionEntry."Scheme Code" := ConfirmedOrder."Scheme Code";
                                CommissionEntry."Project Type" := ConfirmedOrder."Project Type";
                                CommissionEntry."Commission Run Date" := CommissionBatchDate;
                                CommissionEntry."Shortcut Dimension 1 Code" := ConfirmedOrder."Shortcut Dimension 1 Code";  //ALLEDK 040113
                                CommissionEntry."Associate Rank" := AssociateHierarcywithApp."Rank Code";
                                CommissionEntry."First Year" := TRUE;
                                CommissionEntry."Direct to Associate" := TRUE;
                                CommissionEntry."Registration Bonus Hold(BSP2)" := ConfirmedOrder."Registration Bonus Hold(BSP2)";
                                CommissionEntry.INSERT;
                                EntryNo += 1;
                            END;
                    UNTIL PTLSale_1.NEXT = 0;
                Unit_CommBuffer_1.RESET;
                Unit_CommBuffer_1.SETRANGE("Unit No.", BondNo);
                IF Unit_CommBuffer_1.FINDSET THEN
                    REPEAT
                        Unit_CommBuffer_1.DELETE;
                    UNTIL Unit_CommBuffer_1.NEXT = 0;
            END ELSE BEGIN
                //081116
                Unit_CommBuffer_1.RESET;
                Unit_CommBuffer_1.SETRANGE("Unit No.", BondNo);
                IF Unit_CommBuffer_1.FINDSET THEN
                    REPEAT
                        Unit_CommBuffer_1.DELETE;
                    UNTIL Unit_CommBuffer_1.NEXT = 0;

                BaseAmt := 0;
                PTLSale_1.RESET;
                PTLSale_1.SETRANGE("Document No.", BondNo);
                PTLSale_1.SETRANGE("Commision Applicable", TRUE);
                IF PTLSale_1.FINDSET THEN
                    REPEAT
                        PTLSale_1.CALCFIELDS("Received Amt");
                        BaseAmt := BaseAmt + PTLSale_1."Received Amt";
                    UNTIL PTLSale_1.NEXT = 0;

                InitialStagingTab.INIT;
                InitialStagingTab."Unit No." := BondNo;           //ALLETDk
                InitialStagingTab."Installment No." := 1;
                InitialStagingTab."Posting Date" := TODAY; //ALLEDK 130113
                InitialStagingTab.VALIDATE("Introducer Code", ConfirmedOrder."Introducer Code");  //ALLETDK
                InitialStagingTab."Base Amount" := BaseAmt;      //ALLETDK
                InitialStagingTab.VALIDATE("Project Type", ConfirmedOrder."Project Type");
                InitialStagingTab.Duration := ConfirmedOrder.Duration;
                InitialStagingTab."Year Code" := 0;
                InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", ConfirmedOrder."Shortcut Dimension 1 Code");
                InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", ConfirmedOrder."Shortcut Dimension 2 Code");
                InitialStagingTab."Application No." := ConfirmedOrder."No."; //ALLETDK
                InitialStagingTab."Bond Created" := TRUE;
                InitialStagingTab."Min. Allotment Amount Not Paid" := TRUE;
                InitialStagingTab.INSERT;

                //081116
                ReverseTARefundCase(BondNo);
                CreateTACreditMemo(ConfirmedOrder."Introducer Code", 0, BondNo, FALSE);
            END;
        END;
    end;


    procedure "--------From Inter comp post"()
    begin
    end;


    procedure InterPostBondReversal(Bond: Record "Confirmed Order"; ReverseComm: Boolean; PenaltyAmount: Decimal; RefPostDate: Date)
    var
        Application: Record Application;
        BondPaymentEntry: Record "Unit Payment Entry";
        PostedDocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NarrationText1: Text[250];
        BondPostingGroup1: Record "Customer Posting Group";
        CompanywiseGLAccount: Record "Company wise G/L Account";
    begin
        BondSetup.GET;
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;

        IF ((RefundCashAmount + RefundChequeAmount) <> 0) THEN BEGIN
            NarrationText1 := 'Refund Amount for Order- ' + COPYSTR(Bond."Application No.", 1, 30);
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            GenJnlLine.VALIDATE("Posting Date", RefPostDate);
            GenJnlLine.VALIDATE("Document Date", RefPostDate);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", Bond."Customer No.");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund; //ALLETDK061212
            GenJnlLine."Document No." := Bond."Penalty Document No.";
            //GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine."Order Ref No." := Bond."No.";
            GenJnlLine.VALIDATE(Amount, RefundCashAmount + RefundChequeAmount);
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
            BondPostingGroup1.GET(Bond."Bond Posting Group");
            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Order Ref No." := Bond."Application No.";
            GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine.Description := 'Refund Amount';
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 20000;
            GenJnlLine.VALIDATE("Posting Date", RefPostDate);
            GenJnlLine.VALIDATE("Document Date", RefPostDate);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund; //ALLETDK061212
            GenJnlLine."Document No." := Bond."Penalty Document No.";
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            CompanywiseGLAccount.RESET;
            CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
            IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Receivable Account");
            END;
            GenJnlLine.VALIDATE("Account No.", CompanywiseGLAccount."Receivable Account");

            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Refund Cash";
            GenJnlLine."Order Ref No." := Bond."No.";
            GenJnlLine.VALIDATE(Amount, -(RefundCashAmount + RefundChequeAmount));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
            BondPostingGroup1.GET(Bond."Bond Posting Group");
            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Order Ref No." := Bond."Application No.";
            GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine.Description := 'Refund Amount';
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            InsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines;
        END;


        IF (AdjmtCashAmt <> 0) THEN BEGIN
            NarrationText1 := 'Adjustment Amount for Order- ' + COPYSTR(Bond."Application No.", 1, 30);
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            IF RefPostDate <> 0D THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", RefPostDate);
                GenJnlLine.VALIDATE("Document Date", RefPostDate);
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", WORKDATE);
            END;
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", Bond."Customer No.");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "; //ALLETDK061212
            GenJnlLine."Document No." := Bond."Penalty Document No.";
            //GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
            GenJnlLine."Order Ref No." := Bond."No.";
            GenJnlLine.VALIDATE(Amount, AdjmtCashAmt);
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
            GenJnlLine.VALIDATE("Source No.", Bond."Customer No.");
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
            CompanywiseGLAccount.RESET;
            CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
            IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Receivable Account");
            END;
            GenJnlLine.VALIDATE("Bal. Account No.", CompanywiseGLAccount."Receivable Account");
            GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Negative Adjmt.";
            GenJnlLine."Posting Group" := Bond."Bond Posting Group";
            GenJnlLine."Order Ref No." := Bond."Application No.";
            GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine.Description := 'Adjustment Amount';

            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            InsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines;
        END;





        /*
        IF PenaltyAmount <>  0 THEN BEGIN
          NarrationText1 := 'Penalty Amount for Order- ' + COPYSTR(Bond."Application No.",1,30);
          GenJnlLine.INIT;
          GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
          GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
          GenJnlLine."Line No." := 10000;
          GenJnlLine.VALIDATE("Posting Date",WORKDATE);
          GenJnlLine.VALIDATE("Document Date",WORKDATE);
          GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"G/L Account");
          GenJnlLine.VALIDATE("Account No.",BondSetup."Bond Reversal Control A/c");
          GenJnlLine."Document Type" := GenJnlLine."Document Type"::Reminder;
          GenJnlLine."Document No." := Bond."Penalty Document No.";
          GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
          GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
          GenJnlLine."Order Ref No." := Bond."No.";
          GenJnlLine.VALIDATE(Amount,-PenaltyAmount);
          GenJnlLine.VALIDATE("Source Type",GenJnlLine."Source Type"::Customer);
          GenJnlLine.VALIDATE("Source No.",Bond."Customer No.");
          GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Account Type"::Customer);
          BondPostingGroup1.GET(Bond."Bond Posting Group");
          GenJnlLine.VALIDATE("Bal. Account No.",Bond."Customer No.");
          GenJnlLine."Posting Group" := Bond."Bond Posting Group";
          GenJnlLine."Order Ref No." := Bond."Application No.";
          GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
          GenJnlLine."Posting Type" := GenJnlLine."Posting Type" :: Running;
          GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
          GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
          GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
          GenJnlLine."System-Created Entry" := TRUE;
          GenJnlLine."Introducer Code" := Bond."Introducer Code";
          GenJnlLine."Posting Type" := GenJnlLine."Posting Type" ::Running;
          GenJnlLine."Unit No." := Bond."No.";
          GenJnlLine.Description := 'Penalty Amount';
          GenJnlLine.INSERT;
          InitVoucherNarration(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name",GenJnlLine."Document No.",
            GenJnlLine."Line No.",GenJnlLine."Line No.",NarrationText1);
        InsertJnDimension(GenJnlLine); //310113
        PostGenJnlLines;
        END;
        
        IF (AdjmtCashAmt<>0) THEN BEGIN
          NarrationText1 := 'Adjustment Amount for Order- ' + COPYSTR(Bond."Application No.",1,30);
          GenJnlLine.INIT;
          GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
          GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
          GenJnlLine."Line No." := 10000;
          GenJnlLine.VALIDATE("Posting Date",WORKDATE);
          GenJnlLine.VALIDATE("Document Date",WORKDATE);
          GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
          GenJnlLine.VALIDATE("Account No.",Bond."Customer No.");
          GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "; //ALLETDK061212
          GenJnlLine."Document No." := Bond."Penalty Document No.";
          //GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
          GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
          GenJnlLine."Order Ref No." := Bond."No.";
          GenJnlLine.VALIDATE(Amount,AdjmtCashAmt);
          GenJnlLine.VALIDATE("Source Type",GenJnlLine."Source Type"::Customer);
          GenJnlLine.VALIDATE("Source No.",Bond."Customer No.");
          GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Account Type"::"G/L Account");
          BondPostingGroup1.GET(Bond."Bond Posting Group");
          GenJnlLine.VALIDATE("Bal. Account No.",RefundCashAcNo);
          GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Negative Adjmt.";
          GenJnlLine."Posting Group" := Bond."Bond Posting Group";
          GenJnlLine."Order Ref No." := Bond."Application No.";
          GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
          GenJnlLine."Posting Type" := GenJnlLine."Posting Type" :: Running;
          GenJnlLine."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
          GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
          GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
          GenJnlLine."System-Created Entry" := TRUE;
          GenJnlLine."Introducer Code" := Bond."Introducer Code";
          GenJnlLine."Posting Type" := GenJnlLine."Posting Type" ::Running;
          GenJnlLine."Unit No." := Bond."No.";
          GenJnlLine.Description := 'Adjustment Amount';
          GenJnlLine.INSERT;
          InitVoucherNarration(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name",GenJnlLine."Document No.",
            GenJnlLine."Line No.",GenJnlLine."Line No.",NarrationText1);
          InsertJnDimension(GenJnlLine); //310113
          PostGenJnlLines;
        END;
        
        IF (AdjmtAJVMAmt <> 0 )THEN BEGIN
          PDocNo := '';
          GenJnlLine1.INIT;
          GenJnlLine1."Journal Template Name" := BondSetup."Transfer Member Temp Name";
          GenJnlLine1."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
          GenJnlLine1."Line No." := 10000;
          //GenJnlLine1."Document Type" := GenJnlLine1."Document Type"::Payment;
          GenJnlLine1.VALIDATE("Posting Date",WORKDATE); //ALLETDK
          GenJnlLine1.VALIDATE("Party Type",GenJnlLine1."Party Type"::Vendor);
          GenJnlLine1.VALIDATE("Party Code",AJVMAssociateCode);
                  //ALLETDK290313 >>>
          IF TransferType=TransferType::Commission THEN
            GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type" :: Commission
          ELSE
            GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type" :: Incentive;
                  //ALLETDK290313 <<<
          GenJnlLine1.VALIDATE("Bal. Account Type",GenJnlLine1."Bal. Account Type"::"G/L Account");
          GenJnlLine1.VALIDATE("Bal. Account No.",BondSetup."Transfer Control Account");
          GenJnlLine1."Payment Mode" := GenJnlLine1."Payment Mode"::"Negative Adjmt.";
          GenJnlLine1.VALIDATE(Amount,-NetADJAmt);
        
          GenJnlLine1."Document No." := Bond."Penalty Document No.";
          PDocNo:= Bond."Penalty Document No.";
          GenJnlLine1."Order Ref No." := Bond."No.";
          GenJnlLine1."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
          GenJnlLine1."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
          GenJnlLine1."System-Created Entry" := TRUE;
          GenJnlLine1."Introducer Code" := Bond."AJVM Associate Code";  //ALLEDK 270113
          GenJnlLine1."Unit No." := Bond."Unit Code";
          GenJnlLine1."Installment No." := 1;
          GenJnlLine1.INSERT;
          //IF TransferType=TransferType::Commission THEN //ALLETDK290313
            PostPayment.CheckVendorChequeAmount(GenJnlLine1);  //240113
        
          GenJnlLine1.INIT;
          GenJnlLine1."Journal Template Name" := BondSetup."Transfer Member Temp Name";
          GenJnlLine1."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
          GenJnlLine1."Line No." := 20000;
          //GenJnlLine1."Document Type" := GenJnlLine1."Document Type"::Payment;
          GenJnlLine1.VALIDATE("Posting Date",WORKDATE); //ALLETDK
          GenJnlLine1.VALIDATE("Account Type",GenJnlLine1."Account Type"::"G/L Account");
          GenJnlLine1.VALIDATE("Account No.",BondSetup."Transfer Control Account");
          IF TransferType=TransferType::Commission THEN
            GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type" :: Commission
          ELSE
            GenJnlLine1."Posting Type" := GenJnlLine1."Posting Type" :: Incentive;
          GenJnlLine1.VALIDATE("Bal. Account Type",GenJnlLine1."Bal. Account Type"::Customer);
          GenJnlLine1.VALIDATE("Bal. Account No.",Bond."Customer No.");
          GenJnlLine1.VALIDATE(Amount,-ContraAJVMAmt);
        
          GenJnlLine1."Document No." := Bond."Penalty Document No.";
          GenJnlLine1."Order Ref No." := Bond."No.";
          GenJnlLine1."Shortcut Dimension 1 Code" := Bond."Shortcut Dimension 1 Code";
          GenJnlLine1."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
          GenJnlLine1."Introducer Code" := Bond."AJVM Associate Code";  //ALLEDK 270113
          GenJnlLine1."Unit No." := Bond."Unit Code";
          GenJnlLine1."Installment No." := 1;
          GenJnlLine1.INSERT;
        
          InsertJnDimension(GenJnlLine1); //ALLEDK 310113
          InitVoucherNarration(GenJnlLine1."Journal Template Name",GenJnlLine1."Journal Batch Name",GenJnlLine1."Document No.",
           GenJnlLine1."Line No.",GenJnlLine1."Line No.",'Associate to Member Transfer Adjustment');
          PostGenJnlLines1;
        //  Line := Line + 10000;
        END;
        
        IF (JVAmount<>0) THEN BEGIN
          NarrationText1 := 'Project Change JV Amount for Order- ' + COPYSTR(Bond."Application No.",1,30);
          GenJnlLine.INIT;
          GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
          GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
          GenJnlLine."Line No." := 10000;
          GenJnlLine.VALIDATE("Posting Date",WORKDATE);
          GenJnlLine.VALIDATE("Document Date",WORKDATE);
          GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
          GenJnlLine.VALIDATE("Account No.",Bond."Customer No.");
          GenJnlLine."Document No." := Bond."Penalty Document No.";
          GenJnlLine."Bill-to/Pay-to No." := Bond."Customer No.";
          GenJnlLine."Order Ref No." := Bond."No.";
          GenJnlLine.VALIDATE(Amount,JVAmount);
          GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::JV;
          GenJnlLine.VALIDATE("Source Type",GenJnlLine."Source Type"::Customer);
          GenJnlLine.VALIDATE("Source No.",Bond."Customer No.");
          GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Account Type"::"G/L Account");
          BondPostingGroup1.GET(Bond."Bond Posting Group");
          GenJnlLine.VALIDATE("Bal. Account No.",BondSetup."Project Change JV Account");
          GenJnlLine."Posting Group" := Bond."Bond Posting Group";
          GenJnlLine."Order Ref No." := Bond."Application No.";
          GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
          GenJnlLine."Posting Type" := GenJnlLine."Posting Type" :: Running;
          GenJnlLine."Shortcut Dimension 1 Code" := ProjectCode;
          GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
          GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
          GenJnlLine."System-Created Entry" := TRUE;
          GenJnlLine."Introducer Code" := Bond."Introducer Code";
          GenJnlLine."Posting Type" := GenJnlLine."Posting Type" ::Running;
          GenJnlLine."Unit No." := Bond."No.";
          GenJnlLine.Description := 'Project Change JV';
          GenJnlLine.INSERT;
          InitVoucherNarration(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name",GenJnlLine."Document No.",
            GenJnlLine."Line No.",GenJnlLine."Line No.",NarrationText1);
          InsertJnDimension(GenJnlLine); //310113
          PostGenJnlLines;
        END;
          */ //ADDED 071214

        IF ReverseComm THEN BEGIN
            CommisionReverse(Bond."No.", FALSE);
            IF (RefundCashAmount + RefundChequeAmount) <> 0 THEN
                RefundCommisionGenerate(Bond."No.", RefPostDate);
        END;

    end;


    procedure JVEntryInMSC(Bond: Record "New Confirmed Order"; RevAmt: Decimal)
    var
        Application: Record Application;
        BondPaymentEntry: Record "Unit Payment Entry";
        PostedDocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NarrationText1: Text[250];
        BondPostingGroup1: Record "Customer Posting Group";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        ExistAppLines: Record "NewApplication Payment Entry";
    begin
        CompanywiseGLAccount.RESET;
        CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
        IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
            IF COMPANYNAME = CompanywiseGLAccount."Company Code" THEN BEGIN
                BondSetup.GET;
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
                GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
                GenJnlLine.DELETEALL;

                BondSetup.GET;
                BondSetup.TESTFIELD("Cheque Bounce JV No. Series");
                BondSetup.TESTFIELD("Project Change JV Account");
                PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Cheque Bounce JV No. Series", WORKDATE, TRUE); //ALLEDK 260113

                NarrationText1 := 'Project Change JV- ' + COPYSTR(Bond."No.", 1, 30);
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := 10000;
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", WORKDATE);
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");

                CompanywiseGLAccount.RESET;
                CompanywiseGLAccount.SETRANGE("Company Code", Bond."Company Name");
                CompanywiseGLAccount.SETRANGE("MSC Company", FALSE);
                IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                    CompanywiseGLAccount.TESTFIELD(CompanywiseGLAccount."Payable Account");
                END;

                GenJnlLine.VALIDATE("Account No.", CompanywiseGLAccount."Payable Account");
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "; //ALLETDK061212
                GenJnlLine."Document No." := PostedDocNo;
                GenJnlLine."Order Ref No." := Bond."No.";
                GenJnlLine.VALIDATE(Amount, RevAmt);
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Project Change JV Account");
                GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::JV;
                GenJnlLine."Milestone Code" := BondPaymentEntry.Sequence;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine."Shortcut Dimension 1 Code" := Bond."Old Project Code";
                GenJnlLine."Shortcut Dimension 2 Code" := Bond."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
                GenJnlLine.Description := 'Adjustment Amount';
                GenJnlLine.INSERT;
                InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
                  GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
                InsertJnDimension(GenJnlLine); //310113
                PostGenJnlLines;
                ExistAppLines.RESET;
                ExistAppLines.SETRANGE("Document No.", Bond."No.");
                IF ExistAppLines.FINDLAST THEN
                    LineNo := ExistAppLines."Line No.";
                NewInsertAppLines.INIT;
                NewInsertAppLines."Document Type" := NewInsertAppLines."Document Type"::BOND;
                NewInsertAppLines."Document No." := Bond."No.";
                NewInsertAppLines."Line No." := LineNo + 10000;
                NewInsertAppLines.VALIDATE("Payment Mode", NewInsertAppLines."Payment Mode"::JV); //ALLEDK 110213
                NewInsertAppLines.VALIDATE("Payment Method", 'JV');
                NewInsertAppLines.VALIDATE(Amount, -RevAmt);
                NewInsertAppLines."Posted Document No." := PostedDocNo;
                NewInsertAppLines."Posting date" := WORKDATE;
                NewInsertAppLines."Application No." := Bond."No.";
                NewInsertAppLines.INSERT(TRUE);
                NewInsertAppLines."Shortcut Dimension 1 Code" := Bond."Old Project Code";
                IF Bond."JV Posting Date" <> 0D THEN
                    NewInsertAppLines."Posting date" := Bond."JV Posting Date"
                ELSE
                    NewInsertAppLines."Posting date" := WORKDATE;
                NewInsertAppLines.Posted := TRUE;
                NewInsertAppLines."Create from MSC Company" := FALSE;
                NewInsertAppLines.MODIFY;

            END;
        END;
    end;


    procedure PostTACreditMemo(ToVendor: Code[20]; TARevAmt: Decimal; FromProjectChange: Boolean; PostDate_2: Date; OrderRefNo: Code[20]; ProjectCode: Code[20])
    var
        NarrationText1: Text[250];
        Bond: Record "Confirmed Order";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TPmtEntry_1: Record "Travel Payment Entry";
        TPmtEntry_2: Record "Travel Payment Entry";
        PostCreditNote_1: Boolean;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        TAEntry_2: Record "Travel Payment Entry";
        ClbAmt: Decimal;
        "-------------": Integer;
        TDSReversAmount: Decimal;
        TDSEntry: Record "TDS Entry";
        NextTDSEntryNo: Integer;
        TDSGroup: Record "TDS Setup"; //"TDS Setup";
        UnitSetup: Record "Unit Setup";
        TDSPercent: Decimal;
        TDSBaseAmt: Decimal;
        Vendor: Record Vendor;
        //NODLines: Record 13785;//Need to check the code in UAT

        //NatureofDeduction: Record  13726;//Need to check the code in UAT

        CompanyInfo: Record "Company Information";
        StartDate: Date;
        EndDate: Date;
        Year: Integer;
        Month: Integer;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PostPayment: Codeunit PostPayment;
        TDSBaseAmt_1: Decimal;
        TDSBaseAmtNew: Decimal;
        v_ConfirmedOrder: Record "New Confirmed Order";
    begin
        BondSetup.GET;

        //Bond.GET(ApplicationNo);
        UserSetup.GET(USERID);
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;
        BondSetup.TESTFIELD("Refund No. Series");
        DocNo := '';
        IF PostDate_2 = 0D THEN
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", WORKDATE, TRUE)
        ELSE
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", PostDate_2, TRUE);
        //ALLEDK 260113
        NarrationText1 := 'Travel Credit Memo- ' + COPYSTR(ToVendor, 1, 30);
        ClbAmt := 0;
        ClbAmt := ROUND(ABS(TARevAmt * BondSetup."Corpus %" / 100), 0.01, '=');

        IF FromProjectChange THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            IF PostDate_2 = 0D THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", WORKDATE);
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Posting Date", PostDate_2);
                GenJnlLine.VALIDATE("Document Date", PostDate_2);

            END;
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", ToVendor);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"; //ALLETDK061212
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, (ABS(TARevAmt) - ClbAmt));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
            GenJnlLine.VALIDATE("Source No.", ToVendor);
            GenJnlLine."Shortcut Dimension 1 Code" := ProjectCode;   //INS1.0
                                                                     //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center"; //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            //  GenJnlLine."TA Credit Memo" := FALSE;
            GenJnlLine.Description := 'TA Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.INSERT;

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 20000;
            IF PostDate_2 = 0D THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", WORKDATE);
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Posting Date", PostDate_2);
                GenJnlLine.VALIDATE("Document Date", PostDate_2);

            END;

            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."Corpus A/C");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"; //ALLETDK061212
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, ABS(ClbAmt));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
            GenJnlLine.VALIDATE("Source No.", ToVendor);
            // GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0
            GenJnlLine."Shortcut Dimension 1 Code" := ProjectCode;
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            //  GenJnlLine."TA Credit Memo" := FALSE;
            GenJnlLine.Description := 'TA Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.INSERT;

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 30000;
            IF PostDate_2 = 0D THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", WORKDATE);
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Posting Date", PostDate_2);
                GenJnlLine.VALIDATE("Document Date", PostDate_2);

            END;

            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."Commission A/C");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"; //ALLETDK061212
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, -1 * (ABS(TARevAmt)));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
            GenJnlLine.VALIDATE("Source No.", ToVendor);
            //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  INS1.00
            GenJnlLine."Shortcut Dimension 1 Code" := ProjectCode;
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            //  GenJnlLine."TA Credit Memo" := FALSE;
            GenJnlLine.Description := 'TA Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            TAInsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines;

        END ELSE BEGIN

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            IF PostDate_2 = 0D THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", WORKDATE);
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Posting Date", PostDate_2);
                GenJnlLine.VALIDATE("Document Date", PostDate_2);

            END;

            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", ToVendor);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"; //ALLETDK061212
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, ABS(TARevAmt));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
            GenJnlLine.VALIDATE("Source No.", ToVendor);
            //  GenJnlLine."Order Ref No." := ApplicationNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Commission A/C");
            GenJnlLine."Shortcut Dimension 1 Code" := ProjectCode;
            //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            //  GenJnlLine."TA Credit Memo" := TRUE;
            GenJnlLine.Description := 'Travel Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            TAInsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines;
        END;
        TAEntry_2.RESET;
        TAEntry_2.SETCURRENTKEY("Sub Associate Code", "Post Payment");
        TAEntry_2.SETRANGE("Sub Associate Code", ToVendor);
        TAEntry_2.SETRANGE("Post Payment", TRUE);
        TAEntry_2.SETRANGE("Invoice Date", TODAY);
        TAEntry_2.SETRANGE("Voucher No.", '');
        IF TAEntry_2.FINDSET THEN
            REPEAT
                TAEntry_2."Voucher No." := DocNo;
                TAEntry_2.MODIFY;
            UNTIL TAEntry_2.NEXT = 0;



        // ALLE AKUL 060223

        IF FromProjectChange THEN BEGIN
            BondSetup.GET;
            UnitSetup.GET;

            TDSPercent := 0;
            TDSPercent := PostPayment.CalculateTDSPercentage(ToVendor, BondSetup."TDS Nature of Deduction", '');
            TDSReversAmount := 0;
            TDSReversAmount := ABS((TARevAmt * TDSPercent / 100));
            TDSReversAmount := ROUND(TDSReversAmount, 1, '=');
            TDSBaseAmt := ABS(TARevAmt);

            //------------------070223
            StartDate := 0D;
            Year := 0;
            Month := 0;

            Year := DATE2DMY(TODAY, 3);
            Month := DATE2DMY(TODAY, 2);

            IF (Month = 1) OR (Month = 2) OR (Month = 3) THEN
                StartDate := DMY2DATE(1, 1, Year)
            ELSE
                IF (Month = 4) OR (Month = 5) OR (Month = 6) THEN
                    StartDate := DMY2DATE(1, 4, Year)
                ELSE
                    IF (Month = 7) OR (Month = 8) OR (Month = 9) THEN
                        StartDate := DMY2DATE(1, 7, Year)
                    ELSE
                        IF (Month = 10) OR (Month = 11) OR (Month = 12) THEN
                            StartDate := DMY2DATE(1, 10, Year);


            v_ConfirmedOrder.RESET;   //130122
            v_ConfirmedOrder.SETRANGE("No.", OrderRefNo);  //130122
            v_ConfirmedOrder.SETRANGE("Posting Date", StartDate, TODAY);  //130122
            IF v_ConfirmedOrder.FINDFIRST THEN BEGIN  //130122
                TDSBaseAmt_1 := 0;

                TDSEntry.RESET;
                TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date");
                TDSEntry.SETRANGE(TDSEntry."Party Type", TDSEntry."Party Type"::Vendor);
                TDSEntry.SETRANGE(TDSEntry."Party Code", ToVendor);
                TDSEntry.SETRANGE("Posting Date", StartDate, TODAY);
                IF TDSEntry.FINDSET THEN
                    REPEAT
                        TDSBaseAmt_1 := TDSBaseAmt_1 + TDSEntry."TDS Base Amount";
                    UNTIL TDSEntry.NEXT = 0;

                TDSBaseAmtNew := 0;

                IF (TDSBaseAmt_1 - ABS(TDSBaseAmt)) >= 0 THEN BEGIN
                    TDSReversAmount := ABS((TDSBaseAmt * TDSPercent / 100));
                    TDSReversAmount := ROUND(TDSReversAmount, 1, '=');
                    TDSBaseAmtNew := TDSBaseAmt;
                END ELSE BEGIN
                    TDSReversAmount := ABS((TDSBaseAmt_1 * TDSPercent / 100));
                    TDSReversAmount := ROUND(TDSReversAmount, 1, '=');
                    TDSBaseAmtNew := TDSBaseAmt_1;
                END;


                //------------------ 070223



                IF TDSReversAmount <> 0 THEN BEGIN
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                    GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                    GenJnlLine."Line No." := 20000;
                    GenJnlLine.VALIDATE("Posting Date", TODAY);
                    GenJnlLine.VALIDATE("Document Date", TODAY);
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                    GenJnlLine.VALIDATE("Account No.", BondSetup."TDS Payable Commission A/c");
                    GenJnlLine."Document No." := DocNo;
                    GenJnlLine.VALIDATE(Amount, (ABS(TDSReversAmount)));
                    //GenJnlLine.VALIDATE("Source Type",GenJnlLine."Source Type"::"");
                    //GenJnlLine.VALIDATE("Source No.",Associate_1);
                    //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0

                    GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine."Introducer Code" := Bond."Introducer Code";
                    GenJnlLine."External Document No." := DocNo;
                    GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
                    GenJnlLine."Unit No." := Bond."No.";
                    GenJnlLine."Application No." := OrderRefNo;
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Vendor;
                    GenJnlLine."Bal. Account No." := ToVendor;
                    GenJnlLine.Description := 'Comm-TDS/Club 9 Reversal';
                    GenJnlLine."TA/Comm Credit Memo" := TRUE;
                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
                    GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
                    GenJnlLine.INSERT;
                    PostGenJnlLines;
                    CreateTDSEntry(TDSBaseAmtNew, ABS(TDSReversAmount), TODAY, ToVendor, DocNo, TDSPercent);
                END;
            END;
        END;

        // ALLE AKUL 060223
    end;


    procedure PostCommCreditMemo(Associate_1: Code[20]; Amt_1: Decimal; FromProjChange: Boolean; OrderRefNo: Code[20]; PostDate_1: Date; ProjectCode: Code[20])
    var
        NarrationText1: Text[250];
        Bond: Record "Confirmed Order";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CommissionEntry_1: Record "Commission Entry";
        CommissionEntry_2: Record "Commission Entry";
        PostCreditNote_1: Boolean;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        CommEntry_2: Record "Commission Entry";
        ClbAmt: Decimal;
        StartDate: Date;
        EndDate: Date;
        Year: Integer;
        Month: Integer;
    begin

        BondSetup.GET;

        UserSetup.GET(USERID);
        //Bond.GET(CreditCommEntry."Application No.");
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;
        BondSetup.TESTFIELD("Refund No. Series");
        DocNo := '';
        IF PostDate_1 = 0D THEN
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", WORKDATE, TRUE)
        ELSE
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", PostDate_1, TRUE);
        //ALLEDK 260113

        NarrationText1 := 'Commission Credit Memo- ' + COPYSTR(Associate_1, 1, 30);
        ClbAmt := 0;
        ClbAmt := ROUND(ABS(Amt_1 * BondSetup."Corpus %" / 100), 0.01, '=');
        IF FromProjChange THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            IF PostDate_1 = 0D THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", WORKDATE);
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Posting Date", PostDate_1);
                GenJnlLine.VALIDATE("Document Date", PostDate_1);
            END;
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", Associate_1);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"; //ALLETDK061212
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, (ABS(Amt_1) - ClbAmt));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
            GenJnlLine.VALIDATE("Source No.", Associate_1);
            //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0
            GenJnlLine."Shortcut Dimension 1 Code" := ProjectCode;  //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            //  GenJnlLine."TA Credit Memo" := FALSE;
            GenJnlLine.Description := 'Commission Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.INSERT;

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 20000;
            IF PostDate_1 = 0D THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", WORKDATE);
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Posting Date", PostDate_1);
                GenJnlLine.VALIDATE("Document Date", PostDate_1);
            END;
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."Corpus A/C");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"; //ALLETDK061212
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, ABS(ClbAmt));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
            GenJnlLine.VALIDATE("Source No.", Associate_1);
            //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0
            GenJnlLine."Shortcut Dimension 1 Code" := ProjectCode; //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            //  GenJnlLine."TA Credit Memo" := FALSE;
            GenJnlLine.Description := 'Commission Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.INSERT;

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 30000;
            IF PostDate_1 = 0D THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", WORKDATE);
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Posting Date", PostDate_1);
                GenJnlLine.VALIDATE("Document Date", PostDate_1);
            END;
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."Commission A/C");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"; //ALLETDK061212
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, -1 * (ABS(Amt_1)));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
            GenJnlLine.VALIDATE("Source No.", Associate_1);
            GenJnlLine."Shortcut Dimension 1 Code" := ProjectCode; //INS1.0
                                                                   //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode); //INS1.0
                                                                           //  GenJnlLine."TA Credit Memo" := FALSE;
            GenJnlLine.Description := 'Commission Reversal';
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            TAInsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines;

            CommEntry_4.RESET;
            CommEntry_4.SETCURRENTKEY("Application No.", "Direct to Associate", Posted);
            CommEntry_4.SETRANGE("Application No.", OrderRefNo);
            CommEntry_4.SETRANGE(Posted, TRUE);
            CommEntry_4.SETRANGE("Associate Code", Associate_1);
            CommEntry_4.SETRANGE("Voucher No.", '');
            IF CommEntry_4.FINDSET THEN
                REPEAT
                    CommEntry_4."Voucher No." := DocNo;
                    CommEntry_4.MODIFY;
                UNTIL CommEntry_4.NEXT = 0;
        END ELSE BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            IF PostDate_1 = 0D THEN BEGIN
                GenJnlLine.VALIDATE("Posting Date", WORKDATE);
                GenJnlLine.VALIDATE("Document Date", WORKDATE);
            END ELSE BEGIN
                GenJnlLine.VALIDATE("Posting Date", PostDate_1);
                GenJnlLine.VALIDATE("Document Date", PostDate_1);
            END;
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", Associate_1);
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo"; //ALLETDK061212
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, ABS(Amt_1));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
            GenJnlLine.VALIDATE("Source No.", Associate_1);
            //  GenJnlLine."Order Ref No." := CreditCommEntry."Application No.";
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Commission A/C");
            GenJnlLine."Shortcut Dimension 1 Code" := ProjectCode; //INS1.0
                                                                   //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            //  GenJnlLine."TA Credit Memo" := FALSE;
            GenJnlLine.Description := 'Commission Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode); //INS1.0
            GenJnlLine.INSERT;
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            TAInsertJnDimension(GenJnlLine); //310113
            PostGenJnlLines;


            CommEntry_2.RESET;
            CommEntry_2.SETCURRENTKEY("Associate Code", "Direct to Associate", Posted);
            CommEntry_2.SETRANGE("Application No.", OrderRefNo);
            CommEntry_2.SETRANGE("Associate Code", Associate_1);
            CommEntry_2.SETRANGE(Posted, TRUE);
            CommEntry_2.SETRANGE("Invoice Date", TODAY);
            CommEntry_2.SETRANGE("Voucher No.", '');
            IF CommEntry_2.FINDSET THEN
                REPEAT
                    CommEntry_2."Voucher No." := DocNo;
                    CommEntry_2.MODIFY;
                UNTIL CommEntry_2.NEXT = 0;
        END;
    end;


    procedure CheckCostHead(GLAccount: Code[20]): Code[20]
    var
        DefaultDimension: Record "Default Dimension";
        GenLedSetup: Record "General Ledger Setup";
        Dim2Code: Code[20];
    begin
        //ALLEDK 070515
        GenLedSetup.GET;
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", 15);
        DefaultDimension.SETRANGE("No.", GLAccount);
        DefaultDimension.SETFILTER("Value Posting", 'Same Code');
        DefaultDimension.SETFILTER(DefaultDimension."Dimension Code", '%1', GenLedSetup."Global Dimension 2 Code");
        DefaultDimension.SETFILTER(DefaultDimension."Dimension Value Code", '%1', '');
        IF DefaultDimension.FINDFIRST THEN BEGIN
            DefaultDimension.TESTFIELD(DefaultDimension."Dimension Value Code");
        END;

        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", 15);
        DefaultDimension.SETRANGE("No.", GLAccount);
        DefaultDimension.SETFILTER("Value Posting", 'Same Code');
        DefaultDimension.SETFILTER(DefaultDimension."Dimension Code", '%1', GenLedSetup."Global Dimension 2 Code");
        IF DefaultDimension.FINDFIRST THEN BEGIN
            Dim2Code := DefaultDimension."Dimension Value Code";
        END;
        EXIT(Dim2Code);
        //ALLEDK 070515
    end;


    procedure TAInsertJnDimension(RecGenLine: Record "Gen. Journal Line")
    begin
        // ALLE MM Code Commented
        /*
        CLEAR(JournalLineDimension);
        GLSetup.GET;
        UserSetup.GET(USERID);
        CLEAR(JournalLineDimension1);
        JournalLineDimension1.RESET;
        JournalLineDimension1.SETRANGE("Table ID", 81);
        JournalLineDimension1.SETRANGE("Journal Template Name" , RecGenLine."Journal Template Name");
        JournalLineDimension1.SETRANGE("Journal Batch Name" , RecGenLine."Journal Batch Name");
        JournalLineDimension1.SETRANGE("Journal Line No." , RecGenLine."Line No.");
        JournalLineDimension1.SETRANGE("Dimension Code" , GLSetup."Shortcut Dimension 1 Code");
        JournalLineDimension1.SETRANGE("Dimension Value Code" , RecGenLine."Shortcut Dimension 1 Code");
        IF NOT JournalLineDimension1.FINDFIRST THEN BEGIN
          JournalLineDimension.INIT;
          JournalLineDimension."Table ID" := 81;
          JournalLineDimension."Journal Template Name" := RecGenLine."Journal Template Name";
          JournalLineDimension."Journal Batch Name" := RecGenLine."Journal Batch Name";
          JournalLineDimension."Journal Line No." := RecGenLine."Line No.";
          JournalLineDimension."Dimension Code" := GLSetup."Shortcut Dimension 1 Code";
          JournalLineDimension."Dimension Value Code" := RecGenLine."Shortcut Dimension 1 Code";
         JournalLineDimension.INSERT;
        END;
        
        JournalLineDimension1.RESET;
        JournalLineDimension1.SETRANGE("Table ID", 81);
        JournalLineDimension1.SETRANGE("Journal Template Name" , RecGenLine."Journal Template Name");
        JournalLineDimension1.SETRANGE("Journal Batch Name" , RecGenLine."Journal Batch Name");
        JournalLineDimension1.SETRANGE("Journal Line No." , RecGenLine."Line No.");
        JournalLineDimension1.SETRANGE("Dimension Code" , GLSetup."Shortcut Dimension 2 Code");
        JournalLineDimension1.SETRANGE("Dimension Value Code" , RecGenLine."Shortcut Dimension 2 Code");
        IF NOT JournalLineDimension1.FINDFIRST THEN BEGIN
          JournalLineDimension.INIT;
          JournalLineDimension."Table ID" := 81;
          JournalLineDimension."Journal Template Name" := RecGenLine."Journal Template Name";
          JournalLineDimension."Journal Batch Name" := RecGenLine."Journal Batch Name";
          JournalLineDimension."Journal Line No." := RecGenLine."Line No.";
          JournalLineDimension."Dimension Code" := GLSetup."Shortcut Dimension 2 Code";
          JournalLineDimension."Dimension Value Code" := RecGenLine."Shortcut Dimension 2 Code";
         JournalLineDimension.INSERT;
        END;
        */
        // ALLE MM Code Commented

    end;


    procedure InterCompMJVPost(Bond_1: Record "Confirmed Order"; RefPostDate_1: Date; BalAccountno_1: Code[20]; TrfAmount_1: Decimal)
    var
        NarrationText1: Text[100];
        CompanyWise_1: Record "Company wise G/L Account";
        BondPostingGroup1: Record "Customer Posting Group";
    begin
        NarrationText1 := 'MTM Adj. App No.- ' + COPYSTR(Bond_1."Application No.", 1, 30);
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
        GenJnlLine."Line No." := 10000;
        GenJnlLine.VALIDATE("Posting Date", RefPostDate_1);
        GenJnlLine.VALIDATE("Document Date", RefPostDate_1);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", Bond_1."Customer No.");
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" "; //ALLETDK061212
        GenJnlLine."Document No." := Bond_1."Penalty Document No.";
        //GenJnlLine."Bond Posting Group" := Bond."Bond Posting Group";
        GenJnlLine."Bill-to/Pay-to No." := Bond_1."Customer No.";
        GenJnlLine."Order Ref No." := Bond_1."No.";
        GenJnlLine.VALIDATE(Amount, TrfAmount_1);
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Customer);
        GenJnlLine.VALIDATE("Source No.", Bond_1."Customer No.");
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"G/L Account");
        BondPostingGroup1.GET(Bond_1."Bond Posting Group");
        GenJnlLine.VALIDATE("Bal. Account No.", BalAccountno_1);
        GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::"Negative Adjmt.";
        GenJnlLine."Posting Group" := Bond_1."Bond Posting Group";
        GenJnlLine."Order Ref No." := Bond_1."Application No.";
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
        GenJnlLine."Shortcut Dimension 1 Code" := Bond_1."Shortcut Dimension 1 Code";
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
        PostGenJnlLines;
    end;


    procedure CreateTACreditMemo(ToVendor: Code[20]; TARevAmt: Decimal; AppNo_1: Code[20]; ProjectChange1: Boolean)
    var
        NarrationText1: Text[250];
        Bond: Record "Confirmed Order";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TPmtEntry_1: Record "Travel Payment Entry";
        TPmtEntry_2: Record "Travel Payment Entry";
        PostCreditNote_1: Boolean;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        Vend_2: Record Vendor;
        OldProject: Code[20];
        CurrentProject: Code[20];
        TARevAmt_2: Decimal;
        TAInvoiceAmt: Decimal;
        CreatInvoice: Boolean;
        CompanyInformation: Record "Company Information";
    begin
        IF NOT ProjectChange1 THEN BEGIN  //220720
            TPmtEntry_1.RESET;
            TPmtEntry_1.SETRANGE("Post Payment", FALSE);
            TPmtEntry_1.SETRANGE("Application No.", AppNo_1); //110816
            IF TPmtEntry_1.FINDSET THEN
                REPEAT
                    TARevAmt := 0;
                    PostCreditNote_1 := FALSE;
                    TPmtEntry_2.RESET;
                    TPmtEntry_2.SETRANGE("Post Payment", FALSE);
                    TPmtEntry_2.SETRANGE("Sub Associate Code", TPmtEntry_1."Sub Associate Code");
                    TPmtEntry_2.SETRANGE("Application No.", AppNo_1); //110816
                    TPmtEntry_2.SETRANGE("Project Code", TPmtEntry_1."Project Code");
                    IF TPmtEntry_2.FINDSET THEN BEGIN
                        Vend_2.RESET;
                        IF Vend_2.GET(TPmtEntry_2."Sub Associate Code") THEN BEGIN  //150218
                                                                                    //030321
                            CreatInvoice := FALSE;
                            CreatInvoice := TRUE;
                            CompanyInformation.GET;
                            IF CompanyInformation."Development Company Name" = COMPANYNAME THEN BEGIN
                                IF Vend_2."BBG RERA Status" = Vend_2."BBG RERA Status"::Unregistered THEN
                                    CreatInvoice := FALSE;
                            END;
                            //030321
                            IF ((Vend_2."P.A.N. No." <> '') AND (Vend_2."P.A.N. Status" = Vend_2."P.A.N. Status"::" ")) OR (Vend_2."BBG INOPERATIVE PAN") THEN  //271123 Add INOPERATIVE PAN
                                IF (NOT Vend_2."BBG Black List") AND (CreatInvoice) THEN BEGIN  //Add code "AND (Creatinvoice)
                                    REPEAT
                                        TPmtEntry_2."Post Payment" := TRUE;
                                        TARevAmt := TARevAmt + TPmtEntry_2."Amount to Pay";
                                        TPmtEntry_2."Invoice Date" := TODAY;
                                        TPmtEntry_2.MODIFY;
                                    UNTIL TPmtEntry_2.NEXT = 0;
                                    IF TARevAmt < 0 THEN BEGIN
                                        PostTACreditMemo(TPmtEntry_2."Sub Associate Code", ABS(TARevAmt), TRUE, 0D, AppNo_1, TPmtEntry_2."Project Code");
                                    END ELSE
                                        IF TARevAmt > 0 THEN BEGIN
                                            ToVendor := TPmtEntry_2."Sub Associate Code";
                                            CreateCommInvoice.CreateVoucherHeader(ToVendor, TARevAmt, Type_1::TA, 0D, AppNo_1, TPmtEntry_2."Project Code");
                                        END;
                                END;
                        END;
                    END;
                UNTIL TPmtEntry_1.NEXT = 0;

            //220720
        END ELSE BEGIN
            OldProject := '';
            CurrentProject := '';

            TPmtEntry_1.RESET;
            TPmtEntry_1.SETRANGE("Post Payment", FALSE);
            TPmtEntry_1.SETRANGE("Application No.", AppNo_1); //110816
            IF TPmtEntry_1.FINDFIRST THEN
                OldProject := TPmtEntry_1."Project Code";

            TPmtEntry_1.RESET;
            TPmtEntry_1.SETRANGE("Post Payment", FALSE);
            TPmtEntry_1.SETRANGE("Application No.", AppNo_1); //110816
            IF TPmtEntry_1.FINDLAST THEN
                CurrentProject := TPmtEntry_1."Project Code";

            TPmtEntry_1.RESET;
            TPmtEntry_1.SETRANGE("Post Payment", FALSE);
            TPmtEntry_1.SETRANGE("Application No.", AppNo_1); //110816
            IF TPmtEntry_1.FINDSET THEN
                REPEAT
                    TARevAmt := 0;
                    PostCreditNote_1 := FALSE;
                    TPmtEntry_2.RESET;
                    TPmtEntry_2.SETRANGE("Post Payment", FALSE);
                    TPmtEntry_2.SETRANGE("Sub Associate Code", TPmtEntry_1."Sub Associate Code");
                    TPmtEntry_2.SETRANGE("Application No.", AppNo_1); //110816
                    TPmtEntry_2.SETRANGE("Project Code", OldProject);
                    IF TPmtEntry_2.FINDSET THEN BEGIN
                        Vend_2.RESET;
                        IF Vend_2.GET(TPmtEntry_2."Sub Associate Code") THEN BEGIN  //150218
                                                                                    //030321
                            CreatInvoice := FALSE;
                            CreatInvoice := TRUE;
                            CompanyInformation.GET;
                            IF CompanyInformation."Development Company Name" = COMPANYNAME THEN BEGIN
                                IF Vend_2."BBG RERA Status" = Vend_2."BBG RERA Status"::Unregistered THEN
                                    CreatInvoice := FALSE;
                            END;
                            //030321
                            IF (Vend_2."P.A.N. No." <> '') AND (Vend_2."P.A.N. Status" = Vend_2."P.A.N. Status"::" ") THEN
                                IF (CreatInvoice) THEN BEGIN  //Add Code "And (Creatinvoice)" ------- (NOT Vend_2."Black List") AND 171022
                                    REPEAT
                                        TPmtEntry_2."Post Payment" := TRUE;
                                        TARevAmt := TARevAmt + TPmtEntry_2."Amount to Pay";
                                        TPmtEntry_2."Invoice Date" := TODAY;
                                        TPmtEntry_2.MODIFY;
                                    UNTIL TPmtEntry_2.NEXT = 0;
                                    IF TARevAmt < 0 THEN BEGIN
                                        TA_NewPostCommCreditMemo(TPmtEntry_2."Sub Associate Code", ABS(TARevAmt), TRUE, AppNo_1, TODAY, TPmtEntry_2."Project Code");
                                    END;
                                END;
                        END;
                    END;
                    TARevAmt_2 := 0;
                    TPmtEntry_2.RESET;
                    TPmtEntry_2.SETRANGE("Post Payment", FALSE);
                    TPmtEntry_2.SETRANGE("Sub Associate Code", TPmtEntry_1."Sub Associate Code");
                    TPmtEntry_2.SETRANGE("Application No.", AppNo_1); //110816
                    TPmtEntry_2.SETRANGE("Project Code", CurrentProject);
                    IF TPmtEntry_2.FINDSET THEN BEGIN
                        Vend_2.RESET;
                        IF Vend_2.GET(TPmtEntry_2."Sub Associate Code") THEN BEGIN  //150218
                            IF ((Vend_2."P.A.N. No." <> '') AND (Vend_2."P.A.N. Status" = Vend_2."P.A.N. Status"::" ")) OR (Vend_2."BBG INOPERATIVE PAN") THEN //271123 Add INOPERATIVE PAN
                                IF (CreatInvoice) THEN BEGIN   //030321------- (NOT Vend_2."Black List") AND 171022
                                    REPEAT
                                        TPmtEntry_2."Post Payment" := TRUE;
                                        TARevAmt_2 := TARevAmt_2 + TPmtEntry_2."Amount to Pay";
                                        TPmtEntry_2."Invoice Date" := TODAY;
                                        TPmtEntry_2.MODIFY;
                                    UNTIL TPmtEntry_2.NEXT = 0;
                                    TAInvoiceAmt := 0;
                                    IF (TARevAmt + TARevAmt_2) > 0 THEN
                                        TAInvoiceAmt := ABS(TARevAmt)
                                    ELSE
                                        TAInvoiceAmt := TARevAmt_2;
                                    ToVendor := TPmtEntry_2."Sub Associate Code";
                                    IF TAInvoiceAmt > 0 THEN BEGIN
                                        TA_NewPostCommInvoice(ToVendor, TAInvoiceAmt, ProjectChange1, AppNo_1, 0D, TPmtEntry_2."Project Code");
                                        IF (TARevAmt + TARevAmt_2) > 0 THEN
                                            CreateCommInvoice.CreateVoucherHeader(ToVendor, (TARevAmt + TARevAmt_2), Type_1::TA, 0D, AppNo_1, TPmtEntry_2."Project Code");
                                    END;
                                    //            IF (TARevAmt + TARevAmt_2) <0 THEN
                                    //            TA_NewPostCommCreditMemoTDS(ToVendor,(TARevAmt + TARevAmt_2),ProjectChange1,AppNo_1,0D,CurrentProject);
                                END;
                        END;
                    END;
                    IF CreatInvoice THEN BEGIN   //030321
                        IF (TARevAmt + TARevAmt_2) < 0 THEN
                            TA_NewPostCommCreditMemoTDS(ToVendor, (TARevAmt + TARevAmt_2), ProjectChange1, AppNo_1, 0D, CurrentProject);
                    END;    //030321
                UNTIL TPmtEntry_1.NEXT = 0;
        END;
    end;


    procedure CreateCommCreditMemo(OrderNo: Code[20]; FromProjectChange: Boolean)
    var
        NarrationText1: Text[250];
        Bond_1: Record "Confirmed Order";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CommissionEntry_1: Record "Commission Entry";
        CommissionEntry_2: Record "Commission Entry";
        PostCreditNote_1: Boolean;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        Amt_1: Decimal;
        RecConforder: Record "Confirmed Order";
        Vend_2: Record Vendor;
        TotalAmt_1: Decimal;
        OldProject: Code[20];
        CurrentProject: Code[20];
        Amt_2: Decimal;
        InvoiceAmt: Decimal;
        CreatInvoice: Boolean;
        CompanyInformation: Record "Company Information";
        v_AssCode: Code[20];
        UnitSetup: Record "Unit Setup";
    begin
        UnitSetup.Get();
        UnitSetup.TestField("Club9 General Journal Template");
        UnitSetup.TestField("Club9 General Journal Batch");
        //This function is also used in Commission Invoice batch 50009
        IF NOT FromProjectChange THEN BEGIN
            v_AssCode := '';
            CommissionEntry_1.RESET;
            CommissionEntry_1.SETCURRENTKEY("Application No.", "Associate Code");   //130522
            CommissionEntry_1.SETRANGE("Application No.", OrderNo);
            CommissionEntry_1.SETRANGE(Posted, FALSE);
            IF CommissionEntry_1.FINDSET THEN
                REPEAT
                    IF v_AssCode <> CommissionEntry_1."Associate Code" THEN BEGIN   //130522
                        v_AssCode := CommissionEntry_1."Associate Code";    //130522
                        Amt_1 := 0;
                        PostCreditNote_1 := FALSE;
                        CommissionEntry_2.RESET;
                        CommissionEntry_2.SETRANGE("Application No.", OrderNo);
                        CommissionEntry_2.SETRANGE(Posted, FALSE);
                        CommissionEntry_2.SETRANGE("Associate Code", CommissionEntry_1."Associate Code");
                        IF CommissionEntry_2.FINDSET THEN BEGIN
                            Vend_2.RESET;
                            IF Vend_2.GET(CommissionEntry_2."Associate Code") THEN BEGIN
                                ////030321
                                CreatInvoice := FALSE;
                                CreatInvoice := TRUE;
                                CompanyInformation.GET;
                                /*//251121
                                IF CompanyInformation."Development Company Name" = COMPANYNAME THEN BEGIN
                                  IF Vend_2."RERA Status" = Vend_2."RERA Status"::Unregistered THEN
                                    CreatInvoice := FALSE;
                                END;
                                */  //251121
                                    //030321
                                IF ((Vend_2."P.A.N. No." <> '') AND (Vend_2."P.A.N. Status" = Vend_2."P.A.N. Status"::" ")) OR (Vend_2."BBG INOPERATIVE PAN") THEN  //271123 Add INOPERATIVE PAN
                                    IF (NOT Vend_2."BBG Black List") AND (CreatInvoice) THEN BEGIN     //030321 Added Code   "AND (CreatInvoice)"
                                        REPEAT
                                            IF CommissionEntry_2."Direct to Associate" THEN BEGIN
                                                RecConforder.RESET;
                                                RecConforder.SETRANGE("No.", CommissionEntry_2."Application No.");   //BBG1.00 010413
                                                RecConforder.SETRANGE("Registration Bonus Hold(BSP2)", FALSE);     //BBG1.00 010413
                                                IF RecConforder.FINDFIRST THEN BEGIN
                                                    Amt_1 := Amt_1 + CommissionEntry_2."Commission Amount";             //BBG1.00 010413
                                                    CommissionEntry_2.Posted := TRUE;
                                                    CommissionEntry_2."Pmt User ID" := USERID;
                                                    CommissionEntry_2."Pmt Date Time" := CURRENTDATETIME;
                                                    CommissionEntry_2."Invoice Date" := TODAY;
                                                    CommissionEntry_2."TDS Adjust Entry" := TRUE;
                                                    CommissionEntry_2.MODIFY;
                                                END;                                                             //BBG1.00 010413
                                            END ELSE BEGIN
                                                Amt_1 := Amt_1 + CommissionEntry_2."Commission Amount";
                                                CommissionEntry_2.Posted := TRUE;
                                                CommissionEntry_2."Invoice Date" := TODAY;
                                                CommissionEntry_2."TDS Adjust Entry" := TRUE;
                                                CommissionEntry_2.MODIFY;
                                            END;
                                        UNTIL CommissionEntry_2.NEXT = 0;

                                        IF Amt_1 < 0 THEN BEGIN
                                            PostCommCreditMemo(CommissionEntry_2."Associate Code", Amt_1, FromProjectChange, OrderNo, 0D, CommissionEntry_2."Shortcut Dimension 1 Code");
                                        END ELSE
                                            IF Amt_1 > 0 THEN BEGIN
                                                CreateCommInvoice.CreateVoucherHeader(CommissionEntry_2."Associate Code", Amt_1, Type_1::Commission, 0D, OrderNo, CommissionEntry_2."Shortcut Dimension 1 Code");
                                            END;
                                    END;
                            END;
                        END;
                    END;  //130522
                UNTIL CommissionEntry_1.NEXT = 0;
            //BBG2.0
        END ELSE BEGIN
            OldProject := '';
            CurrentProject := '';
            CreatInvoice := FALSE;  //030321
            CommissionEntry_1.RESET;
            CommissionEntry_1.SETCURRENTKEY("Application No.", "Entry No.");
            CommissionEntry_1.SETRANGE("Application No.", OrderNo);
            CommissionEntry_1.SETRANGE(Posted, FALSE);
            IF CommissionEntry_1.FINDFIRST THEN
                OldProject := CommissionEntry_1."Shortcut Dimension 1 Code";

            CommissionEntry_2.RESET;
            CommissionEntry_2.SETCURRENTKEY("Application No.", "Entry No.");
            CommissionEntry_2.SETRANGE("Application No.", OrderNo);
            CommissionEntry_2.SETRANGE(Posted, FALSE);
            IF CommissionEntry_2.FINDLAST THEN
                CurrentProject := CommissionEntry_2."Shortcut Dimension 1 Code";
            v_AssCode := '';
            CommissionEntry_1.RESET;
            CommissionEntry_1.SETRANGE("Application No.", OrderNo);
            CommissionEntry_1.SETRANGE(Posted, FALSE);
            IF CommissionEntry_1.FINDSET THEN BEGIN
                REPEAT
                    IF v_AssCode <> CommissionEntry_1."Associate Code" THEN BEGIN   //130522
                        v_AssCode := CommissionEntry_1."Associate Code";    //130522
                        Amt_1 := 0;
                        CommissionEntry_2.RESET;
                        CommissionEntry_2.SETRANGE("Application No.", OrderNo);
                        CommissionEntry_2.SETRANGE(Posted, FALSE);
                        CommissionEntry_2.SETRANGE("Associate Code", CommissionEntry_1."Associate Code");
                        CommissionEntry_2.SETRANGE("Shortcut Dimension 1 Code", OldProject);  //INS1.0
                        IF CommissionEntry_2.FINDSET THEN BEGIN
                            Vend_2.RESET;
                            IF Vend_2.GET(CommissionEntry_2."Associate Code") THEN BEGIN
                                ////030321
                                CreatInvoice := FALSE;
                                CreatInvoice := TRUE;
                                CompanyInformation.GET;
                                /* //251121
                                IF CompanyInformation."Development Company Name" = COMPANYNAME THEN BEGIN
                                  IF Vend_2."RERA Status" = Vend_2."RERA Status"::Unregistered THEN
                                    CreatInvoice := FALSE;
                                END;
                                */  //251121
                                    //030321
                                IF ((Vend_2."P.A.N. No." <> '') AND (Vend_2."P.A.N. Status" = Vend_2."P.A.N. Status"::" ")) OR (Vend_2."BBG INOPERATIVE PAN") THEN  //271123 Add INOPERATIVE PAN
                                    IF (CreatInvoice) THEN BEGIN   //Added code "And (creatinvoice)'  030321 ---- // (NOT Vend_2."Black List") AND 171022
                                        REPEAT
                                            IF CommissionEntry_2."Direct to Associate" THEN BEGIN
                                                RecConforder.RESET;
                                                RecConforder.SETRANGE("No.", CommissionEntry_2."Application No.");   //BBG1.00 010413
                                                RecConforder.SETRANGE("Registration Bonus Hold(BSP2)", FALSE);     //BBG1.00 010413
                                                IF RecConforder.FINDFIRST THEN BEGIN
                                                    Amt_1 := Amt_1 + CommissionEntry_2."Commission Amount";             //BBG1.00 010413
                                                    CommissionEntry_2.Posted := TRUE;
                                                    CommissionEntry_2."Pmt User ID" := USERID;
                                                    CommissionEntry_2."Pmt Date Time" := CURRENTDATETIME;
                                                    CommissionEntry_2."Invoice Date" := TODAY;
                                                    CommissionEntry_2.MODIFY;
                                                END;                                                             //BBG1.00 010413
                                            END ELSE BEGIN
                                                Amt_1 := Amt_1 + CommissionEntry_2."Commission Amount";
                                                CommissionEntry_2.Posted := TRUE;
                                                CommissionEntry_2."Invoice Date" := TODAY;
                                                CommissionEntry_2.MODIFY;
                                            END;
                                        UNTIL CommissionEntry_2.NEXT = 0;
                                        IF Amt_1 < 0 THEN
                                            NewPostCommCreditMemo(CommissionEntry_2."Associate Code", Amt_1, FromProjectChange, OrderNo, 0D, CommissionEntry_2."Shortcut Dimension 1 Code")
                                        ELSE
                                            IF Amt_1 > 0 THEN
                                                CreateCommInvoice.CreateVoucherHeader(CommissionEntry_2."Associate Code", Amt_1, Type_1::Commission, 0D, OrderNo, CommissionEntry_2."Shortcut Dimension 1 Code");
                                    END;
                            END;
                        END;

                        Amt_2 := 0;
                        CommissionEntry_2.RESET;
                        CommissionEntry_2.SETRANGE("Application No.", OrderNo);
                        CommissionEntry_2.SETRANGE(Posted, FALSE);
                        CommissionEntry_2.SETRANGE("Associate Code", CommissionEntry_1."Associate Code");
                        CommissionEntry_2.SETRANGE("Shortcut Dimension 1 Code", CurrentProject);  //INS1.0
                        IF CommissionEntry_2.FINDSET THEN BEGIN
                            Vend_2.RESET;
                            IF Vend_2.GET(CommissionEntry_2."Associate Code") THEN BEGIN
                                IF ((Vend_2."P.A.N. No." <> '') AND (Vend_2."P.A.N. Status" = Vend_2."P.A.N. Status"::" ")) OR (Vend_2."BBG INOPERATIVE PAN") THEN  //271123 Add INOPERATIVE PAN
                                    IF (CreatInvoice) THEN BEGIN   //Add Code -  "AND (Creatinvoice)"  030321 -------//(NOT Vend_2."Black List") AND  171022
                                        REPEAT
                                            IF CommissionEntry_2."Direct to Associate" THEN BEGIN
                                                RecConforder.RESET;
                                                RecConforder.SETRANGE("No.", CommissionEntry_2."Application No.");   //BBG1.00 010413
                                                RecConforder.SETRANGE("Registration Bonus Hold(BSP2)", FALSE);     //BBG1.00 010413
                                                IF RecConforder.FINDFIRST THEN BEGIN
                                                    Amt_2 := Amt_2 + CommissionEntry_2."Commission Amount";             //BBG1.00 010413
                                                    CommissionEntry_2.Posted := TRUE;
                                                    CommissionEntry_2."Pmt User ID" := USERID;
                                                    CommissionEntry_2."Pmt Date Time" := CURRENTDATETIME;
                                                    CommissionEntry_2."Invoice Date" := TODAY;
                                                    CommissionEntry_2.MODIFY;
                                                END;                                                             //BBG1.00 010413
                                            END ELSE BEGIN
                                                Amt_2 := Amt_2 + CommissionEntry_2."Commission Amount";
                                                CommissionEntry_2.Posted := TRUE;
                                                CommissionEntry_2."Invoice Date" := TODAY;
                                                CommissionEntry_2.MODIFY;
                                            END;
                                        UNTIL CommissionEntry_2.NEXT = 0;
                                        InvoiceAmt := 0;

                                        IF (Amt_1 = 0) THEN BEGIN   //160322 New Code
                                            IF Amt_2 <> 0 THEN     //160522
                                                CreateCommInvoice.CreateVoucherHeader(CommissionEntry_2."Associate Code", Amt_2, Type_1::Commission, 0D, OrderNo, CommissionEntry_2."Shortcut Dimension 1 Code");   //160322 New Code
                                        END ELSE BEGIN
                                            IF Amt_2 <> 0 THEN BEGIN            //180522 New Code
                                                IF (Amt_1 + Amt_2) > 0 THEN
                                                    InvoiceAmt := ABS(Amt_1)
                                                ELSE
                                                    InvoiceAmt := Amt_2;
                                            END;
                                            IF InvoiceAmt > 0 THEN BEGIN
                                                NewPostCommInvoice(CommissionEntry_2."Associate Code", InvoiceAmt, FromProjectChange, OrderNo, 0D, CommissionEntry_2."Shortcut Dimension 1 Code");
                                                IF (Amt_1 + Amt_2) > 0 THEN
                                                    CreateCommInvoice.CreateVoucherHeader(CommissionEntry_2."Associate Code", Amt_1 + Amt_2, Type_1::Commission, 0D, OrderNo, CommissionEntry_2."Shortcut Dimension 1 Code");
                                            END;
                                        END;        //160322 New Code
                                                    //  IF (Amt_1+Amt_2) <0 THEN
                                                    //  NewPostCommCreditMemoTDS(CommissionEntry_2."Associate Code",Amt_1+Amt_2,FromProjectChange,OrderNo,0D,CurrentProject);
                                    END;
                            END;
                        END;
                        IF CreatInvoice THEN BEGIN   //030321
                            IF (Amt_1 + Amt_2) < 0 THEN
                                NewPostCommCreditMemoTDS(CommissionEntry_2."Associate Code", Amt_1 + Amt_2, FromProjectChange, OrderNo, 0D, CurrentProject);
                        END;  //030321

                    END;  //130522

                UNTIL CommissionEntry_1.NEXT = 0;

            END;

        END;
        //BBG2.0

    end;


    procedure CreateProjectChangeEntriesTR(ConfOrderCode_1: Code[20]; LineNo_1: Integer)
    var
        AppPayEntry_1: Record "Application Payment Entry";
        NewAppPayEntry_1: Record "NewApplication Payment Entry";
    begin
        AppPayEntry_1.SETRANGE("Document No.", ConfOrderCode_1);
        AppPayEntry_1.SETFILTER("Line No.", '>=%1', LineNo_1);
        IF AppPayEntry_1.FINDSET THEN BEGIN
            REPEAT
                NewAppPayEntry_1.RESET;
                NewAppPayEntry_1.SETRANGE(NewAppPayEntry_1."Document No.", ConfOrderCode_1);
                IF NewAppPayEntry_1.FINDLAST THEN;
                NewAppPayEntry_1.RESET;
                NewAppPayEntry_1.INIT;
                NewAppPayEntry_1."Document Type" := AppPayEntry_1."Document Type";
                NewAppPayEntry_1."Document No." := AppPayEntry_1."Document No.";
                NewAppPayEntry_1."Line No." := NewAppPayEntry_1."Line No." + 10000;
                NewAppPayEntry_1.VALIDATE("Payment Mode", AppPayEntry_1."Payment Mode"); //ALLEDK 110213
                NewAppPayEntry_1.VALIDATE("Payment Method", AppPayEntry_1."Payment Method");
                NewAppPayEntry_1.VALIDATE(Amount, AppPayEntry_1.Amount);
                NewAppPayEntry_1."Posted Document No." := AppPayEntry_1."Posted Document No.";
                NewAppPayEntry_1."Posting date" := AppPayEntry_1."Posting date";
                NewAppPayEntry_1."Application No." := AppPayEntry_1."Document No.";
                //NewAppPayEntry_1.INSERT(TRUE);
                NewAppPayEntry_1."Shortcut Dimension 1 Code" := AppPayEntry_1."Shortcut Dimension 1 Code";
                NewAppPayEntry_1.Posted := TRUE;
                NewAppPayEntry_1."Create from MSC Company" := FALSE;
                NewAppPayEntry_1."Document Date" := AppPayEntry_1."Document Date";
                NewAppPayEntry_1.INSERT;
            UNTIL AppPayEntry_1.NEXT = 0;
        END;
    end;


    procedure ReverseTARefundCase(AppNo: Code[20])
    var
        ArchiveConfOrder: Record "Archive Confirmed Order";
        TravelPayDetails: Record "Travel Payment Details";
        TravelPaymentEntry: Record "Travel Payment Entry";
        TravelPaymentEntry1: Record "Travel Payment Entry";
        COrd: Record "Confirmed Order";
        LNo: Decimal;
        TravelDocumentNo: Code[20];
    begin
        COrd.GET(AppNo);
        TravelDocumentNo := '';
        TravelPayDetails.RESET;
        TravelPayDetails.SETRANGE("Application No.", AppNo);
        TravelPayDetails.SETRANGE(Approved, TRUE);
        TravelPayDetails.SETRANGE(Reverse, FALSE);
        IF TravelPayDetails.FINDLAST THEN
            TravelDocumentNo := TravelPayDetails."Document No.";

        CLEAR(TravelPayDetails);
        TravelPayDetails.RESET;
        TravelPayDetails.SETRANGE("Application No.", AppNo);
        TravelPayDetails.SETRANGE(Approved, TRUE);
        TravelPayDetails.SETRANGE(Reverse, FALSE);
        TravelPayDetails.SETRANGE("Document No.", TravelDocumentNo);
        IF TravelPayDetails.FINDLAST THEN BEGIN
            CLEAR(LNo);

            CLEAR(TravelPaymentEntry);
            TravelPaymentEntry.RESET;
            TravelPaymentEntry.SETRANGE("Document No.", TravelPayDetails."Document No.");
            IF TravelPaymentEntry.FINDLAST THEN
                LNo := TravelPaymentEntry."Line No.";

            //DK
            LineNo_1 := 0;
            AssCode_1 := '';

            TravelPaymentEntry_1.RESET;
            TravelPaymentEntry_1.SETCURRENTKEY("Sub Associate Code");
            TravelPaymentEntry_1.SETRANGE("Document No.", TravelPayDetails."Document No.");
            TravelPaymentEntry_1.SETRANGE(Approved, TRUE);
            TravelPaymentEntry_1.SETRANGE(Reverse, FALSE);
            TravelPaymentEntry_1.SETFILTER("Amount to Pay", '>%1', 0);
            IF TravelPaymentEntry_1.FINDSET THEN
                REPEAT
                    IF AssCode_1 <> TravelPaymentEntry_1."Sub Associate Code" THEN BEGIN
                        LineNo_1 := TravelPaymentEntry_1."Line No.";
                        AssCode_1 := TravelPaymentEntry_1."Sub Associate Code";


                        TravelPaymentEntry.RESET;
                        TravelPaymentEntry.SETRANGE("Document No.", TravelPayDetails."Document No.");
                        TravelPaymentEntry.SETRANGE(Approved, TRUE);
                        TravelPaymentEntry.SETRANGE("Line No.", LineNo_1);
                        TravelPaymentEntry.SETRANGE("Sub Associate Code", AssCode_1);
                        //    TravelPaymentEntry.SETRANGE(Reverse,FALSE);
                        //    TravelPaymentEntry.SETRANGE("Appl. Not Show on Travel Form",FALSE);
                        //  TravelPaymentEntry.SETFILTER("Amount to Pay",'<>%1',0);
                        IF TravelPaymentEntry.FINDFIRST THEN BEGIN
                            LNo := LNo + 1000;
                            TravelPaymentEntry1.RESET;
                            TravelPaymentEntry1.INIT;
                            TravelPaymentEntry1.COPY(TravelPaymentEntry);
                            TravelPaymentEntry1."Line No." := LNo;
                            TravelPaymentEntry1.INSERT;
                            TravelPaymentEntry1."Total Area" := TravelPayDetails."Saleable Area";
                            TravelPaymentEntry1."Amount to Pay" := -TravelPayDetails."Saleable Area" * TravelPaymentEntry1."TA Rate";
                            //  TravelPaymentEntry1."Amount to Pay" := -TravelPaymentEntry1."Amount to Pay"; 18/11/2014
                            TravelPaymentEntry1."Post Payment" := FALSE;
                            TravelPaymentEntry1."Application No." := AppNo;
                            TravelPaymentEntry1.Reverse := TRUE;
                            TravelPaymentEntry1."Remaining Amount" := 0;   //BBG1.00 040513
                            TravelPaymentEntry1.MODIFY;

                            TAAppwiseDet1.RESET;
                            TAAppwiseDet1.SETRANGE("Document No.", TravelPayDetails."Document No.");
                            TAAppwiseDet1.SETRANGE("TA Detail Line No.", TravelPayDetails."Line no.");
                            IF TAAppwiseDet1.FINDLAST THEN
                                LineNo := TAAppwiseDet1."Line No."
                            ELSE
                                LineNo := 0;

                            TAAppwiseDet.INIT;
                            TAAppwiseDet."Document No." := TravelPaymentEntry."Document No.";
                            TAAppwiseDet."Line No." := LineNo + 1000;
                            TAAppwiseDet."TA Detail Line No." := TravelPayDetails."Line no.";
                            TAAppwiseDet."Application No." := TravelPayDetails."Application No.";
                            TAAppwiseDet."Application Date" := TravelPayDetails."Posting Date";
                            TAAppwiseDet."Introducer Code" := TravelPayDetails."Associate Code";
                            TAAppwiseDet."Introducer Name" := TravelPayDetails."Associate Name";
                            TAAppwiseDet."Associate UpLine Code" := TravelPaymentEntry."Sub Associate Code";
                            TAAppwiseDet."Associate Name" := TravelPaymentEntry."Sub Associate Name";
                            TAAppwiseDet."TA Rate" := TravelPaymentEntry."TA Rate";
                            TAAppwiseDet."TA Generation Date" := TODAY;
                            TAAppwiseDet."TA Amount" := -TravelPayDetails."Saleable Area" * TravelPaymentEntry1."TA Rate";
                            ;
                            TAAppwiseDet."Saleable Area" := TravelPayDetails."Saleable Area";
                            TAAppwiseDet.INSERT;
                            //BBG1.2 231213
                        END;
                    END;
                UNTIL TravelPaymentEntry_1.NEXT = 0;
            TravelPayDetails.Reverse := TRUE;
            TravelPayDetails.MODIFY;
            COrd."Travel Generate" := FALSE;
            COrd.MODIFY;

            AssociateHierarcywithApp.RESET;
            AssociateHierarcywithApp.SETRANGE("Application Code", AppNo);
            IF AssociateHierarcywithApp.FINDSET THEN
                AssociateHierarcywithApp.MODIFYALL("Travel Generated", FALSE);
        END;
    end;


    procedure ReverseTABankRecoCase(AppNo: Code[20])
    var
        ArchiveConfOrder: Record "Archive Confirmed Order";
        TravelPayDetails: Record "Travel Payment Details";
        TravelPaymentEntry: Record "Travel Payment Entry";
        TravelPaymentEntry1: Record "Travel Payment Entry";
        COrd: Record "Confirmed Order";
        LNo: Decimal;
        TravelDocumentNo: Code[20];
    begin
        COrd.GET(AppNo);
        TravelDocumentNo := '';
        IF NOT COrd."Travel Generate" THEN BEGIN
            TravelDocumentNo := '';
            TravelPayDetails.RESET;
            TravelPayDetails.SETRANGE("Application No.", AppNo);
            TravelPayDetails.SETRANGE(Approved, TRUE);
            TravelPayDetails.SETRANGE(Reverse, FALSE);
            IF TravelPayDetails.FINDLAST THEN
                TravelDocumentNo := TravelPayDetails."Document No.";
            IF TravelDocumentNo <> '' THEN BEGIN
                CLEAR(TravelPayDetails);
                TravelPayDetails.RESET;
                TravelPayDetails.SETRANGE("Application No.", AppNo);
                TravelPayDetails.SETRANGE(Approved, TRUE);
                TravelPayDetails.SETRANGE(Reverse, FALSE);
                TravelPayDetails.SETRANGE("Document No.", TravelDocumentNo);
                IF TravelPayDetails.FINDLAST THEN BEGIN
                    CLEAR(LNo);

                    CLEAR(TravelPaymentEntry);
                    TravelPaymentEntry.RESET;
                    TravelPaymentEntry.SETRANGE("Document No.", TravelPayDetails."Document No.");
                    IF TravelPaymentEntry.FINDLAST THEN
                        LNo := TravelPaymentEntry."Line No.";

                    TravelPaymentEntry.RESET;
                    TravelPaymentEntry.SETRANGE("Document No.", TravelPayDetails."Document No.");
                    TravelPaymentEntry.SETRANGE(Approved, TRUE);
                    TravelPaymentEntry.SETRANGE(Reverse, FALSE);
                    TravelPaymentEntry.SETRANGE("Appl. Not Show on Travel Form", FALSE);
                    TravelPaymentEntry.SETFILTER("Amount to Pay", '<>%1', 0);
                    IF TravelPaymentEntry.FINDSET THEN
                        REPEAT
                            LNo := LNo + 1000;
                            TravelPaymentEntry1.RESET;
                            TravelPaymentEntry1.INIT;
                            TravelPaymentEntry1.COPY(TravelPaymentEntry);
                            TravelPaymentEntry1."Line No." := LNo;
                            TravelPaymentEntry1.INSERT;
                            TravelPaymentEntry1."Total Area" := TravelPayDetails."Saleable Area";
                            TravelPaymentEntry1."Amount to Pay" := TravelPayDetails."Saleable Area" * TravelPaymentEntry1."TA Rate";
                            TravelPaymentEntry1."Post Payment" := FALSE;
                            TravelPaymentEntry1."Application No." := AppNo;
                            TravelPaymentEntry1."Remaining Amount" := 0;   //BBG1.00 040513
                            TravelPaymentEntry1.MODIFY;

                            TAAppwiseDet1.RESET;
                            TAAppwiseDet1.SETRANGE("Document No.", TravelPayDetails."Document No.");
                            TAAppwiseDet1.SETRANGE("TA Detail Line No.", TravelPayDetails."Line no.");
                            IF TAAppwiseDet1.FINDLAST THEN
                                LineNo := TAAppwiseDet1."Line No."
                            ELSE
                                LineNo := 0;

                            TAAppwiseDet.INIT;
                            TAAppwiseDet."Document No." := TravelPaymentEntry."Document No.";
                            TAAppwiseDet."Line No." := LineNo + 1000;
                            TAAppwiseDet."TA Detail Line No." := TravelPayDetails."Line no.";
                            TAAppwiseDet."Application No." := TravelPayDetails."Application No.";
                            TAAppwiseDet."Application Date" := TravelPayDetails."Posting Date";
                            TAAppwiseDet."Introducer Code" := TravelPayDetails."Associate Code";
                            TAAppwiseDet."Introducer Name" := TravelPayDetails."Associate Name";
                            TAAppwiseDet."Associate UpLine Code" := TravelPaymentEntry."Sub Associate Code";
                            TAAppwiseDet."Associate Name" := TravelPaymentEntry."Sub Associate Name";
                            TAAppwiseDet."TA Rate" := TravelPaymentEntry."TA Rate";
                            TAAppwiseDet."TA Generation Date" := TODAY;
                            TAAppwiseDet."TA Amount" := TravelPayDetails."Saleable Area" * TravelPaymentEntry1."TA Rate";
                            ;
                            TAAppwiseDet."Saleable Area" := TravelPayDetails."Saleable Area";
                            TAAppwiseDet.INSERT;
                        //BBG1.2 231213

                        UNTIL TravelPaymentEntry.NEXT = 0;
                    TravelPayDetails.MODIFY;
                    COrd."Travel Generate" := TRUE;
                    COrd.MODIFY;

                    AssociateHierarcywithApp.RESET;
                    AssociateHierarcywithApp.SETRANGE("Application Code", AppNo);
                    IF AssociateHierarcywithApp.FINDSET THEN
                        AssociateHierarcywithApp.MODIFYALL("Travel Generated", FALSE);
                END;
            END;
        END;
    end;

    local procedure "-------------------------"()
    begin
    end;


    procedure ProjectChanges(ConfirmedOrder_2: Record "Confirmed Order")
    var
        Vend_1: Record Vendor;
        APE: Record "Application Payment Entry";
        CreatUPEryfromConfOrderAPP: Codeunit "Creat UPEry from ConfOrder/APP";
        VersionNo: Integer;
        BReversal: Codeunit "Unit Reversal";
        CommisionGen: Codeunit "Unit and Comm. Creation Job";
        OldUPEntry: Record "Unit Payment Entry";
        CommHold: Boolean;
        ComHoldDate: Date;
        CommEntry_1: Record "Commission Entry";
        AppPayentry_1: Record "Application Payment Entry";
        OldAppExists: Record Application;
        ProjectMilestoneHdr: Record "Project Milestone Header";
        UpdateChargesAssPmt: Codeunit "UpdateCharges /Post/Rev AssPmt";
        UPName: Text[30];
        TotalValue: Decimal;
        TotalFixed: Decimal;
        AlltAmount: Decimal;
        ProjMilestoneLine: Record "Project Milestone Line";
        Memberof: Record "Access Control";
        AmountToWords: Codeunit "Amount To Words";
        AmountText1: array[2] of Text[300];
        ApplicationForm: Page Application;
        Companywise: Record "Company wise G/L Account";
        OldUnitMaster: Record "Unit Master";
        Newconforder: Record "New Confirmed Order";
        NPaymentPlanDetails: Record "Payment Plan Details";
        NPaymentPlanDetails1: Record "Archive Payment Plan Details";
        NApplicableCharges: Record "Applicable Charges";
        NApplicableCharges1: Record "Archive Applicable Charges";
        NArchivePaymentTermsLine: Record "Payment Terms Line Sale";
        NArchivePaymentTermsLine1: Record "Archive Payment Terms Line";
        UnitCommCreationJob: Codeunit "Unit and Comm. Creation Job";
        UnitPost: Codeunit "Unit Post";
        UnitPaymentEntry: Record "Unit Payment Entry";
        BondReversal: Codeunit "Unit Reversal";
        OldUPmtEntry: Record "Unit Payment Entry";
        RecCommissionEntry: Record "Commission Entry";
        ArchiveConfirmedOrder: Record "Archive Confirmed Order";
    begin
        ConfirmedOrder_2.TESTFIELD("Application Transfered", FALSE);

        //ALLECK 060313 START
        Memberof.RESET;
        Memberof.SETRANGE(Memberof."User Name", USERID);
        Memberof.SETRANGE(Memberof."Role ID", 'A_UNITCHANGE');
        IF NOT Memberof.FINDFIRST THEN
            ERROR('You do not have permission of role :A_UNITCHANGE');
        //ALLECK 060313 End

        //ERROR('Please contact to Admin');
        Vend_1.RESET;
        Vend_1.SETRANGE("No.", ConfirmedOrder_2."Introducer Code");
        IF Vend_1.FINDFIRST THEN
            Vend_1.TESTFIELD("BBG Black List", FALSE);


        OldAppExists.RESET;
        OldAppExists.SETRANGE("Application No.", ConfirmedOrder_2."No.");
        IF OldAppExists.FINDFIRST THEN
            OldAppExists.DELETE;
        ConfirmedOrder_2.TESTFIELD("Project change Comment");
        ConfirmedOrder_2.TESTFIELD("New Unit Payment Plan");

        ProjectMilestoneHdr.RESET;
        ProjectMilestoneHdr.SETRANGE("Project Code", ConfirmedOrder_2."New Project");
        IF ProjectMilestoneHdr.FINDSET THEN BEGIN
            REPEAT
                ProjectMilestoneHdr.TESTFIELD(Status, ProjectMilestoneHdr.Status::Release);
                ProjMilestoneLine.RESET;
                ProjMilestoneLine.SETRANGE("Document No.", ProjectMilestoneHdr."Document No.");
                ProjMilestoneLine.SETRANGE(Code, 'PPLAN');
                IF NOT ProjMilestoneLine.FINDFIRST THEN
                    ERROR('Please define PPlan on Project milstone setup for document No. - ' + FORMAT(ProjectMilestoneHdr."Document No."));
            UNTIL ProjectMilestoneHdr.NEXT = 0;
        END ELSE
            ERROR('Please define Project milestone for Project Code' + ' ' + ConfirmedOrder_2."New Project");

        IF ConfirmedOrder_2."Introducer Code" <> 'IBA9999999' THEN BEGIN
            TotAppAmt := 0;
            IF ConfirmedOrder_2."User Id" = '1003' THEN BEGIN
                AppPaymentEntry.RESET;
                AppPaymentEntry.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                AppPaymentEntry.SETRANGE("User ID", '1003');
                IF AppPaymentEntry.FINDSET THEN
                    REPEAT
                        TotAppAmt += AppPaymentEntry.Amount;
                    UNTIL AppPaymentEntry.NEXT = 0;
                //IF TotAppAmt >= "Min. Allotment Amount" THEN BEGIN
                IF TotAppAmt >= CommisionGen.CheckMinAmountOpng(ConfirmedOrder_2) THEN BEGIN
                    IF ConfirmedOrder_2."User Id" = '1003' THEN BEGIN
                        CommissionEntry.RESET;
                        CommissionEntry.SETRANGE("Application No.", ConfirmedOrder_2."No.");
                        CommissionEntry.SETRANGE("Opening Entries", TRUE);
                        CommissionEntry.SETFILTER("Commission Amount", '<>%1', 0);
                        IF NOT CommissionEntry.FINDFIRST THEN
                            ERROR('Please create Commission for opening Application');
                    END;
                END;
            END;
        END;
        APE.RESET;
        APE.SETRANGE("Document No.", ConfirmedOrder_2."No.");
        APE.SETRANGE(Posted, FALSE);
        IF APE.FINDFIRST THEN
            ERROR('Post/Delete Unposted %1 Entries', FORMAT(APE."Payment Mode"));

        APE.RESET;
        APE.SETRANGE("Document No.", ConfirmedOrder_2."No.");
        APE.SETRANGE("Cheque Status", APE."Cheque Status"::" ");
        IF APE.FINDFIRST THEN
            ERROR('Pending Cheques must be Cleared/Bounced');


        IF CONFIRM('Do you want to upload new unit?', TRUE) THEN BEGIN
            //ALLECK 020313 START
            AmountToWords.InitTextVariable;
            AmountToWords.FormatNoText(AmountText1, ApplicationForm.CheckPaymentAmount(ConfirmedOrder_2."No."), '');
            IF CONFIRM(STRSUBSTNO(Text013, ConfirmedOrder_2."Unit Code", ConfirmedOrder_2."New Unit No.")) THEN BEGIN
                IF CONFIRM(Text006) THEN BEGIN //ALLECK020313
                                               //ALLECK 020313 END
                    Companywise.RESET;
                    Companywise.SETRANGE("MSC Company", TRUE);
                    IF Companywise.FINDFIRST THEN;
                    OldUnitMaster.RESET;
                    OldUnitMaster.CHANGECOMPANY(Companywise."Company Code");
                    OldUnitMaster.SETRANGE("Project Code", ConfirmedOrder_2."New Project");
                    OldUnitMaster.SETRANGE("No.", ConfirmedOrder_2."New Unit No.");
                    IF NOT OldUnitMaster.FINDFIRST THEN
                        ERROR('The MSCompany have not this unit. Please update in MSCompany')
                    ELSE
                        OldUnitMaster.TESTFIELD(Status, OldUnitMaster.Status::Open);


                    IF ConfirmedOrder_2."Application Type" = ConfirmedOrder_2."Application Type"::"Non Trading" THEN BEGIN
                        IF Newconforder.GET(ConfirmedOrder_2."No.") THEN
                            IF Newconforder."Project Change" THEN
                                ERROR('Please run the Replication batch for Project Change in MSCompany');
                    END;
                    ConfirmedOrder_2.Status := ConfirmedOrder_2.Status::Open;
                    ConfirmedOrder_2.MODIFY;

                    CLEAR(ProjChngJVAmt);
                    APE.RESET;
                    APE.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                    APE.SETRANGE("Cheque Status", APE."Cheque Status"::Cleared);
                    APE.SETRANGE(Posted, TRUE);
                    IF APE.FINDSET THEN
                        REPEAT
                            ProjChngJVAmt += APE.Amount;
                        UNTIL APE.NEXT = 0;

                    CLEAR(APE);
                    APE.RESET;
                    APE.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                    APE.SETRANGE("Cheque Status", APE."Cheque Status"::Cleared);
                    IF APE.FINDLAST THEN
                        PostPayment.CreateProjectChangeLines(APE, FALSE, ProjChngJVAmt);

                    CLEAR(VersionNo);
                    ConfirmedOrder_2.TESTFIELD(Type, ConfirmedOrder_2.Type::Normal);
                    ConfirmedOrder_2.TESTFIELD("New Unit No.");
                    NPaymentPlanDetails1.RESET;
                    NPaymentPlanDetails1.SETCURRENTKEY("Document No.", "Version No.");
                    NPaymentPlanDetails1.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                    IF NPaymentPlanDetails1.FINDSET THEN
                        REPEAT
                            IF VersionNo < NPaymentPlanDetails1."Version No." THEN
                                VersionNo := NPaymentPlanDetails1."Version No.";
                        UNTIL NPaymentPlanDetails1.NEXT = 0;

                    NPaymentPlanDetails.RESET;
                    NPaymentPlanDetails.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                    IF NPaymentPlanDetails.FINDSET THEN
                        REPEAT

                            NPaymentPlanDetails1.RESET;
                            NPaymentPlanDetails1.SETRANGE("Project Code", NPaymentPlanDetails."Project Code");
                            NPaymentPlanDetails1.SETRANGE("Payment Plan Code", NPaymentPlanDetails."Payment Plan Code");
                            NPaymentPlanDetails1.SETRANGE("Milestone Code", NPaymentPlanDetails."Milestone Code");
                            NPaymentPlanDetails1.SETRANGE("Charge Code", NPaymentPlanDetails."Charge Code");
                            NPaymentPlanDetails1.SETRANGE("Document No.", NPaymentPlanDetails."Document No.");
                            NPaymentPlanDetails1.SETRANGE("Sale/Lease", NPaymentPlanDetails."Sale/Lease");
                            NPaymentPlanDetails1.SETRANGE("Version No.", VersionNo);
                            IF NOT NPaymentPlanDetails1.FINDFIRST THEN BEGIN
                                NPaymentPlanDetails1.INIT;
                                NPaymentPlanDetails1.TRANSFERFIELDS(NPaymentPlanDetails);
                                NPaymentPlanDetails1."Version No." := VersionNo + 1;
                                NPaymentPlanDetails1.INSERT;
                            END;
                        UNTIL NPaymentPlanDetails.NEXT = 0;
                    //END;
                    CLEAR(VersionNo);
                    NApplicableCharges1.RESET;
                    NApplicableCharges1.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                    IF NApplicableCharges1.FINDSET THEN
                        REPEAT
                            IF VersionNo < NApplicableCharges1."Version No." THEN
                                VersionNo := NApplicableCharges1."Version No.";
                        UNTIL NApplicableCharges1.NEXT = 0;


                    NApplicableCharges.RESET;
                    NApplicableCharges.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                    IF NApplicableCharges.FINDSET THEN
                        REPEAT
                            NApplicableCharges1.INIT;
                            NApplicableCharges1.TRANSFERFIELDS(NApplicableCharges);
                            NApplicableCharges1."Version No." := VersionNo + 1;
                            NApplicableCharges1.INSERT;
                        UNTIL NApplicableCharges.NEXT = 0;
                    //END;


                    CLEAR(VersionNo);
                    NArchivePaymentTermsLine1.RESET;
                    NArchivePaymentTermsLine1.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                    IF NArchivePaymentTermsLine1.FINDSET THEN
                        REPEAT
                            IF VersionNo < NArchivePaymentTermsLine1."Version No." THEN
                                VersionNo := NArchivePaymentTermsLine1."Version No.";
                        UNTIL NArchivePaymentTermsLine1.NEXT = 0;


                    NArchivePaymentTermsLine.RESET;
                    NArchivePaymentTermsLine.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                    IF NArchivePaymentTermsLine.FINDSET THEN
                        REPEAT
                            NArchivePaymentTermsLine.CALCFIELDS("Received Amt");
                            NArchivePaymentTermsLine1.INIT;
                            NArchivePaymentTermsLine1.TRANSFERFIELDS(NArchivePaymentTermsLine);
                            NArchivePaymentTermsLine1."Received Amt" := NArchivePaymentTermsLine."Received Amt";
                            NArchivePaymentTermsLine1."Version No." := VersionNo + 1;
                            NArchivePaymentTermsLine1.INSERT;
                        UNTIL NArchivePaymentTermsLine.NEXT = 0;
                    //END;
                    UpdateUnitwithApplicablecharge(ConfirmedOrder_2);
                    UnitCommCreationJob.UpdateMilestonePercentage(ConfirmedOrder_2."No.", FALSE);
                    //ALLETDK>>>>
                    ConfirmedOrder_2.CALCFIELDS("Total Received Amount");
                    CLEAR(ExcessAmount);
                    IF ConfirmedOrder_2.Amount < ConfirmedOrder_2."Total Received Amount" THEN
                        ExcessAmount := ConfirmedOrder_2."Total Received Amount" - ConfirmedOrder_2.Amount;
                    IF ExcessAmount <> 0 THEN
                        CreatUPEryfromConfOrderAPP.CreateExcessPaymentTermsLine(ConfirmedOrder_2."No.", ExcessAmount);
                    //ALLETDK<<<<
                    PostPayment.CreateProjectChangeLines(APE, TRUE, ProjChngJVAmt);
                    BReversal.CheckandReverseTA(ConfirmedOrder_2."No.", FALSE);
                    IF NOT ConfirmedOrder_2."Vizag datA" THEN
                        UnitPost.NewUpdateTEAMHierarcy(ConfirmedOrder_2, TRUE); //BBG1.00 050613
                                                                                //211114
                    OldUPmtEntry.RESET;
                    OldUPmtEntry.SETRANGE("Document Type", OldUPEntry."Document Type"::BOND);
                    OldUPmtEntry.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                    OldUPmtEntry.SETRANGE(Posted, TRUE);
                    OldUPmtEntry.SETFILTER("Payment Mode", '=%1', OldUPEntry."Payment Mode"::JV);
                    IF OldUPmtEntry.FINDLAST THEN BEGIN
                        OldUPEntry.RESET;
                        OldUPEntry.SETRANGE("Document Type", OldUPEntry."Document Type"::BOND);
                        OldUPEntry.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                        OldUPEntry.SETRANGE(Posted, TRUE);
                        OldUPEntry.SETRANGE("Posted Document No.", OldUPmtEntry."Posted Document No.");
                        OldUPEntry.SETFILTER(Amount, '>%1', 0);
                        IF OldUPEntry.FINDSET THEN
                            REPEAT
                                ComHoldDate := 0D;
                                ComHoldDate := DMY2DATE(31, 10, 2014);
                                IF OldUPEntry."Posting date" > ComHoldDate THEN
                                    CommHold := TRUE;
                                IF ConfirmedOrder_2."Posting Date" > ComHoldDate THEN
                                    CommHold := FALSE;
                                PostPayment.CreateStagingTableAppBond(ConfirmedOrder_2, OldUPEntry."Line No." / 10000, 1, OldUPEntry.Sequence,
                                OldUPEntry."Cheque No./ Transaction No.", OldUPEntry."Commision Applicable", OldUPEntry."Direct Associate",
                                OldUPEntry."Posting date", OldUPEntry.Amount, OldUPEntry, CommHold, ConfirmedOrder_2."Old Process");
                            UNTIL OldUPEntry.NEXT = 0;
                    END;

                    CLEAR(CommisionGen);
                    RecCommissionEntry.RESET;
                    RecCommissionEntry.SETCURRENTKEY("Commission Run Date");
                    RecCommissionEntry.SETFILTER("Commission Run Date", '<>%1', 0D);
                    IF RecCommissionEntry.FINDLAST THEN
                        CommisionGen.CreateBondandCommission(RecCommissionEntry."Commission Run Date", ConfirmedOrder_2."Introducer Code", ConfirmedOrder_2."No.", '', '', TRUE)
                    ELSE
                        CommisionGen.CreateBondandCommission(WORKDATE, ConfirmedOrder_2."Introducer Code", ConfirmedOrder_2."No.", '', '', TRUE);

                END;
            END;//ALLECK 030313
        END;//ALLECK 030313
        //BBG2.01 231214
        ArchiveConfirmedOrder.RESET;
        ArchiveConfirmedOrder.SETRANGE("No.", ConfirmedOrder_2."No.");
        IF ArchiveConfirmedOrder.FINDLAST THEN BEGIN
            IF ArchiveConfirmedOrder."Shortcut Dimension 1 Code" <> ConfirmedOrder_2."Shortcut Dimension 1 Code" THEN BEGIN
                IF Newconforder.GET(ConfirmedOrder_2."No.") THEN BEGIN
                    IF ConfirmedOrder_2."Application Type" = ConfirmedOrder_2."Application Type"::"Non Trading" THEN BEGIN
                        Newconforder."Project Change" := TRUE;
                        Newconforder."Old Project Code" := Newconforder."Shortcut Dimension 1 Code";
                        Newconforder.MODIFY;
                    END ELSE BEGIN
                        AppPayentry_1.RESET;
                        AppPayentry_1.SETRANGE("Document No.", ConfirmedOrder_2."No.");
                        AppPayentry_1.SETFILTER(Amount, '<%1', 0);
                        IF AppPayentry_1.FINDLAST THEN
                            UnitReversal.CreateProjectChangeEntriesTR(ConfirmedOrder_2."No.", AppPayentry_1."Line No.");
                    END;
                END;
            END;
        END;
        IF Newconforder.GET(ConfirmedOrder_2."No.") THEN BEGIN
            Newconforder."Shortcut Dimension 1 Code" := ConfirmedOrder_2."Shortcut Dimension 1 Code";
            Newconforder."Unit Code" := ConfirmedOrder_2."Unit Code";
            Newconforder."Saleable Area" := ConfirmedOrder_2."Saleable Area";
            Newconforder."Min. Allotment Amount" := ConfirmedOrder_2."Min. Allotment Amount";
            Newconforder.Amount := ConfirmedOrder_2.Amount;
            Newconforder."Project change Comment" := ConfirmedOrder_2."Project change Comment";
            Newconforder.Status := Newconforder.Status::Open;
            Newconforder."Project Type" := ConfirmedOrder_2."Project Type";
            Newconforder."Unit Payment Plan" := ConfirmedOrder_2."Unit Payment Plan";
            Newconforder.Status := ConfirmedOrder_2.Status;
            Newconforder."Unit Plan Name" := ConfirmedOrder_2."Unit Plan Name";
            Newconforder.MODIFY;
        END;

        UnitReversal.CreateCommCreditMemo(ConfirmedOrder_2."No.", TRUE);
        UnitReversal.CreateTACreditMemo(ConfirmedOrder_2."Introducer Code", 0, ConfirmedOrder_2."No.", TRUE);

        //BBG2.01 231214
        MESSAGE('%1', 'Process done successful');
    end;


    procedure UpdateUnitwithApplicablecharge(ConfirmedOrder_3: Record "Confirmed Order")
    var
        AppCharge_1: Record "App. Charge Code";
        AppCharge_2: Record "App. Charge Code";
        Unitmaster: Record "Unit Master";
        Job: Record Job;
        AppCharges: Record "Applicable Charges";
        Docmaster: Record "Document Master";
        PPGD: Record "Project Price Group Details";
        UnitMasterRec: Record "Unit Master";
        Plcrec: Record "PLC Details";
        totalamount1: Decimal;
        PaymentDetails: Record "Payment Plan Details";
        Sno: Code[10];
        PaymentPlanDetails2: Record "Payment Plan Details" temporary;
        Applicablecharge: Record "Applicable Charges";
        MilestoneCodeG: Code[10];
        LoopingAmount: Decimal;
        InLoop: Boolean;
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        UnitCode: Code[20];
        OldCust: Code[20];
        UnitpayEntry: Record "Unit Payment Entry";
        PaymentTermLines: Record "Payment Terms Line Sale";
    begin

        ConfirmedOrder_3."Unit Code" := ConfirmedOrder_3."New Unit No.";
        ConfirmedOrder_3."Unit Payment Plan" := ConfirmedOrder_3."New Unit Payment Plan";
        AppCharge_2.RESET;
        AppCharge_2.SETRANGE(Code, ConfirmedOrder_3."New Unit Payment Plan");
        IF AppCharge_2.FINDFIRST THEN
            ConfirmedOrder_3."Unit Plan Name" := AppCharge_2.Description;

        Unitmaster.GET(ConfirmedOrder_3."New Unit No.");
        ConfirmedOrder_3."Saleable Area" := Unitmaster."Saleable Area";
        ConfirmedOrder_3."Shortcut Dimension 1 Code" := Unitmaster."Project Code";
        IF Job.GET(Unitmaster."Project Code") THEN
            ConfirmedOrder_3."Project Type" := Job."Default Project Type";

        ConfirmedOrder_3."Min. Allotment Amount" := Unitmaster."Min. Allotment Amount";
        AlltAmount := 0;
        IF ConfirmedOrder_3."New Unit Payment Plan" <> '1008' THEN BEGIN
            ConfirmedOrder_3.Amount := CalculateAllotAmt(ConfirmedOrder_3);
            AlltAmount := CalculateAllotAmt(ConfirmedOrder_3);
        END ELSE BEGIN
            ConfirmedOrder_3.Amount := Unitmaster."Total Value";
            AlltAmount := Unitmaster."Total Value";
        END;
        ConfirmedOrder_3."Payment Plan" := Unitmaster."Payment Plan";
        ConfirmedOrder_3.VALIDATE(Amount);
        ConfirmedOrder_3.MODIFY;
        IF ConfirmedOrder_3."Unit Code" <> '' THEN BEGIN
            AppCharges.RESET;
            AppCharges.SETRANGE(AppCharges."Document No.", ConfirmedOrder_3."No.");
            IF AppCharges.FIND('-') THEN
                AppCharges.DELETEALL;

            Docmaster.RESET;
            Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
            Docmaster.SETFILTER(Docmaster."Project Code", ConfirmedOrder_3."Shortcut Dimension 1 Code");
            Docmaster.SETFILTER(Docmaster."Unit Code", ConfirmedOrder_3."Unit Code");
            Docmaster.SETFILTER("Total Charge Amount", '<>%1', 0);  //270317
            IF ConfirmedOrder_3."New Unit Payment Plan" <> '1008' THEN
                Docmaster.SETFILTER(Code, '<>%1&<>%2', 'PPLAN', 'PPLAN1');
            IF Docmaster.FINDFIRST THEN
                REPEAT
                    AppCharges.RESET;
                    AppCharges.INIT;
                    AppCharges."Document Type" := Docmaster."Document Type"::Charge;
                    AppCharges.Code := Docmaster.Code;

                    AppCharges.Description := Docmaster.Description;
                    AppCharges."Document No." := ConfirmedOrder_3."No.";
                    AppCharges."Item No." := ConfirmedOrder_3."Unit Code";
                    AppCharges."Membership Fee" := Docmaster."Membership Fee";
                    IF Docmaster."Project Price Dependency Code" <> '' THEN BEGIN
                        PPGD.RESET;
                        PPGD.SETFILTER(PPGD."Project Code", ConfirmedOrder_3."Shortcut Dimension 1 Code");
                        PPGD.SETRANGE(PPGD."Project Price Group", Docmaster."Project Price Dependency Code");
                        PPGD.SETFILTER(PPGD."Starting Date", '<=%1', ConfirmedOrder_3."Document Date");
                        IF PPGD.FINDLAST THEN BEGIN
                            IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Sale THEN
                                AppCharges."Rate/UOM" := PPGD."Sales Rate (per sq ft)";
                            IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Lease THEN
                                AppCharges."Rate/UOM" := PPGD."Lease Rate (per sq ft)";

                        END;
                    END
                    ELSE
                        AppCharges."Rate/UOM" := Docmaster."Rate/Sq. Yd";

                    AppCharges."Project Code" := Docmaster."Project Code";
                    AppCharges."Fixed Price" := Docmaster."Fixed Price";
                    AppCharges."BP Dependency" := Docmaster."BP Dependency";
                    AppCharges."Rate Not Allowed" := Docmaster."Rate Not Allowed";
                    AppCharges."Project Price Dependency Code" := Docmaster."Project Price Dependency Code";
                    IF AppCharges."Rate/UOM" <> 0 THEN BEGIN
                        UnitMasterRec.GET(ConfirmedOrder_3."Unit Code");
                        AppCharges."Net Amount" := UnitMasterRec."Saleable Area" * AppCharges."Rate/UOM"; //ALLEDK 030313
                    END
                    ELSE
                        AppCharges."Net Amount" := AppCharges."Fixed Price";
                    AppCharges.Sequence := Docmaster.Sequence;
                    IF AppCharges.Code = 'PLC' THEN BEGIN
                        Plcrec.SETFILTER("Item Code", ConfirmedOrder_3."Unit Code");
                        Plcrec.SETFILTER("Job Code", ConfirmedOrder_3."Shortcut Dimension 1 Code");
                        IF Plcrec.FINDFIRST THEN
                            REPEAT
                                AppCharges."Fixed Price" := AppCharges."Fixed Price" + Plcrec.Amount;
                                AppCharges."Net Amount" := AppCharges."Fixed Price";
                            UNTIL Plcrec.NEXT = 0;
                    END;
                    AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
                    AppCharges."Direct Associate" := Docmaster."Direct Associate";
                    AppCharges.Applicable := TRUE;
                    AppCharges.INSERT;
                UNTIL Docmaster.NEXT = 0;

            IF ConfirmedOrder_3."New Unit Payment Plan" <> '1008' THEN BEGIN
                Docmaster.RESET;
                Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                Docmaster.SETFILTER(Docmaster."Project Code", ConfirmedOrder_3."Shortcut Dimension 1 Code");
                Docmaster.SETRANGE(Docmaster."Unit Code", '');
                Docmaster.SETRANGE("App. Charge Code", ConfirmedOrder_3."New Unit Payment Plan");
                IF Docmaster.FINDFIRST THEN BEGIN
                    AppCharges.RESET;
                    AppCharges.INIT;
                    AppCharges."Document Type" := Docmaster."Document Type"::Charge;
                    AppCharges.Code := Docmaster.Code;

                    AppCharges.Description := Docmaster.Description;
                    AppCharges."Document No." := ConfirmedOrder_3."No.";
                    AppCharges."Item No." := ConfirmedOrder_3."Unit Code";
                    AppCharges."Membership Fee" := Docmaster."Membership Fee";
                    IF Docmaster."Project Price Dependency Code" <> '' THEN BEGIN
                        PPGD.RESET;
                        PPGD.SETFILTER(PPGD."Project Code", ConfirmedOrder_3."Shortcut Dimension 1 Code");
                        PPGD.SETRANGE(PPGD."Project Price Group", Docmaster."Project Price Dependency Code");
                        PPGD.SETFILTER(PPGD."Starting Date", '<=%1', ConfirmedOrder_3."Document Date");
                        IF PPGD.FINDLAST THEN BEGIN
                            IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Sale THEN
                                AppCharges."Rate/UOM" := PPGD."Sales Rate (per sq ft)";
                            IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Lease THEN
                                AppCharges."Rate/UOM" := PPGD."Lease Rate (per sq ft)";

                        END;
                    END ELSE
                        AppCharges."Rate/UOM" := Docmaster."Rate/Sq. Yd";

                    AppCharges."Project Code" := Docmaster."Project Code";
                    AppCharges."Fixed Price" := Docmaster."Fixed Price";
                    AppCharges."BP Dependency" := Docmaster."BP Dependency";
                    AppCharges."Rate Not Allowed" := Docmaster."Rate Not Allowed";
                    AppCharges."Project Price Dependency Code" := Docmaster."Project Price Dependency Code";
                    IF AppCharges."Rate/UOM" <> 0 THEN BEGIN
                        UnitMasterRec.GET(ConfirmedOrder_3."Unit Code");
                        AppCharges."Net Amount" := UnitMasterRec."Saleable Area" * AppCharges."Rate/UOM"; //ALLEDK 030313
                    END
                    ELSE
                        AppCharges."Net Amount" := AppCharges."Fixed Price";
                    AppCharges.Sequence := Docmaster.Sequence;
                    AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
                    AppCharges."Direct Associate" := Docmaster."Direct Associate";
                    AppCharges.Applicable := TRUE;
                    AppCharges.INSERT;
                END;
            END;

        END;

        Docmaster.RESET;
        Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
        Docmaster.SETFILTER(Docmaster."Project Code", ConfirmedOrder_3."Shortcut Dimension 1 Code");
        Docmaster.SETRANGE(Docmaster."Unit Code", '');
        Docmaster.SETRANGE("Sub Sub Payment Plan Code", ConfirmedOrder_3."New Unit Payment Plan");
        IF Docmaster.FINDFIRST THEN BEGIN
            AppCharges.RESET;
            AppCharges.INIT;
            AppCharges."Document Type" := Docmaster."Document Type"::Charge;
            AppCharges.Code := Docmaster.Code;

            AppCharges.Description := Docmaster.Description;
            AppCharges."Document No." := ConfirmedOrder_3."No.";
            AppCharges."Item No." := ConfirmedOrder_3."Unit Code";
            AppCharges."Membership Fee" := Docmaster."Membership Fee";
            IF Docmaster."Project Price Dependency Code" <> '' THEN BEGIN
                PPGD.RESET;
                PPGD.SETFILTER(PPGD."Project Code", ConfirmedOrder_3."Shortcut Dimension 1 Code");
                PPGD.SETRANGE(PPGD."Project Price Group", Docmaster."Project Price Dependency Code");
                PPGD.SETFILTER(PPGD."Starting Date", '<=%1', ConfirmedOrder_3."Document Date");
                IF PPGD.FINDLAST THEN BEGIN
                    IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Sale THEN
                        AppCharges."Rate/UOM" := PPGD."Sales Rate (per sq ft)";
                    IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Lease THEN
                        AppCharges."Rate/UOM" := PPGD."Lease Rate (per sq ft)";

                END;
            END ELSE
                AppCharges."Rate/UOM" := Docmaster."Rate/Sq. Yd";

            AppCharges."Project Code" := Docmaster."Project Code";
            AppCharges."Fixed Price" := Docmaster."Fixed Price";
            AppCharges."BP Dependency" := Docmaster."BP Dependency";
            AppCharges."Rate Not Allowed" := Docmaster."Rate Not Allowed";
            AppCharges."Project Price Dependency Code" := Docmaster."Project Price Dependency Code";
            IF AppCharges."Rate/UOM" <> 0 THEN BEGIN
                UnitMasterRec.GET(ConfirmedOrder_3."Unit Code");
                AppCharges."Net Amount" := UnitMasterRec."Saleable Area" * AppCharges."Rate/UOM"; //ALLEDK 030313
            END
            ELSE
                AppCharges."Net Amount" := AppCharges."Fixed Price";
            AppCharges.Sequence := Docmaster.Sequence;
            AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
            AppCharges."Direct Associate" := Docmaster."Direct Associate";
            AppCharges.Applicable := TRUE;
            AppCharges.INSERT;
        END;


        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Document No.", ConfirmedOrder_3."No.");
        IF PaymentPlanDetails.FIND('-') THEN
            REPEAT
                PaymentPlanDetails.DELETE;
            UNTIL PaymentPlanDetails.NEXT = 0;

        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", ConfirmedOrder_3."No.");
        IF PaymentTermLines.FINDSET THEN
            REPEAT
                PaymentTermLines.DELETE;
            UNTIL PaymentTermLines.NEXT = 0;


        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Project Code", ConfirmedOrder_3."Shortcut Dimension 1 Code");
        PaymentPlanDetails.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
        PaymentPlanDetails.SETRANGE("Document No.", '');
        PaymentPlanDetails.SETRANGE("Sub Payment Plan", ConfirmedOrder_3."New Unit Payment Plan");
        IF PaymentPlanDetails.FIND('-') THEN
            REPEAT
                PaymentPlanDetails1.INIT;
                PaymentPlanDetails1.COPY(PaymentPlanDetails);
                PaymentPlanDetails1."Document No." := ConfirmedOrder_3."No.";
                PaymentPlanDetails1."Project Milestone Due Date" :=
                CALCDATE(PaymentPlanDetails1."Due Date Calculation", ConfirmedOrder_3."Posting Date"); //ALLETDK221112
                IF FORMAT(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat") <> '' THEN //ALLEDK 040821
                    PaymentPlanDetails1."Auto Plot Vacate Due Date" := CALCDATE(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat", PaymentPlanDetails1."Project Milestone Due Date") //ALLEDK 040821
                ELSE
                    PaymentPlanDetails1."Auto Plot Vacate Due Date" := PaymentPlanDetails1."Project Milestone Due Date";  //ALLEDK 040821

                PaymentPlanDetails1.INSERT;
            UNTIL PaymentPlanDetails.NEXT = 0;

        Unitmaster.TESTFIELD("Total Value");

        totalamount1 := 0;
        PaymentDetails.RESET;
        PaymentDetails.SETFILTER("Project Code", ConfirmedOrder_3."Shortcut Dimension 1 Code");
        PaymentDetails.SETFILTER("Document No.", ConfirmedOrder_3."No.");
        PaymentDetails.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
        IF PaymentDetails.FINDFIRST THEN
            REPEAT
                IF PaymentDetails."Percentage Cum" > 0 THEN BEGIN
                    IF PaymentDetails."Percentage Cum" = 100 THEN
                        PaymentDetails."Total Charge Amount" := (AlltAmount - totalamount1)
                    ELSE
                        PaymentDetails."Total Charge Amount" := (AlltAmount * PaymentDetails."Percentage Cum" / 100) - totalamount1;
                END;
                IF PaymentDetails."Fixed Amount" <> 0 THEN BEGIN
                    PaymentDetails."Total Charge Amount" := PaymentDetails."Fixed Amount";
                END;

                totalamount1 := PaymentDetails."Total Charge Amount" + totalamount1;
                PaymentDetails.VALIDATE("Total Charge Amount");
                PaymentDetails.MODIFY;
            UNTIL PaymentDetails.NEXT = 0;




        Sno := '001';
        PaymentPlanDetails2.RESET;
        PaymentPlanDetails2.DELETEALL;

        TotalAmount := 0;
        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
        PaymentPlanDetails.SETRANGE("Document No.", ConfirmedOrder_3."No.");
        IF PaymentPlanDetails.FINDSET THEN
            REPEAT
                PaymentPlanDetails2.COPY(PaymentPlanDetails);
                TotalAmount := TotalAmount + PaymentPlanDetails2."Milestone Charge Amount";
                PaymentPlanDetails2.INSERT;
            UNTIL PaymentPlanDetails.NEXT = 0;

        Applicablecharge.RESET;
        Applicablecharge.SETCURRENTKEY("Document No.", Applicablecharge.Sequence);
        Applicablecharge.SETRANGE("Document No.", ConfirmedOrder_3."No.");
        Applicablecharge.SETRANGE(Applicable, TRUE);
        Applicablecharge.SETFILTER("Net Amount", '<>%1', 0);  //070317
        IF Applicablecharge.FINDSET THEN BEGIN
            MilestoneCodeG := '1';
            PaymentPlanDetails2.RESET;
            PaymentPlanDetails2.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
            PaymentPlanDetails2.SETRANGE("Document No.", ConfirmedOrder_3."No.");
            PaymentPlanDetails2.SETRANGE(Checked, FALSE);
            IF PaymentPlanDetails2.FINDSET THEN
                REPEAT
                    LoopingAmount := 0;
                    REPEAT
                        IF Applicablecharge."Net Amount" = PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                            CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", ConfirmedOrder_3, PaymentPlanDetails2."Payment Plan Code");
                            PaymentPlanDetails2.Checked := TRUE;
                            PaymentPlanDetails2.MODIFY;
                            TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";
                            Applicablecharge."Net Amount" := 0;
                            InLoop := TRUE;
                        END;
                        IF Applicablecharge."Net Amount" > PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                            CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", ConfirmedOrder_3, PaymentPlanDetails2."Payment Plan Code");
                            PaymentPlanDetails2.Checked := TRUE;
                            PaymentPlanDetails2.MODIFY;

                            TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";//ALLE PS
                            LoopingAmount := 0;

                            Applicablecharge."Net Amount" := Applicablecharge."Net Amount" -
                              PaymentPlanDetails2."Milestone Charge Amount";

                            InLoop := TRUE;
                        END ELSE
                            IF (Applicablecharge."Net Amount" < PaymentPlanDetails2."Milestone Charge Amount") AND
                              (Applicablecharge."Net Amount" <> 0) THEN BEGIN
                                CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                PaymentPlanDetails2."Project Milestone Due Date", Applicablecharge."Net Amount",
                                Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", ConfirmedOrder_3, PaymentPlanDetails2."Payment Plan Code");

                                TotalAmount := TotalAmount - Applicablecharge."Net Amount";//ALLE PS
                                LoopingAmount := PaymentPlanDetails2."Milestone Charge Amount" - Applicablecharge."Net Amount";

                                PaymentPlanDetails2."Milestone Charge Amount" := PaymentPlanDetails2."Milestone Charge Amount" -
                                Applicablecharge."Net Amount";
                                PaymentPlanDetails2.MODIFY;
                                Applicablecharge."Net Amount" := 0;
                                InLoop := TRUE;
                            END;
                        IF Applicablecharge."Net Amount" = 0 THEN BEGIN
                            Applicablecharge.NEXT;
                        END;
                        IF TotalAmount < 1 THEN
                            TotalAmount := 0;
                    UNTIL (LoopingAmount = 0) OR (TotalAmount = 0);
                UNTIL (PaymentPlanDetails2.NEXT = 0) OR (TotalAmount = 0);
        END;

        Unitmaster.VALIDATE(Status, Unitmaster.Status::Booked);
        Unitmaster.MODIFY;


        //"New Unit No." := '';//ALLETDK120413
        ConfirmedOrder_3.MODIFY;

        WebAppService.UpdateUnitStatus(Unitmaster);  //210624
    end;


    procedure CalculateAllotAmt(ConfirmedOrder_4: Record "Confirmed Order"): Decimal
    var
        CalDocMaster: Record "Document Master";
        AppCharge: Record "App. Charge Code";
        UnitMaster_1: Record "Unit Master";
    begin
        TotalValue := 0;
        TotalFixed := 0;
        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY(ConfirmedOrder_4."Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        CalDocMaster.SETRANGE("Project Code", ConfirmedOrder_4."Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code", ConfirmedOrder_4."Unit Code");
        IF CalDocMaster.FINDFIRST THEN
            REPEAT
                AppCharge.RESET;
                AppCharge.SETRANGE(Code, CalDocMaster."App. Charge Code");
                AppCharge.SETRANGE("Sub Payment Plan", TRUE);
                IF NOT AppCharge.FINDFIRST THEN BEGIN
                    TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
                    TotalFixed := TotalFixed + CalDocMaster."Fixed Price";
                END;
            UNTIL CalDocMaster.NEXT = 0;

        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY(ConfirmedOrder_4."Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        CalDocMaster.SETRANGE("Project Code", ConfirmedOrder_4."Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code", '');
        CalDocMaster.SETRANGE("App. Charge Code", ConfirmedOrder_4."New Unit Payment Plan");
        IF CalDocMaster.FINDFIRST THEN
            REPEAT
                TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
            UNTIL CalDocMaster.NEXT = 0;

        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY(ConfirmedOrder_4."Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        CalDocMaster.SETRANGE("Project Code", ConfirmedOrder_4."Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code", '');
        CalDocMaster.SETRANGE("Sub Sub Payment Plan Code", ConfirmedOrder_4."New Unit Payment Plan");
        IF CalDocMaster.FINDFIRST THEN
            REPEAT
                TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
            UNTIL CalDocMaster.NEXT = 0;



        UnitMaster_1.RESET;
        UnitMaster_1.CHANGECOMPANY(ConfirmedOrder_4."Company Name");
        UnitMaster_1.SETRANGE("No.", ConfirmedOrder_4."Unit Code");
        UnitMaster_1.SETRANGE("Project Code", ConfirmedOrder_4."Shortcut Dimension 1 Code");
        IF UnitMaster_1.FINDFIRST THEN BEGIN
            TotalValue := TotalFixed + (TotalValue * UnitMaster_1."Saleable Area");
        END;

        TotalValue := ROUND(TotalValue, 1, '=');

        EXIT(TotalValue);
    end;


    procedure CreatePaymentTermsLine(MilestoneCode: Code[10]; MilestoneDescription: Text[50]; MilestoneDueDate: Date; Milestoneamt: Decimal; ChargeCode: Code[10]; CommisionApplicable: Boolean; DirectAssociate: Boolean; Confirmedorder_5: Record "Confirmed Order"; PaymentPlanCode: Code[10])
    var
        PaymentTermLines: Record "Payment Terms Line Sale";
    begin

        PaymentTermLines.INIT;
        PaymentTermLines."Document No." := Confirmedorder_5."No.";
        PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
        PaymentTermLines.Sequence := Sno;
        Sno := INCSTR(Sno);
        PaymentTermLines."Actual Milestone" := MilestoneCode;
        PaymentTermLines."Payment Plan" := PaymentPlanCode;
        PaymentTermLines.Description := MilestoneDescription;
        PaymentTermLines."Due Date" := MilestoneDueDate;
        PaymentTermLines."Project Code" := Confirmedorder_5."Shortcut Dimension 1 Code";
        PaymentTermLines."Calculation Type" := PaymentTermLines."Calculation Type"::"% age";
        PaymentTermLines."Criteria Value / Base Amount" := Milestoneamt;
        PaymentTermLines."Calculation Value" := 100;
        PaymentTermLines."Due Amount" := ROUND(Milestoneamt, 0.01, '=');
        PaymentTermLines."Charge Code" := ChargeCode;
        PaymentTermLines."Commision Applicable" := CommisionApplicable;
        PaymentTermLines."Direct Associate" := DirectAssociate;
        PaymentTermLines.INSERT(TRUE);
    end;

    local procedure "---------------bbg2.0"()
    begin
    end;


    procedure NewPostCommCreditMemoTDS(Associate_1: Code[20]; Amt_1: Decimal; FromProjChange: Boolean; OrderRefNo: Code[20]; PostDate_1: Date; ProjectCode: Code[20])
    var
        NarrationText1: Text[250];
        Bond: Record "Confirmed Order";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CommissionEntry_1: Record "Commission Entry";
        CommissionEntry_2: Record "Commission Entry";
        PostCreditNote_1: Boolean;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        CommEntry_2: Record "Commission Entry";
        ClbAmt: Decimal;
        StartDate: Date;
        EndDate: Date;
        Year: Integer;
        Month: Integer;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PostPayment: Codeunit PostPayment;
        TDSPercent: Decimal;
        TDSEntry: Record "TDS Entry";
        TDSBaseAmt: Decimal;
        TDSReversAmount: Decimal;
        v_ConfirmedOrder: Record "Confirmed Order";
    begin


        BondSetup.GET;

        StartDate := 0D;
        Year := 0;
        Month := 0;

        Year := DATE2DMY(TODAY, 3);
        Month := DATE2DMY(TODAY, 2);

        IF (Month = 1) OR (Month = 2) OR (Month = 3) THEN
            StartDate := DMY2DATE(1, 1, Year)
        ELSE
            IF (Month = 4) OR (Month = 5) OR (Month = 6) THEN
                StartDate := DMY2DATE(1, 4, Year)
            ELSE
                IF (Month = 7) OR (Month = 8) OR (Month = 9) THEN
                    StartDate := DMY2DATE(1, 7, Year)
                ELSE
                    IF (Month = 10) OR (Month = 11) OR (Month = 12) THEN
                        StartDate := DMY2DATE(1, 10, Year);

        //StartDate := 0D; // ALLE AKUL 060223

        v_ConfirmedOrder.RESET;   //130122
        v_ConfirmedOrder.SETRANGE("No.", OrderRefNo);  //130122
        v_ConfirmedOrder.SETRANGE("Posting Date", StartDate, TODAY);  //130122
        IF v_ConfirmedOrder.FINDFIRST THEN BEGIN  //130122

            TDSBaseAmt := 0;

            TDSEntry.RESET;
            TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date");
            //TDSEntry.SETRANGE(TDSEntry."Party Type", TDSEntry."Party Type"::Vendor);
            ///TDSEntry.SETRANGE(TDSEntry."Party Code", Associate_1); Changes In BC 
            TDSEntry.SETRANGE("Vendor No.", Associate_1);
            TDSEntry.SETRANGE("Posting Date", StartDate, TODAY);
            IF TDSEntry.FINDSET THEN
                REPEAT
                    TDSBaseAmt := TDSBaseAmt + TDSEntry."TDS Base Amount";
                UNTIL TDSEntry.NEXT = 0;

            IF (TDSBaseAmt - ABS(Amt_1)) > 0 THEN BEGIN
                TDSPercent := 0;
                TDSPercent := PostPayment.CalculateTDSPercentage(Associate_1, BondSetup."TDS Nature of Deduction", '');
                TDSReversAmount := 0;
                TDSReversAmount := ABS((Amt_1 * TDSPercent / 100));
                TDSReversAmount := ROUND(TDSReversAmount, 1, '=');
                TDSBaseAmt := ABS(Amt_1);
            END ELSE BEGIN
                TDSPercent := 0;
                TDSPercent := PostPayment.CalculateTDSPercentage(Associate_1, BondSetup."TDS Nature of Deduction", '');
                TDSReversAmount := 0;
                TDSReversAmount := (TDSBaseAmt * TDSPercent / 100);
                TDSReversAmount := ROUND(TDSReversAmount, 1, '=');
            END;

            ClbAmt := 0;
            ClbAmt := ROUND(ABS(Amt_1 * BondSetup."Corpus %" / 100), 0.01, '=');

            UserSetup.GET(USERID);
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
            GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
            GenJnlLine.DELETEALL;
            BondSetup.TESTFIELD("Refund No. Series");
            DocNo := '';
            IF PostDate_1 = 0D THEN
                DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", WORKDATE, TRUE)
            ELSE
                DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", PostDate_1, TRUE);
            //ALLEDK 260113

            NarrationText1 := 'Commission Credit Memo- ' + COPYSTR(Associate_1, 1, 30);
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            GenJnlLine.VALIDATE("Posting Date", TODAY);
            GenJnlLine.VALIDATE("Document Date", TODAY);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", Associate_1);
            GenJnlLine."Document No." := DocNo;

            GenJnlLine.VALIDATE(Amount, -1 * ((ABS(TDSReversAmount) + ABS(ClbAmt))));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
            GenJnlLine.VALIDATE("Source No.", Associate_1);
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission;
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            GenJnlLine.Description := 'Comm-TDS/Club 9 Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine.INSERT;

            IF TDSReversAmount <> 0 THEN BEGIN
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := 20000;
                GenJnlLine.VALIDATE("Posting Date", TODAY);
                GenJnlLine.VALIDATE("Document Date", TODAY);
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", BondSetup."TDS Payable Commission A/c");
                GenJnlLine."Document No." := DocNo;
                GenJnlLine.VALIDATE(Amount, (ABS(TDSReversAmount)));
                //GenJnlLine.VALIDATE("Source Type",GenJnlLine."Source Type"::"");
                //GenJnlLine.VALIDATE("Source No.",Associate_1);
                //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0

                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Introducer Code" := Bond."Introducer Code";
                GenJnlLine."External Document No." := DocNo;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission;
                GenJnlLine."Unit No." := Bond."No.";
                GenJnlLine."Application No." := OrderRefNo;
                GenJnlLine.Description := 'Comm-TDS/Club 9 Reversal';
                GenJnlLine."TA/Comm Credit Memo" := TRUE;
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
                GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
                GenJnlLine.INSERT;
            END;

            IF ClbAmt <> 0 THEN BEGIN
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
                GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
                GenJnlLine."Line No." := 30000;
                GenJnlLine.VALIDATE("Posting Date", TODAY);
                GenJnlLine.VALIDATE("Document Date", TODAY);
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", BondSetup."Corpus A/C");
                GenJnlLine."Document No." := DocNo;


                GenJnlLine.VALIDATE(Amount, (ABS(ClbAmt)));
                GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::" ");
                //GenJnlLine.VALIDATE("Source No.",Associate_1);
                //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0

                GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Introducer Code" := Bond."Introducer Code";
                GenJnlLine."External Document No." := DocNo;
                GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission;
                GenJnlLine."Unit No." := Bond."No.";
                GenJnlLine."Application No." := OrderRefNo;
                GenJnlLine.Description := 'Comm-TDS/Club 9 Reversal';
                GenJnlLine."TA/Comm Credit Memo" := TRUE;
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
                GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
                GenJnlLine.INSERT;
            END;

            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            PostGenJnlLines; //For Testing

            CreateTDSEntry(TDSBaseAmt, TDSReversAmount, TODAY, Associate_1, DocNo, TDSPercent);

        END; //130122
    end;


    procedure NewPostCommCreditMemo(Associate_1: Code[20]; Amt_1: Decimal; FromProjChange: Boolean; OrderRefNo: Code[20]; PostDate_1: Date; ProjectCode: Code[20])
    var
        NarrationText1: Text[250];
        Bond: Record "Confirmed Order";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CommissionEntry_1: Record "Commission Entry";
        CommissionEntry_2: Record "Commission Entry";
        PostCreditNote_1: Boolean;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        CommEntry_2: Record "Commission Entry";
        ClbAmt: Decimal;
        StartDate: Date;
        EndDate: Date;
        Year: Integer;
        Month: Integer;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PostPayment: Codeunit PostPayment;
        TDSPercent: Decimal;
        BaseAmt: Decimal;
        v_CommissionEntry: Record "Commission Entry";
    begin
        BondSetup.GET;

        UserSetup.GET(USERID);
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;
        BondSetup.TESTFIELD("Refund No. Series");
        DocNo := '';
        IF PostDate_1 = 0D THEN
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", WORKDATE, TRUE)
        ELSE
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", PostDate_1, TRUE);
        //ALLEDK 260113

        NarrationText1 := 'Commission Credit Memo- ' + COPYSTR(Associate_1, 1, 30);
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
        GenJnlLine."Line No." := 10000;
        IF PostDate_1 = 0D THEN BEGIN
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", WORKDATE);
        END ELSE BEGIN
            GenJnlLine.VALIDATE("Posting Date", PostDate_1);
            GenJnlLine.VALIDATE("Document Date", PostDate_1);
        END;
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", Associate_1);
        GenJnlLine."Document No." := DocNo;

        GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
        GenJnlLine.VALIDATE(Amount, (ABS(Amt_1)));
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
        GenJnlLine.VALIDATE("Source No.", Associate_1);
        //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0

        GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Introducer Code" := Bond."Introducer Code";
        GenJnlLine."External Document No." := DocNo;
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission;
        GenJnlLine."Unit No." := Bond."No.";
        GenJnlLine."Application No." := OrderRefNo;
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Commission A/C");
        GenJnlLine.Description := 'Commission';
        GenJnlLine."TA/Comm Credit Memo" := TRUE;
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
        GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
        GenJnlLine.INSERT;


        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
          GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
        PostGenJnlLines;

        v_CommissionEntry.RESET;
        v_CommissionEntry.SETCURRENTKEY("Application No.", "Associate Code", "Invoice Date", Posted);
        v_CommissionEntry.SETRANGE("Application No.", OrderRefNo);
        v_CommissionEntry.SETRANGE("Associate Code", Associate_1);
        v_CommissionEntry.SETRANGE("Invoice Date", TODAY);
        v_CommissionEntry.SETRANGE(Posted, TRUE);
        v_CommissionEntry.SETRANGE("Voucher No.", '');
        IF v_CommissionEntry.FINDSET THEN
            REPEAT
                v_CommissionEntry."Voucher No." := DocNo;
                v_CommissionEntry.MODIFY;
            UNTIL v_CommissionEntry.NEXT = 0;
    end;


    procedure NewPostCommInvoice(Associate_1: Code[20]; Amt_1: Decimal; FromProjChange: Boolean; OrderRefNo: Code[20]; PostDate_1: Date; ProjectCode: Code[20])
    var
        NarrationText1: Text[250];
        Bond: Record "Confirmed Order";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CommissionEntry_1: Record "Commission Entry";
        CommissionEntry_2: Record "Commission Entry";
        PostCreditNote_1: Boolean;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        CommEntry_2: Record "Commission Entry";
        ClbAmt: Decimal;
        StartDate: Date;
        EndDate: Date;
        Year: Integer;
        Month: Integer;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PostPayment: Codeunit PostPayment;
        TDSPercent: Decimal;
        BaseAmt: Decimal;
        v_CommissionEntry: Record "Commission Entry";
    begin
        BondSetup.GET;

        UserSetup.GET(USERID);
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;
        BondSetup.TESTFIELD("Refund No. Series");
        DocNo := '';
        DocNo := NoSeriesMgt.GetNextNo(BondSetup."Voucher No. Series", TODAY, TRUE);

        NarrationText1 := 'Commission Invoice- ' + COPYSTR(Associate_1, 1, 30);
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
        GenJnlLine."Line No." := 10000;
        IF PostDate_1 = 0D THEN BEGIN
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", WORKDATE);
        END ELSE BEGIN
            GenJnlLine.VALIDATE("Posting Date", PostDate_1);
            GenJnlLine.VALIDATE("Document Date", PostDate_1);
        END;
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", Associate_1);
        GenJnlLine."Document No." := DocNo;

        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
        GenJnlLine.VALIDATE(Amount, (-1 * (Amt_1)));
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
        GenJnlLine.VALIDATE("Source No.", Associate_1);
        //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0

        GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Introducer Code" := Bond."Introducer Code";
        GenJnlLine."External Document No." := DocNo;
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Commission;
        GenJnlLine."Unit No." := Bond."No.";
        GenJnlLine."Application No." := OrderRefNo;
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Commission A/C");
        GenJnlLine.Description := 'Commission';
        GenJnlLine."TA/Comm Credit Memo" := TRUE;
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
        GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
        GenJnlLine.INSERT;


        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
          GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
        PostGenJnlLines;
        v_CommissionEntry.RESET;
        v_CommissionEntry.SETCURRENTKEY("Application No.", "Associate Code", "Invoice Date", Posted);
        v_CommissionEntry.SETRANGE("Application No.", OrderRefNo);
        v_CommissionEntry.SETRANGE("Associate Code", Associate_1);
        v_CommissionEntry.SETRANGE("Invoice Date", TODAY);
        v_CommissionEntry.SETRANGE(Posted, TRUE);
        v_CommissionEntry.SETRANGE("Voucher No.", '');
        IF v_CommissionEntry.FINDSET THEN
            REPEAT
                v_CommissionEntry."Voucher No." := DocNo;
                v_CommissionEntry.MODIFY;
            UNTIL v_CommissionEntry.NEXT = 0;
    end;


    procedure TA_NewPostCommCreditMemoTDS(Associate_1: Code[20]; Amt_1: Decimal; FromProjChange: Boolean; OrderRefNo: Code[20]; PostDate_1: Date; ProjectCode: Code[20])
    var
        NarrationText1: Text[250];
        Bond: Record "Confirmed Order";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CommissionEntry_1: Record "Commission Entry";
        CommissionEntry_2: Record "Commission Entry";
        PostCreditNote_1: Boolean;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        CommEntry_2: Record "Commission Entry";
        ClbAmt: Decimal;
        StartDate: Date;
        EndDate: Date;
        Year: Integer;
        Month: Integer;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PostPayment: Codeunit PostPayment;
        TDSPercent: Decimal;
        TDSBaseAmt: Decimal;
        TDSEntry: Record "TDS Entry";
        TDSReversAmount: Decimal;
    begin
        BondSetup.GET;

        StartDate := 0D;
        Year := 0;
        Month := 0;

        Year := DATE2DMY(TODAY, 3);
        Month := DATE2DMY(TODAY, 2);

        IF (Month = 1) OR (Month = 2) OR (Month = 3) THEN
            StartDate := DMY2DATE(1, 1, Year)
        ELSE
            IF (Month = 4) OR (Month = 5) OR (Month = 6) THEN
                StartDate := DMY2DATE(1, 4, Year)
            ELSE
                IF (Month = 7) OR (Month = 8) OR (Month = 9) THEN
                    StartDate := DMY2DATE(1, 7, Year)
                ELSE
                    IF (Month = 10) OR (Month = 11) OR (Month = 12) THEN
                        StartDate := DMY2DATE(1, 10, Year);

        TDSBaseAmt := 0;

        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date");
        //TDSEntry.SETRANGE(TDSEntry."Party Type", TDSEntry."Party Type"::Vendor);Changes in BC
        //TDSEntry.SETRANGE(TDSEntry."Party Code", Associate_1); Changes in BC
        TDSEntry.SETRANGE("Vendor No.", Associate_1);
        TDSEntry.SETRANGE("Posting Date", StartDate, TODAY);
        IF TDSEntry.FINDSET THEN
            REPEAT
                TDSBaseAmt := TDSBaseAmt + TDSEntry."TDS Base Amount";
            UNTIL TDSEntry.NEXT = 0;

        IF (TDSBaseAmt - ABS(Amt_1)) > 0 THEN BEGIN
            TDSPercent := 0;
            TDSPercent := PostPayment.CalculateTDSPercentage(Associate_1, BondSetup."TDS Nature of Deduction", '');
            TDSReversAmount := 0;
            TDSReversAmount := ABS((Amt_1 * TDSPercent / 100));
            TDSReversAmount := ROUND(TDSReversAmount, 1, '=');
            TDSBaseAmt := ABS(Amt_1);
        END ELSE BEGIN
            TDSPercent := 0;
            TDSPercent := PostPayment.CalculateTDSPercentage(Associate_1, BondSetup."TDS Nature of Deduction", '');
            TDSReversAmount := 0;
            TDSReversAmount := (TDSBaseAmt * TDSPercent / 100);
            TDSReversAmount := ROUND(TDSReversAmount, 1, '=');
        END;


        ClbAmt := 0;
        ClbAmt := ROUND(ABS(Amt_1 * BondSetup."Corpus %" / 100), 0.01, '=');

        UserSetup.GET(USERID);
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;
        BondSetup.TESTFIELD("Posted TA Credit Memo");
        DocNo := '';
        IF PostDate_1 = 0D THEN
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", WORKDATE, TRUE)
        ELSE
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", PostDate_1, TRUE);
        //ALLEDK 260113

        NarrationText1 := 'TA Credit Memo- ' + COPYSTR(Associate_1, 1, 30);

        PostEntry := FALSE;

        IF (ABS(TDSReversAmount) + ABS(ClbAmt) <> 0) THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            GenJnlLine.VALIDATE("Posting Date", TODAY);
            GenJnlLine.VALIDATE("Document Date", TODAY);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", Associate_1);
            GenJnlLine."Document No." := DocNo;

            GenJnlLine.VALIDATE(Amount, -1 * (ABS(TDSReversAmount) + ABS(ClbAmt)));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
            GenJnlLine.VALIDATE("Source No.", Associate_1);
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            GenJnlLine.Description := 'TA-TDS/Club 9 Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine.INSERT;
            PostEntry := TRUE;
        END;
        IF ABS(TDSReversAmount) <> 0 THEN BEGIN

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 20000;
            GenJnlLine.VALIDATE("Posting Date", TODAY);
            GenJnlLine.VALIDATE("Document Date", TODAY);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."TDS Payable Commission A/c");
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, (ABS(TDSReversAmount)));
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            GenJnlLine.Description := 'TA -TDS/Club 9 Reversal';
            ;
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine.INSERT;
            PostEntry := TRUE;
        END;

        IF ABS(ClbAmt) <> 0 THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 30000;
            GenJnlLine.VALIDATE("Posting Date", TODAY);
            GenJnlLine.VALIDATE("Document Date", TODAY);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."Corpus A/C");
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, (ABS(ClbAmt)));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::" ");
            GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            GenJnlLine.Description := 'TA -TDS/Club 9 Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine.INSERT;
            PostEntry := TRUE;
        END;

        IF PostEntry THEN BEGIN
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            PostGenJnlLines;

            CreateTDSEntry(TDSBaseAmt, TDSReversAmount, TODAY, Associate_1, DocNo, TDSPercent);
        END;
    end;


    procedure TA_NewPostCommCreditMemo(Associate_1: Code[20]; Amt_1: Decimal; FromProjChange: Boolean; OrderRefNo: Code[20]; PostDate_1: Date; ProjectCode: Code[20])
    var
        NarrationText1: Text[250];
        Bond: Record "Confirmed Order";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CommissionEntry_1: Record "Commission Entry";
        CommissionEntry_2: Record "Commission Entry";
        PostCreditNote_1: Boolean;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        CommEntry_2: Record "Commission Entry";
        ClbAmt: Decimal;
        StartDate: Date;
        EndDate: Date;
        Year: Integer;
        Month: Integer;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PostPayment: Codeunit PostPayment;
        TDSPercent: Decimal;
        BaseAmt: Decimal;
        TAEntry_2: Record "Travel Payment Entry";
    begin
        BondSetup.GET;

        UserSetup.GET(USERID);
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;
        BondSetup.TESTFIELD("Refund No. Series");
        DocNo := '';
        IF PostDate_1 = 0D THEN
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", WORKDATE, TRUE)
        ELSE
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", PostDate_1, TRUE);
        //ALLEDK 260113

        NarrationText1 := 'TA Credit Memo- ' + COPYSTR(Associate_1, 1, 30);
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
        GenJnlLine."Line No." := 10000;
        IF PostDate_1 = 0D THEN BEGIN
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", WORKDATE);
        END ELSE BEGIN
            GenJnlLine.VALIDATE("Posting Date", PostDate_1);
            GenJnlLine.VALIDATE("Document Date", PostDate_1);
        END;
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", Associate_1);
        GenJnlLine."Document No." := DocNo;

        GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
        GenJnlLine.VALIDATE(Amount, (ABS(Amt_1)));
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
        GenJnlLine.VALIDATE("Source No.", Associate_1);
        //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0

        GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Introducer Code" := Bond."Introducer Code";
        GenJnlLine."External Document No." := DocNo;
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
        GenJnlLine."Unit No." := Bond."No.";
        GenJnlLine."Application No." := OrderRefNo;
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Commission A/C");
        GenJnlLine.Description := 'TA';
        GenJnlLine."TA/Comm Credit Memo" := TRUE;
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
        GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
        GenJnlLine.INSERT;


        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
          GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
        PostGenJnlLines;
        TAEntry_2.RESET;
        TAEntry_2.SETCURRENTKEY("Sub Associate Code", "Post Payment");
        TAEntry_2.SETRANGE("Sub Associate Code", Associate_1);
        TAEntry_2.SETRANGE("Post Payment", TRUE);
        TAEntry_2.SETRANGE("Invoice Date", TODAY);
        TAEntry_2.SETRANGE("Voucher No.", '');
        IF TAEntry_2.FINDSET THEN
            REPEAT
                TAEntry_2."Voucher No." := DocNo;
                TAEntry_2.MODIFY;
            UNTIL TAEntry_2.NEXT = 0;
    end;


    procedure TA_NewPostCommInvoice(Associate_1: Code[20]; Amt_1: Decimal; FromProjChange: Boolean; OrderRefNo: Code[20]; PostDate_1: Date; ProjectCode: Code[20])
    var
        NarrationText1: Text[250];
        Bond: Record "Confirmed Order";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CommissionEntry_1: Record "Commission Entry";
        CommissionEntry_2: Record "Commission Entry";
        PostCreditNote_1: Boolean;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        CommEntry_2: Record "Commission Entry";
        ClbAmt: Decimal;
        StartDate: Date;
        EndDate: Date;
        Year: Integer;
        Month: Integer;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PostPayment: Codeunit PostPayment;
        TDSPercent: Decimal;
        BaseAmt: Decimal;
    begin
        BondSetup.GET;

        UserSetup.GET(USERID);
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;
        BondSetup.TESTFIELD("Refund No. Series");
        DocNo := '';
        DocNo := NoSeriesMgt.GetNextNo(BondSetup."Voucher No. Series", TODAY, TRUE);

        NarrationText1 := 'TA Invoice- ' + COPYSTR(Associate_1, 1, 30);
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
        GenJnlLine."Line No." := 10000;
        IF PostDate_1 = 0D THEN BEGIN
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", WORKDATE);
        END ELSE BEGIN
            GenJnlLine.VALIDATE("Posting Date", PostDate_1);
            GenJnlLine.VALIDATE("Document Date", PostDate_1);
        END;
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", Associate_1);
        GenJnlLine."Document No." := DocNo;

        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
        GenJnlLine.VALIDATE(Amount, (-1 * (Amt_1)));
        GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
        GenJnlLine.VALIDATE("Source No.", Associate_1);
        //GenJnlLine."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";  //INS1.0

        GenJnlLine."Source Code" := BondSetup."Cr. Source Code";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Introducer Code" := Bond."Introducer Code";
        GenJnlLine."External Document No." := DocNo;
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
        GenJnlLine."Unit No." := Bond."No.";
        GenJnlLine."Application No." := OrderRefNo;
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Commission A/C");
        GenJnlLine.Description := 'TA';
        GenJnlLine."TA/Comm Credit Memo" := TRUE;
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
        GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
        GenJnlLine.INSERT;


        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
          GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
        PostGenJnlLines;
    end;

    local procedure CreateTDSEntry(P_TDSBaseAmount: Decimal; P_TDSAmount: Decimal; P_PostDate: Date; P_VendorNo: Code[20]; P_DocumentNo: Code[20]; P_TDSPerCent: Decimal)
    var
        TDSEntry: Record "TDS Entry";
        v_TDSEntry: Record "TDS Entry";
        NextTDSEntryNo: Integer;
        TDSGroup: Record "TDS Setup";
        Vendor: Record Vendor;
        //NODLines: Record 13785;//Need to check the code in UAT

        //NatureofDeduction: Record 13726;//Need to check the code in UAT

        CompanyInfo: Record "Company Information";
        UnitSetup: Record "Unit Setup";
        AllowedSection: Record "Allowed Sections";
    begin

        UnitSetup.GET;

        TDSEntry.LOCKTABLE;
        IF TDSEntry.FINDLAST THEN
            NextTDSEntryNo := TDSEntry."Entry No." + 1
        ELSE
            NextTDSEntryNo := 1;

        TDSEntry.INIT;
        TDSEntry."Entry No." := NextTDSEntryNo;
        TDSEntry."Document Type" := TDSEntry."Document Type"::"Credit Memo";
        TDSEntry."Document No." := P_DocumentNo;
        TDSEntry."Posting Date" := P_PostDate;
        TDSEntry."Account Type" := TDSEntry."Account Type"::"G/L Account";
        //TDSEntry.Description := 'TDS Reverse';
        //TDSGroup.FindOnDate("TDS Group",P_PostDate);
        //TDSGroup.TESTFIELD("TDS Account");
        //TDSEntry."Account No." := TDSGroup."TDS Account";
        TDSEntry."Party Type" := TDSEntry."Party Type"::Vendor;
        TDSEntry."Party Code" := P_VendorNo;
        //TDSEntry."Party Account No." := "Account No.";
        //TDSEntry."TDS Group" := "TDS Group";
        TDSEntry.Section := UnitSetup."TDS Nature of Deduction";
        //TDSEntry."Assessee Code" := 'Comm';
        TDSEntry."Country Code" := 'IN';
        //TDSEntry."Transaction No." := NextTransactionNo;
        TDSEntry."TDS %" := P_TDSPerCent;

        //TDSEntry."Source Code" := "Source Code";
        IF TDSEntry."Party Type" = TDSEntry."Party Type"::Vendor THEN BEGIN
            Vendor.GET(TDSEntry."Party Code");
            TDSEntry."Deductee PAN No." := Vendor."P.A.N. No.";//Need to check the code in UAT
            AllowedSection.Reset();
            AllowedSection.SetRange("Vendor No", TDSEntry."Party Code");
            IF AllowedSection.FindFirst() then
                TDSEntry.Section := AllowedSection."TDS Section";//Need to check the code in UAT

        END;

        TDSEntry."TDS Line Amount" := ABS(P_TDSAmount);
        TDSEntry."TDS Base Amount" := ABS(P_TDSBaseAmount);
        TDSEntry."TDS Amount" := ABS(P_TDSAmount);
        TDSEntry."TDS Amount Including Surcharge" := ABS(P_TDSAmount);
        TDSEntry."Invoice Amount" := TDSEntry."TDS Base Amount";
        //TDSEntry."Rem. Total TDS Incl. SHE CESS" := ABS(P_TDSAmount);//Need to check the code in UAT

        TDSEntry."Remaining TDS Amount" := ABS(P_TDSAmount);
        /*
        NODLines.RESET;
        NODLines.SETRANGE(Type, NODLines.Type::Vendor);
        NODLines.SETRANGE("No.", P_VendorNo);
        NODLines.SETRANGE("NOD/NOC", UnitSetup."TDS Nature of Deduction");
        IF NODLines.FINDFIRST THEN BEGIN
            TDSEntry."Concessional Code" := NODLines."Concessional Code";
            TDSEntry."Concessional Form" := NODLines."Concessional Form No.";
        END;
        NatureofDeduction.GET(UnitSetup."TDS Nature of Deduction");
        TDSEntry."TDS Category" := NatureofDeduction.Category;
        *///Need to check the code in UAT

        CompanyInfo.GET;
        TDSEntry."T.A.N. No." := CompanyInfo."T.A.N. No.";
        TDSEntry.TESTFIELD("T.A.N. No.");
        TDSEntry."Original TDS Base Amount" := TDSEntry."TDS Base Amount";
        TDSEntry.INSERT(TRUE);
    end;


    procedure TA_ReversalWithTDSformTravelPage(Associate_1: Code[20]; Amt_1: Decimal; OrderRefNo: Code[20]; PostDate_1: Date; ProjectCode: Code[20]; TravelPmtEntries: Record "Travel Payment Entry")
    var
        NarrationText1: Text[250];
        Bond: Record "Confirmed Order";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CommissionEntry_1: Record "Commission Entry";
        CommissionEntry_2: Record "Commission Entry";
        PostCreditNote_1: Boolean;
        CreateCommInvoice: Codeunit "UpdateCharges /Post/Rev AssPmt";
        Type_1: Option " ",Incentive,Commission,TA,ComAndTA;
        CommEntry_2: Record "Commission Entry";
        ClbAmt: Decimal;
        StartDate: Date;
        EndDate: Date;
        Year: Integer;
        Month: Integer;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PostPayment: Codeunit PostPayment;
        TDSPercent: Decimal;
        TDSBaseAmt: Decimal;
        TDSEntry: Record "TDS Entry";
        TDSReversAmount: Decimal;
        NewTravelPaymentEntry: Record "Travel Payment Entry";
        LastTravelPaymentEntry: Record "Travel Payment Entry";
        LastLineNo: Integer;
        NewConfirmedOrder: Record "New Confirmed Order";
        v_ConfirmedOrder: Record "Confirmed Order";
        TAAppwiseDet1: Record "TA Application wise Details";
        TAAppwiseDet: Record "TA Application wise Details";
        TravelPayDetails: Record "Travel Payment Details";
    begin

        //This function also use in Tavel Approved page 091123 Dt
        BondSetup.GET;

        StartDate := 0D;
        Year := 0;
        Month := 0;

        Year := DATE2DMY(TODAY, 3);
        Month := DATE2DMY(TODAY, 2);

        IF (Month = 1) OR (Month = 2) OR (Month = 3) THEN
            StartDate := DMY2DATE(1, 1, Year)
        ELSE
            IF (Month = 4) OR (Month = 5) OR (Month = 6) THEN
                StartDate := DMY2DATE(1, 4, Year)
            ELSE
                IF (Month = 7) OR (Month = 8) OR (Month = 9) THEN
                    StartDate := DMY2DATE(1, 7, Year)
                ELSE
                    IF (Month = 10) OR (Month = 11) OR (Month = 12) THEN
                        StartDate := DMY2DATE(1, 10, Year);

        TDSBaseAmt := 0;

        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date");
        //TDSEntry.SETRANGE(TDSEntry."Party Type", TDSEntry."Party Type"::Vendor);
        //TDSEntry.SETRANGE(TDSEntry."Party Code", Associate_1); Changes in BC
        TDSEntry.SETRANGE("Vendor No.", Associate_1);
        TDSEntry.SETRANGE("Posting Date", StartDate, TODAY);
        IF TDSEntry.FINDSET THEN
            REPEAT
                TDSBaseAmt := TDSBaseAmt + TDSEntry."TDS Base Amount";
            UNTIL TDSEntry.NEXT = 0;

        IF (TDSBaseAmt - ABS(Amt_1)) > 0 THEN BEGIN
            TDSPercent := 0;
            TDSPercent := PostPayment.CalculateTDSPercentage(Associate_1, BondSetup."TDS Nature of Deduction", '');
            TDSReversAmount := 0;
            TDSReversAmount := ABS((Amt_1 * TDSPercent / 100));
            TDSReversAmount := ROUND(TDSReversAmount, 1, '=');
            TDSBaseAmt := ABS(Amt_1);
        END ELSE BEGIN
            TDSPercent := 0;
            TDSPercent := PostPayment.CalculateTDSPercentage(Associate_1, BondSetup."TDS Nature of Deduction", '');
            TDSReversAmount := 0;
            TDSReversAmount := (TDSBaseAmt * TDSPercent / 100);
            TDSReversAmount := ROUND(TDSReversAmount, 1, '=');
        END;


        ClbAmt := 0;
        ClbAmt := ROUND(ABS(Amt_1 * BondSetup."Corpus %" / 100), 0.01, '=');

        UserSetup.GET(USERID);
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", BondSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", BondSetup."Transfer Member Batch Name");
        GenJnlLine.DELETEALL;
        BondSetup.TESTFIELD("Posted TA Credit Memo");
        DocNo := '';
        IF PostDate_1 = 0D THEN
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", WORKDATE, TRUE)
        ELSE
            DocNo := NoSeriesMgt.GetNextNo(BondSetup."Posted TA Credit Memo", PostDate_1, TRUE);
        //ALLEDK 260113

        NarrationText1 := 'TA Credit Memo- ' + COPYSTR(Associate_1, 1, 30);

        PostEntry := FALSE;

        IF (ABS(Amt_1) - ABS(ClbAmt) - ABS(TDSReversAmount)) > 0 THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 10000;
            GenJnlLine.VALIDATE("Posting Date", TODAY);
            GenJnlLine.VALIDATE("Document Date", TODAY);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", Associate_1);
            GenJnlLine."Document No." := DocNo;

            GenJnlLine.VALIDATE(Amount, (ABS(Amt_1) - ABS(ClbAmt) - ABS(TDSReversAmount)));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::Vendor);
            GenJnlLine.VALIDATE("Source No.", Associate_1);
            GenJnlLine."Source Code" := 'Purchases';
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            GenJnlLine.Description := 'TA-TDS/Club 9 Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine.INSERT;
            PostEntry := TRUE;
        END;
        IF ABS(TDSReversAmount) <> 0 THEN BEGIN

            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 20000;
            GenJnlLine.VALIDATE("Posting Date", TODAY);
            GenJnlLine.VALIDATE("Document Date", TODAY);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."TDS Payable Commission A/c");
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, (ABS(TDSReversAmount)));
            GenJnlLine."Source Code" := 'Purchases';
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            GenJnlLine.Description := 'TA -TDS/Club 9 Reversal';
            ;
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine.INSERT;
            PostEntry := TRUE;
        END;

        IF ABS(ClbAmt) <> 0 THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 30000;
            GenJnlLine.VALIDATE("Posting Date", TODAY);
            GenJnlLine.VALIDATE("Document Date", TODAY);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."Corpus A/C");
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, (ABS(ClbAmt)));
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::" ");
            GenJnlLine."Source Code" := 'Purchases';
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            GenJnlLine.Description := 'TA -TDS/Club 9 Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine.INSERT;
            PostEntry := TRUE;
        END;

        IF ABS(ClbAmt) <> 0 THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := BondSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := BondSetup."Transfer Member Batch Name";
            GenJnlLine."Line No." := 40000;
            GenJnlLine.VALIDATE("Posting Date", TODAY);
            GenJnlLine.VALIDATE("Document Date", TODAY);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", BondSetup."Commission A/C");
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount, -1 * Amt_1);
            GenJnlLine.VALIDATE("Source Type", GenJnlLine."Source Type"::" ");
            GenJnlLine."Source Code" := 'Purchases';//BondSetup."Cr. Source Code";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Introducer Code" := Bond."Introducer Code";
            GenJnlLine."External Document No." := DocNo;
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::"Travel Allowance";
            GenJnlLine."Unit No." := Bond."No.";
            GenJnlLine."Application No." := OrderRefNo;
            GenJnlLine.Description := 'TA -TDS/TA Reversal';
            GenJnlLine."TA/Comm Credit Memo" := TRUE;
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", ProjectCode);  //INS1.0
            GenJnlLine."Shortcut Dimension 2 Code" := CheckCostHead(BondSetup."Commission A/C");
            GenJnlLine.INSERT;
            PostEntry := TRUE;
        END;

        IF PostEntry THEN BEGIN
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", NarrationText1);
            PostGenJnlLines;
            IF ABS(TDSReversAmount) > 0 THEN
                CreateTDSEntry(TDSBaseAmt, TDSReversAmount, TODAY, Associate_1, DocNo, TDSPercent);

            //091123 Start
            LastLineNo := 0;
            LastTravelPaymentEntry.RESET;
            LastTravelPaymentEntry.SETRANGE("Document No.", TravelPmtEntries."Document No.");
            IF LastTravelPaymentEntry.FINDLAST THEN
                LastLineNo := LastTravelPaymentEntry."Line No.";
            NewTravelPaymentEntry.INIT;
            NewTravelPaymentEntry.TRANSFERFIELDS(TravelPmtEntries);
            NewTravelPaymentEntry."Amount to Pay" := -1 * TravelPmtEntries."Amount to Pay";
            NewTravelPaymentEntry."Line No." := LastLineNo + 10000;
            NewTravelPaymentEntry.Reverse := TRUE;
            NewTravelPaymentEntry."Voucher No." := DocNo;
            NewTravelPaymentEntry."Post Payment" := TRUE;
            NewTravelPaymentEntry.INSERT;

            //INSERT--------Start-----  TA Reversal show on Confirme order

            TravelPayDetails.RESET;
            TravelPayDetails.SETRANGE("Application No.", TravelPmtEntries."Application No.");
            TravelPayDetails.SETRANGE(Approved, TRUE);
            TravelPayDetails.SETRANGE(Reverse, FALSE);
            TravelPayDetails.SETRANGE("Document No.", TravelPmtEntries."Document No.");
            IF TravelPayDetails.FINDLAST THEN BEGIN
                TravelPayDetails.Reverse := TRUE;
                TravelPayDetails.MODIFY;
            END;
            TAAppwiseDet1.RESET;
            TAAppwiseDet1.SETRANGE("Document No.", TravelPmtEntries."Document No.");
            TAAppwiseDet1.SETRANGE("Application No.", TravelPmtEntries."Application No.");
            IF TAAppwiseDet1.FINDLAST THEN
                LineNo := TAAppwiseDet1."Line No."
            ELSE
                LineNo := 0;

            TAAppwiseDet.INIT;
            TAAppwiseDet.TRANSFERFIELDS(TAAppwiseDet1);
            TAAppwiseDet."Line No." := LineNo + 10000;
            TAAppwiseDet."TA Amount" := -1 * TAAppwiseDet1."TA Amount";
            TAAppwiseDet.INSERT;
            //BBG1.2 231213
            //INSERT---------END----------


            NewConfirmedOrder.RESET;
            IF NewConfirmedOrder.GET(NewTravelPaymentEntry."Application No.") THEN BEGIN
                IF NewConfirmedOrder."Travel Generate" THEN BEGIN
                    NewConfirmedOrder."Travel Generate" := FALSE;
                    NewConfirmedOrder.MODIFY;
                END;
                v_ConfirmedOrder.RESET;
                IF v_ConfirmedOrder.GET(NewConfirmedOrder."No.") THEN BEGIN
                    IF v_ConfirmedOrder."Travel Generate" THEN BEGIN
                        v_ConfirmedOrder."Travel Generate" := FALSE;
                        v_ConfirmedOrder.MODIFY;
                    END;
                END;
            END;
            //091123 End
        END;
    end;
}

