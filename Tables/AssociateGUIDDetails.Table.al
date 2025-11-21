table 50043 "Associate_GUID Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; Token_ID; Guid)
        {
            DataClassification = ToBeClassified;
        }
        field(2; USER_ID; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Is Active"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Token_ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

