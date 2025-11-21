table 97820 "Incentive Setup"
{

    fields
    {
        field(1; "Rank Code"; Decimal)
        {
            TableRelation = Rank;
        }
        field(2; "WEF Date"; Date)
        {
        }
        field(3; "Business Amount"; Decimal)
        {
        }
        field(4; "Incentive Amount"; Decimal)
        {
        }
        field(5; Active; Boolean)
        {
        }
        field(6; "Min. Achievement %"; Decimal)
        {
        }
        field(7; "Additional Business Per"; Decimal)
        {
        }
        field(8; "Additional Incentive Amount"; Decimal)
        {
        }
        field(9; Type; Option)
        {
            OptionCaption = 'Incentive,MFA';
            OptionMembers = Incentive,MFA;
        }
        field(10; "End Date"; Date)
        {
        }
        field(11; "Min No of Plot Booking"; Decimal)
        {
        }
        field(12; "New Bussiness"; Boolean)
        {
        }
        field(13; "Project Code"; Code[20])
        {
            TableRelation = "Dimension Value" WHERE("Global Dimension No." = FILTER(1));
        }
    }

    keys
    {
        key(Key1; Type, "Rank Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

