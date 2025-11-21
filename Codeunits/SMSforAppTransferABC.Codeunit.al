codeunit 50025 "SMS for App Transfer A-B-C"
{

    trigger OnRun()
    begin
        CompInfo.GET;
        IF CompInfo."Send SMS" THEN BEGIN
            "New Confirmed Order".RESET;
            //"New Confirmed Order".SETRANGE("No.",'AP1516005180');
            "New Confirmed Order".SETRANGE(Status, "New Confirmed Order".Status::Open);
            "New Confirmed Order".SETFILTER("Unit Code", '<>%1', '');
            IF "New Confirmed Order".FINDSET THEN
                REPEAT
                    "New Confirmed Order".CALCFIELDS("Total Received Amount");
                    IF ("New Confirmed Order".Amount - "New Confirmed Order"."Total Received Amount") > 0 THEN BEGIN
                        CLEAR(SMSforAppTransferABC1);
                        IF NOT SMSforAppTransferABC1.RUN("New Confirmed Order") THEN BEGIN
                        END;
                    END;
                UNTIL "New Confirmed Order".NEXT = 0;
        END;
    end;

    var
        "New Confirmed Order": Record "New Confirmed Order";
        CompInfo: Record "Company Information";
        CustName: Text;
        Cust: Record Customer;
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        APPPaymentEntry: Record "Application Payment Entry";
        NewDate: Date;
        FromOption: Text;
        ToOption: Text;
        Vendor: Record Vendor;
        ShowData: Boolean;
        OptionA: Date;
        OptionB: Date;
        OptionC: Date;
        UnitSetup: Record "Unit Setup";
        ReceptAmount: Decimal;
        NewOption: Code[10];
        CompanywiseGLAccount: Record "Company wise G/L Account";
        GetDescription: Codeunit GetDescription;
        Text001: Label 'Dear: Mr/Ms %1 , we are pleased to inform you that your Plot:%2 & Appl No:%3 payment plan is changing from %4 to %5 in %6 days..Please pay the due amount to avoid payment option charges. Please ignore if already paid. With best regards from BBG.';
        PostPayment: Codeunit PostPayment;
        SMSforAppTransferABC1: Codeunit "SMS for App Transfer A-B-C-1";
}

