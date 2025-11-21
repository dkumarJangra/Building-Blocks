table 97818 Target
{
    DrillDownPageID = "Fixed Deposit Details";
    LookupPageID = "Fixed Deposit Details";

    fields
    {
        field(1; "Rank Code"; Integer)
        {
            TableRelation = Rank;
        }
        field(2; "WEF Date"; Date)
        {
        }
        field(3; "Target (Lumpsum)"; Decimal)
        {
        }
        field(4; "Target (Reccurring)"; Decimal)
        {
        }
        field(5; Recruitment; Integer)
        {
        }
        field(6; Type; Option)
        {
            OptionMembers = Regular,Upgradation;
        }
        field(7; "Upgradation Target Amt."; Decimal)
        {
        }
        field(8; "Upgradation Target Recruitment"; Integer)
        {
        }
        field(9; "Valid for (Months)"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Rank Code", "WEF Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

