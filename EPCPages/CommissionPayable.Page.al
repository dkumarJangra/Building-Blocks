page 97918 "Commission Payable"
{
    //  Added new function (InsertTAEntries) for insert Travel payment Entries
    // //ALLEDK 011112 Comment

    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Comm. Voucher Posting Buffer";
    SourceTableView = SORTING("Counter Code(Paid)", Status);
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Voucherfilter; VoucherNoFilt)
                {
                    Caption = 'Voucher No. Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // ALLEPG 251012 Start
                        CommissionVoucher.RESET;
                        CommissionVoucher.SETRANGE("Associate Code", PaidTo);
                        IF CommissionVoucher.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Member to Member list", CommissionVoucher) = ACTION::LookupOK THEN
                                VoucherNoFilt := CommissionVoucher."Voucher No.";
                        END;
                        // ALLEPG 251012 End
                    end;

                    trigger OnValidate()
                    var
                        CommissionVoucher: Record "Commission Voucher";
                    begin
                        IF CommissionVoucher.GET(VoucherNoFilt) THEN BEGIN
                            MmCode := CommissionVoucher."Associate Code";
                            MmName := GetDescription.GetVendorName(MmCode);
                            //NetCommission := CommissionVoucher."Commission Amount" - CommissionVoucher."TDS Amount" -
                            // CommissionVoucher."Clube 9 Charge Amount";
                        END ELSE BEGIN
                            MmCode := '';
                            MmName := '';
                            //NetCommission := 0;
                        END;
                    end;
                }
                field(DateFilter; DateFilter)
                {
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    var
                        CommissionVoucher: Record "Commission Voucher";
                    begin
                        DateFilterOnAfterValidate;
                    end;
                }
                field("Payment Mode"; PayMode)
                {
                    Caption = 'Payment Mode';
                    OptionCaption = ' ,Cash,Cheque';
                }
                field("Bank / GL Code"; BankNo)
                {
                    Caption = 'Bank / GL Code';
                    TableRelation = "Bank Account";

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF PayMode = PayMode::Cash THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"G/L Account List", GLACC) = ACTION::LookupOK THEN BEGIN
                                BankNo := GLACC."No.";
                                BankName := GLACC.Name;
                            END;

                        END ELSE
                            IF PayMode = PayMode::Cheque THEN BEGIN
                                IF PAGE.RUNMODAL(Page::"Bank Account List", BankACC) = ACTION::LookupOK THEN BEGIN
                                    BankNo := BankACC."No.";
                                    BankName := BankACC.Name;
                                END;
                            END;
                    end;
                }
                field(MmCode; MmCode)
                {
                    Editable = false;
                }
                field(MmName; MmName)
                {
                    Editable = false;
                }
                field("Cheque No."; ChequeNo)
                {
                    Caption = 'Cheque No.';
                }
                field("Cheque Date"; ChequeDate)
                {
                    Caption = 'Cheque Date';
                }
                field(Name; 'Name')
                {
                    Caption = 'Name';
                    TableRelation = "Bank Account";

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF PayMode = PayMode::Cash THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"G/L Account List", GLACC) = ACTION::LookupOK THEN BEGIN
                                BankNo := GLACC."No.";
                                BankName := GLACC.Name;
                            END;

                        END ELSE
                            IF PayMode = PayMode::Cheque THEN BEGIN
                                IF PAGE.RUNMODAL(Page::"Bank Account List", BankACC) = ACTION::LookupOK THEN BEGIN
                                    BankNo := BankACC."No.";
                                    BankName := BankACC.Name;
                                END;
                            END;
                    end;
                }
                field("Bank Code"; BankName)
                {
                    Caption = 'Bank Code';
                }
                field("Commission Amount"; CommAmt)
                {
                    Caption = 'Commission Amount';
                    Editable = false;
                    Visible = false;
                }
                field("Cash Payment"; PaymentMode)
                {
                    Caption = 'Cash Payment';
                    OptionCaption = 'Cash,Cheque';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        IF PaymentMode = PaymentMode::Cheque THEN
                            ChequePaymentModeOnValidate;
                        IF PaymentMode = PaymentMode::Cash THEN
                            CashPaymentModeOnValidate;
                    end;
                }
                field("Club Charge"; ClubeChargeAmt)
                {
                    Caption = 'Club Charge';
                    Editable = false;
                    Visible = false;
                }
                field("TDS Amount"; TDSAmt)
                {
                    Caption = 'TDS Amount';
                    Editable = false;
                    Visible = false;
                }
                field(NetCommission1; NetCommission)
                {
                    Caption = 'NetCommission';
                    Editable = false;
                    Visible = false;
                }
            }
            repeater(Group)
            {
                Editable = true;
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Voucher No."; Rec."Voucher No.")
                {
                    Editable = false;
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Editable = false;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                }
                field(NetCommission; Rec."Commission Amount" - Rec."TDS Amount" - Rec."Clube 9 Charge Amount")
                {
                    Caption = 'Net Commission';
                }
                field("Clube 9 Charge Amount"; Rec."Clube 9 Charge Amount")
                {
                    Editable = false;
                }
                field("TDS Applicable"; Rec."TDS Applicable")
                {
                }
            }
            group(Total)
            {
                Caption = 'Total';
                field("Total Commission"; TotalComission)
                {
                    Caption = 'Total Commission';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Total TDS"; TotalTDSAmt)
                {
                    Caption = 'Total TDS';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Total Club 9"; TotalClub9charge)
                {
                    Caption = 'Total Club 9';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Net Commission"; GLAmount)
                {
                    Caption = 'Net Commission';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Total Vouchers"; VoucherCount)
                {
                    Caption = 'Total Vouchers';
                    Editable = false;
                }
                field("Unit Office Code"; UserSetup."Responsibility Center")
                {
                    Caption = 'Unit Office Code';
                    Editable = false;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
                }
                field("Counter Code"; UserSetup."Shortcut Dimension 2 Code")
                {
                    Caption = 'Counter Code';
                    Editable = false;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
                }
                field("Document Date"; GetDescription.GetDocomentDate)
                {
                    Caption = 'Document Date';
                    Editable = false;
                    Enabled = true;
                }
                field("Document No"; DocumentNo)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RemoveButton)
            {
                Caption = '&Remove';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    Errortext: Text[1024];
                    Divider: Text[30];
                begin
                    RemoveData;
                    ResetPane;
                end;
            }
            action(GenerateCommissionVoucher)
            {
                Caption = '&Generate Commission Voucher';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    Errortext: Text[1024];
                    Divider: Text[30];
                begin
                    // ALLEPG 251012 Start
                    CommissionEntry.RESET;
                    CommissionEntry.SETRANGE("Associate Code", PaidTo);
                    CommissionEntry.SETFILTER("Posting Date", DateFilter);
                    IF CommissionEntry.FINDFIRST THEN
                        REPORT.RUN(50026, TRUE, FALSE, CommissionEntry);
                    // ALLEPG 251012 End
                end;
            }
            action(ShowButton)
            {
                Caption = '&Add';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Errortext: Text[1024];
                    Divider: Text[30];
                begin
                    IF PayMode = PayMode::" " THEN
                        ERROR('Please define first Payment Mode');
                    IF BankNo = '' THEN
                        ERROR('Please define the GL OR Bank Code');
                    AddVouchers;
                    CashPaymentEditable := FALSE;
                    ChequePaymentEditable := FALSE;
                    PaidToEditable := FALSE;
                    ResetPane;
                end;
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Posting")
                {
                    Caption = 'P&osting';
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        //PostCommission;
                        NewPostCommission;
                    end;
                }
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page Navigate;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GenerateCommAmt;
        ResetPane;
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        TotalComission := 0;
        TotalTDSAmt := 0;
        TotalClub9charge := 0;

        ResetPane;
        CurrPage.UPDATE(TRUE);
    end;

    trigger OnInit()
    begin
        PaidToEditable := TRUE;
        ChequePaymentEditable := TRUE;
        CashPaymentEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        BondSetup.GET;
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Responsibility Center");
        //UserSetup.TESTFIELD("Shortcut Dimension 2 Code");
        Rec.FILTERGROUP(10);
        //SETRANGE("Unit Office Code(Paid)",UserSetup."Responsibility Center");
        Rec.SETRANGE("Counter Code(Paid)", UserSetup."Shortcut Dimension 2 Code");
        Rec.SETRANGE(Status, Rec.Status::Open);
        Rec.FILTERGROUP(0);
        /*
        IF FINDFIRST THEN BEGIN
          IF "Payment Mode" = "Payment Mode"::Cash THEN
            PaymentMode := PaymentMode::Cash
          ELSE
            PaymentMode := PaymentMode::Cheque;
          PaidTo := "Paid To";
          CurrPAGE.CashPayment.EDITABLE(FALSE);
          CurrPAGE.ChequePayment.EDITABLE(FALSE);
          CurrPAGE.PaidTo.EDITABLE(FALSE);
        END;
        */
        ResetPane;

    end;

    var
        BondFilter: Code[20];
        PaidTo: Code[20];
        UserSetup: Record "User Setup";
        BondSetup: Record "Unit Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Vendor: Record Vendor;
        DocumentNo: Code[20];
        PostingNoSeries: Code[10];
        DocNoGenerated: Boolean;
        VoucherNoFilt: Code[20];
        VoucherNoFilter1: Text[1024];
        VoucherSelected: Boolean;
        BaseAmount: Decimal;
        GLAmount: Decimal;
        VoucherCount: Integer;
        VoucherCount2: Integer;
        GLAmtPayment: Decimal;
        GLAmtDiff: Decimal;
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        BankAccountList: Page "Bank Account List";
        GLAccountList: Page "G/L Account List";
        Text0001: Label 'Do you want to post?\\Total Base Amount: %1\Total Commission: %2\Total Amount Payable: %3\No. of Vouchers  = %4';
        Text0002: Label 'Do you want to generate Doc. No.?\\Total Base Amount: %1\Total Commission: %2\Total Amount Payable: %3\No. of Vouchers: %4\';
        Text0003: Label 'Document No. generated. To post press POST button again.';
        Text0004: Label 'The commission vouchers were successfully posted.\\Posted Document No.: %1\No. of Vouchers: %2';
        Text0005: Label 'Voucher No. %1''s marketing member %2 is on hold, Sorry you cannot continue.';
        Text0006: Label 'There is nothing to post.';
        ShowFlag: Boolean;
        Line: Integer;
        Text0007: Label 'Amount to be paid - %1.\Amount Paid %2.';
        GLAmountinCash: Decimal;
        Text0008: Label 'Voucher No. %1 is not printed.';
        PaymentMode: Option Cash,Cheque;
        Text0009: Label 'Voucher %1 is with %2.';
        Text0010: Label 'Voucher %1 is without cheque or cheque not ready.';
        Text0011: Label '%1 Voucher is selected by another users.';
        Text0012: Label '%1 Voucher is selected by the same user.';
        Text0013: Label '%1 Voucher has already been expired.';
        Text0014: Label 'Either Received From Code %1 and MM Code %2 is not from the same chain or Received From Code is junior than MM Code.';
        GetDescription: Codeunit GetDescription;
        MmCode: Code[20];
        NetCommission: Decimal;
        MmName: Text[50];
        DateFilter: Text[250];
        CommissionEntry: Record "Commission Entry";
        CommAmt: Decimal;
        ClubeChargeAmt: Decimal;
        TDSSetup: Record "TDS Setup";
        TDSAmt: Decimal;
        "Integer": Record Integer;
        CommissionVoucher: Record "Commission Voucher";
        //NODNOCHdr: Record 13786;//Need to check the code in UAT

        //NODNOCLines: Record 13785;//Need to check the code in UAT

        GLSetup: Record "General Ledger Setup";
        CommVoucherPostingBuffer: Record "Comm. Voucher Posting Buffer";
        CVPostingBuffer: Record "Comm. Voucher Posting Buffer";
        DocNo: Code[20];
        Unitsetup: Record "Unit Setup";
        TravelPayment: Record "Travel Payment Entry";
        TotalTDSAmt: Decimal;
        TotalComission: Decimal;
        TotalClub9charge: Decimal;
        BankNo: Code[20];
        ChequeNo: Code[10];
        ChequeDate: Date;
        TotalTAAmt: Decimal;
        TotalClub9: Decimal;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DocNo1: Code[20];
        TotalTDSAmt1: Decimal;
        PayMode: Option " ",Cash,Cheque;
        BankACC: Record "Bank Account";
        GLACC: Record "G/L Account";
        BankName: Text[60];

        CashPaymentEditable: Boolean;

        ChequePaymentEditable: Boolean;

        PaidToEditable: Boolean;
        Text666: Label '%1 is not a valid selection.';
        Text19027764: Label 'Document No.';


    procedure GenerateDocNo()
    begin
        DocumentNo := NoSeriesMgt.GetNextNo(BondSetup."Comm. No. Series", WORKDATE, TRUE);
        PostingNoSeries := BondSetup."Comm. No. Series";
        DocNoGenerated := TRUE;
        COMMIT;
    end;


    procedure ResetDocNo()
    begin
        IF DocNoGenerated THEN BEGIN
            DocumentNo := '';
            PostingNoSeries := '';
            DocNoGenerated := FALSE;
            VoucherNoFilt := '';
            PaidTo := '';
            BankNo := '';
        END;
        GLAmount := 0;
        BaseAmount := 0;
        VoucherCount := 0;
        GLAmtPayment := 0;
        TotalComission := 0;
        TotalTDSAmt := 0;
        TotalClub9charge := 0;
    end;


    procedure GenerateGLEntry()
    var
        lRecGLEntry: Record "G/L Entry";
    begin
    end;

    local procedure AddVouchers()
    var
        ConsiderVoucher: Boolean;
        CommVoucherPostingBuffer: Record "Comm. Voucher Posting Buffer";
        CommissionVoucher: Record "Commission Voucher";
        ReapprovedCommissionVoucher: Record "Reapproved Commission Voucher";
        ExpiredVoucher: Text[1024];
        PostPayment: Codeunit PostPayment;
        BondPost: Codeunit "Unit Post";
    begin
        IF PaidTo = '' THEN
            ERROR('Please enter Paid To');

        IF VoucherNoFilt = '' THEN
            ERROR('Please enter Voucher No.');

        PostPayment.DuplicateVoucherChecking(VoucherNoFilt);

        IF CommVoucherPostingBuffer.GET(VoucherNoFilt, UserSetup."Shortcut Dimension 2 Code") THEN
            IF CommVoucherPostingBuffer.Status = CommVoucherPostingBuffer.Status::Open THEN
                ERROR(Text0012, VoucherNoFilt);

        CommVoucherPostingBuffer.SETRANGE("Voucher No.", VoucherNoFilt);
        CommVoucherPostingBuffer.SETFILTER(Status, '<>%1', CommVoucherPostingBuffer.Status::Deleted);
        IF NOT CommVoucherPostingBuffer.ISEMPTY THEN
            ERROR(Text0011, VoucherNoFilt);

        CommVoucherPostingBuffer.RESET;
        VoucherCount2 := 0;
        CommissionVoucher.RESET;

        IF CommissionVoucher.GET(VoucherNoFilt) THEN BEGIN
            //ALLEDK 011112 Comment
            /*

              IF PaymentMode + 1 <> CommissionVoucher."Payment Mode" THEN
                ERROR(Text0009,VoucherNoFilt,FORMAT(CommissionVoucher."Payment Mode"));
              IF CommissionVoucher."Payment Mode" = CommissionVoucher."Payment Mode"::Cheque THEN
                IF CommissionVoucher."Cheque Status" <> CommissionVoucher."Cheque Status"::"Cheque Released" THEN
                  ERROR(Text0010,VoucherNoFilt);

              Vendor.GET(CommissionVoucher."Associate Code");
              IF Vendor."Hold Payables" THEN
                ERROR(Text0005,VoucherNoFilt,CommissionVoucher."Associate Code");

              CLEAR(BondPost);
              IF NOT BondPost.CheckChain(CommissionVoucher."Associate Code",PaidTo,WORKDATE) THEN
                ERROR(Text0014,PaidTo,CommissionVoucher."Associate Code");
                */ //ALLEDK 011112 Comment
                   // ALLEPG 251012 Start
                   /*
                    IF NOT CommissionVoucher."Commission Voucher Printed" THEN
                      ERROR(Text0008,CommissionVoucher."Voucher No.");
                   IF CommissionVoucher."Voucher Printing Date" < CALCDATE(BondSetup."Comm Voucher Payment Period",GetDescription.GetDocomentDate)
                   THEN BEGIN
                     ReapprovedCommissionVoucher.SETRANGE("Voucher No.",CommissionVoucher."Voucher No.");
                     ReapprovedCommissionVoucher.SETFILTER("Expiry Date",'>=%1',GetDescription.GetDocomentDate);
                     ReapprovedCommissionVoucher.SETRANGE(Printed,TRUE);
                     IF ReapprovedCommissionVoucher.ISEMPTY THEN
                       ERROR(Text0013, VoucherNoFilt);
                   END;
                   */
                   // ALLEPG 251012 End
            IF CommVoucherPostingBuffer.GET(CommissionVoucher."Voucher No.", UserSetup."Shortcut Dimension 2 Code") THEN BEGIN
                CommVoucherPostingBuffer.Status := Rec.Status::Open;
                CommVoucherPostingBuffer."Unit Office Code(Paid)" := UserSetup."Responsibility Center";
                CommVoucherPostingBuffer."Counter Code(Paid)" := UserSetup."Shortcut Dimension 2 Code";
                CommVoucherPostingBuffer."Posting Date" := WORKDATE;
                CommVoucherPostingBuffer."Document Date" := GetDescription.GetDocomentDate;
                CommVoucherPostingBuffer."Unit Office Code(Paid)" := UserSetup."Responsibility Center";
                // ALLEPG 251012 Start
                //CommVoucherPostingBuffer."Clube 9 Charge Amount" := ROUND((CommVoucherPostingBuffer."Commission Amount" -
                //                                             CommVoucherPostingBuffer."TDS Amount") * (BondSetup."Corpus %" / 100),
                //                                              BondSetup."Corpus Amt. Rounding Precision");
                CommVoucherPostingBuffer."Clube 9 Charge Amount" := ROUND((CommVoucherPostingBuffer."Commission Amount"
                                                              * (BondSetup."Corpus %" / 100)),
                                                              BondSetup."Corpus Amt. Rounding Precision");
                // ALLEPG 251012 End
                CommVoucherPostingBuffer."Paid To" := PaidTo;
                CommVoucherPostingBuffer.MODIFY;
            END ELSE BEGIN
                Unitsetup.GET;
                DocNo := NoSeriesMgt.GetNextNo(Unitsetup."Comm. No. Series", WORKDATE, TRUE);
                Rec.INIT;
                Rec.TRANSFERFIELDS(CommissionVoucher);
                Rec."Posting Date" := WORKDATE;
                Rec."Document Date" := GetDescription.GetDocomentDate;
                Rec."Unit Office Code(Paid)" := UserSetup."Responsibility Center";
                Rec."Counter Code(Paid)" := UserSetup."Shortcut Dimension 2 Code";
                Rec."Clube 9 Charge Amount" := ROUND((Rec."Commission Amount" * (BondSetup."Corpus %" / 100)),
                                      BondSetup."Corpus Amt. Rounding Precision");  // ALLEPG 251012
                Rec."Paid To" := PaidTo;
                Rec."Payment Mode" := Rec."Payment Mode"::" ";
                Rec."Document No." := DocNo;
                Rec.INSERT;
            END;

            VoucherCount += 1;
            BaseAmount += CommissionVoucher."Base Amount";
            // ALLEPG 231012
            GLAmount += CommissionVoucher."Commission Amount" - CommissionVoucher."TDS Amount" - CommissionVoucher."Clube 9 Charge Amount";
            TotalComission += CommissionVoucher."Commission Amount";
            TotalTDSAmt += CommissionVoucher."TDS Amount";
            TotalClub9charge += CommissionVoucher."Clube 9 Charge Amount";
            VoucherNoFilt := '';

            InsertTAEntry;

        END;

    end;


    procedure ResetPane()
    var
        CommVoucherPostingBuffer2: Record "Comm. Voucher Posting Buffer";
    begin
        BaseAmount := 0;
        GLAmount := 0;
        VoucherCount := 0;
        GLAmountinCash := 0;
        TotalComission := 0;
        TotalTDSAmt := 0;
        TotalClub9charge := 0;
        CommVoucherPostingBuffer2.RESET;
        CommVoucherPostingBuffer2.SETRANGE("Counter Code(Paid)", UserSetup."Shortcut Dimension 2 Code");
        CommVoucherPostingBuffer2.SETRANGE(Status, CommVoucherPostingBuffer2.Status::Open);
        IF CommVoucherPostingBuffer2.FINDSET THEN
            REPEAT
                BaseAmount += CommVoucherPostingBuffer2."Base Amount";
                GLAmount += CommVoucherPostingBuffer2."Commission Amount" - CommVoucherPostingBuffer2."TDS Amount" -
                 CommVoucherPostingBuffer2."Clube 9 Charge Amount"; // ALLEPG 231012
                TotalComission += CommVoucherPostingBuffer2."Commission Amount";
                TotalTDSAmt += CommVoucherPostingBuffer2."TDS Amount";
                TotalClub9charge += CommVoucherPostingBuffer2."Clube 9 Charge Amount";
                IF PaymentMode = PaymentMode::Cash THEN
                    GLAmountinCash += CommVoucherPostingBuffer2."Commission Amount" - CommVoucherPostingBuffer2."TDS Amount";

                VoucherCount += 1;
            UNTIL CommVoucherPostingBuffer2.NEXT = 0;
        GLAmtPayment := (GLAmount - GLAmountinCash) + ROUND(GLAmountinCash, 1);
        MmCode := '';
        MmName := '';
        NetCommission := 0;
    end;


    procedure PostCommission()
    var
        lCodeoucherNo: Code[20];
        lRecVch: Record "Bonus Posting Buffer";
        PostPayment: Codeunit PostPayment;
    begin
        IF PaidTo = '' THEN
            ERROR('Paid To cannot be left blank.');


        IF VoucherCount = 0 THEN
            ERROR(Text0006);

        Rec.RESET;
        Rec.FILTERGROUP(10);
        Rec.SETRANGE("Counter Code(Paid)", UserSetup."Shortcut Dimension 2 Code");
        Rec.SETRANGE(Status, Rec.Status::Open);
        Rec.FILTERGROUP(0);

        CurrPage.UPDATE(FALSE);

        IF CONFIRM(Text0001, TRUE, BaseAmount, GLAmount, GLAmtPayment, VoucherCount) THEN BEGIN
            IF NOT DocNoGenerated THEN
                GenerateDocNo;
            PostPayment.PostCommissionVouchers(PaymentMode, DocumentNo, Rec, PostingNoSeries, PaidTo,
               GLAmount, GLAmtPayment);
            VoucherNoFilt := '';
            PaidTo := '';
            CashPaymentEditable := TRUE;
            ChequePaymentEditable := TRUE;
            PaidToEditable := TRUE;
            COMMIT;
            MESSAGE('Posted Document No. ' + DocumentNo);
        END;
    end;


    procedure RemoveData()
    var
        CommVoucherPostingBuffer2: Record "Comm. Voucher Posting Buffer";
    begin

        TravelPayment.RESET;
        TravelPayment.SETRANGE("Document No.", Rec."Voucher No.");
        IF TravelPayment.FINDFIRST THEN
            REPEAT
                TravelPayment."TA Creation on Commission Vouc" := FALSE;
                TravelPayment.MODIFY;
            UNTIL TravelPayment.NEXT = 0;



        CurrPage.SETSELECTIONFILTER(CommVoucherPostingBuffer2);
        CommVoucherPostingBuffer2.MODIFYALL(Status, CommVoucherPostingBuffer2.Status::Deleted);
        IF Rec.ISEMPTY THEN BEGIN
            CashPaymentEditable := TRUE;
            ChequePaymentEditable := TRUE;
            PaidToEditable := TRUE;
        END
    end;


    procedure Navigate()
    begin
        //Cashier.Navigate(DocumentNo);
    end;


    procedure GenerateCommAmt()
    var
        Vendor: Record Vendor;
        AllowedSection: Record "Allowed Sections";
        CodeunitEventMgt: Codeunit "BBG Codeunit Event Mgnt.";
        TDSPercent: Decimal;
    begin
        // ALLEPG 251012 Start
        IF (DateFilter <> '') AND (PaidTo <> '') THEN BEGIN
            GLSetup.GET;
            CommAmt := 0;
            ClubeChargeAmt := 0;
            TDSAmt := 0;
            CommissionEntry.RESET;
            CommissionEntry.SETRANGE("Associate Code", PaidTo);
            CommissionEntry.SETFILTER("Posting Date", DateFilter);
            IF CommissionEntry.FINDFIRST THEN
                REPEAT
                    CommAmt += CommissionEntry."Commission Amount";
                UNTIL CommissionEntry.NEXT = 0;
            ClubeChargeAmt := ROUND(((CommAmt * BondSetup."Corpus %") / 100), BondSetup."Corpus Amt. Rounding Precision");

            IF Vendor.Get(PaidTo) Then begin
                AllowedSection.Reset();
                AllowedSection.SetRange("Vendor No", Vendor."No.");
                AllowedSection.SetRange("TDS Section", '194H');
                IF AllowedSection.FindFirst() then begin
                    TDSPercent := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
                    //TDSAmt := ROUND((((CommAmt - ClubeChargeAmt) * TDSPercent) / 100), GLSetup."TDS Rounding Precision");
                end;
            end;

            /*
            IF NODNOCHdr.GET(NODNOCHdr.Type::Vendor, PaidTo) THEN BEGIN
                IF NODNOCLines.GET(NODNOCLines.Type::Vendor, PaidTo, 'COMM') THEN BEGIN
                    TDSSetup.RESET;
                    TDSSetup.SETRANGE("Assessee Code", NODNOCHdr."Assesse Code");
                    TDSSetup.SETRANGE("TDS Nature of Deduction", NODNOCLines."NOD/NOC");
                    TDSSetup.SETRANGE("TDS Group", TDSSetup."TDS Group"::Commission);
                    IF TDSSetup.FINDFIRST THEN
                        TDSAmt := ROUND((((CommAmt - ClubeChargeAmt) * TDSSetup."TDS %") / 100), GLSetup."TDS Rounding Precision");
                END;
            END;
            *///Need to check the code in UAT

            NetCommission := CommAmt - TDSAmt - ClubeChargeAmt;
        END
        ELSE BEGIN
            CommAmt := 0;
            ClubeChargeAmt := 0;
            TDSAmt := 0;
            NetCommission := 0;
        END
        // ALLEPG 251012 End
    end;


    procedure InsertTAEntry()
    var
        TravelPaymentDetails: Record "Travel Payment Entry";
    begin
        TravelPaymentDetails.RESET;
        TravelPaymentDetails.SETRANGE("Sub Associate Code", PaidTo);
        TravelPaymentDetails.SETFILTER("Creation Date", DateFilter);
        TravelPaymentDetails.SETRANGE(Approved, TRUE);
        TravelPaymentDetails.SETRANGE("TA Creation on Commission Vouc", FALSE);
        IF TravelPaymentDetails.FINDFIRST THEN
            REPEAT
                CommVoucherPostingBuffer.INIT;
                CommVoucherPostingBuffer."Voucher No." := TravelPaymentDetails."Document No.";
                CommVoucherPostingBuffer."Voucher Date" := TravelPaymentDetails."Creation Date";
                CommVoucherPostingBuffer."Associate Code" := TravelPaymentDetails."Sub Associate Code";
                CommVoucherPostingBuffer."Base Amount" := TravelPaymentDetails."Amount to Pay";
                CommVoucherPostingBuffer."Commission Amount" := TravelPaymentDetails."Amount to Pay";
                CommVoucherPostingBuffer."TDS Amount" := TravelPaymentDetails."TDS Amount";
                CommVoucherPostingBuffer."Document No." := DocNo;
                CommVoucherPostingBuffer.INSERT;
                TravelPaymentDetails."TA Creation on Commission Vouc" := TRUE;
                TravelPaymentDetails.MODIFY;
            UNTIL TravelPaymentDetails.NEXT = 0;
    end;


    procedure NewPostCommission()
    var
        lCodeoucherNo: Code[20];
        lRecVch: Record "Bonus Posting Buffer";
        PostPayment: Codeunit PostPayment;
    begin
        IF PaidTo = '' THEN
            ERROR('Paid To cannot be left blank.');

        TotalTAAmt := 0;
        TotalClub9 := 0;
        TotalTDSAmt1 := 0;
        CVPostingBuffer.RESET;
        CVPostingBuffer.SETRANGE("Document No.", Rec."Document No.");
        IF CVPostingBuffer.FINDSET THEN
            REPEAT
                TotalTAAmt := TotalTAAmt + CVPostingBuffer."Commission Amount";
                TotalClub9 := TotalClub9 + CVPostingBuffer."Clube 9 Charge Amount";
                TotalTDSAmt1 := TotalTDSAmt1 + CVPostingBuffer."TDS Amount";
            UNTIL CVPostingBuffer.NEXT = 0;
        //..........FOR Libality  Start...............

        BondSetup.GET;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := 'COMMPBL';
        GenJnlLine."Journal Batch Name" := 'COMMPBL';
        GenJnlLine.VALIDATE("Document No.", Rec."Document No.");
        GenJnlLine."Line No." := 10000;
        GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Invoice);
        GenJnlLine.VALIDATE("Posting Date", WORKDATE);
        GenJnlLine.VALIDATE("Document Date", WORKDATE);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", Rec."Associate Code");
        //    GenJnlLine.VALIDATE("Credit Amount","Commission Amount");
        GenJnlLine.VALIDATE("Credit Amount", TotalTAAmt - TotalClub9); //ALLEDK 270812
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
        GenJnlLine.VALIDATE("Party Type", GenJnlLine."Party Type"::Vendor);
        GenJnlLine.VALIDATE("Party Code", Rec."Associate Code");
        GenJnlLine.VALIDATE("TDS Section Code", BondSetup."TDS Nature of Deduction TA");//"TDS Nature of Deduction"
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Commission Payable A/C");
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Sales Resp. Ctr. Filter");
        GenJnlLine."External Document No." := Rec."Voucher No.";
        //GenJnlLine.VALIDATE("Shortcut Dimension 2 Code",UserSetup."Shortcut Dimension 2 Code");
        GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
        GenJnlLine."System-Created Entry" := TRUE;
        //  GenJnlLine.INSERT;
        GenJnlPostLine.RUN(GenJnlLine);

        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := 'COMMPBL';
        GenJnlLine."Journal Batch Name" := 'COMMPBL';
        GenJnlLine.VALIDATE("Document No.", Rec."Document No.");
        GenJnlLine."Line No." := 20000;
        GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Invoice);
        GenJnlLine.VALIDATE("Posting Date", WORKDATE);
        GenJnlLine.VALIDATE("Document Date", WORKDATE);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Account No.", BondSetup."Corpus A/C");
        //    GenJnlLine.VALIDATE("Credit Amount","Commission Amount");
        GenJnlLine.VALIDATE("Credit Amount", TotalClub9); //ALLEDK 270812
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", BondSetup."Commission Payable A/C");
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Sales Resp. Ctr. Filter");
        GenJnlLine."External Document No." := Rec."Voucher No.";
        //GenJnlLine.VALIDATE("Shortcut Dimension 2 Code",UserSetup."Shortcut Dimension 2 Code");
        GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
        GenJnlLine."System-Created Entry" := TRUE;
        //    GenJnlLine.INSERT;
        GenJnlPostLine.RUN(GenJnlLine);

        //..........FOR Libality  END...............
        DocNo1 := NoSeriesMgt.GetNextNo(BondSetup."Comm. Payable No. Series", WORKDATE, TRUE);

        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := 'COMMPBL';
        GenJnlLine."Journal Batch Name" := 'COMMPBL';
        GenJnlLine.VALIDATE("Document No.", DocNo1);
        GenJnlLine."Line No." := 10000;
        GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Invoice);
        GenJnlLine.VALIDATE("Posting Date", WORKDATE);
        GenJnlLine.VALIDATE("Document Date", WORKDATE);
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", Rec."Associate Code");
        //    GenJnlLine.VALIDATE("Credit Amount","Commission Amount");
        GenJnlLine.VALIDATE("Credit Amount", TotalTAAmt - TotalClub9 - TotalTDSAmt1); //ALLEDK 270812
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
        IF PayMode = PayMode::Cash THEN BEGIN
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Bal. Account No.", BankNo);
        END ELSE
            IF PayMode = PayMode::Cheque THEN BEGIN
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                GenJnlLine.VALIDATE("Bal. Account No.", BankNo);
                GenJnlLine.VALIDATE("Cheque No.", ChequeNo);
                GenJnlLine.VALIDATE("Cheque Date", ChequeDate);
            END;
        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Sales Resp. Ctr. Filter");
        GenJnlLine."External Document No." := Rec."Document No.";
        //GenJnlLine.VALIDATE("Shortcut Dimension 2 Code",UserSetup."Shortcut Dimension 2 Code");
        GenJnlLine.VALIDATE("Source Code", BondSetup."Comm. Voucher Source Code");
        GenJnlLine."System-Created Entry" := TRUE;
        //  GenJnlLine.INSERT;
        GenJnlPostLine.RUN(GenJnlLine);


        MESSAGE('Document Post successfully');
        Rec.MODIFYALL("Posted Doc. No.", Rec."Document No.");
        Rec.MODIFYALL(Status, Rec.Status::Posted);
    end;

    local procedure PaidToOnAfterValidate()
    begin
        GenerateCommAmt;
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        GenerateCommAmt;
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GenerateCommAmt;
        ResetPane;
    end;

    local procedure VoucherNoFiltOnActivate()
    begin
        IF DocNoGenerated THEN
            ResetDocNo;
    end;

    local procedure PaidToOnActivate()
    begin
        IF DocNoGenerated THEN
            ResetDocNo;
    end;

    local procedure VoucherNoFiltOnInputChange(var Text: Text[1024])
    begin
        VoucherSelected := FALSE;
    end;

    local procedure CashPaymentModeOnValidate()
    begin
        IF NOT (CashPaymentEditable) THEN
            ERROR(Text666, PaymentMode);
    end;

    local procedure ChequePaymentModeOnValidate()
    begin
        IF NOT (ChequePaymentEditable) THEN
            ERROR(Text666, PaymentMode);
    end;
}

