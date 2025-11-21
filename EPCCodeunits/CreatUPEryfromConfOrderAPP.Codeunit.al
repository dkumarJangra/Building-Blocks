codeunit 97734 "Creat UPEry from ConfOrder/APP"
{
    TableNo = "Confirmed Order";

    trigger OnRun()
    var
        AppPaymentEntry: Record "Application Payment Entry";
        TempBondPaymentEntry: Record "Application Payment Entry" temporary;
        DifferenceAmount: Decimal;
        LoopingDifferAmount: Decimal;
        BondPayLineAmt: Decimal;
        TotalBondAmount: Decimal;
        AppliPaymentAmount: Decimal;
        PaymentTermLines: Record "Payment Terms Line Sale";
        APE: Record "Application Payment Entry";
        ConfOrdrer: Record "Confirmed Order";
    begin
        CLEAR(RecConfirmedOrder);
        RecConfirmedOrder.COPY(Rec);

        TotalBondAmount := 0;
        AppliPaymentAmount := 0;
        BondSetup.GET;
        //CLEAR(AppPaymentEntry);
        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::BOND);
        AppPaymentEntry.SETRANGE("Document No.", Rec."No.");
        AppPaymentEntry.SETRANGE(Posted, FALSE);
        IF NOT AppPaymentEntry.FINDFIRST THEN
            ERROR('You must enter the payment lines');


        /*  //071214
        //ALLETDK250313
        CLEAR(AppPaymentEntry);
        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document No.","No.");
        AppPaymentEntry.SETRANGE(Posted,FALSE);
        AppPaymentEntry.SETFILTER("User ID",'<>%1',USERID);
        IF AppPaymentEntry.FINDFIRST THEN
          ERROR('This entry created by another user Id -'+AppPaymentEntry."User ID" +'.'+'Please discuss first with that user');
        //ALLETDK250313
         */ //071214

        //ALLETDK>>
        CLEAR(AppPaymentEntry);
        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::BOND);
        AppPaymentEntry.SETRANGE("Document No.", Rec."No.");
        AppPaymentEntry.SETRANGE(Posted, FALSE);
        AppPaymentEntry.SETRANGE("MSC Post Doc. No.", '');
        IF AppPaymentEntry.FINDSET THEN
            REPEAT
                IF (AppPaymentEntry."Posting date" <> WORKDATE) AND (AppPaymentEntry."Payment Mode" <> AppPaymentEntry."Payment Mode"::JV) THEN
                    ERROR('Payment Entry Posting Date must be same as WORK DATE');
            UNTIL AppPaymentEntry.NEXT = 0;
        //ALLETDK<<
        IF Rec.Type = Rec.Type::Priority THEN BEGIN
            IF Rec."New Unit No." <> '' THEN
                Unitmaster.GET(Rec."New Unit No.")  //ALLEDK 231112
            ELSE
                Unitmaster.GET(Rec."Unit Code");
        END ELSE
            IF Rec.Status <> Rec.Status::Vacate THEN //ALLETDK280313
                IF Rec."Unit Code" <> '' THEN
                    Unitmaster.GET(Rec."Unit Code");

        ConfOrdrer.GET(Rec."No.");
        CLEAR(APE);
        APE.RESET;
        APE.SETRANGE("Document No.", Rec."No.");
        APE.SETRANGE(Posted, FALSE);
        APE.SETRANGE("Cheque Status", APE."Cheque Status"::Cleared);
        IF APE.FINDSET THEN
            REPEAT
                CLEAR(AppliPaymentAmount);
                CLEAR(TotalBondAmount);
                IF APE.Amount > 0 THEN BEGIN
                    TotalBondAmount := APE.Amount;
                    AppliPaymentAmount := APE.Amount;
                    GetLastLineNo(APE);
                    DifferenceAmount := 0;
                    CLEAR(PaymentTermLines);
                    PaymentTermLines.RESET;
                    PaymentTermLines.SETRANGE("Document No.", Rec."No.");
                    IF Rec.Status <> Rec.Status::Vacate THEN //ALLETDK280313
                        PaymentTermLines.SETRANGE("Payment Plan", Unitmaster."Payment Plan") //ALLEDK 231112
                    ELSE
                        PaymentTermLines.SETRANGE("Payment Plan", Rec."Payment Plan"); //ALLETDK280313
                    IF PaymentTermLines.FINDSET THEN
                        REPEAT
                            PaymentTermLines.CALCFIELDS("Received Amt");
                            DifferenceAmount := PaymentTermLines."Due Amount" - PaymentTermLines."Received Amt";
                            LoopingDifferAmount := 0;
                            REPEAT
                                IF DifferenceAmount < AppliPaymentAmount THEN BEGIN
                                    IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                        BondPayLineAmt := AppliPaymentAmount;
                                        AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                    END ELSE BEGIN
                                        BondPayLineAmt := DifferenceAmount;
                                        AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                    END;
                                    TotalBondAmount := TotalBondAmount - BondPayLineAmt;//ALLE PS
                                    LoopingDifferAmount := DifferenceAmount - BondPayLineAmt;
                                END ELSE
                                    IF DifferenceAmount > AppliPaymentAmount THEN BEGIN
                                        IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                            BondPayLineAmt := AppliPaymentAmount;
                                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                        END ELSE BEGIN
                                            BondPayLineAmt := AppliPaymentAmount - AppliPaymentAmount;
                                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                        END;
                                        TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                                        DifferenceAmount := DifferenceAmount - BondPayLineAmt;
                                        LoopingDifferAmount := DifferenceAmount - TotalBondAmount;
                                    END ELSE
                                        IF DifferenceAmount = AppliPaymentAmount THEN BEGIN
                                            BondPayLineAmt := AppliPaymentAmount;
                                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                            TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                                        END;
                                IF BondPayLineAmt <> 0 THEN BEGIN
                                    CreatePaymentEntryLine(BondPayLineAmt, APE, LineNo, PaymentTermLines); //ALLETDK
                                END;
                                IF AppliPaymentAmount = 0 THEN BEGIN
                                    IF APE."Cheque Status" = APE."Cheque Status"::Cleared THEN BEGIN //ALLETDK070213
                                        APE."Explode BOM" := TRUE;
                                        APE.MODIFY;
                                        AppliPaymentAmount := APE.Amount;
                                    END;
                                END;
                            UNTIL (LoopingDifferAmount = 0) OR (TotalBondAmount = 0);
                        UNTIL (PaymentTermLines.NEXT = 0) OR (TotalBondAmount = 0);
                END;
            UNTIL APE.NEXT = 0;

    end;

    var
        BondSetup: Record "Unit Setup";
        Unitmaster: Record "Unit Master";
        BondpaymentEntry: Record "Unit Payment Entry";
        RecConfirmedOrder: Record "Confirmed Order";
        LineNo: Integer;
        RecApplicationOrder: Record Application;
        "..................": Integer;
        PaymentTermLines1: Record "Payment Terms Line Sale";
        LastUnitpayEntry1: Record "Unit Payment Entry";
        LastLineNo1: Integer;
        PostPayment: Codeunit PostPayment;
        Application: Record "Confirmed Order";


    procedure CreatePaymentEntryLine(Amt: Decimal; BondPaymentEntryRec: Record "Application Payment Entry"; RecLineNo: Integer; RecPaymentTermLines: Record "Payment Terms Line Sale")
    var
        UserSetup: Record "User Setup";
        LBondPaymentEntry: Record "Unit Payment Entry";
    begin
        BondpaymentEntry.INIT;
        BondpaymentEntry."Document Type" := BondPaymentEntryRec."Document Type";
        //BondpaymentEntry."Document No." := RecConfirmedOrder."Application No.";
        BondpaymentEntry."Document No." := BondPaymentEntryRec."Document No.";
        //BondpaymentEntry."Line No." := LineNo;
        BondpaymentEntry."Line No." := RecLineNo;
        LineNo += 10000;
        BondpaymentEntry.VALIDATE("Unit Code", BondPaymentEntryRec."Unit Code"); //ALLETDK141112
        BondpaymentEntry.VALIDATE("Payment Mode", BondPaymentEntryRec."Payment Mode");
        BondpaymentEntry."Application No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Document Date" := BondPaymentEntryRec."Document Date";
        BondpaymentEntry."Posting date" := BondPaymentEntryRec."Posting date";
        BondpaymentEntry.Type := BondPaymentEntryRec.Type;
        BondpaymentEntry.Sequence := RecPaymentTermLines.Sequence; //ALLETDK221112
        BondpaymentEntry."Charge Code" := RecPaymentTermLines."Charge Code"; //ALLETDK081112
        BondpaymentEntry."Actual Milestone" := RecPaymentTermLines."Actual Milestone"; //ALLETDK221112
        BondpaymentEntry."Commision Applicable" := RecPaymentTermLines."Commision Applicable";
        BondpaymentEntry."Direct Associate" := RecPaymentTermLines."Direct Associate";
        BondpaymentEntry."Priority Payment" := BondPaymentEntryRec."Priority Payment";
        BondpaymentEntry."Posted Document No." := BondPaymentEntryRec."Posted Document No.";
        IF ((BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::Bank)
            // BBG1.01 251012 START
            OR (BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.C./C.C./Net Banking")) THEN BEGIN
            // BBG1.01 251012 END
            BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            BondpaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            BondpaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            BondpaymentEntry.VALIDATE("Deposit/Paid Bank", BondPaymentEntryRec."Deposit/Paid Bank");
        END;

        IF BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.D." THEN BEGIN
            BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            BondpaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            BondpaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            BondpaymentEntry.VALIDATE("Deposit/Paid Bank", BondPaymentEntryRec."Deposit/Paid Bank");
        END;
        BondpaymentEntry.Amount := Amt;
        UserSetup.GET(USERID);
        BondpaymentEntry."Shortcut Dimension 1 Code" := BondPaymentEntryRec."Shortcut Dimension 1 Code";
        BondpaymentEntry."Shortcut Dimension 2 Code" := BondPaymentEntryRec."Shortcut Dimension 2 Code";
        BondpaymentEntry."Explode BOM" := TRUE;
        BondpaymentEntry."Branch Code" := BondPaymentEntryRec."User Branch Code"; //ALLETDK141112
        BondpaymentEntry."User ID" := BondPaymentEntryRec."User ID"; //ALLEDK271212
        BondpaymentEntry."App. Pay. Entry Line No." := BondPaymentEntryRec."Line No."; //ALLETDK141112
        BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");//ALLETDK040213
        //ALLETDK070213--BEGIN
        IF (BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::Bank) THEN BEGIN
            BondpaymentEntry."Posted Document No." := BondPaymentEntryRec."Posted Document No.";
            BondpaymentEntry."Installment No." := 1;
            BondpaymentEntry.Posted := TRUE;
        END;

        IF BondPaymentEntryRec."Document Type" = BondPaymentEntryRec."Document Type"::Application THEN
            IF (BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::Cash) THEN BEGIN  //220920
                BondpaymentEntry."Posted Document No." := BondPaymentEntryRec."Posted Document No.";
                BondpaymentEntry."Installment No." := 1;
                BondpaymentEntry.Posted := TRUE;
            END;
        //ALLETDK070213--END
        BondpaymentEntry.INSERT;
    end;


    procedure GetLastLineNo(BondPaymentEntryRec: Record "Application Payment Entry")
    var
        BPayEntry: Record "Unit Payment Entry";
    begin
        LineNo := 0;
        BPayEntry.RESET;
        BPayEntry.SETRANGE("Document Type", BondPaymentEntryRec."Document Type");
        BPayEntry.SETFILTER(BPayEntry."Document No.", BondPaymentEntryRec."Document No.");
        IF BPayEntry.FINDLAST THEN
            LineNo := BPayEntry."Line No." + 10000
        ELSE
            LineNo := 10000;
    end;


    procedure CreateUPEntryfromApplication(var RecApplication: Record Application)
    var
        AppPaymentEntry: Record "Application Payment Entry";
        TempBondPaymentEntry: Record "Application Payment Entry" temporary;
        DifferenceAmount: Decimal;
        LoopingDifferAmount: Decimal;
        BondPayLineAmt: Decimal;
        TotalBondAmount: Decimal;
        AppliPaymentAmount: Decimal;
        PaymentTermLines: Record "Payment Terms Line Sale";
    begin
        CLEAR(RecApplicationOrder);
        RecApplicationOrder.COPY(RecApplication);

        TotalBondAmount := 0;
        AppliPaymentAmount := 0;
        BondSetup.GET;
        CLEAR(AppPaymentEntry);
        /*
        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document Type",AppPaymentEntry."Document Type"::Application);
        AppPaymentEntry.SETRANGE("Document No.",RecApplication."Application No.");
        AppPaymentEntry.SETRANGE(Posted,FALSE);
        IF NOT AppPaymentEntry.FINDFIRST THEN
          ERROR('You must enter the payment lines');
        
        //ALLETDK250313
        CLEAR(AppPaymentEntry);
        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document No.",RecApplication."Application No.");
        AppPaymentEntry.SETFILTER("User ID",'<>%1',USERID);
        AppPaymentEntry.SETRANGE(Posted,FALSE);
        AppPaymentEntry.SETRANGE("MSC Post Doc. No.",'');
        IF AppPaymentEntry.FINDFIRST THEN
          ERROR('Another user has modified the payment details. Please check the details again.');
        //ALLETDK250313
        //ALLETDK090513>>
        CLEAR(AppPaymentEntry);
        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document Type",AppPaymentEntry."Document Type"::Application);
        AppPaymentEntry.SETRANGE("Document No.",RecApplication."Application No.");
        AppPaymentEntry.SETRANGE(Posted,FALSE);
        AppPaymentEntry.SETRANGE("MSC Post Doc. No.",'');
        IF AppPaymentEntry.FINDSET THEN
        REPEAT
         IF USERID <> '1003' THEN BEGIN
           IF AppPaymentEntry."Posting date" <> WORKDATE THEN
             ERROR('Payment Entry Posting Date must be same as WORK DATE');
         END;
        UNTIL AppPaymentEntry.NEXT = 0;
        //ALLETDK090513<<
        */
        CLEAR(AppPaymentEntry);
        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::Application);
        AppPaymentEntry.SETRANGE("Document No.", RecApplication."Application No.");
        AppPaymentEntry.SETRANGE("Cheque Status", AppPaymentEntry."Cheque Status"::Cleared); //ALLETDK
        AppPaymentEntry.SETRANGE("Explode BOM", FALSE);
        IF AppPaymentEntry.FINDSET THEN BEGIN
            AppliPaymentAmount := AppPaymentEntry.Amount;
            REPEAT
                IF AppPaymentEntry."MSC Post Doc. No." = '' THEN BEGIN
                    IF USERID <> '1003' THEN BEGIN
                        IF AppPaymentEntry."Posting date" <> WORKDATE THEN
                            ERROR('Payment Entry Posting Date must be same as WORK DATE');
                    END;
                END;
                TotalBondAmount := TotalBondAmount + AppPaymentEntry.Amount;
            UNTIL AppPaymentEntry.NEXT = 0;
        END;

        IF AppPaymentEntry.FINDSET THEN;
        GetLastLineNo(AppPaymentEntry);
        DifferenceAmount := 0;
        CLEAR(PaymentTermLines);
        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", RecApplication."Application No.");
        IF PaymentTermLines.FIND('-') THEN
            REPEAT
                PaymentTermLines.CALCFIELDS("Received Amt");
                DifferenceAmount := PaymentTermLines."Due Amount" + PaymentTermLines."Received Amt";
                LoopingDifferAmount := 0;
                REPEAT
                    IF DifferenceAmount < AppliPaymentAmount THEN BEGIN
                        IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                            BondPayLineAmt := AppliPaymentAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END ELSE BEGIN
                            BondPayLineAmt := DifferenceAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END;
                        TotalBondAmount := TotalBondAmount - BondPayLineAmt;//ALLE PS
                        LoopingDifferAmount := DifferenceAmount - BondPayLineAmt;
                    END ELSE
                        IF DifferenceAmount > AppliPaymentAmount THEN BEGIN
                            IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END ELSE BEGIN
                                BondPayLineAmt := AppliPaymentAmount - AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END;
                            TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            DifferenceAmount := DifferenceAmount - BondPayLineAmt;
                            LoopingDifferAmount := DifferenceAmount - TotalBondAmount;
                        END ELSE
                            IF DifferenceAmount = AppliPaymentAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            END;
                    IF BondPayLineAmt <> 0 THEN
                        //CreatePaymentEntryLineforApp(BondPayLineAmt,AppPaymentEntry);
                        CreatePaymentEntryLine(BondPayLineAmt, AppPaymentEntry, LineNo, PaymentTermLines); //ALLETDK070213
                    IF AppliPaymentAmount = 0 THEN BEGIN
                        IF AppPaymentEntry."Cheque Status" = AppPaymentEntry."Cheque Status"::Cleared THEN BEGIN //ALLETDK070213
                            AppPaymentEntry."Explode BOM" := TRUE;
                            AppPaymentEntry.MODIFY;
                            AppPaymentEntry.NEXT;
                            AppliPaymentAmount := AppPaymentEntry.Amount;
                        END; //ALLETDK070213
                    END;
                UNTIL (LoopingDifferAmount = 0) OR (TotalBondAmount = 0);
            UNTIL (PaymentTermLines.NEXT = 0) OR (TotalBondAmount = 0);

    end;


    procedure CreateUPEntryfromApplicationCash(var RecApplication: Record Application)
    var
        AppPaymentEntry: Record "Application Payment Entry";
        TempBondPaymentEntry: Record "Application Payment Entry" temporary;
        DifferenceAmount: Decimal;
        LoopingDifferAmount: Decimal;
        BondPayLineAmt: Decimal;
        TotalBondAmount: Decimal;
        AppliPaymentAmount: Decimal;
        PaymentTermLines: Record "Payment Terms Line Sale";
    begin
        CLEAR(RecApplicationOrder);
        RecApplicationOrder.COPY(RecApplication);

        TotalBondAmount := 0;
        AppliPaymentAmount := 0;
        BondSetup.GET;
        CLEAR(AppPaymentEntry);
        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::Application);
        AppPaymentEntry.SETRANGE("Document No.", RecApplication."Application No.");
        AppPaymentEntry.SETRANGE("Cheque Status", AppPaymentEntry."Cheque Status"::Cleared); //ALLETDK
        AppPaymentEntry.SETRANGE("Explode BOM", FALSE);
        IF AppPaymentEntry.FINDSET THEN BEGIN
            AppliPaymentAmount := AppPaymentEntry.Amount;
            REPEAT
                TotalBondAmount := TotalBondAmount + AppPaymentEntry.Amount;
            UNTIL AppPaymentEntry.NEXT = 0;
        END;

        IF AppPaymentEntry.FINDSET THEN;
        GetLastLineNo(AppPaymentEntry);
        DifferenceAmount := 0;
        CLEAR(PaymentTermLines);
        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", RecApplication."Application No.");
        IF PaymentTermLines.FIND('-') THEN
            REPEAT
                PaymentTermLines.CALCFIELDS("Received Amt");
                DifferenceAmount := PaymentTermLines."Due Amount" + PaymentTermLines."Received Amt";
                LoopingDifferAmount := 0;
                REPEAT
                    IF DifferenceAmount < AppliPaymentAmount THEN BEGIN
                        IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                            BondPayLineAmt := AppliPaymentAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END ELSE BEGIN
                            BondPayLineAmt := DifferenceAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END;
                        TotalBondAmount := TotalBondAmount - BondPayLineAmt;//ALLE PS
                        LoopingDifferAmount := DifferenceAmount - BondPayLineAmt;
                    END ELSE
                        IF DifferenceAmount > AppliPaymentAmount THEN BEGIN
                            IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END ELSE BEGIN
                                BondPayLineAmt := AppliPaymentAmount - AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END;
                            TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            DifferenceAmount := DifferenceAmount - BondPayLineAmt;
                            LoopingDifferAmount := DifferenceAmount - TotalBondAmount;
                        END ELSE
                            IF DifferenceAmount = AppliPaymentAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            END;
                    IF BondPayLineAmt <> 0 THEN
                        //CreatePaymentEntryLineforApp(BondPayLineAmt,AppPaymentEntry);
                        CreatePaymentEntryLine(BondPayLineAmt, AppPaymentEntry, LineNo, PaymentTermLines); //ALLETDK070213
                    IF AppliPaymentAmount = 0 THEN BEGIN
                        IF AppPaymentEntry."Cheque Status" = AppPaymentEntry."Cheque Status"::Cleared THEN BEGIN //ALLETDK070213
                            AppPaymentEntry."Explode BOM" := TRUE;
                            AppPaymentEntry.MODIFY;
                            AppPaymentEntry.NEXT;
                            AppliPaymentAmount := AppPaymentEntry.Amount;
                        END; //ALLETDK070213
                    END;
                UNTIL (LoopingDifferAmount = 0) OR (TotalBondAmount = 0);
            UNTIL (PaymentTermLines.NEXT = 0) OR (TotalBondAmount = 0);
    end;


    procedure CreatePaymentEntryLineforApp(Amt: Decimal; BondPaymentEntryRec: Record "Application Payment Entry")
    var
        UserSetup: Record "User Setup";
        LBondPaymentEntry: Record "Unit Payment Entry";
    begin
        /*
        BondpaymentEntry.INIT;
        BondpaymentEntry."Document Type" := BondPaymentEntryRec."Document Type";
        BondpaymentEntry."Document No." := RecApplicationOrder."Application No.";
        BondpaymentEntry."Line No." := LineNo;
        LineNo += 10000;
        BondpaymentEntry.VALIDATE("Unit Code",BondPaymentEntryRec."Unit Code"); //ALLETDK141112
        BondpaymentEntry.VALIDATE("Payment Mode",BondPaymentEntryRec."Payment Mode");
        BondpaymentEntry."Application No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Document Date" := BondPaymentEntryRec."Document Date";
        BondpaymentEntry."Posting date" := BondPaymentEntryRec."Posting date";
        BondpaymentEntry.Type := BondPaymentEntryRec.Type;
        BondpaymentEntry.Sequence := PaymentTermLines.Sequence; //ALLETDK221112
        BondpaymentEntry."Charge Code" := PaymentTermLines."Charge Code"; //ALLETDK081112
        BondpaymentEntry."Actual Milestone":=PaymentTermLines."Actual Milestone"; //ALLETDK221112
        BondpaymentEntry."Commision Applicable" := PaymentTermLines."Commision Applicable";
        BondpaymentEntry."Direct Associate" := PaymentTermLines."Direct Associate";
        BondpaymentEntry."Priority Payment" := BondPaymentEntryRec."Priority Payment";
        IF ((BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::Bank)
          // BBG1.01 251012 START
            OR (BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.C./C.C./Net Banking")) THEN BEGIN
          // BBG1.01 251012 END
          BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.",BondPaymentEntryRec."Cheque No./ Transaction No.");
          BondpaymentEntry.VALIDATE("Cheque Date",BondPaymentEntryRec."Cheque Date");
          BondpaymentEntry.VALIDATE("Cheque Bank and Branch",BondPaymentEntryRec."Cheque Bank and Branch");
          BondpaymentEntry.VALIDATE("Cheque Status",BondPaymentEntryRec."Cheque Status");
          BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.",BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
          BondpaymentEntry.VALIDATE("Deposit/Paid Bank",BondPaymentEntryRec."Deposit/Paid Bank");
        END;
        
        IF BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.D." THEN BEGIN
          BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.",BondPaymentEntryRec."Cheque No./ Transaction No.");
          BondpaymentEntry.VALIDATE("Cheque Date",BondPaymentEntryRec."Cheque Date");
          BondpaymentEntry.VALIDATE("Cheque Bank and Branch",BondPaymentEntryRec."Cheque Bank and Branch");
          BondpaymentEntry.VALIDATE("Cheque Status",BondPaymentEntryRec."Cheque Status");
          BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.",BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
          BondpaymentEntry.VALIDATE("Deposit/Paid Bank",BondPaymentEntryRec."Deposit/Paid Bank");
        END;
        BondpaymentEntry.Amount := Amt;
        UserSetup.GET(USERID);
        BondpaymentEntry."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        BondpaymentEntry."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        BondpaymentEntry."Explode BOM" := TRUE;
        BondpaymentEntry."Branch Code" := BondPaymentEntryRec."Branch Code"; //ALLETDK141112
        BondpaymentEntry."User ID" := BondPaymentEntryRec."User ID"; //ALLEDK271212
            BondpaymentEntry."App. Pay. Entry Line No." := BondPaymentEntryRec."Line No."; //ALLETDK141112
        BondpaymentEntry.INSERT;
        */

    end;


    procedure SplitAppPayEntriesforDiscount(var NewAppEntry: Record "Application Payment Entry"; var NewLineNo: Integer)
    var
        AppPaymentEntry: Record "Application Payment Entry";
        TempBondPaymentEntry: Record "Application Payment Entry" temporary;
        DifferenceAmount: Decimal;
        LoopingDifferAmount: Decimal;
        BondPayLineAmt: Decimal;
        TotalBondAmount: Decimal;
        AppliPaymentAmount: Decimal;
        ConfOrder: Record "Confirmed Order";
        PaymentTermLines: Record "Payment Terms Line Sale";
    begin
        IF ConfOrder.GET(NewAppEntry."Document No.") THEN;

        TotalBondAmount := 0;
        AppliPaymentAmount := 0;
        BondSetup.GET;

        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::BOND);
        AppPaymentEntry.SETRANGE("Document No.", NewAppEntry."Document No.");
        AppPaymentEntry.SETRANGE("Line No.", NewLineNo);
        IF AppPaymentEntry.FINDSET THEN BEGIN
            AppliPaymentAmount := AppPaymentEntry.Amount;
            REPEAT
                IF (AppPaymentEntry."Posting date" <> WORKDATE) AND (AppPaymentEntry."Payment Mode" <> AppPaymentEntry."Payment Mode"::JV) THEN
                    ERROR('Payment Entry Posting Date must be same as WORK DATE');
                TotalBondAmount := TotalBondAmount + AppPaymentEntry.Amount;
            UNTIL AppPaymentEntry.NEXT = 0;
        END
        ELSE
            ERROR('You must enter the payment lines');

        IF AppPaymentEntry.FINDSET THEN;
        DifferenceAmount := 0;
        PaymentTermLines1.RESET;
        PaymentTermLines1.SETRANGE("Document No.", NewAppEntry."Document No.");
        IF PaymentTermLines1.FIND('-') THEN
            REPEAT
                PaymentTermLines1.CALCFIELDS("Received Amt");
                DifferenceAmount := PaymentTermLines1."Due Amount" - PaymentTermLines1."Received Amt";
                LoopingDifferAmount := 0;
                REPEAT
                    IF DifferenceAmount < AppliPaymentAmount THEN BEGIN
                        IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                            BondPayLineAmt := AppliPaymentAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END ELSE BEGIN
                            BondPayLineAmt := DifferenceAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END;
                        TotalBondAmount := TotalBondAmount - BondPayLineAmt;//ALLE PS
                        LoopingDifferAmount := DifferenceAmount - BondPayLineAmt;
                    END ELSE
                        IF DifferenceAmount > AppliPaymentAmount THEN BEGIN
                            IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END ELSE BEGIN
                                BondPayLineAmt := AppliPaymentAmount - AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END;
                            TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            DifferenceAmount := DifferenceAmount - BondPayLineAmt;
                            LoopingDifferAmount := DifferenceAmount - TotalBondAmount;
                        END ELSE
                            IF DifferenceAmount = AppliPaymentAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            END;
                    IF BondPayLineAmt <> 0 THEN
                        //CreatePaymentEntryLine(BondPayLineAmt,AppPaymentEntry,NewLineNo,PaymentTermLines); //ALLEDK 180213 ADDED
                        CreatePayEntryLineforDiscount(NewAppEntry, BondPayLineAmt, AppPaymentEntry); //ALLEDK 180213 Comment
                    IF AppliPaymentAmount = 0 THEN BEGIN
                        AppPaymentEntry."Explode BOM" := TRUE;
                        AppPaymentEntry.MODIFY;
                        AppPaymentEntry.NEXT;
                        AppliPaymentAmount := AppPaymentEntry.Amount;
                    END;
                UNTIL (LoopingDifferAmount = 0) OR (TotalBondAmount = 0);
            UNTIL (PaymentTermLines1.NEXT = 0) OR (TotalBondAmount = 0);
    end;


    procedure CreatePayEntryLineforDiscount(var AppEntryLines: Record "Application Payment Entry"; Amt: Decimal; BondPaymentEntryRec: Record "Application Payment Entry")
    var
        UserSetup: Record "User Setup";
        LBondPaymentEntry: Record "Unit Payment Entry";
        LineNo: Integer;
    begin
        LastUnitpayEntry1.RESET;
        LastUnitpayEntry1.SETRANGE("Document Type", AppEntryLines."Document Type");
        LastUnitpayEntry1.SETRANGE("Document No.", AppEntryLines."Document No.");
        IF LastUnitpayEntry1.FINDLAST THEN
            LastLineNo1 := LastUnitpayEntry1."Line No.";


        BondpaymentEntry.INIT;
        BondpaymentEntry."Document Type" := BondPaymentEntryRec."Document Type";
        BondpaymentEntry."Document No." := AppEntryLines."Document No.";
        BondpaymentEntry."Line No." := LastLineNo1 + 10000;
        BondpaymentEntry.VALIDATE("Unit Code", BondPaymentEntryRec."Unit Code");
        BondpaymentEntry.VALIDATE("Payment Mode", BondPaymentEntryRec."Payment Mode");
        BondpaymentEntry."Application No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Document Date" := BondPaymentEntryRec."Document Date";
        BondpaymentEntry."Posting date" := BondPaymentEntryRec."Posting date";
        BondpaymentEntry.Type := BondPaymentEntryRec.Type;
        BondpaymentEntry.Sequence := PaymentTermLines1.Sequence;
        BondpaymentEntry."Charge Code" := PaymentTermLines1."Charge Code";
        BondpaymentEntry."Actual Milestone" := PaymentTermLines1."Actual Milestone";
        BondpaymentEntry."Commision Applicable" := PaymentTermLines1."Commision Applicable";
        BondpaymentEntry."Direct Associate" := PaymentTermLines1."Direct Associate";
        BondpaymentEntry."Priority Payment" := BondPaymentEntryRec."Priority Payment";
        BondpaymentEntry."Cheque Status" := BondPaymentEntryRec."Cheque Status";
        BondpaymentEntry."App. Pay. Entry Line No." := BondPaymentEntryRec."Line No.";
        BondpaymentEntry."User ID" := USERID;
        BondpaymentEntry."Posted Document No." := BondPaymentEntryRec."Posted Document No.";
        BondpaymentEntry.Amount := Amt;
        UserSetup.GET(USERID);
        BondpaymentEntry."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        BondpaymentEntry."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        BondpaymentEntry."Explode BOM" := TRUE;
        BondpaymentEntry.Posted := TRUE;
        //ALLETDK220213>>
        IF BondpaymentEntry."Payment Mode" = BondpaymentEntry."Payment Mode"::JV THEN BEGIN
            BondpaymentEntry.Posted := FALSE;
            BondpaymentEntry.VALIDATE("Payment Method", BondPaymentEntryRec."Payment Method");
            BondpaymentEntry."Cheque No./ Transaction No." := BondPaymentEntryRec."Cheque No./ Transaction No.";
            BondpaymentEntry."Cheque Date" := BondPaymentEntryRec."Cheque Date";
            BondpaymentEntry."Cheque Bank and Branch" := BondPaymentEntryRec."Cheque Bank and Branch";
            BondpaymentEntry."Chq. Cl / Bounce Dt." := BondPaymentEntryRec."Chq. Cl / Bounce Dt.";
            BondpaymentEntry."Deposit/Paid Bank" := BondPaymentEntryRec."Deposit/Paid Bank";
        END;
        //ALLETDK220213<<
        BondpaymentEntry."Branch Code" := BondPaymentEntryRec."User Branch Code"; //ALLETDK141112
        BondpaymentEntry."User ID" := BondPaymentEntryRec."User ID"; //ALLEDK271212
        BondpaymentEntry.INSERT;

        //ALLEDK 280213
        IF (BondpaymentEntry."Payment Mode" = BondpaymentEntry."Payment Mode"::"Debit Note") THEN BEGIN
            IF Application.GET(BondpaymentEntry."Document No.") THEN
                PostPayment.CreateStagingTableAppBond(Application, BondpaymentEntry."Line No." / 10000, 1, BondpaymentEntry.Sequence,
                    BondpaymentEntry."Cheque No./ Transaction No.", BondpaymentEntry."Commision Applicable", BondpaymentEntry."Direct Associate"
            ,
                    BondpaymentEntry."Posting date", BondpaymentEntry.Amount, BondpaymentEntry, FALSE, Application."Old Process");
        END;
        //ALLEDK 280213
    end;


    procedure CheckExcessAmount(ConfirmOrder: Record "Confirmed Order"): Decimal
    var
        RecDueAmount: Decimal;
        ApplPayEntry: Record "Application Payment Entry";
        CurrPayAmount: Decimal;
        ExcessAmount: Decimal;
    begin
        CLEAR(RecDueAmount);
        CLEAR(CurrPayAmount);
        CLEAR(ExcessAmount);
        ConfirmOrder.CALCFIELDS("Total Received Amount");
        ConfirmOrder.CALCFIELDS("Discount Amount");
        RecDueAmount := ConfirmOrder.Amount + ConfirmOrder."Service Charge Amount" - ConfirmOrder."Total Received Amount";
        IF RecDueAmount >= 0 THEN BEGIN
            ApplPayEntry.RESET;
            ApplPayEntry.SETRANGE("Document Type", ApplPayEntry."Document Type"::BOND);
            ApplPayEntry.SETRANGE("Document No.", ConfirmOrder."No.");
            ApplPayEntry.SETRANGE(Posted, FALSE);
            IF ApplPayEntry.FINDSET THEN
                REPEAT
                    CurrPayAmount += ApplPayEntry.Amount;
                UNTIL ApplPayEntry.NEXT = 0;
            IF RecDueAmount < CurrPayAmount THEN
                ExcessAmount := CurrPayAmount - RecDueAmount;
            EXIT(ExcessAmount);
        END;
        //ALLETDK>>>
        IF RecDueAmount < 0 THEN BEGIN
            ApplPayEntry.RESET;
            ApplPayEntry.SETRANGE("Document Type", ApplPayEntry."Document Type"::BOND);
            ApplPayEntry.SETRANGE("Document No.", ConfirmOrder."No.");
            ApplPayEntry.SETRANGE(Posted, FALSE);
            IF ApplPayEntry.FINDSET THEN
                REPEAT
                    CurrPayAmount += ApplPayEntry.Amount;
                UNTIL ApplPayEntry.NEXT = 0;
            ExcessAmount := CurrPayAmount;
            EXIT(ExcessAmount);
        END;
        //ALLETDK<<<
    end;


    procedure CreateExcessPaymentTermsLine(DocumentNo: Code[20]; ExcessAmt: Decimal)
    var
        PaymentTermLines: Record "Payment Terms Line Sale";
        PaymentTermLines1: Record "Payment Terms Line Sale";
        UnitCharge: Record "Unit Charge & Payment Pl. Code";
        ExcessCode: Code[10];
        ConOrder: Record "Confirmed Order";
    begin
        UnitCharge.RESET;
        UnitCharge.SETRANGE(ExcessCode, TRUE);
        IF UnitCharge.FINDFIRST THEN
            ExcessCode := UnitCharge.Code
        ELSE
            ERROR('Excess Code setup does not exist');
        ConOrder.GET(DocumentNo);
        PaymentTermLines1.RESET;
        PaymentTermLines1.SETRANGE("Document No.", DocumentNo);
        IF PaymentTermLines1.FINDLAST THEN BEGIN
            IF PaymentTermLines1."Charge Code" <> ExcessCode THEN BEGIN
                PaymentTermLines.INIT;
                PaymentTermLines."Document Type" := PaymentTermLines1."Document Type";
                PaymentTermLines."Document No." := DocumentNo;
                PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
                PaymentTermLines.Sequence := INCSTR(PaymentTermLines1.Sequence); //ALLETDK221112
                PaymentTermLines."Actual Milestone" := PaymentTermLines1."Actual Milestone";
                PaymentTermLines."Payment Plan" := PaymentTermLines1."Payment Plan";
                PaymentTermLines.Description := 'Excess Payment';
                PaymentTermLines."Due Date" := PaymentTermLines1."Due Date";
                PaymentTermLines."Project Code" := ConOrder."Shortcut Dimension 1 Code";
                PaymentTermLines."Calculation Type" := PaymentTermLines."Calculation Type"::"% age";
                PaymentTermLines."Criteria Value / Base Amount" := ExcessAmt;
                PaymentTermLines."Calculation Value" := 100;
                PaymentTermLines."Due Amount" := ROUND(ExcessAmt, 0.01, '=');
                PaymentTermLines."Charge Code" := ExcessCode;
                PaymentTermLines."Commision Applicable" := FALSE;
                PaymentTermLines."Direct Associate" := FALSE;
                PaymentTermLines.INSERT(TRUE);
            END ELSE BEGIN
                PaymentTermLines1."Criteria Value / Base Amount" += ExcessAmt;
                //PaymentTermLines1."Calculation Value" := 100;
                PaymentTermLines1."Due Amount" += ROUND(ExcessAmt, 0.01, '=');
                PaymentTermLines1.MODIFY;
            END;
        END;
    end;


    procedure "UpdateUnit&CommBufferEntries"(ApplicationCode: Code[20]; FromApplication: Boolean)
    var
        RecApplication: Record Application;
    begin
    end;


    procedure CreateBufferPaymentEntryLine(Amt: Decimal; BondPaymentEntryRec: Record "Application Payment Entry"; RecLineNo: Integer; RecPaymentTermLines: Record "Payment Terms Line Sale")
    var
        UserSetup: Record "User Setup";
        LBondPaymentEntry: Record "Unit Payment Entry buffer";
    begin
        LBondPaymentEntry.INIT;
        LBondPaymentEntry."Document Type" := BondPaymentEntryRec."Document Type";
        //LBondpaymentEntry."Document No." := RecConfirmedOrder."Application No.";
        LBondPaymentEntry."Document No." := BondPaymentEntryRec."Document No.";
        //LBondpaymentEntry."Line No." := LineNo;
        LBondPaymentEntry."Line No." := RecLineNo;
        LineNo += 10000;
        LBondPaymentEntry.VALIDATE("Unit Code", BondPaymentEntryRec."Unit Code"); //ALLETDK141112
        LBondPaymentEntry.VALIDATE("Payment Mode", BondPaymentEntryRec."Payment Mode");
        LBondPaymentEntry."Application No." := BondPaymentEntryRec."Document No.";
        LBondPaymentEntry."Document Date" := BondPaymentEntryRec."Document Date";
        LBondPaymentEntry."Posting date" := BondPaymentEntryRec."Posting date";
        LBondPaymentEntry.Type := BondPaymentEntryRec.Type;
        LBondPaymentEntry.Sequence := RecPaymentTermLines.Sequence; //ALLETDK221112
        LBondPaymentEntry."Charge Code" := RecPaymentTermLines."Charge Code"; //ALLETDK081112
        LBondPaymentEntry."Actual Milestone" := RecPaymentTermLines."Actual Milestone"; //ALLETDK221112
        LBondPaymentEntry."Commision Applicable" := RecPaymentTermLines."Commision Applicable";
        LBondPaymentEntry."Direct Associate" := RecPaymentTermLines."Direct Associate";
        LBondPaymentEntry."Priority Payment" := BondPaymentEntryRec."Priority Payment";
        IF ((BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::Bank)
            // BBG1.01 251012 START
            OR (BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.C./C.C./Net Banking")) THEN BEGIN
            // BBG1.01 251012 END
            LBondPaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            LBondPaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            LBondPaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            LBondPaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            LBondPaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            LBondPaymentEntry."Deposit/Paid Bank" := BondPaymentEntryRec."Deposit/Paid Bank";
        END;

        IF BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.D." THEN BEGIN
            LBondPaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            LBondPaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            LBondPaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            LBondPaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            LBondPaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            LBondPaymentEntry."Deposit/Paid Bank" := BondPaymentEntryRec."Deposit/Paid Bank";
        END;
        LBondPaymentEntry.Amount := Amt;
        UserSetup.GET(USERID);
        LBondPaymentEntry."Shortcut Dimension 1 Code" := BondPaymentEntryRec."Shortcut Dimension 1 Code";
        LBondPaymentEntry."Shortcut Dimension 2 Code" := BondPaymentEntryRec."Shortcut Dimension 2 Code";
        LBondPaymentEntry."Explode BOM" := TRUE;
        LBondPaymentEntry."Branch Code" := BondPaymentEntryRec."User Branch Code"; //ALLETDK141112
        LBondPaymentEntry."User ID" := BondPaymentEntryRec."User ID"; //ALLEDK271212
        LBondPaymentEntry."App. Pay. Entry Line No." := BondPaymentEntryRec."Line No."; //ALLETDK141112
        LBondPaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");//ALLETDK040213
        //ALLETDK070213--BEGIN
        IF BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::Bank THEN BEGIN
            LBondPaymentEntry."Posted Document No." := BondPaymentEntryRec."Posted Document No.";
            LBondPaymentEntry."Installment No." := 1;
            LBondPaymentEntry.Posted := TRUE;
        END;
        //ALLETDK070213--END
        LBondPaymentEntry.INSERT;
    end;


    procedure UpdateBufferUnitpayentryLine(ApplCode: Code[20]; UnitAmount: Decimal)
    var
        ConfOrdrer: Record "Confirmed Order";
        APE: Record "Application Payment Entry";
        AppliPaymentAmount: Decimal;
        TotalBondAmount: Decimal;
        DifferenceAmount: Decimal;
        PaymentTermLines: Record "Payment Terms Line Sale";
        LoopingDifferAmount: Decimal;
        BondPayLineAmount: Decimal;
    begin
        ConfOrdrer.GET(ApplCode);
        CLEAR(APE);
        APE.RESET;
        APE.SETRANGE("Document No.", ApplCode);
        IF APE.FINDFIRST THEN BEGIN
            CLEAR(AppliPaymentAmount);
            CLEAR(TotalBondAmount);
            IF UnitAmount > 0 THEN BEGIN
                TotalBondAmount := UnitAmount;
                AppliPaymentAmount := UnitAmount;
                GetLastLineNo(APE);
                DifferenceAmount := 0;
                CLEAR(PaymentTermLines);
                PaymentTermLines.RESET;
                PaymentTermLines.SETRANGE("Document No.", ApplCode);
                PaymentTermLines.SETRANGE("Payment Plan", ConfOrdrer."Payment Plan"); //ALLETDK280313
                IF PaymentTermLines.FINDSET THEN
                    REPEAT
                        BondPayLineAmount := 0;
                        IF UnitAmount >= PaymentTermLines."Due Amount" THEN BEGIN
                            BondPayLineAmount := PaymentTermLines."Due Amount";
                            UnitAmount := UnitAmount - PaymentTermLines."Due Amount";
                        END ELSE BEGIN
                            BondPayLineAmount := UnitAmount;
                            UnitAmount := 0;
                        END;

                        IF BondPayLineAmount <> 0 THEN BEGIN
                            CreateBufferPaymentEntryLine(BondPayLineAmount, APE, LineNo, PaymentTermLines); //ALLETDK
                        END;
                    UNTIL (PaymentTermLines.NEXT = 0) OR (UnitAmount = 0);
            END;
        END;
    end;


    procedure CreateJVUnitpaymentEntry(Conforder: Record "Confirmed Order")
    var
        TotalBondAmount: Decimal;
        AppliPaymentAmount: Decimal;
        AppPaymentEntry: Record "Application Payment Entry";
        APE: Record "Application Payment Entry";
        DifferenceAmount: Decimal;
        PaymentTermLines: Record "Payment Terms Line Sale";
        LoopingDifferAmount: Decimal;
        BondPayLineAmt: Decimal;
    begin
        CLEAR(RecConfirmedOrder);
        RecConfirmedOrder.COPY(Conforder);

        TotalBondAmount := 0;
        AppliPaymentAmount := 0;
        BondSetup.GET;
        //CLEAR(AppPaymentEntry);
        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::BOND);
        AppPaymentEntry.SETRANGE("Document No.", RecConfirmedOrder."No.");
        AppPaymentEntry.SETRANGE(Posted, FALSE);
        IF NOT AppPaymentEntry.FINDFIRST THEN
            ERROR('You must enter the payment lines');


        //ALLETDK>>
        CLEAR(AppPaymentEntry);
        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::BOND);
        AppPaymentEntry.SETRANGE("Document No.", RecConfirmedOrder."No.");
        AppPaymentEntry.SETRANGE(Posted, FALSE);
        AppPaymentEntry.SETRANGE("MSC Post Doc. No.", '');
        IF AppPaymentEntry.FINDSET THEN
            REPEAT
                IF (AppPaymentEntry."Posting date" <> WORKDATE) AND (AppPaymentEntry."Payment Mode" <> AppPaymentEntry."Payment Mode"::JV) THEN
                    ERROR('Payment Entry Posting Date must be same as WORK DATE');
            UNTIL AppPaymentEntry.NEXT = 0;
        //ALLETDK<<
        IF RecConfirmedOrder.Type = RecConfirmedOrder.Type::Priority THEN BEGIN
            IF RecConfirmedOrder."New Unit No." <> '' THEN
                Unitmaster.GET(RecConfirmedOrder."New Unit No.")  //ALLEDK 231112
            ELSE
                Unitmaster.GET(RecConfirmedOrder."Unit Code");
        END ELSE
            IF RecConfirmedOrder.Status <> RecConfirmedOrder.Status::Vacate THEN //ALLETDK280313
                Unitmaster.GET(RecConfirmedOrder."Unit Code");

        CLEAR(APE);
        APE.RESET;
        APE.SETRANGE("Document No.", RecConfirmedOrder."No.");
        APE.SETRANGE(Posted, TRUE);
        APE.SETRANGE("Cheque Status", APE."Cheque Status"::Cleared);
        APE.SETFILTER("Payment Mode", '<>%1', APE."Payment Mode"::JV);
        IF APE.FINDSET THEN
            REPEAT
                CLEAR(AppliPaymentAmount);
                CLEAR(TotalBondAmount);
                IF APE.Amount > 0 THEN BEGIN
                    TotalBondAmount := APE.Amount;
                    AppliPaymentAmount := APE.Amount;
                    GetLastLineNo(APE);
                    DifferenceAmount := 0;
                    CLEAR(PaymentTermLines);
                    PaymentTermLines.RESET;
                    PaymentTermLines.SETRANGE("Document No.", RecConfirmedOrder."No.");
                    IF RecConfirmedOrder.Status <> RecConfirmedOrder.Status::Vacate THEN //ALLETDK280313
                        PaymentTermLines.SETRANGE("Payment Plan", Unitmaster."Payment Plan") //ALLEDK 231112
                    ELSE
                        PaymentTermLines.SETRANGE("Payment Plan", RecConfirmedOrder."Payment Plan"); //ALLETDK280313
                    IF PaymentTermLines.FINDSET THEN
                        REPEAT
                            PaymentTermLines.CALCFIELDS("Received Amt");
                            DifferenceAmount := PaymentTermLines."Due Amount" - PaymentTermLines."Received Amt";
                            LoopingDifferAmount := 0;
                            REPEAT
                                IF DifferenceAmount < AppliPaymentAmount THEN BEGIN
                                    IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                        BondPayLineAmt := AppliPaymentAmount;
                                        AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                    END ELSE BEGIN
                                        BondPayLineAmt := DifferenceAmount;
                                        AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                    END;
                                    TotalBondAmount := TotalBondAmount - BondPayLineAmt;//ALLE PS
                                    LoopingDifferAmount := DifferenceAmount - BondPayLineAmt;
                                END ELSE
                                    IF DifferenceAmount > AppliPaymentAmount THEN BEGIN
                                        IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                            BondPayLineAmt := AppliPaymentAmount;
                                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                        END ELSE BEGIN
                                            BondPayLineAmt := AppliPaymentAmount - AppliPaymentAmount;
                                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                        END;
                                        TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                                        DifferenceAmount := DifferenceAmount - BondPayLineAmt;
                                        LoopingDifferAmount := DifferenceAmount - TotalBondAmount;
                                    END ELSE
                                        IF DifferenceAmount = AppliPaymentAmount THEN BEGIN
                                            BondPayLineAmt := AppliPaymentAmount;
                                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                            TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                                        END;
                                IF BondPayLineAmt <> 0 THEN BEGIN
                                    CreatePaymentEntryLine1(BondPayLineAmt, APE, LineNo, PaymentTermLines); //ALLETDK
                                END;
                                IF AppliPaymentAmount = 0 THEN BEGIN
                                    IF APE."Cheque Status" = APE."Cheque Status"::Cleared THEN BEGIN //ALLETDK070213
                                        AppliPaymentAmount := APE.Amount;
                                    END;
                                END;
                            UNTIL (LoopingDifferAmount = 0) OR (TotalBondAmount = 0);
                        UNTIL (PaymentTermLines.NEXT = 0) OR (TotalBondAmount = 0);
                END;
            UNTIL APE.NEXT = 0;
    end;


    procedure CreatePaymentEntryLine1(Amt: Decimal; BondPaymentEntryRec: Record "Application Payment Entry"; RecLineNo: Integer; RecPaymentTermLines: Record "Payment Terms Line Sale")
    var
        UserSetup: Record "User Setup";
        LBondPaymentEntry: Record "Unit Payment Entry";
        ApplicationPaymentEntry_JV: Record "Application Payment Entry";
    begin
        BondpaymentEntry.INIT;
        BondpaymentEntry."Document Type" := BondPaymentEntryRec."Document Type";
        BondpaymentEntry."Document No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Line No." := RecLineNo;
        LineNo += 10000;
        BondpaymentEntry.VALIDATE("Unit Code", BondPaymentEntryRec."Unit Code"); //ALLETDK141112
        BondpaymentEntry.VALIDATE("Payment Mode", BondPaymentEntryRec."Payment Mode");
        BondpaymentEntry."Application No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Document Date" := BondPaymentEntryRec."Document Date";
        BondpaymentEntry."Posting date" := BondPaymentEntryRec."Posting date";
        BondpaymentEntry.Type := BondPaymentEntryRec.Type;
        BondpaymentEntry.Sequence := RecPaymentTermLines.Sequence; //ALLETDK221112
        BondpaymentEntry."Charge Code" := RecPaymentTermLines."Charge Code"; //ALLETDK081112
        BondpaymentEntry."Actual Milestone" := RecPaymentTermLines."Actual Milestone"; //ALLETDK221112
        BondpaymentEntry."Commision Applicable" := RecPaymentTermLines."Commision Applicable";
        BondpaymentEntry."Direct Associate" := RecPaymentTermLines."Direct Associate";
        BondpaymentEntry."Priority Payment" := BondPaymentEntryRec."Priority Payment";
        BondpaymentEntry."Payment Mode" := BondpaymentEntry."Payment Mode"::JV;
        BondpaymentEntry."Cheque Status" := BondpaymentEntry."Cheque Status"::Cleared;
        BondpaymentEntry.Amount := Amt;
        UserSetup.GET(USERID);
        ApplicationPaymentEntry_JV.RESET;
        ApplicationPaymentEntry_JV.SETRANGE("Document No.", BondpaymentEntry."Document No.");
        IF ApplicationPaymentEntry_JV.FINDLAST THEN;
        BondpaymentEntry."Shortcut Dimension 1 Code" := ApplicationPaymentEntry_JV."Shortcut Dimension 1 Code";
        BondpaymentEntry."Shortcut Dimension 2 Code" := BondPaymentEntryRec."Shortcut Dimension 2 Code";
        BondpaymentEntry."Explode BOM" := TRUE;
        BondpaymentEntry."Branch Code" := BondPaymentEntryRec."User Branch Code"; //ALLETDK141112
        BondpaymentEntry."User ID" := BondPaymentEntryRec."User ID"; //ALLEDK271212
        BondpaymentEntry."Installment No." := 1;
        BondpaymentEntry."Payment Method" := 'JV';
        BondpaymentEntry.Description := 'JV';
        BondpaymentEntry.INSERT;
    end;
}

