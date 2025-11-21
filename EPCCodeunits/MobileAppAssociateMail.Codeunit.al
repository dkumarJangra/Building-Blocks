codeunit 50006 "Mobile App Associate Mail"
{
    TableNo = "Web Log Details";

    trigger OnRun()
    var
        DataExch1: Record "Data Exch. Field";
        ResponseInStream_L: InStream;
        // HttpStatusCode_L: DotNet HttpStatusCode;
        // ResponseHeaders_L: DotNet NameValueCollection;
        ResponseText: Text;
        FL: File;
        AAAAA: BigText;
    begin

        SendMail(RequestText1_2, TypeofRequest_2, RequestSubject_2, MailRequest_2);
    end;

    var
        AssociateLoginDetails: Record "Associate Login Details";
        RequestText1_2: Text;
        TypeofRequest_2: Text;
        RequestSubject_2: Text;
        MailRequest_2: Text;


    procedure SendMail(RequestText1: Text; TypeofRequest: Text; RequestSubject: Text; MailRequest: Text)
    var
        Jtext: Text;
        //JObject: DotNet JObject;
        VendMBNo: Text;
        VendPassWord: Text;
        // smtpMail: Codeunit 400;
        // SMTPSetup: Record "SMTP Mail Setup";
        Vend: Record Vendor;
        User_Code: Text;
        VendUser_ID1: Integer;
        VendUser_ID: Integer;
        MailCompanyInformation: Record "Company Information";
        HtmlEmailBody: text;
        smtpMail: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        SMTPSetup: Record "Email Account";
        ArrayJSONManagement: Codeunit "JSON Management";
        JSONManagement: Codeunit "JSON Management";
        ObjectJSONManagement: Codeunit "JSON Management";
        i: Integer;
        CodeText: Text;
        CustomerJsonObject: Text;
        JsonArrayText: Text;
        JsonData: Text;

    begin
        MailCompanyInformation.GET;
        IF MailCompanyInformation."Send mail for mobile login" THEN BEGIN

            Jtext := RequestText1;
            IF MailRequest = 'Login' THEN BEGIN
                IF Jtext <> '' THEN BEGIN

                    // JObject := JObject.Parse(Jtext);
                    // VendMBNo := JObject.GetValue('mobileNumber').ToString;  //Pass the value of node in GetValue
                    // VendPassWord := JObject.GetValue('password').ToString;  //Pass the value of node in GetValue

                    JSONManagement.InitializeObject(RequestText1);
                    ObjectJSONManagement.InitializeObject(RequestText1);//CustomerJsonObject);
                    ObjectJSONManagement.GetStringPropertyValueByName('mobileNumber', CodeText);
                    VendMBNo := CodeText;
                    ObjectJSONManagement.GetStringPropertyValueByName('password', CodeText);  //041224
                    VendPassWord := CodeText;
                    AssociateLoginDetails.RESET;
                    AssociateLoginDetails.SETRANGE("Mobile_ No", VendMBNo);
                    AssociateLoginDetails.SETRANGE(Password, VendPassWord);
                    IF AssociateLoginDetails.FINDFIRST THEN BEGIN
                        IF Vend.GET(AssociateLoginDetails.Associate_ID) THEN BEGIN
                            IF Vend."E-Mail" <> '' THEN BEGIN

                                CLEAR(smtpMail);
                                SMTPSetup.Reset();
                                SMTPSetup.SetFilter(Name, '<>%1', '');
                                if SMTPSetup.FindFirst() then;

                                HtmlEmailBody := '<!DOCTYPE html><html><body>';
                                HtmlEmailBody += '<br>';
                                HtmlEmailBody += 'Dear Sir / Madam,';
                                HtmlEmailBody += '<br/>';

                                HtmlEmailBody += '<br>';
                                HtmlEmailBody += TypeofRequest;
                                HtmlEmailBody += '<br/>';

                                HtmlEmailBody += '<br>';
                                HtmlEmailBody += 'Regards';
                                HtmlEmailBody += '<br/>';

                                HtmlEmailBody += '<br>';
                                HtmlEmailBody += 'Building Blocks Group';
                                HtmlEmailBody += '<br/>';
                                HtmlEmailBody += '</body></html>';

                                EmailMessage.Create(Vend."E-Mail", RequestSubject, HtmlEmailBody, True);
                                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                                END;


                                // CLEAR(smtpMail);
                                // SMTPSetup.GET;
                                // smtpMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", Vend."E-Mail", RequestSubject,
                                //    '', TRUE);

                                // smtpMail.AppendBody('<br>');
                                // smtpMail.AppendBody('<br/>');
                                // smtpMail.AppendBody('Dear Sir / Madam,');
                                // smtpMail.AppendBody('<br/>');
                                // smtpMail.AppendBody('<br>');
                                // smtpMail.AppendBody(TypeofRequest);
                                // smtpMail.AppendBody('<br/>');
                                // smtpMail.AppendBody('<br>');
                                // smtpMail.AppendBody('Regards');
                                // smtpMail.AppendBody('<br/>');
                                // smtpMail.AppendBody('<br>');
                                // smtpMail.AppendBody(SMTPSetup."Email Sender Name");
                                // smtpMail.AppendBody('<br/>');
                                // smtpMail.Send;
                                SLEEP(10000);
                            END;
                        END;
                    END;
                END;
            END;
            IF MailRequest = 'PasswordChange' THEN BEGIN
                IF Jtext <> '' THEN BEGIN
                    // JObject := JObject.Parse(Jtext);
                    // VendMBNo := JObject.GetValue('mobileNumber').ToString;  //Pass the value of node in GetValue
                    // User_Code := JObject.GetValue('User_ID').ToString;  //Pass the value of node in GetValue
                    JSONManagement.InitializeObject(RequestText1);
                    ObjectJSONManagement.InitializeObject(RequestText1);//CustomerJsonObject);
                    ObjectJSONManagement.GetStringPropertyValueByName('mobileNumber', CodeText);
                    VendMBNo := CodeText;
                    ObjectJSONManagement.GetStringPropertyValueByName('User_ID', CodeText);  //041224
                    User_Code := CodeText;

                    EVALUATE(VendUser_ID1, User_Code);
                    VendUser_ID := VendUser_ID1;
                    AssociateLoginDetails.RESET;
                    AssociateLoginDetails.SETRANGE(USER_ID, VendUser_ID);
                    AssociateLoginDetails.SETRANGE("Mobile_ No", VendMBNo);
                    IF AssociateLoginDetails.FINDFIRST THEN BEGIN
                        IF Vend.GET(AssociateLoginDetails.Associate_ID) THEN BEGIN
                            IF Vend."E-Mail" <> '' THEN BEGIN

                                CLEAR(smtpMail);
                                SMTPSetup.Reset();
                                SMTPSetup.SetFilter(Name, '<>%1', '');
                                if SMTPSetup.FindFirst() then;

                                HtmlEmailBody := '<!DOCTYPE html><html><body>';
                                HtmlEmailBody += '<br>';
                                HtmlEmailBody += 'Dear Sir / Madam,';
                                HtmlEmailBody += '<br/>';

                                HtmlEmailBody += '<br>';
                                HtmlEmailBody += TypeofRequest;
                                HtmlEmailBody += '<br/>';

                                HtmlEmailBody += '<br>';
                                HtmlEmailBody += 'Regards';
                                HtmlEmailBody += '<br/>';

                                HtmlEmailBody += '<br>';
                                HtmlEmailBody += 'Building Blocks Group';
                                HtmlEmailBody += '<br/>';
                                HtmlEmailBody += '</body></html>';

                                EmailMessage.Create(Vend."E-Mail", RequestSubject, HtmlEmailBody, True);
                                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                                END;

                                // CLEAR(smtpMail);
                                // SMTPSetup.GET;
                                // smtpMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", Vend."E-Mail", RequestSubject,
                                //    '', TRUE);

                                // smtpMail.AppendBody('<br>');
                                // smtpMail.AppendBody('<br/>');
                                // smtpMail.AppendBody('Dear Sir / Madam,');
                                // smtpMail.AppendBody('<br/>');
                                // smtpMail.AppendBody('<br>');
                                // smtpMail.AppendBody(TypeofRequest);
                                // smtpMail.AppendBody('<br/>');
                                // smtpMail.AppendBody('<br>');
                                // smtpMail.AppendBody('Regards');
                                // smtpMail.AppendBody('<br/>');
                                // smtpMail.AppendBody('<br>');
                                // smtpMail.AppendBody(SMTPSetup."Email Sender Name");
                                // smtpMail.AppendBody('<br/>');
                                // smtpMail.Send;
                                SLEEP(10000);
                            END;
                        END;
                    END;
                END;

            END;

        END;
    end;


    procedure ValueFilters(RequestText1: Text; TypeofRequest: Text; RequestSubject: Text; MailRequest: Text)
    begin
        RequestText1_2 := RequestText1;
        TypeofRequest_2 := TypeofRequest;
        RequestSubject_2 := RequestSubject;
        MailRequest_2 := MailRequest;
    end;
}

