codeunit 50013 "Create Associate / SendSMS"
{
    TableNo = "Associate Login Details";

    trigger OnRun()
    var
        RecVendor_1: Record Vendor;
        WebAppService: Codeunit "Web App Service";
        ExitVendCode: Code[20];
    begin
        AssociateLoginDetails.RESET;
        AssociateLoginDetails.SETRANGE(USER_ID, RecUSERID);
        IF AssociateLoginDetails.FINDFIRST THEN
            IF AssociateLoginDetails."Vendor Type" = AssociateLoginDetails."Vendor Type"::" " THEN
                ExitVendCode := CreateVendorMAster(RecUSERID, '')   //Code added 06102025 parameter 
            ELSE
                ExitVendCode := CreateCP_VendorMAster(RecUSERID);
    end;

    var
        AssociateLoginDetails: Record "Associate Login Details";
        VendNo: Code[20];
        Vendor: Record Vendor;
        RegionwiseVendor: Record "Region wise Vendor";
        BondSetup: Record "Unit Setup";
        //NODHeader: Record 13786;
        //NODLine: Record 13785;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        Vend: Record Vendor;
        RecVendorBankAccount: Record "Vendor Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
        PostPayment: Codeunit PostPayment;
        SMS: Text;
        //SMTPSetup: Record "SMTP Mail Setup";
        //SMTPMail: Codeunit 400;
        CompanyInformation: Record "Company Information";
        IntVender: Record Vendor;
        UserDocumentAttachment: Record "User Document Attachment";
        unitsetup: Record "Unit Setup";
        Filename: Text;
        RecUSERID: Integer;
        AssociateTeamforGamifiction: Report "Team Head Name Update";
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        MobFirstLetter: Text;
        CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";
        ExitMessage: Boolean;
        CustomersLead_2: Record "Customers Lead_2";
        CheckVendPanNo: Record Vendor;
        Text016: Label 'Duplicate PAN No.';


    procedure Setvalue(RecUSERID1: Integer)
    begin
        RecUSERID := RecUSERID1;
    end;

    procedure CreateVendorMAster(RecUserID_1: Integer): Code[20]   //06102025  Added NewRegionCode
    var
        RecVendor_1: Record Vendor;
        HtmlEmailBody: text;
        smtpMail: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        SMTPSetup: Record "Email Account";
        AttachmentStream: InStream;
        AllowedSection: Record "Allowed Sections";
        RankCodeMaster: Record "Rank Code";
        AssStatus: Text;
        WebAppService: Codeunit "Web App Service";
    begin
        AssociateLoginDetails.RESET;
        AssociateLoginDetails.SETRANGE(USER_ID, RecUserID_1);
        AssociateLoginDetails.SETRANGE("NAV-Associate Created", FALSE);
        AssociateLoginDetails.SETFILTER(Status, '%1|%2', AssociateLoginDetails.Status::"Under Process", AssociateLoginDetails.Status::"Sent for Approval");
        IF AssociateLoginDetails.FINDFIRST THEN BEGIN

            //210224 Added new code
            CLEAR(CheckMobileNoforSMS);
            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(AssociateLoginDetails."Mobile_ No", FALSE);
            IF NOT ExitMessage THEN
                ERROR('Mobile no. invalid');
            RecVendor_1.RESET;
            RecVendor_1.SETCURRENTKEY("BBG Mob. No.");
            RecVendor_1.SETRANGE("BBG Mob. No.", AssociateLoginDetails."Mobile_ No");
            IF RecVendor_1.FINDFIRST THEN
                ERROR('Mobile no already exists' + AssociateLoginDetails."Mobile_ No");
            MobFirstLetter := '';
            MobFirstLetter := COPYSTR(AssociateLoginDetails."Mobile_ No", 1, 1);
            IF MobFirstLetter = 'R' THEN
                ERROR('Mobile no. invalid');

            VendNo := '';
            VendNo := NoSeriesManagement.GetNextNo('VEND-IBA', TODAY, TRUE);

            Vendor.INIT;
            Vendor."No." := VendNo;
            Vendor.Name := AssociateLoginDetails.Name;
            Vendor."BBG Mob. No." := AssociateLoginDetails."Mobile_ No";

            Vendor."BBG Introducer" := AssociateLoginDetails.Introducer_Code;
            Vendor."BBG Date of Joining" := AssociateLoginDetails.Date_OF_Joining;
            Vendor."BBG Vendor Category" := Vendor."BBG Vendor Category"::"IBA(Associates)";
            Vendor.Address := COPYSTR(AssociateLoginDetails.Address, 1, 50);
            ;
            Vendor."Address 2" := COPYSTR(AssociateLoginDetails.Address, 51, 50);
            Vendor."BBG Address 3" := COPYSTR(AssociateLoginDetails.Address, 101, 50);
            Vendor."BBG Associate Password" := AssociateLoginDetails.Password;
            IF AssociateLoginDetails.PAN_No = 'PANAPPLIED' THEN BEGIN
                Vendor."P.A.N. No." := 'PANAPPLIED';
                Vendor."P.A.N. Status" := Vendor."P.A.N. Status"::PANAPPLIED;
            END ELSE
                Vendor."P.A.N. No." := AssociateLoginDetails.PAN_No;
            Vendor."BBG Nationality" := 'Indian';
            Vendor."BBG Marital Status" := Vendor."BBG Marital Status"::Unmarried;
            Vendor."Vendor Posting Group" := 'ASSC_DOM';
            Vendor."Gen. Bus. Posting Group" := 'DOMESTIC';
            Vendor."BBG Date of Birth" := AssociateLoginDetails.Date_OF_Birth;
            Vendor."BBG Associate Creation" := Vendor."BBG Associate Creation"::New;
            Vendor."BBG Web User_ID" := AssociateLoginDetails.USER_ID;
            Vendor."BBG Status" := Vendor."BBG Status"::Active;
            Vendor."BBG Web Associate Payment Active" := TRUE;
            Vendor."E-Mail" := AssociateLoginDetails."Email-Id";
            Vendor."BBG Creation Date" := AssociateLoginDetails."Creation Date";
            Vendor."BBG Create from Web/Mobile" := TRUE;
            Vendor."BBG Age" := AssociateLoginDetails.Age;
            Vendor."BBG Father Name" := AssociateLoginDetails."Father Name";
            Vendor.City := AssociateLoginDetails.City;
            Vendor."BBG Nominee Name" := AssociateLoginDetails."Nominee Name";
            Vendor."Post Code" := AssociateLoginDetails.Post_Code;
            Vendor."BBG Designation" := AssociateLoginDetails.Designation;
            Vendor."E-Mail" := AssociateLoginDetails."Email-Id";
            Vendor."BBG Associate Password" := 'BBG@1234';
            Vendor."BBG Reporting Office" := AssociateLoginDetails."Reporting Office";  //030524
            Vendor."BBG New Cluster Code" := AssociateLoginDetails."New Cluster Code";  //030524
            Vendor."Region/Districts Code" := AssociateLoginDetails."Region/Districts Code";  //270325
            IF AssociateLoginDetails.Gender = 'Male' THEN
                Vendor."BBG Sex" := Vendor."BBG Sex"::Male;
            IF AssociateLoginDetails.Gender = 'Female' THEN
                Vendor."BBG Sex" := Vendor."BBG Sex"::Female;
            Vendor.Validate("Assessee Code", 'IND');//ALLE-AM
            Vendor."State Code" := AssociateLoginDetails."State Code"; //23072025 Code added
            Vendor."District Code" := AssociateLoginDetails."District Code";  //23072025 Code added
            Vendor."Mandal Code" := AssociateLoginDetails."Mandal Code";  //23072025 Code added
            vendor."Village Code" := AssociateLoginDetails."Village Code";   //23072025 Code added
            IF AssociateLoginDetails."Aadhaar Number" <> '' then
                Vendor."BBG Aadhar No." := AssociateLoginDetails."Aadhaar Number"; //23072025 Code added
            Vendor."Country/Region Code" := 'IN';  //23072025 Code added
            Vendor.INSERT;
            //ALLE-AM
            AllowedSection.Init();
            AllowedSection."Vendor No" := Vendor."No.";
            AllowedSection.Validate("TDS Section", '194H');
            AllowedSection.Insert(true);
            //ALLE-AM
            CheckVendPanNo.RESET;
            CheckVendPanNo.SETFILTER("No.", '<>%1', Vendor."No.");
            CheckVendPanNo.SETRANGE("P.A.N. No.", Vendor."P.A.N. No.");
            CheckVendPanNo.SETRANGE("BBG Vendor Category", Vendor."BBG Vendor Category");//ALLETDK120413
            IF CheckVendPanNo.FINDFIRST THEN BEGIN
                IF CheckVendPanNo."P.A.N. No." <> 'PANAPPLIED' THEN
                    ERROR(Text016, Vendor."P.A.N. No.");
            END;

            AssociateLoginDetails."NAV-Associate Created" := TRUE;
            AssociateLoginDetails."NAV-Associate Creation Date" := TODAY;
            AssociateLoginDetails.Associate_ID := Vendor."No.";
            AssociateLoginDetails."Vendor Profile Status" := AssociateLoginDetails."Vendor Profile Status"::Close;
            //AssociateLoginDetails."Send for Associate Create" := TRUE;
            AssociateLoginDetails.Status := AssociateLoginDetails.Status::Approved;
            AssociateLoginDetails.MODIFY;

            //ALLEDK 221123
            //CLEAR(WebAppService);
            // WebAppService.Post_data('',Vendor."No.",Vendor.Name,Vendor."Mob. No.",Vendor."E-Mail",Vendor."Team Code",Vendor."Leader Code",Vendor.Introducer);
            //ALLEDK 221123


            //050324 code added start
            CustomersLead_2.RESET;
            CustomersLead_2.SETRANGE("Mobile Phone No.", Vendor."BBG Mob. No.");
            CustomersLead_2.SETRANGE("Lead Associate / Customer Id", '');
            CustomersLead_2.SETRANGE("Request From", CustomersLead_2."Request From"::Vendor);
            IF CustomersLead_2.FINDSET THEN
                REPEAT
                    CustomersLead_2."Lead Associate / Customer Id" := Vendor."No.";
                    CustomersLead_2.MODIFY;
                UNTIL CustomersLead_2.NEXT = 0;
            //050324 code added END




            UserDocumentAttachment.RESET;
            UserDocumentAttachment.SETRANGE(USER_ID, AssociateLoginDetails.USER_ID);
            IF UserDocumentAttachment.FINDSET THEN
                REPEAT
                    UserDocumentAttachment."Associate ID" := Vendor."No.";
                    UserDocumentAttachment.MODIFY;
                UNTIL UserDocumentAttachment.NEXT = 0;

            RegionwiseVendor.INIT;

            IF AssociateLoginDetails."Region Code" = 'AP' THEN
                RegionwiseVendor."Region Code" := 'R0002'
            ELSE
                RegionwiseVendor."Region Code" := 'R0001';


            RegionwiseVendor.VALIDATE("No.", Vendor."No.");
            IF AssociateLoginDetails.Rank_Code <> 0 THEN
                RegionwiseVendor."Rank Code" := AssociateLoginDetails.Rank_Code
            ELSE
                RegionwiseVendor."Rank Code" := 1.0;
            IF AssociateLoginDetails.Parent_ID <> '' THEN
                RegionwiseVendor."Parent Code" := AssociateLoginDetails.Parent_ID
            ELSE
                RegionwiseVendor."Parent Code" := AssociateLoginDetails.Introducer_Code;

            RegionwiseVendor."Associate DOJ" := AssociateLoginDetails.Date_OF_Joining;
            RegionwiseVendor.INSERT;
            RegionwiseVendor.VALIDATE("Rank Code");
            RegionwiseVendor.VALIDATE("Parent Code");
            RegionwiseVendor.MODIFY;


            //ALLEDK 160922
            CLEAR(AssociateTeamforGamifiction);
            AssociateTeamforGamifiction.ReportValues(RegionwiseVendor."No.", RegionwiseVendor."Region Code");
            AssociateTeamforGamifiction.RUNMODAL;
            //ALLEDK 160922

            //060525 Code added Start
            RankCodeMaster.RESET;
            RankCodeMaster.SETRANGE("Rank Batch Code", RegionwiseVendor."Region Code");
            RankCodeMaster.SETRANGE(Code, RegionwiseVendor."Rank Code");
            IF RankCodeMaster.FINDFIRST THEN;
            IF Vendor."BBG Black List" THEN
                AssStatus := 'Deactivate'
            ELSE
                AssStatus := 'Active';

            WebAppService.Post_data('', Vendor."No.", Vendor.Name, Vendor."BBG Mob. No.", Vendor."E-Mail", Vendor."BBG Team Code", Vendor."BBG Leader Code", RegionwiseVendor."Parent Code",  //060525 Code added
                                       FORMAT(AssStatus), FORMAT(RegionwiseVendor."Rank Code"), RankCodeMaster.Description);   //060525 Code added

            //060525 Code added END                                       

            BondSetup.GET;
            BondSetup.TESTFIELD("TDS Nature of Deduction");
            /*
            NODHeader.RESET;
            IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vendor."No.") THEN BEGIN
                NODHeader.INIT;
                NODHeader.Type := NODHeader.Type::Vendor;
                NODHeader."No." := Vendor."No.";
                NODHeader."Assesse Code" := 'IND';
                NODHeader.INSERT;
            END;

            IF NOT NODLine.GET(NODLine.Type::Vendor, Vendor."No.", BondSetup."TDS Nature of Deduction") THEN BEGIN
                NODLine.Type := NODLine.Type::Vendor;
                NODLine."No." := Vendor."No.";
                NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                NODLine."Monthly Certificate" := TRUE;
                NODLine."Threshold Overlook" := TRUE;
                NODLine."Surcharge Overlook" := TRUE;
                NODLine.INSERT;
            END;
            *///Need to check the code in UAT

            //-----------------------------

            CompanywiseGLAccount.RESET;
            CompanywiseGLAccount.SETRANGE("MSC Company", FALSE);
            IF CompanywiseGLAccount.FINDSET THEN BEGIN
                REPEAT
                    Vend.RESET;
                    Vend.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    Vend.SETRANGE("No.", VendNo);
                    IF NOT Vend.FINDFIRST THEN BEGIN
                        Vend.INIT;
                        Vend.TRANSFERFIELDS(Vendor);
                        Vend.INSERT;
                    END;
                    BondSetup.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    BondSetup.GET;
                    BondSetup.TESTFIELD("TDS Nature of Deduction");
                    /*
                    NODHeader.RESET;
                    NODHeader.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vend."No.") THEN BEGIN
                        NODHeader.INIT;
                        NODHeader.Type := NODHeader.Type::Vendor;
                        NODHeader."No." := Vend."No.";
                        NODHeader."Assesse Code" := 'IND';
                        NODHeader.INSERT;
                    END;

                    NODLine.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    IF NOT NODLine.GET(NODLine.Type::Vendor, VendNo, BondSetup."TDS Nature of Deduction") THEN BEGIN
                        NODLine.Type := NODLine.Type::Vendor;
                        NODLine."No." := VendNo;
                        NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                        NODLine."Monthly Certificate" := TRUE;
                        NODLine."Threshold Overlook" := TRUE;
                        NODLine."Surcharge Overlook" := TRUE;
                        NODLine.INSERT;
                    END;
                    *///Need to check the code in UAT

                    RecVendorBankAccount.RESET;
                    RecVendorBankAccount.SETRANGE("Vendor No.", Vendor."No.");
                    IF RecVendorBankAccount.FINDSET THEN
                        REPEAT
                            VendorBankAccount.RESET;
                            VendorBankAccount.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                            VendorBankAccount.INIT;
                            VendorBankAccount := RecVendorBankAccount;
                            VendorBankAccount.INSERT;
                        UNTIL RecVendorBankAccount.NEXT = 0;

                    CLEAR(Vend);
                    Vend.RESET;
                    Vend.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    Vend.SETRANGE("No.", Vendor."No.");
                    IF Vend.FINDFIRST THEN BEGIN
                        Vend."Vendor Posting Group" := Vendor."Vendor Posting Group";
                        Vend."BBG Status" := Vendor."BBG Status";
                        Vend."BBG Date of Birth" := Vendor."BBG Date of Birth";
                        Vend."BBG Date of Joining" := Vendor."BBG Date of Joining";
                        Vend."BBG Sex" := Vendor."BBG Sex";
                        Vend."BBG Marital Status" := Vendor."BBG Marital Status";
                        Vend."BBG Nationality" := Vendor."BBG Nationality";
                        Vend."BBG Associate Creation" := Vendor."BBG Associate Creation";
                        Vend."Tax Liable" := Vendor."Tax Liable";
                        Vend."P.A.N. No." := Vendor."P.A.N. No.";
                        Vend."P.A.N. Status" := Vendor."P.A.N. Status";
                        Vend."Gen. Bus. Posting Group" := Vendor."Gen. Bus. Posting Group";
                        Vend.MODIFY;
                    END;
                UNTIL CompanywiseGLAccount.NEXT = 0;
            END;
            //-----------------------------

            CompanyInformation.GET;
            IF CompanyInformation."Send SMS" THEN BEGIN
                CLEAR(PostPayment);
                SMS := '';
                // SMS := 'Your ID'+Vendor."No."+',  Login Id-'+Vendor."Mob. No."+',  Password-'+AssociateLoginDetails.Password+'.BBGIND';  //120523 comment

                //SMS := 'Dear Mr/Ms:'+ FORMAT(Vendor.Name) +'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No." + 'PWD is '+FORMAT(Vendor."Associate Password") +'. Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official BBG WhatsApp channel '+
                //'for updates https://shorturl.at/dgDQV BGIND.';  //401023 New Code

                //Comment  new Message 150224

                //SMS :='Dear Mr/Ms: '+Vendor.Name+'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No."+' PWD is ' + FORMAT(Vendor."Associate Password")+' Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official BBG WhatsApp channel '+
                //'for updates https://shorturl.at/dgDQV BBGIND.';  //181023 code added

                //ADDED new Message 150224
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Vendor."BBG Mob. No.", FALSE);

                IF ExitMessage THEN
                    SMS := 'Dear Mr/Ms: ' + Vendor.Name + ' Congrats and Welcome to BBG Family. Your Business ID is ' + Vendor."No." + ' PWD is BBG@1234.' +                                         //240625 code Added
                         ' We Assure you of our Best Support in Transforming Your Dreams into Reality. Please join our BBG WhatsApp channel for updates https://whatsapp.com/channel/0029Va9v5xP6rsQkBNMHFw2V BBGIND.';  //240625 code Added




                // SMS := 'Dear Mr/Ms: ' + Vendor.Name + ' Congrats and Welcome to BBG Family.Your Business ID ' + Vendor."No." + ' PWD is BBG@1234 Thank you and Assure' +   //240625 code Commented
                //' you of our Best Support in Transforming Your Dreams into Reality.Please join the official BBG WhatsApp channel for updateshttps://shorturl.at/dgDQV BBG Family.';  //240625 code Commented


                //   SMS := 'Dear Mr/Ms:'+ FORMAT(Vendor.Name) +'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No." + 'PWD '+FORMAT(Vendor."Associate Password") +'. Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official telegram channel '+
                //'(BBG Post Office) for updates https://t.me/BBGPostoffice BBGIND.';//120523 New code
                PostPayment.SendSMS(Vendor."BBG Mob. No.", SMS);
                //ALLEDK15112022 Start
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(SMS, 1, 250);
                SmsMessage1 := COPYSTR(SMS, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Associate Login', '', '', '');
                //ALLEDK15112022 END
            END;
            COMMIT;
            IF Vendor."E-Mail" <> '' THEN BEGIN
                unitsetup.GET;
                Filename := '';
                Filename := unitsetup."Associate Mail Image Path";
                // /*                
                // SMTPSetup.GET;
                // SMTPMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", Vendor."E-Mail", 'Associate Onboard',
                //     '', TRUE);

                CLEAR(smtpMail);
                SMTPSetup.Reset();
                SMTPSetup.SetFilter(Name, '<>%1', '');
                if SMTPSetup.FindFirst() then;

                HtmlEmailBody := '<!DOCTYPE html><html><body>';



                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += 'Dear Sir,';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Your ID - ' + Vendor."No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Login ID - ' + Vendor."BBG Mob. No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Password - ' + AssociateLoginDetails.Password;
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Regards';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Building Blocks Group';
                HtmlEmailBody += '<br/>';
                EmailMessage.Create(Vendor."E-Mail", 'Associate Onboard', HtmlEmailBody, True);
                unitsetup."Associate Mail Image".CreateInStream(AttachmentStream);
                EmailMessage.AddAttachment('' + '.JPEG', '.JPEG', AttachmentStream);

                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                END;
                //SMTPMail.Send;
                //*///Need to check the code in UAT

                SLEEP(10000);
            END;

            IntVender.RESET;
            IntVender.GET(AssociateLoginDetails.Introducer_Code);


            IF IntVender."E-Mail" <> '' THEN BEGIN
                // /*
                // SMTPSetup.GET;
                // SMTPMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", IntVender."E-Mail", 'Associate Onboard',
                //     '', TRUE);

                CLEAR(smtpMail);
                SMTPSetup.Reset();
                SMTPSetup.SetFilter(Name, '<>%1', '');
                if SMTPSetup.FindFirst() then;

                HtmlEmailBody := '<!DOCTYPE html><html><body>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += 'Dear Sir,';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Your request for Mr.' + Vendor.Name + ' have been approved';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'ID : ' + Vendor."No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Welcome to BBG family';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Thanks';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Building Blocks Group';
                HtmlEmailBody += '<br/>';
                //SMTPMail.Send;
                EmailMessage.Create(IntVender."E-Mail", 'Associate Onboard', HtmlEmailBody, True);
                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                END;
                // *///Need to check the code in UAT

                SLEEP(10000);
            END;
        END;
        COMMIT;
    end;


    procedure CreateVendorMAster(RecUserID_1: Integer; NewRegionCode: Code[20]): Code[20]   //06102025  Added NewRegionCode
    var
        RecVendor_1: Record Vendor;
        HtmlEmailBody: text;
        smtpMail: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        SMTPSetup: Record "Email Account";
        AttachmentStream: InStream;
        AllowedSection: Record "Allowed Sections";
        RankCodeMaster: Record "Rank Code";
        AssStatus: Text;
        WebAppService: Codeunit "Web App Service";
    begin
        AssociateLoginDetails.RESET;
        AssociateLoginDetails.SETRANGE(USER_ID, RecUserID_1);
        AssociateLoginDetails.SETRANGE("NAV-Associate Created", FALSE);
        AssociateLoginDetails.SETFILTER(Status, '%1|%2', AssociateLoginDetails.Status::"Under Process", AssociateLoginDetails.Status::"Sent for Approval");
        IF AssociateLoginDetails.FINDFIRST THEN BEGIN

            //210224 Added new code
            CLEAR(CheckMobileNoforSMS);
            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(AssociateLoginDetails."Mobile_ No", FALSE);
            IF NOT ExitMessage THEN
                ERROR('Mobile no. invalid');
            RecVendor_1.RESET;
            RecVendor_1.SETCURRENTKEY("BBG Mob. No.");
            RecVendor_1.SETRANGE("BBG Mob. No.", AssociateLoginDetails."Mobile_ No");
            IF RecVendor_1.FINDFIRST THEN
                ERROR('Mobile no already exists' + AssociateLoginDetails."Mobile_ No");
            MobFirstLetter := '';
            MobFirstLetter := COPYSTR(AssociateLoginDetails."Mobile_ No", 1, 1);
            IF MobFirstLetter = 'R' THEN
                ERROR('Mobile no. invalid');

            VendNo := '';
            VendNo := NoSeriesManagement.GetNextNo('VEND-IBA', TODAY, TRUE);

            Vendor.INIT;
            Vendor."No." := VendNo;
            Vendor.Name := AssociateLoginDetails.Name;
            Vendor."BBG Mob. No." := AssociateLoginDetails."Mobile_ No";

            Vendor."BBG Introducer" := AssociateLoginDetails.Introducer_Code;
            Vendor."BBG Date of Joining" := AssociateLoginDetails.Date_OF_Joining;
            Vendor."BBG Vendor Category" := Vendor."BBG Vendor Category"::"IBA(Associates)";
            Vendor.Address := COPYSTR(AssociateLoginDetails.Address, 1, 50);
            ;
            Vendor."Address 2" := COPYSTR(AssociateLoginDetails.Address, 51, 50);
            Vendor."BBG Address 3" := COPYSTR(AssociateLoginDetails.Address, 101, 50);
            Vendor."BBG Associate Password" := AssociateLoginDetails.Password;
            IF AssociateLoginDetails.PAN_No = 'PANAPPLIED' THEN BEGIN
                Vendor."P.A.N. No." := 'PANAPPLIED';
                Vendor."P.A.N. Status" := Vendor."P.A.N. Status"::PANAPPLIED;
            END ELSE
                Vendor."P.A.N. No." := AssociateLoginDetails.PAN_No;
            Vendor."BBG Nationality" := 'Indian';
            Vendor."BBG Marital Status" := Vendor."BBG Marital Status"::Unmarried;
            Vendor."Vendor Posting Group" := 'ASSC_DOM';
            Vendor."Gen. Bus. Posting Group" := 'DOMESTIC';
            Vendor."BBG Date of Birth" := AssociateLoginDetails.Date_OF_Birth;
            Vendor."BBG Associate Creation" := Vendor."BBG Associate Creation"::New;
            Vendor."BBG Web User_ID" := AssociateLoginDetails.USER_ID;
            Vendor."BBG Status" := Vendor."BBG Status"::Active;
            Vendor."BBG Web Associate Payment Active" := TRUE;
            Vendor."E-Mail" := AssociateLoginDetails."Email-Id";
            Vendor."BBG Creation Date" := AssociateLoginDetails."Creation Date";
            Vendor."BBG Create from Web/Mobile" := TRUE;
            Vendor."BBG Age" := AssociateLoginDetails.Age;
            Vendor."BBG Father Name" := AssociateLoginDetails."Father Name";
            Vendor.City := AssociateLoginDetails.City;
            Vendor."BBG Nominee Name" := AssociateLoginDetails."Nominee Name";
            Vendor."Post Code" := AssociateLoginDetails.Post_Code;
            Vendor."BBG Designation" := AssociateLoginDetails.Designation;
            Vendor."E-Mail" := AssociateLoginDetails."Email-Id";
            Vendor."BBG Associate Password" := 'BBG@1234';
            Vendor."BBG Reporting Office" := AssociateLoginDetails."Reporting Office";  //030524
            Vendor."BBG New Cluster Code" := AssociateLoginDetails."New Cluster Code";  //030524
            Vendor."Region/Districts Code" := AssociateLoginDetails."Region/Districts Code";  //270325
            IF AssociateLoginDetails.Gender = 'Male' THEN
                Vendor."BBG Sex" := Vendor."BBG Sex"::Male;
            IF AssociateLoginDetails.Gender = 'Female' THEN
                Vendor."BBG Sex" := Vendor."BBG Sex"::Female;
            Vendor.Validate("Assessee Code", 'IND');//ALLE-AM
            Vendor."State Code" := AssociateLoginDetails."State Code"; //23072025 Code added
            Vendor."District Code" := AssociateLoginDetails."District Code";  //23072025 Code added
            Vendor."Mandal Code" := AssociateLoginDetails."Mandal Code";  //23072025 Code added
            vendor."Village Code" := AssociateLoginDetails."Village Code";   //23072025 Code added
            IF AssociateLoginDetails."Aadhaar Number" <> '' then
                Vendor."BBG Aadhar No." := AssociateLoginDetails."Aadhaar Number"; //23072025 Code added
            Vendor."Country/Region Code" := 'IN';  //23072025 Code added
            Vendor.INSERT;
            //ALLE-AM
            AllowedSection.Init();
            AllowedSection."Vendor No" := Vendor."No.";
            AllowedSection.Validate("TDS Section", '194H');
            AllowedSection.Insert(true);
            //ALLE-AM
            CheckVendPanNo.RESET;
            CheckVendPanNo.SETFILTER("No.", '<>%1', Vendor."No.");
            CheckVendPanNo.SETRANGE("P.A.N. No.", Vendor."P.A.N. No.");
            CheckVendPanNo.SETRANGE("BBG Vendor Category", Vendor."BBG Vendor Category");//ALLETDK120413
            IF CheckVendPanNo.FINDFIRST THEN BEGIN
                IF CheckVendPanNo."P.A.N. No." <> 'PANAPPLIED' THEN
                    ERROR(Text016, Vendor."P.A.N. No.");
            END;

            AssociateLoginDetails."NAV-Associate Created" := TRUE;
            AssociateLoginDetails."NAV-Associate Creation Date" := TODAY;
            AssociateLoginDetails.Associate_ID := Vendor."No.";
            AssociateLoginDetails."Vendor Profile Status" := AssociateLoginDetails."Vendor Profile Status"::Close;
            //AssociateLoginDetails."Send for Associate Create" := TRUE;
            AssociateLoginDetails.Status := AssociateLoginDetails.Status::Approved;
            AssociateLoginDetails.MODIFY;

            //ALLEDK 221123
            //CLEAR(WebAppService);
            // WebAppService.Post_data('',Vendor."No.",Vendor.Name,Vendor."Mob. No.",Vendor."E-Mail",Vendor."Team Code",Vendor."Leader Code",Vendor.Introducer);
            //ALLEDK 221123


            //050324 code added start
            CustomersLead_2.RESET;
            CustomersLead_2.SETRANGE("Mobile Phone No.", Vendor."BBG Mob. No.");
            CustomersLead_2.SETRANGE("Lead Associate / Customer Id", '');
            CustomersLead_2.SETRANGE("Request From", CustomersLead_2."Request From"::Vendor);
            IF CustomersLead_2.FINDSET THEN
                REPEAT
                    CustomersLead_2."Lead Associate / Customer Id" := Vendor."No.";
                    CustomersLead_2.MODIFY;
                UNTIL CustomersLead_2.NEXT = 0;
            //050324 code added END




            UserDocumentAttachment.RESET;
            UserDocumentAttachment.SETRANGE(USER_ID, AssociateLoginDetails.USER_ID);
            IF UserDocumentAttachment.FINDSET THEN
                REPEAT
                    UserDocumentAttachment."Associate ID" := Vendor."No.";
                    UserDocumentAttachment.MODIFY;
                UNTIL UserDocumentAttachment.NEXT = 0;

            RegionwiseVendor.INIT;
            IF NewRegionCode = '' THEN BEGIN   //Code added 06102025
                IF AssociateLoginDetails."Region Code" = 'AP' THEN
                    RegionwiseVendor."Region Code" := 'R0002'
                ELSE
                    RegionwiseVendor."Region Code" := 'R0001';
            END ELSE                                              //Code added 06102025
                RegionwiseVendor."Region Code" := NewRegionCode;     //Code added 06102025

            RegionwiseVendor.VALIDATE("No.", Vendor."No.");
            IF AssociateLoginDetails.Rank_Code <> 0 THEN
                RegionwiseVendor."Rank Code" := AssociateLoginDetails.Rank_Code
            ELSE
                RegionwiseVendor."Rank Code" := 1.0;
            IF AssociateLoginDetails.Parent_ID <> '' THEN
                RegionwiseVendor."Parent Code" := AssociateLoginDetails.Parent_ID
            ELSE
                RegionwiseVendor."Parent Code" := AssociateLoginDetails.Introducer_Code;

            RegionwiseVendor."Associate DOJ" := AssociateLoginDetails.Date_OF_Joining;
            RegionwiseVendor.INSERT;
            RegionwiseVendor.VALIDATE("Rank Code");
            RegionwiseVendor.VALIDATE("Parent Code");
            RegionwiseVendor.MODIFY;


            //ALLEDK 160922
            CLEAR(AssociateTeamforGamifiction);
            AssociateTeamforGamifiction.ReportValues(RegionwiseVendor."No.", RegionwiseVendor."Region Code");
            AssociateTeamforGamifiction.RUNMODAL;
            //ALLEDK 160922

            //060525 Code added Start
            RankCodeMaster.RESET;
            RankCodeMaster.SETRANGE("Rank Batch Code", RegionwiseVendor."Region Code");
            RankCodeMaster.SETRANGE(Code, RegionwiseVendor."Rank Code");
            IF RankCodeMaster.FINDFIRST THEN;
            IF Vendor."BBG Black List" THEN
                AssStatus := 'Deactivate'
            ELSE
                AssStatus := 'Active';

            WebAppService.Post_data('', Vendor."No.", Vendor.Name, Vendor."BBG Mob. No.", Vendor."E-Mail", Vendor."BBG Team Code", Vendor."BBG Leader Code", RegionwiseVendor."Parent Code",  //060525 Code added
                                       FORMAT(AssStatus), FORMAT(RegionwiseVendor."Rank Code"), RankCodeMaster.Description);   //060525 Code added

            //060525 Code added END                                       

            BondSetup.GET;
            BondSetup.TESTFIELD("TDS Nature of Deduction");
            /*
            NODHeader.RESET;
            IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vendor."No.") THEN BEGIN
                NODHeader.INIT;
                NODHeader.Type := NODHeader.Type::Vendor;
                NODHeader."No." := Vendor."No.";
                NODHeader."Assesse Code" := 'IND';
                NODHeader.INSERT;
            END;

            IF NOT NODLine.GET(NODLine.Type::Vendor, Vendor."No.", BondSetup."TDS Nature of Deduction") THEN BEGIN
                NODLine.Type := NODLine.Type::Vendor;
                NODLine."No." := Vendor."No.";
                NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                NODLine."Monthly Certificate" := TRUE;
                NODLine."Threshold Overlook" := TRUE;
                NODLine."Surcharge Overlook" := TRUE;
                NODLine.INSERT;
            END;
            *///Need to check the code in UAT

            //-----------------------------

            CompanywiseGLAccount.RESET;
            CompanywiseGLAccount.SETRANGE("MSC Company", FALSE);
            IF CompanywiseGLAccount.FINDSET THEN BEGIN
                REPEAT
                    Vend.RESET;
                    Vend.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    Vend.SETRANGE("No.", VendNo);
                    IF NOT Vend.FINDFIRST THEN BEGIN
                        Vend.INIT;
                        Vend.TRANSFERFIELDS(Vendor);
                        Vend.INSERT;
                    END;
                    BondSetup.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    BondSetup.GET;
                    BondSetup.TESTFIELD("TDS Nature of Deduction");
                    /*
                    NODHeader.RESET;
                    NODHeader.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vend."No.") THEN BEGIN
                        NODHeader.INIT;
                        NODHeader.Type := NODHeader.Type::Vendor;
                        NODHeader."No." := Vend."No.";
                        NODHeader."Assesse Code" := 'IND';
                        NODHeader.INSERT;
                    END;

                    NODLine.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    IF NOT NODLine.GET(NODLine.Type::Vendor, VendNo, BondSetup."TDS Nature of Deduction") THEN BEGIN
                        NODLine.Type := NODLine.Type::Vendor;
                        NODLine."No." := VendNo;
                        NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                        NODLine."Monthly Certificate" := TRUE;
                        NODLine."Threshold Overlook" := TRUE;
                        NODLine."Surcharge Overlook" := TRUE;
                        NODLine.INSERT;
                    END;
                    *///Need to check the code in UAT

                    RecVendorBankAccount.RESET;
                    RecVendorBankAccount.SETRANGE("Vendor No.", Vendor."No.");
                    IF RecVendorBankAccount.FINDSET THEN
                        REPEAT
                            VendorBankAccount.RESET;
                            VendorBankAccount.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                            VendorBankAccount.INIT;
                            VendorBankAccount := RecVendorBankAccount;
                            VendorBankAccount.INSERT;
                        UNTIL RecVendorBankAccount.NEXT = 0;

                    CLEAR(Vend);
                    Vend.RESET;
                    Vend.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    Vend.SETRANGE("No.", Vendor."No.");
                    IF Vend.FINDFIRST THEN BEGIN
                        Vend."Vendor Posting Group" := Vendor."Vendor Posting Group";
                        Vend."BBG Status" := Vendor."BBG Status";
                        Vend."BBG Date of Birth" := Vendor."BBG Date of Birth";
                        Vend."BBG Date of Joining" := Vendor."BBG Date of Joining";
                        Vend."BBG Sex" := Vendor."BBG Sex";
                        Vend."BBG Marital Status" := Vendor."BBG Marital Status";
                        Vend."BBG Nationality" := Vendor."BBG Nationality";
                        Vend."BBG Associate Creation" := Vendor."BBG Associate Creation";
                        Vend."Tax Liable" := Vendor."Tax Liable";
                        Vend."P.A.N. No." := Vendor."P.A.N. No.";
                        Vend."P.A.N. Status" := Vendor."P.A.N. Status";
                        Vend."Gen. Bus. Posting Group" := Vendor."Gen. Bus. Posting Group";
                        Vend.MODIFY;
                    END;
                UNTIL CompanywiseGLAccount.NEXT = 0;
            END;
            //-----------------------------

            CompanyInformation.GET;
            IF CompanyInformation."Send SMS" THEN BEGIN
                CLEAR(PostPayment);
                SMS := '';
                // SMS := 'Your ID'+Vendor."No."+',  Login Id-'+Vendor."Mob. No."+',  Password-'+AssociateLoginDetails.Password+'.BBGIND';  //120523 comment

                //SMS := 'Dear Mr/Ms:'+ FORMAT(Vendor.Name) +'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No." + 'PWD is '+FORMAT(Vendor."Associate Password") +'. Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official BBG WhatsApp channel '+
                //'for updates https://shorturl.at/dgDQV BGIND.';  //401023 New Code

                //Comment  new Message 150224

                //SMS :='Dear Mr/Ms: '+Vendor.Name+'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No."+' PWD is ' + FORMAT(Vendor."Associate Password")+' Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official BBG WhatsApp channel '+
                //'for updates https://shorturl.at/dgDQV BBGIND.';  //181023 code added

                //ADDED new Message 150224
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Vendor."BBG Mob. No.", FALSE);

                IF ExitMessage THEN
                    SMS := 'Dear Mr/Ms: ' + Vendor.Name + ' Congrats and Welcome to BBG Family. Your Business ID is ' + Vendor."No." + ' PWD is BBG@1234.' +                                         //240625 code Added
                         ' We Assure you of our Best Support in Transforming Your Dreams into Reality. Please join our BBG WhatsApp channel for updates https://whatsapp.com/channel/0029Va9v5xP6rsQkBNMHFw2V BBGIND.';  //240625 code Added




                // SMS := 'Dear Mr/Ms: ' + Vendor.Name + ' Congrats and Welcome to BBG Family.Your Business ID ' + Vendor."No." + ' PWD is BBG@1234 Thank you and Assure' +   //240625 code Commented
                //' you of our Best Support in Transforming Your Dreams into Reality.Please join the official BBG WhatsApp channel for updateshttps://shorturl.at/dgDQV BBG Family.';  //240625 code Commented


                //   SMS := 'Dear Mr/Ms:'+ FORMAT(Vendor.Name) +'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No." + 'PWD '+FORMAT(Vendor."Associate Password") +'. Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official telegram channel '+
                //'(BBG Post Office) for updates https://t.me/BBGPostoffice BBGIND.';//120523 New code
                PostPayment.SendSMS(Vendor."BBG Mob. No.", SMS);
                //ALLEDK15112022 Start
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(SMS, 1, 250);
                SmsMessage1 := COPYSTR(SMS, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Associate Login', '', '', '');
                //ALLEDK15112022 END
            END;
            COMMIT;
            IF Vendor."E-Mail" <> '' THEN BEGIN
                unitsetup.GET;
                Filename := '';
                Filename := unitsetup."Associate Mail Image Path";
                // /*                
                // SMTPSetup.GET;
                // SMTPMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", Vendor."E-Mail", 'Associate Onboard',
                //     '', TRUE);

                CLEAR(smtpMail);
                SMTPSetup.Reset();
                SMTPSetup.SetFilter(Name, '<>%1', '');
                if SMTPSetup.FindFirst() then;

                HtmlEmailBody := '<!DOCTYPE html><html><body>';



                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += 'Dear Sir,';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Your ID - ' + Vendor."No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Login ID - ' + Vendor."BBG Mob. No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Password - ' + AssociateLoginDetails.Password;
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Regards';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Building Blocks Group';
                HtmlEmailBody += '<br/>';
                EmailMessage.Create(Vendor."E-Mail", 'Associate Onboard', HtmlEmailBody, True);
                unitsetup."Associate Mail Image".CreateInStream(AttachmentStream);
                EmailMessage.AddAttachment('' + '.JPEG', '.JPEG', AttachmentStream);

                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                END;
                //SMTPMail.Send;
                //*///Need to check the code in UAT

                SLEEP(10000);
            END;

            IntVender.RESET;
            IntVender.GET(AssociateLoginDetails.Introducer_Code);


            IF IntVender."E-Mail" <> '' THEN BEGIN
                // /*
                // SMTPSetup.GET;
                // SMTPMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", IntVender."E-Mail", 'Associate Onboard',
                //     '', TRUE);

                CLEAR(smtpMail);
                SMTPSetup.Reset();
                SMTPSetup.SetFilter(Name, '<>%1', '');
                if SMTPSetup.FindFirst() then;

                HtmlEmailBody := '<!DOCTYPE html><html><body>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += 'Dear Sir,';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Your request for Mr.' + Vendor.Name + ' have been approved';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'ID : ' + Vendor."No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Welcome to BBG family';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Thanks';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Building Blocks Group';
                HtmlEmailBody += '<br/>';
                //SMTPMail.Send;
                EmailMessage.Create(IntVender."E-Mail", 'Associate Onboard', HtmlEmailBody, True);
                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                END;
                // *///Need to check the code in UAT

                SLEEP(10000);
            END;
        END;
        COMMIT;
    end;


    procedure CreateVendorMAster_2(RecUserID_1: Integer): Code[20]
    var
        RecVendor_1: Record Vendor;
        HtmlEmailBody: text;
        smtpMail: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        SMTPSetup: Record "Email Account";
        AttachmentStream: InStream;

    begin
        AssociateLoginDetails.RESET;
        AssociateLoginDetails.SETRANGE(USER_ID, RecUserID_1);
        //AssociateLoginDetails.SETRANGE("NAV-Associate Created",FALSE);
        //AssociateLoginDetails.SETFILTER(Status,'%1|%2',AssociateLoginDetails.Status::"Under Process",AssociateLoginDetails.Status::"Sent for Approval");
        AssociateLoginDetails.SETRANGE(Associate_ID, '');
        IF AssociateLoginDetails.FINDFIRST THEN BEGIN

            //210224 Added new code
            CLEAR(CheckMobileNoforSMS);
            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(AssociateLoginDetails."Mobile_ No", FALSE);
            IF NOT ExitMessage THEN
                ERROR('Mobile no. invalid');
            RecVendor_1.RESET;
            RecVendor_1.SETCURRENTKEY("BBG Mob. No.");
            RecVendor_1.SETRANGE("BBG Mob. No.", AssociateLoginDetails."Mobile_ No");
            IF RecVendor_1.FINDFIRST THEN
                ERROR('Mobile no already exists' + AssociateLoginDetails."Mobile_ No");
            MobFirstLetter := '';
            MobFirstLetter := COPYSTR(AssociateLoginDetails."Mobile_ No", 1, 1);
            IF MobFirstLetter = 'R' THEN
                ERROR('Mobile no. invalid');

            VendNo := '';
            VendNo := NoSeriesManagement.GetNextNo('VEND-IBA', TODAY, TRUE);

            Vendor.INIT;
            Vendor."No." := VendNo;
            Vendor.Name := AssociateLoginDetails.Name;
            Vendor."BBG Mob. No." := AssociateLoginDetails."Mobile_ No";

            Vendor."BBG Introducer" := AssociateLoginDetails.Introducer_Code;
            Vendor."BBG Date of Joining" := AssociateLoginDetails.Date_OF_Joining;
            Vendor."BBG Vendor Category" := Vendor."BBG Vendor Category"::"IBA(Associates)";
            Vendor.Address := COPYSTR(AssociateLoginDetails.Address, 1, 50);
            ;
            Vendor."Address 2" := COPYSTR(AssociateLoginDetails.Address, 51, 50);
            Vendor."BBG Address 3" := COPYSTR(AssociateLoginDetails.Address, 101, 50);
            Vendor."BBG Associate Password" := AssociateLoginDetails.Password;
            IF AssociateLoginDetails.PAN_No = 'PANAPPLIED' THEN BEGIN
                Vendor."P.A.N. No." := 'PANAPPLIED';
                Vendor."P.A.N. Status" := Vendor."P.A.N. Status"::PANAPPLIED;
            END ELSE
                Vendor."P.A.N. No." := AssociateLoginDetails.PAN_No;
            Vendor."BBG Nationality" := 'Indian';
            Vendor."BBG Marital Status" := Vendor."BBG Marital Status"::Unmarried;
            Vendor."Vendor Posting Group" := 'ASSC_DOM';
            Vendor."Gen. Bus. Posting Group" := 'DOMESTIC';
            Vendor."BBG Date of Birth" := AssociateLoginDetails.Date_OF_Birth;
            Vendor."BBG Associate Creation" := Vendor."BBG Associate Creation"::New;
            Vendor."BBG Web User_ID" := AssociateLoginDetails.USER_ID;
            Vendor."BBG Status" := Vendor."BBG Status"::Active;
            Vendor."BBG Web Associate Payment Active" := TRUE;
            Vendor."E-Mail" := AssociateLoginDetails."Email-Id";
            Vendor."BBG Creation Date" := AssociateLoginDetails."Creation Date";
            Vendor."BBG Create from Web/Mobile" := TRUE;
            Vendor."BBG Age" := AssociateLoginDetails.Age;
            Vendor."BBG Father Name" := AssociateLoginDetails."Father Name";
            Vendor.City := AssociateLoginDetails.City;
            Vendor."BBG Nominee Name" := AssociateLoginDetails."Nominee Name";
            Vendor."Post Code" := AssociateLoginDetails.Post_Code;
            Vendor."BBG Designation" := AssociateLoginDetails.Designation;
            Vendor."E-Mail" := AssociateLoginDetails."Email-Id";
            Vendor."BBG Associate Password" := 'BBG@1234';
            Vendor."BBG Reporting Office" := AssociateLoginDetails."Reporting Office";
            Vendor."Region/Districts Code" := AssociateLoginDetails."Region/Districts Code";  //270325
            IF AssociateLoginDetails.Gender = 'Male' THEN
                Vendor."BBG Sex" := Vendor."BBG Sex"::Male;
            IF AssociateLoginDetails.Gender = 'Female' THEN
                Vendor."BBG Sex" := Vendor."BBG Sex"::Female;

            Vendor."State Code" := AssociateLoginDetails."State Code"; //23072025 Code added
            Vendor."District Code" := AssociateLoginDetails."District Code";  //23072025 Code added
            Vendor."Mandal Code" := AssociateLoginDetails."Mandal Code";  //23072025 Code added
            vendor."Village Code" := AssociateLoginDetails."Village Code";   //23072025 Code added
            IF AssociateLoginDetails."Aadhaar Number" <> '' then
                Vendor."BBG Aadhar No." := AssociateLoginDetails."Aadhaar Number"; //23072025 Code added
            Vendor."Country/Region Code" := 'IN';  //23072025 Code added
            Vendor.INSERT;
            AssociateLoginDetails."NAV-Associate Created" := TRUE;
            AssociateLoginDetails."NAV-Associate Creation Date" := TODAY;
            AssociateLoginDetails.Associate_ID := Vendor."No.";
            AssociateLoginDetails."Vendor Profile Status" := AssociateLoginDetails."Vendor Profile Status"::Close;
            //AssociateLoginDetails."Send for Associate Create" := TRUE;
            AssociateLoginDetails.Status := AssociateLoginDetails.Status::Approved;
            AssociateLoginDetails.MODIFY;

            //ALLEDK 221123
            //CLEAR(WebAppService);
            // WebAppService.Post_data('',Vendor."No.",Vendor.Name,Vendor."Mob. No.",Vendor."E-Mail",Vendor."Team Code",Vendor."Leader Code",Vendor.Introducer);
            //ALLEDK 221123


            //050324 code added start
            CustomersLead_2.RESET;
            CustomersLead_2.SETRANGE("Mobile Phone No.", Vendor."BBG Mob. No.");
            CustomersLead_2.SETRANGE("Lead Associate / Customer Id", '');
            CustomersLead_2.SETRANGE("Request From", CustomersLead_2."Request From"::Vendor);
            IF CustomersLead_2.FINDSET THEN
                REPEAT
                    CustomersLead_2."Lead Associate / Customer Id" := Vendor."No.";
                    CustomersLead_2.MODIFY;
                UNTIL CustomersLead_2.NEXT = 0;
            //050324 code added END




            UserDocumentAttachment.RESET;
            UserDocumentAttachment.SETRANGE(USER_ID, AssociateLoginDetails.USER_ID);
            IF UserDocumentAttachment.FINDSET THEN
                REPEAT
                    UserDocumentAttachment."Associate ID" := Vendor."No.";
                    UserDocumentAttachment.MODIFY;
                UNTIL UserDocumentAttachment.NEXT = 0;

            RegionwiseVendor.INIT;
            IF AssociateLoginDetails."Region Code" = 'AP' THEN
                RegionwiseVendor."Region Code" := 'R0002'
            ELSE
                RegionwiseVendor."Region Code" := 'R0001';
            RegionwiseVendor.VALIDATE("No.", Vendor."No.");
            IF AssociateLoginDetails.Rank_Code <> 0 THEN
                RegionwiseVendor."Rank Code" := AssociateLoginDetails.Rank_Code
            ELSE
                RegionwiseVendor."Rank Code" := 1.0;
            IF AssociateLoginDetails.Parent_ID <> '' THEN
                RegionwiseVendor."Parent Code" := AssociateLoginDetails.Parent_ID
            ELSE
                RegionwiseVendor."Parent Code" := AssociateLoginDetails.Introducer_Code;

            RegionwiseVendor."Associate DOJ" := AssociateLoginDetails.Date_OF_Joining;
            RegionwiseVendor.INSERT;
            RegionwiseVendor.VALIDATE("Rank Code");
            RegionwiseVendor.VALIDATE("Parent Code");
            RegionwiseVendor.MODIFY;


            //ALLEDK 160922
            CLEAR(AssociateTeamforGamifiction);
            AssociateTeamforGamifiction.ReportValues(RegionwiseVendor."No.", RegionwiseVendor."Region Code");
            AssociateTeamforGamifiction.RUNMODAL;
            //ALLEDK 160922


            BondSetup.GET;
            BondSetup.TESTFIELD("TDS Nature of Deduction");
            /*
            NODHeader.RESET;
            IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vendor."No.") THEN BEGIN
                NODHeader.INIT;
                NODHeader.Type := NODHeader.Type::Vendor;
                NODHeader."No." := Vendor."No.";
                NODHeader."Assesse Code" := 'IND';
                NODHeader.INSERT;
            END;

            IF NOT NODLine.GET(NODLine.Type::Vendor, Vendor."No.", BondSetup."TDS Nature of Deduction") THEN BEGIN
                NODLine.Type := NODLine.Type::Vendor;
                NODLine."No." := Vendor."No.";
                NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                NODLine."Monthly Certificate" := TRUE;
                NODLine."Threshold Overlook" := TRUE;
                NODLine."Surcharge Overlook" := TRUE;
                NODLine.INSERT;
            END;
            *///Need to check the code in UAT

            //-----------------------------

            CompanywiseGLAccount.RESET;
            CompanywiseGLAccount.SETRANGE("MSC Company", FALSE);
            IF CompanywiseGLAccount.FINDSET THEN BEGIN
                REPEAT
                    Vend.RESET;
                    Vend.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    Vend.SETRANGE("No.", VendNo);
                    IF NOT Vend.FINDFIRST THEN BEGIN
                        Vend.INIT;
                        Vend.TRANSFERFIELDS(Vendor);
                        Vend.INSERT;
                    END;
                    BondSetup.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    BondSetup.GET;
                    BondSetup.TESTFIELD("TDS Nature of Deduction");
                    /*                    
                    NODHeader.RESET;
                    NODHeader.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vend."No.") THEN BEGIN
                        NODHeader.INIT;
                        NODHeader.Type := NODHeader.Type::Vendor;
                        NODHeader."No." := Vend."No.";
                        NODHeader."Assesse Code" := 'IND';
                        NODHeader.INSERT;
                    END;

                    NODLine.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    IF NOT NODLine.GET(NODLine.Type::Vendor, VendNo, BondSetup."TDS Nature of Deduction") THEN BEGIN
                        NODLine.Type := NODLine.Type::Vendor;
                        NODLine."No." := VendNo;
                        NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                        NODLine."Monthly Certificate" := TRUE;
                        NODLine."Threshold Overlook" := TRUE;
                        NODLine."Surcharge Overlook" := TRUE;
                        NODLine.INSERT;
                    END;
                    *///Need to check the code in UAT

                    RecVendorBankAccount.RESET;
                    RecVendorBankAccount.SETRANGE("Vendor No.", Vendor."No.");
                    IF RecVendorBankAccount.FINDSET THEN
                        REPEAT
                            VendorBankAccount.RESET;
                            VendorBankAccount.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                            VendorBankAccount.INIT;
                            VendorBankAccount := RecVendorBankAccount;
                            VendorBankAccount.INSERT;
                        UNTIL RecVendorBankAccount.NEXT = 0;

                    CLEAR(Vend);
                    Vend.RESET;
                    Vend.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    Vend.SETRANGE("No.", Vendor."No.");
                    IF Vend.FINDFIRST THEN BEGIN
                        Vend."Vendor Posting Group" := Vendor."Vendor Posting Group";
                        Vend."BBG Status" := Vendor."BBG Status";
                        Vend."BBG Date of Birth" := Vendor."BBG Date of Birth";
                        Vend."BBG Date of Joining" := Vendor."BBG Date of Joining";
                        Vend."BBG Sex" := Vendor."BBG Sex";
                        Vend."BBG Marital Status" := Vendor."BBG Marital Status";
                        Vend."BBG Nationality" := Vendor."BBG Nationality";
                        Vend."BBG Associate Creation" := Vendor."BBG Associate Creation";
                        Vend."Tax Liable" := Vendor."Tax Liable";
                        Vend."P.A.N. No." := Vendor."P.A.N. No.";
                        Vend."P.A.N. Status" := Vendor."P.A.N. Status";
                        Vend."Gen. Bus. Posting Group" := Vendor."Gen. Bus. Posting Group";
                        Vend.MODIFY;
                    END;
                UNTIL CompanywiseGLAccount.NEXT = 0;
            END;
            //-----------------------------

            CompanyInformation.GET;
            IF CompanyInformation."Send SMS" THEN BEGIN
                CLEAR(PostPayment);
                SMS := '';
                // SMS := 'Your ID'+Vendor."No."+',  Login Id-'+Vendor."Mob. No."+',  Password-'+AssociateLoginDetails.Password+'.BBGIND';  //120523 comment

                //SMS := 'Dear Mr/Ms:'+ FORMAT(Vendor.Name) +'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No." + 'PWD is '+FORMAT(Vendor."Associate Password") +'. Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official BBG WhatsApp channel '+
                //'for updates https://shorturl.at/dgDQV BGIND.';  //401023 New Code

                //Comment  new Message 150224

                //SMS :='Dear Mr/Ms: '+Vendor.Name+'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No."+' PWD is ' + FORMAT(Vendor."Associate Password")+' Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official BBG WhatsApp channel '+
                //'for updates https://shorturl.at/dgDQV BBGIND.';  //181023 code added

                //ADDED new Message 150224
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Vendor."BBG Mob. No.", FALSE);

                IF ExitMessage THEN
                    SMS := 'Dear Mr/Ms: ' + Vendor.Name + ' Congrats and Welcome to BBG Family. Your Business ID is ' + Vendor."No." + ' PWD is BBG@1234.' +                                         //240625 code Added
                       ' We Assure you of our Best Support in Transforming Your Dreams into Reality. Please join our BBG WhatsApp channel for updates https://whatsapp.com/channel/0029Va9v5xP6rsQkBNMHFw2V BBGIND.';  //240625 code Added    //240625 code Added  //240625 code Added

                // SMS := 'Dear Mr/Ms: ' + Vendor.Name + ' Congrats and Welcome to BBG Family.Your Business ID ' + Vendor."No." + ' PWD is BBG@1234 Thank you and Assure' +   //240625 Code commented
                // ' you of our Best Support in Transforming Your Dreams into Reality.Please join the official BBG WhatsApp channel for updateshttps://shorturl.at/dgDQV BBG Family.';  //240625 Code commented


                //   SMS := 'Dear Mr/Ms:'+ FORMAT(Vendor.Name) +'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No." + 'PWD '+FORMAT(Vendor."Associate Password") +'. Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official telegram channel '+
                //'(BBG Post Office) for updates https://t.me/BBGPostoffice BBGIND.';//120523 New code
                PostPayment.SendSMS(Vendor."BBG Mob. No.", SMS);
                //ALLEDK15112022 Start
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(SMS, 1, 250);
                SmsMessage1 := COPYSTR(SMS, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Associate Login', '', '', '');
                //ALLEDK15112022 END
            END;
            COMMIT;
            IF Vendor."E-Mail" <> '' THEN BEGIN
                unitsetup.GET;
                Filename := '';
                Filename := unitsetup."Associate Mail Image Path";
                // /*
                // SMTPSetup.GET;
                // SMTPMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", Vendor."E-Mail", 'Associate Onboard',
                //     '', TRUE);

                CLEAR(smtpMail);
                SMTPSetup.Reset();
                SMTPSetup.SetFilter(Name, '<>%1', '');
                if SMTPSetup.FindFirst() then;

                HtmlEmailBody := '<!DOCTYPE html><html><body>';



                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += 'Dear Sir,';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Your ID - ' + Vendor."No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Login ID - ' + Vendor."BBG Mob. No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Password - ' + AssociateLoginDetails.Password;
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Regards';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Building Blocks Group';
                HtmlEmailBody += '<br/>';
                // IF Filename <> '' THEN
                //     SMTPMail.AddAttachment(Filename, Filename);

                EmailMessage.Create(Vendor."E-Mail", 'Associate Onboard', HtmlEmailBody, True);
                // IF Filename <> '' THEN
                //   EmailMessage.AddAttachment(Vend."No." + '.Pdf', '.Pdf', AttachmentStream);
                unitsetup."Associate Mail Image".CreateInStream(AttachmentStream);
                EmailMessage.AddAttachment('' + '.JPEG', '.JPEG', AttachmentStream);

                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                END;


                // *///Need to check the code in UAT

                SLEEP(10000);
            END;

            IntVender.RESET;
            IntVender.GET(AssociateLoginDetails.Introducer_Code);


            IF IntVender."E-Mail" <> '' THEN BEGIN
                // /*
                // SMTPSetup.GET;
                // SMTPMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", IntVender."E-Mail", 'Associate Onboard',
                //     '', TRUE);

                CLEAR(smtpMail);
                SMTPSetup.Reset();
                SMTPSetup.SetFilter(Name, '<>%1', '');
                if SMTPSetup.FindFirst() then;

                HtmlEmailBody := '<!DOCTYPE html><html><body>';

                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += 'Dear Sir,';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Your request for Mr.' + Vendor.Name + ' have been approved';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'ID : ' + Vendor."No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Welcome to BBG family';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Thanks';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Building Blocks Group';
                HtmlEmailBody += '<br/>';
                // IF Filename <> '' THEN
                //     SMTPMail.AddAttachment(Filename, Filename);

                EmailMessage.Create(IntVender."E-Mail", 'Associate Onboard', HtmlEmailBody, True);

                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                END;

                // SMTPMail.Send;
                // *///Need to check the code in UAT

                SLEEP(10000);
            END;
        END;
        COMMIT;
    end;


    procedure CreateCP_VendorMAster(RecUserID_1: Integer): Code[20]
    var
        RecVendor_1: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        Parent_Vendor: Record Vendor;
        HtmlEmailBody: text;
        smtpMail: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        SMTPSetup: Record "Email Account";
        AttachmentStream: InStream;
        AllowedSection: Record "Allowed Sections";
    begin
        AssociateLoginDetails.RESET;
        AssociateLoginDetails.SETRANGE(USER_ID, RecUserID_1);
        AssociateLoginDetails.SETRANGE("NAV-Associate Created", FALSE);
        AssociateLoginDetails.SETFILTER(Status, '%1|%2', AssociateLoginDetails.Status::"Under Process", AssociateLoginDetails.Status::"Sent for Approval");
        IF AssociateLoginDetails.FINDFIRST THEN BEGIN

            //210224 Added new code
            CLEAR(CheckMobileNoforSMS);
            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(AssociateLoginDetails."Mobile_ No", FALSE);
            IF NOT ExitMessage THEN
                ERROR('Mobile no. invalid');
            RecVendor_1.RESET;
            RecVendor_1.SETCURRENTKEY("BBG Mob. No.");
            RecVendor_1.SETRANGE("BBG Mob. No.", AssociateLoginDetails."Mobile_ No");
            IF RecVendor_1.FINDFIRST THEN
                ERROR('Mobile no already exists' + AssociateLoginDetails."Mobile_ No");
            MobFirstLetter := '';
            MobFirstLetter := COPYSTR(AssociateLoginDetails."Mobile_ No", 1, 1);
            IF MobFirstLetter = 'R' THEN
                ERROR('Mobile no. invalid');

            VendNo := '';
            VendNo := NoSeriesManagement.GetNextNo('VEND-CP', TODAY, TRUE);

            Vendor.INIT;
            Vendor."No." := VendNo;
            Vendor.Name := AssociateLoginDetails.Name;
            Vendor."BBG Mob. No." := AssociateLoginDetails."Mobile_ No";

            Vendor."BBG Introducer" := AssociateLoginDetails.Introducer_Code;
            Vendor."BBG Date of Joining" := AssociateLoginDetails.Date_OF_Joining;
            Vendor."BBG Vendor Category" := Vendor."BBG Vendor Category"::"CP(Channel Partner)";
            Vendor.Address := COPYSTR(AssociateLoginDetails.Address, 1, 50);
            ;
            Vendor."Address 2" := COPYSTR(AssociateLoginDetails.Address, 51, 50);
            Vendor."BBG Address 3" := COPYSTR(AssociateLoginDetails.Address, 101, 50);
            Vendor."BBG Associate Password" := AssociateLoginDetails.Password;
            IF AssociateLoginDetails.PAN_No = 'PANAPPLIED' THEN BEGIN
                Vendor."P.A.N. No." := 'PANAPPLIED';
                Vendor."P.A.N. Status" := Vendor."P.A.N. Status"::PANAPPLIED;
            END ELSE
                Vendor."P.A.N. No." := AssociateLoginDetails.PAN_No;
            Vendor."BBG Nationality" := 'Indian';
            Vendor."BBG Marital Status" := Vendor."BBG Marital Status"::Unmarried;
            Vendor."Vendor Posting Group" := 'ASSC_DOM';
            Vendor."Gen. Bus. Posting Group" := 'DOMESTIC';
            Vendor."BBG Date of Birth" := AssociateLoginDetails.Date_OF_Birth;
            Vendor."BBG Associate Creation" := Vendor."BBG Associate Creation"::New;
            Vendor."BBG Web User_ID" := AssociateLoginDetails.USER_ID;
            Vendor."BBG Status" := Vendor."BBG Status"::Active;
            Vendor."BBG Web Associate Payment Active" := TRUE;
            Vendor."E-Mail" := AssociateLoginDetails."Email-Id";
            Vendor."BBG Creation Date" := AssociateLoginDetails."Creation Date";
            Vendor."BBG Create from Web/Mobile" := TRUE;
            Vendor."BBG Age" := AssociateLoginDetails.Age;
            Vendor."BBG Father Name" := AssociateLoginDetails."Father Name";
            Vendor.City := AssociateLoginDetails.City;
            Vendor."BBG Nominee Name" := AssociateLoginDetails."Nominee Name";
            Vendor."Post Code" := AssociateLoginDetails.Post_Code;
            Vendor."BBG Designation" := AssociateLoginDetails.Designation;
            Vendor."E-Mail" := AssociateLoginDetails."Email-Id";
            Vendor."BBG Associate Password" := 'BBG@1234';
            Vendor."BBG Reporting Office" := AssociateLoginDetails."Reporting Office";  //030524
            Vendor."BBG New Cluster Code" := AssociateLoginDetails."New Cluster Code";  //030524
            Vendor."BBG CP Designation" := AssociateLoginDetails."CP Designation";
            Vendor."Region/Districts Code" := AssociateLoginDetails."Region/Districts Code";  //27/03/25
            Parent_Vendor.RESET;
            IF Parent_Vendor.GET(AssociateLoginDetails.Parent_ID) THEN;
            Vendor."BBG CP Leader Code" := AssociateLoginDetails."CP Leader Code";
            Vendor."BBG CP Team Code" := AssociateLoginDetails."CP Team Code";
            IF Vendor."BBG CP Leader Code" = '' THEN
                Vendor."BBG CP Leader Code" := Parent_Vendor."BBG CP Leader Code";
            IF Vendor."BBG CP Team Code" = '' THEN
                Vendor."BBG CP Team Code" := Parent_Vendor."BBG CP Team Code";
            IF AssociateLoginDetails.Gender = 'Male' THEN
                Vendor."BBG Sex" := Vendor."BBG Sex"::Male;
            IF AssociateLoginDetails.Gender = 'Female' THEN
                Vendor."BBG Sex" := Vendor."BBG Sex"::Female;
            Vendor."BBG Communication Address" := AssociateLoginDetails."Communication Address";
            Vendor."BBG Communication Address 2" := AssociateLoginDetails."Communication Address 2";
            Vendor."BBG CP Designation" := AssociateLoginDetails."CP Designation";
            Vendor."BBG Membership of association" := AssociateLoginDetails."Membership of association";
            Vendor."BBG Membership Number" := AssociateLoginDetails."Membership Number";
            Vendor."BBG Registration No" := AssociateLoginDetails."Registration No";
            Vendor."BBG Expiry date" := AssociateLoginDetails."Expiry date";
            Vendor."BBG ESI NO" := AssociateLoginDetails."ESI NO";
            Vendor."BBG PF No." := AssociateLoginDetails."PF No.";
            Vendor."BBG Communication City" := AssociateLoginDetails."Communication City";
            Vendor."BBG Communication Post Code" := AssociateLoginDetails."Communication Post Code";
            Vendor."BBG Communication State Code" := AssociateLoginDetails."Communication State Code";
            Vendor.Validate("Assessee Code", 'IND');
            Vendor."Sub Vendor Category" := 'R0003';  //02062025 Code Added
            Vendor."State Code" := AssociateLoginDetails."State Code"; //23072025 Code added
            Vendor."District Code" := AssociateLoginDetails."District Code";  //23072025 Code added
            Vendor."Mandal Code" := AssociateLoginDetails."Mandal Code";  //23072025 Code added
            vendor."Village Code" := AssociateLoginDetails."Village Code";   //23072025 Code added
            IF AssociateLoginDetails."Aadhaar Number" <> '' then
                Vendor."BBG Aadhar No." := AssociateLoginDetails."Aadhaar Number"; //23072025 Code added
            Vendor.INSERT;

            //ALLE-AM 

            AllowedSection.Init();
            AllowedSection."Vendor No" := Vendor."No.";
            AllowedSection.Validate("TDS Section", '194H');
            AllowedSection.Insert(true);
            //ALLE-AM
            VendorBankAccount.RESET;
            IF NOT VendorBankAccount.GET('1001', Vendor."No.") THEN BEGIN
                VendorBankAccount.INIT;
                VendorBankAccount.Code := '1001';
                VendorBankAccount."Vendor No." := Vendor."No.";
                VendorBankAccount.Name := AssociateLoginDetails."Bank Name";
                VendorBankAccount."Bank Branch No." := AssociateLoginDetails."IFSC Code";
                VendorBankAccount."SWIFT Code" := AssociateLoginDetails."MICR Code";
                VendorBankAccount.Address := AssociateLoginDetails."Bank Address";
                VendorBankAccount."Address 2" := AssociateLoginDetails."Bank Address 2";
                VendorBankAccount.Contact := AssociateLoginDetails."Benificiary Name as per Bank";
                VendorBankAccount."Bank Account No." := AssociateLoginDetails."Bank Account No.";
                VendorBankAccount.INSERT;
            END;

            CheckVendPanNo.RESET;
            CheckVendPanNo.SETFILTER("No.", '<>%1', Vendor."No.");
            CheckVendPanNo.SETRANGE("P.A.N. No.", Vendor."P.A.N. No.");
            CheckVendPanNo.SETRANGE("BBG Vendor Category", Vendor."BBG Vendor Category");//ALLETDK120413
            IF CheckVendPanNo.FINDFIRST THEN BEGIN
                IF CheckVendPanNo."P.A.N. No." <> 'PANAPPLIED' THEN
                    ERROR(Text016, Vendor."P.A.N. No.");
            END;

            AssociateLoginDetails."NAV-Associate Created" := TRUE;
            AssociateLoginDetails."NAV-Associate Creation Date" := TODAY;
            AssociateLoginDetails.Associate_ID := Vendor."No.";
            AssociateLoginDetails."Vendor Profile Status" := AssociateLoginDetails."Vendor Profile Status"::Close;
            //AssociateLoginDetails."Send for Associate Create" := TRUE;
            AssociateLoginDetails.Status := AssociateLoginDetails.Status::Approved;
            AssociateLoginDetails.MODIFY;

            //ALLEDK 221123
            //CLEAR(WebAppService);
            // WebAppService.Post_data('',Vendor."No.",Vendor.Name,Vendor."Mob. No.",Vendor."E-Mail",Vendor."Team Code",Vendor."Leader Code",Vendor.Introducer);
            //ALLEDK 221123


            //050324 code added start
            CustomersLead_2.RESET;
            CustomersLead_2.SETRANGE("Mobile Phone No.", Vendor."BBG Mob. No.");
            CustomersLead_2.SETRANGE("Lead Associate / Customer Id", '');
            CustomersLead_2.SETRANGE("Request From", CustomersLead_2."Request From"::"Channel Partner");
            IF CustomersLead_2.FINDSET THEN
                REPEAT
                    CustomersLead_2."Lead Associate / Customer Id" := Vendor."No.";
                    CustomersLead_2.MODIFY;
                UNTIL CustomersLead_2.NEXT = 0;
            //050324 code added END




            UserDocumentAttachment.RESET;
            UserDocumentAttachment.SETRANGE(USER_ID, AssociateLoginDetails.USER_ID);
            IF UserDocumentAttachment.FINDSET THEN
                REPEAT
                    UserDocumentAttachment."Associate ID" := Vendor."No.";
                    UserDocumentAttachment.MODIFY;
                UNTIL UserDocumentAttachment.NEXT = 0;

            RegionwiseVendor.INIT;
            RegionwiseVendor."Region Code" := 'R0003';
            RegionwiseVendor.VALIDATE("No.", Vendor."No.");
            RegionwiseVendor."Rank Code" := AssociateLoginDetails.Rank_Code;
            IF AssociateLoginDetails.Parent_ID <> '' THEN
                RegionwiseVendor."Parent Code" := AssociateLoginDetails.Parent_ID
            ELSE
                RegionwiseVendor."Parent Code" := AssociateLoginDetails.Introducer_Code;

            RegionwiseVendor."Associate DOJ" := AssociateLoginDetails.Date_OF_Joining;
            RegionwiseVendor.INSERT;
            RegionwiseVendor.VALIDATE("Rank Code");
            RegionwiseVendor.VALIDATE("Parent Code");
            RegionwiseVendor.MODIFY;


            //    //ALLEDK 160922
            //    CLEAR(AssociateTeamforGamifiction);
            //    AssociateTeamforGamifiction.ReportValues(RegionwiseVendor."No.",RegionwiseVendor."Region Code");
            //    AssociateTeamforGamifiction.RUNMODAL;
            //    //ALLEDK 160922


            BondSetup.GET;
            BondSetup.TESTFIELD("TDS Nature of Deduction");
            /*
            NODHeader.RESET;
            IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vendor."No.") THEN BEGIN
                NODHeader.INIT;
                NODHeader.Type := NODHeader.Type::Vendor;
                NODHeader."No." := Vendor."No.";
                NODHeader."Assesse Code" := 'IND';
                NODHeader.INSERT;
            END;

            IF NOT NODLine.GET(NODLine.Type::Vendor, Vendor."No.", BondSetup."TDS Nature of Deduction") THEN BEGIN
                NODLine.Type := NODLine.Type::Vendor;
                NODLine."No." := Vendor."No.";
                NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                NODLine."Monthly Certificate" := TRUE;
                NODLine."Threshold Overlook" := TRUE;
                NODLine."Surcharge Overlook" := TRUE;
                NODLine.INSERT;
            END;
            *///Need to check the code in UAT

            //-----------------------------

            CompanywiseGLAccount.RESET;
            CompanywiseGLAccount.SETRANGE("MSC Company", FALSE);
            IF CompanywiseGLAccount.FINDSET THEN BEGIN
                REPEAT
                    Vend.RESET;
                    Vend.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    Vend.SETRANGE("No.", VendNo);
                    IF NOT Vend.FINDFIRST THEN BEGIN
                        Vend.INIT;
                        Vend.TRANSFERFIELDS(Vendor);
                        Vend.INSERT;
                    END;
                    BondSetup.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    BondSetup.GET;
                    BondSetup.TESTFIELD("TDS Nature of Deduction");
                    /*
                    NODHeader.RESET;
                    NODHeader.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vend."No.") THEN BEGIN
                        NODHeader.INIT;
                        NODHeader.Type := NODHeader.Type::Vendor;
                        NODHeader."No." := Vend."No.";
                        NODHeader."Assesse Code" := 'IND';
                        NODHeader.INSERT;
                    END;

                    NODLine.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    IF NOT NODLine.GET(NODLine.Type::Vendor, VendNo, BondSetup."TDS Nature of Deduction") THEN BEGIN
                        NODLine.Type := NODLine.Type::Vendor;
                        NODLine."No." := VendNo;
                        NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                        NODLine."Monthly Certificate" := TRUE;
                        NODLine."Threshold Overlook" := TRUE;
                        NODLine."Surcharge Overlook" := TRUE;
                        NODLine.INSERT;
                    END;
                    *///Need to check the code in UAT

                    RecVendorBankAccount.RESET;
                    RecVendorBankAccount.SETRANGE("Vendor No.", Vendor."No.");
                    IF RecVendorBankAccount.FINDSET THEN
                        REPEAT
                            VendorBankAccount.RESET;
                            VendorBankAccount.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                            VendorBankAccount.INIT;
                            VendorBankAccount := RecVendorBankAccount;
                            VendorBankAccount.INSERT;
                        UNTIL RecVendorBankAccount.NEXT = 0;

                    CLEAR(Vend);
                    Vend.RESET;
                    Vend.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    Vend.SETRANGE("No.", Vendor."No.");
                    IF Vend.FINDFIRST THEN BEGIN
                        Vend."Vendor Posting Group" := Vendor."Vendor Posting Group";
                        Vend."BBG Status" := Vendor."BBG Status";
                        Vend."BBG Date of Birth" := Vendor."BBG Date of Birth";
                        Vend."BBG Date of Joining" := Vendor."BBG Date of Joining";
                        Vend."BBG Sex" := Vendor."BBG Sex";
                        Vend."BBG Marital Status" := Vendor."BBG Marital Status";
                        Vend."BBG Nationality" := Vendor."BBG Nationality";
                        Vend."BBG Associate Creation" := Vendor."BBG Associate Creation";
                        Vend."Tax Liable" := Vendor."Tax Liable";
                        Vend."P.A.N. No." := Vendor."P.A.N. No.";
                        Vend."P.A.N. Status" := Vendor."P.A.N. Status";
                        Vend."Gen. Bus. Posting Group" := Vendor."Gen. Bus. Posting Group";
                        Vend.MODIFY;
                    END;
                UNTIL CompanywiseGLAccount.NEXT = 0;
            END;
            //-----------------------------

            CompanyInformation.GET;
            IF CompanyInformation."Send SMS" THEN BEGIN
                CLEAR(PostPayment);
                SMS := '';
                // SMS := 'Your ID'+Vendor."No."+',  Login Id-'+Vendor."Mob. No."+',  Password-'+AssociateLoginDetails.Password+'.BBGIND';  //120523 comment

                //SMS := 'Dear Mr/Ms:'+ FORMAT(Vendor.Name) +'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No." + 'PWD is '+FORMAT(Vendor."Associate Password") +'. Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official BBG WhatsApp channel '+
                //'for updates https://shorturl.at/dgDQV BGIND.';  //401023 New Code

                //Comment  new Message 150224

                //SMS :='Dear Mr/Ms: '+Vendor.Name+'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No."+' PWD is ' + FORMAT(Vendor."Associate Password")+' Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official BBG WhatsApp channel '+
                //'for updates https://shorturl.at/dgDQV BBGIND.';  //181023 code added

                //ADDED new Message 150224
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Vendor."BBG Mob. No.", FALSE);

                IF ExitMessage THEN
                    SMS := 'Dear Mr/Ms: ' + Vendor.Name + ' Congrats and Welcome to BBG Family. Your Channel Partner ID NO: ' + Vendor."No." + ' PWD is BBG@1234. Thank and Assure' +
                    ' you of our Best Support in Transforming Your Dreams into Reality. Good Luck and God Bless. BBG Family';


                //   SMS := 'Dear Mr/Ms:'+ FORMAT(Vendor.Name) +'. Congrats and Welcome to BBG Family. Your Business ID '+Vendor."No." + 'PWD '+FORMAT(Vendor."Associate Password") +'. Thank you and '+
                //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official telegram channel '+
                //'(BBG Post Office) for updates https://t.me/BBGPostoffice BBGIND.';//120523 New code
                PostPayment.SendSMS(Vendor."BBG Mob. No.", SMS);
                //ALLEDK15112022 Start
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(SMS, 1, 250);
                SmsMessage1 := COPYSTR(SMS, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Associate Login', '', '', '');
                //ALLEDK15112022 END
            END;
            COMMIT;

            //Code commented for testing 020924

            IF Vendor."E-Mail" <> '' THEN BEGIN
                unitsetup.GET;
                Filename := '';
                Filename := unitsetup."Associate Mail Image Path";
                // /*                
                // SMTPSetup.GET;
                // SMTPMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", Vendor."E-Mail", 'Associate Onboard',
                //     '', TRUE);
                CLEAR(smtpMail);
                SMTPSetup.Reset();
                SMTPSetup.SetFilter(Name, '<>%1', '');
                if SMTPSetup.FindFirst() then;

                HtmlEmailBody := '<!DOCTYPE html><html><body>';



                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += 'Dear Sir,';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Your ID - ' + Vendor."No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Login ID - ' + Vendor."BBG Mob. No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Password - ' + AssociateLoginDetails.Password;
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Regards';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Building Blocks Group';
                HtmlEmailBody += '<br/>';
                // IF Filename <> '' THEN
                //     SMTPMail.AddAttachment(Filename, Filename);

                EmailMessage.Create(Vendor."E-Mail", 'Associate Onboard', HtmlEmailBody, True);
                // IF Filename <> '' THEN
                //   EmailMessage.AddAttachment(Vend."No." + '.Pdf', '.Pdf', AttachmentStream);
                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                END;

                SLEEP(10000);
            END;

            IntVender.RESET;
            IntVender.GET(AssociateLoginDetails.Introducer_Code);

            //020924 below code commented for testing

            IF IntVender."E-Mail" <> '' THEN BEGIN
                // /*            
                // SMTPSetup.GET;
                // SMTPMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", IntVender."E-Mail", 'Associate Onboard',
                //     '', TRUE);

                CLEAR(smtpMail);
                SMTPSetup.Reset();
                SMTPSetup.SetFilter(Name, '<>%1', '');
                if SMTPSetup.FindFirst() then;

                HtmlEmailBody := '<!DOCTYPE html><html><body>';

                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += 'Dear Sir,';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Your request for Mr.' + Vendor.Name + ' have been approved';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'ID : ' + Vendor."No.";
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Welcome to BBG family';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Thanks';
                HtmlEmailBody += '<br/>';
                HtmlEmailBody += '<br>';
                HtmlEmailBody += 'Building Blocks Group';
                HtmlEmailBody += '<br/>';
                // IF Filename <> '' THEN
                //     SMTPMail.AddAttachment(Filename, Filename);

                EmailMessage.Create(IntVender."E-Mail", 'Associate Onboard', HtmlEmailBody, True);

                IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                END;

                SLEEP(10000);
            END;
        END;
        COMMIT;
    end;
}

