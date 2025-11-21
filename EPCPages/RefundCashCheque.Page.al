page 98011 "Refund Cash/Cheque"
{
    // Upgrade140118 code comment

    PageType = Document;
    SourceTable = "Confirmed Order";
    SourceTableView = WHERE("Application Transfered" = FILTER(true));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group("Confirmed application")
            {
                field("No."; Rec."No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Pass Book No."; Rec."Pass Book No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Member No.';
                }
                field("Member Name"; Customer.Name)
                {
                    Caption = 'Member Name';
                }
                field("Project Name"; GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1))
                {
                }
                field("Dummay Unit Code"; Rec."Dummay Unit Code")
                {
                    Caption = 'Priority Unit Code';
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
            }
            group(General)
            {
                field("Project Type"; Rec."Project Type")
                {
                    Caption = 'Commission Code';
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                }
                field("LLP Name"; Rec."LLP Name")
                {
                }
                field("Version No."; Rec."Version No.")
                {
                }
                field("Received From Code"; Rec."Received From Code")
                {
                }
                field("Return Payment Mode"; Rec."Return Payment Mode")
                {
                }
                field("Dispute Remark"; Rec."Dispute Remark")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Total Amount';
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                }
                field("Net Amount"; Rec.Amount - Rec."Discount Amount")
                {
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                }
                field("Due Amount"; Rec.Amount + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field("Project change Comment"; Rec."Project change Comment")
                {
                }
                field("Application Type"; Rec."Application Type")
                {
                }
            }
            group("Application Information")
            {
                field(Status; Rec.Status)
                {
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                }
                field("Posted Doc No."; Rec."Posted Doc No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                }
                field("Commission Paid"; Rec."Commission Paid")
                {
                }
                field("Gold Coin Generated"; Rec."Gold Coin Generated")
                {
                }
                field("Travel Generate"; Rec."Travel Generate")
                {
                }
                field("Gold Coin Issued"; Rec."Gold Coin Issued")
                {
                }
            }
            part("Receipt Lines"; "Unit Payment Entry  Subform")
            {
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(false));
                UpdatePropagation = Both;
            }
            part(PostedUnitPayEntrySubform; "Posted Unit Pay Entry Subform")
            {
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(true));
            }
            part(History; "Unit History Subform")
            {
                SubPageLink = "Unit No." = FIELD("No.");
            }
            part(Comment; "Unit Comment Sheet")
            {
                SubPageLink = "Table Name" = FILTER('Confirmed order'),
                              "No." = FIELD("No.");
            }
            part("Print Log"; "Unit Print Log Subform")
            {
                SubPageLink = "Unit No." = FIELD("No.");
            }
            group("Unit Holder")
            {
                group("Unit Holder1")
                {
                    field(Name; Customer.Name)
                    {
                    }
                    field(Relation; Customer.Contact)
                    {
                    }
                    field(Address; Customer.Address)
                    {
                    }
                    field("Address 2"; Customer."Address 2")
                    {
                    }
                    field(City; Customer.City)
                    {
                    }
                    field("Post Code"; Customer."Post Code")
                    {
                    }
                }
                group("Unit Holder Bank Detail")
                {
                    field("Customer Bank Branch"; GetDescription.GetCustBankBranchName(Rec."Customer No.", Rec."Application No."))
                    {
                    }
                    field("Customer Bank Account No."; GetDescription.GetCustBankAccountNo(Rec."Customer No.", Rec."Application No."))
                    {
                    }
                }
                group("2nd Applicant")
                {
                    field("No1."; Customer2."No.")
                    {
                        Caption = 'No.';
                    }
                    field(Customer2Name; Customer2.Name)
                    {
                        Caption = 'Name';
                    }
                    field(Relation1; Customer2.Contact)
                    {
                        Caption = 'Relation';
                    }
                    field(Address1; Customer2.Address)
                    {
                        Caption = 'Address';
                    }
                    field(Address2; Customer2."Address 2")
                    {
                        Caption = 'Address 2';
                    }
                    field(City1; Customer2.City)
                    {
                        Caption = 'City';
                    }
                    field(PostCode; Customer2."Post Code")
                    {
                        Caption = 'Post Code';
                    }
                }
            }
            group(Nominee)
            {
                field(Title; FORMAT(BondNominee.Title))
                {
                }
                field(Name3; BondNominee.Name)
                {
                    Caption = 'Name';
                }
                field(Address4; BondNominee.Address)
                {
                    Caption = 'Address';
                }
                field("Address4-2"; BondNominee."Address 2")
                {
                    Caption = 'Address 2';
                }
                field(City3; BondNominee.City)
                {
                    Caption = 'City';
                }
                field(PostCode2; BondNominee."Post Code")
                {
                    Caption = 'Post Code';
                }
                field(Age; BondNominee.Age)
                {
                }
                field(Relation4; BondNominee.Relation)
                {
                    Caption = 'Relation';
                }
            }
            group("Registration Details")
            {
                field("Registration No."; Rec."Registration No.")
                {
                }
                field("Registration Date"; Rec."Registration Date")
                {
                }
                field("Reg. Office"; Rec."Reg. Office")
                {
                }
                field("Registration In Favour Of"; Rec."Registration In Favour Of")
                {
                }
                field("Registered/Office Name"; Rec."Registered/Office Name")
                {
                }
                field("Reg. Address"; Rec."Reg. Address")
                {
                }
                field("Father/Husband Name"; Rec."Father/Husband Name")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Registered City"; Rec."Registered City")
                {
                }
                field("Zip Code"; Rec."Zip Code")
                {
                }
            }
            group(NEFT)
            {
                field("Bank Name"; CustomerBankAccount.Name)
                {
                }
                field("IFSC Code"; CustomerBankAccount."SWIFT Code")
                {
                }
                field("Bank Branch No."; CustomerBankAccount."Bank Branch No.")
                {
                }
                field("Bank Branch Name"; CustomerBankAccount."Name 2")
                {
                }
                field("Account No."; CustomerBankAccount."Bank Account No.")
                {
                }
                field("UserID"; CustomerBankAccount."USER ID")
                {
                }
                field("Entry Status"; CustomerBankAccount."Entry Completed")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Print)
            {
                action("Commission Print")
                {

                    trigger OnAction()
                    begin

                        ComEntry.RESET;
                        ComEntry.SETCURRENTKEY("Application No.");
                        ComEntry.SETRANGE("Application No.", Rec."Application No.");
                        IF ComEntry.FINDFIRST THEN BEGIN
                            REPORT.RUN(50061, TRUE, FALSE, ComEntry);
                        END ELSE
                            MESSAGE('No Record Found');
                    end;
                }
            }
            group("Function")
            {
                Caption = 'Unit';
                action("Payment Plan Details")
                {

                    trigger OnAction()
                    var
                        PaymentPlanDetails: Record "Payment Plan Details";
                        FormPayPlanDetails: Page "Payment Plan Details Master";
                    begin

                        PaymentPlanDetails.RESET;
                        PaymentPlanDetails.CHANGECOMPANY(Rec."Company Name");
                        PaymentPlanDetails.SETRANGE("Document No.", Rec."No.");
                        PaymentPlanDetails.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
                        IF PaymentPlanDetails.FINDSET THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Payment Plan Details Master", PaymentPlanDetails) = ACTION::LookupOK THEN;
                        END;
                    end;
                }
                action("Payment Milestones")
                {

                    trigger OnAction()
                    var
                        PayTermLineSale: Record "Payment Terms Line Sale";
                    begin

                        PayTermLineSale.RESET;
                        PayTermLineSale.CHANGECOMPANY(Rec."Company Name");
                        PayTermLineSale.SETRANGE("Document No.", Rec."No.");
                        PayTermLineSale.SETRANGE("Transaction Type", PayTermLineSale."Transaction Type"::Sale);
                        IF PayTermLineSale.FINDSET THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Payment Terms Line Sale", PayTermLineSale) = ACTION::LookupOK THEN;
                        END;
                    end;
                }
                action(Post)
                {

                    trigger OnAction()
                    var
                        AppPayEntry: Record "Application Payment Entry";
                        NewAppEntry_1: Record "NewApplication Payment Entry";
                        NewAppEntry_2: Record "NewApplication Payment Entry";
                    begin



                        IF Rec."Application Type" <> Rec."Application Type"::Trading THEN
                            ERROR('Refund Entry posted from MSC company');

                        UserSetup_1.RESET;
                        UserSetup_1.SETRANGE("User ID", USERID);
                        UserSetup_1.SETRANGE("LD Amount Post", TRUE);
                        IF NOT UserSetup_1.FINDFIRST THEN
                            ERROR('Please contact Admin');


                        CheckRefundAmount;
                        //ALLECK 020313 START
                        AmountToWords.InitTextVariable;
                        AmountToWords.FormatNoText(AmountText1, ABS(Rec.CheckPaymentAmt), '');

                        //ALLECK 200313 START
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", Rec."No.");
                        AppPayEntry.SETRANGE(Posted, FALSE);
                        IF AppPayEntry.FINDLAST THEN
                            AppPayEntry.TESTFIELD(AppPayEntry."LD Amount");
                        //ALLECK 200313 END


                        IF CONFIRM(STRSUBSTNO(Text50002, Rec.FIELDCAPTION("Application No."), Rec."Application No.",
                          GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."Shortcut Dimension 1 Code", Rec."Unit Code", Customer.Name,
                          Rec."Customer No.", Rec."Introducer Code", Vend.Name,
                          ABS(Rec.CheckPaymentAmt), AmountText1[1], AppPayEntry."Posting date")) THEN BEGIN
                            IF CONFIRM(Text006) THEN BEGIN //ALLECK020313
                                ReverseComm := FALSE;
                                CLEAR(BondReversal);
                                AppPayEntry.RESET;
                                AppPayEntry.SETRANGE("Document Type", AppPayEntry."Document Type"::BOND);
                                AppPayEntry.SETRANGE("Document No.", Rec."No.");
                                AppPayEntry.SETFILTER("Payment Mode", '%1|%2|%3', 6, 7, 11); //Refund Cash,Refund Cheque,Negative Adjmt.
                                AppPayEntry.SETRANGE("Explode BOM", FALSE);
                                AppPayEntry.SETRANGE(Posted, FALSE);
                                IF AppPayEntry.FINDFIRST THEN BEGIN
                                    IF CONFIRM(Text50001, FALSE) THEN
                                        IF CONFIRM(Text010, FALSE) THEN
                                            AppPayEntry."Commission Reversed" := TRUE
                                        ELSE
                                            AppPayEntry."Commission Reversed" := FALSE;
                                    AppPayEntry.MODIFY;
                                    BondReversal.BondReverse(Rec."No.", AppPayEntry."Commission Reversed", 0, FALSE);
                                    NewAppEntry_2.RESET;
                                    NewAppEntry_2.SETRANGE("Document No.", Rec."No.");
                                    IF NewAppEntry_2.FINDLAST THEN;
                                    NewAppEntry_1.INIT;
                                    NewAppEntry_1."Document Type" := NewAppEntry_1."Document Type"::BOND;
                                    NewAppEntry_1."Document No." := AppPayEntry."Document No.";
                                    NewAppEntry_1."Line No." := NewAppEntry_2."Line No." + 10000;
                                    NewAppEntry_1."Payment Method" := AppPayEntry."Payment Method";
                                    NewAppEntry_1.Amount := AppPayEntry.Amount;
                                    NewAppEntry_1."Payment Mode" := AppPayEntry."Payment Mode";
                                    NewAppEntry_1.Posted := TRUE;
                                    NewAppEntry_1."Unit Code" := AppPayEntry."Unit Code";
                                    NewAppEntry_1.Description := AppPayEntry.Description;
                                    NewAppEntry_1."Document Date" := AppPayEntry."Document Date";
                                    NewAppEntry_1."User Branch Code" := AppPayEntry."User Branch Code";
                                    NewAppEntry_1."User Branch Code" := AppPayEntry."User Branch Code";
                                    NewAppEntry_1."User ID" := AppPayEntry."User ID";
                                    NewAppEntry_1."User Branch Name" := AppPayEntry."User Branch Name";
                                    NewAppEntry_1."Posted Document No." := AppPayEntry."Posted Document No.";
                                    NewAppEntry_1."Posting date" := AppPayEntry."Posting date";
                                    NewAppEntry_1."Shortcut Dimension 1 Code" := AppPayEntry."Shortcut Dimension 1 Code";
                                    NewAppEntry_1."Cheque Status" := NewAppEntry_1."Cheque Status"::Cleared;
                                    NewAppEntry_1."Explode BOM" := TRUE;
                                    NewAppEntry_1."Order Ref No." := AppPayEntry."Order Ref No.";
                                    NewAppEntry_1."Company Name" := COMPANYNAME;
                                    NewAppEntry_1.INSERT;
                                END ELSE
                                    ERROR('Data does not exist to Post');
                            END;
                        END;
                    end;
                }
                action(Navigate)
                {

                    trigger OnAction()
                    begin
                        CurrPage.PostedUnitPayEntrySubform.PAGE.NavigateEntry;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

        UpdateApplicationInfo;
        Rec.SETRANGE("No.");
    end;

    var
        ReceivableAmount: Decimal;
        AmountReceived: Decimal;
        DueAmount: Decimal;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        Dummy: Text[30];
        BondHolderName: Text[50];
        BondHolderName2: Text[50];
        Customer: Record Customer;
        Customer2: Record Customer;
        BondNominee: Record "Unit Nominee";
        Vendor: Record Vendor;
        SchemeHeader: Record "Document Type Initiator";
        BondMaturity: Record "Unit Maturity";
        ReassignType: Option FirstBondHolder,SecondBondHolder,BothBondHolder,MarketingMember;
        Selection: Integer;
        BondChangeType: Option Scheme,"Investment Frequency","Return Frequency","Return Payment Mode","Bond Holder","Co Bond Holder","Marketing Member","Business Transfer";
        GetDescription: Codeunit GetDescription;
        CustomerBankAccount: Record "Customer Bank Account";
        Unitmaster: Record "Unit Master";
        UserSetup: Record "User Setup";
        UnpostedInstallment: Integer;
        BondSetup: Record "Unit Setup";
        BondpaymentEntry: Record "Unit Payment Entry";
        PaymentTermLines: Record "Payment Terms Line Sale";
        LineNo: Integer;
        PostPayment: Codeunit PostPayment;
        MsgDialog: Dialog;
        PenaltyAmount: Decimal;
        ReverseComm: Boolean;
        Bond: Record "Confirmed Order";
        ComEntry: Record "Commission Entry";
        ReceivedAmount: Decimal;
        TotalAmount: Decimal;
        ExcessAmount: Decimal;
        ConOrder: Record "Confirmed Order";
        UnitPaymentEntry: Record "Unit Payment Entry";
        BondReversal: Codeunit "Unit Reversal";
        UnitCommCreationJob: Codeunit "Unit and Comm. Creation Job";
        ArchiveConfirmedOrder: Record "Archive Confirmed Order";
        LastVersion: Integer;
        ConfirmOrder: Record "Confirmed Order";
        NPaymentPlanDetails: Record "Payment Plan Details";
        NPaymentPlanDetails1: Record "Archive Payment Plan Details";
        NApplicableCharges: Record "Applicable Charges";
        NApplicableCharges1: Record "Archive Applicable Charges";
        NArchivePaymentTermsLine: Record "Payment Terms Line Sale";
        NArchivePaymentTermsLine1: Record "Archive Payment Terms Line";
        "-----------------UNIT INSERT -": Integer;
        AppCharges: Record "Applicable Charges";
        Docmaster: Record "Document Master";
        PPGD: Record "Project Price Group Details";
        UnitMasterRec: Record "Unit Master";
        Plcrec: Record "PLC Details";
        totalamount1: Decimal;
        PaymentDetails: Record "Payment Plan Details";
        Sno: Code[10];
        PaymentPlanDetails2: Record "Payment Plan Details" temporary;
        Applicablecharge: Record "Applicable Charges";
        MilestoneCodeG: Code[10];
        LoopingAmount: Decimal;
        InLoop: Boolean;
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        UnitCode: Code[20];
        OldCust: Code[20];
        UnitpayEntry: Record "Unit Payment Entry";
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
        ConfOrder: Record "Confirmed Order";
        BondInvestmentAmt: Decimal;
        ByCheque: Boolean;
        AppPaymentEntry: Record "Application Payment Entry";
        Vend: Record Vendor;
        AmountToWords: Codeunit "Amount To Words";
        AmountText1: array[2] of Text[300];
        ApplicationForm: Page Application;
        UserSetup_1: Record "User Setup";
        Text000: Label '&First Unit Holder,&Second Unit Holder,First &and Second Unit Holder';
        Text001: Label 'Do you want to reassign Marketing Member for the Unit No. %1 ?';
        Text002: Label 'Do you want to change %1 for the Unit No. %2 ?';
        Text003: Label 'Release the Neft details.';
        Text004: Label 'Please enter bank details.';
        Text005: Label 'Do you want to post the Refund Amount and Commission Reversal?';
        Text006: Label 'Are you sure you want to post the entries';
        Text007: Label 'Posting Done';
        Text008: Label 'Do you want to register the Unit %1?';
        Text009: Label 'Registration Done';
        Text010: Label 'Do you want to reverse the commission?';
        Text011: Label 'Cancellation Done';
        Text012: Label 'Do you want to Vacate the Plot %1?';
        Text013: Label 'you sure you want to post the entries';
        Text50001: Label 'Do you want to Adjustment/Refund?';
        Text50002: Label 'Please verify the details below and confirm. Do you want to post ? %1      :%2\Project Name         :%3  Project Code :%4\Unit No.                 :%5\Customer Name     :%6 %7\Associate Code      :%8  %9 \Receiving Amount  : %10 \Amount in Words   : %11 \Posting Date          : %12.';
        WebAppService: Codeunit "Web App Service";

    local procedure UpdateApplicationInfo()
    begin
        ReceivableAmount := Rec.TotalApplicationAmount;
        AmountReceived := Rec.Amount;  //"Amount Received";
        DueAmount := ReceivableAmount - AmountReceived;


        IF Rec."Introducer Code" <> '' THEN
            IF Vend.GET(Rec."Introducer Code") THEN;
        IF Rec."Customer No." <> '' THEN
            Customer.GET(Rec."Customer No."); //23/213
    end;


    procedure ConfirmNeft()
    var
        CustomerBankAccount: Record "Customer Bank Account";
        Customer: Record Customer;
        Application: Record Application;
    begin
        IF CONFIRM(Text003) THEN BEGIN
            IF Rec."Return Payment Mode" = Rec."Return Payment Mode"::NEFT THEN BEGIN
                IF CustomerBankAccount.GET(Rec."Customer No.", Rec."Return Bank Account Code") THEN BEGIN
                    IF NOT CustomerBankAccount."Entry Completed" THEN BEGIN
                        CustomerBankAccount.TESTFIELD(Code);
                        CustomerBankAccount.TESTFIELD(Name);      //Bank Name
                        CustomerBankAccount.TESTFIELD("SWIFT Code");
                        CustomerBankAccount.TESTFIELD("Bank Branch No.");
                        CustomerBankAccount.TESTFIELD("Name 2");  //Branch Name
                        CustomerBankAccount.TESTFIELD("Bank Account No.");
                        CustomerBankAccount."Entry Completed" := TRUE;
                        CustomerBankAccount.MODIFY;
                    END;
                END ELSE
                    ERROR(Text004);
            END;
        END;
    end;


    procedure NeftDetail()
    var
        CustomerBankAccount: Record "Customer Bank Account";
        //CustomerBankInformation: Page 82;
        BankCode: Code[20];
    begin
        CustomerBankAccount.RESET;

        CustomerBankAccount.SETRANGE("Customer No.", Rec."Customer No.");
        IF Rec."Return Bank Account Code" <> '' THEN
            CustomerBankAccount.SETRANGE(Code, Rec."Return Bank Account Code")
        ELSE
            CustomerBankAccount.SETRANGE(Code, Rec."No.");

        IF PAGE.RUNMODAL(82, CustomerBankAccount) = ACTION::LookupOK THEN BEGIN
            Rec."Return Bank Account Code" := CustomerBankAccount.Code;
            Rec.MODIFY;
        END;
    end;


    procedure SplitAppPaymnetEntries()
    var
        AppPaymentEntry: Record "Application Payment Entry";
        TempBondPaymentEntry: Record "Application Payment Entry" temporary;
        DifferenceAmount: Decimal;
        LoopingDifferAmount: Decimal;
        BondPayLineAmt: Decimal;
        TotalBondAmount: Decimal;
        AppliPaymentAmount: Decimal;
    begin
        TotalBondAmount := 0;
        AppliPaymentAmount := 0;
        BondSetup.GET;

        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::BOND);
        AppPaymentEntry.SETRANGE("Document No.", Rec."No.");
        AppPaymentEntry.SETRANGE("Explode BOM", FALSE);
        AppPaymentEntry.SETRANGE(Posted, FALSE);
        IF AppPaymentEntry.FINDSET THEN BEGIN
            AppliPaymentAmount := AppPaymentEntry.Amount;
            REPEAT
                IF AppPaymentEntry."Posting date" <> WORKDATE THEN
                    ERROR('Payment Entry Posting Date must be same as WORK DATE');
                TotalBondAmount := TotalBondAmount + AppPaymentEntry.Amount;
            UNTIL AppPaymentEntry.NEXT = 0;
        END
        ELSE
            ERROR('You must enter the payment lines');

        IF Rec.Type = Rec.Type::Priority THEN BEGIN
            IF Rec."New Unit No." <> '' THEN
                Unitmaster.GET(Rec."New Unit No.")  //ALLEDK 231112
            ELSE
                Unitmaster.GET(Rec."Unit Code");
        END ELSE
            Unitmaster.GET(Rec."Unit Code");

        IF AppPaymentEntry.FINDSET THEN;
        GetLastLineNo(AppPaymentEntry);
        DifferenceAmount := 0;
        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", Rec."Application No.");
        PaymentTermLines.SETRANGE("Payment Plan", Unitmaster."Payment Plan"); //ALLEDK 231112
        IF PaymentTermLines.FIND('-') THEN
            REPEAT
                PaymentTermLines.CALCFIELDS("Received Amt");
                DifferenceAmount := PaymentTermLines."Due Amount" - PaymentTermLines."Received Amt";
                LoopingDifferAmount := 0;
                REPEAT
                    IF DifferenceAmount < AppliPaymentAmount THEN BEGIN
                        IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                            BondPayLineAmt := AppliPaymentAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END ELSE BEGIN
                            BondPayLineAmt := DifferenceAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END;
                        TotalBondAmount := TotalBondAmount - BondPayLineAmt;//ALLE PS
                        LoopingDifferAmount := DifferenceAmount - BondPayLineAmt;
                    END ELSE
                        IF DifferenceAmount > AppliPaymentAmount THEN BEGIN
                            IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END ELSE BEGIN
                                BondPayLineAmt := AppliPaymentAmount - AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END;
                            TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            DifferenceAmount := DifferenceAmount - BondPayLineAmt;
                            LoopingDifferAmount := DifferenceAmount - TotalBondAmount;
                        END ELSE
                            IF DifferenceAmount = AppliPaymentAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            END;
                    IF BondPayLineAmt <> 0 THEN
                        CreatePaymentEntryLine(BondPayLineAmt, AppPaymentEntry);
                    IF AppliPaymentAmount = 0 THEN BEGIN
                        AppPaymentEntry."Explode BOM" := TRUE;
                        AppPaymentEntry.MODIFY;
                        AppPaymentEntry.NEXT;
                        AppliPaymentAmount := AppPaymentEntry.Amount;
                    END;
                UNTIL (LoopingDifferAmount = 0) OR (TotalBondAmount = 0);
            UNTIL (PaymentTermLines.NEXT = 0) OR (TotalBondAmount = 0);
    end;


    procedure CreatePaymentEntryLine(Amt: Decimal; BondPaymentEntryRec: Record "Application Payment Entry")
    var
        UserSetup: Record "User Setup";
        LBondPaymentEntry: Record "Unit Payment Entry";
    begin
        BondpaymentEntry.INIT;
        BondpaymentEntry."Document Type" := BondPaymentEntryRec."Document Type";
        BondpaymentEntry."Document No." := Rec."Application No.";
        BondpaymentEntry."Line No." := LineNo;
        LineNo += 10000;
        BondpaymentEntry.VALIDATE("Unit Code", BondPaymentEntryRec."Unit Code"); //ALLETDK141112
        BondpaymentEntry.VALIDATE("Payment Mode", BondPaymentEntryRec."Payment Mode");
        BondpaymentEntry."Application No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Document Date" := BondPaymentEntryRec."Document Date";
        BondpaymentEntry."Posting date" := BondPaymentEntryRec."Posting date";
        BondpaymentEntry.Type := BondPaymentEntryRec.Type;
        BondpaymentEntry.Sequence := PaymentTermLines.Sequence; //ALLETDK221112
        BondpaymentEntry."Charge Code" := PaymentTermLines."Charge Code"; //ALLETDK081112
        BondpaymentEntry."Actual Milestone" := PaymentTermLines."Actual Milestone"; //ALLETDK221112
        BondpaymentEntry."Commision Applicable" := PaymentTermLines."Commision Applicable";
        BondpaymentEntry."Direct Associate" := PaymentTermLines."Direct Associate";
        BondpaymentEntry."Priority Payment" := BondPaymentEntryRec."Priority Payment";
        IF ((BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::Bank)
            // BBG1.01 251012 START
            OR (BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.C./C.C./Net Banking")) THEN BEGIN
            // BBG1.01 251012 END
            BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            BondpaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            BondpaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            BondpaymentEntry.VALIDATE("Deposit/Paid Bank", BondPaymentEntryRec."Deposit/Paid Bank");
        END;

        IF BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.D." THEN BEGIN
            BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            BondpaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            BondpaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            BondpaymentEntry.VALIDATE("Deposit/Paid Bank", BondPaymentEntryRec."Deposit/Paid Bank");
        END;
        BondpaymentEntry.Amount := Amt;
        UserSetup.GET(USERID);
        BondpaymentEntry."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        BondpaymentEntry."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        BondpaymentEntry."Explode BOM" := TRUE;
        BondpaymentEntry."Branch Code" := BondPaymentEntryRec."User Branch Code"; //ALLETDK141112
        BondpaymentEntry."User ID" := BondPaymentEntryRec."User ID"; //ALLEDK271212
        BondpaymentEntry."App. Pay. Entry Line No." := BondPaymentEntryRec."Line No."; //ALLETDK141112
        BondpaymentEntry.INSERT;
    end;


    procedure GetLastLineNo(BondPaymentEntryRec: Record "Application Payment Entry")
    var
        BPayEntry: Record "Unit Payment Entry";
    begin
        LineNo := 0;
        BPayEntry.RESET;
        BPayEntry.SETRANGE("Document Type", BondPaymentEntryRec."Document Type");
        BPayEntry.SETFILTER(BPayEntry."Document No.", BondPaymentEntryRec."Document No.");
        IF BPayEntry.FINDLAST THEN
            LineNo := BPayEntry."Line No." + 10000
        ELSE
            LineNo := 10000;
    end;


    procedure CheckExcessAmount(ConfirmOrder: Record "Confirmed Order"): Boolean
    var
        RecDueAmount: Decimal;
        ApplPayEntry: Record "Application Payment Entry";
        CurrPayAmount: Decimal;
    begin
        CLEAR(RecDueAmount);
        CLEAR(CurrPayAmount);
        CLEAR(ExcessAmount);
        Rec.CALCFIELDS("Total Received Amount");
        RecDueAmount := Rec.Amount + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount";
        IF RecDueAmount >= 0 THEN BEGIN
            ApplPayEntry.RESET;
            ApplPayEntry.SETRANGE("Document Type", ApplPayEntry."Document Type"::BOND);
            ApplPayEntry.SETRANGE("Document No.", Rec."No.");
            ApplPayEntry.SETRANGE("Explode BOM", FALSE);
            IF ApplPayEntry.FINDSET THEN
                REPEAT
                    CurrPayAmount += ApplPayEntry.Amount;
                UNTIL ApplPayEntry.NEXT = 0;
            IF RecDueAmount < CurrPayAmount THEN
                ExcessAmount := CurrPayAmount - RecDueAmount;
            IF ExcessAmount > 0 THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;
    end;


    procedure CreateExcessPaymentTermsLine()
    var
        PaymentTermLines: Record "Payment Terms Line Sale";
        PaymentTermLines1: Record "Payment Terms Line Sale";
        UnitCharge: Record "Unit Charge & Payment Pl. Code";
        ExcessCode: Code[10];
    begin
        UnitCharge.RESET;
        UnitCharge.SETRANGE(ExcessCode, TRUE);
        IF UnitCharge.FINDFIRST THEN
            ExcessCode := UnitCharge.Code
        ELSE
            ERROR('Excess Code setup does not exist');
        PaymentTermLines1.RESET;
        PaymentTermLines1.SETRANGE("Document No.", Rec."No.");
        IF PaymentTermLines1.FINDLAST THEN BEGIN
            IF PaymentTermLines1."Charge Code" <> ExcessCode THEN BEGIN
                PaymentTermLines.INIT;
                PaymentTermLines."Document Type" := PaymentTermLines1."Document Type";
                PaymentTermLines."Document No." := Rec."No.";
                PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
                PaymentTermLines.Sequence := INCSTR(PaymentTermLines1.Sequence); //ALLETDK221112
                PaymentTermLines."Actual Milestone" := PaymentTermLines1."Actual Milestone";
                PaymentTermLines."Payment Plan" := PaymentTermLines1."Payment Plan";
                PaymentTermLines.Description := 'Excess Payment';
                PaymentTermLines."Due Date" := PaymentTermLines1."Due Date";
                PaymentTermLines."Project Code" := Rec."Shortcut Dimension 1 Code";
                PaymentTermLines."Calculation Type" := PaymentTermLines."Calculation Type"::"% age";
                PaymentTermLines."Criteria Value / Base Amount" := ExcessAmount;
                PaymentTermLines."Calculation Value" := 100;
                PaymentTermLines."Due Amount" := ROUND(ExcessAmount, 0.01, '=');
                PaymentTermLines."Charge Code" := ExcessCode;
                PaymentTermLines."Commision Applicable" := FALSE;
                PaymentTermLines."Direct Associate" := FALSE;
                PaymentTermLines.INSERT(TRUE);
            END;
        END;
    end;


    procedure CreateUnitPaymentApplication()
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        AmountRecd: Decimal;
        InstallmentNo: Integer;
        YearCode: Integer;
        ChequeNo: Code[10];
        DirectAss: Boolean;
    begin
        UnitpayEntry.RESET;
        UnitpayEntry.SETRANGE("Document Type", UnitpayEntry."Document Type"::BOND);
        UnitpayEntry.SETRANGE("Document No.", Rec."No.");
        UnitpayEntry.SETRANGE(Posted, FALSE);
        UnitpayEntry.SETRANGE("Priority Payment", FALSE);
        IF UnitpayEntry.FINDSET THEN
            REPEAT
                CLEAR(BondInvestmentAmt);
                BondInvestmentAmt := UnitpayEntry.Amount;
                CLEAR(ByCheque);
                IF (UnitpayEntry."Payment Mode" IN [UnitpayEntry."Payment Mode"::Bank,
                UnitpayEntry."Payment Mode"::"D.C./C.C./Net Banking", UnitpayEntry."Payment Mode"::"D.D."]) THEN
                    ByCheque := TRUE
                ELSE
                    ByCheque := FALSE;
                // IF (UnitpayEntry."Payment Mode" <> UnitpayEntry."Payment Mode" :: Cash) AND
                //    (UnitpayEntry."Payment Mode" <> UnitpayEntry."Payment Mode" :: "Refund Cash") AND
                //    (UnitpayEntry."Payment Mode" <> UnitpayEntry."Payment Mode" :: AJVM) THEN
                //     "With Cheque" := TRUE;
                CreateStagingTableAppBond(Rec, UnitpayEntry."Line No." / 10000, 1, UnitpayEntry.Sequence,
                  UnitpayEntry."Cheque No./ Transaction No.", UnitpayEntry."Commision Applicable", UnitpayEntry."Direct Associate");
            UNTIL UnitpayEntry.NEXT = 0;
    end;


    procedure CheckRefundAmount()
    var
        ApplicableCharges: Record "Applicable Charges";
        AppPayEntry: Record "Application Payment Entry";
        TotRefundAmt: Decimal;
        AdminCharges: Decimal;
        TotRcvdAmt: Decimal;
    begin
        Rec.CALCFIELDS("Total Received Amount");
        CLEAR(TotRefundAmt);
        CLEAR(AdminCharges);
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document Type", AppPayEntry."Document Type"::BOND);
        AppPayEntry.SETRANGE("Document No.", Rec."No.");
        //AppPayEntry.SETRANGE("Payment Mode",6,7); //Refund Cash,Refund Cheque
        AppPayEntry.SETFILTER("Payment Mode", '%1|%2|%3', 6, 7, 11); //Refund Cash,Refund Cheque,Negative Adjmt.
        AppPayEntry.SETRANGE("Explode BOM", FALSE);
        AppPayEntry.SETRANGE(Posted, FALSE);
        IF AppPayEntry.FINDSET THEN
            REPEAT
                TotRefundAmt += ABS(AppPayEntry.Amount);
            UNTIL AppPayEntry.NEXT = 0;

        CLEAR(TotRcvdAmt);
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document Type", AppPayEntry."Document Type"::BOND);
        AppPayEntry.SETRANGE("Document No.", Rec."No.");
        //AppPayEntry.SETRANGE("Payment Mode",6,7); //Refund Cash,Refund Cheque
        AppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::Cleared);
        //AppPayEntry.SETRANGE("Explode BOM",FALSE);
        AppPayEntry.SETRANGE(Posted, TRUE);
        IF AppPayEntry.FINDSET THEN
            REPEAT
                TotRcvdAmt += AppPayEntry.Amount;
            UNTIL AppPayEntry.NEXT = 0;


        ApplicableCharges.RESET;
        ApplicableCharges.SETRANGE("Document No.", Rec."No.");
        ApplicableCharges.SETFILTER(Code, '%1|%2', 'ADMIN', 'ADMIN2');
        IF ApplicableCharges.FINDFIRST THEN
            AdminCharges := ApplicableCharges."Net Amount";

        IF NOT Rec."Incl. Mem. Fee" THEN BEGIN
            IF (TotRefundAmt > (TotRcvdAmt - AdminCharges)) THEN
                ERROR('Total Refund Amount should not be more than %1', (TotRcvdAmt - AdminCharges));
        END ELSE BEGIN
            IF (TotRefundAmt <> (TotRcvdAmt)) THEN
                ERROR('Total Refund Amount should be %1', (TotRcvdAmt));
        END;

        /*
        IF (TotRefundAmt > (TotRcvdAmt-AdminCharges)) THEN
          ERROR('Total Refund Amount should not be more than %1',(TotRcvdAmt-AdminCharges));
        */

    end;


    procedure UpdateUnitwithApplicablecharge()
    begin

        Rec."Unit Code" := Rec."New Unit No.";

        Unitmaster.GET(Rec."New Unit No.");
        Rec."Saleable Area" := Unitmaster."Saleable Area";
        Rec."Shortcut Dimension 1 Code" := Unitmaster."Project Code";
        IF Job.GET(Unitmaster."Project Code") THEN
            Rec."Project Type" := Job."Default Project Type";

        Rec."Min. Allotment Amount" := Unitmaster."Min. Allotment Amount";
        Rec.Amount := Unitmaster."Total Value";
        Rec.VALIDATE(Amount);
        Rec.MODIFY;
        IF Rec."Unit Code" <> '' THEN BEGIN


            AppCharges.RESET;
            AppCharges.SETRANGE(AppCharges."Document No.", Rec."No.");
            IF AppCharges.FIND('-') THEN
                AppCharges.DELETEALL;

            Docmaster.RESET;
            Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
            Docmaster.SETFILTER(Docmaster."Project Code", Rec."Shortcut Dimension 1 Code");
            Docmaster.SETFILTER(Docmaster."Unit Code", Rec."Unit Code");
            IF Docmaster.FINDFIRST THEN
                REPEAT
                    AppCharges.RESET;
                    AppCharges.INIT;
                    AppCharges."Document Type" := Docmaster."Document Type"::Charge;
                    AppCharges.Code := Docmaster.Code;

                    AppCharges.Description := Docmaster.Description;
                    AppCharges."Document No." := Rec."No.";
                    AppCharges."Item No." := Rec."Unit Code";
                    AppCharges."Membership Fee" := Docmaster."Membership Fee";
                    IF Docmaster."Project Price Dependency Code" <> '' THEN BEGIN
                        PPGD.RESET;
                        PPGD.SETFILTER(PPGD."Project Code", Rec."Shortcut Dimension 1 Code");
                        PPGD.SETRANGE(PPGD."Project Price Group", Docmaster."Project Price Dependency Code");
                        PPGD.SETFILTER(PPGD."Starting Date", '<=%1', Rec."Document Date");
                        IF PPGD.FINDLAST THEN BEGIN
                            IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Sale THEN
                                AppCharges."Rate/UOM" := PPGD."Sales Rate (per sq ft)";
                            IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Lease THEN
                                AppCharges."Rate/UOM" := PPGD."Lease Rate (per sq ft)";

                        END;
                    END
                    ELSE
                        AppCharges."Rate/UOM" := Docmaster."Rate/Sq. Yd";

                    AppCharges."Project Code" := Docmaster."Project Code";
                    AppCharges."Fixed Price" := Docmaster."Fixed Price";
                    AppCharges."BP Dependency" := Docmaster."BP Dependency";
                    AppCharges."Rate Not Allowed" := Docmaster."Rate Not Allowed";
                    AppCharges."Project Price Dependency Code" := Docmaster."Project Price Dependency Code";
                    IF AppCharges."Rate/UOM" <> 0 THEN BEGIN
                        UnitMasterRec.GET(Rec."Unit Code");
                        AppCharges."Net Amount" := ROUND(UnitMasterRec."Saleable Area" * AppCharges."Rate/UOM", 1);
                    END
                    ELSE
                        AppCharges."Net Amount" := AppCharges."Fixed Price";
                    AppCharges.Sequence := Docmaster.Sequence;
                    IF AppCharges.Code = 'PLC' THEN BEGIN
                        Plcrec.SETFILTER("Item Code", Rec."Unit Code");
                        Plcrec.SETFILTER("Job Code", Rec."Shortcut Dimension 1 Code");
                        IF Plcrec.FINDFIRST THEN
                            REPEAT
                                AppCharges."Fixed Price" := AppCharges."Fixed Price" + Plcrec.Amount;
                                AppCharges."Net Amount" := AppCharges."Fixed Price";
                            UNTIL Plcrec.NEXT = 0;
                    END;
                    AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
                    AppCharges."Direct Associate" := Docmaster."Direct Associate";
                    AppCharges.Applicable := TRUE;
                    AppCharges.INSERT;
                UNTIL Docmaster.NEXT = 0;
        END;

        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Document No.", Rec."No.");
        IF PaymentPlanDetails.FIND('-') THEN
            REPEAT
                PaymentPlanDetails.DELETE;
            UNTIL PaymentPlanDetails.NEXT = 0;

        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", Rec."No.");
        IF PaymentTermLines.FINDSET THEN
            REPEAT
                PaymentTermLines.DELETE;
            UNTIL PaymentTermLines.NEXT = 0;


        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
        PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Payment Plan Code", Unitmaster."Payment Plan");
        PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Document No.", '');
        IF PaymentPlanDetails.FIND('-') THEN
            REPEAT
                PaymentPlanDetails1.INIT;
                PaymentPlanDetails1.COPY(PaymentPlanDetails);
                PaymentPlanDetails1."Document No." := Rec."No.";
                PaymentPlanDetails1.INSERT;
            UNTIL PaymentPlanDetails.NEXT = 0;

        Unitmaster.TESTFIELD("Total Value");

        totalamount1 := 0;
        PaymentDetails.RESET;
        PaymentDetails.SETFILTER("Project Code", Rec."Shortcut Dimension 1 Code");
        PaymentDetails.SETFILTER("Document No.", Rec."No.");
        PaymentDetails.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
        IF PaymentDetails.FINDFIRST THEN
            REPEAT
                IF PaymentDetails."Percentage Cum" > 0 THEN BEGIN
                    IF PaymentDetails."Percentage Cum" = 100 THEN
                        PaymentDetails."Total Charge Amount" := (Unitmaster."Total Value" - totalamount1)
                    ELSE
                        PaymentDetails."Total Charge Amount" := (Unitmaster."Total Value" * PaymentDetails."Percentage Cum" / 100) - totalamount1;
                END;
                IF PaymentDetails."Fixed Amount" <> 0 THEN BEGIN
                    PaymentDetails."Total Charge Amount" := PaymentDetails."Fixed Amount";
                END;

                totalamount1 := PaymentDetails."Total Charge Amount" + totalamount1;
                PaymentDetails.VALIDATE("Total Charge Amount");
                PaymentDetails.MODIFY;
            UNTIL PaymentDetails.NEXT = 0;




        Sno := '001';
        PaymentPlanDetails2.RESET;
        PaymentPlanDetails2.DELETEALL;

        TotalAmount := 0;
        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
        PaymentPlanDetails.SETRANGE("Document No.", Rec."No.");
        IF PaymentPlanDetails.FINDSET THEN
            REPEAT
                PaymentPlanDetails2.COPY(PaymentPlanDetails);
                TotalAmount := TotalAmount + PaymentPlanDetails2."Milestone Charge Amount";
                PaymentPlanDetails2.INSERT;
            UNTIL PaymentPlanDetails.NEXT = 0;

        Applicablecharge.RESET;
        Applicablecharge.SETCURRENTKEY("Document No.", Applicablecharge.Sequence);
        Applicablecharge.SETRANGE("Document No.", Rec."No.");
        Applicablecharge.SETRANGE(Applicable, TRUE);
        IF Applicablecharge.FINDSET THEN BEGIN
            MilestoneCodeG := '1';
            PaymentPlanDetails2.RESET;
            PaymentPlanDetails2.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
            PaymentPlanDetails2.SETRANGE("Document No.", Rec."No.");
            PaymentPlanDetails2.SETRANGE(Checked, FALSE);
            IF PaymentPlanDetails2.FINDSET THEN
                REPEAT
                    LoopingAmount := 0;
                    REPEAT
                        IF Applicablecharge."Net Amount" = PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                            CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");
                            PaymentPlanDetails2.Checked := TRUE;
                            PaymentPlanDetails2.MODIFY;
                            TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";
                            Applicablecharge."Net Amount" := 0;
                            InLoop := TRUE;
                        END;
                        IF Applicablecharge."Net Amount" > PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                            CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");
                            PaymentPlanDetails2.Checked := TRUE;
                            PaymentPlanDetails2.MODIFY;

                            TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";//ALLE PS
                            LoopingAmount := 0;

                            Applicablecharge."Net Amount" := Applicablecharge."Net Amount" -
                              PaymentPlanDetails2."Milestone Charge Amount";

                            InLoop := TRUE;
                        END ELSE
                            IF (Applicablecharge."Net Amount" < PaymentPlanDetails2."Milestone Charge Amount") AND
                              (Applicablecharge."Net Amount" <> 0) THEN BEGIN
                                CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                PaymentPlanDetails2."Project Milestone Due Date", Applicablecharge."Net Amount",
                                Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");

                                TotalAmount := TotalAmount - Applicablecharge."Net Amount";//ALLE PS
                                LoopingAmount := PaymentPlanDetails2."Milestone Charge Amount" - Applicablecharge."Net Amount";

                                PaymentPlanDetails2."Milestone Charge Amount" := PaymentPlanDetails2."Milestone Charge Amount" -
                                Applicablecharge."Net Amount";
                                PaymentPlanDetails2.MODIFY;
                                Applicablecharge."Net Amount" := 0;
                                InLoop := TRUE;
                            END;
                        IF Applicablecharge."Net Amount" = 0 THEN BEGIN
                            Applicablecharge.NEXT;
                        END;

                    UNTIL (LoopingAmount = 0) OR (TotalAmount = 0);
                UNTIL (PaymentPlanDetails2.NEXT = 0) OR (TotalAmount = 0);
        END;

        Unitmaster.VALIDATE(Status, Unitmaster.Status::Booked);
        Unitmaster.MODIFY;

        Rec."New Unit No." := '';
        Rec.MODIFY;

        WebAppService.UpdateUnitStatus(Unitmaster);  //210624
    end;


    procedure CreatePaymentTermsLine(MilestoneCode: Code[10]; MilestoneDescription: Text[50]; MilestoneDueDate: Date; Milestoneamt: Decimal; ChargeCode: Code[10]; CommisionApplicable: Boolean; DirectAssociate: Boolean)
    begin

        PaymentTermLines.INIT;
        PaymentTermLines."Document No." := Rec."No.";
        PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
        PaymentTermLines.Sequence := Sno;
        Sno := INCSTR(Sno);
        PaymentTermLines."Actual Milestone" := MilestoneCode;
        PaymentTermLines."Payment Plan" := PaymentPlanDetails."Payment Plan Code";
        PaymentTermLines.Description := MilestoneDescription;
        PaymentTermLines."Due Date" := MilestoneDueDate;
        PaymentTermLines."Project Code" := Rec."Shortcut Dimension 1 Code";
        PaymentTermLines."Calculation Type" := PaymentTermLines."Calculation Type"::"% age";
        PaymentTermLines."Criteria Value / Base Amount" := Milestoneamt;
        PaymentTermLines."Calculation Value" := 100;
        PaymentTermLines."Due Amount" := ROUND(Milestoneamt, 0.01, '=');
        PaymentTermLines."Charge Code" := ChargeCode;
        PaymentTermLines."Commision Applicable" := CommisionApplicable;
        PaymentTermLines."Direct Associate" := DirectAssociate;
        PaymentTermLines.INSERT(TRUE);
    end;


    procedure TransferMemberAmount()
    begin
        Amt := 0;

        IF OldCust <> '' THEN BEGIN

            CustLedgEntry.RESET;
            CustLedgEntry.SETRANGE("Customer No.", OldCust);
            CustLedgEntry.SETRANGE("BBG App. No. / Order Ref No.", Rec."No.");
            IF CustLedgEntry.FINDSET THEN
                REPEAT
                    CustLedgEntry.CALCFIELDS(CustLedgEntry."Amount (LCY)");
                    Amt := Amt + CustLedgEntry."Amount (LCY)";
                UNTIL CustLedgEntry.NEXT = 0;

            UnitSetup.GET;
            UnitSetup.TESTFIELD("Transfer Member Temp Name");
            UnitSetup.TESTFIELD("Transfer Member Batch Name");
            UnitSetup.TESTFIELD("Transfer Control Account");
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", UnitSetup."Transfer Member Temp Name");
            GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
            IF GenJnlLine.FINDLAST THEN
                LineNo2 := GenJnlLine."Line No.";

            GenJnlLine.INIT;
            LineNo2 += 10000;

            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";

            IF GenJnlBatch.GET(UnitSetup."Transfer Member Temp Name", UnitSetup."Transfer Member Batch Name") THEN
                DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Line No." := 10000;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::" ");
            GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", OldCust);
            GenJnlLine.VALIDATE("Debit Amount", ABS(Amt));
            GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Running);
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := UnitSetup."Transfer Control Account";
            GenJnlLine."Source Code" := 'GENJNL';
            GenJnlLine."Order Ref No." := Rec."No.";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.INSERT;

            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", 10000, 'Transfer Member to Member');

            GenJnlLine.INIT;
            LineNo2 += 10000;

            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Line No." := 20000;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::" ");
            GenJnlLine.VALIDATE("Posting Date", Rec."Posting Date");
            GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", Rec."New Member");
            GenJnlLine.VALIDATE("Credit Amount", ABS(Amt));
            GenJnlLine."Order Ref No." := Rec."No.";
            GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Running);
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := UnitSetup."Transfer Control Account";
            GenJnlLine."Source Code" := 'GENJNL';
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.INSERT;

            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", 20000, 'Transfer Member to Member');

            PostGenJnlLines;

            Rec."Customer No." := Rec."New Member";
            Rec."New Member" := '';
            Rec.MODIFY;

        END;
    end;


    procedure PostGenJnlLines()
    begin
        CLEAR(GenJnlPostLine);
        CLEAR(GenJnlPostBatch);
        UnitSetup.GET;
        GenJnlLine2.RESET;
        GenJnlLine2.SETFILTER("Journal Template Name", UnitSetup."Transfer Member Temp Name");
        GenJnlLine2.SETFILTER("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
        IF GenJnlLine2.FINDSET THEN
            REPEAT
                //GenJnlPostLine.SetDocumentNo(GenJnlLine2."Document No.");
                GenJnlPostLine.RUN(GenJnlLine2);
            UNTIL GenJnlLine2.NEXT = 0;
        //GenJnlPostBatch.DeleteGenJournalNarration(GenJnlLine2);
        GenJnlLine.DELETEALL;
    end;


    procedure InitVoucherNarration(JnlTemplate: Code[10]; JnlBatch: Code[10]; DocumentNo: Code[20]; GenJnlLineNo: Integer; NarrationLineNo: Integer; LineNarrationText: Text[50])
    var
        GenJnlNarration: Record "Gen. Journal Narration";// 16549;
        LineNo: Integer;
        PayToName: Text[50];
        Cust: Record Customer;
        Vend: Record Vendor;
    begin
        GenJnlNarration.INIT;
        GenJnlNarration."Journal Template Name" := JnlTemplate;
        GenJnlNarration."Journal Batch Name" := JnlBatch;
        GenJnlNarration."Document No." := DocumentNo;
        GenJnlNarration."Gen. Journal Line No." := GenJnlLineNo;
        GenJnlNarration."Line No." := NarrationLineNo;
        GenJnlNarration.Narration := LineNarrationText;
        GenJnlNarration.INSERT;
    end;


    procedure CreateStagingTableAppBond(Application: Record "Confirmed Order"; InstallmentNo: Integer; YearCode: Integer; MilestoneCode: Code[10]; ChequeNo: Code[10]; CommTree: Boolean; DirectAss: Boolean)
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
        AmountRecd: Decimal;
    begin
        Bond.GET(Application."No.");                                                              //ALLETDK
        AmountRecd := Bond.AmountRecdAppl(Application."No.");             //ALLETDK
        InitialStagingTab.INIT;
        InitialStagingTab."Unit No." := Application."No.";           //ALLETDk
        InitialStagingTab."Installment No." := InstallmentNo + 1;
        InitialStagingTab."Posting Date" := Application."Posting Date";
        InitialStagingTab.VALIDATE("Introducer Code", Application."Introducer Code");//ALLETDK
        InitialStagingTab."Base Amount" := BondInvestmentAmt;      //ALLETDK
        InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
        InitialStagingTab.Duration := Application.Duration;
        InitialStagingTab."Year Code" := YearCode;
        InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
        InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
        InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
        InitialStagingTab."Application No." := Application."No."; //ALLETDK
        InitialStagingTab."Paid by cheque" := ByCheque;                   //ALLETDK
        InitialStagingTab."Cheque No." := ChequeNo;
        InitialStagingTab."Milestone Code" := MilestoneCode;
        InitialStagingTab."Bond Created" := TRUE;
        IF AmountRecd < Bond."Min. Allotment Amount" THEN
            InitialStagingTab."Min. Allotment Amount Not Paid" := TRUE;

        IF (CommTree = FALSE) AND (DirectAss = FALSE) THEN
            InitialStagingTab."Commission Created" := TRUE;

        IF InitialStagingTab."Paid by cheque" THEN BEGIN
            InitialStagingTab."Cheque not Cleared" := TRUE;
        END;

        IF MilestoneCode = '001' THEN BEGIN
            InitialStagingTab."Min. Allotment Amount Not Paid" := FALSE;
            InitialStagingTab."Cheque not Cleared" := FALSE;
        END;

        InitialStagingTab."Direct Associate" := DirectAss;
        InitialStagingTab.INSERT;
    end;


    procedure CalculateTDSPercentage(): Decimal
    var
        TDSPercent: Decimal;
        eCessPercent: Decimal;
        SheCessPercent: Decimal;
    //RecTDSSetup: Record 13728;
    //RecNODHeader: Record 13786;
    //RecNODLines: Record 13785;
    begin
        /*
        RecTDSSetup.RESET;
        RecTDSSetup.SETRANGE("TDS Nature of Deduction","TDS Nature of Deduction");
        RecTDSSetup.SETRANGE("Assessee Code","Assessee Code");
        RecTDSSetup.SETRANGE("TDS Group","TDS Group");
        RecTDSSetup.SETRANGE("Effective Date",0D,"Posting Date");
        RecNODLines.RESET;
        RecNODLines.SETRANGE(Type,"Party Type");
        RecNODLines.SETRANGE("No.","Party Code");
        RecNODLines.SETRANGE("NOD/NOC","TDS Nature of Deduction");
        IF RecNODLines.FINDFIRST THEN BEGIN
          IF RecNODLines."Concessional Code" <> '' THEN
            RecTDSSetup.SETRANGE("Concessional Code",RecNODLines."Concessional Code")
          ELSE
            RecTDSSetup.SETRANGE("Concessional Code",'');
          IF RecTDSSetup.FINDLAST THEN BEGIN
            IF "Party Type" = "Party Type"::Vendor THEN BEGIN
              Vend.GET("Party Code");
              IF (Vend."P.A.N. Status" = Vend."P.A.N. Status"::" ") AND (Vend."P.A.N. No." <> '') THEN
                TDSPercent := RecTDSSetup."TDS %"
              ELSE
                TDSPercent := RecTDSSetup."Non PAN TDS %";
        
              eCessPercent := RecTDSSetup."eCESS %";
              SheCessPercent :=RecTDSSetup."SHE Cess %";
              EXIT(((10000*TDSPercent)+(100*TDSPercent*eCessPercent)+(100*TDSPercent*SheCessPercent)+
                (TDSPercent*eCessPercent*SheCessPercent))/10000);
            END ELSE
               ERROR('Party Type must be Vendor');
          END ELSE
            ERROR('TDS Setup does not exist');
        END ELSE
        ERROR('TDS Setup does not exist');
         */

    end;
}

