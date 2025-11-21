codeunit 50044 "Mobile App Customer Mail"
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

        CustomerSendMail(RequestText1_2, TypeofRequest_2, RequestSubject_2, MailRequest_2);
    end;

    var
        AssociateLoginDetails: Record "Associate Login Details";
        RequestText1_2: Text;
        TypeofRequest_2: Text;
        RequestSubject_2: Text;
        MailRequest_2: Text;


    procedure CustomerSendMail(RequestText1: Text; TypeofRequest: Text; RequestSubject: Text; MailRequest: Text)
    var
        Jtext: Text;
        //JObject: DotNet JObject;
        VendMBNo: Text;
        VendPassWord: Text;
        // smtpMail: Codeunit 400;
        // SMTPSetup: Record "SMTP Mail Setup";
        Customer: Record Customer;
        User_Code: Text;
        VendUser_ID1: Integer;
        VendUser_ID: Integer;
        MailCompanyInformation: Record "Company Information";
        CustomerLoginDetails_1: Record "Customer Login Details";
    begin
        MailCompanyInformation.GET;
        IF MailCompanyInformation."Send mail for mobile login" THEN BEGIN
            IF MailRequest = 'Login' THEN BEGIN
                IF Jtext <> '' THEN BEGIN
                    // JObject := JObject.Parse(Jtext);
                    // VendMBNo := JObject.GetValue('mobileNumber').ToString;  //Pass the value of node in GetValue
                    // VendPassWord := JObject.GetValue('password').ToString;  //Pass the value of node in GetValue
                    CustomerLoginDetails_1.RESET;
                    CustomerLoginDetails_1.SETRANGE("Mobile No.", VendMBNo);
                    CustomerLoginDetails_1.SETRANGE(Password, VendPassWord);
                    IF CustomerLoginDetails_1.FINDFIRST THEN BEGIN
                        IF Customer.GET(CustomerLoginDetails_1."Customer No.") THEN BEGIN
                            IF Customer."E-Mail" <> '' THEN BEGIN
                                // CLEAR(smtpMail);
                                // SMTPSetup.GET;
                                // smtpMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", Customer."E-Mail", RequestSubject,
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
                    EVALUATE(VendUser_ID1, User_Code);
                    VendUser_ID := VendUser_ID1;
                    CustomerLoginDetails_1.RESET;
                    CustomerLoginDetails_1.SETRANGE(USER_ID, VendUser_ID);
                    CustomerLoginDetails_1.SETRANGE("Mobile No.", VendMBNo);
                    IF CustomerLoginDetails_1.FINDFIRST THEN BEGIN
                        IF Customer.GET(CustomerLoginDetails_1."Customer No.") THEN BEGIN
                            IF Customer."E-Mail" <> '' THEN BEGIN
                                // CLEAR(smtpMail);
                                // SMTPSetup.GET;
                                // smtpMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", Customer."E-Mail", RequestSubject,
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


    procedure CustomerValueFilters(RequestText1: Text; TypeofRequest: Text; RequestSubject: Text; MailRequest: Text)
    begin
        RequestText1_2 := RequestText1;
        TypeofRequest_2 := TypeofRequest;
        RequestSubject_2 := RequestSubject;
        MailRequest_2 := MailRequest;
    end;
}

