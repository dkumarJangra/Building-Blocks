report 97771 "New CommissionEligibility50082"
{
    // version Job queue

    // DefaultLayout = RDLC;
    // RDLCLayout = './New CommissionEligibility50082.rdl';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Company wise G/L Account"; "Company wise G/L Account")
        {
            DataItemTableView = SORTING("Company Code")
                                WHERE("Active for Reports" = FILTER(true));
            dataitem("Associate Hierarcy with App."; "Associate Hierarcy with App.")
            {
                DataItemLink = "Company Name" = FIELD("Company Code");
                DataItemTableView = SORTING("Project Code", "Associate Code", "Introducer Code")
                                    WHERE(Status = FILTER(Active));
                dataitem("New Confirmed Order"; "New Confirmed Order")
                {
                    DataItemLink = "No." = FIELD("Application Code");
                    DataItemTableView = SORTING("Introducer Code", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin


                        IF Cust.GET("Customer No.") THEN
                            CName := Cust.Name;

                        RemAmt := 0;

                        CLEAR(DiscAmt);
                        CLEAR(Balance);
                        DebAppPayEntry.RESET;
                        DebAppPayEntry.CHANGECOMPANY("New Confirmed Order"."Company Name");
                        DebAppPayEntry.SETCURRENTKEY("Document No.", "Posting date", Posted, "Introducer Code");
                        DebAppPayEntry.SETRANGE("Document No.", "No.");
                        DebAppPayEntry.SETRANGE("Posting date", 0D, EDate1);
                        DebAppPayEntry.SETRANGE(Posted, TRUE);
                        DebAppPayEntry.SETRANGE("Introducer Code", "Introducer Code");
                        DebAppPayEntry.CALCSUMS(DebAppPayEntry."Net Payable Amt");
                        DiscAmt := DebAppPayEntry."Net Payable Amt";


                        Balance := Amount - "Total Received Amount" - DiscAmt;

                        CLEAR(BSP1);
                        CLEAR(BSP2);
                        CLEAR(BSP3);
                        UnitPayEntry.RESET;
                        UnitPayEntry.CHANGECOMPANY("New Confirmed Order"."Company Name");
                        UnitPayEntry.SETCURRENTKEY("Document No.", "Posting date", "Cheque Status", "Charge Code");
                        UnitPayEntry.SETRANGE("Document No.", "No.");
                        UnitPayEntry.SETRANGE("Posting date", 0D, EDate1);
                        UnitPayEntry.SETRANGE(UnitPayEntry."Cheque Status", UnitPayEntry."Cheque Status"::Cleared);
                        UnitPayEntry.SETFILTER("Charge Code", '%1', 'BSP1');
                        UnitPayEntry.CALCSUMS(Amount);
                        BSP1 += ROUND(UnitPayEntry.Amount, 1);

                        UnitPayEntry.SETFILTER("Charge Code", '%1', 'PPLAN');
                        UnitPayEntry.CALCSUMS(Amount);
                        BSP1 += ROUND(UnitPayEntry.Amount, 1);

                        UnitPayEntry.SETFILTER("Charge Code", '%1', 'BSP2');
                        UnitPayEntry.CALCSUMS(Amount);
                        BSP2 += UnitPayEntry.Amount;

                        UnitPayEntry.SETFILTER("Charge Code", '%1', 'BSP3');
                        UnitPayEntry.CALCSUMS(Amount);
                        BSP3 += UnitPayEntry.Amount;

                        CLEAR(TrvlAmt);
                        CLEAR(TrvlAmt);
                        TrvlPmtDetail.RESET;
                        TrvlPmtDetail.CHANGECOMPANY("New Confirmed Order"."Company Name");
                        TrvlPmtDetail.SETRANGE("Application No.", "No.");
                        TrvlPmtDetail.SETRANGE(Reverse, FALSE);  //BBG1.00 120813
                        IF TrvlPmtDetail.FINDFIRST THEN BEGIN
                            TrvlPmt.RESET;
                            TrvlPmt.CHANGECOMPANY("New Confirmed Order"."Company Name");
                            TrvlPmt.SETRANGE("Document No.", TrvlPmtDetail."Document No.");
                            TrvlPmt.SETRANGE("Sub Associate Code", MMCode);
                            TrvlPmt.SETRANGE("Creation Date", 0D, EDate1);
                            TrvlPmt.SETRANGE(Approved, TRUE);
                            TrvlPmt.SETRANGE(Reverse, FALSE);
                            TrvlPmt.SETRANGE(CreditMemo, FALSE);
                            TrvlPmt.SETRANGE("Not consider in CommReport", FALSE);
                            IF TrvlPmt.FINDSET THEN
                                TrvlAmt := TrvlPmt."TA Rate" * TrvlPmtDetail."Saleable Area";
                        END;




                        TotalTAAmt := TotalTAAmt + TrvlAmt;

                        CLEAR(CommAmt);
                        CLEAR(ElgiblBSP2);
                        CLEAR(CommEntry);
                        CommEntry.RESET;
                        CommEntry.CHANGECOMPANY("New Confirmed Order"."Company Name");
                        CommEntry.SETCURRENTKEY("Associate Code", "Application No.", "Posting Date", Discount, "Opening Entries", "Direct to Associate",
                                                "Remaining Amt of Direct", "Registration Bonus Hold(BSP2)");

                        CommEntry.SETRANGE("Associate Code", MMCode);
                        CommEntry.SETRANGE("Application No.", "Application No.");
                        CommEntry.SETRANGE("Posting Date", 0D, EDate1);
                        CommEntry.SETRANGE(Discount, FALSE);
                        CommEntry.SETRANGE("Opening Entries", FALSE);
                        CommEntry.SETRANGE("Direct to Associate", FALSE);
                        CommEntry.SETRANGE("Remaining Amt of Direct", FALSE);
                        CommEntry.SETRANGE("Registration Bonus Hold(BSP2)", FALSE);
                        CommEntry.CALCSUMS("Commission Amount");
                        TCommAmt := TCommAmt + CommEntry."Commission Amount";
                        CommAmt := CommAmt + CommEntry."Commission Amount";

                        CLEAR(ElgiblBSP2);
                        CommEntry.SETRANGE("Direct to Associate", TRUE);
                        CommEntry.SETRANGE("Remaining Amt of Direct", FALSE);
                        CommEntry.SETRANGE("Registration Bonus Hold(BSP2)", FALSE);
                        CommEntry.CALCSUMS("Commission Amount");
                        ElgiblBSP2 := ElgiblBSP2 + CommEntry."Commission Amount";
                        CommAmt := CommAmt + CommEntry."Commission Amount";
                        TCommAmt := TCommAmt + CommEntry."Commission Amount";





                        TotalRemAmt := TotalRemAmt + RemAmt;
                        Total := CommAmt + TrvlAmt;
                        CompTotal := CompTotal + CommAmt + TrvlAmt;
                        CompTrvlAmt := CompTrvlAmt + TrvlAmt;



                        IF Vend.GET("Introducer Code") THEN;


                        IF ExportToExcel THEN BEGIN

                            TempExcelBuffer.NewRow();
                            TempExcelBuffer.AddColumn("New Confirmed Order"."Introducer Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(Vend.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Application No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Customer No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(CName, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Unit Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Saleable Area", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(Amount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Total Received Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(DiscAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(Balance, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(BSP1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(BSP1 + BSP3, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(BSP2, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(CommAmt - ElgiblBSP2, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(ElgiblBSP2, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(TrvlAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(Total, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);


                        END;
                        //END;
                    end;

                    trigger OnPreDataItem()
                    begin

                        SETRANGE("Posting Date", 0D, EDate1);
                        CurrReport.CREATETOTALS("New Confirmed Order".Amount, "New Confirmed Order"."Total Received Amount", DiscAmt, Balance, BSP1, BSP2, BSP3)
                        ;
                        CurrReport.CREATETOTALS(CommAmt, TrvlAmt, ElgiblBSP2, Total);

                        TCommAmt := 0;
                        TotalTAAmt := 0;
                        TrvlAmt1 := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin

                    //ALLECK 270513 START
                    IF Vend.GET(MMCode) THEN
                        MMName := Vend.Name;
                    IF RCntr.GET("Project Code") THEN;
                end;

                trigger OnPostDataItem()
                begin

                    TotalAmt_1 := TotalAmt_1 + "New Confirmed Order".Amount;
                    TotalRec_1 := TotalRec_1 + "New Confirmed Order"."Total Received Amount";
                    DiscAmt_1 := DiscAmt_1 + DiscAmt;
                    Balanace_1 := Balanace_1 + Balance;
                    TotalBSP1_1 := TotalBSP1_1 + BSP1;
                    TotalBSP3_1 := TotalBSP3_1 + BSP3;
                    TotalBSP2_1 := TotalBSP2_1 + BSP2;
                    TotalTrvlAmt_1 := TotalTrvlAmt_1 + TrvlAmt;
                    TotalCommAmt_1 := TotalCommAmt_1 + CommAmt;
                    TotalElgiblBSP2_1 := TotalElgiblBSP2_1 + ElgiblBSP2;
                    Total_1 := Total_1 + Total;
                end;

                trigger OnPreDataItem()
                begin

                    SETRANGE("Posting Date", 0D, EDate1);



                    SETRANGE("Associate Code", MMCode);
                    ASSCode := '';

                    CurrReport.CREATETOTALS("New Confirmed Order".Amount, "New Confirmed Order"."Total Received Amount", DiscAmt, Balance, BSP1, BSP2, BSP3)
                    ;
                    CurrReport.CREATETOTALS(CommAmt, TrvlAmt, ElgiblBSP2, Total);
                    TotalTAAmt1 := 0;
                    RecAppCode := '';
                end;
            }

            trigger OnAfterGetRecord()
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
                    NewDateforInventive := DMY2DATE(1, 4, 2023);

                    DVLEntry.RESET;
                    DVLEntry.CHANGECOMPANY("Company Code");
                    DVLEntry.SETCURRENTKEY("Vendor No.", "Posting Type", "Posting Date");
                    DVLEntry.SETRANGE("Vendor No.", MMCode);
                    //DVLEntry.SETFILTER("Posting Type",'<>%1',DVLEntry."Posting Type"::Incentive);
                    DVLEntry.SETRANGE("Posting Date", DMY2DATE(1, 3, 2013), EDate1);
                    DVLEntry.CALCSUMS(Amount);
                    IF DVLEntry."Posting Type" = DVLEntry."Posting Type"::Incentive THEN BEGIN
                        IF DVLEntry."Posting Date" >= NewDateforInventive THEN
                            TotalELGODAmt := TotalELGODAmt + DVLEntry.Amount;
                    END ELSE
                        TotalELGODAmt := TotalELGODAmt + DVLEntry.Amount;

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
                                    VLE_Payment_2.SETRANGE("Document Type", VLE_Invoice."Document Type");
                                    VLE_Payment_2.SETRANGE("Vendor No.", VLE_Invoice."Vendor No.");
                                    IF VLE_Payment_2.FINDSET THEN
                                        REPEAT
                                            VLE_Payment_2.CALCFIELDS(Amount);
                                            Amt_Pmt := Amt_Pmt + VLE_Payment_2.Amount;
                                        UNTIL VLE_Payment_2.NEXT = 0;

                                    GLE_Payment.RESET;
                                    GLE_Payment.CHANGECOMPANY("Company Code");
                                    GLE_Payment.SETCURRENTKEY("Document Type", "Document No.", "G/L Account No.", "Transaction No.");
                                    GLE_Payment.SETRANGE("Document Type", GLE_Payment."Document Type"::Payment);
                                    GLE_Payment.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                    GLE_Payment.SETRANGE("G/L Account No.", Unitstup."Corpus A/C");
                                    GLE_Payment.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                    GLE_Payment.CALCSUMS(GLE_Payment.Amount);
                                    Club_Pmt := Club_Pmt + GLE_Payment.Amount;

                                    GLE_Payment.SETRANGE("G/L Account No.", '116400', '117100');
                                    GLE_Payment.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                    GLE_Payment.CALCSUMS(GLE_Payment.Amount);
                                    TDS_Pmt := TDS_Pmt + GLE_Payment.Amount;
                                END;
                            END ELSE BEGIN

                                VLE_Invoice.CALCFIELDS(Amount);
                                IF VLE_Invoice."Posting Date" <= DMY2DATE(31, 8, 2016) THEN BEGIN
                                    IF Doc_Inv <> VLE_Invoice."Document No." THEN BEGIN
                                        GLE_Invoice.RESET;
                                        GLE_Invoice.CHANGECOMPANY("Company Code");
                                        GLE_Invoice.SETCURRENTKEY("Document Type", "Document No.", "G/L Account No.", "Transaction No.");
                                        GLE_Invoice.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                        GLE_Invoice.SETRANGE("G/L Account No.", Unitstup."Corpus A/C");
                                        GLE_Invoice.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                        GLE_Invoice.CALCSUMS(Amount);
                                        Club_Invoice := Club_Invoice + GLE_Invoice.Amount;

                                        GLE_Invoice1.SETRANGE("G/L Account No.", '116400', '117100');
                                        GLE_Invoice1.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                        GLE_Invoice.CALCSUMS(Amount);
                                        TDS_Invoice := TDS_Invoice + GLE_Invoice.Amount;
                                    END;

                                    TotalAmt_Invoice := TotalAmt_Invoice + VLE_Invoice.Amount;
                                END ELSE BEGIN
                                    IF Doc_Inv <> VLE_Invoice."Document No." THEN BEGIN
                                        GLE_Invoice.RESET;
                                        GLE_Invoice.CHANGECOMPANY("Company Code");
                                        GLE_Invoice.SETCURRENTKEY("Document Type", "Document No.", "G/L Account No.", "Transaction No.");
                                        GLE_Invoice.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                        GLE_Invoice.SETRANGE("G/L Account No.", Unitstup."Corpus A/C");
                                        GLE_Invoice.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                        GLE_Invoice.CALCSUMS(Amount);
                                        Club_Invoice_1 := Club_Invoice_1 + GLE_Invoice.Amount;

                                        GLE_Invoice.SETRANGE("G/L Account No.", '116400', '117100');
                                        GLE_Invoice.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                        GLE_Invoice.CALCSUMS(Amount);
                                        TDS_Invoice_1 := TDS_Invoice_1 + GLE_Invoice.Amount;
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

                IF ExportToExcel THEN BEGIN

                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('Total', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalAmt_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalRec_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(DiscAmt_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Balanace_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalBSP1_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalBSP1_1 + TotalBSP3_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalBSP2_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalCommAmt_1 - TotalElgiblBSP2_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalElgiblBSP2_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalTrvlAmt_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Total_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                END;


                IF ExportToExcel THEN BEGIN
                    //ALLECK 200513
                    // XlRange := XlWrkSht.Range('R' + FORMAT(J));
                    // XlRange.Value := 'Total Elg./ OD';
                    /*
                   XLRange := XlWrkSht.Range('A' + FORMAT(J));
                   XLRange.Value := 'Total Deductions Break-Up';

                   XLRange := XlWrkSht.Range('F' + FORMAT(J));
                   XLRange.Value := 'Other Deductions';

                   J+=1;

                   XLRange := XlWrkSht.Range('B' + FORMAT(J));
                   XLRange.Value := '(Comm+RB)';

                   XLRange := XlWrkSht.Range('C' + FORMAT(J));
                   XLRange.Value := 'Club 9';

                   XLRange := XlWrkSht.Range('D' + FORMAT(J));
                   XLRange.Value := 'TDS';

                   XLRange := XlWrkSht.Range('E' + FORMAT(J));
                   XLRange.Value := 'TA Reversal';


                   XLRange := XlWrkSht.Range('G' + FORMAT(J));
                   XLRange.Value := 'Incentive';

                   J+=1;

                   XLRange := XlWrkSht.Range('B' + FORMAT(J));
                   XLRange.Value := FORMAT(CTotalBamt+CPSAmt-CPclb-CPTds);

                   XLRange := XlWrkSht.Range('C' + FORMAT(J));
                   XLRange.Value := FORMAT(CTotalClb+CPclb);

                   XLRange := XlWrkSht.Range('D' + FORMAT(J));
                   XLRange.Value :=FORMAT(CTotalTDS1+CPTds);


                   XLRange := XlWrkSht.Range('E' + FORMAT(J));
                   XLRange.Value := FORMAT(ABS(CCorrTrvlPmt));


                   XLRange := XlWrkSht.Range('G' + FORMAT(J));
                   XLRange.Value := FORMAT(CITotalPayment);
                   */

                    // XlRange := XlWrkSht.Range('S' + FORMAT(J));
                    // XlRange.Value := FORMAT(TotalELGODAmt + TotalElGodAmt1);
                    /*

                      XLRange := XlWrkSht.Range('P' + FORMAT(J));
                      XLRange.Value := 'Total Elig. Incl. Opening';

                      XLRange := XlWrkSht.Range('Q' + FORMAT(J));
                      XLRange.Value := FORMAT(CNetPayable);

                      J+=1;
                      XLRange := XlWrkSht.Range('P' + FORMAT(J));
                      XLRange.Value := 'Total Deduction(Incl TA Rev)';
                      XLRange := XlWrkSht.Range('Q' + FORMAT(J));
                      XLRange.Value := FORMAT(CTotalPayment+ABS(CCorrTrvlPmt));

                      J+=1;

                      XLRange := XlWrkSht.Range('P' + FORMAT(J));
                      XLRange.Value := 'Total Eligibility(Excl. Op)';
                      XLRange := XlWrkSht.Range('Q' + FORMAT(J));
                      XLRange.Value := FORMAT(CTotalPayment+ABS(CCorrTrvlPmt)+(CNetPayable)-CRemOpOpening);

                      J+=1;

                      XLRange := XlWrkSht.Range('P' + FORMAT(J));
                      XLRange.Value := 'Club 9';
                      XLRange := XlWrkSht.Range('Q' + FORMAT(J));
                      XLRange.Value := FORMAT(-ABS(ROUND(CClubDedect,1)));

                      J+=1;

                      XLRange := XlWrkSht.Range('P' + FORMAT(J));
                      XLRange.Value := 'TDS';
                      XLRange := XlWrkSht.Range('Q' + FORMAT(J));
                      XLRange.Value := FORMAT(-ABS(ROUND(CTDSDedect,1)));

                      J+=1;

                      XLRange := XlWrkSht.Range('P' + FORMAT(J));
                      XLRange.Value := 'Balance(Excl. Op)';
                      XLRange := XlWrkSht.Range('Q' + FORMAT(J));
                      XLRange.Value := FORMAT(CTotalPayment+ABS(CCorrTrvlPmt)-ABS(CNetPayable)-CRemOpOpening-ROUND(CClubDedect,1)-ROUND(CTDSDedect,1))
                    ;

                      J+=1;
                      XLRange := XlWrkSht.Range('P' + FORMAT(J));
                      XLRange.Value := 'Opening Bal.(Rem)';
                      XLRange := XlWrkSht.Range('Q' + FORMAT(J));
                      XLRange.Value := FORMAT(ROUND(CPAmt2,1));

                      J+=1;
                      XLRange := XlWrkSht.Range('P' + FORMAT(J));
                      XLRange.Value := 'Net Balance';
                      XLRange := XlWrkSht.Range('Q' + FORMAT(J));
                      XLRange.Value := FORMAT(ROUND(CTotalBal,1));

                      J+=1;
                     */
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('Total Elg./ OD', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalELGODAmt + TotalElGodAmt1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                END;

                IF ShowDetils_1 THEN BEGIN
                    IF ExportToExcel THEN BEGIN

                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('Invoice + Adjustments', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('TDS Amount', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('Club 9 Amount', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('Invoice + Adjustments', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('TDS Amount', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('Club 9 Amount', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('TDS Amount On Advance', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('Club 9 Amount on Advance', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('Payment (Net)', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(TotalAmt_Invoice + TOpenInvAmt_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(TDS_Invoice, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Club_Invoice, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(TotalAmt_Invoice_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(TDS_Invoice_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Club_Invoice_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(TDS_Pmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Club_Pmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Amt_Pmt + TDS_Pmt + Club_Pmt + TPSAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                    END;
                END;

                IF ShowDetils_1 THEN BEGIN
                    IF ExportToExcel THEN BEGIN

                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('Eligibility (Gross)', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(TotalAmt_Invoice + TOpenInvAmt_1 + TotalAmt_Invoice_1 + TDS_Invoice + TDS_Invoice_1 + Club_Invoice + Club_Invoice_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('TDS', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(FORMAT(ABS(TDS_Invoice + TDS_Invoice_1 + TDS_Pmt)), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('Club 9', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(FORMAT(ABS(Club_Invoice + Club_Invoice_1 + Club_Pmt)), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('Payment (Net)', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Amt_Pmt + TDS_Pmt + Club_Pmt + TPSAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn('Eligibility (Net)', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(FORMAT(TotalAmt_Invoice + TOpenInvAmt_1 + TotalAmt_Invoice_1 - TDS_Pmt - Club_Pmt + (Amt_Pmt + TDS_Pmt + Club_Pmt + TPSAmt)), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                    END;
                END ELSE
                    CurrReport.SHOWOUTPUT(FALSE);

            end;

            trigger OnPreDataItem()
            begin


                TPSAmt := 0;
                TOpenInvAmt_1 := 0;
                PSAmt := 0;
                OpenInvAmt_1 := 0;
                PTds := 0;
                Pclb := 0;


                TotalAmt_1 := TotalAmt_1 + "New Confirmed Order".Amount;
                TotalRec_1 := TotalRec_1 + "New Confirmed Order"."Total Received Amount";
                DiscAmt_1 := DiscAmt_1 + DiscAmt;
                Balanace_1 := Balanace_1 + Balance;
                TotalBSP1_1 := TotalBSP1_1 + BSP1;
                TotalBSP3_1 := TotalBSP3_1 + BSP3;
                TotalBSP2_1 := TotalBSP2_1 + BSP2;
                TotalTrvlAmt_1 := TotalTrvlAmt_1 + TrvlAmt;
                TotalCommAmt_1 := TotalCommAmt_1 + CommAmt;
                TotalElgiblBSP2_1 := TotalElgiblBSP2_1 + ElgiblBSP2;
                Total_1 := Total_1 + Total;

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
                SLNo := 0;
                TotalELGODAmt := 0;
                TotalElGodAmt1 := 0;

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
                AssPmtHdr.SETRANGE("Payment Reversed", TRUE);
                AssPmtHdr.SETRANGE("Reversal done in LLP Companies", FALSE);
                AssPmtHdr.SETFILTER("Amt applicable for Payment", '>%1', 0);
                IF EDate1 <> 0D THEN
                    AssPmtHdr.SETRANGE("Posting Date", 0D, EDate1);

                IF AssPmtHdr.FINDFIRST THEN
                    ERROR('Please make reversal in ' + AssPmtHdr."Company Name" + ' ' + 'for Associate Code' + ' '
                                                     + AssPmtHdr."Associate Code" + 'with Document No.' + AssPmtHdr."Document No.");

                AssPmtHdr.RESET;
                AssPmtHdr.SETCURRENTKEY("Associate Code", "Payment Reversed", "Reversal done in LLP Companies");
                AssPmtHdr.SETRANGE(Post, TRUE);
                AssPmtHdr.SETRANGE("Posted on LLP Company", FALSE);
                AssPmtHdr.SETFILTER("Amt applicable for Payment", '>%1', 0);
                IF EDate1 <> 0D THEN
                    AssPmtHdr.SETRANGE("Posting Date", 0D, EDate1);
                IF AssPmtHdr.FINDFIRST THEN
                    ERROR('Please run the Create/Post Payment Batch in Company-' + AssPmtHdr."Company Name");

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
                            ERROR('Please run the Create/Post Payment Batch in Company-' + CompWise."Company Code");
                    UNTIL CompWise.NEXT = 0;

                AssadjEntry_1.RESET;
                AssadjEntry_1.SETRANGE("Associate Code", MMCode);
                AssadjEntry_1.SETRANGE("Sinking Process Done", FALSE);
                IF AssadjEntry_1.FINDSET THEN
                    REPEAT
                        IF NOT AssadjEntry_1."Posted in From Company Name" THEN
                            ERROR('Run Associate OD Adjustment batch in ' + FORMAT(AssadjEntry_1."From Company Name"));
                        IF NOT AssadjEntry_1."Posted in To Company Name" THEN
                            ERROR('Run Associate OD Adjustment batch in ' + FORMAT(AssadjEntry_1."To Company Name"));
                    UNTIL AssadjEntry_1.NEXT = 0;
            end;
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

    trigger OnPreReport()
    begin

        IF ExportToExcel THEN BEGIN
            IF CurrReport.PAGENO = 1 THEN begin


                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(CompInfo.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(CompInfo.Address + ' ' + CompInfo."Address 2" + ' ' + CompInfo.City + ' ' + CompInfo."Post Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn('Date & Time', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Format(Today) + Format(Time), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn('Commission Eligibility(All Application)', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn('Filter:Code : ' + MMCode + ',W.E.F.Date : ' + FORMAT(WEFDate) + 'End Date' + FORMAT(EDate), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            end;

        END;
    end;

    trigger OnPostReport()
    begin
        TempExcelBuffer.CreateNewBook('New Commission Eligibility');
        TempExcelBuffer.WriteSheet('New Commission Eligibility', CompanyName(), UserId());
        TempExcelBuffer.SetFriendlyFilename('New Commission Eligibility');
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();
        TempExcelBuffer.DeleteAll();
    end;

    var
        Text000: Label 'Invalid Parameters.';
        CompInfo: Record "Company Information";
        Filters: Text[30];
        MMCode: Code[20];
        WEFDate: Date;
        ChainMgt: Codeunit "Unit Post";
        Chain: Record Vendor temporary;
        Chain2: Record Vendor temporary;
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
        k: Integer;
        J: Integer;
        FilterUsed: Text[250];
        ExportToExcel: Boolean;
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
        AssadjEntry_1: Record "Associate OD Ajustment Entry";
        SLNo: Integer;
        TotalELGODAmt: Decimal;
        RecVend_1: Record Vendor;
        TotalAmt_1: Decimal;
        TotalRec_1: Decimal;
        DiscAmt_1: Decimal;
        Balanace_1: Decimal;
        TotalBSP1_1: Decimal;
        TotalBSP3_1: Decimal;
        TotalBSP2_1: Decimal;
        TotalTrvlAmt_1: Decimal;
        TotalCommAmt_1: Decimal;
        TotalElgiblBSP2_1: Decimal;
        Total_1: Decimal;
        TotalElGodAmt1: Decimal;
        VLEntry_2: Record "Vendor Ledger Entry";
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
        ShowDetils_1: Boolean;
        TPSAmt: Decimal;
        TOpenInvAmt_1: Decimal;
        VendFilters: Code[20];
        DVLEntry: Record "Detailed Vendor Ledg. Entry";
        SaveReportName: Code[50];
        "ReportDataforE-Mail": Record "Report Data for E-Mail";
        Day_1: Integer;
        Month_1: Integer;
        Year_1: Integer;
        BatchNos: Code[20];
        "ReportDataforE-Mail_1": Record "Report Data for E-Mail";
        EntryNo: Integer;
        // XlApp: Automation;
        // XlWrkBk: Automation;
        // XlWrkSht: Automation;
        // XlWrkshts: Automation;
        // XlRange: Automation;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        NewDateforInventive: Date;

    procedure Setfilters(VendFilter: Code[20]; BatchNo: Code[20])
    begin
        VendFilters := VendFilter;
        BatchNos := BatchNo;
    end;
}

