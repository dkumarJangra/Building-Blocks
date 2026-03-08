table 97850 "Incentive Unit Header"
{
    LookupPageID = "Incentive Unit List";

    fields
    {
        field(1; "Incentive Unit Code"; Code[20])
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
        field(2; "W.e.f. Date"; Date)
        {

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
        field(3; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
        field(4; "No. Series"; Code[20])
        {
        }
        field(5; Status; Option)
        {
            OptionCaption = 'Open,In-Active,Released';
            OptionMembers = Open,"In-Active",Released;

            trigger OnValidate()
            begin
                CheckDuplicate(Rec);
            end;
        }
    }

    keys
    {
        key(Key1; "Incentive Unit Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF (Status = Status::"In-Active") AND (Status = Status::Released) THEN
            ERROR(Text50001);
    end;

    trigger OnInsert()
    begin
        IF "Incentive Unit Code" = '' THEN BEGIN
            PurchasesPayablesSetup.GET;
            PurchasesPayablesSetup.TESTFIELD("Incentive Unit Code");
            // NoSeriesMgt.InitSeries(PurchasesPayablesSetup."Incentive Unit Code", xRec."No. Series", 0D, "Incentive Unit Code", "No. Series");  //Old code commented 07032026
            "Incentive Unit Code" := NoSeriesMgt.GetNextNo(PurchasesPayablesSetup."Incentive Unit Code", WorkDate, true);  //New code added 07032026 
        END;
    end;

    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        IncentiveUnitHdr: Record "Incentive Unit Header";
        NoSeriesMgt: Codeunit "No. Series"; //NoSeriesManagement;
        Text50000: Label 'This incentive already exist.';
        Text50001: Label 'Released or In-active Incentive cannot be deleted.';


    procedure AssistEdit(OldIncentiveUnitHdr: Record "Incentive Unit Header"): Boolean
    var
        Cust: Record Customer;
    begin
        IncentiveUnitHdr := Rec;
        PurchasesPayablesSetup.GET;
        PurchasesPayablesSetup.TESTFIELD("Incentive Unit Code");
        //IF NoSeriesMgt.SelectSeries(PurchasesPayablesSetup."Incentive Unit Code", OldIncentiveUnitHdr."No. Series", IncentiveUnitHdr."No. Series") THEN BEGIN  //Old code commented 07032026
        //  NoSeriesMgt.SetSeries(IncentiveUnitHdr."Incentive Unit Code");  //Old code commented 07032026
        if NoSeriesMgt.LookupRelatedNoSeries(PurchasesPayablesSetup."Incentive Unit Code", Rec."No. Series") then BEGIN  //New code Added 07032026
            Rec.Validate("No. Series");  //New code Added 07032026
            NoSeriesMgt.TestManual("No. Series");  //New code Added 07032026

            Rec := IncentiveUnitHdr;
            EXIT(TRUE);
        END;
    end;


    procedure CheckDuplicate(NewIncentive: Record "Incentive Unit Header")
    begin
        IncentiveUnitHdr.RESET;
        IncentiveUnitHdr.SETRANGE("Responsibility Center", NewIncentive."Responsibility Center");
        IncentiveUnitHdr.SETRANGE("W.e.f. Date", NewIncentive."W.e.f. Date");
        IncentiveUnitHdr.SETRANGE(Status, NewIncentive.Status);
        IF IncentiveUnitHdr.FINDFIRST THEN
            ERROR(Text50000);
    end;
}

