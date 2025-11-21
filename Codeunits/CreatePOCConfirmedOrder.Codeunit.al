codeunit 50010 "Create POC Confirmed Order"
{
    TableNo = "Payment transaction Details";

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
        PaymenttransactionDetails.SETRANGE("Entry No.", Rec."Entry No.");
        PaymenttransactionDetails.SETRANGE("Document Create In NAV", FALSE);
        PaymenttransactionDetails.SETFILTER("Payment Server Status", '%1', 'paid');
        IF PaymenttransactionDetails.FINDSET THEN BEGIN
            //REPEAT
            CompInfo.GET;
            IF PaymenttransactionDetails."Application Type" = PaymenttransactionDetails."Application Type"::New THEN BEGIN
                CheckNewAppBooking.RESET;
                CheckNewAppBooking.SETCURRENTKEY("Unit Code");
                CheckNewAppBooking.SETRANGE("Unit Code", PaymenttransactionDetails."Plot ID");
                IF CheckNewAppBooking.FINDFIRST THEN BEGIN
                    OldNewApplicationPayEntry.RESET;
                    OldNewApplicationPayEntry.SETRANGE("Document No.", CheckNewAppBooking."Application No.");
                    OldNewApplicationPayEntry.SETRANGE(Posted, FALSE);
                    OldNewApplicationPayEntry.SETRANGE(Amount, PaymenttransactionDetails."Payment Amount");
                    IF PaymenttransactionDetails."Payment ID" <> '' THEN
                        OldNewApplicationPayEntry.SETRANGE("Cheque No./ Transaction No.", PaymenttransactionDetails."Payment ID")
                    ELSE
                        OldNewApplicationPayEntry.SETRANGE("Cheque No./ Transaction No.", PaymenttransactionDetails."Unique Payment Order ID");
                    IF OldNewApplicationPayEntry.FINDFIRST THEN BEGIN
                        CLEAR(UnitPost);
                        NewReceiptPost.RESET;
                        IF NewReceiptPost.GET(OldNewApplicationPayEntry."Document No.") THEN;
                        UnitPost.PostNewReceipt(NewReceiptPost, TRUE);
                        CLEAR(PostPayment);
                        MobileNo := PaymenttransactionDetails."Mobile No.";

                        IF (MobileNo <> '') AND (CompInfo."Send SMS") THEN BEGIN
                            CustSMSText := '';
                            CustSMSText :=
                            'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to Building Blocks Family. Please find attached details ID:'
                            + FORMAT(OldNewApplicationPayEntry."Posted Document No.") + 'Dt.' + FORMAT(OldNewApplicationPayEntry."Posting date")
                            + 'Appl No:' + OldNewApplicationPayEntry."Document No." + ' ' + 'Project: ' + GetDescription.GetDimensionName(NewReceiptPost."Shortcut Dimension 1 Code", 1) +
                            'Amt. Rs.' + FORMAT(OldNewApplicationPayEntry.Amount) + 'Thankyou and Assuring you of Best Property Services with Building'
                            + 'Blocks Group' + 'Tx for payment(If Chq-Subject to Realization).';

                            PostPayment.SendSMS(MobileNo, CustSMSText);
                            //ALLEDK15112022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage := COPYSTR(CustSMSText, 1, 250);
                            SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                            SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Customer Receipt',
                            NewReceiptPost."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(NewReceiptPost."Shortcut Dimension 1 Code", 1), NewReceiptPost."Application No.");
                            //ALLEDK15112022 END


                        END;

                        OldNewApplicationBooking.RESET;
                        IF OldNewApplicationBooking.GET(CheckNewAppBooking."Application No.") THEN
                            UnitPost.CreateNewConfOrder(OldNewApplicationBooking);
                    END ELSE BEGIN
                        NewApplicationPaymentEntry.INIT;
                        NewApplicationPaymentEntry."Document Type" := NewApplicationPaymentEntry."Document Type"::Application;
                        NewApplicationPaymentEntry."Document No." := CheckNewAppBooking."Application No.";
                        NewApplicationPaymentEntry."Line No." := 10000;
                        NewApplicationPaymentEntry.VALIDATE("Payment Mode", NewApplicationPaymentEntry."Payment Mode"::Bank);
                        NewApplicationPaymentEntry.VALIDATE("Payment Method", 'D.C./C.C.');
                        NewApplicationPaymentEntry.VALIDATE(Amount, PaymenttransactionDetails."Payment Amount");
                        NewApplicationPaymentEntry.VALIDATE("Bank Type", NewApplicationPaymentEntry."Bank Type"::ProjectCompany);
                        NewApplicationPaymentEntry.VALIDATE("Deposit/Paid Bank", CompanyInformation."Online Bank Account No.");
                        IF PaymenttransactionDetails."Payment ID" <> '' THEN
                            NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", PaymenttransactionDetails."Payment ID")
                        ELSE
                            NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", PaymenttransactionDetails."Unique Payment Order ID");
                        NewApplicationPaymentEntry.VALIDATE("Cheque Date", PaymenttransactionDetails."Receipt Posting Date");
                        NewApplicationPaymentEntry.VALIDATE("Cheque Bank and Branch", 'Online');
                        NewApplicationPaymentEntry."Posting date" := PaymenttransactionDetails."Receipt Posting Date";
                        NewApplicationPaymentEntry."Create from MSC Company" := TRUE;
                        NewApplicationPaymentEntry."Company Name" := CheckNewAppBooking."Company Name";
                        NewApplicationPaymentEntry."Document Date" := TODAY;
                        NewApplicationPaymentEntry."User ID" := USERID;
                        NewApplicationPaymentEntry."Online Customer Receipt" := TRUE;
                        NewApplicationPaymentEntry.VALIDATE("Shortcut Dimension 1 Code", CheckNewAppBooking."Shortcut Dimension 1 Code");
                        NewApplicationPaymentEntry.INSERT;
                        PaymenttransactionDetails."Application No." := CheckNewAppBooking."Application No.";
                        CLEAR(UnitPost);
                        NewReceiptPost.RESET;
                        IF NewReceiptPost.GET(NewApplicationPaymentEntry."Document No.") THEN;

                        UnitPost.PostNewReceipt(NewReceiptPost, TRUE);
                        IF Customer.GET(NewReceiptPost."Customer No.") THEN;
                        MobileNo := PaymenttransactionDetails."Mobile No.";
                        CLEAR(PostPayment);
                        IF (MobileNo <> '') AND (CompInfo."Send SMS") THEN BEGIN
                            CustSMSText := '';
                            CustSMSText :=
                            'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to Building Blocks Family. Please find attached details ID:'
                            + FORMAT(NewApplicationPaymentEntry."Posted Document No.") + 'Dt.' + FORMAT(NewApplicationPaymentEntry."Posting date")
                            + 'Appl No:' + NewApplicationPaymentEntry."Document No." + ' ' + 'Project: ' + GetDescription.GetDimensionName(NewReceiptPost."Shortcut Dimension 1 Code", 1) +
                            'Amt. Rs.' + FORMAT(NewApplicationPaymentEntry.Amount) + 'Thankyou and Assuring you of Best Property Services with Building'
                            + 'Blocks Group' + 'Tx for payment(If Chq-Subject to Realization).';

                            PostPayment.SendSMS(MobileNo, CustSMSText);
                            //ALLEDK15112022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage := COPYSTR(CustSMSText, 1, 250);
                            SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                            SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Customer Receipt',
                            NewReceiptPost."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(NewReceiptPost."Shortcut Dimension 1 Code", 1), NewReceiptPost."Application No.");
                            //ALLEDK15112022 END
                        END;

                        OldNewApplicationBooking.RESET;
                        IF OldNewApplicationBooking.GET(CheckNewAppBooking."Application No.") THEN
                            UnitPost.CreateNewConfOrder(OldNewApplicationBooking);
                    END;
                END ELSE BEGIN
                    UMaster.RESET;
                    IF UMaster.GET(PaymenttransactionDetails."Plot ID") THEN BEGIN
                        UMaster.Status := UMaster.Status::Open;
                        UMaster."Web Portal Status" := UMaster."Web Portal Status"::Available;
                        UMaster.Freeze := FALSE;
                        UMaster.MODIFY;
                    END;

                    NewApplicationBooking.INIT;
                    NewApplicationBooking."Application Type" := NewApplicationBooking."Application Type"::"Non Trading";
                    NewApplicationBooking.Type := NewApplicationBooking.Type::Normal;
                    NewApplicationPaymentEntry."User ID" := USERID;
                    NewApplicationBooking.INSERT(TRUE);
                    NewApplicationBooking.VALIDATE("Shortcut Dimension 1 Code", PaymenttransactionDetails."Project ID");
                    NewApplicationBooking.VALIDATE("Bill-to Customer Name", PaymenttransactionDetails."Member Name");
                    NewApplicationBooking.VALIDATE("Member's D.O.B", PaymenttransactionDetails."Date of Birth");
                    NewApplicationBooking.VALIDATE("Mobile No.", PaymenttransactionDetails."Mobile No.");
                    NewApplicationBooking.VALIDATE("Associate Code", PaymenttransactionDetails."Associate Id");
                    NewApplicationBooking.VALIDATE("Unit Payment Plan", PaymenttransactionDetails."Unit Payment Plan");
                    NewApplicationBooking.VALIDATE("Unit Code", UMaster."No."); //,UMaster."No.");
                    NewApplicationBooking.MODIFY;
                    CompanyInformation.RESET;
                    CompanyInformation.CHANGECOMPANY(NewApplicationBooking."Company Name");
                    CompanyInformation.GET;
                    IF CompanyInformation."Online Bank Account No." = '' THEN
                        ERROR('Please define Online Bank Account on Company information for Comany Name = ' + NewApplicationBooking."Company Name");

                    NewApplicationPaymentEntry.INIT;
                    NewApplicationPaymentEntry."Document Type" := NewApplicationPaymentEntry."Document Type"::Application;
                    NewApplicationPaymentEntry."Document No." := NewApplicationBooking."Application No.";
                    NewApplicationPaymentEntry."Line No." := 10000;
                    NewApplicationPaymentEntry.VALIDATE("Payment Mode", NewApplicationPaymentEntry."Payment Mode"::Bank);
                    NewApplicationPaymentEntry.VALIDATE("Payment Method", 'D.C./C.C.');
                    NewApplicationPaymentEntry.VALIDATE(Amount, PaymenttransactionDetails."Payment Amount");
                    NewApplicationPaymentEntry.VALIDATE("Bank Type", NewApplicationPaymentEntry."Bank Type"::ProjectCompany);
                    NewApplicationPaymentEntry.VALIDATE("Deposit/Paid Bank", CompanyInformation."Online Bank Account No.");
                    IF PaymenttransactionDetails."Payment ID" <> '' THEN
                        NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", PaymenttransactionDetails."Payment ID")
                    ELSE
                        NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", PaymenttransactionDetails."Unique Payment Order ID");
                    NewApplicationPaymentEntry.VALIDATE("Cheque Date", PaymenttransactionDetails."Receipt Posting Date");
                    NewApplicationPaymentEntry.VALIDATE("Cheque Bank and Branch", 'Online');
                    NewApplicationPaymentEntry."Posting date" := PaymenttransactionDetails."Receipt Posting Date";
                    NewApplicationPaymentEntry."Create from MSC Company" := TRUE;
                    NewApplicationPaymentEntry."Company Name" := NewApplicationBooking."Company Name";
                    NewApplicationPaymentEntry."Document Date" := TODAY;
                    NewApplicationPaymentEntry."User ID" := USERID;
                    NewApplicationPaymentEntry."Online Customer Receipt" := TRUE;
                    NewApplicationPaymentEntry.VALIDATE("Shortcut Dimension 1 Code", NewApplicationBooking."Shortcut Dimension 1 Code");
                    NewApplicationPaymentEntry.INSERT;
                    PaymenttransactionDetails."Application No." := NewApplicationBooking."Application No.";
                    CLEAR(UnitPost);
                    IF NewReceiptPost.GET(NewApplicationPaymentEntry."Document No.") THEN;
                    UnitPost.PostNewReceipt(NewReceiptPost, TRUE);
                    NewReceiptPost.RESET;
                    MobileNo := PaymenttransactionDetails."Mobile No.";

                    CLEAR(PostPayment);
                    IF (MobileNo <> '') AND (CompInfo."Send SMS") THEN BEGIN
                        CustSMSText := '';
                        CustSMSText :=
                        'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to Building Blocks Family. Please find attached details ID:'
                        + FORMAT(NewApplicationPaymentEntry."Posted Document No.") + 'Dt.' + FORMAT(NewApplicationPaymentEntry."Posting date")
                        + 'Appl No:' + NewApplicationPaymentEntry."Document No." + ' ' + 'Project: ' + GetDescription.GetDimensionName(NewReceiptPost."Shortcut Dimension 1 Code", 1) +
                        'Amt. Rs.' + FORMAT(NewApplicationPaymentEntry.Amount) + 'Thankyou and Assuring you of Best Property Services with Building'
                        + 'Blocks Group' + 'Tx for payment(If Chq-Subject to Realization).';
                        PostPayment.SendSMS(MobileNo, CustSMSText);
                        //ALLEDK15112022 Start
                        CLEAR(SMSLogDetails);
                        SmsMessage := '';
                        SmsMessage1 := '';
                        SmsMessage := COPYSTR(CustSMSText, 1, 250);
                        SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                        SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Customer Receipt',
                        NewReceiptPost."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(NewReceiptPost."Shortcut Dimension 1 Code", 1), NewReceiptPost."Application No.");
                        //ALLEDK15112022 END
                    END;

                    OldNewApplicationBooking.RESET;
                    IF OldNewApplicationBooking.GET(NewApplicationBooking."Application No.") THEN
                        UnitPost.CreateNewConfOrder(OldNewApplicationBooking);
                END;
            END ELSE BEGIN
                NewConfirmedOrder.RESET;
                IF NewConfirmedOrder.GET(PaymenttransactionDetails."Application No.") THEN BEGIN
                    LineNo := 0;
                    NewApplicationPaymentEntry.RESET;
                    NewApplicationPaymentEntry.SETRANGE("Document No.", PaymenttransactionDetails."Application No.");
                    IF NewApplicationPaymentEntry.FINDLAST THEN
                        LineNo := NewApplicationPaymentEntry."Line No.";

                    CompanyInformation.RESET;
                    CompanyInformation.CHANGECOMPANY(NewConfirmedOrder."Company Name");
                    CompanyInformation.GET;
                    //    CompanyInformation.TESTFIELD("Job Madetory On MRN");

                    OldNewApplicationPayEntry.RESET;
                    OldNewApplicationPayEntry.SETRANGE("Document No.", NewConfirmedOrder."No.");
                    OldNewApplicationPayEntry.SETRANGE(Posted, FALSE);
                    OldNewApplicationPayEntry.SETRANGE(Amount, PaymenttransactionDetails."Payment Amount");
                    IF PaymenttransactionDetails."Payment ID" <> '' THEN
                        OldNewApplicationPayEntry.SETRANGE("Cheque No./ Transaction No.", PaymenttransactionDetails."Payment ID")
                    ELSE
                        OldNewApplicationPayEntry.SETRANGE("Cheque No./ Transaction No.", PaymenttransactionDetails."Unique Payment Order ID");
                    IF OldNewApplicationPayEntry.FINDFIRST THEN BEGIN
                        CLEAR(UnitPost);
                        UnitPost.PostConfirmedReceipt(NewConfirmedOrder, TRUE);
                        CLEAR(PostPayment);
                        IF Customer.GET(NewConfirmedOrder."Customer No.") THEN
                            MobileNo := Customer."BBG Mobile No.";
                        IF (MobileNo <> '') AND (CompInfo."Send SMS") THEN BEGIN
                            CustSMSText := '';
                            CustSMSText :=
                                    'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to BBG Family. Appl No:' + NewConfirmedOrder."No." +
                                    ' ' + 'Recvd Rs.' + FORMAT(OldNewApplicationPayEntry.Amount) +
                                    ' ' + 'Project: ' + GetDescription.GetDimensionName(NewConfirmedOrder."Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' +
                                    FORMAT(OldNewApplicationPayEntry."Posting date") + 'Tx for payment(If Chq-Subject to Realization).';
                        END;
                    END ELSE BEGIN
                        NewApplicationPaymentEntry.INIT;
                        NewApplicationPaymentEntry."Document Type" := NewApplicationPaymentEntry."Document Type"::BOND;
                        NewApplicationPaymentEntry."Document No." := PaymenttransactionDetails."Application No.";
                        NewApplicationPaymentEntry."Line No." := LineNo + 10000;
                        NewApplicationPaymentEntry.VALIDATE("Payment Mode", NewApplicationPaymentEntry."Payment Mode"::Bank);
                        NewApplicationPaymentEntry.VALIDATE(Amount, PaymenttransactionDetails."Payment Amount");
                        NewApplicationPaymentEntry.VALIDATE("Payment Method", 'D.C./C.C.');
                        NewApplicationPaymentEntry.VALIDATE("Bank Type", NewApplicationPaymentEntry."Bank Type"::ProjectCompany);
                        NewApplicationPaymentEntry.VALIDATE("Deposit/Paid Bank", CompanyInformation."Online Bank Account No.");
                        IF PaymenttransactionDetails."Payment ID" <> '' THEN
                            NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", PaymenttransactionDetails."Payment ID")
                        ELSE
                            NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", PaymenttransactionDetails."Unique Payment Order ID");
                        NewApplicationPaymentEntry.VALIDATE("Cheque Date", PaymenttransactionDetails."Receipt Posting Date");
                        NewApplicationPaymentEntry.VALIDATE("Cheque Bank and Branch", 'Online');
                        NewApplicationPaymentEntry."Posting date" := PaymenttransactionDetails."Receipt Posting Date";
                        NewApplicationPaymentEntry."Document Date" := TODAY;
                        NewApplicationPaymentEntry."Create from MSC Company" := TRUE;
                        NewApplicationPaymentEntry."Company Name" := NewConfirmedOrder."Company Name";
                        NewApplicationPaymentEntry."User ID" := USERID;
                        NewApplicationPaymentEntry."Online Customer Receipt" := TRUE;
                        NewApplicationPaymentEntry.VALIDATE("Shortcut Dimension 1 Code", NewConfirmedOrder."Shortcut Dimension 1 Code");
                        NewApplicationPaymentEntry.INSERT;
                        CLEAR(UnitPost);
                        UnitPost.PostConfirmedReceipt(NewConfirmedOrder, TRUE);
                        CLEAR(PostPayment);
                        IF Customer.GET(NewConfirmedOrder."Customer No.") THEN
                            MobileNo := Customer."BBG Mobile No.";
                        IF (MobileNo <> '') AND (CompInfo."Send SMS") THEN BEGIN
                            CustSMSText := '';
                            CustSMSText :=
                                    'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to BBG Family. Appl No:' + NewConfirmedOrder."No." +
                                    ' ' + 'Recvd Rs.' + FORMAT(NewApplicationPaymentEntry.Amount) +
                                    ' ' + 'Project: ' + GetDescription.GetDimensionName(NewConfirmedOrder."Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' +
                                    FORMAT(NewApplicationPaymentEntry."Posting date") + 'Tx for payment(If Chq-Subject to Realization).';
                        END;
                    END;
                END;
            END;

            PaymenttransactionDetails."Document Create In NAV" := TRUE;
            PaymenttransactionDetails.MODIFY;
        END;
        COMMIT;
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
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
}

