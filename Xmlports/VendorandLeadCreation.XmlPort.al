xmlport 50101 "Vendor and Lead Upload"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';
                textelement(Name)
                {
                }
                textelement(MobileNo)
                {
                }
                textelement(StateCode)
                {
                }
                textelement(Districtcode)
                {
                }
                textelement(Citycode)
                {
                }
                textelement(TeamName)
                {
                }
                textelement(SponserID)
                {
                }
                textelement(SponserName)
                {
                }
                textelement(RegionCode)
                {
                }

                textelement(RankCode)
                {
                }

                trigger OnAfterInsertRecord()
                begin

                    SLNo := SLNo + 1;
                    IF SLNo > 1 THEN BEGIN
                        IF RegionCode = '' then
                            Error('Please define Region Code');
                        Evaluate(RankCode_1, RankCode);

                        IF StateCode = 'TS' then
                            StateCode := 'TG';
                        CLEAR(CheckMobileNoforSMS);
                        ExitMessage := CheckMobileNoforSMS.CheckMobileNo(MobileNo, FALSE);
                        IF NOT ExitMessage THEN
                            ERROR('Mobile no. invalid');

                        RecVendor_1.RESET;
                        RecVendor_1.SETCURRENTKEY("BBG Mob. No.");
                        RecVendor_1.SETRANGE("BBG Mob. No.", MobileNo);
                        IF RecVendor_1.FINDFIRST THEN
                            ERROR('Mobile no already exists' + MobileNo);
                        MobFirstLetter := '';
                        MobFirstLetter := COPYSTR(MobileNo, 1, 1);
                        IF MobFirstLetter = 'R' THEN
                            ERROR('Mobile no. invalid');

                        VendNo := '';
                        VendNo := NoSeriesManagement.GetNextNo('VEND-IBA', TODAY, TRUE);

                        Vendor.INIT;
                        Vendor."No." := VendNo;
                        Vendor.Name := Name;
                        Vendor."BBG Mob. No." := MobileNo;

                        Vendor."BBG Introducer" := SponserID;
                        Vendor."BBG Date of Joining" := Today;
                        Vendor."BBG Vendor Category" := Vendor."BBG Vendor Category"::"IBA(Associates)";
                        Vendor."P.A.N. No." := 'PANAPPLIED';
                        Vendor."BBG Nationality" := 'Indian';
                        Vendor."Vendor Posting Group" := 'ASSC_DOM';
                        Vendor."Gen. Bus. Posting Group" := 'DOMESTIC';
                        Vendor."BBG Associate Creation" := Vendor."BBG Associate Creation"::New;
                        Vendor."BBG Status" := Vendor."BBG Status"::Active;
                        Vendor."BBG Creation Date" := Today;
                        Vendor."BBG Associate Password" := 'BBG@1234';
                        Vendor."Region/Districts Code" := Districtcode;  //27/03/25


                        Vendor.Validate("Assessee Code", 'IND');

                        Vendor."State Code" := StateCode; //23072025 Code added
                        Vendor."District Code" := Districtcode;  //23072025 Code added
                                                                 // Vendor."Mandal Code" := AssociateLoginDetails."Mandal Code";  //23072025 Code added
                                                                 // vendor."Village Code" := AssociateLoginDetails."Village Code";   //23072025 Code added
                                                                 // IF AssociateLoginDetails."Aadhaar Number" <> '' then
                                                                 //     Vendor."BBG Aadhar No." := AssociateLoginDetails."Aadhaar Number"; //23072025 Code added
                        Vendor."Create from XMLPort" := True;
                        vendor."BBG Created By" := USERID;
                        Vendor.INSERT;

                        AllowedSection.Init();
                        AllowedSection."Vendor No" := Vendor."No.";
                        AllowedSection.Validate("TDS Section", '194H');
                        AllowedSection.Insert(true);

                        RegionwiseVendor.INIT;
                        RegionwiseVendor."Region Code" := RegionCode;
                        RegionwiseVendor.VALIDATE("No.", Vendor."No.");
                        RegionwiseVendor."Rank Code" := RankCode_1;
                        RegionwiseVendor."Parent Code" := SponserID;
                        RegionwiseVendor."Associate DOJ" := Today;
                        RegionwiseVendor.INSERT;
                        RegionwiseVendor.VALIDATE("Rank Code");
                        RegionwiseVendor.VALIDATE("Parent Code");

                        RegionwiseVendor."Vendor Check Status" := RegionwiseVendor."Vendor Check Status"::Release;
                        RegionwiseVendor.MODIFY;

                        VendorBankAccount.RESET;
                        IF NOT VendorBankAccount.GET('1001', Vendor."No.") THEN BEGIN
                            VendorBankAccount.INIT;
                            VendorBankAccount.Code := '1001';
                            VendorBankAccount."Vendor No." := Vendor."No.";
                            // VendorBankAccount.Name := AssociateLoginDetails."Bank Name";
                            // VendorBankAccount."Bank Branch No." := AssociateLoginDetails."IFSC Code";
                            // VendorBankAccount."SWIFT Code" := AssociateLoginDetails."MICR Code";
                            // VendorBankAccount.Address := AssociateLoginDetails."Bank Address";
                            // VendorBankAccount."Address 2" := AssociateLoginDetails."Bank Address 2";
                            // VendorBankAccount.Contact := AssociateLoginDetails."Benificiary Name as per Bank";
                            // VendorBankAccount."Bank Account No." := AssociateLoginDetails."Bank Account No.";
                            VendorBankAccount.INSERT;
                        END;
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

                        //060525 Code added Start
                        RankCodeMaster.RESET;
                        RankCodeMaster.SETRANGE("Rank Batch Code", RegionCode);
                        RankCodeMaster.SETRANGE(Code, RankCode_1);
                        IF RankCodeMaster.FINDFIRST THEN;
                        IF Vendor."BBG Black List" THEN
                            AssStatus := 'Deactivate'
                        ELSE
                            AssStatus := 'Active';

                        CustomersLead.INIT;
                        CustomersLead."No." := '';
                        CustomersLead.INSERT(TRUE);
                        customersLead."First Name" := Name;
                        CustomersLead.Name := Name;
                        CustomersLead."District Code" := Districtcode;
                        CustomersLead."Mobile Phone No." := MobileNo;
                        CustomersLead."State Code" := StateCode;
                        CustomersLead.City := Citycode;
                        CustomersLead.Rank_Code := RankCode_1;
                        CustomersLead."Request From" := CustomersLead."Request From"::Vendor;
                        CustomersLead."Document Date" := Today;
                        CustomersLead.Status := CustomersLead.Status::Approved;
                        CustomersLead."Region Code" := RegionCode;
                        CustomersLead."Associate ID" := SponserID;
                        CustomersLead."Associate Name" := SponserName;
                        CustomersLead."New Region Code" := RegionCode;
                        CustomersLead."Lead Associate / Customer Id" := Vendor."No.";
                        CustomersLead."Lead Associate / Customer Name" := Vendor.Name;
                        CustomersLead.Modify();

                        NAL_AssociateLoginDetails.RESET;
                        IF NAL_AssociateLoginDetails.FINDLAST THEN
                            EntryNo := NAL_AssociateLoginDetails.USER_ID;


                        v_AssociateLoginDetails.INIT;
                        v_AssociateLoginDetails.USER_ID := EntryNo + 1;
                        v_AssociateLoginDetails.Name := UPPERCASE(Name);
                        v_AssociateLoginDetails.PAN_No := 'PANAPPLIED';
                        v_AssociateLoginDetails.Password := 'BBG@1234';// COPYSTR(VendName,1,1)+FORMAT(v_AssociateLoginDetails.USER_ID) ; 041023
                        v_AssociateLoginDetails.Introducer_Code := SponserID;
                        v_AssociateLoginDetails."Mobile_ No" := MobileNo;
                        v_AssociateLoginDetails."Creation Date" := TODAY;
                        v_AssociateLoginDetails."State Code" := StateCode;
                        v_AssociateLoginDetails.Date := Today;
                        v_AssociateLoginDetails.Date_OF_Joining := TODAY;
                        v_AssociateLoginDetails."Region Code" := StateCode;
                        v_AssociateLoginDetails.Associate_ID := Vendor."No.";
                        v_AssociateLoginDetails."NAV-Associate Created" := True;
                        v_AssociateLoginDetails."NAV-Associate Creation Date" := Today;
                        v_AssociateLoginDetails.Rank_Code := RankCode_1;
                        v_AssociateLoginDetails.Insert();

                        Associate_GUIDDetails.INIT;
                        Associate_GUIDDetails.Token_ID := CreateGuid();
                        Associate_GUIDDetails.USER_ID := v_AssociateLoginDetails.USER_ID;
                        Associate_GUIDDetails.INSERT;

                        WebAppService.Post_data('', Vendor."No.", Vendor.Name, Vendor."BBG Mob. No.", Vendor."E-Mail", Vendor."BBG Team Code", Vendor."BBG Leader Code", SponserID,  //060525 Code added
                                                   FORMAT(AssStatus), FORMAT(RegionwiseVendor."Rank Code"), RankCodeMaster.Description);   //060525 Code added
                        COMMIT;
                        CompanyInformation.GET;
                        IF CompanyInformation."Send SMS" THEN BEGIN
                            CLEAR(PostPayment);
                            SMS := '';
                            SMS := 'Dear Mr/Ms: ' + Vendor.Name + ' Congrats and Welcome to BBG Family. Your Business ID is ' + Vendor."No." + ' PWD is BBG@1234.' +                                         //240625 code Added
                                 ' We Assure you of our Best Support in Transforming Your Dreams into Reality. Please join our BBG WhatsApp channel for updates https://whatsapp.com/channel/0029Va9v5xP6rsQkBNMHFw2V BBGIND.';  //240625 code Added
                            PostPayment.SendSMS(Vendor."BBG Mob. No.", SMS);

                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage := COPYSTR(SMS, 1, 250);
                            SmsMessage1 := COPYSTR(SMS, 251, 250);


                        END;

                        // IF Vendor."E-Mail" <> '' THEN BEGIN
                        //     unitsetup.GET;
                        //     Filename := '';
                        //     Filename := unitsetup."Associate Mail Image Path";

                        //     CLEAR(smtpMail);
                        //     SMTPSetup.Reset();
                        //     SMTPSetup.SetFilter(Name, '<>%1', '');
                        //     if SMTPSetup.FindFirst() then;

                        //     HtmlEmailBody := '<!DOCTYPE html><html><body>';



                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += 'Dear Sir,';
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += 'Your ID - ' + Vendor."No.";
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += 'Login ID - ' + Vendor."BBG Mob. No.";
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += 'Password - ' + Vendor."BBG Associate Password";
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += 'Regards';
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += 'Building Blocks Group';
                        //     HtmlEmailBody += '<br/>';
                        //     EmailMessage.Create(Vendor."E-Mail", 'Associate Onboard', HtmlEmailBody, True);
                        //     unitsetup."Associate Mail Image".CreateInStream(AttachmentStream);
                        //     EmailMessage.AddAttachment('' + '.JPEG', '.JPEG', AttachmentStream);

                        //     IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                        //     END;
                        //     SLEEP(5000);
                        // END;
                        // IntVender.RESET;
                        // IntVender.GET(SponserID);
                        // IF IntVender."E-Mail" <> '' THEN BEGIN
                        //     CLEAR(smtpMail);
                        //     SMTPSetup.Reset();
                        //     SMTPSetup.SetFilter(Name, '<>%1', '');
                        //     if SMTPSetup.FindFirst() then;

                        //     HtmlEmailBody := '<!DOCTYPE html><html><body>';
                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += 'Dear Sir,';
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += 'Your request for Mr.' + Vendor.Name + ' have been approved';
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += 'ID : ' + Vendor."No.";
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += 'Welcome to BBG family';
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += 'Thanks';
                        //     HtmlEmailBody += '<br/>';
                        //     HtmlEmailBody += '<br>';
                        //     HtmlEmailBody += 'Building Blocks Group';
                        //     HtmlEmailBody += '<br/>';
                        //     //SMTPMail.Send;
                        //     EmailMessage.Create(IntVender."E-Mail", 'Associate Onboard', HtmlEmailBody, True);
                        //     IF NOT smtpMail.Send(EmailMessage, Enum::"Email Scenario"::Default) THEN begin

                        //     END;
                        //     SLEEP(5000);
                        // END;
                    END;
                END;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        MESSAGE('%1', 'Process Done');
    end;

    var

        Vendor: Record Vendor;
        CustomersLead: record "Customers Lead_2";
        AllowedSection: Record "Allowed Sections";
        RegionwiseVendor_1: Record "Region wise Vendor";
        Vendor_2: Record vendor;
        CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";
        ExitMessage: Boolean;
        RecVendor_1: Record Vendor;
        MobFirstLetter: Text;
        VendNo: Code[20];
        NoSeriesManagement: Codeunit NoSeriesManagement;
        RegionwiseVendor: Record "Region wise Vendor";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        Vend: Record Vendor;
        RecVendorBankAccount: Record "Vendor Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
        BondSetup: Record "Unit Setup";
        RankCodeMaster: Record "Rank Code";
        AssStatus: text;
        WebAppService: Codeunit "Web App Service";
        NAL_AssociateLoginDetails: Record "Associate Login Details";
        EntryNo: integer;
        v_AssociateLoginDetails: Record "Associate Login Details";
        Associate_GUIDDetails: Record "Associate_GUID Details";
        SLNo: integer;
        CompanyInformation: Record "Company Information";
        IntVender: Record Vendor;
        SMS: text;
        PostPayment: Codeunit PostPayment;
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        unitsetup: Record "Unit Setup";
        smtpMail: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        SMTPSetup: Record "Email Account";
        HtmlEmailBody: text;
        AttachmentStream: InStream;
        RankCode_1: Decimal;


}

