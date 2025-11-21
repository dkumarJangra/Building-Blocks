table 50064 "Report Log Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Report Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Report ID"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Report Run Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Report Run Start Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Report Run End Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Report Run End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "USER ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "USER Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Responsibility Center"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Responsibility Center Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Report Filters"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Report Filters 2"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

