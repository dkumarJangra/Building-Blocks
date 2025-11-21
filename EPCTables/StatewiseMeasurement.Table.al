table 60724 "State wise Measurement"
{

    fields
    {
        field(1; "State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Acres; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Guntas; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Cents; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "State Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

