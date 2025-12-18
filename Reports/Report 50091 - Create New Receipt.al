report 50091 "Create New Receipt"
{
    // version web

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Payment transaction Details"; "Payment transaction Details")
        {
            DataItemTableView = WHERE("Document Create In NAV" = CONST(false),
                                      "Payment Server Status" = FILTER('paid' | 'PAID'));//paid|PAID

            trigger OnAfterGetRecord()
            var
                NewConfirmedOrder: Record "New Confirmed Order";
                LineNo: Integer;
                UMaster: Record "Unit Master";
                OldNewApplicationBooking: Record "New Application Booking";
                CheckNewAppBooking: Record "New Application Booking";
                OldApplicationNo: Code[20];
                OldNewApplicationPayEntry: Record "NewApplication Payment Entry";
                NewReceiptPost: Record "New Application Booking";
                DocumentRec: Record Document;
            begin
                IF "Payment transaction Details"."Application Type" = "Payment transaction Details"."Application Type"::New THEN BEGIN
                    CheckNewAppBooking.RESET;
                    CheckNewAppBooking.SETCURRENTKEY("Unit Code");
                    CheckNewAppBooking.SETRANGE("Unit Code", "Payment transaction Details"."Plot ID");
                    IF CheckNewAppBooking.FINDFIRST THEN BEGIN
                        OldNewApplicationPayEntry.RESET;
                        OldNewApplicationPayEntry.SETRANGE("Document No.", CheckNewAppBooking."Application No.");
                        OldNewApplicationPayEntry.SETRANGE(Posted, FALSE);
                        OldNewApplicationPayEntry.SETRANGE(Amount, "Payment transaction Details"."Payment Amount");
                        IF "Payment transaction Details"."Payment ID" <> '' THEN
                            OldNewApplicationPayEntry.SETRANGE("Cheque No./ Transaction No.", "Payment transaction Details"."Payment ID")
                        ELSE
                            OldNewApplicationPayEntry.SETRANGE("Cheque No./ Transaction No.", "Payment transaction Details"."Unique Payment Order ID");
                        IF OldNewApplicationPayEntry.FINDFIRST THEN BEGIN
                            CLEAR(UnitPost);
                            NewReceiptPost.RESET;
                            IF NewReceiptPost.GET(OldNewApplicationPayEntry."Document No.") THEN;
                            UnitPost.PostNewReceipt(NewReceiptPost, TRUE);
                            COMMIT;
                            OldNewApplicationBooking.RESET;
                            IF OldNewApplicationBooking.GET(CheckNewAppBooking."Application No.") THEN
                                UnitPost.CreateNewConfOrder(OldNewApplicationBooking);
                        END ELSE BEGIN
                            //ALLEDK 190722 Start
                            CompanyInformation.RESET;
                            CompanyInformation.CHANGECOMPANY(CheckNewAppBooking."Company Name");
                            CompanyInformation.GET;
                            //ALLEDK 190722 END
                            NewApplicationPaymentEntry.INIT;
                            NewApplicationPaymentEntry."Document Type" := NewApplicationPaymentEntry."Document Type"::Application;
                            NewApplicationPaymentEntry."Document No." := CheckNewAppBooking."Application No.";
                            NewApplicationPaymentEntry."Line No." := 10000;
                            NewApplicationPaymentEntry.VALIDATE("Payment Mode", NewApplicationPaymentEntry."Payment Mode"::Bank);
                            NewApplicationPaymentEntry.VALIDATE("Payment Method", 'D.C./C.C.');
                            NewApplicationPaymentEntry.VALIDATE(Amount, "Payment transaction Details"."Payment Amount");
                            NewApplicationPaymentEntry.VALIDATE("Bank Type", NewApplicationPaymentEntry."Bank Type"::ProjectCompany);
                            NewApplicationPaymentEntry.VALIDATE("Deposit/Paid Bank", CompanyInformation."Online Bank Account No.");
                            IF "Payment transaction Details"."Payment ID" <> '' THEN
                                NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", "Payment transaction Details"."Payment ID")
                            ELSE
                                NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", "Payment transaction Details"."Unique Payment Order ID");
                            NewApplicationPaymentEntry.VALIDATE("Cheque Date", "Payment transaction Details"."Receipt Posting Date");
                            NewApplicationPaymentEntry.VALIDATE("Cheque Bank and Branch", 'Online');
                            NewApplicationPaymentEntry."Posting date" := "Payment transaction Details"."Receipt Posting Date";
                            NewApplicationPaymentEntry."Create from MSC Company" := TRUE;
                            NewApplicationPaymentEntry."Company Name" := CheckNewAppBooking."Company Name";
                            NewApplicationPaymentEntry."Document Date" := TODAY;
                            NewApplicationPaymentEntry."User ID" := USERID;
                            NewApplicationPaymentEntry.VALIDATE("Shortcut Dimension 1 Code", CheckNewAppBooking."Shortcut Dimension 1 Code");
                            NewApplicationPaymentEntry."Receipt Time" := TIME;
                            NewApplicationPaymentEntry.INSERT;

                            "Payment transaction Details"."Application No." := CheckNewAppBooking."Application No.";
                            CLEAR(UnitPost);
                            NewReceiptPost.RESET;
                            IF NewReceiptPost.GET(NewApplicationPaymentEntry."Document No.") THEN;
                            UnitPost.PostNewReceipt(NewReceiptPost, TRUE);
                            COMMIT;
                            OldNewApplicationBooking.RESET;
                            IF OldNewApplicationBooking.GET(CheckNewAppBooking."Application No.") THEN
                                UnitPost.CreateNewConfOrder(OldNewApplicationBooking);
                        END;
                    END ELSE BEGIN
                        UMaster.RESET;
                        IF UMaster.GET("Payment transaction Details"."Plot ID") THEN BEGIN
                            UMaster.Status := UMaster.Status::Open;
                            UMaster."Web Portal Status" := UMaster."Web Portal Status"::Available;
                            UMaster.Freeze := FALSE;
                            UMaster.MODIFY;
                            WebAppService.UpdateUnitStatus(UMaster);  //210624
                        END;

                        NewApplicationBooking.INIT;
                        NewApplicationBooking."Application Type" := NewApplicationBooking."Application Type"::"Non Trading";
                        NewApplicationBooking.Type := NewApplicationBooking.Type::Normal;
                        NewApplicationPaymentEntry."User ID" := USERID;
                        NewApplicationBooking.INSERT(TRUE);
                        NewApplicationBooking.VALIDATE("Shortcut Dimension 1 Code", "Payment transaction Details"."Project ID");
                        NewApplicationBooking.VALIDATE("Bill-to Customer Name", "Payment transaction Details"."Member Name");
                        NewApplicationBooking.VALIDATE("Member's D.O.B", "Payment transaction Details"."Date of Birth");
                        NewApplicationBooking.VALIDATE("Mobile No.", "Payment transaction Details"."Mobile No.");
                        NewApplicationBooking.VALIDATE("Associate Code", "Payment transaction Details"."Associate Id");
                        NewApplicationBooking.VALIDATE("Unit Payment Plan", "Payment transaction Details"."Unit Payment Plan");
                        NewApplicationBooking.VALIDATE("Unit Code", UMaster."No."); //,UMaster."No.");
                        IF "Payment transaction Details"."Loan File" = 'Yes' THEN Begin //251124
                            NewApplicationBooking."Loan File" := TRUE; //251124
                            NewApplicationBooking."New Loan File" := NewApplicationBooking."New Loan File"::Yes;
                        End;                                           //Code added start 23072025
                        NewApplicationBooking."Customer State Code" := "Payment transaction Details"."State Code";
                        NewApplicationBooking."District Code" := "Payment transaction Details"."District Code";
                        NewApplicationBooking."Mandal Code" := "Payment transaction Details"."Mandal Code";
                        NewApplicationBooking."Village Code" := "Payment transaction Details"."Village Code";
                        NewApplicationBooking."Aadhar No." := "Payment transaction Details"."Aadhaar No.";  //Code added 22082025
                        //Code added End 23072025
                        NewApplicationBooking.MODIFY;

                        //Code added Start 22082025
                        IF "Payment transaction Details"."Entry No." > 0 THEN BEGIN
                            DocumentRec.Reset();
                            DocumentRec.SetRange("Document Type", DocumentRec."Document Type"::Document);
                            DocumentRec.SetRange("Ref. Pmt Entry No.", "Payment transaction Details"."Entry No.");
                            If DocumentRec.FindSet() then
                                repeat
                                    DocumentRec."Document No." := NewApplicationBooking."Application No.";
                                    DocumentRec.Modify();
                                Until DocumentRec.Next = 0;
                        END;

                        //Code added End 22082025

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
                        NewApplicationPaymentEntry.VALIDATE(Amount, "Payment transaction Details"."Payment Amount");
                        NewApplicationPaymentEntry.VALIDATE("Bank Type", NewApplicationPaymentEntry."Bank Type"::ProjectCompany);
                        NewApplicationPaymentEntry.VALIDATE("Deposit/Paid Bank", CompanyInformation."Online Bank Account No.");
                        IF "Payment transaction Details"."Payment ID" <> '' THEN
                            NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", "Payment transaction Details"."Payment ID")
                        ELSE
                            NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", "Payment transaction Details"."Unique Payment Order ID");
                        NewApplicationPaymentEntry.VALIDATE("Cheque Date", "Payment transaction Details"."Receipt Posting Date");
                        NewApplicationPaymentEntry.VALIDATE("Cheque Bank and Branch", 'Online');
                        NewApplicationPaymentEntry."Posting date" := "Payment transaction Details"."Receipt Posting Date";
                        NewApplicationPaymentEntry."Create from MSC Company" := TRUE;
                        NewApplicationPaymentEntry."Company Name" := NewApplicationBooking."Company Name";
                        NewApplicationPaymentEntry."Receipt Time" := TIME;
                        NewApplicationPaymentEntry."Document Date" := TODAY;
                        NewApplicationPaymentEntry."User ID" := USERID;
                        NewApplicationPaymentEntry.VALIDATE("Shortcut Dimension 1 Code", NewApplicationBooking."Shortcut Dimension 1 Code");
                        NewApplicationPaymentEntry.INSERT;
                        "Payment transaction Details"."Application No." := NewApplicationBooking."Application No.";
                        CLEAR(UnitPost);
                        NewReceiptPost.RESET;
                        IF NewReceiptPost.GET(NewApplicationPaymentEntry."Document No.") THEN;
                        UnitPost.PostNewReceipt(NewReceiptPost, TRUE);
                        COMMIT;
                        OldNewApplicationBooking.RESET;
                        IF OldNewApplicationBooking.GET(NewApplicationBooking."Application No.") THEN
                            UnitPost.CreateNewConfOrder(OldNewApplicationBooking);
                    END;
                END ELSE BEGIN
                    NewConfirmedOrder.RESET;
                    IF NewConfirmedOrder.GET("Payment transaction Details"."Application No.") THEN BEGIN
                        LineNo := 0;
                        NewApplicationPaymentEntry.RESET;
                        NewApplicationPaymentEntry.SETRANGE("Document No.", "Application No.");
                        IF NewApplicationPaymentEntry.FINDLAST THEN
                            LineNo := NewApplicationPaymentEntry."Line No.";

                        CompanyInformation.RESET;
                        CompanyInformation.CHANGECOMPANY(NewConfirmedOrder."Company Name");
                        CompanyInformation.GET;
                        //    CompanyInformation.TESTFIELD("Job Madetory On MRN");

                        OldNewApplicationPayEntry.RESET;
                        OldNewApplicationPayEntry.SETRANGE("Document No.", NewConfirmedOrder."No.");
                        OldNewApplicationPayEntry.SETRANGE(Posted, FALSE);
                        OldNewApplicationPayEntry.SETRANGE(Amount, "Payment transaction Details"."Payment Amount");
                        IF "Payment transaction Details"."Payment ID" <> '' THEN
                            OldNewApplicationPayEntry.SETRANGE("Cheque No./ Transaction No.", "Payment transaction Details"."Payment ID")
                        ELSE
                            OldNewApplicationPayEntry.SETRANGE("Cheque No./ Transaction No.", "Payment transaction Details"."Unique Payment Order ID");
                        IF OldNewApplicationPayEntry.FINDFIRST THEN BEGIN
                            CLEAR(UnitPost);
                            UnitPost.PostConfirmedReceipt(NewConfirmedOrder, TRUE);
                        END ELSE BEGIN
                            NewApplicationPaymentEntry.INIT;
                            NewApplicationPaymentEntry."Document Type" := NewApplicationPaymentEntry."Document Type"::BOND;
                            NewApplicationPaymentEntry."Document No." := "Application No.";
                            NewApplicationPaymentEntry."Line No." := LineNo + 10000;
                            NewApplicationPaymentEntry.VALIDATE("Payment Mode", NewApplicationPaymentEntry."Payment Mode"::Bank);
                            NewApplicationPaymentEntry.VALIDATE(Amount, "Payment transaction Details"."Payment Amount");
                            NewApplicationPaymentEntry.VALIDATE("Payment Method", 'D.C./C.C.');
                            NewApplicationPaymentEntry.VALIDATE("Bank Type", NewApplicationPaymentEntry."Bank Type"::ProjectCompany);
                            NewApplicationPaymentEntry.VALIDATE("Deposit/Paid Bank", CompanyInformation."Online Bank Account No.");
                            IF "Payment transaction Details"."Payment ID" <> '' THEN
                                NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", "Payment transaction Details"."Payment ID")
                            ELSE
                                NewApplicationPaymentEntry.VALIDATE("Cheque No./ Transaction No.", "Payment transaction Details"."Unique Payment Order ID");
                            NewApplicationPaymentEntry.VALIDATE("Cheque Date", "Payment transaction Details"."Receipt Posting Date");
                            NewApplicationPaymentEntry.VALIDATE("Cheque Bank and Branch", 'Online');
                            NewApplicationPaymentEntry."Posting date" := "Payment transaction Details"."Receipt Posting Date";
                            NewApplicationPaymentEntry."Document Date" := TODAY;
                            NewApplicationPaymentEntry."Create from MSC Company" := TRUE;
                            NewApplicationPaymentEntry."Company Name" := NewConfirmedOrder."Company Name";
                            NewApplicationPaymentEntry."User ID" := USERID;
                            NewApplicationPaymentEntry.VALIDATE("Shortcut Dimension 1 Code", NewConfirmedOrder."Shortcut Dimension 1 Code");
                            NewApplicationPaymentEntry."Receipt Time" := TIME;
                            NewApplicationPaymentEntry.INSERT;
                            CLEAR(UnitPost);
                            UnitPost.PostConfirmedReceipt(NewConfirmedOrder, TRUE);
                        END;
                    END;
                END;

                "Document Create In NAV" := TRUE;
                MODIFY;
                COMMIT;
            end;

            trigger OnPreDataItem()
            var
                CompanywiseGLAccount: Record "Company wise G/L Account";
            begin
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        MESSAGE('%1', 'Process Done');
    end;

    trigger OnPreReport()
    var
        CompanywiseGLAccount: Record "Company wise G/L Account";
    begin
        //ALLEDK 091121
        CLEAR(GetPmtIDStatusfromServer_1);
        GetPmtIDStatusfromServer_1.RUN;
        //ALLEDK 091121

        CompanywiseGLAccount.RESET;
        CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
        IF CompanywiseGLAccount.FINDFIRST THEN
            IF COMPANYNAME <> CompanywiseGLAccount."Company Code" THEN
                ERROR('Run this batch from -' + CompanywiseGLAccount."Company Code");
    end;

    var
        NewApplicationBooking: Record "New Application Booking";
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        CompanyInformation: Record "Company Information";
        UnitPost: Codeunit "Unit Post";
        GetPmtIDStatusfromServer_1: Codeunit "Get Pmt ID Status fromServer_1";
        WebAppService: Codeunit "Web App Service";
}

