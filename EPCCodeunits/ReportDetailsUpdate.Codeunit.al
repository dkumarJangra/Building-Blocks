codeunit 50018 "Report Details Update"
{

    trigger OnRun()
    begin
    end;

    var
        EntryNo: Integer;
        ReportLogDetails1: Record "Report Log Details";
        Users: Record User;
        UserSetup: Record "User Setup";
        ResponsibilityCenter: Record "Responsibility Center 1";


    procedure InsertReportDetails(ReportName: Text; ReportID: Code[10]; ReportFilters: Text): Integer
    var
        ReportLogDetails: Record "Report Log Details";
    begin
        ReportLogDetails.RESET;
        IF ReportLogDetails.FINDLAST THEN
            EntryNo := ReportLogDetails."Entry No."
        ELSE
            EntryNo := 0;

        ReportLogDetails1.INIT;
        ReportLogDetails1."Entry No." := EntryNo + 1;
        ReportLogDetails1."Report Name" := ReportName;
        ReportLogDetails1."Report ID" := ReportID;
        ReportLogDetails1."Report Run Start Date" := TODAY;
        ReportLogDetails1."Report Run Start Time" := TIME;
        ReportLogDetails1."USER ID" := USERID;
        Users.RESET;
        Users.SETRANGE("User Name", USERID);
        IF Users.FINDFIRST THEN
            ReportLogDetails1."USER Name" := Users."Full Name";
        ReportLogDetails1."Company Name" := COMPANYNAME;
        UserSetup.RESET;
        IF UserSetup.GET(USERID) THEN BEGIN
            ReportLogDetails1."Responsibility Center" := UserSetup."Responsibility Center";
            ResponsibilityCenter.RESET;
            IF ResponsibilityCenter.GET(UserSetup."Responsibility Center") THEN
                ReportLogDetails1."Responsibility Center Name" := ResponsibilityCenter.Name;
        END;
        ReportLogDetails1."Report Filters" := COPYSTR(ReportFilters, 1, 249);
        ReportLogDetails1."Report Filters 2" := COPYSTR(ReportFilters, 250, 248);
        ReportLogDetails1.INSERT;
        COMMIT;
        EXIT(ReportLogDetails1."Entry No.");
    end;


    procedure UpdateReportDetails(EntryNo: Integer)
    var
        ReportLogDetails: Record "Report Log Details";
    begin
        ReportLogDetails.RESET;
        ReportLogDetails.SETRANGE("Entry No.", EntryNo);
        IF ReportLogDetails.FINDFIRST THEN BEGIN
            ReportLogDetails."Report Run End Date" := TODAY;
            ReportLogDetails."Report Run End Time" := TIME;
            ReportLogDetails.MODIFY;
        END;
    end;
}

