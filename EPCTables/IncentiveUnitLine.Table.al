table 97851 "Incentive Unit Line"
{

    fields
    {
        field(1; "Incentive Unit Code"; Code[20])
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Min. Extent"; Decimal)
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
        field(4; "Max. Extent"; Decimal)
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
        field(5; UOM; Code[10])
        {
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
        field(6; "No. of Units"; Decimal)
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
    }

    keys
    {
        key(Key1; "Incentive Unit Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF IncentiveUnitHdr.GET("Incentive Unit Code") THEN
            IF (IncentiveUnitHdr.Status = IncentiveUnitHdr.Status::"In-Active") OR
              (IncentiveUnitHdr.Status = IncentiveUnitHdr.Status::Released) THEN
                ERROR(TEXT50001);
    end;

    trigger OnInsert()
    begin
        CheckDuplicate(Rec);
    end;

    var
        TempIncentiveUnitLine: Record "Incentive Unit Line";
        TEXT50000: Label 'This incentive line already exist.';
        IncentiveUnitHdr: Record "Incentive Unit Header";
        TEXT50001: Label 'Released or In-active Status cannot be deleted.';


    procedure CheckDuplicate(var NewIncentive: Record "Incentive Unit Line")
    begin
        TempIncentiveUnitLine.RESET;
        TempIncentiveUnitLine.SETRANGE("Incentive Unit Code", NewIncentive."Incentive Unit Code");
        TempIncentiveUnitLine.SETRANGE("Max. Extent", NewIncentive."Max. Extent");
        TempIncentiveUnitLine.SETRANGE("Min. Extent", NewIncentive."Min. Extent");
        TempIncentiveUnitLine.SETRANGE(UOM, NewIncentive.UOM);
        TempIncentiveUnitLine.SETRANGE("No. of Units", NewIncentive."No. of Units");
        IF TempIncentiveUnitLine.FINDSET THEN
            ERROR(TEXT50000);
    end;
}

