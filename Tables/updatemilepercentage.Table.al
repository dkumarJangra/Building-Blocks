table 50011 "update mile percentage"
{

    fields
    {
        field(1; "peoj code"; Code[20])
        {
        }
        field(2; first; Decimal)
        {
        }
        field(3; second; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "peoj code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

