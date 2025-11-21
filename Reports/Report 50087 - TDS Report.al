report 50087 "TDS Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/TDS Report.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("TDS Entry"; "TDS Entry")//13729
        {
            DataItemTableView = SORTING("Entry No.")
                                ORDER(Ascending);
            RequestFilterFields = "Posting Date";
            column(FilterDate; FilterDate)
            {
            }
            column(Posting_Date; "TDS Entry"."Posting Date")
            {
            }
            column(TDS_Section; '')//"TDS Entry"."TDS Section"
            {
            }
            column(TDS_Group; '')//"TDS Entry"."TDS Group"
            {
            }
            column(Vendor_Code; "TDS Entry"."Party Code")
            {
            }
            column(PartyName; PartyName)
            {
            }
            column(DocumentNo; "TDS Entry"."Document No.")
            {
            }
            column(TDSBaseAmt; "TDS Entry"."TDS Base Amount")
            {
            }
            column(TDSAmt; "TDS Entry"."TDS Amount")
            {
            }
            column(PAN; "TDS Entry"."Deductee PAN No.")//"TDS Entry"."Deductee P.A.N. No."
            {
            }
            column(TdsPercentage; "TDS Entry"."TDS %")
            {
            }
            column(TDS_Nature_Of_Deduction; '')//"TDS Entry"."TDS Nature of Deduction"
            {
            }
            column(Assessee_Code; "TDS Entry"."Assessee Code")
            {
            }
            column(BRS_Code; "TDS Entry"."BSR Code")
            {
            }
            column(Challan_No; "TDS Entry"."Challan No.")
            {
            }
            column(Challan_Date; "TDS Entry"."Challan Date")
            {
            }
            column(Bank_Name; "TDS Entry"."Bank Name")
            {
            }
            column(IsTDSPaid; "TDS Entry"."TDS Paid")
            {
            }
            column(CompName; CompInfo.Name + ' ' + CompInfo."Name 2")
            {
            }
            column(CompAddress; CompInfo.Address + ', ' + CompInfo."Address 2")
            {
            }
            column(CompCity; CompInfo.City + ' - ' + CompInfo."Post Code")
            {
            }
            column(CompPhoneCompanyInfo__L_S_T__No__yCompanyInfo__L_S_T__No__; CompInfo."Phone No.")
            {
            }
            column(CompLogo; CompInfo.Picture)
            {
            }
            column(ComEMail; CompInfo."E-Mail")
            {
            }
            column(CompWebPage; CompInfo."Home Page")
            {
            }
            column(CompanyInfo__E_C_C__No__; '')//CompInfo."E.C.C. No."
            {
            }
            column(CompanyInfo__P_A_N__No__; CompInfo."P.A.N. No.")
            {
            }
            column(CompanyInfo__C_S_T_No__; '')//CompInfo."C.S.T No."
            {
            }
            column(CompanyInfo__L_S_T__No__; '')//CompInfo."L.S.T. No."
            {
            }

            trigger OnAfterGetRecord()
            begin
                Vendor.RESET;
                Vendor.SETRANGE("No.", "Party Code");
                IF Vendor.FINDFIRST THEN BEGIN
                    PartyName := Vendor.Name;
                END;
            end;

            trigger OnPreDataItem()
            begin
                //alle_271216_nikumar
                SETRANGE("Posting Date", StartDate, EndDate);
                //alle_271216_nikumar
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Start Date"; StartDate)
                {
                    ApplicationArea = All;
                }
                field("End Date"; EndDate)
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

    trigger OnPostReport()
    begin
        ReportDetailsUpdate.UpdateReportDetails(EntryNo);
    end;

    trigger OnPreReport()
    begin

        IF StartDate = 0D THEN
            ERROR('Please enter the start date');
        IF EndDate = 0D THEN
            ERROR('Please enter the end date');

        FilterDate := FORMAT(StartDate) + '..' + FORMAT(EndDate);

        ReportFilters := 'Start Date-' + FORMAT(StartDate) + '.. End Date -' + FORMAT(EndDate);
        EntryNo := ReportDetailsUpdate.InsertReportDetails('TDS Report', '50087', ReportFilters);
    end;

    var
        PartyName: Text[50];
        Vendor: Record Vendor;
        CompInfo: Record "Company Information";
        StartDate: Date;
        EndDate: Date;
        FilterDate: Text;
        ReportDetailsUpdate: Codeunit "Report Details Update";
        EntryNo: Integer;
        ReportFilters: Text;
}

