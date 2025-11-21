table 97849 "Incentive Line"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Incentive Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
        field(3; "Extent Eligibilty"; Decimal)
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
                IncentiveHeader.RESET;
                IncentiveHeader.SETRANGE("Incentive Code", "Incentive Code");
                IF IncentiveHeader.FINDFIRST THEN
                    IF IncentiveHeader."No. of Units" THEN
                        ERROR(TEXT50001, IncentiveHeader.FIELDCAPTION("No. of Units"));
                "Plot Eligibility" := 0;
            end;
        }
        field(4; "Plot Eligibility"; Decimal)
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
                IncentiveHeader.RESET;
                IncentiveHeader.SETRANGE("Incentive Code", "Incentive Code");
                IF IncentiveHeader.FINDFIRST THEN
                    IF NOT IncentiveHeader."No. of Units" THEN
                        ERROR(TEXT50001, IncentiveHeader.FIELDCAPTION("No. of Units"));
                "Extent Eligibilty" := 0;
                UOM := '';
            end;
        }
        field(6; UOM; Code[10])
        {
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
                IncentiveHeader.RESET;
                IncentiveHeader.SETRANGE("Incentive Code", "Incentive Code");
                IF IncentiveHeader.FINDFIRST THEN
                    IF IncentiveHeader."No. of Units" THEN
                        ERROR(TEXT50000, IncentiveHeader.FIELDCAPTION("No. of Units"));
                "Plot Eligibility" := 0;
            end;
        }
        field(7; "Min. Required Collection"; Decimal)
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
        field(8; "Incentive Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
        field(9; "Project Code"; Code[20])
        {
            Description = 'ALLEPG 061112';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
                GeneralLedgerSetup.GET;
                IF "Project Code" <> '' THEN
                    IF DimValue.GET(GeneralLedgerSetup."Global Dimension 1 Code", "Project Code") THEN
                        "Project Name" := DimValue.Name
                    ELSE
                        "Project Name" := '';
            end;
        }
        field(10; "No. of Unit"; Boolean)
        {
        }
        field(11; "Project Name"; Text[60])
        {
            Editable = false;
        }
        field(12; "Incentive Type"; Option)
        {
            OptionCaption = ' ,Individual,Team';
            OptionMembers = " ",Individual,Team;

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
        field(13; "Effective Date"; Date)
        {
            Editable = false;
        }
        field(14; "End Date"; Date)
        {
            Description = 'BBG1.4 231213';
            Editable = false;
        }
        field(15; "Not Applicable Projct for Team"; Boolean)
        {
            Description = 'BBG1.4 271213';

            trigger OnValidate()
            begin
                TESTFIELD("Incentive Type", "Incentive Type"::Individual);
            end;
        }
        field(16; "Incentive Generated"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Incentive Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Incentive Code", "Min. Required Collection")
        {
        }
        key(Key3; "Incentive Code", "Extent Eligibilty")
        {
        }
        key(Key4; "Effective Date", "Project Code", "Incentive Type")
        {
        }
        key(Key5; "Effective Date", "End Date", "Incentive Type", "No. of Unit")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF IncentiveHeader.GET("Incentive Code") THEN
            IF (IncentiveHeader.Status = IncentiveHeader.Status::"In-Active") OR
              (IncentiveHeader.Status = IncentiveHeader.Status::Released) THEN
                ERROR(TEXT50003);
    end;

    trigger OnInsert()
    begin
        CheckDuplicate(Rec);
        IF IncentiveHeader.GET("Incentive Code") THEN
            "End Date" := IncentiveHeader."End Date";
    end;

    trigger OnModify()
    begin
        IF IncentiveHeader.GET("Incentive Code") THEN
            IF (IncentiveHeader.Status = IncentiveHeader.Status::"In-Active") OR
              (IncentiveHeader.Status = IncentiveHeader.Status::Released) THEN
                ERROR(TEXT50004);
    end;

    var
        IncentiveHeader: Record "Incentive Header";
        TEXT50000: Label '%1 should be set true.';
        TEXT50001: Label '%1 should be set false.';
        TempIncentiveLine: Record "Incentive Line";
        TEXT50002: Label 'This Incentive line already exist.';
        TEXT50003: Label 'Released or In-active Incentive lines cannot be deleted.';
        DimValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        TEXT50004: Label 'Released or In-active Incentive lines cannot be modify.';


    procedure CheckDuplicate(var NewIncentive: Record "Incentive Line")
    begin
        /*
        TempIncentiveLine.RESET;
        TempIncentiveLine.SETRANGE("Incentive Code",NewIncentive."Incentive Code");
        TempIncentiveLine.SETRANGE("Project Code",NewIncentive."Project Code");
        TempIncentiveLine.SETRANGE("Extent Eligibilty",NewIncentive."Extent Eligibilty");
        TempIncentiveLine.SETRANGE("Plot Eligibility",NewIncentive."Plot Eligibility");
        TempIncentiveLine.SETRANGE(UOM,NewIncentive.UOM);
        TempIncentiveLine.SETRANGE("Min. Required Collection",NewIncentive."Min. Required Collection");
        TempIncentiveLine.SETRANGE("Incentive Amount",NewIncentive."Incentive Amount");
        IF TempIncentiveLine.FINDSET THEN
          ERROR(TEXT50002);
         */

    end;
}

