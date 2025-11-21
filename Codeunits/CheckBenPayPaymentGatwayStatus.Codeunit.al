codeunit 50104 "Check BENPAY Payment Status"
{
    // UpdatePaymentStatus - ) transaction_id, Pg_Status,Pg_Amount,Associate_ID -> response Success, FAil

    Permissions = TableData "Data Exch. Field" = rimd;

    trigger OnRun()
    var
        PaymentStatus: Text;
        StartDate: Date;
    begin


        StartDate := CALCDATE('-12D', TODAY);
        PaymenttransactionDetails.RESET;
        PaymenttransactionDetails.SETCURRENTKEY("Receipt Posting Date");
        PaymenttransactionDetails.SETRANGE("Receipt Posting Date", StartDate, TODAY);
        PaymenttransactionDetails.SETRANGE("Payment From", PaymenttransactionDetails."Payment From"::Benepay);
        PaymenttransactionDetails.SETFILTER("Payment Server Status", '<>%1&<>%2', 'FAILED', 'PAID');  //270525 Added new 'PAID'
                                                                                                      //PaymenttransactionDetails.SETRANGE("Entry No.",43296);
                                                                                                      // PaymenttransactionDetails.SETRANGE("Entry No.", 49948, 49949); //18112025
        IF PaymenttransactionDetails.FINDSET THEN
            REPEAT
                PmtTransDetails.RESET;
                PmtTransDetails.SETCURRENTKEY("Unique Payment Order ID");
                PmtTransDetails.SETRANGE("Unique Payment Order ID", PaymenttransactionDetails."Unique Payment Order ID");
                IF PmtTransDetails.FINDFIRST THEN BEGIN
                    COMMIT;
                    PaymentStatus := '';
                    CLEAR(CheckPaymentGatwayStatus_2);
                    CheckPaymentGatwayStatus_2.Setfilteres(PmtTransDetails."Entry No.");
                    IF NOT CheckPaymentGatwayStatus_2.RUN(PmtTransDetails) THEN BEGIN
                        PmtTransDetails."Payment Server Error" := COPYSTR(GETLASTERRORTEXT, 1, 50); //'Error';
                        PmtTransDetails.MODIFY;
                    END;
                END;
            UNTIL PaymenttransactionDetails.NEXT = 0;
    end;

    var
        PaymenttransactionDetails: Record "Payment transaction Details";
        PmtTransDetails: Record "Payment transaction Details";
        // StreamWriter: DotNet StreamWriter;
        // StreamReader: DotNet StreamReader;
        CheckPaymentGatwayStatus_2: Codeunit "Check BENPAY Payment Status_2"
;
}

