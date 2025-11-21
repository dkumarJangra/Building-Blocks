page 50101 "Associate Login Details"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Associate Login Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Send for Associate Create"; Rec."Send for Associate Create")
                {
                }
                field(USER_ID; Rec.USER_ID)
                {
                }
                field("Mobile_ No"; Rec."Mobile_ No")
                {
                }
                field(Associate_ID; Rec.Associate_ID)
                {
                }
                field("Device ID"; Rec."Device ID")
                {
                }
                field(Rank_Code; Rec.Rank_Code)
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field(Date_OF_Birth; Rec.Date_OF_Birth)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Address; Rec.Address)
                {
                }
                field(City; Rec.City)
                {
                }
                field(Post_Code; Rec.Post_Code)
                {
                }
                field(PAN_No; Rec.PAN_No)
                {
                }
                field(Introducer_Code; Rec.Introducer_Code)
                {
                }
                field(Date_OF_Joining; Rec.Date_OF_Joining)
                {
                }
                field(Of_User_ID; Rec.Of_User_ID)
                {
                }
                field(Parent_ID; Rec.Parent_ID)
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("NAV-Associate Created"; Rec."NAV-Associate Created")
                {
                }
                field("NAV-Associate Creation Date"; Rec."NAV-Associate Creation Date")
                {
                }
                field("Is Active"; Rec."Is Active")
                {
                }
                field("Associate Creation Error"; Rec."Associate Creation Error")
                {
                }
                field("Identity No."; Rec."Identity No.")
                {
                }
                field(Designation; Rec.Designation)
                {
                }
                field("Father Name"; Rec."Father Name")
                {
                }
                field(Age; Rec.Age)
                {
                }
                field(Occupation; Rec.Occupation)
                {
                }
                field("Wedding Anniversary"; Rec."Wedding Anniversary")
                {
                }
                field("Email-Id"; Rec."Email-Id")
                {
                }
                field("Nominee Name"; Rec."Nominee Name")
                {
                }
                field(RelationShip; Rec.RelationShip)
                {
                }
                field("Nominee Age"; Rec."Nominee Age")
                {
                }
                field("Telephone No."; Rec."Telephone No.")
                {
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                }
                field("Aadhaar Number"; Rec."Aadhaar Number")
                {

                }
                field("Sponsor Name"; Rec."Sponsor Name")
                {
                }
                field("Sponsor Id"; Rec."Sponsor Id")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Place; Rec.Place)
                {
                }
                field("Region Code"; Rec."Region Code")
                {
                }
                field("Mode of Prospect Meet"; Rec."Mode of Prospect Meet")
                {
                }
                field("Income Level"; Rec."Income Level")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("State Code"; Rec."State Code")
                {
                }
                field("District Code"; Rec."District Code")
                {
                    Caption = 'District Code';
                    Editable = False;

                }
                field("Mandal Code"; Rec."Mandal Code")
                {
                    Caption = 'Mandal Code';
                    Editable = False;

                }
                field("Village Code"; Rec."Village Code")
                {
                    Caption = 'Village Code';
                    Editable = False;

                }

                field("Whats App No."; Rec."Whats App No.")
                {
                }
                field("Intersted on Participating"; Rec."Intersted on Participating")
                {
                }
                field("Preffered Day/ Time"; Rec."Preffered Day/ Time")
                {
                }
                field(Education; Rec.Education)
                {
                }
                field("What vehicle do you own"; Rec."What vehicle do you own")
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field("Marital Status"; Rec."Marital Status")
                {
                }
                field("Presence on Social Media"; Rec."Presence on Social Media")
                {
                }
                field("No of Plots you own"; Rec."No of Plots you own")
                {
                }
                field("Send Data to Pathsala"; Rec."Send Data to Pathsala")
                {
                }
                field("Reporting Office"; Rec."Reporting Office")
                {
                }
                field("New Cluster Code"; Rec."New Cluster Code")
                {
                    Caption = 'Cluster Code';
                }
                field("Region/Districts Code"; Rec."Region/Districts Code")
                {
                    Caption = 'Region/Districts Code';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Associate")
            {

                trigger OnAction()
                var
                    VendNo: Code[20];
                    CreateAssociateandSendSMS: Codeunit "Create Associate and Send SMS";
                    UserSetup: Record "User Setup";
                    MobFirstLetter: Text;
                    WebAppService: Codeunit "Web App Service";
                begin
                    /*
                    CLEAR(CreateAssociateandSendSMS);
                    CreateAssociateandSendSMS.RUN;
                    
                    MESSAGE('Process Done');
                    */

                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", USERID);
                    IF UserSetup.FINDFIRST THEN
                        UserSetup.TESTFIELD("Create Associate Manual");

                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
                    IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                        IF COMPANYNAME <> CompanywiseGLAccount."Company Code" THEN
                            ERROR('Associate create only from-' + CompanywiseGLAccount."Company Code");
                    END;




                    AssociateLoginDetails.RESET;
                    AssociateLoginDetails.SETRANGE(Associate_ID, '');
                    AssociateLoginDetails.SETRANGE("NAV-Associate Created", FALSE);
                    AssociateLoginDetails.SETRANGE("Send for Associate Create", TRUE);
                    AssociateLoginDetails.SETFILTER(Status, '%1|%2', AssociateLoginDetails.Status::"Sent for Approval", AssociateLoginDetails.Status::"Under Process");
                    IF AssociateLoginDetails.FINDSET THEN
                        REPEAT
                            //210224 Added new code
                            CLEAR(CheckMobileNoforSMS);
                            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(AssociateLoginDetails."Mobile_ No", FALSE);
                            IF ExitMessage THEN BEGIN
                                MobFirstLetter := '';
                                VendNo := '';
                                VendNo := NoSeriesManagement.GetNextNo('VEND-IBA', TODAY, TRUE);
                                Vendor.INIT;
                                Vendor."No." := VendNo;
                                Vendor.Name := AssociateLoginDetails.Name;
                                Vendor."BBG Mob. No." := AssociateLoginDetails."Mobile_ No";
                                MobFirstLetter := COPYSTR(AssociateLoginDetails."Mobile_ No", 1, 1);
                                IF MobFirstLetter = 'R' THEN
                                    ERROR('Mobile no. invalid');
                                Vendor."BBG Introducer" := AssociateLoginDetails.Introducer_Code;
                                Vendor."BBG Date of Joining" := AssociateLoginDetails.Date_OF_Joining;
                                Vendor."BBG Vendor Category" := Vendor."BBG Vendor Category"::"IBA(Associates)";
                                Vendor.Address := COPYSTR(AssociateLoginDetails.Address, 1, 50);
                                ;
                                Vendor."Address 2" := COPYSTR(AssociateLoginDetails.Address, 51, 100);
                                Vendor."BBG Address 3" := COPYSTR(AssociateLoginDetails.Address, 101, 150);
                                Vendor."BBG Associate Password" := AssociateLoginDetails.Password;
                                IF AssociateLoginDetails.PAN_No = 'PANAPPLIED' THEN BEGIN
                                    Vendor."P.A.N. No." := 'PANAPPLIED';
                                    Vendor."P.A.N. Status" := Vendor."P.A.N. Status"::PANAPPLIED;
                                END ELSE
                                    Vendor."P.A.N. No." := AssociateLoginDetails.PAN_No;

                                CheckVendPanNo.RESET;
                                CheckVendPanNo.SETFILTER("No.", '<>%1', Vendor."No.");
                                CheckVendPanNo.SETRANGE("P.A.N. No.", Vendor."P.A.N. No.");
                                CheckVendPanNo.SETRANGE("BBG Vendor Category", Vendor."BBG Vendor Category");//ALLETDK120413
                                IF CheckVendPanNo.FINDFIRST THEN BEGIN
                                    IF CheckVendPanNo."P.A.N. No." <> 'PANAPPLIED' THEN
                                        ERROR(Text016, Vendor."P.A.N. No.");
                                END;
                                Vendor."BBG Nationality" := 'Indian';
                                Vendor."BBG Marital Status" := Vendor."BBG Marital Status"::Unmarried;
                                Vendor."Vendor Posting Group" := 'ASSC_DOM';
                                Vendor."Gen. Bus. Posting Group" := 'DOMESTIC';
                                Vendor."BBG Date of Birth" := AssociateLoginDetails.Date_OF_Birth;
                                Vendor."BBG Associate Creation" := Vendor."BBG Associate Creation"::New;
                                Vendor."BBG Web User_ID" := AssociateLoginDetails.USER_ID;
                                Vendor."BBG Status" := Vendor."BBG Status"::Active;
                                Vendor."BBG Web Associate Payment Active" := TRUE;
                                Vendor."BBG Address Proof Type" := AssociateLoginDetails."Address Proof Type"; //11-11-21
                                Vendor."BBG Creation Date" := AssociateLoginDetails."Creation Date";
                                Vendor."BBG Create from Web/Mobile" := TRUE;
                                Vendor."BBG Age" := AssociateLoginDetails.Age;
                                Vendor."BBG Father Name" := AssociateLoginDetails."Father Name";
                                Vendor.City := AssociateLoginDetails.City;
                                Vendor."BBG Nominee Name" := AssociateLoginDetails."Nominee Name";
                                Vendor."Post Code" := AssociateLoginDetails.Post_Code;
                                Vendor."BBG Designation" := AssociateLoginDetails.Designation;
                                Vendor."E-Mail" := AssociateLoginDetails."Email-Id";
                                Vendor."BBG Reporting Office" := AssociateLoginDetails."Reporting Office";
                                Vendor."Region/Districts Code" := AssociateLoginDetails."Region/Districts Code";  //270325
                                IF AssociateLoginDetails.Gender = 'Male' THEN
                                    Vendor."BBG Sex" := Vendor."BBG Sex"::Male;
                                IF AssociateLoginDetails.Gender = 'Female' THEN
                                    Vendor."BBG Sex" := Vendor."BBG Sex"::Female;
                                //Code Added Start 29072025
                                Vendor."District Code" := AssociateLoginDetails."District Code";
                                Vendor."Mandal Code" := AssociateLoginDetails."Mandal Code";
                                Vendor."Village Code" := AssociateLoginDetails."Village Code";
                                Vendor."BBG Aadhar No." := AssociateLoginDetails."Aadhaar Number";  //Code added 23072025
                                //Code Added END 29072025
                                Vendor.INSERT;



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
                                    RegionwiseVendor.VALIDATE("Parent Code", AssociateLoginDetails.Parent_ID)
                                ELSE
                                    RegionwiseVendor.VALIDATE("Parent Code", AssociateLoginDetails.Introducer_Code);

                                RegionwiseVendor."Associate DOJ" := AssociateLoginDetails.Date_OF_Joining;
                                RegionwiseVendor.INSERT;
                                /*
                                BondSetup.GET;
                                BondSetup.TESTFIELD("TDS Nature of Deduction");
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

                                AssociateLoginDetails."NAV-Associate Created" := TRUE;
                                AssociateLoginDetails."NAV-Associate Creation Date" := TODAY;
                                AssociateLoginDetails.Associate_ID := Vendor."No.";
                                AssociateLoginDetails."Vendor Profile Status" := AssociateLoginDetails."Vendor Profile Status"::Close;
                                AssociateLoginDetails."Send for Associate Create" := FALSE;
                                AssociateLoginDetails.Status := AssociateLoginDetails.Status::Approved;
                                AssociateLoginDetails.MODIFY;
                                //050324 code added start
                                CustomersLead_2.RESET;
                                CustomersLead_2.SETRANGE("Mobile Phone No.", Vendor."BBG Mob. No.");
                                IF CustomersLead_2.FINDSET THEN
                                    REPEAT
                                        CustomersLead_2."Lead Associate / Customer Id" := Vendor."No.";
                                        CustomersLead_2.MODIFY;
                                    UNTIL CustomersLead_2.NEXT = 0;
                                //050324 code added END


                                COMMIT;


                                //ALLEDK 221123

                                CLEAR(WebAppService);
                                RegionwiseVendor.RESET;
                                RegionwiseVendor.SETCURRENTKEY(RegionwiseVendor."No.");
                                RegionwiseVendor.SETRANGE("No.", Vendor."No.");
                                IF RegionwiseVendor.FINDFIRST THEN;


                                RankCodeMaster.RESET;
                                RankCodeMaster.SETRANGE("Rank Batch Code", RegionwiseVendor."Region Code");
                                RankCodeMaster.SETRANGE(Code, RegionwiseVendor."Rank Code");
                                IF RankCodeMaster.FINDFIRST THEN;
                                IF Vendor."BBG Black List" THEN
                                    AssStatus := 'Deactivate'
                                ELSE
                                    AssStatus := 'Active';

                                WebAppService.Post_data('', Vendor."No.", Vendor.Name, Vendor."BBG Mob. No.", Vendor."E-Mail", Vendor."BBG Team Code", Vendor."BBG Leader Code", RegionwiseVendor."Parent Code",
                          FORMAT(AssStatus), FORMAT(RegionwiseVendor."Rank Code"), RankCodeMaster.Description);

                                //ALLEDK 221123
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
                                            Vend.VALIDATE("P.A.N. No.", Vendor."P.A.N. No.");
                                            Vend."P.A.N. Status" := Vendor."P.A.N. Status";
                                            Vend."Gen. Bus. Posting Group" := Vendor."Gen. Bus. Posting Group";
                                            Vend.MODIFY;
                                        END;
                                    UNTIL CompanywiseGLAccount.NEXT = 0;
                                END;
                                //-----------------------------
                            END;  //210224 code added
                        UNTIL AssociateLoginDetails.NEXT = 0;



                    MESSAGE('%1', 'Process Done');

                end;
            }
            action("View Document")
            {
                RunObject = Page "User Document Attachment";
                RunPageLink = "USER_ID" = FIELD("USER_ID");
            }
            action("Update Associate Profile")
            {
                Visible = false;

                trigger OnAction()
                var
                    RecVendor: Record Vendor;
                    Company: Record Company;
                begin
                    Company.RESET;
                    IF Company.FINDSET THEN
                        REPEAT
                            RecVendor.RESET;
                            RecVendor.CHANGECOMPANY(Company.Name);
                            RecVendor.SETRANGE("No.", Rec.Associate_ID);
                            IF RecVendor.FINDFIRST THEN BEGIN
                                RecVendor."BBG Date of Birth" := Rec.Date_OF_Birth;
                                RecVendor.Name := Rec.Name;
                                RecVendor.Address := COPYSTR(Rec.Address, 1, 50);
                                RecVendor.City := Rec.City;
                                RecVendor."Post Code" := Rec.Post_Code;
                                RecVendor."P.A.N. No." := Rec.PAN_No;
                                RecVendor."BBG Introducer" := Rec.Introducer_Code;
                                //RecVendor.Date_OF_Joining := Date_OF_Joining;
                                RecVendor.MODIFY;
                            END;
                        UNTIL Company.NEXT = 0;
                    Rec."Vendor Profile Status" := Rec."Vendor Profile Status"::Close;
                    Rec.MODIFY;
                end;
            }
            action("Update Associate Details")
            {

                trigger OnAction()
                var
                    v_Vendor: Record Vendor;
                    v_RegionwiseVendor: Record "Region wise Vendor";
                begin
                    v_Vendor.RESET;
                    v_Vendor.SETCURRENTKEY("BBG Mob. No.");
                    v_Vendor.SETRANGE("BBG Mob. No.", Rec."Mobile_ No");
                    v_Vendor.SETRANGE("BBG Vendor Category", v_Vendor."BBG Vendor Category"::"IBA(Associates)");
                    IF v_Vendor.FINDFIRST THEN BEGIN
                        Rec.Password := v_Vendor."BBG Associate Password";
                        Rec.Associate_ID := v_Vendor."No.";
                        v_RegionwiseVendor.RESET;
                        //v_RegionwiseVendor.SETRANGE(v_RegionwiseVendor."Region Code",'R0001');
                        v_RegionwiseVendor.SETRANGE(v_RegionwiseVendor."No.", v_Vendor."No.");
                        IF v_RegionwiseVendor.FINDFIRST THEN
                            Rec.Rank_Code := v_RegionwiseVendor."Rank Code";
                        Rec.Parent_ID := v_RegionwiseVendor."Parent Code";
                        Rec.Status := Rec.Status::Approved;
                        Rec.Date_OF_Birth := v_Vendor."BBG Date of Birth";
                        Rec.Address := v_Vendor.Address;
                        Rec.City := v_Vendor.City;
                        Rec.Post_Code := v_Vendor."Post Code";
                        Rec.PAN_No := v_Vendor."P.A.N. No.";
                        Rec.Introducer_Code := v_Vendor."BBG Introducer";
                        Rec.Date_OF_Joining := v_Vendor."BBG Date of Joining";

                        Rec."NAV-Associate Created" := TRUE;
                        Rec."NAV-Associate Creation Date" := TODAY;
                        Rec."Is Active" := TRUE;
                        Rec.MODIFY;
                    END;
                end;
            }
            action(ChangeStatus)
            {

                trigger OnAction()
                var
                    Selection: Integer;
                begin
                    IF CONFIRM('Do you want to Change Status.') THEN BEGIN
                        Selection := STRMENU(Text002, 2);
                        IF Selection <> 0 THEN BEGIN
                            IF Selection = 1 THEN
                                Rec.Status := Rec.Status::"Under Process"
                            ELSE
                                Rec.Status := Rec.Status::Reject;
                            Rec."Mobile_ No" := 'R' + Rec."Mobile_ No";
                            Rec.MODIFY;
                        END;
                        MESSAGE('Status Updated');
                    END ELSE
                        MESSAGE('Nothing Process');
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Associate Creation", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('You not not have permission for Associate Creation in user setup');//Contact Admin
    end;

    var
        Vendor: Record Vendor;
        RegionwiseVendor: Record "Region wise Vendor";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        AssociateLoginDetails: Record "Associate Login Details";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        BondSetup: Record "Unit Setup";
        //NODHeader: Record 13786;//Need to check the code in UAT

        //NODLine: Record 13785;//Need to check the code in UAT

        Vendor_1: Record Vendor;
        AssociateCode: Code[20];
        Comp: Record "Company Information";
        Vend: Record Vendor;
        RecVendorBankAccount: Record "Vendor Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
        Text002: Label '&Under Process,&Reject';
        RankCodeMaster: Record "Rank Code";
        AssStatus: Text;
        CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";
        ExitMessage: Boolean;
        CustomersLead_2: Record "Customers Lead_2";
        CheckVendPanNo: Record Vendor;
        Text016: Label 'Duplicate PAN No.';
}

