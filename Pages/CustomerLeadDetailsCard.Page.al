page 60707 "Customer Lead Details Card"
{
    Caption = 'Contact Card';
    PageType = Document;
    SourceTable = "Customers Lead_2";
    ApplicationArea = All;
    UsageCategory = Documents;
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
                    OptionCaption = '<Open,Closed,Pending,Approved,Rejected>';
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
                    begin
                        Clear(FileTransferCU);
                        FileTransferCU.JagratiExportFile('https://epc.bbgindia.com:44389/Uploaded/DocPostCRM/', Rec."Aadhaar URL");
                    end;
                }
                field("PAN URL"; Rec."PAN URL")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        Clear(FileTransferCU);
                        FileTransferCU.JagratiExportFile('https://epc.bbgindia.com:44389/Uploaded/DocPostCRM/', Rec."PAN URL");

                    end;
                }
                field(ProfileURL; Rec.ProfileURL)
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        Clear(FileTransferCU);
                        FileTransferCU.JagratiExportFile('https://epc.bbgindia.com:44389/Uploaded/DocPostCRM/', Rec.ProfileURL);
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
            }
            part("Customer Family Details"; "Customer Family Details")
            {
                SubPageLink = "Customer Lead ID" = FIELD("No.");
            }
            part("1"; "Cutomer Visit Details")
            {
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
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Lead Associate / Customer Id"; Rec."Lead Associate / Customer Id")
                {
                }
                field("Lead Associate / Customer Name"; Rec."Lead Associate / Customer Name")
                {
                }
                field("State Code"; Rec."State Code")
                {
                    Editable = False;
                }
                field("District Code"; Rec."District Code")
                {
                    Editable = False;
                }
                field("Mandal Code"; Rec."Mandal Code")
                {
                    Editable = False;
                }
                field("Village Code"; Rec."Village Code")
                {
                    Editable = False;
                }
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
                Visible = false;
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
                        ProfileManagement: Codeunit "BBG Codeunit Event Mgnt.";// 5059;
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
            }
            group(Functions)
            {
                action(Approve)
                {

                    trigger OnAction()
                    begin
                        IF Rec.Status = Rec.Status::Rejected THEN
                            ERROR('Document alredy Rejected');
                        IF CONFIRM('Do you want to Approv this document') THEN BEGIN
                            Rec.TESTFIELD(Remarks);
                            CreateCustomerLogin(Rec);
                            Rec.Status := Rec.Status::Approved;
                            Rec.MODIFY;
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
                        AssociateLeadMenuMaster.SETRANGE("Is for Customer", TRUE);
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
        FileTransferCU: Codeunit "File Transfer";

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

    local procedure CreateCustomerLogin(var v_CustLeads: Record "Customers Lead_2"): Text
    var
        CustomerLoginDetails: Record "Customer Login Details";
        NAL_CustomerLoginDetails1: Record "Customer Login Details";
        NAL_CustomerLoginDetails: Record "Customer Login Details";
        LenIntroducer: Integer;
        EntryNo: Integer;
        CreateCustomerSendSMS: Codeunit "Create Customer / SendSMS";
        CustomersLead_2: Record "Customers Lead_2";
    begin
        EntryNo := 0;
        CustomerLoginDetails.RESET;
        CustomerLoginDetails.SETRANGE("Mobile No.", v_CustLeads."Mobile Phone No.");
        IF NOT CustomerLoginDetails.FINDFIRST THEN BEGIN
            NAL_CustomerLoginDetails.RESET;
            IF NAL_CustomerLoginDetails.FINDLAST THEN
                EntryNo := NAL_CustomerLoginDetails.USER_ID;

            NAL_CustomerLoginDetails1.INIT;
            NAL_CustomerLoginDetails1.USER_ID := EntryNo + 1;
            NAL_CustomerLoginDetails1.Name := UPPERCASE(v_CustLeads.Name);
            NAL_CustomerLoginDetails1."P.A.N. No." := 'PANAPPLIED';
            NAL_CustomerLoginDetails1.Password := 'bbg@1234';
            NAL_CustomerLoginDetails1."Mobile No." := v_CustLeads."Mobile Phone No.";
            NAL_CustomerLoginDetails1."Creation Date" := TODAY;
            NAL_CustomerLoginDetails1."Creation Time" := TIME;
            NAL_CustomerLoginDetails1."Date of Birth" := v_CustLeads.DOB;
            NAL_CustomerLoginDetails1.Address := v_CustLeads.Address;
            NAL_CustomerLoginDetails1."Address 2" := v_CustLeads."Address 2";
            NAL_CustomerLoginDetails1."E-Mail" := v_CustLeads."E-Mail";
            IF v_CustLeads.Gender = v_CustLeads.Gender::Male THEN
                NAL_CustomerLoginDetails1.Sex := NAL_CustomerLoginDetails1.Sex::Male;
            IF v_CustLeads.Gender = v_CustLeads.Gender::Female THEN
                NAL_CustomerLoginDetails1.Sex := NAL_CustomerLoginDetails1.Sex::Female;
            NAL_CustomerLoginDetails1.City := v_CustLeads.City;
            NAL_CustomerLoginDetails1."is Verification Required" := TRUE;
            NAL_CustomerLoginDetails1.INSERT;

            CLEAR(CreateCustomerSendSMS);
            IF NAL_CustomerLoginDetails1.USER_ID <> 0 THEN BEGIN
                NAL_CustomerLoginDetails1."Customer No." := CreateCustomerSendSMS.InsertCustomer(NAL_CustomerLoginDetails1.USER_ID);
                NAL_CustomerLoginDetails1.MODIFY;

                v_CustLeads."Lead Associate / Customer Id" := NAL_CustomerLoginDetails1."Customer No.";
                v_CustLeads."Lead Associate / Customer Name" := NAL_CustomerLoginDetails1.Name;
                //CustomersLead_2.MODIFY;
                //END;
            END;

        END;
    end;
}

