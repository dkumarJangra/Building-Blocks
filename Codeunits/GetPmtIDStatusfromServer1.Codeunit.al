codeunit 50015 "Get Pmt ID Status fromServer_1"
{
    // UpdatePaymentStatus - ) transaction_id, Pg_Status,Pg_Amount,Associate_ID -> response Success, FAil

    Permissions = TableData "Data Exch. Field" = rimd;

    trigger OnRun()
    var
        PaymentStatus: Text;
        StartDate: Date;
    begin


        //StartDate := CALCDATE('-30D',TODAY);
        //StartDate := TODAY;
        PaymenttransactionDetails.RESET;
        PaymenttransactionDetails.SETFILTER("Payment Server Status", '%1', 'paid');
        //PaymenttransactionDetails.SETRANGE("Receipt Posting Date",StartDate,TODAY);
        PaymenttransactionDetails.SETFILTER("Payment ID", '%1', '');
        //PaymenttransactionDetails.SETRANGE("Entry No.",10900);
        IF PaymenttransactionDetails.FINDSET THEN
            REPEAT
                PmtTransDetails.RESET;
                PmtTransDetails.SETRANGE("Unique Payment Order ID", PaymenttransactionDetails."Unique Payment Order ID");
                IF PmtTransDetails.FINDFIRST THEN BEGIN
                    COMMIT;
                    PaymentStatus := '';
                    CLEAR(GetPmtIDStatusfromServer);
                    GetPmtIDStatusfromServer.Setfilteres(PmtTransDetails."Entry No.");
                    IF NOT GetPmtIDStatusfromServer.RUN(PmtTransDetails) THEN BEGIN
                        //PmtTransDetails."Payment Server Error" := COPYSTR(GETLASTERRORTEXT,1,50); //'Error';
                        //PmtTransDetails.MODIFY;
                    END;
                END;
            UNTIL PaymenttransactionDetails.NEXT = 0;

        MESSAGE('Done');
    end;

    var
        PaymenttransactionDetails: Record "Payment transaction Details";
        PmtTransDetails: Record "Payment transaction Details";
        // StreamWriter: DotNet StreamWriter;
        // StreamReader: DotNet StreamReader;
        GetPmtIDStatusfromServer: Codeunit "Get Pmt ID Status from Server";
}

