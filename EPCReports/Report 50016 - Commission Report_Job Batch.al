report 50016 "Commission Report_Job Batch"
{
    // version New REport for Jobqueue

    DefaultLayout = RDLC;
    RDLCLayout = './Reports/Commission Report_Job Batch.rdl';
    UseRequestPage = false;
    ApplicationArea = All;

    dataset
    {
        dataitem("Company wise G/L Account"; "Company wise G/L Account")
        {
            DataItemTableView = SORTING("Company Code")
                                WHERE("Active for Reports" = FILTER(true));
            column(Comp_Name; CompInfo.Name)
            {
            }
            column(AllVenturesSelectedAssociateCommissionFrom_SDate_EDate; 'All Ventures Selected Associate Commission From  ' + FORMAT(SDate1) + ' To  ' + FORMAT(EDate1))
            {
            }
            column(Comp_Address; CompInfo.Address + ',' + CompInfo."Address 2" + ',' + CompInfo.City + ',' + CompInfo."Post Code")
            {
            }
            column(CommissionEligibility_AllApplication; 'Commission Eligibility (All Application)')
            {
            }
            column(MMCode; 'Associate Code :' + MMCode + ' ' + MMName + ' PAN No. :' + ' [' + Vend1."P.A.N. No." + ']')
            {
            }
            column(ShowInt; ShowInt)
            {
            }
            dataitem("Associate Hierarcy with App."; "Associate Hierarcy with App.")
            {
                DataItemLink = "Company Name" = FIELD("Company Code");
                DataItemTableView = SORTING("Project Code", "Associate Code", "Introducer Code")
                                    WHERE(Status = FILTER(Active));
                RequestFilterFields = "Application Code";
                column(ProjectCodeH; 'Project Code :')
                {
                }
                column(ProjectCode; "Project Code")
                {
                }
                column(RCntr_Name; RCntr.Name)
                {
                }
                column(STotalCost; STotalCost)
                {
                }
                column(STotalReceipt; STotalReceipt)
                {
                }
                column(STotalDisc; STotalDisc)
                {
                }
                column(STotalCost_STotalReceipt_STotalDisc; STotalCost - STotalReceipt - STotalDisc)
                {
                }
                column(SBSP1_SBSP3; "SBSP1+SBSP3")
                {
                }
                column(SBSP2; SBSP2)
                {
                }
                column(SBSP1; SBSP1)
                {
                }
                column(STrvlAmt; STrvlAmt)
                {
                }
                column(SBSP2_SBSP1_SBSP3; SBSP2 + "SBSP1+SBSP3")
                {
                }
                column(SCommAmt_SElgiblBSP2; SCommAmt - SElgiblBSP2)
                {
                }
                column(SElgiblBSP2; SElgiblBSP2)
                {
                }
                column(STotal; STotal)
                {
                }
                column(BSP1Total; 'BSP1 Total')
                {
                }
                column(BSP1Tot; BSP1)
                {
                }
                column(TotalEligInclOpening; 'Total Elig. Incl Opening')
                {
                }
                column(NetPayable; NetPayable)
                {
                }
                column(TotalDeductionInclTARev; 'Total Deduction(Incl TA Rev)')
                {
                }
                column(TotalPayment_ABSCorrTrvlPmt; TotalPayment + ABS(CorrTrvlPmt))
                {
                }
                column(TotalEligInclOpen; 'Total Elig. Incl. Opening')
                {
                }
                column(TotalPayment_ABSCorrTrvlPmt_NetPayable; TotalPayment + ABS(CorrTrvlPmt) + (NetPayable))
                {
                }
                column(TotalEligibility_ExclOp; 'Total Eligibility(Excl. Op)')
                {
                }
                column(TotalPayment_ABSCorrTrvlPmt_NetPayable_RemOpOpening; TotalPayment + ABS(CorrTrvlPmt) + (NetPayable) - RemOpOpening)
                {
                }
                dataitem("New Confirmed Order"; "New Confirmed Order")
                {
                    CalcFields = "Total Received Amount";
                    DataItemLink = "No." = FIELD("Application Code");
                    DataItemTableView = SORTING("Introducer Code", "Posting Date");
                    column(CustomerNo_NewConfirmedOrder; "New Confirmed Order"."Customer No.")
                    {
                    }
                    column(CName; CName)
                    {
                    }
                    column(UnitCode_NewConfirmedOrder; "New Confirmed Order"."Unit Code")
                    {
                    }
                    column(SaleableArea_NewConfirmedOrder; "New Confirmed Order"."Saleable Area")
                    {
                    }
                    column(Amount_NewConfirmedOrder; "New Confirmed Order".Amount)
                    {
                    }
                    column(TotalReceivedAmount_NewConfirmedOrder; "New Confirmed Order"."Total Received Amount")
                    {
                    }
                    column(DiscAmt; DiscAmt)
                    {
                    }
                    column(Amount_TotalReceivedAmount_DiscAmt; Amount - "Total Received Amount" - DiscAmt)
                    {
                    }
                    column(BSP1_BSP3; BSP1 + BSP3)
                    {
                    }
                    column(BSP2; BSP2)
                    {
                    }
                    column(BSP1; BSP1)
                    {
                    }
                    column(TrvlAmt; TrvlAmt)
                    {
                    }
                    column(BSP1_BSP3_BSP2; BSP1 + BSP3 + BSP2)
                    {
                    }
                    column(IntroducerCode_NewConfirmedOrder; '[ ' + "New Confirmed Order"."Introducer Code")
                    {
                    }
                    column(Vend_Name; Vend.Name + ' ]')
                    {
                    }
                    column(ApplicationNo; "Application No.")
                    {
                    }
                    column(PostingDate_NewConfirmedOrder; FORMAT("New Confirmed Order"."Posting Date"))
                    {
                    }
                    column(CommAmt_ElgiblBSP2_; CommAmt - ElgiblBSP2)
                    {
                    }
                    column(ElgiblBSP2_; ElgiblBSP2)
                    {
                    }
                    column(Total_; Total)
                    {
                    }
                    column(GTotalCost_; GTotalCost)
                    {
                    }
                    column(GTotalReceipt_; GTotalReceipt)
                    {
                    }
                    column(GTotalDisc_; GTotalDisc)
                    {
                    }
                    column(GTotalCost_GTotalReceipt_GTotalDisc_; GTotalCost - GTotalReceipt - GTotalDisc)
                    {
                    }
                    column(GSBSP1_GSBSP3_; "GSBSP1+GSBSP3")
                    {
                    }
                    column(GBSP2_; GBSP2)
                    {
                    }
                    column(GBSP1_; GBSP1)
                    {
                    }
                    column(GTrvlAmt_; GTrvlAmt)
                    {
                    }
                    column(GBSP2_GSBSP1_GSBSP3_; GBSP2 + "GSBSP1+GSBSP3")
                    {
                    }
                    column(GCommAmt_GElgiblBSP2_; GCommAmt - GElgiblBSP2)
                    {
                    }
                    column(GElgiblBSP2_; GElgiblBSP2)
                    {
                    }
                    column(GTTotal_; GTTotal)
                    {
                    }
                    column(ShowData_; ShowData)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Cust.GET("Customer No.") THEN
                            CName := Cust.Name;

                        RemAmt := 0;

                        CLEAR(DiscAmt);
                        CLEAR(Balance);
                        DebAppPayEntry.RESET;
                        DebAppPayEntry.CHANGECOMPANY("New Confirmed Order"."Company Name");
                        DebAppPayEntry.SETRANGE("Document No.", "No.");
                        DebAppPayEntry.SETRANGE("Posting date", 0D, EDate1);
                        DebAppPayEntry.SETRANGE(Posted, TRUE);
                        DebAppPayEntry.SETRANGE("Introducer Code", "Introducer Code");
                        IF DebAppPayEntry.FINDSET THEN
                            REPEAT
                                DiscAmt += DebAppPayEntry."Net Payable Amt";
                            UNTIL DebAppPayEntry.NEXT = 0;

                        Balance := Amount - "Total Received Amount" - DiscAmt;

                        CLEAR(BSP1);
                        CLEAR(BSP2);
                        CLEAR(BSP3);
                        UnitPayEntry.RESET;
                        UnitPayEntry.CHANGECOMPANY("New Confirmed Order"."Company Name");
                        UnitPayEntry.SETRANGE("Document No.", "No.");
                        UnitPayEntry.SETRANGE("Posting date", 0D, EDate1);
                        IF UnitPayEntry.FINDSET THEN
                            REPEAT
                                IF UnitPayEntry."Cheque Status" = UnitPayEntry."Cheque Status"::Cleared THEN BEGIN
                                    IF (UnitPayEntry."Charge Code" = 'BSP1') OR (UnitPayEntry."Charge Code" = 'PPLAN') THEN BEGIN
                                        BSP1 += ROUND(UnitPayEntry.Amount, 1);
                                    END ELSE IF UnitPayEntry."Charge Code" = 'BSP2' THEN BEGIN
                                        BSP2 += UnitPayEntry.Amount;
                                    END ELSE IF UnitPayEntry."Charge Code" = 'BSP3' THEN BEGIN
                                        BSP3 += ROUND(UnitPayEntry.Amount, 1);
                                    END;
                                END;
                            UNTIL UnitPayEntry.NEXT = 0;
                        CLEAR(TrvlAmt);
                        TrvlPmt.RESET;
                        TrvlPmt.CHANGECOMPANY("New Confirmed Order"."Company Name");
                        TrvlPmt.SETCURRENTKEY("Sub Associate Code", "Creation Date", Approved, Reverse, CreditMemo);
                        TrvlPmt.SETRANGE("Sub Associate Code", MMCode);
                        TrvlPmt.SETRANGE("Creation Date", 0D, EDate1);
                        TrvlPmt.SETRANGE(Approved, TRUE);
                        TrvlPmt.SETRANGE(Reverse, FALSE);
                        TrvlPmt.SETRANGE(CreditMemo, FALSE);
                        TrvlPmt.SETRANGE("Not consider in CommReport", FALSE);
                        IF TrvlPmt.FINDSET THEN
                            REPEAT
                                TrvlPmtDetail.RESET;
                                TrvlPmtDetail.CHANGECOMPANY("New Confirmed Order"."Company Name");
                                TrvlPmtDetail.SETRANGE("Document No.", TrvlPmt."Document No.");
                                TrvlPmtDetail.SETRANGE("Application No.", "No.");
                                TrvlPmtDetail.SETRANGE(Reverse, FALSE);  //BBG1.00 120813
                                IF TrvlPmtDetail.FINDFIRST THEN BEGIN
                                    TrvlAmt := TrvlPmt."TA Rate" * TrvlPmtDetail."Saleable Area";
                                END;
                            UNTIL TrvlPmt.NEXT = 0;


                        TotalTAAmt := TotalTAAmt + TrvlAmt;

                        CLEAR(CommAmt);
                        CLEAR(ElgiblBSP2);
                        CLEAR(CommEntry);
                        CommEntry.RESET;
                        CommEntry.CHANGECOMPANY("New Confirmed Order"."Company Name");
                        CommEntry.SETCURRENTKEY("Associate Code", "Application No.", "Posting Date");
                        CommEntry.SETRANGE("Associate Code", MMCode);
                        CommEntry.SETRANGE("Application No.", "Application No.");
                        CommEntry.SETRANGE("Posting Date", 0D, EDate1);
                        CommEntry.SETRANGE(Discount, FALSE);
                        CommEntry.SETRANGE("Opening Entries", FALSE);
                        IF CommEntry.FINDSET THEN
                            REPEAT
                                IF (CommEntry."Direct to Associate" = FALSE) THEN BEGIN
                                    TCommAmt := TCommAmt + CommEntry."Commission Amount";
                                    CommAmt := CommAmt + CommEntry."Commission Amount";
                                END;
                                IF (CommEntry."Direct to Associate") AND (NOT CommEntry."Remaining Amt of Direct")
                                 AND (NOT "Registration Bonus Hold(BSP2)") THEN BEGIN
                                    ElgiblBSP2 := ElgiblBSP2 + CommEntry."Commission Amount";
                                    CommAmt := CommAmt + CommEntry."Commission Amount";
                                    TCommAmt := TCommAmt + CommEntry."Commission Amount";
                                END;
                            UNTIL CommEntry.NEXT = 0;

                        TotalRemAmt := TotalRemAmt + RemAmt;
                        Total := CommAmt + TrvlAmt;
                        CompTotal := CompTotal + CommAmt + TrvlAmt;
                        CompTrvlAmt := CompTrvlAmt + TrvlAmt;

                        GTotalCost := GTotalCost + "New Confirmed Order".Amount;
                        GTotalReceipt += "New Confirmed Order"."Total Received Amount";
                        GTotalDisc += DiscAmt;
                        GBSP2 += BSP2;
                        GBSP1 += BSP1;
                        GTrvlAmt += TrvlAmt;
                        GCommAmt += CommAmt - ElgiblBSP2;
                        GElgiblBSP2 += ElgiblBSP2;
                        "GSBSP1+GSBSP3" += BSP1 + BSP3;
                        GTTotal += Total;


                        IF Vend.GET("Introducer Code") THEN;
                        ShowData := FALSE;

                        RecUnitSetup.GET;
                        RecUserSetup.GET(USERID);
                        IF "Posting Date" >= RecUserSetup."Commission Report Cuttoff Date" THEN
                            ShowData := TRUE;

                        IF "New Confirmed Order".Status = "New Confirmed Order".Status::Registered THEN
                            ShowData := FALSE;

                        IF ShowData = TRUE THEN BEGIN
                            AppCutoff := '-' + FORMAT(RecUnitSetup."Application Cutoff Period");
                            IF ("Posting Date" <= CALCDATE(AppCutoff, TODAY)) THEN BEGIN
                                IF "New Confirmed Order"."Total Received Amount" > RecUnitSetup."Application Cutoff Amount" THEN
                                    ShowData := TRUE
                                ELSE
                                    ShowData := FALSE;
                            END;
                        END;

                        IF ShowData THEN BEGIN
                            BodyExists := TRUE;
                            STotalCost += "New Confirmed Order".Amount;
                            STotalReceipt += "New Confirmed Order"."Total Received Amount";
                            STotalDisc += DiscAmt;
                            SBSP2 += BSP2;
                            SBSP1 += BSP1;
                            STrvlAmt += TrvlAmt;
                            SCommAmt += CommAmt - ElgiblBSP2;
                            SElgiblBSP2 += ElgiblBSP2;
                            "SBSP1+SBSP3" += BSP1 + BSP3;
                            STotal += Total;
                        END;

                        IF ShowData THEN BEGIN
                            ProjectName := '';
                            GeneralSEtup.GET;
                            DimensionValue.RESET;
                            DimensionValue.SETRANGE(DimensionValue."Dimension Code", GeneralSEtup."Shortcut Dimension 1 Code");
                            DimensionValue.SETRANGE(Code, "New Confirmed Order"."Shortcut Dimension 1 Code");
                            IF DimensionValue.FINDFIRST THEN
                                ProjectName := DimensionValue.Name;

                        END;
                    end;

                    trigger OnPreDataItem()
                    begin

                        SETRANGE("Posting Date", 0D, EDate1);
                        CurrReport.CREATETOTALS("New Confirmed Order".Amount, "New Confirmed Order"."Total Received Amount", DiscAmt, Balance, BSP1, BSP2, BSP3)
                        ;
                        CurrReport.CREATETOTALS(CommAmt, TrvlAmt, ElgiblBSP2, Total);
                        CurrReport.CREATETOTALS(STotalCost, STotalReceipt, STotalDisc, "SBSP1+SBSP3", SBSP2, SBSP1, STrvlAmt, SCommAmt, SElgiblBSP2, STotal);


                        TCommAmt := 0;
                        TotalTAAmt := 0;
                        TrvlAmt1 := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin

                    IF Vend.GET(MMCode) THEN
                        MMName := Vend.Name;
                    IF RCntr.GET("Project Code") THEN;
                end;

                trigger OnPreDataItem()
                begin

                    SETRANGE("Posting Date", 0D, EDate1);



                    SETRANGE("Associate Code", MMCode);
                    ASSCode := '';

                    CurrReport.CREATETOTALS("New Confirmed Order".Amount, "New Confirmed Order"."Total Received Amount", DiscAmt, Balance, BSP1, BSP2, BSP3)
                    ;
                    CurrReport.CREATETOTALS(CommAmt, TrvlAmt, ElgiblBSP2, Total);
                    CurrReport.CREATETOTALS(STotalCost, STotalReceipt, STotalDisc, "SBSP1+SBSP3", SBSP2, SBSP1, STrvlAmt, SCommAmt, SElgiblBSP2, STotal);

                    TotalTAAmt1 := 0;
                    RecAppCode := '';

                    //CurrReport.SHOWOUTPUT :=
                    //                          CurrReport.TOTALSCAUSEDBY = FIELDNO("Project Code");
                    BodyExists := FALSE;
                    ShowHeader := FALSE;

                    RecUnitSetup.GET;
                    RecUserSetup.GET(USERID);

                    CheckNewAssoHier.RESET;
                    CheckNewAssoHier.SETCURRENTKEY("Project Code", "Associate Code", "Introducer Code");
                    CheckNewAssoHier.SETRANGE("Associate Code", MMCode);
                    CheckNewAssoHier.SETRANGE("Project Code", "Project Code");
                    CheckNewAssoHier.SETRANGE(Status, CheckNewAssoHier.Status::Active);
                    IF CheckNewAssoHier.FINDSET THEN
                        REPEAT
                            CheckConfOrder.RESET;
                            CheckConfOrder.SETRANGE("No.", CheckNewAssoHier."Application Code");
                            IF CheckConfOrder.FINDSET THEN
                                REPEAT
                                    CheckConfOrder.CALCFIELDS("Total Received Amount");
                                    IF CheckConfOrder."Posting Date" >= RecUserSetup."Commission Report Cuttoff Date" THEN
                                        ShowHeader := TRUE;

                                    IF CheckConfOrder.Status = CheckConfOrder.Status::Registered THEN
                                        ShowHeader := FALSE;

                                    IF ShowHeader = TRUE THEN BEGIN
                                        AppCutoff := '-' + FORMAT(RecUnitSetup."Application Cutoff Period");
                                        IF (CheckConfOrder."Posting Date" <= CALCDATE(AppCutoff, TODAY)) THEN BEGIN
                                            IF CheckConfOrder."Total Received Amount" > RecUnitSetup."Application Cutoff Amount" THEN
                                                ShowHeader := TRUE
                                            ELSE
                                                ShowHeader := FALSE;
                                        END;
                                    END;

                                UNTIL (CheckConfOrder.NEXT = 0) OR ShowHeader;
                        UNTIL (CheckNewAssoHier.NEXT = 0) OR (ShowHeader);

                    IF ShowHeader THEN
                        CurrReport.SHOWOUTPUT(TRUE)
                    ELSE
                        CurrReport.SHOWOUTPUT(FALSE);
                end;
            }

            trigger OnAfterGetRecord()
            var
                VLEntry_1: Record "Vendor Ledger Entry";
                NewDateforInventive: Date;
            begin

                Unitstup.GET;
                RecVend_1.RESET;
                RecVend_1.SETRANGE("No.", MMCode);
                RecVend_1.SETRANGE("BBG Black List", TRUE);
                IF RecVend_1.FINDFIRST THEN BEGIN
                    CurrReport.SKIP;
                END ELSE BEGIN
                    CompTotal := 0;
                    CompTrvlAmt := 0;
                    VLEntry_2.RESET;
                    VLEntry_2.CHANGECOMPANY("Company Code");
                    VLEntry_2.SETCURRENTKEY("Vendor No.", "Posting Type");
                    VLEntry_2.SETRANGE("Vendor No.", MMCode);
                    VLEntry_2.SETFILTER("Posting Type", '<>%1', VLEntry_2."Posting Type"::Incentive);
                    VLEntry_2.SETRANGE("Posting Date", DMY2DATE(28, 2, 2013), DMY2DATE(28, 2, 2013));
                    IF VLEntry_2.FINDSET THEN BEGIN
                        REPEAT
                            VLEntry_2.CALCFIELDS(VLEntry_2.Amount);
                            TotalElGodAmt1 := TotalElGodAmt1 + VLEntry_2.Amount;
                        UNTIL VLEntry_2.NEXT = 0;
                        IF TotalElGodAmt1 > 0 THEN BEGIN
                            TotalElGodAmt1 := TotalElGodAmt1 * 89 / 100;
                        END;
                    END;


                    NewDateforInventive := 0D;
                    NewDateforInventive := DMY2DATE(1, 10, 2022); //(1,4,2023);  //080623 Code modify
                    VLEntry_1.RESET;
                    VLEntry_1.CHANGECOMPANY("Company Code");
                    VLEntry_1.SETCURRENTKEY("Vendor No.", "Posting Type");
                    VLEntry_1.SETRANGE("Vendor No.", MMCode);
                    //VLEntry_1.SETFILTER("Posting Type",'<>%1',VLEntry_1."Posting Type"::Incentive);
                    VLEntry_1.SETRANGE("Posting Date", DMY2DATE(1, 3, 2013), EDate1);
                    IF VLEntry_1.FINDSET THEN
                        REPEAT
                            VLEntry_1.CALCFIELDS(VLEntry_1.Amount);
                            IF VLEntry_1."Posting Type" = VLEntry_1."Posting Type"::Incentive THEN BEGIN
                                IF "Company wise G/L Account"."Company Code" = 'BBG India Developers LLP' THEN BEGIN  //080623 added
                                    IF (VLEntry_1."Posting Date" >= NewDateforInventive) THEN
                                        TotalELGODAmt := TotalELGODAmt + VLEntry_1.Amount;
                                END;
                            END ELSE
                                TotalELGODAmt := TotalELGODAmt + VLEntry_1.Amount;
                        UNTIL VLEntry_1.NEXT = 0;
                    ////--------------------------------New code Start ------------------


                    Doc_Inv := '';
                    VLE_Invoice.RESET;
                    VLE_Invoice.CHANGECOMPANY("Company Code");
                    VLE_Invoice.SETCURRENTKEY("Vendor No.", "Document No.");
                    VLE_Invoice.SETRANGE("Vendor No.", MMCode);
                    VLE_Invoice.SETRANGE(Reversed, FALSE);
                    VLE_Invoice.SETRANGE("Posting Date", DMY2DATE(1, 3, 2013), EDate1);
                    IF PostTypeFilter = PostTypeFilter::Incentive THEN
                        VLE_Invoice.SETRANGE("Posting Type", VLE_Invoice."Posting Type"::Incentive)
                    ELSE IF PostTypeFilter = PostTypeFilter::CommissionTA THEN
                        VLE_Invoice.SETFILTER("Posting Type", '<>%1', VLE_Invoice."Posting Type"::Incentive);
                    VLE_Invoice.SETRANGE("Payment Trasnfer from Other", FALSE);
                    IF VLE_Invoice.FINDSET THEN
                        REPEAT
                            IF VLE_Invoice."Document Type" = VLE_Invoice."Document Type"::Payment THEN BEGIN
                                IF Doc_Pmt <> VLE_Invoice."Document No." THEN BEGIN
                                    Doc_Pmt := VLE_Invoice."Document No.";

                                    VLE_Payment_2.RESET;
                                    VLE_Payment_2.CHANGECOMPANY("Company Code");
                                    VLE_Payment_2.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                                    VLE_Payment_2.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                    VLE_Payment_2.SETFILTER("Document Type", '%1|%2', VLE_Invoice."Document Type", VLE_Payment_2."Document Type"::Refund);//070417

                                    VLE_Payment_2.SETRANGE("Vendor No.", VLE_Invoice."Vendor No.");
                                    IF VLE_Payment_2.FINDSET THEN
                                        REPEAT
                                            VLE_Payment_2.CALCFIELDS(Amount);
                                            Amt_Pmt := Amt_Pmt + VLE_Payment_2.Amount;
                                        UNTIL VLE_Payment_2.NEXT = 0;

                                    GLE_Payment.RESET;
                                    GLE_Payment.CHANGECOMPANY("Company Code");
                                    GLE_Payment.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                    GLE_Payment.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                    GLE_Payment.SETRANGE("Document Type", GLE_Payment."Document Type"::Payment);
                                    GLE_Payment.SETRANGE("G/L Account No.", Unitstup."Corpus A/C");
                                    GLE_Payment.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                    IF GLE_Payment.FINDSET THEN
                                        REPEAT
                                            Club_Pmt := Club_Pmt + GLE_Payment.Amount;
                                        UNTIL GLE_Payment.NEXT = 0;
                                    GLE_Payment1.RESET;
                                    GLE_Payment1.CHANGECOMPANY("Company Code");
                                    GLE_Payment1.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                    GLE_Payment1.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                    GLE_Payment1.SETRANGE("Document Type", GLE_Payment1."Document Type"::Payment);
                                    GLE_Payment1.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                    GLE_Payment1.SETRANGE("G/L Account No.", '116400', '117100');
                                    IF GLE_Payment1.FINDSET THEN
                                        REPEAT
                                            TDS_Pmt := TDS_Pmt + GLE_Payment1.Amount;
                                        UNTIL GLE_Payment1.NEXT = 0;
                                END;
                            END ELSE BEGIN

                                VLE_Invoice.CALCFIELDS(Amount);
                                IF VLE_Invoice."Posting Date" <= DMY2DATE(31, 8, 2016) THEN BEGIN
                                    IF Doc_Inv <> VLE_Invoice."Document No." THEN BEGIN
                                        GLE_Invoice.RESET;
                                        GLE_Invoice.CHANGECOMPANY("Company Code");
                                        GLE_Invoice.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                        GLE_Invoice.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                        GLE_Invoice.SETRANGE("G/L Account No.", Unitstup."Corpus A/C");
                                        GLE_Invoice.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                        IF GLE_Invoice.FINDSET THEN
                                            REPEAT
                                                Club_Invoice := Club_Invoice + GLE_Invoice.Amount;
                                            UNTIL GLE_Invoice.NEXT = 0;
                                        GLE_Invoice1.RESET;
                                        GLE_Invoice1.CHANGECOMPANY("Company Code");
                                        GLE_Invoice1.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                        GLE_Invoice1.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                        GLE_Invoice1.SETRANGE("G/L Account No.", '116400', '117100');
                                        GLE_Invoice1.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                        IF GLE_Invoice1.FINDSET THEN
                                            REPEAT
                                                TDS_Invoice := TDS_Invoice + GLE_Invoice1.Amount;
                                            UNTIL GLE_Invoice1.NEXT = 0;
                                    END;

                                    TotalAmt_Invoice := TotalAmt_Invoice + VLE_Invoice.Amount;
                                END ELSE BEGIN
                                    IF Doc_Inv <> VLE_Invoice."Document No." THEN BEGIN
                                        GLE_Invoice.RESET;
                                        GLE_Invoice.CHANGECOMPANY("Company Code");
                                        GLE_Invoice.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                        GLE_Invoice.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                        GLE_Invoice.SETRANGE("G/L Account No.", Unitstup."Corpus A/C");
                                        GLE_Invoice.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                        IF GLE_Invoice.FINDSET THEN
                                            REPEAT
                                                Club_Invoice_1 := Club_Invoice_1 + GLE_Invoice.Amount;
                                            UNTIL GLE_Invoice.NEXT = 0;
                                        GLE_Invoice1.RESET;
                                        GLE_Invoice1.CHANGECOMPANY("Company Code");
                                        GLE_Invoice1.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                        GLE_Invoice1.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                        GLE_Invoice1.SETRANGE("G/L Account No.", '116400', '117100');
                                        GLE_Invoice1.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                        IF GLE_Invoice1.FINDSET THEN
                                            REPEAT
                                                TDS_Invoice_1 := TDS_Invoice_1 + GLE_Invoice1.Amount;
                                            UNTIL GLE_Invoice1.NEXT = 0;
                                    END;

                                    TotalAmt_Invoice_1 := TotalAmt_Invoice_1 + VLE_Invoice.Amount;
                                END;
                            END;
                        UNTIL VLE_Invoice.NEXT = 0;

                    PTds := 0;
                    Pclb := 0;
                    PSAmt := 0;
                    OpenInvAmt_1 := 0;


                    VLE.RESET;
                    VLE.CHANGECOMPANY("Company Code");
                    VLE.SETCURRENTKEY("Vendor No.", "Posting Date");
                    VLE.SETRANGE("Posting Date", 0D, DMY2DATE(28, 2, 2013));
                    VLE.SETRANGE("Vendor No.", MMCode);
                    IF PostTypeFilter = PostTypeFilter::Incentive THEN
                        VLE.SETRANGE("Posting Type", VLE."Posting Type"::Incentive)
                    ELSE IF PostTypeFilter = PostTypeFilter::CommissionTA THEN
                        VLE.SETFILTER("Posting Type", '<>%1', VLE."Posting Type"::Incentive);
                    IF VLE.FINDSET THEN BEGIN
                        REPEAT
                            VLE.CALCFIELDS("Original Amt. (LCY)");
                            PAmt += VLE."Original Amt. (LCY)";
                        UNTIL VLE.NEXT = 0;
                        IF PAmt > 0 THEN BEGIN
                            PSAmt := PAmt;
                            PTds := PSAmt * 10 / 100;
                            Pclb := PSAmt * 1 / 100;
                        END ELSE BEGIN
                            PSAmt := 0;
                            OpenInvAmt_1 := PAmt;
                        END;
                    END;

                    TPSAmt += PSAmt - PTds - Pclb;
                    TOpenInvAmt_1 += OpenInvAmt_1;

                    ////--------------------------------New code Start ------------------
                END;
            end;

            trigger OnPostDataItem()
            begin

                //////----------131020

                V_AssociateHierarcywithApp.RESET;
                V_AssociateHierarcywithApp.SETRANGE("Associate Code", MMCode);
                v_TotalElGodAmt1 := 0;
                v_TotalELGODAmt := 0;
                Company.RESET;
                IF Company.FINDSET THEN
                    REPEAT
                        VLEntry_3.RESET;
                        VLEntry_3.CHANGECOMPANY(Company.Name);
                        VLEntry_3.SETCURRENTKEY("Vendor No.", "Posting Type");
                        VLEntry_3.SETRANGE("Vendor No.", "No.");
                        VLEntry_3.SETFILTER("Posting Type", '<>%1', VLEntry_3."Posting Type"::Incentive);
                        VLEntry_3.SETRANGE("Posting Date", DMY2DATE(28, 2, 2013), DMY2DATE(28, 2, 2013));
                        IF VLEntry_3.FINDSET THEN BEGIN
                            REPEAT
                                VLEntry_3.CALCFIELDS(VLEntry_3.Amount);
                                v_TotalElGodAmt1 := v_TotalElGodAmt1 + VLEntry_3.Amount;
                            UNTIL VLEntry_3.NEXT = 0;
                            IF v_TotalElGodAmt1 > 0 THEN BEGIN
                                v_TotalElGodAmt1 := v_TotalElGodAmt1 * 89 / 100;
                            END;
                        END;
                        VLEntry_1.RESET;
                        VLEntry_1.CHANGECOMPANY(Company.Name);
                        VLEntry_1.SETCURRENTKEY("Vendor No.", "Posting Type");
                        VLEntry_1.SETRANGE("Vendor No.", "No.");
                        VLEntry_1.SETFILTER("Posting Type", '<>%1', VLEntry_1."Posting Type"::Incentive);
                        VLEntry_1.SETRANGE("Posting Date", DMY2DATE(1, 3, 2013), TODAY);
                        IF VLEntry_1.FINDSET THEN
                            REPEAT
                                VLEntry_1.CALCFIELDS(VLEntry_1.Amount);
                                v_TotalELGODAmt := v_TotalELGODAmt + VLEntry_1.Amount;
                            UNTIL VLEntry_1.NEXT = 0;
                    UNTIL Company.NEXT = 0;

                //////----------131020



            end;

            trigger OnPreDataItem()
            var
                AssadjEntry_1: Record "Associate OD Ajustment Entry";
            begin

                ShowInt := 0;
                IF ShowDetils_1 THEN
                    ShowInt := 1;

                TPSAmt := 0;
                TOpenInvAmt_1 := 0;
                PSAmt := 0;
                OpenInvAmt_1 := 0;
                PTds := 0;
                Pclb := 0;


                CTotalBamt := 0;
                CPSAmt := 0;
                CPclb := 0;
                CPTds := 0;
                CTotalClb := 0;
                CTotalTDS1 := 0;
                CCorrTrvlPmt := 0;
                CITotalPayment := 0;
                CNetPayable := 0;
                CTotalPayment := 0;
                CRemOpOpening := 0;
                CPAmt2 := 0;
                CClubDedect := 0;
                CTDSDedect := 0;
                CTotalBal := 0;
                TotalElGodAmt1 := 0;

                GTotalCost := 0;
                GTotalReceipt := 0;
                GTotalDisc := 0;
                GBSP2 := 0;
                GBSP1 := 0;
                GTrvlAmt := 0;
                GCommAmt := 0;
                GElgiblBSP2 := 0;
                "GSBSP1+GSBSP3" := 0;
                GTTotal := 0;
                TotalELGODAmt := 0;
                AppCutoff := '';


                AssPmtHdr.RESET;
                AssPmtHdr.SETCURRENTKEY("Associate Code", Post);
                IF EDate1 <> 0D THEN
                    AssPmtHdr.SETRANGE("Posting Date", 0D, EDate1);

                AssPmtHdr.SETRANGE(Post, FALSE);
                IF AssPmtHdr.FINDFIRST THEN BEGIN
                    ERROR('Please post the voucher payment first. Voucher made by -' + AssPmtHdr."User ID");
                END;

                AssPmtHdr.RESET;
                AssPmtHdr.SETCURRENTKEY("Associate Code", "Payment Reversed", "Reversal done in LLP Companies");
                IF EDate1 <> 0D THEN
                    AssPmtHdr.SETRANGE("Posting Date", 0D, EDate1);
                AssPmtHdr.SETRANGE("Payment Reversed", TRUE);
                AssPmtHdr.SETRANGE("Reversal done in LLP Companies", FALSE);
                AssPmtHdr.SETFILTER("Amt applicable for Payment", '>%1', 1);
                IF AssPmtHdr.FINDFIRST THEN
                    ERROR('Please make reversal in ' + AssPmtHdr."Company Name" + ' ' + 'for Associate Code' + ' '
                                                     + AssPmtHdr."Associate Code" + 'with Document No.' + AssPmtHdr."Document No.");

                AssPmtHdr.RESET;
                AssPmtHdr.SETCURRENTKEY("Associate Code", "Payment Reversed", "Reversal done in LLP Companies");
                IF EDate1 <> 0D THEN
                    AssPmtHdr.SETRANGE("Posting Date", 0D, EDate1);

                AssPmtHdr.SETRANGE(Post, TRUE);
                AssPmtHdr.SETRANGE("Posted on LLP Company", FALSE);
                AssPmtHdr.SETFILTER("Amt applicable for Payment", '>%1', 1);
                IF AssPmtHdr.FINDFIRST THEN
                    ERROR('Please run the Create/Post Payment Batch in Company-' + AssPmtHdr."Company Name" + ' ' + AssPmtHdr."Document No.");

                CompWise.RESET;
                CompWise.SETRANGE("MSC Company", FALSE);
                IF CompWise.FINDSET THEN
                    REPEAT
                        AssocPmtHdr.RESET;
                        AssocPmtHdr.CHANGECOMPANY(CompWise."Company Code");
                        AssocPmtHdr.SETCURRENTKEY("Paid To", Post);
                        AssocPmtHdr.SETRANGE("Paid To", MMCode);
                        AssocPmtHdr.SETRANGE(Post, FALSE);
                        IF EDate1 <> 0D THEN
                            AssocPmtHdr.SETRANGE("Posting Date", 0D, EDate1);

                        IF AssocPmtHdr.FINDFIRST THEN
                            ERROR('Please run the Create/Post Payment Batch in Company-' + CompWise."Company Code" + ' ' + AssocPmtHdr."Document No.");
                    UNTIL CompWise.NEXT = 0;

                AssadjEntry_1.RESET;
                AssadjEntry_1.SETCURRENTKEY("Document No.", "Associate Code");  //140618
                AssadjEntry_1.SETRANGE("Associate Code", MMCode);
                AssadjEntry_1.SETRANGE("Sinking Process Done", FALSE);
                IF AssadjEntry_1.FINDSET THEN
                    REPEAT
                        IF NOT AssadjEntry_1."Posted in From Company Name" THEN
                            ERROR('Run Associate OD Adjustment batch in' + FORMAT(AssadjEntry_1."From Company Name"));
                        IF NOT AssadjEntry_1."Posted in To Company Name" THEN
                            ERROR('Run Associate OD Adjustment batch in' + FORMAT(AssadjEntry_1."To Company Name"));
                    UNTIL AssadjEntry_1.NEXT = 0;
            end;
        }
        dataitem(ODEleg; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            dataitem(ODCompanyWise; "Company wise G/L Account")
            {
                DataItemTableView = SORTING("Company Code")
                                    WHERE("Active for Reports" = FILTER(true));

                trigger OnAfterGetRecord()
                begin
                    TotalELGODAmt := 0;
                    v_TotalELGODAmt := 0;
                    v_TotalElGodAmt1 := 0;
                    CheckRecord := FALSE;


                    CheckVLEntry.RESET;
                    CheckVLEntry.CHANGECOMPANY("Company Code");
                    CheckVLEntry.SETCURRENTKEY("Vendor No.");
                    CheckVLEntry.SETRANGE("Vendor No.", AssCode1);
                    IF CheckVLEntry.FINDFIRST THEN
                        CheckRecord := TRUE;

                    IF NOT CheckRecord THEN BEGIN

                        CheckCommEntry.RESET;
                        CheckCommEntry.CHANGECOMPANY("Company Code");
                        CheckCommEntry.SETCURRENTKEY("Associate Code");
                        CheckCommEntry.SETRANGE("Associate Code", AssCode1);
                        IF CheckCommEntry.FINDFIRST THEN
                            CheckRecord := TRUE;

                    END;
                    IF NOT CheckRecord THEN BEGIN
                        CheckTravelEntry.RESET;
                        CheckTravelEntry.CHANGECOMPANY("Company Code");
                        CheckTravelEntry.SETCURRENTKEY("Sub Associate Code");
                        CheckTravelEntry.SETRANGE("Sub Associate Code", AssCode1);
                        IF CheckTravelEntry.FINDFIRST THEN
                            CheckRecord := TRUE;
                    END;

                    IF NOT CheckRecord THEN
                        CurrReport.SKIP;


                    v_TotalElGodAmt1 := 0;
                    v_TotalELGODAmt := 0;
                    V_VLEntry_2.RESET;
                    V_VLEntry_2.CHANGECOMPANY("Company Code");
                    V_VLEntry_2.SETCURRENTKEY("Vendor No.", "Posting Type");
                    V_VLEntry_2.SETRANGE("Vendor No.", AssCode1);
                    V_VLEntry_2.SETFILTER("Posting Type", '<>%1', V_VLEntry_2."Posting Type"::Incentive);
                    V_VLEntry_2.SETRANGE("Posting Date", DMY2DATE(28, 2, 2013), DMY2DATE(28, 2, 2013));
                    IF V_VLEntry_2.FINDSET THEN BEGIN
                        REPEAT
                            V_VLEntry_2.CALCFIELDS(V_VLEntry_2.Amount);
                            v_TotalElGodAmt1 := v_TotalElGodAmt1 + V_VLEntry_2.Amount;
                        UNTIL V_VLEntry_2.NEXT = 0;
                        IF v_TotalElGodAmt1 > 0 THEN BEGIN
                            v_TotalElGodAmt1 := v_TotalElGodAmt1 * 89 / 100;
                        END;
                    END;
                    V_VLEntry_2.SETRANGE("Posting Date", DMY2DATE(1, 3, 2013), TODAY); //DMY2DATE(8,6,2016));
                    IF V_VLEntry_2.FINDSET THEN
                        REPEAT
                            V_VLEntry_2.CALCFIELDS(V_VLEntry_2.Amount);
                            v_TotalELGODAmt := v_TotalELGODAmt + V_VLEntry_2.Amount;
                        UNTIL V_VLEntry_2.NEXT = 0;
                    TotalBalAssociate := TotalBalAssociate + v_TotalELGODAmt + v_TotalElGodAmt1;
                end;

                trigger OnPostDataItem()
                begin
                    ShowRecords := TRUE;
                    IF ODFilter THEN BEGIN
                        IF TotalBalAssociate <= 0 THEN
                            ShowRecords := FALSE;
                    END;
                    IF ShowRecords THEN BEGIN
                        GTotalBalAssociate := GTotalBalAssociate + TotalBalAssociate;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    TotalBalAssociate := 0;
                    v_TotalELGODAmt := 0;
                    //BalanceAmount :=0;
                    v_TotalElGodAmt1 := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF Number = 1 THEN BEGIN
                    Chain.FIND('-');
                END ELSE
                    Chain.NEXT;
                TotalBalAssociate := 0;

                IF AssCode1 <> Chain."No." THEN BEGIN
                    AssCode1 := Chain."No.";
                    RecVendor1.RESET;
                    IF RecVendor1.GET(AssCode1) THEN BEGIN
                    END;
                END ELSE
                    CurrReport.SKIP;


                ParentVend.RESET;
                ParentVend.SETCURRENTKEY("No.");
                ParentVend.SETRANGE("No.", Chain."No.");
                IF ParentVend.FINDFIRST THEN BEGIN
                    IF RecVend1.GET(ParentVend."Parent Code") THEN;
                END;
            end;

            trigger OnPreDataItem()
            var
                Vendor_2: Record Vendor;
                LRegionwisevendor: Record "Region wise Vendor";
            begin
                ODFilter := TRUE;
                RankCode.RESET;

                Vendor_2.RESET;
                IF Vendor_2.GET(MMCode) THEN
                    IF Vendor_2."BBG Vendor Category" = Vendor_2."BBG Vendor Category"::"CP(Channel Partner)" THEN
                        RankCode.SETRANGE(Code, Vendor_2."Sub Vendor Category") //02062025 Code Added
                    ELSE
                        RankCode.SetRange("Use for CP only", False);  //17062025
                //RankCode.SETRANGE(Code, 'R0003')  //02062025 Code commented
                // ELSE   //02062025 Code commented
                //RankCode.SETFILTER(Code, '<>%1', 'R0003');  //02062025 Code commented
                IF RankCode.FINDSET THEN
                    REPEAT
                        LRegionwisevendor.RESET;   //Code Added 01072025
                        LRegionwisevendor.SetRange("Region Code", RankCode.Code);  //Code Added 01072025
                        LRegionwisevendor.SetRange("No.", MMCode);   //Code Added 01072025
                        IF LRegionwisevendor.FindFIRST() THEN begin    //Code Added 01072025
                            ChainMgt.NewInitChain;
                            ChainMgt.NewBuildChainTopToBottom(MMCode, WEFDate, TRUE, RankCode.Code);
                            ChainMgt.NewReturnChain(Chain);

                            Cnt += 1;
                            Chain.SETRANGE("Region Code", RankCode.Code);
                            Chain.SETRANGE("No.", MMCode);
                            IF Chain.FINDFIRST THEN;
                            Chain.Priority := Cnt;
                            Chain.MODIFY;
                            Chain2 := Chain;
                            Chain2.INSERT;
                            BuildHierarchy(RankCode.Code, MMCode);
                        END;  //Code Added 01072025
                    UNTIL RankCode.NEXT = 0;

                Chain.RESET;
                Chain.SETCURRENTKEY("No.");
                SETRANGE(Number, 1, Chain.COUNT);
                AssCode1 := '';
                TotalBalAssociate := 0;
                GTotalBalAssociate := 0;
            end;
        }
        dataitem("<Integer>";
        Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(GTotalBalAssociate;
            GTotalBalAssociate)
            {
            }
            column(BSP1Total_; FORMAT(GBSP1))
            {
            }
            column(TotalEligOD_; FORMAT(TotalAmt_Invoice + TOpenInvAmt_1 + TotalAmt_Invoice_1 - TDS_Pmt - Club_Pmt + (Amt_Pmt + TDS_Pmt + Club_Pmt + TPSAmt)))
            {
            }
            column(Invadj_; FORMAT(TotalAmt_Invoice + TOpenInvAmt_1))
            {
            }
            column(TDS_Invoice_; FORMAT(TDS_Invoice))
            {
            }
            column(Club_Invoice_; FORMAT(Club_Invoice))
            {
            }
            column(TotalAmt_Invoice_1_; FORMAT(TotalAmt_Invoice_1))
            {
            }
            column(TDS_Invoice_1_; FORMAT(TDS_Invoice_1))
            {
            }
            column(Club_Invoice_1_; FORMAT(Club_Invoice_1))
            {
            }
            column(TDS_Pmt_; FORMAT(TDS_Pmt))
            {
            }
            column(Club_Pmt_; FORMAT(Club_Pmt))
            {
            }
            column(PaymentNet_; FORMAT(Amt_Pmt + TDS_Pmt + Club_Pmt + TPSAmt))
            {
            }
            column(EligibilityGross_; FORMAT(TotalAmt_Invoice + TOpenInvAmt_1 + TotalAmt_Invoice_1 + TDS_Invoice + TDS_Invoice_1 + Club_Invoice + Club_Invoice_1))
            {
            }
            column(TDSAmount_; FORMAT(ABS(TDS_Invoice + TDS_Invoice_1 + TDS_Pmt)))
            {
            }
            column(ClibAmount_; FORMAT(ABS(Club_Invoice + Club_Invoice_1 + Club_Pmt)))
            {
            }
            column(NetPayment_; FORMAT(Amt_Pmt + TDS_Pmt + Club_Pmt + TPSAmt))
            {
            }
            column(NetElig_; FORMAT(TotalAmt_Invoice + TOpenInvAmt_1 + TotalAmt_Invoice_1 - TDS_Pmt - Club_Pmt + (Amt_Pmt + TDS_Pmt + Club_Pmt + TPSAmt)))
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        //ReportDetailsUpdate.UpdateReportDetails(EntryNo);
    end;

    trigger OnPreReport()
    begin
        // ReportRequestwebSendMail.RESET;
        // ReportRequestwebSendMail.SetRange("Report Id", 50011);
        // ReportRequestwebSendMail.SetRange("Report Generated", False);
        // ReportRequestwebSendMail.SetFilter("Associate Code", '<>%1', '');
        // IF ReportRequestwebSendMail.FindFirst THEN
        //     MMCode := ReportRequestwebSendMail."Associate Code";
        MMCode := VendFilters;
        ShowDetils_1 := TRUE;
        EDate1 := TODAY;
        WEFDate := TODAY;

        SDate := 20010101D;//010101D
        EDate := TODAY;
        CompInfo.GET;
        IF Vend1.GET(MMCode) THEN;
    end;

    var
        CompInfo: Record "Company Information";
        Filters: Text[30];
        MMCode: Code[20];
        WEFDate: Date;
        ChainMgt: Codeunit "Unit Post";
        Chain: Record "Region wise Vendor" temporary;
        Chain2: Record "Region wise Vendor" temporary;
        Vendor: Record Vendor;
        Cnt: Integer;
        GetDesc: Codeunit GetDescription;
        Amt: Decimal;
        CommEntry: Record "Commission Entry";
        "No.": Code[10];
        Vndr: Record Vendor;
        OD: Boolean;
        NAmt: Decimal;
        SDate: Date;
        EDate: Date;
        FilterUsed: Text[250];
        VHdr: Record "Assoc Pmt Voucher Header";
        VLine: Record "Voucher Line";
        Pclb: Decimal;
        PTds: Decimal;
        PAmt: Decimal;
        Paid: Decimal;
        TNAmt: Decimal;
        Amt12: Decimal;
        Amt13: Decimal;
        TNAmt12: Decimal;
        TNAmt13: Decimal;
        TotalAmt1: Decimal;
        TotalAmt2: Decimal;
        Conforder: Record "New Confirmed Order";
        VLEntry: Record "Vendor Ledger Entry";
        TotalPaid: Decimal;
        TDSAmt: Decimal;
        TotalTDS: Decimal;
        TotalClub: Decimal;
        RecVendor: Record Vendor;
        BalAmt: Decimal;
        Cust: Record Customer;
        DebAppPayEntry: Record "Debit App. Payment Entry";
        DiscAmt: Decimal;
        Balance: Decimal;
        UnitPayEntry: Record "Unit Payment Entry";
        BSP1: Decimal;
        BSP2: Decimal;
        BSP3: Decimal;
        TrvlPmtDetail: Record "Travel Payment Details";
        TrvlPmt: Record "Travel Payment Entry";
        TrvlAmt: Decimal;
        CommAmt: Decimal;
        ElgiblBSP2: Decimal;
        Total: Decimal;
        PAN: Text[30];
        CName: Text[50];
        TCommAmt: Decimal;
        AdvVendor: Record Vendor;
        AdvAmt: Decimal;
        AdvTDS: Decimal;
        TDS: Decimal;
        PostPayment: Codeunit PostPayment;
        UnitSetup: Record "Unit Setup";
        TATDS: Decimal;
        AdvClub: Decimal;
        VoucherHdr: Record "Assoc Pmt Voucher Header";
        VoucherLine: Record "Voucher Line";
        PaidComm: Decimal;
        PaidTA: Decimal;
        PaidTDS: Decimal;
        PaidClub: Decimal;
        GrossAmount: Decimal;
        TotalTAAmt: Decimal;
        TotalDedect: Decimal;
        TotalTDSdedect: Decimal;
        TotalClubdedect: Decimal;
        GTotal: Decimal;
        OpAmt: Decimal;
        RemAmt: Decimal;
        TotalRemAmt: Decimal;
        AdvAmt1: Decimal;
        TotalEligibility: Decimal;
        OpenAdvAmt: Decimal;
        ASSCode: Code[20];
        Vend: Record Vendor;
        TrvlAmt1: Decimal;
        TotalTAAmt1: Decimal;
        MMName: Text[150];
        SDate1: Date;
        EDate1: Date;
        RCntr: Record "Responsibility Center 1";
        TrvlPmt2: Record "Travel Payment Entry";
        InvAmount: Decimal;
        TotalInvAmount: Decimal;
        CorrTrvlPmt: Decimal;
        InvAmount1: Decimal;
        TotalInvAmount1: Decimal;
        //TDSE: Record 13729;
        TTdsAmt: Decimal;
        GLE: Record "G/L Entry";
        GLE1: Record "G/L Entry";
        Clb9: Decimal;
        Tclb9: Decimal;
        BAmt: Decimal;
        BLE: Record "Bank Account Ledger Entry";
        CLE: Record "Cust. Ledger Entry";
        TBAmt: Decimal;
        "G/LE": Record "G/L Entry";
        VLE: Record "Vendor Ledger Entry";
        NOpAmt: Decimal;
        PSAmt1: Decimal;
        PSAmt: Decimal;
        NetPayable: Decimal;
        TotalBal: Decimal;
        RemOpOpening: Decimal;
        TDSDedect: Decimal;
        ClubDedect: Decimal;
        TrvlPmt1: Decimal;
        Show: Boolean;
        Clb91: Decimal;
        TClb91: Decimal;
        TTDSO: Decimal;
        TOPAmt: Decimal;
        TClbO: Decimal;
        GLE2: Record "G/L Entry";
        TDSO: Decimal;
        //TDSE2: Record 13729;
        ClbO: Decimal;
        GLE3: Record "G/L Entry";
        TotalPayment: Decimal;
        ITDSAmt: Decimal;
        IClb91: Decimal;
        ITTdsAmt: Decimal;
        ITClb91: Decimal;
        IBAmt: Decimal;
        IClb9: Decimal;
        ITclb9: Decimal;
        ITotalPayment: Decimal;
        TotalBamt: Decimal;
        TotalClb: Decimal;
        TotalTDS1: Decimal;
        Vend1: Record Vendor;
        ChLE: Record "Check Ledger Entry";
        DirectPaidComm: Decimal;
        PAmt2: Decimal;
        PSAmt2: Decimal;
        ConfirmedOrdr: Record "New Confirmed Order";
        RecAppCode: Code[20];
        CompanyWise: Record "Company wise G/L Account";
        "------------For all company---": Integer;
        CTotalBamt: Decimal;
        CPSAmt: Decimal;
        CPclb: Decimal;
        CPTds: Decimal;
        CTotalClb: Decimal;
        CTotalTDS1: Decimal;
        CCorrTrvlPmt: Decimal;
        CITotalPayment: Decimal;
        CNetPayable: Decimal;
        CTotalPayment: Decimal;
        CRemOpOpening: Decimal;
        CPAmt2: Decimal;
        CClubDedect: Decimal;
        CTDSDedect: Decimal;
        CTotalBal: Decimal;
        CompWise: Record "Company wise G/L Account";
        CTotalInvAmount: Decimal;
        CDirectPaidComm: Decimal;
        CPaidComm: Decimal;
        CPaidTA: Decimal;
        CTotalInvAmount1: Decimal;
        CPSAmt1: Decimal;
        CTrvlPmt1: Decimal;
        CompTotal: Decimal;
        CompTrvlAmt: Decimal;
        AssPmtHdr: Record "Associate Payment Hdr";
        AssocPmtHdr: Record "Assoc Pmt Voucher Header";
        RecUnitSetup: Record "Unit Setup";
        RecUserSetup: Record "User Setup";
        ShowData: Boolean;
        BodyExists: Boolean;
        CheckConfOrder: Record "New Confirmed Order";
        ShowHeader: Boolean;
        CheckNewAssoHier: Record "Associate Hierarcy with App.";
        STotalCost: Decimal;
        STotalReceipt: Decimal;
        STotalDisc: Decimal;
        "SBSP1+SBSP3": Decimal;
        SBSP2: Decimal;
        SBSP1: Decimal;
        STrvlAmt: Decimal;
        SCommAmt: Decimal;
        SElgiblBSP2: Decimal;
        STotal: Decimal;
        GTotalCost: Decimal;
        GTotalReceipt: Decimal;
        GTotalDisc: Decimal;
        "GSBSP1+GSBSP3": Decimal;
        GBSP2: Decimal;
        GBSP1: Decimal;
        GTrvlAmt: Decimal;
        GCommAmt: Decimal;
        GElgiblBSP2: Decimal;
        GTTotal: Decimal;
        AppCutoff: Text[30];
        CheckCompWiseGL: Record "Company wise G/L Account";
        Conforder_1: Record "Confirmed Order";
        TotalELGODAmt: Decimal;
        RecVend_1: Record Vendor;
        VLEntry_2: Record "Vendor Ledger Entry";
        TotalElGodAmt1: Decimal;
        ShowDetils_1: Boolean;
        GLE_OpenTDS: Record "G/L Entry";
        GLE_OpenClub: Record "G/L Entry";
        GLE_CurrTDS: Record "G/L Entry";
        GLE_CurrClub: Record "G/L Entry";
        Memberof: Record "Access Control";
        Doc_Inv: Code[20];
        VLE_Invoice: Record "Vendor Ledger Entry";
        PostTypeFilter: Option " ",Incentive,CommissionTA;
        Doc_Pmt: Code[20];
        VLE_Payment_2: Record "Vendor Ledger Entry";
        Amt_Pmt: Decimal;
        GLE_Payment: Record "G/L Entry";
        GLE_Payment1: Record "G/L Entry";
        Unitstup: Record "Unit Setup";
        Club_Pmt: Decimal;
        TDS_Pmt: Decimal;
        GLE_Invoice: Record "G/L Entry";
        GLE_Invoice1: Record "G/L Entry";
        Club_Invoice: Decimal;
        TDS_Invoice: Decimal;
        TotalAmt_Invoice: Decimal;
        Club_Invoice_1: Decimal;
        TDS_Invoice_1: Decimal;
        TotalAmt_Invoice_1: Decimal;
        OpenInvAmt_1: Decimal;
        TPSAmt: Decimal;
        TOpenInvAmt_1: Decimal;
        Text000: Label 'Invalid Parameters.';
        DimensionValue: Record "Dimension Value";
        GeneralSEtup: Record "General Ledger Setup";
        ProjectName: Text;
        ShowInt: Integer;
        UserSetup: Record "User Setup";
        RunAsExcel: Boolean;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        Company: Record Company;
        VLEntry_1: Record "Vendor Ledger Entry";
        VLEntry_3: Record "Vendor Ledger Entry";
        v_TotalElGodAmt1: Decimal;
        v_TotalELGODAmt: Decimal;
        V_AssociateHierarcywithApp: Record "Associate Hierarcy with App.";
        RankCode: Record "Rank Code Master";
        v_RegionwiseVendor_1: Record "Region wise Vendor" temporary;
        v_RegionwiseVendor_12: Record "Region wise Vendor" temporary;
        AssCode1: Code[20];
        RecVendor1: Record Vendor;
        TotalBalAssociate: Decimal;
        ParentVend: Record "Region wise Vendor";
        RecVend1: Record Vendor;
        CheckRecord: Boolean;
        CheckVLEntry: Record "Vendor Ledger Entry";
        CheckCommEntry: Record "Commission Entry";
        CheckTravelEntry: Record "Travel Payment Entry";
        V_VLEntry_2: Record "Vendor Ledger Entry";
        ODFilter: Boolean;
        ShowRecords: Boolean;
        GTotalBalAssociate: Decimal;
        //ReportDetailsUpdate: Codeunit 50018;
        ReportFilters: Text;
        EntryNo: Integer;
        VendFilters: Code[20];
        BatchNos: Code[20];
        ReportRequestwebSendMail: Record "Report Request from Web/Mb.";

    procedure BuildHierarchy(MCode: Code[20]; RegionCode: Code[20])
    var
        v_RegionwiseVendor_2: Record "Region wise Vendor";
        Level: Integer;
    begin
        v_RegionwiseVendor_2.RESET;
        v_RegionwiseVendor_2.SETCURRENTKEY("Region Code", "Parent Code");
        v_RegionwiseVendor_2.SETRANGE("Region Code", RegionCode);
        v_RegionwiseVendor_2.SETRANGE("Parent Code", MCode);
        IF v_RegionwiseVendor_2.FINDSET THEN
            REPEAT
                IF Chain.GET(RegionCode, v_RegionwiseVendor_2."No.") THEN BEGIN
                    Cnt += 1;

                    Chain2.RESET;
                    Chain2.SETCURRENTKEY("Region Code", "Parent Code");
                    Chain2.SETRANGE("Region Code", RegionCode);
                    Chain2.SETRANGE("Parent Code", MCode);
                    Level := Chain2.COUNT + 1;

                    Chain2.GET(RegionCode, MCode);
                    Chain.Priority := Cnt;
                    Chain."E-Mail" := Chain2."E-Mail" + '.' + FORMAT(Level);
                    Chain.MODIFY;

                    Chain2 := Chain;
                    Chain2.INSERT;

                    BuildHierarchy(RegionCode, v_RegionwiseVendor_2."No.");
                END;
            UNTIL v_RegionwiseVendor_2.NEXT = 0;
    end;

    procedure Setfilters(VendFilter: Code[20]; BatchNo: Code[20])
    begin
        VendFilters := VendFilter;
        BatchNos := BatchNo;
    end;
}

