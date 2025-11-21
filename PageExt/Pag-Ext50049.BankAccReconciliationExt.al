pageextension 50049 "BBG Bank Acc. Reconciliat. Ext" extends "Bank Acc. Reconciliation"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Post)
        {
            action("Post &Bounce Entries")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    CompanywiseGLAccount: Record "Company wise G/L Account";
                    UserSetup: Record "User Setup";
                begin


                    CLEAR(BankAccRecoLine);
                    BankAccRecoLine.RESET;
                    BankAccRecoLine.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                    BankAccRecoLine.SETRANGE("Statement No.", Rec."Statement No.");
                    BankAccRecoLine.SETRANGE(Bounced, TRUE);
                    IF BankAccRecoLine.FINDSET THEN
                        REPEAT
                            BankAccRecoLine.TESTFIELD("Value Date");
                        UNTIL BankAccRecoLine.NEXT = 0;
                    CLEAR(BankAccRecoLine);
                    BankAccRecoLine.RESET;
                    BankAccRecoLine.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                    BankAccRecoLine.SETRANGE("Statement No.", Rec."Statement No.");
                    IF BankAccRecoLine.FINDLAST THEN
                        LineNo := BankAccRecoLine."Statement Line No.";

                    //ALLETDK261212..BEGIN
                    IF CONFIRM(Text50001, FALSE) THEN BEGIN
                        DevelopmentChequeBounce;  //BBG2.O
                        ChequeBounce;
                        MESSAGE('Bounced Entries have been posted sucessfully');
                        // SendBouncedSMS;  040619
                        CompanyInformation.GET;
                        IF CompanyInformation."Send Customer Cheque BounceSMS" THEN
                            SendCustomerChequeBouncSMS; //210824 Added new code for send SMS to customer and Associate.
                    END;
                    //ALLETDK261212..END
                end;
            }
            action("Auto Apply Entries")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                    Window.OPEN('Processing @1@@@@@@@@');
                    CurrRec := 0;

                    BankAccRecoLine.RESET;
                    BankAccRecoLine.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                    BankAccRecoLine.SETRANGE("Statement No.", Rec."Statement No.");
                    //BankAccRecoLine.SETRANGE(Bounced,FALSE); //ALLETDk
                    TotalRec := BankAccRecoLine.COUNT;
                    //ERROR('%1 %2 %3',"Bank Account No.","Statement No.",BankAccRecoLine.COUNT);
                    IF BankAccRecoLine.FINDSET THEN
                        REPEAT
                        // IF NOT BankAccRecoLine.Bounced THEN BEGIN
                        //     CurrRec := CurrRec + 1;
                        //     Window.UPDATE(1, ROUND(CurrRec / TotalRec * 10000, 1));
                        //     CASE BankAccRecoLine.Type OF
                        //         BankAccRecoLine.Type::"Bank Account Ledger Entry":
                        //             BEGIN
                        //                 IF (BankAccRecoLine."Check No." <> '') THEN BEGIN
                        //                     BankAccLedgerEntry.RESET;
                        //                     BankAccLedgerEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                        //                     BankAccLedgerEntry.SETRANGE(Open, TRUE);
                        //                     BankAccLedgerEntry.SETRANGE("Statement Status", BankAccLedgerEntry."Statement Status"::Open);
                        //                     BankAccLedgerEntry.SETRANGE("Cheque No.", BankAccRecoLine."Check No.");
                        //                     BankAccLedgerEntry.SETRANGE(Bounced, FALSE);
                        //                     //BankAccLedgerEntry.SETRANGE("Document Type",BankAccRecoLine."Document Type"); //ALLERK 19-03-2010.
                        //                     IF BankAccLedgerEntry.FINDSET THEN
                        //                         REPEAT
                        //                             BankAccEntrySetReconNo.ToggleReconNo(BankAccLedgerEntry, BankAccRecoLine, FALSE);
                        //                         UNTIL BankAccLedgerEntry.NEXT = 0;
                        //                 END;
                        //             END;
                        //         BankAccRecoLine.Type::"Check Ledger Entry":
                        //             BEGIN
                        //                 IF (BankAccRecoLine."Check No." <> '') THEN BEGIN
                        //                     CheckLedgerEntry.RESET;
                        //                     CheckLedgerEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                        //                     CheckLedgerEntry.SETRANGE(Open, TRUE);
                        //                     CheckLedgerEntry.SETRANGE("Statement Status", CheckLedgerEntry."Statement Status"::Open);
                        //                     CheckLedgerEntry.SETFILTER("Entry Status", '%1|%2', CheckLedgerEntry."Entry Status"::Posted,
                        //                      CheckLedgerEntry."Entry Status"::"Financially Voided");
                        //                     CheckLedgerEntry.SETRANGE("Check No.", BankAccRecoLine."Check No.");
                        //                     IF CheckLedgerEntry.FINDSET THEN BEGIN
                        //                         REPEAT
                        //                             CheckSetStmtNo.ToggleReconNo(CheckLedgerEntry, BankAccRecoLine, ChangeAmount);
                        //                         UNTIL CheckLedgerEntry.NEXT = 0;
                        //                     END ELSE BEGIN
                        //                         BankAccLedgerEntry.RESET;
                        //                         BankAccLedgerEntry.SETCURRENTKEY("Bank Account No.", Open);
                        //                         BankAccLedgerEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                        //                         BankAccLedgerEntry.SETRANGE(Open, TRUE);
                        //                         BankAccLedgerEntry.SETRANGE("Cheque No.", BankAccRecoLine."Check No.");
                        //                         BankAccLedgerEntry.SETRANGE("Statement Status", BankAccLedgerEntry."Statement Status"::Open);
                        //                         BankAccLedgerEntry.SETRANGE(Bounced, FALSE);
                        //                         IF BankAccLedgerEntry.FINDSET THEN
                        //                             REPEAT
                        //                                 BankAccEntrySetReconNo.ToggleReconNo(BankAccLedgerEntry, BankAccRecoLine, FALSE);
                        //                             UNTIL BankAccLedgerEntry.NEXT = 0;
                        //                     END;
                        //                 END;
                        //             END;
                        //     END;
                        // END ELSE BEGIN
                        //     CurrRec := CurrRec + 1;
                        //     Window.UPDATE(1, ROUND(CurrRec / TotalRec * 10000, 1));
                        //     CASE BankAccRecoLine.Type OF
                        //         BankAccRecoLine.Type::"Bank Account Ledger Entry":
                        //             BEGIN
                        //                 IF (BankAccRecoLine."Check No." <> '') THEN BEGIN
                        //                     BankAccLedgerEntry.RESET;
                        //                     BankAccLedgerEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                        //                     BankAccLedgerEntry.SETRANGE(Open, TRUE);
                        //                     BankAccLedgerEntry.SETRANGE("Statement Status", BankAccLedgerEntry."Statement Status"::Open);
                        //                     BankAccLedgerEntry.SETRANGE("Cheque No.", BankAccRecoLine."Check No.");
                        //                     BankAccLedgerEntry.SETRANGE(Bounced, TRUE);
                        //                     IF BankAccLedgerEntry.FINDSET THEN
                        //                         REPEAT
                        //                             BankAccEntrySetReconNo.ToggleReconNo(BankAccLedgerEntry, BankAccRecoLine, FALSE);
                        //                         UNTIL BankAccLedgerEntry.NEXT = 0;
                        //                 END;
                        //             END;
                        //         BankAccRecoLine.Type::"Check Ledger Entry":
                        //             BEGIN
                        //                 IF (BankAccRecoLine."Check No." <> '') THEN BEGIN
                        //                     CheckLedgerEntry.RESET;
                        //                     CheckLedgerEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                        //                     CheckLedgerEntry.SETRANGE(Open, TRUE);
                        //                     CheckLedgerEntry.SETRANGE("Statement Status", CheckLedgerEntry."Statement Status"::Open);
                        //                     CheckLedgerEntry.SETFILTER("Entry Status", '%1|%2', CheckLedgerEntry."Entry Status"::Posted,
                        //                      CheckLedgerEntry."Entry Status"::"Financially Voided");
                        //                     CheckLedgerEntry.SETRANGE("Check No.", BankAccRecoLine."Check No.");
                        //                     IF CheckLedgerEntry.FINDSET THEN BEGIN
                        //                         REPEAT
                        //                             CheckSetStmtNo.ToggleReconNo(CheckLedgerEntry, BankAccRecoLine, ChangeAmount);
                        //                         UNTIL CheckLedgerEntry.NEXT = 0;
                        //                     END ELSE BEGIN
                        //                         BankAccLedgerEntry.RESET;
                        //                         BankAccLedgerEntry.SETCURRENTKEY("Bank Account No.", Open);
                        //                         BankAccLedgerEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                        //                         BankAccLedgerEntry.SETRANGE(Open, TRUE);
                        //                         BankAccLedgerEntry.SETRANGE("Cheque No.", BankAccRecoLine."Check No.");
                        //                         BankAccLedgerEntry.SETRANGE("Statement Status", BankAccLedgerEntry."Statement Status"::Open);
                        //                         BankAccLedgerEntry.SETRANGE(Bounced, TRUE);
                        //                         IF BankAccLedgerEntry.FINDSET THEN
                        //                             REPEAT
                        //                                 BankAccEntrySetReconNo.ToggleReconNo(BankAccLedgerEntry, BankAccRecoLine, FALSE);
                        //                             UNTIL BankAccLedgerEntry.NEXT = 0;
                        //                     END;
                        //                 END;
                        //             END;
                        //     END;
                        // END;
                        UNTIL BankAccRecoLine.NEXT = 0;
                    Window.CLOSE;
                end;
            }
            action("Print Reco")
            {
                Image = "Report";
                Promoted = true;
                RunObject = Report "New Bank Reconciliation";
                ApplicationArea = All;
            }
        }

    }

    var
        myInt: Integer;
        ImportPGStatement: XMLport "Import Bank Reco";
        Window: Dialog;
        CurrRec: Integer;
        TotalRec: Integer;
        ChangeAmount: Boolean;
        BankAccReconciliation: Record "Bank Acc. Reconciliation";
        startdate: Date;
        enddate: Date;
        BankAccRecoLine: Record "Bank Acc. Reconciliation Line";
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccEntrySetReconNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
        CheckLedgerEntry: Record "Check Ledger Entry";
        CheckSetStmtNo: Codeunit "Check Entry Set Recon.-No.";


        BankLedgEntry: Record "Bank Account Ledger Entry";
        PostPayment: Codeunit PostPayment;
        SuggestLines: Report "Suggest Bank Acc. Recon. Lines";
        BankAccSetStmtNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
        LineNo: Decimal;
        CompanyWiseAccount: Record "Company wise G/L Account";
        UnitReversal: Codeunit "Unit Reversal";
        CommisionGen: Codeunit "Unit and Comm. Creation Job";
        RecCommissionEntry: Record "Commission Entry";
        APPENTRY_1: Record "Application Payment Entry";
        BankAccRecoLine_1: Record "Bank Acc. Reconciliation Line";
        ConfOrder_2: Record "Confirmed Order";
        CustMobileNo: Text[30];
        CustSMSText: Text[1000];
        RespCenter: Record "Responsibility Center 1";
        ComInfo: Record "Company Information";
        Customer: Record Customer;
        Text000: Label 'You must select the Bank Accouont Code before import statement.';
        Text001: Label '''''';
        Text50001: Label 'Do you want to bounce the Marked Cheques?';
        NewAssociateBottom: Report "New Associate Bottom To Top_1";
        RegionCode: Code[10];
        UnitPaymentEntry: Record "Unit Payment Entry";
        NewAppEntry: Record "NewApplication Payment Entry";
        SMSFeatures: Codeunit "SMS Features";
        CompanyInformation: Record "Company Information";


    //311224  ChequeClearance shift to Codeunit 70002.
    // PROCEDURE ChequeClearance(BankAccountNo: Code[20]; StatementNo: Code[20]);
    // VAR
    //     BankAccStatmntLine: Record "Bank Account Statement Line";
    //     AppPayEntry: Record "Application Payment Entry";
    //     NewAppPayEntry: Record "NewApplication Payment Entry";
    //     RecAppPmtEntry: Record "Application Payment Entry";
    //     Newconforder: Record "New Confirmed Order";
    //     Conforder_1: Record "New Confirmed Order";
    //     AppPayEntry_2: Record "Application Payment Entry";
    //     ApplicationDevelopmentLine: Record "New Application DevelopmntLine";
    //     v_AppEntry: Record "Application Payment Entry";
    // BEGIN

    //     CLEAR(BankAccStatmntLine);
    //     BankAccStatmntLine.RESET;
    //     //BankAccStatmntLine.SETRANGE("Bank Account No.", BankAcNo);
    //     BankAccStatmntLine.SETRANGE("Statement No.", StatementNo);
    //     IF BankAccStatmntLine.FINDSET THEN
    //         REPEAT
    //             BankAccStatmntLine.CALCFIELDS("Application No.", "Receipt Line No.");  //ALLEDK 111116
    //             CLEAR(AppPayEntry);
    //             AppPayEntry.RESET;
    //             AppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
    //             AppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::" ");
    //             AppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Check No.");
    //             IF BankAccStatmntLine."Receipt Line No." <> 0 THEN
    //                 AppPayEntry.SETRANGE("Receipt Line No.", BankAccStatmntLine."Receipt Line No.");  //ALLEDK 111116
    //             IF AppPayEntry.FINDFIRST THEN BEGIN
    //                 IF AppPayEntry."Payment Mode" <> AppPayEntry."Payment Mode"::"Refund Bank" THEN     //120816
    //                     PostPayment.ChequeClearance(AppPayEntry, BankAccStatmntLine."Value Date")
    //                 ELSE IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Bank") THEN BEGIN  //120816
    //                     AppPayEntry."Cheque Status" := AppPayEntry."Cheque Status"::Cleared;    //120816
    //                     AppPayEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";  //120816
    //                     AppPayEntry.MODIFY;                                                     //120816
    //                 END;                                                                      //120816

    //                 NewAppPayEntry.RESET;
    //                 NewAppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
    //                 IF BankAccStatmntLine."Receipt Line No." <> 0 THEN
    //                     NewAppPayEntry.SETRANGE("Line No.", BankAccStatmntLine."Receipt Line No.");  //ALLEDK 111116
    //                 CompanyWiseAccount.RESET;
    //                 CompanyWiseAccount.SETRANGE(CompanyWiseAccount."MSC Company", TRUE);
    //                 IF CompanyWiseAccount.FINDFIRST THEN
    //                     IF (COMPANYNAME = CompanyWiseAccount."Company Code") THEN BEGIN
    //                         NewAppPayEntry.SETRANGE("Posted Document No.", AppPayEntry."Posted Document No.");
    //                         APPENTRY_1.RESET;
    //                         APPENTRY_1.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
    //                         IF BankAccStatmntLine."Receipt Line No." = 0 THEN                          //ALLEDK 111116
    //                             APPENTRY_1.SETRANGE("Posted Document No.", AppPayEntry."Posted Document No.")
    //                         ELSE
    //                             APPENTRY_1.SETRANGE("Line No.", AppPayEntry."Line No.");                     //ALLEDK 111116
    //                         IF APPENTRY_1.FINDFIRST THEN BEGIN
    //                             APPENTRY_1."Cheque Status" := APPENTRY_1."Cheque Status"::Cleared;
    //                             APPENTRY_1."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
    //                             APPENTRY_1.MODIFY;
    //                         END;
    //                     END ELSE BEGIN
    //                         IF BankAccStatmntLine."Receipt Line No." = 0 THEN BEGIN                    //ALLEDK 111116
    //                             IF AppPayEntry."MSC Post Doc. No." <> '' THEN
    //                                 NewAppPayEntry.SETRANGE("Posted Document No.", AppPayEntry."MSC Post Doc. No.")
    //                             ELSE
    //                                 NewAppPayEntry.SETRANGE("Line No.", AppPayEntry."Line No.");
    //                         END ELSE BEGIN                                                                //ALLEDK 111116
    //                             NewAppPayEntry.SETRANGE("Line No.", AppPayEntry."Receipt Line No.");        //ALLEDK 111116
    //                         END;
    //                     END;

    //                 IF NewAppPayEntry.FINDSET THEN
    //                     REPEAT
    //                         NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Cleared;
    //                         NewAppPayEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
    //                         NewAppPayEntry."BRS Created All Comp From MSC" := TRUE;
    //                         NewAppPayEntry."BRS Date in All Comp From MSC" := TODAY;
    //                         NewAppPayEntry.MODIFY;
    //                     UNTIL NewAppPayEntry.NEXT = 0;
    //                 //Alle 040320 Start
    //                 UnitPaymentEntry.RESET;
    //                 UnitPaymentEntry.SETRANGE("Document No.", AppPayEntry."Document No.");
    //                 UnitPaymentEntry.SETRANGE("Posted Document No.", AppPayEntry."Posted Document No.");
    //                 IF UnitPaymentEntry.FINDSET THEN BEGIN
    //                     REPEAT
    //                         AppPayEntry_2.RESET;
    //                         AppPayEntry_2.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
    //                         AppPayEntry_2.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::" ");
    //                         AppPayEntry_2.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Check No.");
    //                         IF BankAccStatmntLine."Receipt Line No." <> 0 THEN
    //                             AppPayEntry_2.SETRANGE("Receipt Line No.", BankAccStatmntLine."Receipt Line No.");  //ALLEDK 111116
    //                         IF AppPayEntry_2.FINDFIRST THEN BEGIN
    //                             AppPayEntry_2."Cheque Status" := AppPayEntry_2."Cheque Status"::Cleared;
    //                             AppPayEntry_2."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
    //                             AppPayEntry_2.MODIFY;
    //                         END;
    //                     UNTIL UnitPaymentEntry.NEXT = 0;
    //                     NewAppEntry.RESET;
    //                     NewAppEntry.SETRANGE("Document No.", AppPayEntry."Document No.");
    //                     NewAppEntry.SETRANGE("Line No.", AppPayEntry."Receipt Line No.");
    //                     IF NewAppEntry.FINDFIRST THEN BEGIN
    //                         NewAppEntry."Cheque Status" := NewAppEntry."Cheque Status"::Cleared;
    //                         NewAppEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
    //                         NewAppEntry.MODIFY;
    //                     END;
    //                 END;
    //                 //Alle 040320 END
    //             END ELSE BEGIN
    //                 CLEAR(NewAppPayEntry);
    //                 NewAppPayEntry.RESET;
    //                 NewAppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
    //                 NewAppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::" ");
    //                 NewAppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Check No.");
    //                 IF BankAccStatmntLine."Receipt Line No." <> 0 THEN
    //                     NewAppPayEntry.SETRANGE("Line No.", BankAccStatmntLine."Receipt Line No.");   //ALLEDK 111116
    //                 IF NewAppPayEntry.FINDFIRST THEN BEGIN
    //                     NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Cleared;
    //                     NewAppPayEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
    //                     NewAppPayEntry.MODIFY;
    //                 END;
    //             END;
    //         UNTIL BankAccStatmntLine.NEXT = 0;
    // END;


    PROCEDURE ChequeBounce()
    VAR
        BankRecLine: Record "Bank Acc. Reconciliation Line";
        BondPaymentEntry: Record "Application Payment Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        AssoPayHead: Record "Assoc Pmt Voucher Header";
        VLE: Record "Vendor Ledger Entry";
        ReversalEntry: Record "Reversal Entry";
        RevEntry: Record "Reversal Entry";
        FormRevEntries: Page "Auto Reverse Entries-Chq Bounc";
        BLedgerEntry: Record "Bank Account Ledger Entry";
        NewAppPayEntry: Record "NewApplication Payment Entry";
        RecAppPmtEntry: Record "Application Payment Entry";
        NewBondPaymentEntry: Record "NewApplication Payment Entry";
        APmtEntry_1: Record "Application Payment Entry";
        ApplicationDevelopmentLine: Record "New Application DevelopmntLine";
        ChequeLength: Integer;
    BEGIN
        //ALLETDK261212..BEGIN
        CLEAR(BankAccRecoLine);
        BankAccRecoLine.RESET;
        BankAccRecoLine.SETRANGE("Bank Account No.", Rec."Bank Account No.");
        BankAccRecoLine.SETRANGE("Statement No.", Rec."Statement No.");
        BankAccRecoLine.SETRANGE(Bounced, TRUE);
        BankAccRecoLine.SETRANGE(BouncedEntryPosted, FALSE);
        IF BankAccRecoLine.FINDSET THEN BEGIN
            REPEAT
                BankAccRecoLine.CALCFIELDS(BankAccRecoLine."Application No.", BankAccRecoLine."Receipt Line No.", "Development Application No.");  //ALLEDK 10112016
                APmtEntry_1.RESET;
                APmtEntry_1.SETRANGE("Document No.", BankAccRecoLine."Application No.");
                IF BankAccRecoLine."Receipt Line No." <> 0 THEN
                    APmtEntry_1.SETRANGE("Receipt Line No.", BankAccRecoLine."Receipt Line No.");  //ALLEDK 10112016
                IF APmtEntry_1.FINDFIRST THEN BEGIN
                    //BBG1.00 240313
                    IF BankAccRecoLine."Application No." <> '' THEN BEGIN
                        BondPaymentEntry.RESET;
                        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
                        BondPaymentEntry.SETRANGE("Document No.", BankAccRecoLine."Application No.");
                        //   BondPaymentEntry.SETRANGE("Cheque No./ Transaction No.",BankAccRecoLine."Check No.");
                        BondPaymentEntry.SETRANGE("Deposit/Paid Bank", Rec."Bank Account No.");
                        BondPaymentEntry.SETFILTER("Payment Mode", '%1|%2', BondPaymentEntry."Payment Mode"::Bank,
                        BondPaymentEntry."Payment Mode"::"Refund Bank");
                        BondPaymentEntry.SETFILTER("Cheque Status", '<>%1', BondPaymentEntry."Cheque Status"::Bounced);
                        BondPaymentEntry.SETRANGE(Posted, TRUE);
                        IF BankAccRecoLine."Receipt Line No." <> 0 THEN
                            BondPaymentEntry.SETRANGE("Receipt Line No.", BankAccRecoLine."Receipt Line No.");   //ALLEDK 10112016
                        IF BondPaymentEntry.FINDFIRST THEN BEGIN
                            PostPayment.NewChequeBounce(BondPaymentEntry, BankAccRecoLine."Value Date");
                            IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::"Refund Bank" THEN BEGIN
                                IF BondPaymentEntry."Commission Reversed" THEN BEGIN
                                    UnitReversal.CommisionReverse(BondPaymentEntry."Document No.", TRUE);
                                    UnitReversal.RefundCommisionGenerate(BondPaymentEntry."Document No.", BondPaymentEntry."Posting date");
                                END;
                                UnitReversal.ReverseTABankRecoCase(BondPaymentEntry."Document No.");
                            END;
                            //240415
                            CLEAR(BankRecLine);
                            BankRecLine.GET(BankRecLine."Statement Type"::"Bank Reconciliation", BankAccRecoLine."Bank Account No.", BankAccRecoLine."Statement No.",
                            BankAccRecoLine."Statement Line No.");
                            BankRecLine.BouncedEntryPosted := TRUE;
                            BankRecLine.MODIFY;

                            CLEAR(BankAccLedgEntry);
                            BankAccLedgEntry.RESET;
                            BankAccLedgEntry.SETCURRENTKEY("Bank Account No.", "Posting Date");
                            BankAccLedgEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                            BankAccLedgEntry.SETRANGE("Application No.", BankAccRecoLine."Application No.");  //BBG1.00 240313
                            ChequeLength := 0;
                            ChequeLength := StrLen(BankAccRecoLine."Check No.");
                            IF ChequeLength > 10 then
                                BankAccLedgEntry.SETRANGE("Cheque No.1", BankAccRecoLine."Check No.")
                            ELSE
                                BankAccLedgEntry.SETRANGE("Cheque No.", BankAccRecoLine."Check No.");
                            BankAccLedgEntry.SETFILTER("Document Type", '%1|%2', BankAccLedgEntry."Document Type"::" ",
                            BankAccLedgEntry."Document Type"::Refund);
                            BankAccLedgEntry.SETRANGE(Open, TRUE);
                            BankAccLedgEntry.SETRANGE("Statement Status", BankAccLedgEntry."Statement Status"::Open);
                            IF BankAccLedgEntry.FINDFIRST THEN
                                EnterBankAccLine(BankAccLedgEntry);
                        END;
                    END ELSE BEGIN
                        BLedgerEntry.RESET;
                        BLedgerEntry.SETRANGE("Document No.", BankAccRecoLine."Document No.");
                        BLedgerEntry.SETRANGE("Statement No.", BankAccRecoLine."Statement No.");
                        BLedgerEntry.SETRANGE("Statement Line No.", BankAccRecoLine."Statement Line No.");
                        IF BLedgerEntry.FINDFIRST THEN BEGIN
                            CLEAR(ReversalEntry);
                            IF BLedgerEntry.Reversed THEN
                                ReversalEntry.AlreadyReversedEntry(Rec.TABLECAPTION, BLedgerEntry."Entry No.");
                            BLedgerEntry.TESTFIELD("Transaction No.");
                            RevEntry.DELETEALL;
                            ReversalEntry.AutoReverseTransaction(BLedgerEntry."Transaction No.", BankAccRecoLine."Value Date");
                            FormRevEntries.RUN;
                        END ELSE
                            ERROR('Entry does not exist to bounce. Line No. %1', BankAccRecoLine."Statement Line No.");
                    END;
                    NewAppPayEntry.RESET;
                    NewAppPayEntry.SETRANGE("Document No.", BankAccRecoLine."Application No.");
                    NewAppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccRecoLine."Check No.");
                    NewAppPayEntry.SETRANGE("Deposit/Paid Bank", Rec."Bank Account No.");
                    NewAppPayEntry.SETFILTER("Payment Mode", '%1|%2', BondPaymentEntry."Payment Mode"::Bank,
                    NewAppPayEntry."Payment Mode"::"Refund Bank");
                    NewAppPayEntry.SETFILTER("Cheque Status", '<>%1', BondPaymentEntry."Cheque Status"::Bounced);
                    NewAppPayEntry.SETRANGE(Posted, TRUE);
                    IF BankAccRecoLine."Receipt Line No." <> 0 THEN
                        NewAppPayEntry.SETRANGE("Line No.", BankAccRecoLine."Receipt Line No."); //ALLEDK 10112016
                    IF NewAppPayEntry.FINDFIRST THEN BEGIN
                        NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Bounced;
                        NewAppPayEntry."Chq. Cl / Bounce Dt." := BankAccRecoLine."Value Date";
                        NewAppPayEntry."BRS Created All Comp From MSC" := TRUE;
                        NewAppPayEntry."BRS Date in All Comp From MSC" := TODAY;
                        NewAppPayEntry.MODIFY;
                    END;
                END ELSE BEGIN
                    BankAccRecoLine.CALCFIELDS(BankAccRecoLine."Application No."); //BBG1.00 240313
                    IF BankAccRecoLine."Application No." <> '' THEN BEGIN
                        CLEAR(NewBondPaymentEntry);
                        NewBondPaymentEntry.SETRANGE("Document No.", BankAccRecoLine."Application No.");
                        NewBondPaymentEntry.SETRANGE("Cheque No./ Transaction No.", BankAccRecoLine."Check No.");
                        NewBondPaymentEntry.SETRANGE("Deposit/Paid Bank", Rec."Bank Account No.");
                        NewBondPaymentEntry.SETFILTER("Payment Mode", '%1|%2', NewBondPaymentEntry."Payment Mode"::Bank,
                        NewBondPaymentEntry."Payment Mode"::"Refund Bank");
                        NewBondPaymentEntry.SETFILTER("Cheque Status", '<>%1', NewBondPaymentEntry."Cheque Status"::Bounced);
                        NewBondPaymentEntry.SETRANGE(Posted, TRUE);
                        IF BankAccRecoLine."Receipt Line No." <> 0 THEN
                            NewBondPaymentEntry.SETRANGE("Line No.", BankAccRecoLine."Receipt Line No."); //ALLEDK 10112016
                        IF NewBondPaymentEntry.FINDFIRST THEN BEGIN
                            //060515
                            IF NewBondPaymentEntry."Payment Mode" = NewBondPaymentEntry."Payment Mode"::"Refund Bank" THEN BEGIN
                                BLedgerEntry.RESET;
                                BLedgerEntry.SETRANGE("Document No.", BankAccRecoLine."Document No.");
                                BLedgerEntry.SETRANGE("Statement No.", BankAccRecoLine."Statement No.");
                                BLedgerEntry.SETRANGE("Statement Line No.", BankAccRecoLine."Statement Line No.");
                                IF BLedgerEntry.FINDFIRST THEN BEGIN
                                    CLEAR(ReversalEntry);
                                    IF BLedgerEntry.Reversed THEN
                                        ReversalEntry.AlreadyReversedEntry(Rec.TABLECAPTION, BLedgerEntry."Entry No.");
                                    BLedgerEntry.TESTFIELD("Transaction No.");
                                    RevEntry.DELETEALL;
                                    ReversalEntry.AutoReverseTransaction(BLedgerEntry."Transaction No.", BankAccRecoLine."Value Date");
                                    FormRevEntries.RUN;
                                END ELSE
                                    ERROR('Entry does not exist to bounce. Line No. %1', BankAccRecoLine."Statement Line No.");

                                NewAppPayEntry.RESET;
                                NewAppPayEntry.SETRANGE("Document No.", BankAccRecoLine."Application No.");
                                NewAppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccRecoLine."Check No.");
                                //NewAppPayEntry.SETRANGE("Deposit/Paid Bank","Bank Account No.");
                                NewAppPayEntry.SETFILTER("Payment Mode", '%1|%2', BondPaymentEntry."Payment Mode"::Bank,
                                NewAppPayEntry."Payment Mode"::"Refund Bank");
                                NewAppPayEntry.SETFILTER("Cheque Status", '<>%1', BondPaymentEntry."Cheque Status"::Bounced);
                                NewAppPayEntry.SETRANGE(Posted, TRUE);
                                IF BankAccRecoLine."Receipt Line No." <> 0 THEN
                                    NewAppPayEntry.SETRANGE("Line No.", BankAccRecoLine."Receipt Line No."); //ALLEDK 10112016
                                IF NewAppPayEntry.FINDFIRST THEN BEGIN
                                    NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Bounced;
                                    NewAppPayEntry."Chq. Cl / Bounce Dt." := BankAccRecoLine."Value Date";
                                    //   NewAppPayEntry."BRS Created All Comp From MSC" := TRUE;
                                    // NewAppPayEntry."BRS Date in All Comp From MSC" := TODAY;
                                    NewAppPayEntry.MODIFY;
                                END;
                            END ELSE BEGIN
                                //060515

                                PostPayment.InterNewChequeBounce(NewBondPaymentEntry, BankAccRecoLine."Value Date");  //Added Date filter 190113
                                CLEAR(BankRecLine);
                                BankRecLine.GET(BankAccRecoLine."Bank Account No.", BankAccRecoLine."Statement No.",
                                               BankAccRecoLine."Statement Line No.");
                                BankRecLine.BouncedEntryPosted := TRUE;
                                BankRecLine.MODIFY;

                                CLEAR(BankAccLedgEntry);
                                BankAccLedgEntry.RESET;
                                BankAccLedgEntry.SETCURRENTKEY("Bank Account No.", "Posting Date");
                                BankAccLedgEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                                BankAccLedgEntry.SETRANGE("Application No.", BankAccRecoLine."Application No.");  //BBG1.00 240313
                                ChequeLength := 0;
                                ChequeLength := StrLen(BankAccRecoLine."Check No.");
                                IF ChequeLength > 10 then
                                    BankAccLedgEntry.SETRANGE("Cheque No.1", BankAccRecoLine."Check No.")
                                ELSE
                                    BankAccLedgEntry.SETRANGE("Cheque No.", BankAccRecoLine."Check No.");
                                BankAccLedgEntry.SETFILTER("Document Type", '%1|%2', BankAccLedgEntry."Document Type"::" ",
                                BankAccLedgEntry."Document Type"::Refund);
                                BankAccLedgEntry.SETRANGE(Open, TRUE);
                                BankAccLedgEntry.SETRANGE("Statement Status", BankAccLedgEntry."Statement Status"::Open);
                                IF BankAccLedgEntry.FINDFIRST THEN
                                    EnterBankAccLine(BankAccLedgEntry);

                                NewAppPayEntry.RESET;
                                NewAppPayEntry.SETRANGE("Document No.", BankAccRecoLine."Application No.");
                                NewAppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccRecoLine."Check No.");
                                //NewAppPayEntry.SETRANGE("Deposit/Paid Bank","Bank Account No.");
                                NewAppPayEntry.SETFILTER("Payment Mode", '%1|%2', BondPaymentEntry."Payment Mode"::Bank,
                                NewAppPayEntry."Payment Mode"::"Refund Bank");
                                NewAppPayEntry.SETFILTER("Cheque Status", '<>%1', BondPaymentEntry."Cheque Status"::Bounced);
                                NewAppPayEntry.SETRANGE(Posted, TRUE);
                                IF BankAccRecoLine."Receipt Line No." <> 0 THEN
                                    NewAppPayEntry.SETRANGE("Line No.", BankAccRecoLine."Receipt Line No."); //ALLEDK 10112016
                                IF NewAppPayEntry.FINDFIRST THEN BEGIN
                                    NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Bounced;
                                    NewAppPayEntry."Chq. Cl / Bounce Dt." := BankAccRecoLine."Value Date";
                                    NewAppPayEntry."BRS Created All Comp From MSC" := TRUE;
                                    NewAppPayEntry."BRS Date in All Comp From MSC" := TODAY;
                                    NewAppPayEntry.MODIFY;
                                END;
                            END;
                        END;
                    END ELSE BEGIN
                        BLedgerEntry.RESET;
                        BLedgerEntry.SETRANGE("Document No.", BankAccRecoLine."Document No.");
                        BLedgerEntry.SETRANGE("Statement No.", BankAccRecoLine."Statement No.");
                        BLedgerEntry.SETRANGE("Statement Line No.", BankAccRecoLine."Statement Line No.");
                        IF BLedgerEntry.FINDFIRST THEN BEGIN
                            CLEAR(ReversalEntry);
                            IF BLedgerEntry.Reversed THEN
                                ReversalEntry.AlreadyReversedEntry(Rec.TABLECAPTION, BLedgerEntry."Entry No.");
                            BLedgerEntry.TESTFIELD("Transaction No.");
                            RevEntry.DELETEALL;
                            ReversalEntry.AutoReverseTransaction(BLedgerEntry."Transaction No.", BankAccRecoLine."Value Date");
                            FormRevEntries.RUN;
                        END ELSE
                            ERROR('Entry does not exist to bounce. Line No. %1', BankAccRecoLine."Statement Line No.");
                    END;

                END;

                NewAppPayEntry.RESET;
                NewAppPayEntry.SETRANGE("Document No.", BankAccRecoLine."Application No.");
                NewAppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccRecoLine."Check No.");
                //NewAppPayEntry.SETRANGE("Deposit/Paid Bank","Bank Account No.");
                NewAppPayEntry.SETFILTER("Payment Mode", '%1|%2', BondPaymentEntry."Payment Mode"::Bank,
                NewAppPayEntry."Payment Mode"::"Refund Bank");
                NewAppPayEntry.SETFILTER("Cheque Status", '<>%1', BondPaymentEntry."Cheque Status"::Bounced);
                NewAppPayEntry.SETRANGE(Posted, TRUE);
                IF BankAccRecoLine."Receipt Line No." <> 0 THEN
                    NewAppPayEntry.SETRANGE("Line No.", BankAccRecoLine."Receipt Line No."); //ALLEDK 10112016
                IF NewAppPayEntry.FINDFIRST THEN BEGIN
                    NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Bounced;
                    NewAppPayEntry."Chq. Cl / Bounce Dt." := BankAccRecoLine."Value Date";
                    NewAppPayEntry."BRS Created All Comp From MSC" := TRUE;
                    NewAppPayEntry."BRS Date in All Comp From MSC" := TODAY;
                    NewAppPayEntry.MODIFY;
                END;
            UNTIL BankAccRecoLine.NEXT = 0;
        END ELSE
            ERROR('Entry does not exist to bounce');
        //ALLETDK261212..END
    END;

    PROCEDURE EnterBankAccLine(VAR BankAccLedgEntry2: Record "Bank Account Ledger Entry");
    VAR
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    BEGIN
        LineNo := LineNo + 10000;
        BankAccReconLine.INIT;
        BankAccReconLine."Bank Account No." := Rec."Bank Account No.";
        BankAccReconLine."Statement No." := Rec."Statement No.";
        BankAccReconLine."Statement Line No." := LineNo;
        BankAccReconLine."Transaction Date" := BankAccLedgEntry2."Posting Date";
        BankAccReconLine.Description := BankAccLedgEntry2.Description;
        BankAccReconLine."Document No." := BankAccLedgEntry2."Document No.";
        if BankAccLedgEntry2."Cheque No.1" = '' then
            BankAccReconLine."Check No." := BankAccLedgEntry2."Cheque No."//ALLETDK
        Else
            BankAccReconLine."Check No." := BankAccLedgEntry2."Cheque No.1";
        BankAccReconLine."Cheque No." := BankAccReconLine."Check No.";
        BankAccReconLine."Value Date" := BankAccRecoLine."Value Date";//ALLETDK
        BankAccReconLine."External Doc. No." := BankAccRecoLine."External Doc. No.";//ALLETDK
        BankAccReconLine."Statement Amount" := BankAccLedgEntry2."Remaining Amount";
        BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
        //BankAccReconLine.Type := BankAccReconLine.Type::"Bank Account Ledger Entry";
        BankAccReconLine."User ID" := USERID; //ALLETDK
        BankAccReconLine."Applied Entries" := 1;
        BankAccSetStmtNo.SetReconNo(BankAccLedgEntry2, BankAccReconLine);
        BankAccReconLine.Bounced := TRUE;
        BankAccReconLine.BouncedEntryPosted := TRUE;
        BankAccReconLine.INSERT;
    END;

    PROCEDURE SendBouncedSMS()
    VAR
        Job: Record Job;
    BEGIN
        CLEAR(BankAccRecoLine);
        BankAccRecoLine_1.RESET;
        BankAccRecoLine_1.SETRANGE("Bank Account No.", Rec."Bank Account No.");
        BankAccRecoLine_1.SETRANGE("Statement No.", Rec."Statement No.");
        BankAccRecoLine_1.SETRANGE(Bounced, TRUE);
        BankAccRecoLine_1.SETRANGE(BouncedEntryPosted, TRUE);
        BankAccRecoLine_1.SETFILTER("Applied Amount", '>%1', 0);
        //BankAccRecoLine_1.SETRANGE("Send SMS",FALSE);
        IF BankAccRecoLine_1.FINDSET THEN BEGIN
            REPEAT
                COMMIT;
                ConfOrder_2.RESET;
                BankAccRecoLine_1.CALCFIELDS(BankAccRecoLine_1."Application No.");
                IF ConfOrder_2.GET(BankAccRecoLine_1."Application No.") THEN;
                RespCenter.RESET;
                IF RespCenter.GET(ConfOrder_2."Shortcut Dimension 1 Code") THEN;
                ComInfo.GET;
                IF ComInfo."Send SMS" THEN BEGIN
                    IF Customer.GET(ConfOrder_2."Customer No.") THEN BEGIN
                        IF Job.GET(ConfOrder_2."Shortcut Dimension 1 Code") THEN
                            IF Job."Region Code for Rank Hierarcy" <> '' THEN
                                RegionCode := Job."Region Code for Rank Hierarcy"
                            ELSE
                                RegionCode := 'R0001';
                        CLEAR(NewAssociateBottom);
                        NewAssociateBottom.SetCustValues(ConfOrder_2."Introducer Code",
                        RegionCode, ConfOrder_2."No.", Customer.Name, RespCenter.Name, BankAccRecoLine_1."Applied Amount",
                        BankAccRecoLine_1."Cheque Date", Customer."BBG Mobile No.");
                        NewAssociateBottom.RUNMODAL;
                    END;
                END;
            UNTIL BankAccRecoLine_1.NEXT = 0;
        END;
    END;

    //311224 DevlopmentChequeClearance shift to codeunit 70002

    // PROCEDURE DevlopmentChequeClearance(BankAccountNo: Code[20]; StatementNo: Code[20]);
    // VAR
    //     BankAccStatmntLine: Record "Bank Account Statement Line";
    //     AppPayEntry: Record "Application Pmt Devlop. Entry";
    //     NewAppPayEntry: Record "New Application DevelopmntLine";
    //     RecAppPmtEntry: Record "Application Pmt Devlop. Entry";
    //     Newconforder: Record "New Confirmed Order";
    //     Conforder_1: Record "New Confirmed Order";
    // BEGIN

    //     CLEAR(BankAccStatmntLine);
    //     BankAccStatmntLine.RESET;
    //     //BankAccStatmntLine.SETRANGE("Bank Account No.", BankAcNo);
    //     BankAccStatmntLine.SETRANGE("Statement No.", StatementNo);
    //     IF BankAccStatmntLine.FINDSET THEN
    //         REPEAT
    //             BankAccStatmntLine.CALCFIELDS("Development Application No.", "Development Appl. Rcpt LineNo.");  //ALLEDK 111116
    //             CLEAR(AppPayEntry);
    //             AppPayEntry.RESET;
    //             AppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Development Application No.");
    //             AppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::" ");
    //             AppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Check No.");
    //             IF BankAccStatmntLine."Development Appl. Rcpt LineNo." <> 0 THEN
    //                 AppPayEntry.SETRANGE("Receipt Line No.", BankAccStatmntLine."Development Appl. Rcpt LineNo.");  //ALLEDK 111116
    //             IF AppPayEntry.FINDFIRST THEN BEGIN
    //                 AppPayEntry."Cheque Status" := AppPayEntry."Cheque Status"::Cleared;    //120816
    //                 AppPayEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";  //120816
    //                 AppPayEntry.MODIFY;                                                     //120816
    //                 NewAppPayEntry.RESET;
    //                 NewAppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Development Application No.");
    //                 NewAppPayEntry.SETRANGE("Line No.", AppPayEntry."Receipt Line No.");
    //                 IF NewAppPayEntry.FINDFIRST THEN BEGIN
    //                     NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Cleared;
    //                     NewAppPayEntry."Chq. Cl / Bounce Dt." := BankAccStatmntLine."Value Date";
    //                     NewAppPayEntry.MODIFY;
    //                 END;
    //             END;
    //         UNTIL BankAccStatmntLine.NEXT = 0;
    // END;

    PROCEDURE DevelopmentChequeBounce()
    VAR
        BankRecLine: Record "Bank Acc. Reconciliation Line";
        BondPaymentEntry: Record "Application Pmt Devlop. Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        AssoPayHead: Record "Assoc Pmt Voucher Header";
        VLE: Record "Vendor Ledger Entry";
        ReversalEntry: Record "Reversal Entry";
        RevEntry: Record "Reversal Entry";
        FormRevEntries: Page "Auto Reverse Entries-Chq Bounc";
        //FormRevEntries_2: Page 179;
        BLedgerEntry: Record "Bank Account Ledger Entry";
        NewAppPayEntry: Record "NewApplication Payment Entry";
        RecAppPmtEntry: Record "Application Pmt Devlop. Entry";
        NewBondPaymentEntry: Record "NewApplication Payment Entry";
        APmtDevlopEntry_1: Record "Application Pmt Devlop. Entry";
        ApplicationDevelopmentLine: Record "New Application DevelopmntLine";
        PostDevelopmentCharges: Codeunit "Post Development Charges";
        V_ApplicationPmtDevlopEntry: Record "Application Pmt Devlop. Entry";
    BEGIN
        //ALLETDK261212..BEGIN
        CLEAR(BankAccRecoLine);
        BankAccRecoLine.RESET;
        BankAccRecoLine.SETRANGE("Bank Account No.", Rec."Bank Account No.");
        BankAccRecoLine.SETRANGE("Statement No.", Rec."Statement No.");
        BankAccRecoLine.SETRANGE(Bounced, TRUE);
        BankAccRecoLine.SETRANGE(BouncedEntryPosted, FALSE);
        IF BankAccRecoLine.FINDSET THEN BEGIN
            REPEAT
                BankAccRecoLine.CALCFIELDS(BankAccRecoLine."Development Application No.", BankAccRecoLine."Development Appl. Rcpt LineNo.");  //ALLEDK 10112016
                APmtDevlopEntry_1.RESET;
                APmtDevlopEntry_1.SETRANGE("Document No.", BankAccRecoLine."Development Application No.");
                IF BankAccRecoLine."Development Appl. Rcpt LineNo." <> 0 THEN
                    APmtDevlopEntry_1.SETRANGE("Receipt Line No.", BankAccRecoLine."Development Appl. Rcpt LineNo.");  //ALLEDK 10112016
                IF APmtDevlopEntry_1.FINDFIRST THEN BEGIN
                    PostDevelopmentCharges.PostCustRefundBankReco(APmtDevlopEntry_1);
                    CLEAR(BankRecLine);
                    BankRecLine.GET(BankRecLine."Statement Type"::"Bank Reconciliation", BankAccRecoLine."Bank Account No.", BankAccRecoLine."Statement No.",
                    BankAccRecoLine."Statement Line No.");
                    BankRecLine.BouncedEntryPosted := TRUE;
                    BankRecLine.MODIFY;

                    CLEAR(BankAccLedgEntry);
                    BankAccLedgEntry.RESET;
                    BankAccLedgEntry.SETCURRENTKEY("Bank Account No.", "Posting Date");
                    BankAccLedgEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                    BankAccLedgEntry.SETRANGE("Development Application No.", BankAccRecoLine."Development Application No.");  //BBG1.00 240313
                    BankAccLedgEntry.SETRANGE("Cheque No.1", BankAccRecoLine."Check No.");
                    BankAccLedgEntry.SETFILTER("Document Type", '%1|%2', BankAccLedgEntry."Document Type"::" ",
                    BankAccLedgEntry."Document Type"::Refund);
                    BankAccLedgEntry.SETRANGE(Open, TRUE);
                    BankAccLedgEntry.SETRANGE("Statement Status", BankAccLedgEntry."Statement Status"::Open);
                    IF BankAccLedgEntry.FINDFIRST THEN
                        EnterBankAccLine(BankAccLedgEntry);
                END;
                //BBG2.0
                ApplicationDevelopmentLine.RESET;
                ApplicationDevelopmentLine.SETRANGE("Document No.", BankAccRecoLine."Development Application No.");
                ApplicationDevelopmentLine.SETRANGE("Line No.", BankAccRecoLine."Development Appl. Rcpt LineNo.");
                //ApplicationDevelopmentLine.SETRANGE("Cheque No./ Transaction No.",BankAccRecoLine."Cheque No.");
                //ApplicationDevelopmentLine.SETRANGE("LLP Posted Document No.",BankAccRecoLine."Document No.");
                IF ApplicationDevelopmentLine.FINDFIRST THEN BEGIN
                    ApplicationDevelopmentLine."Cheque Status" := ApplicationDevelopmentLine."Cheque Status"::Bounced;
                    ApplicationDevelopmentLine."Chq. Cl / Bounce Dt." := BankAccRecoLine."Value Date";
                    ApplicationDevelopmentLine."Bank Reco Done in LLP" := TRUE;
                    ApplicationDevelopmentLine.MODIFY;
                    V_ApplicationPmtDevlopEntry.RESET;
                    V_ApplicationPmtDevlopEntry.SETRANGE("Document No.", ApplicationDevelopmentLine."Document No.");
                    V_ApplicationPmtDevlopEntry.SETRANGE("Receipt Line No.", ApplicationDevelopmentLine."Line No.");
                    IF V_ApplicationPmtDevlopEntry.FINDFIRST THEN BEGIN
                        V_ApplicationPmtDevlopEntry."Cheque Status" := V_ApplicationPmtDevlopEntry."Cheque Status"::Bounced;
                        V_ApplicationPmtDevlopEntry."Chq. Cl / Bounce Dt." := BankAccRecoLine."Value Date";
                        V_ApplicationPmtDevlopEntry.MODIFY;
                    END;
                END;
            //BBG2.0
            UNTIL BankAccRecoLine.NEXT = 0;
        END ELSE
            ERROR('Entry does not exist to bounce');
        //ALLETDK261212..END
    END;

    PROCEDURE SendCustomerChequeBouncSMS()
    VAR
        NewAppPayEntry: Record "NewApplication Payment Entry";
    BEGIN
        COMMIT;
        CLEAR(BankAccRecoLine);
        BankAccRecoLine_1.RESET;
        BankAccRecoLine_1.SETRANGE("Bank Account No.", Rec."Bank Account No.");
        BankAccRecoLine_1.SETRANGE("Statement No.", Rec."Statement No.");
        BankAccRecoLine_1.SETRANGE(Bounced, TRUE);
        BankAccRecoLine_1.SETRANGE(BouncedEntryPosted, TRUE);
        //BankAccRecoLine_1.SETFILTER("Applied Amount",'>%1',0);
        BankAccRecoLine_1.SETFILTER("Cheque No.", '<>%1', '');
        IF BankAccRecoLine_1.FINDSET THEN BEGIN
            REPEAT
                BankAccRecoLine_1.CALCFIELDS(BankAccRecoLine_1."Application No.", BankAccRecoLine_1."Receipt Line No.");  //ALLEDK 10112016
                NewAppPayEntry.RESET;
                NewAppPayEntry.SETRANGE("Document No.", BankAccRecoLine_1."Application No.");
                NewAppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccRecoLine_1."Check No.");
                NewAppPayEntry.SETRANGE("Deposit/Paid Bank", Rec."Bank Account No.");
                NewAppPayEntry.SETFILTER("Payment Mode", '%1|%2', NewAppPayEntry."Payment Mode"::Bank,
                NewAppPayEntry."Payment Mode"::"Refund Bank");
                //NewAppPayEntry.SETFILTER("Cheque Status",'<>%1',NewAppPayEntry."Cheque Status"::Bounced);
                NewAppPayEntry.SETRANGE(Posted, TRUE);
                NewAppPayEntry.SETRANGE("Line No.", BankAccRecoLine_1."Receipt Line No."); //ALLEDK 10112016
                IF NewAppPayEntry.FINDFIRST THEN BEGIN
                    CLEAR(SMSFeatures);
                    SMSFeatures.CustomerChequeBounced(NewAppPayEntry);
                END;
            UNTIL BankAccRecoLine_1.NEXT = 0;
        END;
    END;

}