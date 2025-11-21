codeunit 97745 "Job Queue for R-50096_1"
{
    TableNo = Vendor;

    trigger OnRun()
    begin
        //   REPORT.RUN(50165,FALSE,FALSE,Rec);
        CLEAR(NBATReport);
        Vend.RESET;
        Vend.SETRANGE("No.", VendFilters);
        IF Vend.FINDFIRST THEN BEGIN
            NBATReport.Setfilters(VendFilters, BatchNos);
            NBATReport.RUN();
        END;
    end;

    var
        Vend: Record Vendor;
        NBATReport: Report "New Booking/Allotment/TA50096";
        VendFilters: Code[20];
        BatchNos: Code[20];


    procedure Setfilteres(VendFilter: Code[20]; BatchNo: Code[20])
    begin
        VendFilters := VendFilter;
        BatchNos := BatchNo;
    end;
}

