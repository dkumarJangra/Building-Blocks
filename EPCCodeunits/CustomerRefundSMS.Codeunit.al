codeunit 50058 "Customer Refund SMS"
{

    trigger OnRun()
    begin
    end;

    var
        Text50001: Label 'Do you want to Refund?';
        Text50002: Label 'Please verify the details below and confirm. Do you want to post ? %1      :%2\Project Name         :%3  Project Code :%4\Unit No.                 :%5\Customer Name     :%6 %7\Associate Code      :%8  %9 \Receiving Amount  : %10 \Amount in Words   : %11 \Posting Date          : %12.';
        Text0011: Label 'is not within your range of allowed posting dates';
        Text50003: Label 'Do you want to send message to customer %1?';
        v_RefundChangeLogDetails: Record "Refund Change Log Details";
        UserSetup: Record "User Setup";
        ComInfo: Record "Company Information";
        Customer: Record Customer;
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        RefundInitiatAmt: Boolean;
        Vendor1: Record Vendor;
        CustSMSText1: Text;
        RefundRejectionSMSSend: Boolean;
        RefundChangeLogDetails: Record "Refund Change Log Details";
        BBGSETUP: Record "BBG Setups";
        RankCodeMaster: Record "Rank Code Master";
        CustSMSText: Text[1000];
        CashAmt: Decimal;
        AppPayEntry: Record "NewApplication Payment Entry";
        CustMobileNo: Text;
        GetDescription: Codeunit GetDescription;
        PostPayment: Codeunit PostPayment;
        Text50005: Label ' ,Submission,Initiation,Verification,Approval,Payment';
        ExitMessage: Boolean;
        CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";


    procedure "Refund SMS Send"(NewConfirmedOrder_P: Record "New Confirmed Order"; "XRecNew Confirmed Order": Record "New Confirmed Order")
    var
        RegionCode: Code[10];
        NewAssociateBottom: Report "New Associate Bottom To Top_1";
        ReceivableAmount: Decimal;
        BondNominee: Record "Unit Nominee";
        AmountReceived: Decimal;
        DueAmount: Decimal;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        Dummy: Text[30];
        BondHolderName: Text[50];
        BondHolderName2: Text[50];
        Customer: Record Customer;
        Customer2: Record Customer;
        Vendor: Record Vendor;
        ReassignType: Option FirstBondHolder,SecondBondHolder,BothBondHolder,MarketingMember;
        Selection: Integer;
        BondChangeType: Option Scheme,"Investment Frequency","Return Frequency","Return Payment Mode","Bond Holder","Co Bond Holder","Marketing Member","Business Transfer";
        GetDescription: Codeunit GetDescription;
        CustomerBankAccount: Record "Customer Bank Account";
        Unitmaster: Record "Associate Hierarcy with App.";
        UserSetup: Record "User Setup";
        UnpostedInstallment: Integer;
        BondSetup: Record "Unit Setup";
        LineNo: Integer;
        PostPayment: Codeunit PostPayment;
        MsgDialog: Dialog;
        PenaltyAmount: Decimal;
        ReverseComm: Boolean;
        Bond: Record "New Confirmed Order";
        ReceivedAmount: Decimal;
        TotalAmount: Decimal;
        ExcessAmount: Decimal;
        ConOrder: Record "New Confirmed Order";
        BondReversal: Codeunit "Unit Reversal";
        LastVersion: Integer;
        ConfirmOrder: Record "New Confirmed Order";
        "-----------------UNIT INSERT -": Integer;
        UnitMasterRec: Record "New Associate Hier with Appl.";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        DocNo1: Code[20];
        Amt: Decimal;
        UnitSetup: Record "Unit Setup";
        LineNo2: Integer;
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Job: Record Job;
        GenJnlLine2: Record "Gen. Journal Line";
        ConfOrder: Record "New Confirmed Order";
        BondInvestmentAmt: Decimal;
        ByCheque: Boolean;
        AppPaymentEntry: Record "NewApplication Payment Entry";
        ConfReport: Report "Member Receipt";
        MemberOf: Record "Access Control";
        CustMobileNo: Text[30];
        CustSMSText: Text[1000];
        CashAmt: Decimal;
        AppPayEntry: Record "NewApplication Payment Entry";
        Flag: Boolean;
        Vend: Record Vendor;
        AmountToWords: Codeunit "Amount To Words";
        AmountText1: array[2] of Text[300];
        ApplicationForm: Page "New Application booking";
        //ConfReport1: Report 50080;
        GJCLine: Codeunit "Gen. Jnl.-Check Line";
        ComInfo: Record "Company Information";
        BBGSMS: Codeunit "SMS Features";
        PaymentAmt: Decimal;
        CheckVendor: Record Vendor;
        NewApplPayEntry_1: Record "NewApplication Payment Entry";
        RespCenter: Record "Responsibility Center 1";
        EditableRegNo: Boolean;
        EditableRegDate: Boolean;
        EditableRegOffice: Boolean;
        EditableReginFavour: Boolean;
        EditableFatherName: Boolean;
        EditableRegoffName: Boolean;
        EditableRegAdd: Boolean;
        EditableBranchCode: Boolean;
        EditableRegCity: Boolean;
        EditableZipcode: Boolean;
        v_RefundChangeLogDetails: Record "Refund Change Log Details";
    begin

        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Refund SMS Completed", FALSE);
        IF UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
        ComInfo.GET;
        IF ComInfo."Send SMS" THEN BEGIN
            IF CONFIRM(Text50003, TRUE) THEN
                IF Customer.GET(NewConfirmedOrder_P."Customer No.") THEN
                    IF Customer."BBG Mobile No." <> '' THEN BEGIN
                        NewApplPayEntry_1.RESET;
                        NewApplPayEntry_1.SETRANGE("Document No.", NewConfirmedOrder_P."No.");
                        NewApplPayEntry_1.SETRANGE(Posted, TRUE);
                        NewApplPayEntry_1.SETFILTER("Payment Mode", '%1|%2', NewApplPayEntry_1."Payment Mode"::"Refund Cash",
                                                     NewApplPayEntry_1."Payment Mode"::"Refund Bank");
                        IF NewApplPayEntry_1.FINDLAST THEN;
                        IF Job.GET(NewConfirmedOrder_P."Shortcut Dimension 1 Code") THEN
                            IF Job."Region Code for Rank Hierarcy" <> '' THEN
                                RegionCode := Job."Region Code for Rank Hierarcy"
                            ELSE
                                RegionCode := 'R0001';

                        RespCenter.RESET;
                        IF RespCenter.GET(NewConfirmedOrder_P."Shortcut Dimension 1 Code") THEN;
                        CLEAR(NewAssociateBottom);
                        NewAssociateBottom.SetCustRefund(Customer."BBG Mobile No.", Customer.Name, NewConfirmedOrder_P."No.", RespCenter.Name, NewApplPayEntry_1.Amount,
                        NewApplPayEntry_1."Posting date", RegionCode, NewConfirmedOrder_P."Introducer Code");
                        NewAssociateBottom.RUNMODAL;
                        InsertRefundChangeLog_2(NewConfirmedOrder_P, "XRecNew Confirmed Order");  //09022023
                    END;
        END;
    end;


    procedure InsertRefundChangeLog_2(NewConfirmedOrder_P1: Record "New Confirmed Order"; XRecNewConfirmedOrder_P1: Record "New Confirmed Order")
    var
        LineNo: Integer;
        RefundChangeLogDetails: Record "Refund Change Log Details";
        NewConfirmedOrder: Record "New Confirmed Order";
    begin
        LineNo := 0;
        RefundChangeLogDetails.RESET;
        RefundChangeLogDetails.SETRANGE("No.", NewConfirmedOrder_P1."No.");
        IF RefundChangeLogDetails.FINDLAST THEN
            LineNo := RefundChangeLogDetails."Line No.";
        RefundChangeLogDetails.INIT;
        RefundChangeLogDetails."No." := NewConfirmedOrder_P1."No.";
        RefundChangeLogDetails."Line No." := LineNo + 1;
        RefundChangeLogDetails."Customer No." := NewConfirmedOrder_P1."Customer No.";
        RefundChangeLogDetails."Introducer Code" := NewConfirmedOrder_P1."Introducer Code";
        RefundChangeLogDetails."Shortcut Dimension 1 Code" := NewConfirmedOrder_P1."Shortcut Dimension 1 Code";
        RefundChangeLogDetails.Status := NewConfirmedOrder_P1.Status;
        RefundChangeLogDetails.Amount := NewConfirmedOrder_P1.Amount;
        RefundChangeLogDetails."Posting Date" := NewConfirmedOrder_P1."Posting Date";
        RefundChangeLogDetails."Document Date" := NewConfirmedOrder_P1."Document Date";
        RefundChangeLogDetails."Refund SMS Status" := RefundChangeLogDetails."Refund SMS Status"::Completed;
        RefundChangeLogDetails."Refund Initiate Amount" := NewConfirmedOrder_P1."Refund Initiate Amount";
        RefundChangeLogDetails."Refund Rejection Remark" := NewConfirmedOrder_P1."Refund Rejection Remark";
        RefundChangeLogDetails."Refund Rejection SMS Sent" := NewConfirmedOrder_P1."Refund Rejection SMS Sent";
        RefundChangeLogDetails."Min. Allotment Amount" := NewConfirmedOrder_P1."Min. Allotment Amount";
        RefundChangeLogDetails."Modified By" := USERID;
        RefundChangeLogDetails."Modify Date" := TODAY;
        RefundChangeLogDetails."Modify Time" := TIME;
        RefundChangeLogDetails."Old Refund SMS Status" := XRecNewConfirmedOrder_P1."Refund SMS Status";
        RefundChangeLogDetails."Old Refund Initiate Amount" := XRecNewConfirmedOrder_P1."Refund Initiate Amount";
        RefundChangeLogDetails."Old Refund Rejection Remark" := XRecNewConfirmedOrder_P1."Refund Rejection Remark";
        RefundChangeLogDetails."Old Refund Rejection SMS Sent" := XRecNewConfirmedOrder_P1."Refund Rejection SMS Sent";
        v_RefundChangeLogDetails.RESET;
        v_RefundChangeLogDetails.SETRANGE("No.", NewConfirmedOrder_P1."No.");
        v_RefundChangeLogDetails.SETFILTER("Submission Date", '<>%1', 0D);
        IF v_RefundChangeLogDetails.FINDFIRST THEN
            RefundChangeLogDetails."Submission Date" := v_RefundChangeLogDetails."Submission Date";

        v_RefundChangeLogDetails.RESET;
        v_RefundChangeLogDetails.SETRANGE("No.", NewConfirmedOrder_P1."No.");
        v_RefundChangeLogDetails.SETFILTER("Rejected Date", '<>%1', 0D);
        IF v_RefundChangeLogDetails.FINDFIRST THEN
            RefundChangeLogDetails."Rejected Date" := v_RefundChangeLogDetails."Rejected Date";
        RefundChangeLogDetails."Completed Date" := TODAY;

        RefundChangeLogDetails.INSERT;

        IF NewConfirmedOrder.GET(NewConfirmedOrder_P1."No.") THEN BEGIN
            NewConfirmedOrder."Refund SMS Status" := NewConfirmedOrder."Refund SMS Status"::Completed;
            NewConfirmedOrder.MODIFY;
        END;
    end;


    procedure "Refund SMS Submission"(NewConfirmedOrder_P: Record "New Confirmed Order")
    begin

        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Refund SMS Submission", FALSE);
        IF UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');

        NewConfirmedOrder_P.TESTFIELD("Refund Initiate Amount");

        ComInfo.GET;
        ComInfo.SETRANGE("Send SMS", TRUE);
        IF ComInfo.FINDFIRST THEN BEGIN
            Customer.RESET;
            Customer.GET(NewConfirmedOrder_P."Customer No.");
            CustMobileNo := Customer."BBG Mobile No.";
            //  CustMobileNo := '9818076832';
            IF CustMobileNo <> '' THEN BEGIN
                CustSMSText1 := '';
                CustSMSText1 := 'Dear Customer, Your PLOT REFUND Request Received at CRM Desk. Name: Mr /Ms ' + Customer.Name + ', Appl No:' + NewConfirmedOrder_P."No." + ', Project:' +
                                GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1) + ', Amount: ' + FORMAT(NewConfirmedOrder_P."Refund Initiate Amount") + ', Date: ' + FORMAT(TODAY) +
                                ' *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';
                //210224 Added new code
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                IF ExitMessage THEN
                    PostPayment.SendSMS(CustMobileNo, CustSMSText1);
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(CustSMSText1, 1, 250);
                SmsMessage1 := COPYSTR(CustSMSText1, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Refund Request', NewConfirmedOrder_P."Shortcut Dimension 1 Code",
                 GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1), NewConfirmedOrder_P."No.");
                COMMIT;
            END;
            Vendor1.RESET;
            Vendor1.GET(NewConfirmedOrder_P."Introducer Code");
            IF Vendor1."BBG Mob. No." <> '' THEN BEGIN
                //210224 Added new code
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Vendor1."BBG Mob. No.", FALSE);
                IF ExitMessage THEN
                    PostPayment.SendSMS(Vendor1."BBG Mob. No.", CustSMSText1);
                //PostPayment.SendSMS('8374999906',CustSMSText1);
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(CustSMSText1, 1, 250);
                SmsMessage1 := COPYSTR(CustSMSText1, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor1."No.", Vendor1.Name, 'Refund Request', NewConfirmedOrder_P."Shortcut Dimension 1 Code",
                GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1), NewConfirmedOrder_P."No.");
            END;
            NewConfirmedOrder_P."Refund SMS Status" := NewConfirmedOrder_P."Refund SMS Status"::Submission;
            NewConfirmedOrder_P.MODIFY;
            InsertRefundChangeLog(NewConfirmedOrder_P, TRUE, FALSE, NewConfirmedOrder_P);
            MESSAGE('SMS Sent');
        END;
    end;


    procedure "Refund SMS Initiation"(NewConfirmedOrder_P: Record "New Confirmed Order")
    begin

        NewConfirmedOrder_P.TESTFIELD("Refund SMS Status", NewConfirmedOrder_P."Refund SMS Status"::Submission);
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Refund SMS Initiation", FALSE);
        IF UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
        NewConfirmedOrder_P.TESTFIELD("Refund Initiate Amount");
        ComInfo.GET;
        ComInfo.SETRANGE("Send SMS", TRUE);
        IF ComInfo.FINDFIRST THEN BEGIN
            Customer.RESET;
            Customer.GET(NewConfirmedOrder_P."Customer No.");
            CustMobileNo := Customer."BBG Mobile No.";
            IF CustMobileNo <> '' THEN BEGIN
                CustSMSText1 := '';
                CustSMSText1 := 'Dear Customer, Your PLOT REFUND Process is Initiated. Name: Mr /Ms ' + Customer.Name + ', Appl No:' + NewConfirmedOrder_P."No." + ', Project:' +
                                GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1) + ', Amount: ' + FORMAT(NewConfirmedOrder_P."Refund Initiate Amount") + ', Date: ' + FORMAT(TODAY) +
                                ' *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';

                //210224 Added new code
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                IF ExitMessage THEN
                    PostPayment.SendSMS(CustMobileNo, CustSMSText1);
                //ALLEDK05122022 Start
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(CustSMSText1, 1, 250);
                SmsMessage1 := COPYSTR(CustSMSText1, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Refund Initiation', NewConfirmedOrder_P."Shortcut Dimension 1 Code",
                GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1), NewConfirmedOrder_P."No.");
                //ALLEDK05122022  END
                COMMIT;
            END;
            Vendor1.RESET;
            Vendor1.GET(NewConfirmedOrder_P."Introducer Code");
            IF Vendor1."BBG Mob. No." <> '' THEN BEGIN
                //210224 Added new code
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Vendor1."BBG Mob. No.", FALSE);
                IF ExitMessage THEN
                    PostPayment.SendSMS(Vendor1."BBG Mob. No.", CustSMSText1);
                //ALLEDK05122022 Start
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(CustSMSText1, 1, 250);
                SmsMessage1 := COPYSTR(CustSMSText1, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor1."No.", Vendor1.Name, 'Refund Initiation', NewConfirmedOrder_P."Shortcut Dimension 1 Code",
                GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1), NewConfirmedOrder_P."No.");
                //ALLEDK05122022  END
            END;

            NewConfirmedOrder_P."Refund SMS Status" := NewConfirmedOrder_P."Refund SMS Status"::Initiated;
            NewConfirmedOrder_P.MODIFY;
            InsertRefundChangeLog(NewConfirmedOrder_P, FALSE, FALSE, NewConfirmedOrder_P);
            MESSAGE('SMS Sent');
        END;
        RefundInitiatAmt := FALSE;
    end;


    procedure "Refund SMS Verification"(NewConfirmedOrder_P: Record "New Confirmed Order")
    begin
        NewConfirmedOrder_P.TESTFIELD("Refund Initiate Amount");
        NewConfirmedOrder_P.TESTFIELD("Refund SMS Status", NewConfirmedOrder_P."Refund SMS Status"::Initiated);
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Refund SMS Verification", FALSE);
        IF UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');

        ComInfo.GET;
        ComInfo.SETRANGE("Send SMS", TRUE);
        IF ComInfo.FINDFIRST THEN BEGIN

            Customer.RESET;
            Customer.GET(NewConfirmedOrder_P."Customer No.");
            CustMobileNo := Customer."BBG Mobile No.";
            IF CustMobileNo <> '' THEN BEGIN
                CustSMSText1 := '';
                CustSMSText1 := 'Dear Customer, Your PLOT REFUND Request Is Verified. Name: Mr /Ms ' + Customer.Name + ', Appl No:' + NewConfirmedOrder_P."No." + ', Project:' +
                                GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1) + ', Amount: ' + FORMAT(NewConfirmedOrder_P."Refund Initiate Amount") +
                                ', Date: ' + FORMAT(TODAY) + ' *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';
                //210224 Added new code
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                IF ExitMessage THEN
                    PostPayment.SendSMS(CustMobileNo, CustSMSText1);
                //ALLEDK05122022 Start
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(CustSMSText1, 1, 250);
                SmsMessage1 := COPYSTR(CustSMSText1, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Refund Verification', NewConfirmedOrder_P."Shortcut Dimension 1 Code",
                GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1), NewConfirmedOrder_P."No.");
                //ALLEDK05122022  END
                COMMIT;
            END;
            Vendor1.RESET;
            Vendor1.GET(NewConfirmedOrder_P."Introducer Code");
            IF Vendor1."BBG Mob. No." <> '' THEN BEGIN
                //210224 Added new code
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Vendor1."BBG Mob. No.", FALSE);
                IF ExitMessage THEN
                    PostPayment.SendSMS(Vendor1."BBG Mob. No.", CustSMSText1);
                //PostPayment.SendSMS('9381601731',CustSMSText1);
                //ALLEDK05122022 Start
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(CustSMSText1, 1, 250);
                SmsMessage1 := COPYSTR(CustSMSText1, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor1."No.", Vendor1.Name, 'Refund Verification', NewConfirmedOrder_P."Shortcut Dimension 1 Code",
                GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1), NewConfirmedOrder_P."No.");
                //ALLEDK05122022  END
            END;

            NewConfirmedOrder_P."Refund SMS Status" := NewConfirmedOrder_P."Refund SMS Status"::Verified;
            NewConfirmedOrder_P.MODIFY;
            InsertRefundChangeLog(NewConfirmedOrder_P, FALSE, FALSE, NewConfirmedOrder_P);
            MESSAGE('SMS Sent');
        END;
    end;


    procedure "Refund SMS Approval"(NewConfirmedOrder_P: Record "New Confirmed Order")
    begin
        NewConfirmedOrder_P.TESTFIELD("Refund SMS Status", NewConfirmedOrder_P."Refund SMS Status"::Verified);
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Refund SMS Approval", FALSE);
        IF UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');

        NewConfirmedOrder_P.TESTFIELD("Refund Initiate Amount");

        ComInfo.GET;
        ComInfo.SETRANGE("Send SMS", TRUE);
        IF ComInfo.FINDFIRST THEN BEGIN
            Customer.RESET;
            Customer.GET(NewConfirmedOrder_P."Customer No.");
            CustMobileNo := Customer."BBG Mobile No.";
            IF CustMobileNo <> '' THEN BEGIN
                CustSMSText1 := '';
                CustSMSText1 := 'Dear Customer, Your PLOT REFUND Request Is Approved. Name: Mr /Ms ' + Customer.Name + ', Appl No:' + NewConfirmedOrder_P."No." + ', Project:' +
                                GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1) + ', Amount: ' + FORMAT(NewConfirmedOrder_P."Refund Initiate Amount") + ', Date: ' + FORMAT(TODAY) +
                                ' *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';

                //210224 Added new code
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                IF ExitMessage THEN
                    PostPayment.SendSMS(CustMobileNo, CustSMSText1);
                //ALLEDK05122022 Start
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(CustSMSText1, 1, 250);
                SmsMessage1 := COPYSTR(CustSMSText1, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Refund Approval', NewConfirmedOrder_P."Shortcut Dimension 1 Code",
                GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1), NewConfirmedOrder_P."No.");
                //ALLEDK05122022  END
                COMMIT;
            END;
            Vendor1.RESET;
            Vendor1.GET(NewConfirmedOrder_P."Introducer Code");
            IF Vendor1."BBG Mob. No." <> '' THEN BEGIN
                //210224 Added new code
                CLEAR(CheckMobileNoforSMS);
                ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Vendor1."BBG Mob. No.", FALSE);
                IF ExitMessage THEN
                    PostPayment.SendSMS(Vendor1."BBG Mob. No.", CustSMSText1);
                //PostPayment.SendSMS('9381601731',CustSMSText1);
                //ALLEDK05122022 Start
                CLEAR(SMSLogDetails);
                SmsMessage := '';
                SmsMessage1 := '';
                SmsMessage := COPYSTR(CustSMSText1, 1, 250);
                SmsMessage1 := COPYSTR(CustSMSText1, 251, 250);
                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor1."No.", Vendor1.Name, 'Refund Approval', NewConfirmedOrder_P."Shortcut Dimension 1 Code",
                GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1), NewConfirmedOrder_P."No.");
                //ALLEDK05122022  END
            END;

            NewConfirmedOrder_P."Refund SMS Status" := NewConfirmedOrder_P."Refund SMS Status"::Approved;
            NewConfirmedOrder_P.MODIFY;
            InsertRefundChangeLog(NewConfirmedOrder_P, FALSE, FALSE, NewConfirmedOrder_P);
            MESSAGE('SMS Sent');
        END;
    end;


    procedure "Refund Reject SMS"(NewConfirmedOrder_P: Record "New Confirmed Order"; RejSMSType: Text)
    var
        Selection: Integer;
        StageTxt: Text;
    begin
        // ,Submission,Initiation,Verification,Approval,Payment

        NewConfirmedOrder_P.TESTFIELD("Refund Rejection Remark");
        NewConfirmedOrder_P.TESTFIELD("Refund Initiate Amount");

        IF RejSMSType <> '' THEN BEGIN
            StageTxt := RejSMSType;
        END ELSE BEGIN
            StageTxt := '';
            Selection := STRMENU(Text50005, 1);
            IF Selection <> 0 THEN BEGIN
                IF Selection = 1 THEN BEGIN
                    UserSetup.RESET;
                    IF UserSetup.GET(USERID) THEN
                        UserSetup.TESTFIELD("Refund Reject Submission");
                    StageTxt := 'Submission';
                END ELSE
                    IF Selection = 2 THEN BEGIN
                        UserSetup.RESET;
                        IF UserSetup.GET(USERID) THEN
                            UserSetup.TESTFIELD("Refund Reject Initiation");
                        StageTxt := 'Initiation';
                    END ELSE
                        IF Selection = 3 THEN BEGIN
                            UserSetup.RESET;
                            IF UserSetup.GET(USERID) THEN
                                UserSetup.TESTFIELD("Refund Reject Verification");
                            StageTxt := 'Verification';
                        END ELSE
                            IF Selection = 4 THEN BEGIN
                                UserSetup.RESET;
                                IF UserSetup.GET(USERID) THEN
                                    UserSetup.TESTFIELD("Refund Reject Approval");
                                StageTxt := 'Approval';
                            END ELSE
                                IF Selection = 5 THEN BEGIN
                                    UserSetup.RESET;
                                    IF UserSetup.GET(USERID) THEN
                                        UserSetup.TESTFIELD("Refund Reject Payment");
                                    StageTxt := 'Payment';
                                END;
            END;
        END;

        IF StageTxt <> '' THEN BEGIN
            ComInfo.GET;
            ComInfo.SETRANGE("Send SMS", TRUE);
            IF ComInfo.FINDFIRST THEN BEGIN
                Customer.RESET;
                Customer.GET(NewConfirmedOrder_P."Customer No.");
                CustMobileNo := Customer."BBG Mobile No.";
                //CustMobileNo := '8374999906';
                IF CustMobileNo <> '' THEN BEGIN
                    CustSMSText1 := '';
                    CustSMSText1 := 'Dear Customer, Your PLOT REFUND Request is Rejected at ' + '(' + StageTxt + ') Stage. Name: Mr /Ms ' + Customer.Name + ', Appl No:' + NewConfirmedOrder_P."No." + ', Project:' +
                                    GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1) + ', Amount: ' + FORMAT(NewConfirmedOrder_P."Refund Initiate Amount") + ', Date: ' + FORMAT(TODAY) +
                                    ' *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';

                    //210224 Added new code
                    CLEAR(CheckMobileNoforSMS);
                    ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                    IF ExitMessage THEN
                        PostPayment.SendSMS(CustMobileNo, CustSMSText1);
                    CLEAR(SMSLogDetails);
                    SmsMessage := '';
                    SmsMessage1 := '';
                    SmsMessage := COPYSTR(CustSMSText1, 1, 250);
                    SmsMessage1 := COPYSTR(CustSMSText1, 251, 250);
                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Refund Reject', NewConfirmedOrder_P."Shortcut Dimension 1 Code",
                    GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1), NewConfirmedOrder_P."No.");
                    COMMIT;
                END;
                Vendor1.RESET;
                Vendor1.GET(NewConfirmedOrder_P."Introducer Code");
                IF Vendor1."BBG Mob. No." <> '' THEN BEGIN
                    //210224 Added new code
                    CLEAR(CheckMobileNoforSMS);
                    ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Vendor1."BBG Mob. No.", FALSE);
                    IF ExitMessage THEN
                        PostPayment.SendSMS(Vendor1."BBG Mob. No.", CustSMSText1);
                    //PostPayment.SendSMS('8374999906',CustSMSText1);
                    CLEAR(SMSLogDetails);
                    SmsMessage := '';
                    SmsMessage1 := '';
                    SmsMessage := COPYSTR(CustSMSText1, 1, 250);
                    SmsMessage1 := COPYSTR(CustSMSText1, 251, 250);
                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor1."No.", Vendor1.Name, 'Refund Reject', NewConfirmedOrder_P."Shortcut Dimension 1 Code",
                    GetDescription.GetDimensionName(NewConfirmedOrder_P."Shortcut Dimension 1 Code", 1), NewConfirmedOrder_P."No.");
                END;
                //RefundRejectionSMSSend := TRUE;
                NewConfirmedOrder_P."Refund Rejection SMS Sent" := TRUE;
                NewConfirmedOrder_P."Refund SMS Status" := NewConfirmedOrder_P."Refund SMS Status"::Rejected;
                NewConfirmedOrder_P.MODIFY;
                InsertRefundChangeLog(NewConfirmedOrder_P, FALSE, TRUE, NewConfirmedOrder_P);
                MESSAGE('SMS Sent');
            END;
        END;
    end;


    procedure InsertRefundChangeLog(NewConfirmedOrder_P_2: Record "New Confirmed Order"; FromSubmission: Boolean; FromRejected: Boolean; XrecNewConfirmedOrder_P_2: Record "New Confirmed Order")
    var
        LineNo: Integer;
    begin

        LineNo := 0;
        RefundChangeLogDetails.RESET;
        RefundChangeLogDetails.SETRANGE("No.", NewConfirmedOrder_P_2."No.");
        IF RefundChangeLogDetails.FINDLAST THEN
            LineNo := RefundChangeLogDetails."Line No.";

        RefundChangeLogDetails.INIT;
        RefundChangeLogDetails."No." := NewConfirmedOrder_P_2."No.";
        RefundChangeLogDetails."Line No." := LineNo + 1;
        RefundChangeLogDetails."Customer No." := NewConfirmedOrder_P_2."Customer No.";
        RefundChangeLogDetails."Introducer Code" := NewConfirmedOrder_P_2."Introducer Code";
        RefundChangeLogDetails."Shortcut Dimension 1 Code" := NewConfirmedOrder_P_2."Shortcut Dimension 1 Code";
        RefundChangeLogDetails.Status := NewConfirmedOrder_P_2.Status;
        RefundChangeLogDetails.Amount := NewConfirmedOrder_P_2.Amount;
        RefundChangeLogDetails."Posting Date" := NewConfirmedOrder_P_2."Posting Date";
        RefundChangeLogDetails."Document Date" := NewConfirmedOrder_P_2."Document Date";
        RefundChangeLogDetails."Refund SMS Status" := NewConfirmedOrder_P_2."Refund SMS Status";
        RefundChangeLogDetails."Refund Initiate Amount" := NewConfirmedOrder_P_2."Refund Initiate Amount";
        RefundChangeLogDetails."Refund Rejection Remark" := NewConfirmedOrder_P_2."Refund Rejection Remark";
        RefundChangeLogDetails."Refund Rejection SMS Sent" := NewConfirmedOrder_P_2."Refund Rejection SMS Sent";
        RefundChangeLogDetails."Min. Allotment Amount" := NewConfirmedOrder_P_2."Min. Allotment Amount";
        RefundChangeLogDetails."Modified By" := USERID;
        RefundChangeLogDetails."Modify Date" := TODAY;
        RefundChangeLogDetails."Modify Time" := TIME;
        RefundChangeLogDetails."Old Refund SMS Status" := XrecNewConfirmedOrder_P_2."Refund SMS Status";
        RefundChangeLogDetails."Old Refund Initiate Amount" := XrecNewConfirmedOrder_P_2."Refund Initiate Amount";
        RefundChangeLogDetails."Old Refund Rejection Remark" := XrecNewConfirmedOrder_P_2."Refund Rejection Remark";
        RefundChangeLogDetails."Old Refund Rejection SMS Sent" := XrecNewConfirmedOrder_P_2."Refund Rejection SMS Sent";
        IF FromSubmission THEN
            RefundChangeLogDetails."Submission Date" := TODAY;
        IF FromRejected THEN BEGIN
            v_RefundChangeLogDetails.RESET;
            v_RefundChangeLogDetails.SETRANGE("No.", NewConfirmedOrder_P_2."No.");
            v_RefundChangeLogDetails.SETFILTER("Submission Date", '<>%1', 0D);
            IF v_RefundChangeLogDetails.FINDFIRST THEN
                RefundChangeLogDetails."Submission Date" := v_RefundChangeLogDetails."Submission Date";
            RefundChangeLogDetails."Rejected Date" := TODAY;
        END;
        RefundChangeLogDetails.INSERT;
    end;
}

