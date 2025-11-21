report 50014 "New Team Collection Det Job"
{
    // version BBG format

    ProcessingOnly = true;
    UseRequestPage = false;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("NewApplication Payment Entry"; "NewApplication Payment Entry")
        {
            DataItemTableView = SORTING("Document No.", Posted, "Posting date")
                                WHERE(Posted = CONST(true),
                                      "Cheque Status" = FILTER(<> Cancelled));
            RequestFilterFields = "Document No.";

            trigger OnAfterGetRecord()
            var
                VLEntry_1: Record "Vendor Ledger Entry";
            begin
                IF DocNo <> "Document No." THEN BEGIN
                    CLEAR(AppHier);
                    AppHier.RESET;
                    AppHier.SETRANGE("Application Code", "Document No.");
                    AppHier.SETRANGE(Status, AppHier.Status::Active);
                    IF AppHier.FINDSET THEN
                        REPEAT
                            CollHier.TRANSFERFIELDS(AppHier);
                            CollHier.INSERT;
                        UNTIL AppHier.NEXT = 0;
                    DocNo := "Document No.";
                END;
            end;

            trigger OnPreDataItem()
            var
                AssadjEntry_1: Record "Associate OD Ajustment Entry";
            begin
                SETRANGE("Posting date", StartDate, EndDate);
            end;
        }
        dataitem("Application Hierar. Collection"; "Application Hierar. Collection")
        {
            DataItemTableView = SORTING("Application Code", "Line No.");
            dataitem("New Confirmed Order"; "New Confirmed Order")
            {
                DataItemTableView = SORTING("Introducer Code", "No.", "Posting Date");

                trigger OnAfterGetRecord()
                var
                    RecVendor1: Record Vendor;
                begin
                    LastDateofRCPT := 0D;
                    LNewAppEntry.RESET;
                    LNewAppEntry.SETCURRENTKEY("Document No.", Posted, "Posting date");
                    LNewAppEntry.SETRANGE("Document No.", "No.");
                    LNewAppEntry.SETRANGE(Posted, TRUE);
                    IF LNewAppEntry.FINDLAST THEN
                        LastDateofRCPT := LNewAppEntry."Posting date";

                    IF CollectionDate = EndDate THEN BEGIN
                        CLEAR(Collection);
                        AplctnPmntE.RESET;
                        AplctnPmntE.SETCURRENTKEY("Document No.", Posted, "Posting date");
                        AplctnPmntE.SETRANGE("Document No.", "No.");
                        AplctnPmntE.SETRANGE(Posted, TRUE);
                        AplctnPmntE.SETRANGE("Posting date", StartDate, EndDate);
                        AplctnPmntE.SETFILTER("Payment Mode", '<>%1&<>%2', 6, 7); //200217
                        IF NOT InclUnClrdChqs THEN
                            AplctnPmntE.SETRANGE("Cheque Status", AplctnPmntE."Cheque Status"::Cleared)
                        ELSE
                            AplctnPmntE.SETFILTER("Cheque Status", '<>%1&<>%2', AplctnPmntE."Cheque Status"::Bounced,
                                     AplctnPmntE."Cheque Status"::Cancelled);

                        IF AplctnPmntE.FINDSET THEN
                            REPEAT
                                Collection += AplctnPmntE.Amount;
                            UNTIL AplctnPmntE.NEXT = 0;
                        CLEAR(RefundAmt);
                        AplctnPmntE.RESET;
                        AplctnPmntE.SETCURRENTKEY("Document No.", Posted, "Posting date");
                        AplctnPmntE.SETRANGE("Document No.", "No.");
                        AplctnPmntE.SETRANGE(Posted, TRUE);
                        AplctnPmntE.SETRANGE("Posting date", StartDate, EndDate);
                        AplctnPmntE.SETRANGE("Payment Mode", 6, 7);
                        AplctnPmntE.SETFILTER("Cheque Status", '<>%1&<>%2', AplctnPmntE."Cheque Status"::Bounced,
                                   AplctnPmntE."Cheque Status"::Cancelled);

                        IF AplctnPmntE.FINDSET THEN
                            REPEAT
                                RefundAmt += AplctnPmntE.Amount;
                            UNTIL AplctnPmntE.NEXT = 0;

                    END ELSE BEGIN
                        CLEAR(Collection);
                        AplctnPmntE.RESET;
                        AplctnPmntE.SETCURRENTKEY("Document No.", Posted, "Posting date");
                        AplctnPmntE.SETRANGE("Document No.", "No.");
                        AplctnPmntE.SETRANGE(Posted, TRUE);
                        AplctnPmntE.SETRANGE("Posting date", StartDate, CollectionDate);
                        AplctnPmntE.SETFILTER("Payment Mode", '<>%1&<>%2', 6, 7);
                        IF NOT InclUnClrdChqs THEN
                            AplctnPmntE.SETRANGE("Cheque Status", AplctnPmntE."Cheque Status"::Cleared)
                        ELSE
                            AplctnPmntE.SETFILTER("Cheque Status", '<>%1&<>%2', AplctnPmntE."Cheque Status"::Bounced,
                                     AplctnPmntE."Cheque Status"::Cancelled);
                        IF AplctnPmntE.FINDSET THEN
                            REPEAT
                                Collection += AplctnPmntE.Amount;

                            UNTIL AplctnPmntE.NEXT = 0;

                        CLEAR(RefundAmt);
                        AplctnPmntE.RESET;
                        AplctnPmntE.SETCURRENTKEY("Document No.", Posted, "Posting date");
                        AplctnPmntE.SETRANGE("Document No.", "No.");
                        AplctnPmntE.SETRANGE(Posted, TRUE);
                        AplctnPmntE.SETRANGE("Posting date", StartDate, CollectionDate);
                        AplctnPmntE.SETRANGE("Payment Mode", 6, 7);
                        AplctnPmntE.SETFILTER("Cheque Status", '<>%1&<>%2', AplctnPmntE."Cheque Status"::Bounced,
                                   AplctnPmntE."Cheque Status"::Cancelled);
                        IF AplctnPmntE.FINDSET THEN
                            REPEAT
                                RefundAmt += AplctnPmntE.Amount;
                            UNTIL AplctnPmntE.NEXT = 0;

                    END;
                    CLEAR(LDP);
                    CLEAR(AppCollection);
                    CLEAR(AplctnPmntE);
                    AplctnPmntE.RESET;
                    AplctnPmntE.SETCURRENTKEY("Document No.", Posted, "Posting date");
                    AplctnPmntE.SETRANGE("Document No.", "No.");
                    AplctnPmntE.SETRANGE(Posted, TRUE);
                    AplctnPmntE.SETRANGE("Posting date", 0D, TODAY);
                    IF NOT InclUnClrdChqs THEN
                        AplctnPmntE.SETRANGE("Cheque Status", AplctnPmntE."Cheque Status"::Cleared)
                    ELSE
                        AplctnPmntE.SETFILTER("Cheque Status", '<>%1&<>%2', AplctnPmntE."Cheque Status"::Bounced,
                                  AplctnPmntE."Cheque Status"::Cancelled);
                    IF AplctnPmntE.FINDSET THEN
                        REPEAT
                            CLEAR(LDP);
                            AppCollection += AplctnPmntE.Amount;
                            LDP := AplctnPmntE."Posting date";
                        UNTIL AplctnPmntE.NEXT = 0;

                    CLEAR(Due);
                    Due := Amount - AppCollection;

                    TotalConfAmt := TotalConfAmt + Amount;
                    TotalColationDurPeriod := TotalColationDurPeriod + AppCollection;
                    TotalDueAmt := TotalDueAmt + Due;
                    TotalExtent := TotalExtent + "New Confirmed Order"."Saleable Area";
                    TotalMinAmt := TotalMinAmt + "New Confirmed Order"."Min. Allotment Amount";
                    Sno += 1;

                    Vndr.GET("Introducer Code");
                    TAppCollection += AppCollection;

                    GLSetup.GET;
                    IF DimValue.GET(GLSetup."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code") THEN;
                    Cstmr.RESET;
                    Cstmr.CHANGECOMPANY("Company Name");
                    Cstmr.GET("Customer No.");

                    USERID_1 := '';
                    Branch_1 := '';

                    APE_1.RESET;
                    APE_1.SETRANGE("Document No.", "No.");
                    APE_1.SETRANGE("Cheque Status", APE_1."Cheque Status"::Cleared);
                    IF APE_1.FINDFIRST THEN BEGIN
                        USERID_1 := APE_1."User ID";
                        Branch_1 := APE_1."User Branch Name";
                    END;

                    TeamHead := '';

                    AssHiercyWithApp.RESET;
                    AssHiercyWithApp.SETRANGE("Application Code", "No.");
                    AssHiercyWithApp.SETRANGE(Status, AssHiercyWithApp.Status::Active);
                    AssHiercyWithApp.SETFILTER(AssHiercyWithApp."Rank Code", '<>%1', 13.0);
                    IF AssHiercyWithApp.FINDLAST THEN
                        TeamHead := AssHiercyWithApp."Associate Code";


                    CLEAR(Memberof);
                    Memberof.RESET;
                    Memberof.SETRANGE("User Name", USERID);
                    Memberof.SETRANGE("Role ID", 'VendInfoVisible');
                    IF Memberof.FINDFIRST THEN
                        "VendMobNo." := Cstmr."BBG Mobile No."
                    ELSE
                        "VendMobNo." := '';


                    IF RunAsExcel THEN BEGIN//110920
                        IF Summary THEN BEGIN
                        END ELSE BEGIN
                            IF ExportToExcel THEN BEGIN
                                ExcelBuffer.NewRow;
                                ExcelBuffer.AddColumn(FORMAT(Sno), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT("Introducer Code"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT(Vndr.Name), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT(DimValue.Name), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT("Unit Code"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT("Application No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT(Cstmr.Name), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT("VendMobNo."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn("Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(LDP, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT("Saleable Area"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(FORMAT("Min. Allotment Amount"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(FORMAT(Amount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(FORMAT(Collection), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                TotalCollation := TotalCollation + Collection;
                                ExcelBuffer.AddColumn(FORMAT(Due), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(FORMAT(RefundAmt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                TotalRefundAmt := TotalRefundAmt + RefundAmt;
                                ExcelBuffer.AddColumn(FORMAT(AppCollection), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                                TotalAppCollection := TotalAppCollection + AppCollection;
                                CLEAR(RegNo);
                                IF "Registration No." <> '' THEN
                                    RegNo := "Registration No.";
                                ExcelBuffer.AddColumn(FORMAT(RegNo), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT("Pass Book No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT(Branch_1), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT("Company Name"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT(TeamHead), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(FORMAT(LastDateofRCPT), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                            END;
                        END;
                    END;   //110920
                end;

                trigger OnPostDataItem()
                begin

                    GPlot += TPlots;

                    IF RunAsExcel THEN BEGIN//110920

                        IF ExportToExcel AND (Summary) THEN BEGIN
                            ExcelBuffer.NewRow;
                            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(FORMAT("New Confirmed Order"."Introducer Code"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Vndr.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(FORMAT("New Confirmed Order"."Saleable Area"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(FORMAT("New Confirmed Order"."Min. Allotment Amount"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(FORMAT("New Confirmed Order".Amount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(FORMAT(Collection), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(FORMAT(DueTotal), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(FORMAT(TPlots), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(FORMAT(USERID_1), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(FORMAT(Branch_1), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(FORMAT("Application Type"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(FORMAT("Company Name"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(FORMAT(TeamHead), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(LastDateofRCPT, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        END;
                    END;  //110920
                end;

                trigger OnPreDataItem()
                begin

                    CurrReport.CREATETOTALS("New Confirmed Order"."Saleable Area", "New Confirmed Order"."Min. Allotment Amount",
                        "New Confirmed Order".Amount);
                    CurrReport.CREATETOTALS(Collection, DueTotal);
                    PlotNo := 0;
                    TPlots := 0;
                    CLEAR(AppCollection);
                    CLEAR(TAppCollection);
                    SETRANGE("No.", DocNo);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                RecVend_1.RESET;
                RecVend_1.SETRANGE("No.", MMCode);
                RecVend_1.SETRANGE("BBG Black List", TRUE);
                IF RecVend_1.FINDFIRST THEN
                    CurrReport.SKIP
                ELSE BEGIN
                    IF DirectTeam = DirectTeam::"Direct+Team" THEN BEGIN
                    END;
                    IF DocNo <> "Application Code" THEN
                        DocNo := "Application Code"
                    ELSE
                        CurrReport.SKIP;
                END;
            end;

            trigger OnPostDataItem()
            begin
                IF RunAsExcel THEN BEGIN//110920
                    IF Summary THEN BEGIN
                        ExcelBuffer.NewRow;
                        ExcelBuffer.AddColumn('Grand Total' + MMCode + '   ' + GetDesc.GetVendorName(MMCode), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(FORMAT(TotalExtent), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(FORMAT(TotalMinAmt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(FORMAT(TotalConfAmt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(FORMAT(TotalColationDurPeriod), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(FORMAT(TotalDueAmt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(FORMAT(GPlot), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    END ELSE BEGIN
                        ExcelBuffer.NewRow;
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Grand Total' + MMCode + '   ' + GetDesc.GetVendorName(MMCode), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(FORMAT(TotalExtent), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(FORMAT(TotalMinAmt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(FORMAT(TotalConfAmt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(FORMAT(TotalCollation), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(FORMAT(TotalDueAmt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(FORMAT(TotalRefundAmt), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(FORMAT(TotalAppCollection), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);

                    END;
                END;  //110920
            end;

            trigger OnPreDataItem()
            begin

                IF DirectTeam = DirectTeam::"Direct+Team" THEN BEGIN
                    SETCURRENTKEY("Application Code", "Associate Code");
                    SETRANGE("Associate Code", MMCode)
                END ELSE BEGIN
                    SETCURRENTKEY("Application Code", "Introducer Code");
                    SETRANGE("Introducer Code", MMCode);

                END;
                IF Venture <> '' THEN
                    SETRANGE("Project Code", Venture);

                CLEAR(Sno);
                CurrReport.CREATETOTALS("New Confirmed Order"."Saleable Area", "New Confirmed Order"."Min. Allotment Amount",
                 "New Confirmed Order".Amount, Due);
                CurrReport.CREATETOTALS(Collection, DueTotal, AppCollection, Due, RefundAmt);
                //ALLECK 230413 END
                DocNo := '';


                IF RunAsExcel THEN BEGIN//110920
                    IF Summary THEN BEGIN
                        ExcelBuffer.NewRow;
                        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('IBA Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('IBA Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Extent', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Min.Allotment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Payable', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Collection/Paid', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Due', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Allotment', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('USER ID', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('USER Branch Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Company Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Team Head ID', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Last Date of Receipt', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    END ELSE BEGIN
                        ExcelBuffer.NewRow;
                        ExcelBuffer.AddColumn('Serial No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('IBA Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('IBA Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Project Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Plot No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Application No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Cust. Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Cust. Mobile No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('DOJ', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('LDP', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Extent', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Allotment Amt', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Total Plot Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Collection during the period', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Due', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Refund', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Total Recd Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Registered Sale Deed No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Old Application No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('USER Branch Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Company Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Team Head ID', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Last Date of Receipt', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    END;
                END;  //110920
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

    trigger OnInitReport()
    begin
        ExcelBuffer.DELETEALL;
    end;

    trigger OnPostReport()
    begin
        //ExcelBuffer.SetRunViaNAS(TRUE);
        //ExcelBuffer.CreateBookAndSaveExcel('', 'Sheet 1', 'Report', COMPANYNAME, USERID, SaveReportName + '.xlsx');
        ExcelBuffer.CreateNewBook('CollectionDetailsReport');
        ExcelBuffer.WriteSheet('CollectionDetailsReport', CompanyName(), UserId());
        ExcelBuffer.SetFriendlyFilename('CollectionDetailsReport');
        ExcelBuffer.CloseBook();
        //ExcelBuffer.OpenExcel();
        OStream := TempBlob.CreateOutStream();
        ExcelBuffer.SaveToStream(OStream, true);
        SendMail();
        ExcelBuffer.DeleteAll();



    end;


    trigger OnPreReport()
    begin

        MMCode := VendFilters;
        DirectTeam := DirectTeam::"Direct+Team";
        StartDate := v_StDates;
        EndDate := v_EndDates1;
        CollectionDate := v_EndDates1;
        InclUnClrdChqs := TRUE;
        RunAsExcel := TRUE;
        //Summary := TRUE;
        ExportToExcel := TRUE;
        ReportFilters := 'MM Code-' + MMCode + ', Direct/Team- ' + FORMAT(DirectTeam) + ', Start Date-' + FORMAT(StartDate) + ', End Date- ' + FORMAT(EndDate) + ', Collection Cutoff Date-' + FORMAT(CollectionDate)
        + ', Incl Uncleard Cheques- ' + FORMAT(InclUnClrdChqs);

        CollHier.DELETEALL;

        Vend2.GET(MMCode);
        CompInfo.GET;

        SaveReportName := '';
        UnitSetup.GET;
        Day_1 := DATE2DMY(EndDate, 1);
        Month_1 := DATE2DMY(EndDate, 2);
        Year_1 := DATE2DMY(EndDate, 3);


        SaveReportName := '50041' + MMCode + '_' + FORMAT(Day_1) + FORMAT(Month_1) + FORMAT(Year_1) + '_' + FORMAT(Entry_No1);//+'.xlsx';  //03022025 code commented
        //  XlWrkBk.SaveAs(UnitSetup."Excel File Save Path" +SaveReportName+'.xlsx');

        "ReportDataforE-Mail_1".RESET;
        IF "ReportDataforE-Mail_1".FINDLAST THEN
            EntryNo := "ReportDataforE-Mail_1"."Entry No."
        ELSE
            EntryNo := 0;

        "ReportDataforE-Mail".INIT;
        "ReportDataforE-Mail"."Entry No." := EntryNo + 1;
        "ReportDataforE-Mail"."Report ID" := 50041;
        "ReportDataforE-Mail"."Associate Code" := MMCode;
        "ReportDataforE-Mail"."Report Name" := SaveReportName;
        "ReportDataforE-Mail"."Report Run Date" := TODAY;
        "ReportDataforE-Mail"."Report Run Time" := TIME;
        "ReportDataforE-Mail"."Report Batch No." := BatchNos;
        "ReportDataforE-Mail"."Request from Mobile" := TRUE;
        "ReportDataforE-Mail"."E-Mail Send" := True;

        "ReportDataforE-Mail".INSERT;

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(CompInfo.Name, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(CompInfo.Address + ' ' + CompInfo."Address 2" + ' ' + CompInfo.City + ' ' + CompInfo."Post Code", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Date & Time', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn((FORMAT(TODAY) + FORMAT(TIME)), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Team Wise Collection Detailed', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    var
        Text000: Label 'Invalid Parameters.';
        Filters: Text[30];
        MMCode: Code[20];
        StartDate: Date;
        EndDate: Date;
        Chain: Record Vendor temporary;
        Chain2: Record Vendor temporary;
        Vendor: Record Vendor;
        Cnt: Integer;
        GetDescry: Codeunit GetDescription;
        CName: Text[50];
        Cstmr: Record Customer;
        CompInfo: Record "Company Information";
        GetDesc: Codeunit GetDescription;
        Stdate: Date;
        EDate: Date;
        FilterUsed: Text[250];
        Vndr: Record Vendor;
        VName: Text[50];
        DOJ: Date;
        DimValue: Record "Dimension Value";
        PName: Text[50];
        AplctnPmntE: Record "NewApplication Payment Entry";
        Collection: Decimal;
        UnitPmntE: Record "Unit Master";
        Plots: Decimal;
        Venture: Code[20];
        DirectTeam: Option Direct,"Direct+Team";
        ShowAll: Boolean;
        GLSetup: Record "General Ledger Setup";
        Vend2: Record Vendor;
        Sno: Integer;
        InclOldApps: Boolean;
        CollectionDate: Date;
        ApplPayEntry: Record "NewApplication Payment Entry";
        k: Integer;
        J: Integer;
        ExportToExcel: Boolean;
        InclUnClrdChqs: Boolean;
        APE: Record "NewApplication Payment Entry";
        Due: Decimal;
        PlotNo: Decimal;
        TPlots: Decimal;
        DueTotal: Decimal;
        Summary: Boolean;
        GPlot: Decimal;
        AssciateCode: Code[20];
        AppHier: Record "New Associate Hier with Appl.";
        CollHier: Record "Application Hierar. Collection";
        AppCollection: Decimal;
        TAppCollection: Decimal;
        GAppCollection: Decimal;
        LDP: Date;
        RefundAmt: Decimal;
        RegNo: Code[20];
        DocNo: Code[20];
        "VendMobNo.": Text[30];
        Memberof: Record "Access Control";
        CompanyWise: Record "Company wise G/L Account";
        RecVend_1: Record Vendor;
        APE_1: Record "NewApplication Payment Entry";
        USERID_1: Code[50];
        Branch_1: Text[60];
        AssHiercyWithApp: Record "Associate Hierarcy with App.";
        TeamHead: Text[60];
        TotalExtent: Decimal;
        TotalMinAmt: Decimal;
        TotalConfAmt: Decimal;
        TotalColationDurPeriod: Decimal;
        TotalDueAmt: Decimal;
        TotalRefund: Decimal;
        TotalRcvedAmount: Decimal;
        TotalAppCollection: Decimal;
        TotalCollation: Decimal;
        TotalRefundAmt: Decimal;
        LastDateofRCPT: Date;
        LNewAppEntry: Record "NewApplication Payment Entry";
        AssociateHierarcywithApp_1: Record "Associate Hierarcy with App.";
        SNo1: Integer;
        UserSetup: Record "User Setup";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        RunAsExcel: Boolean;
        ReportFilters: Text;
        //ReportDetailsUpdate: Codeunit 50018;
        EntryNo: Integer;
        Entry_No1: Integer;
        VendFilters: Code[20];
        BatchNos: Code[20];
        v_StDates: Date;
        v_EndDates1: Date;
        "ReportDataforE-Mail": Record "Report Data for E-Mail";
        "ReportDataforE-Mail_1": Record "Report Data for E-Mail";
        SaveReportName: Text;
        Day_1: Integer;
        Month_1: Integer;
        Year_1: Integer;
        UnitSetup: Record "Unit Setup";
        ExcelBuffer: Record "Excel Buffer" temporary;
        ReportRequestfromWebMb: Record "Report Request from Web/Mb.";
        OStream: OutStream;
        TempBlob: Codeunit "Temp Blob";


    procedure Setfilters(VendFilter: Code[20]; BatchNo: Code[20]; P_StDates: Date; P_EndDates: Date; Entry_No: Integer)
    begin
        VendFilters := VendFilter;
        BatchNos := BatchNo;
        v_StDates := P_StDates;
        v_EndDates1 := P_EndDates;
        Entry_No1 := Entry_No;
    end;

    procedure SendMail()
    var
        AttachmentStream: InStream;
        FileNameTxt: Text;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        HtmlEmailBody: Text;
        MailSent: Boolean;
    begin
        RecVend_1.RESET;
        RecVend_1.SETRANGE("No.", MMCode);
        IF RecVend_1.FindFirst() THEN begin
            FileNameTxt := 'CollectionDetailsReport' + '.Xlsx';
            AttachmentStream := TempBlob.CreateInStream();
            HtmlEmailBody := '<!DOCTYPE html><html><body>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += 'Dear Sir / Madam,';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Please find the attached Report';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Regards';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Building Blocks Group';
            HtmlEmailBody += '<br/>';

            EmailMessage.Create(RecVend_1."E-Mail", 'Your Collection Details Report', HtmlEmailBody, True);

            EmailMessage.AddAttachment(SaveReportName + '.Xlsx', '.Xlsx', AttachmentStream);
            MailSent := Email.Send(EmailMessage, "Email Scenario"::Default);
        end;
        //  END;
    end;

}

