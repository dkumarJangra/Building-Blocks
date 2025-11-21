page 50091 "Refund/Negative Adj"
{
    // Upgrade140118 code comment

    DeleteAllowed = false;
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
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Project Name"; GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1))
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
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
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
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Posted Doc No."; Rec."Posted Doc No.")
                {
                }
                field("Refund Initiate Amount"; Rec."Refund Initiate Amount")
                {
                    Editable = false;
                }
            }
            part("Receipt Lines"; "NewUnit PEntry Refund  Subform")
            {
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(false));
                UpdatePropagation = Both;
            }
            part(PostedUnitPayEntrySubform; "New Posted Unit Pay Entryfom")
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
                SubPageLink = "Table Name" = FILTER("New Confirmed order"),
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
            group("Other Information")
            {
                field(Type; Rec.Type)
                {
                }
                field("Pass Book No."; Rec."Pass Book No.")
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
                field("Project Type"; Rec."Project Type")
                {
                    Caption = 'Commission Code';
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
                field("Application Type"; Rec."Application Type")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Project change Comment"; Rec."Project change Comment")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Print)
            {
                action("Unposted Receipt")
                {

                    trigger OnAction()
                    begin

                        Bond := Rec;
                        Bond.SETRECFILTER;
                        CLEAR(ConfReport);
                        AppPaymentEntry.RESET;
                        AppPaymentEntry.SETRANGE("Document No.", Rec."No.");
                        AppPaymentEntry.SETRANGE(Posted, FALSE);
                        IF AppPaymentEntry.FINDLAST THEN BEGIN
                            // ConfReport1.SetPostFilter(Rec."No.", AppPaymentEntry."Posted Document No.");
                            // ConfReport1.RUN;
                        END;
                        Bond.RESET;
                    end;
                }
                action("Member Receipt")
                {

                    trigger OnAction()
                    begin

                        Bond := Rec;
                        Bond.SETRECFILTER;
                        CLEAR(ConfReport);
                        AppPaymentEntry.RESET;
                        AppPaymentEntry.SETRANGE("Document No.", Rec."No.");
                        AppPaymentEntry.SETFILTER("Payment Mode", '<>%1', AppPaymentEntry."Payment Mode"::JV);
                        AppPaymentEntry.SETRANGE(Posted, TRUE);
                        IF AppPaymentEntry.FINDLAST THEN BEGIN
                            ConfReport.SetPostFilter(Rec."No.", AppPaymentEntry."Posted Document No.");
                            ConfReport.RUN;
                        END;
                        Bond.RESET;
                    end;
                }
            }
            group("&Mod.PssBk")
            {
                action(Release)
                {

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                action(ReOpen)
                {

                    trigger OnAction()
                    begin

                        MemberOf.RESET;
                        MemberOf.SETRANGE("User Name", USERID);
                        MemberOf.SETRANGE("Role ID", 'A_EDITPASSBOOK');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of Role :A_A_EDITPASSBOOK');
                        //ALLECK 290313 END
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
            }
            group("Function")
            {
                action("Refund Entry for Approval")
                {
                    RunObject = Page "Refund Approval pending Entry";
                    RunPageView = WHERE("Payment Mode" = FILTER("Refund Bank" | "Refund Cash"),
                                        Posted = FILTER(false));

                    trigger OnAction()
                    var
                        RecptEntry: Record "NewApplication Payment Entry";
                        NoofRec: Integer;
                    begin


                        IF CONFIRM('Do you want to Cancell the Receipt') THEN BEGIN
                            IF Rec."Application Type" = Rec."Application Type"::"Non Trading" THEN BEGIN
                                CurrPage.PostedUnitPayEntrySubform.PAGE.ReversalRcpt;
                                RecptEntry.RESET;
                                RecptEntry.SETRANGE("Document No.", Rec."No.");
                                RecptEntry.SETRANGE("Create from MSC Company", TRUE);
                                IF RecptEntry.FINDSET THEN BEGIN
                                    NoofRec := RecptEntry.COUNT;
                                    IF NoofRec = 1 THEN
                                        Rec.Status := Rec.Status::Cancelled;
                                    Rec.MODIFY;
                                END;
                            END ELSE
                                ERROR('You can not cancell the Receipt');
                        END;
                    end;
                }
                action(Post)
                {

                    trigger OnAction()
                    var
                        AppPayEntry: Record "NewApplication Payment Entry";
                        CheckPayAmt: Decimal;
                        NewAppEntry_2: Record "Application Payment Entry";
                        NewAppEntry_1: Record "Application Payment Entry";
                        CommEntry_2: Record "Commission Entry";
                        UpdatePostDoc: Record "Application Payment Entry";
                    begin
                        Rec.TESTFIELD("Registration Status", Rec."Registration Status"::" ");  //090921
                        Rec.TESTFIELD("Application Closed", FALSE);  //190820
                        CheckVendor.RESET;
                        CheckVendor.SETRANGE("No.", Rec."Introducer Code");
                        IF CheckVendor.FINDFIRST THEN BEGIN
                            CheckVendor.TESTFIELD("BBG Black List", FALSE);
                        END;


                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Refund Post", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact to Admin');



                        //CheckRefundAmount_1(TRUE);  120516

                        //CheckRefundAmount;

                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document Type", AppPayEntry."Document Type"::BOND);
                        AppPayEntry.SETRANGE("Document No.", Rec."No.");
                        AppPayEntry.SETRANGE(Posted, FALSE);
                        IF AppPayEntry.FINDFIRST THEN BEGIN
                            CheckPayAmt := AppPayEntry.Amount;
                            //291222
                            IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Bank") OR (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Cash") THEN BEGIN
                                UserSetup.RESET;
                                UserSetup.SETRANGE("User ID", USERID);
                                UserSetup.SETRANGE("Direct Refund", TRUE);
                                IF NOT UserSetup.FINDFIRST THEN
                                    Rec.TESTFIELD("Refund SMS Status", Rec."Refund SMS Status"::Approved);
                            END;
                            //291222
                        END;
                        IF CheckPayAmt = 0 THEN
                            ERROR('Please fill the Refund / Negative Adj. amount');

                        AmountToWords.InitTextVariable;
                        AmountToWords.FormatNoText(AmountText1, ABS(CheckPayAmt), '');

                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", Rec."No.");
                        AppPayEntry.SETRANGE(Posted, FALSE);
                        IF AppPayEntry.FINDLAST THEN;

                        IF CONFIRM(STRSUBSTNO(Text50002, Rec.FIELDCAPTION("Application No."), Rec."Application No.",
                          GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."Shortcut Dimension 1 Code", Rec."Unit Code", Customer.Name,
                          Rec."Customer No.", Rec."Introducer Code", Vend.Name, CheckPayAmt, AmountText1[1], AppPayEntry."Posting date")) THEN BEGIN
                            IF CONFIRM(Text006) THEN BEGIN //ALLECK020313
                                CLEAR(PostPayment);
                                AppPayEntry.RESET;
                                AppPayEntry.SETRANGE("Document Type", AppPayEntry."Document Type"::BOND);
                                AppPayEntry.SETRANGE("Document No.", Rec."No.");
                                AppPayEntry.SETFILTER("Payment Mode", '%1|%2|%3', 6, 7, 11); //Refund Cash,Refund Cheque,Negative Adjmt.
                                AppPayEntry.SETRANGE("Explode BOM", FALSE);
                                AppPayEntry.SETRANGE(Posted, FALSE);
                                IF AppPayEntry.FINDFIRST THEN BEGIN
                                    IF CONFIRM(Text50001, FALSE) THEN BEGIN
                                        IF AppPayEntry."Payment Mode" <> AppPayEntry."Payment Mode"::"Negative Adjmt." THEN BEGIN
                                            IF CONFIRM(Text010, FALSE) THEN
                                                AppPayEntry."Commmission Reverse" := TRUE
                                            ELSE
                                                AppPayEntry."Commmission Reverse" := FALSE;
                                            Rec.CALCFIELDS("Amount Received");
                                            IF Rec."Amount Received" >= Rec."Min. Allotment Amount" THEN BEGIN
                                                CommEntry_2.RESET;
                                                CommEntry_2.CHANGECOMPANY(Rec."Company Name");
                                                CommEntry_2.SETRANGE("Application No.", Rec."No.");
                                                IF NOT CommEntry_2.FINDFIRST THEN
                                                    ERROR('Please create Commission Entry');
                                            END;
                                            // ELSE
                                            //AppPayEntry."Commmission Reverse" :=FALSE;
                                        END;
                                        AppPayEntry.MODIFY;

                                        IF Rec."Application Type" = Rec."Application Type"::"Non Trading" THEN
                                            PostPayment.NewPostBondPayment(Rec, 'Refund')
                                        ELSE BEGIN
                                            NewAppEntry_2.RESET;
                                            NewAppEntry_2.SETRANGE("Document No.", Rec."No.");
                                            IF NewAppEntry_2.FINDLAST THEN;
                                            NewAppEntry_1.INIT;
                                            NewAppEntry_1."Document Type" := NewAppEntry_1."Document Type"::BOND;
                                            NewAppEntry_1."Document No." := AppPayEntry."Document No.";
                                            NewAppEntry_1."Line No." := NewAppEntry_2."Line No." + 10000;
                                            NewAppEntry_1."Payment Method" := AppPayEntry."Payment Method";
                                            NewAppEntry_1.Amount := AppPayEntry.Amount;
                                            NewAppEntry_1."LD Amount" := AppPayEntry."LD Amount";
                                            NewAppEntry_1."Payment Mode" := AppPayEntry."Payment Mode";
                                            NewAppEntry_1."Unit Code" := AppPayEntry."Unit Code";
                                            NewAppEntry_1.Description := AppPayEntry.Description;
                                            NewAppEntry_1."Document Date" := AppPayEntry."Document Date";
                                            NewAppEntry_1."User Branch Code" := AppPayEntry."User Branch Code";
                                            NewAppEntry_1."User Branch Code" := AppPayEntry."User Branch Code";
                                            NewAppEntry_1."User ID" := AppPayEntry."User ID";
                                            NewAppEntry_1."User Branch Name" := AppPayEntry."User Branch Name";
                                            NewAppEntry_1."Posting date" := AppPayEntry."Posting date";
                                            NewAppEntry_1."Shortcut Dimension 1 Code" := AppPayEntry."Shortcut Dimension 1 Code";
                                            IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::"Refund Bank" THEN
                                                NewAppEntry_1."Cheque Status" := AppPayEntry."Cheque Status"
                                            ELSE
                                                NewAppEntry_1."Cheque Status" := NewAppEntry_1."Cheque Status"::Cleared;
                                            NewAppEntry_1."Order Ref No." := AppPayEntry."Order Ref No.";
                                            NewAppEntry_1."Commission Reversed" := AppPayEntry."Commmission Reverse";
                                            NewAppEntry_1."Cheque No./ Transaction No." := AppPayEntry."Cheque No./ Transaction No.";
                                            NewAppEntry_1."Cheque Date" := AppPayEntry."Cheque Date";
                                            NewAppEntry_1."Cheque Bank and Branch" := AppPayEntry."Cheque Bank and Branch";
                                            NewAppEntry_1."Deposit/Paid Bank" := AppPayEntry."Deposit/Paid Bank";
                                            NewAppEntry_1.Narration := AppPayEntry.Narration;
                                            NewAppEntry_1."Receipt Line No." := AppPayEntry."Line No."; //ALLEDK 10112016
                                            NewAppEntry_1.INSERT;
                                            BondReversal.BondReverse(Rec."No.", AppPayEntry."Commmission Reverse", 0, FALSE);
                                            AppPayEntry.Posted := TRUE;
                                            AppPayEntry."Receipt post on InterComp" := TRUE;

                                            UpdatePostDoc.RESET;
                                            UpdatePostDoc.SETRANGE("Document No.", Rec."No.");
                                            UpdatePostDoc.SETRANGE(Posted, TRUE);
                                            IF UpdatePostDoc.FINDLAST THEN BEGIN
                                                AppPayEntry."Posted Document No." := UpdatePostDoc."Posted Document No.";
                                            END;

                                            AppPayEntry.MODIFY;
                                        END;
                                    END;
                                END
                                ELSE
                                    ERROR('Data does not exist to Post');
                            END;
                        END;
                        MESSAGE('%1', 'Posting done');

                        //210624 Code start
                        Umasters.RESET;
                        IF Rec."Unit Code" <> '' THEN
                            IF Umasters.GET(Rec."Unit Code") THEN
                                WebAppService.UpdateUnitStatus(Umasters); //210624
                        //210624 Code End
                    end;
                }
                action("Refund Amount Suggest")
                {

                    trigger OnAction()
                    var
                        AssHierarcy: Record "Associate Hierarcy with App.";
                    begin
                        CheckRefundAmount_1(FALSE);
                    end;
                }
                action("Refund SMS Send")
                {

                    trigger OnAction()
                    var
                        RegionCode: Code[10];
                        NewAssociateBottom: Report "New Associate Bottom To Top_1";
                    begin

                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Refund SMS Completed", FALSE);
                        IF UserSetup.FINDFIRST THEN
                            ERROR('Contact Admin');
                        ComInfo.GET;
                        IF ComInfo."Send SMS" THEN BEGIN
                            IF CONFIRM(Text50003, TRUE) THEN
                                IF Customer.GET(Rec."Customer No.") THEN
                                    IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                        NewApplPayEntry_1.RESET;
                                        NewApplPayEntry_1.SETRANGE("Document No.", Rec."No.");
                                        NewApplPayEntry_1.SETRANGE(Posted, TRUE);
                                        NewApplPayEntry_1.SETFILTER("Payment Mode", '%1|%2', NewApplPayEntry_1."Payment Mode"::"Refund Cash",
                                                                     NewApplPayEntry_1."Payment Mode"::"Refund Bank");
                                        IF NewApplPayEntry_1.FINDLAST THEN;
                                        IF Job.GET(Rec."Shortcut Dimension 1 Code") THEN
                                            IF Job."Region Code for Rank Hierarcy" <> '' THEN
                                                RegionCode := Job."Region Code for Rank Hierarcy"
                                            ELSE
                                                RegionCode := 'R0001';

                                        RespCenter.RESET;
                                        IF RespCenter.GET(Rec."Shortcut Dimension 1 Code") THEN;
                                        CLEAR(NewAssociateBottom);
                                        NewAssociateBottom.SetCustRefund(Customer."BBG Mobile No.", Customer.Name, Rec."No.", RespCenter.Name, NewApplPayEntry_1.Amount,
                                        NewApplPayEntry_1."Posting date", RegionCode, Rec."Introducer Code");
                                        NewAssociateBottom.RUNMODAL;
                                        InsertRefundChangeLog;  //09022023
                                    END;
                        END;
                    end;
                }
            }
            group("&Navigate")
            {
                Caption = 'Navigate';
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
        Rec.SETRANGE("No.");
    end;

    trigger OnAfterGetRecord()
    begin

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
        v_RefundChangeLogDetails: Record "Refund Change Log Details";
        WebAppService: Codeunit "Web App Service";
        Umasters: Record "Unit Master";

    local procedure UpdateApplicationInfo()
    begin

        //ReceivableAmount := TotalApplicationAmount;
        //AmountReceived := Amount;  //"Amount Received";
        //DueAmount := ReceivableAmount - AmountReceived;
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


    procedure SendSMS(MobileNo: Text[30]; SMSText: Text[300])
    var
        // XMLHTTP: Automation;
        // XMLResponse: Automation;
        SMSUrl: Text[500];
    begin
        /* Upgrade140118 code comment
        // ALLEPG 280113 Start
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


    procedure InsertSMSText(ConfirmedOrder: Record "New Confirmed Order")
    var
        AppPayEntry: Record "NewApplication Payment Entry";
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
                ELSE IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Bank THEN BEGIN
                    Flag := TRUE;
                    IF AppPayEntry."Payment Method" = 'CHEQUE' THEN
                        CustSMSText += AppPayEntry."Payment Method" + ' with Cheque No. ' + AppPayEntry."Cheque No./ Transaction No." + ' ' +
                        'Dated ' + FORMAT(AppPayEntry."Cheque Date") + ' ' + 'Amount ' + FORMAT(AppPayEntry.Amount) + ','
                    ELSE IF AppPayEntry."Payment Method" = 'CREDITCARD' THEN
                        CustSMSText += AppPayEntry."Payment Method" + ' with Tranx. No. ' + AppPayEntry."Cheque No./ Transaction No." + ' ' +
                        'Dated ' + FORMAT(AppPayEntry."Cheque Date") + ' ' + 'Amount ' + FORMAT(AppPayEntry.Amount) + ','
                    ELSE IF AppPayEntry."Payment Method" = 'DEBITCARD' THEN
                        CustSMSText += AppPayEntry."Payment Method" + ' with Tranx. No. ' + AppPayEntry."Cheque No./ Transaction No." + ' ' +
                        'Dated ' + FORMAT(AppPayEntry."Cheque Date") + ' ' + 'Amount ' + FORMAT(AppPayEntry.Amount) + ','
                    ELSE IF AppPayEntry."Payment Method" = 'NEFT' THEN
                        CustSMSText += AppPayEntry."Payment Method" + ' with Tranx. No. ' + AppPayEntry."Cheque No./ Transaction No." + ' ' +
                        'Dated ' + FORMAT(AppPayEntry."Cheque Date") + ' ' + 'Amount ' + FORMAT(AppPayEntry.Amount) + ','
                    ELSE IF AppPayEntry."Payment Method" = 'RTGS' THEN
                        CustSMSText += AppPayEntry."Payment Method" + ' with Tranx. No. ' + AppPayEntry."Cheque No./ Transaction No." + ' ' +
                        'Dated ' + FORMAT(AppPayEntry."Cheque Date") + ' ' + 'Amount ' + FORMAT(AppPayEntry.Amount) + ','
                END;
            UNTIL AppPayEntry.NEXT = 0;
        // ALLEPG 280113 End
    end;


    procedure CheckRefundAmount()
    var
        ApplicableCharges: Record "Applicable Charges";
        AppPayEntry: Record "NewApplication Payment Entry";
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
        AppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::Cleared);
        AppPayEntry.SETRANGE(Posted, TRUE);
        IF AppPayEntry.FINDSET THEN
            REPEAT
                TotRcvdAmt += AppPayEntry.Amount;
            UNTIL AppPayEntry.NEXT = 0;


        ApplicableCharges.RESET;
        ApplicableCharges.CHANGECOMPANY(Rec."Company Name");
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
    end;


    procedure CheckRefundAmount_1(FromPost: Boolean)
    var
        UnitPayEntry_1: Record "Unit Payment Entry";
        RecJob_1: Record Job;
        TotalRecAmt: Decimal;
        NewAppPayEntry: Record "NewApplication Payment Entry";
    begin
        TotalRecAmt := 0;

        UnitPayEntry_1.RESET;
        UnitPayEntry_1.CHANGECOMPANY(Rec."Company Name");
        UnitPayEntry_1.SETRANGE("Document No.", Rec."No.");
        UnitPayEntry_1.SETRANGE(Posted, TRUE);
        UnitPayEntry_1.SETRANGE("Cheque Status", UnitPayEntry_1."Cheque Status"::Cleared);
        IF UnitPayEntry_1.FINDSET THEN
            REPEAT
                IF (UnitPayEntry_1."Charge Code" <> 'EXCESS') AND (UnitPayEntry_1."Charge Code" <> 'ADMIN') AND
                  (UnitPayEntry_1."Charge Code" <> 'ADMIN2') THEN
                    TotalRecAmt := TotalRecAmt + UnitPayEntry_1.Amount;
            UNTIL UnitPayEntry_1.NEXT = 0;

        RecJob_1.RESET;
        RecJob_1.SETRANGE("No.", Rec."Shortcut Dimension 1 Code");
        IF RecJob_1.FINDFIRST THEN BEGIN
            RecJob_1.TESTFIELD(RecJob_1."Refund %");
            NewAppPayEntry.RESET;
            NewAppPayEntry.SETRANGE("Document No.", Rec."No.");
            NewAppPayEntry.SETRANGE(Posted, FALSE);
            NewAppPayEntry.SETRANGE("User ID", USERID);
            IF NewAppPayEntry.FINDLAST THEN BEGIN
                IF FromPost THEN BEGIN
                    IF NewAppPayEntry."Refund Amount" > ROUND((TotalRecAmt * RecJob_1."Refund %" / 100), 1, '=') THEN
                        ERROR('Refund amount can not greater than Amount ' + FORMAT(ROUND((TotalRecAmt * RecJob_1."Refund %" / 100), 1, '=')));
                END ELSE BEGIN
                    NewAppPayEntry.VALIDATE("Refund Amount", ROUND((TotalRecAmt * RecJob_1."Refund %" / 100), 1, '='));
                    NewAppPayEntry.MODIFY;
                END;
            END;
        END;
    end;

    local procedure InsertRefundChangeLog()
    var
        RefundChangeLogDetails: Record "Refund Change Log Details";
        NewConfirmedOrder: Record "New Confirmed Order";
    begin
        LineNo := 0;
        RefundChangeLogDetails.RESET;
        RefundChangeLogDetails.SETRANGE("No.", Rec."No.");
        IF RefundChangeLogDetails.FINDLAST THEN
            LineNo := RefundChangeLogDetails."Line No.";
        RefundChangeLogDetails.INIT;
        RefundChangeLogDetails."No." := Rec."No.";
        RefundChangeLogDetails."Line No." := LineNo + 1;
        RefundChangeLogDetails."Customer No." := Rec."Customer No.";
        RefundChangeLogDetails."Introducer Code" := Rec."Introducer Code";
        RefundChangeLogDetails."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
        RefundChangeLogDetails.Status := Rec.Status;
        RefundChangeLogDetails.Amount := Rec.Amount;
        RefundChangeLogDetails."Posting Date" := Rec."Posting Date";
        RefundChangeLogDetails."Document Date" := Rec."Document Date";
        RefundChangeLogDetails."Refund SMS Status" := RefundChangeLogDetails."Refund SMS Status"::Completed;
        RefundChangeLogDetails."Refund Initiate Amount" := Rec."Refund Initiate Amount";
        RefundChangeLogDetails."Refund Rejection Remark" := Rec."Refund Rejection Remark";
        RefundChangeLogDetails."Refund Rejection SMS Sent" := Rec."Refund Rejection SMS Sent";
        RefundChangeLogDetails."Min. Allotment Amount" := Rec."Min. Allotment Amount";
        RefundChangeLogDetails."Modified By" := USERID;
        RefundChangeLogDetails."Modify Date" := TODAY;
        RefundChangeLogDetails."Modify Time" := TIME;
        RefundChangeLogDetails."Old Refund SMS Status" := xRec."Refund SMS Status";
        RefundChangeLogDetails."Old Refund Initiate Amount" := xRec."Refund Initiate Amount";
        RefundChangeLogDetails."Old Refund Rejection Remark" := xRec."Refund Rejection Remark";
        RefundChangeLogDetails."Old Refund Rejection SMS Sent" := xRec."Refund Rejection SMS Sent";
        v_RefundChangeLogDetails.RESET;
        v_RefundChangeLogDetails.SETRANGE("No.", Rec."No.");
        v_RefundChangeLogDetails.SETFILTER("Submission Date", '<>%1', 0D);
        IF v_RefundChangeLogDetails.FINDFIRST THEN
            RefundChangeLogDetails."Submission Date" := v_RefundChangeLogDetails."Submission Date";

        v_RefundChangeLogDetails.RESET;
        v_RefundChangeLogDetails.SETRANGE("No.", Rec."No.");
        v_RefundChangeLogDetails.SETFILTER("Rejected Date", '<>%1', 0D);
        IF v_RefundChangeLogDetails.FINDFIRST THEN
            RefundChangeLogDetails."Rejected Date" := v_RefundChangeLogDetails."Rejected Date";
        RefundChangeLogDetails."Completed Date" := TODAY;

        RefundChangeLogDetails.INSERT;

        IF NewConfirmedOrder.GET(Rec."No.") THEN BEGIN
            NewConfirmedOrder."Refund SMS Status" := NewConfirmedOrder."Refund SMS Status"::Completed;
            NewConfirmedOrder.MODIFY;
        END;
    end;
}

