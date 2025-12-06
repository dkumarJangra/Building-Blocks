codeunit 70005 "Other Event Mgnt"
{

    trigger OnRun()
    begin

        //This codeunit use to find team name at upline team
    end;

    procedure ReturnTeamCode(MMCode_1: Code[20]; RankCode_1: Code[10]; CurrentAssCode: code[20]; RunDownteam: Boolean): Code[50]
    var
        AssociateCode: Code[20];
        ChainMgt: Codeunit 97722;
        Chain: Record 50012 temporary;
        Vend: Record 23;
        Rank: Record 97815;
        Vend2: Record 23;
        WEDate: Date;
        RankCode: Code[10];
        Regionwisevend: Record 50012;
        Integer: Record integer;
        Noofrecords: Integer;
        Recodrfind: Boolean;
        Newteamcode: code[50];
        Teamheadcode: Code[20];
    begin
        AssociateCode := MMCode_1;
        RankCode := RankCode_1;
        Recodrfind := false;
        WEDate := Today;
        Newteamcode := '';
        Noofrecords := 1;
        Teamheadcode := '';
        ChainMgt.NewInitChain;
        ChainMgt.NewChainFromToUp(AssociateCode, WEDate, FALSE, RankCode);
        ChainMgt.NewUpdateChainRank(WEDate, RankCode);
        ChainMgt.NewReturnChain(Chain);
        Chain.SETCURRENTKEY("Rank Code");
        //Chain.ASCENDING(FALSE);
        Noofrecords := Chain.COUNT;
        IF Noofrecords = 0 THEN begin
            Regionwisevend.RESET;
            Regionwisevend.SetRange("Region Code", RankCode);
            Regionwisevend.SetRange("No.", AssociateCode); //Chain."No.");
            If Regionwisevend.FindFirst() then begin
                IF Regionwisevend."Team Code" <> '' then BEGIN
                    Newteamcode := Regionwisevend."Team Code";
                    // IF Chain."Parent Code" <> '' then
                    //     Teamheadcode := Chain."Parent Code";
                    if Vend.GET(CurrentAssCode) then begin
                        Vend."BBG Team Code" := Newteamcode;
                        Vend.Modify;
                    end;
                END;
            end;

        end ELSE BEGIN
            Integer.SETRANGE(Number, 1, Noofrecords);
            If Integer.FindSet() then
                repeat
                    IF integer.Number = 1 THEN
                        Chain.FIND('-')
                    ELSE
                        Chain.NEXT;
                    CLEAR(Vend);


                    IF Newteamcode = '' THEN BEGIN
                        Regionwisevend.RESET;
                        Regionwisevend.SetRange("Region Code", RankCode);
                        Regionwisevend.SetRange("No.", Chain."Parent Code");
                        If Regionwisevend.FindFirst() then begin
                            IF Regionwisevend."Team Code" <> '' then BEGIN
                                Newteamcode := Regionwisevend."Team Code";
                                //Teamheadcode := Chain."Parent Code";
                                if Vend.GET(CurrentAssCode) then begin
                                    Vend."BBG Team Code" := Newteamcode;
                                    Vend.Modify;
                                end;
                            END;
                        END ELSE begin
                            Regionwisevend.RESET;
                            Regionwisevend.SetRange("Region Code", RankCode);
                            Regionwisevend.SetRange("No.", Chain."No.");
                            If Regionwisevend.FindFirst() then begin
                                IF Regionwisevend."Team Code" <> '' then BEGIN
                                    Newteamcode := Regionwisevend."Team Code";
                                    // IF Chain."Parent Code" <> '' then
                                    //     Teamheadcode := Chain."Parent Code";
                                    if Vend.GET(CurrentAssCode) then begin
                                        Vend."BBG Team Code" := Newteamcode;
                                        Vend.Modify;
                                    end;
                                END;
                            end;
                        END;
                    END;
                until (integer.Next = 0) OR (Newteamcode <> '');
        END;
        IF RunDownteam THEN BEGIN
            Commit();
            Clear(UpdateTeamcode);
            If (CurrentAssCode <> '') and (RankCode <> '') and (Newteamcode <> '') then
                UpdateTeamcode.UpdateTeamNameatDownline(CurrentAssCode, RankCode, Newteamcode);
        END;
        Exit(Newteamcode);
    end;



    var
        UpdateTeamcode: Codeunit 70006;
}