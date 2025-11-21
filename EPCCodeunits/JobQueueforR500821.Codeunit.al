codeunit 97746 "Job Queue for R-50082_1"
{
    TableNo = Vendor;

    trigger OnRun()
    begin
        //   REPORT.RUN(50165,FALSE,FALSE,Rec);
        CLEAR(NBATReport);
        Vend.RESET;
        Vend.SETRANGE("No.", VendFilters);
        IF Vend.FINDFIRST THEN
            NBATReport.Setfilters(VendFilters, BatchNos);
        NBATReport.RUN();
    end;

    var
        Vend: Record Vendor;
        NBATReport: Report "New CommissionEligibility50082";
        VendFilters: Code[20];
        BatchNos: Code[20];


    procedure Setfilteres(VendFilter: Code[20]; BatchNo: Code[20])
    begin
        VendFilters := VendFilter;
        BatchNos := BatchNo;
    end;
}

