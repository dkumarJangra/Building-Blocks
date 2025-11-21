table 60735 "Cluster State Master"
{
    DrillDownPageID = "Cluster State Master";
    LookupPageID = "Cluster State Master";

    fields
    {
        field(1; "State Id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "State Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "State Id")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

