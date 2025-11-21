table 50063 "Project wise Gold Proj Setup"
{
    DataPerCompany = false;
    DrillDownPageID = "Fixed Deposit Details";
    LookupPageID = "Fixed Deposit Details";

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            TableRelation = "Responsibility Center 1";
        }
        field(2; "From Extent"; Decimal)
        {
        }
        field(3; "To Extent"; Decimal)
        {
        }
        field(4; "Gold Eligibility (gm)"; Decimal)
        {
        }
        field(5; Days; DateFormula)
        {
        }
    }

    keys
    {
        key(Key1; "Project Code", "From Extent", "To Extent")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

