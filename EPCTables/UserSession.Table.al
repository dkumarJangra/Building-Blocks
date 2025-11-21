table 97720 "User Session"
{

    fields
    {
        field(1; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User;
        }
        field(2; "Connection ID"; Integer)
        {
            Caption = 'Connection ID';
        }
        field(3; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
        }
    }

    keys
    {
        key(Key1; "User ID", "Connection ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

