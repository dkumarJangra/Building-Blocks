page 50098 "New Payable Form"
{
    // //BBG1.00 ALLEDK 070313 Code added for changes in Payment methods
    // BBG1.00 010413 Code added in case of BSP2 release or not Release
    // ALLETDK120913>>>  Added code after correction in drawning ledger report.
    // BBG2.00 Added code for bypass the Advace payment calculation effect

    Editable = false;
    PageType = Card;
    SourceTable = "Assoc Pmt Voucher Header";
    SourceTableView = WHERE(Post = FILTER(false),
                            "Sub Type" = CONST(Regular),
                            "From MS Company" = CONST(true));
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
                field(AccCode; AccCode + '....')
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
                field("Sub Type"; Rec."Sub Type")
                {
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
                field("Create Invoice Only"; Rec."Create Invoice Only")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'CreateInvOnly');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You are not authorised person to perform this task');
                    end;
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

                        TDSCode := '';
                        TDSCode1 := '';
                        Unitsetup.GET;

                        IF Rec.Type = Rec.Type::TA THEN
                            TDSCode := Unitsetup."TDS Nature of Deduction TA"
                        ELSE
                            IF Rec.Type = Rec.Type::Commission THEN
                                TDSCode := Unitsetup."TDS Nature of Deduction"
                            ELSE
                                IF Rec.Type = Rec.Type::Incentive THEN
                                    TDSCode := Unitsetup."TDS Nature of Deduction INCT"
                                ELSE
                                    IF Rec.Type = Rec.Type::ComAndTA THEN BEGIN
                                        TDSCode := Unitsetup."TDS Nature of Deduction TA";
                                        TDSCode1 := Unitsetup."TDS Nature of Deduction";
                                    END;

                        IF Rec."Ignore Advance Payment" OR Rec."Create Invoice Only" THEN BEGIN //BBG2.00
                            IF Rec.Type = Rec.Type::TA THEN
                                PostTA
                            ELSE
                                IF Rec.Type = Rec.Type::Commission THEN
                                    PostCommission
                                ELSE
                                    IF Rec.Type = Rec.Type::Incentive THEN
                                        PostIncentive
                                    ELSE
                                        IF Rec.Type = Rec.Type::ComAndTA THEN
                                            PostComAndTA;
                        END ELSE
                            IF (NOT Rec."Ignore Advance Payment") AND (NOT Rec."Create Invoice Only") THEN BEGIN //BBG2.00
                                IF Rec."Advance Amount" = 0 THEN BEGIN
                                    IF Rec.Type = Rec.Type::TA THEN
                                        PostTA
                                    ELSE
                                        IF Rec.Type = Rec.Type::Commission THEN
                                            PostCommission
                                        ELSE
                                            IF Rec.Type = Rec.Type::Incentive THEN
                                                PostIncentive
                                            ELSE
                                                IF Rec.Type = Rec.Type::ComAndTA THEN
                                                    PostComAndTA;
                                END ELSE BEGIN
                                    IF Rec.Type = Rec.Type::TA THEN
                                        PostTA1
                                    ELSE
                                        IF Rec.Type = Rec.Type::Commission THEN
                                            PostCommission1
                                        ELSE
                                            IF Rec.Type = Rec.Type::Incentive THEN
                                                PostIncentive1
                                            ELSE
                                                IF Rec.Type = Rec.Type::ComAndTA THEN
                                                    PostComAndTA1;
                                END;
                            END;
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
        //NODNOCLine: Record 13785;
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
        OpBalance: Decimal;
        NetELEG: Decimal;
        NetElegwithTDSClb: Decimal;
        FinalAmt1: Decimal;
        HdrCommTA: Decimal;
        Vline: Record "Voucher Line";
        VoucherAmt: Decimal;
        VHeader: Record "Assoc Pmt Voucher Header";
        OpenAmt2: Decimal;
        OpenAmt3: Decimal;
        PAmt2: Decimal;
        PSAmt2: Decimal;
        DirectPaidComm: Decimal;
        APPCode: Code[20];
        MemberOf: Record "Access Control";
        GLEntry: Record "G/L Entry";
        AppNo: Code[20];
        CompanyWiseGL: Record "Company wise G/L Account";

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
        PHeader."Cheque No." := Rec."Cheque No.";
        PHeader."Cheque Date" := Rec."Cheque Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::"Travel Allowance";
        PHeader.Approved := TRUE;
        PHeader."From MS Company" := Rec."From MS Company";
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

        IF NOT Rec."Create Invoice Only" THEN BEGIN      //BBG2.00
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
        PHeader."Cheque No." := Rec."Cheque No.";
        PHeader."Cheque Date" := Rec."Cheque Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::Commission;
        PHeader.Approved := TRUE;
        PHeader."From MS Company" := Rec."From MS Company";
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
        PHeader."Cheque No." := Rec."Cheque No.";
        PHeader."Cheque Date" := Rec."Cheque Date";
        //PHeader.Structure := 'EXEMPT';
        PHeader."Sent for Approval" := TRUE;
        PHeader."Associate Posting Type" := PHeader."Associate Posting Type"::CommAndTA;
        PHeader.Approved := TRUE;
        PHeader."From MS Company" := Rec."From MS Company";
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
                END ELSE
                    IF VoucherLine."Incentive Type" = VoucherLine."Incentive Type"::Team THEN BEGIN
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
                GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", Rec."Paid To");
                GenJnlLine.VALIDATE("Debit Amount", ROUND(DBAmt, 1));
                GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::"Travel Allowance");
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                CompanyWiseGL.RESET;
                CompanyWiseGL.SETRANGE(CompanyWiseGL."MSC Company", TRUE);
                IF CompanyWiseGL.FINDFIRST THEN
                    CompanyWiseGL.TESTFIELD(CompanyWiseGL."Payable Account");
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", CompanyWiseGL."Payable Account");
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
        PHeader."From MS Company" := Rec."From MS Company";
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

                DBAmt := ABS(Rec."Net Elig.");

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
                GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", Rec."Paid To");
                GenJnlLine.VALIDATE("Debit Amount", ROUND(DBAmt, 1));
                GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Commission);
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                CompanyWiseGL.RESET;
                CompanyWiseGL.SETRANGE(CompanyWiseGL."MSC Company", TRUE);
                IF CompanyWiseGL.FINDFIRST THEN
                    CompanyWiseGL.TESTFIELD(CompanyWiseGL."Payable Account");

                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", CompanyWiseGL."Payable Account");
                GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                GenJnlLine."External Document No." := Rec."Document No.";
                GenJnlLine."Cheque No." := Rec."Cheque No.";
                GenJnlLine."Cheque Date" := Rec."Cheque Date";
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
        PHeader."From MS Company" := Rec."From MS Company";
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
                GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
                GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", Rec."Paid To");
                GenJnlLine.VALIDATE("Debit Amount", DBAmt);
                GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::CommAndTA);
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.VALIDATE(GenJnlLine."Bal. Account No.", CompanyWiseGL."Payable Account");
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
        PHeader."From MS Company" := Rec."From MS Company";
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
        Unitsetup.GET;
        TDSSetup.RESET;
        //IF RecNODHeader.GET(RecNODHeader.Type::Vendor, Rec."Paid To") THEN;//Need to check the code in UAT
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
        IF PHeader."Assessee Code" = '' THEN
            TDSSetup.SETRANGE("Assessee Code", RecNODHeader."Assesse Code") //24
        ELSE
            TDSSetup.SETRANGE("Assessee Code", PHeader."Assessee Code");
        //TDSSetup.SETRANGE("TDS Group","TDS Group");
        TDSSetup.SETRANGE("Effective Date", 0D, Rec."Posting Date");
        NODLines.RESET;
        NODLines.SETRANGE(Type, NODLines.Type::Vendor);
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
            *///Need to check the code in UAT

        //    END;
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

