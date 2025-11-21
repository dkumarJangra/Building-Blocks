codeunit 97749 "Job Queue for R-97782_1"
{
    TableNo = Vendor;

    trigger OnRun()
    begin
        //   REPORT.RUN(50165,FALSE,FALSE,Rec);
        CLEAR(NBATReport);
        Vend.RESET;
        Vend.SETRANGE("No.", VendFilters);
        IF Vend.FINDFIRST THEN begin
            NBATReport.Setfilters(VendFilters, BatchNos, FromDt, ToDt);

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

            EmailMessage.Create(Vend."E-Mail", 'Your Drawing Ledger Report', HtmlEmailBody, True);

            EmailMessage.AddAttachment('33057782' + VendFilters + '_' + FORMAT(Entry_No1) + '.Pdf', '.Pdf', AttachmentStream);
            MailSent := Email.Send(EmailMessage, "Email Scenario"::Default);

        end;

        UnitSetup.GET;
        //NBATReport.SAVEASPDF(UnitSetup."Excel File Save Path" + '97782' + VendFilters + '_' + FORMAT(Entry_No1) + '.pdf');

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
        "ReportDataforE-Mail"."Report Batch No." := BatchNos;
        "ReportDataforE-Mail"."Report Name" := '33057782' + VendFilters + '_' + FORMAT(Entry_No1);//+'.pdf';
        "ReportDataforE-Mail"."Report Type" := '.pdf';
        "ReportDataforE-Mail"."Request from Mobile" := TRUE;
        "ReportDataforE-Mail".INSERT;
    end;

    var
        Vend: Record Vendor;
        NBATReport: Report "New Assoc Drawing Job queue";
        VendFilters: Code[20];
        BatchNos: Code[20];
        FromDt: Date;
        ToDt: Date;
        UnitSetup: Record "Unit Setup";
        Entry_No1: Integer;
        "ReportDataforE-Mail_1": Record "Report Data for E-Mail";
        "ReportDataforE-Mail": Record "Report Data for E-Mail";
        EntryNo: Integer;

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






    procedure Setfilteres(VendFilter: Code[20]; BatchNo: Code[20]; FromDate: Date; ToDate: Date; Entry_No: Integer)
    begin
        VendFilters := VendFilter;
        BatchNos := BatchNo;
        FromDt := FromDate;
        ToDt := ToDate;
        Entry_No1 := Entry_No;
    end;
}

