table 60665 "Food Team Master"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Food Team ID"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Food Team Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Food Team ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

