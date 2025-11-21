table 50074 "Target Vs Achivement Details"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Collection Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Tg. Vs Ach. Summary Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Team Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Current Month Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
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

