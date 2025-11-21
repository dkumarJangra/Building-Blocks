table 50042 "Web Log Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Request Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Request Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Response Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Response Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Request Description"; Text[1024])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Response Description"; Text[1024])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Function Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Request Description 2"; Text[1024])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Response Description 2"; Text[1024])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Table ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Login Mail Send Error"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Request Description 3"; Text[1024])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Request Description 4"; Text[1024])
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

