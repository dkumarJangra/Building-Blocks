page 97953 "Payable Form NEW"
{
    // //BBG1.00 ALLEDK 070313 Code added for changes in Payment methods
    // BBG1.00 010413 Code added in case of BSP2 release or not Release
    // ALLETDK120913>>>  Added code after correction in drawning ledger report.
    // BBG2.00 Added code for bypass the Advace payment calculation effect

    Editable = true;
    PageType = Card;
    SourceTable = "Assoc Pmt Voucher Header";
    SourceTableView = WHERE(Post = FILTER(false),
                            "Sub Type" = CONST(Regular));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                    Editable = "Document No.Editable";
                    Enabled = true;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Paid To"; Rec."Paid To")
                {
                    Editable = "Paid ToEditable";

                    trigger OnValidate()
                    begin
                        //ALLECK 230313 START
                        Rec."User ID" := USERID;
                        IF UserSetup.GET(Rec."User ID") THEN
                            Rec."User Branch Code" := UserSetup."User Branch";
                        //ALLECK 230313 END

                        IF Rec."Paid To" <> '' THEN BEGIN
                            VHeader.RESET;
                            VHeader.SETCURRENTKEY("Paid To");
                            VHeader.SETRANGE("Paid To", Rec."Paid To");
                            VHeader.SETFILTER("Document No.", '<>%1', Rec."Document No.");
                            VHeader.SETRANGE(Post, FALSE);
                            IF VHeader.FINDFIRST THEN
                                ERROR('You have already select this Associate with another Document No.=' + VHeader."Document No.");
                        END;
                    end;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    Editable = "Payment ModeEditable";

                    trigger OnValidate()
                    begin
                        PaymentModeOnAfterValidate;
                    end;
                }
                field("AccCode...."; AccCode + '....')
                {
                }
                field("Bank/G L Code"; Rec."Bank/G L Code")
                {
                    Editable = "Bank/G L CodeEditable";

                    trigger OnValidate()
                    begin

                        //BBG1.00 030613
                        IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN BEGIN
                            IF NOT BAccount.GET(Rec."Bank/G L Code") THEN
                                ERROR('Please check Bank Account Code');
                        END ELSE
                            IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN BEGIN
                                IF NOT GLAccount1.GET(Rec."Bank/G L Code") THEN
                                    ERROR('Please check CASH Account Code');
                            END;
                        //BBG1.00 030613
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Name; Rec.Name)
                {
                    Editable = NameEditable;
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
                field("User Branch Code"; Rec."User Branch Code")
                {
                    Caption = 'User Branch';
                }
                field("Bank/G L Name"; Rec."Bank/G L Name")
                {
                    Caption = 'Name';
                    Editable = "Bank/G L NameEditable";
                }
                field(Type; Rec.Type)
                {
                    Editable = TypeEditable;
                    OptionCaption = ' ,Incentive,Commission,TA,ComAndTA';
                }
                field("Incentive Type"; Rec."Incentive Type")
                {
                    Editable = "Incentive TypeEditable";
                }
                field("Commission Date"; Rec."Commission Date")
                {
                }
                field(NetAmt; NetAmt)
                {
                    Caption = 'Cheque Amount';
                    Visible = true;

                    trigger OnValidate()
                    begin
                        NetAmtOnAfterValidate;
                    end;
                }
                field("Sub Type"; Rec."Sub Type")
                {
                }
                field("Rem. Opening Inv Amt"; Rec."Rem. Opening Inv Amt")
                {
                    Caption = 'Op. Invoices(Total)';
                    Editable = false;
                }
                field(TotalInvAmount; TotalInvAmount)
                {
                    Caption = 'Net Change (1-3-2013 onwards)';
                    Editable = false;
                }
                field("Ignore Advance Payment"; Rec."Ignore Advance Payment")
                {

                    trigger OnValidate()
                    begin
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'IgnoreAdvPayment');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You are not authorised person to perform this task');
                    end;
                }
                field(FinalAmt; FinalAmt)
                {
                    Caption = 'Gross Amount';
                    Visible = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Project Code';
                    Visible = false;
                }
                field("Rem. Direct Inv Amt"; Rec."Rem. Direct Inv Amt")
                {
                    Caption = 'Rem. Direct Invoice';
                    Editable = false;
                    Visible = true;
                }
                field("Advance Amount"; Rec."Advance Amount")
                {
                    Editable = false;
                }
                field("Create Invoice Only"; Rec."Create Invoice Only")
                {
                    Caption = 'Total Rem. Open+Direct Amt';
                    Visible = true;

                    trigger OnValidate()
                    begin
                        MemberOf.RESET;
                        MemberOf.SETRANGE("User Name", USERID);
                        MemberOf.SETRANGE("Role ID", 'CreateInvOnly');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You are not authorised person to perform this task');
                    end;
                }
                field("Total Elig. Incl Opening"; Rec."Total Elig. Incl Opening")
                {
                    Editable = false;
                }
                field("Eligible Amount"; Rec."Eligible Amount")
                {
                    Editable = false;
                }
                field("Payable Amount"; Rec."Payable Amount")
                {
                    Caption = 'Payment Amount';
                    Editable = false;
                }
                field("Payable Amount (Incl. OP+Dir)"; Rec."Payable Amount (Incl. OP+Dir)")
                {
                    Editable = false;
                }
                field("Total Deduction (Incl TA Rev)"; Rec."Total Deduction (Incl TA Rev)")
                {
                    Editable = false;
                }
                field("Total Elig. Incl. Opening"; Rec."Total Elig. Incl. Opening")
                {
                    Editable = false;
                }
                field("Total Elig. Excl. Opening"; Rec."Total Elig. Excl. Opening")
                {
                    Editable = false;
                }
                field("Total Club 9"; Rec."Total Club 9")
                {
                    Editable = false;
                }
                field("Total TDS"; Rec."Total TDS")
                {
                    Editable = false;
                }
                field("Net Elig."; Rec."Net Elig.")
                {
                    Editable = false;
                }
                field(PSAmt2; PSAmt2)
                {
                    Caption = 'Open Bal Rem.';
                    Editable = false;
                }
                field("Net Balance"; Rec."Net Balance")
                {
                    Editable = false;
                }
                field("Rem. Direct Inv Amt Rem. Opening Inv Amt"; Rec."Rem. Direct Inv Amt" + Rec."Rem. Opening Inv Amt")
                {
                    Editable = false;
                }
            }
            part(VoucherSubform; "Voucher Sub form")
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
            group("F&unction")
            {
                Caption = 'F&unction';
                action("&Get Lines")
                {
                    Caption = '&Get Lines';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        IF Rec.Type = Rec.Type::Incentive THEN
                            Rec.TESTFIELD("Incentive Type");
                        IF CONFIRM('Do you want to generate Entries?', FALSE) THEN BEGIN

                            IF Rec."Payment Mode" = Rec."Payment Mode"::" " THEN
                                ERROR('Please define first Payment Mode');
                            IF Rec."Bank/G L Code" = '' THEN
                                ERROR('Please define the GL OR Bank Code');

                            VoucherLine.RESET;
                            IF VoucherLine.FINDLAST THEN BEGIN
                                LineNo := VoucherLine."Line No.";
                            END;

                            Rec."Check Advance Amount" := FALSE;  //BBG1.4

                            IF Rec.Type = Rec.Type::Incentive THEN BEGIN

                                AddIncentiveVouchers;
                            END ELSE IF Rec.Type = Rec.Type::Commission THEN BEGIN
                                Rec.TESTFIELD("Commission Date");
                                AddCommVouchers;
                            END ELSE IF Rec.Type = Rec.Type::TA THEN
                                    InsertTAEntry
                            ELSE IF Rec.Type = Rec.Type::ComAndTA THEN BEGIN
                                Rec.TESTFIELD("Commission Date");
                                AddCommVouchers;
                                InsertTAEntry;
                            END;
                        END;

                        UpdateheaderValues;  //ALLEDK 130314
                    end;
                }
                group("&Set Status")
                {
                    Caption = '&Set Status';
                    Visible = false;
                    action("Re&lease")
                    {
                        Caption = 'Re&lease';
                        Image = ReleaseDoc;
                        ShortCutKey = 'Ctrl+F9';
                        Visible = false;

                        trigger OnAction()
                        begin
                            IF Rec.Status <> Rec.Status::Released THEN BEGIN
                                IF NOT CONFIRM(Text50000) THEN
                                    EXIT;
                                Rec.Status := Rec.Status::Released;
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
                                Rec.MODIFY;
                            END
                            ELSE
                                ERROR(Text50001);
                        end;
                    }
                    action("Re&Open")
                    {
                        Caption = 'Re&Open';
                        Visible = false;

                        trigger OnAction()
                        begin
                            IF Rec.Status <> Rec.Status::Open THEN BEGIN
                                IF NOT CONFIRM(Text50002) THEN
                                    EXIT;
                                Rec.Status := Rec.Status::Open;
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
                                Rec.MODIFY;
                            END
                            ELSE
                                ERROR(Text50003);
                        end;
                    }
                }
                action(Refresh)
                {
                    Caption = 'Refresh';
                    Image = Refresh;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        HdrCommTA := 0;
                        IF Rec.Type = Rec.Type::Commission THEN
                            ForHeaderInsertTAEntry;
                        IF Rec.Type = Rec.Type::TA THEN
                            ForHdrAddComm;

                        BalAmount; //BBG1.00 270613

                        Unitsetup.GET;
                        TDSCode := '';
                        TDSCode1 := '';
                        Unitsetup.GET;

                        IF Rec.Type = Rec.Type::TA THEN
                            TDSCode := Unitsetup."TDS Nature of Deduction TA"
                        ELSE IF Rec.Type = Rec.Type::Commission THEN
                            TDSCode := Unitsetup."TDS Nature of Deduction"
                        ELSE IF Rec.Type = Rec.Type::Incentive THEN
                            TDSCode := Unitsetup."TDS Nature of Deduction INCT"
                        ELSE IF Rec.Type = Rec.Type::ComAndTA THEN BEGIN
                            TDSCode := Unitsetup."TDS Nature of Deduction TA";
                            TDSCode1 := Unitsetup."TDS Nature of Deduction";
                        END;
                        Rec.CALCFIELDS("Payable Amount", "TDS Amount", "Club 9 Amount");


                        CalcTDSPercentage;

                        IF Rec.Type = Rec.Type::Incentive THEN
                            Rec."Net Pay after adv. Adj." := (Rec."Payable Amount" - Rec."TDS Amount" - Rec."Club 9 Amount") - (Rec."Advance Amount" - (Rec."Advance Amount" * TDSPercentage /
                          100
                            )
                            - (Rec."Advance Amount" * Unitsetup."Incentive Club 9%" / 100))
                        ELSE
                            Rec."Net Pay after adv. Adj." := (Rec."Payable Amount" - Rec."TDS Amount" - Rec."Club 9 Amount") - (Rec."Advance Amount" - (Rec."Advance Amount" * TDSPercentage /
                          100
                            )
                            - (Rec."Advance Amount" * Unitsetup."Corpus %" / 100));


                        IF Rec."Net Pay after adv. Adj." < 0 THEN
                            Rec."Net Pay after adv. Adj." := 0
                        ELSE
                            Rec."Net Pay after adv. Adj." := Rec."Net Pay after adv. Adj.";
                        Rec.MODIFY;
                    end;
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                action("&Post")
                {
                    Caption = '&Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        Rec.TESTFIELD("User Branch Code"); //ALLEDK 030313
                        Rec.TESTFIELD("Create Invoice Only");
                        //IF "Advance Payment" THEN
                        //  TESTFIELD("Advance Amount");
                        Rec.TESTFIELD(Type);
                        Rec.TESTFIELD("Sub Type", Rec."Sub Type"::Regular);
                        Rec.TESTFIELD("Posting Date");
                        Rec.TESTFIELD("Bank/G L Code");
                        Rec.TESTFIELD("Payable Amount");
                        BondSetup.GET;
                        BondSetup.TESTFIELD(BondSetup."SMS Start Date");
                        //TESTFIELD(Status,Status::Released);
                        IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN BEGIN
                            Rec.TESTFIELD("Cheque No.");
                            Rec.TESTFIELD("Cheque Date");
                        END;

                        //BBG1.00 030613

                        IF NOT Rec."Ignore Advance Payment" AND NOT Rec."Create Invoice Only" THEN BEGIN  //BBG2.00
                            IF (Rec."Net Elig.") > -1 THEN BEGIN

                                IF Rec."Cheque No." <> '' THEN BEGIN
                                    StartNo := COPYSTR(Rec."Cheque No.", 1, 1);
                                    IF EVALUATE(VarInteger, StartNo) THEN
                                        ERROR('Please define Dummy Cheque No. For Dummy Cheque No. Add ' + ' ' + 'D' + ' ' + ' character before cheque no.');
                                END;
                            END;
                        END;

                        //BBG2.00

                        //BBG1.00 030613

                        TDSCode := '';
                        TDSCode1 := '';
                        Unitsetup.GET;

                        IF Rec.Type = Rec.Type::TA THEN
                            TDSCode := Unitsetup."TDS Nature of Deduction TA"
                        ELSE IF Rec.Type = Rec.Type::Commission THEN
                            TDSCode := Unitsetup."TDS Nature of Deduction"
                        ELSE IF Rec.Type = Rec.Type::Incentive THEN
                            TDSCode := Unitsetup."TDS Nature of Deduction INCT"
                        ELSE IF Rec.Type = Rec.Type::ComAndTA THEN BEGIN
                            TDSCode := Unitsetup."TDS Nature of Deduction TA";
                            TDSCode1 := Unitsetup."TDS Nature of Deduction";
                        END;

                        IF Rec."Ignore Advance Payment" OR Rec."Create Invoice Only" THEN BEGIN //BBG2.00
                            IF CONFIRM('Do you want to Post Invoice ?') THEN BEGIN
                                IF Rec.Type = Rec.Type::TA THEN
                                    PostTA
                                ELSE IF Rec.Type = Rec.Type::Commission THEN
                                    PostCommission
                                ELSE IF Rec.Type = Rec.Type::Incentive THEN
                                    PostIncentive
                                ELSE IF Rec.Type = Rec.Type::ComAndTA THEN
                                    PostComAndTA;
                            END;
                        END ELSE IF (NOT Rec."Ignore Advance Payment") AND (NOT Rec."Create Invoice Only") THEN BEGIN //BBG2.00
                            IF Rec."Advance Amount" = 0 THEN BEGIN
                                IF CONFIRM('Do you want to Post Invoice ?') THEN BEGIN
                                    IF Rec.Type = Rec.Type::TA THEN
                                        PostTA
                                    ELSE IF Rec.Type = Rec.Type::Commission THEN
                                        PostCommission
                                    ELSE IF Rec.Type = Rec.Type::Incentive THEN
                                        PostIncentive
                                    ELSE IF Rec.Type = Rec.Type::ComAndTA THEN
                                        PostComAndTA;
                                END;
                            END ELSE IF CONFIRM('Do you want to Post Invoice ?') THEN BEGIN
                                IF Rec.Type = Rec.Type::TA THEN
                                    PostTA1
                                ELSE IF Rec.Type = Rec.Type::Commission THEN
                                    PostCommission1
                                ELSE IF Rec.Type = Rec.Type::Incentive THEN
                                    PostIncentive1
                                ELSE IF Rec.Type = Rec.Type::ComAndTA THEN
                                    PostComAndTA1;
                            END;
                        END;
                        //BBG2.00 Start
                        AssociateSMS.SmsonCommissionRelease(Rec."Document No.");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateGLCode;
        UpdateControls;
    end;

    trigger OnInit()
    begin
        VoucherSubPAGEEditable := TRUE;
        "Payment ModeEditable" := TRUE;
        "Incentive TypeEditable" := TRUE;
        TypeEditable := TRUE;
        "Cheque DateEditable" := TRUE;
        "Cheque No.Editable" := TRUE;
        "Bank/G L CodeEditable" := TRUE;
        "Paid ToEditable" := TRUE;
        "Document No.Editable" := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Sub Type" := Rec."Sub Type"::Regular;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Sub Type" := Rec."Sub Type"::Regular;
    end;

    trigger OnOpenPage()
    begin
        UpdateGLCode;
        UpdateControls;
        IF NOT (USERID IN ['1003', '1005']) THEN
            Rec.SETRANGE("User ID", USERID); //BBG1.00 050413
    end;

    var
        LineNo: Integer;
        VoucherCount2: Integer;
        UserSetup: Record "User Setup";
        Unitsetup: Record "Unit Setup";
        BondSetup: Record "Unit Setup";
        VoucherLine: Record "Voucher Line";
        Text50000: Label 'Do you want to Release this Voucher?';
        Text50001: Label 'Status of this Voucher is already Released.';
        Text50002: Label 'Do you want to open this Voucher?';
        Text50003: Label 'Status of this Voucher is already Open.';
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        LineNo2: Integer;
        GenJnlBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        //NODNOCLine: Record 13785;//Need to check the code in UAT

        GenJnlLine2: Record "Gen. Journal Line";
        Amt2: Decimal;
        TDSAmt2: Decimal;
        Club9ChargesAmt2: Decimal;
        DocNo: Code[20];
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
        VLEntry: Record "Vendor Ledger Entry";
        GenLedSetup: Record "General Ledger Setup";
        PurchPost: Codeunit "Purch.-Post";
        GLSetup: Record "General Ledger Setup";
        Club9Post: Decimal;
        RecGenJnlLines: Record "Gen. Journal Line";
        Amt4: Decimal;
        TotalAdAmt: Decimal;
        AccCode: Text[20];
        Dim2Code: Code[20];
        //RecNODHeader: Record 13786;//Need to check the code in UAT

        CreatTA: Boolean;
        RecConforder: Record "Confirmed Order";
        EntryNo: Integer;
        FinalAmt: Decimal;
        NetAmt: Decimal;
        OpenAmt: Decimal;
        Vend: Record Vendor;
        OpenAmt1: Decimal;
        TDS: Decimal;
        PayableAmt: Decimal;
        PayableOpenAmt: Decimal;
        TotalEligibility: Decimal;
        BAccount: Record "Bank Account";
        GLAccount1: Record "G/L Account";
        StartNo: Text[30];
        VarInteger: Integer;
        TrvlPmt: Record "Travel Payment Entry";
        PostPayment: Codeunit PostPayment;
        VoucherHdr: Record "Assoc Pmt Voucher Header";
        Clb91: Decimal;
        TClb91: Decimal;
        TDSAmt: Decimal;
        TDSE: Record "TDS Entry";// 13729;
        TTdsAmt: Decimal;
        GLE: Record "G/L Entry";
        GLE1: Record "G/L Entry";
        PSAmt1: Decimal;
        TotalInvAmount: Decimal;
        PaidTDS: Decimal;
        PaidClub: Decimal;
        AdvTDS: Decimal;
        AdvClub: Decimal;
        InvAmount: Decimal;
        OpenAdvAmt: Decimal;
        OpAmt: Decimal;
        TrvlPmt1: Decimal;
        TotalPayment: Decimal;
        BAMT: Decimal;
        BLE: Record "Bank Account Ledger Entry";
        CLE: Record "Cust. Ledger Entry";
        CLB9: Decimal;
        "G/LE": Record "G/L Entry";
        TClb9: Decimal;
        TTDSO: Decimal;
        TopAmt: Decimal;
        TCLBO: Decimal;
        GLE2: Record "G/L Entry";
        TDSO: Decimal;
        TDSE2: Record "TDS Entry";// 13729;
        clbo: Decimal;
        GLE3: Record "G/L Entry";
        VLE: Record "Vendor Ledger Entry";
        Pamt: Decimal;
        PSAmt: Decimal;
        PTDS: Decimal;
        PCLB: Decimal;
        NopAmt: Decimal;
        CommAmt: Decimal;
        ElgiblBSP2: Decimal;
        TCommAmt: Decimal;
        TotalTAAmt: Decimal;
        TRVlAmt: Decimal;
        EDate: Date;
        TDSAmt1: Decimal;
        ClbAmt1: Decimal;
        CorrTrvlPmt: Decimal;
        ClubDedect: Decimal;
        TDSDedect: Decimal;
        TotalBal: Decimal;
        NetPayable1: Decimal;
        PaidComm: Decimal;
        PaidTA: Decimal;
        Total: Decimal;
        GrossAmount: Decimal;
        TotalDedect: Decimal;
        TotalTDSdedect: Decimal;
        TotalClubdedect: Decimal;
        TTotalDedect: Decimal;
        InvAmount1: Decimal;
        TotalInvAmount1: Decimal;
        NetPayable: Decimal;
        RemOpOpening: Decimal;
        AHWZpplication: Record "Associate Hierarcy with App.";
        OpBalance: Decimal;
        NetELEG: Decimal;
        NetElegwithTDSClb: Decimal;
        FinalAmt1: Decimal;
        HdrCommTA: Decimal;
        Vline: Record "Voucher Line";
        VoucherAmt: Decimal;
        VHeader: Record "Assoc Pmt Voucher Header";
        ChLE: Record "Check Ledger Entry";
        OpenAmt2: Decimal;
        OpenAmt3: Decimal;
        PAmt2: Decimal;
        PSAmt2: Decimal;
        DirectPaidComm: Decimal;
        APPCode: Code[20];
        MemberOf: Record "Access Control";
        GLEntry: Record "G/L Entry";
        AppNo: Code[20];
        AssociateSMS: Codeunit "SMS Features";

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
        EntryNo := 0;

        IncentiveSummary.RESET;
        IncentiveSummary.SETFILTER("Entry No.", '>%1', 0);
        IF IncentiveSummary.FINDLAST THEN
            EntryNo := IncentiveSummary."Entry No.";



        IF (Rec."Incentive Type" = Rec."Incentive Type"::Direct) OR
         (Rec."Incentive Type" = Rec."Incentive Type"::" ") THEN BEGIN
            IncentiveSummary.RESET;
            IncentiveSummary.SETCURRENTKEY("Associate Code", Month, Year);
            IncentiveSummary.SETRANGE("Associate Code", Rec."Paid To");
            IncentiveSummary.SETRANGE(Type, IncentiveSummary.Type::Direct);
            IncentiveSummary.SETRANGE("Post Payment", FALSE);
            //  IncentiveSummary.SETRANGE("Incentive Not Applicable",FALSE);  //BBG1.4 231213
            IF IncentiveSummary.FINDFIRST THEN BEGIN
                REPEAT
                    AmttoPay1 := AmttoPay1 + IncentiveSummary."Payable Incentive Amount";
                    AmtTDS1 := AmtTDS1 + IncentiveSummary."TDS Amount";
                    IncentiveSummary."Voucher No." := Rec."Document No.";
                    IncentiveSummary."Entry No." := EntryNo + 1;
                    IncentiveSummary."Post Payment" := TRUE;
                    IncentiveSummary.MODIFY;
                    EntryNo := IncentiveSummary."Entry No.";
                UNTIL IncentiveSummary.NEXT = 0;
            END;

            IncentiveSummary.RESET;
            IncentiveSummary.SETCURRENTKEY("Associate Code", Month, Year);
            IncentiveSummary.SETRANGE("Associate Code", Rec."Paid To");
            IncentiveSummary.SETRANGE(Type, IncentiveSummary.Type::Direct);
            IncentiveSummary.SETFILTER("Remaining Amount", '<>%1', 0);
            IF IncentiveSummary.FINDFIRST THEN BEGIN
                REPEAT
                    AmttoPay := AmttoPay + IncentiveSummary."Remaining Amount";
                UNTIL IncentiveSummary.NEXT = 0;
            END;

            IF (AmttoPay + AmttoPay1) < 0 THEN BEGIN
                IncentiveSummary.RESET;
                IncentiveSummary.SETCURRENTKEY("Associate Code");
                IncentiveSummary.SETRANGE("Associate Code", Rec."Paid To");
                IncentiveSummary.SETRANGE("Voucher No.", Rec."Document No.");
                IF IncentiveSummary.FINDSET THEN BEGIN
                    REPEAT
                        IncentiveSummary."Voucher No." := '';
                        IncentiveSummary."Post Payment" := FALSE;
                        IncentiveSummary.MODIFY;
                    UNTIL IncentiveSummary.NEXT = 0;
                END;
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
                VoucherLine."Associate Code" := Rec."Paid To";
                VoucherLine.Amount := AmttoPay + AmttoPay1;
                VoucherLine."Eligible Amount" := AmttoPay + AmttoPay1;
                VoucherLine.Year := IncentiveSummary.Year;
                VoucherLine."TDS Amount" := ((AmttoPay + AmttoPay1) * "TDS%" / 100);
                VoucherLine.Month := IncentiveSummary.Month;
                VoucherLine."Posting Date" := Rec."Posting Date";//WORKDATE;
                VoucherLine.Type := VoucherLine.Type::Incentive;
                VoucherLine."Incentive Type" := VoucherLine."Incentive Type"::Direct;
                VoucherLine."Paid To" := Rec."Paid To";
                VoucherLine."Clube 9 Charge Amount" := ((AmttoPay1 + AmttoPay) * Unitsetup."Incentive Club 9%") / 100;
                VoucherLine.MODIFY;
                MESSAGE('%1', 'Generate the Incentive Entries.');
            END ELSE
                MESSAGE('%1', 'No Record found');
        END;

        IF (Rec."Incentive Type" = Rec."Incentive Type"::Team) OR
         (Rec."Incentive Type" = Rec."Incentive Type"::" ") THEN BEGIN

            IncentiveSummary.RESET;
            IncentiveSummary.SETCURRENTKEY("Associate Code", Month, Year);
            IncentiveSummary.SETRANGE("Associate Code", Rec."Paid To");
            IncentiveSummary.SETRANGE(Type, IncentiveSummary.Type::Team);
            IncentiveSummary.SETRANGE("Post Payment", FALSE);
            //  IncentiveSummary.SETRANGE("Incentive Not Applicable",FALSE);  //BBG1.4 231213
            IF IncentiveSummary.FINDFIRST THEN BEGIN
                REPEAT
                    AmttoPay1 := AmttoPay1 + IncentiveSummary."Payable Incentive Amount";
                    AmtTDS1 := AmtTDS1 + IncentiveSummary."TDS Amount";
                    IncentiveSummary."Voucher No." := Rec."Document No.";
                    IncentiveSummary."Entry No." := EntryNo + 1;
                    IncentiveSummary."Post Payment" := TRUE;
                    IncentiveSummary.MODIFY;
                    EntryNo := IncentiveSummary."Entry No.";
                UNTIL IncentiveSummary.NEXT = 0;
            END;

            IncentiveSummary.RESET;
            IncentiveSummary.SETCURRENTKEY("Associate Code", Month, Year);
            IncentiveSummary.SETRANGE("Associate Code", Rec."Paid To");
            IncentiveSummary.SETRANGE(IncentiveSummary.Type, IncentiveSummary.Type::Team);
            IncentiveSummary.SETFILTER("Remaining Amount", '<>%1', 0);
            IF IncentiveSummary.FINDFIRST THEN BEGIN
                REPEAT
                    AmttoPay := AmttoPay + IncentiveSummary."Remaining Amount";
                UNTIL IncentiveSummary.NEXT = 0;
            END;

            IF (AmttoPay + AmttoPay1) < 0 THEN BEGIN
                IncentiveSummary.RESET;
                IncentiveSummary.SETCURRENTKEY("Associate Code");
                IncentiveSummary.SETRANGE("Associate Code", Rec."Paid To");
                IncentiveSummary.SETRANGE("Voucher No.", Rec."Document No.");
                IF IncentiveSummary.FINDSET THEN BEGIN
                    REPEAT
                        IncentiveSummary."Voucher No." := '';
                        IncentiveSummary."Post Payment" := FALSE;
                        IncentiveSummary.MODIFY;
                    UNTIL IncentiveSummary.NEXT = 0;
                END;
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
                VoucherLine."Posting Date" := Rec."Posting Date";//WORKDATE;
                VoucherLine.Type := VoucherLine.Type::Incentive;
                VoucherLine."Incentive Type" := VoucherLine."Incentive Type"::Direct;
                VoucherLine."Clube 9 Charge Amount" := ((AmttoPay1 + AmttoPay) * Unitsetup."Incentive Club 9%") / 100;
                VoucherLine.MODIFY;

                MESSAGE('%1', 'Generate the Incentive Entries.');
            END ELSE
                MESSAGE('%1', 'No Record Found');
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
        CommissionEntry.SETRANGE("Posting Date", 0D, TODAY);
        //CommissionEntry.SETFILTER("Vouch/Ber No.",'=%1','');    //ALLEDK 210213
        CommissionEntry.SETRANGE(Posted, FALSE);  //ALLEDK 210213
        CommissionEntry.SETRANGE("Remaining Amt of Direct", FALSE);
        CommissionEntry.SETRANGE("Opening Entries", FALSE);
        IF CommissionEntry.FINDSET THEN BEGIN
            REPEAT
                IF CommissionEntry."Direct to Associate" THEN BEGIN
                    RecConforder.RESET;                                               //BBG1.00 010413
                    RecConforder.SETRANGE("No.", CommissionEntry."Application No.");   //BBG1.00 010413
                    RecConforder.SETRANGE("Registration Bonus Hold(BSP2)", FALSE);     //BBG1.00 010413
                    IF RecConforder.FINDFIRST THEN BEGIN                              //BBG1.00 010413
                        AmttoPay1 := AmttoPay1 + CommissionEntry."Commission Amount";
                        CommissionEntry."Voucher No." := Rec."Document No.";
                        CommissionEntry.Posted := TRUE;
                        CommissionEntry.MODIFY;
                    END;                                                             //BBG1.00 010413
                END ELSE BEGIN
                    AmttoPay1 := AmttoPay1 + CommissionEntry."Commission Amount";
                    CommissionEntry."Voucher No." := Rec."Document No.";
                    CommissionEntry.Posted := TRUE;
                    CommissionEntry.MODIFY;
                END;
            UNTIL CommissionEntry.NEXT = 0;
        END;
        CommissionEntry.RESET;
        CommissionEntry.SETCURRENTKEY("Associate Code", "Posting Date");
        CommissionEntry.SETRANGE("Associate Code", Rec."Paid To");
        //CommissionEntry.SETRANGE("Posting Date",0D,"Commission Date");
        CommissionEntry.SETFILTER("Remaining Amount", '<>%1', 0);
        CommissionEntry.SETRANGE("Opening Entries", FALSE);
        IF CommissionEntry.FINDSET THEN BEGIN
            REPEAT
                AmttoPay := AmttoPay + CommissionEntry."Remaining Amount";
            UNTIL CommissionEntry.NEXT = 0;
        END;

        IF (AmttoPay + AmttoPay1) < 0 THEN BEGIN
            CommissionEntry.RESET;
            CommissionEntry.SETCURRENTKEY("Associate Code", "Posting Date");
            CommissionEntry.SETRANGE("Associate Code", Rec."Paid To");
            CommissionEntry.SETRANGE("Posting Date", 0D, TODAY); //"Commission Date");
            CommissionEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF CommissionEntry.FINDSET THEN BEGIN
                REPEAT
                    CommissionEntry."Voucher No." := '';
                    CommissionEntry.Posted := FALSE;
                    CommissionEntry.MODIFY;
                UNTIL CommissionEntry.NEXT = 0;
            END;
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
            VoucherLine."Posting Date" := Rec."Posting Date";
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
            MESSAGE('%1', 'Generate the Commission Entries.');
        END
        ELSE
            MESSAGE('No Record found');
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
        EntryNo := 0;

        TravelPaymentEntry.RESET;
        TravelPaymentEntry.SETFILTER("Entry No.", '>%1', 0);
        IF TravelPaymentEntry.FINDLAST THEN
            EntryNo := TravelPaymentEntry."Entry No.";



        Unitsetup.GET;
        TravelPaymentEntry.RESET;
        TravelPaymentEntry.SETCURRENTKEY("Sub Associate Code", Month, Year, Approved);
        TravelPaymentEntry.SETRANGE("Sub Associate Code", Rec."Paid To");
        TravelPaymentEntry.SETRANGE("Creation Date", 0D, TODAY);//"Posting Date");
        TravelPaymentEntry.SETRANGE(Approved, TRUE);
        TravelPaymentEntry.SETRANGE("TA Creation on Commission Vouc", FALSE);
        //TravelPaymentEntry.SETFILTER("Voucher No.",'=%1','');
        TravelPaymentEntry.SETRANGE("Post Payment", FALSE);
        IF TravelPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                AmttoPay := AmttoPay + TravelPaymentEntry."Amount to Pay";
                AmtTDS := AmtTDS + TravelPaymentEntry."TDS Amount";
                TravelPaymentEntry."Voucher No." := Rec."Document No.";
                TravelPaymentEntry."Post Payment" := TRUE;
                TravelPaymentEntry."Entry No." := EntryNo + 1;
                TravelPaymentEntry.MODIFY;
                EntryNo := TravelPaymentEntry."Entry No.";
            UNTIL TravelPaymentEntry.NEXT = 0;
        END;

        TravelPaymentEntry.RESET;
        TravelPaymentEntry.SETCURRENTKEY("Sub Associate Code", Month, Year, Approved);
        TravelPaymentEntry.SETRANGE("Sub Associate Code", Rec."Paid To");
        //TravelPaymentEntry.SETRANGE("Creation Date",0D,"Posting Date");
        TravelPaymentEntry.SETFILTER("Remaining Amount", '<>%1', 0);
        IF TravelPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                AmttoPay1 := AmttoPay1 + TravelPaymentEntry."Remaining Amount";
            UNTIL TravelPaymentEntry.NEXT = 0;
        END;

        IF (AmttoPay + AmttoPay1) < 0 THEN BEGIN
            TravelPaymentEntry.RESET;
            TravelPaymentEntry.SETCURRENTKEY("Sub Associate Code");
            TravelPaymentEntry.SETRANGE("Sub Associate Code", Rec."Paid To");
            TravelPaymentEntry.SETRANGE("Creation Date", 0D, TODAY);//"Commission Date");
            TravelPaymentEntry.SETRANGE("Voucher No.", Rec."Document No.");
            IF TravelPaymentEntry.FINDSET THEN BEGIN
                REPEAT
                    TravelPaymentEntry."Voucher No." := '';
                    TravelPaymentEntry."Post Payment" := FALSE;
                    TravelPaymentEntry.MODIFY;
                UNTIL TravelPaymentEntry.NEXT = 0;
            END;
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
            VoucherLine."Voucher Date" := Rec."Posting Date";//TravelPaymentEntry."Creation Date";
            VoucherLine."Associate Code" := Rec."Paid To";
            VoucherLine.Amount := (AmttoPay1 + AmttoPay);
            VoucherLine."Eligible Amount" := (AmttoPay1 + AmttoPay);
            VoucherLine."TDS Amount" := ((AmttoPay + AmttoPay1) * "TDS%" / 100);
            VoucherLine.Type := VoucherLine.Type::TA;
            VoucherLine."New Line No." := TravelPaymentEntry."Line No.";
            VoucherLine."Paid To" := Rec."Paid To";
            VoucherLine."Clube 9 Charge Amount" := ((AmttoPay1 + AmttoPay) * Unitsetup."Corpus %") / 100;
            VoucherLine.INSERT;
            MESSAGE('%1', 'Generate the Travel Entries.');
        END
        ELSE
            MESSAGE('No Record found');
    end;


    procedure UpdateGLCode()
    begin
        AccCode := '';
        IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN
            AccCode := 'Cash Account'
        ELSE
            AccCode := 'Bank Account';
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
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";

        //BBG1.00 ALLEDK 070313
        IF NOT Rec."Create Invoice Only" THEN BEGIN      //BBG2.00
            PHeader."Payment Method Code" := FORMAT(Rec."Payment Mode");
            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN BEGIN
                PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"Bank Account";
                PHeader."Bal. Account No." := Rec."Bank/G L Code";
            END ELSE BEGIN
                PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"G/L Account";
                PHeader."Bal. Account No." := Rec."Bank/G L Code";
            END;
        END;   //BBG2.00
        //BBG1.00 ALLEDK 070313

        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Cheque No." := Rec."Cheque No.";
        PHeader."Cheque Date" := Rec."Cheque Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::"Travel Allowance";
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
        PLine.VALIDATE(PLine."Direct Unit Cost", Amt2);
        IF NOT Rec."Create Invoice Only" THEN       //BBG2.00
            PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
        PLine.INSERT;
        IF NOT Rec."Create Invoice Only" THEN BEGIN      //BBG2.00
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
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
                EligibleAmt += VoucherLine."Eligible Amount";
            UNTIL VoucherLine.NEXT = 0;


        IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

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
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";

        //BBG1.00 ALLEDK 070313
        //PHeader."Payment Method Code" := "Bank/G L Code";
        //PHeader."Bal. Account Type" := PaymentMethod."Bal. Account Type";
        //PHeader."Bal. Account No." := PaymentMethod."Bal. Account No.";
        IF NOT Rec."Create Invoice Only" THEN BEGIN      //BBG2.00
            PHeader."Payment Method Code" := FORMAT(Rec."Payment Mode");
            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN BEGIN
                PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"Bank Account";
                PHeader."Bal. Account No." := Rec."Bank/G L Code";
            END ELSE BEGIN
                PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"G/L Account";
                PHeader."Bal. Account No." := Rec."Bank/G L Code";
            END;
        END; //BBG2.00
        //BBG1.00 ALLEDK 070313

        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Cheque No." := Rec."Cheque No.";
        PHeader."Cheque Date" := Rec."Cheque Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission;
        PHeader.Approved := TRUE;
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
        IF NOT Rec."Create Invoice Only" THEN      //BBG2.00
            PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction");
        PLine.INSERT;

        IF NOT Rec."Create Invoice Only" THEN BEGIN      //BBG2.00
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
        MESSAGE('Document has been posted successfully');
        //150213
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
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                Amt2 += VoucherLine.Amount;
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
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);
        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        IF NOT Rec."Create Invoice Only" THEN BEGIN      //BBG2.00
            PHeader."Payment Method Code" := FORMAT(Rec."Payment Mode");
            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN BEGIN
                PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"Bank Account";
                PHeader."Bal. Account No." := Rec."Bank/G L Code";
            END ELSE BEGIN
                PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"G/L Account";
                PHeader."Bal. Account No." := Rec."Bank/G L Code";
            END;
        END;  //BBG2.00

        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Cheque No." := Rec."Cheque No.";
        PHeader."Cheque Date" := Rec."Cheque Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::CommAndTA;
        PHeader.Approved := TRUE;
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
            IF NOT Rec."Create Invoice Only" THEN       //BBG2.00
                PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
            PLine.INSERT;
            IF NOT Rec."Create Invoice Only" THEN BEGIN      //BBG2.00
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
        MESSAGE('Document has been posted successfully');
    end;


    procedure PostIncentive()
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        EligibleAmt := 0;
        Amt1 := 0;
        EligibleAmt1 := 0;
        Club9ChargesAmt2 := 0;

        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        VoucherLine.SETRANGE(Type, VoucherLine.Type::Incentive);
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                IF VoucherLine."Incentive Type" = VoucherLine."Incentive Type"::Direct THEN BEGIN
                    EligibleAmt += VoucherLine."Eligible Amount";
                    Amt1 += VoucherLine.Amount;
                END ELSE IF VoucherLine."Incentive Type" = VoucherLine."Incentive Type"::Team THEN BEGIN
                    EligibleAmt1 += VoucherLine."Eligible Amount";
                END;
                Amt2 += VoucherLine.Amount;
                Club9ChargesAmt2 += VoucherLine."Clube 9 Charge Amount";
            UNTIL VoucherLine.NEXT = 0;


        IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

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
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);

        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        IF NOT Rec."Create Invoice Only" THEN BEGIN      //BBG2.00
            PHeader."Payment Method Code" := FORMAT(Rec."Payment Mode");
            IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN BEGIN
                PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"Bank Account";
                PHeader."Bal. Account No." := Rec."Bank/G L Code";
            END ELSE BEGIN
                PHeader."Bal. Account Type" := PHeader."Bal. Account Type"::"G/L Account";
                PHeader."Bal. Account No." := Rec."Bank/G L Code";
            END;
        END;      //BBG2.00
        //BBG1.00 ALLEDK 070313

        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Cheque No." := Rec."Cheque No.";
        PHeader."Cheque Date" := Rec."Cheque Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Incentive;
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
        IF NOT Rec."Create Invoice Only" THEN       //BBG2.00
            PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction INCT");
        PLine.INSERT;

        IF NOT Rec."Create Invoice Only" THEN BEGIN      //BBG2.00
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

        MESSAGE('Document has been posted successfully');
    end;


    procedure PostTA1()
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        Club9ChargesAmt2 := 0;
        EligibleAmt := 0;
        BondSetup.GET;
        Club9Post := 0;

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
        Unitsetup.TESTFIELD("Posting Voucher No. Series");



        IF ABS(Rec."Advance Amount") < Amt2 THEN
            Club9Post := ((Amt2 - ABS(Rec."Advance Amount")) * Unitsetup."Corpus %" / 100)
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


        //BBG1.00 ALLEDK 070313

        //IF PaymentMethod.GET("Bank/G L Code") THEN BEGIN
        //  IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"G/L Account" THEN
        //    IF GLAccount.GET(PaymentMethod."Bal. Account No.") THEN
        //      GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");
        //END;


        IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN BEGIN
            IF GLAccount.GET(Rec."Bank/G L Code") THEN
                GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");
        END;
        //BBG1.00 ALLEDK 070313

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");

        IF Amt2 > ABS(Rec."Advance Amount") THEN BEGIN
            IF PaymentMethod.GET(Rec."Bank/G L Code") THEN;

            CalcTDSPercentage;
            TDSAmt2 := (Amt2) * TDSPercentage / 100;

            IF Rec."Net Elig." < 0 THEN BEGIN

                DBAmt := ABS(Rec."Net Elig.");

                //DBAmt := (Amt2-ABS("Advance Amount")-((Amt2-ABS("Advance Amount"))*TDSPercentage/100)
                //-((Amt2-ABS("Advance Amount"))*Unitsetup."Corpus %"/100));//14


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
                    //GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";// Code commented:AD 100613
                END ELSE BEGIN
                    GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";
                END;

                IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                    DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

                GenJnlLine."Document No." := DocNo;
                GenJnlLine."Line No." := LineNo2;
                GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", Rec."Paid To");
                GenJnlLine.VALIDATE("Debit Amount", ROUND(DBAmt, 1));
                GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::"Travel Allowance");
                IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account")
                ELSE
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", Rec."Bank/G L Code");
                GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                GenJnlLine."External Document No." := Rec."Document No.";
                GenJnlLine."Cheque No." := Rec."Cheque No.";
                GenJnlLine."Cheque Date" := Rec."Cheque Date";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Branch Code" := UserSetup."User Branch";  //180113
                IF Rec."Payment Mode" <> Rec."Payment Mode"::Bank THEN
                    GenJnlLine.VALIDATE("Bal. Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::Purchase);  //140213
                GenJnlLine.INSERT;
                CLEAR(GenJnlPostLine);
                InsertJnlDimension(GenJnlLine); //ALLEDK 010213
                GenJnlPostLine.RunWithCheck(GenJnlLine);  //ALLEDK 010213
                                                          //  GenJnlPostLine.RUN(GenJnlLine);  //ALLEDK 010213
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
        GLEntry.SETRANGE("External Document No.", Rec."Document No.");
        IF GLEntry.FINDFIRST THEN;
        //BBG2.0 250714


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);

        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::"Travel Allowance";
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission; //BBG2.0 250714
        PHeader."Applies-to Doc. Type" := PHeader."Applies-to Doc. Type"::Payment;   //BBG2.0 250714

        PHeader.Approved := TRUE;
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
        IF ABS(Rec."Advance Amount") < Amt2 THEN BEGIN
            PLine."Detect TDS Amount" := ABS(Rec."Advance Amount");
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
        Unitsetup.TESTFIELD("Posting Voucher No. Series");

        Club9Post := 0;

        IF ABS(Rec."Advance Amount") < Amt2 THEN
            Club9Post := ((Amt2 - ABS(Rec."Advance Amount")) * Unitsetup."Corpus %" / 100)
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

        //BBG1.00 ALLEDK 070313
        //  IF PaymentMethod.GET("Bank/G L Code") THEN BEGIN
        //    PaymentMethod.TESTFIELD("Bal. Account No.");  //ALALEDK 030313
        //    IF GLAccount.GET("Bank/G L Code") THEN
        //      GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");
        //  END;

        IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN BEGIN
            IF GLAccount.GET(Rec."Bank/G L Code") THEN
                GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");
        END;
        //BBG1.00 ALLEDK 070313


        IF Location.GET(Rec."Shortcut Dimension 1 Code") THEN
            Location.TESTFIELD(Location."T.A.N. No.");



        CalcTDSPercentage;
        TDSAmt2 := Amt2 * TDSPercentage / 100;



        DBAmt := 0;
        IF Rec."Advance Amount" > 0 THEN BEGIN
            IF Rec."Net Elig." < 0 THEN BEGIN
                //DBAmt := (Amt2-ABS("Advance Amount"))-((Amt2-ABS("Advance Amount"))*TDSPercentage/100)
                //-((Amt2-ABS("Advance Amount"))*Unitsetup."Corpus %"/100);//14

                DBAmt := ABS(Rec."Net Elig.");

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
                    // GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";
                END ELSE BEGIN
                    GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";

                END;

                IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                    DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

                GenJnlLine."Document No." := DocNo;
                GenJnlLine."Line No." := LineNo2;
                GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", Rec."Paid To");
                GenJnlLine.VALIDATE("Debit Amount", ROUND(DBAmt, 1));
                GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Commission);
                IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account")
                ELSE
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");

                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", Rec."Bank/G L Code");
                GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                GenJnlLine."External Document No." := Rec."Document No.";
                GenJnlLine."Cheque No." := Rec."Cheque No.";
                GenJnlLine."Cheque Date" := Rec."Cheque Date";
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Branch Code" := UserSetup."User Branch";  //180113
                IF Rec."Payment Mode" <> Rec."Payment Mode"::Bank THEN
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
        GLEntry.SETRANGE("External Document No.", Rec."Document No.");
        IF GLEntry.FINDFIRST THEN;
        //BBG2.0 250714

        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);

        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission; //BBG2.0 250714
        PHeader."Applies-to Doc. Type" := PHeader."Applies-to Doc. Type"::Payment;   //BBG2.0 250714
        PHeader."Applies-to Doc. No." := GLEntry."Document No.";

        PHeader.Approved := TRUE;
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
        IF ABS(Rec."Advance Amount") < Amt2 THEN BEGIN
            PLine."Detect TDS Amount" := ABS(Rec."Advance Amount");
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
        Club9Post := ((Amt2 - ABS(Rec."Advance Amount")) * Unitsetup."Corpus %" / 100);

        IF GLAccount.GET(Unitsetup."Commission A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Travel A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF GLAccount.GET(Unitsetup."Corpus A/C") THEN
            GLAccount.TESTFIELD(GLAccount."Gen. Prod. Posting Group");

        IF Location.GET(UserSetup."Responsibility Center") THEN
            Location.TESTFIELD(Location."T.A.N. No.");

        Amt3 := Amt2;

        CalcTDSPercentage;

        TDSAmt2 := Amt3 * TDSPercentage / 100;


        DBAmt := 0;
        IF Amt3 > ABS(Rec."Advance Amount") THEN BEGIN

            IF Rec."Net Elig." < 0 THEN BEGIN

                DBAmt := ABS(Rec."Net Elig.");
                //DBAmt := (Amt3-ABS("Advance Amount"))-((Amt3-ABS("Advance Amount"))*TDSPercentage/100)
                //-((Amt3-ABS("Advance Amount"))*Unitsetup."Corpus %"/100);//14


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
                    // GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";
                END ELSE BEGIN
                    GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";
                    GenJnlLine.VALIDATE("Bal. Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::Purchase);  //140213
                END;

                IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                    DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

                GenJnlLine."Document No." := DocNo;
                GenJnlLine."Line No." := LineNo2;
                GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", Rec."Paid To");
                GenJnlLine.VALIDATE("Debit Amount", DBAmt);
                GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::CommAndTA);
                IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account")
                ELSE
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", Rec."Bank/G L Code");
                GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                GenJnlLine."External Document No." := Rec."Document No.";
                GenJnlLine."Cheque No." := Rec."Cheque No.";
                GenJnlLine."Cheque Date" := Rec."Cheque Date";
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
        GLEntry.SETRANGE("External Document No.", Rec."Document No.");
        IF GLEntry.FINDFIRST THEN;
        //BBG2.0 250714



        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);

        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission; //BBG2.0 250714
        PHeader."Applies-to Doc. Type" := PHeader."Applies-to Doc. Type"::Payment;   //BBG2.0 250714
        PHeader.Approved := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::CommAndTA;
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
            IF ABS(Rec."Advance Amount") < Amt3 THEN BEGIN
                PLine.VALIDATE("TDS Section Code", Unitsetup."TDS Nature of Deduction TA");
                PLine."Detect TDS Amount" := ABS(Rec."Advance Amount");
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

        MESSAGE('Document has been posted successfully');
    end;


    procedure PostIncentive1()
    begin
        Amt2 := 0;
        TDSAmt2 := 0;
        EligibleAmt := 0;
        Club9Post := 0;
        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
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


        IF ABS(Rec."Advance Amount") < Amt2 THEN
            Club9Post := ((Amt2 - ABS(Rec."Advance Amount")) * Unitsetup."Incentive Club 9%" / 100)
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



        CalcTDSPercentage;

        TDSAmt2 := Amt2 * TDSPercentage / 100;


        DBAmt := 0;
        //IF Amt2 > ABS("Advance Amount") THEN BEGIN
        IF Rec."Advance Amount" > 0 THEN BEGIN

            IF Rec."Net Elig." < 0 THEN BEGIN
                //DBAmt := (Amt2-ABS("Advance Amount"))-((Amt2-ABS("Advance Amount"))*TDSPercentage/100)
                //-((Amt2-ABS("Advance Amount"))*Unitsetup."Incentive Club 9%"/100);//14

                DBAmt := ABS(Rec."Net Elig.");

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
                    // GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";
                END ELSE BEGIN
                    GenJnlLine."Journal Template Name" := Unitsetup."Cash Voucher Template Name";
                    GenJnlLine."Journal Batch Name" := Unitsetup."Cash Voucher Batch Name";
                END;

                IF GenJnlBatch.GET(Unitsetup."Bank Voucher Template Name", Unitsetup."Bank Voucher Batch Name") THEN
                    DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

                GenJnlLine."Document No." := DocNo;
                GenJnlLine."Line No." := LineNo2;
                GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", Rec."Paid To");
                GenJnlLine.VALIDATE("Debit Amount", DBAmt);
                GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Incentive);
                IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account")
                ELSE
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", Rec."Bank/G L Code");
                GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                GenJnlLine."External Document No." := Rec."Document No.";
                GenJnlLine."Cheque No." := Rec."Cheque No.";
                GenJnlLine."Cheque Date" := Rec."Cheque Date";
                GenJnlLine."Branch Code" := UserSetup."User Branch";  //180113
                GenJnlLine."System-Created Entry" := TRUE;
                IF Rec."Payment Mode" <> Rec."Payment Mode"::Bank THEN
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
        GLEntry.SETRANGE("External Document No.", Rec."Document No.");
        IF GLEntry.FINDFIRST THEN;
        //BBG2.0 250714


        PHeader.INIT;
        PHeader."Document Type" := PHeader."Document Type"::Invoice;
        PHeader."No." := Rec."Document No.";
        PHeader.INSERT;

        PHeader.VALIDATE("Buy-from Vendor No.", Rec."Paid To");
        PHeader.VALIDATE("Posting Date", Rec."Posting Date");
        PHeader.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Responsibility Center");
        IF Dim2Code <> '' THEN
            PHeader.VALIDATE("Shortcut Dimension 2 Code", Dim2Code);

        PHeader."Posting No. Series" := Unitsetup."Posting Voucher No. Series";
        PHeader."User Branch" := UserSetup."User Branch";  //180113
        PHeader.CommissionVoucher := TRUE; //180113
        PHeader."Vendor Invoice No." := Rec."Document No.";
        PHeader."Vendor Invoice Date" := Rec."Posting Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Incentive;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission; //BBG2.0 250714
        PHeader."Applies-to Doc. Type" := PHeader."Applies-to Doc. Type"::Payment;   //BBG2.0 250714
        PHeader.Approved := TRUE;
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
        IF ABS(Rec."Advance Amount") < Amt2 THEN BEGIN
            PLine."Detect TDS Amount" := ABS(Rec."Advance Amount");
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
        IF Vendor.Get(Rec."Paid To") Then begin
            AllowedSection.Reset();
            AllowedSection.SetRange("Vendor No", Vendor."No.");
            AllowedSection.SetRange("TDS Section", TDSCode);
            IF AllowedSection.FindFirst() then begin
                TDSPercentage := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
            end;
        end;
        /*
                IF RecNODHeader.GET(RecNODHeader.Type::Vendor, Rec."Paid To") THEN;

                IF Vendor.GET(Rec."Paid To") THEN;
                Unitsetup.GET;
                TDSSetup.RESET;
                TDSSetup.SETRANGE("TDS Nature of Deduction", TDSCode);
                IF PHeader."Assessee Code" = '' THEN
                    TDSSetup.SETRANGE("Assessee Code", RecNODHeader."Assesse Code") //24
                ELSE
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


    procedure InsertDocumentDimension(RecPHeader: Record "Purchase Header")
    begin
        //BBG1.00 ALLEDK 070313
        /*
        GLSetup.GET;
        UserSetup.GET(USERID);
        DocumentDimension.DELETEALL;
        DocumentDimension.INIT;
        DocumentDimension."Table ID" :=38;
        DocumentDimension."Document Type" :=DocumentDimension."Document Type"::Invoice;;
        DocumentDimension."Document No." :="Document No.";
        DocumentDimension."Line No." :=0;
        DocumentDimension."Dimension Code" :=GLSetup."Shortcut Dimension 3 Code";
        DocumentDimension."Dimension Value Code" := UserSetup."User Branch";
        DocumentDimension.INSERT;
         */
        //BBG1.00 ALLEDK 070313

    end;


    procedure InsertJnlDimension(RecGenLine: Record "Gen. Journal Line")
    begin
        // ALLE MM Code Commented
        /*
        GLSetup.GET;
        UserSetup.GET(USERID);
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

    end;


    procedure BalAmount()
    begin
        TDS := 0;
        Unitsetup.GET;
        PaidComm := 0;
        PaidTA := 0;
        PaidTDS := 0;
        PaidClub := 0;
        GrossAmount := 0;
        AdvTDS := 0;
        AdvClub := 0;
        InvAmount := 0;
        OpenAdvAmt := 0;
        OpAmt := 0;
        TotalInvAmount := 0;
        Rec."Total Elig. Incl Opening" := 0;
        Rec."Payable Amount (Incl. OP+Dir)" := 0;
        Rec."Total Deduction (Incl TA Rev)" := 0;
        Rec."Total Elig. Incl. Opening" := 0;
        Rec."Total Elig. Excl. Opening" := 0;
        Rec."Total Club 9" := 0;
        Rec."Total TDS" := 0;
        Rec."Net Elig." := 0;
        Rec."Opening Bal. Rem" := 0;
        Rec."Net Balance" := 0;
        Rec."Total Comm/TA Amount" := 0;
        Rec."Rem. Direct Inv Amt" := 0;
        Rec."Rem. Opening Inv Amt" := 0;


        //210513

        OpenAmt2 := 0;
        OpenAmt3 := 0;
        CLEAR(VLEntry);
        VLEntry.RESET;
        VLEntry.SETCURRENTKEY(VLEntry."Vendor No.", "Posting Date");
        VLEntry.SETRANGE("Vendor No.", Rec."Paid To");
        VLEntry.SETRANGE("Posting Date", 20130228D);
        VLEntry.SETFILTER("Posting Type", '<>%1', VLEntry."Posting Type"::Incentive);
        IF VLEntry.FINDSET THEN
            REPEAT
                VLEntry.CALCFIELDS(VLEntry."Remaining Amt. (LCY)");
            //    OpenAmt2 := OpenAmt2 + VLEntry."Remaining Amt. (LCY)";
            UNTIL VLEntry.NEXT = 0;

        CLEAR(VLEntry);
        VLEntry.RESET;
        VLEntry.SETCURRENTKEY(VLEntry."Vendor No.", "Posting Date");
        VLEntry.SETRANGE("Vendor No.", Rec."Paid To");
        VLEntry.SETRANGE("Posting Date", 20130301D, TODAY);
        VLEntry.SETRANGE("Document Type", VLEntry."Document Type"::Invoice);
        VLEntry.SETRANGE("ARM Invoice", FALSE);
        VLEntry.SETFILTER("Posting Type", '<>%1', VLEntry."Posting Type"::Incentive);
        IF VLEntry.FINDSET THEN
            REPEAT
                VLEntry.CALCFIELDS(VLEntry."Remaining Amt. (LCY)");
                OpenAmt3 := OpenAmt3 + VLEntry."Remaining Amt. (LCY)";
            UNTIL VLEntry.NEXT = 0;




        CLEAR(CorrTrvlPmt);
        CLEAR(TrvlPmt);
        TrvlPmt.RESET;
        TrvlPmt.SETRANGE("Sub Associate Code", Rec."Paid To");
        TrvlPmt.SETRANGE("Creation Date", 0D, TODAY);
        TrvlPmt.SETRANGE(Approved, TRUE);
        TrvlPmt.SETRANGE(Reverse, TRUE);
        TrvlPmt.SETRANGE(CreditMemo, FALSE);
        IF TrvlPmt.FINDFIRST THEN
            REPEAT
                CorrTrvlPmt := CorrTrvlPmt + TrvlPmt."Amount to Pay";
            UNTIL TrvlPmt.NEXT = 0;

        TrvlPmt1 := 0;
        CLEAR(TrvlPmt);
        TrvlPmt.RESET;
        TrvlPmt.SETRANGE("Sub Associate Code", Rec."Paid To");
        TrvlPmt.SETRANGE("Creation Date", 0D, TODAY);
        TrvlPmt.SETRANGE(Approved, TRUE);
        TrvlPmt.SETRANGE(Reverse, FALSE);
        TrvlPmt.SETRANGE(CreditMemo, FALSE);
        IF TrvlPmt.FINDFIRST THEN
            REPEAT
                TrvlPmt1 := TrvlPmt1 + TrvlPmt."Amount to Pay";
            UNTIL TrvlPmt.NEXT = 0;



        Unitsetup.GET;

        TDS := PostPayment.CalculateTDSPercentage(Rec."Paid To", Unitsetup."TDS Nature of Deduction", '');


        VoucherHdr.RESET;
        VoucherHdr.SETRANGE("Paid To", Rec."Paid To");
        VoucherHdr.SETRANGE("Posting Date", 0D, TODAY);
        VoucherHdr.SETRANGE(Post, TRUE);
        IF VoucherHdr.FINDSET THEN
            REPEAT
                VoucherLine.RESET;
                VoucherLine.SETRANGE("Voucher No.", VoucherHdr."Document No.");
                IF VoucherLine.FINDSET THEN
                    REPEAT
                        IF VoucherLine.Type = VoucherLine.Type::Commission THEN BEGIN
                            PaidComm := PaidComm + VoucherLine.Amount;
                        END ELSE IF VoucherLine.Type = VoucherLine.Type::TA THEN BEGIN
                            PaidTA := PaidTA + VoucherLine.Amount;
                        END;
                    //PaidTDS := PaidTDS +VoucherLine."TDS Amount";
                    // PaidClub := PaidClub + VoucherLine."Clube 9 Charge Amount";
                    UNTIL VoucherLine.NEXT = 0;
            UNTIL VoucherHdr.NEXT = 0;

        //GKG 15042014 start

        DirectPaidComm := 0;
        CLEAR(VoucherHdr);
        VoucherHdr.RESET;
        VoucherHdr.SETRANGE("Paid To", Rec."Paid To");
        VoucherHdr.SETRANGE("Posting Date", 0D, TODAY);
        VoucherHdr.SETRANGE(Post, TRUE);
        VoucherHdr.SETRANGE("Invoice Reversed", FALSE); //BBG2.50 080914
        VoucherHdr.SETRANGE("Sub Type", VoucherHdr."Sub Type"::Direct);
        IF VoucherHdr.FINDSET THEN
            REPEAT
                VoucherLine.RESET;
                VoucherLine.SETRANGE("Voucher No.", VoucherHdr."Document No.");
                IF VoucherLine.FINDSET THEN
                    REPEAT
                        IF VoucherLine.Type = VoucherLine.Type::Commission THEN BEGIN
                            DirectPaidComm := DirectPaidComm + VoucherLine.Amount;
                        END ELSE IF VoucherLine.Type = VoucherLine.Type::TA THEN BEGIN
                            DirectPaidComm := DirectPaidComm + VoucherLine.Amount;
                        END;
                    UNTIL VoucherLine.NEXT = 0;
            UNTIL VoucherHdr.NEXT = 0;

        // GKG 15042014 end

        VLEntry.RESET;
        VLEntry.SETRANGE("Posting Date", 20130301D, TODAY);
        VLEntry.SETRANGE("Vendor No.", Rec."Paid To");
        IF Rec.Type = Rec.Type::Incentive THEN
            VLEntry.SETRANGE("Posting Type", VLEntry."Posting Type"::Incentive)
        ELSE
            VLEntry.SETFILTER("Posting Type", '<>%1', VLEntry."Posting Type"::Incentive);
        IF VLEntry.FINDSET THEN
            REPEAT
                VLEntry.CALCFIELDS(VLEntry."Amount (LCY)");
                InvAmount := VLEntry."Amount (LCY)";
                TotalInvAmount := TotalInvAmount + InvAmount;
            UNTIL VLEntry.NEXT = 0;

        IF TotalInvAmount < 0 THEN
            TotalInvAmount := 0;


        InvAmount1 := 0;
        TotalInvAmount1 := 0;



        VLEntry.RESET;
        VLEntry.SETRANGE("Posting Date", 20130301D, TODAY);
        VLEntry.SETRANGE("Vendor No.", Rec."Paid To");
        VLEntry.SETRANGE("Document Type", VLEntry."Document Type"::Invoice);
        VLEntry.SETRANGE("ARM Invoice", FALSE);
        IF Rec.Type = Rec.Type::Incentive THEN
            VLEntry.SETRANGE("Posting Type", VLEntry."Posting Type"::Incentive)
        ELSE
            VLEntry.SETFILTER("Posting Type", '<>%1', VLEntry."Posting Type"::Incentive);
        IF VLEntry.FINDSET THEN
            REPEAT
                VLEntry.CALCFIELDS(VLEntry."Amount (LCY)");
                InvAmount1 := VLEntry."Amount (LCY)";
                TotalInvAmount1 := TotalInvAmount1 + InvAmount1;
            UNTIL VLEntry.NEXT = 0;



        CLEAR(Clb91);
        CLEAR(TClb91);
        TotalPayment := 0;
        Unitsetup.GET;

        CLEAR(VLEntry);
        VLEntry.RESET;
        VLEntry.SETCURRENTKEY("Document Type", "Vendor No.", "Posting Date");
        VLEntry.SETFILTER("Document Type", '%1|%2|%3|%4', VLEntry."Document Type"::Payment, VLEntry."Document Type"::"Credit Memo",
                             VLEntry."Document Type"::Refund, VLEntry."Document Type"::" ");
        VLEntry.SETRANGE("Vendor No.", Rec."Paid To");
        VLEntry.SETRANGE("Posting Date", 20130301D, TODAY);
        IF Rec.Type = Rec.Type::Incentive THEN
            VLEntry.SETRANGE("Posting Type", VLEntry."Posting Type"::Incentive)
        ELSE
            VLEntry.SETFILTER("Posting Type", '<>%1', VLEntry."Posting Type"::Incentive);
        IF VLEntry.FINDSET THEN
            REPEAT
                CLEAR(TDSAmt);
                CLEAR(Clb91);
                TDSE.RESET;
                TDSE.SETRANGE("Document No.", VLEntry."Document No.");
                TDSE.SETRANGE("Posting Date", VLEntry."Posting Date");
                TDSE.SETRANGE("Party Code", VLEntry."Vendor No.");
                IF TDSE.FINDFIRST THEN BEGIN
                    TDSAmt := TDSE."Total TDS Including SHE CESS";
                    IF (VLEntry."Document Type" = VLEntry."Document Type"::Payment) AND (VLEntry.Reversed) AND (NOT VLEntry.Positive) THEN
                        TDSAmt := -TDSE."Total TDS Including SHE CESS";
                    // TTdsAmt := TTdsAmt + TDSAmt;
                END ELSE BEGIN
                    IF VLEntry."External Document No." <> '' THEN BEGIN
                        CLEAR(GLE);
                        GLE.RESET;
                        GLE.SETCURRENTKEY("Document No.", "Posting Date");
                        GLE.SETFILTER("Document No.", '<>%1', VLEntry."Document No.");
                        GLE.SETRANGE("Posting Date", 20130301D, TODAY);
                        //GLE.SETFILTER("Bal. Account Type",'%1',GLE."Bal. Account Type"::Vendor);
                        // GLE.SETRANGE("Bal. Account No.","Paid To");
                        GLE.SETRANGE("External Document No.", VLEntry."External Document No.");
                        IF GLE.FINDFIRST THEN BEGIN
                            CLEAR(TDSE);
                            TDSE.RESET;
                            TDSE.SETRANGE("Document No.", GLE."Document No.");
                            TDSE.SETRANGE("Posting Date", GLE."Posting Date");
                            IF TDSE.FINDFIRST THEN BEGIN
                                TDSAmt := TDSE."TDS Amount";
                                IF (VLEntry."Document Type" = VLEntry."Document Type"::Payment) AND (VLEntry.Reversed) AND (NOT VLEntry.Positive) THEN
                                    TDSAmt := -TDSE."TDS Amount";
                                //      TTdsAmt := TTdsAmt + TDSAmt;
                            END;
                            CLEAR(GLE1);
                            CLEAR(Clb91);
                            GLE1.RESET;
                            GLE1.SETCURRENTKEY("Document No.", "Posting Date");
                            GLE1.SETRANGE("Document No.", GLE."Document No.");
                            GLE1.SETRANGE("Posting Date", GLE."Posting Date");
                            //GLE1.SETRANGE("Posting Date",010313D,TODAY);
                            GLE1.SETRANGE("G/L Account No.", Unitsetup."Corpus A/C");
                            IF GLE1.FINDFIRST THEN BEGIN
                                Clb91 := GLE1."Credit Amount";
                                IF (VLEntry."Document Type" = VLEntry."Document Type"::Payment) AND (VLEntry.Reversed) AND (NOT VLEntry.Positive) THEN
                                    Clb91 := -GLE1."Credit Amount";
                                // TClb91 := TClb91 + Clb91;
                            END;
                        END;
                    END;
                END;

                CLEAR(ChLE);
                CLEAR(BAMT);
                BLE.RESET;
                BLE.SETRANGE("Document No.", VLEntry."Document No.");
                BLE.SETRANGE("Transaction No.", VLEntry."Transaction No.");
                IF BLE.FINDFIRST THEN BEGIN
                    BAMT := BLE."Credit Amount";
                    //ALLETDK021213>>>>
                    IF VLEntry."Document Type" = VLEntry."Document Type"::Refund THEN
                        BAMT := -BLE."Debit Amount";
                    //ALLETDK021213<<
                    IF BAMT = 0 THEN BEGIN
                        ChLE.RESET;
                        ChLE.SETRANGE("Document No.", VLEntry."Document No.");
                        ChLE.SETRANGE("Check No.", BLE."Cheque No.");
                        ChLE.SETRANGE("Entry Status", ChLE."Entry Status"::"Financially Voided");
                        IF ChLE.FINDFIRST THEN BEGIN
                            BAMT := -BLE."Debit Amount";
                            Clb91 := -Clb91;
                            TDSAmt := -TDSAmt;
                        END;
                    END;
                END ELSE BEGIN
                    CLEAR(BAMT);
                    CLE.RESET;
                    CLE.SETRANGE("Document No.", VLEntry."Document No.");
                    CLE.SETRANGE("Transaction No.", VLEntry."Transaction No.");
                    IF CLE.FINDFIRST THEN BEGIN
                        CLE.CALCFIELDS("Credit Amount");
                        BAMT := CLE."Credit Amount";
                    END;
                    IF BAMT = 0 THEN BEGIN
                        CLEAR(BAMT);
                        GLE.RESET;
                        GLE.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                        GLE.SETRANGE("Document No.", VLEntry."Document No.");
                        GLE.SETRANGE("Bal. Account Type", GLE."Bal. Account Type"::Vendor);
                        GLE.SETRANGE("Bal. Account No.", Rec."Paid To");
                        GLE.SETRANGE("Transaction No.", VLEntry."Transaction No.");
                        IF GLE.FINDFIRST THEN
                            BAMT := -GLE.Amount;
                    END;
                    //ALLETDK120913>>>
                    IF BAMT = 0 THEN BEGIN
                        CLEAR(BAMT);
                        GLE.RESET;
                        GLE.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                        GLE.SETRANGE("Document No.", VLEntry."Document No.");
                        GLE.SETRANGE("Source Type", GLE."Source Type"::Vendor);
                        GLE.SETRANGE("Source No.", Rec."Paid To");
                        GLE.SETRANGE("Transaction No.", VLEntry."Transaction No.");
                        IF GLE.FINDFIRST THEN
                            BAMT := GLE.Amount;
                    END;
                    //ALLETDK120913<<<

                END;
                TClb91 := TClb91 + Clb91;
                TTdsAmt := TTdsAmt + TDSAmt;

                Unitsetup.GET;
                CLEAR(CLB9);
                "G/LE".RESET;
                "G/LE".SETCURRENTKEY("Document No.", "Posting Date", Amount);
                "G/LE".SETRANGE("Document No.", VLEntry."Document No.");
                "G/LE".SETRANGE("Posting Date", VLEntry."Posting Date");
                "G/LE".SETFILTER(Amount, '<%1', 0);
                "G/LE".SETRANGE("G/L Account No.", Unitsetup."Corpus A/C");
                IF "G/LE".FINDFIRST THEN BEGIN
                    CLB9 := "G/LE"."Credit Amount";
                    IF (VLEntry."Document Type" = VLEntry."Document Type"::Payment) AND (VLEntry.Reversed) AND (NOT VLEntry.Positive) THEN BEGIN
                        CLB9 := -"G/LE"."Credit Amount";
                        IF ChLE."Document No." = VLEntry."Document No." THEN
                            CLB9 := -CLB9;
                        TClb9 := TClb9 + CLB9;
                    END;
                END;

                TotalPayment := TotalPayment + BAMT + CLB9 + Clb91 + TDSAmt;


            UNTIL VLEntry.NEXT = 0;

        //---------------------For Opening-------------START------------------
        CLEAR(TTDSO);
        CLEAR(TopAmt);
        CLEAR(TCLBO);

        CLEAR(VLEntry);
        VLEntry.RESET;
        VLEntry.SETRANGE("Posting Date", 0D, 20130228D);
        VLEntry.SETRANGE("Vendor No.", Rec."Paid To");//1705
        VLEntry.SETRANGE(Reversed, FALSE);
        IF VLEntry.FINDSET THEN BEGIN
            REPEAT
                CLEAR(OpAmt);
                GLE2.RESET;
                GLE2.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                GLE2.SETRANGE("Document No.", VLEntry."Document No.");
                GLE2.SETRANGE("Bal. Account Type", GLE2."Bal. Account Type"::Vendor);
                GLE2.SETRANGE("Bal. Account No.", VLEntry."Vendor No.");
                GLE2.SETRANGE("Transaction No.", VLEntry."Transaction No.");
                IF GLE2.FINDFIRST THEN BEGIN
                    OpAmt := -GLE2.Amount;
                    TopAmt += OpAmt;
                END;
                //----------------TDS And Club9 From 010313 to Before Start Date---------Start----------
                CLEAR(TDSO);
                TDSE2.RESET;
                TDSE2.SETRANGE("Document No.", VLEntry."Document No.");
                IF TDSE2.FINDFIRST THEN BEGIN
                    TDSO := TDSE2."Total TDS Including SHE CESS";
                    TTDSO += TDSO;
                END;
                Unitsetup.GET;
                CLEAR(clbo);
                GLE3.RESET;
                GLE3.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                GLE3.SETRANGE("Document No.", VLEntry."Document No.");
                //GLE3.SETRANGE("Posting Date",010313D,010313D-1);//ALLECK 160513
                GLE3.SETFILTER(Amount, '<%1', 0);
                GLE3.SETRANGE("Posting Date", VLEntry."Posting Date");
                GLE3.SETRANGE("G/L Account No.", Unitsetup."Corpus A/C");
                IF GLE3.FINDFIRST THEN BEGIN
                    clbo := GLE3."Credit Amount";
                    TCLBO += clbo;
                END;
                //----------------TDS And Club9 From 010313 to Before Start Date-----------END--------
                TotalPayment := TotalPayment + TDSO + clbo;

            UNTIL VLEntry.NEXT = 0;
        END;

        CLEAR(VLE);
        PSAmt1 := 0;
        PSAmt := 0;
        Pamt := 0;
        VLE.RESET;
        VLE.SETRANGE("Posting Date", 0D, 20130228D);
        VLE.SETRANGE("Vendor No.", Rec."Paid To");
        IF Rec.Type = Rec.Type::Incentive THEN
            VLE.SETRANGE("Posting Type", VLE."Posting Type"::Incentive)
        ELSE
            VLE.SETFILTER("Posting Type", '<>%1', VLE."Posting Type"::Incentive);
        IF VLE.FINDSET THEN BEGIN
            REPEAT
                VLE.CALCFIELDS("Original Amt. (LCY)");
                Pamt += VLE."Original Amt. (LCY)";
            UNTIL VLE.NEXT = 0;
            IF Pamt > 0 THEN BEGIN
                PSAmt := Pamt;
                PTDS := PSAmt * 10 / 100;
                PCLB := PSAmt * 1 / 100;
            END ELSE
                PSAmt1 := Pamt;
            NopAmt := PSAmt - PTDS - PCLB;
        END;

        PAmt2 := 0;
        PSAmt2 := 0;

        CLEAR(VLE);
        VLE.RESET;
        VLE.SETRANGE("Posting Date", 0D, 20130228D);
        VLE.SETRANGE("Vendor No.", Rec."Paid To");
        VLE.SETFILTER("Posting Type", '<>%1', VLE."Posting Type"::Incentive);
        IF VLE.FINDSET THEN BEGIN
            REPEAT
                VLE.CALCFIELDS("Remaining Amt. (LCY)");
                PAmt2 += VLE."Remaining Amt. (LCY)";
            UNTIL VLE.NEXT = 0;
            IF Pamt < 0 THEN
                PSAmt2 := PAmt2;
        END;



        TotalPayment := TotalPayment + PSAmt;

        CLEAR(CommAmt);
        CLEAR(ElgiblBSP2);
        CLEAR(CommEntry);
        CLEAR(TCommAmt);
        CLEAR(TotalTAAmt);
        APPCode := '';
        AHWZpplication.RESET;
        AHWZpplication.SETRANGE("Associate Code", Rec."Paid To");
        AHWZpplication.SETRANGE(Status, AHWZpplication.Status::Active); //BBG2.02  210814
        IF AHWZpplication.FINDSET THEN
            REPEAT
                //IF APPCode <> AHWZpplication."Application Code" THEN BEGIN     //BBG2.02  210814
                //  APPCode := AHWZpplication."Application Code";
                TRVlAmt := 0;
                CommEntry.RESET;
                CommEntry.SETCURRENTKEY("Associate Code", "Application No.", "Posting Date");
                CommEntry.SETRANGE("Associate Code", Rec."Paid To");
                CommEntry.SETRANGE("Application No.", AHWZpplication."Application Code");
                CommEntry.SETRANGE("Posting Date", 0D, TODAY);
                CommEntry.SETRANGE(Discount, FALSE);
                CommEntry.SETRANGE("Opening Entries", FALSE);
                IF CommEntry.FINDSET THEN
                    REPEAT
                        RecConforder.RESET;
                        RecConforder.GET(CommEntry."Application No.");
                        IF (CommEntry."Direct to Associate" = FALSE) THEN BEGIN
                            TCommAmt := TCommAmt + CommEntry."Commission Amount";
                            CommAmt := CommAmt + CommEntry."Commission Amount";
                        END;
                        IF (CommEntry."Direct to Associate") AND (NOT CommEntry."Remaining Amt of Direct")
                         AND (NOT RecConforder."Registration Bonus Hold(BSP2)") THEN BEGIN
                            ElgiblBSP2 := ElgiblBSP2 + CommEntry."Commission Amount";
                            CommAmt := CommAmt + CommEntry."Commission Amount";
                            TCommAmt := TCommAmt + CommEntry."Commission Amount";
                        END;
                    UNTIL CommEntry.NEXT = 0;
            // END; //BBG2.02  210814
            UNTIL AHWZpplication.NEXT = 0;
        CLEAR(TRVlAmt);
        CLEAR(TrvlPmt);
        TrvlPmt.RESET;
        TrvlPmt.SETRANGE("Sub Associate Code", Rec."Paid To");
        TrvlPmt.SETRANGE("Creation Date", 0D, EDate);
        TrvlPmt.SETRANGE(Approved, TRUE);
        TrvlPmt.SETRANGE(Reverse, FALSE);
        TrvlPmt.SETRANGE(CreditMemo, FALSE);
        IF TrvlPmt.FINDFIRST THEN
            REPEAT
                TRVlAmt := TRVlAmt + TrvlPmt."Amount to Pay";
            UNTIL TrvlPmt.NEXT = 0;

        TotalTAAmt := 0;
        TotalTAAmt := TotalTAAmt + TRVlAmt;

        Total := TCommAmt + TotalTAAmt;




        TotalDedect := 0;
        TotalTDSdedect := 0;
        TotalClubdedect := 0;
        TotalEligibility := 0;
        TotalDedect := (TotalInvAmount + TotalPayment - Total + PaidComm + PaidTA - CorrTrvlPmt);  //PSAmt1+
        TotalTDSdedect := -(TotalDedect * TDS / 100);
        TotalClubdedect := -(TotalDedect * Unitsetup."Corpus %" / 100);


        GrossAmount := ROUND(TotalDedect + TotalTDSdedect + TotalClubdedect, 1, '=');

        NetPayable1 := 0;

        //GKG 15042014 start
        //NetPayable1 := TotalInvAmount1-Total+ PSAmt1+TRVlAmt-TrvlPmt1;
        NetPayable1 := TotalInvAmount1 - Total - DirectPaidComm + PSAmt1 + TRVlAmt - TrvlPmt1;
        //GKG 15042014 end

        TotalEligibility := ROUND(TotalDedect, 1);
        TotalBal := 0;

        RemOpOpening := 0;

        //IF (PSAmt1)+(TotalInvAmount) <0 THEN
        //  RemOpOpening := (PSAmt1)+(TotalInvAmount);

        RemOpOpening := PSAmt2;
        /*
        IF (PSAmt1+TotalInvAmount) >0 THEN
          "Advance Amount" := PSAmt1+TotalInvAmount
        ELSE
         "Advance Amount" := 0;
        
        TDSAmt1 :=0;
        ClbAmt1 := 0;
        
        TDSAmt1 :=ABS((-1*("Payable Amount")+"Advance Amount")*TDS/100);
        ClbAmt1 := ABS((-1*("Payable Amount")+"Advance Amount")*Unitsetup."Corpus %"/100);
         */

        Rec."Total Comm/TA Amount" := HdrCommTA;

        TDSDedect := 0;
        ClubDedect := 0;

        TDSDedect := (-(Rec."Payable Amount") + NetPayable1 + (Rec."Eligible Amount") + TotalPayment + ABS(CorrTrvlPmt) - RemOpOpening +
                       HdrCommTA) * TDS / 100;
        ClubDedect := (-(Rec."Payable Amount") + NetPayable1 + (Rec."Eligible Amount") + TotalPayment + ABS(CorrTrvlPmt) +
                      HdrCommTA - RemOpOpening
        ) * Unitsetup."Corpus %" / 100;


        TotalBal := RemOpOpening +
        ((TotalPayment + ABS(CorrTrvlPmt) - ABS(NetPayable1) - RemOpOpening))
        - ((TotalPayment + ABS(CorrTrvlPmt) - ABS(NetPayable1) - RemOpOpening) * TDS / 100)
        - ((TotalPayment + ABS(CorrTrvlPmt) - ABS(NetPayable1) - RemOpOpening) * Unitsetup."Corpus %" / 100);

        NetELEG := 0;
        NetELEG := -(Rec."Payable Amount") + NetPayable1 + (Rec."Eligible Amount") + TotalPayment + ABS(CorrTrvlPmt) - RemOpOpening +
                  HdrCommTA - TDSDedect -
                  ClubDedect;


        NetElegwithTDSClb := 0;
        NetElegwithTDSClb := -(Rec."Payable Amount") + NetPayable1 + (Rec."Eligible Amount") + TotalPayment + ABS(CorrTrvlPmt) - RemOpOpening +
                            HdrCommTA;

        Rec."Total Elig. Incl Opening" := NetPayable1;
        Rec."Payable Amount (Incl. OP+Dir)" := -(Rec."Payable Amount") + NetPayable1 + (Rec."Eligible Amount") + HdrCommTA;
        Rec."Total Deduction (Incl TA Rev)" := TotalPayment + ABS(CorrTrvlPmt);
        Rec."Total Elig. Incl. Opening" := -(Rec."Payable Amount") + NetPayable1 + (Rec."Eligible Amount") + TotalPayment + ABS(CorrTrvlPmt) +
                                       HdrCommTA;
        Rec."Total Elig. Excl. Opening" := NetElegwithTDSClb;
        Rec."Total Club 9" := ClubDedect;
        Rec."Total TDS" := TDSDedect;
        Rec."Net Elig." := NetELEG;
        Rec."Opening Bal. Rem" := ROUND(RemOpOpening, 1);
        Rec."Net Balance" := NetELEG + RemOpOpening;
        Rec."Rem. Opening Inv Amt" := OpenAmt2;
        Rec."Rem. Direct Inv Amt" := OpenAmt3;

        Rec.CALCFIELDS("Eligible Amount");
        //140713

        VoucherAmt := 0;
        Vline.RESET;
        Vline.SETRANGE("Voucher No.", Rec."Document No.");
        IF Vline.FINDSET THEN
            REPEAT
                VoucherAmt := VoucherAmt + Vline.Amount;
            UNTIL Vline.NEXT = 0;

        IF VoucherAmt = 0 THEN BEGIN
            Rec."Check Advance Amount" := FALSE;
            Rec."Advance Amount" := 0;
            Rec."Advance Payment" := FALSE;
            Rec.MODIFY;
        END;
        IF NOT Rec."Check Advance Amount" THEN BEGIN
            IF Rec."Eligible Amount" > 0 THEN BEGIN
                IF Rec."Eligible Amount" + Rec."Total Elig. Excl. Opening" > 0 THEN BEGIN
                    Rec."Advance Amount" := Rec."Eligible Amount" + Rec."Total Elig. Excl. Opening";
                    Rec."Advance Payment" := TRUE;
                    Rec."Check Advance Amount" := TRUE;
                END ELSE BEGIN
                    Rec."Advance Amount" := 0;
                    Rec."Advance Payment" := FALSE;
                    Rec."Check Advance Amount" := TRUE;
                END;
            END;
        END;
        Rec.MODIFY;

    end;


    procedure ForHeaderInsertTAEntry(): Decimal
    var
        TravelPaymentEntry: Record "Travel Payment Entry";
    begin

        LineNo := 0;
        AmttoPay := 0;
        AmtTDS := 0;
        AmttoPay1 := 0;
        "TDS%" := 0;
        EntryNo := 0;

        TravelPaymentEntry.RESET;
        TravelPaymentEntry.SETFILTER("Entry No.", '>%1', 0);
        IF TravelPaymentEntry.FINDLAST THEN
            EntryNo := TravelPaymentEntry."Entry No.";



        Unitsetup.GET;
        TravelPaymentEntry.RESET;
        TravelPaymentEntry.SETCURRENTKEY("Sub Associate Code", Month, Year, Approved);
        TravelPaymentEntry.SETRANGE("Sub Associate Code", Rec."Paid To");
        TravelPaymentEntry.SETRANGE("Creation Date", 0D, TODAY);//"Posting Date");
        TravelPaymentEntry.SETRANGE(Approved, TRUE);
        TravelPaymentEntry.SETRANGE("TA Creation on Commission Vouc", FALSE);
        //TravelPaymentEntry.SETFILTER("Voucher No.",'=%1','');
        TravelPaymentEntry.SETRANGE("Post Payment", FALSE);
        IF TravelPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                AmttoPay := AmttoPay + TravelPaymentEntry."Amount to Pay";
                AmtTDS := AmtTDS + TravelPaymentEntry."TDS Amount";
            UNTIL TravelPaymentEntry.NEXT = 0;
        END;

        TravelPaymentEntry.RESET;
        TravelPaymentEntry.SETCURRENTKEY("Sub Associate Code", Month, Year, Approved);
        TravelPaymentEntry.SETRANGE("Sub Associate Code", Rec."Paid To");
        //TravelPaymentEntry.SETRANGE("Creation Date",0D,"Posting Date");
        TravelPaymentEntry.SETFILTER("Remaining Amount", '<>%1', 0);
        IF TravelPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                AmttoPay1 := AmttoPay1 + TravelPaymentEntry."Remaining Amount";
            UNTIL TravelPaymentEntry.NEXT = 0;
        END;

        HdrCommTA := 0;
        IF (AmttoPay1 + AmttoPay) > 0 THEN BEGIN
            HdrCommTA := (AmttoPay1 + AmttoPay);
        END;
    end;

    local procedure ForHdrAddComm()
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
        CommissionEntry.SETRANGE("Posting Date", 0D, TODAY);
        //CommissionEntry.SETFILTER("Vouch/Ber No.",'=%1','');    //ALLEDK 210213
        CommissionEntry.SETRANGE(Posted, FALSE);  //ALLEDK 210213
        CommissionEntry.SETRANGE("Remaining Amt of Direct", FALSE);
        CommissionEntry.SETRANGE("Opening Entries", FALSE);
        IF CommissionEntry.FINDSET THEN BEGIN
            REPEAT
                IF CommissionEntry."Direct to Associate" THEN BEGIN
                    RecConforder.RESET;                                               //BBG1.00 010413
                    RecConforder.SETRANGE("No.", CommissionEntry."Application No.");   //BBG1.00 010413
                    RecConforder.SETRANGE("Registration Bonus Hold(BSP2)", FALSE);     //BBG1.00 010413
                    IF RecConforder.FINDFIRST THEN BEGIN                              //BBG1.00 010413
                        AmttoPay1 := AmttoPay1 + CommissionEntry."Commission Amount";
                    END;                                                             //BBG1.00 010413
                END ELSE BEGIN
                    AmttoPay1 := AmttoPay1 + CommissionEntry."Commission Amount";
                END;
            UNTIL CommissionEntry.NEXT = 0;
        END;
        CommissionEntry.RESET;
        CommissionEntry.SETCURRENTKEY("Associate Code", "Posting Date");
        CommissionEntry.SETRANGE("Associate Code", Rec."Paid To");
        //CommissionEntry.SETRANGE("Posting Date",0D,"Commission Date");
        CommissionEntry.SETFILTER("Remaining Amount", '<>%1', 0);
        CommissionEntry.SETRANGE("Opening Entries", FALSE);
        IF CommissionEntry.FINDSET THEN BEGIN
            REPEAT
                AmttoPay := AmttoPay + CommissionEntry."Remaining Amount";
            UNTIL CommissionEntry.NEXT = 0;
        END;

        HdrCommTA := 0;
        IF (AmttoPay + AmttoPay1) > 0 THEN BEGIN
            HdrCommTA := (AmttoPay + AmttoPay1);
        END;
    end;


    procedure UpdateheaderValues()
    begin
        HdrCommTA := 0;
        IF Rec.Type = Rec.Type::Commission THEN
            ForHeaderInsertTAEntry;
        IF Rec.Type = Rec.Type::TA THEN
            ForHdrAddComm;

        BalAmount; //BBG1.00 270613

        Unitsetup.GET;
        TDSCode := '';
        TDSCode1 := '';
        Unitsetup.GET;

        IF Rec.Type = Rec.Type::TA THEN
            TDSCode := Unitsetup."TDS Nature of Deduction TA"
        ELSE IF Rec.Type = Rec.Type::Commission THEN
            TDSCode := Unitsetup."TDS Nature of Deduction"
        ELSE IF Rec.Type = Rec.Type::Incentive THEN
            TDSCode := Unitsetup."TDS Nature of Deduction INCT"
        ELSE IF Rec.Type = Rec.Type::ComAndTA THEN BEGIN
            TDSCode := Unitsetup."TDS Nature of Deduction TA";
            TDSCode1 := Unitsetup."TDS Nature of Deduction";
        END;
        Rec.CALCFIELDS("Payable Amount", "TDS Amount", "Club 9 Amount");


        CalcTDSPercentage;

        IF Rec.Type = Rec.Type::Incentive THEN
            Rec."Net Pay after adv. Adj." := (Rec."Payable Amount" - Rec."TDS Amount" - Rec."Club 9 Amount") - (Rec."Advance Amount" - (Rec."Advance Amount" * TDSPercentage /
          100
            )
            - (Rec."Advance Amount" * Unitsetup."Incentive Club 9%" / 100))
        ELSE
            Rec."Net Pay after adv. Adj." := (Rec."Payable Amount" - Rec."TDS Amount" - Rec."Club 9 Amount") - (Rec."Advance Amount" - (Rec."Advance Amount" * TDSPercentage /
          100
            )
            - (Rec."Advance Amount" * Unitsetup."Corpus %" / 100));


        IF Rec."Net Pay after adv. Adj." < 0 THEN
            Rec."Net Pay after adv. Adj." := 0
        ELSE
            Rec."Net Pay after adv. Adj." := Rec."Net Pay after adv. Adj.";
        Rec.MODIFY;
    end;

    local procedure PaymentModeOnAfterValidate()
    begin
        UpdateGLCode;
    end;

    local procedure NetAmtOnAfterValidate()
    begin
        Unitsetup.GET;
        "TDS%" := PostPayment1.CalculateTDSPercentage(Rec."Paid To", Unitsetup."TDS Nature of Deduction INCT", '');

        //IF "Advance Amount" > NetAmt THEN
        //  FinalAmt :=0
        //ELSE BEGIN
        FinalAmt := 0;
        IF Rec.Type = Rec.Type::Incentive THEN
            FinalAmt := (100 * (NetAmt)) / (100 - Unitsetup."Incentive Club 9%" - "TDS%")
        ELSE
            FinalAmt := (100 * (NetAmt)) / (100 - Unitsetup."Corpus %" - "TDS%");

        Rec.CALCFIELDS("Eligible Amount");
        FinalAmt1 := 0;
        FinalAmt1 := Rec."Eligible Amount" + (Rec."Total Elig. Incl. Opening" + (-Rec."Opening Bal. Rem" + FinalAmt));
        //END;
    end;
}

