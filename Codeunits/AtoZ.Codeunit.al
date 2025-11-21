codeunit 50036 AtoZ
{
    TableNo = Vendor;

    trigger OnRun()
    begin

        RankCodeMaster.RESET;
        IF RankCodeMaster.FINDSET THEN
            REPEAT
                TopHeadDetailsA1.RESET;
                TopHeadDetailsA1.SETRANGE("Associate Code", Rec."No.");
                IF NOT TopHeadDetailsA1.FINDFIRST THEN BEGIN
                    CLEAR(AssociateTeamforGamifiction);
                    RegionwiseVendor.RESET;
                    IF RegionwiseVendor.GET(RankCodeMaster.Code, Rec."No.") THEN BEGIN
                        AssociateTeamforGamifiction.ReportValues(Rec."No.", RankCodeMaster.Code);
                        AssociateTeamforGamifiction.RUNMODAL;
                    END;
                    COMMIT;
                END;

            UNTIL RankCodeMaster.NEXT = 0;
    end;

    var
        AssociateTeamforGamifiction: Report "Team Head Name Update";
        TopHeadDetailsA1: Record "Top Head Details A1";
        RankCodeMaster: Record "Rank Code Master";
        RegionwiseVendor: Record "Region wise Vendor";
}

