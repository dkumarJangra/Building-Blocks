table 60664 "Food Type Master"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Food Type ID"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Food Type Description"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Food Type ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

