report 97833 "New Bank Reconciliation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EPCReports/New Bank Reconciliation.rdl';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(CompanyName_; "Company Information".Name)
            {
            }
            column(CompAddress_; "Company Information".Address)
            {
            }
            column(CompAddress_2_; "Company Information"."Address 2")
            {
            }
            column(CompPhone_; "Company Information"."Phone No.")
            {
            }
            column(disp_diff_; disp_diff)
            {
            }
            column(disp_cleared_; disp_cleared)
            {
            }
            column(DateFrom_; FORMAT(DateFrom))
            {
            }
            column(DateTo_; FORMAT(DateTo))
            {
            }
            column(SNo_; SNo)
            {
            }
            column(BankAccountNAme_; BankAcc_1.Name)
            {
            }
            column(BankAccountNo_; BankAcc_1."No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF BankAccNo = '' THEN
                    ERROR('Please select Bank Account No.');

                BankAcc_1.RESET;
                IF BankAcc_1.GET(BankAccNo) THEN;
            end;

            trigger OnPreDataItem()
            begin
                Showtable := 0;
                IF disp_cleared THEN
                    Showtable := 1
            end;
        }
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = SORTING("No.");
            column(Showtable_; Showtable)
            {
            }
            dataitem("Bank Ledger Entry Debit"; "Bank Account Ledger Entry")
            {
                CalcFields = "Value Date";
                DataItemLink = "Bank Account No." = FIELD("No.");
                DataItemTableView = SORTING("Bank Account No.", "Posting Date")
                                    WHERE(Amount = FILTER(> 0),
                                          Reversed = FILTER(false));
                column(PostDate_; FORMAT("Posting Date"))
                {
                }
                column(DocNo_; "Document No.")
                {
                }
                column(Desc_; Description)
                {
                }
                column(ChequeNo_; "Cheque No.")
                {
                }
                column(DebitAmt_; "Debit Amount")
                {
                }
                column(ShowDebitBLE_; ShowDebitBLE)
                {
                }
                column(TotalD_; TotalD)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CALCFIELDS("Value Date");
                    IF ("Bank Ledger Entry Debit"."Value Date" = 0D) OR ("Bank Ledger Entry Debit"."Value Date" > DateTo) THEN BEGIN
                        ShowDebitBLE := 1;
                        TotalD := TotalD + "Debit Amount";
                    END ELSE BEGIN
                        CurrReport.SKIP;
                        ShowDebitBLE := 0;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    "Bank Ledger Entry Debit".SETRANGE("Posting Date", 0D, DateTo);
                end;
            }
            dataitem("Bank Ledger Entry Credit"; "Bank Account Ledger Entry")
            {
                CalcFields = "Value Date";
                DataItemLink = "Bank Account No." = FIELD("No.");
                DataItemTableView = SORTING("Bank Account No.", "Posting Date")
                                    WHERE(Amount = FILTER(< 0),
                                          Reversed = FILTER(false));
                column(BLECredit_PostDate; FORMAT("Posting Date"))
                {
                }
                column(BLECredit_DocDate; "Document No.")
                {
                }
                column(BLECredit_Desc; Description)
                {
                }
                column(BLECredit_ChequeNo; "Cheque No.")
                {
                }
                column(BLECredit_CreditAmt; "Credit Amount")
                {
                }
                column(TotalC_; TotalC)
                {
                }
                column(ShowCreditBLE_; ShowCreditBLE)
                {
                }

                trigger OnAfterGetRecord()
                var
                    RecordFind: Boolean;
                begin
                    CALCFIELDS("Value Date");
                    IF ("Value Date" = 0D) OR ("Value Date" > DateTo) THEN BEGIN
                        ShowCreditBLE := 1;
                        TotalC := TotalC + "Credit Amount";
                    END ELSE BEGIN
                        CurrReport.SKIP;
                        ShowCreditBLE := 0;
                    END;
                end;

                trigger OnPreDataItem()
                begin

                    SETRANGE("Posting Date", 0D, DateTo);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Total_amt_cr := 0;
                Total_amt_dr := 0;
                Total_bal_amt := 0;
                BAL_AMT_PRT := 0;
                BalBook := 0;

                BNKaccLedEnt.RESET;
                BNKaccLedEnt.SETCURRENTKEY("Bank Account No.", "Posting Date");
                BNKaccLedEnt.SETRANGE("Bank Account No.", "No.");
                BNKaccLedEnt.SETRANGE("Posting Date", DateFrom, DateTo);
                IF BNKaccLedEnt.FINDSET THEN
                    REPEAT
                        BookTotal := BookTotal + BNKaccLedEnt.Amount;
                    UNTIL BNKaccLedEnt.NEXT = 0;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("No.", BankAccNo);
            end;
        }
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(BookTotal_; BookTotal)
            {
            }
            column(Total_amt_dr_TotalOpen_; Total_amt_dr + TotalOpen)
            {
            }
            column(Total_amt_cr_TotalOpen2_TotalC_1; Total_amt_cr + TotalOpen2 + TotalC_1)
            {
            }
            column(ADD_Crdt_diff_; ADD_Crdt_diff)
            {
            }
            column(ADD_Debit_diff_; ADD_Debit_diff)
            {
            }
            column(Gtotal_; Gtotal)
            {
            }

            trigger OnAfterGetRecord()
            begin

                BAL_AMT_PRT := Total_amt_dr - Total_amt_cr;
                BAL_AMT_PRT := "BAL As Per Ledger" - BAL_AMT_PRT;



                IF BAL_AMT_PRT < 0 THEN BEGIN
                    CBAL_DC := 'Cr.';
                    BAL_AMT_PRT := ABS(BAL_AMT_PRT);
                END
                ELSE
                    CBAL_DC := 'Dr.';

                Total_amt_dr := TotalD;
                Total_amt_cr := TotalC;

                Gtotal := BookTotal - Total_amt_dr - TotalOpen + Total_amt_cr + TotalOpen2 + ADD_Crdt_diff - ADD_Debit_diff + TotalC_1;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Bank Account No."; BankAccNo)
                {
                    TableRelation = "Bank Account"."No.";
                    ApplicationArea = All;
                }
                field("To Date"; DateTo)
                {
                    ApplicationArea = All;
                }
                field("Statement No."; SNo)
                {
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        BankAccs1.RESET;
                        IF PAGE.RUNMODAL(Page::"Bank Account Statement List", BankAccs1) = ACTION::LookupOK THEN BEGIN
                            SNo := BankAccs1."Statement No.";
                            stdate := BankAccs1."Statement Date";
                        END;
                    end;
                }
                field("Statement Date"; stdate)
                {
                    Visible = false;
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
            UserSetup.SETRANGE("Report ID - 97832 - Run", TRUE);
            IF NOT UserSetup.FINDFIRST THEN
                ERROR('Please contact Admin');
        END;
        DateFrom := 20010101D;//010101D
    end;

    trigger OnPostReport()
    begin
        ReportDetailsUpdate.UpdateReportDetails(EntryNo);
    end;

    trigger OnPreReport()
    begin
        ReportFilters := 'Bank Account No.-' + BankAccNo + ', From Date-' + FORMAT(DateFrom) + ', To Date-' + FORMAT(DateTo);// + ', Statement No.' + FORMAT(SNo) +', Statement Date' + FORMAT(stdate) + ', Display Clearing :'+FORMAT(disp_cleared) +
        //', Display Diff. :'+FORMAT(disp_diff);
        EntryNo := ReportDetailsUpdate.InsertReportDetails('Bank Reconciliation', '97833', ReportFilters);
    end;

    var
        DateFrom: Date;
        DateTo: Date;
        chk_open: Boolean;
        Total_amt_cr: Decimal;
        Total_amt_dr: Decimal;
        Total_bal_amt: Decimal;
        CBAL_DC: Text[4];
        BAL_LAST_STATEMENT: Decimal;
        BAL_AMT_PRT: Decimal;
        "bank reconciliation line rec": Record "Bank Account Statement Line";
        "Bank Account Statement": Record "Bank Account Statement";
        "min account statement date": Date;
        "BAL As Per Ledger": Decimal;
        CBAL_DC1: Text[4];
        CBAL_DC2: Text[4];
        bankaccstatementline: Record "Bank Account Statement Line";
        B_repass: Boolean;
        ADD_Crdt_diff: Decimal;
        ADD_Debit_diff: Decimal;
        BNKaccLedEnt: Record "Bank Account Ledger Entry";
        pd1: Date;
        pd2: Date;
        sh1: Text[50];
        sh2: Text[50];
        disp_diff: Boolean;
        disp_cleared: Boolean;
        BookTotal: Decimal;
        Gtotal: Decimal;
        TotalD: Decimal;
        TotalC: Decimal;
        TotalIC: Decimal;
        TotalDC: Decimal;
        BankAccs: Record "Bank Account Statement";
        BalBook: Decimal;
        stdate: Date;
        SNo: Code[20];
        BankAccs1: Record "Bank Account Statement";
        BankAccountStatement: Record "Bank Account Statement";
        CompInfo: Record "Company Information";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ExportToExcel: Boolean;
        RowNo: Integer;
        BankAccountStatement2: Record "Bank Account Statement";
        TotalOpen: Decimal;
        TotalOpen2: Decimal;
        TotalC_1: Decimal;
        text1: Label 'From Date is not proper';
        text2: Label 'To Date is not proper';
        ShowDebitBLE: Integer;
        ShowCreditBLE: Integer;
        ShowBASLine: Integer;
        ShowBLSL0: Integer;
        BankAccNo: Code[20];
        BankAcc_1: Record "Bank Account";
        Showtable: Integer;
        FindRecords: Integer;
        ShowBASLTable1: Integer;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        UserSetup: Record "User Setup";
        ReportDetailsUpdate: Codeunit "Report Details Update";
        ReportFilters: Text;
        EntryNo: Integer;
}

