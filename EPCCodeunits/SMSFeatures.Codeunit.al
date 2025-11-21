codeunit 97738 "SMS Features"
{
    Permissions = TableData "Bank Account Ledger Entry" = rimd;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        IF Rec."Parameter String" = 'FullAmtRecv' THEN
            SmsonfullAmountReceive
        ELSE
            IF Rec."Parameter String" = 'CustomerCheqBounce' THEN
                SmsonCustomerCheqbounce
            ELSE
                IF Rec."Parameter String" = 'PaymentReminder' THEN
                    SmsforPaymentReminder
                ELSE
                    IF Rec."Parameter String" = 'GoldCoinFullPmt' THEN
                        SmsGoldCoinonFullPayment
                    ELSE
                        IF Rec."Parameter String" = 'GoldCoinPartial' THEN
                            SmsGoldCoinonPartialPayment;
    end;

    var
        ComInfo: Record "Company Information";
        PostPayment: Codeunit PostPayment;
        GetDescription: Codeunit GetDescription;
        Bondsetup: Record "Unit Setup";
        "Parameter String": Text[30];
        RespCenter: Record "Responsibility Center 1";
        Company: Record Company;
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";
        ExitMessage: Boolean;
        AssociateHierarcywithApp: Record "Associate Hierarcy with App.";
        Customer: Record Customer;
        NewConfirmedOrder: Record "New Confirmed Order";
        SMSVendor: Record Vendor;
        CustMobileNo: Text;
        CustSMSText: Text;
        ResponsibilityCenter: Record "Responsibility Center 1";
        CompanywiseGLAccount: Record "Company wise G/L Account";


    procedure SmsGoldCoinonFullPayment()
    var
        Customer: Record Customer;
        CustMobileNo: Text[30];
        CustSMSText: Text[1000];
        ConfirmedOrder: Record "Confirmed Order";
        NoofGoldCoin: Integer;
    begin
        Bondsetup.GET;
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            Bondsetup.TESTFIELD(Bondsetup."SMS Start Date");
            ConfirmedOrder.RESET;
            ConfirmedOrder.SETCURRENTKEY(ConfirmedOrder."Sent SMS on Full Pmt Gold Coin");
            ConfirmedOrder.SETRANGE(ConfirmedOrder."Sent SMS on Full Pmt Gold Coin", FALSE);
            ConfirmedOrder.SETRANGE("Posting Date", Bondsetup."SMS Start Date", TODAY);
            ConfirmedOrder.SETFILTER(Status, '<>%1', ConfirmedOrder.Status::Cancelled);
            IF ConfirmedOrder.FINDSET THEN
                REPEAT
                    IF Customer.GET(ConfirmedOrder."Customer No.") THEN
                        IF Customer."BBG Mobile No." <> '' THEN BEGIN
                            CustMobileNo := Customer."BBG Mobile No.";
                            NoofGoldCoin := CheckGoldcoinEligibility(ConfirmedOrder."No.", TRUE);
                            IF NoofGoldCoin > 0 THEN BEGIN
                                CustSMSText := '';
                                CustSMSText :=
                                          'Mr/Mrs/Ms:' + Customer.Name + '.' + 'Congratulations! You are eligible for ' + '' + FORMAT(NoofGoldCoin) +
                                                ' ' + 'Gold Coins,twdsApplNo:' + ConfirmedOrder."No." +
                                                ' ' + 'Project: ' + GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1) + ' ' +
                                                'Pls Collect';

                                //210224 Added new code
                                CLEAR(CheckMobileNoforSMS);
                                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                                IF ExitMessage THEN
                                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                ConfirmedOrder."Sent SMS on Full Pmt Gold Coin" := TRUE;
                                ConfirmedOrder.MODIFY;
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Gold Coin', ConfirmedOrder."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1), ConfirmedOrder."No.")
                          ;

                                //ALLEDK15112022 END

                            END;
                        END;
                UNTIL ConfirmedOrder.NEXT = 0;
        END;
    end;


    procedure SmsGoldCoinonPartialPayment()
    var
        Customer: Record Customer;
        CustMobileNo: Text[30];
        CustSMSText: Text[1024];
        ConfirmedOrder: Record "Confirmed Order";
        NoofGoldCoin: Integer;
        RemGoldCoin: Integer;
    begin
        Bondsetup.GET;
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            Bondsetup.TESTFIELD(Bondsetup."SMS Start Date");
            ConfirmedOrder.RESET;
            ConfirmedOrder.SETCURRENTKEY("Sent SMS on Full Pmt Gold Coin");
            ConfirmedOrder.SETRANGE("Sent SMS on Partial Gold Coin", FALSE);
            ConfirmedOrder.SETRANGE("Sent SMS on Full Pmt Gold Coin", FALSE);
            ConfirmedOrder.SETRANGE("Posting Date", Bondsetup."SMS Start Date", TODAY);
            ConfirmedOrder.SETFILTER(Status, '<>%1', ConfirmedOrder.Status::Cancelled);
            IF ConfirmedOrder.FINDSET THEN
                REPEAT
                    IF Customer.GET(ConfirmedOrder."Customer No.") THEN
                        IF Customer."BBG Mobile No." <> '' THEN BEGIN
                            CustMobileNo := Customer."BBG Mobile No.";
                            NoofGoldCoin := CheckGoldcoinEligibility(ConfirmedOrder."No.", FALSE);
                            RemGoldCoin := TotalCheckGoldcoinEligibility(ConfirmedOrder."No.") - NoofGoldCoin;
                            IF NoofGoldCoin > 0 THEN BEGIN
                                CustSMSText := '';
                                CustSMSText :=
                                          'Mr/Mrs/Ms:' + Customer.Name + '.' + 'Congratulations! You are eligible for ' + '' + FORMAT(NoofGoldCoin) +
                                                ' ' + 'Gold Coins twdsApplNo:' + ConfirmedOrder."No." +
                                                ' ' + 'Project: ' + GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1) + ' ' +
                                                '& remining ' + FORMAT(RemGoldCoin) + 'Coins will be issued on full payment within one month';
                                //210224 Added new code
                                CLEAR(CheckMobileNoforSMS);
                                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                                IF ExitMessage THEN
                                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                ConfirmedOrder."Sent SMS on Partial Gold Coin" := TRUE;
                                ConfirmedOrder.MODIFY;
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Gold Coin',
                                ConfirmedOrder."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1)
                                , ConfirmedOrder."No.");

                                //ALLEDK15112022 END
                            END;
                        END;
                UNTIL ConfirmedOrder.NEXT = 0;
        END;
    end;


    procedure SmsonAJVM(ApplicationCode: Code[20])
    var
        Vendor: Record Vendor;
        CustMobileNo: Text[30];
        AppPayEntry: Record "Application Payment Entry";
        CustSMSText: Text[1000];
        ConfirmedOrder: Record "Confirmed Order";
        Cust: Record Customer;
    begin
        IF ConfirmedOrder.GET(ApplicationCode) THEN BEGIN
            ComInfo.GET;
            IF ComInfo."Send SMS" THEN BEGIN
                IF Vendor.GET(ConfirmedOrder."AJVM Associate Code") THEN
                    IF Vendor."BBG Mob. No." <> '' THEN BEGIN
                        CustMobileNo := Vendor."BBG Mob. No.";
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", ConfirmedOrder."No.");
                        AppPayEntry.SETRANGE(Posted, TRUE);
                        AppPayEntry.SETFILTER("Payment Mode", '%1', AppPayEntry."Payment Mode"::AJVM);
                        AppPayEntry.SETFILTER(Amount, '<>%1', 0);
                        IF AppPayEntry.FINDLAST THEN BEGIN
                            CustSMSText := '';
                            CustSMSText :=
                                  'Dear Associate,your Id No ' + '' + Vendor."No." + ' ' + 'is credited Rs.' +
                                        ' ' + FORMAT(ABS(AppPayEntry.Amount)) +
                                        ' ' + 'on' + ' ' + FORMAT(AppPayEntry."Posting date") + ' ' + '(Dt) towards AppNo.: ' +
                                        '' + ConfirmedOrder."No.";

                            MESSAGE('%1', CustSMSText);
                            //210224 Added new code
                            CLEAR(CheckMobileNoforSMS);
                            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                            IF ExitMessage THEN
                                PostPayment.SendSMS(CustMobileNo, CustSMSText);
                            //ALLEDK15112022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage := COPYSTR(CustSMSText, 1, 250);
                            SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                            SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'AMJV', ConfirmedOrder."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1), ConfirmedOrder."No.");
                            //ALLEDK15112022 END
                        END;
                    END ELSE
                        MESSAGE('%1', 'Mobile No. not Found');
                CustMobileNo := '';
                IF Cust.GET(ConfirmedOrder."Customer No.") THEN
                    IF Cust."BBG Mobile No." <> '' THEN BEGIN
                        CustMobileNo := Cust."BBG Mobile No.";
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", ConfirmedOrder."No.");
                        AppPayEntry.SETRANGE(Posted, TRUE);
                        AppPayEntry.SETFILTER("Payment Mode", '%1', AppPayEntry."Payment Mode"::AJVM);
                        AppPayEntry.SETFILTER(Amount, '<>%1', 0);
                        IF AppPayEntry.FINDLAST THEN BEGIN
                            CustSMSText := '';
                            CustSMSText :=
                            'Mr/Mrs/Ms: ' + '' + Cust.Name + ' Appl No.: ' + ConfirmedOrder."No." + ', Recvd Rs.' + FORMAT(ABS(AppPayEntry.Amount)) +
                              ', Project:' + GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1) +
                              ', Date' + FORMAT(AppPayEntry."Posting date");

                            MESSAGE('%1', CustSMSText);
                            //210224 Added new code
                            CLEAR(CheckMobileNoforSMS);
                            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                            IF ExitMessage THEN
                                PostPayment.SendSMS(CustMobileNo, CustSMSText);
                            //ALLEDK15112022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage := COPYSTR(CustSMSText, 1, 250);
                            SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                            SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Cust."No.", Cust.Name, 'AMJV', ConfirmedOrder."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1), ConfirmedOrder."No.");
                            //ALLEDK15112022 END

                        END;
                    END ELSE
                        MESSAGE('%1', 'Mobile No. not Found');
            END;
        END;
    end;


    procedure SmspmMJV(ApplicationCode: Code[20])
    var
        Customer: Record Customer;
        CustMobileNo: Text[30];
        AppPayEntry: Record "Application Payment Entry";
        CustSMSText: Text[1000];
        ConfirmedOrder: Record "Confirmed Order";
        ConfirmedOrder1: Record "Confirmed Order";
    begin
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            IF ConfirmedOrder.GET(ApplicationCode) THEN BEGIN
                IF Customer.GET(ConfirmedOrder."Customer No.") THEN
                    IF Customer."BBG Mobile No." <> '' THEN BEGIN
                        CustMobileNo := Customer."BBG Mobile No.";
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", ConfirmedOrder."No.");
                        AppPayEntry.SETRANGE(Posted, TRUE);
                        AppPayEntry.SETFILTER("Payment Mode", '%1', AppPayEntry."Payment Mode"::MJVM);
                        AppPayEntry.SETFILTER(Amount, '<>%1', 0);
                        IF AppPayEntry.FINDLAST THEN BEGIN
                            IF ConfirmedOrder1.GET(AppPayEntry."Order Ref No.") THEN;
                            CustSMSText := '';
                            CustSMSText :=

                                  'Mr/Mrs/Ms:' + Customer.Name + ' ' + 'for App. No. :' + AppPayEntry."Order Ref No." +
                                        ' ' + 'Project: ' + GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1) + ' ' +
                                       'Rs' + FORMAT(AppPayEntry.Amount) +
                  ' is transfered to ApplNo :' +
                                        ApplicationCode + ' Project: ' +
                                        GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1) + ','
                                        + ConfirmedOrder1."Unit Code" + 'Team BBG.';

                            MESSAGE('%1', CustSMSText);
                            //210224 Added new code
                            CLEAR(CheckMobileNoforSMS);
                            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                            IF ExitMessage THEN
                                PostPayment.SendSMS(CustMobileNo, CustSMSText);
                            //ALLEDK15112022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage := COPYSTR(CustSMSText, 1, 250);
                            SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                            SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'MJV', ConfirmedOrder."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1), ConfirmedOrder."No.");
                            //ALLEDK15112022 END
                            CLEAR(Customer);
                            CLEAR(CustMobileNo);
                            IF Customer.GET(ConfirmedOrder1."Customer No.") THEN
                                IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                    CustMobileNo := Customer."BBG Mobile No.";
                                    CustSMSText := '';
                                    CustSMSText :=
                                          'Mr/Mrs/Ms:' + Customer.Name + ' ' + 'for App. No. :' + AppPayEntry."Order Ref No." +
                                                ' ' + 'Project: ' + GetDescription.GetDimensionName(ConfirmedOrder1."Shortcut Dimension 1 Code", 1) + ' ' +
                                               'Rs' + FORMAT(AppPayEntry.Amount) +
                          ' is transfered to ApplNo :' +
                                                ApplicationCode + ' Project: ' +
                                                GetDescription.GetDimensionName(ConfirmedOrder1."Shortcut Dimension 1 Code", 1) + ','
                                                + ConfirmedOrder1."Unit Code" + 'Team BBG.';

                                    MESSAGE('%1', CustSMSText);
                                    //210224 Added new code
                                    CLEAR(CheckMobileNoforSMS);
                                    ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                                    IF ExitMessage THEN
                                        PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                    CLEAR(SMSLogDetails);
                                    SmsMessage := '';
                                    SmsMessage1 := '';
                                    SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                    SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'MJV', ConfirmedOrder1."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(ConfirmedOrder1."Shortcut Dimension 1 Code", 1), ConfirmedOrder1."No."
                          );
                                    //ALLEDK15112022 END

                                END;
                        END;
                    END ELSE
                        MESSAGE('%1', 'Mobile No. not Found');
            END;
        END;
    end;


    procedure SmsonCommissionRelease(VoucherCode: Code[20])
    var
        Vendor: Record Vendor;
        CustMobileNo: Text[30];
        CustSMSText: Text[1000];
        GLEntry: Record "G/L Entry";
        VHeader: Record "Assoc Pmt Voucher Header";
        Amt: Decimal;
    begin
        Bondsetup.GET;
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            Bondsetup.TESTFIELD(Bondsetup."SMS Start Date");
            VHeader.SETRANGE("Document No.", VoucherCode);
            VHeader.SETRANGE("Posting Date", Bondsetup."SMS Start Date", TODAY);
            IF VHeader.FINDSET THEN BEGIN
                REPEAT
                    IF Vendor.GET(VHeader."Paid To") THEN
                        IF Vendor."BBG Mob. No." <> '' THEN BEGIN
                            CustMobileNo := Vendor."BBG Mob. No.";
                            GLEntry.RESET;
                            GLEntry.SETCURRENTKEY("External Document No.", "Document Type");
                            GLEntry.SETRANGE("External Document No.", VHeader."Document No.");
                            GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Payment);
                            IF GLEntry.FINDLAST THEN BEGIN
                                CustSMSText := '';
                                CustSMSText :=
                                      'Dear Associate, your id No ' + Vendor."No." + ' ' + ' is credited Rs.' + '' + FORMAT(ABS(GLEntry.Amount)) +
                                      'on' + ' ' + FORMAT(GLEntry."Posting Date") + '(Dt) ' + 'twds  XXXX (C/I)' + ' ' +
                                        'Happy payment,BBG';
                                //210224 Added new code
                                CLEAR(CheckMobileNoforSMS);
                                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                                IF ExitMessage THEN
                                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Commission Payment', '', '', '');
                                //ALLEDK15112022 END
                            END;
                        END;
                UNTIL VHeader.NEXT = 0;
            END;
        END;
    end;


    procedure SmsonfullAmountReceive()
    var
        Customer: Record Customer;
        CustMobileNo: Text[30];
        AppPayEntry: Record "Application Payment Entry";
        CustSMSText: Text[1000];
        ConfirmedOrder: Record "Confirmed Order";
        TotalAmt: Decimal;
    begin
        Bondsetup.GET;
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            Bondsetup.TESTFIELD(Bondsetup."SMS Start Date");
            ConfirmedOrder.RESET;
            ConfirmedOrder.SETRANGE("Sent SMS on Full Amount", FALSE);
            ConfirmedOrder.SETRANGE("Posting Date", Bondsetup."SMS Start Date", TODAY);
            IF ConfirmedOrder.FINDSET THEN BEGIN
                REPEAT
                    TotalAmt := 0;
                    IF Customer.GET(ConfirmedOrder."Customer No.") THEN
                        IF Customer."BBG Mobile No." <> '' THEN BEGIN
                            CustMobileNo := Customer."BBG Mobile No.";
                            AppPayEntry.RESET;
                            AppPayEntry.SETRANGE("Document No.", ConfirmedOrder."No.");
                            AppPayEntry.SETRANGE(Posted, TRUE);
                            AppPayEntry.SETFILTER(Amount, '<>%1', 0);
                            AppPayEntry.SETRANGE(AppPayEntry."Cheque Status", AppPayEntry."Cheque Status"::Cleared);
                            IF AppPayEntry.FINDSET THEN
                                REPEAT
                                    TotalAmt := TotalAmt + AppPayEntry.Amount;
                                UNTIL AppPayEntry.NEXT = 0;

                            IF TotalAmt >= ConfirmedOrder.Amount THEN BEGIN
                                CustSMSText := '';
                                CustSMSText :=
                                      ' Dear Customer we have received full payment, t/w AppNo: ' + ' ' + ConfirmedOrder."No." +
                                            ' ' + 'Project: ' + GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1) + ' ' +
                                            ' plot No :' + '' + ConfirmedOrder."Unit Code" + ' ' +
                                            'Pls submit Registration Application to arrange regd.Thank you.Team BBG';
                                //210224 Added new code
                                CLEAR(CheckMobileNoforSMS);
                                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                                IF ExitMessage THEN
                                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                ConfirmedOrder."Sent SMS on Full Amount" := TRUE;
                                ConfirmedOrder.MODIFY;
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Customer Receipt full Amount', ConfirmedOrder."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1
                      ),
                                ConfirmedOrder."No.");
                                //ALLEDK15112022 END


                            END;
                        END;
                UNTIL ConfirmedOrder.NEXT = 0;
            END;
        END;
    end;


    procedure SmsonPlotCancellation(ApplicationNo: Code[20])
    var
        Customer: Record Customer;
        CustMobileNo: Text[30];
        AppPayEntry: Record "Application Payment Entry";
        CustSMSText: Text[1000];
        ConfirmedOrder: Record "Confirmed Order";
        TotalAmt: Decimal;
    begin
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            IF ConfirmedOrder.GET(ApplicationNo) THEN BEGIN
                IF (ConfirmedOrder.Status = ConfirmedOrder.Status::Cancelled) AND
                                            (NOT ConfirmedOrder."Sent SMS on Plot Cancellation") THEN BEGIN
                    IF Customer.GET(ConfirmedOrder."Customer No.") THEN
                        IF Customer."BBG Mobile No." <> '' THEN BEGIN
                            CustMobileNo := Customer."BBG Mobile No.";
                            AppPayEntry.RESET;
                            AppPayEntry.SETRANGE("Document No.", ConfirmedOrder."No.");
                            AppPayEntry.SETRANGE(Posted, TRUE);
                            AppPayEntry.SETFILTER("Payment Mode", '%1|%2', AppPayEntry."Payment Mode"::"Refund Cash",
                                                          AppPayEntry."Payment Mode"::"Refund Bank");
                            AppPayEntry.SETFILTER(Amount, '<>%1', 0);
                            IF AppPayEntry.FINDLAST THEN BEGIN
                                CustSMSText := '';
                                CustSMSText :=
                                'Mr/Mrs/Ms:' + Customer.Name + ' ' + 'twdsApplNo:' + ConfirmedOrder."No." +
                                        ' ' + 'Project: ' + GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1) + ' ' +
                                   ' ' + FORMAT(ABS(AppPayEntry.Amount)) + ' ' +
                                        'refunded and plot got cancelled on your request.';
                                MESSAGE('%1', CustSMSText);
                                //210224 Added new code
                                CLEAR(CheckMobileNoforSMS);
                                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                                IF ExitMessage THEN
                                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                ConfirmedOrder."Sent SMS on Plot Cancellation" := TRUE;
                                ConfirmedOrder.MODIFY;
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Plot Cancellation', ConfirmedOrder."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1),
                                ConfirmedOrder."No.");
                                //ALLEDK15112022 END
                            END;
                        END ELSE
                            MESSAGE('%1', 'Mobile No. not Found');
                END;
            END;
        END;
    end;


    procedure SmsonCustomerCheqbounce()
    var
        Customer: Record Customer;
        CustMobileNo: Text[30];
        BALEntry: Record "Bank Account Ledger Entry";
        CustSMSText: Text[1000];
        ConfirmedOrder: Record "Confirmed Order";
        TotalAmt: Decimal;
    begin
        Bondsetup.GET;
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            Bondsetup.TESTFIELD(Bondsetup."SMS Start Date");
            BALEntry.RESET;
            BALEntry.SETCURRENTKEY("Document Type", "Application No.", BALEntry."Send SMS on Cheq bounce");
            BALEntry.SETRANGE("Document Type", BALEntry."Document Type"::" ");
            BALEntry.SETFILTER("Application No.", '<>%1', '');
            BALEntry.SETRANGE("Send SMS on Cheq bounce", FALSE);
            BALEntry.SETFILTER(Amount, '<>%1', 0);
            BALEntry.SETRANGE("Posting Date", Bondsetup."SMS Start Date", TODAY);
            IF BALEntry.FINDSET THEN BEGIN
                REPEAT
                    IF ConfirmedOrder.GET(BALEntry."Application No.") THEN;
                    RespCenter.RESET;
                    IF RespCenter.GET(ConfirmedOrder."Shortcut Dimension 1 Code") THEN;
                    TotalAmt := 0;
                    IF Customer.GET(ConfirmedOrder."Customer No.") THEN
                        IF Customer."BBG Mobile No." <> '' THEN BEGIN
                            CustMobileNo := Customer."BBG Mobile No.";
                            CustSMSText := '';
                            CustSMSText :=

                  'Dear Customer, Your CHEQUE Got Bounced & Request to process the Payment immediately.' +   //210824 Added new SMS
                   'Name: Mr/Ms ' + Customer.Name + ', Appl No: ' + BALEntry."Application No." + ', Project: ' + RespCenter.Name
                   + ' Amount: Rs.' + FORMAT(ABS(BALEntry.Amount)) + ', Date: ' + FORMAT(BALEntry."Posting Date") + ',' +
                   ' *Thank you & Assuring you of Best Property Services with Building Blocks Group.';

                            //210824 comment Old SMS

                            //                    ' Dear Customer Your Cheque ' + ' '+BALEntry."Cheque No." +' '+'Rs'+
                            //                   ' '+FORMAT(ABS(BALEntry.Amount))+' '+'has been bounced against the Application:'+' '+BALEntry."Application No."
                            // +
                            //                    '.'+'Resubmit the New Cheque.Team BBG.';
                            //210224 Added new code
                            CLEAR(CheckMobileNoforSMS);
                            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                            IF ExitMessage THEN
                                PostPayment.SendSMS(CustMobileNo, CustSMSText);
                            BALEntry."Send SMS on Cheq bounce" := TRUE;
                            BALEntry.MODIFY;
                            //ALLEDK15112022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage := COPYSTR(CustSMSText, 1, 250);
                            SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                            SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Customer Cheque Bounce', ConfirmedOrder."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1),
                            ConfirmedOrder."No.");
                            //ALLEDK15112022 END
                        END;
                UNTIL BALEntry.NEXT = 0;
            END;
        END;
    end;


    procedure SmsonAknowledgeofRegApp(ApplicationCode: Code[20])
    var
        Customer: Record Customer;
        CustMobileNo: Text[30];
        AppPayEntry: Record "Application Payment Entry";
        CustSMSText: Text[1024];
        ConfirmedOrder: Record "Confirmed Order";
        TotalAmt: Decimal;
    begin
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            IF ConfirmedOrder.GET(ApplicationCode) THEN BEGIN
                IF NOT ConfirmedOrder."Sent SMS on Acknoledgement" THEN BEGIN
                    IF Customer.GET(ConfirmedOrder."Customer No.") THEN
                        IF Customer."BBG Mobile No." <> '' THEN BEGIN
                            CustMobileNo := Customer."BBG Mobile No.";
                            CustSMSText := '';
                            RespCenter.RESET;
                            IF RespCenter.GET(ConfirmedOrder."Shortcut Dimension 1 Code") THEN;
                            CustSMSText :=
                       'Dear Customer, We acknowledge the Receipt of Thumb impression form for Plot Registration. Name: Mr/Ms ' + Customer.Name +
                        ', Appl No: ' + ConfirmedOrder."No." + ' , Plot No.:' + FORMAT(ConfirmedOrder."Unit Code") + ' , Project:' + RespCenter.Name +
                        ', Amount: Rs.' + FORMAT(ConfirmedOrder.Amount) + ',*Building Blocks Group will Update your Plot Registration' +
                           'number within 15 working Days. Thank you.';
                            MESSAGE('%1', CustSMSText);
                            //210224 Added new code
                            CLEAR(CheckMobileNoforSMS);
                            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                            IF ExitMessage THEN
                                PostPayment.SendSMS(CustMobileNo, CustSMSText);
                            ConfirmedOrder."Sent SMS on Acknoledgement" := TRUE;
                            ConfirmedOrder.MODIFY;
                            //ALLEDK15112022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage := COPYSTR(CustSMSText, 1, 250);
                            SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                            SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Acknowledge of Plot Registraion',
                            ConfirmedOrder."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1), ConfirmedOrder."No.");

                            //ALLEDK15112022 END
                        END ELSE
                            MESSAGE('%1', 'Mobile No. not Found');
                END;
            END;
        END;
    end;


    procedure SmsforPaymentReminder()
    var
        Customer: Record Customer;
        CustMobileNo: Text[30];
        AppPayEntry: Record "Application Payment Entry";
        CustSMSText: Text[1000];
        ConfirmedOrder: Record "Confirmed Order";
        TotalAmt: Decimal;
        PaymentPlanDetails: Record "Payment Plan Details";
        AppNo: Code[20];
        PPlanDetails: Record "Payment Plan Details";
        DueDate: Date;
        PlanAmt: Decimal;
    begin
        Bondsetup.GET;
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            Bondsetup.TESTFIELD(Bondsetup."SMS Start Date");
            AppNo := '';
            ConfirmedOrder.RESET;
            ConfirmedOrder.SETRANGE("Posting Date", Bondsetup."SMS Start Date", TODAY);
            ConfirmedOrder.SETFILTER(Status, '<>%1', ConfirmedOrder.Status::Cancelled);
            IF ConfirmedOrder.FINDSET THEN
                REPEAT
                    PaymentPlanDetails.RESET;
                    PaymentPlanDetails.SETCURRENTKEY(PaymentPlanDetails."Document No.");
                    PaymentPlanDetails.SETRANGE("Document No.", ConfirmedOrder."No.");
                    PaymentPlanDetails.SETRANGE("Send SMS Cust for Due Amount", FALSE);
                    PaymentPlanDetails.SETRANGE("Project Milestone Due Date", 0D, CALCDATE('1D', TODAY));
                    IF PaymentPlanDetails.FINDSET THEN
                        REPEAT
                            IF AppNo <> PaymentPlanDetails."Document No." THEN BEGIN
                                AppNo := PaymentPlanDetails."Document No.";
                                IF ConfirmedOrder.GET(PaymentPlanDetails."Document No.") THEN;
                                IF Customer.GET(ConfirmedOrder."Customer No.") THEN
                                    IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                        CustMobileNo := Customer."BBG Mobile No.";
                                        PlanAmt := 0;
                                        TotalAmt := 0;
                                        PPlanDetails.RESET;
                                        PPlanDetails.SETRANGE("Document No.", PaymentPlanDetails."Document No.");
                                        PPlanDetails.SETRANGE("Send SMS Cust for Due Amount", FALSE);
                                        IF PPlanDetails.FINDSET THEN
                                            REPEAT
                                                PlanAmt := PlanAmt + PPlanDetails."Total Charge Amount";
                                                IF PPlanDetails."Project Milestone Due Date" = TODAY THEN BEGIN
                                                    AppPayEntry.RESET;
                                                    AppPayEntry.SETRANGE("Document No.", PaymentPlanDetails."Document No.");
                                                    AppPayEntry.SETFILTER("Cheque Status", '<>%1', AppPayEntry."Cheque Status"::Bounced);
                                                    IF AppPayEntry.FINDSET THEN
                                                        REPEAT
                                                            TotalAmt := TotalAmt + AppPayEntry.Amount;
                                                        UNTIL AppPayEntry.NEXT = 0;

                                                    IF PlanAmt > TotalAmt THEN BEGIN
                                                        CustSMSText := '';
                                                        CustSMSText :=
                                                        'Mr/Mrs/Ms:' + Customer.Name + ' ' + 'Your payment of Rs.' + FORMAT(PlanAmt - TotalAmt) + ' '
                                                         + 'is due for the AppNo:'
                                                            + PPlanDetails."Document No." +
                                                                ' ' + 'Project: ' + GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1
                          )
                                                         + ' ' + 'Kindly make  payment till ' + ' ' + FORMAT(PPlanDetails."Project Milestone Due Date");
                                                        //210224 Added new code
                                                        CLEAR(CheckMobileNoforSMS);
                                                        ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                                                        IF ExitMessage THEN
                                                            PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                                        PPlanDetails."Send SMS Cust for Due Amount" := TRUE;
                                                        PPlanDetails.MODIFY;
                                                        //ALLEDK15112022 Start
                                                        CLEAR(SMSLogDetails);
                                                        SmsMessage := '';
                                                        SmsMessage1 := '';
                                                        SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                                        SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                                        SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Payment Reminder', ConfirmedOrder."Shortcut Dimension 1 Code",
                                                        GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1), ConfirmedOrder."No.");
                                                        //ALLEDK15112022 END
                                                    END;
                                                END;
                                                IF PPlanDetails."Project Milestone Due Date" = CALCDATE('1D', TODAY) THEN BEGIN
                                                    TotalAmt := 0;
                                                    AppPayEntry.RESET;
                                                    AppPayEntry.SETRANGE("Document No.", PaymentPlanDetails."Document No.");
                                                    AppPayEntry.SETFILTER("Cheque Status", '<>%1', AppPayEntry."Cheque Status"::Bounced);
                                                    IF AppPayEntry.FINDSET THEN
                                                        REPEAT
                                                            TotalAmt := TotalAmt + AppPayEntry.Amount;
                                                        UNTIL AppPayEntry.NEXT = 0;

                                                    IF PlanAmt > TotalAmt THEN BEGIN
                                                        CustSMSText := '';
                                                        CustSMSText :=
                                                        'Mr/Mrs/Ms:' + Customer.Name + ' ' + 'Your payment of Rs.' + FORMAT(PlanAmt - TotalAmt) +
                                                        ' ' + 'is due for the AppNo:' + PPlanDetails."Document No." +
                                                             ' ' + 'Project: ' + GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1)
                                                           + ' ' + 'Kindly make payment till' + ' ' + FORMAT(PPlanDetails."Project Milestone Due Date");

                                                        //MESSAGE('%1',CustSMSText);
                                                        //210224 Added new code
                                                        CLEAR(CheckMobileNoforSMS);
                                                        ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                                                        IF ExitMessage THEN
                                                            PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                                        PPlanDetails."Send SMS Cust for Due Amount" := TRUE;
                                                        PPlanDetails.MODIFY;
                                                        //ALLEDK15112022 Start
                                                        CLEAR(SMSLogDetails);
                                                        SmsMessage := '';
                                                        SmsMessage1 := '';
                                                        SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                                        SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                                        SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Payment Reminder', ConfirmedOrder."Shortcut Dimension 1 Code",
                                                        GetDescription.GetDimensionName(ConfirmedOrder."Shortcut Dimension 1 Code", 1), ConfirmedOrder."No.");
                                                        //ALLEDK15112022 END
                                                    END;
                                                END;
                                            UNTIL PPlanDetails.NEXT = 0;
                                    END;
                            END;
                        UNTIL PaymentPlanDetails.NEXT = 0;

                UNTIL ConfirmedOrder.NEXT = 0;
        END;
    end;


    procedure CheckGoldcoinEligibility(ApplicationCode: Code[20]; FromFullPayment: Boolean): Integer
    var
        ConfOrder: Record "Confirmed Order";
        APPPaymentEntry: Record "Application Payment Entry";
        EleDate: Date;
        NoCalculation: Boolean;
        UMAster: Record "Unit Master";
        UnitSEtup: Record "Unit Setup";
        GoldCoinSetup: Record "Gold Coin Line";
        Amt: Decimal;
        GoldCoin: Integer;
        NoofGoldCoinAllot: Integer;
        GoldCoinEntry: Record "Gold Coin Eligibility";
    begin
        IF ConfOrder.GET(ApplicationCode) THEN BEGIN
            CLEAR(APPPaymentEntry);
            APPPaymentEntry.RESET;
            APPPaymentEntry.SETRANGE("Document No.", ConfOrder."No.");
            APPPaymentEntry.SETRANGE("Cheque Status", APPPaymentEntry."Cheque Status"::Cleared);
            APPPaymentEntry.SETRANGE("Payment Mode", APPPaymentEntry."Payment Mode"::MJVM);
            IF APPPaymentEntry.FINDFIRST THEN
                NoCalculation := TRUE;

            IF NOT NoCalculation THEN BEGIN
                IF ConfOrder."Unit Code" <> '' THEN
                    IF UMAster.GET(ConfOrder."Unit Code") THEN;
                UnitSEtup.GET;
                GoldCoinSetup.RESET;
                IF ConfOrder."Unit Code" <> '' THEN
                    GoldCoinSetup.SETRANGE("Plot Size", UMAster."Saleable Area")
                ELSE
                    GoldCoinSetup.SETRANGE("Plot Size", ConfOrder."Saleable Area");

                GoldCoinSetup.SETRANGE("Project Code", ConfOrder."Shortcut Dimension 1 Code");
                GoldCoinSetup.SETRANGE("Effective Date", 0D, ConfOrder."Posting Date");
                IF GoldCoinSetup.FINDLAST THEN BEGIN
                    Amt := 0;
                    GoldCoin := 0;
                    EleDate := 0D;
                    EleDate := CALCDATE(GoldCoinSetup."Due Days", ConfOrder."Posting Date");
                    CLEAR(APPPaymentEntry);
                    APPPaymentEntry.RESET;
                    APPPaymentEntry.SETRANGE("Document No.", ConfOrder."No.");
                    APPPaymentEntry.SETRANGE("Cheque Status", APPPaymentEntry."Cheque Status"::Cleared);
                    APPPaymentEntry.SETRANGE("Posting date", 0D, EleDate);
                    APPPaymentEntry.SETFILTER("Payment Mode", '<>%1', APPPaymentEntry."Payment Mode"::MJVM);
                    IF APPPaymentEntry.FINDSET THEN BEGIN
                        REPEAT
                            IF (APPPaymentEntry."Payment Mode" = APPPaymentEntry."Payment Mode"::Bank) THEN BEGIN
                                IF (APPPaymentEntry."Chq. Cl / Bounce Dt." <= CALCDATE(UnitSEtup."No. of Cheque Buffer Days",
                                APPPaymentEntry."Posting date"))
                                  THEN
                                    Amt := Amt + APPPaymentEntry.Amount;
                            END ELSE BEGIN
                                Amt := Amt + APPPaymentEntry.Amount;
                            END;
                        UNTIL APPPaymentEntry.NEXT = 0;
                        NoofGoldCoinAllot := 0;
                        GoldCoinEntry.RESET;
                        GoldCoinEntry.SETCURRENTKEY("Project Code", "Application No.");
                        //GoldCoinEntry.SETRANGE("Project Code","Confirmed Order"."Shortcut Dimension 1 Code");
                        GoldCoinEntry.SETRANGE("Application No.", ConfOrder."No.");
                        IF GoldCoinEntry.FINDSET THEN
                            REPEAT
                                NoofGoldCoinAllot := NoofGoldCoinAllot + GoldCoinEntry."Eligibility Gold / Silver";
                            UNTIL GoldCoinEntry.NEXT = 0;
                        IF NOT FromFullPayment THEN BEGIN
                            IF (Amt >= ConfOrder."Min. Allotment Amount") AND (Amt < ConfOrder.Amount) THEN
                                GoldCoin := GoldCoinSetup."Min. No. of Gold Coins";
                        END;
                        IF (Amt >= ConfOrder.Amount) THEN
                            GoldCoin := GoldCoinSetup."No. of Gold Coins on Full Pmt." + GoldCoinSetup."Min. No. of Gold Coins";
                    END;
                    IF GoldCoin - NoofGoldCoinAllot > 0 THEN
                        EXIT(GoldCoin - NoofGoldCoinAllot);
                END;
            END;
        END;
    end;


    procedure TotalCheckGoldcoinEligibility(ApplicationCode: Code[20]): Integer
    var
        ConfOrder: Record "Confirmed Order";
        EleDate: Date;
        NoCalculation: Boolean;
        UMAster: Record "Unit Master";
        UnitSEtup: Record "Unit Setup";
        GoldCoinSetup: Record "Gold Coin Line";
        TotalGoldCoin: Integer;
        GoldCoinEntry: Record "Gold Coin Eligibility";
    begin
        IF ConfOrder.GET(ApplicationCode) THEN BEGIN
            IF ConfOrder."Unit Code" <> '' THEN
                IF UMAster.GET(ConfOrder."Unit Code") THEN;
            UnitSEtup.GET;
            GoldCoinSetup.RESET;
            IF ConfOrder."Unit Code" <> '' THEN
                GoldCoinSetup.SETRANGE("Plot Size", UMAster."Saleable Area")
            ELSE
                GoldCoinSetup.SETRANGE("Plot Size", ConfOrder."Saleable Area");
            GoldCoinSetup.SETRANGE("Project Code", ConfOrder."Shortcut Dimension 1 Code");
            GoldCoinSetup.SETRANGE("Effective Date", 0D, ConfOrder."Posting Date");
            IF GoldCoinSetup.FINDLAST THEN BEGIN
                TotalGoldCoin := 0;
                TotalGoldCoin := GoldCoinSetup."No. of Gold Coins on Full Pmt." + GoldCoinSetup."Min. No. of Gold Coins";
                EXIT(TotalGoldCoin);
            END;
        END;
    end;


    procedure SmsonCommissionReleaseMSC(VoucherCode: Code[20])
    var
        Vendor: Record Vendor;
        CustMobileNo: Text[30];
        CustSMSText: Text[1000];
        GLEntry: Record "G/L Entry";
        VHeader: Record "Associate Payment Hdr";
        Amt: Decimal;
        DocNo: Code[20];
    begin
        Bondsetup.GET;
        DocNo := '';
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            Bondsetup.TESTFIELD(Bondsetup."SMS Start Date");
            VHeader.SETCURRENTKEY("Document No.");
            VHeader.SETRANGE("Document No.", VoucherCode);
            VHeader.SETRANGE(Post, TRUE);
            VHeader.SETFILTER(Type, '%1|%2', VHeader.Type::Commission, VHeader.Type::TA);
            IF VHeader.FINDFIRST THEN BEGIN

                IF Vendor.GET(VHeader."Associate Code") THEN
                    IF Vendor."BBG Mob. No." <> '' THEN BEGIN
                        CustMobileNo := Vendor."BBG Mob. No.";
                        GLEntry.RESET;
                        GLEntry.SETCURRENTKEY("Document No.", "Entry No.");
                        GLEntry.SETRANGE("Document No.", VHeader."Posted Document No.");
                        GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Payment);
                        IF GLEntry.FINDLAST THEN BEGIN
                            CustSMSText := '';
                            CustSMSText :=
                                  'Dear Associate, your id No ' + Vendor."No." + ' ' + ' is credited Rs.' + '' + FORMAT(ABS(GLEntry.Amount)) +
                                    'on' + ' ' + FORMAT(GLEntry."Posting Date") + '(Dt) ' + 'twds Commission ' +
                                      'Happy payment,BBP';
                            //210224 Added new code
                            CLEAR(CheckMobileNoforSMS);
                            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                            IF ExitMessage THEN
                                PostPayment.SendSMS(CustMobileNo, CustSMSText);
                            //ALLEDK15112022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage := COPYSTR(CustSMSText, 1, 250);
                            SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                            SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Commission Payment', '', '', '');
                            //ALLEDK15112022 END
                        END;
                    END;
            END;
        END;
    end;


    procedure SMSUnitVacate()
    var
        PaymentTermsLineSales: Record "Payment Terms Line Sale";
        PaymentTermsLineSales_1: Record "Payment Terms Line Sale";
        Conforders: Record "New Confirmed Order";
        DocNo: Code[20];
        CustMobileNo: Text[30];
        CustSMSText: Text[1000];
        Cust: Record Customer;
    begin
        /*
        DocNo := '';
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
        
        Company.RESET;
        IF Company.FINDSET THEN
          REPEAT
            PaymentTermsLineSales.RESET;
            PaymentTermsLineSales.CHANGECOMPANY(Company.Name);
            PaymentTermsLineSales.SETCURRENTKEY("Due Date of SMS for Unit Vacat","Unit Vacate SMS Send");
            PaymentTermsLineSales.SETRANGE("Due Date of SMS for Unit Vacat",TODAY);
            PaymentTermsLineSales.SETRANGE("Unit Vacate SMS Send",FALSE);
            IF PaymentTermsLineSales.FINDSET THEN
              REPEAT
                IF DocNo <> PaymentTermsLineSales."Document No." THEN BEGIN
                  Conforders.RESET;
                  IF Conforders.GET(PaymentTermsLineSales."Document No.") THEN BEGIN
                    Conforders.CALCFIELDS("Total Received Amount");
                    Cust.RESET;
                    Cust.CHANGECOMPANY(Company.Name);
                    Cust.GET(Conforders."Customer No.");
                    CustMobileNo := '';
                    CustMobileNo := '7799882763'; // Cust."Mobile No.";
                    IF Conforders."Total Received Amount" >= Conforders."Min. Allotment Amount" THEN
                       CustSMSText :='Dear ' + Cust.Name+ ', your payment against Application-'+ PaymentTermsLineSales."Document No."+
                                ' is due. Please make the payment against your plot else your plot would be renewed. Please ignore '+
                                 'if already paid. Have A Nice Day!!'
                    ELSE
                      CustSMSText :='Dear ' + Cust.Name+ ', your payment against Application-'+ PaymentTermsLineSales."Document No."+
                                ' is due. Please make the payment against your plot else your plot will be vacated. Please ignore '+
                                 'if already paid. Have A Nice Day!!';
        
                    PostPayment.SendSMS(CustMobileNo,CustSMSText);
        
                    PaymentTermsLineSales_1.RESET;
                    PaymentTermsLineSales_1.CHANGECOMPANY(Company.Name);
                    PaymentTermsLineSales_1.SETCURRENTKEY("Due Date of SMS for Unit Vacat","Unit Vacate SMS Send");
                    PaymentTermsLineSales_1.SETRANGE("Due Date of SMS for Unit Vacat",TODAY);
                    PaymentTermsLineSales_1.SETRANGE("Unit Vacate SMS Send",FALSE);
                    IF PaymentTermsLineSales_1.FINDSET THEN
                      REPEAT
                        PaymentTermsLineSales_1."Unit Vacate SMS Send" := TRUE;
                        PaymentTermsLineSales_1.MODIFY;
                      UNTIL PaymentTermsLineSales_1.NEXT =0;
                   END;
                 END;
                 COMMIT;
              UNTIL PaymentTermsLineSales.NEXT =0;
           UNTIL Company.NEXT =0;
         END;
                                                 */

    end;

    local procedure "------------------------------"()
    begin
    end;


    procedure CustomerChequeBounced(NewApplicationPaymtEntry_2: Record "NewApplication Payment Entry")
    begin

        CompanywiseGLAccount.RESET;
        CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
        IF CompanywiseGLAccount.FINDFIRST THEN;

        NewConfirmedOrder.RESET;
        IF NewConfirmedOrder.GET(NewApplicationPaymtEntry_2."Document No.") THEN;
        Customer.RESET;
        Customer.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
        IF Customer.GET(NewConfirmedOrder."Customer No.") THEN;
        ResponsibilityCenter.RESET;
        IF ResponsibilityCenter.GET(NewConfirmedOrder."Shortcut Dimension 1 Code") THEN;
        AssociateHierarcywithApp.RESET;
        AssociateHierarcywithApp.SETRANGE("Application Code", NewApplicationPaymtEntry_2."Document No.");
        AssociateHierarcywithApp.SETRANGE("Parent Code", 'IBA9999999');
        IF AssociateHierarcywithApp.FINDFIRST THEN BEGIN
            SMSVendor.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
            SMSVendor.GET(AssociateHierarcywithApp."Associate Code");
            IF SMSVendor."BBG Mob. No." <> '' THEN BEGIN
                CustMobileNo := '';
                CustSMSText := '';
                CustMobileNo := SMSVendor."BBG Mob. No.";
                CustSMSText :=
                    'Dear Customer, Your CHEQUE Got Bounced & Request to process the Payment immediately. Name: ' +
                    Customer.Name + ', Appl No: ' + NewApplicationPaymtEntry_2."Document No." + ',Project: ' + ResponsibilityCenter.Name + ', Amount: Rs.' +
                    FORMAT(NewApplicationPaymtEntry_2.Amount) + ', Date:' + FORMAT(NewApplicationPaymtEntry_2."Cheque Date") + ',' +
                    'Thank you & Assuring you of Best Property Services with Building Blocks Group';

                CLEAR(PostPayment);
                PostPayment.SendSMS(CustMobileNo, CustSMSText);
                SLEEP(50);
            END;
        END;

        SMSVendor.RESET;
        SMSVendor.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
        IF SMSVendor.GET(NewConfirmedOrder."Introducer Code") THEN BEGIN
            IF SMSVendor."BBG Mob. No." <> '' THEN BEGIN
                CustMobileNo := '';
                CustSMSText := '';
                CustMobileNo := SMSVendor."BBG Mob. No.";
                CustSMSText :=
                                       'Dear Customer, Your CHEQUE Got Bounced & Request to process the Payment immediately. Name: ' +
                    Customer.Name + ', Appl No: ' + NewApplicationPaymtEntry_2."Document No." + ',Project: ' + ResponsibilityCenter.Name + ', Amount: Rs.' +
                    FORMAT(NewApplicationPaymtEntry_2.Amount) + ', Date:' + FORMAT(NewApplicationPaymtEntry_2."Cheque Date") + ',' +
                    'Thank you & Assuring you of Best Property Services with Building Blocks Group';


                CLEAR(PostPayment);
                PostPayment.SendSMS(CustMobileNo, CustSMSText);
                SLEEP(50);
            END;
        END;

        IF Customer."BBG Mobile No." <> '' THEN BEGIN
            CustMobileNo := '';
            CustMobileNo := Customer."BBG Mobile No.";
            CustSMSText := '';
            CustSMSText :=
                 'Dear Customer, Your CHEQUE Got Bounced & Request to process the Payment immediately. Name: ' +                                                            //250625 code modify
                    Customer.Name + ', Appl No: ' + NewApplicationPaymtEntry_2."Document No." + ',Project: ' + ResponsibilityCenter.Name + ', Amount: Rs.' +
                    FORMAT(NewApplicationPaymtEntry_2.Amount) + ', Date:' + FORMAT(NewApplicationPaymtEntry_2."Cheque Date") + ',' +
                    'Thank you & Assuring you of Best Property Services with Building Blocks Group';

            MESSAGE('%1', CustSMSText);
            CLEAR(PostPayment);
            PostPayment.SendSMS(CustMobileNo, CustSMSText);
            //  MESSAGE('%1','SMS Sent');
        END;
    end;
}

