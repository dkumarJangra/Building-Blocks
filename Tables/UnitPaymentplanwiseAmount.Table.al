table 50038 "Unit Payment plan wise Amount"
{

    fields
    {
        field(1; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Unit Payment Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = FILTER(true));
        }
    }

    keys
    {
        key(Key1; "Unit Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

