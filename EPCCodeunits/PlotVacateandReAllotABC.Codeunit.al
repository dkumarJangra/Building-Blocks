codeunit 97767 "Plot Vacate and Re-Allot A-B-C"
{

    trigger OnRun()
    begin
    end;

    var
        Text006: Label 'Are you sure you want to post the entries';
        "New-ConfOrder": Record "New Confirmed Order";
        "Re-ConfOrder": Record "Confirmed Order";
        ReceivableAmount: Decimal;
        AmountReceived: Decimal;
        DueAmount: Decimal;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        Dummy: Text[30];
        BondHolderName: Text[50];
        BondHolderName2: Text[50];
        Customer: Record Customer;
        Customer2: Record Customer;
        BondNominee: Record "Unit Nominee";
        Vendor: Record Vendor;
        SchemeHeader: Record "Document Type Initiator";
        BondMaturity: Record "Unit Maturity";
        ReassignType: Option FirstBondHolder,SecondBondHolder,BothBondHolder,MarketingMember;
        Selection: Integer;
        BondChangeType: Option Scheme,"Investment Frequency","Return Frequency","Return Payment Mode","Bond Holder","Co Bond Holder","Marketing Member","Business Transfer";
        GetDescription: Codeunit GetDescription;
        CustomerBankAccount: Record "Customer Bank Account";
        Unitmaster: Record "Unit Master";
        UserSetup: Record "User Setup";
        UnpostedInstallment: Integer;
        BondSetup: Record "Unit Setup";
        BondpaymentEntry: Record "Unit Payment Entry";
        PaymentTermLines: Record "Payment Terms Line Sale";
        LineNo: Integer;
        PostPayment: Codeunit PostPayment;
        MsgDialog: Dialog;
        PenaltyAmount: Decimal;
        ReverseComm: Boolean;
        Bond: Record "Confirmed Order";
        ComEntry: Record "Commission Entry";
        ReceivedAmount: Decimal;
        TotalAmount: Decimal;
        ExcessAmount: Decimal;
        ConOrder: Record "Confirmed Order";
        UnitPaymentEntry: Record "Unit Payment Entry";
        BondReversal: Codeunit "Unit Reversal";
        UnitCommCreationJob: Codeunit "Unit and Comm. Creation Job";
        ArchiveConfirmedOrder: Record "Archive Confirmed Order";
        LastVersion: Integer;
        ConfirmOrder: Record "Confirmed Order";
        NPaymentPlanDetails: Record "Payment Plan Details";
        NPaymentPlanDetails1: Record "Archive Payment Plan Details";
        NApplicableCharges: Record "Applicable Charges";
        NApplicableCharges1: Record "Archive Applicable Charges";
        NArchivePaymentTermsLine: Record "Payment Terms Line Sale";
        NArchivePaymentTermsLine1: Record "Archive Payment Terms Line";
        "-----------------UNIT INSERT -": Integer;
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
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line" temporary;
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        DocNo1: Code[20];
        Amt: Decimal;
        UnitSetup: Record "Unit Setup";
        LineNo2: Integer;
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Job: Record Job;
        ConfOrder: Record "Confirmed Order";
        BondInvestmentAmt: Decimal;
        ByCheque: Boolean;
        AppPaymentEntry: Record "Application Payment Entry";
        GLSetup: Record "General Ledger Setup";
        Vend: Record Vendor;
        AmountToWords: Codeunit "Amount To Words";
        AmountText1: array[2] of Text[300];
        ApplicationForm: Page Application;
        Memberof: Record "Access Control";
        ProjChngJVAmt: Decimal;
        CommissionEntry: Record "Commission Entry";
        TotAppAmt: Decimal;
        UnitPost: Codeunit "Unit Post";
        RecCommissionEntry: Record "Commission Entry";
        ProjChngJVAmt1: Decimal;
        UnitReversal: Codeunit "Unit Reversal";
        Newconforder: Record "New Confirmed Order";
        RecUnitMaster: Record "Unit Master";
        Companywise: Record "Company wise G/L Account";
        OldUPmtEntry: Record "Unit Payment Entry";
        OldUnitMaster: Record "Unit Master";
        OldAppExists: Record Application;
        RespCenter: Record "Responsibility Center 1";
        ProjectMilestoneHdr: Record "Project Milestone Header";
        UpdateChargesAssPmt: Codeunit "UpdateCharges /Post/Rev AssPmt";
        UPName: Text[30];
        TotalValue: Decimal;
        TotalFixed: Decimal;
        AlltAmount: Decimal;
        ProjMilestoneLine: Record "Project Milestone Line";
        Vend_1: Record Vendor;
        NewUnitEditable: Boolean;
        NewProjectEditable: Boolean;
        NewProject: Code[20];
        OldProject: Code[20];
        Commholforoldprocess: Boolean;
        RecConforders: Record "Confirmed Order";
        RecApplication: Record Application;
        v_Conforder: Record "Confirmed Order";
        "--------------------------": Integer;
        UnitCode_1: Code[20];
        Pcode: Code[20];
        PaymentTermsLineSale: Record "Payment Terms Line Sale";
        EleDate: Date;
        AppPEntry: Record "NewApplication Payment Entry";
        PTLineSale: Record "Payment Terms Line Sale";
        TotalAmt: Decimal;
        MSCUnitMaster: Record "Unit Master";
        ArchDocMaster: Record "Archive Document Master";
        DocumentMaster: Record "Document Master";
        DocumentMaster1: Record "Document Master";
        UMaster: Record "Unit Master";
        ReleaseUnit: Codeunit "Release Unit Application";
        RecordDiff: Boolean;
        Forcefullvacate: Boolean;
        AppCode_2: Code[20];
        RecConfORder: Record "Confirmed Order";
        AppPayentry_2: Record "Application Payment Entry";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        v_ResponsibilityCenter: Record "Responsibility Center 1";
        UnitAllocationPage: Page "Unit Allocation";
        WebAppService: Codeunit "Web App Service";


    procedure VacateUnit(NP_ConfomredOrder: Record "New Confirmed Order"; NPPLANCode: Code[10])
    var
        FindCompany: Boolean;
        ResponsibilityCenter_1: Record "Responsibility Center 1";
        UnitMaster_1: Record "Unit Master";
        UnitMaster_2: Record "Unit Master";
        JobRec_1: Record Job;
        RecUnitMaster: Record "Unit Master";
        Versn: Integer;
        DocMaster: Record "Document Master";
        ToDoctMaster1: Record "Document Master";
        ToDoctMaster: Record "Document Master";
        FromDocMaster1: Record "Document Master";
        ArchUnitMaster: Record "Archive Unit Master";
    begin
        "New-ConfOrder".GET(NP_ConfomredOrder."No.");
        "New-ConfOrder".TESTFIELD(Type, "New-ConfOrder".Type::Normal);
        "New-ConfOrder".CALCFIELDS("Amount Received");
        "New-ConfOrder".CALCFIELDS("Total Received Amount");
        "New-ConfOrder".CALCFIELDS("Amount Refunded");

        AppPayentry_2.RESET;
        AppPayentry_2.SETRANGE("Document No.", "New-ConfOrder"."No.");
        AppPayentry_2.SETRANGE("Cheque Status", AppPayentry_2."Cheque Status"::" ");
        IF AppPayentry_2.FINDFIRST THEN
            ERROR('Receipt entry should be cleared Or Bounced for Application No. -' + "New-ConfOrder"."No.");

        ConfOrder.RESET;
        ConfOrder.CHANGECOMPANY("New-ConfOrder"."Company Name");
        ConfOrder.SETRANGE("No.", "New-ConfOrder"."No.");
        IF ConfOrder.FINDFIRST THEN BEGIN
            ArchiveConfirmedOrder.RESET;
            ArchiveConfirmedOrder.CHANGECOMPANY("New-ConfOrder"."Company Name");
            ArchiveConfirmedOrder.SETRANGE("No.", "New-ConfOrder"."No.");
            IF ArchiveConfirmedOrder.FINDLAST THEN
                LastVersion := ArchiveConfirmedOrder."Version No."
            ELSE
                LastVersion := 0;
            ArchiveConfirmedOrder.INIT;
            ArchiveConfirmedOrder.TRANSFERFIELDS(ConfOrder);
            ArchiveConfirmedOrder."Version No." := LastVersion + 1;
            ArchiveConfirmedOrder."Amount Received" := "New-ConfOrder"."Amount Received";
            ArchiveConfirmedOrder.INSERT;
        END;

        UnitCode_1 := '';
        UnitCode_1 := "New-ConfOrder"."Unit Code";
        "New-ConfOrder"."New Unit No." := "New-ConfOrder"."Unit Code";
        "New-ConfOrder"."Unit Code" := '';
        "New-ConfOrder"."New Project" := "New-ConfOrder"."Shortcut Dimension 1 Code";
        "New-ConfOrder".Status := "New-ConfOrder".Status::Vacate;
        "New-ConfOrder".MODIFY;

        IF UnitCode_1 <> '' THEN BEGIN
            IF Unitmaster.GET(UnitCode_1) THEN BEGIN
                Unitmaster.Freeze := FALSE;
                Unitmaster.Status := Unitmaster.Status::Open;
                Unitmaster."Web Portal Status" := Unitmaster."Web Portal Status"::Available;
                // Unitmaster.VALIDATE(Status,Status::Open);
                Unitmaster."Plot Cost" := 0;
                Unitmaster."Customer Code" := '';
                Unitmaster."Customer Name" := '';
                Unitmaster."Registration No." := '';
                //Unitmaster."Company Name" := 'BBG India Developers LLP';  //Code commented 08092025 
                Unitmaster.MODIFY;
                COMMIT;
                WebAppService.UpdateUnitStatus(Unitmaster);  //210624
            END;
        END;

        ConfOrder.RESET;
        ConfOrder.CHANGECOMPANY("New-ConfOrder"."Company Name");
        ConfOrder.SETRANGE("No.", "New-ConfOrder"."No.");
        IF ConfOrder.FINDFIRST THEN BEGIN
            ConfOrder.Status := ConfOrder.Status::Vacate;
            ConfOrder."Unit Code" := '';
            ConfOrder."Project change Comment" := 'Payment Lag';
            ConfOrder."New Unit No." := "New-ConfOrder"."New Unit No.";
            ConfOrder."New Unit Payment Plan" := NPPLANCode;
            ConfOrder."New Project" := ConfOrder."Shortcut Dimension 1 Code";
            ConfOrder.MODIFY;
        END;


        ReAssignedUnit(ConfOrder);
    end;

    local procedure ReAssignedUnit(P_ConfOrder: Record "Confirmed Order")
    var
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
        UnitReversal_2: Codeunit "Unit Reversal";
        UnitMaster_2: Record "Unit Master";
        Job_2: Record Job;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        v_ConfirmedOrder: Record "Confirmed Order";
        ProjectwiseDevelopmentCharg: Record "Project wise Development Charg";
        EndDate: Date;
        V_CompanyInformation: Record "Company Information";
        RecApplication: Record Application;
        RecCustomer: Record Customer;
    begin
        "Re-ConfOrder".GET(P_ConfOrder."No.");
        "Re-ConfOrder".TESTFIELD("Application Closed", FALSE);  //190820
        //UnitReversal_2.ProjectChanges(Rec); new code

        "Re-ConfOrder".TESTFIELD("Application Transfered", FALSE);

        UnitSetup.GET;
        UnitSetup.TESTFIELD("Gold No. Series for Proj Chang");
        RecApplication.RESET;
        RecApplication.SETRANGE("Application No.", "Re-ConfOrder"."No.");
        IF RecApplication.FINDFIRST THEN
            RecApplication.DELETE;
        COMMIT;

        //ERROR('Please contact to Admin');
        Vend_1.RESET;
        Vend_1.SETRANGE("No.", "Re-ConfOrder"."Introducer Code");
        IF Vend_1.FINDFIRST THEN
            Vend_1.TESTFIELD("BBG Black List", FALSE);



        "Re-ConfOrder".TESTFIELD("New Unit Payment Plan");

        ProjectMilestoneHdr.RESET;
        ProjectMilestoneHdr.SETRANGE("Project Code", "Re-ConfOrder"."New Project");
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
            ERROR('Please define Project milestone for Project Code' + ' ' + "Re-ConfOrder"."New Project");

        IF "Re-ConfOrder"."Introducer Code" <> 'IBA9999999' THEN BEGIN
            TotAppAmt := 0;
            IF "Re-ConfOrder"."User Id" = '1003' THEN BEGIN
                AppPaymentEntry.RESET;
                AppPaymentEntry.SETRANGE("Document No.", "Re-ConfOrder"."No.");
                AppPaymentEntry.SETRANGE("User ID", '1003');
                IF AppPaymentEntry.FINDSET THEN
                    REPEAT
                        TotAppAmt += AppPaymentEntry.Amount;
                    UNTIL AppPaymentEntry.NEXT = 0;
                //IF TotAppAmt >= "Min. Allotment Amount" THEN BEGIN
                IF TotAppAmt >= CommisionGen.CheckMinAmountOpng("Re-ConfOrder") THEN BEGIN
                    IF "Re-ConfOrder"."User Id" = '1003' THEN BEGIN
                        CommissionEntry.RESET;
                        CommissionEntry.SETCURRENTKEY("Application No.");
                        CommissionEntry.SETRANGE("Application No.", "Re-ConfOrder"."No.");
                        CommissionEntry.SETRANGE("Opening Entries", TRUE);
                        CommissionEntry.SETFILTER("Commission Amount", '<>%1', 0);
                        IF NOT CommissionEntry.FINDFIRST THEN
                            ERROR('Please create Commission for opening Application');
                    END;
                END;
            END;
        END;
        APE.RESET;
        APE.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        APE.SETRANGE(Posted, FALSE);
        IF APE.FINDFIRST THEN
            ERROR('Post/Delete Unposted %1 Entries', FORMAT(APE."Payment Mode"));

        APE.RESET;
        APE.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        APE.SETRANGE("Cheque Status", APE."Cheque Status"::" ");
        IF APE.FINDFIRST THEN
            ERROR('Pending Cheques must be Cleared/Bounced');


        //IF CONFIRM('Do you want to upload new unit?',TRUE) THEN BEGIN   100821
        AmountToWords.InitTextVariable;
        AmountToWords.FormatNoText(AmountText1, ApplicationForm.CheckPaymentAmount("Re-ConfOrder"."No."), '');
        //IF CONFIRM(STRSUBSTNO(Text006,"Re-ConfOrder"."Unit Code","Re-ConfOrder"."New Unit No.")) THEN BEGIN   //100821
        OldUnitMaster.RESET;
        OldUnitMaster.SETRANGE("No.", "Re-ConfOrder"."New Unit No.");
        OldUnitMaster.SETRANGE("Project Code", "Re-ConfOrder"."New Project");
        IF OldUnitMaster.FINDFIRST THEN
            OldUnitMaster.TESTFIELD(Status, OldUnitMaster.Status::Open);

        "Re-ConfOrder".Status := "Re-ConfOrder".Status::Open;
        Commholforoldprocess := "Re-ConfOrder"."Comm hold for Old Process"; //280219
        "Re-ConfOrder"."Comm hold for Old Process" := FALSE;
        "Re-ConfOrder".MODIFY;

        CLEAR(ProjChngJVAmt);
        APE.RESET;
        APE.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        APE.SETRANGE("Cheque Status", APE."Cheque Status"::Cleared);
        APE.SETRANGE(Posted, TRUE);
        IF APE.FINDSET THEN
            REPEAT
                ProjChngJVAmt += APE.Amount;
            UNTIL APE.NEXT = 0;

        CLEAR(APE);
        APE.RESET;
        APE.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        APE.SETRANGE("Cheque Status", APE."Cheque Status"::Cleared);
        IF APE.FINDLAST THEN
            PostPayment.CreateProjectChangeLines(APE, FALSE, ProjChngJVAmt);

        CLEAR(VersionNo);
        "Re-ConfOrder".TESTFIELD(Type, "Re-ConfOrder".Type::Normal);
        "Re-ConfOrder".TESTFIELD("New Unit No.");
        NPaymentPlanDetails1.RESET;
        NPaymentPlanDetails1.SETCURRENTKEY("Document No.", "Version No.");
        NPaymentPlanDetails1.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        IF NPaymentPlanDetails1.FINDSET THEN
            REPEAT
                IF VersionNo < NPaymentPlanDetails1."Version No." THEN
                    VersionNo := NPaymentPlanDetails1."Version No.";
            UNTIL NPaymentPlanDetails1.NEXT = 0;

        NPaymentPlanDetails.RESET;
        NPaymentPlanDetails.SETCURRENTKEY("Document No.");
        NPaymentPlanDetails.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        IF NPaymentPlanDetails.FINDSET THEN
            REPEAT

                NPaymentPlanDetails1.RESET;
                NPaymentPlanDetails1.SETCURRENTKEY("Document No.", "Project Code");
                NPaymentPlanDetails1.SETRANGE("Document No.", NPaymentPlanDetails."Document No.");
                NPaymentPlanDetails1.SETRANGE("Project Code", NPaymentPlanDetails."Project Code");
                NPaymentPlanDetails1.SETRANGE("Payment Plan Code", NPaymentPlanDetails."Payment Plan Code");
                NPaymentPlanDetails1.SETRANGE("Milestone Code", NPaymentPlanDetails."Milestone Code");
                NPaymentPlanDetails1.SETRANGE("Charge Code", NPaymentPlanDetails."Charge Code");
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
        NApplicableCharges1.SETCURRENTKEY("Document No.");
        NApplicableCharges1.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        IF NApplicableCharges1.FINDSET THEN
            REPEAT
                IF VersionNo < NApplicableCharges1."Version No." THEN
                    VersionNo := NApplicableCharges1."Version No.";
            UNTIL NApplicableCharges1.NEXT = 0;


        NApplicableCharges.RESET;
        NApplicableCharges.SETCURRENTKEY("Document No.");
        NApplicableCharges.SETRANGE("Document No.", "Re-ConfOrder"."No.");
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
        NArchivePaymentTermsLine1.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        IF NArchivePaymentTermsLine1.FINDSET THEN
            REPEAT
                IF VersionNo < NArchivePaymentTermsLine1."Version No." THEN
                    VersionNo := NArchivePaymentTermsLine1."Version No.";
            UNTIL NArchivePaymentTermsLine1.NEXT = 0;


        NArchivePaymentTermsLine.RESET;
        NArchivePaymentTermsLine.SETRANGE("Document No.", "Re-ConfOrder"."No.");
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
        UpdateUnitwithApplicablecharge;
        UnitCommCreationJob.UpdateMilestonePercentage("Re-ConfOrder"."No.", FALSE);
        //ALLETDK>>>>
        "Re-ConfOrder".CALCFIELDS("Total Received Amount");
        CLEAR(ExcessAmount);
        IF "Re-ConfOrder".Amount < "Re-ConfOrder"."Total Received Amount" THEN
            ExcessAmount := "Re-ConfOrder"."Total Received Amount" - "Re-ConfOrder".Amount;
        IF ExcessAmount <> 0 THEN
            CreatUPEryfromConfOrderAPP.CreateExcessPaymentTermsLine("Re-ConfOrder"."No.", ExcessAmount);
        //ALLETDK<<<<
        PostPayment.CreateProjectChangeLines(APE, TRUE, ProjChngJVAmt);
        BReversal.CheckandReverseTA("Re-ConfOrder"."No.", FALSE);
        IF NOT "Re-ConfOrder"."Vizag datA" THEN
            UnitPost.NewUpdateTEAMHierarcy("Re-ConfOrder", TRUE); //BBG1.00 050613
                                                                  //211114

        // IF OldProject = NewProject THEN BEGIN
        OldUPmtEntry.RESET;
        OldUPmtEntry.SETRANGE("Document Type", OldUPmtEntry."Document Type"::BOND);
        OldUPmtEntry.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        OldUPmtEntry.SETRANGE(Posted, TRUE);
        OldUPmtEntry.SETFILTER("Payment Mode", '=%1', OldUPmtEntry."Payment Mode"::JV);
        IF OldUPmtEntry.FINDLAST THEN BEGIN
            OldUPEntry.RESET;
            OldUPEntry.SETRANGE("Document Type", OldUPEntry."Document Type"::BOND);
            OldUPEntry.SETRANGE("Document No.", "Re-ConfOrder"."No.");
            OldUPEntry.SETRANGE(Posted, TRUE);
            OldUPEntry.SETRANGE("Posted Document No.", OldUPmtEntry."Posted Document No.");
            OldUPEntry.SETFILTER(Amount, '>%1', 0);
            OldUPEntry.SETRANGE("Commision Applicable", TRUE);     //110219
            IF OldUPEntry.FINDSET THEN
                REPEAT
                    ComHoldDate := 0D;
                    ComHoldDate := DMY2DATE(31, 10, 2014);
                    IF OldUPEntry."Posting date" > ComHoldDate THEN
                        CommHold := TRUE;
                    IF "Re-ConfOrder"."Posting Date" > ComHoldDate THEN
                        CommHold := FALSE;
                    PostPayment.CreateStagingTableAppBond("Re-ConfOrder", OldUPEntry."Line No." / 10000, 1, OldUPEntry.Sequence,
                    OldUPEntry."Cheque No./ Transaction No.", OldUPEntry."Commision Applicable", OldUPEntry."Direct Associate",
                    OldUPEntry."Posting date", OldUPEntry.Amount, OldUPEntry, CommHold, "Re-ConfOrder"."Old Process");
                UNTIL OldUPEntry.NEXT = 0;
            OldUPEntry.RESET;
            OldUPEntry.SETRANGE("Document Type", OldUPEntry."Document Type"::BOND);
            OldUPEntry.SETRANGE("Document No.", "Re-ConfOrder"."No.");
            OldUPEntry.SETRANGE(Posted, TRUE);
            OldUPEntry.SETRANGE("Posted Document No.", OldUPmtEntry."Posted Document No.");
            OldUPEntry.SETFILTER(Amount, '>%1', 0);
            OldUPEntry.SETRANGE("Direct Associate", TRUE);
            IF OldUPEntry.FINDSET THEN
                REPEAT
                    ComHoldDate := 0D;
                    ComHoldDate := DMY2DATE(31, 10, 2014);
                    IF OldUPEntry."Posting date" > ComHoldDate THEN
                        CommHold := TRUE;
                    IF "Re-ConfOrder"."Posting Date" > ComHoldDate THEN
                        CommHold := FALSE;
                    PostPayment.CreateStagingTableAppBond("Re-ConfOrder", OldUPEntry."Line No." / 10000, 1, OldUPEntry.Sequence,
                    OldUPEntry."Cheque No./ Transaction No.", OldUPEntry."Commision Applicable", OldUPEntry."Direct Associate",
                    OldUPEntry."Posting date", OldUPEntry.Amount, OldUPEntry, CommHold, "Re-ConfOrder"."Old Process");
                UNTIL OldUPEntry.NEXT = 0;

        END;
        CLEAR(CommisionGen);
        RecCommissionEntry.RESET;
        RecCommissionEntry.SETCURRENTKEY("Commission Run Date");
        RecCommissionEntry.SETFILTER("Commission Run Date", '<>%1', 0D);
        IF RecCommissionEntry.FINDLAST THEN
            CommisionGen.CreateBondandCommission(RecCommissionEntry."Commission Run Date", "Re-ConfOrder"."Introducer Code", "Re-ConfOrder"."No.", '', '', TRUE)
        ELSE
            CommisionGen.CreateBondandCommission(WORKDATE, "Re-ConfOrder"."Introducer Code", "Re-ConfOrder"."No.", '', '', TRUE);

        //   END;
        //END;//ALLECK 030313  100821
        //END;//ALLECK 030313  100821
        //BBG2.01 231214
        ArchiveConfirmedOrder.RESET;
        ArchiveConfirmedOrder.SETRANGE("No.", "Re-ConfOrder"."No.");
        IF ArchiveConfirmedOrder.FINDLAST THEN BEGIN
            IF ArchiveConfirmedOrder."Shortcut Dimension 1 Code" <> "Re-ConfOrder"."Shortcut Dimension 1 Code" THEN BEGIN
                IF Newconforder.GET("Re-ConfOrder"."No.") THEN BEGIN
                    IF "Re-ConfOrder"."Application Type" = "Re-ConfOrder"."Application Type"::"Non Trading" THEN BEGIN
                        Newconforder."Project Change" := TRUE;
                        Newconforder."Old Project Code" := Newconforder."Shortcut Dimension 1 Code";
                        Newconforder.MODIFY;
                    END ELSE BEGIN
                        AppPayentry_1.RESET;
                        AppPayentry_1.SETRANGE("Document No.", "Re-ConfOrder"."No.");
                        AppPayentry_1.SETFILTER(Amount, '<%1', 0);
                        IF AppPayentry_1.FINDLAST THEN
                            UnitReversal.CreateProjectChangeEntriesTR("Re-ConfOrder"."No.", AppPayentry_1."Line No.");
                    END;
                END;
            END;
        END;
        IF Newconforder.GET("Re-ConfOrder"."No.") THEN BEGIN
            Newconforder."Shortcut Dimension 1 Code" := "Re-ConfOrder"."Shortcut Dimension 1 Code";
            Newconforder."Unit Code" := "Re-ConfOrder"."Unit Code";
            Newconforder."Saleable Area" := "Re-ConfOrder"."Saleable Area";
            Newconforder."Min. Allotment Amount" := "Re-ConfOrder"."Min. Allotment Amount";
            Newconforder.Amount := "Re-ConfOrder".Amount;
            Newconforder."Project change Comment" := "Re-ConfOrder"."Project change Comment";
            Newconforder.Status := Newconforder.Status::Open;
            Newconforder."Project Type" := "Re-ConfOrder"."Project Type";
            Newconforder."Unit Payment Plan" := "Re-ConfOrder"."Unit Payment Plan";
            Newconforder.Status := "Re-ConfOrder".Status;
            Newconforder."Unit Plan Name" := "Re-ConfOrder"."Unit Plan Name";
            //BBG2.0
            UnitMaster_2.GET("Re-ConfOrder"."Unit Code");
            IF RecCustomer.GET("Re-ConfOrder"."Customer No.") THEN BEGIN
                UnitMaster_2."Customer Code" := RecCustomer."No.";
                UnitMaster_2."Customer Name" := RecCustomer.Name;
                UnitMaster_2.MODIFY;
            END;
            CompanywiseGLAccount.RESET;
            CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
            IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                ProjectwiseDevelopmentCharg.RESET;
                ProjectwiseDevelopmentCharg.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                ProjectwiseDevelopmentCharg.SETRANGE("Project Code", "Re-ConfOrder"."Shortcut Dimension 1 Code");
                IF ProjectwiseDevelopmentCharg.FINDSET THEN
                    REPEAT
                        IF ProjectwiseDevelopmentCharg."End Date" = 0D THEN
                            EndDate := TODAY
                        ELSE
                            EndDate := ProjectwiseDevelopmentCharg."End Date";
                        IF ("Re-ConfOrder"."Posting Date" > ProjectwiseDevelopmentCharg."Start Date") AND ("Re-ConfOrder"."Posting Date" < EndDate) THEN
                            Newconforder."Development Charges" := ProjectwiseDevelopmentCharg.Amount * UnitMaster_2."Saleable Area";
                    UNTIL ProjectwiseDevelopmentCharg.NEXT = 0;
            END;

            Newconforder.MODIFY;
            V_CompanyInformation.RESET;
            V_CompanyInformation.CHANGECOMPANY(Newconforder."Company Name");
            IF V_CompanyInformation.FINDFIRST THEN BEGIN
                v_ConfirmedOrder.RESET;
                v_ConfirmedOrder.CHANGECOMPANY(V_CompanyInformation."Development Company Name");
                IF v_ConfirmedOrder.GET(Newconforder."No.") THEN BEGIN
                    v_ConfirmedOrder."Development Charges" := Newconforder."Development Charges";
                    v_ConfirmedOrder.MODIFY;
                END;
            END;
            //BBG2.0
        END;
        //CreateUnitLifeCycle; //040919
        UnitReversal.CreateCommCreditMemo("Re-ConfOrder"."No.", TRUE);  //BBG2.0   030321
        //UnitReversal.CreateTACreditMemo("Re-ConfOrder"."Introducer Code",0,"Re-ConfOrder"."No.",TRUE);  //BBG2.0

        v_ConfirmedOrder.RESET;
        IF v_ConfirmedOrder.GET("Re-ConfOrder"."No.") THEN BEGIN
            v_ConfirmedOrder."Comm hold for Old Process" := Commholforoldprocess;  //280219
            v_ConfirmedOrder.MODIFY;
        END;
    end;


    procedure UpdateUnitwithApplicablecharge()
    var
        AppCharge_1: Record "App. Charge Code";
        AppCharge_2: Record "App. Charge Code";
        Unitmaster: Record "Unit Master";
        Job: Record Job;
        v_ArchiveDocumentMaster: Record "Archive Document Master";
        CheckDate: Date;
        v_NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
    begin

        "Re-ConfOrder"."Unit Code" := "Re-ConfOrder"."New Unit No.";
        "Re-ConfOrder"."Unit Payment Plan" := "Re-ConfOrder"."New Unit Payment Plan";
        AppCharge_2.RESET;
        AppCharge_2.SETRANGE(Code, "Re-ConfOrder"."New Unit Payment Plan");
        IF AppCharge_2.FINDFIRST THEN
            "Re-ConfOrder"."Unit Plan Name" := AppCharge_2.Description;

        Unitmaster.GET("Re-ConfOrder"."New Unit No.");
        "Re-ConfOrder"."Saleable Area" := Unitmaster."Saleable Area";
        "Re-ConfOrder"."Shortcut Dimension 1 Code" := Unitmaster."Project Code";
        IF Job.GET(Unitmaster."Project Code") THEN
            "Re-ConfOrder"."Project Type" := Job."Default Project Type";

        IF "Re-ConfOrder"."Unit Code" <> '' THEN BEGIN
            AppCharges.RESET;
            AppCharges.SETRANGE(AppCharges."Document No.", "Re-ConfOrder"."No.");
            AppCharges.SETRANGE(Code, 'PPLAN');
            IF AppCharges.FIND('-') THEN
                AppCharges.DELETEALL;

            CheckDate := 0D;
            v_NewApplicationPaymentEntry.RESET;
            v_NewApplicationPaymentEntry.SETRANGE("Document No.", "Re-ConfOrder"."No.");
            v_NewApplicationPaymentEntry.SETRANGE("Payment Mode", v_NewApplicationPaymentEntry."Payment Mode"::JV);
            IF v_NewApplicationPaymentEntry.FINDLAST THEN
                CheckDate := v_NewApplicationPaymentEntry."Posting date"
            ELSE
                CheckDate := "Re-ConfOrder"."Posting Date";

            UpdateApplicablechargesBSP4("Re-ConfOrder", Unitmaster);  //090424


            v_ArchiveDocumentMaster.RESET;
            v_ArchiveDocumentMaster.SETFILTER("Archive Date", '>=%1', CheckDate);
            v_ArchiveDocumentMaster.SETRANGE("Project Code", "Re-ConfOrder"."Shortcut Dimension 1 Code");
            v_ArchiveDocumentMaster.SETRANGE("Unit Code", '');
            v_ArchiveDocumentMaster.SETRANGE("App. Charge Code", "Re-ConfOrder"."New Unit Payment Plan");
            IF v_ArchiveDocumentMaster.FINDFIRST THEN BEGIN
                AppCharges.RESET;
                AppCharges.INIT;
                AppCharges."Document Type" := v_ArchiveDocumentMaster."Document Type"::Charge;
                AppCharges.Code := v_ArchiveDocumentMaster.Code;
                AppCharges.Description := v_ArchiveDocumentMaster.Description;
                AppCharges."Document No." := "Re-ConfOrder"."No.";
                AppCharges."Item No." := "Re-ConfOrder"."Unit Code";
                AppCharges."Membership Fee" := v_ArchiveDocumentMaster."Membership Fee";
                IF v_ArchiveDocumentMaster."Project Price Dependency Code" <> '' THEN BEGIN
                    PPGD.RESET;
                    PPGD.SETFILTER(PPGD."Project Code", "Re-ConfOrder"."Shortcut Dimension 1 Code");
                    PPGD.SETRANGE(PPGD."Project Price Group", v_ArchiveDocumentMaster."Project Price Dependency Code");
                    PPGD.SETFILTER(PPGD."Starting Date", '<=%1', "Re-ConfOrder"."Document Date");
                    IF PPGD.FINDLAST THEN BEGIN
                        IF v_ArchiveDocumentMaster."Sale/Lease" = Docmaster."Sale/Lease"::Sale THEN
                            AppCharges."Rate/UOM" := PPGD."Sales Rate (per sq ft)";
                        IF v_ArchiveDocumentMaster."Sale/Lease" = v_ArchiveDocumentMaster."Sale/Lease"::Lease THEN
                            AppCharges."Rate/UOM" := PPGD."Lease Rate (per sq ft)";

                    END;
                END ELSE
                    AppCharges."Rate/UOM" := v_ArchiveDocumentMaster."Rate/Sq. Yd";

                AppCharges."Project Code" := v_ArchiveDocumentMaster."Project Code";
                AppCharges."Fixed Price" := v_ArchiveDocumentMaster."Fixed Price";
                AppCharges."BP Dependency" := v_ArchiveDocumentMaster."BP Dependency";
                AppCharges."Rate Not Allowed" := v_ArchiveDocumentMaster."Rate Not Allowed";
                AppCharges."Project Price Dependency Code" := v_ArchiveDocumentMaster."Project Price Dependency Code";
                IF AppCharges."Rate/UOM" <> 0 THEN BEGIN
                    UnitMasterRec.GET("Re-ConfOrder"."Unit Code");
                    AppCharges."Net Amount" := UnitMasterRec."Saleable Area" * AppCharges."Rate/UOM"; //ALLEDK 030313
                END
                ELSE
                    AppCharges."Net Amount" := AppCharges."Fixed Price";
                AppCharges.Sequence := v_ArchiveDocumentMaster.Sequence;
                AppCharges."Commision Applicable" := v_ArchiveDocumentMaster."Commision Applicable";
                AppCharges."Direct Associate" := v_ArchiveDocumentMaster."Direct Associate";
                AppCharges.Applicable := TRUE;
                AppCharges.INSERT;
            END ELSE BEGIN
                Docmaster.RESET;
                Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                Docmaster.SETFILTER(Docmaster."Project Code", "Re-ConfOrder"."Shortcut Dimension 1 Code");
                Docmaster.SETRANGE(Docmaster."Unit Code", '');
                Docmaster.SETRANGE("App. Charge Code", "Re-ConfOrder"."New Unit Payment Plan");
                IF Docmaster.FINDFIRST THEN BEGIN
                    AppCharges.RESET;
                    AppCharges.INIT;
                    AppCharges."Document Type" := Docmaster."Document Type"::Charge;
                    AppCharges.Code := Docmaster.Code;
                    AppCharges.Description := Docmaster.Description;
                    AppCharges."Document No." := "Re-ConfOrder"."No.";
                    AppCharges."Item No." := "Re-ConfOrder"."Unit Code";
                    AppCharges."Membership Fee" := Docmaster."Membership Fee";
                    IF Docmaster."Project Price Dependency Code" <> '' THEN BEGIN
                        PPGD.RESET;
                        PPGD.SETFILTER(PPGD."Project Code", "Re-ConfOrder"."Shortcut Dimension 1 Code");
                        PPGD.SETRANGE(PPGD."Project Price Group", Docmaster."Project Price Dependency Code");
                        PPGD.SETFILTER(PPGD."Starting Date", '<=%1', "Re-ConfOrder"."Document Date");
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
                        UnitMasterRec.GET("Re-ConfOrder"."Unit Code");
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
            END;  //310122
                  //END; 281119

        END;

        AlltAmount := 0;
        "Re-ConfOrder".Amount := CalculateAllotAmt;
        AlltAmount := "Re-ConfOrder".Amount;
        "Re-ConfOrder"."Payment Plan" := Unitmaster."Payment Plan";
        "Re-ConfOrder".VALIDATE(Amount);

        "Re-ConfOrder"."Min. Allotment Amount" := UnitAllocationPage.CalculateMinAllotAmt(Unitmaster, "Re-ConfOrder"."Posting Date", "Re-ConfOrder"."Min. Allotment Amount", "Re-ConfOrder".Amount, FALSE);  //291221


        "Re-ConfOrder".MODIFY;

        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        IF PaymentPlanDetails.FIND('-') THEN
            REPEAT
                PaymentPlanDetails.DELETE;
            UNTIL PaymentPlanDetails.NEXT = 0;

        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        IF PaymentTermLines.FINDSET THEN
            REPEAT
                PaymentTermLines.DELETE;
            UNTIL PaymentTermLines.NEXT = 0;


        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Project Code", "Re-ConfOrder"."Shortcut Dimension 1 Code");
        PaymentPlanDetails.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
        PaymentPlanDetails.SETRANGE("Document No.", '');
        PaymentPlanDetails.SETRANGE("Sub Payment Plan", "Re-ConfOrder"."New Unit Payment Plan");
        IF PaymentPlanDetails.FIND('-') THEN
            REPEAT
                PaymentPlanDetails1.INIT;
                PaymentPlanDetails1.COPY(PaymentPlanDetails);
                PaymentPlanDetails1."Document No." := "Re-ConfOrder"."No.";
                PaymentPlanDetails1."Project Milestone Due Date" :=
                CALCDATE(PaymentPlanDetails1."Due Date Calculation", "Re-ConfOrder"."Posting Date"); //ALLETDK221112
                IF FORMAT(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat") <> '' THEN //ALLEDK 040821
                    PaymentPlanDetails1."Auto Plot Vacate Due Date" := CALCDATE(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat", PaymentPlanDetails1."Project Milestone Due Date") //ALLEDK 040821
                ELSE
                    PaymentPlanDetails1."Auto Plot Vacate Due Date" := PaymentPlanDetails1."Project Milestone Due Date";  //ALLEDK 040821

                PaymentPlanDetails1.INSERT;
            UNTIL PaymentPlanDetails.NEXT = 0;

        Unitmaster.TESTFIELD("Total Value");

        totalamount1 := 0;
        PaymentDetails.RESET;
        PaymentDetails.SETFILTER("Project Code", "Re-ConfOrder"."Shortcut Dimension 1 Code");
        PaymentDetails.SETFILTER("Document No.", "Re-ConfOrder"."No.");
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
        PaymentPlanDetails.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        IF PaymentPlanDetails.FINDSET THEN
            REPEAT
                PaymentPlanDetails2.COPY(PaymentPlanDetails);
                TotalAmount := TotalAmount + PaymentPlanDetails2."Milestone Charge Amount";
                PaymentPlanDetails2.INSERT;
            UNTIL PaymentPlanDetails.NEXT = 0;

        Applicablecharge.RESET;
        Applicablecharge.SETCURRENTKEY("Document No.", Applicablecharge.Sequence);
        Applicablecharge.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        Applicablecharge.SETRANGE(Applicable, TRUE);
        Applicablecharge.SETFILTER("Net Amount", '<>%1', 0);  //070317
        IF Applicablecharge.FINDSET THEN BEGIN
            MilestoneCodeG := '1';
            PaymentPlanDetails2.RESET;
            PaymentPlanDetails2.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
            PaymentPlanDetails2.SETRANGE("Document No.", "Re-ConfOrder"."No.");
            PaymentPlanDetails2.SETRANGE(Checked, FALSE);
            IF PaymentPlanDetails2.FINDSET THEN
                REPEAT
                    LoopingAmount := 0;
                    REPEAT
                        IF Applicablecharge."Net Amount" = PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                            CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", PaymentPlanDetails2."Buffer Days for AutoPlot Vacat", PaymentPlanDetails2."Auto Plot Vacate Due Date"); //ALLEDK040821
                            PaymentPlanDetails2.Checked := TRUE;
                            PaymentPlanDetails2.MODIFY;
                            TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";
                            Applicablecharge."Net Amount" := 0;
                            InLoop := TRUE;
                        END;
                        IF Applicablecharge."Net Amount" > PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                            CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", PaymentPlanDetails2."Buffer Days for AutoPlot Vacat", PaymentPlanDetails2."Auto Plot Vacate Due Date");  //ALLEDK040821
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
                                Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", PaymentPlanDetails2."Buffer Days for AutoPlot Vacat", PaymentPlanDetails2."Auto Plot Vacate Due Date"); //ALLEDK 040821

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

        WebAppService.UpdateUnitStatus(Unitmaster);  //210624

        //"New Unit No." := '';//ALLETDK120413
        "Re-ConfOrder".MODIFY;
    end;


    procedure CalculateAllotAmt(): Decimal
    var
        CalDocMaster: Record "Document Master";
        AppCharge: Record "App. Charge Code";
        UnitMaster_1: Record "Unit Master";
    begin

        Applicablecharge.RESET;
        Applicablecharge.SETRANGE("Document No.", "Re-ConfOrder"."No.");
        IF Applicablecharge.FINDSET THEN
            REPEAT
                TotalValue := TotalValue + Applicablecharge."Net Amount";
            UNTIL Applicablecharge.NEXT = 0;

        TotalValue := ROUND(TotalValue, 1, '=');
        EXIT(TotalValue);
    end;


    procedure CreatePaymentTermsLine(MilestoneCode: Code[10]; MilestoneDescription: Text[50]; MilestoneDueDate: Date; Milestoneamt: Decimal; ChargeCode: Code[10]; CommisionApplicable: Boolean; DirectAssociate: Boolean; BufferDaysAutoPlot: DateFormula; AutoPlotVacateDueDate: Date)
    begin

        PaymentTermLines.INIT;
        PaymentTermLines."Document No." := "Re-ConfOrder"."No.";
        PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
        PaymentTermLines.Sequence := Sno;
        Sno := INCSTR(Sno);
        PaymentTermLines."Actual Milestone" := MilestoneCode;
        PaymentTermLines."Payment Plan" := PaymentPlanDetails."Payment Plan Code";
        PaymentTermLines.Description := MilestoneDescription;
        PaymentTermLines."Due Date" := MilestoneDueDate;
        PaymentTermLines."Auto Plot Vacate Due Date" := AutoPlotVacateDueDate; //ALLEDK040821
        PaymentTermLines."Buffer Days for AutoPlot Vacat" := BufferDaysAutoPlot; //ALLEDK040821
        PaymentTermLines."Project Code" := "Re-ConfOrder"."Shortcut Dimension 1 Code";
        PaymentTermLines."Calculation Type" := PaymentTermLines."Calculation Type"::"% age";
        PaymentTermLines."Criteria Value / Base Amount" := Milestoneamt;
        PaymentTermLines."Calculation Value" := 100;
        PaymentTermLines."Due Amount" := ROUND(Milestoneamt, 0.01, '=');
        PaymentTermLines."Charge Code" := ChargeCode;
        PaymentTermLines."Commision Applicable" := CommisionApplicable;
        PaymentTermLines."Direct Associate" := DirectAssociate;
        PaymentTermLines.INSERT(TRUE);
    end;


    procedure UpdateRoundOFF(ProjectCode: Code[20]; UnitCode: Code[20])
    var
        TotalChAmt1: Decimal;
        RoundOffAmt: Decimal;
        ReviseValue: Decimal;
    begin
        TotalChAmt1 := 0;
        RoundOffAmt := 0;
        ReviseValue := 0;
        DocumentMaster.RESET;
        DocumentMaster.SETRANGE("Document Type", DocumentMaster."Document Type"::Charge);
        DocumentMaster.SETRANGE("Project Code", ProjectCode);
        DocumentMaster.SETRANGE("Unit Code", UnitCode);
        DocumentMaster.SETFILTER(Code, '<>%1&<>%2', 'OTH', 'PPLAN*');
        IF DocumentMaster.FINDFIRST THEN BEGIN
            REPEAT
                //IF DocumentMaster.Code <> 'PPLAN' THEN
                TotalChAmt1 := TotalChAmt1 + DocumentMaster."Total Charge Amount";
            UNTIL DocumentMaster.NEXT = 0;
            ReviseValue := ROUND(TotalChAmt1, 1, '>');

            RoundOffAmt := ReviseValue - TotalChAmt1;
            IF RoundOffAmt < 0 THEN
                ERROR('The Unit Rate must be greater or Equal to Charge Rate');

            IF RoundOffAmt <> 0 THEN BEGIN
                DocumentMaster1.RESET;
                DocumentMaster1.SETRANGE("Document Type", DocumentMaster1."Document Type"::Charge);
                DocumentMaster1.SETRANGE("Project Code", ProjectCode);
                DocumentMaster1.SETRANGE("Unit Code", UnitCode);
                DocumentMaster1.SETRANGE(Code, 'OTH');
                IF DocumentMaster1.FINDFIRST THEN BEGIN
                    DocumentMaster1.VALIDATE("Fixed Price", (RoundOffAmt));
                    DocumentMaster1.MODIFY;
                END;
            END;
        END;
        IF UMaster.GET(UnitCode) THEN BEGIN
            UMaster."Total Value" := ROUND(ReviseValue, 1, '>');
            UMaster.MODIFY;
            //ReleaseUnit.Updateunitmaster(UMaster);
        END;
        ReviseValue := 0;
    end;

    local procedure UpdateApplicablechargesBSP4(RecConforders_3: Record "Confirmed Order"; UnitMaster_3: Record "Unit Master")
    var
        Docmaster_3: Record "Document Master";
    begin
        Docmaster_3.RESET;
        Docmaster_3.SETRANGE(Docmaster_3."Document Type", Docmaster_3."Document Type"::Charge);
        Docmaster_3.SETFILTER(Docmaster_3."Project Code", RecConforders_3."Shortcut Dimension 1 Code");
        Docmaster_3.SETFILTER(Docmaster_3."Unit Code", UnitMaster_3."No.");
        Docmaster_3.SETFILTER(Code, 'BSP4');   //040424
        IF Docmaster_3.FINDSET THEN BEGIN
            Docmaster.RESET;
            Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
            Docmaster.SETFILTER(Docmaster."Project Code", RecConforders_3."Shortcut Dimension 1 Code");
            Docmaster.SETRANGE(Docmaster."Unit Code", '');
            Docmaster.SETRANGE("App. Charge Code", RecConforders_3."New Unit Payment Plan");
            Docmaster.SETFILTER("Rate/Sq. Yd", '<>%1', 0);
            IF Docmaster.FINDFIRST THEN BEGIN
                Job.RESET;
                IF Job.GET(RecConforders_3."Shortcut Dimension 1 Code") THEN BEGIN
                    IF (Job."BSP4 Plan wise Applicable") AND (RecConforders_3."Posting Date" >= Job."BSP4 Plan wise St. Date") THEN BEGIN
                        Docmaster_3."Rate/Sq. Yd" := Docmaster."BSP4 Plan wise Rate / Sq. Yd";
                        Docmaster_3."Total Charge Amount" := Docmaster."BSP4 Plan wise Rate / Sq. Yd" * UnitMaster_3."Saleable Area";
                        Docmaster_3.MODIFY;
                        AppCharges.RESET;
                        AppCharges.SETRANGE("Document Type", AppCharges."Document Type"::Charge);
                        AppCharges.SETRANGE("Project Code", RecConforders_3."Shortcut Dimension 1 Code");
                        AppCharges.SETRANGE(Code, 'BSP4');
                        AppCharges.SETRANGE("Document No.", RecConforders_3."No.");
                        AppCharges.SETRANGE("Item No.", UnitMaster_3."No.");
                        IF AppCharges.FINDFIRST THEN BEGIN
                            AppCharges."Net Amount" := Docmaster_3."Total Charge Amount";
                            AppCharges.MODIFY;
                        END;
                    END ELSE BEGIN
                        Docmaster.RESET;
                        Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                        Docmaster.SETFILTER(Docmaster."Project Code", RecConforders_3."Shortcut Dimension 1 Code");
                        Docmaster.SETRANGE(Docmaster."Unit Code", '');
                        Docmaster.SETRANGE(Code, 'BSP4');
                        Docmaster.SETFILTER("Rate/Sq. Yd", '<>%1', 0);
                        IF Docmaster.FINDFIRST THEN BEGIN
                            Docmaster_3."Rate/Sq. Yd" := Docmaster."Rate/Sq. Yd";
                            Docmaster_3."Total Charge Amount" := Docmaster."Rate/Sq. Yd" * UnitMaster_3."Saleable Area";
                            Docmaster_3.MODIFY;
                            AppCharges.RESET;
                            AppCharges.SETRANGE("Document Type", AppCharges."Document Type"::Charge);
                            AppCharges.SETRANGE("Project Code", RecConforders_3."Shortcut Dimension 1 Code");
                            AppCharges.SETRANGE(Code, 'BSP4');
                            AppCharges.SETRANGE("Document No.", RecConforders_3."No.");
                            AppCharges.SETRANGE("Item No.", UnitMaster_3."No.");
                            IF AppCharges.FINDFIRST THEN BEGIN
                                AppCharges."Net Amount" := Docmaster_3."Total Charge Amount";
                                AppCharges.MODIFY;
                            END;

                        END;
                    END;
                END;
            END;
        END;
    end;
}

