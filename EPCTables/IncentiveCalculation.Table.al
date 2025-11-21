table 97784 "Incentive Calculation"
{
    DrillDownPageID = "Incentive Calculation List";
    LookupPageID = "Incentive Calculation List";

    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = 'Incentive,MFA';
            OptionMembers = Incentive,MFA;
        }
        field(2; "Associate Code"; Code[20])
        {
            Caption = 'Associate Code';
            TableRelation = Vendor;
        }
        field(3; "From Date"; Date)
        {
        }
        field(4; "To Date"; Date)
        {
        }
        field(5; "Rank Code"; Integer)
        {
            TableRelation = Rank;
        }
        field(6; "Target Business Amount"; Decimal)
        {
        }
        field(7; "New Business Amount"; Decimal)
        {
        }
        field(8; "Recurring Business Amount"; Decimal)
        {
        }
        field(9; "Business Amount"; Decimal)
        {
        }
        field(10; "Achievement (%)"; Decimal)
        {
        }
        field(11; "Min. Achievement (%)"; Decimal)
        {
        }
        field(12; "Incentive Amount"; Decimal)
        {
        }
        field(13; "Additional Incentive Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; Type, "Associate Code", "From Date")
        {
            Clustered = true;
        }
        key(Key2; "Rank Code", "From Date", "To Date")
        {
        }
    }

    fieldgroups
    {
    }


    procedure TotalIncentiveAmount(): Decimal
    begin
        EXIT("Incentive Amount" + "Additional Incentive Amount");
    end;
}

