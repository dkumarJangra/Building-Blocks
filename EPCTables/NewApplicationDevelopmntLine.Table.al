table 50051 "New Application DevelopmntLine"
{
    // ALLEDK 101012 Added code for Bank Name
    // // BBG1.01_NB 191012: Add additonal option of D.C./C.C/ Net Banking in Payment Mode.
    // ALLEPG 221012 : Code modify for cheque date.
    // ALLETDK081112...Added "Posted","Cheque Status" fields to Key "Document Type","Application No."
    // ALLETDK061212..Added new option "Refund Cash" and "Refund Cheque" in "Pyament Mode" field
    // AD230213:BBG1.00 CODE COMMENTED: NOT REQUIRED IN BBG
    //  ADCOMMENTED280313
    // ALLEDK 2.01 (This code is used to identify the object used for Refund Cheque related objects)

    Caption = 'Application Development Line';
    DataPerCompany = false;
    DrillDownPageID = "New Appl Payment Entry List";
    LookupPageID = "New Appl Payment Entry List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Application,RD,FD,MIS,BOND';
            OptionMembers = Application,RD,FD,MIS,BOND;
        }
        field(2; "Document No."; Code[20])
        {
            Editable = false;
            TableRelation = IF ("Document Type" = CONST(BOND)) "New Confirmed Order" WHERE("No." = FIELD("Document No."));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = true;
        }
        field(4; "Unit Code"; Code[20])
        {
            Caption = 'Unit Code';
            TableRelation = "Unit Master";
        }
        field(5; "Payment Method"; Code[10])
        {
            Caption = 'Payment Method';
            NotBlank = true;

            trigger OnLookup()
            begin
                //ALLEDK 190113
                IF ("Payment Mode" = "Payment Mode"::Cash) OR ("Payment Mode" = "Payment Mode"::"Refund Cash") OR
                ("Payment Mode" = "Payment Mode"::MJVM) THEN BEGIN
                    RecPaymentMethod.RESET;
                    RecPaymentMethod.SETRANGE("Payment Method Type", RecPaymentMethod."Payment Method Type"::Cash);
                    IF RecPaymentMethod.FINDFIRST THEN BEGIN
                        IF PAGE.RUNMODAL(Page::"Payment Methods New", RecPaymentMethod) = ACTION::LookupOK THEN
                            VALIDATE("Payment Method", RecPaymentMethod.Code);
                    END;
                END ELSE
                    IF ("Payment Mode" = "Payment Mode"::Bank) OR ("Payment Mode" = "Payment Mode"::"Refund Bank") THEN BEGIN
                        RecPaymentMethod.RESET;
                        RecPaymentMethod.SETRANGE("Payment Method Type", RecPaymentMethod."Payment Method Type"::Bank);
                        IF RecPaymentMethod.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Payment Methods New", RecPaymentMethod) = ACTION::LookupOK THEN
                                VALIDATE("Payment Method", RecPaymentMethod.Code);
                        END;
                    END;
                //ALLEDK 190113
            end;

            trigger OnValidate()
            begin
                IF PaymentMethod.GET("Payment Method") THEN BEGIN
                    IF ("Payment Mode" <> "Payment Mode"::"Refund Cash") AND ("Payment Mode" <> "Payment Mode"::"Refund Bank") THEN //ALLETDK
                        Description := PaymentMethod.Description;
                END;
            end;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            var
                AdjmtAmt: Decimal;
                v_NewConfirmedOrder: Record "New Confirmed Order";
            begin
                "Bank Type" := "Bank Type"::VeritaCompany; //100919

                TESTFIELD("Payment Mode");  //220713

                IF ("Payment Mode" IN ["Payment Mode"::"Refund Cash", "Payment Mode"::"Refund Bank"]) THEN BEGIN
                    Amount := -1 * Amount;
                END;

                IF ("Payment Mode" IN ["Payment Mode"::"Refund Cash", "Payment Mode"::"Refund Bank",
                "Payment Mode"::"Negative Adjmt."]) AND (Amount > 0) THEN
                    ERROR('Amount must be Negative for Adjustments/Refunds');

                IF NOT ("Payment Mode" IN ["Payment Mode"::"Refund Cash", "Payment Mode"::"Refund Bank",
                  "Payment Mode"::"Negative Adjmt.", "Payment Mode"::JV]) AND (Amount < 0) THEN
                    ERROR('Amount must be Positive');

                v_NewConfirmedOrder.GET("Document No.");  //031120
                //v_NewConfirmedOrder.TESTFIELD("Development Company Name");
                //"Development Company Name" := v_NewConfirmedOrder."Development Company Name";
            end;
        }
        field(8; "Cheque No./ Transaction No."; Code[20])
        {

            trigger OnValidate()
            begin
                AppPayEntry.RESET;
                AppPayEntry.SETRANGE("Document No.", "Document No.");
                AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                AppPayEntry.SETRANGE("Cheque No./ Transaction No.", "Cheque No./ Transaction No.");
                IF AppPayEntry.FINDFIRST THEN
                    IF "Cheque No./ Transaction No." <> '' THEN
                        ERROR('Cheque No. %1 already exist', "Cheque No./ Transaction No.");

                IF NOT Posted THEN
                    "Cheque No.1" := "Cheque No./ Transaction No.";
            end;
        }
        field(9; "Cheque Date"; Date)
        {

            trigger OnValidate()
            var
                Application: Record "New Application Booking";
                BondSetup: Record "Unit Setup";
            begin
                BondSetup.GET;
                IF (("Cheque Date" > CALCDATE(BondSetup."Ch. Dt. After Days", WORKDATE))
                OR ("Cheque Date" < CALCDATE(BondSetup."Cheque Date Validity", WORKDATE))) THEN
                    ERROR(Text0002);
            end;
        }
        field(10; "Cheque Bank and Branch"; Text[50])
        {

            trigger OnValidate()
            begin
                "Cheque Bank and Branch" := UPPERCASE("Cheque Bank and Branch");
            end;
        }
        field(12; "Cheque Status"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Cleared,Bounced,Cancelled';
            OptionMembers = " ",Cleared,Bounced,Cancelled;
        }
        field(13; "Chq. Cl / Bounce Dt."; Date)
        {
        }
        field(14; "Application No."; Code[20])
        {
            Caption = 'Application No.';
        }
        field(15; "Payment Mode"; Option)
        {
            Caption = 'Payment Mode';
            OptionCaption = ' ,Cash,Bank,D.D.,MJVM,D.C./C.C./Net Banking,Refund Cash,Refund Bank,AJVM,Debit Note,JV,Negative Adjmt.';
            OptionMembers = " ",Cash,Bank,"D.D.",MJVM,"D.C./C.C./Net Banking","Refund Cash","Refund Bank",AJVM,"Debit Note",JV,"Negative Adjmt.";

            trigger OnValidate()
            begin
                IF ("Payment Mode" <> "Payment Mode"::"Refund Bank") AND ("Payment Mode" <> "Payment Mode"::MJVM) THEN BEGIN
                    CompanywiseGl.RESET;
                    CompanywiseGl.SETRANGE(CompanywiseGl."MSC Company", TRUE);
                    IF CompanywiseGl.FINDFIRST THEN BEGIN
                        IF COMPANYNAME <> CompanywiseGl."Company Code" THEN
                            ERROR('Receipt create from Master Company');
                    END;
                END;

                //"Bank Type" := "Bank Type"::ProjectCompany; //100919


                BondSetup.GET;
                BondSetup.TESTFIELD("Cash A/c No.");
                BondSetup.TESTFIELD("Cheque in Hand");
                BondSetup.TESTFIELD("DD in Hand");
                // BBG1.01 191012 START
                BondSetup.TESTFIELD("D.C./C.C./Net Banking A/c No.");
                // BBG1.01 191012 END

                IF ("Payment Mode" <> "Payment Mode"::Bank) AND ("Payment Mode" <> "Payment Mode"::"Refund Bank") THEN  //1208
                    "Cheque Status" := "Cheque Status"::Cleared
                ELSE
                    "Cheque Status" := "Cheque Status"::" ";

                IF "Payment Mode" = "Payment Mode"::Cash THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", AppPayEntry."Payment Mode"::Cash);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Payment Mode CASH already exist');
                END;

                IF ("Payment Mode" IN [1, 2, 3]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", 4, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines Of ' + FORMAT(AppPayEntry."Payment Mode"));
                END;

                //ALLEDK 140213
                IF ("Payment Mode" IN [8]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines of ' + FORMAT(AppPayEntry."Payment Mode"));
                END;

                IF ("Payment Mode" IN [4]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines of ' + FORMAT(AppPayEntry."Payment Mode"));
                END;

                IF ("Payment Mode" IN [6]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines Of ' + FORMAT(AppPayEntry."Payment Mode"));
                END;

                IF ("Payment Mode" IN [7]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines Of ' + FORMAT(AppPayEntry."Payment Mode"));
                END;

                IF ("Payment Mode" IN [11]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    //AppPayEntry.SETRANGE("Payment Mode",AppPayEntry."Payment Mode"::"Negative Adjmt.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines Of ' + FORMAT(AppPayEntry."Payment Mode"));
                END;

                IF ("Payment Mode" IN [10]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    //AppPayEntry.SETRANGE("Payment Mode",AppPayEntry."Payment Mode"::"Negative Adjmt.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines Of ' + FORMAT(AppPayEntry."Payment Mode"));
                END;

                IF ("Payment Mode" IN [11]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", AppPayEntry."Payment Mode"::"Negative Adjmt.");
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Adjustment Entry already exist ' + FORMAT(AppPayEntry."Payment Mode"));
                END;

                UserSetup.GET(USERID);
                UserSetup.TESTFIELD("User Branch");
                "User Branch Code" := UserSetup."User Branch";
                IF Loc.GET("User Branch Code") THEN
                    "User Branch Name" := Loc.Name
                ELSE
                    CLEAR("User Branch Name");



                IF "Payment Mode" = "Payment Mode"::Cash THEN BEGIN
                    RecPaymentMethod.RESET;
                    RecPaymentMethod.SETRANGE("Payment Method Type", RecPaymentMethod."Payment Method Type"::Cash);
                    IF NOT RecPaymentMethod.FINDFIRST THEN
                        ERROR('Create Payment Method for CASH')
                    ELSE
                        VALIDATE("Payment Method", RecPaymentMethod.Code);
                END;

                //"Bank Type" := "Bank Type"::ProjectCompany;
            end;
        }
        field(17; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(18; "Installment No."; Integer)
        {
        }
        field(19; "Deposit/Paid Bank"; Code[20])
        {

            trigger OnLookup()
            var
                RecConfOrder: Record "New Confirmed Order";
                RecApplication: Record "New Application Booking";
                CompName: Text[30];
                Company_1: Record "Company wise G/L Account";
                CompanyInformation: Record "Company Information";
            begin
                CompName := '';
                IF "Bank Type" <> "Bank Type"::ProjectCompany THEN BEGIN
                    IF RecConfOrder.GET("Document No.") THEN BEGIN
                        //IF RecConfOrder."Development Company Name" = '' THEN BEGIN
                        CompanyInformation.RESET;
                        CompanyInformation.CHANGECOMPANY(RecConfOrder."Company Name");
                        //    IF CompanyInformation.GET THEN
                        //CompanyInformation.TESTFIELD("Development Company Name");
                        //CompName := CompanyInformation."Development Company Name";
                        // END ELSE
                        // CompName := RecConfOrder."Development Company Name";
                    END;
                END ELSE IF RecConfOrder.GET("Document No.") THEN
                        CompName := RecConfOrder."Company Name";


                UserSetup.GET(USERID);
                IF ("Payment Mode" = "Payment Mode"::"Refund Bank") THEN BEGIN

                    CreditVoucherAccount.RESET;
                    CreditVoucherAccount.CHANGECOMPANY(CompName);
                    CreditVoucherAccount.SETRANGE("Account Type", CreditVoucherAccount."Account Type"::"Bank Account");
                    CreditVoucherAccount.SETFILTER("ARM Account Type", '%1|%2', CreditVoucherAccount."ARM Account Type"::Collection,
                    CreditVoucherAccount."ARM Account Type"::Both);
                    CreditVoucherAccount.SETRANGE("Bank Filter for Main Comp", TRUE);
                    CreditVoucherAccount.SETRANGE(Type, CreditVoucherAccount.Type::"Bank Payment Voucher");
                    IF CreditVoucherAccount.FINDFIRST THEN BEGIN
                        IF PAGE.RUNMODAL(Page::"Voucher Posting Credit Account", CreditVoucherAccount) = ACTION::LookupOK THEN BEGIN
                            BankACC.CHANGECOMPANY(CompName);
                            "Deposit/Paid Bank" := CreditVoucherAccount."Account No.";
                            IF BankACC.GET(CreditVoucherAccount."Account No.") THEN BEGIN
                                BankACC.TESTFIELD(Blocked, FALSE);
                                "Deposit / Paid Bank Name" := BankACC.Name;
                            END ELSE
                                "Deposit / Paid Bank Name" := '';
                        END;


                    END;
                    //Need to check the code in UAT
                END;

                IF ("Payment Mode" = "Payment Mode"::Bank) THEN BEGIN

                    DebitVoucherAccount.RESET;
                    DebitVoucherAccount.CHANGECOMPANY(CompName);
                    DebitVoucherAccount.SETRANGE("Account Type", DebitVoucherAccount."Account Type"::"Bank Account");
                    DebitVoucherAccount.SETFILTER("ARM Account Type", '%1|%2', DebitVoucherAccount."ARM Account Type"::Collection,
                    DebitVoucherAccount."ARM Account Type"::Both);
                    DebitVoucherAccount.SETRANGE("Bank Filter for Main Comp", TRUE);
                    DebitVoucherAccount.SETRANGE(Type, DebitVoucherAccount.Type::"Bank Receipt Voucher");
                    IF DebitVoucherAccount.FINDFIRST THEN BEGIN
                        IF PAGE.RUNMODAL(Page::"Voucher Posting Debit Accounts", DebitVoucherAccount) = ACTION::LookupOK THEN BEGIN
                            "Deposit/Paid Bank" := DebitVoucherAccount."Account No.";
                            BankACC.CHANGECOMPANY(CompName);
                            IF BankACC.GET(DebitVoucherAccount."Account No.") THEN BEGIN
                                BankACC.TESTFIELD(Blocked, FALSE);
                                "Deposit / Paid Bank Name" := BankACC.Name;
                            END ELSE
                                "Deposit / Paid Bank Name" := '';
                        END;
                    END;
                    //Need to check the code in UAT
                END;
            end;

            trigger OnValidate()
            var
                NewConfOrder: Record "New Confirmed Order";
            begin

                TESTFIELD("Bank Type");
                IF "Document Type" IN ["Document Type"::Application, "Document Type"::RD] THEN BEGIN
                    GetUserSetup;
                    UserSetup.TESTFIELD("Responsibility Center");
                    GetGLSetup;
                    GLSetup.TESTFIELD("Global Dimension 1 Code");
                END;



                //ALLEDK 101012
                IF BankAccount.GET("Deposit/Paid Bank") THEN
                    "Deposit / Paid Bank Name" := BankAccount.Name
                ELSE
                    "Deposit / Paid Bank Name" := '';
                //ALLEDK 101012
                BankAccount.TESTFIELD("Bank Acc. Posting Group"); //ALLETDK
            end;
        }
        field(22; "Posted Document No."; Code[20])
        {
        }
        field(23; Type; Option)
        {
            Editable = false;
            OptionCaption = ' ,Received,Interest,Principal,Interest + Principal';
            OptionMembers = " ",Received,Interest,Principal,"Interest + Principal";
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(26; "Document Date"; Date)
        {
        }
        field(27; "Posting date"; Date)
        {
            Caption = 'Posting Date';
            Editable = true;
        }
        field(32; "Explode BOM"; Boolean)
        {
            Editable = true;
        }
        field(34; "Order Ref No."; Code[20])
        {

            trigger OnLookup()
            var
                RecConfOrder_1: Record "Confirmed Order";
            begin
                IF "Payment Mode" = "Payment Mode"::MJVM THEN
                    IF RecConfOrder_1.GET("Document No.") THEN BEGIN
                        RecConfOrder_1.RESET;
                        RecConfOrder_1.SETFILTER("No.", '<>%1', "Document No.");
                        RecConfOrder_1.SETFILTER(Status, '%1|%2', RecConfOrder_1.Status::Open, RecConfOrder_1.Status::Vacate);
                        IF RecConfOrder_1.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Unit List", RecConfOrder_1) = ACTION::LookupOK THEN
                                VALIDATE("Order Ref No.", RecConfOrder_1."No.");
                        END;
                    END;
            end;

            trigger OnValidate()
            var
                RecConfOrder_1: Record "Confirmed Order";
                RecConfirmOrder_1: Record "Confirmed Order";
                NewconfOrder_1: Record "New Confirmed Order";
            begin
                IF "Order Ref No." = "Document No." THEN
                    ERROR('This Order Ref No. must be different to Confirmed Order No.');

                IF RecConfOrder_1.GET("Document No.") THEN;

                IF RecConfirmOrder_1.GET("Order Ref No.") THEN BEGIN
                    IF RecConfirmOrder_1.Status = RecConfirmOrder_1.Status::Cancelled THEN
                        ERROR('The Transfer From Appl. No. status is Cancelled. Select another App. No.');
                    RecConfirmOrder_1.TESTFIELD("Application Closed", FALSE);
                END;
            end;
        }
        field(36; "User Branch Code"; Code[20])
        {
            TableRelation = Location WHERE("BBG Branch" = CONST(true));
        }
        field(50001; "Deposit / Paid Bank Name"; Text[60])
        {
            Description = 'ALLEDK 101012';
            Editable = true;
        }
        field(50003; "Introducer Code"; Code[20])
        {
            Description = 'BBG181012';
            TableRelation = Vendor;
        }
        field(50005; Approved; Boolean)
        {
        }
        field(50006; "Approved By"; Text[20])
        {
            Editable = false;
        }
        field(50007; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(50008; "User ID"; Code[50])
        {
            Description = 'ALLE Ck 2604119';
            Editable = false;
            TableRelation = User;
        }
        field(50017; Narration; Text[80])
        {
            Description = 'ALLETDK010313';

            trigger OnValidate()
            begin
                IF Posted THEN BEGIN
                    CLEAR(Memberof);
                    Memberof.RESET;
                    Memberof.SETRANGE("User Name", USERID);
                    Memberof.SETRANGE("Role ID", 'A_NarrUpdate');
                    IF NOT Memberof.FINDFIRST THEN
                        ERROR('You are not authorised person to perform this task. Please contact to Admin Dept.');
                END;
            end;
        }
        field(50019; "User Branch Name"; Text[70])
        {
            Description = 'ALLECK 280313';
            Editable = false;
        }
        field(50101; "No. Printed"; Integer)
        {
        }
        field(50201; "Discount Payment Type"; Option)
        {
            Description = 'BBG1.6 311213';
            OptionCaption = ' ,Forfeit,Excess Payment';
            OptionMembers = " ",Forfeit,"Excess Payment";
        }
        field(50202; "Receipt Post in LLP Comp Date"; Date)
        {
        }
        field(50204; "Receipt Post in LLP Company"; Boolean)
        {
            Description = 'BBG2.00 300714';
            Editable = true;
        }
        field(50206; "Receipt Post in Devlp. Comp."; Boolean)
        {
            Editable = true;
        }
        field(50207; "Company Name"; Text[30])
        {
            Editable = false;
            TableRelation = Company;
        }
        field(50208; "Receipt Post InterComp Date"; Date)
        {
            Editable = false;
        }
        field(50210; "Create from MSC Company"; Boolean)
        {
            Editable = true;
        }
        field(50220; "Bank Type"; Option)
        {
            Editable = true;
            OptionCaption = ' ,VeritaCompany,ProjectCompany';
            OptionMembers = " ",VeritaCompany,ProjectCompany;

            trigger OnValidate()
            var
                v_NewConfirmedOrder: Record "New Confirmed Order";
                V_CompanyInformation: Record "Company Information";
            begin
                v_NewConfirmedOrder.RESET;
                IF v_NewConfirmedOrder.GET("Document No.") THEN BEGIN
                    V_CompanyInformation.RESET;
                    V_CompanyInformation.CHANGECOMPANY(v_NewConfirmedOrder."Company Name");
                    IF V_CompanyInformation.GET THEN BEGIN
                        //IF V_CompanyInformation."Development Company Name" = v_NewConfirmedOrder."Company Name" THEN
                        //TESTFIELD("Bank Type","Bank Type"::VeritaCompany);
                    END;
                END;
            end;
        }
        field(50221; "BRS Created All Comp From MSC"; Boolean)
        {
            Editable = true;
        }
        field(50222; "BRS Date in All Comp From MSC"; Date)
        {
            Editable = false;
        }
        field(50225; Status; Option)
        {
            CalcFormula = Lookup("New Confirmed Order".Status WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
            OptionCaption = 'Open,Documented,Cash Dispute,Documentation Dispute,Verified,Active,Death Claim,Maturity Claim,Maturity Dispute,Matured,Dispute,Blocked (Loan),Registered,Cancelled,Vacate,Forfeit';
            OptionMembers = Open,Documented,"Cash Dispute","Documentation Dispute",Verified,Active,"Death Claim","Maturity Claim","Maturity Dispute",Matured,Dispute,"Blocked (Loan)",Registered,Cancelled,Vacate,Forfeit;
        }
        field(50228; "Refund Amount"; Decimal)
        {

            trigger OnValidate()
            var
                NewAppPEntry_1: Record "Application Payment Entry";
            begin
                UserSetup.RESET;
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE("Refund Amount Modify", TRUE);
                IF NOT UserSetup.FINDFIRST THEN
                    ERROR('Please contact Admin');

                /*
                Amt :=0;
                NewAppPEntry_1.RESET;
                NewAppPEntry_1.SETRANGE("Document No.","Document No.");
                NewAppPEntry_1.SETRANGE("Cheque Status",NewAppPEntry_1."Cheque Status"::Cleared);
                IF NewAppPEntry_1.FINDSET THEN
                  REPEAT
                    Amt := Amt + NewAppPEntry_1.Amount;
                  UNTIL NewAppPEntry_1.NEXT =0;
                
                IF ABS("Refund Amount") > Amt THEN
                  ERROR('Refund amount can not be greater than-'+FORMAT(Amt));
                
                Amount := -1*"Refund Amount";
                */

            end;
        }
        field(50244; "Cheque No.1"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50335; "GST Group Code"; Code[20])
        {
            Caption = 'GST Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "GST Group";

            trigger OnValidate()
            var
                GSTGroup: Record "GST Group";  //16404;
                SalesReceivablesSetup: Record "Sales & Receivables Setup";
                GenJournalLine2: Record "Gen. Journal Line";
            begin
            end;
        }
        field(50336; "GST Group Type"; Option)
        {
            Caption = 'GST Group Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Goods,Service';
            OptionMembers = Goods,Service;
        }
        field(50337; "GST Place of Supply"; Option)
        {
            Caption = 'GST Place of Supply';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Bill-to Address,Ship-to Address,Location Address';
            OptionMembers = " ","Bill-to Address","Ship-to Address","Location Address";
        }
        field(50338; "HSN/SAC Code"; Code[8])
        {
            Caption = 'HSN/SAC Code';
            DataClassification = ToBeClassified;
            TableRelation = "HSN/SAC".Code WHERE("GST Group Code" = FIELD("GST Group Code"));

            trigger OnValidate()
            var
                GenJournalLine: Record "Gen. Journal Line";
            begin
            end;
        }
        field(50339; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(50340; "Apply to Document No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                OldApplicationPaymentEntry: Record "Application Pmt Devlop. Entry";
                NewConfirmedOrder: Record "New Confirmed Order";
                CompCode: Text;
                CompanyInformation: Record "Company Information";
            begin
                CompCode := '';
                NewConfirmedOrder.GET("Document No.");
                //IF NewConfirmedOrder."Development Company Name" <> '' THEN
                //CompCode := NewConfirmedOrder."Development Company Name"
                // ELSE BEGIN
                // CompanyInformation.RESET;
                // CompanyInformation.CHANGECOMPANY(NewConfirmedOrder."Company Name");
                // IF CompanyInformation.GET THEN
                //  CompCode := CompanyInformation."Development Company Name";
                //END;

                OldApplicationPaymentEntry.RESET;
                OldApplicationPaymentEntry.CHANGECOMPANY(CompCode);
                OldApplicationPaymentEntry.SETRANGE("Document No.", "Document No.");
                OldApplicationPaymentEntry.SETRANGE("Cheque Status", OldApplicationPaymentEntry."Cheque Status"::Cleared);
                IF OldApplicationPaymentEntry.FINDFIRST THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Posted App Payment Entries", OldApplicationPaymentEntry) = ACTION::LookupOK THEN BEGIN
                        OldApplicationPaymentEntry.TESTFIELD("Cheque Status", OldApplicationPaymentEntry."Cheque Status"::Cleared);
                        //"Apply to Document No." := OldApplicationPaymentEntry."Eligible Amount";
                        //Amount := -1*OldApplicationPaymentEntry."Cheque No.";
                        //IF "Payment Mode" = "Payment Mode"::"Refund Bank" THEN
                        //"Refund Amount" := OldApplicationPaymentEntry."Cheque No.";
                        "Bank Type" := "Bank Type"::VeritaCompany;
                        "Development Company Name" := CompCode;
                    END;
                END;
            end;

            trigger OnValidate()
            var
                CustLedgerEntry: Record "Cust. Ledger Entry";
            begin
                IF ("Payment Mode" <> "Payment Mode"::"Refund Bank") AND ("Payment Mode" <> "Payment Mode"::MJVM) THEN
                    ERROR('Payment Mode should be Refund Bank');
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETCURRENTKEY("Document No.");
                CustLedgerEntry.SETRANGE("Document No.", "Apply to Document No.");
                CustLedgerEntry.SETRANGE(Open, TRUE);
                IF NOT CustLedgerEntry.FINDFIRST THEN
                    ERROR('Customer Ledger Entry already Applied with other Document');
            end;
        }
        field(50341; "Bank Reco Done in LLP"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50342; "LLP Posted Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50343; "Verita Data upload"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50344; "Opening Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50345; Remarks; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50346; "Required Posting"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50347; "Positive Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50348; "P_Document No"; Code[20])
        {
            CalcFormula = Lookup("Application Payment Entry"."Posted Document No." WHERE("Document No." = FIELD("Document No."),
                                                                                          "Receipt Line No." = FIELD("Line No.")));
            FieldClass = FlowField;
        }
        field(50349; Apply; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50350; "Refund date less than Recpt"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50351; "MArk only one entry"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50352; Correction; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50353; "Development Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Company;
        }
        field(50354; "MJV Transfer Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; Posted, "Payment Mode", "Cheque Status", "Chq. Cl / Bounce Dt.", "Document Type", "Document No.", "Document Date", "Posting date")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Shortcut Dimension 1 Code", "Document No.")
        {
        }
        key(Key4; "Document No.", "Shortcut Dimension 1 Code", "Posting date")
        {
        }
        key(Key5; "Introducer Code", "Document No.", "Shortcut Dimension 1 Code", "Posting date")
        {
        }
        key(Key6; "Introducer Code", "Shortcut Dimension 1 Code", "Document No.", "Posting date")
        {
        }
        key(Key7; "Document Type", "Application No.", Posted, "Cheque Status")
        {
            SumIndexFields = Amount;
        }
        key(Key8; "Unit Code")
        {
        }
        key(Key9; "User Branch Code", "Document No.")
        {
        }
        key(Key10; Posted, "Posting date")
        {
        }
        key(Key11; Posted, "Payment Mode", "Cheque Status", "Cheque Date", "Document Type", "Document No.", "Document Date", "Posting date")
        {
        }
        key(Key12; "Chq. Cl / Bounce Dt.")
        {
        }
        key(Key13; "User Branch Code", "Posting date", Posted)
        {
        }
        key(Key14; "Document No.", Posted, "Posting date")
        {
        }
        key(Key15; "Shortcut Dimension 1 Code", "Posting date")
        {
        }
        key(Key16; "Posted Document No.", "Receipt Post in Devlp. Comp.", "Create from MSC Company", "Cheque Status")
        {
        }
        key(Key17; "Document No.", "Cheque Status")
        {
            SumIndexFields = Amount;
        }
        key(Key18; "Receipt Post in Devlp. Comp.")
        {
        }
        key(Key19; "Document Type", "Posted Document No.", "Payment Mode", "BRS Created All Comp From MSC")
        {
        }
        key(Key20; "Document No.", Posted, "Posting date", "Payment Mode", "Cheque Status")
        {
            SumIndexFields = Amount;
        }
        key(Key21; "Document No.", "Posting date", "Cheque Status")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //TESTFIELD(Posted,FALSE);
    end;

    trigger OnInsert()
    begin
        BPayEntry.RESET;
        BPayEntry.SETRANGE("Document Type", "Document Type");
        BPayEntry.SETFILTER(BPayEntry."Document No.", "Document No.");
        IF BPayEntry.FIND('+') THEN BEGIN
            "Line No." := BPayEntry."Line No." + 10000;
        END ELSE
            "Line No." := 10000;

        TESTFIELD("Payment Method");
        IF ("Payment Mode" IN ["Payment Mode"::Bank, "Payment Mode"::"Refund Bank"]) THEN BEGIN
            TESTFIELD("Cheque No./ Transaction No.");
            TESTFIELD("Cheque Date");
            IF "Payment Mode" = "Payment Mode"::Bank THEN
                TESTFIELD("Cheque Bank and Branch");
            TESTFIELD("Deposit/Paid Bank");
        END;
        "Posting date" := WORKDATE;
        "Document Date" := GetDescription.GetDocomentDate;
        UserSetup.GET(USERID);
        "Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        "User Branch Code" := UserSetup."User Branch";

        "Application No." := "Document No."; //ALLEDK 091012
        "User ID" := USERID;  //ALLEDK 271212
        IF ("Payment Mode" <> "Payment Mode"::Bank) AND ("Payment Mode" <> "Payment Mode"::"Refund Bank") THEN  //1208
            "Cheque Status" := "Cheque Status"::Cleared;

        //ALLEDK 250113
        RecApplication.RESET;
        RecApplication.SETRANGE("Application No.", "Document No.");
        IF RecApplication.FINDFIRST THEN BEGIN
            RecApplication.TESTFIELD(Status, RecApplication.Status::Open);
            "Shortcut Dimension 1 Code" := RecApplication."Shortcut Dimension 1 Code";
            "Company Name" := RecApplication."Company Name";
        END ELSE BEGIN
            ConfOrdernew.RESET;
            ConfOrdernew.SETRANGE("No.", "Document No.");
            IF ConfOrdernew.FINDFIRST THEN
                "Shortcut Dimension 1 Code" := ConfOrdernew."Shortcut Dimension 1 Code";
            "Company Name" := ConfOrdernew."Company Name";
        END;
        //ALLEDK 250113
        "Create from MSC Company" := TRUE;
        "Application No." := "Document No."; //ALLEDK 091012
        "Bank Type" := "Bank Type"::VeritaCompany;
    end;

    var
        PaymentMethod: Record "Payment Method";
        BondSetup: Record "Unit Setup";
        Text0001: Label 'Please enter a valid cheque no.';
        Text0002: Label 'Please enter a valid cheque date.';
        Text0003: Label 'You cannot change Line No. %1.';
        Text0004: Label 'Cheque Already Cleared and Posted';
        Text0005: Label 'Payment Mode is %1';
        Text0006: Label 'Please enter Cheque Clearance Date';
        Text0007: Label 'Please enter a valid cheque Clearance date.';
        Text0008: Label 'Cheque Clearance date cannot be changed';
        Application: Record "New Application Booking";
        Bond: Record "New Confirmed Order";
        TotalApplAmt: Decimal;
        TotalRcvdAmt: Decimal;
        Text0009: Label 'Payment mode %1 already exists.';
        Text0010: Label 'Maximum permitted amount in %1 is %2.';
        Text0011: Label 'Amount should not be greater than Due Amount = %1.';
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        DefaultDim: Record "Default Dimension";
        Text0012: Label 'Error';
        GLSetupRead: Boolean;
        GetDescription: Codeunit GetDescription;
        BPayEntry: Record "New Application DevelopmntLine";
        Text0013: Label 'The Order is already Exploded.\Not allowed to enter New Line';
        Text0014: Label 'Order is already Registered.\Not allowed to modify or delete';
        Text0015: Label 'Order is already Cancelled.\Not allowed to modify or delete';
        TotalApplAmt2: Decimal;
        TotalRcvdAmt2: Decimal;
        Vendor: Record Vendor;
        Text50000: Label 'Associate %1 PAN No. not verified';
        BankAccount: Record "Bank Account";
        ConfirmOrder: Record "New Confirmed Order";
        APPNo: Record "New Application Booking";
        Text50001: Label 'Total Receipt Amount is greater than Amount = %1. Do you want to continue?';
        RecConfirmOrder: Record "New Confirmed Order";
        RecConfOrder: Record "New Confirmed Order";
        AppPayEntry: Record "New Application DevelopmntLine";
        UnitReversal: Codeunit "Unit Reversal";
        Amt: Decimal;
        CommissionEntry: Record "Commission Entry";
        CommAmt: Decimal;
        UnitSetup: Record "Unit Setup";
        Vend: Record Vendor;
        TDSP: Decimal;
        ClubP: Decimal;
        ConfOrder: Record "New Confirmed Order";
        //NODNOCHdr: Record 13786;//Need to check the code in UAT
        AppPaymentEntry: Record "New Application DevelopmntLine";
        LastLineNo: Integer;
        InsertAppLines: Record "New Application DevelopmntLine";
        Text50002: Label 'Total Received Amount on Application No.-%1 is %2. The Amount must be less or equal.';
        GetConfOrder: Record "New Confirmed Order";
        RecPaymentMethod: Record "Payment Method";
        RecApplication: Record "New Application Booking";
        UnitPaymentEntry: Record "Unit Payment Entry";
        TotalRecAmt: Decimal;
        AJVMCode: Code[20];
        VendCode: Code[20];
        //VoucherAccount: Record 16547;//Need to check the code in UAT
        DebitVoucherAccount: Record "Voucher Posting Debit Account";
        CreditVoucherAccount: Record "Voucher Posting Credit Account";
        BankACC: Record "Bank Account";
        ConfOrdernew: Record "New Confirmed Order";
        Loc: Record Location;
        CompanywiseGl: Record "Company wise G/L Account";
        Memberof: Record "Access Control";


    procedure CheckCashAmount()
    var
        BondSetup: Record "Unit Setup";
        PaymentLines: Record "New Application DevelopmntLine";
        CashAmount: Decimal;
    begin
        IF "Document Type" = "Document Type"::Application THEN
            IF "Payment Mode" = "Payment Mode"::Cash THEN BEGIN
                PaymentLines := Rec;
                SETRANGE("Document Type", "Document Type");
                SETRANGE("Document No.", "Document No.");
                SETRANGE("Payment Mode", "Payment Mode"::Cash);
                SETFILTER("Line No.", '<>%1', "Line No.");
                IF FINDSET THEN
                    REPEAT
                        CashAmount += Amount;
                    UNTIL NEXT = 0;
                SETRANGE("Document Type");
                SETRANGE("Document No.");
                SETRANGE("Payment Mode");
                SETRANGE("Line No.");
                Rec := PaymentLines;
                BondSetup.GET;
                IF CashAmount + Amount > BondSetup."Cash Max. Amount" THEN
                    ERROR(STRSUBSTNO(Text0010, FORMAT("Payment Mode"), BondSetup."Cash Max. Amount"));
            END;
    end;


    procedure UpdateDueAmount()
    begin
        UpdateAmount();
        IF TotalApplAmt - TotalRcvdAmt < 0 THEN BEGIN
            IF NOT CONFIRM(Text50001, FALSE, TotalApplAmt) THEN
                ERROR(STRSUBSTNO(Text0011, TotalApplAmt - TotalRcvdAmt + Amount));
        END;
    end;


    procedure UpdateAmount()
    var
        PmtLines: Record "New Application DevelopmntLine";
    begin
        IF "Document Type" <> "Document Type"::Application THEN
            EXIT;

        IF NOT Application.GET("Document No.") THEN
            EXIT;

        TotalApplAmt := 0;
        TotalRcvdAmt := 0;
        TotalApplAmt := Application."Investment Amount" + Application."Service Charge Amount";
        TotalRcvdAmt := Rec.Amount;

        PmtLines := Rec;
        SETRANGE("Document Type", "Document Type");
        SETRANGE("Document No.", "Document No.");
        SETFILTER("Line No.", '<>%1', "Line No.");
        IF FINDSET THEN
            REPEAT
                TotalRcvdAmt += Amount;
            UNTIL NEXT = 0;

        SETRANGE("Document Type");
        SETRANGE("Document No.");
        SETRANGE("Line No.");
        Rec := PmtLines;
    end;


    procedure GetAmounts(var TotalAmount: Decimal; var ReceivedAmount: Decimal)
    begin
        UpdateAmount();
        TotalAmount := TotalApplAmt;
        ReceivedAmount := TotalRcvdAmt;
    end;


    procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    end;


    procedure GetUserSetup()
    begin
        IF UserSetup."User ID" <> USERID THEN
            UserSetup.GET(USERID);
    end;


    procedure CheckExistingLines()
    begin
        BPayEntry.RESET;
        BPayEntry.SETRANGE("Document Type", "Document Type");
        BPayEntry.SETFILTER("Document No.", "Document No.");
        BPayEntry.SETRANGE("Explode BOM", TRUE);
        BPayEntry.SETRANGE(Posted, FALSE);
        IF BPayEntry.FINDFIRST THEN
            ERROR(Text0013);
    end;


    procedure CheckRegistration()
    var
        Bond: Record "New Confirmed Order";
    begin
        Bond.RESET;
        IF Bond.GET("Document No.") THEN BEGIN
            IF Bond.Status = Bond.Status::Registered THEN
                ERROR(Text0014);
            IF Bond.Status = Bond.Status::Cancelled THEN
                ERROR(Text0015);

        END;
    end;


    procedure CheckAppPaymentPlan()
    var
        Application: Record "New Application Booking";
    begin
        IF Application.GET("Document No.") THEN
            Application.TESTFIELD("Payment Plan");
        /*
        // ALLEPG 230812 Start
        IF Vendor.GET(Application."Associate Code") THEN BEGIN
          IF NOT Vendor."Verify P.A.N. No." THEN
            MESSAGE(Text50000,Application."Associate Code");
        END;
        // ALLEPG 230812 End
        */

    end;


    procedure UpdateAmount2()
    var
        PmtLines: Record "New Application DevelopmntLine";
    begin
        IF "Document Type" <> "Document Type"::BOND THEN
            EXIT;

        IF NOT Bond.GET("Document No.") THEN
            EXIT;

        TotalApplAmt2 := 0;
        TotalRcvdAmt2 := 0;
        TotalApplAmt2 := Bond.Amount + Bond."Service Charge Amount";
        TotalRcvdAmt2 := Rec.Amount;

        PmtLines := Rec;
        SETRANGE("Document Type", "Document Type");
        SETRANGE("Document No.", "Document No.");
        //SETRANGE("Payment Mode","Payment Mode"::Cash);
        //SETRANGE("Not Refundable",FALSE);
        SETFILTER("Line No.", '<>%1', "Line No.");
        IF FINDSET THEN
            REPEAT
                TotalRcvdAmt2 += Amount;
            UNTIL NEXT = 0;

        SETRANGE("Document Type");
        SETRANGE("Document No.");
        //SETRANGE("Payment Mode");
        //SETRANGE("Not Refundable");
        SETRANGE("Line No.");
        Rec := PmtLines;
    end;


    procedure GetAmounts2(var TotalAmount: Decimal; var ReceivedAmount: Decimal)
    begin
        UpdateAmount2();
        TotalAmount := TotalApplAmt2;
        ReceivedAmount := TotalRcvdAmt2;
    end;


    procedure CheckTotalReciptAmountBond()
    var
        RecConfirmOrder: Record "New Confirmed Order";
        AppPayEntry: Record "NewApplication Payment Entry";
        TotRcptAmt: Decimal;
    begin
        //ALLETDK141112..BEGIN
        RecConfirmOrder.GET("Document No.");
        TotRcptAmt := Amount;
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document Type", "Document Type");
        AppPayEntry.SETRANGE("Document No.", "Document No.");
        AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
        AppPayEntry.SETFILTER("Cheque Status", '<>%1', AppPayEntry."Cheque Status"::Bounced);
        IF AppPayEntry.FINDSET THEN
            REPEAT
                TotRcptAmt += AppPayEntry.Amount;
            UNTIL AppPayEntry.NEXT = 0;
        IF (RecConfirmOrder.Amount + RecConfirmOrder."Service Charge Amount" - TotRcptAmt) < 0 THEN BEGIN
            IF NOT CONFIRM(Text50001, FALSE, RecConfirmOrder.Amount + RecConfirmOrder."Service Charge Amount") THEN
                ERROR(STRSUBSTNO(Text0011, RecConfirmOrder.Amount + RecConfirmOrder."Service Charge Amount" - TotRcptAmt + Amount));
        END;
        //ALLETDK141112..END
    end;


    procedure CalculateTDSPercentage(): Decimal
    var
        TDSPercent: Decimal;
        eCessPercent: Decimal;
        SheCessPercent: Decimal;
        RecTDSSetup: Record "TDS Setup"; // 13728;
                                         // RecNODHeader: Record 13786;//Need to check the code in UAT
                                         //RecNODLines: Record 13785;//Need to check the code in UAT
        RAPE: Record "NewApplication Payment Entry";
        Vendor: Record Vendor;
        AllowedSection: Record "Allowed Sections";
        CodeunitEventMgt: Codeunit "BBG Codeunit Event Mgnt.";
    begin
        UnitSetup.GET;
        VendCode := '';
        IF ConfOrder.GET("Document No.") THEN;

        IF "Payment Mode" = "Payment Mode"::AJVM THEN BEGIN
            ConfOrder.TESTFIELD(ConfOrder."AJVM Associate Code");
            VendCode := ConfOrder."AJVM Associate Code";
        END ELSE
            VendCode := ConfOrder."Introducer Code";

        IF "Payment Mode" = "Payment Mode"::"Negative Adjmt." THEN BEGIN
            RAPE.CALCFIELDS("AJVM Associate Code");
            VendCode := RAPE."AJVM Associate Code";
        END;

        IF Vendor.Get(VendCode) Then begin
            AllowedSection.Reset();
            AllowedSection.SetRange("Vendor No", Vendor."No.");
            AllowedSection.SetRange("TDS Section", UnitSetup."TDS Nature of Deduction");
            IF AllowedSection.FindFirst() then begin
                TDSPercent := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
                EXIT(((10000 * TDSPercent) + (100 * TDSPercent * eCessPercent) + (100 * TDSPercent * SheCessPercent) +
                          (TDSPercent * eCessPercent * SheCessPercent)) / 10000);
            end;
        end;

        /*
                IF NODNOCHdr.GET(NODNOCHdr.Type::Vendor, VendCode) THEN;

                RecTDSSetup.RESET;
                RecTDSSetup.SETRANGE("TDS Nature of Deduction", UnitSetup."TDS Nature of Deduction");
                RecTDSSetup.SETRANGE("Assessee Code", NODNOCHdr."Assesse Code");
                //RecTDSSetup.SETRANGE("TDS Group","TDS Group");
                RecTDSSetup.SETRANGE("Effective Date", 0D, TODAY);
                RecNODLines.RESET;
                RecNODLines.SETRANGE(Type, RecNODLines.Type::Vendor);
                RecNODLines.SETRANGE("No.", VendCode);
                RecNODLines.SETRANGE("NOD/NOC", UnitSetup."TDS Nature of Deduction");
                IF RecNODLines.FINDFIRST THEN BEGIN
                    IF RecTDSSetup.FINDLAST THEN BEGIN
                        Vend.GET(VendCode);
                        IF (Vend."P.A.N. Status" = Vend."P.A.N. Status"::" ") AND (Vend."P.A.N. No." <> '') THEN
                            TDSPercent := RecTDSSetup."TDS %"
                        ELSE
                            TDSPercent := RecTDSSetup."Non PAN TDS %";

                        eCessPercent := RecTDSSetup."eCESS %";
                        SheCessPercent := RecTDSSetup."SHE Cess %";
                        EXIT(((10000 * TDSPercent) + (100 * TDSPercent * eCessPercent) + (100 * TDSPercent * SheCessPercent) +
                          (TDSPercent * eCessPercent * SheCessPercent)) / 10000);
                    END ELSE
                        ERROR('TDS Setup does not exist');
                END ELSE
                    ERROR('TDS Setup does not exist');\
                    *///Need to check the code in UAT
    end;
}

