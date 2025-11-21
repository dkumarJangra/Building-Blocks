report 50062 "Generate Coin Entry"
{
    // version North

    //  ALLE_NB 181012: Adding Calculate Eligibilty Command Button.
    //  ALLE_NB 251012: Skipping the insertion of already existing Gold Coin Eligibility Records.
    // 
    // ALLEDK 210213 ADDED on DataItem Filter of Type= Normal. Gold coin generate only Normal Booking
    // ALLEDK 050216 Added new function (InsertSilverCoin) for Silver Coin
    // Added new code 060323 for calculate the Gold and Silver condition Base.

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Confirmed Order"; "Confirmed Order")
        {
            CalcFields = "Total Received Amount";
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE(Type = FILTER(Normal),
                                      "Application Transfered" = FILTER(false));
            RequestFilterFields = "Customer No.", "Shortcut Dimension 1 Code", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                CLEAR(APPPaymentEntry);
                APPPaymentEntry.RESET;
                APPPaymentEntry.SETRANGE("Document No.", "No.");
                APPPaymentEntry.SETRANGE("Cheque Status", APPPaymentEntry."Cheque Status"::Cleared);
                //APPPaymentEntry.SETRANGE("Posting date",0D,EleDate);
                APPPaymentEntry.SETRANGE("Payment Mode", APPPaymentEntry."Payment Mode"::MJVM);
                APPPaymentEntry.SETFILTER(Amount, '<>%1', 0);
                IF APPPaymentEntry.FINDFIRST THEN
                    CurrReport.SKIP;


                UnitSEtup.GET;
                BBGSetups.GET;  //Added new code 060323
                BBGSetups.TESTFIELD("Gold/Silver New Setup StDt.");    //Added new code 060323
                BBGSetups.TESTFIELD("Gold/Silver New Setup EndDt.");   //Added new code 060323
                ProcessGoforNewSetup := FALSE;   //Added new code 060323
                IF ("Confirmed Order"."Posting Date" >= BBGSetups."Gold/Silver New Setup StDt.") AND ("Confirmed Order"."Posting Date" <= BBGSetups."Gold/Silver New Setup EndDt.") THEN BEGIN
                    ProjecWiseNewGoldSilver.RESET;
                    ProjecWiseNewGoldSilver.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                    IF ProjecWiseNewGoldSilver.FINDFIRST THEN BEGIN
                        ProcessGoforNewSetup := TRUE;   //Added new code 060323
                        IF "Confirmed Order"."Posting Date" >= EffectiveDateforR2 THEN BEGIN
                            Amt := 0;
                            NoofCoins := 0;
                            NoofCoins := ROUND(("Confirmed Order"."Saleable Area" / ProjecWiseNewGoldSilver.Extent), 1, '<');

                            IF "Confirmed Order"."Unit Payment Plan" = ProjecWiseNewGoldSilver."Silver Payment Plan" THEN BEGIN
                                EleDate := 0D;
                                EleDate := CALCDATE(ProjecWiseNewGoldSilver."S_Valid Days for full payment", "Confirmed Order"."Posting Date");
                                CLEAR(APPPaymentEntry);
                                APPPaymentEntry.RESET;
                                APPPaymentEntry.SETRANGE("Document No.", "No.");
                                APPPaymentEntry.SETRANGE("Cheque Status", APPPaymentEntry."Cheque Status"::Cleared);
                                APPPaymentEntry.SETRANGE("Posting date", 0D, EleDate);
                                IF APPPaymentEntry.FINDSET THEN BEGIN
                                    REPEAT
                                        IF (APPPaymentEntry."Payment Mode" = APPPaymentEntry."Payment Mode"::Bank) THEN BEGIN
                                            IF (APPPaymentEntry."Chq. Cl / Bounce Dt." <= CALCDATE(UnitSEtup."No. of Cheque Buffer Days", APPPaymentEntry."Posting date")
                                                    ) THEN
                                                Amt := Amt + APPPaymentEntry.Amount;
                                        END ELSE BEGIN
                                            Amt := Amt + APPPaymentEntry.Amount;
                                        END;
                                    UNTIL APPPaymentEntry.NEXT = 0;

                                    IF (Amt >= "Confirmed Order".Amount) THEN BEGIN
                                        IF RunReportOption_1 <> 1 THEN BEGIN
                                            IF NOT "Confirmed Order"."Silver Coin Generated" THEN BEGIN
                                                NewInsertSilverCoinEntry(NoofCoins);
                                                "Silver Coin Generated" := TRUE;
                                                MODIFY;
                                            END;
                                        END;
                                    END;
                                END;
                            END;

                            IF RunReportOption_1 = 1 THEN BEGIN
                                EleDate := 0D;
                                Amt := 0;
                                EleDate := CALCDATE(ProjecWiseNewGoldSilver."G_Valid Days for full payment", "Confirmed Order"."Posting Date");
                                CLEAR(APPPaymentEntry);
                                APPPaymentEntry.RESET;
                                APPPaymentEntry.SETRANGE("Document No.", "No.");
                                APPPaymentEntry.SETRANGE("Cheque Status", APPPaymentEntry."Cheque Status"::Cleared);
                                APPPaymentEntry.SETRANGE("Posting date", 0D, EleDate);
                                IF APPPaymentEntry.FINDSET THEN
                                    REPEAT
                                        IF (APPPaymentEntry."Payment Mode" = APPPaymentEntry."Payment Mode"::Bank) THEN BEGIN
                                            IF (APPPaymentEntry."Chq. Cl / Bounce Dt." <= CALCDATE(UnitSEtup."No. of Cheque Buffer Days", APPPaymentEntry."Posting date")) THEN
                                                Amt := Amt + APPPaymentEntry.Amount
                                            ELSE
                                                Amt := Amt + APPPaymentEntry.Amount;
                                        END ELSE
                                            Amt := Amt + APPPaymentEntry.Amount;
                                    UNTIL APPPaymentEntry.NEXT = 0;
                                IF (Amt >= "Confirmed Order".Amount) THEN BEGIN
                                    IF NOT "Confirmed Order"."Gold Generated for R2" THEN BEGIN
                                        NewInsertGoldCoinEntry(NoofCoins);
                                        "Confirmed Order"."Gold Generated for R2" := TRUE;
                                        MODIFY;
                                    END;
                                END;
                            END;
                        END;
                    END;//   ELSE BEGIN
                END;   //Added new code 060323

                IF NOT ProcessGoforNewSetup THEN BEGIN   //Added new code 060323

                    SilverCoin := 0;
                    IF Status = Status::Registered THEN BEGIN
                        IF (NOT "Silver Coin Generated") AND ("Silver Coin Eligible") THEN BEGIN
                            GoldCoinSetup.RESET;
                            GoldCoinSetup.SETRANGE("Plot Size", "Saleable Area");
                            GoldCoinSetup.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                            GoldCoinSetup.SETRANGE("Effective Date", 0D, "Posting Date");
                            IF GoldCoinSetup.FINDLAST THEN BEGIN
                                SilverCoin := 0;
                                GoldCoinSetup.TESTFIELD("No. of Silver Coins on Reg.");
                                SilverCoin := GoldCoinSetup."No. of Silver Coins on Reg.";
                            END;
                        END;
                        IF SilverCoin > 0 THEN BEGIN
                            IF RunReportOption_1 <> 1 THEN BEGIN
                                InsertSilverCoinEntry;
                                "Silver Coin Generated" := TRUE;
                                MODIFY;
                            END;
                        END;
                    END;
                    CLEAR(APPPaymentEntry);
                    APPPaymentEntry.RESET;
                    APPPaymentEntry.SETRANGE("Document No.", "No.");
                    APPPaymentEntry.SETRANGE("Cheque Status", APPPaymentEntry."Cheque Status"::Cleared);
                    //APPPaymentEntry.SETRANGE("Posting date",0D,EleDate);
                    APPPaymentEntry.SETRANGE("Payment Mode", APPPaymentEntry."Payment Mode"::MJVM);
                    APPPaymentEntry.SETFILTER(Amount, '<>%1', 0);
                    IF APPPaymentEntry.FINDFIRST THEN
                        CurrReport.SKIP;




                    IF "Unit Code" <> '' THEN
                        IF UMAster.GET("Confirmed Order"."Unit Code") THEN;
                    UnitSEtup.GET;
                    UnitSEtup.TESTFIELD("No. of Cheque Buffer Days");
                    GoldCoinSetup.RESET;
                    IF "Unit Code" <> '' THEN
                        GoldCoinSetup.SETRANGE("Plot Size", UMAster."Saleable Area")
                    ELSE
                        GoldCoinSetup.SETRANGE("Plot Size", "Saleable Area");

                    GoldCoinSetup.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                    GoldCoinSetup.SETRANGE("Effective Date", 0D, "Posting Date");
                    IF GoldCoinSetup.FINDLAST THEN BEGIN
                        Amt := 0;
                        GoldCoin := 0;
                        EleDate := 0D;
                        EleDate := CALCDATE(GoldCoinSetup."Due Days", "Confirmed Order"."Posting Date");
                        CLEAR(APPPaymentEntry);
                        APPPaymentEntry.RESET;
                        APPPaymentEntry.SETRANGE("Document No.", "No.");
                        APPPaymentEntry.SETRANGE("Cheque Status", APPPaymentEntry."Cheque Status"::Cleared);
                        APPPaymentEntry.SETRANGE("Posting date", 0D, EleDate);
                        APPPaymentEntry.SETFILTER("Payment Mode", '<>%1', APPPaymentEntry."Payment Mode"::MJVM);
                        IF APPPaymentEntry.FINDSET THEN BEGIN
                            REPEAT
                                IF (APPPaymentEntry."Payment Mode" = APPPaymentEntry."Payment Mode"::Bank) THEN BEGIN
                                    IF (APPPaymentEntry."Chq. Cl / Bounce Dt." <= CALCDATE(UnitSEtup."No. of Cheque Buffer Days", APPPaymentEntry."Posting date")
                            )
                                      THEN
                                        Amt := Amt + APPPaymentEntry.Amount;
                                END ELSE BEGIN
                                    Amt := Amt + APPPaymentEntry.Amount;
                                END;
                            UNTIL APPPaymentEntry.NEXT = 0;

                            IF (Amt >= "Confirmed Order"."Min. Allotment Amount") AND (Amt < "Confirmed Order".Amount) THEN
                                GoldCoin := GoldCoinSetup."Min. No. of Gold Coins";

                            IF (Amt >= "Confirmed Order".Amount) THEN
                                GoldCoin := GoldCoinSetup."No. of Gold Coins on Full Pmt." + GoldCoinSetup."Min. No. of Gold Coins";
                        END;
                        IF (Amt > 0) THEN BEGIN
                            IF NOT "Confirmed Order"."Gold Coin Generated" THEN
                                IF RunReportOption_1 = 1 THEN
                                    InsertGoldCoinEntry;
                        END;
                    END ELSE BEGIN
                        IF UMAster.GET("Unit Code") THEN
                            ERROR(Text50001, UMAster."Saleable Area", "Confirmed Order"."Shortcut Dimension 1 Code", "Posting Date")
                        ELSE
                            ERROR(Text50001, "Saleable Area", "Confirmed Order"."Shortcut Dimension 1 Code", "Posting Date")
                    END;
                END;
            end;

            trigger OnPreDataItem()
            begin
                IF Cust1 <> '' THEN
                    SETFILTER("Customer No.", Cust1);
                IF ProjectCode1 <> '' THEN
                    SETFILTER("Shortcut Dimension 1 Code", ProjectCode1);
                IF EndDate1 <> 0D THEN BEGIN
                    SETRANGE("Posting Date", 20130301D, EndDate1);//010313D
                END ELSE
                    SETRANGE("Posting Date", 20130301D, TODAY);//010313D

                IF EffectiveDateforR2 = 0D THEN
                    ERROR('Please define Effective Date for R2');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Effective Date for R2"; EffectiveDateforR2)
                {
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        //IF NOT CONFIRM(Text50000) THEN
        //  ERROR('');
    end;

    var
        TotalFor: Label 'Total for ';
        Text50000: Label 'Do you want to generate coin eligibility lines?';
        Text50001: Label 'Gold Coin setup does not exists for Plot Size = %1, and project code=%2 and Date =%3';
        GoldCoinSetup: Record "Gold Coin Line";
        UnitSEtup: Record "Unit Setup";
        APPPaymentEntry: Record "Application Payment Entry";
        Cust: Record Customer;
        UMAster: Record "Unit Master";
        DimValue: Record "Dimension Value";
        Vend: Record Vendor;
        GLSETUP: Record "General Ledger Setup";
        LastPaymentEntry: Record "Application Payment Entry";
        GCoinEntry: Record "Gold Coin Eligibility";
        GoldCoinEntry: Record "Gold Coin Eligibility";
        goldcoineligiblity: Page "Gold Coin Eligibility";
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        GoldCoin: Integer;
        Amt: Decimal;
        DueDate: Date;
        FullAmt: Decimal;
        noofCoinIssued: Integer;
        LineNo: Integer;
        TotalnoofCoin: Integer;
        TempGoldCoinEligibility: Record "Gold Coin Eligibility";
        Cust1: Text[30];
        ProjectCode1: Code[20];
        EndDate1: Date;
        NoofGoldCoinAllot: Integer;
        EleDate: Date;
        SilverCoin: Integer;
        ProjecWiseNewGoldSilver: Record "Projec Wise New Gold/Silver";
        NoofCoins: Decimal;
        EffectiveDateforR2: Date;
        RunReportOption_1: Integer;
        BBGSetups: Record "BBG Setups";
        ProcessGoforNewSetup: Boolean;

    procedure InsertGoldCoinEntry()
    begin
        noofCoinIssued := 0;
        NoofGoldCoinAllot := 0;
        GoldCoinEntry.RESET;
        GoldCoinEntry.SETCURRENTKEY("Project Code", "Application No.");
        //GoldCoinEntry.SETRANGE("Project Code","Confirmed Order"."Shortcut Dimension 1 Code");
        GoldCoinEntry.SETRANGE("Application No.", "Confirmed Order"."No.");
        GoldCoinEntry.SETRANGE("Item Type", GoldCoinEntry."Item Type"::Gold); //050216
        IF GoldCoinEntry.FINDSET THEN
            REPEAT
                NoofGoldCoinAllot := NoofGoldCoinAllot + GoldCoinEntry."Eligibility Gold / Silver";
            UNTIL GoldCoinEntry.NEXT = 0;

        IF (GoldCoin - NoofGoldCoinAllot) > 0 THEN BEGIN

            GCoinEntry.RESET;
            GCoinEntry.SETRANGE("Application No.", "Confirmed Order"."No.");
            IF GCoinEntry.FINDLAST THEN
                LineNo := GCoinEntry."Line No."
            ELSE
                LineNo := 0;

            GCoinEntry.INIT;
            GCoinEntry."Project Code" := "Confirmed Order"."Shortcut Dimension 1 Code";
            GCoinEntry."Application No." := "Confirmed Order"."No.";
            GCoinEntry."Line No." := LineNo + 10000;
            GCoinEntry."Application Date" := "Confirmed Order"."Posting Date";
            GCoinEntry.VALIDATE("Customer No.", "Confirmed Order"."Customer No.");
            GCoinEntry."Due Amount" := "Confirmed Order".Amount - Amt; //"Confirmed Order"."Total Received Amount"; ALLEDK 210113
            GCoinEntry."Amount Received" := Amt; //"Confirmed Order"."Total Received Amount"; ALLEDK 210113
            GCoinEntry."Min. Allotment" := "Confirmed Order"."Min. Allotment Amount"; //UMAster."Min. Allotment Amount"; //Alledk 210921
            GCoinEntry."Plot No." := "Confirmed Order"."Unit Code";
            GCoinEntry."Total Unit Amount" := "Confirmed Order".Amount;
            GCoinEntry."Eligibility Gold / Silver" := GoldCoin - NoofGoldCoinAllot;
            GCoinEntry."Due Date" := DueDate;
            IF UMAster."Saleable Area" <> 0 THEN
                GCoinEntry.Extent := UMAster."Saleable Area"
            ELSE
                GCoinEntry.Extent := "Confirmed Order"."Saleable Area";
            GCoinEntry."Last Payment Date" := "Confirmed Order"."Posting Date";
            GCoinEntry."Agent ID" := "Confirmed Order"."Introducer Code";
            GCoinEntry."Agent Name" := Vend.Name;
            GCoinEntry."Item Type" := GCoinEntry."Item Type"::Gold;
            GCoinEntry.INSERT;
        END;
    end;

    procedure SetValues(var CustCode: Text[30]; var ProjectCode: Code[20]; var ToDate: Date; var EndDate: Date; RunReportOption: Integer)
    begin
        Cust1 := CustCode;
        ProjectCode1 := ProjectCode;
        EndDate1 := EndDate;
        RunReportOption_1 := RunReportOption;
    end;

    procedure InsertSilverCoinEntry()
    begin
        GCoinEntry.RESET;
        GCoinEntry.SETRANGE("Application No.", "Confirmed Order"."No.");
        IF GCoinEntry.FINDLAST THEN
            LineNo := GCoinEntry."Line No."
        ELSE
            LineNo := 0;

        GCoinEntry.INIT;
        GCoinEntry."Project Code" := "Confirmed Order"."Shortcut Dimension 1 Code";
        GCoinEntry."Application No." := "Confirmed Order"."No.";
        GCoinEntry."Line No." := LineNo + 10000;
        GCoinEntry."Application Date" := "Confirmed Order"."Posting Date";
        GCoinEntry.VALIDATE("Customer No.", "Confirmed Order"."Customer No.");
        GCoinEntry."Due Amount" := "Confirmed Order".Amount - Amt; //"Confirmed Order"."Total Received Amount"; ALLEDK 210113
        GCoinEntry."Amount Received" := Amt; //"Confirmed Order"."Total Received Amount"; ALLEDK 210113

        GCoinEntry."Min. Allotment" := "Confirmed Order"."Min. Allotment Amount"; //UMAster."Min. Allotment Amount"; //Alledk 210921
        GCoinEntry."Plot No." := "Confirmed Order"."Unit Code";
        GCoinEntry."Total Unit Amount" := "Confirmed Order".Amount;
        GCoinEntry."Eligibility Gold / Silver" := SilverCoin;
        GCoinEntry."Due Date" := DueDate;
        IF UMAster."Saleable Area" <> 0 THEN
            GCoinEntry.Extent := UMAster."Saleable Area"
        ELSE
            GCoinEntry.Extent := "Confirmed Order"."Saleable Area";
        GCoinEntry."Last Payment Date" := "Confirmed Order"."Posting Date";
        GCoinEntry."Agent ID" := "Confirmed Order"."Introducer Code";
        GCoinEntry."Agent Name" := Vend.Name;
        GCoinEntry."Item Type" := GCoinEntry."Item Type"::Silver;
        GCoinEntry.INSERT;
    end;

    procedure NewInsertGoldCoinEntry(GoldCoins: Decimal)
    begin
        IF (GoldCoins) > 0 THEN BEGIN

            GCoinEntry.RESET;
            GCoinEntry.SETRANGE("Application No.", "Confirmed Order"."No.");
            IF GCoinEntry.FINDLAST THEN
                LineNo := GCoinEntry."Line No."
            ELSE
                LineNo := 0;

            GCoinEntry.INIT;
            GCoinEntry."Project Code" := "Confirmed Order"."Shortcut Dimension 1 Code";
            GCoinEntry."Application No." := "Confirmed Order"."No.";
            GCoinEntry."Line No." := LineNo + 10000;
            GCoinEntry."Application Date" := "Confirmed Order"."Posting Date";
            GCoinEntry.VALIDATE("Customer No.", "Confirmed Order"."Customer No.");
            GCoinEntry."Due Amount" := "Confirmed Order".Amount - Amt; //"Confirmed Order"."Total Received Amount"; ALLEDK 210113
            GCoinEntry."Amount Received" := Amt; //"Confirmed Order"."Total Received Amount"; ALLEDK 210113
            GCoinEntry."Min. Allotment" := "Confirmed Order"."Min. Allotment Amount"; //UMAster."Min. Allotment Amount"; //Alledk 210921
            GCoinEntry."Plot No." := "Confirmed Order"."Unit Code";
            GCoinEntry."Total Unit Amount" := "Confirmed Order".Amount;
            GCoinEntry."Eligibility Gold / Silver" := GoldCoins;
            GCoinEntry."Due Date" := DueDate;
            IF UMAster."Saleable Area" <> 0 THEN
                GCoinEntry.Extent := UMAster."Saleable Area"
            ELSE
                GCoinEntry.Extent := "Confirmed Order"."Saleable Area";
            GCoinEntry."Last Payment Date" := "Confirmed Order"."Posting Date";
            GCoinEntry."Agent ID" := "Confirmed Order"."Introducer Code";
            GCoinEntry."Agent Name" := Vend.Name;
            GCoinEntry."Item Type" := GCoinEntry."Item Type"::Gold;
            GCoinEntry.INSERT;
        END;
    end;

    procedure NewInsertSilverCoinEntry(SilverCoins: Decimal)
    begin
        GCoinEntry.RESET;
        GCoinEntry.SETRANGE("Application No.", "Confirmed Order"."No.");
        IF GCoinEntry.FINDLAST THEN
            LineNo := GCoinEntry."Line No."
        ELSE
            LineNo := 0;

        GCoinEntry.INIT;
        GCoinEntry."Project Code" := "Confirmed Order"."Shortcut Dimension 1 Code";
        GCoinEntry."Application No." := "Confirmed Order"."No.";
        GCoinEntry."Line No." := LineNo + 10000;
        GCoinEntry."Application Date" := "Confirmed Order"."Posting Date";
        GCoinEntry.VALIDATE("Customer No.", "Confirmed Order"."Customer No.");
        GCoinEntry."Due Amount" := "Confirmed Order".Amount - Amt; //"Confirmed Order"."Total Received Amount"; ALLEDK 210113
        GCoinEntry."Amount Received" := Amt; //"Confirmed Order"."Total Received Amount"; ALLEDK 210113

        GCoinEntry."Min. Allotment" := "Confirmed Order"."Min. Allotment Amount"; //UMAster."Min. Allotment Amount"; //Alledk 210921
        GCoinEntry."Plot No." := "Confirmed Order"."Unit Code";
        GCoinEntry."Total Unit Amount" := "Confirmed Order".Amount;
        GCoinEntry."Eligibility Gold / Silver" := SilverCoins;
        GCoinEntry."Due Date" := DueDate;
        IF UMAster."Saleable Area" <> 0 THEN
            GCoinEntry.Extent := UMAster."Saleable Area"
        ELSE
            GCoinEntry.Extent := "Confirmed Order"."Saleable Area";
        GCoinEntry."Last Payment Date" := "Confirmed Order"."Posting Date";
        GCoinEntry."Agent ID" := "Confirmed Order"."Introducer Code";
        GCoinEntry."Agent Name" := Vend.Name;
        GCoinEntry."Item Type" := GCoinEntry."Item Type"::Silver;
        GCoinEntry.INSERT;
    end;
}

