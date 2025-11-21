table 97727 Category
{
    LookupPageID = "Category List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Name; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

