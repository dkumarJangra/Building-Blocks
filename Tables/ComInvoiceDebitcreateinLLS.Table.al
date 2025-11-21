table 50034 "ComInvoice/Debit create in LLS"
{

    fields
    {
        field(1; "Associate Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(2; "Company Code"; Text[30])
        {
            TableRelation = Company;
        }
        field(3; Month; Integer)
        {
        }
        field(4; Year; Integer)
        {
        }
        field(5; "Commission Posting Date"; Date)
        {
        }
        field(6; "Commission Amount_1"; Decimal)
        {
        }
        field(7; "Line No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Associate Code", "Company Code", "Commission Posting Date", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

