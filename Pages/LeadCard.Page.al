page 60697 "Lead Card"
{
    Caption = 'Contact Card';
    PageType = ListPlus;
    SourceTable = "Customers Lead_2";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                }
                field(Surname; Rec.Surname)
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field("Parent Name"; Rec."Parent Name")
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field(City; Rec.City)
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Search Name"; Rec."Search Name")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Lead Type"; Rec."Lead Type")
                {
                }
                field(Occupation; Rec.Occupation)
                {
                }
                field("Income Category"; Rec."Income Category")
                {
                }
                field("Mode Of Approach"; Rec."Mode Of Approach")
                {
                }
                field("Customer Vehicle"; Rec."Customer Vehicle")
                {
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Caption = 'Lead Creation Date';
                }
                field("Date of Last Interaction"; Rec."Date of Last Interaction")
                {

                    trigger OnDrillDown()
                    var
                        InteractionLogEntry: Record "Interaction Log Entry";
                    begin
                        InteractionLogEntry.SETCURRENTKEY("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed");
                        InteractionLogEntry.SETRANGE("Contact Company No.", Rec."Company No.");
                        InteractionLogEntry.SETFILTER("Contact No.", Rec."Lookup Contact No.");
                        InteractionLogEntry.SETRANGE("Attempt Failed", FALSE);
                        IF InteractionLogEntry.FINDLAST THEN
                            PAGE.RUN(0, InteractionLogEntry);
                    end;
                }
                field("Last Date Attempted"; Rec."Last Date Attempted")
                {

                    trigger OnDrillDown()
                    var
                        InteractionLogEntry: Record "Interaction Log Entry";
                    begin
                        InteractionLogEntry.SETCURRENTKEY("Contact Company No.", Date, "Contact No.", Canceled, "Initiated By", "Attempt Failed");
                        InteractionLogEntry.SETRANGE("Contact Company No.", Rec."Company No.");
                        InteractionLogEntry.SETFILTER("Contact No.", Rec."Lookup Contact No.");
                        InteractionLogEntry.SETRANGE("Initiated By", InteractionLogEntry."Initiated By"::Us);
                        IF InteractionLogEntry.FINDLAST THEN
                            PAGE.RUN(0, InteractionLogEntry);
                    end;
                }
                field("Aadhaar Number"; Rec."Aadhaar Number")
                {
                }
                field("Pan Number"; Rec."Pan Number")
                {
                }
                field(Verified; Rec.Verified)
                {
                }
                field("Aadhaar URL"; Rec."Aadhaar URL")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    var
                        FiletransferCu: Codeunit "File Transfer";
                    begin
                        Clear(FiletransferCu);
                        FiletransferCu.JagratiExportFile('https://epc.bbgindia.com:44389/Uploaded/DocPostCRM/', Rec."Aadhaar URL");

                    end;
                }
                field("PAN URL"; Rec."PAN URL")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    var
                        FiletransferCu: Codeunit "File Transfer";
                    begin
                        Clear(FiletransferCu);
                        FiletransferCu.JagratiExportFile('https://epc.bbgindia.com:44389/Uploaded/DocPostCRM/', Rec."PAN URL");

                    end;
                }
                field(ProfileURL; Rec.ProfileURL)
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    var
                        FiletransferCu: Codeunit "File Transfer";
                    begin
                        Clear(FiletransferCu);
                        FiletransferCu.JagratiExportFile('https://epc.bbgindia.com:44389/Uploaded/DocPostCRM/', Rec."ProfileURL");

                    end;
                }
                field(Remarks; Rec.Remarks)
                {

                    trigger OnValidate()
                    begin
                        IF (Rec.Status = Rec.Status::Approved) OR (Rec.Status = Rec.Status::Close) OR (Rec.Status = Rec.Status::Rejected) THEN
                            ERROR('Status can not be ' + FORMAT(Rec.Status));
                    end;
                }
                field("Re-Open Comment"; Rec."Re-Open Comment")
                {

                    trigger OnValidate()
                    begin
                        IF (Rec.Status <> Rec.Status::Approved) OR (Rec.Status <> Rec.Status::Close) OR (Rec.Status <> Rec.Status::Rejected) THEN
                            ERROR('Status must be Approve / Close / Rejected');
                    end;
                }
                field("Region/Districts Code"; Rec."Region/Districts Code")
                {

                }
                field("State Code"; Rec."State Code")
                {

                }
                field("District Code"; Rec."District Code")
                {

                }
                field("Mandal Code"; Rec."Mandal Code")
                {

                }
                field("Village Code"; Rec."Village Code")
                {

                }

                //Code added Start 06102025
                field("New Region Code"; Rec."New Region Code")
                {
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        Usersetup: Record "User Setup";
                    begin
                        Rec.TESTFIELD("Lead Associate / Customer Id", '');
                        Usersetup.RESET;
                        Usersetup.SetRange("User ID", UserId);
                        Usersetup.SetRange("Allow Region Code Change", True);
                        If NOT Usersetup.FindFirst() then
                            Error('Contact Admin');
                    end;

                }
                //Code added END 06102025
            }
            part("Lead Card Subform"; "Lead Card Subform")
            {
                SubPageLink = "Contact No." = FIELD("No.");
            }
            part("Prospect Details"; "Prospect Details")
            {
                SubPageLink = "Contact No." = FIELD("No.");
            }
            part("Intraction Sub Page"; "Intraction Sub Page")
            {
                //Provider = Control1120174010;
                // SubPageLink = "Contact No." = FIELD("Contact No."),
                //               "Customer Prospect Line No." = FIELD("Line No.");
            }
            part("Visit Details"; "Cutomer Visit Details")
            {
                Caption = 'Visit Details';
                SubPageLink = "Customer Lead ID" = FIELD("No.");
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.2"; Rec."Phone No.")
                {
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
            }
            group("BBG Department Detail")
            {
                Caption = 'BBG Department Detail';
                field("CRM ID"; Rec."CRM ID")
                {
                }
                field("CRM Name"; Rec."CRM Name")
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = true;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("C&ontact")
            {
                Caption = 'C&ontact';
                Image = ContactPerson;
                group("P&erson")
                {
                    Caption = 'P&erson';
                    Enabled = PersonGroupEnabled;
                    Image = User;
                    Visible = false;
                }
                action("Pro&files")
                {
                    Caption = 'Pro&files';
                    Image = Answers;
                    Visible = false;

                    trigger OnAction()
                    var
                        ProfileManagement: Codeunit "BBG Codeunit Event Mgnt.";// ProfileManagement;
                    begin
                        ProfileManagement.ShowContactQuestionnaireCardCustomer(Rec, '', 0);
                    end;
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Contact Picture";
                    RunPageLink = "No." = FIELD("No.");
                    Visible = false;
                }
                action("CRM Lead Checks")
                {
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        AssociateLeadMenuMaster: Record "Associate Lead Menu Master";
                        CRMLeadChecks: Record "CRM Lead Checks";
                    begin
                        AssociateLeadMenuMaster.RESET;
                        IF AssociateLeadMenuMaster.FINDSET THEN
                            REPEAT
                                CRMLeadChecks.RESET;
                                CRMLeadChecks.SETRANGE("No.", Rec."No.");
                                CRMLeadChecks.SETRANGE("Line No.", AssociateLeadMenuMaster."Entry No.");
                                CRMLeadChecks.SETRANGE(Name, AssociateLeadMenuMaster.Name);
                                IF NOT CRMLeadChecks.FINDFIRST THEN BEGIN
                                    CRMLeadChecks.INIT;
                                    CRMLeadChecks."No." := Rec."No.";
                                    CRMLeadChecks."Line No." := AssociateLeadMenuMaster."Entry No.";
                                    CRMLeadChecks.Name := AssociateLeadMenuMaster.Name;
                                    CRMLeadChecks.INSERT;
                                END;
                            UNTIL AssociateLeadMenuMaster.NEXT = 0;

                        CRMLeadChecks.RESET;
                        CRMLeadChecks.SETRANGE("No.", Rec."No.");
                        IF CRMLeadChecks.FINDFIRST THEN
                            PAGE.RUN(Page::"CRM Lead Checks", CRMLeadChecks);
                    end;
                }
            }
            group(Functions)
            {
                action(Approve)
                {

                    trigger OnAction()
                    begin

                        IF Rec.Status = Rec.Status::Rejected THEN
                            ERROR('Document alredy Rejected');
                        IF CONFIRM('Do you want to Approve this document') THEN BEGIN
                            Rec.TESTFIELD(Remarks);
                            CreateAssociateLogin(Rec);
                            Rec.Status := Rec.Status::Approved;
                            Rec.MODIFY;
                            COMMIT;
                            Rec.ArchiveDuplicateLeadwithMobileNo(Rec);
                            MESSAGE('Document has been Approved');
                        END ELSE
                            MESSAGE('Nothing Done');
                    end;
                }
                action(Reject)
                {

                    trigger OnAction()
                    begin
                        IF Rec.Status = Rec.Status::Approved THEN
                            ERROR('Document alredy Approved');
                        IF CONFIRM('Do you want to Reject this document') THEN BEGIN
                            Rec.TESTFIELD(Remarks);
                            Rec.Status := Rec.Status::Rejected;
                            Rec.MODIFY;
                            MESSAGE('Document has been Rejected');
                        END ELSE
                            MESSAGE('Nothing Done');
                    end;
                }
                action("Re-Open")
                {

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to Re-Open this document') THEN BEGIN
                            Rec.TESTFIELD("Re-Open Comment");
                            Rec.Status := Rec.Status::Open;
                            Rec.MODIFY;
                            MESSAGE('Document has been Open');
                        END ELSE
                            MESSAGE('Nothing Done');
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        xRec := Rec;
        EnableFields;

        IF Rec.Type = Rec.Type::Person THEN
            IntegrationFindCustomerNo
        ELSE
            IntegrationCustomerNo := '';

        /*
        IF CRMIntegrationEnabled THEN
          CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
          */
        ChangLeadType;

    end;

    trigger OnAfterGetRecord()
    begin
        ChangLeadType;
    end;

    trigger OnInit()
    begin
        NoofJobResponsibilitiesEnable := TRUE;
        OrganizationalLevelCodeEnable := TRUE;
        "Company NameEnable" := TRUE;
        "Company No.Enable" := TRUE;
        "VAT Registration No.Enable" := TRUE;
        "Currency CodeEnable" := TRUE;
        MapPointVisible := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        Contact: Record Contact;
    begin
        IF Rec.GETFILTER("Company No.") <> '' THEN BEGIN
            Rec."Company No." := Rec.GETRANGEMAX("Company No.");
            Rec.Type := Rec.Type::Person;
            Contact.GET(Rec."Company No.");
            //  InheritCompanyToPersonData(Contact,TRUE)
        END;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        /*
        IF NOT MapMgt.TestSetup THEN
          MapPointVisible := FALSE;
        
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        SetParentalConsentReceivedEnable;
        */

        IF Rec."No." <> '' THEN
            ChangLeadType;

    end;

    var
        Cont: Record Contact;
        CompanyDetails: Page "Company Details";
        NameDetails: Page "Name Details";
        IntegrationCustomerNo: Code[20];


        MapPointVisible: Boolean;

        "Currency CodeEnable": Boolean;

        "VAT Registration No.Enable": Boolean;

        "Company No.Enable": Boolean;

        "Company NameEnable": Boolean;

        OrganizationalLevelCodeEnable: Boolean;

        NoofJobResponsibilitiesEnable: Boolean;
        CompanyGroupEnabled: Boolean;
        PersonGroupEnabled: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        ParentalConsentReceivedEnable: Boolean;
        NoofDays: Integer;
        BBGSetups: Record "BBG Setups";
        WebAppService: Codeunit "Web App Service";

    local procedure EnableFields()
    begin
        CompanyGroupEnabled := Rec.Type = Rec.Type::Company;
        PersonGroupEnabled := Rec.Type = Rec.Type::Person;
        "Currency CodeEnable" := Rec.Type = Rec.Type::Company;
        "VAT Registration No.Enable" := Rec.Type = Rec.Type::Company;
        "Company No.Enable" := Rec.Type = Rec.Type::Person;
        "Company NameEnable" := Rec.Type = Rec.Type::Person;
        OrganizationalLevelCodeEnable := Rec.Type = Rec.Type::Person;
        NoofJobResponsibilitiesEnable := Rec.Type = Rec.Type::Person;
    end;

    local procedure IntegrationFindCustomerNo()
    var
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        ContactBusinessRelation.SETCURRENTKEY("Link to Table", "Contact No.");
        ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
        ContactBusinessRelation.SETRANGE("Contact No.", Rec."Company No.");
        IF ContactBusinessRelation.FINDFIRST THEN BEGIN
            IntegrationCustomerNo := ContactBusinessRelation."No.";
        END ELSE
            IntegrationCustomerNo := '';
    end;

    local procedure SetParentalConsentReceivedEnable()
    begin
        IF Rec.Minor THEN
            ParentalConsentReceivedEnable := TRUE
        ELSE BEGIN
            Rec."Parental Consent Received" := FALSE;
            ParentalConsentReceivedEnable := FALSE;
        END;
    end;

    local procedure TypeOnAfterValidate()
    begin
        EnableFields;
    end;

    local procedure ChangLeadType()
    begin

        BBGSetups.GET;
        BBGSetups.TESTFIELD("No. of Days for Cold Lead");
        BBGSetups.TESTFIELD("No. of Days for Hot Lead");

        NoofDays := 0;
        IF Rec."Document Date" <> 0D THEN
            NoofDays := TODAY - Rec."Document Date";

        IF NoofDays < BBGSetups."No. of Days for Hot Lead" THEN
            Rec."Lead Type" := Rec."Lead Type"::Hot
        ELSE IF (NoofDays > BBGSetups."No. of Days for Hot Lead") AND (NoofDays < BBGSetups."No. of Days for Cold Lead") THEN
            Rec."Lead Type" := Rec."Lead Type"::Cold
        ELSE IF NoofDays > BBGSetups."No. of Days for Cold Lead" THEN
            Rec."Lead Type" := Rec."Lead Type"::Failed;
        Rec.MODIFY;
    end;

    local procedure "--------------------------"()
    begin
    end;

    local procedure CreateAssociateLogin(var v_CustLeads: Record "Customers Lead_2")
    var
        AssociateLoginDetails: Record "Associate Login Details";
        NAL_AssociateLoginDetails1: Record "Associate Login Details";
        NAL_AssociateLoginDetails: Record "Associate Login Details";
        LenIntroducer: Integer;
        EntryNo: Integer;
        CreateAssociateSendSMS: Codeunit "Create Associate / SendSMS";
        CustomersLead_2: Record "Customers Lead_2";
    begin
        AssociateLoginDetails.RESET;
        AssociateLoginDetails.SETRANGE("Mobile_ No", v_CustLeads."Mobile Phone No.");
        IF NOT AssociateLoginDetails.FINDFIRST THEN BEGIN
            NAL_AssociateLoginDetails.RESET;
            IF NAL_AssociateLoginDetails.FINDLAST THEN
                EntryNo := NAL_AssociateLoginDetails.USER_ID;

            NAL_AssociateLoginDetails1.INIT;
            NAL_AssociateLoginDetails1.USER_ID := EntryNo + 1;
            NAL_AssociateLoginDetails1.Name := UPPERCASE(v_CustLeads.Name);
            IF v_CustLeads."Pan Number" = '' THEN
                NAL_AssociateLoginDetails1.PAN_No := 'PANAPPLIED'
            ELSE
                NAL_AssociateLoginDetails1.PAN_No := v_CustLeads."Pan Number";

            NAL_AssociateLoginDetails1.Password := 'bbg@1234';
            NAL_AssociateLoginDetails1.Introducer_Code := v_CustLeads."Associate ID";
            NAL_AssociateLoginDetails1.Parent_ID := v_CustLeads."Associate ID";
            NAL_AssociateLoginDetails1."Mobile_ No" := v_CustLeads."Mobile Phone No.";
            NAL_AssociateLoginDetails1."Creation Date" := TODAY;
            NAL_AssociateLoginDetails1.Date_OF_Birth := v_CustLeads.DOB;
            NAL_AssociateLoginDetails1.Address := v_CustLeads.Address;
            NAL_AssociateLoginDetails1."Email-Id" := v_CustLeads."E-Mail";
            IF v_CustLeads.Gender = v_CustLeads.Gender::Male THEN
                NAL_AssociateLoginDetails1.Gender := 'Male';
            IF v_CustLeads.Gender = v_CustLeads.Gender::Female THEN
                NAL_AssociateLoginDetails1.Gender := 'Female';
            IF v_CustLeads.Gender = v_CustLeads.Gender::Other THEN
                NAL_AssociateLoginDetails1.Gender := 'Other';
            NAL_AssociateLoginDetails1.City := v_CustLeads.City;
            NAL_AssociateLoginDetails1."Data Come From" := NAL_AssociateLoginDetails1."Data Come From"::CRM;
            IF v_CustLeads."Parent ID" = '' THEN
                NAL_AssociateLoginDetails1.Parent_ID := v_CustLeads."Associate ID"
            ELSE
                NAL_AssociateLoginDetails1.Parent_ID := v_CustLeads."Parent ID";
            NAL_AssociateLoginDetails1.Date_OF_Joining := TODAY;
            NAL_AssociateLoginDetails1.Designation := v_CustLeads.Designation;
            NAL_AssociateLoginDetails1.Rank_Code := v_CustLeads.Rank_Code;
            NAL_AssociateLoginDetails1."Region Code" := v_CustLeads."Region Code";
            NAL_AssociateLoginDetails1."Reporting Office" := v_CustLeads."Reporting Office Name";
            NAL_AssociateLoginDetails1."New Cluster Code" := v_CustLeads."Cluster Description";
            NAL_AssociateLoginDetails1."Region/Districts Code" := v_CustLeads."Region/Districts Code";  //270325
            //Code added start 23072025 
            IF v_CustLeads."State Code" = 'TS' then
                NAL_AssociateLoginDetails1."State Code" := 'TG'
            ELSE
                NAL_AssociateLoginDetails1."State Code" := v_CustLeads."State Code";
            NAL_AssociateLoginDetails1."District Code" := v_CustLeads."District Code";
            NAL_AssociateLoginDetails1."Mandal Code" := v_CustLeads."Mandal Code";
            NAL_AssociateLoginDetails1."Village Code" := v_CustLeads."Village Code";
            IF v_CustLeads."Aadhaar Number" <> '' then
                NAL_AssociateLoginDetails1."Aadhaar Number" := v_CustLeads."Aadhaar Number";
            //Code added END 23072025 

            NAL_AssociateLoginDetails1.INSERT;

            CLEAR(CreateAssociateSendSMS);
            IF NAL_AssociateLoginDetails1.USER_ID <> 0 THEN BEGIN
                v_CustLeads."Lead Associate / Customer Id" := CreateAssociateSendSMS.CreateVendorMAster(NAL_AssociateLoginDetails1.USER_ID, Rec."New Region Code");  //Code added 06102025 Paraemter "New Region code"
                v_CustLeads."Lead Associate / Customer Name" := NAL_AssociateLoginDetails1.Name;
            END;
        END;
    end;
}

