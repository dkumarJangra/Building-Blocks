table 60795 "CP Team Master"
{

    fields
    {
        field(1; "Team Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Team Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Team Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

