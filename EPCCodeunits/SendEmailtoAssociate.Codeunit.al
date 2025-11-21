codeunit 97750 "Send E-mail to Associate"
{
    TableNo = "Report Data for E-Mail";

    trigger OnRun()
    begin
        ReportDataforEMail.RESET;
        ReportDataforEMail.SETRANGE("E-Mail Send", SmsFilter);
        ReportDataforEMail.SETRANGE("Report Name", ReportNameFilter);
        //ReportDataforEMail.SETRANGE("Entry No.",51562);
        IF ReportDataforEMail.FINDSET THEN
            REPEAT
                Vend.RESET;
                Unitsetup.GET;
                Unitsetup.TESTFIELD(Unitsetup."Excel File Save Path");
                //SMTPSetup.GET;
                VendorEmail := '';
                IF Vend.GET(ReportDataforEMail."Associate Code") THEN
                    VendorEmail := Vend."E-Mail";
                //  IF ReportDataforEMail."Request from Mobile" THEN
                //  VendorEmail := 'it.erp@bbgindia.com';

                ExcelSheetName := '';
                IF ReportDataforEMail."Report Type" = '' THEN
                    ExcelSheetName := Unitsetup."Excel File Save Path" + ReportDataforEMail."Report Name" + '.Xlsx'
                ELSE
                    ExcelSheetName := Unitsetup."Excel File Save Path" + ReportDataforEMail."Report Name" + '.pdf';


                EmailSubject := '';
                IF (ReportDataforEMail."Report ID" = 50096) THEN begin
                    EmailSubject := 'Booking_Allotment Report';
                    //     smtpMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", VendorEmail, 'Booking_Allotment Report',

                    //          'Your Booking_Allotment Report', TRUE);
                end;
                IF (ReportDataforEMail."Report ID" = 97782) THEN begin
                    EmailSubject := 'Drawing Ledger Report';

                    //     smtpMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", VendorEmail, 'Drawing Ledger Report',
                    //             'Your Drawing Ledger Report', TRUE);
                end;
                IF (ReportDataforEMail."Report ID" = 50011) OR (ReportDataforEMail."Report ID" = 50082) THEN BEGIN
                    EmailSubject := 'Commission Report';
                    //     smtpMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", VendorEmail, 'Commission Report',
                    //             'Your commission Report', TRUE);
                END;
                IF (ReportDataforEMail."Report ID" = 50041) THEN begin
                    EmailSubject := 'Collection Report';
                    //     smtpMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", VendorEmail, 'Collection Report',
                    //             'Your Collection Details Report', TRUE);
                end;

                // Unitsetup.GET;


                CLEAR(smtpMail);
                SMTPSetup.Reset();
                SMTPSetup.SetFilter(Name, '<>%1', '');
                if SMTPSetup.FindFirst() then;

                HtmlEmailBody := '<!DOCTYPE html><html><body>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Dear Sir / Madam,';
                HtmlEmailBody += '<br/>';

                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Please find the attached Report';
                HtmlEmailBody += '<br/>';

                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Regards';
                HtmlEmailBody += '<br/>';

                HtmlEmailBody += '<br>';
                HtmlEmailBody += SMTPSetup."Name";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '</body></html>';
                EmailMessage.Create(VendorEmail, EmailSubject, HtmlEmailBody, True);

                // IF ReportDataforEMail."Report Type" = '' THEN
                //     EmailMessage.AddAttachment(ExcelSheetName, ReportDataforEMail."Report Name" + '.Xlsx')
                // ELSE
                //     EmailMessage.AddAttachment(ExcelSheetName, ReportDataforEMail."Report Name" + '.pdf');

                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                END;



            // smtpMail.AppendBody('<br>');
            // smtpMail.AppendBody('<br/>');
            // smtpMail.AppendBody('Dear Sir / Madam,');
            // smtpMail.AppendBody('<br/>');
            // smtpMail.AppendBody('<br>');
            // smtpMail.AppendBody('Please find the attached Report');
            // smtpMail.AppendBody('<br/>');
            // smtpMail.AppendBody('<br>');
            // smtpMail.AppendBody('Regards');
            // smtpMail.AppendBody('<br/>');
            // smtpMail.AppendBody('<br>');
            // //smtpMail.AppendBody(SMTPSetup."Email Sender Name");
            // smtpMail.AppendBody('<br/>');
            // Unitsetup.GET;
            // IF ReportDataforEMail."Report Type" = '' THEN
            //     smtpMail.AddAttachment(ExcelSheetName, ReportDataforEMail."Report Name" + '.Xlsx')
            // ELSE
            //     smtpMail.AddAttachment(ExcelSheetName, ReportDataforEMail."Report Name" + '.pdf');
            // smtpMail.Send;
            // ReportDataforEMail."E-Mail Send" := TRUE;
            // ReportDataforEMail."E_Mail Send Error" := FALSE;
            // ReportDataforEMail."E_Mail Send Error Message" := '';
            // ReportDataforEMail.MODIFY;
            // SLEEP(10000);
            UNTIL ReportDataforEMail.NEXT = 0;


    end;

    var
        //smtpMail: Codeunit 400;
        Vend: Record Vendor;
        //SMTPSetup: Record 409;
        ExcelSheetName: Code[100];
        Message_1: Text[200];
        Unitsetup: Record "Unit Setup";
        ReportDataforEMail: Record "Report Data for E-Mail";
        SmsFilter: Boolean;
        ReportNameFilter: Text[50];
        VendorEmail: Text;
        SMTPSetup: Record "Email Account"; //"SMTP Mail Setup";
        smtpMail: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        HtmlEmailBody: text;

        EmailSubject: Text;


    procedure SetEmailFilters(SmsFilters: Boolean; ReportNameFilters: Text[50])
    begin
        SmsFilter := SmsFilters;
        ReportNameFilter := ReportNameFilters;
    end;
}

