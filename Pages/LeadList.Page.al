page 60696 "Lead List"
{
    Caption = 'Lead List';
    CardPageID = "Lead Card";
    DataCaptionFields = "Company No.";
    Editable = false;
    PageType = List;
    SourceTable = "Customers Lead_2";
    SourceTableView = SORTING("Company Name", "Company No.", Type, Name)
                      WHERE("Request From" = CONST(Vendor));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
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
                field(Name; Rec.Name)
                {
                }
                field("Name 2"; Rec."Name 2")
                {
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    Visible = false;
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field(City; Rec.City)
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Job Title"; Rec."Job Title")
                {

                }
                field(Comment; Rec.Comment)
                {

                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Caption = 'Lead Creation Date';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field(Initials; Rec.Initials)
                {

                }
                field("Extension No."; Rec."Extension No.")
                {

                }
                field("Phone No."; Rec."Phone No.")
                {

                }

                field("Parental Consent Received"; Rec."Parental Consent Received")
                {
                }
                field("CRM ID"; Rec."CRM ID")
                {
                    Caption = 'CRM Team ID';
                }
                field("CRM Name"; Rec."CRM Name")
                {
                    Caption = 'CRM Team Name';
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field("Parent Name"; Rec."Parent Name")
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
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Reporting Office ID"; Rec."Reporting Office ID")
                {
                }
                field("Reporting Office Name"; Rec."Reporting Office Name")
                {
                }
                field("Cluster Code"; Rec."Cluster Code")
                {
                }
                field("Cluster Description"; Rec."Cluster Description")
                {
                }
                field(DOB; Rec.DOB)
                {

                }
                field("No. of Business Relations"; Rec."No. of Business Relations")
                {

                }
                field("Land Mark"; Rec."Land Mark")
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
                field("Request From"; Rec."Request From")
                {

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

                }
                field("PAN URL"; Rec."PAN URL")
                {

                }
                field(ProfileURL; Rec.ProfileURL)
                {

                }
                field(Remarks; Rec.Remarks)
                {

                }
                field("Re-Open Comment"; Rec."Re-Open Comment")
                {

                }
                field("Parent ID"; Rec."Parent ID")
                {

                }
                field("Region Code"; Rec."Region Code")
                {

                }

                field(Rank_Code; Rec.Rank_Code)
                {

                }
                field(Designation; Rec.Designation)
                {

                }
                field("Customer Campiagn Entry No."; Rec."Customer Campiagn Entry No.")
                {

                }
                field("Lead Associate / Customer Id"; Rec."Lead Associate / Customer Id")
                {

                }
                field("Lead Associate / Customer Name"; Rec."Lead Associate / Customer Name")
                {

                }
                field("Communication Address"; Rec."Communication Address")
                {

                }
                field("Communication Address 2"; Rec."Communication Address 2")
                {

                }
                field("Communication City"; Rec."Communication City")
                {

                }
                field("Communication Post Code"; Rec."Communication Post Code")
                {

                }
                field("Communication State Code"; Rec."Communication State Code")
                {

                }
                field("Region/Districts Code"; Rec."Region/Districts Code")
                {

                }


            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Associate Data upload")
            {
                Caption = 'Associate Data upload';
                Image = Process;
                //Visible = false;
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
                        ProfileManagement: Codeunit ProfileManagement;
                    begin
                        //ProfileManagement.ShowContactQuestionnaireCard(Rec,'',0);
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
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    Visible = false;
                }
                action("Create Assoicate and Lead")
                {
                    Caption = 'Create Assoicate and Lead';
                    Image = Process;
                    RunObject = XMlport 50101;

                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        EnableFields;
        StyleIsStrong := Rec.Type = Rec.Type::Company;

        NameIndent := 0;
        IF Rec.Type <> Rec.Type::Company THEN BEGIN
            Cont.SETCURRENTKEY("Company Name", "Company No.", Type, Name);
            IF (Rec."Company No." <> '') AND (NOT Rec.HASFILTER) AND (NOT Rec.MARKEDONLY) AND (Rec.CURRENTKEY = Cont.CURRENTKEY) THEN
                NameIndent := 1
        END;

        IF CRMIntegrationEnabled THEN
            CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RECORDID);
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    var
        Cont: Record Contact;

        StyleIsStrong: Boolean;

        NameIndent: Integer;
        CompanyGroupEnabled: Boolean;
        PersonGroupEnabled: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;

    local procedure EnableFields()
    begin
        CompanyGroupEnabled := Rec.Type = Rec.Type::Company;
        PersonGroupEnabled := Rec.Type = Rec.Type::Person;
    end;
}

