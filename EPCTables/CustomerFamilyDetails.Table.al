table 60695 "Customer Family Details"
{

    fields
    {
        field(1; "Family Member ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Customer Lead ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Name; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(8; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Male,Female,Other';
            OptionMembers = " ",Male,Female,Other;
        }
        field(9; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(10; County; Text[30])
        {
            Caption = 'County';
            DataClassification = ToBeClassified;
        }
        field(11; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(12; "Image Path"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(36; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(37; Relation; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." WHERE("BBG Vendor Category" = CONST("IBA(Associates)"));
        }
        field(39; "State code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(40; Age; Text[5])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "View Images"; Text[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Family Member ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CustomersLead_2.RESET;
        IF CustomersLead_2.GET("Customer Lead ID") THEN
            CustomersLead_2.TESTFIELD(Status, CustomersLead_2.Status::Open);
    end;

    trigger OnInsert()
    begin
        RMSetup.GET;

        IF "Family Member ID" = '' THEN BEGIN
            RMSetup.TESTFIELD("Family Member No. Series");
            "Family Member ID" := NoSeriesMgt.GetNextNo(RMSetup."Family Member No. Series", TODAY, TRUE);
            "View Images" := 'Image';
        END;
    end;

    var
        PostCode: Record "Post Code";
        RMSetup: Record "Marketing Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomersLead_2: Record "Customers Lead_2";
}

