page 50087 "Associate Advance Pmt Form"
{
    // //BBG1.00 ALLEDK 070313 Code added for changes in Payment methods
    // BBG1.00 010413 Code added in case of BSP2 release or not Release

    Editable = true;
    PageType = Card;
    SourceTable = "Assoc Pmt Voucher Header";
    SourceTableView = WHERE(Post = FILTER(false),
                            "Sub Type" = FILTER(AssociateAdvance));
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

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Paid To"; Rec."Paid To")
                {

                    trigger OnValidate()
                    begin
                        //ALLECK 230313 START
                        Rec."User ID" := USERID;
                        IF UserSetup.GET(Rec."User ID") THEN
                            Rec."User Branch Code" := UserSetup."User Branch";
                        //ALLECK 230313 END

                        IF Vendor.GET(Rec."Paid To") THEN
                            Vendor.TESTFIELD(Vendor.Blocked, Vendor.Blocked::" ");


                        VHeader.RESET;
                        VHeader.SETRANGE("Paid To", Rec."Paid To");
                        VHeader.SETRANGE("Sub Type", Rec."Sub Type"::AssociateAdvance);
                        VHeader.SETFILTER("Document No.", '<>%1', Rec."Document No.");
                        VHeader.SETRANGE(Post, FALSE);
                        IF VHeader.FINDFIRST THEN
                            ERROR('You have already select this Associate with another Document No.=' + VHeader."Document No.");
                    end;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {

                    trigger OnValidate()
                    begin
                        Rec.Type := Rec.Type::" ";
                        PaymentModeOnAfterValidate;
                    end;
                }
                field(AccCode; AccCode + '....')
                {
                }
                field("Bank/G L Code"; Rec."Bank/G L Code")
                {

                    trigger OnValidate()
                    begin

                        //BBG1.00 030613
                        IF Rec."Payment Mode" = Rec."Payment Mode"::Bank THEN BEGIN
                            IF NOT BAccount.GET(Rec."Bank/G L Code") THEN
                                ERROR('Please check Bank Account Code');
                        END ELSE IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN BEGIN
                            IF NOT GLAccount1.GET(Rec."Bank/G L Code") THEN
                                ERROR('Please check CASH Account Code');
                        END;
                        //BBG1.00 030613
                        Rec."Posting Date" := WORKDATE;
                    end;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
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
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field("Bank/G L Name"; Rec."Bank/G L Name")
                {
                    Caption = 'Name';
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                }
            }
            part(VoucherSubform; "Associate Adv. Pmt. subform")
            {
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
                        Companywise.RESET;
                        Companywise.SETRANGE(Companywise."MSC Company", TRUE);
                        IF Companywise.FINDFIRST THEN
                            IF Companywise."Company Code" = COMPANYNAME THEN BEGIN
                                Rec.TESTFIELD("Posting Date");
                                IF CONFIRM('Do you want to post the payment?') THEN BEGIN
                                    CheckEntry();
                                    CreateEntries();
                                    Rec.Post := TRUE;
                                    Rec.MODIFY;
                                END;
                            END ELSE
                                ERROR('This process wil done from Master Company');
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Sub Type" := Rec."Sub Type"::AssociateAdvance;
        Rec.Type := Rec.Type::" ";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Sub Type" := Rec."Sub Type"::AssociateAdvance;
        Rec.Type := Rec.Type::" ";
    end;

    trigger OnOpenPage()
    begin
        ERROR('Use other Advance payment window');
        UpdateGLCode;
        UpdateControls;
        IF USERID <> '1003' THEN
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
        //RecNODHeader: Record 13786;
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
        Companywise: Record "Company wise G/L Account";
        AssociatePaymentHdr: Record "Associate Payment Hdr";
        OldAssPayEntry: Record "Associate Payment Hdr";
        PostedDocNo: Code[20];
        Vendor: Record Vendor;
        SNo: Integer;


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
    end;


    procedure CreateEntries()
    begin
        SNo := 0;
        GLSetup.GET;
        Unitsetup.GET;
        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        IF VoucherLine.FINDFIRST THEN
            REPEAT

                SNo := SNo + 1;
                IF SNo = 1 THEN BEGIN
                    BondSetup.GET;
                    BondSetup.TESTFIELD("Voucher No. Series");
                    OldAssPayEntry.RESET;
                    IF OldAssPayEntry.FINDLAST THEN BEGIN
                        PostedDocNo := OldAssPayEntry."Document No.";
                        PostedDocNo := INCSTR(PostedDocNo);
                    END ELSE
                        PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Voucher No. Series", WORKDATE, TRUE);
                END;
                Unitsetup.CHANGECOMPANY(VoucherLine."Company Code");
                TDS := PostPayment.CalculateTDSPercentage(Rec."Paid To", Unitsetup."TDS Nature of Deduction", VoucherLine."Company Code");
                LineNo := LineNo + 10000;
                AssociatePaymentHdr.INIT;
                AssociatePaymentHdr."Document No." := PostedDocNo;
                AssociatePaymentHdr."Sub Type" := AssociatePaymentHdr."Sub Type"::AssociateAdvance;
                AssociatePaymentHdr."Line No." := LineNo;
                AssociatePaymentHdr."Associate Code" := Rec."Paid To";
                IF Vendor.GET(Rec."Paid To") THEN
                    AssociatePaymentHdr."Associate Name" := Vendor.Name;
                AssociatePaymentHdr.Type := VoucherLine.Type;
                AssociatePaymentHdr."Posting Type" := Rec."Posting Type";
                AssociatePaymentHdr."User ID" := USERID;
                AssociatePaymentHdr."User Branch Code" := UserSetup."User Branch";
                AssociatePaymentHdr."Posting Date" := Rec."Posting Date";
                AssociatePaymentHdr."Document Date" := Rec."Document Date";
                AssociatePaymentHdr."Eligible Amount" := VoucherLine.Amount;
                //  +                                VoucherLine.Amount*((TDS + Unitsetup."Corpus %")/(100-(TDS+Unitsetup."Corpus %")));
                AssociatePaymentHdr."Payable Amount" := AssociatePaymentHdr."Eligible Amount";
                AssociatePaymentHdr."Company Name" := VoucherLine."Company Code";
                AssociatePaymentHdr."From MS Company" := TRUE;
                AssociatePaymentHdr.Narration := VoucherLine.Narration;
                IF SNo = 1 THEN BEGIN
                    AssociatePaymentHdr."Line Type" := AssociatePaymentHdr."Line Type"::Header;
                    AssociatePaymentHdr."Payment Mode" := Rec."Payment Mode";
                    AssociatePaymentHdr."Bank/G L Code" := Rec."Bank/G L Code";
                    AssociatePaymentHdr."Bank/G L Name" := Rec."Bank/G L Name";
                    AssociatePaymentHdr."Cheque No." := Rec."Cheque No.";
                    AssociatePaymentHdr."Cheque Date" := Rec."Cheque Date";
                END ELSE
                    AssociatePaymentHdr."Line Type" := AssociatePaymentHdr."Line Type"::Line;
                AssociatePaymentHdr."Amt applicable for Payment" := VoucherLine."Net Amount";

                AssociatePaymentHdr."Net Payable (As per Actual)" := AssociatePaymentHdr."Amt applicable for Payment";
                AssociatePaymentHdr."Rejected/Approved" := AssociatePaymentHdr."Rejected/Approved"::Approved;
                AssociatePaymentHdr."TDS Amount" := ROUND(((AssociatePaymentHdr."Eligible Amount") * TDS / 100), 1, '=');
                AssociatePaymentHdr."Club 9 Amount" := ((AssociatePaymentHdr."Eligible Amount") * Unitsetup."Corpus %" / 100);
                AssociatePaymentHdr.INSERT;
            UNTIL VoucherLine.NEXT = 0;
        PostPayment.PostAssociatePayment(AssociatePaymentHdr);
    end;


    procedure CheckEntry()
    begin
        VoucherLine.RESET;
        VoucherLine.SETRANGE("Voucher No.", Rec."Document No.");
        IF VoucherLine.FINDFIRST THEN
            REPEAT
                IF VoucherLine."Company Code" = COMPANYNAME THEN
                    ERROR('You can not give Advance for this company at this window');

                IF VoucherLine."Associate Code" <> Rec."Paid To" THEN
                    ERROR('Please check the Associate code in line. ');
            UNTIL VoucherLine.NEXT = 0
    end;

    local procedure PaymentModeOnAfterValidate()
    begin
        UpdateGLCode;
    end;
}

