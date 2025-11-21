codeunit 97740 "Job Queue for R-50011"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        UnitSetup.GET;
        UnitSetup.TESTFIELD(UnitSetup."Report Batch No. Series");
        BatchNo := '';
        BatchNo := NoseriesMGT.GetNextNo(UnitSetup."Report Batch No. Series", TODAY, TRUE);
        COMMIT;
        Vend.RESET;
        Vend.SETCURRENTKEY("BBG Commission Report for Associat");
        Vend.SETRANGE("BBG Report 50011 Run for Associate", TRUE);
        IF Vend.FINDSET THEN
            REPEAT
                CLEAR(Codeunit_12);
                Codeunit_12.Setfilteres(Vend."No.", BatchNo, 0);
                IF NOT Codeunit_12.RUN(Vend) THEN BEGIN
                    "ReportDataforE-Mail_1".RESET;
                    IF "ReportDataforE-Mail_1".FINDLAST THEN
                        EntryNo := "ReportDataforE-Mail_1"."Entry No."
                    ELSE
                        EntryNo := 0;

                    "ReportDataforE-Mail".INIT;
                    "ReportDataforE-Mail"."Entry No." := EntryNo + 1;
                    "ReportDataforE-Mail"."Report ID" := 50011;
                    "ReportDataforE-Mail"."Associate Code" := Vend."No.";
                    "ReportDataforE-Mail"."Error Message" := COPYSTR(GETLASTERRORTEXT, 1, 200);
                    "ReportDataforE-Mail"."Report Run Date" := TODAY;
                    "ReportDataforE-Mail"."Report Run Time" := TIME;
                    "ReportDataforE-Mail"."Report Batch No." := BatchNo;
                    "ReportDataforE-Mail".INSERT;
                    COMMIT;
                END;

            UNTIL Vend.NEXT = 0;
    end;

    var
        Vend: Record Vendor;
        Codeunit_12: Codeunit "Job Queue for R-50011_1";
        "ReportDataforE-Mail": Record "Report Data for E-Mail";
        BatchNo: Code[20];
        NoseriesMGT: Codeunit NoSeriesManagement;
        UnitSetup: Record "Unit Setup";
        "ReportDataforE-Mail_1": Record "Report Data for E-Mail";
        EntryNo: Integer;
}

