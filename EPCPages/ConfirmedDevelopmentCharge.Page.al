page 50146 "Confirmed Development Charge"
{
    // Upgrade140118 code comment

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Confirmed Order";
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
                    Editable = false;
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                    Editable = false;
                }
                field("IBA Name"; Vend.Name)
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Editable = false;
                }
                field("Member Name"; Customer.Name)
                {
                    Editable = false;
                }
                field("Project Type"; Rec."Project Type")
                {
                    Caption = 'Commission Code';
                    Editable = false;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    Editable = false;
                }
                field("Unit Facing"; Rec."Unit Facing")
                {
                    Editable = false;
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                    Editable = false;
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Total Amount';
                    Editable = false;
                }
                field("New Total Received Amount"; Rec."New Total Received Amount")
                {
                    Caption = 'Received Amount';
                }
                field("Due Amount"; Rec.Amount - Rec."New Total Received Amount")
                {
                }
                field("Development Charges"; Rec."Development Charges")
                {
                    Editable = false;
                }
                field("Total Received Dev. Charges"; Rec."Total Received Dev. Charges")
                {
                    Editable = false;
                }
                field("Development Due Amount"; Rec."Development Charges" - Rec."Total Received Dev. Charges")
                {
                    Editable = false;
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("GST Base Amount"; Rec."GST Base Amount")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                    Editable = false;
                    Visible = false;
                }
            }
            part(PostedUnitPayEntrySubform; "Posted App Pay Entry Subform")
            {
                Caption = 'Posted Receipt';
                Editable = false;
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(true));
            }
            group("Unit Holder")
            {
                Visible = false;
                group("Unit Holder1")
                {
                    Visible = false;
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
            }
            group(Nominee)
            {
                Visible = false;
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
                Visible = false;
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
        }
    }

    actions
    {
        area(processing)
        {
            action(Navigate)
            {
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.PostedUnitPayEntrySubform.PAGE.NavigateEntry;
                end;
            }
            action("Customer Change")
            {
                Visible = false;

                trigger OnAction()
                var
                    NewConfirmedOrder: Record "New Confirmed Order";
                    PostDevelopmentCharges: Codeunit "Post Development Charges";
                begin
                    /*
                    NewConfirmedOrder.RESET;
                    NewConfirmedOrder.GET("No.");
                    IF NewConfirmedOrder."Customer No." <> "Customer No." THEN BEGIN
                      IF CONFIRM('Do you want to change Customer') THEN BEGIN
                        PostDevelopmentCharges.CustomerChange(Rec);
                      END ELSE
                        MESSAGE('Nothing Done');
                    END ELSE
                    MESSAGE('Nothing Done');
                    */

                end;
            }
            action("Project Change")
            {

                trigger OnAction()
                var
                    NewConfirmedOrder: Record "New Confirmed Order";
                    PostDevelopmentCharges: Codeunit "Post Development Charges";
                begin
                    NewConfirmedOrder.RESET;
                    NewConfirmedOrder.GET(Rec."No.");
                    IF NewConfirmedOrder."Shortcut Dimension 1 Code" <> Rec."Shortcut Dimension 1 Code" THEN BEGIN
                        IF CONFIRM('Do you want to change Project') THEN BEGIN
                            PostDevelopmentCharges.ProjectChange(Rec);
                        END ELSE
                            MESSAGE('Nothing Done');
                    END ELSE
                        MESSAGE('Nothing Done');
                end;
            }
            action("Create Sales Invoice")
            {

                trigger OnAction()
                var
                    PostDevelopmentCharges: Codeunit "Post Development Charges";
                    ApplicationDevelopmentLine: Record "New Application DevelopmntLine";
                    TotalchargeAmt: Decimal;
                    NewConfirmedOrder: Record "New Confirmed Order";
                begin
                    Rec.TESTFIELD("Sales Invoice booked", FALSE);
                    Rec.TESTFIELD("GST Base Amount");
                    IF CONFIRM('Do you want to Create Sales Invoice.') THEN BEGIN
                        TotalchargeAmt := 0;
                        ApplicationDevelopmentLine.RESET;
                        ApplicationDevelopmentLine.SETRANGE("Document No.", Rec."No.");
                        ApplicationDevelopmentLine.SETFILTER("Cheque Status", '<>%1', ApplicationDevelopmentLine."Cheque Status"::" ");
                        IF ApplicationDevelopmentLine.FINDSET THEN
                            REPEAT
                                TotalchargeAmt := TotalchargeAmt + ApplicationDevelopmentLine.Amount;
                            UNTIL ApplicationDevelopmentLine.NEXT = 0;
                        NewConfirmedOrder.GET(Rec."No.");
                        IF NewConfirmedOrder."Development Charges" > TotalchargeAmt THEN BEGIN
                            ERROR('Development Charge not received complete');
                        END ELSE BEGIN
                            CLEAR(PostDevelopmentCharges);
                            PostDevelopmentCharges.CustomerSalesInvoice(Rec, Rec."GST Base Amount");
                            MESSAGE('Sales invoice Posted');
                        END;
                    END ELSE
                        MESSAGE('Nothing to Create');
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

        UpdateApplicationInfo;
        Rec.SETRANGE("No.");
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateApplicationInfo;
        IF Rec.Status = Rec.Status::Registered THEN BEGIN
            EditableRegNo := FALSE; //CurrForm."Registration No.".EDITABLE(FALSE);
            EditableRegDate := FALSE; //CurrForm."Registration Date".EDITABLE(FALSE);
            EditableRegOffice := FALSE; //CurrForm."Reg. Office".EDITABLE(FALSE);
            EditableReginFavour := FALSE; //CurrForm."Registration In Favour Of".EDITABLE(FALSE);
            EditableFatherName := FALSE; //CurrForm."Father/Husband Name".EDITABLE(FALSE);
            EditableRegoffName := FALSE; //CurrForm."Registered/Office Name".EDITABLE(FALSE);
            EditableRegAdd := FALSE; //CurrForm."Reg. Address".EDITABLE(FALSE);
            EditableBranchCode := FALSE; //CurrForm."Branch Code".EDITABLE(FALSE);
            EditableRegCity := FALSE; //CurrForm."Registered City".EDITABLE(FALSE);
            EditableZipcode := FALSE; // CurrForm."Zip Code".EDITABLE(FALSE);
        END ELSE BEGIN
            EditableRegNo := TRUE; //CurrForm."Registration No.".EDITABLE(FALSE);
            EditableRegDate := TRUE; //CurrForm."Registration Date".EDITABLE(FALSE);
            EditableRegOffice := TRUE; //CurrForm."Reg. Office".EDITABLE(FALSE);
            EditableReginFavour := TRUE; //CurrForm."Registration In Favour Of".EDITABLE(FALSE);
            EditableFatherName := TRUE; //CurrForm."Father/Husband Name".EDITABLE(FALSE);
            EditableRegoffName := TRUE; //CurrForm."Registered/Office Name".EDITABLE(FALSE);
            EditableRegAdd := TRUE; //CurrForm."Reg. Address".EDITABLE(FALSE);
            EditableBranchCode := TRUE; //CurrForm."Branch Code".EDITABLE(FALSE);
            EditableRegCity := TRUE; //CurrForm."Registered City".EDITABLE(FALSE);
            EditableZipcode := TRUE; // CurrForm."Zip Code".EDITABLE(FALSE);
        END;

        IF Rec."Unit Code" <> '' THEN BEGIN
            UMaster_11.RESET;
            UMaster_11.SETRANGE("No.", Rec."Unit Code");
            IF UMaster_11.FINDFIRST THEN
                Rec."Unit Facing" := UMaster_11.Facing;
        END;
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
        CreatingUnitPaymentEntries: Codeunit "Creat UPEry from ConfOrder/APP";
        MemberOf: Record "Access Control";
        CommEntry: Record "Commission Entry";
        UnitCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        CustMobileNo: Text[30];
        CustSMSText: Text[1000];
        CashAmt: Decimal;
        AppPayEntry: Record "Application Payment Entry";
        Flag: Boolean;
        Vend: Record Vendor;
        GoldCoinLine: Record "Gold Coin Line";
        GoldCoinEligibility: Record "Gold Coin Eligibility";
        AmountToWords: Codeunit "Amount To Words";
        AmountText1: array[2] of Text[300];
        ApplicationForm: Page Application;
        //ConfReport1: Report 50080;
        GJCLine: Codeunit "Gen. Jnl.-Check Line";
        AssHierarcy: Record "Associate Hierarcy with App.";
        ComInfo: Record "Company Information";
        BBGSMS: Codeunit "SMS Features";
        RecUMaster: Record "Unit Master";
        RespCenter: Record "Responsibility Center 1";
        Companywise: Record "Company wise G/L Account";
        RecAPEtry: Record "Application Payment Entry";
        RcveAmt_1: Decimal;
        UMaster_11: Record "Unit Master";
        //SALESInvoiceData: Report 50023;
        NAPEntry: Record "NewApplication Payment Entry";
        Text000: Label '&First Unit Holder,&Second Unit Holder,First &and Second Unit Holder';
        Text001: Label 'Do you want to reassign Marketing Member for the Unit No. %1 ?';
        Text002: Label 'Do you want to change %1 for the Unit No. %2 ?';
        Text003: Label 'Release the Neft details.';
        Text004: Label 'Please enter bank details.';
        Text005: Label 'Do you want to Cancell the Unit and Post Commission Reversal?';
        Text006: Label 'Are you sure you want to post the entries';
        Text007: Label 'Posting Done';
        Text008: Label 'Do you want to register the Unit %1?';
        Text009: Label 'Registration Done';
        Text010: Label 'Do you want the reverse the Commision';
        Text011: Label 'Cancellation Done';
        Text012: Label 'Do you want to Vacate the Plot %1?';
        Text013: Label 'you sure you want to post the entries';
        Text50001: Label 'Do you want to Refund?';
        Text50002: Label 'Please verify the details below and confirm. Do you want to post ? %1      :%2\Project Name         :%3  Project Code :%4\Unit No.                 :%5\Customer Name     :%6 %7\Associate Code      :%8  %9 \Receiving Amount  : %10 \Amount in Words   : %11 \Posting Date          : %12.';
        Text0011: Label 'is not within your range of allowed posting dates';
        Text50003: Label 'Do you want to send message to customer %1?';
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
        WebAppService: Codeunit "Web App Service";

    local procedure UpdateApplicationInfo()
    begin
        ReceivableAmount := Rec.TotalApplicationAmount;
        AmountReceived := Rec.Amount;  //"Amount Received";
        DueAmount := ReceivableAmount - AmountReceived;
        IF Rec."Introducer Code" <> '' THEN
            Vend.GET(Rec."Introducer Code");
        IF Rec."Customer No." <> '' THEN
            IF Customer.GET(Rec."Customer No.") THEN;
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
        ConfirmOrder.CALCFIELDS("Total Received Amount");
        ConfirmOrder.CALCFIELDS("Discount Amount");
        RecDueAmount := ConfirmOrder.Amount + ConfirmOrder."Service Charge Amount" -
        ConfirmOrder."Discount Amount" - ConfirmOrder."Total Received Amount";
        IF RecDueAmount >= 0 THEN BEGIN
            ApplPayEntry.RESET;
            ApplPayEntry.SETRANGE("Document Type", ApplPayEntry."Document Type"::BOND);
            ApplPayEntry.SETRANGE("Document No.", ConfirmOrder."No.");
            ApplPayEntry.SETRANGE(Posted, FALSE);
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


    procedure CreateExcessPaymentTermsLine(DocumentNo: Code[20])
    var
        PaymentTermLines: Record "Payment Terms Line Sale";
        PaymentTermLines1: Record "Payment Terms Line Sale";
        UnitCharge: Record "Unit Charge & Payment Pl. Code";
        ExcessCode: Code[10];
        ConOrder: Record "Confirmed Order";
    begin
        UnitCharge.RESET;
        UnitCharge.SETRANGE(ExcessCode, TRUE);
        IF UnitCharge.FINDFIRST THEN
            ExcessCode := UnitCharge.Code
        ELSE
            ERROR('Excess Code setup does not exist');
        ConOrder.GET(DocumentNo);
        PaymentTermLines1.RESET;
        PaymentTermLines1.SETRANGE("Document No.", DocumentNo);
        IF PaymentTermLines1.FINDLAST THEN BEGIN
            IF PaymentTermLines1."Charge Code" <> ExcessCode THEN BEGIN
                PaymentTermLines.INIT;
                PaymentTermLines."Document Type" := PaymentTermLines1."Document Type";
                PaymentTermLines."Document No." := DocumentNo;
                PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
                PaymentTermLines.Sequence := INCSTR(PaymentTermLines1.Sequence); //ALLETDK221112
                PaymentTermLines."Actual Milestone" := PaymentTermLines1."Actual Milestone";
                PaymentTermLines."Payment Plan" := PaymentTermLines1."Payment Plan";
                PaymentTermLines.Description := 'Excess Payment';
                PaymentTermLines."Due Date" := PaymentTermLines1."Due Date";
                PaymentTermLines."Project Code" := ConOrder."Shortcut Dimension 1 Code";
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
                IF UnitpayEntry."Payment Mode" = UnitpayEntry."Payment Mode"::Bank THEN
                    ByCheque := TRUE
                ELSE
                    ByCheque := FALSE;
                //  IF (UnitpayEntry."Payment Mode" <> UnitpayEntry."Payment Mode" :: Cash) AND
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
        AppPayEntry.SETRANGE("Payment Mode", 6, 7); //Refund Cash,Refund Cheque
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
        AppPayEntry.SETRANGE("Explode BOM", FALSE);
        AppPayEntry.SETRANGE(Posted, TRUE);
        IF AppPayEntry.FINDSET THEN
            REPEAT
                TotRcvdAmt += ABS(AppPayEntry.Amount);
            UNTIL AppPayEntry.NEXT = 0;


        ApplicableCharges.RESET;
        ApplicableCharges.SETRANGE("Document No.", Rec."No.");
        ApplicableCharges.SETRANGE(Code, 'ADMIN');
        IF ApplicableCharges.FINDFIRST THEN
            AdminCharges := ApplicableCharges."Net Amount";

        IF (TotRefundAmt > (TotRcvdAmt - AdminCharges)) THEN
            ERROR('Full Refund Amount must be %1', (TotRcvdAmt - AdminCharges));
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

            //  PostGenJnlLines; ALLEDK 260113

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
        //GenJnlLine.DELETEALL;
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


    procedure SendSMS(MobileNo: Text[30]; SMSText: Text[300])
    var
        //XMLHTTP: Automation;
        //XMLResponse: Automation;
        SMSUrl: Text[500];
    begin
        // ALLEPG 280113 Start
        /* Upgrade140118 code comment
        IF ISCLEAR(XMLHTTP) THEN
          CREATE(XMLHTTP);
        SMSUrl:='http://www.smscountry.com/SAPSendSMS.asp?i=a&User=marami&passwd=blocks&mobilenumber=';
        SMSUrl+=MobileNo+'&message='+SMSText;
        SMSUrl+='&App=SAP&sid=bbgind';
        XMLHTTP.open('GET',SMSUrl,FALSE);
        XMLHTTP.send();
        CLEAR(XMLHTTP);
        // ALLEPG 280113 End
        
        */ //Upgrade140118 code comment

    end;


    procedure InsertSMSText(ConfirmedOrder: Record "Confirmed Order")
    var
        AppPayEntry: Record "Application Payment Entry";
    begin
        // ALLEPG 280113 Start
        CashAmt := 0;
        Flag := FALSE;
        CustSMSText := 'Thanks for making payment by ';

        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document No.", ConfirmedOrder."Application No.");
        AppPayEntry.SETRANGE(Posted, FALSE);
        IF AppPayEntry.FINDSET THEN
            REPEAT
                IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Cash THEN BEGIN
                    CashAmt += AppPayEntry.Amount;
                    CustSMSText += AppPayEntry."Payment Method" + ' ' + 'Amount ' + FORMAT(AppPayEntry.Amount) + ',';
                END
                ELSE
                    IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Bank THEN BEGIN
                        Flag := TRUE;
                        IF AppPayEntry."Payment Method" = 'CHEQUE' THEN
                            CustSMSText += AppPayEntry."Payment Method" + ' with Cheque No. ' + AppPayEntry."Cheque No./ Transaction No." + ' ' +
                            'Dated ' + FORMAT(AppPayEntry."Cheque Date") + ' ' + 'Amount ' + FORMAT(AppPayEntry.Amount) + ','
                        ELSE
                            IF AppPayEntry."Payment Method" = 'CREDITCARD' THEN
                                CustSMSText += AppPayEntry."Payment Method" + ' with Tranx. No. ' + AppPayEntry."Cheque No./ Transaction No." + ' ' +
                                'Dated ' + FORMAT(AppPayEntry."Cheque Date") + ' ' + 'Amount ' + FORMAT(AppPayEntry.Amount) + ','
                            ELSE
                                IF AppPayEntry."Payment Method" = 'DEBITCARD' THEN
                                    CustSMSText += AppPayEntry."Payment Method" + ' with Tranx. No. ' + AppPayEntry."Cheque No./ Transaction No." + ' ' +
                                    'Dated ' + FORMAT(AppPayEntry."Cheque Date") + ' ' + 'Amount ' + FORMAT(AppPayEntry.Amount) + ','
                                ELSE
                                    IF AppPayEntry."Payment Method" = 'NEFT' THEN
                                        CustSMSText += AppPayEntry."Payment Method" + ' with Tranx. No. ' + AppPayEntry."Cheque No./ Transaction No." + ' ' +
                                        'Dated ' + FORMAT(AppPayEntry."Cheque Date") + ' ' + 'Amount ' + FORMAT(AppPayEntry.Amount) + ','
                                    ELSE
                                        IF AppPayEntry."Payment Method" = 'RTGS' THEN
                                            CustSMSText += AppPayEntry."Payment Method" + ' with Tranx. No. ' + AppPayEntry."Cheque No./ Transaction No." + ' ' +
                                            'Dated ' + FORMAT(AppPayEntry."Cheque Date") + ' ' + 'Amount ' + FORMAT(AppPayEntry.Amount) + ','
                    END;
            UNTIL AppPayEntry.NEXT = 0;
        // ALLEPG 280113 End
    end;


    procedure UpdateClearance()
    var
        APEntry1: Record "Application Payment Entry";
        BALEntry1: Record "Bank Account Ledger Entry";
        BASLines1: Record "Bank Account Statement Line";
        NAPEntry1: Record "NewApplication Payment Entry";
        APEntry2: Record "Application Payment Entry";
        UPEntry: Record "Unit Payment Entry";
    begin
        APEntry1.RESET;
        APEntry1.SETRANGE("Document No.", Rec."No.");
        //APEntry1.SETRANGE("Cheque Status",APEntry1."Cheque Status"::" ");
        APEntry1.SETFILTER("Payment Mode", '<>%1', APEntry1."Payment Mode"::JV);
        APEntry1.SETRANGE(APEntry1.Posted, TRUE);
        APEntry1.SETFILTER("Posting date", '>%1', 20190101D);
        IF APEntry1.FINDSET THEN
            REPEAT
                BALEntry1.RESET;
                BALEntry1.SETCURRENTKEY("Document No.");
                BALEntry1.SETRANGE("Document No.", APEntry1."Posted Document No.");
                BALEntry1.SETRANGE(BALEntry1."Statement Status", BALEntry1."Statement Status"::Closed);
                // BALEntry1.SETRANGE(Amount,ABS(APEntry1.Amount));
                BALEntry1.SETRANGE("Cheque No.", APEntry1."Cheque No./ Transaction No.");
                BALEntry1.SETRANGE("Bank Account No.", APEntry1."Deposit/Paid Bank");
                BALEntry1.SETRANGE(Bounced, TRUE);
                IF BALEntry1.FINDFIRST THEN BEGIN
                    BASLines1.RESET;
                    BASLines1.SETCURRENTKEY("Document No.");
                    BASLines1.SETRANGE("Document No.", BALEntry1."Document No.");
                    BASLines1.SETRANGE("Bank Account No.", BALEntry1."Bank Account No.");
                    IF BASLines1.FINDFIRST THEN BEGIN
                        APEntry1."Cheque Status" := APEntry1."Cheque Status"::Bounced;
                        APEntry1."Chq. Cl / Bounce Dt." := BASLines1."Value Date";
                        APEntry1.MODIFY;
                        NAPEntry1.RESET;
                        NAPEntry1.SETRANGE("Document No.", Rec."No.");
                        NAPEntry1.SETRANGE("Posting date", APEntry1."Posting date");
                        NAPEntry1.SETRANGE(Amount, APEntry1.Amount);
                        NAPEntry1.SETRANGE("Cheque No./ Transaction No.", APEntry1."Cheque No./ Transaction No.");
                        NAPEntry1.SETRANGE(NAPEntry1."Deposit/Paid Bank", APEntry1."Deposit/Paid Bank");
                        IF NAPEntry1.FINDFIRST THEN BEGIN
                            NAPEntry1."Cheque Status" := NAPEntry1."Cheque Status"::Bounced;
                            NAPEntry1."Chq. Cl / Bounce Dt." := BASLines1."Value Date";
                            NAPEntry1.MODIFY;
                        END;
                    END;
                END ELSE BEGIN
                    BALEntry1.RESET;
                    BALEntry1.SETCURRENTKEY("Document No.");
                    BALEntry1.SETRANGE("Document No.", APEntry1."Posted Document No.");
                    BALEntry1.SETRANGE("Statement Status", BALEntry1."Statement Status"::Closed);
                    BALEntry1.SETRANGE(Amount, ABS(APEntry1.Amount));
                    BALEntry1.SETRANGE("Cheque No.", APEntry1."Cheque No./ Transaction No.");
                    BALEntry1.SETRANGE("Bank Account No.", APEntry1."Deposit/Paid Bank");
                    BALEntry1.SETRANGE(Open, FALSE);
                    IF BALEntry1.FINDFIRST THEN BEGIN
                        BASLines1.RESET;
                        BASLines1.SETCURRENTKEY("Document No.");
                        BASLines1.SETRANGE("Document No.", BALEntry1."Document No.");
                        BASLines1.SETRANGE("Bank Account No.", BALEntry1."Bank Account No.");
                        IF BASLines1.FINDFIRST THEN BEGIN
                            APEntry1."Cheque Status" := APEntry1."Cheque Status"::Cleared;
                            APEntry1."Chq. Cl / Bounce Dt." := BASLines1."Value Date";
                            APEntry1.MODIFY;
                            NAPEntry1.RESET;
                            NAPEntry1.SETRANGE("Document No.", Rec."No.");
                            NAPEntry1.SETRANGE("Posting date", APEntry1."Posting date");
                            NAPEntry1.SETRANGE(Amount, APEntry1.Amount);
                            NAPEntry1.SETRANGE("Cheque No./ Transaction No.", APEntry1."Cheque No./ Transaction No.");
                            NAPEntry1.SETRANGE(NAPEntry1."Deposit/Paid Bank", APEntry1."Deposit/Paid Bank");
                            IF NAPEntry1.FINDFIRST THEN BEGIN
                                NAPEntry1."Cheque Status" := NAPEntry1."Cheque Status"::Cleared;
                                NAPEntry1."Chq. Cl / Bounce Dt." := BASLines1."Value Date";
                                NAPEntry1.MODIFY;
                            END;
                        END;
                    END;
                END;
            UNTIL APEntry1.NEXT = 0;

        UPEntry.RESET;
        UPEntry.SETRANGE("Document No.", Rec."No.");
        UPEntry.SETRANGE(UPEntry."Cheque Status", UPEntry."Cheque Status"::" ");
        IF UPEntry.FINDSET THEN
            REPEAT
                APEntry2.RESET;
                APEntry2.SETRANGE("Document No.", Rec."No.");
                APEntry2.SETRANGE("Posted Document No.", UPEntry."Posted Document No.");
                IF APEntry2.FINDFIRST THEN BEGIN
                    UPEntry."Cheque Status" := UPEntry."Cheque Status"::Cleared;
                    UPEntry."Chq. Cl / Bounce Dt." := APEntry2."Chq. Cl / Bounce Dt.";
                    UPEntry.MODIFY;
                END;
            UNTIL UPEntry.NEXT = 0;
    end;
}

