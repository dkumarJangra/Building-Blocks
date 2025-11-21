codeunit 97752 "SMS_Email to Vend_Cust_Employe"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            MBNo := '';
            Customer.RESET;
            Customer.SETCURRENTKEY("BBG Mobile No.");
            Customer.SETFILTER("BBG Mobile No.", '<>%1', '');
            Customer.SETFILTER("BBG Date of Birth", '<>%1', 0D);
            IF Customer.FINDSET THEN
                REPEAT
                    IF MBNo <> Customer."BBG Mobile No." THEN BEGIN
                        MBNo := Customer."BBG Mobile No.";
                        Month := DATE2DMY(Customer."BBG Date of Birth", 2);
                        Days := DATE2DMY(Customer."BBG Date of Birth", 1);
                        Month_1 := DATE2DMY(TODAY, 2);
                        Days_1 := DATE2DMY(TODAY, 1);
                        IF (Days_1 = Days) AND (Month = Month_1) THEN BEGIN
                            SMS_EmailWishes.GETValueSMS('CustomerBirth', Customer."No.");
                            IF NOT SMS_EmailWishes.RUN THEN BEGIN
                            END;
                        END;
                    END;
                UNTIL Customer.NEXT = 0;
        END;
    end;

    var
        ComInfo: Record "Company Information";
        MBNo: Text[30];
        Customer: Record Customer;
        SMS_EmailWishes: Codeunit "Email and SMS for Wishes";
        Month: Integer;
        Days: Integer;
        Month_1: Integer;
        Days_1: Integer;
}

