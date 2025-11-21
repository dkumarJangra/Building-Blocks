table 97859 "Error Entry"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Application No."; Code[20])
        {
        }
        field(3; "Error Field"; Code[20])
        {
        }
        field(4; "Error Value"; Text[60])
        {
        }
        field(5; "Error Text"; Text[250])
        {
        }
        field(6; DateTime; DateTime)
        {
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

