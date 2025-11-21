page 50172 "MJV Development Card"
{
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "New Confirmed Order";
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
                field("Project Name"; GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1))
                {
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Member No.';
                    Editable = false;
                }
                field("Member Name"; Customer.Name)
                {
                    Caption = 'Member Name';
                    Editable = false;
                }
                field("User Id"; Rec."User Id")
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
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                    Editable = false;
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                    Editable = false;
                }
                field("LLP Name"; Rec."LLP Name")
                {
                    Editable = false;
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Company Name"; Rec."Company Name")
                {
                    Editable = false;
                }
                field("Development Charges"; Rec."Development Charges")
                {
                }
                field("Total Recved Development Charge"; Rec."Total Received Dev. Charges")
                {
                    Caption = 'Total Recved Development Charge';
                }
                field("Development Due Amount"; Rec."Development Charges" - Rec."Total Received Dev. Charges")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                    Editable = false;
                }
            }
            part("Receipt Lines"; "MJV Developmnt Subform")
            {
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(false));
                UpdatePropagation = Both;
            }
            part(PostedUnitPayEntrySubform; "Posted Application Devlopment")
            {
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(true));
            }
            group(Info)
            {
                Editable = false;
                field(Amount; Rec.Amount)
                {
                    Caption = 'Total Amount';
                    Editable = false;
                    Visible = false;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Net Amount"; Rec.Amount - Rec."Discount Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Due Amount"; Rec.Amount + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Application Type"; Rec."Application Type")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Function")
            {
                action(Post)
                {
                    Image = Post;
                    Promoted = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        AppPayEntry: Record "New Application DevelopmntLine";
                        NewAppEntry: Record "New Application DevelopmntLine";
                        OldConforder: Record "Confirmed Order";
                        AppPayEntry_1: Record "Application Payment Entry";
                        PostDevelopmentCharges: Codeunit "Post Development Charges";
                    begin

                        CLEAR(PaymentAmt);
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", Rec."No.");
                        AppPayEntry.SETRANGE(Posted, FALSE);
                        IF AppPayEntry.FINDSET THEN
                            REPEAT
                                PaymentAmt += AppPayEntry.Amount;
                                IF AppPayEntry.COUNT > 1 THEN
                                    ERROR('Single receipt entry allowed');
                                AppPayEntry.TESTFIELD("Apply to Document No.");
                                AppPayEntry.TESTFIELD("Order Ref No.");
                                IF ABS(AppPayEntry.Amount) < AppPayEntry."MJV Transfer Amount" THEN
                                    ERROR('MJV Transfer Amount can not be greater than Amount');
                            UNTIL AppPayEntry.NEXT = 0;

                        AmountToWords.InitTextVariable;
                        AmountToWords.FormatNoText(AmountText1, PaymentAmt, '');
                        CLEAR(AppPayEntry);
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", Rec."No.");
                        AppPayEntry.SETFILTER(Amount, '<>%1', 0);
                        AppPayEntry.SETRANGE(Posted, FALSE);
                        IF AppPayEntry.FINDLAST THEN
                            IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::" " THEN
                                ERROR('Please define the Payment Mode.');

                        Amt1 := 0;
                        AppPaymentEntryNew.RESET;
                        AppPaymentEntryNew.SETRANGE("Document No.", Rec."No.");
                        AppPaymentEntryNew.SETFILTER("Cheque Status", '<>%1', AppPaymentEntryNew."Cheque Status"::Bounced);
                        IF AppPaymentEntryNew.FINDSET THEN
                            REPEAT
                                Amt1 := Amt1 + AppPaymentEntryNew.Amount;
                            UNTIL AppPaymentEntryNew.NEXT = 0;

                        IF Amt1 > Rec."Development Charges" THEN
                            IF CONFIRM(STRSUBSTNO(Text50004, (Amt1 - Rec."Development Charges"))) THEN BEGIN
                            END ELSE
                                EXIT;




                        IF CONFIRM(STRSUBSTNO(Text50002, Rec.FIELDCAPTION("Application No."), Rec."Application No.",
                           GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."Shortcut Dimension 1 Code", Rec."Unit Code", Customer.Name,
                           Rec."Customer No.", Rec."Introducer Code", Vend.Name,
                           PaymentAmt, AmountText1[1], AppPayEntry."Posting date")) THEN BEGIN
                            IF CONFIRM(Text006) THEN BEGIN
                                AppPaymentEntryNew.RESET;
                                AppPaymentEntryNew.SETRANGE("Document No.", Rec."No.");
                                IF AppPaymentEntryNew.FINDLAST THEN BEGIN
                                    //AppPaymentEntryNew.Posted := TRUE;
                                    //AppPaymentEntryNew."Receipt Post in Devlp. Comp." := TRUE;
                                    //AppPaymentEntry."Create from MSC Company" := FALSE;
                                    //AppPaymentEntryNew.MODIFY;
                                    CLEAR(PostDevelopmentCharges);
                                    PostDevelopmentCharges.CreateDevlopmentCustomerMJVEntry(AppPaymentEntryNew, AppPaymentEntryNew."Apply to Document No.");
                                END;
                            END;
                            MESSAGE(Text007);

                        END;
                    end;
                }
                action("New Receipt")
                {
                    Image = print;
                    Visible = false;
                }
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
        IF NOT Customer.GET(Rec."Customer No.") THEN
            CLEAR(Customer);

        IF NOT Customer2.GET(Rec."Customer No. 2") THEN
            CLEAR(Customer2);

        IF NOT BondNominee.GET(Rec."No.") THEN
            CLEAR(BondNominee);
        IF NOT Vendor.GET(Rec."Introducer Code") THEN
            CLEAR(Vendor);
        //IF NOT BondMaturity.GET("No.") THEN
        //  CLEAR(BondMaturity);

        IF NOT CustomerBankAccount.GET(Rec."Customer No.", Rec."Return Bank Account Code") THEN
            CLEAR(CustomerBankAccount);

        UnpostedInstallment :=
          GetDescription.GetPaymentSchedule(Rec."No.", Rec."Investment Type") - GetDescription.GetRDNotClearedChq(Rec."No.", Rec."Investment Type"
        );
        IF UnpostedInstallment < 0 THEN
            UnpostedInstallment := 0;
        //ALLECK 060513 START

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

        //ALLECK 060513 END
    end;

    var
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
        Unitmaster: Record "Unit Master";
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
        AppPaymentEntry: Record "New Application DevelopmntLine";
        ConfReport: Report "Member Receipt";
        MemberOf: Record "Access Control";
        CustMobileNo: Text[30];
        CustSMSText: Text[1000];
        CashAmt: Decimal;
        AppPayEntry: Record "New Application DevelopmntLine";
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
        UnitCode: Code[20];
        Companywise: Record "Company wise G/L Account";
        Job1: Record Job;
        CreatUPEryfromConfOrder: Codeunit "Creat UPEry from ConfOrder/APP";
        LLPName: Text[30];
        RecJob1: Record "Responsibility Center 1";
        Amt1: Decimal;
        AppPaymentEntryNew: Record "New Application DevelopmntLine";
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
        Text50004: Label 'The total receive amount is going to excess with value %1. Do you want to continue?';
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
        ConfReport3: Report "Member Receipt_12";

    local procedure UpdateApplicationInfo()
    begin

        ReceivableAmount := Rec.TotalApplicationAmount;
        AmountReceived := Rec.Amount;  //"Amount Received";
        DueAmount := ReceivableAmount - AmountReceived;
        IF Rec."Introducer Code" <> '' THEN
            Vend.GET(Rec."Introducer Code");
        IF Rec."Customer No." <> '' THEN
            Customer.GET(Rec."Customer No.");
    end;


    procedure GetLastLineNo(BondPaymentEntryRec: Record "Application Payment Entry")
    var
        BPayEntry: Record "Unit Payment Entry";
    begin
    end;
}

