codeunit 97735 "UpdateCharges /Post/Rev AssPmt"
{
    // 271119 Added new code

    Permissions = TableData "Vendor Ledger Entry" = rim;
    TableNo = "Confirmed Order";

    trigger OnRun()
    begin
        CLEARALL;
        ConfirmedOrder.COPY(Rec);



        Rec."Unit Code" := Rec."New Unit No.";
        UnitMaster.GET(Rec."New Unit No.");
        Rec."Maturity Amount" := UnitMaster."Min. Allotment Amount";
        Rec.Amount := UnitMaster."Total Value";
        Rec."Payment Plan" := UnitMaster."Payment Plan";
        Rec."Saleable Area" := UnitMaster."Saleable Area";
        Rec."Min. Allotment Amount" := UnitMaster."Min. Allotment Amount"; //ALLEDK 260213
        Rec.VALIDATE(Amount);
        Rec.MODIFY;
        IF Rec."Unit Code" <> '' THEN BEGIN


            AppCharges1.RESET;
            AppCharges1.SETRANGE("Document No.", Rec."No.");
            AppCharges1.SETRANGE("Item No.", Rec."Dummay Unit Code");
            IF AppCharges1.FINDSET THEN
                REPEAT
                    AppCharges1.DELETE;
                UNTIL AppCharges1.NEXT = 0;
            IF Rec.Type = Rec.Type::Priority THEN BEGIN
                UCB.RESET;
                UCB.SETRANGE("Unit No.", Rec."No.");
                IF UCB.FINDSET THEN
                    REPEAT
                        UCB.DELETE;
                    UNTIL UCB.NEXT = 0;
            END;
            Docmaster.RESET;
            Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
            Docmaster.SETFILTER(Docmaster."Project Code", Rec."Shortcut Dimension 1 Code");
            Docmaster.SETFILTER(Docmaster."Unit Code", Rec."Unit Code");
            IF Docmaster.FINDFIRST THEN
                REPEAT
                    AppCharges.RESET;
                    AppCharges.INIT;
                    AppCharges."Document Type" := Docmaster."Document Type"::Charge;
                    AppCharges.Code := Docmaster.Code;

                    AppCharges.Description := Docmaster.Description;
                    AppCharges."Document No." := Rec."No.";
                    AppCharges."Item No." := Rec."Unit Code";
                    AppCharges."Membership Fee" := Docmaster."Membership Fee";
                    IF Docmaster."Project Price Dependency Code" <> '' THEN BEGIN
                        PPGD.RESET;
                        PPGD.SETFILTER(PPGD."Project Code", Rec."Shortcut Dimension 1 Code");
                        PPGD.SETRANGE(PPGD."Project Price Group", Docmaster."Project Price Dependency Code");
                        PPGD.SETFILTER(PPGD."Starting Date", '<=%1', Rec."Document Date");
                        IF PPGD.FINDLAST THEN BEGIN
                            IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Sale THEN
                                AppCharges."Rate/UOM" := PPGD."Sales Rate (per sq ft)";
                            IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Lease THEN
                                AppCharges."Rate/UOM" := PPGD."Lease Rate (per sq ft)";

                        END;
                    END
                    ELSE
                        AppCharges."Rate/UOM" := Docmaster."Rate/Sq. Yd";

                    AppCharges."Project Code" := Docmaster."Project Code";
                    AppCharges."Fixed Price" := Docmaster."Fixed Price";
                    AppCharges."BP Dependency" := Docmaster."BP Dependency";
                    AppCharges."Rate Not Allowed" := Docmaster."Rate Not Allowed";
                    AppCharges."Project Price Dependency Code" := Docmaster."Project Price Dependency Code";
                    IF AppCharges."Rate/UOM" <> 0 THEN BEGIN
                        ItemRec.GET(Rec."Unit Code");
                        AppCharges."Net Amount" := ItemRec."Saleable Area" * AppCharges."Rate/UOM";
                    END
                    ELSE
                        AppCharges."Net Amount" := AppCharges."Fixed Price";
                    AppCharges.Sequence := Docmaster.Sequence;
                    IF AppCharges.Code = 'PLC' THEN BEGIN
                        Plcrec.SETFILTER("Item Code", Rec."Unit Code");
                        Plcrec.SETFILTER("Job Code", Rec."Shortcut Dimension 1 Code");
                        IF Plcrec.FINDFIRST THEN
                            REPEAT
                                AppCharges."Fixed Price" := AppCharges."Fixed Price" + Plcrec.Amount;
                                AppCharges."Net Amount" := AppCharges."Fixed Price";
                            UNTIL Plcrec.NEXT = 0;
                    END;
                    AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
                    AppCharges."Direct Associate" := Docmaster."Direct Associate";
                    AppCharges.Applicable := TRUE;
                    AppCharges.INSERT;
                UNTIL Docmaster.NEXT = 0;
        END;

        IF RecUnitMaster.GET(Rec."Dummay Unit Code") THEN;

        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
        PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Payment Plan Code", RecUnitMaster."Payment Plan");
        PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Document No.", Rec."No.");
        IF PaymentPlanDetails.FIND('-') THEN
            REPEAT
                PaymentPlanDetails.DELETE;
            UNTIL PaymentPlanDetails.NEXT = 0;

        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", Rec."No.");
        IF PaymentTermLines.FINDSET THEN
            REPEAT
                PaymentTermLines.DELETE;
            UNTIL PaymentTermLines.NEXT = 0;


        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
        PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Payment Plan Code", UnitMaster."Payment Plan");
        PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Document No.", '');
        IF PaymentPlanDetails.FIND('-') THEN
            REPEAT
                PaymentPlanDetails1.INIT;
                PaymentPlanDetails1.COPY(PaymentPlanDetails);
                PaymentPlanDetails1."Document No." := Rec."No.";
                PaymentPlanDetails1.INSERT;
            UNTIL PaymentPlanDetails.NEXT = 0;

        UnitMaster.TESTFIELD("Total Value");

        totalamount1 := 0;
        PaymentDetails.RESET;
        PaymentDetails.SETFILTER("Project Code", Rec."Shortcut Dimension 1 Code");
        PaymentDetails.SETFILTER("Document No.", Rec."No.");
        PaymentDetails.SETRANGE("Payment Plan Code", UnitMaster."Payment Plan");
        IF PaymentDetails.FINDFIRST THEN
            REPEAT
                IF PaymentDetails."Percentage Cum" > 0 THEN BEGIN
                    IF PaymentDetails."Percentage Cum" = 100 THEN
                        PaymentDetails."Total Charge Amount" := (UnitMaster."Total Value" - totalamount1)
                    ELSE
                        PaymentDetails."Total Charge Amount" := (UnitMaster."Total Value" * PaymentDetails."Percentage Cum" / 100) - totalamount1;
                END;
                IF PaymentDetails."Fixed Amount" <> 0 THEN BEGIN
                    PaymentDetails."Total Charge Amount" := PaymentDetails."Fixed Amount";
                END;

                totalamount1 := PaymentDetails."Total Charge Amount" + totalamount1;
                PaymentDetails.VALIDATE("Total Charge Amount");
                PaymentDetails.MODIFY;
            UNTIL PaymentDetails.NEXT = 0;




        Sno := '001';

        TotalAmount := 0;
        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Payment Plan Code", UnitMaster."Payment Plan");
        PaymentPlanDetails.SETRANGE("Document No.", Rec."No.");
        PaymentPlanDetails.SETRANGE("Payment Plan Code", UnitMaster."Payment Plan");
        IF PaymentPlanDetails.FINDSET THEN
            REPEAT
                PaymentPlanDetails2.COPY(PaymentPlanDetails);
                TotalAmount := TotalAmount + PaymentPlanDetails2."Milestone Charge Amount";
                PaymentPlanDetails2.INSERT;
            UNTIL PaymentPlanDetails.NEXT = 0;

        Applicablecharge.RESET;
        Applicablecharge.SETCURRENTKEY("Document No.", Applicablecharge.Sequence);
        Applicablecharge.SETRANGE("Document No.", Rec."No.");
        Applicablecharge.SETRANGE(Applicable, TRUE);
        IF Applicablecharge.FINDSET THEN BEGIN
            MilestoneCodeG := '1';
            PaymentPlanDetails2.RESET;
            PaymentPlanDetails2.SETRANGE("Payment Plan Code", UnitMaster."Payment Plan");
            PaymentPlanDetails2.SETRANGE("Document No.", Rec."No.");
            PaymentPlanDetails2.SETRANGE(Checked, FALSE);
            IF PaymentPlanDetails2.FINDSET THEN
                REPEAT
                    LoopingAmount := 0;
                    REPEAT
                        IF Applicablecharge."Net Amount" = PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                            CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");
                            PaymentPlanDetails2.Checked := TRUE;
                            PaymentPlanDetails2.MODIFY;
                            TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";
                            Applicablecharge."Net Amount" := 0;
                            InLoop := TRUE;
                        END;
                        IF Applicablecharge."Net Amount" > PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                            CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");
                            PaymentPlanDetails2.Checked := TRUE;
                            PaymentPlanDetails2.MODIFY;

                            TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";//ALLE PS
                            LoopingAmount := 0;

                            Applicablecharge."Net Amount" := Applicablecharge."Net Amount" -
                              PaymentPlanDetails2."Milestone Charge Amount";

                            InLoop := TRUE;
                        END ELSE
                            IF (Applicablecharge."Net Amount" < PaymentPlanDetails2."Milestone Charge Amount") AND
                              (Applicablecharge."Net Amount" <> 0) THEN BEGIN
                                CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                PaymentPlanDetails2."Project Milestone Due Date", Applicablecharge."Net Amount",
                                Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");
                                TotalAmount := TotalAmount - Applicablecharge."Net Amount";//ALLE PS
                                LoopingAmount := PaymentPlanDetails2."Milestone Charge Amount" - Applicablecharge."Net Amount";

                                PaymentPlanDetails2."Milestone Charge Amount" := PaymentPlanDetails2."Milestone Charge Amount" -
                                Applicablecharge."Net Amount";
                                PaymentPlanDetails2.MODIFY;
                                Applicablecharge."Net Amount" := 0;
                                InLoop := TRUE;
                            END;
                        IF Applicablecharge."Net Amount" = 0 THEN BEGIN
                            Applicablecharge.NEXT;
                        END;

                    UNTIL (LoopingAmount = 0) OR (TotalAmount = 0);
                UNTIL (PaymentPlanDetails2.NEXT = 0) OR (TotalAmount = 0);
        END;

        ModifyAPP.RESET;
        ModifyAPP.SETRANGE("Document No.", Rec."No.");
        //ModifyAPP.SETRANGE("Priority Payment",TRUE);
        IF ModifyAPP.FINDFIRST THEN
            REPEAT
                ModifyAPP.Posted := FALSE;
                ModifyAPP."Explode BOM" := FALSE;
                ModifyAPP."Priority Payment" := FALSE;
                ModifyAPP.MODIFY;
            UNTIL ModifyAPP.NEXT = 0;

        //ModifyUnitAPP.RESET;
        //ModifyUnitAPP.SETRANGE("Document No.","No.");
        //ModifyUnitAPP.SETFILTER("Priority Payment",'%1',TRUE);
        //IF ModifyUnitAPP.FINDFIRST THEN
        //  REPEAT
        //    ModifyUnitAPP.DELETE;
        //  UNTIL ModifyUnitAPP.NEXT = 0;

        //"New Unit No." := '';
        //Type := Type::Normal;
        Rec.MODIFY;
    end;

    var
        ConfirmedOrder: Record "Confirmed Order";
        AppCharges: Record "Applicable Charges";
        Docmaster: Record "Document Master";
        UnitMaster: Record "Unit Master";
        PPGD: Record "Project Price Group Details";
        ItemRec: Record "Unit Master";
        Plcrec: Record "PLC Details";
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        Applicablecharge: Record "Applicable Charges";
        PaymentPlanDetails2: Record "Payment Plan Details" temporary;
        PaymentTermLines: Record "Payment Terms Line Sale";
        Sno: Code[10];
        totalamount1: Decimal;
        MilestoneCodeG: Code[10];
        LoopingAmount: Decimal;
        InLoop: Boolean;
        PaymentDetails: Record "Payment Plan Details";
        BondSetup: Record "Unit Setup";
        BondpaymentEntry: Record "Unit Payment Entry";
        LineNo: Integer;
        PostPayment: Codeunit PostPayment;
        MsgDialog: Dialog;
        PenaltyAmount: Decimal;
        ReverseComm: Boolean;
        Bond: Record "Confirmed Order";
        ComEntry: Record "Commission Entry";
        ReceivedAmount: Decimal;
        TotalAmount: Decimal;
        ExcessAmount: Decimal;
        ModifyAPP: Record "Application Payment Entry";
        ConfOrder: Record "Confirmed Order";
        UnitMaster1: Record "Unit Master";
        UnitMaster2: Record "Unit Master";
        confirmedorderform: Page "Confirmed Order";
        ModifyUnitAPP: Record "Unit Payment Entry";
        RecUnitMaster: Record "Unit Master";
        AppCharges1: Record "Applicable Charges";
        UCB: Record "Unit & Comm. Creation Buffer";
        "------------------": Integer;
        AccCode: Text[20];
        Amt2: Decimal;
        TDSAmt2: Decimal;
        Club9ChargesAmt2: Decimal;
        EligibleAmt: Decimal;
        VoucherLine: Record "Voucher Line";
        UserSetup: Record "User Setup";
        Unitsetup: Record "Unit Setup";
        GLAccount: Record "G/L Account";
        Location: Record Location;
        PHeader: Record "Purchase Header";
        Dim2Code: Code[20];
        CompanyWiseGL: Record "Company wise G/L Account";
        PLine: Record "Purchase Line";
        EligibleAmt1: Decimal;
        Amt1: Decimal;
        Club9Post: Decimal;
        TDSPercentage: Decimal;
        DBAmt: Decimal;
        GenJnlLine: Record "Gen. Journal Line";
        LineNo2: Integer;
        GenJnlBatch: Record "Gen. Journal Batch";
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        RecGenJnlLines: Record "Gen. Journal Line";
        GLEntry: Record "G/L Entry";
        ClubAmt1: Decimal;
        ClubAmt2: Decimal;
        Amt3: Decimal;
        CreatTA: Boolean;
        //RecNODHeader: Record 13786;//Need to check the code in UAT

        GenLedSetup: Record "General Ledger Setup";
        GLSetup: Record "General Ledger Setup";
        "-------------------------": Integer;
        ReversalEntry: Record "Reversal Entry";
        Text000: Label 'Reverse Transaction Entries';
        Text001: Label 'Reverse Register Entries';
        Text002: Label 'Do you want to reverse the entries?';
        Text003: Label 'The entries were successfully reversed.';
        Text004: Label 'To reverse these entries, the program will post correcting entries.';
        Text005: Label 'Do you want to reverse the entries and print the report?';
        Text006: Label 'There is nothing to reverse.';
        Text007: Label '\There are one or more FA Ledger Entries. You should consider using the fixed asset function Cancel Entries.';
        Text008: Label 'Changes have been made to posted entries after the window was opened.\Close and reopen the window to continue.';
        ExtDocNo: Code[20];
        VendNo: Code[20];
        VendLE: Record "Vendor Ledger Entry";
        CommPayVoucher: Record "Assoc Pmt Voucher Header";
        CommEntry: Record "Commission Entry";
        LastEntryNo: Integer;
        CommissionEntry: Record "Commission Entry";
        TPE: Record "Travel Payment Entry";
        TravelPmtEntry: Record "Travel Payment Entry";
        APEntry: Record "Application Payment Entry";
        IncentiveSummary: Record "Incentive Summary";
        RecReverseEntry: Record "Reversal Entry";
        RemAmount: Decimal;
        CommEntry2: Record "Commission Entry";
        GenJnlManagement: Codeunit GenJnlManagement;
        TotalDebitAmount: Decimal;
        TotalCreditAmount: Decimal;
        RoundOff: Decimal;
        RecGenJnlLine: Record "Gen. Journal Line";
        CommEntry_1: Record "Commission Entry";
        TPEntry_1: Record "Travel Payment Entry";


    procedure CreatePaymentTermsLine(MilestoneCode: Code[10]; MilestoneDescription: Text[50]; MilestoneDueDate: Date; Milestoneamt: Decimal; ChargeCode: Code[10]; CommisionApplicable: Boolean; DirectAssociate: Boolean)
    begin
        PaymentTermLines.INIT;
        PaymentTermLines."Document No." := ConfirmedOrder."No.";
        PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
        PaymentTermLines.Sequence := Sno;
        Sno := INCSTR(Sno);
        PaymentTermLines."Actual Milestone" := MilestoneCode;
        PaymentTermLines."Payment Plan" := PaymentPlanDetails."Payment Plan Code";
        PaymentTermLines.Description := MilestoneDescription;
        PaymentTermLines."Due Date" := MilestoneDueDate;
        PaymentTermLines."Project Code" := ConfirmedOrder."Shortcut Dimension 1 Code";
        PaymentTermLines."Calculation Type" := PaymentTermLines."Calculation Type"::"% age";
        PaymentTermLines."Criteria Value / Base Amount" := Milestoneamt;
        PaymentTermLines."Calculation Value" := 100;
        PaymentTermLines."Due Amount" := ROUND(Milestoneamt, 0.01, '=');
        PaymentTermLines."Charge Code" := ChargeCode;
        PaymentTermLines."Commision Applicable" := CommisionApplicable;
        PaymentTermLines."Direct Associate" := DirectAssociate;
        PaymentTermLines.INSERT(TRUE);
    end;


    procedure PostTA(VoucherHeader: Record "Assoc Pmt Voucher Header")
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;
        BondSetup.GET;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", VoucherHeader."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::TA);
        IF VoucherLine.FINDSET THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                // TDSAmt2 += VoucherLine."TDS Amount";
                EligibleAmt += VoucherLine."Eligible Amount";
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
            UNTIL VoucherLine.NEXT = 0;




        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Travel A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");
        //ALLEDK 060113
        CheckCostCode(Unitsetup."Travel A/C");
        CheckCostCode(Unitsetup."Corpus A/C");
        CheckCostCode(Unitsetup."Commission A/C");
        //ALLEDK 060113
        IF GLAccount.GET(Unitsetup."Travel A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := VoucherHeader."Document No.";
        PHeader.INSERT;
        PHeader.VALIDATE("Posting Date", VoucherHeader."Posting Date");
        PHeader.VALIDATE("Buy-from Vendor No.", VoucherHeader."Paid To");

        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := VoucherHeader."Document No.";
        PHeader."Vendor Invoice Date" := VoucherHeader."Posting Date";

        //BBG1.00 ALLEDK 070313
        IF NOT VoucherHeader."Create Invoice Only" THEN BEGIN      //BBG2.00
            PHeader."Payment Method Code" := 'CASH';
            CompanyWiseGL.RESET;
            CompanyWiseGL.SETRANGE(CompanyWiseGL."MSC Company", TRUE);
            IF CompanyWiseGL.FINDFIRST THEN
                CompanyWiseGL.TESTFIELD(CompanyWiseGL."Payable Account");

            PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"G/L Account";
            PHeader."Bal. Account No." := CompanyWiseGL."Payable Account";
        END;   //BBG2.00
        //BBG1.00 ALLEDK 070313

        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Cheque No." := VoucherHeader."Cheque No.";
        PHeader."Cheque Date" := VoucherHeader."Cheque Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::"Travel Allowance";
        PHeader.Approved := TRUE;
        PHeader."From MS Company" := VoucherHeader."From MS Company";
        PHeader."Assigned User ID" := USERID;
        PHeader.MODIFY;

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Travel A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2);
        IF NOT VoucherHeader."Create Invoice Only" THEN       //BBG2.00
            PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
        PLine.INSERT;
        IF NOT VoucherHeader."Create Invoice Only" THEN BEGIN      //BBG2.00
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
        END;     //BBG2.00
        CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PHeader);
    end;


    procedure PostCommission(VoucherHeader: Record "Assoc Pmt Voucher Header")
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;
        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", VoucherHeader."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::Commission);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;



        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Commission A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");
        Unitsetup.TESTFIELD("Posting Voucher No. Series");
        //ALLEDK 060113
        CheckCostCode(Unitsetup."Commission A/C");
        CheckCostCode(Unitsetup."Corpus A/C");
        //ALLEDK 060113


        IF GLAccount.GET(Unitsetup."Commission A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := VoucherHeader."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Posting Date", VoucherHeader."Posting Date");
        PHeader.VALIDATE("Buy-from Vendor No.", VoucherHeader."Paid To");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := VoucherHeader."Document No.";
        PHeader."Vendor Invoice Date" := VoucherHeader."Posting Date";

        IF NOT VoucherHeader."Create Invoice Only" THEN BEGIN      //BBG2.00
            PHeader."Payment Method Code" := 'CASH';
            CompanyWiseGL.RESET;
            CompanyWiseGL.SETRANGE(CompanyWiseGL."MSC Company", TRUE);
            IF CompanyWiseGL.FINDFIRST THEN
                CompanyWiseGL.TESTFIELD(CompanyWiseGL."Payable Account");

            PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"G/L Account";
            PHeader."Bal. Account No." := CompanyWiseGL."Payable Account";
        END;   //BBG2.00

        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Cheque No." := VoucherHeader."Cheque No.";
        PHeader."Cheque Date" := VoucherHeader."Cheque Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission;
        PHeader.Approved := TRUE;
        PHeader."From MS Company" := VoucherHeader."From MS Company";
        PHeader."Assigned User ID" := USERID;
        PHeader.MODIFY;

        //InsertDocumentDimension(PHeader); //BBG1.00 ALLEDK 070313



        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Commission A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2);
        IF NOT VoucherHeader."Create Invoice Only" THEN      //BBG2.00
            PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction");
        PLine.INSERT;

        IF NOT VoucherHeader."Create Invoice Only" THEN BEGIN      //BBG2.00
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
        END;   //BBG2.00
        CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PHeader);
        //150213
    end;


    procedure PostComAndTA(VoucherHeader: Record "Assoc Pmt Voucher Header")
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt1 := 0;
        BondSetup.GET;
        Amt1 := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", VoucherHeader."Document No.");
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt1 += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;


        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Travel A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");
        Unitsetup.TESTFIELD(Unitsetup."Commission A/C");
        Unitsetup.TESTFIELD("Posting Voucher No. Series");

        //ALLEDK 060113
        CheckCostCode(Unitsetup."Commission A/C");
        CheckCostCode(Unitsetup."Corpus A/C");
        CheckCostCode(Unitsetup."Travel A/C");
        //ALLEDK 060113

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
        PHeader."No." := VoucherHeader."Document No.";
        PHeader.INSERT;
        PHeader.VALIDATE("Posting Date", VoucherHeader."Posting Date");
        PHeader.VALIDATE("Buy-from Vendor No.", VoucherHeader."Paid To");

        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := VoucherHeader."Document No.";
        PHeader."Vendor Invoice Date" := VoucherHeader."Posting Date";

        IF NOT VoucherHeader."Create Invoice Only" THEN BEGIN      //BBG2.00
            PHeader."Payment Method Code" := 'CASH';
            CompanyWiseGL.RESET;
            CompanyWiseGL.SETRANGE(CompanyWiseGL."MSC Company", TRUE);
            IF CompanyWiseGL.FINDFIRST THEN
                CompanyWiseGL.TESTFIELD(CompanyWiseGL."Payable Account");

            PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"G/L Account";
            PHeader."Bal. Account No." := CompanyWiseGL."Payable Account";
        END;   //BBG2.00

        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Cheque No." := VoucherHeader."Cheque No.";
        PHeader."Cheque Date" := VoucherHeader."Cheque Date";
        ///PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::CommAndTA;
        PHeader.Approved := TRUE;
        PHeader."From MS Company" := VoucherHeader."From MS Company";
        PHeader."Assigned User ID" := USERID;
        PHeader.MODIFY;

        IF Amt2 > 0 THEN BEGIN
            PLine.INIT;
            PLine."Document Type" := PLine."Document Type"::Invoice;
            PLine."Document No." := PHeader."No.";
            PLine."Line No." := 10000;
            PLine.Type := PLine.Type::"G/L Account";
            PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
            PLine.VALIDATE("No.", Unitsetup."Travel A/C");
            PLine.VALIDATE(Quantity, 1);
            PLine.VALIDATE(PLine."Direct Unit Cost", Amt2);
            IF NOT VoucherHeader."Create Invoice Only" THEN       //BBG2.00
                PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
            PLine.INSERT;
            IF NOT VoucherHeader."Create Invoice Only" THEN BEGIN      //BBG2.00
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
            END;   //BBG2.00
        END;
        CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PHeader);
    end;


    procedure PostIncentive(VoucherHeader: Record "Assoc Pmt Voucher Header")
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        EligibleAmt := 0;
        Amt1 := 0;
        EligibleAmt1 := 0;
        Club9ChargesAmt2 := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", VoucherHeader."Document No.");
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
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
            UNTIL VoucherLine.NEXT = 0;



        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Incentive A/C");
        Unitsetup.TESTFIELD("Posting Voucher No. Series");

        //ALLEDK 060113
        CheckCostCode(Unitsetup."Incentive A/C");
        //ALLEDK 060113

        IF GLAccount.GET(Unitsetup."Incentive A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := VoucherHeader."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Posting Date", VoucherHeader."Posting Date");
        PHeader.VALIDATE("Buy-from Vendor No.", VoucherHeader."Paid To");

        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);

        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := VoucherHeader."Document No.";
        PHeader."Vendor Invoice Date" := VoucherHeader."Posting Date";
        IF NOT VoucherHeader."Create Invoice Only" THEN BEGIN      //BBG2.00
            PHeader."Payment Method Code" := 'CASH';
            CompanyWiseGL.RESET;
            CompanyWiseGL.SETRANGE(CompanyWiseGL."MSC Company", TRUE);
            IF CompanyWiseGL.FINDFIRST THEN
                CompanyWiseGL.TESTFIELD(CompanyWiseGL."Payable Account");

            PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"G/L Account";
            PHeader."Bal. Account No." := CompanyWiseGL."Payable Account";
        END;   //BBG2.00

        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Cheque No." := VoucherHeader."Cheque No.";
        PHeader."Cheque Date" := VoucherHeader."Cheque Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Incentive;
        PHeader.Approved := TRUE;
        PHeader."Assigned User ID" := USERID;
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
        IF NOT VoucherHeader."Create Invoice Only" THEN       //BBG2.00
            PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction INCT");
        PLine.INSERT;

        IF NOT VoucherHeader."Create Invoice Only" THEN BEGIN      //BBG2.00
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
        END;   //BBG2.00

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PHeader);
    end;


    procedure PostTA1(VoucherHeader: Record "Assoc Pmt Voucher Header")
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;
        BondSetup.GET;
        Club9Post := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", VoucherHeader."Document No.");
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
        Unitsetup.TESTFIELD("Posting Voucher No. Series");



        IF ABS(VoucherHeader."Advance Amount") < Amt2 THEN
            Club9Post := ((Amt2 - ABS(VoucherHeader."Advance Amount")) * Unitsetup."Corpus %" / 100)
        ELSE
            Club9Post := 0;



        //ALLEDK 060113
        CheckCostCode(Unitsetup."Corpus A/C");
        CheckCostCode(Unitsetup."Travel A/C");
        //ALLEDK 060113

        IF GLAccount.GET(Unitsetup."Travel A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");

        IF Amt2 > ABS(VoucherHeader."Advance Amount") THEN BEGIN

            CalcTDSPercentage(VoucherHeader);
            TDSAmt2 := (Amt2) * TDSPercentage / 100;

            IF VoucherHeader."Net Elig." < 0 THEN BEGIN

                DBAmt := ABS(VoucherHeader."Net Elig.");

                Unitsetup.GET;
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", Unitsetup."Bank Voucher Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", Unitsetup."Bank Voucher Batch Name");
                IF GenJnlLine.FINDLAST THEN
                    LineNo2 := GenJnlLine."Line No.";

                GenJnlLine.INIT;
                LineNo2 += 10000;

                GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";

                IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                    DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

                GenJnlLine."Document No." := DocNo;
                GenJnlLine."Line No." := LineNo2;
                GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Posting Date", VoucherHeader."Posting Date");
                GenJnlLine.VALIDATE("Document Date", VoucherHeader."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", VoucherHeader."Paid To");
                GenJnlLine.VALIDATE("Debit Amount", ROUND(DBAmt, 1));
                GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::"Travel Allowance");
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                CompanyWiseGL.RESET;
                CompanyWiseGL.SETRANGE(CompanyWiseGL."MSC Company", TRUE);
                IF CompanyWiseGL.FINDFIRST THEN
                    CompanyWiseGL.TESTFIELD(CompanyWiseGL."Payable Account");
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", CompanyWiseGL."Payable Account");
                GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
                GenJnlLine."External Document No." := VoucherHeader."Document No.";
                GenJnlLine."Cheque No." := VoucherHeader."Cheque No.";
                GenJnlLine."Cheque Date" := VoucherHeader."Cheque Date";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Branch Code" := UserSetup."User Branch";  //180113
                GenJnlLine.VALIDATE("Bal. Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::Purchase);  //140213
                GenJnlLine.INSERT;
                CLEAR(GenJnlPostLine);
                InsertJnlDimension(GenJnlLine); //ALLEDK 010213
                GenJnlPostLine.RunWithCheck(GenJnlLine);  //ALLEDK 010213
                                                          //ALLEDK 140213
                RecGenJnlLines.RESET;
                RecGenJnlLines.SETRANGE("Document No.", DocNo);
                IF RecGenJnlLines.FINDFIRST THEN
                    RecGenJnlLines.DELETEALL(TRUE);
                //ALLEDK 140213
            END;
        END;

        //BBG2.0 250714
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("External Document No.");
        GLEntry.SETRANGE("External Document No.", VoucherHeader."Document No.");
        IF GLEntry.FINDFIRST THEN;
        //BBG2.0 250714


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := VoucherHeader."Document No.";
        PHeader.INSERT;
        PHeader.VALIDATE("Posting Date", VoucherHeader."Posting Date");
        PHeader.VALIDATE("Buy-from Vendor No.", VoucherHeader."Paid To");

        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);

        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Vendor Invoice No." := VoucherHeader."Document No.";
        PHeader."Vendor Invoice Date" := VoucherHeader."Posting Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::"Travel Allowance";
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission; //BBG2.0 250714
        PHeader."Applies-to Doc. Type" := PHeader."Applies-to Doc. Type"::Payment;   //BBG2.0 250714
        PHeader.Approved := TRUE;
        PHeader."From MS Company" := VoucherHeader."From MS Company";
        PHeader."Assigned User ID" := USERID;
        PHeader.MODIFY;
        //InsertDocumentDimension(PHeader); //BBG1.00 ALLEDK 070313

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Travel A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2);
        IF ABS(VoucherHeader."Advance Amount") < Amt2 THEN BEGIN
            PLine."Detect TDS Amount" := ABS(VoucherHeader."Advance Amount");
            PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
        END ELSE
            PLine."Detect TDS Amount" := 0;
        PLine.INSERT;

        IF Club9Post > 0 THEN BEGIN

            PLine.INIT;
            PLine."Document Type" := PLine."Document Type"::Invoice;
            PLine."Document No." := PHeader."No.";
            PLine."Line No." := 20000;
            PLine.Type := PLine.Type::"G/L Account";
            PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
            PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
            PLine.VALIDATE(Quantity, -1);
            PLine.VALIDATE(PLine."Direct Unit Cost", Club9Post);
            PLine.INSERT;
        END;

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PHeader);
    end;


    procedure PostCommission1(VoucherHeader: Record "Assoc Pmt Voucher Header")
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", VoucherHeader."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::Commission);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;





        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Commission A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");
        Unitsetup.TESTFIELD("Posting Voucher No. Series");

        Club9Post := 0;

        IF ABS(VoucherHeader."Advance Amount") < Amt2 THEN
            Club9Post := ((Amt2 - ABS(VoucherHeader."Advance Amount")) * Unitsetup."Corpus %" / 100)
        ELSE
            Club9Post := 0;


        //ALLEDK 060113
        CheckCostCode(Unitsetup."Commission A/C");
        CheckCostCode(Unitsetup."Corpus A/C");
        //ALLEDK 060113

        IF GLAccount.GET(Unitsetup."Commission A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");



        CalcTDSPercentage(VoucherHeader);
        TDSAmt2 := Amt2 * TDSPercentage / 100;



        DBAmt := 0;
        IF VoucherHeader."Advance Amount" > 0 THEN BEGIN
            IF VoucherHeader."Net Elig." < 0 THEN BEGIN

                DBAmt := ABS(VoucherHeader."Net Elig.");

                Unitsetup.GET;
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", Unitsetup."Bank Voucher Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", Unitsetup."Bank Voucher Batch Name");
                IF GenJnlLine.FINDLAST THEN
                    LineNo2 := GenJnlLine."Line No.";

                GenJnlLine.INIT;
                LineNo2 += 10000;

                GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";

                IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                    DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

                GenJnlLine."Document No." := DocNo;
                GenJnlLine."Line No." := LineNo2;
                GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Posting Date", VoucherHeader."Posting Date");
                GenJnlLine.VALIDATE("Document Date", VoucherHeader."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", VoucherHeader."Paid To");
                GenJnlLine.VALIDATE("Debit Amount", ROUND(DBAmt, 1));
                GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Commission);
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                CompanyWiseGL.RESET;
                CompanyWiseGL.SETRANGE(CompanyWiseGL."MSC Company", TRUE);
                IF CompanyWiseGL.FINDFIRST THEN
                    CompanyWiseGL.TESTFIELD(CompanyWiseGL."Payable Account");

                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", CompanyWiseGL."Payable Account");
                GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
                GenJnlLine."External Document No." := VoucherHeader."Document No.";
                GenJnlLine."Cheque No." := VoucherHeader."Cheque No.";
                GenJnlLine."Cheque Date" := VoucherHeader."Cheque Date";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Branch Code" := UserSetup."User Branch";  //180113
                GenJnlLine.VALIDATE("Bal. Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::Purchase);  //140213
                GenJnlLine.INSERT;
                CLEAR(GenJnlPostLine);
                InsertJnlDimension(GenJnlLine); //ALLEDK 010213
                GenJnlPostLine.RunWithCheck(GenJnlLine);  //ALLEDK 010213
                                                          //ALLEDK 140213
                RecGenJnlLines.RESET;
                RecGenJnlLines.SETRANGE("Document No.", DocNo);
                IF RecGenJnlLines.FINDFIRST THEN
                    RecGenJnlLines.DELETEALL(TRUE);
            END;
        END;

        //BBG2.0 250714
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("External Document No.");
        GLEntry.SETRANGE("External Document No.", VoucherHeader."Document No.");
        IF GLEntry.FINDFIRST THEN;
        //BBG2.0 250714

        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := VoucherHeader."Document No.";
        PHeader.INSERT;
        PHeader.VALIDATE("Posting Date", VoucherHeader."Posting Date");
        PHeader.VALIDATE("Buy-from Vendor No.", VoucherHeader."Paid To");

        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);

        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Vendor Invoice No." := VoucherHeader."Document No.";
        PHeader."Vendor Invoice Date" := VoucherHeader."Posting Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission; //BBG2.0 250714
        PHeader."Applies-to Doc. Type" := PHeader."Applies-to Doc. Type"::Payment;   //BBG2.0 250714
        PHeader."Applies-to Doc. No." := GLEntry."Document No.";
        PHeader.Approved := TRUE;
        PHeader."From MS Company" := VoucherHeader."From MS Company";
        PHeader."Assigned User ID" := USERID;
        PHeader.MODIFY;

        //InsertDocumentDimension(PHeader); //BBG1.00 ALLEDK 070313

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Commission A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2);
        IF ABS(VoucherHeader."Advance Amount") < Amt2 THEN BEGIN
            PLine."Detect TDS Amount" := ABS(VoucherHeader."Advance Amount");
            PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction");
        END ELSE
            PLine."Detect TDS Amount" := 0;

        PLine.INSERT;

        IF Club9Post > 0 THEN BEGIN

            PLine.INIT;
            PLine."Document Type" := PLine."Document Type"::Invoice;
            PLine."Document No." := PHeader."No.";
            PLine."Line No." := 20000;
            PLine.Type := PLine.Type::"G/L Account";
            PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
            PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
            PLine.VALIDATE(Quantity, -1);
            PLine.VALIDATE(PLine."Direct Unit Cost", Club9Post);
            PLine.INSERT;
        END;
        CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PHeader);
    end;


    procedure PostComAndTA1(VoucherHeader: Record "Assoc Pmt Voucher Header")
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
        VoucherLine.SETRANGE("Voucher No.", VoucherHeader."Document No.");
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt1 += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;

        ClubAmt1 := Club9ChargesAmt2;

        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Travel A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");
        Unitsetup.TESTFIELD(Unitsetup."Commission A/C");
        Unitsetup.TESTFIELD("Posting Voucher No. Series");

        //ALLEDK 060113
        CheckCostCode(Unitsetup."Commission A/C");
        CheckCostCode(Unitsetup."Corpus A/C");
        CheckCostCode(Unitsetup."Travel A/C");
        //ALLEDK 060113

        Club9Post := 0;
        Club9Post := ((Amt2 - ABS(VoucherHeader."Advance Amount")) * Unitsetup."Corpus %" / 100);

        IF GLAccount.GET(Unitsetup."Commission A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Travel A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");

        Amt3 := Amt2;

        CalcTDSPercentage(VoucherHeader);

        TDSAmt2 := Amt3 * TDSPercentage / 100;


        DBAmt := 0;
        IF Amt3 > ABS(VoucherHeader."Advance Amount") THEN BEGIN

            IF VoucherHeader."Net Elig." < 0 THEN BEGIN

                DBAmt := ABS(VoucherHeader."Net Elig.");

                Unitsetup.GET;
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", Unitsetup."Bank Voucher Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", Unitsetup."Bank Voucher Batch Name");
                IF GenJnlLine.FINDLAST THEN
                    LineNo2 := GenJnlLine."Line No.";

                GenJnlLine.INIT;
                LineNo2 += 10000;

                CompanyWiseGL.RESET;
                CompanyWiseGL.SETRANGE(CompanyWiseGL."MSC Company", TRUE);
                IF CompanyWiseGL.FINDFIRST THEN
                    CompanyWiseGL.TESTFIELD(CompanyWiseGL."Payable Account");

                GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";
                GenJnlLine.VALIDATE("Bal. Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::Purchase);  //140213

                IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                    DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

                GenJnlLine."Document No." := DocNo;
                GenJnlLine."Line No." := LineNo2;
                GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Posting Date", VoucherHeader."Posting Date");
                GenJnlLine.VALIDATE("Document Date", VoucherHeader."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", VoucherHeader."Paid To");
                GenJnlLine.VALIDATE("Debit Amount", DBAmt);
                GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::CommAndTA);
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", CompanyWiseGL."Payable Account");
                GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
                GenJnlLine."External Document No." := VoucherHeader."Document No.";
                GenJnlLine."Cheque No." := VoucherHeader."Cheque No.";
                GenJnlLine."Cheque Date" := VoucherHeader."Cheque Date";
                GenJnlLine."Branch Code" := UserSetup."User Branch";  //180113
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine.INSERT;
                InsertJnlDimension(GenJnlLine); //ALLEDK 010213
                CLEAR(GenJnlPostLine);
                GenJnlPostLine.RunWithCheck(GenJnlLine);  //ALLEDK 010213
                RecGenJnlLines.RESET;
                RecGenJnlLines.SETRANGE("Document No.", DocNo);
                IF RecGenJnlLines.FINDFIRST THEN
                    RecGenJnlLines.DELETEALL(TRUE);

            END;
        END;


        //BBG2.0 250714
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("External Document No.");
        GLEntry.SETRANGE("External Document No.", VoucherHeader."Document No.");
        IF GLEntry.FINDFIRST THEN;
        //BBG2.0 250714



        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := VoucherHeader."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Posting Date", VoucherHeader."Posting Date");
        PHeader.VALIDATE("Buy-from Vendor No.", VoucherHeader."Paid To");

        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);

        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Vendor Invoice No." := VoucherHeader."Document No.";
        PHeader."Vendor Invoice Date" := VoucherHeader."Posting Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission; //BBG2.0 250714
        PHeader."Applies-to Doc. Type" := PHeader."Applies-to Doc. Type"::Payment;   //BBG2.0 250714
        PHeader.Approved := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::CommAndTA;
        PHeader."From MS Company" := VoucherHeader."From MS Company";
        PHeader."Assigned User ID" := USERID;
        PHeader.MODIFY;

        //InsertDocumentDimension(PHeader); //BBG1.00 ALLEDK 070313

        IF Amt3 <> 0 THEN BEGIN
            PLine.INIT;
            PLine."Document Type" := PLine."Document Type"::Invoice;
            PLine."Document No." := PHeader."No.";
            PLine."Line No." := 10000;
            PLine.Type := PLine.Type::"G/L Account";
            PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
            PLine.VALIDATE("No.", Unitsetup."Travel A/C");
            PLine.VALIDATE(Quantity, 1);
            PLine.VALIDATE(PLine."Direct Unit Cost", Amt3);
            IF ABS(VoucherHeader."Advance Amount") < Amt3 THEN BEGIN
                PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
                PLine."Detect TDS Amount" := ABS(VoucherHeader."Advance Amount");
            END;
            PLine.INSERT;

            PLine.INIT;
            PLine."Document Type" := PLine."Document Type"::Invoice;
            PLine."Document No." := PHeader."No.";
            PLine."Line No." := 20000;
            PLine.Type := PLine.Type::"G/L Account";
            PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
            PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
            PLine.VALIDATE(Quantity, -1);
            PLine.VALIDATE(PLine."Direct Unit Cost", Club9Post);
            PLine.INSERT;
            CreatTA := TRUE;
        END;

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PHeader);
    end;


    procedure PostIncentive1(VoucherHeader: Record "Assoc Pmt Voucher Header")
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        EligibleAmt := 0;
        Club9Post := 0;
        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", VoucherHeader."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::Incentive);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                EligibleAmt += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;


        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Incentive A/C");
        Unitsetup.TESTFIELD("Posting Voucher No. Series");


        IF ABS(VoucherHeader."Advance Amount") < Amt2 THEN
            Club9Post := ((Amt2 - ABS(VoucherHeader."Advance Amount")) * Unitsetup."Incentive Club 9%" / 100)
        ELSE
            Club9Post := 0;




        //ALLEDK 060113
        CheckCostCode(Unitsetup."Incentive A/C");
        //ALLEDK 060113

        //IF PaymentMethod.GET("Bank/G L Code") THEN;

        IF GLAccount.GET(Unitsetup."Incentive A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");



        CalcTDSPercentage(VoucherHeader);

        TDSAmt2 := Amt2 * TDSPercentage / 100;


        DBAmt := 0;
        //IF Amt2 > ABS("Advance Amount") THEN BEGIN
        IF VoucherHeader."Advance Amount" > 0 THEN BEGIN

            IF VoucherHeader."Net Elig." < 0 THEN BEGIN

                DBAmt := ABS(VoucherHeader."Net Elig.");

                Unitsetup.GET;
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", Unitsetup."Bank Voucher Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", Unitsetup."Bank Voucher Batch Name");
                IF GenJnlLine.FINDLAST THEN
                    LineNo2 := GenJnlLine."Line No.";

                GenJnlLine.INIT;
                LineNo2 += 10000;

                IF VoucherHeader."Payment Mode" = VoucherHeader."Payment Mode"::Bank THEN BEGIN
                    GenJnlLine."Journal Template Name" := Unitsetup."Bank Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := Unitsetup."Bank Voucher Batch Name";
                END ELSE BEGIN
                    GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";
                END;

                IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                    DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

                GenJnlLine."Document No." := DocNo;
                GenJnlLine."Line No." := LineNo2;
                GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Posting Date", VoucherHeader."Posting Date");
                GenJnlLine.VALIDATE("Document Date", VoucherHeader."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", VoucherHeader."Paid To");
                GenJnlLine.VALIDATE("Debit Amount", DBAmt);
                GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Incentive);
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                CompanyWiseGL.RESET;
                CompanyWiseGL.SETRANGE(CompanyWiseGL."MSC Company", TRUE);
                IF CompanyWiseGL.FINDFIRST THEN
                    CompanyWiseGL.TESTFIELD(CompanyWiseGL."Payable Account");
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", CompanyWiseGL."Payable Account");

                GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
                GenJnlLine."External Document No." := VoucherHeader."Document No.";
                GenJnlLine."Cheque No." := VoucherHeader."Cheque No.";
                GenJnlLine."Cheque Date" := VoucherHeader."Cheque Date";
                GenJnlLine."Branch Code" := UserSetup."User Branch";  //180113
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine.VALIDATE("Bal. Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::Purchase);  //140213
                GenJnlLine.INSERT;
                CLEAR(GenJnlPostLine);
                InsertJnlDimension(GenJnlLine); //ALLEDK 010213
                GenJnlPostLine.RunWithCheck(GenJnlLine);  //ALLEDK 010213
                                                          //ALLEDK 140213
                RecGenJnlLines.RESET;
                RecGenJnlLines.SETRANGE("Document No.", DocNo);
                IF RecGenJnlLines.FINDFIRST THEN
                    RecGenJnlLines.DELETEALL(TRUE);
                //ALLEDK 140213
            END;
        END;


        //BBG2.0 250714
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("External Document No.");
        GLEntry.SETRANGE("External Document No.", VoucherHeader."Document No.");
        IF GLEntry.FINDFIRST THEN;
        //BBG2.0 250714


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := VoucherHeader."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Posting Date", VoucherHeader."Posting Date");
        PHeader.VALIDATE("Buy-from Vendor No.", VoucherHeader."Paid To");

        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);

        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Vendor Invoice No." := VoucherHeader."Document No.";
        PHeader."Vendor Invoice Date" := VoucherHeader."Posting Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Incentive;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission; //BBG2.0 250714
        PHeader."Applies-to Doc. Type" := PHeader."Applies-to Doc. Type"::Payment;   //BBG2.0 250714
        PHeader.Approved := TRUE;
        PHeader."Assigned User ID" := USERID;
        PHeader.MODIFY;

        //InsertDocumentDimension(PHeader); //BBG1.00 ALLEDK 070313

        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Incentive A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2);
        IF ABS(VoucherHeader."Advance Amount") < Amt2 THEN BEGIN
            PLine."Detect TDS Amount" := ABS(VoucherHeader."Advance Amount");
            PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction");
        END ELSE
            PLine."Detect TDS Amount" := 0;
        PLine.INSERT;

        IF Club9Post > 0 THEN BEGIN

            PLine.INIT;
            PLine."Document Type" := PLine."Document Type"::Invoice;
            PLine."Document No." := PHeader."No.";
            PLine."Line No." := 20000;
            PLine.Type := PLine.Type::"G/L Account";
            PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
            PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
            PLine.VALIDATE(Quantity, -1);
            PLine.VALIDATE(PLine."Direct Unit Cost", Club9Post);
            PLine.INSERT;
        END;

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PHeader);
    end;


    procedure CalcTDSPercentage(VoucherHeader: Record "Assoc Pmt Voucher Header")
    var
        TDSSetup: Record "TDS Setup";// "TDS Setup";
        //NODLines: Record 13785;
        Vendor: Record Vendor;
        AllowedSection: Record "Allowed Sections";
        CodeunitEventMgt: Codeunit "BBG Codeunit Event Mgnt.";
    begin
        TDSPercentage := 0;
        IF Vendor.Get(VoucherHeader."Paid To") Then begin
            AllowedSection.Reset();
            AllowedSection.SetRange("Vendor No", Vendor."No.");
            AllowedSection.SetRange("TDS Section", Unitsetup."TDS Nature of Deduction");
            IF AllowedSection.FindFirst() then begin
                TDSPercentage := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
            end;
        end;
        /*
        IF RecNODHeader.GET(RecNODHeader.Type::Vendor, VoucherHeader."Paid To") THEN;
        
        IF Vendor.GET(VoucherHeader."Paid To") THEN;
        Unitsetup.GET;
        TDSSetup.RESET;
        TDSSetup.SETRANGE("TDS Nature of Deduction", Unitsetup."TDS Nature of Deduction");
        IF PHeader."Assessee Code" = '' THEN
            TDSSetup.SETRANGE("Assessee Code", RecNODHeader."Assesse Code") //24
        ELSE
            TDSSetup.SETRANGE("Assessee Code", PHeader."Assessee Code");
        TDSSetup.SETRANGE("Effective Date", 0D, VoucherHeader."Posting Date");
        NODLines.RESET;
        NODLines.SETRANGE(Type, NODLines.Type::Vendor);
        NODLines.SETRANGE("No.", VoucherHeader."Paid To");
        NODLines.SETRANGE("NOD/NOC", Unitsetup."TDS Nature of Deduction");
        IF NODLines.FIND('-') THEN BEGIN
            IF NODLines."Concessional Code" <> '' THEN
                TDSSetup.SETRANGE("Concessional Code", NODLines."Concessional Code")
            ELSE
                TDSSetup.SETRANGE("Concessional Code", '');
            IF NOT TDSSetup.FIND('+') THEN BEGIN
                TDSPercentage := 0;
            END ELSE BEGIN
                IF (Vendor."P.A.N. Status" = Vendor."P.A.N. Status"::" ") AND (Vendor."P.A.N. No." <> '') THEN BEGIN
                    IF Vendor."206AB" THEN   //ALLEDK 020721
                        TDSPercentage := TDSSetup."206AB %"    //ALLEDK 020721
                    ELSE
                        TDSPercentage := TDSSetup."TDS %"
                END ELSE
                    TDSPercentage := TDSSetup."Non PAN TDS %";
            END;
        END;
        *///Need to check the code in UAT

    end;


    procedure CheckCostCode(GLAccount: Code[20])
    var
        DefaultDimension: Record "Default Dimension";
    begin
        GenLedSetup.GET;
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", 15);
        DefaultDimension.SETRANGE("No.", GLAccount);
        DefaultDimension.SETFILTER("Value Posting", 'Code Mandatory');
        DefaultDimension.SETFILTER(DefaultDimension."Dimension Code", '<>%1', GenLedSetup."Global Dimension 1 Code");
        DefaultDimension.SETFILTER(DefaultDimension."Dimension Value Code", '%1', '');
        IF DefaultDimension.FINDFIRST THEN
            DefaultDimension.TESTFIELD(DefaultDimension."Dimension Value Code");

        Dim2Code := '';
        //ALLEDK 170213
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", 15);
        DefaultDimension.SETRANGE("No.", GLAccount);
        DefaultDimension.SETFILTER("Value Posting", 'Same Code');
        DefaultDimension.SETFILTER(DefaultDimension."Dimension Code", '%1', GenLedSetup."Global Dimension 2 Code");
        DefaultDimension.SETFILTER(DefaultDimension."Dimension Value Code", '%1', '');
        IF DefaultDimension.FINDFIRST THEN BEGIN
            DefaultDimension.TESTFIELD(DefaultDimension."Dimension Value Code");
        END;

        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", 15);
        DefaultDimension.SETRANGE("No.", GLAccount);
        DefaultDimension.SETFILTER("Value Posting", 'Same Code');
        DefaultDimension.SETFILTER(DefaultDimension."Dimension Code", '%1', GenLedSetup."Global Dimension 2 Code");
        IF DefaultDimension.FINDFIRST THEN BEGIN
            Dim2Code := DefaultDimension."Dimension Value Code";
        END;

        //ALLEDK 170213
    end;


    procedure InsertJnlDimension(RecGenLine: Record "Gen. Journal Line")
    begin
        GLSetup.GET;
        UserSetup.GET(USERID);
        // ALLE MM Code Commented
        /*
        JournalLineDimension.DELETEALL;
        
        
        GLSetup.GET;
        UserSetup.GET(USERID);
        JournalLineDimension.INIT;
        JournalLineDimension."Table ID" := 81;
        JournalLineDimension."Journal Template Name" := RecGenLine."Journal Template Name";
        JournalLineDimension."Journal Batch Name" := RecGenLine."Journal Batch Name";
        JournalLineDimension."Journal Line No." := RecGenLine."Line No.";
        JournalLineDimension."Dimension Code" := GLSetup."Shortcut Dimension 1 Code";
        JournalLineDimension."Dimension Value Code" := RecGenLine."Shortcut Dimension 1 Code";
        JournalLineDimension.INSERT;
        */
        // ALLE MM Code Commented

    end;


    procedure ReversalInvoiceCommORTA(AssPmtVoucherHeader: Record "Assoc Pmt Voucher Header")
    var
        VLE: Record "Vendor Ledger Entry";
        ReversalEntry: Record "Reversal Entry";
        RevEntry: Record "Reversal Entry";
        FormRevEntries: Page "Auto Reverse Entries";
    begin
        VLE.RESET;
        VLE.SETRANGE("Vendor No.", AssPmtVoucherHeader."Paid To");
        VLE.SETRANGE("External Document No.", AssPmtVoucherHeader."Document No.");
        VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
        IF VLE.FINDFIRST THEN BEGIN
            CLEAR(ReversalEntry);
            IF VLE.Reversed THEN
                ReversalEntry.AlreadyReversedEntry(AssPmtVoucherHeader.TABLECAPTION, VLE."Entry No.");
            VLE.TESTFIELD("Transaction No.");
            RevEntry.DELETEALL;
            ReversalEntry.AutoReverseTransaction(VLE."Transaction No.", AssPmtVoucherHeader."Posting Date");
            IF RecReverseEntry.FIND('-') THEN
                AutoReversalPost(RecReverseEntry);
        END;
    end;


    procedure ReversalPaymentCommORTA(AssPmtVoucherHeader: Record "Assoc Pmt Voucher Header")
    var
        VLE: Record "Vendor Ledger Entry";
        ReversalEntry: Record "Reversal Entry";
        RevEntry: Record "Reversal Entry";
        FormRevEntries: Page "Auto Reverse Entries";
    begin
        VLE.RESET;
        VLE.SETRANGE("Vendor No.", AssPmtVoucherHeader."Paid To");
        VLE.SETRANGE("External Document No.", AssPmtVoucherHeader."Document No.");
        VLE.SETRANGE("Document Type", VLE."Document Type"::Payment);
        IF VLE.FINDFIRST THEN BEGIN
            CLEAR(ReversalEntry);
            IF VLE.Reversed THEN
                ReversalEntry.AlreadyReversedEntry(AssPmtVoucherHeader.TABLECAPTION, VLE."Entry No.");
            VLE.TESTFIELD("Transaction No.");
            RevEntry.DELETEALL;
            ReversalEntry.AutoReverseTransaction(VLE."Transaction No.", AssPmtVoucherHeader."Posting Date");
            AutoReversalPost(RecReverseEntry);
        END;
    end;


    procedure ReversalAssPmtVoucher(AssociatePaymentHdr: Record "Associate Payment Hdr")
    var
        "G/LEntry": Record "G/L Entry";
        ReversalEntry: Record "Reversal Entry";
        RevEntry: Record "Reversal Entry";
        FormRevEntries: Page "Auto Reverse Entries";
    begin
        "G/LEntry".RESET;
        "G/LEntry".SETRANGE("Document No.", AssociatePaymentHdr."Posted Document No.");
        "G/LEntry".SETRANGE("Document Type", "G/LEntry"."Document Type"::Payment);
        IF "G/LEntry".FINDFIRST THEN BEGIN
            CLEAR(ReversalEntry);
            IF "G/LEntry".Reversed THEN
                ReversalEntry.AlreadyReversedEntry(AssociatePaymentHdr.TABLECAPTION, "G/LEntry"."Entry No.");
            "G/LEntry".TESTFIELD("Transaction No.");

            RevEntry.DELETEALL;
            ReversalEntry.AutoReverseTransaction("G/LEntry"."Transaction No.", AssociatePaymentHdr."Posting Date");
            FormRevEntries.RUN;
        END;
    end;


    procedure AutoReversalPost(ReversalEntries: Record "Reversal Entry")
    var
        GLReg: Record "G/L Register";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Txt: Text[250];
        WarningText: Text[250];
        Number: Integer;
        NewAppPayEntry: Record "NewApplication Payment Entry";
        RecCommEntry: Record "Commission Entry";
        RecTravelPmtEntry: Record "Travel Payment Entry";
    begin
        ReversalEntries.FIND('-');
        ReversalEntry := ReversalEntries;
        IF ReversalEntries."Reversal Type" = ReversalEntries."Reversal Type"::Transaction THEN BEGIN
            ReversalEntry.SetReverseFilter(ReversalEntries."Transaction No.", ReversalEntries."Reversal Type");
        END ELSE BEGIN
            ReversalEntry.SetReverseFilter(ReversalEntries."G/L Register No.", ReversalEntries."Reversal Type");
        END;

        ReversalEntries.RESET;
        ReversalEntries.SETRANGE("Entry Type");
        ReversalEntry.CheckEntries;
        ReversalEntries.GET(1);
        IF ReversalEntries."Reversal Type" = ReversalEntries."Reversal Type"::Register THEN
            Number := ReversalEntries."G/L Register No."
        ELSE
            Number := ReversalEntries."Transaction No.";
        IF NOT ReversalEntry.VerifyReversalEntries(ReversalEntries, Number, ReversalEntries."Reversal Type") THEN
            ERROR(Text008);
        //GenJnlPostLine.Reverse(ReversalEntry,ReversalEntries);

        CLEAR(ExtDocNo);
        CLEAR(VendNo);
        VendLE.RESET;
        VendLE.SETRANGE("Document No.", ReversalEntries."Document No.");
        VendLE.SETRANGE("Document Type", VendLE."Document Type"::Invoice);
        VendLE.SETRANGE(Reversed, TRUE);
        IF VendLE.FINDFIRST THEN BEGIN
            CommPayVoucher.SETRANGE("Document No.", VendLE."External Document No."); //BBG2.00 050814
            IF CommPayVoucher.FINDFIRST THEN BEGIN
                IF NOT CommPayVoucher."Invoice Reversed" THEN BEGIN
                    ExtDocNo := VendLE."External Document No.";
                    VendNo := VendLE."Vendor No.";
                    Unitsetup.GET;
                    IF (CommPayVoucher.Type IN [CommPayVoucher.Type::Commission, CommPayVoucher.Type::ComAndTA]) THEN BEGIN
                        IF CommPayVoucher."Sub Type" = CommPayVoucher."Sub Type"::Regular THEN BEGIN  //BBG 2.01 140814
                            CLEAR(VoucherLine);
                            VoucherLine.RESET;
                            VoucherLine.SETRANGE("Voucher No.", VendLE."External Document No.");
                            VoucherLine.SETRANGE(Type, VoucherLine.Type::Commission);
                            IF VoucherLine.FINDFIRST THEN BEGIN
                                RemAmount := 0;
                                RemAmount := VoucherLine.Amount;

                                RecCommEntry.RESET;
                                RecCommEntry.SETCURRENTKEY("Associate Code");
                                RecCommEntry.SETRANGE("Associate Code", VoucherLine."Associate Code");
                                RecCommEntry.SETRANGE(Posted, TRUE);
                                RecCommEntry.SETFILTER("Remaining Amount", '<>%1', 0);
                                IF RecCommEntry.FINDSET THEN
                                    REPEAT
                                        RemAmount += RecCommEntry."Remaining Amount";
                                    UNTIL RecCommEntry.NEXT = 0;


                                CommissionEntry.RESET;
                                CommissionEntry.SETCURRENTKEY("Associate Code");
                                CommissionEntry.SETRANGE("Associate Code", VoucherLine."Associate Code");
                                CommissionEntry.SETRANGE(Posted, TRUE);
                                CommissionEntry.SETFILTER("Commission Amount", '>%1', 0);
                                IF CommissionEntry.FIND('+') THEN
                                    REPEAT
                                        IF RemAmount > CommissionEntry."Commission Amount" THEN BEGIN
                                            CommissionEntry."Remaining Amount" := CommissionEntry."Commission Amount";
                                            RemAmount := RemAmount - CommissionEntry."Commission Amount";
                                        END ELSE BEGIN
                                            CommissionEntry."Remaining Amount" := RemAmount;
                                            RemAmount := 0;
                                        END;
                                        CommissionEntry.MODIFY;
                                    UNTIL (CommissionEntry.NEXT(-1) = 0) OR (RemAmount = 0);
                            END;
                        END;
                    END; //BBG 2.01 140814
                    IF (CommPayVoucher.Type IN [CommPayVoucher.Type::TA, CommPayVoucher.Type::ComAndTA]) THEN BEGIN
                        IF CommPayVoucher."Sub Type" = CommPayVoucher."Sub Type"::Regular THEN BEGIN  //BBG 2.01 140814
                            CLEAR(VoucherLine);
                            VoucherLine.RESET;
                            VoucherLine.SETRANGE("Voucher No.", VendLE."External Document No.");
                            VoucherLine.SETRANGE(Type, VoucherLine.Type::TA);
                            IF VoucherLine.FINDFIRST THEN BEGIN
                                RemAmount := 0;
                                RemAmount := VoucherLine.Amount;

                                RecTravelPmtEntry.RESET;
                                RecTravelPmtEntry.SETCURRENTKEY("Sub Associate Code");
                                RecTravelPmtEntry.SETRANGE("Sub Associate Code", VoucherLine."Associate Code");
                                RecTravelPmtEntry.SETFILTER("Remaining Amount", '<>%1', 0);
                                IF RecTravelPmtEntry.FINDSET THEN
                                    REPEAT
                                        RemAmount += TravelPmtEntry."Remaining Amount";
                                    UNTIL RecTravelPmtEntry.NEXT = 0;

                                TravelPmtEntry.RESET;
                                TravelPmtEntry.SETCURRENTKEY("Sub Associate Code", "Post Payment");
                                TravelPmtEntry.SETRANGE("Sub Associate Code", VoucherLine."Associate Code");
                                TravelPmtEntry.SETRANGE("Post Payment", TRUE);
                                TravelPmtEntry.SETFILTER("Amount to Pay", '>%1', 0);
                                IF TravelPmtEntry.FIND('+') THEN
                                    REPEAT
                                        IF RemAmount > TravelPmtEntry."Amount to Pay" THEN BEGIN
                                            TravelPmtEntry."Remaining Amount" := TravelPmtEntry."Amount to Pay";
                                            RemAmount := RemAmount - TravelPmtEntry."Amount to Pay";
                                        END ELSE BEGIN
                                            TravelPmtEntry."Remaining Amount" := RemAmount;
                                            RemAmount := 0;
                                        END;
                                        TravelPmtEntry.MODIFY;
                                    UNTIL (TravelPmtEntry.NEXT(-1) = 0) OR (RemAmount = 0);
                            END;
                        END;//BBG2.01 140814
                    END;
                END;
                CommPayVoucher."Invoice Reversed" := TRUE;
                CommPayVoucher.MODIFY;
            END;//BBG2.00 050814
            APEntry.RESET;
            APEntry.SETCURRENTKEY("Posted Document No.");
            APEntry.SETRANGE("Posted Document No.", VendLE."External Document No.");
            APEntry.SETRANGE("Reverse AJVM Invoice", TRUE);
            IF APEntry.FINDFIRST THEN BEGIN
                IF APEntry."AJVM Transfer Type" = APEntry."AJVM Transfer Type"::Commission THEN BEGIN
                    CommEntry.RESET;
                    IF CommEntry.FINDLAST THEN
                        LastEntryNo := CommEntry."Entry No.";
                    CommEntry2.INIT;
                    CommEntry2."Entry No." := LastEntryNo + 1;
                    CommEntry2."Application No." := APEntry."Document No.";
                    CommEntry2."Associate Code" := VendLE."Vendor No.";
                    CommEntry2."Posting Date" := APEntry."Posting date";
                    CommEntry2."Base Amount" := APEntry."Associate Transfer Amount";
                    CommEntry2."Commission Amount" := APEntry."Associate Transfer Amount";
                    CommEntry2."Business Type" := CommEntry2."Business Type"::SELF;
                    CommEntry2."First Year" := TRUE;
                    CommEntry2."Introducer Code" := VendLE."Vendor No.";
                    CommEntry2.CreditMemo := TRUE;
                    CommEntry2.INSERT;
                END;
                Unitsetup.GET;
                IF Unitsetup."Incentive elegiblity App. AJVM" THEN BEGIN
                    IF APEntry."AJVM Transfer Type" = APEntry."AJVM Transfer Type"::Incentive THEN BEGIN
                        IncentiveSummary.RESET;
                        IF IncentiveSummary.FINDLAST THEN
                            LineNo2 := IncentiveSummary."Line No.";
                        IncentiveSummary.INIT;
                        LineNo2 += 10000;
                        IncentiveSummary."Incentive Application No." := '';
                        IncentiveSummary."Line No." := LineNo2;
                        IncentiveSummary.INSERT(TRUE);
                        IncentiveSummary.Year := DATE2DMY(ReversalEntries."Posting Date", 3);
                        IncentiveSummary.Month := DATE2DMY(ReversalEntries."Posting Date", 2);
                        IncentiveSummary."Associate Code" := VendLE."Vendor No.";
                        IncentiveSummary."Plot Incentive Amount" := ABS(VendLE.Amount);
                        IncentiveSummary."Payable Incentive Amount" := ABS(VendLE.Amount);
                        IncentiveSummary.Type := IncentiveSummary.Type::Direct;
                        IncentiveSummary."Incentive Scheme" := '';
                        IncentiveSummary."No. of plot" := 0;
                        IncentiveSummary."BSP1_BSP3 Amount" := 0;  //BBG1.00 280713
                        IncentiveSummary.MODIFY;
                    END;
                END;
                APEntry."Reverse AJVM Invoice" := FALSE;
                APEntry."Reversed AJVM Invoice" := TRUE;
                APEntry.MODIFY;
            END;
            //BBG2.00 050814
        END;
        CLEAR(VendLE);
        VendLE.RESET;
        VendLE.SETRANGE("Document No.", ReversalEntries."Document No.");
        VendLE.SETRANGE("Document Type", VendLE."Document Type"::Payment);
        VendLE.SETRANGE(Reversed, TRUE);
        IF VendLE.FINDFIRST THEN BEGIN
            CommPayVoucher.GET(VendLE."External Document No.");
            IF NOT CommPayVoucher."Payment Reversed" THEN BEGIN
                CommPayVoucher."Payment Reversed" := TRUE;
                CommPayVoucher.MODIFY;
            END;
        END;
        //END;
        ReversalEntries.DELETEALL;
    end;


    procedure PostAssAdvPmt(VoucherHeader: Record "Assoc Pmt Voucher Header")
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;
        BondSetup.GET;
        Club9Post := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", VoucherHeader."Document No.");
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount - VoucherLine."TDS Amount" - VoucherLine."Clube 9 Charge Amount";
                //  TDSAmt2 += VoucherLine."TDS Amount";
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
            UNTIL VoucherLine.NEXT = 0;


        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Travel A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");
        Unitsetup.TESTFIELD("Posting Voucher No. Series");



        //ALLEDK 060113
        CheckCostCode(Unitsetup."Corpus A/C");
        CheckCostCode(Unitsetup."Travel A/C");
        //ALLEDK 060113

        IF GLAccount.GET(Unitsetup."Travel A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");

        CalcTDSPercentage(VoucherHeader);
        TDSAmt2 := (Amt2) * TDSPercentage / 100;

        Unitsetup.GET;
        RecGenJnlLine.RESET;
        RecGenJnlLine.SETRANGE("Journal Template Name", Unitsetup."Bank Voucher Template Name");
        RecGenJnlLine.SETRANGE("Journal Batch Name", Unitsetup."Bank Voucher Batch Name");
        IF RecGenJnlLine.FINDLAST THEN
            LineNo2 := RecGenJnlLine."Line No.";

        RecGenJnlLine.INIT;
        LineNo2 += 10000;

        RecGenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
        RecGenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";

        IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
            DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

        RecGenJnlLine."Document No." := DocNo;
        RecGenJnlLine."Line No." := 10000;
        RecGenJnlLine.VALIDATE(RecGenJnlLine."Document Type", RecGenJnlLine."Document Type"::Payment);
        RecGenJnlLine.VALIDATE("Posting Date", VoucherHeader."Posting Date");
        RecGenJnlLine.VALIDATE("Document Date", VoucherHeader."Document Date");
        RecGenJnlLine.VALIDATE("Party Type", RecGenJnlLine."Party Type"::Vendor);
        RecGenJnlLine.VALIDATE("Party Code", VoucherHeader."Paid To");
        RecGenJnlLine.VALIDATE("Account Type", RecGenJnlLine."Account Type"::Vendor);
        RecGenJnlLine.VALIDATE("Account No.", VoucherHeader."Paid To");
        RecGenJnlLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction");
        IF VoucherHeader.Type = VoucherHeader.Type::Incentive THEN
            RecGenJnlLine.VALIDATE("Posting Type", RecGenJnlLine."Posting Type"::Incentive)
        ELSE
            RecGenJnlLine.VALIDATE("Posting Type", RecGenJnlLine."Posting Type"::Commission);
        RecGenJnlLine.VALIDATE("Bal. Account Type", RecGenJnlLine."Bal. Account Type"::"G/L Account");
        CompanyWiseGL.RESET;
        CompanyWiseGL.SETRANGE(CompanyWiseGL."MSC Company", TRUE);
        IF CompanyWiseGL.FINDFIRST THEN
            CompanyWiseGL.TESTFIELD(CompanyWiseGL."Payable Account");
        RecGenJnlLine.VALIDATE(RecGenJnlLine."Bal. Account No.", CompanyWiseGL."Payable Account");
        RecGenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        RecGenJnlLine."External Document No." := VoucherHeader."Document No.";
        RecGenJnlLine."Cheque No." := VoucherHeader."Cheque No.";

        RecGenJnlLine."Cheque Date" := VoucherHeader."Cheque Date";
        RecGenJnlLine."Branch Code" := UserSetup."User Branch";  //180113
        RecGenJnlLine."Payment Mode" := RecGenJnlLine."Payment Mode"::AJVM;
        RecGenJnlLine.INSERT;
        //  RecGenJnlLine.VALIDATE("Bal. Gen. Posting Type",RecGenJnlLine."Bal. Gen. Posting Type"::Purchase);  //140213
        RecGenJnlLine.VALIDATE("Vendor Cheque Amount", Amt2);
        UpdateDebitCreditAmount(RecGenJnlLine);
        CheckVendorChequeAmount(RecGenJnlLine);
        RecGenJnlLine.MODIFY;
        CLEAR(GenJnlPostLine);
        InsertJnlDimension(RecGenJnlLine); //ALLEDK 010213
                                           //GenJnlPostLine.RunWithCheck(RecGenJnlLine,JournalLineDimension);  //ALLEDK 010213 //Upgrade
                                           // CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",RecGenJnlLine); 2301
                                           //ALLEDK 140213
        RecGenJnlLines.RESET;
        RecGenJnlLines.SETRANGE("Document No.", DocNo);
        IF RecGenJnlLines.FINDFIRST THEN
            RecGenJnlLines.DELETEALL(TRUE);
        //ALLEDK 140213

        //BBG2.0 250714
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("External Document No.");
        GLEntry.SETRANGE("External Document No.", VoucherHeader."Document No.");
        IF GLEntry.FINDFIRST THEN;
        //BBG2.0 250714
        VoucherHeader.Post := TRUE;
        VoucherHeader.MODIFY;
    end;


    procedure "------for post assadvpmt"()
    begin
    end;

    local procedure UpdateDebitCreditAmount(GenJnlLine: Record "Gen. Journal Line")
    begin
        //GenJnlManagement.CalcTotDebitTotCreditAmount(GenJnlLine, TotalDebitAmount, TotalCreditAmount, FALSE);
    end;


    procedure CheckVendorChequeAmount(RecGnlJnlLine: Record "Gen. Journal Line")
    var
        JnlBankCharge: Record "Journal Bank Charges";// "Journal Bank Charges";
        BankCharge: Record "Bank Charge"; // "Bank Charge";
        TCSEntry: Record "TDS Entry";// "TDS Entry";
        TCSAmountApplied: Decimal;
        TDSAmount: Decimal;
        TCSAmount: Decimal;
        TotalAmount: Decimal;
        RoundAmt: Decimal;
        RecBankChrgAmt: Decimal;
        NewBankChrgAmt: Decimal;
    begin
        BankCharge.RESET;
        BankCharge.SETRANGE(Club9, TRUE);
        IF NOT BankCharge.FINDFIRST THEN
            ERROR('Create Bank Charge Code for Club9 Charges');
        NewBankChrgAmt := 0;
        RecBankChrgAmt := 0;
        Unitsetup.GET;
        //RecBankChrgAmt:=-ROUND((RecGnlJnlLine.Amount*UnitSetup."Corpus %"/100),1);
        RecBankChrgAmt := -(RecGnlJnlLine.Amount * Unitsetup."Corpus %" / 100);
        JnlBankCharge.RESET;
        JnlBankCharge.SETRANGE("Journal Template Name", RecGnlJnlLine."Journal Template Name");
        JnlBankCharge.SETRANGE("Journal Batch Name", RecGnlJnlLine."Journal Batch Name");
        JnlBankCharge.SETRANGE("Line No.", RecGnlJnlLine."Line No.");
        JnlBankCharge.SETRANGE("Bank Charge", BankCharge.Code);
        IF NOT JnlBankCharge.FINDFIRST THEN BEGIN
            JnlBankCharge.INIT;
            JnlBankCharge."Journal Template Name" := RecGnlJnlLine."Journal Template Name";
            JnlBankCharge."Journal Batch Name" := RecGnlJnlLine."Journal Batch Name";
            JnlBankCharge."Line No." := RecGnlJnlLine."Line No.";
            JnlBankCharge.VALIDATE("Bank Charge", BankCharge.Code);
            JnlBankCharge.VALIDATE(Amount, RecBankChrgAmt);
            JnlBankCharge.INSERT;
            CheckRoundAmount(RecGnlJnlLine, RecBankChrgAmt);
            NewBankChrgAmt := JnlBankCharge.Amount + RoundOff;
            JnlBankCharge.VALIDATE(Amount, NewBankChrgAmt);
            JnlBankCharge.MODIFY;
        END ELSE BEGIN
            CheckRoundAmount(RecGnlJnlLine, RecBankChrgAmt);
            NewBankChrgAmt := RecBankChrgAmt + RoundOff;
            JnlBankCharge.VALIDATE(Amount, NewBankChrgAmt);
            JnlBankCharge.MODIFY;
        END;
    end;


    procedure CheckRoundAmount(JnlLine: Record "Gen. Journal Line"; BankChargeAmt: Decimal)
    var
        JnlBankCharge: Record "Journal Bank Charges";
        BankCharge: Record "Bank Charge";
        UnitSetup: Record "Unit Setup";
        TCSEntry: Record "TDS Entry";
        TCSAmountApplied: Decimal;
        TDSAmount: Decimal;
        TCSAmount: Decimal;
        TotalAmount: Decimal;
        RoundAmt: Decimal;
    begin
        CLEAR(TDSAmount);
        CLEAR(TCSAmount);
        CLEAR(TotalAmount);
        CLEAR(TCSAmountApplied);
        CLEAR(RoundOff);
        TCSEntry.RESET;
        TCSEntry.SETRANGE("Document Type", JnlLine."Applies-to Doc. Type");
        TCSEntry.SETRANGE("Document No.", JnlLine."Applies-to Doc. No.");
        IF TCSEntry.FINDFIRST THEN
            REPEAT
                TCSAmountApplied += TCSEntry."TDS Amount" + TCSEntry."Surcharge Amount" + TCSEntry."eCESS Amount"
                 + TCSEntry."SHE Cess Amount";//Need to check the code in UAT //"TCS Amount"

            UNTIL (TCSEntry.NEXT = 0);
        /*
        IF JnlLine."TDS Section Code" <> '' THEN
            TDSAmount := JnlLine."Total TDS/TCS Incl. SHE CESS";
        IF JnlLine."TCS Nature of Collection" <> '' THEN
            TCSAmount := JnlLine."Total TDS/TCS Incl. SHE CESS";

        TotalAmount := JnlLine."Amount (LCY)" - TDSAmount - JnlLine."Work Tax Amount" + TCSAmount + TCSAmountApplied + BankChargeAmt;
        //ALLETDK100213>>
        IF TotalAmount <> JnlLine."Vendor Cheque Amount" THEN
            RoundOff := JnlLine."Vendor Cheque Amount" - TotalAmount
            *///Need to check the code in UAT

    end;


    procedure CreateCommissionInvoice(VoucherHeader_1: Record "Assoc Pmt Voucher Header"; OrderRefNo_1: Code[20]; ProjectCode_1: Code[20])
    var
        PIHeader: Record "Purch. Inv. Header";
        AdjustAmt: Decimal;
        CalculateTax: Codeunit "Calculate Tax";
    begin

        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;
        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", VoucherHeader_1."Document No.");
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;



        IF UserSetup.GET(USERID) THEN;

        Unitsetup.GET;
        Unitsetup.TESTFIELD(Unitsetup."Commission A/C");
        Unitsetup.TESTFIELD(Unitsetup."Corpus A/C");
        Unitsetup.TESTFIELD("Posting Voucher No. Series");
        //ALLEDK 060113
        CheckCostCode(Unitsetup."Commission A/C");
        CheckCostCode(Unitsetup."Corpus A/C");
        //ALLEDK 060113


        IF GLAccount.GET(Unitsetup."Commission A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := VoucherHeader_1."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Posting Date", VoucherHeader_1."Posting Date");
        PHeader.VALIDATE("Buy-from Vendor No.", VoucherHeader_1."Paid To");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", ProjectCode_1);  //INS1.0
        //PHeader.VALIDATE("Shortcut Dimension 1 Code",UserSetup."Responsibility Center");  //INS1.0
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := VoucherHeader_1."Document No.";
        PHeader."Vendor Invoice Date" := VoucherHeader_1."Posting Date";
        PHeader."User Branch" := UserSetup."User Branch";  //180113
        AdjustAmt := 0;
        AdjustAmt := AppliesPayment(PHeader."No.", PHeader."Buy-from Vendor No.");
        if AdjustAmt > 0 Then Begin
            PHeader.VALIDATE("Applies-to Doc. Type", PHeader."Applies-to Doc. Type"::Payment);
            PHeader."Applies-to ID" := USERID;
        End;
        PHeader.CommissionVoucher := TRUE; //180113
        //PHeader.Structure := 'EXEMPT';
        PHeader."Application No." := OrderRefNo_1;
        PHeader."Sent for Approval" := TRUE;
        IF VoucherHeader_1.Type = VoucherHeader_1.Type::Commission THEN
            PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission;
        IF VoucherHeader_1.Type = VoucherHeader_1.Type::TA THEN
            PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::"Travel Allowance";

        PHeader.Approved := TRUE;
        PHeader."From MS Company" := VoucherHeader_1."From MS Company";
        PHeader."Assigned User ID" := USERID;

        PHeader.MODIFY;


        PLine.INIT;
        PLine."Document Type" := PLine."Document Type"::Invoice;
        PLine."Document No." := PHeader."No.";
        PLine."Line No." := 10000;
        PLine.Type := PLine.Type::"G/L Account";
        PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
        PLine.VALIDATE("No.", Unitsetup."Commission A/C");
        PLine.VALIDATE(Quantity, 1);
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2);
        PLine.INSERT;
        PLine.Validate("TDS Section Code", Unitsetup."TDS Nature of Deduction");
        //PLine.VALIDATE("TDS Section Code"); //,Unitsetup."TDS Nature of Deduction");
        PLine.Modify();
        CalculateTax.CallTaxEngineOnPurchaseLine(PLine, PLine);//Added Code for BC


        IF AdjustAmt > 0 THEN BEGIN
            IF (Club9ChargesAmt2 - (AdjustAmt * Unitsetup."Corpus %" / 100)) > 0 THEN
                Club9ChargesAmt2 := (Club9ChargesAmt2 - (AdjustAmt * Unitsetup."Corpus %" / 100))
            ELSE
                Club9ChargesAmt2 := 0;
        END;


        CalculateTax.CallTaxEngineOnPurchaseLine(PLine, PLine);//Added Code for BC

        CODEUNIT.RUN(CODEUNIT::"Purch.-Post", PHeader);

        IF VoucherHeader_1.Type = VoucherHeader_1.Type::Commission THEN BEGIN
            PIHeader.RESET;
            PIHeader.SETRANGE("Buy-from Vendor No.", VoucherHeader_1."Paid To");
            PIHeader.SETRANGE("Posting Date", VoucherHeader_1."Posting Date");
            PIHeader.SETRANGE("Application No.", OrderRefNo_1);  //271119
            IF PIHeader.FINDLAST THEN BEGIN
                CommEntry_1.RESET;
                CommEntry_1.SETCURRENTKEY("Associate Code");
                CommEntry_1.SETRANGE("Associate Code", VoucherHeader_1."Paid To");
                CommEntry_1.SETRANGE("Voucher No.", '');
                CommEntry_1.SETRANGE(Posted, TRUE);
                CommEntry_1.SETRANGE("Invoice Date", TODAY);
                CommEntry_1.SETRANGE("Application No.", OrderRefNo_1);
                IF CommEntry_1.FINDSET THEN
                    REPEAT
                        CommEntry_1."Voucher No." := PIHeader."No.";
                        CommEntry_1.MODIFY;
                    UNTIL CommEntry_1.NEXT = 0;
            END;
        END;
        IF VoucherHeader_1.Type = VoucherHeader_1.Type::TA THEN BEGIN
            PIHeader.RESET;
            PIHeader.SETRANGE("Buy-from Vendor No.", VoucherHeader_1."Paid To");
            PIHeader.SETRANGE("Posting Date", VoucherHeader_1."Posting Date");
            PIHeader.SETRANGE("Application No.", OrderRefNo_1); //271119
            IF PIHeader.FINDLAST THEN BEGIN
                TPEntry_1.RESET;
                TPEntry_1.SETCURRENTKEY(TPEntry_1."Sub Associate Code");
                TPEntry_1.SETRANGE("Sub Associate Code", VoucherHeader_1."Paid To");
                TPEntry_1.SETRANGE("Voucher No.", '');
                TPEntry_1.SETRANGE("Post Payment", TRUE);
                TPEntry_1.SETRANGE("Invoice Date", TODAY);
                TPEntry_1.SETRANGE("Application No.", OrderRefNo_1);   //271119
                IF TPEntry_1.FINDSET THEN
                    REPEAT
                        TPEntry_1."Voucher No." := PIHeader."No.";
                        TPEntry_1.MODIFY;
                    UNTIL TPEntry_1.NEXT = 0;
            END;
        END;
        IF Club9ChargesAmt2 > 0 THEN BEGIN
            // PLine.INIT;
            // PLine."Document Type" := PLine."Document Type"::Invoice;
            // PLine."Document No." := PHeader."No.";
            // PLine."Line No." := 20000;
            // PLine.Type := PLine.Type::"G/L Account";
            // PLine.VALIDATE("Buy-from Vendor No.", PHeader."Buy-from Vendor No.");
            // PLine.VALIDATE("No.", Unitsetup."Corpus A/C");
            // PLine.VALIDATE(Quantity, -1);
            // PLine.VALIDATE(PLine."Direct Unit Cost", Club9ChargesAmt2);
            // PLine.INSERT;
            PIHeader.RESET;
            PIHeader.SETRANGE("Buy-from Vendor No.", VoucherHeader_1."Paid To");
            PIHeader.SETRANGE("Posting Date", VoucherHeader_1."Posting Date");
            PIHeader.SETRANGE("Application No.", OrderRefNo_1); //271119
            IF PIHeader.FINDLAST THEN BEGIN

                CreateGeneralJournalClub9(PIHeader."Buy-from Vendor No.", Club9ChargesAmt2, PIHeader."No.", PIHeader."Dimension Set ID", PIHeader."Location Code", PIHeader."Vendor Invoice No.", PIHeader);
            End;
        END;
    end;


    procedure CreateVoucherHeader(AssociateCode_1: Code[20]; "Comm/TAAmount": Decimal; Type_1: Option " ",Incentive,Commission,TA,ComAndTA; InvoicePostDate: Date; OrderRefNo: Code[20]; ProjectCode: Code[20])
    var
        AssPmtVoucherHdr_1: Record "Assoc Pmt Voucher Header";
        TDS: Decimal;
    begin
        Unitsetup.GET;
        AssPmtVoucherHdr_1.INIT;
        AssPmtVoucherHdr_1."Document No." := '';
        AssPmtVoucherHdr_1.INSERT(TRUE);
        AssPmtVoucherHdr_1."Paid To" := AssociateCode_1;
        //AssPmtVoucherHdr_1."Payment Mode" := PaymentMode;
        // AssPmtVoucherHdr_1."Bank/G L Code" := BankGLCode;
        // AssPmtVoucherHdr_1."Cheque No." := CheqNo;
        // AssPmtVoucherHdr_1."Cheque Date" := CheqDate;
        // AssPmtVoucherHdr_1."Bank/G L Name" := "Associate Payment Hdr"."Bank/G L Name";
        AssPmtVoucherHdr_1."Sub Type" := AssPmtVoucherHdr_1."Sub Type"::Regular;
        AssPmtVoucherHdr_1.Type := Type_1;

        AssPmtVoucherHdr_1."User ID" := USERID;
        AssPmtVoucherHdr_1."User Branch Code" := UserSetup."User Branch";
        IF InvoicePostDate <> 0D THEN BEGIN
            AssPmtVoucherHdr_1."Posting Date" := InvoicePostDate;
            AssPmtVoucherHdr_1."Document Date" := InvoicePostDate;
            AssPmtVoucherHdr_1."Commission Date" := InvoicePostDate;
        END ELSE BEGIN
            AssPmtVoucherHdr_1."Posting Date" := TODAY;
            AssPmtVoucherHdr_1."Document Date" := TODAY;
            AssPmtVoucherHdr_1."Commission Date" := TODAY;

        END;
        AssPmtVoucherHdr_1."From MS Company" := FALSE;
        AssPmtVoucherHdr_1.MODIFY;

        VoucherLine.INIT;
        VoucherLine."Voucher No." := AssPmtVoucherHdr_1."Document No.";
        VoucherLine."Line No." := 10000;
        VoucherLine."Associate Code" := AssociateCode_1;
        VoucherLine.Amount := "Comm/TAAmount";
        VoucherLine.Type := AssPmtVoucherHdr_1.Type;
        //VoucherLine."Incentive Type" := "Associate Payment Hdr"."Incentive Type";
        VoucherLine."Eligible Amount" := "Comm/TAAmount";
        VoucherLine."Paid To" := AssociateCode_1;
        TDS := 0;
        VoucherLine."Clube 9 Charge Amount" := ROUND((("Comm/TAAmount" * Unitsetup."Corpus %") / 100), 0.01);
        TDS := PostPayment.CalculateTDSPercentage(AssociateCode_1, Unitsetup."TDS Nature of Deduction", '');
        VoucherLine."TDS Amount" := ("Comm/TAAmount" * TDS) / 100;
        VoucherLine."From MS Company" := FALSE;
        VoucherLine.INSERT;

        CreateCommissionInvoice(AssPmtVoucherHdr_1, OrderRefNo, ProjectCode);
    end;


    procedure AppliesPayment(DocumentNo_1: Code[20]; VendorCode_1: Code[20]): Decimal
    var
        VLEntry_2: Record "Vendor Ledger Entry";
        AdjustClbAmt: Decimal;
    begin
        AdjustClbAmt := 0;
        VLEntry_2.RESET;
        //VLEntry_2.SETCURRENTKEY(VLEntry_2."Vendor No.");
        VLEntry_2.SETRANGE("Vendor No.", VendorCode_1);
        VLEntry_2.SETRANGE("Document Type", VLEntry_2."Document Type"::Payment);
        VLEntry_2.SETFILTER("TDS Section Code", '<>%1', '');
        VLEntry_2.SETRANGE(VLEntry_2.Reversed, FALSE);
        VLEntry_2.SETRANGE(Open, TRUE);
        IF VLEntry_2.FINDSET THEN BEGIN
            REPEAT
                VLEntry_2.CALCFIELDS(VLEntry_2."Remaining Amount");
                IF VLEntry_2."Remaining Amount" > 0 THEN BEGIN
                    VLEntry_2."Applies-to Doc. Type" := VLEntry_2."Applies-to Doc. Type"::Payment;
                    VLEntry_2."Applies-to ID" := USERID;
                    VLEntry_2."Amount to Apply" := VLEntry_2."Remaining Amount";
                    AdjustClbAmt := AdjustClbAmt + VLEntry_2."Remaining Amount";
                    VLEntry_2.MODIFY;
                END;
            UNTIL VLEntry_2.NEXT = 0;
        END;
        EXIT(AdjustClbAmt);
    end;


    procedure PostDiscountEntries(CustomerCode_1: Code[20]; AppCode_1: Code[20]; PostDate_1: Date; Amount_1: Decimal)
    var
        APPPayEntry_1: Record "Application Payment Entry";
    begin

        Unitsetup.GET;
        UserSetup.GET(USERID);
        GenJnlLine.RESET;
        GenJnlLine.SETFILTER("Journal Template Name", Unitsetup."Transfer Member Temp Name");
        GenJnlLine.SETRANGE("Journal Batch Name", Unitsetup."Transfer Member Batch Name");
        IF GenJnlLine.FINDLAST THEN
            LineNo2 := GenJnlLine."Line No.";

        GenJnlLine.INIT;
        LineNo2 += 10000;

        GenJnlLine."Journal Template Name" := Unitsetup."Transfer Member Temp Name";
        GenJnlLine."Journal Batch Name" := Unitsetup."Transfer Member Batch Name";

        IF GenJnlBatch.GET(Unitsetup."Transfer Member Temp Name", Unitsetup."Transfer Member Batch Name") THEN
            DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Line No." := LineNo2;
        GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::" ");
        GenJnlLine.VALIDATE("Posting Date", PostDate_1);
        GenJnlLine.VALIDATE("Document Date", PostDate_1);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Account No.", Unitsetup."BBG Discount Account");
        GenJnlLine.VALIDATE("Debit Amount", ROUND(Amount_1, 1));
        GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Running);
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::Customer);
        GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", CustomerCode_1);
        //  GenJnlLine.VALIDATE("Source Code",CustomerCode_1);
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        GenJnlLine."External Document No." := AppCode_1;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Branch Code" := UserSetup."User Branch";  //180113
                                                              //  GenJnlLine.VALIDATE("Bal. Gen. Posting Type",GenJnlLine."Bal. Gen. Posting Type"::Purchase);  //140213
        GenJnlLine.INSERT;
        CLEAR(GenJnlPostLine);
        InsertJnlDimension(GenJnlLine); //ALLEDK 010213
        GenJnlPostLine.RunWithCheck(GenJnlLine);  //ALLEDK 010213  Upgrade
                                                  //ALLEDK 140213
        RecGenJnlLines.RESET;
        RecGenJnlLines.SETRANGE("Document No.", DocNo);
        IF RecGenJnlLines.FINDFIRST THEN
            RecGenJnlLines.DELETEALL(TRUE);

        APEntry.RESET;
        APEntry.SETRANGE("Document No.", AppCode_1);
        IF APEntry.FINDLAST THEN BEGIN
            APEntry."Posted Document No." := DocNo;
            APEntry.MODIFY;
        END;
    end;

    procedure CreateGeneralJournalClub9(Var VendNo: Code[20]; Amt: Decimal; DocNo: Code[20]; Var DimSetID: Integer; Var LocCode: Code[10]; Var VendorInvNo: Code[35]; Var PurInvHdr: Record "Purch. Inv. Header")
    var
        GenJournalLine: Record "Gen. Journal Line";
        UnitSetup: Record "Unit Setup";
        LineNo: Integer;
        GenJournalPost: Codeunit "Gen. Jnl.-Post Line";
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        LineNo := 0;
        UnitSetup.Get();
        UnitSetup.TestField("Club9 General Journal Template");
        UnitSetup.TestField("Club9 General Journal Batch");

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", UnitSetup."Club9 General Journal Template");
        GenJournalLine.SetRange("Journal Batch Name", UnitSetup."Club9 General Journal Batch");
        IF GenJournalLine.FindLast() then
            LineNo := GenJournalLine."Line No.";

        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := UnitSetup."Club9 General Journal Template";
        GenJournalLine."Journal Batch Name" := UnitSetup."Club9 General Journal Batch";
        GenJournalLine."Line No." := LineNo + 10000;
        GenJournalLine.Validate("Posting Date", Today);
        GenJournalLine.Validate("Document No.", DocNo);
        GenJournalLine.Insert();
        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::Vendor);
        GenJournalLine.Validate("Account No.", VendNo);
        GenJournalLine.Validate(Amount, Amt);
        GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
        GenJournalLine.Validate("Bal. Account No.", UnitSetup."Corpus A/C");
        GenJournalLine.Validate("Location Code", LocCode);
        GenJournalLine.Validate("Dimension Set ID", DimSetID);
        GenJournalLine.Validate("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::Invoice);
        GenJournalLine.Validate("Applies-to Doc. No.", DocNo);
        GenJournalLine."Club 9 Entry" := True;  //260225
        GenJournalLine.Description := 'Club 9 Entry';
        GenJournalLine."External Document No." := VendorInvNo;
        VendLedgerEntry.Reset();
        VendLedgerEntry.SetRange("Document No.", PurInvHdr."No.");
        IF VendLedgerEntry.FindFirst() then
            GenJournalLine."Posting Type" := VendLedgerEntry."Posting Type";
        GenJournalLine."Application No." := PurInvHdr."Application No.";
        GenJournalLine.Modify();
        GenJournalPost.RunWithCheck(GenJournalLine);
        GenJournalLine.DeleteAll();
    end;

}

