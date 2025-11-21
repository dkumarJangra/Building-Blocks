table 60721 "Customer Login Details"
{
    Caption = 'Customer Login Details';
    DataCaptionFields = "Customer No.", Name;
    DrillDownPageID = "Customer List";
    LookupPageID = "Customer List";
    Permissions = TableData "Cust. Ledger Entry" = r,
                  TableData Job = r,
                  TableData "VAT Registration Log" = rd,
                  TableData "Service Header" = r,
                  TableData "Service Item" = rm,
                  TableData "Service Contract Header" = rm,
                  TableData "Sales Price" = rd,
                  TableData "Sales Line Discount" = rd;

    fields
    {
        field(1; USER_ID; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
            NotBlank = true;
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnValidate()
            var
                v_PostCode: Record "Post Code";
            begin
            end;
        }
        field(92; County; Text[30])
        {
            Caption = 'County';
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(13722; "State Code"; Code[10])
        {
            Caption = 'State Code';
            TableRelation = State;
        }
        field(16500; "P.A.N. No."; Code[20])
        {
            Caption = 'P.A.N. Reference No.';
        }
        field(50005; "Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 190608';
        }
        field(50006; Occupation; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00';
        }
        field(50102; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(50103; Password; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90025; "Address 3"; Text[80])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB for soul space';
        }
        field(90026; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90027; Age; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(90028; Sex; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Male,Female;
        }
        field(90029; "Father's/Husband's Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90030; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '03/10/12';
            Editable = false;
        }
        field(90031; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90033; "NAV-Customer Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(90034; "NAV-Customer Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90035; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = 'Under Process,Sent for Approval,Approved,Reject';
            OptionMembers = "Under Process","Sent for Approval",Approved,Reject;
        }
        field(90036; "Customer Creation Error"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(90037; "Profile Image Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(90038; "PAN Card Image Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(90039; "Aadhar Card Image Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(90040; "Aadhar Card No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90041; "Alternate Contact No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90042; "Anniversary Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90043; "is Verification Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(60040; "District Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'District Code';
            DataClassification = ToBeClassified;
            TableRelation = "District Details".Code where("State Code" = field("State Code"));
            Editable = False;
        }
        field(60041; "Mandal Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Mandal Code';
            DataClassification = ToBeClassified;
            TableRelation = "Mandal Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"));
            Editable = False;
        }
        field(60042; "Village Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Village Code';
            DataClassification = ToBeClassified;
            TableRelation = "Village Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"), "Mandal Code" = field("Mandal Code"));
            Editable = False;
        }
    }

    keys
    {
        key(Key1; USER_ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; USER_ID, Name, City, "Post Code", "Phone No.")
        {
        }
        fieldgroup(Brick; USER_ID, Name)
        {
        }
    }

    trigger OnDelete()
    var
        CampaignTargetGr: Record "Campaign Target Group";
        ContactBusRel: Record "Contact Business Relation";
        Job: Record Job;
        //DOPaymentCreditCard: Record 827;
        //SocialListeningSearchTopic: Record 871;
        StdCustSalesCode: Record "Standard Customer Sales Code";
        CustomReportSelection: Record "Custom Report Selection";
        CampaignTargetGrMgmt: Codeunit "Campaign Target Group Mgt";
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
    begin
    end;

    trigger OnModify()
    var
        Company: Record Company;
        V_Customer: Record Customer;
    begin
    end;

    var
        PostCode: Record "Post Code";
        State: Record State;// 13762;
        RecRef: RecordRef;
        StartNo: Text[10];
        VarInteger: Integer;
        Cust: Record Customer;
        Memberof: Record "Access Control";
        "--------------------": Integer;
        pos: Integer;
        result: Text;
        IsNumeric: Boolean;
}

