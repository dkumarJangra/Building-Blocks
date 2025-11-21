report 50039 "Project Price Summary"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Dimension Value"; "Dimension Value")
        {
            DataItemTableView = SORTING("Dimension Code", Code)
                                WHERE("Dimension Code" = CONST('PROJECT'),
                                      "IS Project" = CONST(true));
            RequestFilterFields = "Code";
            dataitem("Archive Document Master"; "Archive Document Master")
            {
                DataItemLink = "Project Code" = FIELD(Code);
                DataItemTableView = SORTING("Project Code", "Unit Code", Version)
                                    ORDER(Descending)
                                    WHERE("Unit Code" = FILTER(''),
                                          Code = FILTER(<> 'BSP3'),
                                          "Document Type" = CONST(Charge));

                trigger OnAfterGetRecord()
                begin
                    IF NewVersion <> Version THEN BEGIN
                        NewVersion := Version;
                        BSPAmt := 0;
                        APlan := 0;
                        BPlan := 0;
                        CPlan := 0;
                        BSPAmt := 0;
                        APlan := 0;
                        BPlan := 0;
                        CPlan := 0;

                        ArchiveDocumentMaster.RESET;
                        ArchiveDocumentMaster.SETRANGE("Document Type", "Document Type");
                        ArchiveDocumentMaster.SETRANGE("Project Code", "Project Code");
                        ArchiveDocumentMaster.SETRANGE("Archive Date", FromDate, EndDate);
                        ArchiveDocumentMaster.SETFILTER(Code, '<>%1', 'BSP3');
                        ArchiveDocumentMaster.SETRANGE(Version, Version);
                        ArchiveDocumentMaster.SETRANGE("Unit Code", '');
                        IF ArchiveDocumentMaster.FINDSET THEN
                            REPEAT
                                IF ArchiveDocumentMaster.Code = 'PPLAN' THEN BEGIN
                                    IF ArchiveDocumentMaster."App. Charge Code" = '1006' THEN
                                        APlan := APlan + ArchiveDocumentMaster."Rate/Sq. Yd"
                                    ELSE IF ArchiveDocumentMaster."App. Charge Code" = '1007' THEN
                                        BPlan := BPlan + ArchiveDocumentMaster."Rate/Sq. Yd"
                                    ELSE IF ArchiveDocumentMaster."App. Charge Code" = '1008' THEN
                                        CPlan := CPlan + ArchiveDocumentMaster."Rate/Sq. Yd";
                                END ELSE
                                    BSPAmt := BSPAmt + ArchiveDocumentMaster."Rate/Sq. Yd";
                            UNTIL ArchiveDocumentMaster.NEXT = 0;

                        IF (APlan <> 0) AND (BPlan <> 0) AND (CPlan <> 0) AND (BSPAmt <> 0) THEN BEGIN

                            TempExcelBuffer.NewRow();
                            TempExcelBuffer.AddColumn("Project Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Dimension Value".Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Archive Document Master".Version, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Archive Document Master"."Archive Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(FORMAT(APlan + BSPAmt), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(FORMAT(BPlan + BSPAmt), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(FORMAT(CPlan + BSPAmt), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        END;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Archive Document Master"."Archive Date", FromDate, EndDate);
                    NewVersion := 0;
                end;
            }
            dataitem("Document Master"; "Document Master")
            {
                DataItemLink = "Project Code" = FIELD(Code);
                DataItemTableView = SORTING("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code")
                                    WHERE("Unit Code" = FILTER(''),
                                          Code = FILTER('BSP1'),
                                          "Document Type" = CONST(Charge));

                trigger OnAfterGetRecord()
                begin
                    BSPAmt := 0;
                    APlan := 0;
                    BPlan := 0;
                    CPlan := 0;
                    BSPAmt := 0;
                    APlan := 0;
                    BPlan := 0;
                    CPlan := 0;


                    DocumentMaster.RESET;
                    DocumentMaster.SETRANGE("Document Type", "Document Type");
                    DocumentMaster.SETRANGE("Project Code", "Project Code");
                    DocumentMaster.SETFILTER(Code, '<>%1', 'BSP3');
                    DocumentMaster.SETRANGE("Unit Code", '');
                    IF DocumentMaster.FINDSET THEN
                        REPEAT
                            IF DocumentMaster.Code = 'PPLAN' THEN BEGIN
                                IF DocumentMaster."App. Charge Code" = '1006' THEN
                                    APlan := APlan + DocumentMaster."Rate/Sq. Yd"
                                ELSE IF DocumentMaster."App. Charge Code" = '1007' THEN
                                    BPlan := BPlan + DocumentMaster."Rate/Sq. Yd"
                                ELSE IF DocumentMaster."App. Charge Code" = '1008' THEN
                                    CPlan := CPlan + DocumentMaster."Rate/Sq. Yd";
                            END ELSE
                                BSPAmt := BSPAmt + DocumentMaster."Rate/Sq. Yd";
                        UNTIL DocumentMaster.NEXT = 0;

                    IF (APlan <> 0) AND (BPlan <> 0) AND (CPlan <> 0) AND (BSPAmt <> 0) THEN BEGIN

                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn("Project Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("Dimension Value".Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Format(0), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Today, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(FORMAT(APlan + BSPAmt), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(FORMAT(BPlan + BSPAmt), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(FORMAT(CPlan + BSPAmt), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("From Date"; FromDate)
                {
                    ApplicationArea = All;
                }
                field("To Date"; EndDate)
                {
                    ApplicationArea = All;
                }
            }
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
        CompInfo.GET;
    end;

    trigger OnPostReport()
    begin
        ReportDetailsUpdate.UpdateReportDetails(EntryNo);
        MESSAGE('%1', 'Done');

        TempExcelBuffer.CreateNewBook('Project Price Summary');
        TempExcelBuffer.WriteSheet('Project Price Summary', CompanyName(), UserId());
        TempExcelBuffer.SetFriendlyFilename('Project Price Summary');
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();
        TempExcelBuffer.DeleteAll();
    end;

    trigger OnPreReport()
    begin
        ReportFilters := 'From Date-' + FORMAT(FromDate) + ', To Date-' + FORMAT(EndDate);
        EntryNo := ReportDetailsUpdate.InsertReportDetails('Commission Report', '50011', ReportFilters);


        CompanywiseGLAccount.RESET;
        CompanywiseGLAccount.SETRANGE(CompanywiseGLAccount."MSC Company", TRUE);
        IF CompanywiseGLAccount.FINDFIRST THEN
            IF COMPANYNAME <> CompanywiseGLAccount."Company Code" THEN
                ERROR('Please run this report in-' + CompanywiseGLAccount."Company Code");

        ExportToExcel := TRUE;
        IF ExportToExcel THEN BEGIN

            CompInfo.Get();

            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(CompInfo.Name, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(CompInfo.Address + ' ' + CompInfo."Address 2" + ' ' + CompInfo.City + '-' + CompInfo."Post Code", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('Date & Time', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Format(Today) + Format(Time), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Date);
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('Project Price', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('Project Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Project Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Version', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('A CLP PP', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('B TLP PP', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('C DPP PP', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);


        END;
    end;

    var
        CompInfo: Record "Company Information";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ExportToExcel: Boolean;
        RowNo: Integer;
        K: Integer;
        // XlApp: Automation;
        // XlWrkBk: Automation;
        // XlWrkSht: Automation;
        // XlWrkshts: Automation;
        // XlRange: Automation;
        SNo: Integer;
        FromDate: Date;
        EndDate: Date;
        APlan: Decimal;
        BPlan: Decimal;
        CPlan: Decimal;
        NewVersion: Integer;
        ArchiveDocumentMaster: Record "Archive Document Master";
        DocumentMaster: Record "Document Master";
        BSPAmt: Decimal;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        ReportDetailsUpdate: Codeunit "Report Details Update";
        EntryNo: Integer;
        ReportFilters: Text;
}

