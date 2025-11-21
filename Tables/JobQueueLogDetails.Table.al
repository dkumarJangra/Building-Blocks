table 60682 "Job Queue Log Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Process Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Process Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Process Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Process Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Error Message"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Company Name"; Text[30])
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

