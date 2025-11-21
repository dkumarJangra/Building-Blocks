codeunit 50056 "Create Customer and Send SMS"
{

    trigger OnRun()
    var
        CustomerLoginDetails_1: Record "Customer Login Details";
    begin

        CustomerLoginDetails.RESET;
        CustomerLoginDetails.SETRANGE(CustomerLoginDetails."Customer No.", '');
        CustomerLoginDetails.SETRANGE("NAV-Customer Created", FALSE);
        //AssociateLoginDetails.SETRANGE("Send for Associate Create",TRUE);
        //AssociateLoginDetails.SETFILTER(Parent_ID,'<>%1','');
        CustomerLoginDetails.SETFILTER(Status, '%1|%2', CustomerLoginDetails.Status::"Under Process", CustomerLoginDetails.Status::"Sent for Approval");
        IF CustomerLoginDetails.FINDSET THEN
            REPEAT

                CLEAR(CreateCustomerSendSMS);
                CreateCustomerSendSMS.Setvalue(CustomerLoginDetails.USER_ID);
                IF NOT CreateCustomerSendSMS.RUN(CustomerLoginDetails) THEN BEGIN
                    CustomerLoginDetails_1.RESET;
                    IF CustomerLoginDetails_1.GET(CustomerLoginDetails.USER_ID) THEN BEGIN
                        CustomerLoginDetails_1."Customer Creation Error" := COPYSTR(GETLASTERRORTEXT, 1, 100);
                        CustomerLoginDetails_1.MODIFY;
                    END;
                END;
                COMMIT;
            UNTIL CustomerLoginDetails.NEXT = 0;
    end;

    var
        CustomerLoginDetails: Record "Customer Login Details";
        VendNo: Code[20];
        BondSetup: Record "Unit Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        PostPayment: Codeunit PostPayment;
        SMS: Text;
        //SMTPSetup: Record "SMTP Mail Setup";
        //SMTPMail: Codeunit 400;
        CompanyInformation: Record "Company Information";
        CreateCustomerSendSMS: Codeunit "Create Customer / SendSMS";
}

