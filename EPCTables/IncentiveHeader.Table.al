table 97848 "Incentive Header"
{
    DataPerCompany = false;
    LookupPageID = "Incentive List";

    fields
    {
        field(1; "Incentive Code"; Code[20])
        {
        }
        field(2; "W.e.f. Date"; Date)
        {

            trigger OnValidate()
            begin
                //CheckDuplicate(Rec);

                IncentiveLine.RESET;
                IncentiveLine.SETRANGE("Incentive Code", "Incentive Code");
                IF IncentiveLine.FINDSET THEN
                    REPEAT
                        IncentiveLine."Effective Date" := "W.e.f. Date";
                        IncentiveLine.MODIFY;
                    UNTIL (IncentiveLine.NEXT = 0);
            end;
        }
        field(4; Status; Option)
        {
            OptionCaption = 'Open,In-Active,Released';
            OptionMembers = Open,"In-Active",Released;

            trigger OnValidate()
            begin
                //CheckDuplicate(Rec);
                TESTFIELD("W.e.f. Date");
                /*
                IncentiveHdr.RESET;
                IncentiveHdr.SETRANGE("W.e.f. Date","W.e.f. Date");
                  IncentiveHdr.SETRANGE("Responsibility Center","Responsibility Center");
                  IncentiveHdr.SETRANGE("Incentive Type","Incentive Type");
                  IF IncentiveHdr.FINDFIRST THEN
                    ERROR(STRSUBSTNO(TEXT50000,Status));
                */

            end;
        }
        field(5; "Incentive Type"; Option)
        {
            OptionCaption = ' ,Individual,Team';
            OptionMembers = " ",Individual,Team;

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);

                IncentiveLine.RESET;
                IncentiveLine.SETRANGE("Incentive Code", "Incentive Code");
                IF IncentiveLine.FINDSET THEN
                    REPEAT
                        IncentiveLine."Incentive Type" := "Incentive Type";
                        IncentiveLine.MODIFY;
                    UNTIL (IncentiveLine.NEXT = 0);
            end;
        }
        field(6; "No. of Units"; Boolean)
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
                IF NOT "No. of Units" THEN BEGIN
                    IncentiveLine.RESET;
                    IncentiveLine.SETRANGE("Incentive Code", "Incentive Code");
                    IF IncentiveLine.FINDSET THEN
                        REPEAT
                            IF IncentiveLine."Plot Eligibility" <> 0 THEN
                                ERROR(TEXT50003);
                        UNTIL (IncentiveLine.NEXT = 0);
                END ELSE BEGIN
                    IncentiveLine.RESET;
                    IncentiveLine.SETRANGE("Incentive Code", "Incentive Code");
                    IF IncentiveLine.FINDSET THEN
                        REPEAT
                            IF (IncentiveLine.UOM <> '') OR (IncentiveLine."Extent Eligibilty" <> 0.0) THEN
                                ERROR(TEXT50004);
                        UNTIL (IncentiveLine.NEXT = 0);
                END;
            end;
        }
        field(8; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(9; "End Date"; Date)
        {
            Description = 'BBG1.4 231213';

            trigger OnValidate()
            begin
                IncentiveLine.RESET;
                IncentiveLine.SETRANGE("Incentive Code", "Incentive Code");
                IF IncentiveLine.FINDSET THEN
                    REPEAT
                        IncentiveLine."End Date" := "End Date";
                        IncentiveLine.MODIFY;
                    UNTIL IncentiveLine.NEXT = 0;
            end;
        }
    }

    keys
    {
        key(Key1; "Incentive Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF (Status = Status::"In-Active") OR (Status = Status::Released) THEN
            ERROR(TEXT50002);

        IncentiveLine.RESET;
        IncentiveLine.SETRANGE("Incentive Code", "Incentive Code");
        IF IncentiveLine.FINDSET THEN
            REPEAT
                IncentiveLine.DELETE;
            UNTIL (IncentiveLine.NEXT = 0);
    end;

    trigger OnInsert()
    begin
        IF "Incentive Code" = '' THEN BEGIN
            UnitSetup.GET;
            UnitSetup.TESTFIELD("Incentive Setup No. Series");
            NoSeriesMgt.InitSeries(UnitSetup."Incentive Setup No. Series", xRec."No. Series", 0D, "Incentive Code", "No. Series");
        END;

        //CheckDuplicate(Rec);
    end;

    var
        IncentiveHdr: Record "Incentive Header";
        IncentiveLine: Record "Incentive Line";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TEXT50000: Label 'Incentive with %1 status already exist. ';
        TEXT50001: Label 'Details of Released Incentive cannot be modified.';
        TEXT50002: Label 'You cannot delete from in-active or release Incentive.  ';
        TEXT50003: Label 'Plot Eligibility of all the Incentive line must be blank.';
        TEXT50004: Label 'Extent Eligibility and UOM of all the incentive line should be blank.';
        TEXT50005: Label 'There already exist Incentive with these details. ';
        UnitSetup: Record "Unit Setup";


    procedure AssistEdit(OldIncentiveHdr: Record "Incentive Header"): Boolean
    var
        Cust: Record Customer;
    begin
        IncentiveHdr := Rec;
        PurchasesPayablesSetup.GET;
        PurchasesPayablesSetup.TESTFIELD("Incentive No.");
        IF NoSeriesMgt.SelectSeries(PurchasesPayablesSetup."Incentive No.", OldIncentiveHdr."No. Series", IncentiveHdr."No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(IncentiveHdr."Incentive Code");
            Rec := IncentiveHdr;
            EXIT(TRUE);
        END;
    end;


    procedure CheckDuplicate(NewIncentive: Record "Incentive Header")
    begin
        IncentiveHdr.RESET;
        IncentiveHdr.SETRANGE("W.e.f. Date", NewIncentive."W.e.f. Date");
        IncentiveHdr.SETRANGE(Status, NewIncentive.Status);
        IncentiveHdr.SETRANGE("Incentive Type", NewIncentive."Incentive Type");
        IncentiveHdr.SETRANGE("No. of Units", NewIncentive."No. of Units");
        IF IncentiveHdr.FINDFIRST THEN
            ERROR(TEXT50005);
    end;
}

