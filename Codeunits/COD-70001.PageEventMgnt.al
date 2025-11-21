codeunit 70001 "BBG Page Event Mgnt."
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    [EventSubscriber(ObjectType::Page, Page::"General Journal", OnBeforeActionEvent, 'Post', false, false)]
    local procedure OnBeforeActionEventPost_GeneralJournal(var Rec: Record "Gen. Journal Line")
    var
        MemberOf: Record "Access Control";
        GenJnlLineL: Record "Gen. Journal Line";
        CheckLine: Codeunit "Gen. Jnl.-Check Line";
        LastNo: Code[20];
        GLEntry: Record "G/L Entry";
    Begin
        Rec.SETRANGE(Verified, TRUE);

        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');



        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'DDS-G/L-JOURNAL POST');
        IF NOT MemberOf.FIND('-') THEN
            ERROR('You don''t have permission Post the entries...');

        //JPL60 START
        GenJnlLineL.RESET;
        GenJnlLineL.COPYFILTERS(Rec);
        IF GenJnlLineL.FIND('-') THEN
            REPEAT
                IF GenJnlLineL."Order Ref No." <> '' THEN BEGIN
                    GenJnlLineL.TESTFIELD("Posting Type");
                    //    GenJnlLineL.TESTFIELD("Milestone Code");
                    GenJnlLineL.TESTFIELD("Ref Document Type", GenJnlLineL."Ref Document Type"::Order);
                END;
                IF (GenJnlLineL."Account Type" = GenJnlLineL."Account Type"::Vendor) OR
                   (GenJnlLineL."Bal. Account Type" = GenJnlLineL."Bal. Account Type"::Vendor) THEN;
            //CheckLine.CheckPostingType(GenJnlLineL);
            UNTIL GenJnlLineL.NEXT = 0;
        //JPL06 STOP

        LastNo := '';
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN
            LastNo := GLEntry."Document No.";
    End;

    [EventSubscriber(ObjectType::Page, Page::"General Journal", OnAfterActionEvent, 'Post', false, false)]
    local procedure OnAfterActionEventPost_GeneralJournal(var Rec: Record "Gen. Journal Line")
    var
        LastNo: Code[20];
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN BEGIN
            IF LastNo <> GLEntry."Document No." THEN
                MESSAGE('Last Voucher No Posted = %1', GLEntry."Document No.");
        end;
    End;

    [EventSubscriber(ObjectType::Page, Page::"General Journal", OnBeforeActionEvent, 'PostAndPrint', false, false)]
    local procedure OnBeforeActionEventPostAndPrint_GeneralJournal(var Rec: Record "Gen. Journal Line")
    begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice", OnAfterActionEvent, 'Post', false, false)]
    local procedure OnAfterActionEventPost_SalesInvoice(var Rec: Record "Sales Header")
    var
        ICOutboxTransaction: Record "IC Outbox Transaction";
    Begin
        COMMIT;
        ICOutboxTransaction.DELETEALL;  //ALLE 300724
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Quote", OnAfterActionEvent, 'MakeOrder', false, false)]
    local procedure OnAfterActionEventMakeOrder_PurchaseQuote(var Rec: Record "Purchase Header")
    begin
        // ALLEAA 10.01.11
        Rec.TESTFIELD("Indent No.");
        Rec.TESTFIELD("Enquiry No.");
        // ALLEAA 10.01.11
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Invoice", OnBeforeActionEvent, 'Post', false, false)]
    local procedure OnBeforeActionEventPost_PurchaseInvoice(var Rec: Record "Purchase Header")
    var
        SalesHeader: Record "Sales Header";
        PInvHd: Record "Purch. Inv. Header";
        GLEn: Record "G/L Entry";
        PRcpt: Record "Purch. Rcpt. Header";
        PHeadRec: Record "Purchase Header";
        PuchLines: Record "Purchase Line";
        Unitsetup: Record "unit setup";
    begin
        //ALLETDK>>
        IF Rec."Posting No." <> '' THEN BEGIN
            GLEn.RESET;
            GLEn.SETRANGE("Document No.", Rec."Posting No.");
            IF GLEn.FINDFIRST THEN
                ERROR('Posted Entry already exist with Document No. %1', Rec."Posting No.");
            IF (PInvHd.GET(Rec."Posting No.") AND (PInvHd."Pre-Assigned No." = Rec."No.")) THEN
                PInvHd.DELETE(TRUE);
        END;
        IF Rec."Receiving No." <> '' THEN BEGIN
            IF PRcpt.GET(Rec."Receiving No.") AND (Rec."Posting Description" = PRcpt."Posting Description") THEN
                PRcpt.DELETE(TRUE);
        END;
        //ALLETDK<<
        //IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN // ALLE MM Code Commented
        //CODEUNIT.RUN(CODEUNIT::"Purch.-Post (Yes/No)", Rec);
        //alleab

        IF PHeadRec.GET(PHeadRec."Document Type"::Order, Rec."Order Ref. No.") THEN;  //311224 code added
        IF PHeadRec.Amended = TRUE THEN
            PHeadRec.TESTFIELD(PHeadRec."Amendment Approved", TRUE);
        //alleab

        //09052025 Code added start
        IF Rec."Document Type" = Rec."Document Type"::Invoice THEN begin
            Unitsetup.GET;
            If Unitsetup."Gift Control A/c" <> '' THEN BEGIN

                PuchLines.RESET;
                PuchLines.SetRange("Document Type", PuchLines."Document Type"::Invoice);
                PuchLines.SetRange("Document No.", Rec."No.");
                PuchLines.SetRange(Type, PuchLines.Type::"G/L Account");
                PuchLines.SetRange("No.", Unitsetup."Gift Control A/c");
                PuchLines.SetRange("Ref. Gift Item No.", '');
                IF PuchLines.FindFirst() then
                    PuchLines.TestField("Ref. Gift Item No.");

            END;
        end;
        //09052025 Code added END



    End;

    [EventSubscriber(ObjectType::Page, Page::"Apply Customer Entries", OnBeforeEarlierPostingDateError, '', false, false)]
    local procedure OnBeforeActionEventSetAppliestoID_ApplyCustomerEntries(ApplyingCustLedgerEntry: Record "Cust. Ledger Entry"; CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        Textalle001: Label 'You are not allowed to apply an entry with different Dimension code. Applying Entry Dimesnion is %1 & Applies to ID Dimension is %2';
    begin
        //ALLAB
        IF (ApplyingCustLedgerEntry."Global Dimension 1 Code" <> '') THEN
            IF (ApplyingCustLedgerEntry."Global Dimension 1 Code" <> CustLedgerEntry."Global Dimension 1 Code") THEN
                ERROR(Textalle001, ApplyingCustLedgerEntry."Global Dimension 1 Code", CustLedgerEntry."Global Dimension 1 Code");
        //alleab
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Journal", OnBeforeActionEvent, 'Post', false, false)]
    local procedure OnBeforeActionEventPost_PurchaseJournal(var Rec: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
    Begin
        LastNo := '';
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN
            LastNo := GLEntry."Document No.";

    End;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Journal", OnAfterActionEvent, 'Post', false, false)]
    local procedure OnAfterActionEventMakeOrder_PurchaseJournal(var Rec: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
    begin
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN BEGIN
            IF LastNo <> GLEntry."Document No." THEN
                MESSAGE('Last Voucher No Posted = %1', GLEntry."Document No.");
        END;
    End;

    [EventSubscriber(ObjectType::Page, Page::"Cash Receipt Journal", OnBeforeActionEvent, 'Post', false, false)]
    local procedure OnBeforeActionEventPost_CashReceiptJournal(var Rec: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
        MemberOF: Record "Access Control";
        GenJnlLineL: Record "Gen. Journal Line";
        CheckLine: Codeunit "Gen. Jnl.-Check Line";
    Begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');


        //may 1.0
        MemberOF.RESET;
        MemberOF.SETRANGE("User Name", USERID);
        MemberOF.SETFILTER("Role ID", 'DDS-G/L-JOURNAL POST');
        IF NOT MemberOF.FIND('-') THEN
            ERROR('You don''t have permission Post the entries...');

        //JPL60 START
        GenJnlLineL.RESET;
        GenJnlLineL.COPYFILTERS(Rec);
        IF GenJnlLineL.FIND('-') THEN
            REPEAT
                IF GenJnlLineL."Order Ref No." <> '' THEN BEGIN
                    GenJnlLineL.TESTFIELD("Posting Type");
                    GenJnlLineL.TESTFIELD("Milestone Code");
                    GenJnlLineL.TESTFIELD("Ref Document Type", GenJnlLineL."Ref Document Type"::Order);
                END;
                IF (GenJnlLineL."Account Type" = GenJnlLineL."Account Type"::Vendor) OR
                   (GenJnlLineL."Bal. Account Type" = GenJnlLineL."Bal. Account Type"::Vendor) THEN;
            //CheckLine.CheckPostingType(GenJnlLineL);
            UNTIL GenJnlLineL.NEXT = 0;
        //JPL06 STOP
        LastNo := '';
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN
            LastNo := GLEntry."Document No.";

    End;

    [EventSubscriber(ObjectType::Page, Page::"Cash Receipt Journal", OnAfterActionEvent, 'Post', false, false)]
    local procedure OnAfterActionEventMakeOrder_CashReceiptJournal(var Rec: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
    Begin
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN BEGIN
            IF LastNo <> GLEntry."Document No." THEN
                MESSAGE('Last Voucher No Posted = %1', GLEntry."Document No.");

        End;
    End;

    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", OnBeforeActionEvent, 'Post', false, false)]
    local procedure OnBeforeActionEventPost_PaymentJournal(var Rec: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
        MemberOf: Record "Access Control";
        GenJnlLineL: Record "Gen. Journal Line";
        PO: Record "Purchase Header";
        CheckLine: Codeunit "Gen. Jnl.-Check Line";
    Begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');


        //may 1.0
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'DDS-G/L-JOURNAL POST');
        IF NOT MemberOf.FIND('-') THEN
            ERROR('You don''t have permission Post the entries...');


        //JPL60 START
        GenJnlLineL.RESET;
        GenJnlLineL.COPYFILTERS(Rec);
        IF GenJnlLineL.FIND('-') THEN
            REPEAT
                IF GenJnlLineL."Order Ref No." <> '' THEN BEGIN
                    GenJnlLineL.TESTFIELD("Posting Type");
                    GenJnlLineL.TESTFIELD("Milestone Code");
                    GenJnlLineL.TESTFIELD("Ref Document Type", GenJnlLineL."Ref Document Type"::Order);
                    IF GenJnlLineL."Document Type" = GenJnlLineL."Document Type"::Payment THEN BEGIN
                        PO.GET(PO."Document Type"::Order, GenJnlLineL."Order Ref No.");
                        IF PO."Work Tax Applicable" THEN;
                        //GenJnlLineL.TESTFIELD("Work Tax Amount");
                    END;

                END;
                IF (GenJnlLineL."Account Type" = GenJnlLineL."Account Type"::Vendor) OR
                   (GenJnlLineL."Bal. Account Type" = GenJnlLineL."Bal. Account Type"::Vendor) THEN;
            //CheckLine.CheckPostingType(GenJnlLineL);

            UNTIL GenJnlLineL.NEXT = 0;

        //JPL06 STOP

        LastNo := '';
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN
            LastNo := GLEntry."Document No.";

    End;

    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", OnAfterActionEvent, 'Post', false, false)]
    local procedure OnAfterActionEventMakeOrder_PaymentJournal(var Rec: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
    Begin
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN BEGIN
            IF LastNo <> GLEntry."Document No." THEN
                MESSAGE('Last Voucher No Posted = %1', GLEntry."Document No.");

        END;
    End;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Bank Acc. Recon. Post (Yes/No)", OnBeforeBankAccReconPostYesNo, '', false, false)]
    local procedure OnBeforeBankAccReconPostYesNo_BankAccReconPostYesNo(var BankAccReconciliation: Record "Bank Acc. Reconciliation"; var Handled: Boolean; var Result: Boolean)
    var
        RBankAccRecoLine: Record "Bank Acc. Reconciliation Line";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        StatementNo: Code[20];
        BankAcNo: Code[20];
        BankAccReconciliationPage: Page "Bank Acc. Reconciliation";
    Begin
        //ALLETDK141112..BEGIN
        CLEAR(StatementNo);
        CLEAR(BankAcNo);
        CLEAR(RBankAccRecoLine);
        RBankAccRecoLine.RESET;
        RBankAccRecoLine.SETRANGE("Bank Account No.", BankAccReconciliation."Bank Account No.");
        RBankAccRecoLine.SETRANGE("Statement No.", BankAccReconciliation."Statement No.");
        IF RBankAccRecoLine.FINDSET THEN
            REPEAT
                RBankAccRecoLine.TESTFIELD("Value Date");
                IF RBankAccRecoLine.Bounced THEN
                    RBankAccRecoLine.TESTFIELD(BouncedEntryPosted);
            UNTIL RBankAccRecoLine.NEXT = 0;
        StatementNo := BankAccReconciliation."Statement No.";
        BankAcNo := BankAccReconciliation."Bank Account No.";
        //CODEUNIT.RUN(CODEUNIT::"Bank Acc. Recon. Post (Yes/No)", Rec);
        //   BankAccReconciliationPage.DevlopmentChequeClearance(BankAcNo, StatementNo);  //BBG2.O  //311224 Code shift down
        // BankAccReconciliationPage.ChequeClearance(BankAcNo, StatementNo);  //311224 Code shift down
        //ALLETDK141112..END
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Reconciliation Post", OnAfterFinalizePost, '', false, false)]
    local procedure OnAfterFinalizePost(var BankAccReconciliation: Record "Bank Acc. Reconciliation")
    var

    begin
        DevlopmentChequeClearance(BankAccReconciliation."Bank Account No.", BankAccReconciliation."Statement No.");
        ChequeClearance(BankAccReconciliation."Bank Account No.", BankAccReconciliation."Statement No.");
    End;

    procedure DevlopmentChequeClearance(BankAccountNo: Code[20]; StatementNo: Code[20])
    var

        BankAccStatmntLine: Record "Bank Account Statement Line";
        AppPayEntry: Record "Application Pmt Devlop. Entry";
        NewAppPayEntry: Record "New Application DevelopmntLine";
        RecAppPmtEntry: Record "Application Pmt Devlop. Entry";
        Newconforder: Record "New Confirmed Order";
        Conforder_1: Record "New Confirmed Order";
    begin

        CLEAR(BankAccStatmntLine);
        BankAccStatmntLine.RESET;
        BankAccStatmntLine.SETRANGE("Bank Account No.", BankAccountNo);
        BankAccStatmntLine.SETRANGE("Statement No.", StatementNo);
        IF BankAccStatmntLine.FINDSET THEN
            REPEAT
                BankAccStatmntLine.CALCFIELDS("Development Application No.", "Development Appl. Rcpt LineNo.");  //ALLEDK 111116
                CLEAR(AppPayEntry);
                AppPayEntry.RESET;
                AppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Development Application No.");
                AppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::" ");
                AppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Check No.");
                IF BankAccStatmntLine."Development Appl. Rcpt LineNo." <> 0 THEN
                    AppPayEntry.SETRANGE("Receipt Line No.", BankAccStatmntLine."Development Appl. Rcpt LineNo.");  //ALLEDK 111116
                IF AppPayEntry.FINDFIRST THEN BEGIN
                    AppPayEntry."Cheque Status" := AppPayEntry."Cheque Status"::Cleared;    //120816
                    AppPayEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";  //120816
                    AppPayEntry.MODIFY;                                                     //120816
                    NewAppPayEntry.RESET;
                    NewAppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Development Application No.");
                    NewAppPayEntry.SETRANGE("Line No.", AppPayEntry."Receipt Line No.");
                    IF NewAppPayEntry.FINDFIRST THEN BEGIN
                        NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Cleared;
                        NewAppPayEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
                        NewAppPayEntry.MODIFY;
                    END;
                END;
            UNTIL BankAccStatmntLine.NEXT = 0;
    end;

    procedure ChequeClearance(BankAccountNo: Code[20]; StatementNo: Code[20])
    var

        BankAccStatmntLine: Record "Bank Account Statement Line";
        AppPayEntry: Record "Application Payment Entry";
        NewAppPayEntry: Record "NewApplication Payment Entry";
        RecAppPmtEntry: Record "Application Payment Entry";
        Newconforder: Record "New Confirmed Order";
        Conforder_1: Record "New Confirmed Order";
        AppPayEntry_2: Record "Application Payment Entry";
        ApplicationDevelopmentLine: Record "New Application DevelopmntLine";
        v_AppEntry: Record "Application Payment Entry";
        PostPayment: Codeunit PostPayment;
        CompanyWiseAccount: Record "Company wise G/L Account";
        APPENTRY_1: Record "Application Payment Entry";
        UnitPaymentEntry: Record "Unit Payment Entry";
        NewAppEntry: Record "NewApplication Payment Entry";
    begin
        CLEAR(BankAccStatmntLine);
        BankAccStatmntLine.RESET;
        BankAccStatmntLine.SETRANGE("Bank Account No.", BankAccountNo);
        BankAccStatmntLine.SETRANGE("Statement No.", StatementNo);
        IF BankAccStatmntLine.FINDSET THEN
            REPEAT
                BankAccStatmntLine.CALCFIELDS("Application No.", "Receipt Line No.");  //ALLEDK 111116
                CLEAR(AppPayEntry);
                AppPayEntry.RESET;
                AppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
                AppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::" ");
                AppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Check No.");
                IF BankAccStatmntLine."Receipt Line No." <> 0 THEN
                    AppPayEntry.SETRANGE("Receipt Line No.", BankAccStatmntLine."Receipt Line No.");  //ALLEDK 111116
                IF AppPayEntry.FINDFIRST THEN BEGIN
                    IF AppPayEntry."Payment Mode" <> AppPayEntry."Payment Mode"::"Refund Bank" THEN     //120816
                        PostPayment.ChequeClearance(AppPayEntry, BankAccStatmntLine."Value Date")
                    ELSE IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Bank") THEN BEGIN  //120816
                        AppPayEntry."Cheque Status" := AppPayEntry."Cheque Status"::Cleared;    //120816
                        AppPayEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";  //120816
                        AppPayEntry.MODIFY;                                                     //120816
                    END;                                                                      //120816

                    NewAppPayEntry.RESET;
                    NewAppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
                    IF BankAccStatmntLine."Receipt Line No." <> 0 THEN
                        NewAppPayEntry.SETRANGE("Line No.", BankAccStatmntLine."Receipt Line No.");  //ALLEDK 111116
                    CompanyWiseAccount.RESET;
                    CompanyWiseAccount.SETRANGE(CompanyWiseAccount."MSC Company", TRUE);
                    IF CompanyWiseAccount.FINDFIRST THEN
                        IF (COMPANYNAME = CompanyWiseAccount."Company Code") THEN BEGIN
                            NewAppPayEntry.SETRANGE("Posted Document No.", AppPayEntry."Posted Document No.");
                            APPENTRY_1.RESET;
                            APPENTRY_1.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
                            IF BankAccStatmntLine."Receipt Line No." = 0 THEN                          //ALLEDK 111116
                                APPENTRY_1.SETRANGE("Posted Document No.", AppPayEntry."Posted Document No.")
                            ELSE
                                APPENTRY_1.SETRANGE("Line No.", AppPayEntry."Line No.");                     //ALLEDK 111116
                            IF APPENTRY_1.FINDFIRST THEN BEGIN
                                APPENTRY_1."Cheque Status" := APPENTRY_1."Cheque Status"::Cleared;
                                APPENTRY_1."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
                                APPENTRY_1.MODIFY;
                            END;
                        END ELSE BEGIN
                            IF BankAccStatmntLine."Receipt Line No." = 0 THEN BEGIN                    //ALLEDK 111116
                                IF AppPayEntry."MSC Post Doc. No." <> '' THEN
                                    NewAppPayEntry.SETRANGE("Posted Document No.", AppPayEntry."MSC Post Doc. No.")
                                ELSE
                                    NewAppPayEntry.SETRANGE("Line No.", AppPayEntry."Line No.");
                            END ELSE BEGIN                                                                //ALLEDK 111116
                                NewAppPayEntry.SETRANGE("Line No.", AppPayEntry."Receipt Line No.");        //ALLEDK 111116
                            END;
                        END;

                    IF NewAppPayEntry.FINDSET THEN
                        REPEAT
                            NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Cleared;
                            NewAppPayEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
                            NewAppPayEntry."BRS Created All Comp From MSC" := TRUE;
                            NewAppPayEntry."BRS Date in All Comp From MSC" := TODAY;
                            NewAppPayEntry.MODIFY;
                        UNTIL NewAppPayEntry.NEXT = 0;
                    //Alle 040320 Start
                    UnitPaymentEntry.RESET;
                    UnitPaymentEntry.SETRANGE("Document No.", AppPayEntry."Document No.");
                    UnitPaymentEntry.SETRANGE("Posted Document No.", AppPayEntry."Posted Document No.");
                    IF UnitPaymentEntry.FINDSET THEN BEGIN
                        REPEAT
                            AppPayEntry_2.RESET;
                            AppPayEntry_2.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
                            AppPayEntry_2.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::" ");
                            AppPayEntry_2.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Check No.");
                            IF BankAccStatmntLine."Receipt Line No." <> 0 THEN
                                AppPayEntry_2.SETRANGE("Receipt Line No.", BankAccStatmntLine."Receipt Line No.");  //ALLEDK 111116
                            IF AppPayEntry_2.FINDFIRST THEN BEGIN
                                AppPayEntry_2."Cheque Status" := AppPayEntry_2."Cheque Status"::Cleared;
                                AppPayEntry_2."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
                                AppPayEntry_2.MODIFY;
                            END;
                        UNTIL UnitPaymentEntry.NEXT = 0;
                        NewAppEntry.RESET;
                        NewAppEntry.SETRANGE("Document No.", AppPayEntry."Document No.");
                        NewAppEntry.SETRANGE("Line No.", AppPayEntry."Receipt Line No.");
                        IF NewAppEntry.FINDFIRST THEN BEGIN
                            NewAppEntry."Cheque Status" := NewAppEntry."Cheque Status"::Cleared;
                            NewAppEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
                            NewAppEntry.MODIFY;
                        END;
                    END;
                    //Alle 040320 END
                END ELSE BEGIN
                    CLEAR(NewAppPayEntry);
                    NewAppPayEntry.RESET;
                    NewAppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
                    NewAppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::" ");
                    NewAppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Check No.");
                    IF BankAccStatmntLine."Receipt Line No." <> 0 THEN
                        NewAppPayEntry.SETRANGE("Line No.", BankAccStatmntLine."Receipt Line No.");   //ALLEDK 111116
                    IF NewAppPayEntry.FINDFIRST THEN BEGIN
                        NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Cleared;
                        NewAppPayEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
                        NewAppPayEntry.MODIFY;
                    END;
                END;
            UNTIL BankAccStatmntLine.NEXT = 0;

    end;



    [EventSubscriber(ObjectType::Page, Page::"Assembly Order", OnBeforeActionEvent, "P&ost", false, false)]
    local procedure OnBeforeActionEventPost_AssemblyOrder(var Rec: Record "Assembly Header")
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.RESET;
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Allow Back Date Posting" THEN BEGIN
                IF Rec."Posting Date" > TODAY THEN
                    ERROR('Posting Date can not be greater than =' + FORMAT(TODAY));
            END ELSE
                IF Rec."Posting Date" <> TODAY THEN
                    ERROR('Posting Date can not be differ from Today Date =' + FORMAT(TODAY));
        END;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Bank Receipt Voucher", OnBeforeActionEvent, Post, false, false)]
    local procedure OnBeforeActionEventPost_BankReceiptVoucher(var Rec: Record "Gen. Journal Line")
    var
        genline: Record "Gen. Journal Line";
        Genjnlline: Record "Gen. Journal Line";
        OldDoc: Code[20];
        "Gen. Journal Narration": Record "Gen. Journal Narration"; //16549;
        LastNo: Code[20];
        GLEntry: Record "G/L Entry";
        text002: Label 'There is Voucher Narration Missing Do you still want to post the entries %1.';
        PostGenjnlLinesCheck: Codeunit "Post Genjnl Lines Check";
        Memberof: Record "Access Control";

    begin
        //ALLE-PKS12
        OldDoc := '';
        Genjnlline.SETFILTER(Genjnlline."Journal Template Name", Rec."Journal Template Name");
        Genjnlline.SETFILTER(Genjnlline."Journal Batch Name", Rec."Journal Batch Name");
        IF Genjnlline.FIND('-') THEN
            REPEAT

                "Gen. Journal Narration".RESET;
                "Gen. Journal Narration".SETRANGE("Journal Template Name", Genjnlline."Journal Template Name");
                "Gen. Journal Narration".SETRANGE("Journal Batch Name", Genjnlline."Journal Batch Name");
                "Gen. Journal Narration".SETRANGE("Document No.", Genjnlline."Document No.");
                IF NOT "Gen. Journal Narration".FIND('-') THEN
                    IF OldDoc <> Genjnlline."Document No." THEN BEGIN
                        MESSAGE(text002, Genjnlline."Document No.");
                        OldDoc := Genjnlline."Document No.";
                    END;
            UNTIL Genjnlline.NEXT = 0;
        //ALLE-PKS12

        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');


        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'DDS-CRBRVPOST');
        IF NOT Memberof.FIND('-') THEN
            ERROR('You don''t have permission Post the entries...');



        LastNo := '';
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN
            LastNo := GLEntry."Document No.";
        //ALLE-PKS10
        Genjnlline.RESET;
        Genjnlline.SETFILTER(Genjnlline."Journal Template Name", Rec."Journal Template Name");
        Genjnlline.SETFILTER(Genjnlline."Journal Batch Name", Rec."Journal Batch Name");
        Genjnlline.SETRANGE(Genjnlline.Verified, TRUE);
        IF Genjnlline.FIND('-') THEN
            REPEAT
                genline.RESET;
                genline.SETFILTER(genline."Journal Template Name", Rec."Journal Template Name");
                genline.SETFILTER(genline."Journal Batch Name", Rec."Journal Batch Name");
                genline.SETRANGE(genline.Verified, TRUE);
                genline.SETRANGE(genline."Document No.", Genjnlline."Document No.");
                IF genline.FIND('-') THEN
                    REPEAT
                        IF genline."Shortcut Dimension 1 Code" <> Genjnlline."Shortcut Dimension 1 Code" THEN
                            ERROR('You must check the Region Code for the Document No %1', Genjnlline."Document No.");
                    UNTIL genline.NEXT = 0;
            UNTIL Genjnlline.NEXT = 0;
        //ALLE-PKS10

        //ALLEDK 190722
        CLEAR(PostGenjnlLinesCheck);
        PostGenjnlLinesCheck.CheckNarration(Rec);
        //ALLEDK 190722
    End;

    [EventSubscriber(ObjectType::Page, Page::"Bank Receipt Voucher", OnAfterActionEvent, 'Post', false, false)]
    local procedure OnAfterActionEventMakeOrder_BankReceiptVoucher(var Rec: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
    Begin
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN BEGIN
            IF LastNo <> GLEntry."Document No." THEN
                MESSAGE('Last Voucher No Posted = %1', GLEntry."Document No.");
        END;
    End;

    [EventSubscriber(ObjectType::Page, Page::"Bank Receipt Voucher", OnBeforeActionEvent, PostAndPrint, false, false)]
    local procedure OnBeforeActionEventPostAndPrint_BankReceiptVoucher(var Rec: Record "Gen. Journal Line")
    begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Contra Voucher", OnBeforeActionEvent, Post, false, false)]
    local procedure OnBeforeActionEventPost_ContraVoucher(var Rec: Record "Gen. Journal Line")
    var
        genline: Record "Gen. Journal Line";
        Genjnlline: Record "Gen. Journal Line";
        OldDoc: Code[20];
        "Gen. Journal Narration": Record "Gen. Journal Narration"; //16549;
        GenJnlLine1: Record "Gen. Journal Line";
        LastNo: Code[20];
        GLEntry: Record "G/L Entry";
        text002: Label 'There is Voucher Narration Missing Do you still want to post the entries %1.';
        PostGenjnlLinesCheck: Codeunit "Post Genjnl Lines Check";
        Memberof: Record "Access Control";

    Begin
        //ALLE-PKS12
        OldDoc := '';
        GenJnlLine.SETFILTER(GenJnlLine."Journal Template Name", Rec."Journal Template Name");
        GenJnlLine.SETFILTER(GenJnlLine."Journal Batch Name", Rec."Journal Batch Name");
        IF GenJnlLine.FIND('-') THEN
            REPEAT
                "Gen. Journal Narration".RESET;
                "Gen. Journal Narration".SETRANGE("Gen. Journal Narration"."Journal Template Name", GenJnlLine."Journal Template Name");
                "Gen. Journal Narration".SETRANGE("Gen. Journal Narration"."Journal Batch Name", GenJnlLine."Journal Batch Name");
                "Gen. Journal Narration".SETRANGE("Gen. Journal Narration"."Document No.", GenJnlLine."Document No.");
                IF NOT "Gen. Journal Narration".FIND('-') THEN
                    IF OldDoc <> GenJnlLine."Document No." THEN BEGIN
                        MESSAGE(Text002, GenJnlLine."Document No.");
                        OldDoc := GenJnlLine."Document No.";
                    END;
            UNTIL GenJnlLine.NEXT = 0;
        //ALLE-PKS12

        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');


        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'DDS-CRCONVPOST');
        IF NOT Memberof.FIND('-') THEN
            ERROR('You don''t have permission Post the entries...');


        LastNo := '';
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN
            LastNo := GLEntry."Document No.";
        //ALLE-PKS10
        GenJnlLine1.RESET;
        GenJnlLine1.SETFILTER(GenJnlLine1."Journal Template Name", Rec."Journal Template Name");
        GenJnlLine1.SETFILTER(GenJnlLine1."Journal Batch Name", Rec."Journal Batch Name");
        GenJnlLine1.SETRANGE(GenJnlLine1.Verified, TRUE);
        IF GenJnlLine1.FIND('-') THEN
            REPEAT
                genline.RESET;
                genline.SETFILTER(genline."Journal Template Name", Rec."Journal Template Name");
                genline.SETFILTER(genline."Journal Batch Name", Rec."Journal Batch Name");
                genline.SETRANGE(genline.Verified, TRUE);
                genline.SETRANGE(genline."Document No.", GenJnlLine1."Document No.");
                IF genline.FIND('-') THEN
                    REPEAT
                        IF genline."Shortcut Dimension 1 Code" <> GenJnlLine1."Shortcut Dimension 1 Code" THEN
                            ERROR('You must check the Region Code for the Document No %1', GenJnlLine1."Document No.");
                    UNTIL genline.NEXT = 0;
            UNTIL GenJnlLine1.NEXT = 0;
        //ALLE-PKS10
        //ALLEDK 190722
        CLEAR(PostGenjnlLinesCheck);
        PostGenjnlLinesCheck.CheckNarration(Rec);
        //ALLEDK 190722
    End;

    [EventSubscriber(ObjectType::Page, Page::"Contra Voucher", OnAfterActionEvent, 'Post', false, false)]
    local procedure OnAfterActionEventMakeOrder_ContraVoucher(var Rec: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
    Begin
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN BEGIN
            IF LastNo <> GLEntry."Document No." THEN
                MESSAGE('Last Voucher No Posted = %1', GLEntry."Document No.");
        END;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Contra Voucher", OnBeforeActionEvent, PostAndPrint, false, false)]
    local procedure OnBeforeActionEventPostAndPrint_ContraVoucher(var Rec: Record "Gen. Journal Line")
    begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');
    End;

    [EventSubscriber(ObjectType::Page, Page::"Journal Voucher", OnBeforeActionEvent, Post, false, false)]
    local procedure OnBeforeActionEventPost_JournalVoucher(var Rec: Record "Gen. Journal Line")
    var
        genline: Record "Gen. Journal Line";
        Genjnlline: Record "Gen. Journal Line";
        OldDoc: Code[20];
        "Gen. Journal Narration": Record "Gen. Journal Narration"; //16549;
        GenJnlLine1: Record "Gen. Journal Line";
        LastNo: Code[20];
        GLEntry: Record "G/L Entry";
        text002: Label 'There is Voucher Narration Missing Do you still want to post the entries %1.';
        PostGenjnlLinesCheck: Codeunit "Post Genjnl Lines Check";
        Memberof: Record "Access Control";
    Begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');

        //ALLE-PKS12
        OldDoc := '';
        Genjnlline.SETFILTER(Genjnlline."Journal Template Name", Rec."Journal Template Name");
        Genjnlline.SETFILTER(Genjnlline."Journal Batch Name", Rec."Journal Batch Name");
        IF Genjnlline.FIND('-') THEN
            REPEAT
                "Gen. Journal Narration".RESET;
                "Gen. Journal Narration".SETRANGE("Gen. Journal Narration"."Journal Template Name", Genjnlline."Journal Template Name");
                "Gen. Journal Narration".SETRANGE("Gen. Journal Narration"."Journal Batch Name", Genjnlline."Journal Batch Name");
                "Gen. Journal Narration".SETRANGE("Gen. Journal Narration"."Document No.", Genjnlline."Document No.");
                IF NOT "Gen. Journal Narration".FIND('-') THEN
                    IF OldDoc <> Genjnlline."Document No." THEN BEGIN
                        MESSAGE(Text002, Genjnlline."Document No.");
                        OldDoc := Genjnlline."Document No.";
                    END;
            UNTIL Genjnlline.NEXT = 0;
        //ALLE-PKS12

        memberof.RESET;
        memberof.SETRANGE("User Name", USERID);
        memberof.SETFILTER("Role ID", 'DDS-CRJVPOST');
        IF NOT memberof.FIND('-') THEN
            ERROR('You dont have permission to Post the entries...');

        LastNo := '';
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN
            LastNo := GLEntry."Document No.";
        //ALLE-PKS10
        Genjnlline.RESET;
        Genjnlline.SETFILTER(Genjnlline."Journal Template Name", Rec."Journal Template Name");
        Genjnlline.SETFILTER(Genjnlline."Journal Batch Name", Rec."Journal Batch Name");
        Genjnlline.SETRANGE(Genjnlline.Verified, TRUE);
        IF Genjnlline.FIND('-') THEN
            REPEAT
                genline.RESET;
                genline.SETFILTER(genline."Journal Template Name", Rec."Journal Template Name");
                genline.SETFILTER(genline."Journal Batch Name", Rec."Journal Batch Name");
                genline.SETRANGE(genline.Verified, TRUE);
                genline.SETRANGE(genline."Document No.", Genjnlline."Document No.");
                IF genline.FIND('-') THEN
                    REPEAT
                        IF genline."Shortcut Dimension 1 Code" <> Genjnlline."Shortcut Dimension 1 Code" THEN
                            ERROR('You must check the Region Code for the Document No %1', Genjnlline."Document No.");
                    UNTIL genline.NEXT = 0;
            UNTIL Genjnlline.NEXT = 0;
        //ALLE-PKS10

        //ALLEDK 190722
        CLEAR(PostGenjnlLinesCheck);
        PostGenjnlLinesCheck.CheckNarration(Rec);
        //ALLEDK 190722
    end;

    [EventSubscriber(ObjectType::Page, Page::"Journal Voucher", OnAfterActionEvent, 'Post', false, false)]
    local procedure OnAfterActionEventMakeOrder_JournalVoucher(var Rec: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
    Begin
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN BEGIN
            IF LastNo <> GLEntry."Document No." THEN
                MESSAGE('Last Voucher No Posted = %1', GLEntry."Document No.");
        END;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Journal Voucher", OnBeforeActionEvent, PostAndPrint, false, false)]
    local procedure OnBeforeActionEventPostAndPrint_JournalVoucher(var Rec: Record "Gen. Journal Line")
    begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');

    End;

    [EventSubscriber(ObjectType::Page, Page::"Cash Payment Voucher", OnBeforeActionEvent, Post, false, false)]
    local procedure OnBeforeActionEventPost_CashPaymentVoucher(var Rec: Record "Gen. Journal Line")
    var
        genline: Record "Gen. Journal Line";
        Genjnlline: Record "Gen. Journal Line";
        OldDoc: Code[20];
        "Gen. Journal Narration": Record "Gen. Journal Narration"; //16549;
        GenJnlLine1: Record "Gen. Journal Line";
        LastNo: Code[20];
        GLEntry: Record "G/L Entry";
        text002: Label 'There is Voucher Narration Missing Do you still want to post the entries %1.';
        PostGenjnlLinesCheck: Codeunit "Post Genjnl Lines Check";
        Memberof: Record "Access Control";
    Begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');

        Genjnlline.RESET;
        Genjnlline.SETFILTER(Genjnlline."Journal Template Name", Rec."Journal Template Name");
        Genjnlline.SETFILTER(Genjnlline."Journal Batch Name", Rec."Journal Batch Name");
        Genjnlline.SETRANGE(Genjnlline.Verified, TRUE);
        IF Genjnlline.FIND('-') THEN
            REPEAT
                genline.RESET;
                genline.SETFILTER(genline."Journal Template Name", Rec."Journal Template Name");
                genline.SETFILTER(genline."Journal Batch Name", Rec."Journal Batch Name");
                genline.SETRANGE(genline.Verified, TRUE);
                genline.SETRANGE(genline."Document No.", Genjnlline."Document No.");
                IF genline.FIND('-') THEN
                    REPEAT
                        IF genline."Shortcut Dimension 1 Code" <> Genjnlline."Shortcut Dimension 1 Code" THEN
                            ERROR('You must check the Region Code for the Document No %1', Genjnlline."Document No.");
                    UNTIL genline.NEXT = 0;
            UNTIL Genjnlline.NEXT = 0;
        //ALLE-PKS10

        //ALLEDK 190722
        CLEAR(PostGenjnlLinesCheck);
        PostGenjnlLinesCheck.CheckNarration(Rec);
        //ALLEDK 190722

    End;

    [EventSubscriber(ObjectType::Page, Page::"Cash Payment Voucher", OnBeforeActionEvent, PostAndPrint, false, false)]
    local procedure OnBeforeActionEventPostAndPrint_CashPaymentVoucher(var Rec: Record "Gen. Journal Line")
    begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');
    End;

    [EventSubscriber(ObjectType::Page, Page::"Bank Payment Voucher", OnBeforeActionEvent, Post, false, false)]
    local procedure OnBeforeActionEventPost_BankPaymentVoucher(var Rec: Record "Gen. Journal Line")
    var
        genline: Record "Gen. Journal Line";
        Genjnlline: Record "Gen. Journal Line";
        OldDoc: Code[20];
        "Gen. Journal Narration": Record "Gen. Journal Narration"; //16549;
        GenJnlLine1: Record "Gen. Journal Line";
        LastNo: Code[20];
        GLEntry: Record "G/L Entry";
        text002: Label 'There is Voucher Narration Missing Do you still want to post the entries %1.';
        PostGenjnlLinesCheck: Codeunit "Post Genjnl Lines Check";
        Memberof: Record "Access Control";
    Begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');

        GenJnlLine.RESET;
        GenJnlLine.SETFILTER(GenJnlLine."Journal Template Name", Rec."Journal Template Name");
        GenJnlLine.SETFILTER(GenJnlLine."Journal Batch Name", Rec."Journal Batch Name");
        GenJnlLine.SETRANGE(GenJnlLine.Verified, TRUE);
        IF GenJnlLine.FINDSET THEN
            REPEAT
                GenJnlLine.TESTFIELD("Cheque No.");
                GenJnlLine.TESTFIELD("Cheque Date");

                genline.RESET;
                genline.SETFILTER(genline."Journal Template Name", Rec."Journal Template Name");
                genline.SETFILTER(genline."Journal Batch Name", Rec."Journal Batch Name");
                genline.SETRANGE(genline.Verified, TRUE);
                genline.SETRANGE(genline."Document No.", GenJnlLine."Document No.");
                IF genline.FIND('-') THEN
                    REPEAT
                        IF genline."Shortcut Dimension 1 Code" <> GenJnlLine."Shortcut Dimension 1 Code" THEN
                            ERROR('You must check the Region Code for the Document No %1', GenJnlLine."Document No.");
                    UNTIL genline.NEXT = 0;
            UNTIL GenJnlLine.NEXT = 0;
        //ALLE-PKS10

        //ALLEDK 190722
        CLEAR(PostGenjnlLinesCheck);
        PostGenjnlLinesCheck.CheckNarration(Rec);
        //ALLEDK 190722
    End;

    [EventSubscriber(ObjectType::Page, Page::"Bank Payment Voucher", OnBeforeActionEvent, PostAndPrint, false, false)]
    local procedure OnBeforeActionEventPostAndPrint_BankPaymentVoucher(var Rec: Record "Gen. Journal Line")
    begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');
    End;

    [EventSubscriber(ObjectType::Page, Page::"Cash Receipt Voucher", OnBeforeActionEvent, Post, false, false)]
    local procedure OnBeforeActionEventPost_CashReceiptVoucher(var Rec: Record "Gen. Journal Line")
    var
        genline: Record "Gen. Journal Line";
        Genjnlline: Record "Gen. Journal Line";
        OldDoc: Code[20];
        "Gen. Journal Narration": Record "Gen. Journal Narration"; //16549;
        GenJnlLine1: Record "Gen. Journal Line";
        LastNo: Code[20];
        GLEntry: Record "G/L Entry";
        text002: Label 'There is Voucher Narration Missing Do you still want to post the entries %1.';
        PostGenjnlLinesCheck: Codeunit "Post Genjnl Lines Check";
        Memberof: Record "Access Control";
    Begin
        //ALLE-PKS12
        OldDoc := '';
        Genjnlline.SETFILTER(Genjnlline."Journal Template Name", Rec."Journal Template Name");
        Genjnlline.SETFILTER(Genjnlline."Journal Batch Name", Rec."Journal Batch Name");
        IF Genjnlline.FIND('-') THEN
            REPEAT
                "Gen. Journal Narration".RESET;
                "Gen. Journal Narration".SETRANGE("Gen. Journal Narration"."Journal Template Name", Genjnlline."Journal Template Name");
                "Gen. Journal Narration".SETRANGE("Gen. Journal Narration"."Journal Batch Name", Genjnlline."Journal Batch Name");
                "Gen. Journal Narration".SETRANGE("Gen. Journal Narration"."Document No.", Genjnlline."Document No.");
                IF NOT "Gen. Journal Narration".FIND('-') THEN
                    IF OldDoc <> Genjnlline."Document No." THEN BEGIN
                        MESSAGE(Text002, Genjnlline."Document No.");
                        OldDoc := Genjnlline."Document No.";
                    END;
            UNTIL Genjnlline.NEXT = 0;
        //ALLE-PKS12


        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');


        memberof.RESET;
        memberof.SETRANGE("User Name", USERID);
        memberof.SETFILTER("Role ID", 'DDS-CRCRVPOST');
        IF NOT memberof.FIND('-') THEN
            ERROR('You don''t have permission Post the entries...');

        LastNo := '';
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN
            LastNo := GLEntry."Document No.";
        //ALLE-PKS10
        Genjnlline.RESET;
        Genjnlline.SETFILTER(Genjnlline."Journal Template Name", Rec."Journal Template Name");
        Genjnlline.SETFILTER(Genjnlline."Journal Batch Name", Rec."Journal Batch Name");
        Genjnlline.SETRANGE(Genjnlline.Verified, TRUE);
        IF Genjnlline.FIND('-') THEN
            REPEAT
                genline.RESET;
                genline.SETFILTER(genline."Journal Template Name", Rec."Journal Template Name");
                genline.SETFILTER(genline."Journal Batch Name", Rec."Journal Batch Name");
                genline.SETRANGE(genline.Verified, TRUE);
                genline.SETRANGE(genline."Document No.", Genjnlline."Document No.");
                IF genline.FIND('-') THEN
                    REPEAT
                        IF genline."Shortcut Dimension 1 Code" <> Genjnlline."Shortcut Dimension 1 Code" THEN
                            ERROR('You must check the Region Code for the Document No %1', Genjnlline."Document No.");
                    UNTIL genline.NEXT = 0;
            UNTIL Genjnlline.NEXT = 0;
        //ALLE-PKS10

        //ALLEDK 190722
        CLEAR(PostGenjnlLinesCheck);
        PostGenjnlLinesCheck.CheckNarration(Rec);
        //ALLEDK 190722
    End;

    [EventSubscriber(ObjectType::Page, Page::"Cash Receipt Voucher", OnAfterActionEvent, 'Post', false, false)]
    local procedure OnAfterActionEventMakeOrder_CashReceiptVoucher(var Rec: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
    Begin
        GLEntry.RESET;
        IF GLEntry.FIND('+') THEN BEGIN
            IF LastNo <> GLEntry."Document No." THEN
                MESSAGE('Last Voucher No Posted = %1', GLEntry."Document No.");
        END;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Cash Receipt Voucher", OnBeforeActionEvent, PostAndPrint, false, false)]
    local procedure OnBeforeActionEventPostAndPrint_CashReceiptVoucher(var Rec: Record "Gen. Journal Line")
    begin
        Rec.SETRANGE(Verified, TRUE);
        IF Rec.COUNT = 0 THEN
            ERROR('Please verify the documents');

    End;

}