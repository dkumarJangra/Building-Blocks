table 60696 "Customer Visit Schedule Detail"
{

    fields
    {
        field(1; "Schedule ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Customer Lead ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." WHERE("BBG Vendor Category" = CONST("IBA(Associates)"));
        }
        field(4; "Schedule Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Visit Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Pending,Done';
            OptionMembers = Pending,Done;
        }
        field(6; "Visit Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Home,Office,Site,Talent';
            OptionMembers = " ",Home,Office,Site,Talent;
        }
        field(7; "Visit Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Comments; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Image Path"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Schedule Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Visit Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "View Images"; Text[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "visitAddress"; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Longitude"; Text[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Latitude"; Text[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Schedule ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CustomersLead_2: Record "Customers Lead_2";
    begin
        CustomersLead_2.RESET;
        IF CustomersLead_2.GET("Customer Lead ID") THEN
            CustomersLead_2.TESTFIELD(Status, CustomersLead_2.Status::Open);
    end;

    trigger OnInsert()
    begin
        RMSetup.GET;

        IF "Schedule ID" = '' THEN BEGIN
            RMSetup.TESTFIELD("Family Member No. Series");
            "Schedule ID" := NoSeriesMgt.GetNextNo(RMSetup."Visit Schedule No. Series", TODAY, TRUE);
            "View Images" := 'Image';
        END;
    end;

    var
        PostCode: Record "Post Code";
        RMSetup: Record "Marketing Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

