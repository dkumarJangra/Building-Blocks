table 50078 "vendor rank check"
{

    fields
    {
        field(1; "ven code"; Code[20])
        {
        }
        field(2; "rank code"; Code[10])
        {
        }
        field(3; "line No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "ven code", "line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

