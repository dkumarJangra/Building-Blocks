table 97781 "Reapproved Commission Voucher"
{
    DrillDownPageID = "Reapproved Commission Voucher";
    LookupPageID = "Reapproved Commission Voucher";

    fields
    {
        field(1; "Voucher No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(4; "User ID"; Code[20])
        {
        }
        field(5; "Posting Date"; Date)
        {
        }
        field(6; "Posting Time"; Time)
        {
        }
        field(7; "Expiry Date"; Date)
        {
        }
        field(8; Printed; Boolean)
        {
        }
        field(9; "Print Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Voucher No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

