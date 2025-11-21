page 50113 "Application Cheque Status"
{
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Application Status Update";
    SourceTableView = WHERE("Posted BRS" = CONST(false));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Payment Method"; Rec."Payment Method")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Cheque No./ Transaction No."; Rec."Cheque No./ Transaction No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Posting date"; Rec."Posting date")
                {
                }
                field("Statement No."; Rec."Statement No.")
                {
                }
                field("Statement Line No."; Rec."Statement Line No.")
                {
                }
                field("BLE Entry No."; Rec."BLE Entry No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(CreateLines)
            {

                trigger OnAction()
                var
                    ApplicationPaymentEntry: Record "Application Payment Entry";
                    BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                    OldBRSEntry: Record "Application Status Update";
                begin
                    CreateApplicationLines(FALSE);
                end;
            }
            action(UpdateChequeStatus)
            {

                trigger OnAction()
                begin
                    UpdateApplicationCheqStatus(FALSE);
                end;
            }
        }
    }

    var
        BRSEntry: Record "Application Status Update";
        UnitPaymentEntry: Record "Unit Payment Entry";
        NewAppEntry: Record "NewApplication Payment Entry";


    procedure ChequeClearance(BankAccountNo: Code[20]; StatementNo: Code[20]; StatementLineno: Integer)
    var
        BankAccStatmntLine: Record "Bank Account Ledger Entry";
        AppPayEntry: Record "Application Payment Entry";
        NewAppPayEntry: Record "NewApplication Payment Entry";
        RecAppPmtEntry: Record "Application Payment Entry";
        Newconforder: Record "New Confirmed Order";
        Conforder_1: Record "New Confirmed Order";
        PostPayment: Codeunit PostPayment;
        CompanyWiseAccount: Record "Company wise G/L Account";
        APPENTRY_1: Record "Application Payment Entry";
        ValueDate: Date;
    begin

        CLEAR(BankAccStatmntLine);
        BankAccStatmntLine.RESET;
        BankAccStatmntLine.SETRANGE("Bank Account No.", BankAccountNo);
        BankAccStatmntLine.SETRANGE("Statement No.", StatementNo);
        BankAccStatmntLine.SETRANGE("Statement Line No.", StatementLineno);
        BankAccStatmntLine.SETRANGE(Open, FALSE);
        IF BankAccStatmntLine.FINDSET THEN
            REPEAT

                //BankAccStatmntLine.CALCFIELDS("Application No.","Receipt Line No.");  //ALLEDK 111116
                BankAccStatmntLine.CALCFIELDS("Value Date");  //ALLEDK 111116
                ValueDate := BankAccStatmntLine."Value Date";
                IF ValueDate = 0D THEN
                    IF BankAccStatmntLine."New Value Dt." = 0D THEN
                        ValueDate := BankAccStatmntLine."Cheque Date"
                    ELSE
                        ValueDate := BankAccStatmntLine."New Value Dt.";

                CLEAR(AppPayEntry);
                AppPayEntry.RESET;
                AppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
                AppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::" ");
                if BankAccStatmntLine."Cheque No.1" <> '' then
                    AppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Cheque No.1")
                Else
                    AppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Cheque No.");
                AppPayEntry.SETRANGE("Posted Document No.", BankAccStatmntLine."Document No.");
                //    IF BankAccStatmntLine."Receipt Line No." <> 0 THEN
                //    AppPayEntry.SETRANGE("Receipt Line No.",BankAccStatmntLine."Receipt Line No.");  //ALLEDK 111116
                IF AppPayEntry.FINDFIRST THEN BEGIN

                    IF AppPayEntry."Payment Mode" <> AppPayEntry."Payment Mode"::"Refund Bank" THEN     //120816
                        PostPayment.ChequeClearance(AppPayEntry, ValueDate)
                    ELSE
                        IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Bank") THEN BEGIN  //120816
                            AppPayEntry."Cheque Status" := AppPayEntry."Cheque Status"::Cleared;    //120816
                            AppPayEntry."Chq. Cl / Bounce Dt." := ValueDate;  //120816
                            AppPayEntry.MODIFY;                                                     //120816
                        END;                                                                      //120816

                    NewAppPayEntry.RESET;
                    NewAppPayEntry.SETRANGE("Document No.", AppPayEntry."Document No.");
                    //        IF BankAccStatmntLine."Receipt Line No." <> 0 THEN
                    //        NewAppPayEntry.SETRANGE("Line No.",BankAccStatmntLine."Receipt Line No.");  //ALLEDK 111116
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
                                APPENTRY_1."Chq. Cl / Bounce Dt." := ValueDate;
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
                            NewAppPayEntry."Chq. Cl / Bounce Dt." := ValueDate;
                            NewAppPayEntry."BRS Created All Comp From MSC" := TRUE;
                            NewAppPayEntry."BRS Date in All Comp From MSC" := TODAY;
                            NewAppPayEntry.MODIFY;
                            //ALLEDK 100821
                            APPENTRY_1.RESET;
                            APPENTRY_1.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
                            APPENTRY_1.SETRANGE("Line No.", AppPayEntry."Line No.");                     //ALLEDK 111116
                            IF APPENTRY_1.FINDFIRST THEN BEGIN
                                APPENTRY_1."Cheque Status" := APPENTRY_1."Cheque Status"::Cleared;
                                APPENTRY_1."Chq. Cl / Bounce Dt." := ValueDate;
                                APPENTRY_1.MODIFY;
                            END;
                        //ALLEDK 100821
                        UNTIL NewAppPayEntry.NEXT = 0;
                END ELSE BEGIN
                    CLEAR(NewAppPayEntry);
                    NewAppPayEntry.RESET;
                    NewAppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
                    NewAppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::" ");
                    NewAppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Cheque No.");
                    IF BankAccStatmntLine."Receipt Line No." <> 0 THEN
                        NewAppPayEntry.SETRANGE("Line No.", BankAccStatmntLine."Receipt Line No.");   //ALLEDK 111116
                    IF NewAppPayEntry.FINDFIRST THEN BEGIN
                        NewAppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status"::Cleared;
                        NewAppPayEntry."Chq. Cl / Bounce Dt." := ValueDate;
                        NewAppPayEntry.MODIFY;
                    END;
                END;
                BRSEntry."Posted BRS" := TRUE;
                BRSEntry.MODIFY;
            UNTIL BankAccStatmntLine.NEXT = 0;
    end;


    procedure CreateApplicationLines(FromBatch: Boolean)
    var
        ApplicationPaymentEntry: Record "Application Payment Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        OldBRSEntry: Record "Application Status Update";
    begin
        ApplicationPaymentEntry.RESET;
        ApplicationPaymentEntry.SETFILTER("Cheque Status", '=%1', ApplicationPaymentEntry."Cheque Status"::" ");
        ApplicationPaymentEntry.SETRANGE(Posted, TRUE);
        //ApplicationPaymentEntry.SETRANGE("Chq. Cl / Bounce Dt.",0D);
        //ApplicationPaymentEntry.SETRANGE("Document No.",'AP2122000974');
        IF ApplicationPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                UnitPaymentEntry.RESET;
                UnitPaymentEntry.SETRANGE("Document No.", ApplicationPaymentEntry."Document No.");
                UnitPaymentEntry.SETRANGE("Posted Document No.", ApplicationPaymentEntry."Posted Document No.");
                IF UnitPaymentEntry.FINDSET THEN BEGIN
                    REPEAT
                        ApplicationPaymentEntry."Cheque Status" := ApplicationPaymentEntry."Cheque Status"::Cleared;
                        ApplicationPaymentEntry.MODIFY;
                    UNTIL UnitPaymentEntry.NEXT = 0;
                    NewAppEntry.RESET;
                    NewAppEntry.SETRANGE("Document No.", ApplicationPaymentEntry."Document No.");
                    NewAppEntry.SETRANGE("Line No.", ApplicationPaymentEntry."Receipt Line No.");
                    IF NewAppEntry.FINDFIRST THEN BEGIN
                        NewAppEntry."Cheque Status" := NewAppEntry."Cheque Status"::Cleared;
                        NewAppEntry.MODIFY;
                    END;
                END ELSE BEGIN
                    BankAccountLedgerEntry.RESET;
                    BankAccountLedgerEntry.SETCURRENTKEY("Document No.");
                    BankAccountLedgerEntry.SETRANGE("Document No.", ApplicationPaymentEntry."Posted Document No.");
                    BankAccountLedgerEntry.SETRANGE(Open, FALSE);
                    BankAccountLedgerEntry.SETRANGE("Statement Status", BankAccountLedgerEntry."Statement Status"::Closed);
                    BankAccountLedgerEntry.SETRANGE("Posting Date", ApplicationPaymentEntry."Posting date");
                    BankAccountLedgerEntry.SETRANGE("Bank Account No.", ApplicationPaymentEntry."Deposit/Paid Bank");
                    IF BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                        OldBRSEntry.RESET;
                        OldBRSEntry.SETRANGE("Document Type", ApplicationPaymentEntry."Document Type");
                        OldBRSEntry.SETRANGE("Document No.", ApplicationPaymentEntry."Document No.");
                        OldBRSEntry.SETRANGE("Line No.", ApplicationPaymentEntry."Line No.");
                        IF OldBRSEntry.FINDFIRST THEN BEGIN
                            OldBRSEntry."Statement No." := BankAccountLedgerEntry."Statement No.";
                            OldBRSEntry."Statement Line No." := BankAccountLedgerEntry."Statement Line No.";
                            OldBRSEntry."BLE Entry No." := BankAccountLedgerEntry."Entry No.";
                            OldBRSEntry."Posted BRS" := FALSE;
                            OldBRSEntry.MODIFY;
                        END ELSE BEGIN
                            BRSEntry.INIT;
                            BRSEntry.TRANSFERFIELDS(ApplicationPaymentEntry);
                            BRSEntry."Statement No." := BankAccountLedgerEntry."Statement No.";
                            BRSEntry."Statement Line No." := BankAccountLedgerEntry."Statement Line No.";
                            BRSEntry."BLE Entry No." := BankAccountLedgerEntry."Entry No.";
                            BRSEntry.INSERT;
                        END;
                    END;
                END;
            UNTIL ApplicationPaymentEntry.NEXT = 0;
            IF NOT FromBatch THEN
                MESSAGE('%1', 'Entry Created');
        END ELSE BEGIN
            IF NOT FromBatch THEN
                MESSAGE('%1', 'Nothing Process');
        END;
    end;


    procedure UpdateApplicationCheqStatus(FromBatch: Boolean)
    begin
        IF NOT FromBatch THEN BEGIN
            IF CONFIRM('Do you want to update the Status') THEN BEGIN
                BRSEntry.RESET;
                BRSEntry.SETRANGE("Posted BRS", FALSE);
                IF BRSEntry.FINDSET THEN
                    REPEAT
                        ChequeClearance(BRSEntry."Deposit/Paid Bank", BRSEntry."Statement No.", BRSEntry."Statement Line No.");
                    UNTIL BRSEntry.NEXT = 0;
                MESSAGE('%1', 'Process Done');
            END ELSE
                MESSAGE('%1', 'Nothing Process');
        END ELSE BEGIN
            BRSEntry.RESET;
            BRSEntry.SETRANGE("Posted BRS", FALSE);
            IF BRSEntry.FINDSET THEN
                REPEAT
                    ChequeClearance(BRSEntry."Deposit/Paid Bank", BRSEntry."Statement No.", BRSEntry."Statement Line No.");
                UNTIL BRSEntry.NEXT = 0;

        END;
    end;
}

