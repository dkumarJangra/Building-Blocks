table 60789 "Land Sales Document Temp"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Sales Invoice Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Ref. LLP Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        field(7; "Sales Invoice Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Sales Inv. Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Sales Inv. Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "IC Partner Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "External Doc. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Ref. LLP Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Ref. LLP Item Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Application No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

