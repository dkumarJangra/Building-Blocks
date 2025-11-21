table 50070 "Gle Data update"
{

    fields
    {
        field(1; "entry no"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "gl account"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "entry no")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

