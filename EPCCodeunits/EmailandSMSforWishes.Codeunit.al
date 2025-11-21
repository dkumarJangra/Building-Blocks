codeunit 97739 "Email and SMS for Wishes"
{
    // 08022022 code comment after discuss with client

    Permissions = TableData "Bank Account Ledger Entry" = rimd;

    trigger OnRun()
    begin
        //EmailtoVendorandCustomer;

        //VendorBirthday;
        IF CustomerBirth THEN
            CustomerBirthday(CustCode_1);
        //EmployeesBirthday;
    end;

    var
        ComInfo: Record "Company Information";
        PostPayment: Codeunit PostPayment;
        GetDescription: Codeunit GetDescription;
        Bondsetup: Record "Unit Setup";
        "Parameter String": Text[30];
        //SMTP: Codeunit 400;
        //SMTPMailSetup: Record 409;
        Customer: Record Customer;
        CustMobileNo: Text[30];
        CustSMSText: Text[1000];
        MBNo: Text[30];
        CustCode_1: Code[20];
        CustomerBirth: Boolean;
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];


    procedure EmailtoVendorandCustomer()
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        CustSMSText: Text[200];
    begin
        /*
        ComInfo.GET;
        SMTPMailSetup.GET;
        Customer.RESET;
        Customer.SETRANGE("No.",'C0000007');
        Customer.SETFILTER("Date of Birth",'<>%1',0D);
        Customer.SETFILTER("E-Mail",'<>%1','');
        IF Customer.FINDSET THEN
          REPEAT
           CustSMSText := 'Dear ' + Customer.Name+', Building Blocks wishes You a Very Happy Birthday! We wish that peace, prosperity'+
                        ' and happiness be with you. Thanks for being Valued Customer..';
            SMTP.CreateMessage(SMTPMailSetup."Email Sender Name",SMTPMailSetup."Email Sender Email",Customer."E-Mail",'Birthday Wish',
                    CustSMSText,TRUE);
        {
          SMTPMailSetup.AppendBody('<br>');
          SMTPMailSetup.AppendBody('<br/>');
          SMTPMailSetup.AppendBody('Dear Sir / Madam,');
          SMTPMailSetup.AppendBody('<br/>');
          SMTPMailSetup.AppendBody('<br>');
          SMTPMailSetup.AppendBody('Please find the attached Report');
          SMTPMailSetup.AppendBody('<br/>');
          SMTPMailSetup.AppendBody('<br>');
          SMTPMailSetup.AppendBody('Regards');
          SMTPMailSetup.AppendBody('<br/>');
          SMTPMailSetup.AppendBody('<br>');
          SMTPMailSetup.AppendBody('Team BBG');
          SMTPMailSetup.AppendBody('<br/>');
          SMTPMailSetup.AddAttachment(ExcelSheetName);
         }
        
             // Dear customer name, Building Blocks wishes You A Very Happy Wedding Anniversary! We wish that peace, prosperity and happines
        s'
        //   + be with you. Thanks for being Valued Customer..;
        //Regards,
        //Team BBG.
            SMTP.Send;
          UNTIL Customer.NEXT =0;
         */

    end;


    procedure VendorBirthday()
    var
        Vend: Record Vendor;
        Month: Integer;
        Days: Integer;
        Month_1: Integer;
        Days_1: Integer;
    begin
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            Vend.RESET;
            Vend.SETFILTER(Vend."BBG Date of Birth", '<>%1', 0D);
            Vend.SETRANGE("BBG Status", Vend."BBG Status"::Active);
            Vend.SETFILTER("BBG Mob. No.", '<>%1', '');
            IF Vend.FINDSET THEN
                REPEAT
                    Month := DATE2DMY(Vend."BBG Date of Birth", 2);
                    Days := DATE2DMY(Vend."BBG Date of Birth", 1);
                    Month_1 := DATE2DMY(TODAY, 2);
                    Days_1 := DATE2DMY(TODAY, 1);

                    IF (Days_1 = Days) AND (Month = Month_1) THEN BEGIN
                        CustMobileNo := '';
                        CustMobileNo := Vend."BBG Mob. No.";
                        CustSMSText := '';
                        CustSMSText := 'Dear ' + Customer.Name +
                            ', Life is like a fond memory that makes U cherish-Your True Wealth. On your Birthday BBG wishes ' +
                          'U long life filled with beautiful memories.BBGIND';

                        PostPayment.SendSMS(CustMobileNo, CustSMSText);
                        //ALLEDK15112022 Start
                        CLEAR(SMSLogDetails);
                        SmsMessage := '';
                        SmsMessage1 := '';
                        SmsMessage := COPYSTR(CustSMSText, 1, 250);
                        SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                        SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vend."No.", Vend.Name, 'Associate Birthday', '', '', '');
                        //ALLEDK15112022 END
                    END;
                UNTIL Vend.NEXT = 0;
        END;
    end;


    procedure CustomerBirthday(CustCode: Code[20])
    var
        Month: Integer;
        Days: Integer;
        Month_1: Integer;
        Days_1: Integer;
    begin
        /* //08022022
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
          MBNo := '';
          Customer.RESET;
          Customer.SETCURRENTKEY("Mobile No.");
          Customer.SETRANGE("No.",CustCode);
          Customer.SETFILTER("Date of Birth",'<>%1',0D);
          Customer.SETFILTER("Mobile No.",'<>%1','');
          IF Customer.FINDSET THEN
            REPEAT
              IF MBNo <> Customer."Mobile No." THEN BEGIN
                MBNo := Customer."Mobile No.";
                Month := DATE2DMY(Customer."Date of Birth",2);
                Days := DATE2DMY(Customer."Date of Birth",1);
                Month_1 := DATE2DMY(TODAY,2);
                Days_1 := DATE2DMY(TODAY,1);
                IF (Days_1 = Days) AND (Month = Month_1) THEN BEGIN
                  CustMobileNo := '';
                  CustMobileNo := Customer."Mobile No.";
                  CustSMSText := '';
                CustSMSText := 'Dear ' + Customer.Name+
                    ', Life is like a fond memory that makes U cherish-Your True Wealth on your Birthday BBG wishes you long '+
                  'life filled with beautiful memories.BBGIND';
        
        
                     PostPayment.SendSMS(CustMobileNo,CustSMSText);
                END;
              END;
            UNTIL Customer.NEXT =0;
        END;
        */ ////08022022

    end;


    procedure EmployeesBirthday()
    var
        Employee: Record Employee;
        Month: Integer;
        Days: Integer;
        Month_1: Integer;
        Days_1: Integer;
    begin
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            Employee.RESET;
            Employee.SETFILTER("Birth Date", '<>%1', 0D);
            Employee.SETFILTER("Mobile Phone No.", '<>%1', '');
            IF Employee.FINDSET THEN
                REPEAT
                    Month := DATE2DMY(Employee."Birth Date", 2);
                    Days := DATE2DMY(Employee."Birth Date", 1);
                    Month_1 := DATE2DMY(TODAY, 2);
                    Days_1 := DATE2DMY(TODAY, 1);
                    IF (Days_1 = Days) AND (Month = Month_1) THEN BEGIN
                        CustMobileNo := '';
                        CustMobileNo := Employee."Mobile Phone No.";
                        CustSMSText := '';
                        CustSMSText := 'Dear ' + Employee."Full Name" + ', Building Blocks wishes You a Very Happy Birthday! We wish that peace,' +
                                      'prosperity and happiness be with you.BBGIND';
                        PostPayment.SendSMS(CustMobileNo, CustSMSText);
                        //ALLEDK15112022 Start
                        CLEAR(SMSLogDetails);
                        SmsMessage := '';
                        SmsMessage1 := '';
                        SmsMessage := COPYSTR(CustSMSText, 1, 250);
                        SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                        SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Employee', Employee."No.", Employee."Full Name", 'Employee Birthday', '', '', '');
                        //ALLEDK15112022 END
                    END;
                UNTIL Employee.NEXT = 0;
        END;
    end;


    procedure GETValueSMS(Type: Text[30]; CustomerCode: Code[20])
    begin
        IF Type = 'CustomerBirth' THEN
            CustomerBirth := TRUE;

        CustCode_1 := CustomerCode;
    end;
}

