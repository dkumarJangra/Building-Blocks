codeunit 97722 "Unit Post"
{
    // //Commission Entry Creation
    // //Bonus Entry Creation
    // ALLEDK 040113  Added code for flow Project Code
    // 
    // //BBG1.00 280413 Commission Gernerated on Confirmed Posting Date
    // Added BEGIN and END 230622
    // 
    // 251023 Code added for New Commission Structure


    trigger OnRun()
    begin
    end;

    var
        Bond: Record "Confirmed Order";
        Vend: Record Vendor;
        ParentChain: Record Vendor temporary;
        Window: Dialog;
        VendorChain: Record Vendor temporary;
        RankChangeHistory: Record "Rank Change History";
        Text001: Label 'Creating Bonus                #2######\';
        Text002: Label 'Building Chain for            #1######';
        Text008: Label 'NOD Lines not found for Vendor No. %1 for NOD Code ''COMM''.';
        Text009: Label 'On hold %1 exists for %2 %3, %4 %5. ';
        Priority: Integer;
        WindowOpen: Boolean;
        TempBonusEntry: Record "Bonus Entry" temporary;
        GetDescription: Codeunit GetDescription;
        RankList: Record Rank;
        RankLevel: Integer;
        AppPostingDate: Date;
        BuildChain1: Record Vendor;
        Rank: Record Rank;
        UnitSetup: Record "Unit Setup";
        TDSPercentage: Decimal;
        //NODNOCHdr: Record 13786;
        TDSSetup: Record "TDS Setup";// "13728";
        //NODLines: Record 13785;
        Vendor: Record Vendor;
        PaymentTermsLineSale: Record "Payment Terms Line Sale";
        CommEntry: Record "Commission Entry";
        BSp2Amt: Decimal;
        Level1: Integer;
        AssociateHierarcywithApp: Record "Associate Hierarcy with App.";
        RecRank: Record Rank;
        NewParentChain: Record "Region wise Vendor" temporary;
        NewVend: Record "Region wise Vendor";
        NewRankList: Record "Rank Code";
        NewRecRank: Record "Rank Code";
        NewAssociateHierwithAppl: Record "New Associate Hier with Appl.";
        AssHierwithApp: Record "New Associate Hier with Appl.";
        VendorTree_1: Record "Vendor Tree";
        ConOrder_11: Record "Confirmed Order";
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        UnitandCommCreationJob: Codeunit "Unit and Comm. Creation Job";
        ReleaseUnitApplication: Codeunit "Release Unit Application";
        PPLANCode: Code[20];
        WebAppService: Codeunit "Web App Service";


    procedure CalculateComission(var ComPostingBuffer: Record "Unit & Comm. Creation Buffer")
    var
        ComStructTemp: Record "Commission Structure" temporary;
        PrevRank: Decimal;
        CommissionEntry: Record "Commission Entry";
        EntryNo: Integer;
        InvestmentType: Integer;
        BondNo: Code[20];
        Application: Record Application;
        PostingDate: Date;
    begin
        IF ComPostingBuffer."Min. Allotment Amount Not Paid" <> TRUE THEN BEGIN
            //Commission Entry Creation
            InitChain;
            PrevRank := 0;
            BondNo := ComPostingBuffer."Unit No.";
            Bond.GET(BondNo);
            //  PostingDate := ComPostingBuffer."Posting Date";  //BBG1.00 280413
            PostingDate := Bond."Posting Date";  //BBG1.00 280413
            AppPostingDate := Bond."Posting Date";
            ChainFromToUp(ComPostingBuffer."Introducer Code", PostingDate, ComPostingBuffer."Direct Associate");
            UpdateChainRank(PostingDate);

            ComStructTemp.RESET;
            ComStructTemp.DELETEALL;
            CASE ComPostingBuffer."Investment Type" OF
                ComPostingBuffer."Investment Type"::FD:
                    InvestmentType := 0;
                ComPostingBuffer."Investment Type"::MIS:
                    InvestmentType := 0;
                ComPostingBuffer."Investment Type"::RD:
                    InvestmentType := 1;
            END;

            PPLANCode := '';
            PPLANCode := ReleaseUnitApplication.CheckUnitPaymentPlan(Bond."Shortcut Dimension 1 Code", Bond."No.", FALSE);  //071223
            BuildBonusComissionStructure(0, ComPostingBuffer."Year Code", ComStructTemp,
              InvestmentType, Bond.Duration, Bond."Project Type", PostingDate, PPLANCode);  //071223

            EntryNo := GetLastEntryNo;
            UnitSetup.GET;
            ParentChain.SETCURRENTKEY("BBG Rank Code");
            IF ParentChain.FINDSET THEN
                REPEAT
                    IF ParentChain."BBG Rank Code" <= UnitSetup."Hierarchy Head" THEN BEGIN //ALLEDK 301112
                        CommissionEntry.INIT;
                        CommissionEntry."Entry No." := EntryNo;
                        CommissionEntry.VALIDATE("Application No.", ComPostingBuffer."Unit No.");
                        CommissionEntry."Posting Date" := ComPostingBuffer."Posting Date";
                        CommissionEntry."Associate Code" := ParentChain."No.";
                        CommissionEntry."Base Amount" := ComPostingBuffer."Base Amount";
                        IF ComPostingBuffer."Direct Associate" THEN BEGIN  //ALLEDK 011212
                            CommissionEntry."Commission Amount" := ROUND(CommissionEntry."Base Amount");
                            CommissionEntry."Direct to Associate" := ComPostingBuffer."Direct Associate";
                            //  CommissionEntry."Remaining Amt of Direct" := TRUE;
                        END ELSE BEGIN
                            PPLANCode := '';
                            PPLANCode := ReleaseUnitApplication.CheckUnitPaymentPlan(Bond."Shortcut Dimension 1 Code", Bond."No.", FALSE);  //071223
                            CommissionEntry."Commission %" := CalculateBonusCommissionPct(ComStructTemp, PrevRank, ParentChain."BBG Rank Code", PPLANCode);  //071223
                            CommissionEntry."Commission Amount" := ROUND(CommissionEntry."Base Amount" * (CommissionEntry."Commission %" / 100));
                            CommissionEntry."Direct to Associate" := ComPostingBuffer."Direct Associate";
                            CommissionEntry."Remaining Amt of Direct" := FALSE;
                        END;
                        CommissionEntry."Installment No." := ComPostingBuffer."Installment No.";
                        CommissionEntry."Bond Category" := Bond."Bond Category";
                        IF Bond."Introducer Code" = ParentChain."No." THEN
                            CommissionEntry."Business Type" := CommissionEntry."Business Type"::SELF
                        ELSE
                            CommissionEntry."Business Type" := CommissionEntry."Business Type"::CHAIN;
                        CommissionEntry."Introducer Code" := Bond."Introducer Code";
                        CommissionEntry."Scheme Code" := Bond."Scheme Code";
                        CommissionEntry."Project Type" := Bond."Project Type";
                        CommissionEntry.Duration := ComPostingBuffer.Duration;
                        CommissionEntry."Shortcut Dimension 1 Code" := ComPostingBuffer."Shortcut Dimension 1 Code";  //ALLEDK 040113
                        CommissionEntry."Associate Rank" := ParentChain."BBG Rank Code";
                        CommissionEntry."Opening Entries" := ComPostingBuffer."Opening Commision Adj."; //BBG1.00 290413
                        CommissionEntry.Posted := ComPostingBuffer."Opening Commision Adj."; //BBG1.00 290413
                        CommissionEntry."Charge Code" := ComPostingBuffer."Charge Code";
                        CommissionEntry."Unit Payment Line No." := ComPostingBuffer."Unit Payment Line No.";
                        IF ComPostingBuffer."Year Code" = 1 THEN
                            CommissionEntry."First Year" := TRUE
                        ELSE
                            CommissionEntry."First Year" := FALSE;
                        CommissionEntry."Registration Bonus Hold(BSP2)" := TRUE;
                        //CalcTDSPercentage; ALLEDK 141212
                        CommissionEntry.INSERT;

                        BSp2Amt := 0;
                        //ALLEDK 201212
                        IF CommissionEntry."Direct to Associate" THEN BEGIN
                            PaymentTermsLineSale.RESET;
                            PaymentTermsLineSale.SETRANGE("Document No.", CommissionEntry."Application No.");
                            PaymentTermsLineSale.SETRANGE("Direct Associate", TRUE);
                            IF PaymentTermsLineSale.FINDFIRST THEN BEGIN
                                REPEAT
                                    PaymentTermsLineSale.CALCFIELDS("Received Amt");
                                    IF ROUND(PaymentTermsLineSale."Received Amt", 1, '=') >= PaymentTermsLineSale."Due Amount" THEN BEGIN
                                        CommEntry.RESET;
                                        CommEntry.SETRANGE("Application No.", CommissionEntry."Application No.");
                                        CommEntry.SETRANGE("Direct to Associate", TRUE);
                                        IF CommEntry.FINDSET THEN
                                            REPEAT
                                                CommEntry."Remaining Amt of Direct" := FALSE;
                                                CommEntry.MODIFY;
                                            UNTIL CommEntry.NEXT = 0;
                                    END ELSE BEGIN
                                        CommissionEntry."Remaining Amt of Direct" := TRUE;
                                        CommissionEntry.MODIFY;
                                    END;
                                UNTIL PaymentTermsLineSale.NEXT = 0;
                            END;
                        END;
                        //ALLEDK 201212
                        PrevRank := ParentChain."BBG Rank Code" + 0.0001; //BBG1.00 090313
                        EntryNo += 1;
                    END;   //ALLEDK 301112
                UNTIL ParentChain.NEXT = 0;

            ComPostingBuffer."Commission Created" := TRUE;
            ComPostingBuffer.MODIFY;
        END;
    end;


    procedure ChainFromToUp(MMCode: Code[20]; PostingDate: Date; DirectAss: Boolean)
    begin
        Vend.GET(MMCode);
        ParentChain.INIT;
        ParentChain.TRANSFERFIELDS(Vend);
        ParentChain.INSERT;

        IF NOT DirectAss THEN BEGIN
            Vend."BBG Parent Code" := ParentChange(MMCode, PostingDate);
            ParentChain."BBG Parent Code" := Vend."BBG Parent Code"; //ALLETDK 2312
            ParentChain.MODIFY;                              //ALLETDK 2312
            RankList.RESET;
            IF RankList.FIND('-') THEN
                RankLevel := RankList.COUNT;

            IF (Vend."BBG Parent Code" = '') OR (Vend."BBG Rank Code" = RankLevel - 1) THEN //ALLE PS
                EXIT;
            ChainFromToUp(Vend."BBG Parent Code", PostingDate, DirectAss);
        END
        ELSE
            EXIT;
    end;


    procedure InitChain()
    begin
        ParentChain.RESET;
        ParentChain.DELETEALL;
    end;


    procedure ReturnChain(var BuildChain: Record Vendor temporary)
    begin
        //UnitSetup.GET;                                                        //Alledk 131212
        //ParentChain.SETFILTER("Rank Code",'<=%1',UnitSetup."Hierarchy Head"); //Alledk 131212
        IF ParentChain.FINDSET THEN
            REPEAT
                BuildChain.INIT;
                BuildChain.TRANSFERFIELDS(ParentChain);
                IF NOT BuildChain.GET(BuildChain."No.") THEN //1812
                    BuildChain.INSERT;
            UNTIL ParentChain.NEXT = 0;
    end;


    procedure PresentRank(MemberNo: Code[20]; EffectiveDate: Date): Decimal
    var
        RankHistory: Record "Rank Change History";
        MM: Record Vendor;
        RH: Record "Rank Change History";
        RH1: Record "Rank Change History";
    begin
        RankHistory.SETCURRENTKEY(MMCode, "Authorisation Date");
        RankHistory.SETRANGE(MMCode, MemberNo);
        RankHistory.SETFILTER("Authorisation Date", '>%1', EffectiveDate);
        IF RankHistory.FINDFIRST THEN
            //IF (RankHistory."Previous Rank" <> 0) AND (RankHistory."Previous Rank" <> RankHistory."New Rank") THEN
            //EXIT(RankHistory."Previous Rank");
            //ALLETDK>>>>
            RH.RESET;
        RH.SETRANGE(MMCode, MemberNo);
        RH.SETRANGE("Authorisation Date", RankHistory."Authorisation Date");
        IF RH.FINDLAST THEN BEGIN

            RH1.RESET;
            RH1.SETRANGE(MMCode, MemberNo);
            RH1.SETRANGE("Authorisation Date", RH."Authorisation Date");
            RH1.SETRANGE("New Rank", RH."New Rank");
            RH1.SETFILTER("Entry No", '<>%1', RH."Entry No");
            IF RH1.FINDFIRST THEN
                EXIT(RH1."Previous Rank");

            IF (RH."Previous Rank" <> 0) AND (RH."Previous Rank" <> RH."New Rank") THEN
                EXIT(RH."Previous Rank");
            IF RH."Previous Rank" = RH."New Rank" THEN
                EXIT(RH."Previous Rank");
        END;
        //ALLETDK<<<
        MM.GET(MemberNo);
        EXIT(MM."BBG Rank Code");
    end;


    procedure BuildBonusComissionStructure(Type: Integer; YearCode: Integer; var ComissionStructure: Record "Commission Structure" temporary; InvType: Integer; Duration: Integer; BondType: Code[10]; PostingDate: Date; UnitPaymentPlan: Code[10])
    var
        ComissionStruc: Record "Commission Structure";
        WEFDate: Date;
    begin
        ComissionStruc.SETCURRENTKEY("Rank Code", "Commission Type", Period, "Investment Type", "Starting Date");
        ComissionStruc.SETRANGE("Commission Type", Type);
        ComissionStruc.SETRANGE(Period, Duration);
        ComissionStruc.SETRANGE("Project Type", BondType);
        ComissionStruc.SETRANGE("Investment Type", InvType);
        ComissionStruc.SETRANGE("Unit Payment Plan", UnitPaymentPlan); //071223
        IF YearCode > 1 THEN
            ComissionStruc.SETRANGE("Year Code", 0)
        ELSE
            ComissionStruc.SETRANGE("Year Code", YearCode);
        ComissionStruc.SETFILTER("Starting Date", '<=%1', PostingDate);
        IF ComissionStruc.FINDLAST THEN
            WEFDate := ComissionStruc."Starting Date";

        ComissionStruc.SETFILTER("Starting Date", '%1', WEFDate);
        IF ComissionStruc.FINDSET THEN
            REPEAT
                ComissionStructure.INIT;
                ComissionStructure.TRANSFERFIELDS(ComissionStruc);
                ComissionStructure.INSERT;
            UNTIL ComissionStruc.NEXT = 0;
    end;


    procedure UpdateChainRank(EffectiveDate: Date)
    begin
        UnitSetup.GET;                                                        //Alledk 051212
        ParentChain.SETFILTER("BBG Rank Code", '<=%1', UnitSetup."Hierarchy Head"); //Alledk 051212
        IF ParentChain.FINDSET THEN
            REPEAT
                ParentChain."BBG Rank Code" := PresentRank(ParentChain."No.", EffectiveDate);
                ParentChain.MODIFY;
            UNTIL ParentChain.NEXT = 0;
    end;


    procedure CalculateBonusCommissionPct(var ComStructure: Record "Commission Structure" temporary; LastRank: Decimal; CurrRank: Decimal; UnitPaymentPlan: Code[10]): Decimal
    var
        CommBonPct: Decimal;
    begin
        ComStructure.SETCURRENTKEY("Rank Code", "Commission Type", Period, "Investment Type", "Starting Date");
        ComStructure.SETRANGE("Rank Code", LastRank, CurrRank);
        ComStructure.SETRANGE("Unit Payment Plan", UnitPaymentPlan); //071223
        IF ComStructure.FINDSET THEN
            REPEAT
                CommBonPct += ComStructure."Commission %";
            UNTIL ComStructure.NEXT = 0;
        EXIT(CommBonPct);
    end;


    procedure GetLastEntryNo(): Integer
    var
        CommEnt: Record "Commission Entry";
        CommEntPosted: Record "Commission Entry Posted";
        EntNo: Integer;
    begin
        IF CommEntPosted.FINDLAST THEN
            EntNo := CommEntPosted."Entry No.";

        IF CommEnt.FINDLAST THEN
            IF CommEnt."Entry No." > EntNo THEN
                EntNo := CommEnt."Entry No.";

        EXIT(EntNo + 1);
    end;


    procedure ParentChange(MemberNo: Code[20]; EffectiveDate: Date): Code[20]
    var
        RankHistory: Record "Rank Change History";
        MM: Record Vendor;
    begin
        RankHistory.SETCURRENTKEY(MMCode, "Authorisation Date");
        RankHistory.SETRANGE(MMCode, MemberNo);
        IF RankHistory.FINDSET THEN
            REPEAT
                IF (RankHistory."Old Parent Code" <> '') AND (RankHistory."Old Parent Code" <> RankHistory."New Parent Code")
                //AND (RankHistory."Authorisation Date" > AppPostingDate) THEN //ALLETDK 2312
                AND (RankHistory."Authorisation Date" > EffectiveDate) THEN //ALLETDK 2312
                    EXIT(RankHistory."Old Parent Code");
            UNTIL RankHistory.NEXT = 0;
        MM.GET(MemberNo);
        EXIT(MM."BBG Parent Code");
    end;


    procedure CheckChain(MMCode: Code[20]; ReceiveFromCode: Code[20]; PostingDate: Date): Boolean
    begin
        ChainFromToUp(MMCode, PostingDate, FALSE);
        IF NOT ParentChain.GET(ReceiveFromCode) THEN
            EXIT(FALSE);
        EXIT(TRUE);
    end;


    procedure CheckVendorChain(MMCode: Code[20]; PostingDate: Date)
    begin
        InitChain;
        ChainFromToUp(MMCode, PostingDate, FALSE);
        ParentChain.SETCURRENTKEY("BBG Rank Code");
        IF ParentChain.FINDSET THEN
            REPEAT
                ParentChain.TESTFIELD("Vendor Posting Group");
                IF NOT ParentChain.NODExists THEN
                    ERROR(Text008, ParentChain."No.");
            UNTIL ParentChain.NEXT = 0;
    end;


    procedure OnHoldCommissionExists(BondNo: Code[20]; InstNo: Integer): Boolean
    var
        CommissionEntry: Record "Commission Entry";
    begin
        CommissionEntry.RESET;
        CommissionEntry.SETCURRENTKEY("Application No.", "Installment No.");
        CommissionEntry.SETRANGE("Application No.", BondNo);
        CommissionEntry.SETRANGE("Installment No.", InstNo);
        CommissionEntry.SETRANGE("On Hold", TRUE);
        EXIT(NOT CommissionEntry.ISEMPTY);
    end;


    procedure OpenOnHoldCommission(BondNo: Code[20]; InstNo: Integer)
    var
        CommissionEntry: Record "Commission Entry";
    begin
        CommissionEntry.RESET;
        CommissionEntry.SETCURRENTKEY("Application No.", "Installment No.");
        CommissionEntry.SETRANGE("Application No.", BondNo);
        CommissionEntry.SETRANGE("Installment No.", InstNo);
        CommissionEntry.MODIFYALL("On Hold", FALSE);
    end;


    procedure DeleteOnHoldCommission(BondNo: Code[20]; InstNo: Integer)
    var
        CommissionEntry: Record "Commission Entry";
    begin
        CommissionEntry.RESET;
        CommissionEntry.SETCURRENTKEY("Application No.", "Installment No.");
        CommissionEntry.SETRANGE("Application No.", BondNo);
        CommissionEntry.SETRANGE("Installment No.", InstNo);
        CommissionEntry.SETRANGE("On Hold", TRUE);
        CommissionEntry.DELETEALL;
    end;


    procedure "-Bonus-"()
    begin
    end;


    procedure CalculateApplicationBonus(var Application: Record Application; OnHold: Boolean)
    var
        BondNo: Code[20];
        ComStructTemp: Record "Commission Structure" temporary;
        PrevRank: Decimal;
        EntryNo: Integer;
        InvestmentType: Integer;
        CommissionEntry: Record "Commission Entry";
        PPLANCode: Code[10];
    begin
        //Bonus Entry Creation New Application
        IF GUIALLOWED THEN
            Window.OPEN(
              '#1#################################\\' +
              Text001);

        IF GUIALLOWED THEN
            Window.UPDATE(1, 'Creating Bonus');

        InitChain();
        PrevRank := 0;
        Application.TESTFIELD("Unit No.");
        BondNo := Application."Unit No.";
        //Bond.GET(BondNo);

        IF OnHoldBonusExists(Application."Unit No.", 1) THEN
            ERROR(Text009, TempBonusEntry.TABLECAPTION, TempBonusEntry.FIELDCAPTION("Unit No."), Application."Unit No.",
              TempBonusEntry.FIELDCAPTION("Installment No."), 1);
        IF OnHoldCommissionExists(Application."Unit No.", 1) THEN
            ERROR(Text009, CommissionEntry.TABLECAPTION, CommissionEntry.FIELDCAPTION("Application No."), Application."Unit No.",
              CommissionEntry.FIELDCAPTION("Installment No."), 1);

        ChainFromToUp(Application."Associate Code", Application."Posting Date", FALSE);
        UpdateChainRank(Application."Posting Date");
        ComStructTemp.RESET;
        ComStructTemp.DELETEALL;

        CASE Application."Investment Type" OF
            Application."Investment Type"::FD:
                InvestmentType := 0;
            Application."Investment Type"::MIS:
                InvestmentType := 0;
            Application."Investment Type"::RD:
                InvestmentType := 1;
        END;


        PPLANCode := '';
        PPLANCode := ReleaseUnitApplication.CheckUnitPaymentPlan(Application."Shortcut Dimension 1 Code", Application."Application No.", FALSE);  //071223
        BuildBonusComissionStructure(1, 1, ComStructTemp, InvestmentType, Application.Duration,
        Application."Project Type", Application."Posting Date", PPLANCode);  //071223

        ParentChain.SETCURRENTKEY("BBG Rank Code");
        IF ParentChain.FINDSET THEN BEGIN
            //EntryNo := GetLastEntryNoBonus(ParentChain.COUNT);
            EntryNo := GetLastEntryNoTempBonus;
            REPEAT
                TempBonusEntry.INIT;
                TempBonusEntry."Entry No." := EntryNo;
                IF GUIALLOWED THEN
                    Window.UPDATE(2, EntryNo);
                EntryNo += 1;
                TempBonusEntry."Unit No." := Application."Unit No.";
                TempBonusEntry."Posting Date" := Application."Posting Date";//WORKDATE;
                TempBonusEntry."Associate Code" := ParentChain."No.";
                TempBonusEntry."Base Amount" := Application."Investment Amount";
                PPLANCode := '';
                PPLANCode := ReleaseUnitApplication.CheckUnitPaymentPlan(Application."Shortcut Dimension 1 Code", Application."Application No.", FALSE);  //071223
                TempBonusEntry."Bonus %" := CalculateBonusCommissionPct(ComStructTemp, PrevRank, ParentChain."BBG Rank Code", PPLANCode);  //071223
                PrevRank := ParentChain."BBG Rank Code" + 0.0001; //BBG1.00 ALLEDK 090313
                TempBonusEntry."Bonus Amount" := ROUND(TempBonusEntry."Base Amount" * (TempBonusEntry."Bonus %" / 100));
                TempBonusEntry."Installment No." := 1; //ComPostingBuffer."Installment No.";
                TempBonusEntry."Bond Category" := Application.Category;
                IF Application."Associate Code" = ParentChain."No." THEN
                    TempBonusEntry."Business Type" := TempBonusEntry."Business Type"::SELF
                ELSE
                    TempBonusEntry."Business Type" := TempBonusEntry."Business Type"::CHAIN;
                TempBonusEntry."Introducer Code" := Application."Associate Code";
                TempBonusEntry."Scheme Code" := Application."Scheme Code";
                TempBonusEntry."Project Type" := Application."Project Type";

                TempBonusEntry.Duration := Application.Duration;
                TempBonusEntry."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
                TempBonusEntry."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
                TempBonusEntry."Associate Rank" := ParentChain."BBG Rank Code";
                TempBonusEntry."Pmt Received From Code" := Application."Received From Code";
                TempBonusEntry."Document Date" := Application."Document Date";
                TempBonusEntry.Stopped := OnHold;
                TempBonusEntry.INSERT;
            UNTIL ParentChain.NEXT = 0;
        END;

        IF GUIALLOWED THEN
            Window.CLOSE;
    end;


    procedure CalculateRDInstallmentBonus(var RDPmtSch: Record Terms; Dim1: Code[20]; Dim2: Code[20]; PaymentRcvdFrom: Code[20]; OnHold: Boolean)
    var
        BondNo: Code[20];
        ComPostingBuffer: Record "Unit & Comm. Creation Buffer";
        ComStructTemp: Record "Commission Structure" temporary;
        PrevRank: Integer;
        CommissionEntry: Record "Commission Entry";
        EntryNo: Integer;
        "-": Integer;
        PostingDate: Date;
        RDPmtSchBuff: Record "Template Field";
        UserSetup: Record "User Setup";
    begin
    end;


    procedure OnHoldBonusExists(BondNo: Code[20]; InstNo: Integer): Boolean
    var
        BonusEntry: Record "Bonus Entry";
    begin
        BonusEntry.RESET;
        BonusEntry.SETCURRENTKEY("Unit No.", "Installment No.");
        BonusEntry.SETRANGE("Unit No.", BondNo);
        BonusEntry.SETRANGE("Installment No.", InstNo);
        BonusEntry.SETRANGE(Stopped, TRUE);
        EXIT(NOT BonusEntry.ISEMPTY);
    end;


    procedure OpenOnHoldBonus(BondNo: Code[20]; InstNo: Integer)
    var
        BonusEntry: Record "Bonus Entry";
    begin
        BonusEntry.RESET;
        BonusEntry.SETCURRENTKEY("Unit No.", "Installment No.");
        BonusEntry.SETRANGE("Unit No.", BondNo);
        BonusEntry.SETRANGE("Installment No.", InstNo);
        BonusEntry.MODIFYALL(Stopped, FALSE);
    end;


    procedure DeleteOnHoldBonus(BondNo: Code[20]; InstNo: Integer)
    var
        BonusEntry: Record "Bonus Entry";
    begin
        BonusEntry.RESET;
        BonusEntry.SETCURRENTKEY("Unit No.", "Installment No.");
        BonusEntry.SETRANGE("Unit No.", BondNo);
        BonusEntry.SETRANGE("Installment No.", InstNo);
        BonusEntry.SETRANGE(Stopped, TRUE);
        BonusEntry.DELETEALL;
    end;


    procedure GetLastEntryNoBonus(IncrementBy: Integer): Integer
    var
        BonusEnt: Record "Bonus Entry";
        BonusEntPosted: Record "Bonus Entry Posted";
        EntNo: Integer;
        EntNoSetup: Record "Entry No. Setup";
    begin
        EntNoSetup.RESET;
        EntNoSetup.SETRANGE(TableNo, DATABASE::"Bonus Entry");
        IF EntNoSetup.FINDSET(TRUE, FALSE) THEN BEGIN
            EntNo := EntNoSetup."Entry No.";
            EntNoSetup."Entry No." := EntNo + IncrementBy;
            EntNoSetup.MODIFY;
        END ELSE BEGIN
            IF BonusEntPosted.FINDLAST THEN
                EntNo := BonusEntPosted."Entry No.";
            IF BonusEnt.FINDLAST THEN
                IF BonusEnt."Entry No." > EntNo THEN
                    EntNo := BonusEnt."Entry No.";

            EntNoSetup.INIT;
            EntNoSetup.TableNo := DATABASE::"Bonus Entry";
            EntNoSetup."Entry No." := EntNo + IncrementBy;
            EntNoSetup.INSERT;
        END;

        EXIT(EntNo + 1);
    end;


    procedure InitTempBonusEntry()
    begin
        TempBonusEntry.RESET;
        TempBonusEntry.DELETEALL;
    end;


    procedure GetLastEntryNoTempBonus(): Integer
    var
        LastEntNo: Integer;
    begin
        TempBonusEntry.RESET;
        IF TempBonusEntry.FINDLAST THEN
            LastEntNo := TempBonusEntry."Entry No.";

        EXIT(LastEntNo + 1);
    end;


    procedure InsertBonusEntry(WithCheque: Boolean)
    var
        EntryNo: Integer;
        BonusEntry: Record "Bonus Entry";
    begin
        TempBonusEntry.RESET;
        IF TempBonusEntry.FINDSET THEN BEGIN
            EntryNo := GetLastEntryNoBonus(TempBonusEntry.COUNT);
            REPEAT
                BonusEntry := TempBonusEntry;
                BonusEntry."Entry No." := EntryNo;
                BonusEntry.Stopped := WithCheque;
                BonusEntry.INSERT;
                EntryNo += 1;
            UNTIL TempBonusEntry.NEXT = 0;
        END;
    end;


    procedure "-Chain-"()
    begin
    end;


    procedure BuildChainTopToBottom(ParentCode: Code[20]; PostingDate: Date; FirstTime: Boolean)
    begin
        Priority := 0;
        ChainTopToBottom(ParentCode, PostingDate, TRUE);
        IF PostingDate < GetDescription.GetDocomentDate THEN
            IncludeChain(ParentCode, PostingDate);
    end;


    procedure ChainTopToBottom(ParentCode: Code[20]; PostingDate: Date; FirstTime: Boolean)
    var
        Vendor: Record Vendor;
        RCH: Record "Rank Change History";
        SerialNo: Text[80];
        Cnt: Integer;
    begin
        IF FirstTime THEN BEGIN
            Vendor.GET(ParentCode);
            IF NOT ParentChain.GET(Vendor."No.") THEN BEGIN
                ParentChain := Vendor;
                Priority += 1;
                ParentChain.Priority := Priority;
                ParentChain.INSERT;
            END;
        END;

        Vendor.RESET;
        Vendor.SETCURRENTKEY("BBG Parent Code");
        Vendor.SETRANGE("BBG Parent Code", ParentCode);
        IF Vendor.FINDSET THEN
            REPEAT
                IF (Vendor."BBG Date of Joining" <= PostingDate) AND NOT ChildChange(ParentCode, Vendor."No.", PostingDate) THEN BEGIN
                    IF NOT ParentChain.GET(Vendor."No.") THEN BEGIN
                        ParentChain := Vendor;
                        IF PostingDate < GetDescription.GetDocomentDate THEN BEGIN
                            RCH.RESET;
                            RCH.SETCURRENTKEY(MMCode, "Authorisation Date");
                            RCH.SETRANGE(MMCode, Vendor."No.");
                            RCH.SETFILTER("Authorisation Date", '<=%1', PostingDate);
                            IF RCH.FINDLAST THEN BEGIN
                                ParentChain."BBG Parent Code" := RCH."New Parent Code";
                                ParentChain."BBG Parent Rank" := RCH."Parent Rank New";
                            END;
                        END;
                        Priority += 1;
                        ParentChain.Priority := Priority;
                        ParentChain.INSERT;
                    END;

                    IF PostingDate < GetDescription.GetDocomentDate THEN
                        IncludeChain(ParentChain."No.", PostingDate);
                    ChainTopToBottom(ParentChain."No.", PostingDate, FALSE);
                END;
            UNTIL Vendor.NEXT = 0;
    end;


    procedure ChildChange(ParantCode: Code[20]; MMCode: Code[20]; EffectiveDate: Date): Boolean
    var
        RankHistory: Record "Rank Change History";
        MM: Record Vendor;
    begin
        //RankHistory.SETCURRENTKEY(MMCode,"Authorisation Date","Change Type");
        RankHistory.SETCURRENTKEY(MMCode, "Authorisation Date");
        RankHistory.SETRANGE(MMCode, MMCode);
        RankHistory.SETFILTER("Authorisation Date", '>=%1', EffectiveDate);
        IF RankHistory.FINDSET THEN
            REPEAT
                IF (RankHistory."Old Parent Code" <> '') AND (RankHistory."Old Parent Code" <> RankHistory."New Parent Code") THEN
                    IF RankHistory."Old Parent Code" <> ParantCode THEN
                        EXIT(TRUE);
            UNTIL RankHistory.NEXT = 0;
        EXIT(FALSE);
    end;


    procedure IncludeChain(ParentCode: Code[20]; PostingDate: Date)
    var
        CompressedChain: Record "Rank Change History" temporary;
        ChainSubset2: Record "Rank Change History";
    begin
        RankChangeHistory.RESET;
        RankChangeHistory.SETCURRENTKEY(MMCode, "Authorisation Date");
        RankChangeHistory.ASCENDING(FALSE);
        RankChangeHistory.SETFILTER("Authorisation Date", '<=%1', PostingDate);
        RankChangeHistory.SETRANGE("New Parent Code", ParentCode);
        IF RankChangeHistory.FIND('-') THEN
            REPEAT
                IF RankChangeHistory."Old Parent Code" <> RankChangeHistory."New Parent Code" THEN BEGIN
                    CompressedChain.RESET;
                    CompressedChain.SETCURRENTKEY(MMCode, "Authorisation Date");
                    CompressedChain.SETRANGE(MMCode, RankChangeHistory.MMCode);
                    IF NOT CompressedChain.FINDFIRST THEN BEGIN
                        CompressedChain.RESET;
                        CompressedChain.INIT;
                        CompressedChain.TRANSFERFIELDS(RankChangeHistory);
                        CompressedChain.INSERT;
                    END;
                END;
            UNTIL RankChangeHistory.NEXT = 0;

        CompressedChain.RESET;
        CompressedChain.SETCURRENTKEY(MMCode, "Authorisation Date");
        IF CompressedChain.FINDSET THEN
            REPEAT
                ChainSubset2.RESET;
                ChainSubset2.SETCURRENTKEY(MMCode, "Authorisation Date");
                ChainSubset2.SETRANGE(MMCode, CompressedChain.MMCode);
                ChainSubset2.SETFILTER("Authorisation Date", '<=%1', PostingDate);
                IF ChainSubset2.FINDLAST THEN BEGIN
                    IF ChainSubset2."New Parent Code" = CompressedChain."New Parent Code" THEN BEGIN
                        IF Vend.GET(CompressedChain.MMCode) THEN BEGIN  //Added BEGIN and END 230622
                            IF Vend."BBG Date of Joining" <= PostingDate THEN BEGIN
                                ChainTopToBottom(CompressedChain.MMCode, PostingDate, TRUE);
                            END;
                        END;
                    END;
                END;
            UNTIL CompressedChain.NEXT = 0;
    end;


    procedure GetChain(var Vendor: Record Vendor temporary)
    begin
        ParentChain.COPY(Vendor, TRUE);
    end;


    procedure ValidCommStruc(InvestmentType: Option " ",RD,FD,MIS; Duration: Integer; BondType: Code[10]; PostingDate: Date; UnitPaymentPlan: Code[10]) Invalid: Boolean
    var
        InvType: Integer;
        ComissionStruc: Record "Commission Structure";
        ComissionStruc1: Record "Commission Structure";
        WEFDate: Date;
        Rank: Integer;
        i: Integer;
        ComType: Integer;
        BondSetup: Record "Unit Setup";
    begin
        BondSetup.GET;
        CASE InvestmentType OF
            InvestmentType::" ":
                EXIT(FALSE);
            InvestmentType::FD:
                InvType := 0;
            InvestmentType::MIS:
                InvType := 0;
            InvestmentType::RD:
                InvType := 1;
        END;

        Level1 := 0;

        ComissionStruc1.RESET;
        ComissionStruc1.SETCURRENTKEY("Rank Code", "Commission Type", Period, "Investment Type", "Starting Date");
        ComissionStruc1.SETRANGE(Period, Duration);
        ComissionStruc1.SETRANGE("Investment Type", InvType);
        ComissionStruc1.SETRANGE("Project Type", BondType);
        ComissionStruc1.SETFILTER("Starting Date", '<=%1', PostingDate);
        ComissionStruc1.SETRANGE("Unit Payment Plan", UnitPaymentPlan);  //071223
        //IF ComissionStruc1.FINDFIRST THEN  BBG1.00 120613
        IF ComissionStruc1.FINDLAST THEN
            Level1 := ComissionStruc1."Entry No.";


        ComissionStruc.SETCURRENTKEY("Rank Code", "Commission Type", Period, "Investment Type", "Starting Date");
        ComissionStruc.SETRANGE(Period, Duration);
        ComissionStruc.SETRANGE("Investment Type", InvType);
        ComissionStruc.SETRANGE("Project Type", BondType);
        ComissionStruc.SETFILTER("Starting Date", '<=%1', PostingDate);
        ComissionStruc.SETRANGE("Unit Payment Plan", UnitPaymentPlan);  //071223
        IF ComissionStruc.FINDLAST THEN
            WEFDate := ComissionStruc."Starting Date"
        ELSE
            EXIT(FALSE);
        ComissionStruc.SETFILTER("Starting Date", '%1', WEFDate);
        //BBG1.00 ALLEDK 090313
        //RankList.RESET;
        //IF RankList.FIND('-') THEN
        //  RankLevel := RankList.COUNT;
        //BBG1.00 ALLEDK 090313
        //FOR Rank := 1 TO RankLevel-1 DO BEGIN  //BBG1.00 ALLEDK 090313
        FOR Rank := Level1 TO ComissionStruc."Entry No." - 1 DO BEGIN
            //ComissionStruc.SETRANGE(ComissionStruc."Rank Code",Rank);  //BBG1.00 ALLEDK 090313
            ComissionStruc.SETRANGE(ComissionStruc."Entry No.", Rank);   //BBG1.00 ALLEDK 090313
            IF BondSetup."Bonus Calculation" THEN
                FOR ComType := 0 TO 1 DO BEGIN
                    ComissionStruc.SETRANGE("Commission Type", ComType);
                    IF ComissionStruc.ISEMPTY THEN
                        EXIT(FALSE);
                END
            ELSE BEGIN
                ComissionStruc.SETRANGE("Commission Type", 0);//ALLE PS
                IF ComissionStruc.ISEMPTY THEN
                    EXIT(FALSE);
            END;

            ComissionStruc.SETRANGE("Commission Type");
            IF InvType = 0 THEN BEGIN //FD-MIS
                ComissionStruc.SETRANGE(ComissionStruc."Year Code", 1);
                IF ComissionStruc.FINDSET THEN BEGIN
                    REPEAT
                        IF ComissionStruc."Commission %" <= 0 THEN
                            EXIT(FALSE);
                        IF (ComissionStruc."Commission Type" = ComissionStruc."Commission Type"::Commission) AND
                        (NOT ComissionStruc."TDS Applicable") THEN
                            EXIT(FALSE);
                        IF (ComissionStruc."Commission Type" = ComissionStruc."Commission Type"::Bonus) AND
                        (ComissionStruc."TDS Applicable") THEN
                            EXIT(FALSE);
                    UNTIL ComissionStruc.NEXT = 0;
                END ELSE
                    EXIT(FALSE);
            END ELSE
                IF InvType = 1 THEN BEGIN //RD
                    FOR i := 1 DOWNTO 0 DO BEGIN
                        IF (Duration = 12) AND (i = 0) THEN
                            EXIT(TRUE);
                        ComissionStruc.SETRANGE(ComissionStruc."Year Code", i);
                        IF ComissionStruc.FINDSET THEN BEGIN
                            REPEAT
                                IF ComissionStruc."Commission %" <= 0 THEN
                                    EXIT(FALSE);
                                IF (ComissionStruc."Commission Type" = ComissionStruc."Commission Type"::Commission) AND
                                (NOT ComissionStruc."TDS Applicable") THEN
                                    EXIT(FALSE);
                                IF (ComissionStruc."Commission Type" = ComissionStruc."Commission Type"::Bonus) AND
                                (ComissionStruc."TDS Applicable") THEN
                                    EXIT(FALSE);

                            UNTIL ComissionStruc.NEXT = 0;
                        END ELSE
                            EXIT(FALSE);
                    END;
                END;
        END;

        EXIT(TRUE);
    end;


    procedure "-ExistingBonus-"()
    begin
    end;


    procedure CalculateExistingBonus(BondNo: Code[20]; InstallmentNo: Integer; YearCode: Integer; InvestmentAmount: Decimal; MMCode: Code[10]; PostDate: Date; DocDate: Date; InvestmentType: Integer; Duration: Integer; BondType: Code[10]; BondCat: Option "A Type","B Type"; SchemeCode: Code[10]; Dim1Code: Code[10]; Dim2Code: Code[10]; ReceivedFromCode: Code[20]; UnitPaymentPlan: Code[10])
    var
        ComStructTemp: Record "Commission Structure" temporary;
        PrevRank: Integer;
        EntryNo: Integer;
    begin
        //Bonus Entry Creation for existing cheque entries
        InitChain;
        PrevRank := 0;

        ChainFromToUp(MMCode, PostDate, FALSE);
        UpdateChainRank(PostDate);

        ComStructTemp.RESET;
        ComStructTemp.DELETEALL;


        BuildBonusComissionStructure(1, YearCode, ComStructTemp, InvestmentType, Duration, BondType, PostDate, UnitPaymentPlan);  //071223

        ParentChain.SETCURRENTKEY("BBG Rank Code");
        IF ParentChain.FINDSET THEN BEGIN
            EntryNo := GetLastEntryNoTempBonus;
            REPEAT
                TempBonusEntry.INIT;
                TempBonusEntry."Entry No." := EntryNo;

                EntryNo += 1;
                TempBonusEntry."Unit No." := BondNo;
                TempBonusEntry."Posting Date" := PostDate;//WORKDATE;
                TempBonusEntry."Associate Code" := ParentChain."No.";
                TempBonusEntry."Base Amount" := InvestmentAmount;
                TempBonusEntry."Bonus %" := CalculateBonusCommissionPct(ComStructTemp, PrevRank, ParentChain."BBG Rank Code", UnitPaymentPlan);  //071223
                PrevRank := ParentChain."BBG Rank Code" + 1;
                TempBonusEntry."Bonus Amount" := ROUND(TempBonusEntry."Base Amount" * (TempBonusEntry."Bonus %" / 100));
                TempBonusEntry."Installment No." := InstallmentNo; //ComPostingBuffer."Installment No.";
                TempBonusEntry."Bond Category" := BondCat;
                IF MMCode = ParentChain."No." THEN
                    TempBonusEntry."Business Type" := TempBonusEntry."Business Type"::SELF
                ELSE
                    TempBonusEntry."Business Type" := TempBonusEntry."Business Type"::CHAIN;
                TempBonusEntry."Introducer Code" := MMCode;
                TempBonusEntry."Scheme Code" := SchemeCode;
                TempBonusEntry."Project Type" := BondType;

                TempBonusEntry.Duration := Duration;
                TempBonusEntry."Shortcut Dimension 1 Code" := Dim1Code;
                TempBonusEntry."Shortcut Dimension 2 Code" := Dim2Code;
                TempBonusEntry."Associate Rank" := ParentChain."BBG Rank Code";
                TempBonusEntry."Pmt Received From Code" := ReceivedFromCode;
                TempBonusEntry."Document Date" := DocDate;
                TempBonusEntry.INSERT;
            UNTIL ParentChain.NEXT = 0;
        END;
    end;


    procedure CalcTDSPercentage()
    var
        AllowedSection: Record "Allowed Sections";
        CodeunitEventMgt: Codeunit "BBG Codeunit Event Mgnt.";
    begin
        TDSPercentage := 0;
        //IF Vendor.GET(ParentChain."No.") THEN;
        IF Vendor.Get(ParentChain."No.") Then begin
            AllowedSection.Reset();
            AllowedSection.SetRange("Vendor No", Vendor."No.");
            AllowedSection.SetRange("TDS Section", UnitSetup."TDS Nature of Deduction INCT");
            IF AllowedSection.FindFirst() then begin
                TDSPercentage := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
            end;
        end;
        /*        
        IF NODNOCHdr.GET(NODNOCHdr.Type::Vendor, ParentChain."No.") THEN;
        UnitSetup.GET;
        TDSSetup.RESET;
        TDSSetup.SETRANGE("TDS Nature of Deduction", UnitSetup."TDS Nature of Deduction");
        TDSSetup.SETRANGE("Assessee Code", NODNOCHdr."Assesse Code");
        TDSSetup.SETRANGE("Effective Date", 0D, WORKDATE);
        NODLines.RESET;
        NODLines.SETRANGE(Type, NODLines.Type::Vendor);
        NODLines.SETRANGE("No.", ParentChain."No.");
        NODLines.SETRANGE("NOD/NOC", UnitSetup."TDS Nature of Deduction INCT");
        IF NODLines.FIND('-') THEN BEGIN
            IF NODLines."Concessional Code" <> '' THEN
                TDSSetup.SETRANGE("Concessional Code", NODLines."Concessional Code")
            ELSE
                TDSSetup.SETRANGE("Concessional Code", '');
            IF NOT TDSSetup.FIND('+') THEN BEGIN
                TDSPercentage := 0;
            END ELSE BEGIN
                IF (Vendor."P.A.N. Status" = Vendor."P.A.N. Status"::" ") AND (Vendor."P.A.N. No." <> '') THEN BEGIN
                    IF Vend."206AB" THEN   //ALLEDK 020721
                        TDSPercentage := TDSSetup."206AB %"    //ALLEDK 020721
                    ELSE
                        TDSPercentage := TDSSetup."TDS %"
                END ELSE
                    TDSPercentage := TDSSetup."Non PAN TDS %";
            END;
        END ELSE
            ERROR('TDS Setup not define');
            *///Need to check the code in UAT

    end;


    procedure CheckBSP2fullAmount()
    begin
    end;


    procedure CalculateComissionTemp(var ComPostingBuffer: Record "Unit & Comm. Creation Buffer")
    var
        ComStructTemp: Record "Commission Structure" temporary;
        PrevRank: Decimal;
        CommissionEntry: Record "Commission Eligibility Temp";
        EntryNo: Integer;
        InvestmentType: Integer;
        BondNo: Code[20];
        Application: Record Application;
        PostingDate: Date;
        PPLANCode: Code[10];
    begin
        IF ComPostingBuffer."Min. Allotment Amount Not Paid" <> TRUE THEN BEGIN
            //Commission Entry Creation
            InitChain;
            PrevRank := 0;
            BondNo := ComPostingBuffer."Unit No.";
            Bond.GET(BondNo);
            //  PostingDate := ComPostingBuffer."Posting Date";
            PostingDate := Bond."Posting Date"; //BBG1.00 280413
            AppPostingDate := Bond."Posting Date";
            ChainFromToUp(ComPostingBuffer."Introducer Code", PostingDate, ComPostingBuffer."Direct Associate");
            UpdateChainRank(PostingDate);

            ComStructTemp.RESET;
            ComStructTemp.DELETEALL;
            CASE ComPostingBuffer."Investment Type" OF
                ComPostingBuffer."Investment Type"::FD:
                    InvestmentType := 0;
                ComPostingBuffer."Investment Type"::MIS:
                    InvestmentType := 0;
                ComPostingBuffer."Investment Type"::RD:
                    InvestmentType := 1;
            END;

            PPLANCode := '';
            PPLANCode := ReleaseUnitApplication.CheckUnitPaymentPlan(Bond."Shortcut Dimension 1 Code", Bond."No.", FALSE);  //071223
            BuildBonusComissionStructure(0, ComPostingBuffer."Year Code", ComStructTemp,
              InvestmentType, Bond.Duration, Bond."Project Type", PostingDate, PPLANCode);  //071223

            EntryNo := GetLastEntryNoforTemp;
            UnitSetup.GET;
            ParentChain.SETCURRENTKEY("BBG Rank Code");
            IF ParentChain.FINDSET THEN
                REPEAT
                    IF ParentChain."BBG Rank Code" <= UnitSetup."Hierarchy Head" THEN BEGIN //ALLEDK 301112
                        CommissionEntry.INIT;
                        CommissionEntry."Entry No." := EntryNo;
                        CommissionEntry.VALIDATE("Application No.", ComPostingBuffer."Unit No.");
                        CommissionEntry."Posting Date" := ComPostingBuffer."Posting Date";
                        CommissionEntry."Associate Code" := ParentChain."No.";
                        CommissionEntry."Base Amount" := ComPostingBuffer."Base Amount";
                        IF ComPostingBuffer."Direct Associate" THEN BEGIN  //ALLEDK 011212
                            CommissionEntry."Commission Amount" := ROUND(CommissionEntry."Base Amount");
                            CommissionEntry."Direct to Associate" := ComPostingBuffer."Direct Associate";
                            //  CommissionEntry."Remaining Amt of Direct" := TRUE;
                        END ELSE BEGIN
                            PPLANCode := '';
                            PPLANCode := ReleaseUnitApplication.CheckUnitPaymentPlan(Bond."Shortcut Dimension 1 Code", Bond."No.", FALSE);  //071223
                            CommissionEntry."Commission %" := CalculateBonusCommissionPct(ComStructTemp, PrevRank, ParentChain."BBG Rank Code", PPLANCode); //071223
                            CommissionEntry."Commission Amount" := ROUND(CommissionEntry."Base Amount" * (CommissionEntry."Commission %" / 100));
                            CommissionEntry."Direct to Associate" := ComPostingBuffer."Direct Associate";
                            CommissionEntry."Remaining Amt of Direct" := FALSE;
                        END;
                        CommissionEntry."Installment No." := ComPostingBuffer."Installment No.";
                        CommissionEntry."Bond Category" := Bond."Bond Category";
                        IF Bond."Introducer Code" = ParentChain."No." THEN
                            CommissionEntry."Business Type" := CommissionEntry."Business Type"::SELF
                        ELSE
                            CommissionEntry."Business Type" := CommissionEntry."Business Type"::CHAIN;
                        CommissionEntry."Introducer Code" := Bond."Introducer Code";
                        CommissionEntry."Scheme Code" := Bond."Scheme Code";
                        CommissionEntry."Project Type" := Bond."Project Type";
                        CommissionEntry.Duration := ComPostingBuffer.Duration;
                        CommissionEntry."Shortcut Dimension 1 Code" := ComPostingBuffer."Shortcut Dimension 1 Code";  //ALLEDK 040113
                        CommissionEntry."Associate Rank" := ParentChain."BBG Rank Code";
                        IF ComPostingBuffer."Year Code" = 1 THEN
                            CommissionEntry."First Year" := TRUE
                        ELSE
                            CommissionEntry."First Year" := FALSE;
                        //CalcTDSPercentage; ALLEDK 141212
                        CommissionEntry.INSERT;

                        BSp2Amt := 0;
                        //ALLEDK 201212
                        IF CommissionEntry."Direct to Associate" THEN BEGIN
                            PaymentTermsLineSale.RESET;
                            PaymentTermsLineSale.SETRANGE("Document No.", CommissionEntry."Application No.");
                            PaymentTermsLineSale.SETRANGE("Direct Associate", TRUE);
                            IF PaymentTermsLineSale.FINDFIRST THEN BEGIN
                                REPEAT
                                    PaymentTermsLineSale.CALCFIELDS("Received Amt");
                                    IF ROUND(PaymentTermsLineSale."Received Amt", 1, '=') >= PaymentTermsLineSale."Due Amount" THEN BEGIN
                                        CommEntry.RESET;
                                        CommEntry.SETRANGE("Application No.", CommissionEntry."Application No.");
                                        CommEntry.SETRANGE("Direct to Associate", TRUE);
                                        IF CommEntry.FINDSET THEN
                                            REPEAT
                                                CommEntry."Remaining Amt of Direct" := FALSE;
                                                CommEntry.MODIFY;
                                            UNTIL CommEntry.NEXT = 0;
                                    END ELSE BEGIN
                                        CommissionEntry."Remaining Amt of Direct" := TRUE;
                                        CommissionEntry.MODIFY;
                                    END;
                                UNTIL PaymentTermsLineSale.NEXT = 0;
                            END;
                        END;
                        //ALLEDK 201212


                        //ALLEDK 201212
                        PrevRank := ParentChain."BBG Rank Code" + 0.0001; //BBG1.00 090313
                        EntryNo += 1;
                    END;   //ALLEDK 301112
                UNTIL ParentChain.NEXT = 0;

            //  ComPostingBuffer."Commission Created" := TRUE;
            //  ComPostingBuffer.MODIFY;
        END;
    end;


    procedure GetLastEntryNoforTemp(): Integer
    var
        CommEnt: Record "Commission Eligibility Temp";
        CommEntPosted: Record "Commission Entry Posted";
        EntNo: Integer;
    begin
        IF CommEntPosted.FINDLAST THEN
            EntNo := CommEntPosted."Entry No.";

        IF CommEnt.FINDLAST THEN
            IF CommEnt."Entry No." > EntNo THEN
                EntNo := CommEnt."Entry No.";

        EXIT(EntNo + 1);
    end;


    procedure GetLastTemHierarcy(var AppCode: Code[20]): Integer
    var
        LastEntNo: Integer;
        AssHierarcywithApp: Record "Associate Hierarcy with App.";
    begin
        AssHierarcywithApp.RESET;
        AssHierarcywithApp.SETRANGE("Application Code", AppCode);
        IF AssHierarcywithApp.FINDLAST THEN
            LastEntNo := AssHierarcywithApp."Line No.";

        AssHierarcywithApp.RESET;
        AssHierarcywithApp.SETRANGE("Application Code", AppCode);
        IF AssHierarcywithApp.FINDLAST THEN
            IF AssHierarcywithApp."Line No." > LastEntNo THEN
                LastEntNo := AssHierarcywithApp."Line No.";

        EXIT(LastEntNo + 1);
    end;


    procedure UpdateChainRankTemp(EffectiveDate: Date)
    begin
        IF ParentChain.FINDSET THEN
            REPEAT
                ParentChain."BBG Rank Code" := PresentRank(ParentChain."No.", EffectiveDate);
                ParentChain.MODIFY;
            UNTIL ParentChain.NEXT = 0;
    end;


    procedure CalculateComissionNew(var ComPostingBuffer: Record "Unit & Comm. Creation Buffer"; CommissionBatchDate: Date)
    var
        ComStructTemp: Record "Commission Structure" temporary;
        PrevRank: Decimal;
        CommissionEntry: Record "Commission Entry";
        EntryNo: Integer;
        InvestmentType: Integer;
        BondNo: Code[20];
        Application: Record Application;
        PostingDate: Date;
        CommissionStructrAmountBase: Record "Commission Structr Amount Base";
        MinAmt: Decimal;
        CheckCommAmount: Decimal;
        CommissionEntry_P: Record "Commission Entry";
        AssHierarcywithApplication_2: Record "Associate Hierarcy with App.";
    begin
        IF ComPostingBuffer."Min. Allotment Amount Not Paid" <> TRUE THEN BEGIN
            BondNo := ComPostingBuffer."Unit No.";
            Bond.GET(BondNo);
            PostingDate := Bond."Posting Date";  //BBG1.00 280413
            AppPostingDate := Bond."Posting Date";
            EntryNo := GetLastEntryNo;
            UnitSetup.GET;
            AssociateHierarcywithApp.RESET;
            AssociateHierarcywithApp.SETCURRENTKEY("Rank Code", "Application Code");
            AssociateHierarcywithApp.SETRANGE("Application Code", ComPostingBuffer."Unit No.");
            IF ComPostingBuffer."Direct Associate" THEN
                AssociateHierarcywithApp.SETRANGE("Associate Code", Bond."Introducer Code");
            AssociateHierarcywithApp.SETRANGE(Status, AssociateHierarcywithApp.Status::Active);
            IF AssociateHierarcywithApp.FINDSET THEN
                REPEAT
                    IF AssociateHierarcywithApp."Rank Code" <= UnitSetup."Hierarchy Head" THEN BEGIN //ALLEDK 301112
                        CommissionEntry.INIT;
                        CommissionEntry."Entry No." := EntryNo;
                        CommissionEntry.VALIDATE("Application No.", ComPostingBuffer."Unit No.");
                        CommissionEntry."Posting Date" := ComPostingBuffer."Posting Date";
                        CommissionEntry."Associate Code" := AssociateHierarcywithApp."Associate Code";
                        CommissionEntry."Base Amount" := ComPostingBuffer."Base Amount";
                        IF ComPostingBuffer."Direct Associate" THEN BEGIN  //ALLEDK 011212
                            CommissionEntry."Commission Amount" := ROUND(CommissionEntry."Base Amount");
                            CommissionEntry."Direct to Associate" := ComPostingBuffer."Direct Associate";
                            //  CommissionEntry."Remaining Amt of Direct" := TRUE;
                        END ELSE BEGIN
                            CommissionEntry."Commission %" := AssociateHierarcywithApp."Commission %";
                            CommissionEntry."Commission Amount" := ROUND(CommissionEntry."Base Amount" * (CommissionEntry."Commission %" / 100));
                            CommissionEntry."Direct to Associate" := ComPostingBuffer."Direct Associate";
                            CommissionEntry."Remaining Amt of Direct" := FALSE;
                        END;
                        CommissionEntry."Installment No." := ComPostingBuffer."Installment No.";
                        CommissionEntry."Bond Category" := Bond."Bond Category";
                        IF Bond."Introducer Code" = AssociateHierarcywithApp."Associate Code" THEN
                            CommissionEntry."Business Type" := CommissionEntry."Business Type"::SELF
                        ELSE
                            CommissionEntry."Business Type" := CommissionEntry."Business Type"::CHAIN;
                        //230425 Added new commission Str Base amount start
                        IF NOT ComPostingBuffer."Direct Associate" THEN BEGIN
                            CommissionStructrAmountBase.RESET;
                            CommissionStructrAmountBase.SETRANGE("Project Code", Bond."Shortcut Dimension 1 Code");
                            CommissionStructrAmountBase.SETRANGE("Payment Plan Code", Bond."Unit Payment Plan");
                            CommissionStructrAmountBase.SETFILTER("Start Date", '<=%1', Bond."Posting Date");
                            CommissionStructrAmountBase.SETFILTER("End Date", '>=%1', Bond."Posting Date");
                            CommissionStructrAmountBase.SETRANGE("Desg. Code", 0, AssociateHierarcywithApp."Rank Code");
                            CommissionStructrAmountBase.SetRange("Rank Code", Bond."Region Code");  //Code added 01072025
                            IF CommissionStructrAmountBase.FINDLAST THEN BEGIN  //3010
                                MinAmt := 0;
                                MinAmt := UnitandCommCreationJob.CheckMinAmount(Today, Bond."Introducer Code", Bond."No.");  //Bond."Posting Date" 240425 chang with Today

                                // IF (MinAmt >= Bond."Min. Allotment Amount") AND (MinAmt < Bond.Amount) THEN BEGIN
                                // CheckCommAmount := 0;
                                // CommissionEntry_P.RESET;
                                // CommissionEntry_P.SETRANGE("Application No.", Bond."No.");
                                // CommissionEntry_P.SETRANGE("Associate Code", AssociateHierarcywithApp."Associate Code");
                                // IF CommissionEntry_P.FINDSET THEN
                                //     REPEAT
                                //         CheckCommAmount := CheckCommAmount + CommissionEntry_P."Commission Amount";
                                //     UNTIL CommissionEntry_P.NEXT = 0;
                                //IF CheckCommAmount = 0 THEN BEGIN
                                CommissionEntry."Commission Amount" := CalculateCommissionAmount(Bond, AssociateHierarcywithApp, CommissionEntry."Base Amount", FALSE, FALSE);


                                //END;
                                // END ELSE IF MinAmt >= Bond.Amount THEN BEGIN
                                //     CommissionEntry."Commission Amount" := CalculateCommissionAmount(Bond, AssociateHierarcywithApp, CommissionEntry."Base Amount", TRUE, FALSE);
                                // CheckCommAmount := 0;
                                // CommissionEntry_P.RESET;
                                // CommissionEntry_P.SETRANGE("Application No.", Bond."No.");
                                // CommissionEntry_P.SETRANGE("Associate Code", AssociateHierarcywithApp."Associate Code");
                                // IF CommissionEntry_P.FINDSET THEN
                                //     REPEAT
                                //         CheckCommAmount := CheckCommAmount + CommissionEntry_P."Commission Amount";
                                //     UNTIL CommissionEntry_P.NEXT = 0;
                                // IF CheckCommAmount > 0 THEN BEGIN
                                //     CommissionEntry."Commission Amount" := CalculateCommissionAmount(Bond, AssociateHierarcywithApp, CommissionEntry."Base Amount", TRUE, FALSE);
                                //     CommissionEntry."Base Amount" := (Bond.Amount - Bond."Min. Allotment Amount");
                                // END ELSE BEGIN
                                //     CommissionEntry."Commission Amount" := CalculateCommissionAmount(Bond, AssociateHierarcywithApp, CommissionEntry."Base Amount", TRUE, TRUE);
                                //     CommissionEntry."Base Amount" := Bond.Amount;
                                // END;
                                // END;
                            END;
                        END;

                        //230425 Added new commission Str Base amount END





                        CommissionEntry."Introducer Code" := Bond."Introducer Code";
                        CommissionEntry."Scheme Code" := Bond."Scheme Code";
                        CommissionEntry."Project Type" := Bond."Project Type";
                        CommissionEntry.Duration := ComPostingBuffer.Duration;
                        CommissionEntry."Commission Run Date" := CommissionBatchDate;
                        CommissionEntry."Shortcut Dimension 1 Code" := ComPostingBuffer."Shortcut Dimension 1 Code";  //INS1.0
                        CommissionEntry."Associate Rank" := AssociateHierarcywithApp."Rank Code";
                        CommissionEntry."Opening Entries" := ComPostingBuffer."Opening Commision Adj."; //BBG1.00 290413
                        CommissionEntry.Posted := ComPostingBuffer."Opening Commision Adj."; //BBG1.00 290413
                        CommissionEntry."Charge Code" := ComPostingBuffer."Charge Code";
                        CommissionEntry."Unit Payment Line No." := ComPostingBuffer."Unit Payment Line No.";
                        //Code added Start 01072025 
                        IF (CommissionEntry."Commission %" = 0) AND (NOT CommissionEntry."Direct to Associate") THEN begin
                            AssHierarcywithApplication_2.RESET;
                            AssHierarcywithApplication_2.SetRange(AssHierarcywithApplication_2."Application Code", AssociateHierarcywithApp."Application Code");
                            AssHierarcywithApplication_2.SETRANGE("Associate code", AssociateHierarcywithApp."Associate Code");
                            AssHierarcywithApplication_2.SETRANGE(Status, AssHierarcywithApplication_2.Status::Active);
                            AssHierarcywithApplication_2.SetFilter("Commission %", '<>%1', 0);
                            IF AssHierarcywithApplication_2.FindFirst() THEN BEGIN
                                CommissionEntry."Commission %" := AssHierarcywithApplication_2."Commission %";
                            END;
                        end;
                        //Code added End 01072025 

                        IF ComPostingBuffer."Year Code" = 1 THEN
                            CommissionEntry."First Year" := TRUE
                        ELSE
                            CommissionEntry."First Year" := FALSE;
                        CommissionEntry."Registration Bonus Hold(BSP2)" := TRUE;
                        //CalcTDSPercentage; ALLEDK 141212
                        CommissionEntry.INSERT;

                        BSp2Amt := 0;
                        //ALLEDK 201212
                        IF CommissionEntry."Direct to Associate" THEN BEGIN
                            PaymentTermsLineSale.RESET;
                            PaymentTermsLineSale.SETRANGE("Document No.", CommissionEntry."Application No.");
                            PaymentTermsLineSale.SETRANGE("Direct Associate", TRUE);
                            IF PaymentTermsLineSale.FINDFIRST THEN BEGIN
                                REPEAT
                                    PaymentTermsLineSale.CALCFIELDS("Received Amt");
                                    //IF ROUND(PaymentTermsLineSale."Received Amt",1,'=') >= PaymentTermsLineSale."Due Amount" THEN BEGIN
                                    IF ABS(PaymentTermsLineSale."Due Amount" - ROUND(PaymentTermsLineSale."Received Amt", 1)) <= 1 THEN BEGIN
                                        CommEntry.RESET;
                                        CommEntry.SETRANGE("Application No.", CommissionEntry."Application No.");
                                        CommEntry.SETRANGE("Direct to Associate", TRUE);
                                        IF CommEntry.FINDSET THEN
                                            REPEAT
                                                CommEntry."Remaining Amt of Direct" := FALSE;
                                                CommEntry.MODIFY;
                                            UNTIL CommEntry.NEXT = 0;
                                    END ELSE BEGIN
                                        CommissionEntry."Remaining Amt of Direct" := TRUE;
                                        CommissionEntry.MODIFY;
                                    END;
                                UNTIL PaymentTermsLineSale.NEXT = 0;
                            END;
                        END;
                        //ALLEDK 201212
                        //           PrevRank := AssociateHierarcywithApp."Rank Code" + 0.0001; //BBG1.00 090313
                        EntryNo += 1;
                    END;   //ALLEDK 301112
                UNTIL AssociateHierarcywithApp.NEXT = 0;

            ComPostingBuffer."Commission Created" := TRUE;
            ComPostingBuffer.MODIFY;
        END;
    end;


    procedure InsertVendorTree(var VendorI: Record Vendor; EffDate: Date)
    var
        ComStructTemp: Record "Commission Structure" temporary;
        PrevRank: Decimal;
        AssHierarcywithApp: Record "Associate Hierarcy with App.";
        LastLineNo: Integer;
        InvestmentType: Integer;
        BondNo: Code[20];
        Application: Record Application;
        PostingDate: Date;
        VendTree: Record "Vendor Tree";
        VendTree2: Record "Vendor Tree";
    begin
        InitChain;
        PrevRank := 0;
        //BondNo := ConfirmedOrder."No.";
        //Bond.GET(ConfirmedOrder."No.");
        //PostingDate := ConfirmedOrder."Posting Date";  //BBG1.00 280413
        //AppPostingDate := ConfirmedOrder."Posting Date";
        //ChainFromToUp(ConfirmedOrder."Introducer Code",PostingDate,FALSE);
        VendTree2.RESET;
        VendTree2.SETRANGE("Introducer Code", VendorI."No.");
        VendTree2.SETRANGE("Effective Date", EffDate);
        IF VendTree2.FINDSET THEN
            VendTree2.DELETEALL;

        CLEAR(VendTree2);
        VendTree2.RESET;
        VendTree2.SETRANGE("Introducer Code", VendorI."No.");
        VendTree2.SETRANGE(Status, VendTree2.Status::Active);
        IF VendTree2.FINDSET THEN
            REPEAT
                VendTree2.Status := VendTree2.Status::"In-Active";
                VendTree2.MODIFY;
            UNTIL VendTree2.NEXT = 0;

        ChainFromToUp(VendorI."No.", EffDate, FALSE);
        UpdateChainRankTemp(EffDate);

        //ComStructTemp.RESET;
        //ComStructTemp.DELETEALL;
        //BuildBonusComissionStructure(0,1,ComStructTemp,
        //0,Bond.Duration,Bond."Project Type",PostingDate);

        //LastLineNo := GetLastTemHierarcy(ConfirmedOrder."No.");
        LastLineNo := 10000;
        UnitSetup.GET;
        ParentChain.SETCURRENTKEY("BBG Rank Code");
        IF ParentChain.FINDSET THEN
            REPEAT
                //IF ParentChain."Rank Code" <= UnitSetup."Hierarchy Head" THEN BEGIN //ALLEDK 301112
                VendTree.INIT;
                VendTree."Introducer Code" := VendorI."No.";
                VendTree."Associate Code" := ParentChain."No.";
                VendTree."Line No." := LastLineNo;
                VendTree."Effective Date" := EffDate;
                //AssHierarcywithApp."Associate Code" := ParentChain."No.";
                //AssHierarcywithApp."Introducer Code" := ConfirmedOrder."Introducer Code";
                VendTree."Parent Code" := ParentChain."BBG Parent Code";
                //AssHierarcywithApp."Project Code" := ConfirmedOrder."Shortcut Dimension 1 Code";
                //AssHierarcywithApp."Travel Generated" := ConfirmedOrder."Travel Generate";
                VendTree."Rank Code" := ParentChain."BBG Rank Code";
                VendTree."Associate Name" := ParentChain.Name;
                IF RecRank.GET(ParentChain."BBG Rank Code") THEN
                    VendTree."Rank Description" := RecRank.Description;
                /*
                IF ParentChain."Rank Code" <= UnitSetup."Hierarchy Head" THEN
                  AssHierarcywithApp."Commission %" := CalculateBonusCommissionPct(ComStructTemp,PrevRank,ParentChain."Rank Code")
                ELSE
                  AssHierarcywithApp."Commission %" := 0;
                */
                VendTree.INSERT;
                //PrevRank := ParentChain."Rank Code" + 0.0001; //BBG1.00 090313
                LastLineNo += 10000;
            // END;   //ALLEDK 301112
            UNTIL ParentChain.NEXT = 0;

    end;


    procedure NewInsertTeamHierarcy(var ConfirmedOrder: Record "Confirmed Order"; RegionCode: Code[10]; TravelGen: Boolean; FromProjectChange: Boolean)
    var
        ComStructTemp: Record "Commission Structure" temporary;
        PrevRank: Decimal;
        AssHierarcywithApp: Record "Associate Hierarcy with App.";
        LastLineNo: Integer;
        InvestmentType: Integer;
        BondNo: Code[20];
        Application: Record Application;
        PostingDate: Date;
        CommissionStructrAmountBase: Record "Commission Structr Amount Base";
        v_DocumentMaster: Record "Document Master";
        OtherRate: Decimal;
        PPLANCode: Code[10];
    begin
        NewInitChain;
        PrevRank := 0;
        BondNo := ConfirmedOrder."No.";
        Bond.GET(ConfirmedOrder."No.");
        PostingDate := ConfirmedOrder."Posting Date";  //BBG1.00 280413
        AppPostingDate := ConfirmedOrder."Posting Date";
        NewChainFromToUp(ConfirmedOrder."Introducer Code", PostingDate, FALSE, RegionCode);
        NewUpdateChainRankTemp(PostingDate, RegionCode);

        ComStructTemp.RESET;
        ComStructTemp.DELETEALL;

        PPLANCode := '';
        PPLANCode := ReleaseUnitApplication.CheckUnitPaymentPlan(Bond."Shortcut Dimension 1 Code", Bond."No.", FromProjectChange); //071223
        BuildBonusComissionStructure(0, 1, ComStructTemp,
          0, Bond.Duration, Bond."Project Type", PostingDate, PPLANCode); //071223

        LastLineNo := GetLastTemHierarcy(ConfirmedOrder."No.");
        UnitSetup.GET;
        NewParentChain.SETCURRENTKEY("Rank Code");
        IF NewParentChain.FINDSET THEN
            REPEAT
                //IF ParentChain."Rank Code" <= UnitSetup."Hierarchy Head" THEN BEGIN //ALLEDK 301112
                AssHierarcywithApp.INIT;
                AssHierarcywithApp."Application Code" := ConfirmedOrder."No.";
                AssHierarcywithApp."Line No." := LastLineNo;
                AssHierarcywithApp."Posting Date" := ConfirmedOrder."Posting Date";
                AssHierarcywithApp."Associate Code" := NewParentChain."No.";
                AssHierarcywithApp."Introducer Code" := ConfirmedOrder."Introducer Code";
                AssHierarcywithApp."Parent Code" := NewParentChain."Parent Code";
                AssHierarcywithApp."Project Code" := ConfirmedOrder."Shortcut Dimension 1 Code";
                AssHierarcywithApp."Travel Generated" := TravelGen; //ConfirmedOrder."Travel Generate";

                AssHierarcywithApp."Rank Code" := NewParentChain."Rank Code";
                AssHierarcywithApp."Associate Name" := NewParentChain.Name;
                PPLANCode := '';
                PPLANCode := ReleaseUnitApplication.CheckUnitPaymentPlan(ConfirmedOrder."Shortcut Dimension 1 Code", ConfirmedOrder."No.", FromProjectChange); //071223
                IF NewRecRank.GET(RegionCode, NewParentChain."Rank Code") THEN
                    AssHierarcywithApp."Rank Description" := NewRecRank.Description;
                IF NewParentChain."Rank Code" <= UnitSetup."Hierarchy Head" THEN
                    AssHierarcywithApp."Commission %" := CalculateBonusCommissionPct(ComStructTemp, PrevRank, NewParentChain."Rank Code", PPLANCode)   //071223 -1
                ELSE
                    AssHierarcywithApp."Commission %" := 0;
                //AssHierarcywithApp."Commission Structure Amount" := CalculateCommissionAmount(ConfirmedOrder,AssHierarcywithApp,FALSE,FALSE); // 251023

                AssHierarcywithApp."Region/Rank Code" := RegionCode;
                AssHierarcywithApp."Company Name" := COMPANYNAME;
                AssHierarcywithApp.INSERT;
                PrevRank := NewParentChain."Rank Code" + 0.0001; //BBG1.00 090313
                LastLineNo += 1;
                // END;   //ALLEDK 301112
                NewAssociateHierwithAppl.INIT;
                NewAssociateHierwithAppl.TRANSFERFIELDS(AssHierarcywithApp);
                NewAssociateHierwithAppl.INSERT;

            UNTIL NewParentChain.NEXT = 0;


    end;


    procedure NewInitChain()
    begin
        NewParentChain.RESET;
        NewParentChain.DELETEALL;
    end;


    procedure NewChainFromToUp(MMCode: Code[20]; PostingDate: Date; DirectAss: Boolean; RegionCode: Code[10])
    begin
        NewVend.GET(RegionCode, MMCode);
        NewParentChain.INIT;
        NewParentChain.TRANSFERFIELDS(NewVend);
        NewParentChain.INSERT;

        IF NOT DirectAss THEN BEGIN
            NewVend."Parent Code" := NewParentChange(MMCode, PostingDate, RegionCode);
            NewParentChain."Parent Code" := NewVend."Parent Code"; //ALLETDK 2312
            NewParentChain.MODIFY;                              //ALLETDK 2312
            NewRankList.RESET;
            NewRankList.SETRANGE("Rank Batch Code", RegionCode);
            IF NewRankList.FIND('-') THEN
                RankLevel := NewRankList.COUNT;

            IF (NewVend."Parent Code" = '') OR (NewVend."Rank Code" = RankLevel - 1) THEN //ALLE PS
                EXIT;
            NewChainFromToUp(NewVend."Parent Code", PostingDate, DirectAss, RegionCode);
        END
        ELSE
            EXIT;
    end;


    procedure NewUpdateChainRankTemp(EffectiveDate: Date; RegionCode: Code[10])
    begin
        IF NewParentChain.FINDSET THEN
            REPEAT
                NewParentChain."Rank Code" := NewPresentRank(NewParentChain."No.", EffectiveDate, RegionCode);
                NewParentChain.MODIFY;
            UNTIL NewParentChain.NEXT = 0;
    end;


    procedure NewParentChange(MemberNo: Code[20]; EffectiveDate: Date; RegionCode: Code[10]): Code[20]
    var
        RankHistory: Record "Rank Change History";
        NewMM: Record "Region wise Vendor";
    begin
        RankHistory.SETCURRENTKEY(MMCode, "Authorisation Date");
        RankHistory.SETRANGE("Rank Code", RegionCode);
        RankHistory.SETRANGE(MMCode, MemberNo);
        IF RankHistory.FINDSET THEN
            REPEAT
                IF (RankHistory."Old Parent Code" <> '') AND (RankHistory."Old Parent Code" <> RankHistory."New Parent Code")
                //AND (RankHistory."Authorisation Date" > AppPostingDate) THEN //ALLETDK 2312
                AND (RankHistory."Authorisation Date" > EffectiveDate) THEN //ALLETDK 2312
                    EXIT(RankHistory."Old Parent Code");
            UNTIL RankHistory.NEXT = 0;
        NewMM.GET(RegionCode, MemberNo);
        EXIT(NewMM."Parent Code");
    end;


    procedure NewPresentRank(MemberNo: Code[20]; EffectiveDate: Date; RegionCode: Code[10]): Decimal
    var
        RankHistory: Record "Rank Change History";
        NewMM: Record "Region wise Vendor";
        RH: Record "Rank Change History";
        RH1: Record "Rank Change History";
    begin
        RankHistory.SETCURRENTKEY(MMCode, "Authorisation Date");
        RankHistory.SETRANGE("Rank Code", RegionCode);
        RankHistory.SETRANGE(MMCode, MemberNo);
        RankHistory.SETFILTER("Authorisation Date", '>%1', EffectiveDate);
        IF RankHistory.FINDFIRST THEN
            //IF (RankHistory."Previous Rank" <> 0) AND (RankHistory."Previous Rank" <> RankHistory."New Rank") THEN
            //EXIT(RankHistory."Previous Rank");
            //ALLETDK>>>>
            RH.RESET;
        RH.SETRANGE("Rank Code", RegionCode);
        RH.SETRANGE(MMCode, MemberNo);
        RH.SETRANGE("Authorisation Date", RankHistory."Authorisation Date");
        IF RH.FINDLAST THEN BEGIN

            RH1.RESET;
            RH1.SETRANGE("Rank Code", RegionCode);
            RH1.SETRANGE(MMCode, MemberNo);
            RH1.SETRANGE("Authorisation Date", RH."Authorisation Date");
            RH1.SETRANGE("New Rank", RH."New Rank");
            RH1.SETFILTER("Entry No", '<>%1', RH."Entry No");
            IF RH1.FINDFIRST THEN
                EXIT(RH1."Previous Rank");

            IF (RH."Previous Rank" <> 0) AND (RH."Previous Rank" <> RH."New Rank") THEN
                EXIT(RH."Previous Rank");
            IF RH."Previous Rank" = RH."New Rank" THEN
                EXIT(RH."Previous Rank");
        END;
        //ALLETDK<<<
        NewMM.GET(RegionCode, MemberNo);
        EXIT(NewMM."Rank Code");
    end;


    procedure NewUpdateTEAMHierarcy(var RecConfirmedOrder: Record "Confirmed Order"; FromProjectChange: Boolean)
    var
        Change: Boolean;
        "Associate Hierarcy with App": Record "Associate Hierarcy with App.";
        AssHierarcywithApp: Record "Associate Hierarcy with App.";
        unitpost: Codeunit "Unit Post";
        RecJob: Record Job;
        Region_RankwiseVendor: Record "Region wise Vendor";
        Vendor_4: Record Vendor;
        RankRegionCode: Code[10];
    begin

        //060924 Code Added Start
        RankRegionCode := '';
        //RankRegionCode := RecJob."Region Code for Rank Hierarcy";  //Code comment 01072025
        RankRegionCode := RecConfirmedOrder."Region Code";   //Code Added 01072025

        Vendor_4.RESET;
        IF Vendor_4.GET(RecConfirmedOrder."Introducer Code") THEN BEGIN
            IF Vendor_4."BBG Vendor Category" = Vendor_4."BBG Vendor Category"::"CP(Channel Partner)" THEN
                RankRegionCode := Vendor_4."Sub Vendor Category";
            //RankRegionCode := 'R0003';  //02062025 Code commented
        END;
        //060924 Code Added End
        CLEAR(Change);
        "Associate Hierarcy with App".RESET;
        "Associate Hierarcy with App".SETRANGE("Application Code", RecConfirmedOrder."No.");
        "Associate Hierarcy with App".SETRANGE(Status, "Associate Hierarcy with App".Status::Active);
        IF "Associate Hierarcy with App".FINDFIRST THEN BEGIN
            IF "Associate Hierarcy with App"."Introducer Code" <> RecConfirmedOrder."Introducer Code" THEN BEGIN
                Change := TRUE;
            END;
            IF "Associate Hierarcy with App"."Posting Date" <> RecConfirmedOrder."Posting Date" THEN BEGIN
                Change := TRUE;
            END;
            IF "Associate Hierarcy with App"."Project Code" <> RecConfirmedOrder."Shortcut Dimension 1 Code" THEN BEGIN
                Change := TRUE;
            END;
            IF "Associate Hierarcy with App"."Travel Generated" <> RecConfirmedOrder."Travel Generate" THEN BEGIN
                Change := TRUE;
            END;

            IF RecJob.GET(RecConfirmedOrder."Shortcut Dimension 1 Code") THEN BEGIN
                //060924 Code Added Start
                RankRegionCode := '';
                //RankRegionCode := RecJob."Region Code for Rank Hierarcy";  //Code commented 01072025
                RankRegionCode := RecConfirmedOrder."Region Code";  //Code Added 01072025
                Vendor_4.RESET;
                IF Vendor_4.GET(RecConfirmedOrder."Introducer Code") THEN BEGIN
                    IF Vendor_4."BBG Vendor Category" = Vendor_4."BBG Vendor Category"::"CP(Channel Partner)" THEN
                        IF Vendor_4."Sub Vendor Category" <> '' then  //Code Added 01072025
                            RankRegionCode := Vendor_4."Sub Vendor Category";
                    // RankRegionCode := 'R0003';  02/06/2025 Code commented
                END;
                //060924 Code Added End

                CLEAR(Region_RankwiseVendor);
                Region_RankwiseVendor.RESET;
                Region_RankwiseVendor.SETRANGE("Region Code", RankRegionCode); //060924 Code changes
                Region_RankwiseVendor.SETRANGE("No.", RecConfirmedOrder."Introducer Code");
                IF Region_RankwiseVendor.FINDFIRST THEN;
            END;

            //IF Change THEN BEGIN  //071223
            AssHierarcywithApp.RESET;
            AssHierarcywithApp.SETRANGE("Application Code", RecConfirmedOrder."No.");
            IF AssHierarcywithApp.FINDSET THEN BEGIN
                REPEAT
                    AssHierarcywithApp.Status := AssHierarcywithApp.Status::"In-Active";
                    AssHierarcywithApp.MODIFY;
                UNTIL AssHierarcywithApp.NEXT = 0;
            END;  //071223
            //BBG2.01 130115
            AssHierwithApp.RESET;
            AssHierwithApp.SETRANGE("Application Code", RecConfirmedOrder."No.");
            IF AssHierwithApp.FINDSET THEN BEGIN
                REPEAT
                    AssHierwithApp.Status := AssHierwithApp.Status::"In-Active";
                    AssHierwithApp.MODIFY;
                UNTIL AssHierwithApp.NEXT = 0;
            END;
            //  END;  071223

            unitpost.NewInsertTeamHierarcy(RecConfirmedOrder, RankRegionCode, FALSE, FromProjectChange)  //071223 Change Placement
        END ELSE BEGIN
            unitpost.NewInsertTeamHierarcy(RecConfirmedOrder, RankRegionCode, TRUE, FromProjectChange);
        END;
    end;


    procedure NewInsertVendorTree(var VendorI: Record "Region wise Vendor"; EffDate: Date)
    var
        ComStructTemp: Record "Commission Structure" temporary;
        PrevRank: Decimal;
        AssHierarcywithApp: Record "Associate Hierarcy with App.";
        LastLineNo: Integer;
        InvestmentType: Integer;
        BondNo: Code[20];
        Application: Record Application;
        PostingDate: Date;
        VendTree: Record "Vendor Tree";
        VendTree2: Record "Vendor Tree";
    begin
        NewInitChain;
        PrevRank := 0;
        //BondNo := ConfirmedOrder."No.";
        //Bond.GET(ConfirmedOrder."No.");
        //PostingDate := ConfirmedOrder."Posting Date";  //BBG1.00 280413
        //AppPostingDate := ConfirmedOrder."Posting Date";
        //ChainFromToUp(ConfirmedOrder."Introducer Code",PostingDate,FALSE);
        VendTree2.RESET;
        VendTree2.SETRANGE("Introducer Code", VendorI."No.");
        VendTree2.SETRANGE("Region/Rank Code", VendorI."Region Code");
        VendTree2.SETRANGE("Effective Date", EffDate);
        IF VendTree2.FINDSET THEN
            VendTree2.DELETEALL;

        CLEAR(VendTree2);
        VendTree2.RESET;
        VendTree2.SETRANGE("Introducer Code", VendorI."No.");
        VendTree2.SETRANGE("Region/Rank Code", VendorI."Region Code");
        VendTree2.SETRANGE(Status, VendTree2.Status::Active);
        IF VendTree2.FINDSET THEN
            REPEAT
                VendTree2.Status := VendTree2.Status::"In-Active";
                VendTree2.MODIFY;
            UNTIL VendTree2.NEXT = 0;

        NewChainFromToUp(VendorI."No.", EffDate, FALSE, VendorI."Region Code");
        NewUpdateChainRankTemp(EffDate, VendorI."Region Code");
        LastLineNo := 10000;
        UnitSetup.GET;
        NewParentChain.SETCURRENTKEY("Rank Code");
        IF NewParentChain.FINDSET THEN
            REPEAT
                //ALLEDK 020317
                VendorTree_1.RESET;
                VendorTree_1.SETRANGE("Introducer Code", VendorI."No.");
                VendorTree_1.SETRANGE("Effective Date", EffDate);
                IF VendorTree_1.FINDLAST THEN
                    LastLineNo := VendorTree_1."Line No.";
                //ALLEDK 020317
                VendTree.INIT;
                VendTree."Introducer Code" := VendorI."No.";
                VendTree."Associate Code" := NewParentChain."No.";
                VendTree."Line No." := LastLineNo + 10000;
                VendTree."Effective Date" := EffDate;
                VendTree."Parent Code" := NewParentChain."Parent Code";
                VendTree."Rank Code" := NewParentChain."Rank Code";
                VendTree."Associate Name" := NewParentChain.Name;
                IF NewRecRank.GET(VendorI."Region Code", NewParentChain."Rank Code") THEN
                    VendTree."Rank Description" := RecRank.Description;
                VendTree.INSERT;
                LastLineNo += 10000;
            UNTIL NewParentChain.NEXT = 0;
    end;


    procedure NewUpdateChainRank(EffectiveDate: Date; RegionCode: Code[10])
    begin
        UnitSetup.GET;                                                        //Alledk 051212
        NewParentChain.SETFILTER("Rank Code", '<=%1', UnitSetup."Hierarchy Head"); //Alledk 051212
        IF NewParentChain.FINDSET THEN
            REPEAT
                NewParentChain."Rank Code" := NewPresentRank(NewParentChain."No.", EffectiveDate, RegionCode);
                NewParentChain.MODIFY;
            UNTIL NewParentChain.NEXT = 0;
    end;


    procedure NewReturnChain(var BuildChain: Record "Region wise Vendor" temporary)
    begin
        IF NewParentChain.FINDSET THEN
            REPEAT
                BuildChain.INIT;
                BuildChain.TRANSFERFIELDS(NewParentChain);
                IF NOT BuildChain.GET(BuildChain."Rank Code", BuildChain."No.") THEN //1812  161123
                    BuildChain.INSERT;
            UNTIL NewParentChain.NEXT = 0;
    end;


    procedure NewBuildChainTopToBottom(ParentCode: Code[20]; PostingDate: Date; FirstTime: Boolean; RegionRankCode: Code[10])
    begin
        Priority := 0;
        NewChainTopToBottom(ParentCode, PostingDate, TRUE, RegionRankCode);
        IF PostingDate < GetDescription.GetDocomentDate THEN
            NewIncludeChain(ParentCode, PostingDate, RegionRankCode);
    end;


    procedure NewChainTopToBottom(ParentCode: Code[20]; PostingDate: Date; FirstTime: Boolean; RegionrankCode: Code[10])
    var
        Vendor: Record "Region wise Vendor";
        RCH: Record "Rank Change History";
        SerialNo: Text[80];
        Cnt: Integer;
        Vend: Record Vendor;
    begin
        IF FirstTime THEN BEGIN
            Vendor.SETRANGE("Region Code", RegionrankCode);
            Vendor.SETRANGE("No.", ParentCode);
            IF Vendor.FINDFIRST THEN BEGIN   //code added 01072025  Added Begin and END 
                IF NOT NewParentChain.GET(RegionrankCode, Vendor."No.") THEN BEGIN
                    NewParentChain := Vendor;
                    Priority += 1;
                    NewParentChain.Priority := Priority;
                    NewParentChain.INSERT;
                END;
            END;   //code added 01072025  Added Begin and END 
        END;

        Vendor.RESET;
        Vendor.SETCURRENTKEY("Region Code", "Parent Code");
        Vendor.SETRANGE("Region Code", RegionrankCode);
        Vendor.SETRANGE("Parent Code", ParentCode);
        IF Vendor.FINDSET THEN
            REPEAT
                IF Vend.GET(ParentCode) THEN
                    IF (Vend."BBG Date of Joining" <= PostingDate) AND NOT NewChildChange(ParentCode, Vendor."No.", PostingDate
                                                                                 , RegionrankCode) THEN BEGIN
                        IF NOT NewParentChain.GET(RegionrankCode, Vendor."No.") THEN BEGIN
                            NewParentChain := Vendor;
                            IF PostingDate < GetDescription.GetDocomentDate THEN BEGIN
                                RCH.RESET;
                                RCH.SETCURRENTKEY(MMCode, "Authorisation Date");
                                RCH.SETRANGE(RCH."Rank Code", RegionrankCode);
                                RCH.SETRANGE(MMCode, Vendor."No.");
                                RCH.SETFILTER("Authorisation Date", '<=%1', PostingDate);
                                IF RCH.FINDLAST THEN BEGIN
                                    NewParentChain."Parent Code" := RCH."New Parent Code";
                                    NewParentChain."Parent Rank" := RCH."Parent Rank New";
                                END;
                            END;
                            Priority += 1;
                            NewParentChain.Priority := Priority;
                            NewParentChain.INSERT;
                        END;

                        IF PostingDate < GetDescription.GetDocomentDate THEN
                            NewIncludeChain(NewParentChain."No.", PostingDate, RegionrankCode);
                        NewChainTopToBottom(NewParentChain."No.", PostingDate, FALSE, RegionrankCode);
                    END;
            UNTIL Vendor.NEXT = 0;
    end;


    procedure NewChildChange(ParantCode: Code[20]; MMCode: Code[20]; EffectiveDate: Date; RegionRankCode: Code[10]): Boolean
    var
        RankHistory: Record "Rank Change History";
        MM: Record Vendor;
    begin
        //RankHistory.SETCURRENTKEY(MMCode,"Authorisation Date","Change Type");
        RankHistory.SETCURRENTKEY(MMCode, "Authorisation Date");
        RankHistory.SETRANGE(MMCode, MMCode);
        RankHistory.SETRANGE("Rank Code", RegionRankCode);
        RankHistory.SETFILTER("Authorisation Date", '>=%1', EffectiveDate);
        IF RankHistory.FINDSET THEN
            REPEAT
                IF (RankHistory."Old Parent Code" <> '') AND (RankHistory."Old Parent Code" <> RankHistory."New Parent Code") THEN
                    IF RankHistory."Old Parent Code" <> ParantCode THEN
                        EXIT(TRUE);
            UNTIL RankHistory.NEXT = 0;
        EXIT(FALSE);
    end;


    procedure NewIncludeChain(ParentCode: Code[20]; PostingDate: Date; Regionrankcode: Code[10])
    var
        CompressedChain: Record "Rank Change History" temporary;
        ChainSubset2: Record "Rank Change History";
    begin
        RankChangeHistory.RESET;
        RankChangeHistory.SETCURRENTKEY(MMCode, "Authorisation Date");
        RankChangeHistory.ASCENDING(FALSE);
        RankChangeHistory.SETFILTER("Authorisation Date", '<=%1', PostingDate);
        RankChangeHistory.SETRANGE("New Parent Code", ParentCode);
        IF RankChangeHistory.FIND('-') THEN
            REPEAT
                IF RankChangeHistory."Old Parent Code" <> RankChangeHistory."New Parent Code" THEN BEGIN
                    CompressedChain.RESET;
                    CompressedChain.SETCURRENTKEY(MMCode, "Authorisation Date");
                    CompressedChain.SETRANGE(MMCode, RankChangeHistory.MMCode);
                    IF NOT CompressedChain.FINDFIRST THEN BEGIN
                        CompressedChain.RESET;
                        CompressedChain.INIT;
                        CompressedChain.TRANSFERFIELDS(RankChangeHistory);
                        CompressedChain.INSERT;
                    END;
                END;
            UNTIL RankChangeHistory.NEXT = 0;

        CompressedChain.RESET;
        CompressedChain.SETCURRENTKEY(MMCode, "Authorisation Date");
        IF CompressedChain.FINDSET THEN
            REPEAT
                ChainSubset2.RESET;
                ChainSubset2.SETCURRENTKEY(MMCode, "Authorisation Date");
                ChainSubset2.SETRANGE(MMCode, CompressedChain.MMCode);
                ChainSubset2.SETFILTER("Authorisation Date", '<=%1', PostingDate);
                IF ChainSubset2.FINDLAST THEN BEGIN
                    IF ChainSubset2."New Parent Code" = CompressedChain."New Parent Code" THEN BEGIN
                        IF Vend.GET(CompressedChain.MMCode) THEN BEGIN  //Added BEGIN and END 230622
                            IF Vend."BBG Date of Joining" <= PostingDate THEN BEGIN
                                ChainTopToBottom(CompressedChain.MMCode, PostingDate, TRUE);
                            END;
                        END;
                    END;
                END;
            UNTIL CompressedChain.NEXT = 0;
    end;


    procedure "----------For new Application."()
    begin
    end;


    procedure OnAppInsertTeamHierarcy(var NewApplication: Record "New Application Booking"; RegionCode: Code[10])
    var
        ComStructTemp: Record "Commission Structure" temporary;
        PrevRank: Decimal;
        AssHierarcywithApp: Record "Associate Hierarcy with App.";
        LastLineNo: Integer;
        InvestmentType: Integer;
        BondNo: Code[20];
        Application: Record "New Application Booking";
        PostingDate: Date;
    begin
        NewInitChain;
        PrevRank := 0;
        BondNo := NewApplication."Application No.";
        PostingDate := NewApplication."Posting Date";  //BBG1.00 280413
        AppPostingDate := NewApplication."Posting Date";
        NewChainFromToUp(NewApplication."Associate Code", PostingDate, FALSE, RegionCode);
        NewUpdateChainRankTemp(PostingDate, RegionCode);

        //  ComStructTemp.RESET;
        //  ComStructTemp.DELETEALL;
        //  BuildBonusComissionStructure(0,1,ComStructTemp,
        //    0,Bond.Duration,Bond."Project Type",PostingDate);

        LastLineNo := GetLastTemHierarcy(NewApplication."Application No.");
        UnitSetup.GET;
        NewParentChain.SETCURRENTKEY("Rank Code");
        IF NewParentChain.FINDSET THEN
            REPEAT
                //IF ParentChain."Rank Code" <= UnitSetup."Hierarchy Head" THEN BEGIN //ALLEDK 301112
                AssHierarcywithApp.INIT;
                AssHierarcywithApp."Application Code" := NewApplication."Application No.";
                AssHierarcywithApp."Line No." := LastLineNo;
                AssHierarcywithApp."Posting Date" := NewApplication."Posting Date";
                AssHierarcywithApp."Associate Code" := NewParentChain."No.";
                AssHierarcywithApp."Introducer Code" := NewApplication."Associate Code";
                AssHierarcywithApp."Parent Code" := NewParentChain."Parent Code";
                AssHierarcywithApp."Project Code" := NewApplication."Shortcut Dimension 1 Code";
                // AssHierarcywithApp."Travel Generated" := ConfirmedOrder."Travel Generate";
                AssHierarcywithApp."Rank Code" := NewParentChain."Rank Code";
                AssHierarcywithApp."Associate Name" := NewParentChain.Name;
                IF NewRecRank.GET(RegionCode, NewParentChain."Rank Code") THEN
                    AssHierarcywithApp."Rank Description" := NewRecRank.Description;
                //    IF NewParentChain."Rank Code" <= UnitSetup."Hierarchy Head" THEN
                //    AssHierarcywithApp."Commission %" := CalculateBonusCommissionPct(ComStructTemp,PrevRank,NewParentChain."Rank Code")
                //  ELSE
                //   AssHierarcywithApp."Commission %" := 0;
                AssHierarcywithApp."Region/Rank Code" := RegionCode;
                AssHierarcywithApp.INSERT;
                PrevRank := NewParentChain."Rank Code" + 0.0001; //BBG1.00 090313
                LastLineNo += 1;
            // END;   //ALLEDK 301112
            UNTIL NewParentChain.NEXT = 0;
    end;

    local procedure "-----------------------------"()
    begin
    end;

    local procedure "------------Post New REceipt----------------"()
    begin
    end;


    procedure PostNewReceipt(P_NewApplicationBooking: Record "New Application Booking"; FromBatch: Boolean)
    var
        AppPayEntry: Record "NewApplication Payment Entry";
        BondSetup: Record "Unit Setup";
        NewAppEntry: Record "NewApplication Payment Entry";
        AmountToWords: Codeunit "Amount To Words";
        AmountText1: array[2] of Text[300];
        MMName: Text[50];
        Text0010: Label 'Are you sure to post the entries?';
        Text002_1: Label 'Please verify the details below and confirm. Do you want to post ? %1    :%2\Project Name       :%3  Project Code :%4\Unit No.               :%5\Customer Name   :%6-%7\Associate Code    :%8-%9 \Receiving Amount: %10 \Amount in Words : %11 \Posting Date        : %12.';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ComInfo: Record "Company Information";
        Customer: Record Customer;
        CustSMSText: Text[700];
        CustMobileNo: Text[30];
        PostPayment: Codeunit PostPayment;
        NewApplicationpayentry: Record "NewApplication Payment Entry";
        UnitMaster: Record "Unit Master";
        RespCenter: Record "Responsibility Center 1";
        RecUMaster: Record "Unit Master";
        Text003_1: Label '%1 %2 has been released.\%3 %4 has been assigned.';
        RegionCode: Code[10];
        RecJob: Record Job;
        NewUnitMaster1: Record "Unit Master";
        unitpost: Codeunit "Unit Post";
        MemberOf: Record "Access Control";
        Vendor_2: Record Vendor;
        Vendor_3: Record Vendor;
    begin
        BondSetup.GET;
        BondSetup.TESTFIELD(BondSetup."Bar Code no. Series");


        IF NOT FromBatch THEN BEGIN
            MemberOf.SETRANGE(MemberOf."User Name", USERID);
            MemberOf.SETRANGE(MemberOf."Role ID", 'A_APPPOSTING');
            IF NOT MemberOf.FINDFIRST THEN
                ERROR('You do not have permission of role  :A_APPPOSTING');
        END;

        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document No.", P_NewApplicationBooking."Application No.");
        AppPayEntry.SETRANGE(Posted, FALSE);
        AppPayEntry.SETRANGE(Amount, 0);
        IF AppPayEntry.FINDFIRST THEN
            AppPayEntry.TESTFIELD(Amount);
        //BBG2.00 310714



        P_NewApplicationBooking.TESTFIELD(Status, P_NewApplicationBooking.Status::Open);
        P_NewApplicationBooking.TESTFIELD("Bill-to Customer Name");
        BondSetup.GET;
        IF P_NewApplicationBooking."Customer No." = '' THEN
            P_NewApplicationBooking.VALIDATE("Customer No.", P_NewApplicationBooking.CreateCustomer(P_NewApplicationBooking."Customer Name"));

        IF (P_NewApplicationBooking."Customer Name" = '') AND (P_NewApplicationBooking."Customer No." = '') THEN BEGIN
            ERROR(Text001, P_NewApplicationBooking.FIELDCAPTION(P_NewApplicationBooking."Bill-to Customer Name"), P_NewApplicationBooking.FIELDCAPTION(P_NewApplicationBooking."Customer No."));
        END;

        NewAppEntry.RESET;
        NewAppEntry.SETRANGE("Document No.", P_NewApplicationBooking."Application No.");
        NewAppEntry.SETRANGE(Posted, FALSE);
        IF NewAppEntry.FINDFIRST THEN
            REPEAT
                IF NewAppEntry."Payment Mode" = NewAppEntry."Payment Mode"::Bank THEN
                    NewAppEntry.TESTFIELD("Bank Type");
                IF NewAppEntry.COUNT > 1 THEN
                    ERROR('Single receipt entry allowed');

            UNTIL NewAppEntry.NEXT = 0;


        //ALLECK 020313 START

        IF NOT FromBatch THEN BEGIN
            IF P_NewApplicationBooking."Application Type" = P_NewApplicationBooking."Application Type"::Trading THEN BEGIN  //070815
                AmountToWords.InitTextVariable;
                AmountToWords.FormatNoText(AmountText1, CheckPaymentAmount(P_NewApplicationBooking."Application No."), '');
                IF CONFIRM(STRSUBSTNO(Text002_1, P_NewApplicationBooking.FIELDCAPTION(P_NewApplicationBooking."Application No."), P_NewApplicationBooking."Application No.",
                   GetDescription.GetDimensionName(P_NewApplicationBooking."Shortcut Dimension 1 Code", 1), P_NewApplicationBooking."Shortcut Dimension 1 Code", P_NewApplicationBooking."Unit Code", P_NewApplicationBooking."Customer Name",
                   P_NewApplicationBooking."Customer No.", P_NewApplicationBooking."Associate Code", MMName, CheckPaymentAmount(P_NewApplicationBooking."Application No."), AmountText1[1], P_NewApplicationBooking."Posting Date")) THEN BEGIN
                    IF CONFIRM(Text0010) THEN BEGIN //ALLECK020313
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", P_NewApplicationBooking."Application No.");
                        AppPayEntry.SETRANGE(Posted, FALSE);
                        IF AppPayEntry.FINDFIRST THEN BEGIN
                            AppPayEntry.TESTFIELD(Amount);
                            AppPayEntry.Posted := TRUE;
                            AppPayEntry."Create from MSC Company" := FALSE;
                            AppPayEntry."BarCode No." := NoSeriesMgt.GetNextNo(BondSetup."Bar Code no. Series", TODAY, TRUE);
                            AppPayEntry.MODIFY;
                            P_NewApplicationBooking.Status := P_NewApplicationBooking.Status::Released;
                            P_NewApplicationBooking.MODIFY;
                        END;
                        ComInfo.GET;
                        IF ComInfo."Send SMS" THEN BEGIN
                            IF Customer.GET(P_NewApplicationBooking."Customer No.") THEN BEGIN
                                IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                    CustMobileNo := Customer."BBG Mobile No.";
                                    CLEAR(AppPayEntry);
                                    AppPayEntry.RESET;
                                    AppPayEntry.SETRANGE("Document No.", P_NewApplicationBooking."Application No.");
                                    AppPayEntry.SETRANGE(Posted, TRUE);
                                    AppPayEntry.SETFILTER(Amount, '<>%1', 0);
                                    IF AppPayEntry.FINDLAST THEN BEGIN
                                        IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Cash) THEN
                                            CustSMSText :=
                                  'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to Building Blocks Family. Please find attached details ID:'
                                  + FORMAT(AppPayEntry."Posted Document No.") + 'Dt.' + FORMAT(AppPayEntry."Posting date")
                                  + 'Appl No:' + P_NewApplicationBooking."Application No." + ' ' + 'Project: ' + GetDescription.GetDimensionName(P_NewApplicationBooking."Shortcut Dimension 1 Code", 1) +
                                  'Amt. Rs.' + FORMAT(AppPayEntry.Amount) + 'Thankyou and Assuring you of Best Property Services with Building'
                                  + 'Blocks Group'
                                        ELSE
                                            CustSMSText :=
                                  'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to Building Blocks Family. Please find attached details ID:'
                                  + FORMAT(AppPayEntry."Posted Document No.") + 'Dt.' + FORMAT(AppPayEntry."Posting date")
                                  + 'Appl No:' + P_NewApplicationBooking."Application No." + ' ' + 'Project: ' + GetDescription.GetDimensionName(P_NewApplicationBooking."Shortcut Dimension 1 Code", 1) +
                                  'Amt. Rs.' + FORMAT(AppPayEntry.Amount) + 'Thankyou and Assuring you of Best Property Services with Building'
                                  + 'Blocks Group' + 'Tx for payment(If Chq-Subject to Realization).';

                                        MESSAGE('%1', CustSMSText);
                                        PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                        //ALLEDK15112022 Start
                                        CLEAR(SMSLogDetails);
                                        SmsMessage := '';
                                        SmsMessage1 := '';
                                        SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                        SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                        SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Customer Receipt',
                                        P_NewApplicationBooking."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(P_NewApplicationBooking."Shortcut Dimension 1 Code", 1),
                                        P_NewApplicationBooking."Application No.");
                                        //ALLEDK15112022 END



                                    END;
                                END;
                            END;
                        END;
                    END;
                END;
            END ELSE BEGIN  //070815
                AmountToWords.InitTextVariable;
                AmountToWords.FormatNoText(AmountText1, CheckPaymentAmount(P_NewApplicationBooking."Application No."), '');
                IF CONFIRM(STRSUBSTNO(Text002_1, P_NewApplicationBooking.FIELDCAPTION(P_NewApplicationBooking."Application No."), P_NewApplicationBooking."Application No.",
                   GetDescription.GetDimensionName(P_NewApplicationBooking."Shortcut Dimension 1 Code", 1), P_NewApplicationBooking."Shortcut Dimension 1 Code", P_NewApplicationBooking."Unit Code", P_NewApplicationBooking."Customer Name",
                   P_NewApplicationBooking."Customer No.", P_NewApplicationBooking."Associate Code", MMName, CheckPaymentAmount(P_NewApplicationBooking."Application No."), AmountText1[1], P_NewApplicationBooking."Posting Date")) THEN BEGIN
                    IF CONFIRM(Text0010) THEN BEGIN //ALLECK020313
                        IF P_NewApplicationBooking."Posted Doc No." = '' THEN BEGIN
                            P_NewApplicationBooking."Posted Doc No." := NoSeriesMgt.GetNextNo(BondSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
                            COMMIT;
                        END;

                        NewAppEntry.RESET;
                        NewAppEntry.SETRANGE("Document No.", P_NewApplicationBooking."Application No.");
                        NewAppEntry.SETRANGE(Posted, FALSE);
                        NewAppEntry.SETFILTER(NewAppEntry."Bank Type", '<>%1', NewAppEntry."Bank Type"::ProjectCompany);
                        IF NewAppEntry.FINDLAST THEN BEGIN
                            PostPayment.NewCreateApplicationGenJnlLine(P_NewApplicationBooking, 'Initial Payment Received');
                        END;
                        NewApplicationpayentry.RESET;
                        NewApplicationpayentry.SETRANGE(NewApplicationpayentry."Document No.", P_NewApplicationBooking."Application No.");
                        IF NewApplicationpayentry.FINDSET THEN
                            REPEAT
                                NewApplicationpayentry."Posted Document No." := P_NewApplicationBooking."Posted Doc No.";
                                NewApplicationpayentry.Posted := TRUE;
                                NewApplicationpayentry."BarCode No." := NoSeriesMgt.GetNextNo(BondSetup."Bar Code no. Series", TODAY, TRUE);
                                NewApplicationpayentry.MODIFY;
                            UNTIL NewApplicationpayentry.NEXT = 0;

                        P_NewApplicationBooking.Status := P_NewApplicationBooking.Status::Released;
                        P_NewApplicationBooking.MODIFY;
                        CLEAR(UnitMaster);
                        IF UnitMaster.GET(P_NewApplicationBooking."Unit Code") THEN BEGIN
                            UnitMaster.VALIDATE(Status, UnitMaster.Status::Booked);
                            RespCenter.RESET;
                            IF RespCenter.GET(P_NewApplicationBooking."Shortcut Dimension 1 Code") THEN BEGIN
                                IF RespCenter."Publish Plot Cost" THEN
                                    UnitMaster."Plot Cost" := RecUMaster."Total Value";
                                IF RespCenter."Publish CustomerName" THEN
                                    UnitMaster."Customer Name" := P_NewApplicationBooking."Bill-to Customer Name";
                            END;
                            UnitMaster.MODIFY;
                        END;
                        MESSAGE(Text003_1, P_NewApplicationBooking.FIELDCAPTION("Application No."), P_NewApplicationBooking."Application No.", P_NewApplicationBooking.FIELDCAPTION("Unit Code"), P_NewApplicationBooking."Unit Code");

                        CLEAR(RecUMaster);
                        RecUMaster.CHANGECOMPANY(P_NewApplicationBooking."Company Name");
                        IF RecUMaster.GET(P_NewApplicationBooking."Unit Code") THEN BEGIN
                            RespCenter.RESET;
                            IF RespCenter.GET(P_NewApplicationBooking."Shortcut Dimension 1 Code") THEN BEGIN
                                IF RespCenter."Publish Plot Cost" THEN
                                    RecUMaster."Plot Cost" := RecUMaster."Total Value";
                                IF RespCenter."Publish CustomerName" THEN
                                    RecUMaster."Customer Name" := P_NewApplicationBooking."Bill-to Customer Name";
                                RecUMaster.MODIFY;
                            END;
                        END;


                        RegionCode := '';
                        RecJob.RESET;
                        RecJob.CHANGECOMPANY(P_NewApplicationBooking."Company Name");
                        IF RecJob.GET(P_NewApplicationBooking."Shortcut Dimension 1 Code") THEN
                            RegionCode := RecJob."Region Code for Rank Hierarcy";
                        RegionCode := P_NewApplicationBooking."Rank Code"; //Code Added 01072025


                        Vendor_2.RESET;   //200924 code added
                        IF Vendor_2.GET(P_NewApplicationBooking."Associate Code") THEN
                            IF Vendor_2."BBG Vendor Category" = Vendor_2."BBG Vendor Category"::"CP(Channel Partner)" THEN
                                RegionCode := Vendor_2."Sub Vendor Category";
                        // RegionCode := 'R0003';  02/06/2025 Code commented

                        unitpost.OnAppInsertTeamHierarcy(P_NewApplicationBooking, RegionCode);

                        ComInfo.GET;
                        IF ComInfo."Send SMS" THEN BEGIN
                            IF Customer.GET(P_NewApplicationBooking."Customer No.") THEN BEGIN
                                IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                    CustMobileNo := Customer."BBG Mobile No.";
                                    CLEAR(AppPayEntry);
                                    AppPayEntry.RESET;
                                    AppPayEntry.SETRANGE("Document No.", P_NewApplicationBooking."Application No.");
                                    AppPayEntry.SETRANGE(Posted, TRUE);
                                    IF AppPayEntry.FINDLAST THEN BEGIN
                                        IF (AppPayEntry.Amount <> 0) THEN BEGIN
                                            IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Cash) THEN
                                                CustSMSText :=
                                                'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to BBG Family. Appl No:' + P_NewApplicationBooking."Application No." + ' ' +
                                                'Recvd Rs.' + FORMAT(AppPayEntry.Amount) +
                                                ' ' + 'Project: ' + GetDescription.GetDimensionName(P_NewApplicationBooking."Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' +
                                                FORMAT(AppPayEntry."Posting date")
                                            ELSE
                                                CustSMSText :=
                                                'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to BBG Family. Appl No:' + P_NewApplicationBooking."Application No." +
                                                ' ' + 'Recvd Rs.' + FORMAT(AppPayEntry.Amount) +
                                                ' ' + 'Project: ' + GetDescription.GetDimensionName(P_NewApplicationBooking."Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' +
                                                FORMAT(AppPayEntry."Posting date") + 'Tx for payment(If Chq-Subject to Realization).';

                                            MESSAGE('%1', CustSMSText);
                                            PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                            //ALLEDK15112022 Start
                                            CLEAR(SMSLogDetails);
                                            SmsMessage := '';
                                            SmsMessage1 := '';
                                            SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                            SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                            SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Customer Receipt',
                                            P_NewApplicationBooking."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(P_NewApplicationBooking."Shortcut Dimension 1 Code", 1),
                                            P_NewApplicationBooking."Application No.");
                                            //ALLEDK15112022 END
                                        END;
                                    END;
                                END
                                ELSE
                                    MESSAGE('%1', 'Mobile No. not Found');
                            END;
                        END;
                    END;
                END;
            END;
            //----------------new code--------------
        END ELSE BEGIN
            IF P_NewApplicationBooking."Application Type" = P_NewApplicationBooking."Application Type"::Trading THEN BEGIN  //070815
                AmountToWords.InitTextVariable;
                AmountToWords.FormatNoText(AmountText1, CheckPaymentAmount(P_NewApplicationBooking."Application No."), '');
                AppPayEntry.RESET;
                AppPayEntry.SETRANGE("Document No.", P_NewApplicationBooking."Application No.");
                AppPayEntry.SETRANGE(Posted, FALSE);
                IF AppPayEntry.FINDFIRST THEN BEGIN
                    AppPayEntry.TESTFIELD(Amount);
                    AppPayEntry.Posted := TRUE;
                    AppPayEntry."Create from MSC Company" := FALSE;
                    AppPayEntry."BarCode No." := NoSeriesMgt.GetNextNo(BondSetup."Bar Code no. Series", TODAY, TRUE);
                    AppPayEntry.MODIFY;
                    P_NewApplicationBooking.Status := P_NewApplicationBooking.Status::Released;
                    P_NewApplicationBooking.MODIFY;
                END;
            END ELSE BEGIN  //070815
                AmountToWords.InitTextVariable;
                AmountToWords.FormatNoText(AmountText1, CheckPaymentAmount(P_NewApplicationBooking."Application No."), '');
                IF P_NewApplicationBooking."Posted Doc No." = '' THEN BEGIN
                    P_NewApplicationBooking."Posted Doc No." := NoSeriesMgt.GetNextNo(BondSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
                    COMMIT;
                END;

                NewAppEntry.RESET;
                NewAppEntry.SETRANGE("Document No.", P_NewApplicationBooking."Application No.");
                NewAppEntry.SETRANGE(Posted, FALSE);
                NewAppEntry.SETFILTER(NewAppEntry."Bank Type", '<>%1', NewAppEntry."Bank Type"::ProjectCompany);
                IF NewAppEntry.FINDLAST THEN BEGIN
                    PostPayment.NewCreateApplicationGenJnlLine(P_NewApplicationBooking, 'Initial Payment Received');
                END;
                NewApplicationpayentry.RESET;
                NewApplicationpayentry.SETRANGE(NewApplicationpayentry."Document No.", P_NewApplicationBooking."Application No.");
                IF NewApplicationpayentry.FINDSET THEN
                    REPEAT
                        NewApplicationpayentry."Posted Document No." := P_NewApplicationBooking."Posted Doc No.";
                        NewApplicationpayentry.Posted := TRUE;
                        NewApplicationpayentry."BarCode No." := NoSeriesMgt.GetNextNo(BondSetup."Bar Code no. Series", TODAY, TRUE);
                        NewApplicationpayentry.MODIFY;
                    UNTIL NewApplicationpayentry.NEXT = 0;

                P_NewApplicationBooking.Status := P_NewApplicationBooking.Status::Released;
                P_NewApplicationBooking.MODIFY;
                CLEAR(UnitMaster);
                IF UnitMaster.GET(P_NewApplicationBooking."Unit Code") THEN BEGIN
                    UnitMaster.VALIDATE(Status, UnitMaster.Status::Booked);
                    RespCenter.RESET;
                    IF RespCenter.GET(P_NewApplicationBooking."Shortcut Dimension 1 Code") THEN BEGIN
                        IF RespCenter."Publish Plot Cost" THEN
                            UnitMaster."Plot Cost" := RecUMaster."Total Value";
                        IF RespCenter."Publish CustomerName" THEN
                            UnitMaster."Customer Name" := P_NewApplicationBooking."Bill-to Customer Name";
                    END;
                    UnitMaster.MODIFY;
                END;
                //MESSAGE(Text003_1,P_NewApplicationBooking.FIELDCAPTION("Application No."),P_NewApplicationBooking."Application No.",P_NewApplicationBooking.FIELDCAPTION("Unit Code"),P_NewApplicationBooking."Unit Code");

                CLEAR(RecUMaster);
                RecUMaster.CHANGECOMPANY(P_NewApplicationBooking."Company Name");
                IF RecUMaster.GET(P_NewApplicationBooking."Unit Code") THEN BEGIN
                    RespCenter.RESET;
                    IF RespCenter.GET(P_NewApplicationBooking."Shortcut Dimension 1 Code") THEN BEGIN
                        IF RespCenter."Publish Plot Cost" THEN
                            RecUMaster."Plot Cost" := RecUMaster."Total Value";
                        IF RespCenter."Publish CustomerName" THEN
                            RecUMaster."Customer Name" := P_NewApplicationBooking."Bill-to Customer Name";
                        RecUMaster.MODIFY;
                    END;
                END;


                RegionCode := '';
                RecJob.RESET;
                RecJob.CHANGECOMPANY(P_NewApplicationBooking."Company Name");
                IF RecJob.GET(P_NewApplicationBooking."Shortcut Dimension 1 Code") THEN
                    RegionCode := RecJob."Region Code for Rank Hierarcy";
                RegionCode := P_NewApplicationBooking."Rank Code";  //Code Added 01072025

                //110924 Code added START
                Vendor_3.RESET;
                IF Vendor_3.GET(P_NewApplicationBooking."Associate Code") THEN
                    IF Vendor_3."BBG Vendor Category" = Vendor_3."BBG Vendor Category"::"CP(Channel Partner)" THEN
                        RegionCode := Vendor_3."Sub Vendor Category";

                //  RegionCode := 'R0003';  02062025 Code Comment
                //110924 Code added END
                unitpost.OnAppInsertTeamHierarcy(P_NewApplicationBooking, RegionCode);
            END;
        END;

        WebAppService.UpdateUnitStatus(UnitMaster);  //210624
    end;


    procedure CheckPaymentAmount(DocumentNo: Code[20]) PayAmount: Decimal
    var
        ApplPayEntry: Record "NewApplication Payment Entry";
    begin
        ApplPayEntry.RESET;
        ApplPayEntry.SETRANGE("Document Type", ApplPayEntry."Document Type"::Application);
        ApplPayEntry.SETRANGE("Document No.", DocumentNo);
        ApplPayEntry.SETRANGE(Posted, FALSE);
        IF ApplPayEntry.FINDSET THEN
            REPEAT
                PayAmount += ApplPayEntry.Amount;
            UNTIL ApplPayEntry.NEXT = 0;
    end;


    procedure CreateNewConfOrder(NewAppBooking: Record "New Application Booking")
    var
        CreateBond: Codeunit "Unit and Comm. Creation Job";
        PaymentPlanDtl: Record "Payment Plan Details";
        APmtEntry_1: Record "Application Payment Entry";
        NewAPmtEntry_1: Record "NewApplication Payment Entry";
        DelApplication: Record Application;
    begin
        NewAppBooking.TESTFIELD(Status, NewAppBooking.Status::Released);
        IF NewAppBooking."Application Type" = NewAppBooking."Application Type"::Trading THEN BEGIN
            CreateApplicationInTrading(NewAppBooking);
        END;
        CreateBond.NewCreateBondfromApplication(NewAppBooking);

        IF NewAppBooking."Application Type" = NewAppBooking."Application Type"::"Non Trading" THEN BEGIN
            PaymentPlanDtl.RESET;
            PaymentPlanDtl.SETRANGE("Document No.", NewAppBooking."Application No.");
            PaymentPlanDtl.SETRANGE("Project Code", NewAppBooking."Shortcut Dimension 1 Code");
            IF PaymentPlanDtl.FINDSET THEN
                REPEAT
                    PaymentPlanDtl.DELETE;
                UNTIL PaymentPlanDtl.NEXT = 0;
        END;

        CreateUnitLifeCycle(NewAppBooking); //040919

        APmtEntry_1.RESET;
        APmtEntry_1.SETRANGE("Document No.", NewAppBooking."Application No.");
        IF APmtEntry_1.FINDFIRST THEN BEGIN
            NewAPmtEntry_1.RESET;
            NewAPmtEntry_1.SETRANGE("Document No.", NewAppBooking."Application No.");
            IF NewAPmtEntry_1.FINDFIRST THEN BEGIN
                NewAPmtEntry_1."Posted Document No." := APmtEntry_1."Posted Document No.";
                NewAPmtEntry_1.MODIFY;
            END;
        END;

        DelApplication.RESET;
        DelApplication.SETRANGE("Application No.", NewAppBooking."Application No.");
        IF DelApplication.FINDFIRST THEN
            DelApplication.DELETE;

        NewAppBooking.DELETE;
        COMMIT;
    end;


    procedure CreateApplicationInTrading(NewApplicationBook_1: Record "New Application Booking")
    var
        NewAppEntry_1: Record "NewApplication Payment Entry";
        LocalApplication: Record Application;
        AppEntry_1: Record "Application Payment Entry";
        AppRecord: Record Application;
        CompanywiseGL: Record "Company wise G/L Account";
        ExistsApp: Record Application;
        ExistAppPayentry: Record "Application Payment Entry";
        PaymentPlanDet_1: Record "Payment Plan Details";
        ExistApplication: Boolean;
        CreatUPEntryfromApplication: Codeunit "Creat UPEry from ConfOrder/APP";
        ReleaseBondApplication: Codeunit "Release Unit Application";
    begin
        NewAppEntry_1.RESET;
        NewAppEntry_1.SETRANGE("Document No.", NewApplicationBook_1."Application No.");
        NewAppEntry_1.SETRANGE("Receipt post on InterComp", FALSE);
        IF NewAppEntry_1.FINDFIRST THEN BEGIN
            ExistApplication := FALSE;
            ExistsApp.RESET;
            ExistsApp.SETRANGE("Application No.", NewApplicationBook_1."Application No.");
            IF NOT ExistsApp.FINDFIRST THEN BEGIN
                PaymentPlanDet_1.RESET;
                PaymentPlanDet_1.SETRANGE("Document No.", NewApplicationBook_1."Application No.");
                IF PaymentPlanDet_1.FINDSET THEN
                    REPEAT
                        PaymentPlanDet_1.DELETE;
                    UNTIL PaymentPlanDet_1.NEXT = 0;
                LocalApplication.INIT;
                LocalApplication."Application No." := NewApplicationBook_1."Application No.";
                LocalApplication."Investment Type" := LocalApplication."Investment Type"::FD;
                LocalApplication.INSERT;
                LocalApplication.VALIDATE(Type, NewApplicationBook_1.Type);
                LocalApplication."Application Type" := LocalApplication."Application Type"::Trading;
                LocalApplication.VALIDATE("Shortcut Dimension 1 Code", NewApplicationBook_1."Shortcut Dimension 1 Code");
                LocalApplication.VALIDATE("Customer No.", NewApplicationBook_1."Customer No.");
                LocalApplication.VALIDATE("Posting Date", NewApplicationBook_1."Posting Date");
                LocalApplication.VALIDATE("Document Date", NewApplicationBook_1."Document Date");
                LocalApplication.VALIDATE("Associate Code", NewApplicationBook_1."Associate Code");
                LocalApplication.VALIDATE("Unit Payment Plan", NewApplicationBook_1."Unit Payment Plan");
                LocalApplication.VALIDATE("Unit Code", NewApplicationBook_1."Unit Code");
                CompanywiseGL.RESET;
                CompanywiseGL.SETRANGE("MSC Company", TRUE);
                IF CompanywiseGL.FINDFIRST THEN
                    LocalApplication."Company Name" := CompanywiseGL."Company Code";
                LocalApplication."User ID" := NewApplicationBook_1."User Id";
                LocalApplication."Registration Bonus Hold(BSP2)" := TRUE;
                LocalApplication.MODIFY;
                ExistApplication := TRUE;
            END;

            ExistAppPayentry.RESET;
            ExistAppPayentry.SETRANGE("Document No.", NewAppEntry_1."Document No.");
            ExistAppPayentry.SETRANGE("Line No.", NewAppEntry_1."Line No.");
            IF NOT ExistAppPayentry.FINDFIRST THEN BEGIN
                CLEAR(AppEntry_1);
                AppEntry_1.RESET;
                AppEntry_1.INIT;
                AppEntry_1."Document Type" := AppEntry_1."Document Type"::Application;
                AppEntry_1."Document No." := LocalApplication."Application No.";
                AppEntry_1."Line No." := NewAppEntry_1."Line No.";
                AppEntry_1.Type := AppEntry_1.Type::Received;
                AppEntry_1.INSERT;
                AppEntry_1.VALIDATE("Payment Mode", NewAppEntry_1."Payment Mode");
                AppEntry_1."Payment Method" := NewAppEntry_1."Payment Method";
                AppEntry_1.Description := NewAppEntry_1.Description;
                AppEntry_1."Cheque No./ Transaction No." := NewAppEntry_1."Cheque No./ Transaction No.";
                AppEntry_1."Cheque Date" := NewAppEntry_1."Cheque Date";
                AppEntry_1."Cheque Bank and Branch" := NewAppEntry_1."Cheque Bank and Branch";
                AppEntry_1."Deposit/Paid Bank" := NewAppEntry_1."Deposit/Paid Bank";
                AppEntry_1."User Branch Code" := NewAppEntry_1."User Branch Code";
                AppEntry_1.VALIDATE(Amount, NewAppEntry_1.Amount);
                AppEntry_1.VALIDATE("Posting date", NewAppEntry_1."Posting date");
                AppEntry_1.VALIDATE("Document Date", NewAppEntry_1."Posting date");
                AppEntry_1.VALIDATE("Shortcut Dimension 1 Code", NewAppEntry_1."Shortcut Dimension 1 Code");
                AppEntry_1."MSC Post Doc. No." := NewAppEntry_1."Posted Document No.";
                AppEntry_1."Reverse Commission" := NewAppEntry_1."Commmission Reverse";
                AppEntry_1."Application No." := NewAppEntry_1."Document No.";
                AppEntry_1."Bank Type" := NewAppEntry_1."Bank Type";
                AppEntry_1."Commission Reversed" := NewAppEntry_1."Commmission Reverse";  //ALLE240415
                AppEntry_1."User ID" := NewAppEntry_1."User ID";
                AppEntry_1."Entry From MSC" := TRUE;
                AppEntry_1.Narration := NewAppEntry_1.Narration;
                AppEntry_1."Receipt Line No." := NewAppEntry_1."Line No."; //ALLEDK 10112016
                AppEntry_1.MODIFY;
            END;
            IF ExistApplication THEN BEGIN
                CreatUPEntryfromApplication.CreateUPEntryfromApplication(LocalApplication);
                ReleaseBondApplication.ReleaseApplication(LocalApplication, FALSE);
                AppRecord.CreateConOrder(LocalApplication);
            END ELSE BEGIN
                CreatUPEntryfromApplication.CreateUPEntryfromApplication(ExistsApp);
                ReleaseBondApplication.ReleaseApplication(ExistsApp, FALSE);
                AppRecord.CreateConOrder(ExistsApp);

            END;
            NewAppEntry_1."Receipt post on InterComp" := TRUE;
            NewAppEntry_1."Receipt post InterComp Date" := TODAY;
            NewAppEntry_1.MODIFY;
        END;
    end;

    local procedure CreateUnitLifeCycle(newAppBooking_1: Record "New Application Booking")
    var
        UnitLifeCycle: Record "Unit Life Cycle";
        OldUnitLifeCycle: Record "Unit Life Cycle";
        LineNo: Integer;
        ExistUnitLifeCycle: Record "Unit Life Cycle";
        UnitMaster_1: Record "Unit Master";
    begin
        LineNo := 0;
        OldUnitLifeCycle.RESET;
        OldUnitLifeCycle.SETRANGE("Unit Code", newAppBooking_1."Unit Code");
        IF OldUnitLifeCycle.FINDLAST THEN
            LineNo := OldUnitLifeCycle."Line No.";

        UnitLifeCycle.INIT;
        UnitLifeCycle.TRANSFERFIELDS(OldUnitLifeCycle);
        UnitLifeCycle."Unit Code" := newAppBooking_1."Unit Code";
        UnitLifeCycle."Line No." := LineNo + 1;
        UnitLifeCycle."Unit Allocation Date" := TODAY;
        UnitLifeCycle."Unit Allocation Time" := TIME;
        UnitLifeCycle."Unit Payment Plan" := newAppBooking_1."Unit Payment Plan";
        IF UnitMaster_1.GET(newAppBooking_1."Unit Code") THEN
            UnitLifeCycle."Unit Cost" := UnitMaster_1."Total Value";
        UnitLifeCycle."Application Unit Cost" := newAppBooking_1."Investment Amount";
        UnitLifeCycle."Type of Transaction" := UnitLifeCycle."Type of Transaction"::"Unit Assigned";
        UnitLifeCycle.INSERT;
    end;

    local procedure "-----------PostConfirmed Receipt-----------"()
    begin
    end;


    procedure PostConfirmedReceipt(NewConfirmedOrders: Record "New Confirmed Order"; FromBatch: Boolean)
    var
        AmountToWords: Codeunit "Amount To Words";
        AmountText1: array[2] of Text[300];
        AppPayEntry_1: Record "Application Payment Entry";
        MemberOf: Record "Access Control";
        AppPayEntry: Record "NewApplication Payment Entry";
        BondSetup: Record "Unit Setup";
        PaymentAmt: Decimal;
        NewAppEntry: Record "NewApplication Payment Entry";
        Amt1: Decimal;
        AppPaymentEntryNew: Record "NewApplication Payment Entry";
        Text50001: Label 'Do you want to Refund?';
        Text50002: Label 'Please verify the details below and confirm. Do you want to post ? %1      :%2\Project Name         :%3  Project Code :%4\Unit No.                 :%5\Customer Name     :%6 %7\Associate Code      :%8  %9 \Receiving Amount  : %10 \Amount in Words   : %11 \Posting Date          : %12.';
        Text50003: Label 'Do you want to send message to customer %1?';
        Text50004: Label 'The total receive amount is going to excess with value %1. Do you want to continue?';
        Customer: Record Customer;
        Text006: Label 'Are you sure you want to post the entries';
        OldConforder: Record "Confirmed Order";
        PostPayment: Codeunit PostPayment;
        Text007: Label 'Posting Done';
        ComInfo: Record "Company Information";
        CustMobileNo: Text;
        CustSMSText: Text;
    begin

        AppPayEntry_1.RESET;
        AppPayEntry_1.CHANGECOMPANY(NewConfirmedOrders."Company Name");
        AppPayEntry_1.SETRANGE("Document No.", NewConfirmedOrders."No.");
        AppPayEntry_1.SETRANGE(Posted, TRUE);
        AppPayEntry_1.SETRANGE("Discount Payment Type", AppPayEntry_1."Discount Payment Type"::Forfeit);
        IF AppPayEntry_1.FINDFIRST THEN
            ERROR('You have already done Forefit entry');

        IF NOT FromBatch THEN BEGIN
            MemberOf.RESET;
            MemberOf.SETRANGE("User Name", USERID);
            MemberOf.SETRANGE("Role ID", 'A_Refund');
            IF NOT MemberOf.FINDFIRST THEN BEGIN
                AppPayEntry.RESET;
                AppPayEntry.SETRANGE("Document No.", NewConfirmedOrders."No.");
                AppPayEntry.SETFILTER("Payment Mode", '%1|%2', AppPayEntry."Payment Mode"::"Refund Cash",
                AppPayEntry."Payment Mode"::"Refund Bank");
                AppPayEntry.SETFILTER("Cheque Status", '<>%1', AppPayEntry."Cheque Status"::Bounced);
                AppPayEntry.SETRANGE(Posted, TRUE);
                IF AppPayEntry.FINDFIRST THEN
                    ERROR('This application' + ' ' + AppPayEntry."Application No." +
                    'has Refund Entry. So you can not post receipt or other transaction');
            END;
        END;
        BondSetup.GET;
        BondSetup.TESTFIELD(BondSetup."Bar Code no. Series");


        IF NewConfirmedOrders.Status = NewConfirmedOrders.Status::Forfeit THEN
            ERROR('Status can not be Forefit');
        //BBG2.00 310714
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document No.", NewConfirmedOrders."No.");
        AppPayEntry.SETRANGE(Posted, FALSE);
        AppPayEntry.SETRANGE(Amount, 0);
        IF AppPayEntry.FINDFIRST THEN
            AppPayEntry.TESTFIELD(Amount);
        //BBG2.00 310714


        CLEAR(PaymentAmt);
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document No.", NewConfirmedOrders."No.");
        AppPayEntry.SETRANGE(Posted, FALSE);
        IF AppPayEntry.FINDSET THEN
            REPEAT
                PaymentAmt += AppPayEntry.Amount;
                IF AppPayEntry.COUNT > 1 THEN
                    ERROR('Single receipt entry allowed');
            UNTIL AppPayEntry.NEXT = 0;

        AmountToWords.InitTextVariable;
        AmountToWords.FormatNoText(AmountText1, PaymentAmt, '');
        //ALLECK 130313 START
        CLEAR(AppPayEntry);
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document No.", NewConfirmedOrders."No.");
        AppPayEntry.SETFILTER(Amount, '<>%1', 0);
        AppPayEntry.SETRANGE(Posted, FALSE);
        IF AppPayEntry.FINDLAST THEN
            IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::" " THEN
                ERROR('Please define the Payment Mode.');
        //ALLECK 130313 END

        NewAppEntry.RESET;
        NewAppEntry.SETRANGE("Document No.", NewConfirmedOrders."Application No.");
        NewAppEntry.SETRANGE(Posted, FALSE);
        IF NewAppEntry.FINDFIRST THEN
            REPEAT
                IF NewAppEntry."Payment Mode" = NewAppEntry."Payment Mode"::Bank THEN
                    NewAppEntry.TESTFIELD("Bank Type", NewAppEntry."Bank Type"::ProjectCompany);
            UNTIL NewAppEntry.NEXT = 0;

        Amt1 := 0;
        AppPaymentEntryNew.RESET;
        AppPaymentEntryNew.SETRANGE("Document No.", NewConfirmedOrders."No.");
        AppPaymentEntryNew.SETFILTER("Cheque Status", '<>%1', AppPaymentEntryNew."Cheque Status"::Bounced);
        IF AppPaymentEntryNew.FINDSET THEN
            REPEAT
                Amt1 := Amt1 + AppPaymentEntryNew.Amount;
            UNTIL AppPaymentEntryNew.NEXT = 0;

        IF Amt1 > NewConfirmedOrders.Amount THEN
            IF CONFIRM(STRSUBSTNO(Text50004, (Amt1 - NewConfirmedOrders.Amount))) THEN BEGIN
            END ELSE
                EXIT;



        IF NOT FromBatch THEN BEGIN
            IF CONFIRM(STRSUBSTNO(Text50002, NewConfirmedOrders.FIELDCAPTION("Application No."), NewConfirmedOrders."Application No.",
               GetDescription.GetDimensionName(NewConfirmedOrders."Shortcut Dimension 1 Code", 1), NewConfirmedOrders."Shortcut Dimension 1 Code", NewConfirmedOrders."Unit Code", Customer.Name,
               NewConfirmedOrders."Customer No.", NewConfirmedOrders."Introducer Code", Vend.Name,
               PaymentAmt, AmountText1[1], AppPayEntry."Posting date")) THEN BEGIN
                IF CONFIRM(Text006) THEN BEGIN //ALLECK020313
                                               //ALLECK 020313 END
                    IF NewConfirmedOrders."Application Type" = NewConfirmedOrders."Application Type"::Trading THEN BEGIN
                        OldConforder.RESET;
                        OldConforder.SETRANGE("No.", NewConfirmedOrders."No.");
                        IF OldConforder.FINDFIRST THEN
                            CreateReceiptEntry(OldConforder);
                    END ELSE BEGIN
                        NewAppEntry.RESET;
                        NewAppEntry.SETRANGE("Document No.", NewConfirmedOrders."Application No.");
                        NewAppEntry.SETRANGE(Posted, FALSE);
                        IF NewAppEntry.FINDLAST THEN BEGIN
                            PostPayment.NewPostBondPayment(NewConfirmedOrders, 'Payment Received');
                        END;
                    END;
                    MESSAGE(Text007);

                    ComInfo.GET;
                    IF ComInfo."Send SMS" THEN BEGIN
                        IF Customer.GET(NewConfirmedOrders."Customer No.") THEN BEGIN
                            IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                CustMobileNo := Customer."BBG Mobile No.";
                                AppPayEntry.RESET;
                                AppPayEntry.SETRANGE("Document No.", NewConfirmedOrders."Application No.");
                                AppPayEntry.SETRANGE(Posted, TRUE);
                                IF AppPayEntry.FINDLAST THEN BEGIN
                                    IF (AppPayEntry.Amount <> 0) THEN BEGIN
                                        IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Cash) THEN
                                            CustSMSText :=
                                            'Mr/Mrs/Ms:' + Customer.Name + 'Appl No:' + NewConfirmedOrders."Application No." + ' ' +
                                            'Recvd Rs.' + FORMAT(AppPayEntry.Amount) +
                                            ' ' + 'Project: ' + GetDescription.GetDimensionName(NewConfirmedOrders."Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' +
                                            FORMAT(AppPayEntry."Posting date")
                                        ELSE
                                            CustSMSText :=
                                            'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to BBG Family. Appl No:' + NewConfirmedOrders."Application No." +
                                            ' ' + 'Recvd Rs.' + FORMAT(AppPayEntry.Amount) +
                                            ' ' + 'Project: ' + GetDescription.GetDimensionName(NewConfirmedOrders."Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' +
                                            FORMAT(AppPayEntry."Posting date") + 'Tx for payment(If Chq-Subject to Realization).';

                                        MESSAGE('%1', CustSMSText);
                                        PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                        //ALLEDK15112022 Start
                                        CLEAR(SMSLogDetails);
                                        SmsMessage := '';
                                        SmsMessage1 := '';
                                        SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                        SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                        SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Customer Receipt',
                                        NewConfirmedOrders."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(NewConfirmedOrders."Shortcut Dimension 1 Code", 1),
                                        NewConfirmedOrders."Application No.");
                                        //ALLEDK15112022 END
                                    END;
                                END;
                            END
                            ELSE
                                MESSAGE('%1', 'Mobile No. not Found');
                        END;
                    END;
                END;
            END;
            //---------New Code-----
        END ELSE BEGIN
            IF NewConfirmedOrders."Application Type" = NewConfirmedOrders."Application Type"::Trading THEN BEGIN
                OldConforder.RESET;
                OldConforder.SETRANGE("No.", NewConfirmedOrders."No.");
                IF OldConforder.FINDFIRST THEN
                    CreateReceiptEntry(OldConforder);
            END ELSE BEGIN
                NewAppEntry.RESET;
                NewAppEntry.SETRANGE("Document No.", NewConfirmedOrders."Application No.");
                NewAppEntry.SETRANGE(Posted, FALSE);
                IF NewAppEntry.FINDLAST THEN BEGIN
                    PostPayment.NewPostBondPayment(NewConfirmedOrders, 'Payment Received');
                END;
            END;
        END;
    end;


    procedure CreateReceiptEntry(OldConfOrder_1: Record "Confirmed Order")
    var
        ExcessAmount: Decimal;
        AppPayEntry_1: Record "Application Payment Entry";
        NewAppEntry_1: Record "NewApplication Payment Entry";
        LineNo_1: Integer;
        AppPayEntry_2: Record "Application Payment Entry";
        CreatUPEryfromConfOrder: Codeunit "Creat UPEry from ConfOrder/APP";
        PostPayment: Codeunit PostPayment;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        BondSetup: Record "Unit Setup";
    begin
        LineNo_1 := 0;
        BondSetup.GET;
        NewAppEntry_1.RESET;
        NewAppEntry_1.SETRANGE("Document No.", OldConfOrder_1."No.");
        NewAppEntry_1.SETRANGE("Receipt post on InterComp", FALSE);
        NewAppEntry_1.SETRANGE("User ID", USERID);
        IF NewAppEntry_1.FINDLAST THEN BEGIN
            AppPayEntry_1.RESET;
            AppPayEntry_1.SETRANGE("Document No.", OldConfOrder_1."No.");
            IF AppPayEntry_1.FINDLAST THEN
                LineNo_1 := AppPayEntry_1."Line No.";
            CLEAR(AppPayEntry_1);
            AppPayEntry_1.RESET;
            AppPayEntry_1.INIT;
            AppPayEntry_1."Document Type" := NewAppEntry_1."Document Type"::BOND;
            AppPayEntry_1."Document No." := NewAppEntry_1."Document No.";
            AppPayEntry_1."Line No." := LineNo_1 + 10000;
            AppPayEntry_1.INSERT;
            AppPayEntry_1."Adjmt. Line No." := NewAppEntry_1."Adjmt. Line No.";
            AppPayEntry_1.VALIDATE("Payment Mode", NewAppEntry_1."Payment Mode");
            AppPayEntry_1.VALIDATE("Payment Method", NewAppEntry_1."Payment Method");
            AppPayEntry_1.Description := NewAppEntry_1.Description;
            AppPayEntry_1."Cheque No./ Transaction No." := NewAppEntry_1."Cheque No./ Transaction No.";
            AppPayEntry_1."Cheque Date" := NewAppEntry_1."Cheque Date";
            AppPayEntry_1."Cheque Bank and Branch" := NewAppEntry_1."Cheque Bank and Branch";
            AppPayEntry_1."Deposit/Paid Bank" := NewAppEntry_1."Deposit/Paid Bank";
            AppPayEntry_1."User Branch Code" := NewAppEntry_1."User Branch Code";
            AppPayEntry_1."Bank Type" := NewAppEntry_1."Bank Type";
            AppPayEntry_1.VALIDATE(Amount, NewAppEntry_1.Amount);
            AppPayEntry_1.VALIDATE("Posting date", NewAppEntry_1."Posting date");
            AppPayEntry_1.VALIDATE("Document Date", NewAppEntry_1."Posting date");
            AppPayEntry_1.VALIDATE("Shortcut Dimension 1 Code", OldConfOrder_1."Shortcut Dimension 1 Code");
            AppPayEntry_1."MSC Post Doc. No." := NewAppEntry_1."Posted Document No.";
            AppPayEntry_1."Reverse Commission" := NewAppEntry_1."Commmission Reverse";
            AppPayEntry_1."Application No." := NewAppEntry_1."Document No.";
            AppPayEntry_1."User ID" := NewAppEntry_1."User ID";
            AppPayEntry_1."Commission Reversed" := NewAppEntry_1."Commmission Reverse";  //ALLE240415
            AppPayEntry_1."Entry From MSC" := FALSE;
            AppPayEntry_1.Narration := NewAppEntry_1.Narration;
            AppPayEntry_1."Receipt Line No." := NewAppEntry_1."Line No."; //ALLEDK 10112016
            AppPayEntry_1.MODIFY;
            CLEAR(ExcessAmount);
            ExcessAmount := CreatUPEryfromConfOrder.CheckExcessAmount(OldConfOrder_1);
            IF ExcessAmount <> 0 THEN
                CreatUPEryfromConfOrder.CreateExcessPaymentTermsLine(OldConfOrder_1."No.", ExcessAmount);
            CreatUPEryfromConfOrder.RUN(OldConfOrder_1);
            PostPayment.PostBondPayment(OldConfOrder_1, FALSE);
            NewAppEntry_1."Receipt post on InterComp" := TRUE;
            NewAppEntry_1."Receipt post InterComp Date" := TODAY;
            AppPayEntry_2.RESET;
            AppPayEntry_2.SETRANGE("Document No.", OldConfOrder_1."No.");
            IF AppPayEntry_2.FINDLAST THEN
                NewAppEntry_1."Posted Document No." := AppPayEntry_2."Posted Document No.";
            NewAppEntry_1."BarCode No." := NoSeriesMgt.GetNextNo(BondSetup."Bar Code no. Series", TODAY, TRUE);
            NewAppEntry_1.Posted := TRUE;
            NewAppEntry_1.MODIFY;
        END;
    end;

    procedure CalculateCommissionAmount(ConfOrder_P: Record "Confirmed Order"; AssHierarcywithApp_P: Record "Associate Hierarcy with App."; CommissionBaseAmt: Decimal; FullPayment: Boolean; CommGenerated: Boolean): Decimal  //06102025 change local funciton to normal funciton
    var
        CommissionStructrAmountBase: Record "Commission Structr Amount Base";
        OtherRate: Decimal;
        v_DocumentMaster: Record "Document Master";
        CommisionAmounts: Decimal;
        MinAmt: Decimal;
        ProjectwiseDevelopmentCharg: Record "Project wise Development Charg";
        EndDate: Date;
        DevelopmentCharges: Decimal;
        V_AssHierarcywithApp1: Record "Associate Hierarcy with App.";
        OldRankCode: Decimal;
        RatePerSq: Decimal;
        Old_CommissionStructrAmountBase: Record "Commission Structr Amount Base";
        CheckDesgCommStrAmountBase: Record "Commission Structr Amount Base";
        FindOldRank: Boolean;
        PrintRateperSq: Decimal;

        AssHierarcywithApplication_2: Record "Associate Hierarcy with App.";
    begin
        //251023
        CommisionAmounts := 0;
        OldRankCode := 0;
        MinAmt := 0;
        RatePerSq := 0;
        FindOldRank := FALSE;
        Old_CommissionStructrAmountBase.RESET;
        Old_CommissionStructrAmountBase.SETRANGE("Project Code", ConfOrder_P."Shortcut Dimension 1 Code");
        Old_CommissionStructrAmountBase.SETRANGE("Payment Plan Code", ConfOrder_P."Unit Payment Plan");
        Old_CommissionStructrAmountBase.SETFILTER("Start Date", '<=%1', ConfOrder_P."Posting Date");
        Old_CommissionStructrAmountBase.SETFILTER("End Date", '>=%1', ConfOrder_P."Posting Date");
        Old_CommissionStructrAmountBase.SETRANGE("Desg. Code", AssHierarcywithApp_P."Rank Code");
        Old_CommissionStructrAmountBase.SetRange("Rank Code", ConfOrder_P."Region Code"); //Code added 01072025

        //Old_CommissionStructrAmountBase.SETFILTER("Commission % on Min.Allotment", '<>%1', 0);  //Code commented 01072025
        Old_CommissionStructrAmountBase.SETFILTER("% Per Square", '<>%1', 0);  //Code Added 01072025
        IF Old_CommissionStructrAmountBase.FINDFIRST THEN BEGIN

            V_AssHierarcywithApp1.RESET;
            V_AssHierarcywithApp1.SETCURRENTKEY("Application Code", "Rank Code", Status);
            V_AssHierarcywithApp1.SETRANGE("Application Code", ConfOrder_P."No.");
            V_AssHierarcywithApp1.SETFILTER("Rank Code", '<%1', AssHierarcywithApp_P."Rank Code");
            V_AssHierarcywithApp1.SETRANGE(Status, V_AssHierarcywithApp1.Status::Active);
            V_AssHierarcywithApp1.ASCENDING(FALSE);
            IF V_AssHierarcywithApp1.FINDSET THEN
                REPEAT
                    CheckDesgCommStrAmountBase.RESET;
                    CheckDesgCommStrAmountBase.SETRANGE("Project Code", ConfOrder_P."Shortcut Dimension 1 Code");
                    CheckDesgCommStrAmountBase.SETRANGE("Payment Plan Code", ConfOrder_P."Unit Payment Plan");
                    CheckDesgCommStrAmountBase.SETFILTER("Start Date", '<=%1', ConfOrder_P."Posting Date");
                    CheckDesgCommStrAmountBase.SETFILTER("End Date", '>=%1', ConfOrder_P."Posting Date");
                    CheckDesgCommStrAmountBase.SETRANGE("Desg. Code", V_AssHierarcywithApp1."Rank Code");
                    CheckDesgCommStrAmountBase.SETFILTER("% Per Square", '<>%1', 0);  //Code Added 01072025
                    CheckDesgCommStrAmountBase.SetRange("Rank Code", ConfOrder_P."Region Code");  //Code added 01072025
                    //CheckDesgCommStrAmountBase.SETFILTER("Commission % on Min.Allotment", '<>%1', 0); //Code commented 01072025

                    IF CheckDesgCommStrAmountBase.FINDFIRST THEN BEGIN
                        OldRankCode := CheckDesgCommStrAmountBase."Desg. Code" + 0.0001;
                        FindOldRank := TRUE;
                    END ELSE
                        OldRankCode := 0.0001;
                UNTIL (V_AssHierarcywithApp1.NEXT = 0) OR (FindOldRank = TRUE);

            OtherRate := 0;
            PrintRateperSq := 0;
            CommissionStructrAmountBase.RESET;
            CommissionStructrAmountBase.SETRANGE("Project Code", ConfOrder_P."Shortcut Dimension 1 Code");
            CommissionStructrAmountBase.SETRANGE("Payment Plan Code", ConfOrder_P."Unit Payment Plan");
            CommissionStructrAmountBase.SETFILTER("Start Date", '<=%1', ConfOrder_P."Posting Date");
            CommissionStructrAmountBase.SETFILTER("End Date", '>=%1', ConfOrder_P."Posting Date");
            CommissionStructrAmountBase.SETRANGE("Desg. Code", OldRankCode, AssHierarcywithApp_P."Rank Code");
            CommissionStructrAmountBase.SETFILTER("% Per Square", '<>%1', 0);  //Code Change 01072025
            CommissionStructrAmountBase.SetRange("Rank Code", ConfOrder_P."Region Code");  //Code added 01072025
            IF CommissionStructrAmountBase.FINDSET THEN BEGIN
                REPEAT
                    RatePerSq := RatePerSq + CommissionStructrAmountBase."% Per Square";
                    PrintRateperSq := PrintRateperSq + CommissionStructrAmountBase."Rate Per Square";

                    IF CommissionStructrAmountBase."% Per Square" <> 0 THEN begin  //Code added 01072025
                        v_DocumentMaster.RESET;
                        v_DocumentMaster.SETRANGE("Project Code", ConfOrder_P."Shortcut Dimension 1 Code");
                        v_DocumentMaster.SETRANGE("Unit Code", ConfOrder_P."Unit Code");
                        v_DocumentMaster.SETRANGE(Code, 'BSP3');
                        IF v_DocumentMaster.FINDFIRST THEN BEGIN
                            IF v_DocumentMaster."App. Charge Code" = '1002' THEN
                                OtherRate := CommissionStructrAmountBase."East Facing Rate Per Sq.";
                            IF v_DocumentMaster."App. Charge Code" = '1003' THEN
                                OtherRate := CommissionStructrAmountBase."Corner Rate Per Square";
                            IF v_DocumentMaster."App. Charge Code" = '1004' THEN
                                OtherRate := CommissionStructrAmountBase."60 Ft Rate Per Square";
                            IF v_DocumentMaster."App. Charge Code" = '1005' THEN
                                OtherRate := CommissionStructrAmountBase."Corner And 60 Ft Rate Per Sq.";
                        END;
                    END;   //Code added 01072025
                UNTIL CommissionStructrAmountBase.NEXT = 0;


                //280425 Old code comment Rate per Square Start
                // IF FullPayment THEN BEGIN
                //     IF NOT CommGenerated THEN
                //         CommisionAmounts := ((RatePerSq + OtherRate) * ConfOrder_P."Saleable Area") * ((100 - CommissionStructrAmountBase."Commission % on Min.Allotment") / 100)
                //     ELSE
                //         CommisionAmounts := ((RatePerSq + OtherRate) * ConfOrder_P."Saleable Area");
                // END ELSE
                //     CommisionAmounts := ((RatePerSq) * ConfOrder_P."Saleable Area") * (CommissionStructrAmountBase."Commission % on Min.Allotment" / 100);    //remove this 240425 "+ OtherRate"

                IF FullPayment THEN BEGIN
                    IF NOT CommGenerated THEN
                        CommisionAmounts := (CommissionBaseAmt * RatePerSq / 100) // * ((100 - CommissionStructrAmountBase."Commission % on Min.Allotment") / 100)
                    ELSE
                        CommisionAmounts := (CommissionBaseAmt * RatePerSq / 100);
                END ELSE
                    CommisionAmounts := (CommissionBaseAmt * RatePerSq / 100);// * (CommissionStructrAmountBase."Commission % on Min.Allotment" / 100);    //remove this 240425 "+ OtherRate"

                //280425 added code END
                //300425 Code added start

                AssHierarcywithApplication_2.RESET;
                AssHierarcywithApplication_2.SetRange(AssHierarcywithApplication_2."Application Code", AssHierarcywithApp_P."Application Code");
                AssHierarcywithApplication_2.SETRANGE("Line No.", AssHierarcywithApp_P."Line No.");
                IF AssHierarcywithApplication_2.FindFirst() THEN BEGIN
                    AssHierarcywithApplication_2."Commission Rate/SQD" := PrintRateperSq + OtherRate;
                    AssHierarcywithApplication_2."Commission %" := RatePerSq;  //06062025 added
                    AssHierarcywithApplication_2.Modify;
                END;
                //300425 Code added END

            END;
            EXIT(CommisionAmounts);
        END ELSE
            EXIT(0);
    end;

}

