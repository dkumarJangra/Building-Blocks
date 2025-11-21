codeunit 97751 "Assoicate E-Mail Send"
{

    trigger OnRun()
    begin
        ReportDataforEMail.RESET;
        //ReportDataforEMail.SETRANGE("Entry No.",51562);
        ReportDataforEMail.SETRANGE("E-Mail Send", FALSE);
        ReportDataforEMail.SETFILTER("Report Name", '<>%1', '');
        //ReportDataforEMail.SETRANGE("E_Mail Send Error",FALSE);
        ReportDataforEMail.SETRANGE("Report Run Date", TODAY);
        IF ReportDataforEMail.FINDSET THEN
            REPEAT
                CLEAR(Codeunit_12);
                Codeunit_12.SetEmailFilters(ReportDataforEMail."E-Mail Send", ReportDataforEMail."Report Name");
                IF NOT Codeunit_12.RUN(ReportDataforEMail) THEN BEGIN
                    ReportDataforEMail."E_Mail Send Error Message" := GETLASTERRORTEXT;
                    ReportDataforEMail."E_Mail Send Error" := TRUE;
                    ReportDataforEMail.MODIFY;
                    COMMIT;
                END;
            UNTIL ReportDataforEMail.NEXT = 0;
        MESSAGE('%1', 'Send Mail');
    end;

    var
        Codeunit_12: Codeunit "Send E-mail to Associate";
        ReportDataforEMail: Record "Report Data for E-Mail";
}

