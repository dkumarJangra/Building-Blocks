table 60671 "Sub Team Master"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Sub Team Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Sub Team Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

