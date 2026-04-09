codeunit 50076 "Send Whatsup Email"

{

    trigger OnRun()
    begin
        SendWhatupEmail;
    end;

    var
        EMAILS_F: Text;
        BodyMessages_F: Text;
        AppCode: code[20];
        ProjName: Text[200];
        PlotNo: code[20];
        DueDt: Date;
        DueAmt: Decimal;
        CustName: Text[100];



    local procedure SendWhatupEmail()
    var
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
            HtmlEmailBody += 'Dear ' + '<b>' + CustName + '</b>' + ',';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'This is a gentle reminder that a payment of ₹' + '<b>' + format(DueAmt) + '</b>' + ' is due on ' + '<b>' + format(DueDt, 0, '<Day, 2>-<Month, 2>-<Year4>') + '</b>' + '.';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Please find the details below:';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Project: ' + '<b>' + format(ProjName) + '</b>';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Plot No: ' + '<b>' + format(PlotNo) + '</b>';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'Application No: ' + '<b>' + format(AppCode) + '</b>';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += 'We request you to kindly' + '<b>' + ' complete the payment on or before the due date to avoid any inconvenience ' + '</b>' + ', including potential vacating procedures.' +
                             'If you have' + '<b>' + ' already made the payment, please disregard this message' + '</b>' + '. For any assistance or clarification, feel free to reach out to us.' +
                             'Thank you for your continued association.';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += '<b>' + 'Warm regards,' + '</b>';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += '<b>' + 'Building Blocks Groups,' + '</b>';//SMTPSetup."Name";
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '<br>';
            HtmlEmailBody += '<b>' + 'Collections Department.' + '</b>';
            HtmlEmailBody += '<br/>';
            HtmlEmailBody += '</body></html>';
            EmailMessage.Create(EMAILS_F, 'Payment Reminder from BBG -' + ProjName + '| Application No: ' + AppCode, HtmlEmailBody, True);
            IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::"Vendor Remittance") THEN begin

            END;
        END;
        COMMIT;
    end;

    procedure SetEmailfilters(EMAILS: Text; CustomerName: text[100]; ApplicationCode: Code[20]; ProjectName: text[200]; PlotId: Code[20]; DueDate: date; Dueamount: Decimal)
    begin
        EMAILS_F := EMAILS;
        CustName := CustomerName;
        AppCode := ApplicationCode;
        ProjName := ProjectName;
        PlotNo := PlotId;
        DueDt := DueDate;
        DueAmt := Dueamount;
    end;

}


