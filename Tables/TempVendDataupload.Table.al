table 50030 "Temp Vend Data upload"
{

    fields
    {
        field(2; "BBG Vendor No."; Code[20])
        {
        }
        field(3; "Comp Vendor No."; Code[20])
        {
            TableRelation = Vendor."No.";
        }
        field(4; "Company Name"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "BBG Vendor No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

