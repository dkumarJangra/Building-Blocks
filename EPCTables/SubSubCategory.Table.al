table 97735 "Sub Sub Category"
{
    LookupPageID = "Sub Sub Category List";

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

