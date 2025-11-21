table 50061 "Commission amount update"
{

    fields
    {
        field(1; "Associate id"; Code[20])
        {
        }
        field(2; Amount; Decimal)
        {
        }
        field(3; "Direct paid commission"; Decimal)
        {
            FieldClass = Normal;
        }
        field(4; "Remainin amt exist"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Associate id")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

