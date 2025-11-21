table 60672 "Leader Master"
{

    fields
    {
        field(1; "Leader Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Allow Special Request"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Leader Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

