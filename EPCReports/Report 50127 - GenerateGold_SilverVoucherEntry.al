report 50127 "Generate G/S VoucherEntry"
{
    Caption = 'Generate Gold/Silver Voucher Entry';

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



                UnitSEtup.GET;
                BBGSetups.GET;

                ProcessGoforNewSetup := FALSE;
                NoofCoins := 0;
                TotalRecAmt := 0;
                Amt := 0;

                ProjecWiseNewGoldSilver.RESET;
                ProjecWiseNewGoldSilver.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                ProjecWiseNewGoldSilver.SETRANGE("Gold/Silver Voucher Pmt Plan", "Unit Payment Plan");
                ProjecWiseNewGoldSilver.SetFilter("Gold/Silver Voucher Elg. Amt", '<>%1', 0);
                ProjecWiseNewGoldSilver.SetRange(Status, ProjecWiseNewGoldSilver.Status::Release);
                ProjecWiseNewGoldSilver.SetFilter("Effective Start Date", '<=%1', "Confirmed Order"."Posting Date");
                IF ProjecWiseNewGoldSilver.FindLast() THEN BEGIN

                    ProcessGoforNewSetup := TRUE;   //Added new code 060323
                    CLEAR(APPPaymentEntry);
                    BBGSetups.GET;
                    Amt := 0;
                    TotalRecAmt := 0;
                    APPPaymentEntry.RESET;
                    APPPaymentEntry.SETRANGE("Document No.", "No.");
                    APPPaymentEntry.SetFilter("Cheque Status", '<>%1', APPPaymentEntry."Cheque Status"::Bounced);
                    APPPaymentEntry.SETRANGE("Posting date", ProjecWiseNewGoldSilver."Effective Start Date", Today);
                    // APPPaymentEntry.SETRANGE("Payment Mode", APPPaymentEntry."Payment Mode"::MJVM);
                    APPPaymentEntry.SETFILTER(Amount, '<>%1', 0);
                    IF APPPaymentEntry.FINDSET THEN
                        repeat
                            IF APPPaymentEntry."Cheque Status" = APPPaymentEntry."Cheque Status"::Cleared THEN BEGIN
                                IF APPPaymentEntry."Payment Mode" <> APPPaymentEntry."Payment Mode"::MJVM THEN
                                    TotalRecAmt := TotalRecAmt + APPPaymentEntry.Amount;
                            END;

                            Amt := Amt + APPPaymentEntry.Amount;

                        until APPPaymentEntry.Next = 0;
                    NoofCoins := 0;
                    NoofCoins := ROUND((TotalRecAmt / ProjecWiseNewGoldSilver."Gold/Silver Voucher Elg. Amt"), 1, '<');
                    NoofCoins := NoofCoins * ProjecWiseNewGoldSilver."No. of Vouchers";
                    InsertGold_SilverVoucher(NoofCoins);

                END;
            END;


            trigger OnPreDataItem()
            var

            begin
                IF Cust1 <> '' THEN
                    SETFILTER("Customer No.", Cust1);
                IF ProjectCode1 <> '' THEN
                    SETFILTER("Shortcut Dimension 1 Code", ProjectCode1);
                //IF EndDate1 <> 0D THEN BEGIN

                SETRANGE("Posting Date", EffectiveDateforR2, Today);//010313D

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Effective Date for Gold/Silver Voucher"; EffectiveDateforR2)
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
    var
        ProjectGoldSilver: Record "Project Gold/Silver Voucher";
    begin
        //IF NOT CONFIRM(Text50000) THEN
        //  ERROR('');
        ProjectGoldSilver.RESET;
        ProjectGoldSilver.SetFilter("Effective Start Date", '<>%1', 0D);
        If ProjectGoldSilver.FindFirst() then
            EffectiveDateforR2 := ProjectGoldSilver."Effective Start Date";

    end;

    var
        TotalFor: Label 'Total for ';
        Text50000: Label 'Do you want to generate Gold/Silver Voucher eligibility lines?';


        UnitSEtup: Record "Unit Setup";
        APPPaymentEntry: Record "Application Payment Entry";
        Cust: Record Customer;
        UMAster: Record "Unit Master";
        DimValue: Record "Dimension Value";
        Vend: Record Vendor;
        GLSETUP: Record "General Ledger Setup";
        LastPaymentEntry: Record "Application Payment Entry";
        GCoinEntry: Record "Gold/Silver Voucher Eleg.";
        GoldCoinEntry: Record "Gold/Silver Voucher Eleg.";

        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalRecAmt: Decimal;

        Amt: Decimal;
        DueDate: Date;
        FullAmt: Decimal;
        noofCoinIssued: Integer;
        LineNo: Integer;
        TotalnoofCoin: Integer;
        TempGoldCoinEligibility: Record "Gold/Silver Voucher Eleg.";
        Cust1: Text[30];
        ProjectCode1: Code[20];
        EndDate1: Date;
        NoofGoldCoinAllot: Integer;
        EleDate: Date;
        SilverCoin: Integer;
        ProjecWiseNewGoldSilver: Record "Project Gold/Silver Voucher";
        NoofCoins: Decimal;
        EffectiveDateforR2: Date;
        RunReportOption_1: Integer;
        BBGSetups: Record "BBG Setups";
        ProcessGoforNewSetup: Boolean;

    procedure InsertGold_SilverVoucher(GoldCoin: Decimal)
    begin
        noofCoinIssued := 0;
        NoofGoldCoinAllot := 0;
        GoldCoinEntry.RESET;
        GoldCoinEntry.SETCURRENTKEY("Project Code", "Application No.");
        //GoldCoinEntry.SETRANGE("Project Code","Confirmed Order"."Shortcut Dimension 1 Code");
        GoldCoinEntry.SETRANGE("Application No.", "Confirmed Order"."No.");
        IF GoldCoinEntry.FINDSET THEN
            REPEAT
                NoofGoldCoinAllot := NoofGoldCoinAllot + GoldCoinEntry."Gold/Silver Voucher Elg.";
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
            GCoinEntry."Due Amount" := "Confirmed Order".Amount - Amt;
            GCoinEntry."Amount Received" := Amt;
            GCoinEntry."Min. Allotment" := "Confirmed Order"."Min. Allotment Amount";
            GCoinEntry."Plot No." := "Confirmed Order"."Unit Code";
            GCoinEntry."Total Unit Amount" := "Confirmed Order".Amount;
            GCoinEntry."Gold/Silver Voucher Elg." := GoldCoin - NoofGoldCoinAllot;
            GCoinEntry."Due Date" := DueDate;
            IF UMAster."Saleable Area" <> 0 THEN
                GCoinEntry.Extent := UMAster."Saleable Area"
            ELSE
                GCoinEntry.Extent := "Confirmed Order"."Saleable Area";
            GCoinEntry."Last Payment Date" := "Confirmed Order"."Posting Date";
            GCoinEntry."Agent ID" := "Confirmed Order"."Introducer Code";
            GCoinEntry."Agent Name" := Vend.Name;

            GCoinEntry.INSERT;
        END;
    end;

    procedure SetValues(var CustCode: Text[30]; var ProjectCode: Code[20])
    begin
        Cust1 := CustCode;
        ProjectCode1 := ProjectCode;

    end;


}

