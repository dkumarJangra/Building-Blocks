table 60709 "Direct Bonanza App. Details"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Ref. Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Extent; Text[30])
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

