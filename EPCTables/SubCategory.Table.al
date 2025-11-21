table 97730 "Sub Category"
{
    LookupPageID = "Sub Category List";

    fields
    {
        field(1; "Code"; Code[50])
        {
        }
        field(2; Name; Text[100])
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

