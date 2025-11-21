table 97812 "Application Payment Entry"
{
    // ALLEDK 101012 Added code for Bank Name
    // // BBG1.01_NB 191012: Add additonal option of D.C./C.C/ Net Banking in Payment Mode.
    // ALLEPG 221012 : Code modify for cheque date.
    // ALLETDK081112...Added "Posted","Cheque Status" fields to Key "Document Type","Application No."
    // ALLETDK061212..Added new option "Refund Cash" and "Refund Cheque" in "Pyament Mode" field
    // AD230213:BBG1.00 CODE COMMENTED: NOT REQUIRED IN BBG
    //  ADCOMMENTED280313

    Caption = 'Application Payment Entry';
    DrillDownPageID = "Application Payment Entry List";
    LookupPageID = "Application Payment Entry List";

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
                                                                                                                                    // PaymentMethod.TESTFIELD(PaymentMethod."Bal. Account No."); AD230213:BBG1.00 CODE COMMENTED
                        Description := PaymentMethod.Description;
                    // "Cheque Status" := PaymentMethod."Default Payment Status";
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
            begin
                //ALLETDK061212
                AJVMCode := '';
                ConfirmOrder.RESET;
                IF ConfirmOrder.GET("Document No.") THEN BEGIN
                    "Introducer Code" := ConfirmOrder."Introducer Code";
                    "Unit Code" := ConfirmOrder."Unit Code"; //ALLETDK141112
                    AJVMCode := ConfirmOrder."AJVM Associate Code";
                    IF ConfirmOrder.Type = ConfirmOrder.Type::Priority THEN
                        "Priority Payment" := TRUE
                    ELSE
                        "Priority Payment" := FALSE;
                    IF ConfirmOrder.Status = ConfirmOrder.Status::Forfeit THEN
                        ERROR('Application on hold. Please contact Admin');
                END ELSE BEGIN
                    APPNo.RESET;
                    APPNo.SETRANGE("Application No.", "Document No.");
                    IF APPNo.FINDFIRST THEN BEGIN
                        "Introducer Code" := APPNo."Associate Code";
                        "Unit Code" := APPNo."Unit Code"; //ALLETDK141112
                        IF APPNo.Type = APPNo.Type::Priority THEN
                            "Priority Payment" := TRUE
                        ELSE
                            "Priority Payment" := FALSE;
                        IF "Payment Mode" = "Payment Mode"::AJVM THEN
                            ERROR('Please check the open Application.');
                    END;
                END;




                IF ("Payment Mode" IN ["Payment Mode"::"Refund Cash", "Payment Mode"::"Refund Bank"]) THEN BEGIN
                    Amount := -1 * Amount;
                END;

                IF ("Payment Mode" IN ["Payment Mode"::"Refund Cash", "Payment Mode"::"Refund Bank",
                "Payment Mode"::"Negative Adjmt."]) AND (Amount > 0) THEN
                    ERROR('Amount must be Negative for Adjustments/Refunds');

                IF NOT ("Payment Mode" IN ["Payment Mode"::"Refund Cash", "Payment Mode"::"Refund Bank",
                "Payment Mode"::"Negative Adjmt.", "Payment Mode"::JV]) AND (Amount < 0) THEN
                    ERROR('Amount must be Positive');


                IF "Payment Mode" = "Payment Mode"::AJVM THEN BEGIN

                    TESTFIELD("Payment Mode", "Payment Mode"::AJVM);
                    UnitSetup.GET;
                    UnitSetup.TESTFIELD("Corpus %");
                    TDSP := CalculateTDSPercentage;
                    //IF "AJVM Transfer Type" = "AJVM Transfer Type"::Commission THEN //ALLETDK290313
                    ClubP := UnitSetup."Corpus %";
                    "TDS %" := TDSP;
                    "Associate Transfer Amount" := ROUND((100 * Amount) / (100 - ClubP - TDSP), 0.01);
                    Vendor.RESET;
                    IF Vendor.GET(AJVMCode) THEN BEGIN
                        Vendor.CALCFIELDS(Vendor."BBG Balance at Date (LCY)");
                        //   Vendor.CALCFIELDS("Commission Amount Qualified");
                        //  Vendor.CALCFIELDS("Travel Amount Qualified");
                        // Vendor.CALCFIELDS("Incentive Amount Qualified");
                    END;

                    "TDS Amount" := ("Associate Transfer Amount" * (TDSP / 100));
                    //IF "AJVM Transfer Type" = "AJVM Transfer Type"::Commission THEN BEGIN //ALLETDK290313
                    "Club 9 Amount" := ("Associate Transfer Amount" * (ClubP / 100));
                    "Club 9%" := ClubP;
                    /*
                    END ELSE BEGIN
                      "Club 9 Amount" := 0;
                      "Club 9%" := 0;

                    END;
                    */


                    /* // 090316
                     IF (Vendor."Commission Amount Qualified"+Vendor."Travel Amount Qualified"+
                           Vendor."Incentive Amount Qualified" - Vendor."Balance at Date (LCY)") > 0 THEN BEGIN
                       IF "Associate Transfer Amount" > ABS(Vendor."Commission Amount Qualified"+Vendor."Travel Amount Qualified"+
                           Vendor."Incentive Amount Qualified" - Vendor."Balance at Date (LCY)") THEN BEGIN
                           MESSAGE('The Payment amount is exceeding the Elibility Amt to date');
                           //TESTFIELD(Approved);
                         END;
                       END ELSE
                         IF CONFIRM('Insufficient balance in Associate Account. Do you want Continue?',TRUE) THEN BEGIN
                           END ELSE BEGIN
                           Amount := 0;
                           "Associate Transfer Amount" := 0;
                           "TDS %" := 0;
                           "TDS Amount" := 0;
                           "Club 9 Amount" := 0;
                           "Club 9%" := 0;
                         END;
                   */ // 090316

                    IF Vendor."BBG Balance at Date (LCY)" < 0 THEN BEGIN
                        IF "Associate Transfer Amount" > ABS(Vendor."BBG Balance at Date (LCY)") THEN BEGIN
                            MESSAGE('The Payment amount is exceeding the Elibility Amt to date');
                        END;
                    END ELSE
                        IF CONFIRM('Insufficient balance in Associate Account. Do you want Continue?', TRUE) THEN BEGIN
                        END ELSE BEGIN
                            Amount := 0;
                            "Associate Transfer Amount" := 0;
                            "TDS %" := 0;
                            "TDS Amount" := 0;
                            "Club 9 Amount" := 0;
                            "Club 9%" := 0;
                        END;
                END;

                //ALLETEDK081112..BEGIN
                IF Application.GET("Document No.") THEN BEGIN
                    Application.TESTFIELD("Unit Code");
                    //   Application.TESTFIELD("Customer No.");
                    Application.TESTFIELD("Associate Code");
                    Application.TESTFIELD("Received From Code");
                END;
                //ALLETEDK081112..END

                IF ("Payment Mode" = "Payment Mode"::"Negative Adjmt.") THEN BEGIN
                    TESTFIELD("Adjmt. Line No.");
                    CLEAR(AdjmtAmt);
                    AppPaymentEntry.RESET;
                    AppPaymentEntry.SETRANGE("Document No.", "Document No.");
                    AppPaymentEntry.SETRANGE("Adjmt. Line No.", "Adjmt. Line No.");
                    IF AppPaymentEntry.FINDSET THEN
                        REPEAT
                            AdjmtAmt += (AppPaymentEntry.Amount);
                        UNTIL AppPaymentEntry.NEXT = 0;
                    AppPaymentEntry.GET("Document Type", "Document No.", "Adjmt. Line No.");
                    IF (AppPaymentEntry.Amount + AdjmtAmt + Amount) < 0 THEN
                        ERROR('Total Adjustment Amount %1 is more than Actual Amount %2', ABS(AdjmtAmt + Amount), AppPaymentEntry.Amount);
                    IF AppPaymentEntry."Payment Mode" = AppPaymentEntry."Payment Mode"::AJVM THEN BEGIN
                        UnitSetup.GET;
                        UnitSetup.TESTFIELD("Corpus %");
                        //IF AppPaymentEntry."AJVM Transfer Type" = AppPaymentEntry."AJVM Transfer Type"::Commission THEN BEGIN
                        ClubP := UnitSetup."Corpus %";
                        TDSP := CalculateTDSPercentage;
                        /*
                        END ELSE BEGIN
                          CLEAR(TDSP);
                          CLEAR(ClubP);
                        END;
                        */
                        "TDS %" := TDSP;
                        "Associate Transfer Amount" := ROUND((100 * Amount) / (100 - ClubP - TDSP), 0.01);
                        /*
                        IF Vendor.GET(AJVMCode) THEN BEGIN
                          Vendor.CALCFIELDS(Vendor."Balance at Date (LCY)");
                          Vendor.CALCFIELDS("Commission Amount Qualified");
                          Vendor.CALCFIELDS("Travel Amount Qualified");
                          Vendor.CALCFIELDS("Incentive Amount Qualified");
                        END;
                        */
                        "TDS Amount" := ("Associate Transfer Amount" * (TDSP / 100));
                        "Club 9 Amount" := ("Associate Transfer Amount" * (ClubP / 100));
                        "Club 9%" := ClubP;
                    END;
                END;

                TESTFIELD("Payment Mode");  //220713


                UpdateDueAmount;
                CheckCashAmount;
                //ALLETEDK141112..BEGIN
                IF "Document Type" = "Document Type"::BOND THEN
                    CheckTotalReciptAmountBond;
                //ALLETEDK141112..END

            end;
        }
        field(8; "Cheque No./ Transaction No."; Code[20])
        {

            trigger OnValidate()
            begin
                //ALLETEDK081112..BEGIN
                IF Application.GET("Document No.") THEN BEGIN
                    Application.TESTFIELD("Unit Code");
                    // Application.TESTFIELD("Customer No.");
                    Application.TESTFIELD("Associate Code");
                    Application.TESTFIELD("Received From Code");
                END;
                //ALLETEDK081112..END

                //ALLETDK061212..BEGIN
                AppPayEntry.RESET;
                AppPayEntry.SETRANGE("Document No.", "Document No.");
                AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                AppPayEntry.SETRANGE("Cheque No./ Transaction No.", "Cheque No./ Transaction No.");
                IF AppPayEntry.FINDFIRST THEN
                    IF "Cheque No./ Transaction No." <> '' THEN
                        ERROR('Cheque No. %1 already exist', "Cheque No./ Transaction No.");
                //ALLETDK061212..END

                // IF ("Cheque No./ Transaction No." <> '') AND NOT (STRLEN("Cheque No./ Transaction No.") IN [6,7]) THEN
                //   ERROR(Text0001);
            end;
        }
        field(9; "Cheque Date"; Date)
        {

            trigger OnValidate()
            var
                Application: Record Application;
                BondSetup: Record "Unit Setup";
            begin
                // ALLEPG 221012 Start
                BondSetup.GET;
                //IF (("Cheque Date" > WORKDATE) OR ("Cheque Date" < CALCDATE(BondSetup."Cheque Date Validity",WORKDATE))) THEN
                //  ERROR(Text0002);
                IF "Cheque Date" <> 0D THEN BEGIN
                    IF ("Cheque Date" >= CALCDATE(BondSetup."Cheque Date Validity", WORKDATE)) AND
                    ("Cheque Date" <= CALCDATE(BondSetup."Ch. Dt. After Days", WORKDATE)) THEN BEGIN
                    END ELSE
                        ERROR(Text0002);
                END;

                // ALLEPG 221012 End
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
            OptionCaption = ' ,Cleared,Bounced,,Cancelled';
            OptionMembers = " ",Cleared,Bounced,,Cancelled;
        }
        field(13; "Chq. Cl / Bounce Dt."; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin

                IF "Document Type" = "Document Type"::Application THEN BEGIN
                    IF Application.GET("Document No.") THEN
                        IF Bond.GET(Application."Unit No.") THEN;
                END;

                //IF "Cheque Status" <> "Cheque Status"::" " THEN
                //ERROR(Text0008);
            end;
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
                BondSetup.GET;
                BondSetup.TESTFIELD("Cash A/c No.");
                BondSetup.TESTFIELD("Cheque in Hand");
                BondSetup.TESTFIELD("DD in Hand");
                // BBG1.01 191012 START
                BondSetup.TESTFIELD("D.C./C.C./Net Banking A/c No.");
                // BBG1.01 191012 END

                IF ("Payment Mode" <> "Payment Mode"::Bank) AND ("Payment Mode" <> "Payment Mode"::"Refund Bank") THEN  //220519
                    "Cheque Status" := "Cheque Status"::Cleared
                ELSE
                    "Cheque Status" := "Cheque Status"::" ";

                //ALLETEDK081112..BEGIN
                IF Application.GET("Document No.") THEN BEGIN
                    Application.TESTFIELD("Unit Code");
                    //Application.TESTFIELD("Customer No.");
                    Application.TESTFIELD("Associate Code");
                    Application.TESTFIELD("Received From Code");
                END;
                //ALLETEDK081112..END
                //ALLETDK061212..BEGIN
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
                        ERROR('Please delete OR Post Lines Of ' + FORMAT(AppPayEntry."Payment Mode") + ', App No. -' + FORMAT("Document No."));
                END;

                //ALLEDK 140213
                IF ("Payment Mode" IN [8]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines of ' + FORMAT(AppPayEntry."Payment Mode") + ', App No. -' + FORMAT("Document No."));
                END;

                IF ("Payment Mode" IN [4]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines of ' + FORMAT(AppPayEntry."Payment Mode") + ', App No. -' + FORMAT("Document No."));
                END;

                IF ("Payment Mode" IN [6]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines Of ' + FORMAT(AppPayEntry."Payment Mode") + ', App No. -' + FORMAT("Document No."));
                END;

                IF ("Payment Mode" IN [7]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines Of ' + FORMAT(AppPayEntry."Payment Mode") + ', App No. -' + FORMAT("Document No."));
                END;

                IF ("Payment Mode" IN [11]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    //AppPayEntry.SETRANGE("Payment Mode",AppPayEntry."Payment Mode"::"Negative Adjmt.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines Of ' + FORMAT(AppPayEntry."Payment Mode") + ', App No. -' + FORMAT("Document No."));
                END;

                IF ("Payment Mode" IN [10]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    //AppPayEntry.SETRANGE("Payment Mode",AppPayEntry."Payment Mode"::"Negative Adjmt.");
                    AppPayEntry.SETRANGE("Payment Mode", 1, 11);
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Please delete OR Post Lines Of ' + FORMAT(AppPayEntry."Payment Mode") + ', App No. -' + FORMAT("Document No."));
                END;

                IF ("Payment Mode" IN [11]) THEN BEGIN
                    AppPayEntry.RESET;
                    AppPayEntry.SETRANGE("Document No.", "Document No.");
                    AppPayEntry.SETFILTER("Line No.", '<>%1', "Line No.");
                    AppPayEntry.SETRANGE("Payment Mode", AppPayEntry."Payment Mode"::"Negative Adjmt.");
                    AppPayEntry.SETRANGE(Posted, FALSE);
                    IF AppPayEntry.FINDFIRST THEN
                        ERROR('Adjustment Entry already exist ' + FORMAT(AppPayEntry."Payment Mode") + ', App No. -' + FORMAT("Document No."));
                END;


                //ALLEDK 140213



                //ALLETDK061212..END

                //ALLETDK141212..BEGIN
                UserSetup.GET(USERID);
                UserSetup.TESTFIELD("User Branch");
                //"User Branch Code" := UserSetup."User Branch";
                "User Branch Code" := UserSetup."Responsibility Center";
                //ALLETDK141212..END

                //ALLECK 280313 START
                IF Loc.GET("User Branch Code") THEN
                    "User Branch Name" := Loc.Name
                ELSE
                    CLEAR("User Branch Name");
                //ALLECK 280313 END

                //ALLEDK 190113
                /*
                CASE "Payment Mode" OF
                  "Payment Mode"::Cash:
                  BEGIN
                     VALIDATE("Payment Method",BondSetup."Cash A/c No.");
                     "Cheque No./ Transaction No." := '';
                     "Cheque Date" := 0D;
                     "Cheque Bank and Branch" := '';
                     "Deposit/Paid Bank" := '';
                     //ALLETDK141212--BEGIN
                     IF UnitReversal.GetCashAccountNo("Branch Code")='' THEN
                       ERROR('You must specify CASH Account for the Branch Code %1',"Branch Code");
                     //ALLETDK141212--END
                  END;
                  "Payment Mode"::Bank:
                     VALIDATE("Payment Method",BondSetup."Cheque in Hand");
                  "Payment Mode"::"D.D.":
                     VALIDATE("Payment Method",BondSetup."DD in Hand");
                  "Payment Mode"::Transfer:
                     VALIDATE("Payment Method",BondSetup."Transfer A/c");
                  // BBG1.01 191012 START
                  "Payment Mode"::"D.C./C.C./Net Banking":
                     VALIDATE("Payment Method",BondSetup."D.C./C.C./Net Banking A/c No.");
                  // BBG1.01 191012 END
                  //ALLETDK061212..BEGIN
                  "Payment Mode"::"Refund Cash":
                  BEGIN
                     BondSetup.TESTFIELD("Refund Cash A/C");
                     VALIDATE("Payment Method",BondSetup."Refund Cash A/C");
                END;
                  "Payment Mode"::"Refund Bank":
                  BEGIN
                     BondSetup.TESTFIELD("Refund Cheque A/C");
                     VALIDATE("Payment Method",BondSetup."Refund Cheque A/C");
                  END;
                  //ALLETDK061212..END
                END;
                // VALIDATE(Amount,0);
                */  //ALLEDK 190113

                //"Payment Method" := '';

                IF "Payment Mode" = "Payment Mode"::MJVM THEN BEGIN
                    RecPaymentMethod.RESET;
                    RecPaymentMethod.SETRANGE("Payment Method Type", RecPaymentMethod."Payment Method Type"::MJVM);
                    IF NOT RecPaymentMethod.FINDFIRST THEN
                        ERROR('Create Payment Method for MJVM')
                    ELSE
                        VALIDATE("Payment Method", RecPaymentMethod.Code);
                END;

                IF "Payment Mode" = "Payment Mode"::AJVM THEN BEGIN
                    "AJVM Transfer Type" := "AJVM Transfer Type"::Commission;
                    RecPaymentMethod.RESET;
                    RecPaymentMethod.SETRANGE("Payment Method Type", RecPaymentMethod."Payment Method Type"::AJVM);
                    IF NOT RecPaymentMethod.FINDFIRST THEN
                        ERROR('Create Payment Method for AJVM')
                    ELSE
                        VALIDATE("Payment Method", RecPaymentMethod.Code);
                END;


                IF "Payment Mode" = "Payment Mode"::Cash THEN BEGIN
                    RecPaymentMethod.RESET;
                    RecPaymentMethod.SETRANGE("Payment Method Type", RecPaymentMethod."Payment Method Type"::Cash);
                    IF NOT RecPaymentMethod.FINDFIRST THEN
                        ERROR('Create Payment Method for CASH')
                    ELSE
                        VALIDATE("Payment Method", RecPaymentMethod.Code);
                END;

                //IF "Payment Mode" = "Payment Mode"::Cash THEN
                //"Payment Method" := 'CASH';


                //ALLE280415
                IF "Payment Mode" <> "Payment Mode"::JV THEN BEGIN
                    MemberOf.RESET;
                    MemberOf.SETRANGE("User Name", USERID);
                    MemberOf.SETRANGE("Role ID", 'A_Refund');
                    IF NOT MemberOf.FINDFIRST THEN BEGIN
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", "Document No.");
                        AppPayEntry.SETFILTER("Payment Mode", '%1|%2', AppPayEntry."Payment Mode"::"Refund Cash",
                        AppPayEntry."Payment Mode"::"Refund Bank");
                        AppPayEntry.SETFILTER("Cheque Status", '<>%1', "Cheque Status"::Bounced);
                        AppPayEntry.SETRANGE(Posted, TRUE);
                        IF AppPayEntry.FINDFIRST THEN
                            ERROR('This application' + '' + AppPayEntry."Application No." +
                            'has Refund Entry. So you can not post receipt or other transction');
                    END;
                END;
                //ALLE280415

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
            begin
                UserSetup.GET(USERID);
                TESTFIELD(Posted, FALSE);
                IF ("Payment Mode" = "Payment Mode"::"Refund Bank") THEN BEGIN

                    CreditVoucherAccount.RESET;
                    CreditVoucherAccount.SETRANGE("Account Type", CreditVoucherAccount."Account Type"::"Bank Account");
                    CreditVoucherAccount.SETFILTER("ARM Account Type", '%1|%2', CreditVoucherAccount."ARM Account Type"::Collection,
                    CreditVoucherAccount."ARM Account Type"::Both);
                    CreditVoucherAccount.SETRANGE("Location code", UserSetup."User Branch");
                    CreditVoucherAccount.SETRANGE(Type, CreditVoucherAccount.Type::"Bank Payment Voucher");
                    IF CreditVoucherAccount.FINDFIRST THEN BEGIN
                        IF PAGE.RUNMODAL(Page::"Voucher Posting Credit Account", CreditVoucherAccount) = ACTION::LookupOK THEN BEGIN
                            "Deposit/Paid Bank" := CreditVoucherAccount."Account No.";
                            IF BankACC.GET(CreditVoucherAccount."Account No.") THEN
                                "Deposit / Paid Bank Name" := BankACC.Name
                            ELSE
                                "Deposit / Paid Bank Name" := '';
                        END;
                    END;
                    //Need to check the code in UAT

                END;

                IF ("Payment Mode" = "Payment Mode"::Bank) THEN BEGIN

                    DebitVoucherAccount.RESET;
                    DebitVoucherAccount.SETRANGE("Account Type", DebitVoucherAccount."Account Type"::"Bank Account");
                    DebitVoucherAccount.SETFILTER("ARM Account Type", '%1|%2', DebitVoucherAccount."ARM Account Type"::Collection,
                    DebitVoucherAccount."ARM Account Type"::Both);
                    DebitVoucherAccount.SETRANGE("Location code", UserSetup."User Branch");
                    DebitVoucherAccount.SETRANGE(Type, DebitVoucherAccount.Type::"Bank Receipt Voucher");
                    IF DebitVoucherAccount.FINDFIRST THEN BEGIN
                        IF PAGE.RUNMODAL(Page::"Voucher Posting Debit Accounts", DebitVoucherAccount) = ACTION::LookupOK THEN BEGIN
                            "Deposit/Paid Bank" := DebitVoucherAccount."Account No.";
                            IF BankACC.GET(DebitVoucherAccount."Account No.") THEN
                                "Deposit / Paid Bank Name" := BankACC.Name
                            ELSE
                                "Deposit / Paid Bank Name" := '';
                        END;
                    END;
                    //Need to check the code in UAT

                END;
            end;

            trigger OnValidate()
            begin
                IF "Document Type" IN ["Document Type"::Application, "Document Type"::RD] THEN BEGIN
                    GetUserSetup;
                    UserSetup.TESTFIELD("Responsibility Center");
                    //  UserSetup.TESTFIELD("Shortcut Dimension 2 Code");

                    GetGLSetup;
                    GLSetup.TESTFIELD("Global Dimension 1 Code");
                    /*
                      DefaultDim.RESET;
                      DefaultDim.SETRANGE("Table ID",DATABASE::"Bank Account");
                      DefaultDim.SETRANGE("No.","Deposit/Paid Bank");
                      DefaultDim.SETRANGE("Dimension Code",GLSetup."Global Dimension 1 Code");
                      DefaultDim.SETRANGE("Dimension Value Code",UserSetup."Responsibility Center");
                      IF DefaultDim.ISEMPTY THEN
                        FIELDERROR("Deposit/Paid Bank");
                        */
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
        field(20; "Not Refundable"; Boolean)
        {
            Editable = false;
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
            Editable = true;
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
            Editable = false;
        }
        field(28; Reversed; Boolean)
        {
            CalcFormula = Max("G/L Entry"."BBG Do Not Show" WHERE("Document No." = FIELD("Posted Document No.")));
            FieldClass = FlowField;
        }
        field(29; "Milestone Code"; Code[10])
        {
        }
        field(30; "Commision Applicable"; Boolean)
        {
        }
        field(31; "Direct Associate"; Boolean)
        {
        }
        field(32; "Explode BOM"; Boolean)
        {
            Editable = true;
        }
        field(33; "Reversal Document No."; Code[20])
        {
        }
        field(34; "Order Ref No."; Code[20])
        {
            TableRelation = "Confirmed Order";

            trigger OnLookup()
            var
                ConfOrder_1: Record "New Confirmed Order";
                GetConfOrder_1: Record "New Confirmed Order";
            begin
                IF "Payment Mode" = "Payment Mode"::MJVM THEN
                    IF GetConfOrder.GET("Document No.") THEN BEGIN
                        ConfOrder.RESET;
                        ConfOrder.SETFILTER("No.", '<>%1', "Document No.");
                        ConfOrder.SETFILTER(Status, '%1|%2', ConfOrder.Status::Open, ConfOrder.Status::Vacate);
                        //ConfOrder.SETRANGE("Introducer Code",GetConfOrder."Introducer Code");
                        //ConfOrder.SETRANGE("Customer No.",GetConfOrder."Customer No.");
                        IF ConfOrder.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Unit List", ConfOrder) = ACTION::LookupOK THEN
                                VALIDATE("Order Ref No.", ConfOrder."No.");
                        END;
                    END;
                //ALLEDK 180113
            end;

            trigger OnValidate()
            var
                NewconfOrder_1: Record "New Confirmed Order";
                RecConfOrder_1: Record "New Confirmed Order";
                RecConfirmOrder_1: Record "New Confirmed Order";
                UnitPaymentEntry_1: Record "Unit Payment Entry";
                v_ConfirmedOrder: Record "Confirmed Order";
                v_Application: Record Application;
            begin
                //130321
                v_ConfirmedOrder.RESET;
                IF v_ConfirmedOrder.GET("Order Ref No.") THEN BEGIN
                    v_Application.RESET;
                    IF v_Application.GET("Order Ref No.") THEN BEGIN
                        v_Application.DELETE;
                    END;
                END;

                v_ConfirmedOrder.RESET;
                IF v_ConfirmedOrder.GET("Document No.") THEN BEGIN
                    v_Application.RESET;
                    IF v_Application.GET("Document No.") THEN BEGIN
                        v_Application.DELETE;
                    END;
                END;
                //130321

                IF "Order Ref No." = "Document No." THEN
                    ERROR('This Order Ref No. must be different to Confirmed Order No.');

                IF RecConfOrder_1.GET("Document No.") THEN;
                IF RecConfirmOrder_1.GET("Order Ref No.") THEN BEGIN
                    IF RecConfirmOrder_1.Status = RecConfirmOrder_1.Status::Cancelled THEN
                        ERROR('The Transfer From Appl. No. status is Cancelled. Select another App. No.');
                    RecConfirmOrder_1.TESTFIELD("Application Closed", FALSE);
                END;
                /*
                AppEntry_1.RESET;
                AppEntry_1.SETRANGE("Document No.","Order Ref No.");
                AppEntry_1.SETFILTER("Payment Mode",'%1|%2',AppEntry_1."Payment Mode"::"Refund Bank",AppEntry_1."Payment Mode"::"Refund Cash");
                AppEntry_1.SETFILTER("Cheque Status",'<>%1',AppEntry_1."Cheque Status"::Bounced);
                IF AppEntry_1.FINDFIRST THEN
                  ERROR('The application-'+' '+"Order Ref No."+ 'having Refund entry' );
                
                AppEntry_1.RESET;
                AppEntry_1.SETRANGE("Document No.","Document No.");
                AppEntry_1.SETFILTER("Payment Mode",'%1|%2',AppEntry_1."Payment Mode"::"Refund Bank",AppEntry_1."Payment Mode"::"Refund Cash");
                AppEntry_1.SETFILTER("Cheque Status",'<>%1',AppEntry_1."Cheque Status"::Bounced);
                IF AppEntry_1.FINDFIRST THEN
                  ERROR('The application-'+' '+"Document No."+ 'having Refund entry' );
                  */

                TotalRecAmt := 0;
                NewconfOrder_1.RESET;
                IF NewconfOrder_1.GET("Order Ref No.") THEN BEGIN
                    NewconfOrder_1.TESTFIELD("Application Closed", FALSE);
                    /*
                      IF NewconfOrder_1."Application Type" = NewconfOrder_1."Application Type"::"Non Trading" THEN BEGIN
                        UnitPaymentEntry_1.RESET;
                        UnitPaymentEntry_1.CHANGECOMPANY(NewconfOrder_1."Company Name");
                        UnitPaymentEntry_1.SETRANGE("Document No.","Order Ref No.");
                        UnitPaymentEntry_1.SETFILTER("Charge Code",'<>%1&<>%2','ADMIN','ADMIN2');
                        IF UnitPaymentEntry_1.FINDSET THEN BEGIN
                          REPEAT
                            IF (UnitPaymentEntry_1."Payment Mode" = UnitPaymentEntry_1."Payment Mode"::Cash) OR
                              (UnitPaymentEntry_1."Cheque Status" = UnitPaymentEntry_1."Cheque Status"::Cleared) THEN BEGIN
                              TotalRecAmt := TotalRecAmt + UnitPaymentEntry_1.Amount;
                            END;
                          UNTIL UnitPaymentEntry_1.NEXT =0;
                          IF TotalRecAmt >=RecConfirmOrder_1."Min. Allotment Amount" THEN
                            ERROR('Application %1 Min. Allotment Amount is already Received',"Order Ref No.");
                        END;
                      END ELSE BEGIN
                     */



                    TotalRecAmt := 0;
                    UnitPaymentEntry.RESET;
                    UnitPaymentEntry.SETRANGE("Document No.", "Order Ref No.");
                    UnitPaymentEntry.SETFILTER("Charge Code", '<>%1&<>%2', 'ADMIN', 'ADMIN2');
                    IF UnitPaymentEntry.FINDSET THEN BEGIN
                        REPEAT
                            IF (UnitPaymentEntry."Payment Mode" = UnitPaymentEntry."Payment Mode"::Cash) OR
                              (UnitPaymentEntry."Cheque Status" = UnitPaymentEntry."Cheque Status"::Cleared) THEN BEGIN
                                TotalRecAmt := TotalRecAmt + UnitPaymentEntry.Amount;
                            END;
                        UNTIL UnitPaymentEntry.NEXT = 0;

                        //      IF RecConfirmOrder_1."Introducer Code" <> RecConfOrder_1."Introducer Code" THEN BEGIN
                        MemberOf.RESET;
                        MemberOf.SETRANGE("User Name", USERID);
                        MemberOf.SETRANGE("Role ID", 'MJVMBYPASS');
                        IF NOT MemberOf.FINDSET THEN BEGIN
                            IF TotalRecAmt >= RecConfirmOrder_1."Min. Allotment Amount" THEN BEGIN
                                IF RecConfirmOrder_1."Introducer Code" <> RecConfOrder_1."Introducer Code" THEN
                                    ERROR('Application %1 Min. Allotment Amount is already Received', "Order Ref No.");
                            END;
                        END;
                    END;
                    //END;

                    IF (TotalRecAmt - Amount) < 0 THEN BEGIN
                        ERROR(Text50002, "Order Ref No.", TotalRecAmt);
                    END;
                END ELSE
                    ERROR('No Sufficient Balance');


                /*//010316 old comment
                IF "Order Ref No." = "Document No." THEN
                  ERROR('This Order Ref No. must be different to Confirmed Order No.');
                
                IF RecConfOrder_1.GET("Document No.") THEN;
                IF RecConfirmOrder_1.GET("Order Ref No.") THEN BEGIN
                  IF RecConfirmOrder_1.Status = RecConfirmOrder_1.Status::Cancelled THEN
                    ERROR('The Transfer From Appl. No. status is Cancelled. Select another App. No.');
                END;
                
                TotalRecAmt :=0;
                NewconfOrder_1.RESET;
                IF NewconfOrder_1.GET("Order Ref No.") THEN BEGIN
                  IF NewconfOrder_1."Application Type" = NewconfOrder_1."Application Type"::"Non Trading" THEN BEGIN
                    UnitPaymentEntry_1.RESET;
                    UnitPaymentEntry_1.CHANGECOMPANY(NewconfOrder_1."Company Name");
                    UnitPaymentEntry_1.SETRANGE("Document No.","Order Ref No.");
                    UnitPaymentEntry_1.SETFILTER("Charge Code",'<>%1&<>%2','ADMIN','ADMIN2');
                    IF UnitPaymentEntry_1.FINDSET THEN BEGIN
                      REPEAT
                        IF (UnitPaymentEntry_1."Payment Mode" = UnitPaymentEntry_1."Payment Mode"::Cash) OR
                          (UnitPaymentEntry_1."Cheque Status" = UnitPaymentEntry_1."Cheque Status"::Cleared) THEN BEGIN
                          TotalRecAmt := TotalRecAmt + UnitPaymentEntry_1.Amount;
                        END;
                      UNTIL UnitPaymentEntry_1.NEXT =0;
                      IF TotalRecAmt >=RecConfirmOrder_1."Min. Allotment Amount" THEN
                        ERROR('Application %1 Min. Allotment Amount is already Received',"Order Ref No.");
                    END;
                  END ELSE BEGIN
                    TotalRecAmt :=0;
                    UnitPaymentEntry.RESET;
                    UnitPaymentEntry.SETRANGE("Document No.","Order Ref No.");
                    UnitPaymentEntry.SETFILTER("Charge Code",'<>%1&<>%2','ADMIN','ADMIN2');
                    IF UnitPaymentEntry.FINDSET THEN BEGIN
                        REPEAT
                          IF (UnitPaymentEntry."Payment Mode" = UnitPaymentEntry."Payment Mode"::Cash) OR
                            (UnitPaymentEntry."Cheque Status" = UnitPaymentEntry."Cheque Status"::Cleared) THEN BEGIN
                            TotalRecAmt := TotalRecAmt + UnitPaymentEntry.Amount;
                          END;
                        UNTIL UnitPaymentEntry.NEXT =0;
                
                      IF RecConfirmOrder_1."Introducer Code" <> RecConfOrder_1."Introducer Code" THEN BEGIN
                        IF TotalRecAmt >=RecConfirmOrder_1."Min. Allotment Amount" THEN
                          ERROR('Application %1 Min. Allotment Amount is already Received',"Order Ref No.");
                      END;
                    END;
                  END;
                
                  IF (TotalRecAmt - Amount) < 0 THEN BEGIN
                    ERROR(Text50002,"Order Ref No.",TotalRecAmt);
                  END;
                END ELSE
                  ERROR('No Sufficient Balance');
                    */ //010316 comment

            end;
        }
        field(36; "User Branch Code"; Code[20])
        {
            TableRelation = Location WHERE("BBG Branch" = CONST(true));
        }
        field(50000; "Created From Application"; Boolean)
        {
            Description = 'ALLEDK 091012';
            Editable = true;
        }
        field(50001; "Deposit / Paid Bank Name"; Text[60])
        {
            Description = 'ALLEDK 101012';
            Editable = false;
        }
        field(50002; "Gold Coin Eligibility"; Boolean)
        {
            Description = 'BBG161012';
        }
        field(50003; "Introducer Code"; Code[20])
        {
            Description = 'BBG181012';
            TableRelation = Vendor;
        }
        field(50004; "Priority Payment"; Boolean)
        {
        }
        field(50005; Approved; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Payment Mode" = "Payment Mode"::AJVM THEN BEGIN
                    MemberOf.RESET;
                    MemberOf.SETRANGE("User Name", USERID);
                    MemberOf.SETFILTER(MemberOf."Role ID", '%1', 'AJVM');
                    IF NOT MemberOf.FINDFIRST THEN
                        ERROR('You are not authorised person to allowed post this Document');
                    IF Approved THEN BEGIN
                        "Approved By" := USERID;
                        "Approved Date" := TODAY;
                    END ELSE BEGIN
                        "Approved By" := '';
                        "Approved Date" := 0D;
                    END;
                END;
            end;
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
            Description = 'ALLEDK 271212';
            Editable = false;
            TableRelation = User;
        }
        field(50009; "Associate Transfer Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                //TESTFIELD("Payment Mode","Payment Mode"::AJVM);
                IF "Payment Mode" = "Payment Mode"::AJVM THEN BEGIN
                    UnitSetup.GET;
                    UnitSetup.TESTFIELD("Corpus %");
                    TDSP := CalculateTDSPercentage;
                    //IF "AJVM Transfer Type"="AJVM Transfer Type"::Commission THEN
                    ClubP := UnitSetup."Corpus %";
                    //ELSE
                    //CLEAR(ClubP);
                    VALIDATE(Amount, ("Associate Transfer Amount") - (("Associate Transfer Amount" * (ClubP / 100)) +
                             ("Associate Transfer Amount" * (TDSP / 100))));
                    "TDS Amount" := ("Associate Transfer Amount" * (TDSP / 100));
                    //IF "AJVM Transfer Type"="AJVM Transfer Type"::Commission THEN BEGIN
                    "Club 9 Amount" := ("Associate Transfer Amount" * (ClubP / 100));
                    "Club 9%" := ClubP;
                    /*
                    END ELSE BEGIN
                      "Club 9 Amount" := 0;
                      "Club 9%" := 0;
                    END;
                    */
                END;
                IF "Payment Mode" = "Payment Mode"::"Negative Adjmt." THEN BEGIN
                    UnitSetup.GET;
                    UnitSetup.TESTFIELD("Corpus %");
                    //IF "AJVM Transfer Type" = "AJVM Transfer Type"::Commission THEN BEGIN
                    TDSP := CalculateTDSPercentage;
                    ClubP := UnitSetup."Corpus %";
                    /*
                    END ELSE BEGIN
                      CLEAR(TDSP);
                      CLEAR(ClubP);
                    END;
                    */
                    VALIDATE(Amount, (("Associate Transfer Amount") - (("Associate Transfer Amount" * (ClubP / 100)) +
                             ("Associate Transfer Amount" * (TDSP / 100)))));
                    "TDS Amount" := ("Associate Transfer Amount" * (TDSP / 100));
                    "Club 9 Amount" := ("Associate Transfer Amount" * (ClubP / 100));
                    "Club 9%" := ClubP;
                END;

            end;
        }
        field(50010; "TDS %"; Decimal)
        {
            Editable = false;
        }
        field(50011; "Associate Code For Disc"; Code[20])
        {
            Description = 'ALLEDK 090113';
            Editable = false;
            TableRelation = Vendor;
        }
        field(50012; "TDS Amount"; Decimal)
        {
            Editable = false;
        }
        field(50013; "Club 9%"; Decimal)
        {
            Editable = false;
        }
        field(50014; "Club 9 Amount"; Decimal)
        {
            Editable = false;
        }
        field(50015; "Adjmt. Line No."; Integer)
        {
            Description = 'ALLETDK280213';
            TableRelation = IF ("Payment Mode" = CONST("Negative Adjmt.")) "Application Payment Entry"."Line No." WHERE("Document No." = FIELD("Document No."),
                                                                                                                   "Payment Mode" = FILTER(Cash | AJVM),
                                                                                                                   Posted = CONST(true));

            trigger OnValidate()
            var
                AdjmtAmt: Decimal;
            begin
                IF "Payment Mode" <> "Payment Mode"::JV THEN BEGIN
                    AppPaymentEntry.GET("Document Type", "Document No.", "Adjmt. Line No.");
                    VALIDATE("Payment Method", AppPaymentEntry."Payment Method");
                    VALIDATE("AJVM Transfer Type", AppPaymentEntry."AJVM Transfer Type");
                END;
            end;
        }
        field(50016; "AJVM Associate Code"; Code[20])
        {
            CalcFormula = Lookup("Vendor Ledger Entry"."Vendor No." WHERE("Document No." = FIELD("Posted Document No."),
                                                                           "Order Ref No." = FIELD("Document No.")));
            Description = 'ALLETDK280213';
            FieldClass = FlowField;
        }
        field(50017; Narration; Text[80])
        {
            Description = 'ALLETDK010313';

            trigger OnValidate()
            begin
                IF Posted THEN BEGIN
                    CLEAR(MemberOf);
                    MemberOf.RESET;
                    MemberOf.SETRANGE("User Name", USERID);
                    MemberOf.SETRANGE("Role ID", 'A_NarrUpdate');
                    IF NOT MemberOf.FINDFIRST THEN
                        ERROR('You are not authorised person to perform this task. Please contact to Admin Dept.');
                END;
            end;
        }
        field(50018; "Provisional Rcpt. No."; Code[20])
        {
            Description = 'ALLETDK010313';
        }
        field(50019; "User Branch Name"; Text[70])
        {
            Description = 'ALLECK 280313';
            Editable = false;
        }
        field(50020; "AJVM Transfer Type"; Option)
        {
            Description = 'ALLETDK290313';
            OptionCaption = ',Commission,Incentive';
            OptionMembers = ,Commission,Incentive;
        }
        field(50100; "Opening Entries"; Boolean)
        {
            Description = 'BBG1.00 030413';
            Editable = false;
        }
        field(50101; "No. Printed"; Integer)
        {
        }
        field(50102; "LD Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                BondSetup.GET;
                BondSetup.TESTFIELD("LD Account");
                IF ("Payment Mode" IN ["Payment Mode"::"Refund Cash", "Payment Mode"::"Refund Bank"]) THEN
                    "LD Amount" := -1 * "LD Amount";
                IF ("Payment Mode" IN ["Payment Mode"::"Refund Cash", "Payment Mode"::"Refund Bank"]) AND ("LD Amount" > 0) THEN
                    ERROR('Amount must be Negative Refunds');
            end;
        }
        field(50103; "Reversed AJVM Payment"; Boolean)
        {
            Editable = false;
        }
        field(50201; "Discount Payment Type"; Option)
        {
            Description = 'BBG1.6 311213';
            OptionCaption = ' ,Forfeit,Excess Payment';
            OptionMembers = " ",Forfeit,"Excess Payment";
        }
        field(50202; "check app"; Boolean)
        {
        }
        field(50203; "Reverse AJVM Invoice"; Boolean)
        {
            Description = 'BBG2.00 300714';
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD("Payment Mode", "Payment Mode"::AJVM);  //BBG2.00
                TESTFIELD("Reversed AJVM Invoice", FALSE);
            end;
        }
        field(50204; "Reversed AJVM Invoice"; Boolean)
        {
            Description = 'BBG2.00 300714';
            Editable = false;
        }
        field(50205; "MSC Post Doc. No."; Code[20])
        {
            Editable = false;
        }
        field(50206; "Reverse Commission"; Boolean)
        {
            Editable = false;
        }
        field(50220; "Bank Type"; Option)
        {
            OptionCaption = ' ,CollectionCompany,ProjectCompany';
            OptionMembers = " ",CollectionCompany,ProjectCompany;
        }
        field(50221; "MSC Bank Code"; Code[20])
        {
            Editable = false;
        }
        field(50222; "Entry From MSC"; Boolean)
        {
            Editable = false;
        }
        field(50223; "Not Post JV Entry in MSC"; Boolean)
        {
            Editable = false;
        }
        field(50230; "Commission Reversed"; Boolean)
        {
            Description = 'ALLE240415';
            Editable = false;
        }
        field(50231; "Order Status"; Option)
        {
            CalcFormula = Lookup("Confirmed Order".Status WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
            OptionCaption = 'Open,Documented,Cash Dispute,Documentation Dispute,Verified,Active,Death Claim,Maturity Claim,Maturity Dispute,Matured,Dispute,Blocked (Loan),Registered,Cancelled,Vacate,Forfeit';
            OptionMembers = Open,Documented,"Cash Dispute","Documentation Dispute",Verified,Active,"Death Claim","Maturity Claim","Maturity Dispute",Matured,Dispute,"Blocked (Loan)",Registered,Cancelled,Vacate,Forfeit;
        }
        field(50232; "Ref.Inter Post Document No."; Code[20])
        {
        }
        field(50233; "MJV Entry Posted"; Boolean)
        {
        }
        field(50234; "Balance Account No."; Code[20])
        {
        }
        field(50235; "Payment Mode New"; Option)
        {
            OptionCaption = ' ,AJVM ELEG,AJVM ADV';
            OptionMembers = " ","AJVM ELEG","AJVM ADV";
        }
        field(50236; "Receipt Line No."; Integer)
        {
            Editable = false;
        }
        field(50237; "Service Tax Amount"; Decimal)
        {
            Editable = false;
        }
        field(50238; "Service Tax Group"; Code[20])
        {
        }
        field(50239; "Service Tax Reg. No."; Code[20])
        {
        }
        field(50240; "Advance Payment Service Tax"; Boolean)
        {
        }
        field(50241; "Service Tax Base amount"; Decimal)
        {
            Editable = false;
        }
        field(50244; "Cheque No.1"; Code[20])
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Cheque No.1" WHERE("Document No." = FIELD("Posted Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50257; "Send for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '270923 Approval Workflow';
            Editable = false;
        }
        field(50258; "Send for Approval DT"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = '270923 Approval Workflow';
            Editable = false;
        }
        field(50300; "APP transfer in LLPs"; Boolean)
        {
            Editable = false;
        }
        field(50301; "AMJV Payment Reverse"; Boolean)
        {
        }
        field(50335; "GST Group Code"; Code[20])
        {
            Caption = 'GST Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "GST Group";

            trigger OnValidate()
            var
                GSTGroup: Record "GST Group";// 16404;
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
        field(50340; "CGST Amount"; Decimal)
        {
            CalcFormula = Sum("GST Ledger Entry"."GST Amount" WHERE("Document No." = FIELD("Posted Document No."),
                                                                     "GST Component Code" = CONST('CGST')));
            FieldClass = FlowField;
        }
        field(50341; "SGST Amount"; Decimal)
        {
            CalcFormula = Sum("GST Ledger Entry"."GST Amount" WHERE("Document No." = FIELD("Posted Document No."),
                                                                     "GST Component Code" = CONST('SGST')));
            FieldClass = FlowField;
        }
        field(50342; "IGST Amount"; Decimal)
        {
            CalcFormula = Sum("GST Ledger Entry"."GST Amount" WHERE("Document No." = FIELD("Posted Document No."),
                                                                     "GST Component Code" = CONST('IGST')));
            FieldClass = FlowField;
        }
        field(50343; "Posting Required"; Text[50])
        {
            CalcFormula = Lookup("New Application DevelopmntLine".Remarks WHERE("Document No." = FIELD("Document No."),
                                                                                 "Line No." = FIELD("Receipt Line No.")));
            FieldClass = FlowField;
        }
        field(50344; "GL Entry Amount"; Decimal)
        {
            CalcFormula = Lookup("G/L Entry".Amount WHERE("Document No." = FIELD("Posted Document No."),
                                                           "Bal. Account No." = CONST('999999'),
                                                           "BBG Order Ref No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(50345; "Apply doc no."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50346; "Mm Code"; Code[20])
        {
            CalcFormula = Lookup("New Confirmed Order"."Customer No." WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(50347; Noofentry; Integer)
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
        key(Key7; "Document Type", "Application No.", Posted, "Cheque Status", "Priority Payment")
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
        key(Key16; "Posted Document No.")
        {
        }
        key(Key17; "Document No.", "Cheque Status")
        {
            SumIndexFields = Amount;
        }
        key(Key18; "MSC Post Doc. No.")
        {
        }
        key(Key19; "Document No.", "MSC Post Doc. No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CheckRegistration;
        TESTFIELD(Posted, FALSE);
        //UpdateAmount();
    end;

    trigger OnInsert()
    begin
        //CheckExistingLines;
        CheckRegistration;
        CheckAppPaymentPlan;
        BPayEntry.RESET;
        BPayEntry.SETRANGE("Document Type", "Document Type");
        BPayEntry.SETFILTER(BPayEntry."Document No.", "Document No.");
        IF BPayEntry.FIND('+') THEN BEGIN
            "Line No." := BPayEntry."Line No." + 10000;
        END ELSE
            "Line No." := 10000;

        //IF "Payment Mode" <> "Payment Mode"::AJVM THEN
        TESTFIELD("Payment Method");
        //IF ("Payment Mode" <> "Payment Mode"::Cash) AND ("Payment Mode" <> "Payment Mode"::MJVM)
        //AND ("Payment Mode" <> "Payment Mode"::"Refund Cash") AND ("Payment Mode" <> "Payment Mode"::AJVM) THEN BEGIN //ALLETDK
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
        //"Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        "Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        //"User Branch Code" := UserSetup."User Branch";
        "User Branch Code" := UserSetup."Responsibility Center";

        "Application No." := "Document No."; //ALLEDK 091012
        "User ID" := USERID;  //ALLEDK 271212
        IF "Payment Mode" <> "Payment Mode"::Bank THEN
            "Cheque Status" := "Cheque Status"::Cleared;

        //ALLEDK 250113
        ConfOrdernew.RESET;
        ConfOrdernew.SETRANGE("No.", "Document No.");
        IF ConfOrdernew.FINDFIRST THEN BEGIN
            "Shortcut Dimension 1 Code" := ConfOrdernew."Shortcut Dimension 1 Code";
        END ELSE BEGIN
            RecApplication.RESET;
            RecApplication.SETRANGE("Application No.", "Document No.");
            IF RecApplication.FINDFIRST THEN BEGIN
                RecApplication.TESTFIELD(Status, RecApplication.Status::Open);
                "Shortcut Dimension 1 Code" := RecApplication."Shortcut Dimension 1 Code";
            END;
        END;
        //ALLEDK 250113
    end;

    trigger OnModify()
    begin
        CheckRegistration;
        //TESTFIELD(Posted,FALSE);

        IF ("Payment Mode" <> "Payment Mode"::AJVM) THEN
            TESTFIELD("Payment Method");
        //IF ("Payment Mode" <> "Payment Mode"::Cash) AND ("Payment Mode" <> "Payment Mode"::MJVM)
        //AND ("Payment Mode" <> "Payment Mode"::"Refund Cash") AND ("Payment Mode" <> "Payment Mode"::AJVM) AND
        //("Payment Mode" <> "Payment Mode"::JV)THEN BEGIN //ALLETDK
        IF ("Payment Mode" IN ["Payment Mode"::Bank, "Payment Mode"::"Refund Bank"]) THEN BEGIN
            IF "Deposit/Paid Bank" <> '' THEN BEGIN
                TESTFIELD("Cheque No./ Transaction No.");
                TESTFIELD("Cheque Date");
                IF "Payment Mode" = "Payment Mode"::Bank THEN
                    TESTFIELD("Cheque Bank and Branch");
                TESTFIELD("Deposit/Paid Bank");
            END;
            //TESTFIELD("Cheque Bank and Branch");
        END;
        //UpdateAmount();
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
        Application: Record Application;
        Bond: Record "Confirmed Order";
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
        BPayEntry: Record "Application Payment Entry";
        Text0013: Label 'The Order is already Exploded.\Not allowed to enter New Line';
        Text0014: Label 'Order is already Registered.\Not allowed to modify or delete';
        Text0015: Label 'Order is already Cancelled.\Not allowed to modify or delete';
        TotalApplAmt2: Decimal;
        TotalRcvdAmt2: Decimal;
        Vendor: Record Vendor;
        Text50000: Label 'Associate %1 PAN No. not verified';
        BankAccount: Record "Bank Account";
        ConfirmOrder: Record "Confirmed Order";
        APPNo: Record Application;
        Text50001: Label 'Total Receipt Amount is greater than Amount = %1. Do you want to continue?';
        RecConfirmOrder: Record "Confirmed Order";
        RecConfOrder: Record "Confirmed Order";
        AppPayEntry: Record "Application Payment Entry";
        UnitReversal: Codeunit "Unit Reversal";
        Amt: Decimal;
        CommissionEntry: Record "Commission Entry";
        CommAmt: Decimal;
        UnitSetup: Record "Unit Setup";
        AppEntry_1: Record "Application Payment Entry";
        Vend: Record Vendor;
        TDSP: Decimal;
        ClubP: Decimal;
        ConfOrder: Record "Confirmed Order";
        //NODNOCHdr: Record 13786;//Need to check the code in UAT

        AppPaymentEntry: Record "Application Payment Entry";
        LastLineNo: Integer;
        InsertAppLines: Record "Application Payment Entry";
        Text50002: Label 'Total Received Amount on Application No.-%1 is %2. The Amount must be less or equal.';
        GetConfOrder: Record "Confirmed Order";
        RecPaymentMethod: Record "Payment Method";
        RecApplication: Record Application;
        UnitPaymentEntry: Record "Unit Payment Entry";
        TotalRecAmt: Decimal;
        AJVMCode: Code[20];
        VendCode: Code[20];
        //VoucherAccount: Record 16547;//Need to check the code in UAT
        DebitVoucherAccount: Record "Voucher Posting Debit Account";
        CreditVoucherAccount: Record "Voucher Posting Credit Account";
        BankACC: Record "Bank Account";
        ConfOrdernew: Record "Confirmed Order";
        Loc: Record Location;
        MemberOf: Record "Access Control";
        v_ConfirmedOrder_1: Record "Confirmed Order";


    procedure CheckCashAmount()
    var
        BondSetup: Record "Unit Setup";
        PaymentLines: Record "Application Payment Entry";
        CashAmount: Decimal;
    begin
        IF "Document Type" = "Document Type"::Application THEN
            IF "Payment Mode" = "Payment Mode"::Cash THEN BEGIN
                PaymentLines := Rec;
                SETRANGE("Document Type", "Document Type");
                SETRANGE("Document No.", "Document No.");
                SETRANGE("Payment Mode", "Payment Mode"::Cash);
                SETRANGE("Not Refundable", FALSE);
                SETFILTER("Line No.", '<>%1', "Line No.");
                IF FINDSET THEN
                    REPEAT
                        CashAmount += Amount;
                    UNTIL NEXT = 0;
                SETRANGE("Document Type");
                SETRANGE("Document No.");
                SETRANGE("Payment Mode");
                SETRANGE("Not Refundable");
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
        //ALLETDK081112..COMEMNT CODE
        /*
        IF TotalApplAmt - TotalRcvdAmt < 0 THEN
            ERROR(STRSUBSTNO(Text0011,TotalApplAmt - TotalRcvdAmt + Amount));
        */
        //ALLETDK081112..COMEMNT CODE
        //ALLETDK141112..BEGIN
        IF TotalApplAmt - TotalRcvdAmt < 0 THEN BEGIN
            IF NOT CONFIRM(Text50001, FALSE, TotalApplAmt) THEN
                ERROR(STRSUBSTNO(Text0011, TotalApplAmt - TotalRcvdAmt + Amount));
        END;
        //ALLETDK141112..END

    end;


    procedure UpdateAmount()
    var
        PmtLines: Record "Application Payment Entry";
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
        //SETRANGE("Payment Mode","Payment Mode"::Cash);
        //SETRANGE("Not Refundable",FALSE);
        SETFILTER("Line No.", '<>%1', "Line No.");
        IF FINDSET THEN
            REPEAT
                TotalRcvdAmt += Amount;
            UNTIL NEXT = 0;

        SETRANGE("Document Type");
        SETRANGE("Document No.");
        //SETRANGE("Payment Mode");
        //SETRANGE("Not Refundable");
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
        Bond: Record "Confirmed Order";
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
        Application: Record Application;
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
        PmtLines: Record "Application Payment Entry";
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
        RecConfirmOrder: Record "Confirmed Order";
        AppPayEntry: Record "Application Payment Entry";
        TotRcptAmt: Decimal;
    begin
        /*
        //ALLETDK141112..BEGIN
        RecConfirmOrder.GET("Document No.");
        TotRcptAmt := Amount;
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document Type","Document Type");
        AppPayEntry.SETRANGE("Document No.","Document No.");
        AppPayEntry.SETFILTER("Line No.",'<>%1',"Line No.");
        AppPayEntry.SETFILTER("Cheque Status",'<>%1',AppPayEntry."Cheque Status"::Bounced);
        IF AppPayEntry.FINDSET THEN
        REPEAT
          TotRcptAmt+=AppPayEntry.Amount;
        UNTIL AppPayEntry.NEXT=0;
        IF (RecConfirmOrder.Amount+RecConfirmOrder."Service Charge Amount"-TotRcptAmt) < 0 THEN BEGIN
           IF NOT CONFIRM(Text50001,FALSE,RecConfirmOrder.Amount+RecConfirmOrder."Service Charge Amount") THEN
             ERROR(STRSUBSTNO(Text0011,RecConfirmOrder.Amount+RecConfirmOrder."Service Charge Amount"-TotRcptAmt + Amount));
        END;
        //ALLETDK141112..END
        */

    end;


    procedure CalculateTDSPercentage(): Decimal
    var
        TDSPercent: Decimal;
        eCessPercent: Decimal;
        SheCessPercent: Decimal;
        RecTDSSetup: Record "TDS Setup";// 13728;
        //RecNODHeader: Record 13786;//Need to check the code in UAT

        //RecNODLines: Record 13785;//Need to check the code in UAT
        Vendor: Record Vendor;
        AllowedSection: Record "Allowed Sections";
        TaxRate: Record "Tax Rate";
        RAPE: Record "Application Payment Entry";
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
            RAPE.GET("Document Type", "Document No.", "Adjmt. Line No.");
            RAPE.CALCFIELDS("AJVM Associate Code");
            VendCode := RAPE."AJVM Associate Code";
        END;

        IF Vendor.Get(VendCode) then;
        AllowedSection.Reset();
        AllowedSection.SetRange("Vendor No", VendCode);
        AllowedSection.SetRange("TDS Section", UnitSetup."TDS Nature of Deduction");
        IF AllowedSection.FindFirst() Then begin
            TDSPercent := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
            EXIT(((10000 * TDSPercent) + (100 * TDSPercent * eCessPercent) + (100 * TDSPercent * SheCessPercent) +
                  (TDSPercent * eCessPercent * SheCessPercent)) / 10000);
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
            ERROR('TDS Setup does not exist');
            *///Need to check the code in UAT

    end;
}

