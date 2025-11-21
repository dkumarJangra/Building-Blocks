page 60708 "Customer Lead Details List"
{
    Caption = 'Cusstomer Contact List';
    CardPageID = "Customer Lead Details Card";
    DataCaptionFields = "Company No.";
    Editable = false;
    PageType = List;
    SourceTable = "Customers Lead_2";
    SourceTableView = SORTING("Company Name", "Company No.", Type, Name)
                      WHERE("Request From" = FILTER(Customer));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
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
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Caption = 'Lead Creation Date';
                }
                field("E-Mail"; Rec."E-Mail")
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
            }
        }
    }

    actions
    {
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

