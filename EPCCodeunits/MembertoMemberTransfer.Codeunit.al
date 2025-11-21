codeunit 97736 "Member to Member Transfer"
{
    // //BBG1.00 ALLEDK 050313 Code commented for Dim-3


    trigger OnRun()
    begin
    end;

    var
        AppPaymentEntry: Record "Application Payment Entry";
        LastLineNo: Integer;
        InsertAppLines: Record "Application Payment Entry";
        BondSetup: Record "Unit Setup";
        Unitmaster: Record "Unit Master";
        PaymentTermLines: Record "Payment Terms Line Sale";
        BondpaymentEntry: Record "Unit Payment Entry";
        LineNo: Integer;
        UnitAppPaymentEntry: Record "Unit Payment Entry";
        UnitLastLineNo: Integer;
        InsertUnitAppLines: Record "Unit Payment Entry";
        Amt: Decimal;
        ApplyAmt: Decimal;
        TotalAmt: Decimal;
        ApplyAmt1: Decimal;
        //MTMDebitNoteGen: Report 50084;
        RecUnitPEntry: Record "Unit Payment Entry";
        RecUnitPEntryDirect: Record "Unit Payment Entry";
        AssociateAmt: Decimal;
        DirectAssAmt: Decimal;
        OldAPPNo: Code[20];
        NewAPPNo: Code[20];
        CustNo: Code[20];
        UnitSetup: Record "Unit Setup";
        GenJnlLine: Record "Gen. Journal Line" temporary;
        PostDate: Date;
        LineNo2: Integer;
        GenJnlBatch: Record "Gen. Journal Batch";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        RecConfOrder: Record "Confirmed Order";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        DimCode: Code[20];
        PostPayment: Codeunit PostPayment;
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        Dim2Code: Code[20];
        UnitReversal: Codeunit "Unit Reversal";
        CreatUPEryfromConfOrder: Codeunit "Creat UPEry from ConfOrder/APP";
        NewAppPaymentEntry: Record "NewApplication Payment Entry";
        NewInsertAppLines: Record "NewApplication Payment Entry";


    procedure MembertoMemberTransfer(var DOCNo: Code[20]; ReverseComm: Boolean)
    var
        TrfApplicationPayEntry: Record "Application Payment Entry";
        TrfUnitApplPayEntry: Record "Unit Payment Entry";
        ConfOrder: Record "Confirmed Order";
        DifferenceAmount: Decimal;
        AppliPaymentAmount: Decimal;
        LoopingDifferAmount: Decimal;
        BondPayLineAmt: Decimal;
        TotalBondAmount: Decimal;
        TrfApplicationPayEntry1: Record "Application Payment Entry";
        TotalRecdAmt: Decimal;
        UnitPayEntrybuffer: Record "Unit Payment Entry buffer";
        DelUPEntry: Record "Unit Payment Entry";
        UpdateOldUPEntry: Record "Unit Payment Entry";
        UnitCommBuffer: Record "Unit & Comm. Creation Buffer";
        TotalRecAmt: Decimal;
        v_MinAmount: Decimal;
        CommReversalDone: Boolean;
    begin
        Amt := 0;
        ApplyAmt1 := 0;
        ApplyAmt := 0;
        AssociateAmt := 0;
        DirectAssAmt := 0;
        OldAPPNo := '';
        NewAPPNo := '';
        CustNo := '';
        PostDate := 0D;
        DimCode := '';
        TrfApplicationPayEntry.RESET;
        TrfApplicationPayEntry.SETRANGE("Document No.", DOCNo);
        TrfApplicationPayEntry.SETRANGE("Payment Mode", TrfApplicationPayEntry."Payment Mode"::MJVM);
        TrfApplicationPayEntry.SETRANGE(Posted, TRUE);
        IF TrfApplicationPayEntry.FINDLAST THEN BEGIN
            Amt := TrfApplicationPayEntry.Amount;
            PostDate := TrfApplicationPayEntry."Posting date";
            AppPaymentEntry.RESET;
            AppPaymentEntry.SETRANGE("Document No.", TrfApplicationPayEntry."Order Ref No.");
            IF AppPaymentEntry.FINDLAST THEN
                LastLineNo := AppPaymentEntry."Line No.";

            InsertAppLines.INIT;
            InsertAppLines."Document Type" := InsertAppLines."Document Type"::BOND;
            InsertAppLines."Document No." := TrfApplicationPayEntry."Order Ref No.";
            InsertAppLines."Line No." := LastLineNo + 10000;
            InsertAppLines."Payment Method" := TrfApplicationPayEntry."Payment Method";
            InsertAppLines.Amount := -TrfApplicationPayEntry.Amount;
            InsertAppLines."Payment Mode" := TrfApplicationPayEntry."Payment Mode";
            InsertAppLines.Posted := TRUE;
            InsertAppLines."Unit Code" := TrfApplicationPayEntry."Unit Code";
            InsertAppLines.Description := TrfApplicationPayEntry.Description;
            InsertAppLines."Document Date" := TrfApplicationPayEntry."Document Date";
            InsertAppLines."User Branch Code" := TrfApplicationPayEntry."User Branch Code";
            InsertAppLines."User Branch Code" := TrfApplicationPayEntry."User Branch Code";
            InsertAppLines."User ID" := TrfApplicationPayEntry."User ID";
            InsertAppLines."User Branch Name" := TrfApplicationPayEntry."User Branch Name";
            InsertAppLines."Posted Document No." := TrfApplicationPayEntry."Posted Document No.";
            InsertAppLines."Posting date" := TrfApplicationPayEntry."Posting date";
            InsertAppLines."Shortcut Dimension 1 Code" := TrfApplicationPayEntry."Shortcut Dimension 1 Code";
            InsertAppLines."Cheque Status" := InsertAppLines."Cheque Status"::Cleared;
            InsertAppLines."Explode BOM" := TRUE;
            InsertAppLines."Application No." := TrfApplicationPayEntry."Order Ref No.";
            InsertAppLines."Reverse Commission" := ReverseComm;
            InsertAppLines.INSERT;
            IF ReverseComm THEN BEGIN  //ALLE 280415
                PostPayment.InsertRefundUnitPaymentLines(InsertAppLines."Document No.", InsertAppLines);
                IF ConfOrder.GET(InsertAppLines."Document No.") THEN;

                TrfApplicationPayEntry1.RESET;
                TrfApplicationPayEntry1.SETRANGE("Document No.", InsertAppLines."Document No.");
                TrfApplicationPayEntry1.SETRANGE("Cheque Status", TrfApplicationPayEntry1."Cheque Status"::Cleared);
                IF TrfApplicationPayEntry1.FINDSET THEN
                    REPEAT
                        TotalRecdAmt := TotalRecdAmt + TrfApplicationPayEntry1.Amount;
                    UNTIL TrfApplicationPayEntry1.NEXT = 0;

                CommReversalDone := FALSE;
                v_MinAmount := 0;
                v_MinAmount := ConfOrder."Min. Allotment Amount";
                TotalRecAmt := 0;

                IF v_MinAmount > TotalRecdAmt THEN BEGIN
                    UnitReversal.CommisionReverse(InsertAppLines."Application No.", FALSE);  //061114
                    CommReversalDone := TRUE;
                END;


                UnitPayEntrybuffer.DELETEALL;
                UnitCommBuffer.RESET;
                UnitCommBuffer.SETRANGE(UnitCommBuffer."Unit No.", InsertAppLines."Document No.");
                IF UnitCommBuffer.FINDSET THEN
                    UnitCommBuffer.DELETEALL;

                CreatUPEryfromConfOrder.UpdateBufferUnitpayentryLine(InsertAppLines."Document No.", TotalRecdAmt);

                DelUPEntry.RESET;
                DelUPEntry.SETRANGE("Document No.", InsertAppLines."Document No.");
                DelUPEntry.SETFILTER("Balance Amount", '<>%1', 0);
                IF DelUPEntry.FINDSET THEN
                    REPEAT
                        DelUPEntry."Balance Amount" := 0;
                        DelUPEntry.MODIFY;
                    UNTIL DelUPEntry.NEXT = 0;

                //Check Commission --------200522

                IF NOT ConfOrder."Commission Hold on Full Pmt" THEN BEGIN
                    IF NOT CommReversalDone THEN
                        UnitReversal.CommisionReverse(InsertAppLines."Application No.", FALSE);  //061114
                    UnitPayEntrybuffer.RESET;
                    UnitPayEntrybuffer.SETRANGE("Document No.", InsertAppLines."Document No.");
                    IF UnitPayEntrybuffer.FINDSET THEN
                        REPEAT
                            CreateStagingTableAppBond(ConfOrder, UnitPayEntrybuffer."Line No.", 1, UnitPayEntrybuffer.Sequence,
                            UnitPayEntrybuffer."Cheque No./ Transaction No.", UnitPayEntrybuffer."Commision Applicable",
                            UnitPayEntrybuffer."Direct Associate", UnitPayEntrybuffer."Posting date", UnitPayEntrybuffer.Amount, UnitPayEntrybuffer);
                            TotalRecAmt := TotalRecAmt + UnitPayEntrybuffer.Amount;
                        UNTIL UnitPayEntrybuffer.NEXT = 0;
                END ELSE BEGIN
                    IF CommReversalDone THEN BEGIN
                        UnitPayEntrybuffer.RESET;
                        UnitPayEntrybuffer.SETRANGE("Document No.", InsertAppLines."Document No.");
                        IF UnitPayEntrybuffer.FINDSET THEN
                            REPEAT
                                IF v_MinAmount > UnitPayEntrybuffer.Amount THEN BEGIN
                                    CreateStagingTableAppBond(ConfOrder, UnitPayEntrybuffer."Line No.", 1, UnitPayEntrybuffer.Sequence,
                                    UnitPayEntrybuffer."Cheque No./ Transaction No.", UnitPayEntrybuffer."Commision Applicable",
                                    UnitPayEntrybuffer."Direct Associate", UnitPayEntrybuffer."Posting date", UnitPayEntrybuffer.Amount, UnitPayEntrybuffer);
                                    v_MinAmount := v_MinAmount - UnitPayEntrybuffer.Amount;
                                END ELSE BEGIN
                                    IF v_MinAmount <> 0 THEN BEGIN
                                        CreateStagingTableAppBond(ConfOrder, UnitPayEntrybuffer."Line No.", 1, UnitPayEntrybuffer.Sequence,
                                        UnitPayEntrybuffer."Cheque No./ Transaction No.", UnitPayEntrybuffer."Commision Applicable",
                                        UnitPayEntrybuffer."Direct Associate", UnitPayEntrybuffer."Posting date", v_MinAmount, UnitPayEntrybuffer);
                                    END;
                                    v_MinAmount := 0;
                                END;
                            UNTIL (UnitPayEntrybuffer.NEXT = 0);
                    END;
                END;
                //Check Commission --------200522

                IF TotalRecAmt >= ConfOrder."Min. Allotment Amount" THEN
                    UpdatestagingtableRefund(InsertAppLines."Document No.", TotalRecAmt);
                CLEAR(UnitPayEntrybuffer);
                UnitPayEntrybuffer.RESET;
                UnitPayEntrybuffer.SETRANGE("Document No.", InsertAppLines."Document No.");
                UnitPayEntrybuffer.SETFILTER("Balance Amount", '<>%1', 0);
                IF UnitPayEntrybuffer.FINDSET THEN
                    REPEAT
                        CLEAR(UpdateOldUPEntry);
                        UpdateOldUPEntry.RESET;
                        UpdateOldUPEntry.SETRANGE("Document No.", UnitPayEntrybuffer."Document No.");
                        UpdateOldUPEntry.SETRANGE("Charge Code", UnitPayEntrybuffer."Charge Code");
                        IF UpdateOldUPEntry.FINDFIRST THEN BEGIN
                            UpdateOldUPEntry."Balance Amount" := UnitPayEntrybuffer."Balance Amount";
                            UpdateOldUPEntry.MODIFY;
                        END;
                    UNTIL UnitPayEntrybuffer.NEXT = 0;
            END;
            //ALLE 280415
        END;
    end;


    procedure CommissionDebittoVendor(var AssociateCode: Code[20]; DBAmt: Decimal)
    begin
    end;


    procedure CusttoCustTransferwithAppNo(RecOldAPPNo: Code[20]; RecNewAPPNo: Code[20]; RecCustNo: Code[20]; PostDate: Date; RecAmt: Decimal)
    var
        RecConfOrder: Record "Confirmed Order";
        UnitPayEntrybuffer: Record "Unit Payment Entry buffer";
    begin
        CLEAR(GenJnlPostLine);
        IF RecConfOrder.GET(DocNo) THEN;
        UserSetup.GET(USERID);


        UnitSetup.GET;
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        IF GenJnlLine.FINDLAST THEN
            LineNo2 := GenJnlLine."Line No.";

        GenJnlLine.INIT;
        LineNo2 += 10000;

        GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";

        //    IF GenJnlBatch.GET(UnitSetup."Transfer Member Temp Name",UnitSetup."Transfer Member Batch Name") THEN
        DocNo := NoSeriesMgt.GetNextNo(UnitSetup."Member to Member No. Series", WORKDATE, TRUE);

        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Line No." := LineNo2;
        GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::" ");
        GenJnlLine.VALIDATE("Posting Date", PostDate);
        GenJnlLine.VALIDATE("Document Date", PostDate);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", RecCustNo);
        GenJnlLine.VALIDATE("Debit Amount", ABS(Amt));
        GenJnlLine."Source Code" := 'GENJNL';
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source No." := RecCustNo;
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", UnitSetup."Transfer Control Account");
        GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Running);
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", RecConfOrder."Shortcut Dimension 1 Code");
        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
        GenJnlLine."Order Ref No." := RecOldAPPNo;
        GenJnlLine."Branch Code" := UserSetup."User Branch";
        GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::" "; //ALLEDK 170213
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::MJVM; //ALLEDK010313
        GenJnlLine."Shortcut Dimension 1 Code" := DimCode;
        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
          GenJnlLine."Line No.", GenJnlLine."Line No.", 'Transfer MTM with Diff. Application');
        InsertJnDimension(GenJnlLine);  //ALLEDK 310113
        GenJnlPostLine.RunWithCheck(GenJnlLine); //ALLEDK 310113

        GenJnlLine.DELETEALL;  //ALLEDK 310113
        GenJnlLine.RESET;
        GenJnlLine.INIT;
        LineNo2 += 10000;
        GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";

        //IF GenJnlBatch.GET(UnitSetup."Transfer Member Temp Name",UnitSetup."Transfer Member Batch Name") THEN
        DocNo := NoSeriesMgt.GetNextNo(UnitSetup."Member to Member No. Series", WORKDATE, TRUE);
        //     DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series",WORKDATE,TRUE);

        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Line No." := LineNo2;
        GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::" ");
        GenJnlLine.VALIDATE("Posting Date", PostDate);
        GenJnlLine.VALIDATE("Document Date", PostDate);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", RecCustNo);
        GenJnlLine.VALIDATE("Credit Amount", ABS(Amt));
        GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Running);
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", RecConfOrder."Shortcut Dimension 1 Code");
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", UnitSetup."Transfer Control Account");
        GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::" "; //ALLEDK 170213
        GenJnlLine."Branch Code" := UserSetup."User Branch";
        GenJnlLine."Source Code" := 'GENJNL';
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
        GenJnlLine."Source No." := RecCustNo;
        GenJnlLine."Order Ref No." := RecNewAPPNo;
        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Shortcut Dimension 1 Code" := DimCode;
        GenJnlLine."Payment Mode" := GenJnlLine."Payment Mode"::MJVM; //ALLEDK010313
                                                                      //GenJnlLine.INSERT;
        InsertJnDimension(GenJnlLine);  //ALLEDK 310113

        InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
          GenJnlLine."Line No.", GenJnlLine."Line No.", 'Transfer MTM with Diff. Application');

        //GenJnlPostLine.RUN(GenJnlLine); 310113

        GenJnlPostLine.RunWithCheck(GenJnlLine); //ALLEDK 310113
    end;


    procedure InitVoucherNarration(JnlTemplate: Code[10]; JnlBatch: Code[10]; DocumentNo: Code[20]; GenJnlLineNo: Integer; NarrationLineNo: Integer; LineNarrationText: Text[50])
    var
        GenJnlNarration: Record "Gen. Journal Narration"; // "Gen. Journal Narration";
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


    procedure InsertJnDimension(RecGenLine: Record "Gen. Journal Line")
    begin
        // ALLE MM Code Commented
        /*
        GLSetup.GET;
        UserSetup.GET(USERID);
        JournalLineDimension.DELETEALL;
        //BBG1.00 ALLEDK 050313
        GLSetup.GET;
        UserSetup.GET(USERID);
        JournalLineDimension.INIT;
        JournalLineDimension."Table ID" := 81;
        JournalLineDimension."Journal Template Name" := RecGenLine."Journal Template Name";
        JournalLineDimension."Journal Batch Name" := RecGenLine."Journal Batch Name";
        JournalLineDimension."Journal Line No." := RecGenLine."Line No.";
        JournalLineDimension."Dimension Code" := GLSetup."Shortcut Dimension 1 Code";
        JournalLineDimension."Dimension Value Code" := RecGenLine."Shortcut Dimension 1 Code";
        JournalLineDimension.INSERT;
        */
        // ALLE MM Code Commented

    end;


    procedure CreateStagingTableAppBond(Application: Record "Confirmed Order"; InstallmentNo: Integer; YearCode: Integer; MilestoneCode: Code[10]; ChequeNo: Code[20]; CommTree: Boolean; DirectAss: Boolean; PostDate: Date; BaseAmount: Decimal; RecUPayEntry1: Record "Unit Payment Entry buffer")
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
        AmountRecd: Decimal;
    begin
        //CreateStagingTableApplication
        Bond.GET(Application."No.");                                                              //ALLETDK
        //AmountRecd := Bond.AmountRecdAppl(Application."No.");             //ALLETDK
        //BaseAmount := UpdateUnit_ComBufferAmt(RecUPayEntry1,FALSE);  //200522
        IF BaseAmount <> 0 THEN BEGIN
            InitialStagingTab.INIT;
            InitialStagingTab."Unit No." := Application."No.";           //ALLETDk
            InitialStagingTab."Installment No." := InstallmentNo + 1;
            InitialStagingTab."Posting Date" := PostDate; //ALLEDK 130113
            InitialStagingTab.VALIDATE("Introducer Code", Application."Introducer Code");  //ALLETDK
                                                                                           //InitialStagingTab."Base Amount" := BaseAmount;    //ALLEDK 211014
            InitialStagingTab."Base Amount" := BaseAmount; //ALLEDK 211014
            InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
            InitialStagingTab.Duration := Application.Duration;
            InitialStagingTab."Year Code" := YearCode;
            InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
            InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
            InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
            InitialStagingTab."Application No." := Application."No."; //ALLETDK
                                                                      //InitialStagingTab."Paid by cheque" := ByCheque;                   //ALLETDK
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

            InitialStagingTab."Direct Associate" := DirectAss;
            InitialStagingTab.INSERT;
        END;
    end;


    procedure UpdateUnit_ComBufferAmt(RecUnitPayEntry: Record "Unit Payment Entry buffer"; FromApplication: Boolean): Decimal
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
        UnitPEntry: Record "Unit Payment Entry buffer";
        BalanceAmt: Decimal;
        OnFullPmt: Boolean;
        AssoBalanceAmt: Decimal;
        TotalBalAmt: Decimal;
        TotalAssBalAmt: Decimal;
        AppCharge: Record "Applicable Charges";
        UnitPmtEntry: Record "Unit Payment Entry buffer";
        TotalAmt: Decimal;
        ExistCommAmt: Decimal;
        Firstmileston: Decimal;
        Secondmileston: Decimal;
        PaymentTermLineSale: Record "Payment Terms Line Sale";
        MilestonSequence: Code[10];
        DelUPEntry: Record "Unit Payment Entry buffer";
        ComHoldDate: Date;
        Postdate1: Date;
    begin
        CLEAR(PTLineSale);
        CLEAR(RecApplication1);
        CLEAR(AppAmt);
        CLEAR(RecConforder1);
        CLEAR(BalanceAmt);
        CLEAR(ComHoldDate);
        CLEAR(Postdate1);

        FullAmountRcvd := FALSE;
        IF RecConforder1.GET(RecUnitPayEntry."Application No.") THEN BEGIN
            AppAmt := RecConforder1.Amount;
            Postdate1 := RecConforder1."Posting Date";
        END;

        ComHoldDate := DMY2DATE(31, 10, 2014);

        IF Postdate1 > ComHoldDate THEN BEGIN


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
            IF AppCharge.FINDSET THEN BEGIN
                REPEAT
                    CLEAR(UnitPmtEntry);
                    TotalAmt := 0;
                    ExistCommAmt := 0;
                    UnitPmtEntry.RESET;
                    UnitPmtEntry.SETRANGE(UnitPmtEntry."Document No.", AppCharge."Document No.");
                    UnitPmtEntry.SETRANGE(UnitPmtEntry."Charge Code", AppCharge.Code);
                    IF UnitPmtEntry.FINDFIRST THEN BEGIN
                        UnitPmtEntry.CALCFIELDS(UnitPmtEntry."Unit & Buffer Base Amount", UnitPmtEntry."Commission Entry Base Amount");
                        ExistCommAmt := UnitPmtEntry."Unit & Buffer Base Amount" + UnitPmtEntry."Commission Entry Base Amount";
                    END;

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


                    CLEAR(UnitPmtEntry);
                    UnitPmtEntry.RESET;
                    UnitPmtEntry.SETRANGE(UnitPmtEntry."Document No.", AppCharge."Document No.");
                    UnitPmtEntry.SETRANGE(UnitPmtEntry."Charge Code", AppCharge.Code);
                    UnitPmtEntry.SETFILTER("Line No.", '<%1', RecUnitPayEntry."Line No.");
                    IF UnitPmtEntry.FINDSET THEN BEGIN
                        REPEAT
                            TotalAmt := TotalAmt + UnitPmtEntry.Amount;
                        UNTIL UnitPmtEntry.NEXT = 0;
                        TotalAmt := TotalAmt + RecUnitPayEntry.Amount;

                        IF (AppCharge."Net Amount" * Firstmileston / 100) >= TotalAmt THEN BEGIN
                            UnitBufferAmt := RecUnitPayEntry.Amount;
                        END ELSE BEGIN
                            IF Firstmileston <> 0 THEN
                                UnitBufferAmt := (AppCharge."Net Amount" * Firstmileston / 100) - ExistCommAmt
                            ELSE
                                UnitBufferAmt := 0;
                            IF UnitBufferAmt < 0 THEN
                                UnitBufferAmt := 0;

                            DelUPEntry.RESET;
                            DelUPEntry.SETRANGE("Document No.", AppCharge."Document No.");
                            DelUPEntry.SETRANGE("Charge Code", AppCharge.Code);
                            IF DelUPEntry.FINDSET THEN
                                REPEAT
                                    DelUPEntry."Balance Amount" := 0;
                                    DelUPEntry.MODIFY;
                                UNTIL DelUPEntry.NEXT = 0;
                            UnitPmtEntry."Balance Amount" := TotalAmt - (AppCharge."Net Amount" * Firstmileston / 100);
                            UnitPmtEntry.MODIFY;
                        END;
                    END ELSE BEGIN
                        UnitBufferAmt := RecUnitPayEntry.Amount;
                        IF Firstmileston = 0 THEN BEGIN
                            UnitBufferAmt := 0;
                            RecUnitPayEntry."Balance Amount" := RecUnitPayEntry.Amount;
                            RecUnitPayEntry.MODIFY;
                        END;
                    END;
                UNTIL AppCharge.NEXT = 0;
            END ELSE
                UnitBufferAmt := RecUnitPayEntry.Amount;

            CLEAR(UnitPmtEntry);
            UnitPmtEntry.RESET;
            UnitPmtEntry.SETRANGE(UnitPmtEntry."Document No.", AppCharge."Document No.");
            UnitPmtEntry.SETFILTER("Line No.", '>%1', RecUnitPayEntry."Line No.");
            IF NOT UnitPmtEntry.FINDFIRST THEN BEGIN

                IF FullAmountRcvd THEN BEGIN
                    AssoBalanceAmt := 0;
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
                            IF NOT RecConforder1."Commission Hold on Full Pmt" THEN //200522
                                CreateStaggingforBalAmt(UnitPEntry, BalanceAmt, FALSE);
                        UNTIL UnitPEntry.NEXT = 0;
                    END;
                END;
            END;
        END ELSE
            UnitBufferAmt := RecUnitPayEntry.Amount;

        EXIT(UnitBufferAmt);
    end;


    procedure CreateStaggingforBalAmt(RecUnitPayEntry1: Record "Unit Payment Entry buffer"; PendingAmt: Decimal; FromAplication: Boolean)
    var
        RecInitialStagingTab: Record "Unit & Comm. Creation Buffer";
        RecInitialStagingTab1: Record "Unit & Comm. Creation Buffer";
        Application: Record Application;
        FromConfirmedOrder: Record "Confirmed Order";
        InstallationNo: Integer;
    begin
        IF PendingAmt <> 0 THEN BEGIN
            RecInitialStagingTab1.RESET;
            RecInitialStagingTab1.SETRANGE("Unit No.", RecUnitPayEntry1."Document No.");
            IF RecInitialStagingTab1.FINDLAST THEN
                InstallationNo := RecInitialStagingTab1."Installment No.";

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
            RecInitialStagingTab.INSERT;
        END;
    end;


    procedure UpdatestagingtableRefund(AppCode: Code[20]; TotalRecvdAmt: Decimal)
    var
        UnitAndCommBuffer: Record "Unit & Comm. Creation Buffer";
    begin
        UnitAndCommBuffer.RESET;
        UnitAndCommBuffer.SETRANGE(UnitAndCommBuffer."Unit No.", AppCode);
        UnitAndCommBuffer.SETRANGE("Commission Created", FALSE);
        IF UnitAndCommBuffer.FINDSET THEN
            REPEAT
                UnitAndCommBuffer."Min. Allotment Amount Not Paid" := FALSE;
                UnitAndCommBuffer.MODIFY;
            UNTIL UnitAndCommBuffer.NEXT = 0;
    end;


    procedure CreateNewAppEntry(ConfOrderNo: Code[20]; FromMJV: Boolean)
    var
        AppPmtEntry: Record "Application Payment Entry";
        NewConforder_1: Record "New Confirmed Order";
    begin
        CLEAR(AppPmtEntry);
        AppPmtEntry.RESET;
        AppPmtEntry.SETRANGE("Document No.", ConfOrderNo);
        IF FromMJV THEN
            AppPmtEntry.SETRANGE("Payment Method", 'MJV')
        ELSE
            AppPmtEntry.SETRANGE("Payment Method", 'AJVM');
        AppPmtEntry.SETRANGE(Posted, TRUE);
        IF AppPmtEntry.FINDLAST THEN BEGIN
            Amt := AppPmtEntry.Amount;
            PostDate := AppPmtEntry."Posting date";
            LastLineNo := 0;
            NewAppPaymentEntry.RESET;
            NewAppPaymentEntry.SETRANGE("Document No.", AppPmtEntry."Document No.");
            IF NewAppPaymentEntry.FINDLAST THEN
                LastLineNo := NewAppPaymentEntry."Line No.";

            NewInsertAppLines.INIT;
            NewInsertAppLines."Document Type" := NewInsertAppLines."Document Type"::BOND;
            NewInsertAppLines."Document No." := AppPmtEntry."Document No.";
            NewInsertAppLines."Line No." := LastLineNo + 10000;
            NewInsertAppLines."Payment Method" := AppPmtEntry."Payment Method";
            NewInsertAppLines.Amount := AppPmtEntry.Amount;
            NewInsertAppLines."Payment Mode" := AppPmtEntry."Payment Mode";
            NewInsertAppLines.Posted := TRUE;
            NewInsertAppLines."Unit Code" := AppPmtEntry."Unit Code";
            NewInsertAppLines.Description := AppPmtEntry.Description;
            NewInsertAppLines."Document Date" := AppPmtEntry."Document Date";
            NewInsertAppLines."User Branch Code" := AppPmtEntry."User Branch Code";
            NewInsertAppLines."User Branch Code" := AppPmtEntry."User Branch Code";
            NewInsertAppLines."User ID" := AppPmtEntry."User ID";
            NewInsertAppLines."User Branch Name" := AppPmtEntry."User Branch Name";
            NewInsertAppLines."Posted Document No." := AppPmtEntry."Posted Document No.";
            NewInsertAppLines."Posting date" := AppPmtEntry."Posting date";
            NewInsertAppLines."Shortcut Dimension 1 Code" := AppPmtEntry."Shortcut Dimension 1 Code";
            NewInsertAppLines."Cheque Status" := NewInsertAppLines."Cheque Status"::Cleared;
            NewInsertAppLines."Explode BOM" := TRUE;
            NewInsertAppLines."Order Ref No." := AppPmtEntry."Order Ref No.";
            NewInsertAppLines."Company Name" := COMPANYNAME;
            NewInsertAppLines.INSERT;

            IF FromMJV THEN BEGIN
                LastLineNo := 0;

                CLEAR(NewAppPaymentEntry);
                NewAppPaymentEntry.RESET;
                NewAppPaymentEntry.SETRANGE("Document No.", AppPmtEntry."Order Ref No.");
                IF NewAppPaymentEntry.FINDLAST THEN
                    LastLineNo := NewAppPaymentEntry."Line No.";

                IF NewConforder_1.GET(NewAppPaymentEntry."Document No.") THEN;
                AppPaymentEntry.RESET;
                AppPaymentEntry.SETRANGE("Document No.", AppPmtEntry."Order Ref No.");
                AppPaymentEntry.SETRANGE("Payment Method", 'MJV');
                AppPaymentEntry.SETRANGE(Posted, TRUE);
                IF AppPaymentEntry.FINDLAST THEN BEGIN
                    NewInsertAppLines.INIT;
                    NewInsertAppLines."Document Type" := AppPaymentEntry."Document Type"::BOND;
                    NewInsertAppLines."Document No." := NewAppPaymentEntry."Document No.";
                    NewInsertAppLines."Line No." := LastLineNo + 10000;
                    NewInsertAppLines."Payment Method" := 'MJV';
                    NewInsertAppLines.Amount := -ABS(Amt);
                    NewInsertAppLines."Payment Mode" := NewInsertAppLines."Payment Mode"::MJVM;
                    NewInsertAppLines.Posted := TRUE;
                    NewInsertAppLines."Unit Code" := AppPaymentEntry."Unit Code";
                    NewInsertAppLines.Description := AppPaymentEntry.Description;
                    NewInsertAppLines."Document Date" := AppPaymentEntry."Document Date";
                    NewInsertAppLines."User Branch Code" := AppPaymentEntry."User Branch Code";
                    NewInsertAppLines."User Branch Code" := AppPaymentEntry."User Branch Code";
                    NewInsertAppLines."User ID" := AppPaymentEntry."User ID";
                    NewInsertAppLines."User Branch Name" := AppPaymentEntry."User Branch Name";
                    NewInsertAppLines."Posted Document No." := AppPaymentEntry."Posted Document No.";
                    NewInsertAppLines."Posting date" := AppPaymentEntry."Posting date";
                    NewInsertAppLines."Shortcut Dimension 1 Code" := NewAppPaymentEntry."Shortcut Dimension 1 Code";
                    NewInsertAppLines."Cheque Status" := NewInsertAppLines."Cheque Status"::Cleared;
                    NewInsertAppLines."Explode BOM" := TRUE;
                    NewInsertAppLines."Order Ref No." := AppPaymentEntry."Document No.";
                    IF NewConforder_1."Application Type" = NewConforder_1."Application Type"::Trading THEN
                        NewInsertAppLines."MJV Entry Not Posted" := FALSE
                    ELSE
                        NewInsertAppLines."MJV Entry Not Posted" := TRUE;
                    NewInsertAppLines."Company Name" := COMPANYNAME;
                    NewInsertAppLines.INSERT;
                END;
            END;
        END;
    end;


    procedure InterMembertoMemberTransfer(var DOCNo: Code[20]; ReverseComm: Boolean; CompanyCode_1: Text[30])
    var
        TrfApplicationPayEntry: Record "Application Payment Entry";
        ConfOrder: Record "Confirmed Order";
        TrfApplicationPayEntry1: Record "Application Payment Entry";
        InsertAppLines_1: Record "NewApplication Payment Entry";
        InsertAppLines_2: Record "NewApplication Payment Entry";
        CompanywiseGL: Record "Company wise G/L Account";
    begin
        Amt := 0;
        ApplyAmt1 := 0;
        ApplyAmt := 0;
        AssociateAmt := 0;
        DirectAssAmt := 0;
        OldAPPNo := '';
        NewAPPNo := '';
        CustNo := '';
        PostDate := 0D;
        DimCode := '';
        TrfApplicationPayEntry.RESET;
        TrfApplicationPayEntry.SETRANGE("Document No.", DOCNo);
        TrfApplicationPayEntry.SETRANGE("Payment Mode", TrfApplicationPayEntry."Payment Mode"::MJVM);
        TrfApplicationPayEntry.SETRANGE(Posted, TRUE);
        IF TrfApplicationPayEntry.FINDLAST THEN BEGIN
            Amt := TrfApplicationPayEntry.Amount;
            PostDate := TrfApplicationPayEntry."Posting date";
            AppPaymentEntry.RESET;
            AppPaymentEntry.CHANGECOMPANY(CompanyCode_1);
            AppPaymentEntry.SETRANGE("Document No.", TrfApplicationPayEntry."Order Ref No.");
            IF AppPaymentEntry.FINDLAST THEN
                LastLineNo := AppPaymentEntry."Line No.";

            InsertAppLines.CHANGECOMPANY(CompanyCode_1);
            InsertAppLines.INIT;
            InsertAppLines."Document Type" := InsertAppLines."Document Type"::BOND;
            InsertAppLines."Document No." := TrfApplicationPayEntry."Order Ref No.";
            InsertAppLines."Line No." := LastLineNo + 10000;
            InsertAppLines."Payment Method" := TrfApplicationPayEntry."Payment Method";
            InsertAppLines.Amount := -TrfApplicationPayEntry.Amount;
            InsertAppLines."Payment Mode" := TrfApplicationPayEntry."Payment Mode";
            InsertAppLines.Posted := TRUE;
            InsertAppLines."Unit Code" := TrfApplicationPayEntry."Unit Code";
            InsertAppLines.Description := TrfApplicationPayEntry.Description;
            InsertAppLines."Document Date" := TrfApplicationPayEntry."Document Date";
            InsertAppLines."User Branch Code" := TrfApplicationPayEntry."User Branch Code";
            InsertAppLines."User ID" := TrfApplicationPayEntry."User ID";
            InsertAppLines."User Branch Name" := TrfApplicationPayEntry."User Branch Name";
            InsertAppLines."Ref.Inter Post Document No." := TrfApplicationPayEntry."Posted Document No.";
            InsertAppLines."Posting date" := TrfApplicationPayEntry."Posting date";
            InsertAppLines."Shortcut Dimension 1 Code" := TrfApplicationPayEntry."Shortcut Dimension 1 Code";
            InsertAppLines."Cheque Status" := InsertAppLines."Cheque Status"::Cleared;
            InsertAppLines."Explode BOM" := TRUE;
            InsertAppLines."Application No." := TrfApplicationPayEntry."Order Ref No.";
            InsertAppLines."Reverse Commission" := ReverseComm;
            InsertAppLines."MJV Entry Posted" := TRUE;
            CompanywiseGL.RESET;
            CompanywiseGL.SETRANGE(CompanywiseGL."Company Code", COMPANYNAME);
            IF CompanywiseGL.FINDFIRST THEN;
            InsertAppLines."Balance Account No." := CompanywiseGL."Payable Account";
            InsertAppLines.INSERT;


            InsertAppLines_1.INIT;
            InsertAppLines_1."Document Type" := InsertAppLines_1."Document Type"::BOND;
            InsertAppLines_1."Document No." := TrfApplicationPayEntry."Document No.";
            InsertAppLines_1."Line No." := LastLineNo + 10000;
            InsertAppLines_1."Payment Method" := TrfApplicationPayEntry."Payment Method";
            InsertAppLines_1.Amount := -TrfApplicationPayEntry.Amount;
            InsertAppLines_1."Payment Mode" := TrfApplicationPayEntry."Payment Mode";
            InsertAppLines_1.Posted := TRUE;
            InsertAppLines_1."Unit Code" := TrfApplicationPayEntry."Unit Code";
            InsertAppLines_1.Description := TrfApplicationPayEntry.Description;
            InsertAppLines_1."Document Date" := TrfApplicationPayEntry."Document Date";
            InsertAppLines_1."User Branch Code" := TrfApplicationPayEntry."User Branch Code";
            InsertAppLines_1."User ID" := TrfApplicationPayEntry."User ID";
            InsertAppLines_1."User Branch Name" := TrfApplicationPayEntry."User Branch Name";
            InsertAppLines_1."Posted Document No." := TrfApplicationPayEntry."Posted Document No.";
            InsertAppLines_1."Posting date" := TrfApplicationPayEntry."Posting date";
            InsertAppLines_1."Shortcut Dimension 1 Code" := TrfApplicationPayEntry."Shortcut Dimension 1 Code";
            InsertAppLines_1."Cheque Status" := InsertAppLines_1."Cheque Status"::Cleared;
            InsertAppLines_1."Application No." := TrfApplicationPayEntry."Order Ref No.";
            InsertAppLines_1."Company Name" := COMPANYNAME;
            InsertAppLines_1."MJV Entry Not Posted" := FALSE;
            InsertAppLines_1.INSERT;

            InsertAppLines_2.INIT;
            InsertAppLines_2."Document Type" := InsertAppLines_2."Document Type"::BOND;
            InsertAppLines_2."Document No." := TrfApplicationPayEntry."Order Ref No.";
            InsertAppLines_2."Line No." := LastLineNo + 10000;
            InsertAppLines_2."Payment Method" := TrfApplicationPayEntry."Payment Method";
            InsertAppLines_2.Amount := -TrfApplicationPayEntry.Amount;
            InsertAppLines_2."Payment Mode" := TrfApplicationPayEntry."Payment Mode";
            InsertAppLines_2.Posted := TRUE;
            InsertAppLines_2."Unit Code" := TrfApplicationPayEntry."Unit Code";
            InsertAppLines_2.Description := TrfApplicationPayEntry.Description;
            InsertAppLines_2."Document Date" := TrfApplicationPayEntry."Document Date";
            InsertAppLines_2."User Branch Code" := TrfApplicationPayEntry."User Branch Code";
            InsertAppLines_2."User ID" := TrfApplicationPayEntry."User ID";
            InsertAppLines_2."User Branch Name" := TrfApplicationPayEntry."User Branch Name";
            InsertAppLines_2."Ref. InterPost Doc. No." := TrfApplicationPayEntry."Posted Document No.";
            InsertAppLines_2."Posting date" := TrfApplicationPayEntry."Posting date";
            InsertAppLines_2."Shortcut Dimension 1 Code" := TrfApplicationPayEntry."Shortcut Dimension 1 Code";
            InsertAppLines_2."Cheque Status" := InsertAppLines_2."Cheque Status"::Cleared;
            InsertAppLines_2."Explode BOM" := TRUE;
            InsertAppLines_2."Application No." := TrfApplicationPayEntry."Order Ref No.";
            InsertAppLines_2."Company Name" := CompanyCode_1;
            InsertAppLines_2."MJV Entry Not Posted" := FALSE;
            InsertAppLines_2.INSERT;
        END;
    end;
}

