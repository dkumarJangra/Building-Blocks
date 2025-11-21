codeunit 97748 "Job Queue for R-50011_1"
{
    TableNo = Vendor;

    trigger OnRun()
    begin

        CLEAR(NBATReport);
        Vend.RESET;
        Vend.SETRANGE("No.", VendFilters);
        IF Vend.FINDFIRST THEN BEGIN
            NBATReport.Setfilters(VendFilters, BatchNos);
            ReportOStream := TempBlob.CreateOutStream();
            NBATReport.SAVEAS('', REPORTFORMAT::Pdf, ReportOStream, ReportRecRef);
            AttachmentStream := TempBlob.CreateInStream();
            HtmlEmailBody := '<!DOCTYPE html><html><body>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += 'Dear Sir / Madam,';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Please find the attached Report';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Regards';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Building Blocks Group';
            HtmlEmailBody += '<br/>';

            EmailMessage.Create(Vend."E-Mail", 'Your commission Report', HtmlEmailBody, True);

            EmailMessage.AddAttachment('50011' + VendFilters + '-' + FORMAT(Enty_No1) + '.Pdf', '.Pdf', AttachmentStream);
            MailSent := Email.Send(EmailMessage, "Email Scenario"::Default);


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
            "ReportDataforE-Mail"."Report Batch No." := BatchNos;
            "ReportDataforE-Mail"."Report Name" := '50011' + VendFilters + '-' + FORMAT(Enty_No1);//+'.pdf';
            "ReportDataforE-Mail"."Report Type" := '.pdf';
            "ReportDataforE-Mail"."Request from Mobile" := TRUE;
            "ReportDataforE-Mail".INSERT;
        END;
    end;

    var
        Vend: Record Vendor;
        NBATReport: Report "Commission Report_Job Batch";
        VendFilters: Code[20];
        BatchNos: Code[20];
        UnitSetup: Record "Unit Setup";
        Enty_No1: Integer;
        "ReportDataforE-Mail_1": Record "Report Data for E-Mail";
        EntryNo: Integer;
        "ReportDataforE-Mail": Record "Report Data for E-Mail";
        Email: Codeunit Email;
        AttachmentStream: InStream;
        HtmlEmailBody: text;
        smtpMail: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        SMTPSetup: Record "Email Account";
        TempBlob: Codeunit "Temp Blob";
        FileNameTxt: Text;
        ReportRecRef: RecordRef;
        ReportOStream: OutStream;
        MailSent: Boolean;






    procedure Setfilteres(VendFilter: Code[20]; BatchNo: Code[20]; Enty_No: Integer)
    begin
        VendFilters := VendFilter;
        BatchNos := BatchNo;
        Enty_No1 := Enty_No;
    end;
}

