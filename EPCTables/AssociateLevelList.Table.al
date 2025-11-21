table 60691 "Associate Level List"
{

    fields
    {
        field(1; "Associate Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(2; "Second Level Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(3; "Third Level Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1; "Associate Id", "Second Level Associate ID", "Third Level Associate ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

