report 97846 "BBG Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EPCReports/BBG Trial Balance.rdl';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            column(CompInfoName_; CompInfo.Name)
            {
            }
            column(Address_; CompInfo.Address + ' ' + CompInfo."Address 2" + ' ' + CompInfo.City + ' ' + CompInfo."Post Code" + ' ' + CompInfo.County)
            {
            }
            column(Filters; "G/L Account".TABLECAPTION + ': ' + GLFilter + ' ' + DimValueName)
            {
            }
            column(Date_; TODAY)
            {
            }
            column(UserID_; USERID)
            {
            }
            column(LedgerCode_; "G/L Account"."No.")
            {
            }
            column(AccountHead_; "G/L Account".Name)
            {
            }
            column(OpeningDr_; TotalOPeningDebitNetChange)
            {
            }
            column(OpeningCr_; TotalOpeningCreditNetChange)
            {
            }
            column(TransactionDr_; TotalDebitNetChange)
            {
            }
            column(TransactionCr_; TotalCreditNetChange)
            {
            }
            column(ClosingDr_; TotalDebitBalanceAtDate)
            {
            }
            column(ClosingCr_; TotalCreditBalanceAtDate)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TotalOPeningDebitNetChange := 0;
                TotalOpeningCreditNetChange := 0;
                TotalDebitNetChange := 0;
                TotalCreditNetChange := 0;
                TotalDebitBalanceAtDate := 0;
                TotalCreditBalanceAtDate := 0;
                GLAccount.RESET;
                GLAccount.SETRANGE("Date Filter", 0D, CLOSINGDATE(StartDate - 1));
                GLAccount.SETRANGE(GLAccount."No.", "No.");
                GLAccount.SETRANGE("Account Type", GLAccount."Account Type"::Posting);
                IF DimValue <> '' THEN
                    GLAccount.SETFILTER("Global Dimension 1 Filter", DimValue);
                IF GLAccount.FINDSET THEN
                    REPEAT
                        GLAccount.CALCFIELDS("Net Change", "Balance at Date");
                        IF GLAccount."Balance at Date" > 0 THEN
                            TotalOPeningDebitNetChange += GLAccount."Balance at Date"
                        ELSE
                            TotalOpeningCreditNetChange += -GLAccount."Balance at Date";
                    UNTIL GLAccount.NEXT = 0;

                CALCFIELDS("Net Change", "Balance at Date");

                IF "G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting THEN BEGIN
                    IF "Net Change" > 0 THEN
                        TotalDebitNetChange += "G/L Account"."Net Change"
                    ELSE
                        TotalCreditNetChange += -"G/L Account"."Net Change";
                END;

                IF "G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting THEN BEGIN
                    IF "Balance at Date" > 0 THEN
                        TotalDebitBalanceAtDate += "G/L Account"."Balance at Date"
                    ELSE
                        TotalCreditBalanceAtDate += -"G/L Account"."Balance at Date";
                END;



                IF SHowAccountwithBalance THEN BEGIN
                    IF ("G/L Account"."Balance at Date" = 0) AND ("G/L Account"."Net Change" = 0) AND (GLAccount."Balance at Date" = 0) THEN
                        CurrReport.SKIP;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Show Account With Balance"; SHowAccountwithBalance)
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
        CompanywiseGLAccount.RESET;
        CompanywiseGLAccount.SETRANGE(CompanywiseGLAccount."MSC Company", TRUE);
        IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
            UserSetup.RESET;
            UserSetup.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
            UserSetup.SETRANGE("User ID", USERID);
            UserSetup.SETRANGE("Report ID - 97846 - Run", TRUE);
            IF NOT UserSetup.FINDFIRST THEN
                ERROR('Please contact Admin');
        END;
    end;

    trigger OnPostReport()
    begin
        ReportDetailsUpdate.UpdateReportDetails(EntryNo);
    end;

    trigger OnPreReport()
    begin
        ReportFilters := "G/L Account".GETFILTERS + ', Show Account With Balance-' + FORMAT(SHowAccountwithBalance);
        EntryNo := ReportDetailsUpdate.InsertReportDetails('BBG Trial Balance', '97846', ReportFilters);

        GLFilter := "G/L Account".GETFILTERS;
        PeriodText := "G/L Account".GETFILTER("Date Filter");
        StartDate := "G/L Account".GETRANGEMIN("G/L Account"."Date Filter");
        DimValue := "G/L Account".GETFILTER("G/L Account"."Global Dimension 1 Filter");

        CompInfo.GET;
    end;

    var
        TempExcelBuffer1: Record "Excel Buffer" temporary;
        GLFilter: Text[250];
        PeriodText: Text[30];
        PrintToExcel: Boolean;
        CurrFormat: Text[30];
        TotalDebitNetChange: Decimal;
        TotalCreditNetChange: Decimal;
        TotalDebitBalanceAtDate: Decimal;
        TotalCreditBalanceAtDate: Decimal;
        StartDate: Date;
        TotalOPeningDebitNetChange: Decimal;
        TotalOpeningCreditNetChange: Decimal;
        GLAccount: Record "G/L Account";
        DimValue: Code[250];
        RowNo: Integer;
        Columnno: Integer;
        "Export To Excel": Boolean;
        CompInfo: Record "Company Information";
        OpeningDB: Decimal;
        OpeningCR: Decimal;
        ClosingDB: Decimal;
        ClosingCr: Decimal;
        SHowAccountwithBalance: Boolean;
        RecDimValue: Record "Dimension Value";
        DimValueName: Text[150];
        GeneralLedgerSetup: Record "General Ledger Setup";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        UserSetup: Record "User Setup";
        ReportFilters: Text;
        EntryNo: Integer;
        ReportDetailsUpdate: Codeunit "Report Details Update";
}

