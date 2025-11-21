report 50055 "Bank Transactions Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/Bank Transactions Status.rdl';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(Comp_Name; CompInfo.Name)
            {
            }
            column(Comp_Address; CompInfo.Address + ',' + CompInfo."Address 2" + ',' + CompInfo.City + ',' + CompInfo."Post Code")
            {
            }
            column(Date_; TODAY)
            {
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemTableView = SORTING("Entry No.")
                                    WHERE(Open = CONST(true));
                column(AppNo_; "Application No.")
                {
                }
                column(BankAccNo_; "Bank Account No.")
                {
                }
                column(DocNo_; "Document No.")
                {
                }
                column(PostDate_; FORMAT("Posting Date"))
                {
                }
                column(ChequeNo_; "Cheque No.")
                {
                }
                column(ChequeDate_; FORMAT("Cheque Date"))
                {
                }
                column(Amt_; Amount)
                {
                }
                column(Statmentstatus_; "Statement Status")
                {
                }
                column(StatementNo_; "Statement No.")
                {
                }
                column(TotamAmt_; TotamAmt)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    IF (ShowTransaction = ShowTransaction::Cleared) OR (ShowTransaction = ShowTransaction::Bounced) THEN
                        CurrReport.SKIP
                    ELSE BEGIN
                        TotamAmt := TotamAmt + Amount;
                        // IF ExportToExcel THEN BEGIN
                        //     XlRange := XlWrkSht.Range('A' + FORMAT(k));
                        //     XlRange.Value := FORMAT("Application No.");

                        //     XlRange := XlWrkSht.Range('B' + FORMAT(k));
                        //     XlRange.Value := FORMAT("Bank Account No.");

                        //     XlRange := XlWrkSht.Range('C' + FORMAT(k));
                        //     XlRange.Value := FORMAT("Document No.");

                        //     XlRange := XlWrkSht.Range('D' + FORMAT(k));
                        //     XlRange.Value := "Posting Date";

                        //     XlRange := XlWrkSht.Range('E' + FORMAT(k));
                        //     XlRange.Value := FORMAT("Cheque No.");

                        //     XlRange := XlWrkSht.Range('F' + FORMAT(k));
                        //     XlRange.Value := "Cheque Date";

                        //     XlRange := XlWrkSht.Range('G' + FORMAT(k));
                        //     XlRange.Value := FORMAT(Amount);

                        //     XlRange := XlWrkSht.Range('H' + FORMAT(k));
                        //     XlRange.Value := FORMAT("Statement Status");

                        //     XlRange := XlWrkSht.Range('J' + FORMAT(k));
                        //     XlRange.Value := FORMAT("Statement No.");

                        //     k += 1;
                        // END;
                    END;
                end;

                trigger OnPostDataItem()
                begin

                    // IF ExportToExcel THEN BEGIN

                    //     XlRange := XlWrkSht.Range('E' + FORMAT(k));
                    //     XlRange.Value := 'Total Uncleared Amount';

                    //     XlRange := XlWrkSht.Range('G' + FORMAT(k));
                    //     XlRange.Value := FORMAT(TotamAmt);

                    //     k += 1;
                    // END;
                end;

                trigger OnPreDataItem()
                begin
                    IF ShowAppEntries THEN
                        SETFILTER("Application No.", '<>%1', '');
                    IF BankAccNo <> '' THEN
                        SETRANGE("Bank Account No.", BankAccNo);
                    IF SNo = '' THEN
                        SETRANGE("Posting Date", StartDate, EndDate);
                    IF ProjectCode <> '' THEN
                        SETRANGE("Global Dimension 1 Code", ProjectCode);
                    IF SNo <> '' THEN
                        SETRANGE("Statement No.", SNo);
                    TotamAmt := 0;
                end;
            }
            dataitem(BankAccountLedgerEntry1; "Bank Account Ledger Entry")
            {
                CalcFields = "Value Date";
                DataItemTableView = SORTING("Entry No.")
                                    WHERE(Open = CONST(false),
                                          Bounced = FILTER(false));
                column(AppNo_1; "Application No.")
                {
                }
                column(BankAccNo_1; "Bank Account No.")
                {
                }
                column(DocNo_1; "Document No.")
                {
                }
                column(PostDate_1; FORMAT("Posting Date"))
                {
                }
                column(ChequeNo_1; "Cheque No.")
                {
                }
                column(ChequeDate_1; FORMAT("Cheque Date"))
                {
                }
                column(Amt_1; Amount)
                {
                }
                column(Statmentstatus_1; "Statement Status")
                {
                }
                column(StatementNo_1; "Statement No.")
                {
                }
                column(ValueDate_1; FORMAT(ValueDate1))
                {
                }
                column(UserID_1; BSL."User ID")
                {
                }
                column(TotamAmt1_; TotamAmt1)
                {
                }

                trigger OnAfterGetRecord()
                var
                    ApplicationPaymentEntry: Record "Application Payment Entry";
                begin

                    IF (ShowTransaction = ShowTransaction::UnCleared) OR (ShowTransaction = ShowTransaction::Bounced) THEN
                        CurrReport.SKIP;

                    IF BSL.GET("Bank Account No.", "Statement No.", "Statement Line No.") THEN;

                    ValueDate1 := 0D;
                    ValueDate1 := "Value Date";
                    IF ValueDate1 = 0D THEN BEGIN
                        ApplicationPaymentEntry.RESET;
                        ApplicationPaymentEntry.SETRANGE("Document No.", "Application No.");
                        ApplicationPaymentEntry.SETRANGE("Posted Document No.", "Document No.");
                        IF ApplicationPaymentEntry.FINDFIRST THEN
                            ValueDate1 := ApplicationPaymentEntry."Chq. Cl / Bounce Dt.";
                    END;

                    //Alledk 211021
                    IF ValueDate1 = 0D THEN
                        IF BankAccountLedgerEntry1."New Value Dt." <> 0D THEN
                            ValueDate1 := BankAccountLedgerEntry1."New Value Dt.";
                    //Alledk 211021

                    TotamAmt1 := TotamAmt1 + Amount;

                    // IF ExportToExcel THEN BEGIN
                    //     XlRange := XlWrkSht.Range('A' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Application No.");

                    //     XlRange := XlWrkSht.Range('B' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Bank Account No.");

                    //     XlRange := XlWrkSht.Range('C' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Document No.");

                    //     XlRange := XlWrkSht.Range('D' + FORMAT(k));
                    //     XlRange.Value := "Posting Date";

                    //     XlRange := XlWrkSht.Range('E' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Cheque No.");

                    //     XlRange := XlWrkSht.Range('F' + FORMAT(k));
                    //     XlRange.Value := "Cheque Date";

                    //     XlRange := XlWrkSht.Range('G' + FORMAT(k));
                    //     XlRange.Value := FORMAT(Amount);

                    //     XlRange := XlWrkSht.Range('H' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Statement Status");

                    //     XlRange := XlWrkSht.Range('I' + FORMAT(k));
                    //     XlRange.Value := ValueDate1;
                    //     // XlRange.Value :=Single+FORMAT(ValueDate1);

                    //     XlRange := XlWrkSht.Range('J' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Statement No.");

                    //     XlRange := XlWrkSht.Range('K' + FORMAT(k));
                    //     XlRange.Value := FORMAT(BSL."User ID");

                    //     k += 1;
                    // END;
                end;

                trigger OnPostDataItem()
                begin

                    // IF ExportToExcel THEN BEGIN
                    //     XlRange := XlWrkSht.Range('E' + FORMAT(k));
                    //     XlRange.Value := 'Total Cleared Amount';

                    //     XlRange := XlWrkSht.Range('G' + FORMAT(k));
                    //     XlRange.Value := FORMAT(TotamAmt1);

                    //     k += 1;
                    // END;

                    //MESSAGE('%1',TotamAmt1);
                end;

                trigger OnPreDataItem()
                begin

                    IF ShowAppEntries THEN
                        SETFILTER("Application No.", '<>%1', '');
                    IF BankAccNo <> '' THEN
                        SETRANGE("Bank Account No.", BankAccNo);
                    IF SNo = '' THEN
                        SETRANGE("Posting Date", StartDate, EndDate);
                    IF ProjectCode <> '' THEN
                        SETRANGE("Global Dimension 1 Code", ProjectCode);
                    IF SNo <> '' THEN
                        SETRANGE("Statement No.", SNo);

                    TotamAmt1 := 0;
                end;
            }
            dataitem(BankAccountLedgerEntry2; "Bank Account Ledger Entry")
            {
                CalcFields = "Value Date";
                DataItemTableView = SORTING("Entry No.")
                                    WHERE(Open = FILTER(false),
                                          Bounced = FILTER(true));
                column(AppNo_2; "Application No.")
                {
                }
                column(BankAccNo_2; "Bank Account No.")
                {
                }
                column(DocNo_2; "Document No.")
                {
                }
                column(PostDate_2; FORMAT("Posting Date"))
                {
                }
                column(ChequeNo_2; "Cheque No.")
                {
                }
                column(ChequeDate_2; FORMAT("Cheque Date"))
                {
                }
                column(Amt_2; Amount)
                {
                }
                column(Statmentstatus_2; "Statement Status")
                {
                }
                column(StatementNo_2; "Statement No.")
                {
                }
                column(ValueDate_2; FORMAT(ValueDate2))
                {
                }
                column(UserID_2; BSL1."User ID")
                {
                }
                column(TotamAmt2_; TotamAmt2)
                {
                }

                trigger OnAfterGetRecord()
                var
                    ApplicationPaymentEntry: Record "Application Payment Entry";
                begin

                    IF BSL1.GET("Bank Account No.", "Statement No.", "Statement Line No.") THEN;

                    TotamAmt2 := TotamAmt2 + Amount;

                    ValueDate2 := 0D;
                    ValueDate2 := "Value Date";
                    IF ValueDate2 = 0D THEN BEGIN
                        ApplicationPaymentEntry.RESET;
                        ApplicationPaymentEntry.SETRANGE("Document No.", "Application No.");
                        ApplicationPaymentEntry.SETRANGE("Posted Document No.", "Document No.");
                        IF ApplicationPaymentEntry.FINDFIRST THEN
                            ValueDate2 := ApplicationPaymentEntry."Chq. Cl / Bounce Dt.";
                    END;

                    //Alledk 211021
                    IF ValueDate2 = 0D THEN
                        IF BankAccountLedgerEntry2."New Value Dt." <> 0D THEN
                            ValueDate2 := BankAccountLedgerEntry2."New Value Dt.";
                    //Alledk 211021

                    // IF ExportToExcel THEN BEGIN

                    //     XlRange := XlWrkSht.Range('A' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Application No.");

                    //     XlRange := XlWrkSht.Range('B' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Bank Account No.");

                    //     XlRange := XlWrkSht.Range('C' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Document No.");

                    //     XlRange := XlWrkSht.Range('D' + FORMAT(k));
                    //     XlRange.Value := "Posting Date";

                    //     XlRange := XlWrkSht.Range('E' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Cheque No.");

                    //     XlRange := XlWrkSht.Range('F' + FORMAT(k));
                    //     XlRange.Value := "Cheque Date";

                    //     XlRange := XlWrkSht.Range('G' + FORMAT(k));
                    //     XlRange.Value := FORMAT(Amount);

                    //     XlRange := XlWrkSht.Range('H' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Statement Status");

                    //     XlRange := XlWrkSht.Range('I' + FORMAT(k));
                    //     XlRange.Value := ValueDate2;

                    //     XlRange := XlWrkSht.Range('J' + FORMAT(k));
                    //     XlRange.Value := FORMAT("Statement No.");

                    //     XlRange := XlWrkSht.Range('K' + FORMAT(k));
                    //     XlRange.Value := FORMAT(BSL1."User ID");

                    //     k += 1;
                    // END;
                end;

                trigger OnPostDataItem()
                begin

                    // IF ExportToExcel THEN BEGIN

                    //     XlRange := XlWrkSht.Range('E' + FORMAT(k));
                    //     XlRange.Value := 'Total Bounced Cheques Amount';

                    //     XlRange := XlWrkSht.Range('G' + FORMAT(k));
                    //     XlRange.Value := FORMAT(TotamAmt2);

                    //     k += 1;
                    // END;
                end;

                trigger OnPreDataItem()
                begin
                    IF (ShowTransaction = ShowTransaction::UnCleared) OR (ShowTransaction = ShowTransaction::Cleared) THEN
                        CurrReport.SKIP;

                    IF ShowAppEntries THEN
                        SETFILTER("Application No.", '<>%1', '');
                    IF BankAccNo <> '' THEN
                        SETRANGE("Bank Account No.", BankAccNo);
                    IF SNo = '' THEN
                        SETRANGE("Posting Date", StartDate, EndDate);
                    IF ProjectCode <> '' THEN
                        SETRANGE("Global Dimension 1 Code", ProjectCode);
                    IF SNo <> '' THEN
                        SETRANGE("Statement No.", SNo);
                    TotamAmt2 := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                VLEntry_1: Record "Vendor Ledger Entry";
            begin
            end;

            trigger OnPostDataItem()
            begin
                Footer1 := 0;
                Footer2 := 0;
                Footer3 := 0;

                IF (ShowTransaction = ShowTransaction::UnCleared) OR (ShowTransaction = ShowTransaction::" ") THEN BEGIN
                    Footer1 := 1;
                    // IF ExportToExcel THEN BEGIN
                    //     IF (ShowTransaction = ShowTransaction::UnCleared) OR (ShowTransaction = ShowTransaction::" ") THEN BEGIN
                    //         XlRange := XlWrkSht.Range('G' + FORMAT(k));
                    //         XlRange.Value := 'Total UnCleared Amount';

                    //         XlRange := XlWrkSht.Range('I' + FORMAT(k));
                    //         XlRange.Value := FORMAT(TotamAmt);

                    //         k += 1;
                    //     END;
                    // END;
                END;

                IF (ShowTransaction = ShowTransaction::Cleared) OR (ShowTransaction = ShowTransaction::" ") THEN BEGIN
                    Footer2 := 1;
                    // IF ExportToExcel THEN BEGIN
                    //     IF (ShowTransaction = ShowTransaction::Cleared) OR (ShowTransaction = ShowTransaction::" ") THEN BEGIN
                    //         XlRange := XlWrkSht.Range('G' + FORMAT(k));
                    //         XlRange.Value := 'Total Cleared Amount';

                    //         XlRange := XlWrkSht.Range('I' + FORMAT(k));
                    //         XlRange.Value := FORMAT(TotamAmt1);

                    //         k += 1;
                    //     END;
                    // END;
                END;

                IF (ShowTransaction = ShowTransaction::Bounced) OR (ShowTransaction = ShowTransaction::" ") THEN BEGIN
                    Footer3 := 1;
                    // IF ExportToExcel THEN BEGIN
                    //     IF (ShowTransaction = ShowTransaction::Bounced) OR (ShowTransaction = ShowTransaction::" ") THEN BEGIN
                    //         XlRange := XlWrkSht.Range('G' + FORMAT(k));
                    //         XlRange.Value := 'Total Bounced Cheques Amount';

                    //         XlRange := XlWrkSht.Range('I' + FORMAT(k));
                    //         XlRange.Value := FORMAT(TotamAmt2);

                    //         k += 1;
                    //     END;
                    // END;
                END;
            end;

            trigger OnPreDataItem()
            var
                AssadjEntry_1: Record "Associate OD Ajustment Entry";
            begin
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Bank No."; BankAccNo)
                {
                    TableRelation = "Bank Account";
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CLEAR(SNo);
                    end;
                }
                field("Project Code"; ProjectCode)
                {
                    TableRelation = "Responsibility Center 2";
                    ApplicationArea = All;
                }
                field("Start Date"; StartDate)
                {
                    ApplicationArea = All;
                }
                field("End Date"; EndDate)
                {
                    ApplicationArea = All;
                }
                field("Filter Transactions"; ShowTransaction)
                {
                    ApplicationArea = All;
                }
                field("Show Application Entries"; ShowAppEntries)
                {
                    ApplicationArea = All;
                }
                field("Statement No."; SNo)
                {
                    ApplicationArea = All;
                }
                field("Export To Excel"; ExportToExcel)
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
        CompInfo.CALCFIELDS(Picture);
    end;

    trigger OnPostReport()
    begin
        ReportDetailsUpdate.UpdateReportDetails(EntryNo);
    end;

    trigger OnPreReport()
    begin
        ReportFilters := 'Bank No.-' + BankAccNo + ', Project Code-' + FORMAT(ProjectCode) + ', Start Date-' + FORMAT(StartDate) + ', End Date' + FORMAT(EndDate) + ', Filter Transactions-' + FORMAT(ShowTransaction) +
        ', Show Application Entries-' + FORMAT(ShowAppEntries) + ', Statement No.-' + FORMAT(SNo);
        EntryNo := ReportDetailsUpdate.InsertReportDetails('Bank Transactions Status', '50055', ReportFilters);

        IF SNo = '' THEN
            IF (StartDate = 0D) OR (EndDate = 0D) THEN
                ERROR('Please enter Start Date and End Date');

        CompInfo.GET;
        // IF ExportToExcel THEN BEGIN
        //     IF NOT CREATE(XlApp, TRUE, TRUE) THEN
        //         ERROR('Excel not found.');

        //     XlWrkBk := XlApp.Workbooks.Add;
        //     XlWrkSht := XlWrkBk.ActiveSheet;
        //     XlApp.Visible := TRUE;

        //     k := 1;
        //     XlRange := XlWrkSht.Range('A' + FORMAT(k));
        //     XlRange.Value := CompInfo.Name;
        //     k += 1;
        //     XlRange := XlWrkSht.Range('A' + FORMAT(k));
        //     XlRange.Value := CompInfo.Address + ' ' + CompInfo."Address 2" + ' ' + CompInfo.City + ' ' + CompInfo."Post Code";
        //     k += 1;

        //     XlRange := XlWrkSht.Range('A' + FORMAT(k));
        //     XlRange.Value := 'Date & Time';
        //     XlRange := XlWrkSht.Range('B' + FORMAT(k));
        //     XlRange.Value := FORMAT(TODAY) + FORMAT(TIME);
        //     k += 1;

        //     XlRange := XlWrkSht.Range('A' + FORMAT(k));
        //     XlRange.Value := 'Bank Transactions Status';
        //     k += 1;


        //     XlRange := XlWrkSht.Range('A' + FORMAT(k));
        //     XlRange.Value := 'Application No.';

        //     XlRange := XlWrkSht.Range('B' + FORMAT(k));
        //     XlRange.Value := 'Bank Account No.';

        //     XlRange := XlWrkSht.Range('C' + FORMAT(k));
        //     XlRange.Value := 'Document No.';

        //     XlRange := XlWrkSht.Range('D' + FORMAT(k));
        //     XlRange.Value := 'Posting Date';

        //     XlRange := XlWrkSht.Range('E' + FORMAT(k));
        //     XlRange.Value := 'Cheque No.';

        //     XlRange := XlWrkSht.Range('F' + FORMAT(k));
        //     XlRange.Value := 'Cheque Date';

        //     XlRange := XlWrkSht.Range('G' + FORMAT(k));
        //     XlRange.Value := 'Amount';

        //     XlRange := XlWrkSht.Range('H' + FORMAT(k));
        //     XlRange.Value := 'Entry Status';

        //     XlRange := XlWrkSht.Range('I' + FORMAT(k));
        //     XlRange.Value := 'Clearence Date';

        //     XlRange := XlWrkSht.Range('J' + FORMAT(k));
        //     XlRange.Value := 'Statement No.';

        //     XlRange := XlWrkSht.Range('K' + FORMAT(k));
        //     XlRange.Value := 'User ID';

        //     k += 1;
        // END;
    end;

    var
        Text000: Label 'Invalid Parameters.';
        // XlApp: Automation;
        // XlWrkBk: Automation;
        // XlWrkSht: Automation;
        // XlWrkshts: Automation;
        // XlRange: Automation;
        BLE: Record "Bank Account Ledger Entry";
        ShowAppEntries: Boolean;
        BankAccNo: Code[20];
        StartDate: Date;
        EndDate: Date;
        ProjectCode: Code[20];
        CompInfo: Record "Company Information";
        k: Integer;
        J: Integer;
        FilterUsed: Text[250];
        ExportToExcel: Boolean;
        ShowTransaction: Option " ",UnCleared,Cleared,Bounced;
        BankAccs1: Record "Bank Account Statement";
        SNo: Code[20];
        BSL: Record "Bank Account Statement Line";
        BSL1: Record "Bank Account Statement Line";
        Footer1: Integer;
        Footer2: Integer;
        Footer3: Integer;
        TotamAmt: Decimal;
        TotamAmt1: Decimal;
        TotamAmt2: Decimal;
        Single: Label '''';
        ValueDate1: Date;
        ValueDate2: Date;
        ReportDetailsUpdate: Codeunit "Report Details Update";
        EntryNo: Integer;
        ReportFilters: Text;
}

