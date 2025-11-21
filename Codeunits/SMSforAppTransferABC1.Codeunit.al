codeunit 50026 "SMS for App Transfer A-B-C-1"
{
    // Cust."Mobile No."

    TableNo = "New Confirmed Order";

    trigger OnRun()
    begin
        IF "New Confirmed Order".GET(Rec."No.") THEN BEGIN
            "New Confirmed Order".CALCFIELDS("Total Received Amount");
            IF ("New Confirmed Order".Amount - "New Confirmed Order"."Total Received Amount") > 0 THEN BEGIN
                NewApplicationPaymentEntry.RESET;
                NewApplicationPaymentEntry.SETRANGE("Document No.", "New Confirmed Order"."No.");
                NewApplicationPaymentEntry.SETRANGE("Cheque Status", NewApplicationPaymentEntry."Cheque Status"::" ");
                IF NOT NewApplicationPaymentEntry.FINDFIRST THEN BEGIN
                    IF "New Confirmed Order"."Unit Payment Plan" <> '1008' THEN BEGIN
                        OptionA := 0D;
                        OptionB := 0D;
                        OptionC := 0D;
                        FromOption := '';
                        ToOption := '';
                        NewOption := '';
                        UnitSetup.GET;
                        UnitSetup.TESTFIELD("Transfer Days for Option A");
                        UnitSetup.TESTFIELD("Transfer Days for Option B");
                        UnitSetup.TESTFIELD("Transfer Days for Option C");
                        ReceptAmount := 0;
                        OptionA := CALCDATE(UnitSetup."Transfer Days for Option A", "New Confirmed Order"."Posting Date");
                        OptionB := CALCDATE(UnitSetup."Transfer Days for Option B", "New Confirmed Order"."Posting Date");
                        OptionC := CALCDATE(UnitSetup."Transfer Days for Option C", "New Confirmed Order"."Posting Date");
                        OptionA := CALCDATE('-2D', OptionA);
                        OptionB := CALCDATE('-2D', OptionB);
                        IF "New Confirmed Order"."Unit Payment Plan" = '1006' THEN BEGIN
                            APPPaymentEntry.RESET;
                            APPPaymentEntry.SETRANGE("Document No.", "New Confirmed Order"."No.");
                            APPPaymentEntry.SETRANGE("Posting date", "New Confirmed Order"."Posting Date", OptionA);
                            APPPaymentEntry.SETFILTER("Cheque Status", '<>%1', APPPaymentEntry."Cheque Status"::Bounced);
                            IF APPPaymentEntry.FINDSET THEN
                                REPEAT
                                    ReceptAmount := ReceptAmount + APPPaymentEntry.Amount;
                                UNTIL APPPaymentEntry.NEXT = 0;
                            IF "New Confirmed Order".Amount > ReceptAmount THEN BEGIN
                                IF OptionA <= TODAY THEN BEGIN
                                    FromOption := 'Option A';
                                    ToOption := 'Option B';
                                    NewOption := '1007';
                                END;
                            END ELSE
                                FromOption := 'Option A';
                            IF OptionA <= TODAY THEN BEGIN
                                ReceptAmount := 0;
                                APPPaymentEntry.RESET;
                                APPPaymentEntry.SETRANGE("Document No.", "New Confirmed Order"."No.");
                                APPPaymentEntry.SETRANGE("Posting date", "New Confirmed Order"."Posting Date", OptionB);
                                APPPaymentEntry.SETFILTER("Cheque Status", '<>%1', APPPaymentEntry."Cheque Status"::Bounced);
                                IF APPPaymentEntry.FINDSET THEN
                                    REPEAT
                                        ReceptAmount := ReceptAmount + APPPaymentEntry.Amount;
                                    UNTIL APPPaymentEntry.NEXT = 0;
                                IF "New Confirmed Order".Amount > ReceptAmount THEN BEGIN
                                    IF OptionB <= TODAY THEN BEGIN
                                        FromOption := 'Option A';
                                        ToOption := 'Option C';
                                        NewOption := '1008';
                                    END ELSE
                                        FromOption := 'Option A';
                                END;
                            END ELSE
                                FromOption := 'Option A';
                        END;

                        IF "New Confirmed Order"."Unit Payment Plan" = '1007' THEN BEGIN
                            APPPaymentEntry.RESET;
                            APPPaymentEntry.SETRANGE("Document No.", "New Confirmed Order"."No.");
                            APPPaymentEntry.SETRANGE("Posting date", "New Confirmed Order"."Posting Date", OptionB);
                            APPPaymentEntry.SETFILTER("Cheque Status", '<>%1', APPPaymentEntry."Cheque Status"::Bounced);
                            IF APPPaymentEntry.FINDSET THEN
                                REPEAT
                                    ReceptAmount := ReceptAmount + APPPaymentEntry.Amount;
                                UNTIL APPPaymentEntry.NEXT = 0;
                            IF "New Confirmed Order".Amount > ReceptAmount THEN BEGIN
                                IF OptionB <= TODAY THEN BEGIN
                                    FromOption := 'Option B';
                                    ToOption := 'Option C';
                                    NewOption := '1008';
                                END ELSE
                                    FromOption := 'Option B';
                            END ELSE
                                FromOption := 'Option B';
                        END;
                    END;
                END;
                //--------------Send SMS------------
                IF FromOption = 'Option A' THEN BEGIN
                    IF NOT "New Confirmed Order"."Sent SMS A To B" THEN BEGIN
                        Cust.RESET;
                        IF Cust.GET("New Confirmed Order"."Customer No.") THEN
                            IF Cust."BBG Mobile No." <> '' THEN BEGIN
                                CLEAR(PostPayment);
                                TextMessage := STRSUBSTNO(PreAtoB, Cust.Name, "New Confirmed Order"."Unit Code", "New Confirmed Order"."No.");
                                //210224 Added new code
                                CLEAR(CheckMobileNoforSMS);
                                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Cust."BBG Mobile No.", FALSE);
                                IF ExitMessage THEN
                                    PostPayment.SendSMS(Cust."BBG Mobile No.", TextMessage);
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(TextMessage, 1, 250);
                                SmsMessage1 := COPYSTR(TextMessage, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Cust."No.", Cust.Name, 'Application Transfer', "New Confirmed Order"."Shortcut Dimension 1 Code",
                                GetDescription.GetDimensionName("New Confirmed Order"."Shortcut Dimension 1 Code", 1), "New Confirmed Order"."No.");
                                //ALLEDK15112022 END

                                "New Confirmed Order"."Sent SMS A To B" := TRUE;
                                "New Confirmed Order".MODIFY;
                                COMMIT;
                            END;
                    END;
                END;
                IF FromOption = 'Option B' THEN BEGIN
                    IF NOT "New Confirmed Order"."Sent SMS B to C" THEN BEGIN
                        Cust.RESET;
                        IF Cust.GET("New Confirmed Order"."Customer No.") THEN
                            IF Cust."BBG Mobile No." <> '' THEN BEGIN
                                CLEAR(PostPayment);
                                TextMessage := STRSUBSTNO(PreBtoC, Cust.Name, "New Confirmed Order"."Unit Code", "New Confirmed Order"."No.");
                                //210224 Added new code
                                CLEAR(CheckMobileNoforSMS);
                                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Cust."BBG Mobile No.", FALSE);
                                IF ExitMessage THEN BEGIN
                                    PostPayment.SendSMS(Cust."BBG Mobile No.", TextMessage);
                                    "New Confirmed Order"."Sent SMS B to C" := TRUE;
                                    "New Confirmed Order".MODIFY;
                                END;
                                COMMIT;
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(TextMessage, 1, 250);
                                SmsMessage1 := COPYSTR(TextMessage, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Cust."No.", Cust.Name, 'Application Transfer', "New Confirmed Order"."Shortcut Dimension 1 Code",
                                GetDescription.GetDimensionName("New Confirmed Order"."Shortcut Dimension 1 Code", 1), "New Confirmed Order"."No.");
                                //ALLEDK15112022 END
                            END;
                    END;
                END;

                /*  //Code comment for Auto plot vacate SMS 090522
                  IF ("New Confirmed Order"."Unit Payment Plan" = '1008') AND (NOT "New Confirmed Order"."Sent SMS Auto Plot Vacate") THEN BEGIN
                    EleDate := 0D;
                    TotalAmt := 0;
                    PaymentTermsLineSale.RESET;
                    PaymentTermsLineSale.CHANGECOMPANY("Company Name");
                    PaymentTermsLineSale.SETRANGE("Document No.","No.");
                    PaymentTermsLineSale.SETRANGE("Auto Plot Vacate Due Date",010101D,(TODAY-1));
                    PaymentTermsLineSale.SETRANGE("Allow Auto Plot Vacate",TRUE);
                    IF PaymentTermsLineSale.FINDSET THEN BEGIN
                      REPEAT
                        IF PaymentTermsLineSale."Auto Plot Vacate Due Date" <> 0D THEN
                          EleDate := CALCDATE('-11D',PaymentTermsLineSale."Auto Plot Vacate Due Date");
                        TotalAmt := TotalAmt + PaymentTermsLineSale."Due Amount";
                      UNTIL PaymentTermsLineSale.NEXT =0;
                    END;
                    IF EleDate > "New Confirmed Order"."Posting Date" THEN BEGIN
                      IF EleDate <> 0D THEN BEGIN
                        IF EleDate < TODAY THEN BEGIN
                          IF TotalAmt > "New Confirmed Order"."Total Received Amount" THEN BEGIN
                            Cust.RESET;
                            IF Cust.GET("New Confirmed Order"."Customer No.") THEN
                              IF Cust."Mobile No." <> '' THEN BEGIN
                                TextMessage :='';
                                CLEAR(PostPayment);
                                TextMessage := STRSUBSTNO(PrePlotVacate,Cust.Name,"New Confirmed Order"."Unit Code","New Confirmed Order"."No.");
                                PostPayment.SendSMS(Cust."Mobile No.",TextMessage);
                                "New Confirmed Order"."Sent SMS Auto Plot Vacate" := TRUE;
                                "New Confirmed Order".MODIFY;
                                COMMIT;
                            END;
                          END;
                        END;
                      END;
                    END;
                  END;
                //--------------Send SMS------------
                */   //Code comment for Auto plot vacate SMS 090522
            END;
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
        PostPayment: Codeunit PostPayment;
        TextMessage: Text;
        PaymentTermsLineSale: Record "Payment Terms Line Sale";
        EleDate: Date;
        TotalAmt: Decimal;
        PreAtoB: Label 'Dear: %1, we are pleased to inform you that your Plot''s:%2 & Appl No: %3 payment plan is changing from option A to B in 2 days.Please pay the due amount to avoid payment option charges. Please ignore if already paid. With best regards from BBGIND.';
        PreBtoC: Label 'Dear: %1, we are pleased to inform you that your Plot''s:%2 & Appl No: %3 payment plan is changing from option B to C in 2 days.Please pay the due amount to avoid payment option charges. Please ignore if already paid. With best regards from BBGIND.';
        PrePlotVacate: Label 'Dear: %1 , we are pleased to inform you that your Plot''s:%2 & Appl No: %3 payment plan option C is expiring in 11 days.Please pay the due amount to avoid the renewal price & Auto Plot vacate.Please ignore if already paid. With best regards from BBGIND.';
        PostAtoB: Label 'Dear: %1 , we are pleased to inform you that your Plot''s:%2& Appl No: %3 payment plan has got changed from option A to B. You may please pay the due amount as per the new payment plan option. Please ignore if already paid. With best regards from BBGIND.';
        PostBtoC: Label 'Dear: %1 , we are pleased to inform you that your Plot''s:%2 & Appl No: %3 payment plan has got changed from option B to C. You may please pay the due amount as per the new payment plan option. Please ignore if already paid. With best regards from BBGIND.';
        PostPlotVacate: Label 'Dear: %1 , we are pleased to inform you that your Plot''s:%2 & Appl No: %3 payment plan got expired and plot got  autovacated. Please pay the renewal amount. Please ignore if already paid. With best regards from BBGIND.';
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";
        ExitMessage: Boolean;


    procedure AfterProcessSMSTransferABC(NewConfirmedOrder: Record "New Confirmed Order"; FromOption1: Text; ToOption1: Text)
    begin
        IF FromOption1 = 'Option A' THEN BEGIN
            Cust.RESET;
            IF Cust.GET(NewConfirmedOrder."Customer No.") THEN
                IF Cust."BBG Mobile No." <> '' THEN BEGIN
                    TextMessage := '';
                    CLEAR(PostPayment);
                    TextMessage := STRSUBSTNO(PostAtoB, Cust.Name, NewConfirmedOrder."Unit Code", NewConfirmedOrder."No.");
                    //210224 Added new code
                    CLEAR(CheckMobileNoforSMS);
                    ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Cust."BBG Mobile No.", FALSE);
                    IF ExitMessage THEN
                        PostPayment.SendSMS(Cust."BBG Mobile No.", TextMessage);
                    //ALLEDK15112022 Start
                    CLEAR(SMSLogDetails);
                    SmsMessage := '';
                    SmsMessage1 := '';
                    SmsMessage := COPYSTR(TextMessage, 1, 250);
                    SmsMessage1 := COPYSTR(TextMessage, 251, 250);
                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Cust."No.", Cust.Name, 'Application Transfer', NewConfirmedOrder."Shortcut Dimension 1 Code",
                    GetDescription.GetDimensionName(NewConfirmedOrder."Shortcut Dimension 1 Code", 1), NewConfirmedOrder."No.");
                    //ALLEDK15112022 END
                END;
        END;

        IF FromOption1 = 'Option B' THEN BEGIN
            Cust.RESET;
            IF Cust.GET(NewConfirmedOrder."Customer No.") THEN
                IF Cust."BBG Mobile No." <> '' THEN BEGIN
                    TextMessage := '';
                    CLEAR(PostPayment);
                    TextMessage := STRSUBSTNO(PostBtoC, Cust.Name, NewConfirmedOrder."Unit Code", NewConfirmedOrder."No.");
                    //210224 Added new code
                    CLEAR(CheckMobileNoforSMS);
                    ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Cust."BBG Mobile No.", FALSE);
                    IF ExitMessage THEN
                        PostPayment.SendSMS(Cust."BBG Mobile No.", TextMessage);
                    //ALLEDK15112022 Start
                    CLEAR(SMSLogDetails);
                    SmsMessage := '';
                    SmsMessage1 := '';
                    SmsMessage := COPYSTR(TextMessage, 1, 250);
                    SmsMessage1 := COPYSTR(TextMessage, 251, 250);
                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Cust."No.", Cust.Name, 'Application Transfer', NewConfirmedOrder."Shortcut Dimension 1 Code",
                    GetDescription.GetDimensionName(NewConfirmedOrder."Shortcut Dimension 1 Code", 1), NewConfirmedOrder."No.");
                    //ALLEDK15112022 END
                END;
        END;


        IF FromOption1 = 'Option C' THEN BEGIN
            Cust.RESET;
            IF Cust.GET(NewConfirmedOrder."Customer No.") THEN
                IF Cust."BBG Mobile No." <> '' THEN BEGIN
                    TextMessage := '';
                    CLEAR(PostPayment);
                    TextMessage := STRSUBSTNO(PostPlotVacate, Cust.Name, NewConfirmedOrder."Unit Code", NewConfirmedOrder."No.");
                    //210224 Added new code
                    CLEAR(CheckMobileNoforSMS);
                    ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Cust."BBG Mobile No.", FALSE);
                    IF ExitMessage THEN
                        PostPayment.SendSMS(Cust."BBG Mobile No.", TextMessage);
                    //ALLEDK15112022 Start
                    CLEAR(SMSLogDetails);
                    SmsMessage := '';
                    SmsMessage1 := '';
                    SmsMessage := COPYSTR(TextMessage, 1, 250);
                    SmsMessage1 := COPYSTR(TextMessage, 251, 250);
                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Cust."No.", Cust.Name, 'Application Transfer', NewConfirmedOrder."Shortcut Dimension 1 Code",
                    GetDescription.GetDimensionName(NewConfirmedOrder."Shortcut Dimension 1 Code", 1), NewConfirmedOrder."No.");
                    //ALLEDK15112022 END
                END;
        END;
    end;
}

