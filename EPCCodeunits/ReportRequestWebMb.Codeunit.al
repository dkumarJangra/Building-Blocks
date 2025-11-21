codeunit 97770 "Report Request Web/Mb"
{

    trigger OnRun()
    var
        MailSends: Text;
    begin

        UnitSetup.GET;
        UnitSetup.TESTFIELD(UnitSetup."Report Batch No. Series");
        BatchNo := '';
        BatchNo := NoseriesMGT.GetNextNo(UnitSetup."Report Batch No. Series", TODAY, TRUE);
        COMMIT;
        ReportRequestfromWebMb.RESET;
        ReportRequestfromWebMb.SETRANGE("Report Id", 50011);
        ReportRequestfromWebMb.SETRANGE("Report Generated", FALSE);
        //ReportRequestfromWebMb.SETRANGE("Entry No.",54);
        ReportRequestfromWebMb.SETFILTER("Associate Code", '<>%1', '');
        IF ReportRequestfromWebMb.FINDSET THEN
            REPEAT
                CLEAR(Codeunit_12);
                Codeunit_12.Setfilteres(ReportRequestfromWebMb."Associate Code", BatchNo, ReportRequestfromWebMb."Entry No.");
                Vend.RESET;
                IF Vend.GET(ReportRequestfromWebMb."Associate Code") THEN BEGIN
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
                        "ReportDataforE-Mail"."Report Type" := '.pdf';
                        "ReportDataforE-Mail"."Request from Mobile" := TRUE;
                        "ReportDataforE-Mail".INSERT;

                        ReportRequestfromWebMb."Error Message" := CopyStr(GetLastErrorText(), 1, 1000);

                        ReportRequestfromWebMb.MODIFY;
                        COMMIT;
                    END ELSE BEGIN
                        ReportRequestfromWebMb."Report Generated" := TRUE;
                        ReportRequestfromWebMb."Report Send" := True;
                        ReportRequestfromWebMb."Report Sending Date" := Today;
                        ReportRequestfromWebMb."Report Sending Time" := Time;
                        ReportRequestfromWebMb.MODIFY;

                        "ReportDataforE-Mail_1".RESET;
                        IF "ReportDataforE-Mail_1".FINDLAST THEN
                            EntryNo := "ReportDataforE-Mail_1"."Entry No."
                        ELSE
                            EntryNo := 0;

                        "ReportDataforE-Mail".INIT;
                        "ReportDataforE-Mail"."Entry No." := EntryNo + 1;
                        "ReportDataforE-Mail"."Report ID" := 50011;
                        "ReportDataforE-Mail"."Associate Code" := Vend."No.";
                        "ReportDataforE-Mail"."Report Run Date" := TODAY;
                        "ReportDataforE-Mail"."Report Run Time" := TIME;
                        "ReportDataforE-Mail"."Report Batch No." := BatchNo;
                        "ReportDataforE-Mail"."Report Type" := '.pdf';
                        "ReportDataforE-Mail"."Request from Mobile" := TRUE;
                        "ReportDataforE-Mail"."E-Mail Send" := True;
                        "ReportDataforE-Mail".INSERT;
                    END;
                END;
                COMMIT;
            UNTIL ReportRequestfromWebMb.NEXT = 0;
        COMMIT;

        //----------------------------------------------------------
        CollectionTime := 0T;
        CollectionTime := 210000T;
        //IF TIME > CollectionTime THEN BEGIN

        ReportRequestfromWebMb.RESET;
        ReportRequestfromWebMb.SETRANGE("Report Id", 50041);
        ReportRequestfromWebMb.SETRANGE("Report Generated", FALSE);
        ReportRequestfromWebMb.SETFILTER("Associate Code", '<>%1', '');
        //ReportRequestfromWebMb.SETRANGE("Entry No.",54);
        IF ReportRequestfromWebMb.FINDSET THEN
            REPEAT
                CLEAR(JobQueueforR50041_1);
                JobQueueforR50041_1.Setfilteres(ReportRequestfromWebMb."Associate Code", BatchNo, ReportRequestfromWebMb."From Date", ReportRequestfromWebMb."To Date", ReportRequestfromWebMb."Entry No.");
                Vend.RESET;
                IF Vend.GET(ReportRequestfromWebMb."Associate Code") THEN BEGIN
                    IF NOT JobQueueforR50041_1.RUN(Vend) THEN BEGIN
                        "ReportDataforE-Mail_1".RESET;
                        IF "ReportDataforE-Mail_1".FINDLAST THEN
                            EntryNo := "ReportDataforE-Mail_1"."Entry No."
                        ELSE
                            EntryNo := 0;

                        "ReportDataforE-Mail".INIT;
                        "ReportDataforE-Mail"."Entry No." := EntryNo + 1;
                        "ReportDataforE-Mail"."Report ID" := 50041;
                        "ReportDataforE-Mail"."Associate Code" := Vend."No.";
                        "ReportDataforE-Mail"."Error Message" := COPYSTR(GETLASTERRORTEXT, 1, 200);
                        "ReportDataforE-Mail"."Report Run Date" := TODAY;
                        "ReportDataforE-Mail"."Report Run Time" := TIME;
                        "ReportDataforE-Mail"."Report Batch No." := BatchNo;
                        "ReportDataforE-Mail"."Request from Mobile" := TRUE;
                        "ReportDataforE-Mail".INSERT;
                        ReportRequestfromWebMb."Error Message" := CopyStr(GetLastErrorText(), 1, 1000);
                        ReportRequestfromWebMb.MODIFY;
                        COMMIT;
                    END ELSE BEGIN
                        ReportRequestfromWebMb."Report Generated" := TRUE;
                        ReportRequestfromWebMb."Report Send" := True;
                        ReportRequestfromWebMb."Report Sending Date" := Today;
                        ReportRequestfromWebMb."Report Sending Time" := Time;
                        ReportRequestfromWebMb.MODIFY;
                        "ReportDataforE-Mail_1".RESET;
                        IF "ReportDataforE-Mail_1".FINDLAST THEN
                            EntryNo := "ReportDataforE-Mail_1"."Entry No."
                        ELSE
                            EntryNo := 0;

                        "ReportDataforE-Mail".INIT;
                        "ReportDataforE-Mail"."Entry No." := EntryNo + 1;
                        "ReportDataforE-Mail"."Report ID" := 50041;
                        "ReportDataforE-Mail"."Associate Code" := Vend."No.";
                        "ReportDataforE-Mail"."Report Run Date" := TODAY;
                        "ReportDataforE-Mail"."Report Run Time" := TIME;
                        "ReportDataforE-Mail"."Report Batch No." := BatchNo;
                        "ReportDataforE-Mail"."Request from Mobile" := TRUE;
                        "ReportDataforE-Mail"."E-Mail Send" := True;
                        "ReportDataforE-Mail".INSERT;
                    END;
                END;
                COMMIT;
            UNTIL ReportRequestfromWebMb.NEXT = 0;
        //END;
        //-----------------------------------------------------

        COMMIT;


        ReportRequestfromWebMb.RESET;
        ReportRequestfromWebMb.SETRANGE("Report Id", 33057782);
        ReportRequestfromWebMb.SETRANGE("Report Generated", FALSE);
        ReportRequestfromWebMb.SETFILTER("Associate Code", '<>%1', '');
        //ReportRequestfromWebMb.SETRANGE("Entry No.",54);
        IF ReportRequestfromWebMb.FINDSET THEN
            REPEAT
                CLEAR(JobQueueforR97782_1);
                JobQueueforR97782_1.Setfilteres(ReportRequestfromWebMb."Associate Code", BatchNo, ReportRequestfromWebMb."From Date", ReportRequestfromWebMb."To Date", ReportRequestfromWebMb."Entry No.");
                Vend.RESET;
                IF Vend.GET(ReportRequestfromWebMb."Associate Code") THEN BEGIN
                    IF NOT JobQueueforR97782_1.RUN(Vend) THEN BEGIN
                        "ReportDataforE-Mail_1".RESET;
                        IF "ReportDataforE-Mail_1".FINDLAST THEN
                            EntryNo := "ReportDataforE-Mail_1"."Entry No."
                        ELSE
                            EntryNo := 0;

                        "ReportDataforE-Mail".INIT;
                        "ReportDataforE-Mail"."Entry No." := EntryNo + 1;
                        "ReportDataforE-Mail"."Report ID" := 33057782;
                        "ReportDataforE-Mail"."Associate Code" := Vend."No.";
                        "ReportDataforE-Mail"."Error Message" := COPYSTR(GETLASTERRORTEXT, 1, 200);
                        "ReportDataforE-Mail"."Report Run Date" := TODAY;
                        "ReportDataforE-Mail"."Report Run Time" := TIME;
                        "ReportDataforE-Mail"."Report Batch No." := BatchNo;
                        "ReportDataforE-Mail"."Request from Mobile" := TRUE;
                        "ReportDataforE-Mail"."Report Type" := '.pdf';
                        "ReportDataforE-Mail".INSERT;

                        ReportRequestfromWebMb."Error Message" := CopyStr(GetLastErrorText(), 1, 1000);
                        ReportRequestfromWebMb.MODIFY;
                        COMMIT;
                    END ELSE BEGIN
                        ReportRequestfromWebMb."Report Generated" := TRUE;
                        ReportRequestfromWebMb."Report Send" := True;
                        ReportRequestfromWebMb."Report Sending Date" := Today;
                        ReportRequestfromWebMb."Report Sending Time" := Time;
                        ReportRequestfromWebMb.MODIFY;
                        "ReportDataforE-Mail_1".RESET;
                        IF "ReportDataforE-Mail_1".FINDLAST THEN
                            EntryNo := "ReportDataforE-Mail_1"."Entry No."
                        ELSE
                            EntryNo := 0;

                        "ReportDataforE-Mail".INIT;
                        "ReportDataforE-Mail"."Entry No." := EntryNo + 1;
                        "ReportDataforE-Mail"."Report ID" := 33057782;
                        "ReportDataforE-Mail"."Associate Code" := Vend."No.";
                        "ReportDataforE-Mail"."Report Run Date" := TODAY;
                        "ReportDataforE-Mail"."Report Run Time" := TIME;
                        "ReportDataforE-Mail"."Report Batch No." := BatchNo;
                        "ReportDataforE-Mail"."Request from Mobile" := TRUE;
                        "ReportDataforE-Mail"."Report Type" := '.pdf';
                        "ReportDataforE-Mail"."E-Mail Send" := True;
                        "ReportDataforE-Mail".INSERT;

                    END;
                END;
                COMMIT;
            UNTIL ReportRequestfromWebMb.NEXT = 0;
        COMMIT;

    end;

    var
        ReportRequestfromWebMb: Record "Report Request from Web/Mb.";
        UnitSetup: Record "Unit Setup";
        NoseriesMGT: Codeunit NoSeriesManagement;
        BatchNo: Code[20];
        Codeunit_12: Codeunit "Job Queue for R-50011_1";
        Vend: Record Vendor;
        "ReportDataforE-Mail_1": Record "Report Data for E-Mail";
        "ReportDataforE-Mail": Record "Report Data for E-Mail";
        EntryNo: Integer;
        FirstDateStart: Date;
        FirstDateEnd: Date;
        SecondDateStart: Date;
        SecondDateEnd: Date;
        LastDateStart: Date;
        LastDateEnd: Date;
        MonthNo: Integer;
        Days: Integer;
        CommissionTime: Time;
        CollectionTime: Time;
        DrawingLedgerTime: Time;
        JobQueueforR50041_1: Codeunit "Job Queue for R-50041_1";
        JobQueueforR97782_1: Codeunit "Job Queue for R-97782_1";
        v_SendEmailtoAssociate: Codeunit "Send E-mail to Associate";
        v_ReportRequestfromWebMb: Record "Report Request from Web/Mb.";

    local procedure SendEmailtoAssociate(p_ReportRequestfromWebMb: Record "Report Request from Web/Mb.") SendMailtoAssoc: Text
    var
        ReportDataforEMail: Record "Report Data for E-Mail";
        V_ReportRequestfromWebMb: Record "Report Request from Web/Mb.";
    begin
        ReportDataforEMail.RESET;
        ReportDataforEMail.SETRANGE("Report ID", p_ReportRequestfromWebMb."Report Id");
        ReportDataforEMail.SETRANGE("Associate Code", p_ReportRequestfromWebMb."Associate Code");
        ReportDataforEMail.SETRANGE("E-Mail Send", FALSE);
        //ReportDataforEMail.SETRANGE("E_Mail Send Error",FALSE);
        ReportDataforEMail.SETRANGE("Report Run Date", TODAY - 3, TODAY);
        ReportDataforEMail.SETFILTER("Report Name", '<>%1', '');
        IF ReportDataforEMail.FINDFIRST THEN BEGIN
            CLEAR(v_SendEmailtoAssociate);
            v_SendEmailtoAssociate.SetEmailFilters(ReportDataforEMail."E-Mail Send", ReportDataforEMail."Report Name");
            IF NOT v_SendEmailtoAssociate.RUN(ReportDataforEMail) THEN BEGIN
                ReportDataforEMail."E_Mail Send Error Message" := GETLASTERRORTEXT;
                ReportDataforEMail."E_Mail Send Error" := TRUE;
                ReportDataforEMail.MODIFY;
                SendMailtoAssoc := 'Not Send';
                COMMIT;
            END;
        END;
        EXIT(SendMailtoAssoc);
    end;

    local procedure AllCodes()
    begin
        /*
        UnitSetup.GET;
        UnitSetup.TESTFIELD(UnitSetup."Report Batch No. Series");
        BatchNo := '';
        BatchNo := NoseriesMGT.GetNextNo(UnitSetup."Report Batch No. Series",TODAY,TRUE);
        COMMIT;
        
        Days := 0;
        MonthNo := 0;
        
        Days := DATE2DMY(TODAY,1);
        MonthNo := DATE2DMY(TODAY,2);
        IF MonthNo <> 2 THEN BEGIN
          IF Days <= 28 THEN BEGIN
            CommissionTime := 200000T;
            CollectionTime := 220000T;
            DrawingLedgerTime := 223000T;
          END ELSE IF (Days >28) AND (Days <=29) THEN BEGIN
            CommissionTime := 220000T;
            CollectionTime := 233000T;
            DrawingLedgerTime := 234000T;
          END ELSE IF Days > 29 THEN BEGIN
            CommissionTime := 235000T;
            CollectionTime := 010000T;
            DrawingLedgerTime := 020000T;
          END;
        END ELSE BEGIN
          IF Days <= 24 THEN BEGIN
              CommissionTime := 200000T;
            CollectionTime := 220000T;
            DrawingLedgerTime := 223000T;
          END ELSE IF (Days >24) AND (Days <=26) THEN BEGIN
            CommissionTime := 220000T;
            CollectionTime := 233000T;
            DrawingLedgerTime := 234000T;
          END ELSE IF Days > 26 THEN BEGIN
            CommissionTime := 235000T;
            CollectionTime := 010000T;
            DrawingLedgerTime := 020000T;
          END;
        END;
        
        IF TIME > CommissionTime THEN BEGIN
          ReportRequestfromWebMb.RESET;
          ReportRequestfromWebMb.SETRANGE("Report Id",50011);
          ReportRequestfromWebMb.SETRANGE("Report Generated",FALSE);
          IF ReportRequestfromWebMb.FINDSET THEN
            REPEAT
              CLEAR(Codeunit_12);
              Codeunit_12.Setfilteres(ReportRequestfromWebMb."Associate Code",BatchNo);
              Vend.RESET;
              Vend.GET(ReportRequestfromWebMb."Associate Code");
                IF NOT Codeunit_12.RUN(Vend) THEN BEGIN
                  "ReportDataforE-Mail_1".RESET;
                  IF "ReportDataforE-Mail_1".FINDLAST THEN
                    EntryNo := "ReportDataforE-Mail_1"."Entry No."
                  ELSE
                    EntryNo := 0;
        
                  "ReportDataforE-Mail".INIT;
                  "ReportDataforE-Mail"."Entry No." := EntryNo+1;
                  "ReportDataforE-Mail"."Report ID" := 50011;
                  "ReportDataforE-Mail"."Associate Code" := Vend."No.";
                  "ReportDataforE-Mail"."Error Message" := COPYSTR(GETLASTERRORTEXT,1,200);
                  "ReportDataforE-Mail"."Report Run Date" := TODAY;
                  "ReportDataforE-Mail"."Report Run Time" := TIME;
                  "ReportDataforE-Mail"."Report Batch No." := BatchNo;
                  "ReportDataforE-Mail".INSERT;
                   COMMIT;
              END ELSE BEGIN
                ReportRequestfromWebMb."Report Generated" := TRUE;
                ReportRequestfromWebMb.MODIFY;
              END;
            UNTIL ReportRequestfromWebMb.NEXT = 0;
        
         END;
        COMMIT;
        
        //----------------------------------------------------------
        IF TIME > CollectionTime THEN BEGIN
          ReportRequestfromWebMb.RESET;
          ReportRequestfromWebMb.SETRANGE("Report Id",50041);
          ReportRequestfromWebMb.SETRANGE("Report Generated",FALSE);
          IF ReportRequestfromWebMb.FINDSET THEN
            REPEAT
              CLEAR(JobQueueforR50041_1);
              JobQueueforR50041_1.Setfilteres(ReportRequestfromWebMb."Associate Code",BatchNo,ReportRequestfromWebMb."From Date",ReportRequestfromWebMb."To Date");
              Vend.RESET;
              Vend.GET(ReportRequestfromWebMb."Associate Code");
                IF NOT JobQueueforR50041_1.RUN(Vend) THEN BEGIN
                  "ReportDataforE-Mail_1".RESET;
                  IF "ReportDataforE-Mail_1".FINDLAST THEN
                    EntryNo := "ReportDataforE-Mail_1"."Entry No."
                  ELSE
                    EntryNo := 0;
        
                  "ReportDataforE-Mail".INIT;
                  "ReportDataforE-Mail"."Entry No." := EntryNo+1;
                  "ReportDataforE-Mail"."Report ID" := 50041;
                  "ReportDataforE-Mail"."Associate Code" := Vend."No.";
                  "ReportDataforE-Mail"."Error Message" := COPYSTR(GETLASTERRORTEXT,1,200);
                  "ReportDataforE-Mail"."Report Run Date" := TODAY;
                  "ReportDataforE-Mail"."Report Run Time" := TIME;
                  "ReportDataforE-Mail"."Report Batch No." := BatchNo;
                  "ReportDataforE-Mail".INSERT;
                   COMMIT;
              END ELSE BEGIN
                ReportRequestfromWebMb."Report Generated" := TRUE;
                ReportRequestfromWebMb.MODIFY;
              END;
            UNTIL ReportRequestfromWebMb.NEXT = 0;
        END;
        //-----------------------------------------------------
        COMMIT;
        
        
        IF TIME > DrawingLedgerTime THEN BEGIN
          ReportRequestfromWebMb.RESET;
          ReportRequestfromWebMb.SETRANGE("Report Id",97782);
          ReportRequestfromWebMb.SETRANGE("Report Generated",FALSE);
          IF ReportRequestfromWebMb.FINDSET THEN
            REPEAT
              CLEAR(JobQueueforR97782_1);
              JobQueueforR97782_1.Setfilteres(ReportRequestfromWebMb."Associate Code",BatchNo,ReportRequestfromWebMb."From Date",ReportRequestfromWebMb."To Date");
              Vend.RESET;
              Vend.GET(ReportRequestfromWebMb."Associate Code");
                IF NOT JobQueueforR97782_1.RUN(Vend) THEN BEGIN
                  "ReportDataforE-Mail_1".RESET;
                  IF "ReportDataforE-Mail_1".FINDLAST THEN
                    EntryNo := "ReportDataforE-Mail_1"."Entry No."
                  ELSE
                    EntryNo := 0;
        
                  "ReportDataforE-Mail".INIT;
                  "ReportDataforE-Mail"."Entry No." := EntryNo+1;
                  "ReportDataforE-Mail"."Report ID" := 97782;
                  "ReportDataforE-Mail"."Associate Code" := Vend."No.";
                  "ReportDataforE-Mail"."Error Message" := COPYSTR(GETLASTERRORTEXT,1,200);
                  "ReportDataforE-Mail"."Report Run Date" := TODAY;
                  "ReportDataforE-Mail"."Report Run Time" := TIME;
                  "ReportDataforE-Mail"."Report Batch No." := BatchNo;
                  "ReportDataforE-Mail".INSERT;
                   COMMIT;
              END ELSE BEGIN
                ReportRequestfromWebMb."Report Generated" := TRUE;
                ReportRequestfromWebMb.MODIFY;
              END;
            UNTIL ReportRequestfromWebMb.NEXT = 0;
        END;
        COMMIT;
        */

    end;
}

