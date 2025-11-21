table 60681 "Gamification Team Hierarchy"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Team Top Head"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; DOJ; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Rank Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Rank Code", "Associate Code")
        {
            Clustered = true;
        }
        key(Key2; "Team Top Head", "Associate Code")
        {
        }
    }

    fieldgroups
    {
    }
}

