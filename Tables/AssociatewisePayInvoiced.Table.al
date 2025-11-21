table 50022 "Associate wise Pay_Invoiced"
{

    fields
    {
        field(1; "Associate Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(2; "Company Name"; Text[30])
        {
            TableRelation = Company;
        }
        field(3; "Gross Paid Amount"; Decimal)
        {
        }
        field(4; "Gross Invoiced Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Associate Code", "Company Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

