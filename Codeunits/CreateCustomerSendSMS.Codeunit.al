codeunit 50057 "Create Customer / SendSMS"
{
    TableNo = "Customer Login Details";

    trigger OnRun()
    var
        RecVendor_1: Record Vendor;
        BondSetup: Record "Unit Setup";
        Customer: Record Customer;
    begin
        ReturnCustomerCode := InsertCustomer(RecUSERID);
    end;

    var
        CustomerLoginDetails: Record "Customer Login Details";
        VendNo: Code[20];
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        PostPayment: Codeunit PostPayment;
        SMS: Text;
        //SMTPSetup: Record "SMTP Mail Setup";
        //SMTPMail: Codeunit 400;
        CompanyInformation: Record "Company Information";
        Filename: Text;
        RecUSERID: Integer;
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        MobFirstLetter: Text;
        BondSetup: Record "Unit Setup";
        Customer: Record Customer;
        CustNo: Code[20];
        ReturnCustomerCode: Code[20];


    procedure Setvalue(RecUSERID1: Integer)
    begin
        RecUSERID := RecUSERID1;
    end;


    procedure CreateCustomer(P_vCustomerLoginDetails: Record "Customer Login Details"): Code[20]
    begin
        BondSetup.GET;
        Customer.INIT;
        Customer.VALIDATE(Name, P_vCustomerLoginDetails.Name);
        Customer."Customer Posting Group" := BondSetup."Customer Posting Group";
        Customer."No. Series" := BondSetup."Customer No Series";
        Customer."BBG Mobile No." := P_vCustomerLoginDetails."Mobile No.";
        Customer."BBG Date of Birth" := P_vCustomerLoginDetails."Date of Birth";
        Customer."E-Mail" := P_vCustomerLoginDetails."E-Mail";
        Customer.Address := P_vCustomerLoginDetails.Address;
        Customer."Address 2" := P_vCustomerLoginDetails."Address 2";
        Customer.City := P_vCustomerLoginDetails.City;
        Customer."GST Customer Type" := Customer."GST Customer Type"::Unregistered;
        //Customer."State Code" := "Customer State Code";
        //Customer."State Code" := UnitSetup."Default Customer State Code";
        Customer."Country/Region Code" := 'IN'; //Code added 23072025
        Customer.INSERT(TRUE);
        EXIT(Customer."No.");
    end;


    procedure InsertCustomer(RecUSERID_1: Integer): Code[20]
    begin
        CustomerLoginDetails.RESET;
        CustomerLoginDetails.SETRANGE(USER_ID, RecUSERID);
        CustomerLoginDetails.SETRANGE("NAV-Customer Created", FALSE);
        CustomerLoginDetails.SETFILTER(Status, '%1|%2', CustomerLoginDetails.Status::"Under Process", CustomerLoginDetails.Status::"Sent for Approval");
        IF CustomerLoginDetails.FINDFIRST THEN BEGIN
            //AssociateLoginDetails."Send for Associate Create" := TRUE;
            CustNo := CreateCustomer(CustomerLoginDetails);
            CustomerLoginDetails."Customer No." := CustNo;
            CustomerLoginDetails."NAV-Customer Created" := TRUE;
            CustomerLoginDetails."NAV-Customer Creation Date" := TODAY;
            CustomerLoginDetails.Status := CustomerLoginDetails.Status::Approved;
            CustomerLoginDetails.MODIFY;
        END;
        COMMIT;
    end;
}

