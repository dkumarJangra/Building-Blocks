table 60663 "Coupon Type Master"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Coupon Type ID"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Coupon Type Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Coupon Type ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

