codeunit 70006 "Team codeupdate at downline"
{

    trigger OnRun()
    begin

        //This codeunit for update the team name at down line team
    end;

    procedure UpdateTeamNameatDownline(MMCode_1: Code[20]; RankCode_1: Code[10]; Newteamcode: code[50])
    var
        Noofrecords: Integer;
        Integer: Record Integer;
        Regionwisevend: Record 50012;
        AssStatus: text;
    begin
        MMCode := MMCode_1;
        RankCode := RankCode_1;
        WEFDate := Today;

        ChainMgt.NewInitChain;
        ChainMgt.NewBuildChainTopToBottom(MMCode, WEFDate, TRUE, RankCode);
        ChainMgt.NewReturnChain(Chain);

        //Create Hierarchy Serial No.s
        Cnt += 1;
        Chain.GET(RankCode, MMCode);
        Chain.Priority := Cnt;
        //Chain."E-Mail" := '1';
        Chain.MODIFY;
        Chain2 := Chain;
        Chain2.INSERT;
        BuildHierarchy(MMCode);

        Chain.RESET;
        Chain.SETCURRENTKEY(Priority);
        Noofrecords := Chain.COUNT;
        IF Noofrecords = 0 THEN begin
            Regionwisevend.RESET;
            Regionwisevend.SetRange("Region Code", RankCode);
            Regionwisevend.SetRange("No.", Chain."No.");
            If Regionwisevend.FindFirst() then begin
                Regionwisevend."Team Code" := Newteamcode;
                if Vend.GET(Chain."No.") then begin
                    IF Vend."BBG Black List" THEN
                        AssStatus := 'Deactivate'
                    ELSE
                        AssStatus := 'Active';
                    Vend."BBG Team Code" := Newteamcode;
                    Vend.Modify;
                end;
                Regionwisevend.Modify;
                RankCodeMaster.RESET;
                RankCodeMaster.SETRANGE("Rank Batch Code", Regionwisevend."Region Code");
                RankCodeMaster.SETRANGE(Code, Regionwisevend."Rank Code");
                IF RankCodeMaster.FINDFIRST THEN;

                WebAppService.Post_data('', Vend."No.", Vend.Name, Vend."BBG Mob. No.", Vend."E-Mail", Vend."BBG Team Code", Vend."BBG Leader Code", Regionwisevend."Parent Code",
                FORMAT(AssStatus), FORMAT(Regionwisevend."Rank Code"), RankCodeMaster.Description);
            END;

        end ELSE BEGIN
            Integer.reset;
            Integer.SETRANGE(Number, 1, Noofrecords);
            If Integer.FindSet() then
                repeat
                    IF integer.Number = 1 THEN
                        Chain.FIND('-')
                    ELSE
                        Chain.NEXT;
                    CLEAR(Vend);


                    Regionwisevend.RESET;
                    Regionwisevend.SetRange("Region Code", RankCode);
                    Regionwisevend.SetRange("No.", Chain."No.");
                    If Regionwisevend.FindFirst() then begin
                        Regionwisevend."Team Code" := Newteamcode;
                        if Vend.GET(Chain."Parent Code") then begin
                            IF Vend."BBG Black List" THEN
                                AssStatus := 'Deactivate'
                            ELSE
                                AssStatus := 'Active';
                            Vend."BBG Team Code" := Newteamcode;
                            Vend.Modify;
                        end;
                        Regionwisevend.Modify;
                        RankCodeMaster.RESET;
                        RankCodeMaster.SETRANGE("Rank Batch Code", Regionwisevend."Region Code");
                        RankCodeMaster.SETRANGE(Code, Regionwisevend."Rank Code");
                        IF RankCodeMaster.FINDFIRST THEN;

                        WebAppService.Post_data('', Vend."No.", Vend.Name, Vend."BBG Mob. No.", Vend."E-Mail", Vend."BBG Team Code", Vend."BBG Leader Code", Regionwisevend."Parent Code",
                        FORMAT(AssStatus), FORMAT(Regionwisevend."Rank Code"), RankCodeMaster.Description);
                    END;

                until (integer.Next = 0);

            //Exit(Newteamcode);
        END;
    end;

    var
        Text000: Label 'Invalid Parameters.';
        CurrentTeamName: Code[50];

        RegionVendorCode: Record 50012;
        j: Integer;
        k: Integer;
        CompInfo: Record 79;
        TempExcelBuffer: Record 370 temporary;
        Filters: Text[30];
        MMCode: Code[10];
        WEFDate: Date;
        ChainMgt: Codeunit 97722;
        Chain: Record 50012 temporary;
        Chain2: Record 50012 temporary;
        Vendor: Record 50012;
        Cnt: Integer;
        GetDesc: Codeunit 97724;
        ExportToExcel: Boolean;
        RowNo: Integer;
        Rank: Record 50014;
        Designation: Text[30];
        Vend3: Record 23;
        VName: Text[50];
        Memberof: Record 2000000053;
        "VendMobNo.": Text[30];
        RankCode: Code[10];
        RecVend: Record 23;
        Vend_2: Record 23;
        Associatecode: Code[20];
        WEDate: Date;
        Vend: Record 23;
        DOJ: Date;
        D: Integer;
        M: Integer;
        Y: Integer;
        CompanywiseGLAccount: Record 50020;
        UserSetup: Record 91;
        Single: Label '''';
        ReportDetailsUpdate: Codeunit 50018;
        EntryNo: Integer;
        ReportFilters: Text;
        InsertData: Boolean;
        GamificationTeamHierarchy: Record 60681;
        UnitSetup: Record 97788;
        AssociateHieWithApp: record "Associate Hierarcy with App.";
        newconfirmedorder: Record "New Confirmed Order";
        ConfirmedOrder: Record "Confirmed Order";
        WebAppService: Codeunit "Web App Service";
        RankCodeMaster: Record "Rank Code";


    procedure BuildHierarchy(MCode: Code[20])
    var
        RegionwiseVendor: Record 50012;
        Level: Integer;
    begin
        RegionwiseVendor.RESET;
        RegionwiseVendor.SETCURRENTKEY("Region Code", "Parent Code");
        RegionwiseVendor.SETRANGE("Region Code", RankCode);
        RegionwiseVendor.SETRANGE("Parent Code", MCode);
        IF RegionwiseVendor.FINDSET THEN
            REPEAT
                IF Chain.GET(RankCode, RegionwiseVendor."No.") THEN BEGIN
                    Cnt += 1;

                    Chain2.RESET;
                    Chain2.SETRANGE("Parent Code", MCode);
                    Level := Chain2.COUNT + 1;

                    Chain2.GET(RankCode, MCode);
                    Chain.Priority := Cnt;
                    //Chain."E-Mail" := Chain2."E-Mail" + '.' + FORMAT(Level);
                    Chain.MODIFY;

                    Chain2 := Chain;
                    Chain2.INSERT;

                    BuildHierarchy(RegionwiseVendor."No.");
                END;
            UNTIL RegionwiseVendor.NEXT = 0;
    end;

}
