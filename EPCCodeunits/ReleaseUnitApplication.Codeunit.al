codeunit 97721 "Release Unit Application"
{
    TableNo = Application;

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Due amount is %1. Please enter rest due amount.';
        Text002: Label 'Required valid setup for Bonus and Commission for %1 %2, %3 %4, %5 %6.';
        BondType: Record "Unit Type";
        ApplPaymentEntry: Record "Unit Payment Entry";
        BondSetup: Record "Unit Setup";
        ApplHistory: Record "Unit History";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        BondPost: Codeunit "Unit Post";
        GetDescription: Codeunit GetDescription;
        UnitMaster: Record "Unit Master";
        PostedDocNo: Code[20];
        NewUnitMaster: Record "New Associate Hier with Appl.";
        RecVendCode: Code[20];
        RecJob: Record Job;
        PPLANCode: Code[10];


    procedure ReleaseApplication(var Application: Record Application; FromBatchjob: Boolean)
    var
        BondType: Record "Unit Type";
        PostPayment: Codeunit PostPayment;
        BondPaymentEntry: Record "Unit Payment Entry";
        Vendor: Record Vendor;
        Documentation: Record Documentation;
        BondNominee: Record "Unit Nominee";
    begin
        IF Application.Status = Application.Status::Released THEN
            EXIT;

        Application.TESTFIELD(Status, Application.Status::Open);
        Application.TESTFIELD("Application No.");
        Application.TESTFIELD("Project Type");
        Application.TESTFIELD("Investment Type");
        IF Application."Posted Doc No." = '' THEN BEGIN
            IF USERID <> '1003' THEN BEGIN
                IF NOT FromBatchjob THEN BEGIN
                    // TESTFIELD("Posting Date",WORKDATE); 1912
                    // TESTFIELD("Document Date",GetDescription.GetDocomentDate);  1912
                END;
            END;
        END;
        Application.TESTFIELD("Customer Name");
        Application.TESTFIELD("Associate Code");
        Application.TESTFIELD("Received From Code");
        Application.TESTFIELD("Investment Amount");
        IF Application."Investment Type" = Application."Investment Type"::MIS THEN
            Application.TESTFIELD("Return Frequency");

        Application.CALCFIELDS("Amount Received");

        PPLANCode := '';
        PPLANCode := CheckUnitPaymentPlan(Application."Shortcut Dimension 1 Code", Application."Application No.", FALSE);
        IF NOT BondPost.ValidCommStruc(Application."Investment Type", Application.Duration, Application."Project Type", Application."Posting Date", PPLANCode) THEN  //071223
            ERROR(Text002, Application.FIELDCAPTION("Project Type"), Application."Project Type", Application.FIELDCAPTION("Investment Type"),
            Application."Investment Type", Application.FIELDCAPTION(Duration), Application.Duration);

        BondSetup.GET;

        BondType.RESET;
        BondType.GET(Application."Project Type");
        BondType.TESTFIELD("Bond Nos.");

        IF Application."Customer No." = '' THEN
            Application."Customer No." := Application.CreateCustomer(Application."Customer Name");

        IF Application."Unit No." = '' THEN BEGIN
            Application."Unit No." := Application."Application No.";
            COMMIT;
        END;

        IF (Application."Bank Account No." <> '') OR (Application."Branch Name" <> '') THEN
            Application.CreateCustomerBankAccount(Application."Application No.", Application."Customer No.", Application."Bank Account No.", Application."Branch Name");

        BondPost.InitTempBonusEntry;
        BondPost.CalculateApplicationBonus(Application, Application."With Cheque");

        IF Application."Posted Doc No." = '' THEN BEGIN
            Application."Posted Doc No." := NoSeriesMgt.GetNextNo(BondSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
            COMMIT;
        END;

        PostedDocNo := Application."Posted Doc No."; //ALLETDK

        Vendor.GET(Application."Associate Code");

        IF (Vendor."BBG Status" = Vendor."BBG Status"::" ") OR (Vendor."BBG Status" = Vendor."BBG Status"::Provisional) THEN BEGIN
            Vendor."BBG Status" := Vendor."BBG Status"::Active;
            Vendor.MODIFY;
        END;

        Application.Status := Application.Status::Released;

        IF NOT Documentation.GET(Application."Unit No.") THEN BEGIN
            Documentation.INIT;
            Documentation."Unit No." := Application."Unit No.";
            Documentation.INSERT;
        END;

        Documentation."Customer No.(1)" := Application."Customer No.";
        Documentation."Customer Name(1)" := Application."Customer Name";
        Documentation."Application No." := Application."Application No.";
        Documentation.MODIFY;

        IF NOT BondNominee.GET(Application."Unit No.") THEN BEGIN
            BondNominee.INIT;
            BondNominee."Unit No." := Application."Unit No.";
            BondNominee.INSERT;
        END;
        BondNominee."Customer No." := Application."Customer No.";
        BondNominee.MODIFY;
        UpdateAppPaymentEntries(Application."Application No.");
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::Application);
        BondPaymentEntry.SETRANGE("Document No.", Application."Application No.");
        IF BondPaymentEntry.FINDSET THEN
            REPEAT
                BondPaymentEntry.TESTFIELD("Explode BOM", TRUE);
                BondPaymentEntry."Unit Code" := Application."Unit Code"; //ALLETDK141112
                BondPaymentEntry."Installment No." := 1;
                BondPaymentEntry."Posted Document No." := Application."Posted Doc No.";
                BondPaymentEntry.Posted := TRUE;
                BondPaymentEntry.MODIFY;
                IF (BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::Cash) AND
                   (BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::"Refund Cash")
                   AND (BondPaymentEntry."Payment Mode" <> BondPaymentEntry."Payment Mode"::AJVM) THEN
                    Application."With Cheque" := TRUE;
            UNTIL BondPaymentEntry.NEXT = 0;
        Application.MODIFY;

        PostPayment.PostPayment(Application, 'Initial Payment Received', FromBatchjob);


        BondPost.InsertBonusEntry(Application."With Cheque");

        PostPayment.PostGenJnlLines(Application."Posted Doc No.");
        UnitMaster.GET(Application."Unit Code");
        UnitMaster.VALIDATE(Status, UnitMaster.Status::Booked);
        UnitMaster.MODIFY;
    end;


    procedure InsertBondHistory(BondNo: Code[20]; Description: Text[50]; EntryType: Option Application,Bond; DocumentNo: Code[20])
    var
        BondHistory: Record "Unit History";
        NewLineNo: Integer;
    begin
        BondHistory.RESET;
        BondHistory.SETRANGE("Unit No.", BondNo);
        IF BondHistory.FINDLAST THEN
            NewLineNo := BondHistory."Line No." + 1
        ELSE
            NewLineNo := 1;

        BondHistory.INIT;
        BondHistory."Unit No." := BondNo;
        BondHistory."Line No." := NewLineNo;
        BondHistory.Description := Description;
        BondHistory."User ID" := USERID;
        BondHistory."Date(Today)" := GetDescription.GetDocomentDate;
        BondHistory."Date(Workdate)" := WORKDATE;
        BondHistory.Time := TIME;
        BondHistory."Entry Type" := EntryType;
        BondHistory."Entry No." := DocumentNo;
        BondHistory.INSERT;
    end;


    procedure InsertPrintLog(Description: Text[250]; BondNo: Code[20]; PrintingStatus: Option Printed,Reprinted,Duplicate,Assigned,Reassigned; ReportType: Option Acknowledgement,Certificate,Commission,"Debit Voucher Printed","Discharge Form")
    var
        EntryNo: Integer;
        BondPrintLog: Record "Unit Print Log";
    begin
        BondPrintLog.SETRANGE("Unit No.", BondNo);
        IF BondPrintLog.FINDLAST THEN
            EntryNo := BondPrintLog."Line No." + 1
        ELSE
            EntryNo := 1;

        BondPrintLog.INIT;
        BondPrintLog."Unit No." := BondNo;
        BondPrintLog."Report Type" := ReportType;
        BondPrintLog."Line No." := EntryNo;
        BondPrintLog."User ID" := USERID;
        BondPrintLog.Date := WORKDATE;
        BondPrintLog.Description := Description;
        BondPrintLog.Time := TIME;
        BondPrintLog."Printing Status" := PrintingStatus;
        BondPrintLog.INSERT;
    end;


    procedure UpdateAppPaymentEntries(AppNo: Code[20])
    var
        AppPaymentEntry: Record "Application Payment Entry";
        LApplication: Record Application;
    begin
        AppPaymentEntry.RESET;
        IF LApplication.GET(AppNo) THEN;
        AppPaymentEntry.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::Application);
        AppPaymentEntry.SETRANGE("Document No.", AppNo);
        IF AppPaymentEntry.FINDSET THEN
            REPEAT
                //AppPaymentEntry."Posted Document No." := LApplication."Posted Doc No.";
                AppPaymentEntry."Posted Document No." := PostedDocNo; //ALLETDK
                AppPaymentEntry.Posted := TRUE;
                AppPaymentEntry.MODIFY;
            UNTIL AppPaymentEntry.NEXT = 0;
    end;


    procedure Updateunitmaster(RecUnitMaster: Record "Unit Master")
    var
        Newunitmaster: Record "Unit Master";
        CompWiseAccount: Record "Company wise G/L Account";
    begin
        CompWiseAccount.RESET;
        CompWiseAccount.SETRANGE(CompWiseAccount."MSC Company", TRUE);
        IF CompWiseAccount.FINDFIRST THEN BEGIN
            Newunitmaster.RESET;
            Newunitmaster.CHANGECOMPANY(CompWiseAccount."Company Code");
            Newunitmaster.SETRANGE("Project Code", RecUnitMaster."Project Code");
            Newunitmaster.SETRANGE("No.", RecUnitMaster."No.");
            Newunitmaster.SETFILTER(Status, '<>%1', Newunitmaster.Status::Booked);
            IF Newunitmaster.FINDFIRST THEN BEGIN
                Newunitmaster."Total Value" := RecUnitMaster."Total Value";
                Newunitmaster."Min. Allotment Amount" := RecUnitMaster."Min. Allotment Amount";
                Newunitmaster."Web Portal Status" := RecUnitMaster."Web Portal Status";
                Newunitmaster.Reserve := RecUnitMaster.Reserve;
                Newunitmaster."Payment Plan" := RecUnitMaster."Payment Plan";
                Newunitmaster."Min. Allotment Amount" := RecUnitMaster."Min. Allotment Amount";
                Newunitmaster.Status := RecUnitMaster.Status;
                Newunitmaster.Freeze := RecUnitMaster.Freeze;
                Newunitmaster."No. of Plots" := RecUnitMaster."No. of Plots";
                Newunitmaster.Blocked := RecUnitMaster.Blocked;
                Newunitmaster.Facing := RecUnitMaster.Facing;
                Newunitmaster.MODIFY;
            END;
        END;
    end;


    procedure CheckVendStatus(VendCode: Code[20])
    var
        Vendor_1: Record Vendor;
    begin
        //BBG 090816
        RecVendCode := '';
        RecVendCode := VendCode;

        Vendor_1.RESET;
        Vendor_1.SETRANGE("No.", RecVendCode);
        IF Vendor_1.FINDFIRST THEN BEGIN
            IF Vendor_1."P.A.N. Status" <> Vendor_1."P.A.N. Status"::" " THEN
                // IF CONFIRM('This vendor has no PAN Number. Do you want continue?',TRUE) THEN BEGIN
                // END;
                MESSAGE('%1', 'This vendor has no PAN Number');
        END;
        //BBG 090816
    end;


    procedure CheckUnitPaymentPlan(ProjectCode: Code[20]; ApplicationNo: Code[20]; FromProjectChange: Boolean): Code[20]
    var
        NewApplicationBooking: Record "New Application Booking";
        NewConfirmedOrder: Record "New Confirmed Order";
        CommissionStructure: Record "Commission Structure";
        PostDate: Date;
        ConfirmedOrder: Record "Confirmed Order";
    begin
        PPLANCode := '';
        PostDate := 0D;
        NewApplicationBooking.RESET;
        NewApplicationBooking.SETRANGE("Application No.", ApplicationNo);
        IF NewApplicationBooking.FINDFIRST THEN BEGIN
            PPLANCode := NewApplicationBooking."Unit Payment Plan";
            PostDate := NewApplicationBooking."Posting Date";
        END;
        NewConfirmedOrder.RESET;
        NewConfirmedOrder.SETRANGE("No.", ApplicationNo);
        IF NewConfirmedOrder.FINDFIRST THEN BEGIN
            PPLANCode := NewConfirmedOrder."Unit Payment Plan";
            PostDate := NewConfirmedOrder."Posting Date";
        END;

        IF FromProjectChange THEN BEGIN
            ConfirmedOrder.RESET;
            ConfirmedOrder.SETRANGE("No.", ApplicationNo);
            IF ConfirmedOrder.FINDFIRST THEN BEGIN
                PPLANCode := ConfirmedOrder."New Unit Payment Plan";
            END;
        END;

        RecJob.RESET;
        IF RecJob.GET(ProjectCode) THEN BEGIN
            IF RecJob."New commission Str. Applicable" THEN BEGIN
                IF PostDate <= RecJob."New commission Str. StartDate" THEN
                    PPLANCode := '';
            END ELSE
                PPLANCode := '';
        END;

        EXIT(PPLANCode);
    end;
}

