xmlport 97723 "Import Bank Reco"
{
    // ALLESC YN013, YN016 10-03-2009: New Object Created for Importing "Bank Statement" & "Payment Gateway Statement".
    // ALLERK 19-03-2010: Code added for document type wise reconciliation.

    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
            {
                AutoSave = false;
                XmlName = 'BankAccReconciliation';
                //SourceTableView = SORTING(Field1, Field2);
                UseTemporary = true;
                textelement(BankAccountCode)
                {
                }
                textelement(StatementDate)
                {
                }
                textelement(TransactionDate)
                {
                }
                textelement(CheckNo)
                {
                }
                textelement(ChequeDate)
                {
                }
                textelement(Desc)
                {
                }
                textelement(StatementDrAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(StatementCrAmount)
                {
                    MinOccurs = Zero;
                }
                textelement(ExtDocumentNo)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    IF BankAccountCode <> '' THEN
                        EVALUATE(BankAccountCode1, BankAccountCode);

                    IF BankAccountCode1 <> BankAccReco."Bank Account No." THEN
                        ERROR(Text000);

                    IF StatementDate <> '' THEN
                        EVALUATE(StatementDate1, StatementDate);
                    IF NOT HeaderUpdated THEN BEGIN
                        IF BankAccReco2.GET(BankAccReco2."Statement Type"::"Bank Reconciliation", BankAccReco."Bank Account No.", BankAccReco."Statement No.") THEN BEGIN
                            BankAccReco2."Statement Date" := StatementDate1;
                            BankAccReco2.MODIFY;
                        END;
                    END;

                    InsertBankRecoLines;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        BankAccount: Record "Bank Account";
        BankAccReco: Record "Bank Acc. Reconciliation";
        BankAccReco2: Record "Bank Acc. Reconciliation";
        BankAccRecoLine: Record "Bank Acc. Reconciliation Line";
        HeaderUpdated: Boolean;
        LineNo: Integer;
        "--FiledsToImport--": Integer;
        BankAccountCode1: Code[20];
        StatementDate1: Date;
        TransactionDate1: Date;
        CheckNo1: Code[20];
        PGTransNo: Code[25];
        StatementDrAmount1: Decimal;
        StatementCrAmount1: Decimal;
        DocumentType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        Desc1: Text[50];
        CheckLedgerEntry: Record "Check Ledger Entry";
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        StatementAmount: Decimal;
        Text000: Label 'You are importing wrong Bank''s statement.';
        chequeDate1: Date;


    procedure InsertBankRecoLines()
    begin
        BankAccRecoLine.RESET;
        BankAccRecoLine.SETRANGE("Bank Account No.", BankAccReco2."Bank Account No.");
        BankAccRecoLine.SETRANGE("Statement No.", BankAccReco2."Statement No.");
        IF BankAccRecoLine.FINDLAST THEN
            LineNo := BankAccRecoLine."Statement Line No." + 10000
        ELSE
            LineNo := 10000;

        BankAccRecoLine.RESET;
        BankAccRecoLine.INIT;
        BankAccRecoLine."Bank Account No." := BankAccReco2."Bank Account No.";
        BankAccRecoLine."Statement No." := BankAccReco2."Statement No.";
        BankAccRecoLine."Statement Line No." := LineNo;
        BankAccRecoLine.INSERT;
        IF TransactionDate <> '' THEN
            EVALUATE(TransactionDate1, TransactionDate);
        BankAccRecoLine."Transaction Date" := TransactionDate1;
        BankAccRecoLine."Value Date" := TransactionDate1;
        IF ChequeDate <> '' THEN
            EVALUATE(chequeDate1, ChequeDate);
        BankAccRecoLine.VALIDATE("Cheque Date", chequeDate1);
        IF CheckNo <> '' THEN BEGIN
            EVALUATE(CheckNo1, CheckNo);
            BankAccRecoLine."External Doc. No." := FORMAT(ExtDocumentNo);
            CheckLedgerEntry.RESET;
            CheckLedgerEntry.SETRANGE(CheckLedgerEntry."Bank Account No.", BankAccountCode1);
            CheckLedgerEntry.SETRANGE(CheckLedgerEntry."Check No.", CheckNo1);
            CheckLedgerEntry.SETFILTER(
              "Entry Status", '%1|%2', CheckLedgerEntry."Entry Status"::Posted,
              CheckLedgerEntry."Entry Status"::"Financially Voided");
            CheckLedgerEntry.SETRANGE(Open, TRUE);
            CheckLedgerEntry.SETRANGE("Statement Status", CheckLedgerEntry."Statement Status"::Open);
            IF CheckLedgerEntry.FIND('-') THEN;
            //     BankAccRecoLine.Type := BankAccRecoLine.Type::"Check Ledger Entry"
            // ELSE
            //     BankAccRecoLine.Type := BankAccRecoLine.Type::"Bank Account Ledger Entry";
        END;
        BankAccRecoLine."Check No." := CheckNo1;
        BankAccRecoLine."Cheque No." := CheckNo1;
        IF StatementDrAmount <> '' THEN BEGIN
            EVALUATE(StatementDrAmount1, StatementDrAmount);
            StatementAmount := -StatementDrAmount1;
        END;
        IF StatementCrAmount <> '' THEN BEGIN
            EVALUATE(StatementCrAmount1, StatementCrAmount);
            StatementAmount := StatementCrAmount1;
        END;

        BankAccRecoLine.VALIDATE("Statement Amount", StatementAmount);
        BankAccRecoLine."Document Type" := DocumentType; //ALLERK 19-03-2010.
        BankAccRecoLine.Description := Desc;
        IF CheckDuplicateChequeNos(CheckNo1) AND (StatementDrAmount1 <> 0) THEN        //ALLETDk
            BankAccRecoLine.Bounced := TRUE;
        //INSERT;
        BankAccRecoLine.MODIFY;//(TRUE);
    end;


    procedure SetStmtHeaderValues(pBankReco: Record "Bank Acc. Reconciliation")
    begin
        BankAccReco := pBankReco;
    end;


    procedure CheckDuplicateChequeNos(ChequeNo: Code[20]): Boolean
    var
        BankRecLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankRecLine.RESET;
        BankRecLine.SETRANGE("Bank Account No.", BankAccReco2."Bank Account No.");
        BankRecLine.SETRANGE("Statement No.", BankAccReco2."Statement No.");
        BankRecLine.SETRANGE("Check No.", ChequeNo);
        IF BankRecLine.FINDFIRST THEN BEGIN
            //BankRecLine.Bounced := TRUE;
            //BankRecLine.MODIFY;
            EXIT(TRUE);
        END;
    end;
}

