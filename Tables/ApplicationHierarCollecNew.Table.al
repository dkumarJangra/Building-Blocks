table 50006 "Application Hierar. Collec New"
{

    fields
    {
        field(1; "Application Code"; Code[20])
        {
            TableRelation = "Confirmed Order";
        }
        field(2; "Introducer Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(3; "Associate Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(4; "Posting Date"; Date)
        {
        }
        field(5; "Line No."; Integer)
        {
        }
        field(6; "Rank Change"; Boolean)
        {
        }
        field(7; "Rank Change Date"; Date)
        {
        }
        field(8; "Parent Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(9; "Project Code"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Application Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Introducer Code", "Associate Code")
        {
        }
        key(Key3; "Application Code", "Introducer Code")
        {
        }
        key(Key4; "Application Code", "Associate Code")
        {
        }
        key(Key5; "Associate Code", "Introducer Code", "Application Code")
        {
        }
        key(Key6; "Parent Code", "Posting Date", "Project Code")
        {
        }
        key(Key7; "Introducer Code", "Associate Code", "Posting Date", "Project Code")
        {
        }
        key(Key8; "Introducer Code", "Parent Code", "Posting Date", "Project Code")
        {
        }
    }

    fieldgroups
    {
    }
}

