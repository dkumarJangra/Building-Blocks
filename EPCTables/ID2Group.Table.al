table 97747 "ID 2 Group"
{
    LookupPageID = "ID 2 Groups";

    fields
    {
        field(1; "Item Category Code"; Code[10])
        {
            TableRelation = "Item Category";
        }
        field(2; "Product Group Code"; Code[10])
        {
            //TableRelation = "Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(3; "ID 1 Group Code"; Code[10])
        {
            TableRelation = "ID 1 Group"."ID 1 Group Code" WHERE("Item Category Code" = FIELD("Item Category Code"),
                                                                  "Product Group Code" = FIELD("Product Group Code"));
        }
        field(4; "ID 2 Group Code"; Code[10])
        {
        }
        field(5; Description; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Item Category Code", "Product Group Code", "ID 1 Group Code", "ID 2 Group Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

