xmlport 97757 "Update UTR No"
{
    Direction = Import;
    FieldDelimiter = '<None>';
    Format = VariableText;
    Permissions = TableData "Bank Account Ledger Entry" = rim;

    schema
    {
        textelement(Root)
        {
            tableelement("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'BLE';
                fieldelement(EntryNo; "Bank Account Ledger Entry"."Entry No.")
                {
                }
                fieldelement(DocumentNo; "Bank Account Ledger Entry"."Document No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(UTRNo; "Bank Account Ledger Entry"."UTR No.")
                {
                }
                fieldelement(Vdate; "Bank Account Ledger Entry"."Value Date")
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    ApplicationPaymentEntry: Record "Application Payment Entry";
                    NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
                begin
                    IF BankAccountLedgerEntry.GET("Bank Account Ledger Entry"."Entry No.") THEN BEGIN
                        //BankAccountLedgerEntry.CALCFIELDS("Application No.","Receipt Line No.");
                        // IF UpdateChequeNo THEN BEGIN
                        BankAccountLedgerEntry."UTR No." := BankAccountLedgerEntry."Cheque No.";
                        BankAccountLedgerEntry."Cheque No." := "Bank Account Ledger Entry"."UTR No.";
                        //END ELSE BEGIN
                        //  BankAccountLedgerEntry."UTR No." := "Bank Account Ledger Entry"."UTR No.";
                        //END;
                        BankAccountLedgerEntry."Value Date" := "Bank Account Ledger Entry"."Value Date";
                        BankAccountLedgerEntry.MODIFY;

                        ApplicationPaymentEntry.RESET;
                        ApplicationPaymentEntry.SETRANGE("Document No.", BankAccountLedgerEntry."Application No.");
                        ApplicationPaymentEntry.SETRANGE("Line No.", BankAccountLedgerEntry."Receipt Line No.");
                        ApplicationPaymentEntry.SETRANGE("Posted Document No.", BankAccountLedgerEntry."Document No.");
                        IF ApplicationPaymentEntry.FINDFIRST THEN BEGIN
                            ApplicationPaymentEntry."Cheque No./ Transaction No." := BankAccountLedgerEntry."Cheque No.";
                            ApplicationPaymentEntry.MODIFY;

                            NewApplicationPaymentEntry.RESET;
                            NewApplicationPaymentEntry.SETRANGE("Document No.", BankAccountLedgerEntry."Application No.");
                            NewApplicationPaymentEntry.SETRANGE("Line No.", ApplicationPaymentEntry."Receipt Line No.");
                            IF NewApplicationPaymentEntry.FINDFIRST THEN BEGIN
                                NewApplicationPaymentEntry."Cheque No./ Transaction No." := BankAccountLedgerEntry."Cheque No.";
                                NewApplicationPaymentEntry.MODIFY;
                            END;
                        END;
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        //PurchasesPayablesSetup.GET;
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Process Done');
    end;

    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        UpdateChequeNo: Boolean;
}

