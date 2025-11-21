table 50033 Reveslentry_2
{

    fields
    {
        field(1; "App code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Assocaite Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Base Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "App code", "Assocaite Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

