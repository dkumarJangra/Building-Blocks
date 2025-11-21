table 97847 "Sub Department"
{
    DrillDownPageID = "Get Job Planning Line";
    LookupPageID = "Get Job Planning Line";

    fields
    {
        field(1; "Department Dimension"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(2; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Department Dimension"));
        }
        field(3; "Sub Department Code"; Code[20])
        {
        }
        field(4; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Department Dimension", "Department Code", "Sub Department Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

