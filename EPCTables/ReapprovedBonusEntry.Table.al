table 97782 "Reapproved Bonus Entry"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(4; "User ID"; Code[20])
        {
        }
        field(5; "Posting date"; Date)
        {
        }
        field(6; "Posting Time"; Time)
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

