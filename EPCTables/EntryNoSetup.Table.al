table 97817 "Entry No. Setup"
{

    fields
    {
        field(1; TableNo; Integer)
        {
            TableRelation = AllObj."Object ID" WHERE("Object Type" = FILTER(Table));
        }
        field(2; "Entry No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; TableNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

