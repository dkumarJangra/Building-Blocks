table 60708 "Jagriti Customer Details Reqst"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Customer Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Request 5"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Request 6"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Request 7"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Request 8"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Customer Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

