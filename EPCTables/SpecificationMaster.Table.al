table 97758 "Specification Master"
{
    LookupPageID = "Specification Master";

    fields
    {
        field(10; "Code"; Code[30])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[60])
        {
            Caption = 'Name';
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

