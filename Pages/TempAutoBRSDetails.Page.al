page 60678 "Temp Auto BRS Details"
{
    //     LengthRefNo:=0;
    //     LengthTransDescription := 0;
    //     LengthRefNo := STRLEN(TempAutoBRSDetails."Reference No.");
    //     LengthTransDescription := STRLEN(TempAutoBRSDetails."Transaction Description");
    //     IF LengthRefNo > 15 THEN
    //     TempAutoBRSDetails."New Reference No." :=  COPYSTR(TempAutoBRSDetails."Reference No.",LengthRefNo-14,30)
    //     ELSE
    //       TempAutoBRSDetails."New Reference No." :=  TempAutoBRSDetails."Reference No.";
    //     IF LengthTransDescription >15 THEN
    //      TempAutoBRSDetails."New Transaction Description" := COPYSTR(TempAutoBRSDetails."Transaction Description",LengthTransDescription-14,30)
    //     ELSE
    //       TempAutoBRSDetails."New Transaction Description" := TempAutoBRSDetails."Transaction Description";

    InsertAllowed = false;
    PageType = List;
    SourceTable = "Temp Auto BRS Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                }
                field("Value Date"; Rec."Value Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Reference No."; Rec."Reference No.")
                {
                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                }
                field("Transaction Amount"; Rec."Transaction Amount")
                {
                }
                field("USER ID"; Rec."USER ID")
                {
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                }
                field("New Reference No."; Rec."New Reference No.")
                {
                }
                field("New Transaction Description"; Rec."New Transaction Description")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("BALEntry Exists"; Rec."BALEntry Exists")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Insert Data")
            {
                RunObject = XMLport "Temp Auto BRS Details";
            }
            action("Check BRS Entries")
            {

                trigger OnAction()
                var
                    BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                    BankAccountStatementLine: Record "Bank Account Statement Line";
                    TempAutoBRSDetails: Record "Temp Auto BRS Details";
                    ValueDt: Date;
                    LengthRefNo: Integer;
                    LengthTransDescription: Integer;
                    NewTempAutoBRSDetails: Record "Temp Auto BRS Details";
                begin


                    TempAutoBRSDetails.RESET;
                    TempAutoBRSDetails.SETRANGE("USER ID", USERID);
                    IF TempAutoBRSDetails.FINDSET THEN
                        REPEAT
                            TempAutoBRSDetails."New Reference No." := COPYSTR(TempAutoBRSDetails."Reference No.", 1, 20);
                            TempAutoBRSDetails."New Transaction Description" := COPYSTR(TempAutoBRSDetails."Transaction Description", 1, 20);
                            TempAutoBRSDetails.MODIFY;
                        UNTIL TempAutoBRSDetails.NEXT = 0;
                    NewTempAutoBRSDetails.RESET;
                    NewTempAutoBRSDetails.SETRANGE("USER ID", USERID);
                    NewTempAutoBRSDetails.SETRANGE("BALEntry Exists", FALSE);
                    IF NewTempAutoBRSDetails.FINDSET THEN
                        REPEAT
                            BankAccountLedgerEntry.RESET;
                            BankAccountLedgerEntry.SETCURRENTKEY("Bank Account No.", Open);
                            BankAccountLedgerEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                            BankAccountLedgerEntry.SETRANGE(Open, TRUE);
                            BankAccountLedgerEntry.SETRANGE("Cheque No.", NewTempAutoBRSDetails."New Reference No.");
                            IF BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                                IF ABS(BankAccountLedgerEntry.Amount) = ABS(NewTempAutoBRSDetails."Transaction Amount") THEN BEGIN
                                    IF BankAccountLedgerEntry."Cheque Date" > NewTempAutoBRSDetails."Value Date" THEN
                                        ERROR('Value date can not be less than cheque Date' + FORMAT(NewTempAutoBRSDetails."Entry No."));
                                    IF BankAccountLedgerEntry."Posting Date" > NewTempAutoBRSDetails."Value Date" THEN
                                        ERROR('Value date can not be less than Posting Date' + FORMAT(NewTempAutoBRSDetails."Entry No."));
                                    NewTempAutoBRSDetails."BALEntry Exists" := TRUE;
                                    NewTempAutoBRSDetails."Cheque No." := NewTempAutoBRSDetails."New Reference No.";
                                    NewTempAutoBRSDetails."Posting Date" := BankAccountLedgerEntry."Posting Date";
                                    NewTempAutoBRSDetails.MODIFY;
                                END;
                            END;
                            IF NOT NewTempAutoBRSDetails."BALEntry Exists" THEN BEGIN
                                BankAccountLedgerEntry.RESET;
                                BankAccountLedgerEntry.SETCURRENTKEY("Bank Account No.", Open);
                                BankAccountLedgerEntry.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                                BankAccountLedgerEntry.SETRANGE(Open, TRUE);
                                BankAccountLedgerEntry.SETRANGE("Cheque No.", NewTempAutoBRSDetails."New Transaction Description");
                                IF BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                                    IF ABS(BankAccountLedgerEntry.Amount) = ABS(NewTempAutoBRSDetails."Transaction Amount") THEN BEGIN
                                        IF BankAccountLedgerEntry."Cheque Date" > NewTempAutoBRSDetails."Value Date" THEN
                                            ERROR('Value date can not be less than cheque Date' + FORMAT(NewTempAutoBRSDetails."Entry No."));
                                        IF BankAccountLedgerEntry."Posting Date" > NewTempAutoBRSDetails."Value Date" THEN
                                            ERROR('Value date can not be less than Posting Date' + FORMAT(NewTempAutoBRSDetails."Entry No."));
                                        NewTempAutoBRSDetails."BALEntry Exists" := TRUE;
                                        NewTempAutoBRSDetails."Cheque No." := NewTempAutoBRSDetails."New Transaction Description";
                                        NewTempAutoBRSDetails."Posting Date" := BankAccountLedgerEntry."Posting Date";
                                        NewTempAutoBRSDetails.MODIFY;
                                    END;
                                END;
                            END;
                        UNTIL NewTempAutoBRSDetails.NEXT = 0;

                    MESSAGE('%1', 'Done');
                end;
            }
            action("Export Bank Statement Data")
            {
                RunObject = XMLport "Export Temp Auto BRS Details";
            }
        }
    }

    var
        TempAutoBRSDetails: Record "Temp Auto BRS Details";
}

