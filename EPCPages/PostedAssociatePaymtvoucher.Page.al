page 50190 "Posted Associate Paymt voucher"
{
    PageType = Document;
    SourceTable = "Assoc Pmt Voucher Header";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = "Document No.Editable";

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Paid To"; Rec."Paid To")
                {
                    Editable = "Paid ToEditable";
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    Editable = "Payment ModeEditable";

                    trigger OnValidate()
                    begin
                        PaymentModeOnAfterValidate;
                    end;
                }
                field("Bank/G L Code"; Rec."Bank/G L Code")
                {
                    Editable = "Bank/G L CodeEditable";
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    Editable = "Cheque No.Editable";
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    Editable = "Cheque DateEditable";
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Sub Type"; Rec."Sub Type")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    Caption = 'Posted Payment Doc. No.';
                    MultiLine = true;
                }
                field("Pmt from MS Company Ref. No."; Rec."Pmt from MS Company Ref. No.")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Name; Rec.Name)
                {
                    Editable = NameEditable;
                }
                field("Bank/G L Name"; Rec."Bank/G L Name")
                {
                    Caption = 'Name';
                    Editable = "Bank/G L NameEditable";
                }
                field(Type; Rec.Type)
                {
                    Editable = TypeEditable;
                }
                field("Incentive Type"; Rec."Incentive Type")
                {
                    Editable = "Incentive TypeEditable";
                }
                field("Commission Date"; Rec."Commission Date")
                {

                    trigger OnValidate()
                    begin
                        OpAmt := 0;
                        VLEntry.RESET;
                        VLEntry.SETRANGE("Posting Date", 20130228D);
                        VLEntry.SETRANGE("Vendor No.", Rec."Paid To");
                        VLEntry.SETRANGE("Document Type", VLEntry."Document Type"::Payment);
                        IF VLEntry.FINDSET THEN
                            REPEAT
                                VLEntry.CALCFIELDS("Remaining Amt. (LCY)");
                                OpAmt := OpAmt + VLEntry."Remaining Amt. (LCY)";
                            UNTIL VLEntry.NEXT = 0;


                        VLEntry.RESET;
                        VLEntry.SETCURRENTKEY(VLEntry."Vendor No.", "Posting Date");
                        VLEntry.SETRANGE("Vendor No.", Rec."Paid To");
                        VLEntry.SETRANGE("Posting Date", 20130301D, Rec."Commission Date");
                        IF VLEntry.FINDFIRST THEN BEGIN
                            VLEntry.CALCFIELDS(VLEntry."Remaining Amt. (LCY)");
                            IF (OpAmt + VLEntry."Remaining Amt. (LCY)") > 0 THEN BEGIN
                                IF CONFIRM('There exists advance to this Associate, Do you want to adjust Yes/No') THEN
                                    Rec."Advance Payment" := TRUE
                                ELSE
                                    Rec."Advance Payment" := FALSE;
                                Rec.MODIFY;
                            END;
                        END;
                    end;
                }
            }
            part(VoucherSubform; "Posted Voucher Sub form")
            {
                Editable = VoucherSubPAGEEditable;
                SubPageLink = "Voucher No." = FIELD("Document No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Reverse Invoice")
            {
                Caption = 'Reverse Invoice';

                trigger OnAction()
                var
                    VLE: Record "Vendor Ledger Entry";
                    ReversalEntry: Record "Reversal Entry";
                    RevEntry: Record "Reversal Entry";
                    //PAGERevEntries: Page "Reverse Entries";// 179;
                    VLE2: Record "Vendor Ledger Entry";
                begin
                    VLE.RESET;
                    VLE.SETRANGE("External Document No.", Rec."Document No.");
                    VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
                    IF VLE.FINDFIRST THEN BEGIN
                        CLEAR(ReversalEntry);
                        IF VLE.Reversed THEN
                            ReversalEntry.AlreadyReversedEntry(Rec.TABLECAPTION, VLE."Entry No.");
                        VLE.TESTFIELD("Transaction No.");
                        RevEntry.DELETEALL;
                        ReversalEntry.AutoReverseTransaction(VLE."Transaction No.", Rec."Posting Date");
                        //PAGERevEntries.RUN;
                        VLE2.GET(VLE."Entry No.");
                        IF VLE2.Reversed THEN BEGIN
                            Rec."Invoice Reversed" := TRUE;
                            Rec.MODIFY;
                        END;
                    END;
                end;
            }
        }
    }

    var
        LineNo: Integer;
        VoucherCount2: Integer;
        UserSetup: Record "User Setup";
        Unitsetup: Record "Unit Setup";
        BondSetup: Record "Unit Setup";
        VoucherLine: Record "Voucher Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        LineNo2: Integer;
        GenJnlBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        //NODNOCLine: Record 13785;
        GenJnlLine2: Record "Gen. Journal Line";
        Amt2: Decimal;
        TDSAmt2: Decimal;
        Club9ChargesAmt2: Decimal;
        DocNo: Code[20];
        MonthNo: Integer;
        PLine: Record "Purchase Line";
        PHeader: Record "Purchase Header";
        PurchSetup: Record "Purchases & Payables Setup";
        DocNo1: Code[20];
        PaymentMethod: Record "Payment Method";
        TravelPaymentEntry: Record "Travel Payment Entry";
        RecVoucherLine: Record "Voucher Line";
        VoucherLine1: Record "Voucher Line";
        AmttoPay: Decimal;
        AmtTDS: Decimal;
        CommissionEntry: Record "Commission Entry";
        GenJnlLine: Record "Gen. Journal Line";
        TDSCode: Code[10];
        TDSCode1: Code[10];
        TDSPercentage: Decimal;
        Amt1: Decimal;
        Amt3: Decimal;
        VLEntry: Record "Vendor Ledger Entry";
        GLAccount: Record "G/L Account";
        Location: Record Location;
        DBAmt: Decimal;
        ClubAmt1: Decimal;
        ClubAmt2: Decimal;
        AmttoPay1: Decimal;
        EligibleAmt: Decimal;
        CommEntry: Record "Commission Entry";
        TVEntry: Record "Travel Payment Entry";
        IncEntry: Record "Incentive Summary";
        EligibleAmt1: Decimal;
        AmtTDS1: Decimal;
        PostPayment1: Codeunit PostPayment;
        "TDS%": Decimal;
        AccCaption: Text[30];
        GLEntry: Record "G/L Entry";
        //PostedVoucher: Report 16567;
        ASSVoucher: Boolean;
        OpAmt: Decimal;
        VendLE: Record "Vendor Ledger Entry";
        AssPmtHdr: Record "Associate Payment Hdr";

        "Document No.Editable": Boolean;

        "Paid ToEditable": Boolean;

        "Bank/G L CodeEditable": Boolean;

        "Cheque No.Editable": Boolean;

        "Cheque DateEditable": Boolean;

        NameEditable: Boolean;

        "Bank/G L NameEditable": Boolean;

        TypeEditable: Boolean;

        "Incentive TypeEditable": Boolean;

        "Payment ModeEditable": Boolean;

        VoucherSubPAGEEditable: Boolean;
        Text50000: Label 'Do you want to Release this Voucher?';
        Text50001: Label 'Status of this Voucher is already Released.';
        Text50002: Label 'Do you want to open this Voucher?';
        Text50003: Label 'Status of this Voucher is already Open.';

    local procedure AddIncentiveVouchers()
    var
        ConsiderVoucher: Boolean;
        VoucherLine: Record "Voucher Line";
        IncentiveSummary: Record "Incentive Summary";
    begin
        IF Rec."Paid To" = '' THEN
            ERROR('Please enter Paid To');
        AmttoPay1 := 0;
        AmtTDS1 := 0;
        AmttoPay := 0;
        AmtTDS := 0;
        "TDS%" := 0;


        IF (Rec."Incentive Type" = Rec."Incentive Type"::Direct) OR
         (Rec."Incentive Type" = Rec."Incentive Type"::" ") THEN BEGIN
            IncentiveSummary.RESET;
            IncentiveSummary.SETCURRENTKEY("Associate Code", Month, Year);
            IncentiveSummary.SETRANGE("Associate Code", Rec."Paid To");
            IncentiveSummary.SETRANGE(Month, Rec.Month);
            IncentiveSummary.SETRANGE(Year, Rec.Year);
            IncentiveSummary.SETFILTER("Voucher No.", '%1', '');
            IncentiveSummary.SETRANGE(Type, IncentiveSummary.Type::Direct);
            IF IncentiveSummary.FINDFIRST THEN BEGIN
                REPEAT
                    AmttoPay1 := AmttoPay1 + IncentiveSummary."Payable Incentive Amount";
                    AmtTDS1 := AmtTDS1 + IncentiveSummary."TDS Amount";
                    IncentiveSummary."Voucher No." := Rec."Document No.";
                    IncentiveSummary.MODIFY;
                UNTIL IncentiveSummary.NEXT = 0;
            END;

            IncentiveSummary.RESET;
            IncentiveSummary.SETCURRENTKEY("Associate Code", Month, Year);
            IncentiveSummary.SETRANGE("Associate Code", Rec."Paid To");
            IncentiveSummary.SETRANGE(Month, Rec.Month);
            IncentiveSummary.SETRANGE(Year, Rec.Year);
            IncentiveSummary.SETRANGE(Type, IncentiveSummary.Type::Direct);
            IncentiveSummary.SETFILTER("Remaining Amount", '<>%1', 0);
            IF IncentiveSummary.FINDFIRST THEN BEGIN
                REPEAT
                    AmttoPay := AmttoPay + IncentiveSummary."Remaining Amount";
                UNTIL IncentiveSummary.NEXT = 0;
            END;

            IF (AmttoPay + AmttoPay1) > 0 THEN BEGIN
                LineNo := 0;

                VoucherLine.RESET;
                VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
                IF VoucherLine.FINDLAST THEN
                    LineNo := VoucherLine."Line No."
                ELSE
                    LineNo := 0;

                Unitsetup.GET;
                "TDS%" := PostPayment1.CalculateTDSPercentage(Rec."Paid To", Unitsetup."TDS Nature of Deduction INCT", '');

                VoucherLine.INIT;
                VoucherLine."Voucher No." := Rec."Document No.";
                VoucherLine."Line No." := LineNo + 10000;
                VoucherLine.INSERT(TRUE);
                VoucherLine."Associate Code" := IncentiveSummary."Associate Code";
                VoucherLine.Amount := AmttoPay + AmttoPay1;
                VoucherLine."Eligible Amount" := AmttoPay + AmttoPay1;
                VoucherLine.Year := IncentiveSummary.Year;
                VoucherLine."TDS Amount" := ((AmttoPay + AmttoPay1) * "TDS%" / 100);
                VoucherLine.Month := IncentiveSummary.Month;
                VoucherLine."Posting Date" := WORKDATE;
                VoucherLine.Type := VoucherLine.Type::Incentive;
                VoucherLine."Incentive Type" := VoucherLine."Incentive Type"::Direct;
                VoucherLine.MODIFY;
            END;
        END;

        IF (Rec."Incentive Type" = Rec."Incentive Type"::Team) OR
         (Rec."Incentive Type" = Rec."Incentive Type"::" ") THEN BEGIN

            IncentiveSummary.RESET;
            IncentiveSummary.SETCURRENTKEY("Associate Code", Month, Year);
            IncentiveSummary.SETRANGE("Associate Code", Rec."Paid To");
            IncentiveSummary.SETRANGE(Month, Rec.Month);
            IncentiveSummary.SETRANGE(Year, Rec.Year);
            IncentiveSummary.SETFILTER("Voucher No.", '%1', '');
            IncentiveSummary.SETRANGE(Type, IncentiveSummary.Type::Team);
            IF IncentiveSummary.FINDFIRST THEN BEGIN
                REPEAT
                    AmttoPay1 := AmttoPay1 + IncentiveSummary."Payable Incentive Amount";
                    AmtTDS1 := AmtTDS1 + IncentiveSummary."TDS Amount";
                    IncentiveSummary."Voucher No." := Rec."Document No.";
                    IncentiveSummary.MODIFY;
                UNTIL IncentiveSummary.NEXT = 0;
            END;

            IncentiveSummary.RESET;
            IncentiveSummary.SETCURRENTKEY("Associate Code", Month, Year);
            IncentiveSummary.SETRANGE("Associate Code", Rec."Paid To");
            IncentiveSummary.SETRANGE(Month, Rec.Month);
            IncentiveSummary.SETRANGE(Year, Rec.Year);
            IncentiveSummary.SETRANGE(IncentiveSummary.Type, IncentiveSummary.Type::Team);
            IncentiveSummary.SETFILTER("Remaining Amount", '<>%1', 0);
            IF IncentiveSummary.FINDFIRST THEN BEGIN
                REPEAT
                    AmttoPay := AmttoPay + IncentiveSummary."Remaining Amount";
                UNTIL IncentiveSummary.NEXT = 0;
            END;
            IF (AmttoPay + AmttoPay1) > 0 THEN BEGIN

                LineNo := 0;

                VoucherLine.RESET;
                VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
                IF VoucherLine.FINDLAST THEN
                    LineNo := VoucherLine."Line No."
                ELSE
                    LineNo := 0;

                Unitsetup.GET;
                "TDS%" := PostPayment1.CalculateTDSPercentage(Rec."Paid To", Unitsetup."TDS Nature of Deduction INCT", '');

                VoucherLine.INIT;
                VoucherLine."Voucher No." := Rec."Document No.";
                VoucherLine."Line No." := LineNo + 10000;
                VoucherLine.INSERT(TRUE);
                VoucherLine."Associate Code" := IncentiveSummary."Associate Code";
                VoucherLine.Amount := AmttoPay + AmttoPay1;
                VoucherLine."Eligible Amount" := AmttoPay + AmttoPay1;
                VoucherLine."TDS Amount" := ((AmttoPay + AmttoPay1) * "TDS%" / 100);
                VoucherLine.Year := IncentiveSummary.Year;
                VoucherLine.Month := IncentiveSummary.Month;
                VoucherLine."Posting Date" := WORKDATE;
                VoucherLine.Type := VoucherLine.Type::Incentive;
                VoucherLine."Incentive Type" := VoucherLine."Incentive Type"::Direct;
                VoucherLine.MODIFY;
            END;
        END;
    end;

    local procedure AddCommVouchers()
    var
        ConsiderVoucher: Boolean;
        VoucherLine: Record "Voucher Line";
        CommissionVoucher: Record "Commission Voucher";
        ReapprovedCommissionVoucher: Record "Reapproved Commission Voucher";
        ExpiredVoucher: Text[1024];
        PostPayment: Codeunit PostPayment;
        BondPost: Codeunit "Unit Post";
        BaseAmt: Decimal;
        CommAmt: Decimal;
        TDSAmt: Decimal;
        Club9ChargesAmt: Decimal;
    begin

        IF Rec."Paid To" = '' THEN
            ERROR('Please enter Paid To');

        AmttoPay := 0;
        TDSAmt := 0;
        AmttoPay1 := 0;
        AmtTDS1 := 0;
        "TDS%" := 0;

        Unitsetup.GET;
        CommissionEntry.RESET;
        CommissionEntry.SETCURRENTKEY("Associate Code", "Posting Date");
        CommissionEntry.SETRANGE("Associate Code", Rec."Paid To");
        CommissionEntry.SETRANGE("Posting Date", 0D, Rec."Commission Date");
        CommissionEntry.SETFILTER("Voucher No.", '=%1', '');
        CommissionEntry.SETRANGE("Remaining Amt of Direct", FALSE);
        IF CommissionEntry.FINDSET THEN BEGIN
            REPEAT
                AmttoPay1 := AmttoPay1 + CommissionEntry."Commission Amount";
                AmtTDS1 := AmtTDS1 + CommissionEntry."TDS Amount";
                CommissionEntry."Voucher No." := Rec."Document No.";
                CommissionEntry.MODIFY;
            UNTIL CommissionEntry.NEXT = 0;
        END;
        CommissionEntry.RESET;
        CommissionEntry.SETCURRENTKEY("Associate Code", "Posting Date");
        CommissionEntry.SETRANGE("Associate Code", Rec."Paid To");
        CommissionEntry.SETRANGE("Posting Date", 0D, Rec."Commission Date");
        CommissionEntry.SETFILTER("Remaining Amount", '<>%1', 0);
        IF CommissionEntry.FINDSET THEN BEGIN
            REPEAT
                AmttoPay := AmttoPay + CommissionEntry."Remaining Amount";
            UNTIL CommissionEntry.NEXT = 0;
        END;

        IF (AmttoPay + AmttoPay1) > 0 THEN BEGIN

            LineNo := 0;

            VoucherLine.RESET;
            VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
            IF VoucherLine.FINDLAST THEN
                LineNo := VoucherLine."Line No."
            ELSE
                LineNo := 0;

            Unitsetup.GET;
            "TDS%" := PostPayment1.CalculateTDSPercentage(Rec."Paid To", Unitsetup."TDS Nature of Deduction", '');
            VoucherLine.INIT;
            VoucherLine."Voucher No." := Rec."Document No.";
            VoucherLine."Line No." := LineNo + 10000;
            VoucherLine."Posting Date" := WORKDATE;
            VoucherLine."Associate Code" := Rec."Paid To";
            VoucherLine."Unit Office Code(Paid)" := UserSetup."Responsibility Center";
            VoucherLine."Counter Code(Paid)" := UserSetup."Shortcut Dimension 2 Code";
            VoucherLine.Amount := AmttoPay + AmttoPay1;
            VoucherLine."Eligible Amount" := AmttoPay + AmttoPay1;
            VoucherLine."TDS Amount" := ((AmttoPay + AmttoPay1) * "TDS%" / 100);
            VoucherLine."Clube 9 Charge Amount" := ROUND(((AmttoPay + AmttoPay1) * (Unitsetup."Corpus %" / 100)),
                                  Unitsetup."Corpus Amt. Rounding Precision");  // ALLEPG 251012
            VoucherLine."Paid To" := Rec."Paid To";
            VoucherLine."Payment Mode" := VoucherLine."Payment Mode"::" ";
            VoucherLine.Type := VoucherLine.Type::Commission;
            VoucherLine.INSERT;
        END
        ELSE
            MESSAGE('No Record found on this Filter');
    end;


    procedure InsertTAEntry()
    var
        TravelPaymentEntry: Record "Travel Payment Entry";
    begin
        LineNo := 0;
        AmttoPay := 0;
        AmtTDS := 0;
        AmttoPay1 := 0;
        "TDS%" := 0;

        Unitsetup.GET;
        TravelPaymentEntry.RESET;
        TravelPaymentEntry.SETCURRENTKEY("Sub Associate Code", Month, Year, Approved);
        TravelPaymentEntry.SETRANGE("Sub Associate Code", Rec."Paid To");
        TravelPaymentEntry.SETRANGE(Month, MonthNo);
        TravelPaymentEntry.SETRANGE(Year, Rec.Year);
        TravelPaymentEntry.SETRANGE(Approved, TRUE);
        TravelPaymentEntry.SETRANGE("TA Creation on Commission Vouc", FALSE);
        TravelPaymentEntry.SETFILTER("Voucher No.", '=%1', '');
        IF TravelPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                AmttoPay := AmttoPay + TravelPaymentEntry."Amount to Pay";
                AmtTDS := AmtTDS + TravelPaymentEntry."TDS Amount";
                TravelPaymentEntry."Voucher No." := Rec."Document No.";
                TravelPaymentEntry.MODIFY;
            UNTIL TravelPaymentEntry.NEXT = 0;
        END;

        TravelPaymentEntry.RESET;
        TravelPaymentEntry.SETCURRENTKEY("Sub Associate Code", Month, Year, Approved);
        TravelPaymentEntry.SETRANGE("Sub Associate Code", Rec."Paid To");
        TravelPaymentEntry.SETRANGE(Month, MonthNo);
        TravelPaymentEntry.SETRANGE(Year, Rec.Year);
        TravelPaymentEntry.SETFILTER("Remaining Amount", '<>%1', 0);
        IF TravelPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                AmttoPay1 := AmttoPay1 + TravelPaymentEntry."Remaining Amount";
            UNTIL TravelPaymentEntry.NEXT = 0;
        END;

        IF (AmttoPay1 + AmttoPay) > 0 THEN BEGIN
            LineNo := 0;
            VoucherLine.RESET;
            VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
            IF VoucherLine.FINDLAST THEN
                LineNo := VoucherLine."Line No."
            ELSE
                LineNo := 0;

            Unitsetup.GET;
            "TDS%" := PostPayment1.CalculateTDSPercentage(Rec."Paid To", Unitsetup."TDS Nature of Deduction INCT", '');
            VoucherLine.INIT;
            VoucherLine."Voucher No." := Rec."Document No.";
            VoucherLine."Line No." := LineNo + 10000;
            VoucherLine."Voucher Date" := TravelPaymentEntry."Creation Date";
            VoucherLine."Associate Code" := TravelPaymentEntry."Sub Associate Code";
            VoucherLine.Amount := (AmttoPay1 + AmttoPay);
            VoucherLine."Eligible Amount" := (AmttoPay1 + AmttoPay);
            VoucherLine."TDS Amount" := ((AmttoPay + AmttoPay1) * "TDS%" / 100);
            VoucherLine.Type := VoucherLine.Type::TA;
            VoucherLine."New Line No." := TravelPaymentEntry."Line No.";
            VoucherLine."Clube 9 Charge Amount" := ((AmttoPay1 + AmttoPay) * Unitsetup."Corpus %") / 100;
            VoucherLine.INSERT;
        END
        ELSE
            MESSAGE('No Record found on this Filter');
    end;


    procedure UpdateGLCode()
    begin
        AccCaption := '';
        IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN
            AccCaption := 'Cash Account'
        ELSE
            AccCaption := 'Bank Account';
    end;


    procedure UpdateControls()
    begin
        IF Rec.Status = Rec.Status::Released THEN BEGIN
            "Document No.Editable" := FALSE;
            "Paid ToEditable" := FALSE;
            "Bank/G L CodeEditable" := FALSE;
            "Cheque No.Editable" := FALSE;
            "Cheque DateEditable" := FALSE;
            NameEditable := FALSE;
            "Bank/G L NameEditable" := FALSE;
            TypeEditable := FALSE;
            "Incentive TypeEditable" := FALSE;
            "Payment ModeEditable" := FALSE;
            VoucherSubPAGEEditable := FALSE;
        END
        ELSE BEGIN
            "Document No.Editable" := TRUE;
            "Paid ToEditable" := TRUE;
            "Bank/G L CodeEditable" := TRUE;
            "Cheque No.Editable" := TRUE;
            "Cheque DateEditable" := TRUE;
            NameEditable := TRUE;
            "Bank/G L NameEditable" := TRUE;
            TypeEditable := TRUE;
            "Incentive TypeEditable" := TRUE;
            "Payment ModeEditable" := TRUE;
            VoucherSubPAGEEditable := TRUE;
        END;
    end;


    procedure PostTA()
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;
        BondSetup.GET;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::TA);
        IF VoucherLine.FINDSET THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                // TDSAmt2 += VoucherLine."TDS Amount";
                EligibleAmt += VoucherLine."Eligible Amount";
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
            UNTIL VoucherLine.NEXT = 0;


        IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Travel A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");


        IF GLAccount.GET(Unitsetup."Travel A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        PHeader."Payment Method Code" := Rec."Bank/G L Code";
        PHeader."Bal. Account Type" := PaymentMethod."Bal. Account Type";
        PHeader."Bal. Account No." := PaymentMethod."Bal. Account No.";

        PHeader."Cheque No." := Rec."Cheque No.";
        PHeader."Cheque Date" := Rec."Cheque Date";
        //PHeader.Structure := 'EXEMPTED';
        PHeader."Sent for Approval" := TRUE;
        PHeader.Approved := TRUE;
        PHeader.MODIFY;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Travel A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2 - Club9ChargesAmt2);
        PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 20000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
        PLine.VALIDATE(Quantity, -1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 30000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Travel A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post (Yes/No)", PHeader);

        //ALLEDK 221212
        IF (EligibleAmt - Amt2) > 0 THEN BEGIN
            TVEntry.RESET;
            TVEntry.SETCURRENTKEY("Voucher No.");
            TVEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF TVEntry.FINDLAST THEN BEGIN
                TVEntry."Remaining Amount" := EligibleAmt - Amt2;
                TVEntry.MODIFY;
            END;
        END;
        //ALLEDK 221212
        Rec.Post := TRUE;
        Rec.MODIFY;
        MESSAGE('Document has been posted successfully');
    end;


    procedure PostCommission()
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;
        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::Commission);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                //    TDSAmt2 += VoucherLine."TDS Amount";
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;


        IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Commission A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");


        IF GLAccount.GET(Unitsetup."Commission A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        PHeader."Payment Method Code" := Rec."Bank/G L Code";
        PHeader."Bal. Account Type" := PaymentMethod."Bal. Account Type";
        PHeader."Bal. Account No." := PaymentMethod."Bal. Account No.";

        PHeader."Cheque No." := Rec."Cheque No.";
        PHeader."Cheque Date" := Rec."Cheque Date";
        // PHeader.Structure := 'EXEMPTED';
        PHeader."Sent for Approval" := TRUE;
        PHeader.Approved := TRUE;
        PHeader.MODIFY;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Commission A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2 - Club9ChargesAmt2);
        PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction");
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 20000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
        PLine.VALIDATE(Quantity, -1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 30000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Commission A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post (Yes/No)", PHeader);

        //ALLEDK 221212
        IF (EligibleAmt - Amt2) > 0 THEN BEGIN
            CommEntry.RESET;
            CommEntry.SETCURRENTKEY("Voucher No.");
            CommEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF CommEntry.FINDLAST THEN BEGIN
                CommEntry."Remaining Amount" := EligibleAmt - Amt2;
                CommEntry.MODIFY;
            END;
        END;
        //ALLEDK 221212

        Rec.Post := TRUE;
        Rec.MODIFY;
        MESSAGE('Document has been posted successfully');
    end;


    procedure PostComAndTA()
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt1 := 0;
        BondSetup.GET;
        Amt1 := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::TA);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                //TDSAmt2 += VoucherLine."TDS Amount";
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt1 += VoucherLine."Eligible Amount";
                Amt1 += VoucherLine.Amount;
            UNTIL VoucherLine.NEXT = 0;

        IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Travel A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");
        Unitsetup.TESTFIELD(Unitsetup."Commission A/C");

        IF GLAccount.GET(Unitsetup."Commission A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Travel A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");



        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        PHeader."Payment Method Code" := Rec."Bank/G L Code";
        PHeader."Bal. Account Type" := PaymentMethod."Bal. Account Type";
        PHeader."Bal. Account No." := PaymentMethod."Bal. Account No.";

        PHeader."Cheque No." := Rec."Cheque No.";
        PHeader."Cheque Date" := Rec."Cheque Date";
        //PHeader.Structure := 'EXEMPTED';
        PHeader."Sent for Approval" := TRUE;
        PHeader.Approved := TRUE;
        PHeader.MODIFY;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Travel A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2 - Club9ChargesAmt2);
        PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 20000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
        PLine.VALIDATE(Quantity, -1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 30000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Travel A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::Commission);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                // TDSAmt2 += VoucherLine."TDS Amount";
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
            UNTIL VoucherLine.NEXT = 0;

        IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

        IF UserSetup.GET(USERID) THEN;


        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 40000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Commission A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2 - Club9ChargesAmt2);
        PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 50000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
        PLine.VALIDATE(Quantity, -1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 60000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Commission A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post (Yes/No)", PHeader);


        IF (EligibleAmt1 - Amt1) > 0 THEN BEGIN
            TVEntry.RESET;
            TVEntry.SETCURRENTKEY("Voucher No.");
            TVEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF TVEntry.FINDLAST THEN BEGIN
                TVEntry."Remaining Amount" := EligibleAmt1 - Amt1;
                TVEntry.MODIFY;
            END;
        END;

        IF (EligibleAmt - Amt2) > 0 THEN BEGIN
            CommEntry.RESET;
            CommEntry.SETCURRENTKEY("Voucher No.");
            CommEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF CommEntry.FINDLAST THEN BEGIN
                CommEntry."Remaining Amount" := EligibleAmt - Amt2;
                CommEntry.MODIFY;
            END;
        END;


        Rec.Post := TRUE;
        Rec.MODIFY;
        MESSAGE('Document has been posted successfully');
    end;


    procedure PostIncentive()
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        EligibleAmt := 0;
        Amt1 := 0;
        EligibleAmt1 := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::Incentive);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                IF VoucherLine."Incentive Type" = VoucherLine."Incentive Type"::Direct THEN BEGIN
                    EligibleAmt += VoucherLine."Eligible Amount";
                    Amt1 += VoucherLine.Amount;
                END ELSE
                    IF VoucherLine."Incentive Type" = VoucherLine."Incentive Type"::Team THEN BEGIN
                        EligibleAmt1 += VoucherLine."Eligible Amount";
                    END;
                Amt2 += VoucherLine.Amount;
            UNTIL VoucherLine.NEXT = 0;


        IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Incentive A/C");

        IF GLAccount.GET(Unitsetup."Incentive A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        PHeader."Payment Method Code" := Rec."Bank/G L Code";
        PHeader."Bal. Account Type" := PaymentMethod."Bal. Account Type";
        PHeader."Bal. Account No." := PaymentMethod."Bal. Account No.";

        PHeader."Cheque No." := Rec."Cheque No.";
        PHeader."Cheque Date" := Rec."Cheque Date";
        //PHeader.Structure := 'EXEMPTED';
        PHeader."Sent for Approval" := TRUE;
        PHeader.Approved := TRUE;
        PHeader.MODIFY;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Incentive A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2);
        PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction INCT");
        PLine.INSERT;

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post (Yes/No)", PHeader);

        //ALLEDK 221212
        IF (EligibleAmt - Amt2) > 0 THEN BEGIN
            IncEntry.RESET;
            IncEntry.SETCURRENTKEY("Voucher No.");
            IncEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF IncEntry.FINDLAST THEN BEGIN
                IncEntry."Remaining Amount" := EligibleAmt - Amt2;
                IncEntry.MODIFY;
            END;
        END;

        IF (EligibleAmt1 - Amt2) > 0 THEN BEGIN
            IncEntry.RESET;
            IncEntry.SETCURRENTKEY("Voucher No.");
            IncEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF IncEntry.FINDLAST THEN BEGIN
                IncEntry."Remaining Amount" := EligibleAmt - Amt2;
                IncEntry.MODIFY;
            END;
        END;

        //ALLEDK 221212


        Rec.Post := TRUE;
        Rec.MODIFY;
        MESSAGE('Document has been posted successfully');
    end;


    procedure PostTA1()
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;
        BondSetup.GET;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::TA);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                //  TDSAmt2 += VoucherLine."TDS Amount";
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;


        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Travel A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");

        IF GLAccount.GET(Unitsetup."Travel A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");



        IF PaymentMethod.GET(Rec."Bank/G L Code") THEN BEGIN
            IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"G/L Account" THEN
                IF GLAccount.GET(PaymentMethod."Bal. Account No.") THEN
                    GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");
        END;

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        //PHeader.Structure := 'EXEMPTED';
        PHeader."Sent for Approval" := TRUE;
        PHeader.Approved := TRUE;
        PHeader.MODIFY;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Travel A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2 - Club9ChargesAmt2);
        PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
        PLine."Detect TDS Amount" := Rec."Advance Amount";
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 20000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
        PLine.VALIDATE(Quantity, -1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 30000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Travel A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post (Yes/No)", PHeader);

        IF Amt2 > Rec."Advance Amount" THEN BEGIN
            IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

            CalcTDSPercentage;
            TDSAmt2 := (Amt2) * TDSPercentage / 100;

            Unitsetup.GET;
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", Unitsetup."Bank Voucher Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", Unitsetup."Bank Voucher Batch Name");
            IF GenJnlLine.FINDLAST THEN
                LineNo2 := GenJnlLine."Line No.";

            GenJnlLine.INIT;
            LineNo2 += 10000;

            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN BEGIN
                GenJnlLine."Journal Template Name" := Unitsetup."Bank Voucher Template Name";
                GenJnlLine."Journal Batch Name" := Unitsetup."Bank Voucher Batch Name";
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";
            END ELSE BEGIN
                GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";
            END;

            IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, FALSE);

            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Line No." := LineNo2;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", Rec."Paid To");
            GenJnlLine.VALIDATE("Debit Amount", DBAmt);
            GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::"Travel Allowance");
            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account")
            ELSE
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", PaymentMethod."Bal. Account No.");
            GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."User Branch Code");
            GenJnlLine."External Document No." := Rec."Document No.";
            GenJnlLine."Cheque No." := Rec."Cheque No.";
            GenJnlLine."Cheque Date" := Rec."Cheque Date";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.INSERT;
            GenJnlPostLine.RUN(GenJnlLine);
        END;

        //ALLEDK 221212
        IF (EligibleAmt - Amt2) > 0 THEN BEGIN
            TVEntry.RESET;
            TVEntry.SETCURRENTKEY("Voucher No.");
            TVEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF TVEntry.FINDLAST THEN BEGIN
                TVEntry."Remaining Amount" := EligibleAmt - Amt2;
                TVEntry.MODIFY;
            END;
        END;
        //ALLEDK 221212


        Rec.Post := TRUE;
        Rec.MODIFY;
        MESSAGE('Document has been posted successfully');
    end;


    procedure PostCommission1()
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::Commission);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                //    TDSAmt2 += VoucherLine."TDS Amount";
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;




        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Commission A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");

        IF GLAccount.GET(Unitsetup."Commission A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF PaymentMethod.GET(Rec."Bank/G L Code") THEN
            IF GLAccount.GET(PaymentMethod."Bal. Account No.") THEN
                GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(Rec."User Branch Code") THEN
            Location.TESTFIELD(Location."T.A.N. No.");

        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        //PHeader.Structure := 'EXEMPTED';
        PHeader."Sent for Approval" := TRUE;
        PHeader.Approved := TRUE;
        PHeader.MODIFY;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Commission A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2 - Club9ChargesAmt2);
        PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction");
        PLine."Detect TDS Amount" := Rec."Advance Amount";
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 20000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
        PLine.VALIDATE(Quantity, -1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 30000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Commission A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post (Yes/No)", PHeader);

        CalcTDSPercentage;
        TDSAmt2 := Amt2 * TDSPercentage / 100;



        DBAmt := 0;
        IF Amt2 > Rec."Advance Amount" THEN BEGIN

            DBAmt := (Amt2 - Club9ChargesAmt2) - ((Amt2 - Club9ChargesAmt2) * TDSPercentage / 100) -
            -(Rec."Advance Amount" - (Rec."Advance Amount" * TDSPercentage / 100));

            Unitsetup.GET;
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", Unitsetup."Bank Voucher Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", Unitsetup."Bank Voucher Batch Name");
            IF GenJnlLine.FINDLAST THEN
                LineNo2 := GenJnlLine."Line No.";

            GenJnlLine.INIT;
            LineNo2 += 10000;

            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN BEGIN
                GenJnlLine."Journal Template Name" := Unitsetup."Bank Voucher Template Name";
                GenJnlLine."Journal Batch Name" := Unitsetup."Bank Voucher Batch Name";
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";
            END ELSE BEGIN
                GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";
            END;

            IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, FALSE);

            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Line No." := LineNo2;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", Rec."Paid To");
            GenJnlLine.VALIDATE("Debit Amount", DBAmt);
            GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::"Travel Allowance");
            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account")
            ELSE
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", PaymentMethod."Bal. Account No.");
            GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."User Branch Code");
            GenJnlLine."External Document No." := Rec."Document No.";
            GenJnlLine."Cheque No." := Rec."Cheque No.";
            GenJnlLine."Cheque Date" := Rec."Cheque Date";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.INSERT;
            // GenJnlPostLine.RUN(GenJnlLine);
        END;

        Rec."Payment Amount" := DBAmt;

        //ALLEDK 221212
        IF (EligibleAmt - Amt2) > 0 THEN BEGIN
            CommEntry.RESET;
            CommEntry.SETCURRENTKEY("Voucher No.");
            CommEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF CommEntry.FINDLAST THEN BEGIN
                CommEntry."Remaining Amount" := EligibleAmt - Amt2;
                CommEntry.MODIFY;
            END;
        END;
        //ALLEDK 221212


        Rec.Post := TRUE;
        Rec.MODIFY;
        MESSAGE('Document has been posted successfully');
    end;


    procedure PostComAndTA1()
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        Amt1 := 0;
        Amt2 := 0;
        ClubAmt1 := 0;
        ClubAmt2 := 0;
        EligibleAmt1 := 0;

        BondSetup.GET;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::TA);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                //    TDSAmt2 += VoucherLine."TDS Amount";
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt1 += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;

        Amt1 := Amt2;
        ClubAmt1 := Club9ChargesAmt2;

        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Travel A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");
        Unitsetup.TESTFIELD(Unitsetup."Commission A/C");
        IF GLAccount.GET(Unitsetup."Commission A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Travel A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        //PHeader.Structure := 'EXEMPTED';
        PHeader."Sent for Approval" := TRUE;
        PHeader.Approved := TRUE;
        PHeader.MODIFY;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Travel A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2 - Club9ChargesAmt2);
        PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
        PLine."Detect TDS Amount" := Rec."Advance Amount";
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 20000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
        PLine.VALIDATE(Quantity, -1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 30000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Travel A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;





        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::Commission);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                //    TDSAmt2 += VoucherLine."TDS Amount";
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;


        ClubAmt2 := Club9ChargesAmt2;


        IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Commission A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 40000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Commission A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2 - Club9ChargesAmt2);
        PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Payable Commission A/c");
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 50000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
        PLine.VALIDATE(Quantity, -1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 60000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Commission A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
        PLine.INSERT;

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post (Yes/No)", PHeader);

        Amt3 := Amt1 + Amt2;

        CalcTDSPercentage;

        TDSAmt2 := Amt3 * TDSPercentage / 100;


        DBAmt := 0;
        IF Amt3 > Rec."Advance Amount" THEN BEGIN

            DBAmt := (Amt3 - (ClubAmt1 + ClubAmt2) - ((Amt3 - (ClubAmt1 + ClubAmt2)) * TDSPercentage / 100 - Rec."Advance Amount" * TDSPercentage / 100))
            - (Rec."Advance Amount" - (Rec."Advance Amount" * TDSPercentage / 100));

            IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

            Unitsetup.GET;
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", Unitsetup."Bank Voucher Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", Unitsetup."Bank Voucher Batch Name");
            IF GenJnlLine.FINDLAST THEN
                LineNo2 := GenJnlLine."Line No.";

            GenJnlLine.INIT;
            LineNo2 += 10000;

            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN BEGIN
                GenJnlLine."Journal Template Name" := Unitsetup."Bank Voucher Template Name";
                GenJnlLine."Journal Batch Name" := Unitsetup."Bank Voucher Batch Name";
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";
            END ELSE BEGIN
                GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";
            END;

            IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, FALSE);

            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Line No." := LineNo2;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", Rec."Paid To");
            GenJnlLine.VALIDATE("Debit Amount", DBAmt);
            GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::"Travel Allowance");
            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account")
            ELSE
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", PaymentMethod."Bal. Account No.");
            GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."User Branch Code");
            GenJnlLine."External Document No." := Rec."Document No.";
            GenJnlLine."Cheque No." := Rec."Cheque No.";
            GenJnlLine."Cheque Date" := Rec."Cheque Date";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.INSERT;
            GenJnlPostLine.RUN(GenJnlLine);
        END;

        //ALLEDK 221212

        IF (EligibleAmt1 - Amt1) > 0 THEN BEGIN
            TVEntry.RESET;
            TVEntry.SETCURRENTKEY("Voucher No.");
            TVEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF TVEntry.FINDLAST THEN BEGIN
                TVEntry."Remaining Amount" := EligibleAmt1 - Amt1;
                TVEntry.MODIFY;
            END;
        END;

        IF (EligibleAmt - Amt2) > 0 THEN BEGIN
            CommEntry.RESET;
            CommEntry.SETCURRENTKEY("Voucher No.");
            CommEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF CommEntry.FINDLAST THEN BEGIN
                CommEntry."Remaining Amount" := EligibleAmt - Amt2;
                CommEntry.MODIFY;
            END;
        END;
        //ALLEDK 221212


        Rec.Post := TRUE;
        Rec.MODIFY;
        MESSAGE('Document has been posted successfully');
    end;


    procedure PostIncentive1()
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::Incentive);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                //    TDSAmt2 += VoucherLine."TDS Amount";
                //    Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;


        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Incentive A/C");

        IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

        IF GLAccount.GET(Unitsetup."Incentive A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");




        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        //PHeader.Structure := 'EXEMPTED';
        PHeader."Sent for Approval" := TRUE;
        PHeader.Approved := TRUE;
        PHeader.MODIFY;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Incentive A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2);
        PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction INCT");
        PLine.INSERT;

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post (Yes/No)", PHeader);


        CalcTDSPercentage;

        TDSAmt2 := Amt2 * TDSPercentage / 100;


        DBAmt := 0;
        IF Amt2 > Rec."Advance Amount" THEN BEGIN
            DBAmt := (Amt2 - (Amt2 * TDSPercentage / 100 - Rec."Advance Amount" * TDSPercentage / 100))
              - (Rec."Advance Amount" - (Rec."Advance Amount" * TDSPercentage / 100));


            Unitsetup.GET;
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", Unitsetup."Bank Voucher Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", Unitsetup."Bank Voucher Batch Name");
            IF GenJnlLine.FINDLAST THEN
                LineNo2 := GenJnlLine."Line No.";

            GenJnlLine.INIT;
            LineNo2 += 10000;

            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN BEGIN
                GenJnlLine."Journal Template Name" := Unitsetup."Bank Voucher Template Name";
                GenJnlLine."Journal Batch Name" := Unitsetup."Bank Voucher Batch Name";
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";
            END ELSE BEGIN
                GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";
            END;

            IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, FALSE);

            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Line No." := LineNo2;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", Rec."Paid To");
            GenJnlLine.VALIDATE("Debit Amount", DBAmt);
            GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::"Travel Allowance");
            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account")
            ELSE
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", PaymentMethod."Bal. Account No.");
            GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."User Branch Code");
            GenJnlLine."External Document No." := Rec."Document No.";
            GenJnlLine."Cheque No." := Rec."Cheque No.";
            GenJnlLine."Cheque Date" := Rec."Cheque Date";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.INSERT;
            GenJnlPostLine.RUN(GenJnlLine);

        END;


        //ALLEDK 221212
        IF (EligibleAmt - Amt2) > 0 THEN BEGIN
            IncEntry.RESET;
            IncEntry.SETCURRENTKEY("Voucher No.");
            IncEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF IncEntry.FINDLAST THEN BEGIN
                IncEntry."Remaining Amount" := EligibleAmt - Amt2;
                IncEntry.MODIFY;
            END;
        END;
        //ALLEDK 221212

        Rec.Post := TRUE;
        Rec.MODIFY;
        MESSAGE('Document has been posted successfully');
    end;


    procedure CalcTDSPercentage()
    var
        TDSSetup: Record "TDS Setup";// 13728;
        //NODLines: Record 13785;//Need to check the code in UAT
        Vendor: Record Vendor;
        AllowedSection: Record "Allowed Sections";
        CodeunitEventMgt: Codeunit "BBG Codeunit Event Mgnt.";
    begin
        TDSPercentage := 0;
        //IF Vendor.GET(Rec."Paid To") THEN;
        Unitsetup.GET;
        TDSSetup.RESET;

        IF Vendor.Get(Rec."Paid To") Then begin
            AllowedSection.Reset();
            AllowedSection.SetRange("Vendor No", Vendor."No.");
            AllowedSection.SetRange("TDS Section", TDSCode);
            IF AllowedSection.FindFirst() then begin
                TDSPercentage := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
            end;
        end;
        /*
        TDSSetup.SETRANGE("TDS Nature of Deduction", TDSCode);
        TDSSetup.SETRANGE("Assessee Code", PHeader."Assessee Code");
        //TDSSetup.SETRANGE("TDS Group","TDS Group");
        TDSSetup.SETRANGE("Effective Date", 0D, Rec."Posting Date");
        NODLines.RESET;
        NODLines.SETRANGE(Rec.Type, NODLines.Type::Vendor);
        NODLines.SETRANGE("No.", Rec."Paid To");
        NODLines.SETRANGE("NOD/NOC", TDSCode);
        IF NODLines.FIND('-') THEN BEGIN
            IF NODLines."Concessional Code" <> '' THEN
                TDSSetup.SETRANGE("Concessional Code", NODLines."Concessional Code")
            ELSE
                TDSSetup.SETRANGE("Concessional Code", '');
            IF NOT TDSSetup.FIND('+') THEN BEGIN
                TDSPercentage := 0;
            END ELSE BEGIN
                IF (Vendor."P.A.N. Status" = Vendor."P.A.N. Status"::" ") AND (Vendor."P.A.N. No." <> '') THEN
                    TDSPercentage := TDSSetup."TDS %"
                ELSE
                    TDSPercentage := TDSSetup."Non PAN TDS %";
            END;
        END;
        *///Need to check the code in UAT

    end;


    procedure ReversalInvoiceComTA(AssocPmtVoucherHeader: Record "Assoc Pmt Voucher Header")
    var
        VLE: Record "Vendor Ledger Entry";
        ReversalEntry: Record "Reversal Entry";
        RevEntry: Record "Reversal Entry";
        PAGERevEntries: Page "Auto Reverse Entries";
    begin

        VLE.RESET;
        VLE.SETRANGE("Vendor No.", AssocPmtVoucherHeader."Paid To");
        VLE.SETRANGE("External Document No.", AssocPmtVoucherHeader."Document No.");
        VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
        IF VLE.FINDFIRST THEN BEGIN
            CLEAR(ReversalEntry);
            IF VLE.Reversed THEN
                ReversalEntry.AlreadyReversedEntry(Rec.TABLECAPTION, VLE."Entry No.");
            VLE.TESTFIELD("Transaction No.");
            RevEntry.DELETEALL;
            ReversalEntry.AutoReverseTransaction(VLE."Transaction No.", AssocPmtVoucherHeader."Posting Date");
            PAGERevEntries.RUN;
        END;
    end;

    local procedure PaymentModeOnAfterValidate()
    begin
        UpdateGLCode;
    end;
}

