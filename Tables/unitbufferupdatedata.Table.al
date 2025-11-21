table 50009 "unit buffer update data"
{

    fields
    {
        field(1; "application code"; Code[20])
        {
        }
        field(2; amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "application code", amount)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

