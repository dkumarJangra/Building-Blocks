table 97738 "ID 1 Group"
{
    DataPerCompany = false;
    DrillDownPageID = "ID 1 Groups";
    LookupPageID = "ID 1 Groups";

    fields
    {
        field(1; "Item Category Code"; Code[10])
        {
            TableRelation = "Item Category";
        }
        field(2; "Product Group Code"; Code[10])
        {
            TableRelation = "BBG Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(3; "ID 1 Group Code"; Code[10])
        {
        }
        field(4; Description; Text[30])
        {
            Description = 'dds-length changed from 30 to 60';
        }
    }

    keys
    {
        key(Key1; "Item Category Code", "Product Group Code", "ID 1 Group Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

