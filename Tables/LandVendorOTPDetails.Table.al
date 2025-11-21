table 60792 "Land Vendor OTP Details"
{

    fields
    {
        field(1; "Land Vendor Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; OTP; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Is used"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Land Vendor Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

