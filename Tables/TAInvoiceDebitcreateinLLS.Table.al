table 50035 "TAInvoice/Debit create in LLS"
{

    fields
    {
        field(1; "Associate Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(2; "Company Code"; Text[30])
        {
        }
        field(3; Month; Integer)
        {
        }
        field(4; Year; Integer)
        {
        }
        field(7; "TA Posting Date"; Date)
        {
        }
        field(8; "TA Amount_1"; Decimal)
        {
        }
        field(9; "Line No."; Integer)
        {
        }
        field(10; "Entry No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Associate Code", "Company Code", "TA Posting Date", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

