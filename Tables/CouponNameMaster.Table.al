table 60662 "Coupon Name Master"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Coupon Name ID"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Coupon Description"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Coupon Name ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

