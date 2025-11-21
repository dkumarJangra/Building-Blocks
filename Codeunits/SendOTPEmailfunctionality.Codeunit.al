codeunit 50046 "SendOTP Email functionality"

{

    trigger OnRun()
    begin
        SendOTPEmail;
    end;

    var
        EMAILS_F: Text;
        BodyMessages_F: Text;

    local procedure SendOTPEmail()
    var
        Vend: Record Vendor;
        smtpMail: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        EmailBody: List of [Text];
        SMTPSetup: Record "Email Account"; //"SMTP Mail Setup";
        Body: text;
        HtmlEmailBody: text;
    begin
        IF EMAILS_F <> '' THEN BEGIN
            CLEAR(smtpMail);
            SMTPSetup.Reset();
            SMTPSetup.SetFilter(Name, '<>%1', '');
            if SMTPSetup.FindFirst() then;

            HtmlEmailBody := '<!DOCTYPE html><html><body>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Dear Sir / Madam,';
            HtmlEmailBody += '<br/>';

            HtmlEmailBody += '<br>';
            HtmlEmailBody += BodyMessages_F;
            HtmlEmailBody += '<br/>';

            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Regards';
            HtmlEmailBody += '<br/>';

            HtmlEmailBody += '<br>';
            HtmlEmailBody += SMTPSetup."Name";
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '</body></html>';
            EmailMessage.Create(EMAILS_F, 'Verification OTP', HtmlEmailBody, True);
            IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

            END;


            // smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default);
            // SLEEP(10000);


            //SMTPSetup.GET;
            // smtpMail.CreateMessage(SMTPSetup.Name, SMTPSetup."Email Address", EMAILS_F, 'Verification OTP',
            //   '', TRUE);

            // smtpMail.AppendBody('<br>');
            // smtpMail.AppendBody('<br/>');
            // smtpMail.AppendBody('Dear Sir / Madam,');
            // smtpMail.AppendBody('<br/>');
            // smtpMail.AppendBody('<br>');
            // smtpMail.AppendBody(BodyMessages_F);
            // smtpMail.AppendBody('<br/>');
            // smtpMail.AppendBody('<br>');
            // smtpMail.AppendBody('Regards');
            // smtpMail.AppendBody('<br/>');
            // smtpMail.AppendBody('<br>');
            // smtpMail.AppendBody(SMTPSetup."Email Sender Name");
            // smtpMail.AppendBody('<br/>');
            // smtpMail.Send;
            // EmailBody.Add('<br>');
            // EmailBody.Add('<br/>');
            // EmailBody.Add('Dear Sir / Madam,');
            // EmailBody.Add('<br/>');
            // EmailBody.Add('<br>');
            // EmailBody.Add(BodyMessages_F);
            // EmailBody.Add('<br/>');
            // EmailBody.Add('<br>');
            // EmailBody.Add('Regards');
            // EmailBody.Add('<br/>');
            // EmailBody.Add('<br>');
            // EmailBody.Add(SMTPSetup.Name);
            // EmailBody.Add('<br/>');

            // //MsgTxt.split(EmailBody);
            // Message('%1', EmailBody.Count);
            // EmailMessage.Create(EMAILS_F, 'Verification OTP', Format(EmailBody));
            // smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default);
            // SLEEP(10000);


        END;

        COMMIT;
    end;


    procedure SetEmailfilters(EMAILS: Text; BodyMessages: Text)
    begin
        EMAILS_F := EMAILS;
        BodyMessages_F := BodyMessages;
    end;
}

