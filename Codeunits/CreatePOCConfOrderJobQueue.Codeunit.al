codeunit 50011 "Create POC Conf Order JobQueue"
{

    trigger OnRun()
    var
        NewConfirmedOrder: Record "New Confirmed Order";
        LineNo: Integer;
        UMaster: Record "Unit Master";
        OldNewApplicationBooking: Record "New Application Booking";
        CheckNewAppBooking: Record "New Application Booking";
        OldApplicationNo: Code[20];
        OldNewApplicationPayEntry: Record "NewApplication Payment Entry";
        NewReceiptPost: Record "New Application Booking";
        PostPayment: Codeunit PostPayment;
        MobileNo: Text;
        Customer: Record Customer;
    begin

        PaymenttransactionDetails.RESET;
        //PaymenttransactionDetails.SETRANGE("Entry No.",181);
        PaymenttransactionDetails.SETRANGE("Document Create In NAV", FALSE);
        PaymenttransactionDetails.SETFILTER("Payment Server Status", '%1', 'paid');
        //PaymenttransactionDetails.SETRANGE("Error Log",'');
        IF PaymenttransactionDetails.FINDSET THEN
            REPEAT
                CLEAR(CU_CreatePOCConfirmedOrder);
                IF NOT CU_CreatePOCConfirmedOrder.RUN(PaymenttransactionDetails) THEN BEGIN
                    PaymenttransactionDetails."Error Log" := COPYSTR(GETLASTERRORTEXT, 1, 200);
                    PaymenttransactionDetails.MODIFY;
                END ELSE BEGIN
                    PaymenttransactionDetails."Document Create In NAV" := TRUE;
                    PaymenttransactionDetails.MODIFY;
                END;
                COMMIT;
            UNTIL PaymenttransactionDetails.NEXT = 0;
    end;

    var
        NewApplicationBooking: Record "New Application Booking";
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        CompanyInformation: Record "Company Information";
        UnitPost: Codeunit "Unit Post";
        PaymenttransactionDetails: Record "Payment transaction Details";
        CustSMSText: Text;
        GetDescription: Codeunit GetDescription;
        CompInfo: Record "Company Information";
        CU_CreatePOCConfirmedOrder: Codeunit "Create POC Confirmed Order";
}

