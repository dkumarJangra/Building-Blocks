codeunit 97761 "Send E-mail to Customer"
{
    TableNo = "NewApplication Payment Entry";

    trigger OnRun()
    begin

        NewApplicationPaymentEntry.RESET;
        NewApplicationPaymentEntry.SETRANGE("Document No.", ApplicationDocNo_1);
        NewApplicationPaymentEntry.SETRANGE("Send Mail", FALSE);
        IF NewApplicationPaymentEntry.FINDLAST THEN BEGIN
            NewConfirmedOrder.RESET;
            IF NewConfirmedOrder.GET(NewApplicationPaymentEntry."Document No.") THEN
                IF Customer.GET(NewConfirmedOrder."Customer No.") THEN;
            Unitsetup.GET;
            //SMTPSetup.GET;
            ExcelSheetName := '';
            ExcelSheetName := Unitsetup."Customer Receipt Path" + NewApplicationPaymentEntry."Document No." + '.pdf';

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
            EmailMessage.Create(Customer."E-Mail", 'Plot Allotment Receipt', HtmlEmailBody, True);
            EmailMessage.AddAttachment(ExcelSheetName, ExcelSheetName, '');
            IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

            END;


            // smtpMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", Customer."E-Mail", 'Plot Allotment Receipt',
            //    'Your Plot Allotment Receipt', TRUE);

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
            // smtpMail.AppendBody(SMTPSetup."Email Sender Name");
            // smtpMail.AppendBody('<br/>');
            // Unitsetup.GET;
            // smtpMail.AddAttachment(ExcelSheetName, ExcelSheetName);
            // smtpMail.Send;
            NewApplicationPaymentEntry."Send Mail" := TRUE;
            NewApplicationPaymentEntry.MODIFY;
            SLEEP(10000);
        END;

    end;

    var
        //smtpMail: Codeunit 400;
        Vend: Record Vendor;
        //SMTPSetup: Record 409;
        ExcelSheetName: Code[50];
        Message_1: Text[200];
        Unitsetup: Record "Unit Setup";
        ApplicationDocNo_1: Code[20];
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        Customer: Record Customer;
        NewConfirmedOrder: Record "New Confirmed Order";
        SMTPSetup: Record "Email Account"; //"SMTP Mail Setup";
        smtpMail: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        HtmlEmailBody: text;



    procedure SetEmailFilters(ApplicationDocNo: Code[20])
    begin
        ApplicationDocNo_1 := ApplicationDocNo;
    end;


    procedure CustomerWelcomLetter(MemberCode: Code[20])
    var
        Companyinfo: Record "Company Information";
    begin
        IF Customer.GET(MemberCode) THEN BEGIN
            IF Customer."E-Mail" <> '' THEN BEGIN
                Unitsetup.GET;
                ExcelSheetName := '';
                ExcelSheetName := Unitsetup."Customer Welcome letter Path";
                CLEAR(smtpMail);
                SMTPSetup.Reset();
                SMTPSetup.SetFilter(Name, '<>%1', '');
                if SMTPSetup.FindFirst() then;

                HtmlEmailBody := '<!DOCTYPE html><html><body>';





                // smtpMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", Customer."E-Mail", 'Welcome to the BBG Family',
                // '', TRUE);

                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'To,';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Mr./Ms.' + Customer.Name;
                HtmlEmailBody += '<br/>';
                IF Customer.Address <> '' THEN BEGIN
                    HtmlEmailBody += '<br>';
                    HtmlEmailBody += Customer.Address + ',' + Customer."Address 2" + ',' + Customer.City;
                    HtmlEmailBody += '<br/>';
                END;
                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<P style="text-align:Right">' + FORMAT(TODAY) + '</P>';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<P style="text-align:center"> Welcome to the BBG Family' + '</P>';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Respected ' + Customer.Name + ',';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'We take this opportunity to first of all thank you for your kind consideration and interest in our ';
                HtmlEmailBody += 'company, Building Blocks Group. Through this letter we would like to extend a warm welcome to you ';
                HtmlEmailBody += 'as a new customer of our company. You have chosen a recognized company, which remains forever ';
                HtmlEmailBody += 'committed to provide the best products and services to its customers.';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'BBG is an award-winning, plotted land development firm and one of the fastest growing real estate ';
                HtmlEmailBody += 'companies. With over a decade in operations, BBG today has over one lakh customers and has';
                HtmlEmailBody += 'successfully completed over 200 plotted land development projects across Shadnagar, Sadashivpet,';
                HtmlEmailBody += 'Yadadri, Visakhapatnam, Vijayawada, Rajahmundry, Tirupati and other prominent locations in the';
                HtmlEmailBody += 'states of Telangana and Andhra Pradesh.';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'A firm believer in the ideals of the Father of the Nation, Mahatma Gandhi, who believed that that';
                HtmlEmailBody += 'businesses should exist as part of a healthy community in order to serve that community, BBG provides';
                HtmlEmailBody += 'its customers an ideal opportunity to make safe and secure long-term savings by owning a piece of land';
                HtmlEmailBody += 'and thereby create, true, long-term wealth for their families.';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Apart from helping create “True Wealth” for its customers, BBG has an unwavering commitment to ';
                HtmlEmailBody += 'enable and empower the “girl child.” Enshrining the ideals of Mahatma Gandhi, who visualized a';
                HtmlEmailBody += 'fundamental role for women as instruments of social change, BBG is enabling and empowering over';
                HtmlEmailBody += '20,000 girls in over 40 primary schools across Telangana and Andhra Pradesh. ';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Again, THANK YOU. We hope we can give you the same level of satisfaction and service as what our ';
                HtmlEmailBody += 'loyal customers have been experiencing from us. We look forward to working closely with you and ';
                HtmlEmailBody += 'provide safe and secure opportunities for every Indian to own a piece of land.';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Thank you.';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Warm regards,';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'BMR';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += '(Building Blocks Mallikarjun Reddy)';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Chairman and Managing Director';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Building Blocks Group';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '</body></html>';
                EmailMessage.Create(Customer."E-Mail", 'Plot Allotment Receipt', HtmlEmailBody, True);
                //  EmailMessage.AddAttachment(ExcelSheetName, ExcelSheetName, '';
                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                END;

                // Unitsetup.GET;

                // smtpMail.AddAttachment(ExcelSheetName, ExcelSheetName);
                // smtpMail.Send;
                // SLEEP(10000);
            END;
        END;
    end;
}

