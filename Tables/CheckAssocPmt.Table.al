table 50031 "Check Assoc Pmt"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Company Code"; Text[30])
        {
        }
        field(3; "Associate MSC comp"; Code[10])
        {
        }
        field(4; "Associate Code LLP"; Code[10])
        {
        }
        field(5; CommEntry; Boolean)
        {
        }
        field(6; "Travel Pmt"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Company Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

