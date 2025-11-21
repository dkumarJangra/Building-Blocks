codeunit 50051 "Commission Update"
{

    trigger OnRun()
    begin
    end;

    var
        BondpaymentEntry: Record "Unit Payment Entry";
        BPayEntry: Record "Unit Payment Entry";
        LineNo: Decimal;
        AppPaymentEntry: Record "Application Payment Entry";
        TempBondPaymentEntry: Record "Application Payment Entry" temporary;
        DifferenceAmount: Decimal;
        LoopingDifferAmount: Decimal;
        BondPayLineAmt: Decimal;
        TotalBondAmount: Decimal;
        AppliPaymentAmount: Decimal;
        PaymentTermLines: Record "Payment Terms Line Sale";
        ConfOrdrer: Record "Confirmed Order";
        AppPay: Record "Application Payment Entry";
        CommBuff: Record "Unit & Comm. Creation Buffer";
        UnitReversal: Codeunit "Unit Reversal";
        Memberof: Record "Access Control";
        CommisionGen: Codeunit "Unit and Comm. Creation Job";
        AppEntry: Record "Application Payment Entry";
        CommBuff1: Record "Unit & Comm. Creation Buffer";
        TotalAmt: Decimal;
        PostPayment: Codeunit PostPayment;
        CommissionEntry: Record "Commission Entry";
        RecCommissionEntry: Record "Commission Entry";
        APE: Record "Application Payment Entry";
        RecAPE_1: Record "Application Payment Entry";
        JVAmt: Decimal;
        AppPaymentEntry1: Record "Application Payment Entry";
        FullAmountRcvd: Boolean;
        RecConfirmedOrder: Record "Confirmed Order";
        "-------------------------": Integer;
        CompInfo: Record "Company Information";
        UnitAndCommBuff: Record "Unit & Comm. Creation Buffer";
        UnitSetup: Record "Unit Setup";
        ComDate: Date;
        "----------------------1": Integer;
        JobQueueLogDetails: Record "Job Queue Log Details";
        EntryNo: Integer;


    procedure ConfirmedOnAfter(AppNo: Code[20]; FromBatch: Boolean)
    begin

        RecConfirmedOrder.GET(AppNo);
        IF NOT FromBatch THEN BEGIN
            Memberof.RESET;
            Memberof.SETRANGE("User Name", USERID);
            Memberof.SETRANGE(Memberof."Role ID", 'A_COMMISSIONGENRATE');
            IF NOT Memberof.FINDFIRST THEN
                ERROR('You are not authorised to perform this task');
        END;
        IF RecConfirmedOrder."Posting Date" > 20141101D THEN BEGIN
            IF (RecConfirmedOrder."Total Received Amount" - RecConfirmedOrder.Amount) >= 0 THEN BEGIN
                IF RecConfirmedOrder."User Id" = '1003' THEN BEGIN
                    CommissionEntry.RESET;
                    CommissionEntry.SETRANGE("Application No.", RecConfirmedOrder."No.");
                    CommissionEntry.SETRANGE("Opening Entries", TRUE);
                    CommissionEntry.SETFILTER("Commission Amount", '<>%1', 0);
                    IF NOT CommissionEntry.FINDFIRST THEN
                        ERROR('Please create Commission for opening Application');
                END;


                BondpaymentEntry.RESET;
                BondpaymentEntry.SETRANGE("Document No.", RecConfirmedOrder."No.");
                IF BondpaymentEntry.FINDSET THEN
                    REPEAT
                        BondpaymentEntry.DELETEALL;
                    UNTIL BondpaymentEntry.NEXT = 0;
                CommBuff.RESET;
                CommBuff.SETRANGE("Unit No.", RecConfirmedOrder."No.");
                IF CommBuff.FINDSET THEN
                    REPEAT
                        CommBuff.DELETEALL;
                    UNTIL CommBuff.NEXT = 0;
                //--------------------------------
                ConfOrdrer.GET(RecConfirmedOrder."No.");
                CLEAR(APE);
                APE.RESET;
                APE.SETRANGE("Document No.", RecConfirmedOrder."No.");
                APE.SETRANGE(Posted, TRUE);
                //IF ROUND(JVAmt) =0 THEN
                //  APE.SETFILTER("Payment Mode",'<>%1',APE."Payment Mode"::JV);
                APE.SETRANGE("Cheque Status", APE."Cheque Status"::Cleared);
                IF APE.FINDSET THEN
                    REPEAT
                        CLEAR(AppliPaymentAmount);
                        CLEAR(TotalBondAmount);
                        IF APE.Amount <> 0 THEN BEGIN
                            LineNo := 0;
                            BPayEntry.RESET;
                            BPayEntry.SETRANGE("Document Type", BPayEntry."Document Type"::BOND);
                            BPayEntry.SETFILTER(BPayEntry."Document No.", RecConfirmedOrder."No.");
                            IF BPayEntry.FINDLAST THEN
                                LineNo := BPayEntry."Line No." + 10000
                            ELSE
                                LineNo := 10000;
                            TotalAmt := TotalAmt + APE.Amount;
                            TotalBondAmount := APE.Amount;
                            AppliPaymentAmount := APE.Amount;
                            // GetLastLineNo(APE);
                            DifferenceAmount := 0;
                            CLEAR(PaymentTermLines);
                            PaymentTermLines.RESET;
                            PaymentTermLines.SETRANGE("Document No.", RecConfirmedOrder."No.");
                            PaymentTermLines.SETRANGE("Payment Plan", RecConfirmedOrder."Payment Plan"); //ALLETDK280313
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
                                            CreatePaymentEntryLine(BondPayLineAmt, APE, LineNo, PaymentTermLines); //ALLETDK
                                        END;
                                        IF AppliPaymentAmount = 0 THEN BEGIN
                                            IF APE."Cheque Status" = APE."Cheque Status"::Cleared THEN BEGIN //ALLETDK070213
                                                APE."Explode BOM" := TRUE;
                                                APE.MODIFY;
                                                AppliPaymentAmount := APE.Amount;
                                            END;
                                        END;
                                    UNTIL (LoopingDifferAmount = 0) OR (TotalBondAmount = 0);
                                UNTIL (PaymentTermLines.NEXT = 0) OR (TotalBondAmount = 0);
                        END;
                    UNTIL APE.NEXT = 0;

                UnitReversal.CommisionReverse(RecConfirmedOrder."No.", FALSE);
                IF TotalAmt >= RecConfirmedOrder."Min. Allotment Amount" THEN
                    PostPayment.UpdateStagingtable(RecConfirmedOrder."No.");

                AppEntry.RESET;
                AppEntry.SETRANGE("Document No.", RecConfirmedOrder."No.");
                IF AppEntry.FINDLAST THEN;
                RecCommissionEntry.RESET;
                RecCommissionEntry.SETCURRENTKEY("Commission Run Date");
                RecCommissionEntry.SETFILTER("Commission Run Date", '<>%1', 0D);
                IF RecCommissionEntry.FINDLAST THEN
                    CommisionGen.CreateBondandCommission(RecCommissionEntry."Commission Run Date", RecConfirmedOrder."Introducer Code", RecConfirmedOrder."No.", '', '', TRUE)
                ELSE
                    CommisionGen.CreateBondandCommission(WORKDATE, RecConfirmedOrder."Introducer Code", RecConfirmedOrder."No.", '', '', TRUE);
                // CommisionGen.CreateBondandCommission(AppEntry."Posting date","Introducer Code",'','','',TRUE);
            END;
        END ELSE BEGIN
            RecConfirmedOrder.TESTFIELD(RecConfirmedOrder."Commission Hold on Full Pmt", FALSE);
            BondpaymentEntry.RESET;
            BondpaymentEntry.SETRANGE("Document No.", RecConfirmedOrder."No.");
            IF BondpaymentEntry.FINDSET THEN
                REPEAT
                    BondpaymentEntry.DELETEALL;
                UNTIL BondpaymentEntry.NEXT = 0;
            CommBuff.RESET;
            CommBuff.SETRANGE("Unit No.", RecConfirmedOrder."No.");
            IF CommBuff.FINDSET THEN
                REPEAT
                    CommBuff.DELETEALL;
                UNTIL CommBuff.NEXT = 0;
            ConfOrdrer.GET(RecConfirmedOrder."No.");
            CLEAR(APE);
            APE.RESET;
            APE.SETRANGE("Document No.", RecConfirmedOrder."No.");
            APE.SETRANGE(Posted, TRUE);
            APE.SETRANGE("Cheque Status", APE."Cheque Status"::Cleared);
            IF APE.FINDSET THEN
                REPEAT
                    CLEAR(AppliPaymentAmount);
                    CLEAR(TotalBondAmount);
                    IF APE.Amount <> 0 THEN BEGIN
                        LineNo := 0;
                        BPayEntry.RESET;
                        BPayEntry.SETRANGE("Document Type", BPayEntry."Document Type"::BOND);
                        BPayEntry.SETFILTER(BPayEntry."Document No.", RecConfirmedOrder."No.");
                        IF BPayEntry.FINDLAST THEN
                            LineNo := BPayEntry."Line No." + 10000
                        ELSE
                            LineNo := 10000;
                        TotalAmt := TotalAmt + APE.Amount;
                        TotalBondAmount := APE.Amount;
                        AppliPaymentAmount := APE.Amount;
                        DifferenceAmount := 0;
                        CLEAR(PaymentTermLines);
                        PaymentTermLines.RESET;
                        PaymentTermLines.SETRANGE("Document No.", RecConfirmedOrder."No.");
                        PaymentTermLines.SETRANGE("Payment Plan", RecConfirmedOrder."Payment Plan"); //ALLETDK280313
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
                                        CreatePaymentEntryLine(BondPayLineAmt, APE, LineNo, PaymentTermLines); //ALLETDK
                                    END;
                                    IF AppliPaymentAmount = 0 THEN BEGIN
                                        IF APE."Cheque Status" = APE."Cheque Status"::Cleared THEN BEGIN //ALLETDK070213
                                            APE."Explode BOM" := TRUE;
                                            APE.MODIFY;
                                            AppliPaymentAmount := APE.Amount;
                                        END;
                                    END;
                                UNTIL (LoopingDifferAmount = 0) OR (TotalBondAmount = 0);
                            UNTIL (PaymentTermLines.NEXT = 0) OR (TotalBondAmount = 0);
                    END;
                UNTIL APE.NEXT = 0;

            UnitReversal.CommisionReverse(RecConfirmedOrder."No.", FALSE);
            IF TotalAmt >= RecConfirmedOrder."Min. Allotment Amount" THEN
                PostPayment.UpdateStagingtable(RecConfirmedOrder."No.");

            AppEntry.RESET;
            AppEntry.SETRANGE("Document No.", RecConfirmedOrder."No.");
            IF AppEntry.FINDLAST THEN;
            RecCommissionEntry.RESET;
            RecCommissionEntry.SETCURRENTKEY("Commission Run Date");
            RecCommissionEntry.SETFILTER("Commission Run Date", '<>%1', 0D);
            IF RecCommissionEntry.FINDLAST THEN
                CommisionGen.CreateBondandCommission(RecCommissionEntry."Commission Run Date", RecConfirmedOrder."Introducer Code", RecConfirmedOrder."No.", '', '', TRUE)
            ELSE
                CommisionGen.CreateBondandCommission(WORKDATE, RecConfirmedOrder."Introducer Code", RecConfirmedOrder."No.", '', '', TRUE);
        END;
    end;


    procedure CreatePaymentEntryLine(Amt: Decimal; BondPaymentEntryRec: Record "Application Payment Entry"; RecLineNo: Integer; RecPaymentTermLines: Record "Payment Terms Line Sale")
    var
        UserSetup: Record "User Setup";
        LBondPaymentEntry: Record "Unit Payment Entry";
    begin
        BondpaymentEntry.INIT;
        BondpaymentEntry."Document Type" := BondPaymentEntryRec."Document Type";
        BondpaymentEntry."Document No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Line No." := RecLineNo;
        LineNo += 10000;
        BondpaymentEntry.VALIDATE("Unit Code", BondPaymentEntryRec."Unit Code"); //ALLETDK141112
        BondpaymentEntry.VALIDATE("Payment Mode", BondPaymentEntryRec."Payment Mode");
        BondpaymentEntry."Application No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Document Date" := BondPaymentEntryRec."Document Date";
        BondpaymentEntry."Posting date" := BondPaymentEntryRec."Posting date";
        BondpaymentEntry.Type := BondPaymentEntryRec.Type;
        BondpaymentEntry.Sequence := RecPaymentTermLines.Sequence; //ALLETDK221112
        BondpaymentEntry."Charge Code" := RecPaymentTermLines."Charge Code"; //ALLETDK081112
        BondpaymentEntry."Actual Milestone" := RecPaymentTermLines."Actual Milestone"; //ALLETDK221112
        BondpaymentEntry."Commision Applicable" := RecPaymentTermLines."Commision Applicable";
        BondpaymentEntry."Direct Associate" := RecPaymentTermLines."Direct Associate";
        BondpaymentEntry."Priority Payment" := BondPaymentEntryRec."Priority Payment";
        IF ((BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::Bank)
            OR (BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.C./C.C./Net Banking")) THEN BEGIN
            BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            BondpaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            BondpaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            BondpaymentEntry."Deposit/Paid Bank" := BondPaymentEntryRec."Deposit/Paid Bank";
        END;

        IF BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.D." THEN BEGIN
            BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            BondpaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            BondpaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            BondpaymentEntry."Deposit/Paid Bank" := BondPaymentEntryRec."Deposit/Paid Bank";
        END;
        BondpaymentEntry.Amount := Amt;
        BondpaymentEntry."Shortcut Dimension 1 Code" := BondPaymentEntryRec."Shortcut Dimension 1 Code";

        BondpaymentEntry."Shortcut Dimension 2 Code" := BondPaymentEntryRec."Shortcut Dimension 2 Code";
        BondpaymentEntry."Explode BOM" := TRUE;
        BondpaymentEntry."Branch Code" := BondPaymentEntryRec."User Branch Code"; //ALLETDK141112
        BondpaymentEntry."User ID" := BondPaymentEntryRec."User ID"; //ALLEDK271212
        BondpaymentEntry."App. Pay. Entry Line No." := BondPaymentEntryRec."Line No."; //ALLETDK141112
        BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");//ALLETDK040213
        BondpaymentEntry."Posted Document No." := BondPaymentEntryRec."Posted Document No.";
        BondpaymentEntry."Installment No." := 1;
        BondpaymentEntry.Posted := TRUE;
        BondpaymentEntry.INSERT;
        CreateStagingTableAppBond(ConfOrdrer, BondpaymentEntry."Line No." / 10000, 1, BondpaymentEntry.Sequence,
        BondpaymentEntry."Cheque No./ Transaction No.", BondpaymentEntry."Commision Applicable", BondpaymentEntry."Direct Associate",
        BondpaymentEntry."Posting date", BondpaymentEntry.Amount, BondpaymentEntry."Chq. Cl / Bounce Dt.");
    end;


    procedure CreateStagingTableAppBond(Application: Record "Confirmed Order"; InstallmentNo: Integer; YearCode: Integer; MilestoneCode: Code[10]; ChequeNo: Code[20]; CommTree: Boolean; DirectAss: Boolean; PostDate: Date; BaseAmount: Decimal; ChequeDate: Date)
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
        AmountRecd: Decimal;
    begin
        Bond.GET(Application."No.");                                                              //ALLETDK
        AmountRecd := Bond.AmountRecdAppl(Application."No.");
        FullAmountRcvd := FALSE;
        AppPaymentEntry1.RESET;
        AppPaymentEntry1.SETCURRENTKEY(AppPaymentEntry1."Document No.", AppPaymentEntry1."Cheque Status");
        AppPaymentEntry1.SETRANGE("Document No.", Bond."No.");
        AppPaymentEntry1.SETRANGE("Cheque Status", AppPaymentEntry1."Cheque Status"::Cleared);
        IF AppPaymentEntry1.FINDSET THEN BEGIN
            AppPaymentEntry1.CALCSUMS(AppPaymentEntry1.Amount);
            IF AppPaymentEntry1.Amount >= AmountRecd THEN
                FullAmountRcvd := TRUE;
        END;

        IF NOT FullAmountRcvd THEN
            BaseAmount := PostPayment.UpdateUnit_ComBufferAmt(BondpaymentEntry, FALSE);
        IF BaseAmount <> 0 THEN BEGIN             //ALLETDK
            InitialStagingTab.INIT;
            InitialStagingTab."Unit No." := Application."No.";           //ALLETDk
            InitialStagingTab."Installment No." := InstallmentNo + 1;
            InitialStagingTab."Posting Date" := PostDate; //ALLEDK 130113
            InitialStagingTab.VALIDATE("Introducer Code", Application."Introducer Code");  //ALLETDK
            InitialStagingTab."Base Amount" := BaseAmount;      //ALLETDK
            InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
            InitialStagingTab.Duration := Application.Duration;
            InitialStagingTab."Year Code" := YearCode;
            InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
            InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
            InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
            InitialStagingTab."Application No." := Application."No."; //ALLETDK
            InitialStagingTab."Paid by cheque" := (ChequeNo <> '');                   //ALLETDK
            InitialStagingTab."Cheque No." := ChequeNo;
            InitialStagingTab."Cheque Cleared Date" := ChequeDate;
            InitialStagingTab."Milestone Code" := MilestoneCode;
            InitialStagingTab."Bond Created" := TRUE;
            IF AmountRecd < Bond."Min. Allotment Amount" THEN
                InitialStagingTab."Min. Allotment Amount Not Paid" := TRUE;
            InitialStagingTab."Charge Code" := BondpaymentEntry."Charge Code";
            IF (CommTree = FALSE) AND (DirectAss = FALSE) THEN
                InitialStagingTab."Commission Created" := TRUE;
            IF MilestoneCode = '001' THEN BEGIN
                InitialStagingTab."Min. Allotment Amount Not Paid" := FALSE;
                InitialStagingTab."Cheque not Cleared" := FALSE;
            END;

            InitialStagingTab."Direct Associate" := DirectAss;
            InitialStagingTab.INSERT;
        END;
    end;


    procedure CommissionBatchRun()
    begin

        JobQueueLogDetails.RESET;
        IF JobQueueLogDetails.FINDLAST THEN
            EntryNo := JobQueueLogDetails."Entry No."
        ELSE
            EntryNo := 1;
        JobQueueLogDetails.INIT;
        JobQueueLogDetails."Entry No." := EntryNo + 1;
        JobQueueLogDetails."Process Name" := 'Generate Commission';
        JobQueueLogDetails."Process Code" := 'CU 50051';
        JobQueueLogDetails."Process Date" := TODAY;
        JobQueueLogDetails."Process Time" := TIME;
        JobQueueLogDetails."Error Message" := COPYSTR(GETLASTERRORTEXT, 1, 200);
        JobQueueLogDetails."Company Name" := COMPANYNAME;
        JobQueueLogDetails.INSERT;

        CompInfo.GET;
        IF CompInfo."Run Commission Batch" THEN BEGIN
            UnitSetup.GET;
            UnitAndCommBuff.RESET;
            UnitAndCommBuff.SETRANGE("Branch Code", '');
            IF UnitAndCommBuff.FINDSET THEN
                REPEAT
                    UnitAndCommBuff.VALIDATE("Shortcut Dimension 1 Code");
                    UnitAndCommBuff.MODIFY;
                UNTIL UnitAndCommBuff.NEXT = 0;
            ComDate := TODAY;
            CLEAR(CommisionGen);
            CommisionGen.CreateBondandCommission(ComDate, '', '', '', '', FALSE);
            UnitSetup."Last Date Commission" := TODAY;
            UnitSetup."Last Commission Generated By" := USERID;
            UnitSetup.MODIFY;
        END;
    end;
}

