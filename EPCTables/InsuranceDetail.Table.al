table 97779 "Insurance Detail"
{
    // ALLEPG RAHEE1.00 240212 : Created new table


    fields
    {
        field(1; "Insurance No."; Code[20])
        {
            TableRelation = Insurance;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Accident Date"; Date)
        {
        }
        field(4; "Claim No."; Integer)
        {
        }
        field(5; "Amount Claimed"; Decimal)
        {
        }
        field(6; "Amount Received"; Decimal)
        {
        }
        field(7; "Excess Limit"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Insurance No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

