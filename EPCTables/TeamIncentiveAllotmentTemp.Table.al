table 97870 "Team Incentive Allotment Temp"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Associate Code"; Code[20])
        {
        }
        field(3; "Parent Code"; Code[20])
        {
        }
        field(4; "Act Code"; Code[20])
        {
        }
        field(5; Checked; Boolean)
        {
        }
        field(6; Checked2; Boolean)
        {
        }
        field(7; Extent; Decimal)
        {
        }
        field(8; Collection; Decimal)
        {
        }
        field(9; Allotment; Decimal)
        {
        }
        field(10; ChildChecked; Boolean)
        {
        }
        field(11; "Order Amount"; Decimal)
        {
        }
        field(12; "Due Amount"; Decimal)
        {
        }
        field(13; "Min. Allotment"; Decimal)
        {
        }
        field(15; "Self Extent"; Decimal)
        {
        }
        field(16; "Self Collection"; Decimal)
        {
        }
        field(17; "Self Allotment"; Decimal)
        {
        }
        field(18; "Self Order Amount"; Decimal)
        {
        }
        field(19; "Self Due Amount"; Decimal)
        {
        }
        field(20; "Self Min. Allotment Amount"; Decimal)
        {
        }
        field(21; "Refund Amount"; Decimal)
        {
        }
        field(22; "Self Refund Amount"; Decimal)
        {
        }
        field(23; "Team Incentive Scheme"; Code[20])
        {
        }
        field(24; "Team Calculation Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Number Wise,Extent Wise';
            OptionMembers = "Number Wise","Extent Wise";
        }
        field(25; "Plot Eligible Amount"; Decimal)
        {
        }
        field(26; "Payable Incentive Amount"; Decimal)
        {
        }
        field(27; "Extent Eligible Amount"; Decimal)
        {
        }
        field(28; "TIA Checked"; Boolean)
        {
        }
        field(29; Month; Integer)
        {
        }
        field(30; Year; Integer)
        {
        }
        field(31; "Self BSP1_BSP3 Amount"; Decimal)
        {
        }
        field(32; "Team BSP1_BSP3 Amount"; Decimal)
        {
        }
        field(33; "Team Incentive Calc. Date"; Date)
        {
        }
        field(34; "Team Dim"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Associate Code")
        {
        }
        key(Key3; "Team Incentive Scheme")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF NTB.FINDLAST THEN
            "Entry No." := NTB."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    var
        NTB: Record "Team Incentive Allotment Temp";
        EntryNo: Integer;
}

