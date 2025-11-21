table 50055 "Applocation Refund data"
{

    fields
    {
        field(1; "App no"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line no."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Posted Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "App no", "Line no.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

