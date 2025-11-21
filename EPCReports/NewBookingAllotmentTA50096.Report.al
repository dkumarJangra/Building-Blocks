report 97774 "New Booking/Allotment/TA50096"
{
    // version BBG format

    // ALLECK 230513: Restricted Report to Run by only Userid 100237

    ProcessingOnly = true;
    UseRequestPage = false;
    //ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Vendor_11; Vendor)
        {

            trigger OnAfterGetRecord()
            begin
                MMCode := "No.";
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("No.", VendFilters);
            end;
        }
        dataitem("New Associate Hier with Appl."; "New Associate Hier with Appl.")
        {
            DataItemTableView = SORTING("Application Code", "Line No.")
                                WHERE(Status = CONST(Active));
            dataitem("New Confirmed Order"; "New Confirmed Order")
            {
                DataItemLink = "No." = FIELD("Application Code");
                DataItemTableView = SORTING("Introducer Code", "No.", "Posting Date");

                trigger OnAfterGetRecord()
                begin



                    IF CollectionDate = EndDate THEN BEGIN
                        CLEAR(Collection);
                        AplctnPmntE.RESET;
                        AplctnPmntE.SETRANGE("Document No.", "No.");
                        AplctnPmntE.SETRANGE("Posting date", StartDate, EndDate);
                        IF NOT InclUnClrdChqs THEN
                            AplctnPmntE.SETRANGE("Cheque Status", AplctnPmntE."Cheque Status"::Cleared)
                        ELSE
                            AplctnPmntE.SETFILTER("Cheque Status", '%1|%2', AplctnPmntE."Cheque Status"::" ",
                                     AplctnPmntE."Cheque Status"::Cleared);
                        IF AplctnPmntE.FINDSET THEN
                            REPEAT
                                Collection := Collection + AplctnPmntE.Amount;
                            UNTIL AplctnPmntE.NEXT = 0;
                    END ELSE BEGIN
                        CLEAR(Collection);
                        AplctnPmntE.RESET;
                        AplctnPmntE.SETRANGE("Document No.", "No.");
                        AplctnPmntE.SETRANGE("Posting date", StartDate, CollectionDate);
                        IF NOT InclUnClrdChqs THEN
                            AplctnPmntE.SETRANGE("Cheque Status", AplctnPmntE."Cheque Status"::Cleared)
                        ELSE
                            AplctnPmntE.SETFILTER("Cheque Status", '%1|%2', AplctnPmntE."Cheque Status"::" ",
                                     AplctnPmntE."Cheque Status"::Cleared);

                        IF AplctnPmntE.FINDSET THEN
                            REPEAT
                                Collection := Collection + AplctnPmntE.Amount;
                            UNTIL AplctnPmntE.NEXT = 0;
                    END;

                    IF Collection = 0 THEN
                        CurrReport.SKIP;

                    IF NOT ShowAll AND (Collection < "Min. Allotment Amount") THEN
                        CurrReport.SKIP;

                    Due := Amount - Collection;
                    IF Due > 0 THEN
                        DueTotal += Due;


                    Sno += 1;

                    Vndr.GET("Introducer Code");
                    CLEAR(PlotNo);
                    IF "Unit Code" <> '' THEN BEGIN
                        IF UnitPmntE.GET("Unit Code") THEN BEGIN
                            //ALLECK 230413
                            IF (Collection < "Min. Allotment Amount") THEN
                                PlotNo := 0
                            ELSE BEGIN
                                PlotNo := UnitPmntE."No. of Plots for Incentive Cal";  //170316
                                IF PlotNo = 0 THEN
                                    PlotNo := UnitPmntE."No. of Plots";   //170316
                            END;
                        END;
                    END ELSE BEGIN
                        ArcOrd.RESET;
                        ArcOrd.CHANGECOMPANY("Company Name");
                        ArcOrd.SETRANGE("No.", "No.");
                        IF ArcOrd.FINDLAST THEN BEGIN
                            IF UnitPmntE.GET(ArcOrd."Unit Code") THEN BEGIN
                                //ALLECK 230413
                                IF (Collection < "Min. Allotment Amount") THEN
                                    PlotNo := 0
                                ELSE BEGIN
                                    PlotNo := UnitPmntE."No. of Plots for Incentive Cal";  //170316
                                    IF PlotNo = 0 THEN
                                        PlotNo := UnitPmntE."No. of Plots";   //170316
                                END;
                            END;
                        END;
                    END;
                    TPlots += PlotNo;
                    //ALLECK 230413

                    GLSetup.GET;
                    IF DimValue.GET(GLSetup."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code") THEN;
                    Cstmr.RESET;
                    Cstmr.CHANGECOMPANY("Company Name");
                    Cstmr.GET("Customer No.");

                    "VendMobNo." := '';
                    "VendMobNo." := Cstmr."BBG Mobile No.";


                    APE.RESET;
                    APE.SETRANGE("Document No.", "No.");
                    //APE.SETRANGE("Cheque Status",APE."Cheque Status"::Cleared);
                    APE.SETFILTER(Amount, '<>%1', 0);
                    IF APE.FINDLAST THEN
                        LPDate := APE."Posting date"
                    ELSE
                        LPDate := 0D;

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

                    TotalSaleablearea := TotalSaleablearea + "New Confirmed Order"."Saleable Area";
                    TotalAmount := TotalAmount + "New Confirmed Order".Amount;
                    TotalCollection := TotalCollection + Collection;
                    TotalDueAmt := TotalDueAmt + DueTotal;
                    TotalGPlot := TotalGPlot + PlotNo;
                    TotalMinAllotmentAmt := TotalMinAllotmentAmt + "New Confirmed Order"."Min. Allotment Amount";

                    IF Summary THEN BEGIN
                    END ELSE BEGIN

                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn(Sno, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("Introducer Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Vndr.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(DimValue.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("Unit Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("Application No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Cstmr.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("VendMobNo.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(LPDate, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("Saleable Area", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("Min. Allotment Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Amount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Collection, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Due, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(PlotNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Branch_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(TeamHead, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    END;
                end;

                trigger OnPostDataItem()
                begin
                    IF Summary THEN BEGIN
                        GPlot += TPlots;

                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("New Confirmed Order"."Introducer Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Vndr.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("New Confirmed Order"."Saleable Area", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("New Confirmed Order"."Min. Allotment Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("New Confirmed Order".Amount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Collection, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(DueTotal, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(TPlots, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(USERID_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Branch_1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(TeamHead, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);


                    END;
                end;

                trigger OnPreDataItem()
                begin

                    CurrReport.CREATETOTALS("New Confirmed Order"."Saleable Area", "New Confirmed Order"."Min. Allotment Amount",
                    "New Confirmed Order".Amount);
                    CurrReport.CREATETOTALS(Collection, DueTotal);
                    //ALLECK 230413 END
                    PlotNo := 0;//ALLECK 230413
                    TPlots := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                IF DocNo <> "Application Code" THEN
                    DocNo := "Application Code"
                ELSE
                    CurrReport.SKIP;


                IF DirectTeam = DirectTeam::"Direct+Team" THEN BEGIN
                END;
                TPlots += PlotNo;//alleck 230413
            end;

            trigger OnPostDataItem()
            begin

                IF Summary THEN BEGIN


                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn('Grand Total' + MMCode + '   ' + GetDesc.GetVendorName(MMCode), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalSaleablearea, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalMinAllotmentAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalAmount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalCollection, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalDueAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalGPlot, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);


                END ELSE BEGIN


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
                    TempExcelBuffer.AddColumn('Grand Total' + MMCode + '   ' + GetDesc.GetVendorName(MMCode), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalSaleablearea, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalMinAllotmentAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalAmount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalCollection, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalDueAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(TotalGPlot, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);


                END;
            end;

            trigger OnPreDataItem()
            begin
                TotalSaleablearea := 0;
                TotalAmount := 0;
                TotalCollection := 0;
                TotalDueAmt := 0;
                TotalGPlot := 0;
                TotalMinAllotmentAmt := 0;


                IF DirectTeam = DirectTeam::"Direct+Team" THEN BEGIN
                    SETCURRENTKEY("Application Code", "Associate Code");
                    SETRANGE("Associate Code", MMCode)

                END ELSE BEGIN
                    SETCURRENTKEY("Application Code", "Introducer Code");
                    SETRANGE("Introducer Code", MMCode);
                    // SETRANGE("Associate Code",MMCode);
                END;
                IF Venture <> '' THEN
                    SETRANGE("Project Code", Venture);
                //IF NOT InclOldApps THEN
                SETRANGE("Posting Date", StartDate, EndDate);

                //IF DirectTeam=DirectTeam::"Direct+Team" THEN BEGIN
                CLEAR(Sno);
                CurrReport.CREATETOTALS("New Confirmed Order"."Saleable Area", "New Confirmed Order"."Min. Allotment Amount",
                "New Confirmed Order".Amount, Due);
                CurrReport.CREATETOTALS(Collection, DueTotal);
                //ALLECK 230413 END
                DocNo := '';
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

    trigger OnPostReport()
    begin
        //XlWrkBk.Close(TRUE);
        TempExcelBuffer.CreateNewBook('BookingAllotmentReport');
        TempExcelBuffer.WriteSheet('BookingAllotmentReport', CompanyName(), UserId());
        TempExcelBuffer.SetFriendlyFilename('BookingAllotmentReport');
        TempExcelBuffer.CloseBook();
        //TempExcelBuffer.OpenExcel();
        OStream := TempBlob.CreateOutStream();
        TempExcelBuffer.SaveToStream(OStream, true);
        IF Vendor_11."E-Mail" <> '' THEN
            SendMail();
        TempExcelBuffer.DeleteAll();

    end;

    trigger OnPreReport()
    begin
        CompInfo.GET;
        // IF NOT CREATE(XlApp, TRUE, TRUE) THEN
        //     ERROR('Excel not found.');

        // XlWrkBk := XlApp.Workbooks.Add;
        // XlWrkSht := XlWrkBk.ActiveSheet;
        //  XlApp.Visible := TRUE;

        SaveReportName := '';
        UnitSEtup.GET;

        UnitSEtup.GET;
        MMCode := VendFilters;

        UnitSEtup.TESTFIELD("Report Run End Date_1");
        UnitSEtup.TESTFIELD("Report Run End Date_1");
        UnitSEtup.TESTFIELD(UnitSEtup."Collection Cutoff Date_1");

        DirectTeam := UnitSEtup."Direct/Team_1";
        StartDate := UnitSEtup."Report Run Start Date_1";
        EndDate := UnitSEtup."Report Run End Date_1";
        CollectionDate := UnitSEtup."Collection Cutoff Date_1";
        InclUnClrdChqs := UnitSEtup."Incl. Uncleared Cheque_1";
        ShowAll := UnitSEtup."Show All Applications_1";
        Day_1 := DATE2DMY(UnitSEtup."Report Run End Date_1", 1);
        Month_1 := DATE2DMY(UnitSEtup."Report Run End Date_1", 2);
        Year_1 := DATE2DMY(UnitSEtup."Report Run End Date_1", 3);

        SaveReportName := '50096' + MMCode + '_' + FORMAT(Day_1) + FORMAT(Month_1) + FORMAT(Year_1);//+'.xlsx';
        //XlWrkBk._SaveAs(UnitSEtup."Excel File Save Path" + SaveReportName + '.xlsx');

        "ReportDataforE-Mail_1".RESET;
        IF "ReportDataforE-Mail_1".FINDLAST THEN
            EntryNo := "ReportDataforE-Mail_1"."Entry No."
        ELSE
            EntryNo := 0;

        "ReportDataforE-Mail".INIT;
        "ReportDataforE-Mail"."Entry No." := EntryNo + 1;
        "ReportDataforE-Mail"."Report ID" := 50096;
        "ReportDataforE-Mail"."Associate Code" := MMCode;
        "ReportDataforE-Mail"."Report Name" := SaveReportName;
        "ReportDataforE-Mail"."Report Run Date" := TODAY;
        "ReportDataforE-Mail"."Report Run Time" := TIME;
        "ReportDataforE-Mail"."Report Batch No." := BatchNos;

        "ReportDataforE-Mail".INSERT;


        J := 5;
        k := 1;


        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(CompInfo.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(CompInfo.Address + ' ' + CompInfo."Address 2" + ' ' + CompInfo.City + ' ' + CompInfo."Post Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Date & Time', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(Today) + Format(Time), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Team Wise Plot Allotment', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);


        IF Summary THEN BEGIN


            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Associate Code', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Associate Name', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Extent', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Min.Allotment Amount', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Payable', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Collection/ Paid', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Due', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Allotment', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('User ID', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('User Branch Name', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Team Head ID', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);


        END ELSE BEGIN


            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('Serial No.', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Associate Code', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Associate Name', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Project Name', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Plot No.', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Application No.', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Customer Name', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Customer Mobile No.', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('DOJ', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('LDP', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Extent', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Allotment Amt', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Total Plot cost', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Collection during the period', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Due', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Allotment', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('USer Branch Name', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Team Head ID', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);


        END;
    end;

    var
        Text000: Label 'Invalid Parameters.';
        // XlApp: Automation;
        // XlWrkBk: Automation;
        // XlWrkSht: Automation;
        // XlWrkshts: Automation;
        // XlRange: Automation;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        Filters: Text[30];
        MMCode: Code[20];
        StartDate: Date;
        EndDate: Date;
        ChainMgt: Codeunit "Unit Post";
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
        BatchNos: Code[20];
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
        InclUnClrdChqs: Boolean;
        APE: Record "NewApplication Payment Entry";
        Due: Decimal;
        PlotNo: Decimal;
        TPlots: Decimal;
        DueTotal: Decimal;
        Summary: Boolean;
        GPlot: Decimal;
        AssciateCode: Code[20];
        ArcOrd: Record "Archive Confirmed Order";
        DocNo: Code[20];
        "VendMobNo.": Text[30];
        Memberof: Record "Access Control";
        Companywise: Record "Company wise G/L Account";
        USERID_1: Code[50];
        Branch_1: Text[60];
        APE_1: Record "NewApplication Payment Entry";
        AssHiercyWithApp: Record "Associate Hierarcy with App.";
        TeamHead: Text[60];
        LPDate: Date;
        TotalSaleablearea: Decimal;
        TotalMinAllotmentAmt: Decimal;
        TotalAmount: Decimal;
        TotalCollection: Decimal;
        TotalDueAmt: Decimal;
        TotalGPlot: Decimal;
        TotalAlotment: Decimal;
        VendFilters: Code[20];
        SaveReportName: Code[50];
        Day_1: Integer;
        Month_1: Integer;
        Year_1: Integer;
        "ReportDataforE-Mail_1": Record "Report Data for E-Mail";
        EntryNo: Integer;
        UnitSEtup: Record "Unit Setup";
        "ReportDataforE-Mail": Record "Report Data for E-Mail";
        OStream: OutStream;
        TempBlob: Codeunit "Temp Blob";


    procedure BuildHierarchy(MCode: Code[20])
    var
        Vend: Record Vendor;
        Level: Integer;
    begin
        Vend.RESET;
        Vend.SETCURRENTKEY("BBG Parent Code");
        Vend.SETRANGE("BBG Parent Code", MCode);
        IF Vend.FINDSET THEN
            REPEAT
                IF Chain.GET(Vend."No.") THEN BEGIN
                    Cnt += 1;
                    Chain2.RESET;
                    Chain2.SETRANGE("BBG Parent Code", MCode);
                    Level := Chain2.COUNT + 1;

                    Chain2.GET(MCode);
                    Chain.Priority := Cnt;
                    Chain."E-Mail" := Chain2."E-Mail" + '.' + FORMAT(Level);
                    Chain.MODIFY;

                    Chain2 := Chain;
                    Chain2.INSERT;

                    BuildHierarchy(Vend."No.");
                END;
            UNTIL Vend.NEXT = 0;
    end;

    procedure Setfilters(VendFilter: Code[20]; BatchNo: Code[20])
    begin
        VendFilters := VendFilter;
        BatchNos := BatchNo;
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
        FileNameTxt := 'BookingAllotmentTA' + '.Xlsx';
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

        EmailMessage.Create(Vendor_11."E-Mail", 'Your Booking_Allotment Report', HtmlEmailBody, True);

        EmailMessage.AddAttachment(SaveReportName + '.Xlsx', '.Xlsx', AttachmentStream);
        MailSent := Email.Send(EmailMessage, "Email Scenario"::Default);
    end;

}

