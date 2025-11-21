table 97868 "Temp Team Plot Allotmt. Detail"
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
        NTB: Record "Temp Team Plot Allotmt. Detail";
        EntryNo: Integer;
}

