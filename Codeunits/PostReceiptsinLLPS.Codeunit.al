codeunit 50008 "Post Receipts in LLPS"
{
    // ALLEDK121222 Added new code

    TableNo = "NewApplication Payment Entry";

    trigger OnRun()
    begin
        PostReceipt(Rec);
    end;

    var
        AppPayEntry: Record "Application Payment Entry";
        Company: Record Company;
        Application: Record Application;
        NewConforder: Record "New Confirmed Order";
        Customer: Record Customer;
        AppRecord: Record Application;
        ConfRecord: Record "Confirmed Order";
        Conforder: Record "Confirmed Order";
        BondReversal: Codeunit "Unit Reversal";
        ReleaseBondApplication: Codeunit "Release Unit Application";
        ExistApplication: Record Application;
        ExistAppPayEntry: Record "Application Payment Entry";
        ExistConforder: Record "Confirmed Order";
        ExistRecord: Boolean;
        DelApplication: Record Application;
        SkipCreateConfOrder: Boolean;
        CreatUPEryfromConfOrder: Codeunit "Creat UPEry from ConfOrder/APP";
        PostPayment: Codeunit PostPayment;
        CompanyWiseAccount: Record "Company wise G/L Account";
        DocNo: Code[20];
        NewAppEntry: Record "NewApplication Payment Entry";
        RecNewConforder: Record "New Confirmed Order";
        PaymentTermsLineSale_2: Record "Payment Terms Line Sale";
        PLDetails: Record "Payment Plan Details";
        v_NewApplicationPaymentEntry_1: Record "NewApplication Payment Entry";
        AppPayEntry_1: Record "Application Payment Entry";


    procedure PostReceipt(P_NewApplicationPayEntry: Record "NewApplication Payment Entry")
    begin
        v_NewApplicationPaymentEntry_1.RESET;
        v_NewApplicationPaymentEntry_1.SETRANGE("Document No.", P_NewApplicationPayEntry."Document No.");
        v_NewApplicationPaymentEntry_1.SETRANGE("Line No.", P_NewApplicationPayEntry."Line No.");
        v_NewApplicationPaymentEntry_1.SETRANGE("Receipt post on InterComp", FALSE);
        IF v_NewApplicationPaymentEntry_1.FINDFIRST THEN BEGIN
            //ALLEDK121222 Start
            AppPayEntry_1.RESET;
            AppPayEntry_1.SETRANGE("Document No.", v_NewApplicationPaymentEntry_1."Document No.");
            AppPayEntry_1.SETRANGE("Receipt Line No.", v_NewApplicationPaymentEntry_1."Line No.");
            AppPayEntry_1.SETRANGE(Posted, TRUE);
            IF AppPayEntry_1.FINDFIRST THEN BEGIN
                //ERROR('App No.-'+FORMAT(v_NewApplicationPaymentEntry_1."Document No.")+'Line No. - '+FORMAT(v_NewApplicationPaymentEntry_1."Line No.")+' already Exists');
                v_NewApplicationPaymentEntry_1."Receipt post on InterComp" := TRUE;
                v_NewApplicationPaymentEntry_1."Receipt post InterComp Date" := TODAY;
                v_NewApplicationPaymentEntry_1.MODIFY;
            END;
            AppPayEntry_1.RESET;
            AppPayEntry_1.SETRANGE("Document No.", v_NewApplicationPaymentEntry_1."Document No.");
            AppPayEntry_1.SETRANGE("Receipt Line No.", v_NewApplicationPaymentEntry_1."Line No.");
            AppPayEntry_1.SETRANGE(Posted, FALSE);
            IF AppPayEntry_1.FINDFIRST THEN
                AppPayEntry_1.DELETE;

            //ALLEDK121222 END
            NewAppEntry.RESET;
            NewAppEntry.SETRANGE("Document No.", v_NewApplicationPaymentEntry_1."Document No.");
            NewAppEntry.SETRANGE("Line No.", v_NewApplicationPaymentEntry_1."Line No.");
            NewAppEntry.SETRANGE("Receipt post on InterComp", FALSE);
            IF NewAppEntry.FINDFIRST THEN BEGIN
                AppPayEntry.RESET;
                AppPayEntry.SETRANGE("Document No.", v_NewApplicationPaymentEntry_1."Document No.");
                IF AppPayEntry.FINDLAST THEN BEGIN
                    ExistConforder.RESET;
                    ExistConforder.SETRANGE("No.", v_NewApplicationPaymentEntry_1."Document No.");
                    IF ExistConforder.FINDFIRST THEN
                        CreateReceiptEntry(v_NewApplicationPaymentEntry_1, AppPayEntry."Line No.")
                    ELSE
                        CreateConforder(v_NewApplicationPaymentEntry_1);
                    v_NewApplicationPaymentEntry_1."Receipt post on InterComp" := TRUE;
                    v_NewApplicationPaymentEntry_1."Receipt post InterComp Date" := TODAY;
                    v_NewApplicationPaymentEntry_1.MODIFY;

                END ELSE BEGIN
                    CreateConforder(v_NewApplicationPaymentEntry_1);
                    v_NewApplicationPaymentEntry_1."Receipt post on InterComp" := TRUE;
                    v_NewApplicationPaymentEntry_1."Receipt post InterComp Date" := TODAY;
                    v_NewApplicationPaymentEntry_1.MODIFY;
                END;
            END;
        END;
    end;


    procedure CreateConforder(NewAppPayEntry: Record "NewApplication Payment Entry")
    var
        NewCust: Record Customer;
    begin
        ExistRecord := FALSE;
        IF NewConforder.GET(NewAppPayEntry."Document No.") THEN;
        Application.RESET;
        Customer.RESET;
        IF NOT Customer.GET(NewConforder."Customer No.") THEN BEGIN
            CompanyWiseAccount.RESET;
            CompanyWiseAccount.SETRANGE("MSC Company", TRUE);
            IF CompanyWiseAccount.FINDFIRST THEN;
            NewCust.RESET;
            NewCust.CHANGECOMPANY(CompanyWiseAccount."Company Code");
            IF NewCust.GET(NewConforder."Customer No.") THEN BEGIN
                Customer.INIT;
                Customer.TRANSFERFIELDS(NewCust);
                Customer.INSERT;
            END;
            //Code added Start 23072025
        END ELSE begin
            IF Customer.GET(NewConforder."Customer No.") THEN BEGIN
                Customer."State Code" := NewConforder."Customer State Code";
                Customer."District Code" := NewConforder."District Code";
                Customer."Mandal Code" := NewConforder."Mandal Code";
                Customer."Village Code" := NewConforder."Village Code";
                Customer.Modify();
            END;

        end;
        //Code added END 23072025

        ExistApplication.RESET;
        ExistApplication.SETRANGE("Application No.", NewAppPayEntry."Document No.");
        IF NOT ExistApplication.FINDFIRST THEN BEGIN
            ExistRecord := TRUE;
            PLDetails.RESET;
            PLDetails.SETCURRENTKEY("Document No.");
            PLDetails.SETRANGE("Document No.", NewAppPayEntry."Document No.");
            IF PLDetails.FINDSET THEN
                REPEAT
                    PLDetails.DELETE;
                UNTIL PLDetails.NEXT = 0;
            Application.INIT;
            Application."Application No." := NewAppPayEntry."Document No.";
            Application."Investment Type" := Application."Investment Type"::FD;
            Application.INSERT;
            Application.VALIDATE(Type, NewConforder.Type);
            Application.VALIDATE("Shortcut Dimension 1 Code", NewConforder."Shortcut Dimension 1 Code");
            Application."Unit Payment Plan" := NewConforder."Unit Payment Plan";
            Application."Unit Plan Name" := NewConforder."Unit Plan Name";
            Application."Rank Code" := NewConforder."Region Code";  //Code added 01072025
            Application."Travel applicable" := NewConforder."Travel applicable";   //Code added 01072025
            Application."Registration Bouns (BSP2)" := NewConforder."Registration Bouns (BSP2)";   //Code added 01072025

            Application.VALIDATE("Customer No.", NewConforder."Customer No.");
            Application.VALIDATE("Posting Date", NewConforder."Posting Date");
            Application.VALIDATE("Document Date", NewConforder."Document Date");
            Application.VALIDATE("Associate Code", NewConforder."Introducer Code");
            Application.VALIDATE("Unit Code", NewConforder."Unit Code");
            Application.VALIDATE("Pass Book No.", NewConforder."Application No.");
            Application."Company Name" := NewAppPayEntry."Company Name";
            Application."User ID" := NewConforder."User Id";
            Application."Registration Bonus Hold(BSP2)" := TRUE;
            Application."Application Type" := NewConforder."Application Type";
            Application."Development Charges" := NewConforder."Development Charges";
            Application."Min. Allotment Amount" := NewConforder."Min. Allotment Amount";  //281221
                                                                                          //Code added Start 23072025
            Application."District Code" := NewConforder."District Code";
            Application."Customer State Code" := NewConforder."Customer State Code";
            Application."Mandal Code" := NewConforder."Mandal Code";
            Application."Village Code" := NewConforder."Village Code";
            Application."New Loan File" := NewConforder."New Loan File";//Ankur
            //Code added END 23072025

            Application.MODIFY;
        END;
        ExistAppPayEntry.RESET;
        ExistAppPayEntry.SETRANGE("Document No.", NewAppPayEntry."Document No.");
        IF NOT ExistAppPayEntry.FINDFIRST THEN BEGIN
            CLEAR(AppPayEntry);
            AppPayEntry.RESET;
            AppPayEntry.INIT;
            AppPayEntry."Document Type" := AppPayEntry."Document Type"::Application;
            AppPayEntry."Document No." := NewAppPayEntry."Document No.";
            AppPayEntry."Line No." := NewAppPayEntry."Line No.";
            AppPayEntry.Type := AppPayEntry.Type::Received;
            AppPayEntry.INSERT;
            AppPayEntry.VALIDATE("Payment Mode", NewAppPayEntry."Payment Mode");
            AppPayEntry."Payment Method" := NewAppPayEntry."Payment Method";
            AppPayEntry.Description := NewAppPayEntry.Description;
            AppPayEntry."Cheque No./ Transaction No." := NewAppPayEntry."Cheque No./ Transaction No.";
            AppPayEntry."Cheque Date" := NewAppPayEntry."Cheque Date";
            AppPayEntry."Cheque Bank and Branch" := NewAppPayEntry."Cheque Bank and Branch";
            IF v_NewApplicationPaymentEntry_1."Bank Type" <> v_NewApplicationPaymentEntry_1."Bank Type"::ProjectCompany THEN BEGIN
                AppPayEntry."MSC Bank Code" := NewAppPayEntry."Deposit/Paid Bank";
            END ELSE
                AppPayEntry."Deposit/Paid Bank" := NewAppPayEntry."Deposit/Paid Bank";
            //  AppPayEntry."Cheque Status" := NewAppPayEntry."Cheque Status";
            //AppPayEntry."User Branch Code" := NewAppPayEntry."User Branch Code";
            AppPayEntry.VALIDATE(Amount, NewAppPayEntry.Amount);
            AppPayEntry.VALIDATE("Posting date", NewAppPayEntry."Posting date");
            AppPayEntry.VALIDATE("Document Date", NewAppPayEntry."Posting date");
            AppPayEntry.VALIDATE("Shortcut Dimension 1 Code", NewConforder."Shortcut Dimension 1 Code");
            AppPayEntry."MSC Post Doc. No." := NewAppPayEntry."Posted Document No.";
            AppPayEntry."Reverse Commission" := NewAppPayEntry."Commmission Reverse";
            AppPayEntry."Application No." := NewAppPayEntry."Document No.";
            AppPayEntry."Bank Type" := NewAppPayEntry."Bank Type";
            AppPayEntry."Commission Reversed" := NewAppPayEntry."Commmission Reverse";  //ALLE240415
            AppPayEntry."User ID" := NewAppPayEntry."User ID";
            AppPayEntry."Entry From MSC" := TRUE;
            AppPayEntry.Narration := NewAppPayEntry.Narration;
            AppPayEntry."Receipt Line No." := NewAppPayEntry."Line No."; //ALLEDK 10112016
            AppPayEntry."LD Amount" := NewAppPayEntry."LD Amount";
            AppPayEntry."User Branch Code" := NewAppPayEntry."User Branch Code";
            AppPayEntry."User Branch Name" := NewAppPayEntry."User Branch Name";
            AppPayEntry.MODIFY;
        END;

        IF ExistRecord THEN BEGIN
            IF v_NewApplicationPaymentEntry_1."Bank Type" <> v_NewApplicationPaymentEntry_1."Bank Type"::ProjectCompany THEN
                AppRecord.ReleaseRcpt(Application)
            ELSE
                ReleaseBondApplication.ReleaseApplication(Application, FALSE);
            AppRecord.CreateConOrder(Application);
        END ELSE BEGIN
            IF v_NewApplicationPaymentEntry_1."Bank Type" <> v_NewApplicationPaymentEntry_1."Bank Type"::ProjectCompany THEN
                AppRecord.ReleaseRcpt(ExistApplication)
            ELSE
                ReleaseBondApplication.ReleaseApplication(ExistApplication, FALSE);
            AppRecord.CreateConOrder(ExistApplication);
        END;

        DelApplication.RESET;
        DelApplication.SETRANGE("Application No.", Application."Application No.");
        IF DelApplication.FINDFIRST THEN
            DelApplication.DELETE;
    end;


    procedure CreateReceiptEntry(NewApplPayEntry: Record "NewApplication Payment Entry"; LineNo: Integer)
    var
        ExcessAmount: Decimal;
    begin
        CLEAR(Conforder);
        IF Conforder.GET(NewApplPayEntry."Document No.") THEN;
        CLEAR(AppPayEntry);
        AppPayEntry.RESET;
        AppPayEntry.INIT;
        AppPayEntry."Document Type" := NewApplPayEntry."Document Type"::BOND;
        AppPayEntry."Document No." := NewApplPayEntry."Document No.";
        AppPayEntry."Line No." := LineNo + 10000;
        AppPayEntry.INSERT;
        AppPayEntry."Adjmt. Line No." := NewApplPayEntry."Adjmt. Line No.";
        AppPayEntry.VALIDATE("Payment Mode", NewApplPayEntry."Payment Mode");
        AppPayEntry.VALIDATE("Payment Method", NewApplPayEntry."Payment Method");
        AppPayEntry.Description := NewApplPayEntry.Description;
        AppPayEntry."Cheque No./ Transaction No." := NewApplPayEntry."Cheque No./ Transaction No.";
        AppPayEntry."Cheque Date" := NewApplPayEntry."Cheque Date";
        AppPayEntry."Cheque Bank and Branch" := NewApplPayEntry."Cheque Bank and Branch";

        //AppPayEntry."Cheque Status" := NewApplPayEntry."Cheque Status";
        IF v_NewApplicationPaymentEntry_1."Bank Type" <> v_NewApplicationPaymentEntry_1."Bank Type"::ProjectCompany THEN BEGIN
            AppPayEntry."MSC Bank Code" := NewApplPayEntry."Deposit/Paid Bank";
        END ELSE
            AppPayEntry."Deposit/Paid Bank" := NewApplPayEntry."Deposit/Paid Bank";

        AppPayEntry."User Branch Code" := NewApplPayEntry."User Branch Code";
        AppPayEntry."Bank Type" := NewApplPayEntry."Bank Type";
        IF (NewApplPayEntry."Payment Mode" = NewApplPayEntry."Payment Mode"::"Negative Adjmt.") THEN
            AppPayEntry.VALIDATE(Amount, NewApplPayEntry.Amount)
        ELSE
            AppPayEntry.VALIDATE(Amount, ABS(NewApplPayEntry.Amount));
        AppPayEntry.VALIDATE("Posting date", NewApplPayEntry."Posting date");
        AppPayEntry.VALIDATE("Document Date", NewApplPayEntry."Posting date");
        AppPayEntry.VALIDATE("Shortcut Dimension 1 Code", Conforder."Shortcut Dimension 1 Code");
        AppPayEntry."MSC Post Doc. No." := NewApplPayEntry."Posted Document No.";
        AppPayEntry."Reverse Commission" := NewApplPayEntry."Commmission Reverse";
        AppPayEntry."Application No." := NewApplPayEntry."Document No.";
        AppPayEntry."User ID" := NewApplPayEntry."User ID";
        AppPayEntry."Commission Reversed" := NewApplPayEntry."Commmission Reverse";  //ALLE240415
        AppPayEntry."Entry From MSC" := TRUE;
        AppPayEntry.Narration := NewApplPayEntry.Narration;
        AppPayEntry."LD Amount" := NewApplPayEntry."LD Amount";
        AppPayEntry."Receipt Line No." := NewApplPayEntry."Line No."; //ALLEDK 10112016
        AppPayEntry."User Branch Code" := NewApplPayEntry."User Branch Code";
        AppPayEntry."User Branch Name" := NewApplPayEntry."User Branch Name";
        AppPayEntry.MODIFY;



        IF (v_NewApplicationPaymentEntry_1."Bank Type" <> v_NewApplicationPaymentEntry_1."Bank Type"::ProjectCompany) THEN BEGIN
            IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Cash) OR
                                       (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Bank) THEN
                ConfRecord.PostReceipt(Conforder);

            IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Cash") OR
                                       (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Bank") OR
                                       (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Negative Adjmt.") THEN BEGIN

                RecNewConforder.RESET;
                RecNewConforder.GET(NewApplPayEntry."Document No.");
                Conforder."Incl. Mem. Fee" := RecNewConforder."Incl. Mem. Fee";
                Conforder.MODIFY;
                RecNewConforder."Incl. Mem. Fee" := FALSE;
                RecNewConforder.MODIFY;
                BondReversal.BondReverse(NewApplPayEntry."Document No.", NewApplPayEntry."Commmission Reverse", 0, TRUE);
            END;
        END ELSE BEGIN
            IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Cash) OR
                                       (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Bank) THEN BEGIN

                CLEAR(ExcessAmount);
                ExcessAmount := CreatUPEryfromConfOrder.CheckExcessAmount(Conforder);
                IF ExcessAmount <> 0 THEN
                    CreatUPEryfromConfOrder.CreateExcessPaymentTermsLine(Conforder."No.", ExcessAmount);
                CreatUPEryfromConfOrder.RUN(Conforder);
                PostPayment.PostBondPayment(Conforder, FALSE);
            END;
            IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Cash") OR
                                       (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Bank") OR
                                       (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Negative Adjmt.") THEN BEGIN
                RecNewConforder.RESET;
                RecNewConforder.GET(NewApplPayEntry."Document No.");
                Conforder."Incl. Mem. Fee" := RecNewConforder."Incl. Mem. Fee";
                Conforder.MODIFY;
                RecNewConforder."Incl. Mem. Fee" := FALSE;
                RecNewConforder.MODIFY;

                BondReversal.BondReverse(NewApplPayEntry."Document No.", NewApplPayEntry."Commmission Reverse", 0, FALSE);
            END;
        END;
    end;
}

