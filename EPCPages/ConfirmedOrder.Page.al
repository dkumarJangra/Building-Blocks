page 97932 "Confirmed Order"
{
    // Upgrade140118 code comment
    // code comment 250122
    // ALLESSS 02/01/24 : Added function CreateSalesInvoiceNew to create sales invoice for land item
    // ALLESSS 14/03/24 : Fields added "Purchase Invoice Unit Cost" and "Sales Invoice Unit Price" and its related code

    DeleteAllowed = false;
    PageType = Document;
    SourceTable = "Confirmed Order";
    SourceTableView = WHERE("Application Transfered" = FILTER(false));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group("Confirmed application")
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("IBA Name"; Vend.Name)
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Editable = EditableCustNo;
                }
                field("Member Name"; Customer.Name)
                {
                    Editable = false;
                }
                field("Customer State Code"; Rec."Customer State Code")
                {
                    Editable = False;
                }
                field("District Code"; Rec."District Code")
                {
                    Editable = False;
                }
                field("Mandal Code"; Rec."Mandal Code")
                {
                    Editable = False;
                }
                field("Village Code"; Rec."Village Code")
                {
                    Caption = 'Village Name';
                    Editable = False;
                }

                field("Project Type"; Rec."Project Type")
                {
                    Caption = 'Commission Code';
                    Editable = EditableCommCode;
                }
                field("Region Code"; Rec."Region Code")
                {
                    Editable = False;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    Editable = EditableUnitCode;
                }
                field("Unit Facing"; Rec."Unit Facing")
                {
                }
                field("60 feet road"; Rec."60 feet road")
                {
                }
                field("100 feet road"; Rec."100 feet road")
                {
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                    Editable = EditableUnitPaymentPlan;
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                }
                field("Travel applicable"; Rec."Travel applicable")
                {
                    Editable = False;

                }
                field("Registration Bouns (BSP2)"; Rec."Registration Bouns (BSP2)")
                {
                    Caption = 'BSP2 applicable';
                    Editable = false;
                }
                field("Version No."; Rec."Version No.")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Total Amount';
                    Editable = EditableTotalAmt;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                }
                field("Net Amount"; Rec.Amount - Rec."Discount Amount")
                {
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                    Editable = EditableTotalRcvdAmt;
                }
                field("Due Amount"; Rec.Amount + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount")
                {
                }
                field("Development Charges"; Rec."Development Charges")
                {
                    Visible = false;
                }
                field("Total Received Dev. Charges"; Rec."Total Received Dev. Charges")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = EditablePostingDate;
                }
                field("Commission Hold on Full Pmt"; Rec."Commission Hold on Full Pmt")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Restrict Issue for Gold/Silver"; Rec."Restrict Issue for Gold/Silver")
                {
                }
                field("Restriction Remark"; Rec."Restriction Remark")
                {
                    Caption = 'Remark';
                    Editable = EditableRemark;
                }
                field("Loan File"; Rec."Loan File")   //251124 new field added
                {
                    Caption = 'Loan File';
                    Visible = false;
                }
                field("New Loan File"; Rec."New Loan File")
                {
                    Caption = 'New Loan File';
                }
                field("Gold/Silver Voucher Issued"; Rec."Gold/Silver Voucher Issued")
                {
                    Caption = 'Gold/Silver Voucher Issued';
                    Editable = False;
                }
            }
            part("Receipt Lines"; "Unit Payment Entry  Subform")
            {
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(false));
                UpdatePropagation = Both;
                Visible = false;
            }
            part(PostedUnitPayEntrySubform; "Posted Unit Pay Entry Subform")
            {
                Caption = 'Posted Receipt';
                Editable = false;
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(true));
            }
            part(History; "Unit History Subform")
            {
                Editable = false;
                SubPageLink = "Unit No." = FIELD("No.");
            }
            part(Comment; "Unit Comment Sheet")
            {
                SubPageLink = "Table Name" = FILTER('Confirmed order'),
                              "No." = FIELD("No.");
            }
            part("Print Log"; "Unit Print Log Subform")
            {
                Editable = false;
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
                field("Purchase Invoice Unit Cost"; Rec."Purchase Invoice Unit Cost")
                {

                    trigger OnValidate()
                    begin
                        ModifypurchinvAmt := TRUE;
                    end;
                }
                field("Sales Invoice Unit Price"; Rec."Sales Invoice Unit Price")
                {

                    trigger OnValidate()
                    begin
                        ModifypurchinvAmt := TRUE;
                    end;
                }
                field("Registration Status"; Rec."Registration Status")
                {

                    trigger OnValidate()
                    begin
                        IF Rec."Registration Initiated Date" = 0D THEN BEGIN
                            IF Rec."Registration Status" = Rec."Registration Status"::Initiated THEN
                                Rec."Registration Initiated Date" := TODAY;
                            v_NConfirmedOrder.RESET;
                            IF v_NConfirmedOrder.GET(Rec."No.") THEN BEGIN
                                v_NConfirmedOrder."Registration Initiated Date" := Rec."Registration Initiated Date";
                                v_NConfirmedOrder.MODIFY;
                            END;
                        END;
                    end;
                }
                field("Registration Initiated Date"; Rec."Registration Initiated Date")
                {
                    Editable = false;
                }
                field("Registration No."; Rec."Registration No.")
                {
                }

                field("Registration No. 2"; Rec."Registration No. 2")
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
                    Visible = false;
                }
                field("Father/Husband Name"; Rec."Father/Husband Name")
                {
                }
                field("Reg. Address"; Rec."Reg. Address")
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
                field("Registration Bonus Hold(BSP2)"; Rec."Registration Bonus Hold(BSP2)")
                {
                }
                field("Before Registration SMS Sent"; Rec."Before Registration SMS Sent")
                {
                }
                field("Registration SMS Sent"; Rec."Registration SMS Sent")
                {
                }
                field("RB Release by User ID"; Rec."RB Release by User ID")
                {
                }
                field("Date/Time of RB Release"; Rec."Date/Time of RB Release")
                {
                }
                field("Old Process"; Rec."Old Process")
                {
                }
                field("Comm hold for Old Process"; Rec."Comm hold for Old Process")
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
                field("User ID"; CustomerBankAccount."USER ID")
                {
                }
                field("Entry Status"; CustomerBankAccount."Entry Completed")
                {
                }
            }
            group("Other Information")
            {
                field("UserId"; Rec."User Id")
                {
                }
                field("Scheme Code"; Rec."Scheme Code")
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
                field("Pass Book No."; Rec."Pass Book No.")
                {
                }
                field("Project change Comment"; Rec."Project change Comment")
                {
                }
                field("Application Type"; Rec."Application Type")
                {
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                }
                field("Posted Doc No."; Rec."Posted Doc No.")
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

                    trigger OnValidate()
                    var
                        TotalAmt: Decimal;
                    begin
                        IF Rec."Travel Generate" THEN BEGIN
                            IF (USERID = 'NAVUSER4') OR (USERID = '100254') THEN BEGIN
                                TAApplicationwiseDetails.RESET;
                                TAApplicationwiseDetails.SETRANGE("Document No.", Rec."No.");
                                IF TAApplicationwiseDetails.FINDSET THEN
                                    REPEAT
                                        TotalAmt := TotalAmt + TAApplicationwiseDetails."TA Amount";
                                    UNTIL TAApplicationwiseDetails.NEXT = 0;

                                IF TotalAmt = 0 THEN
                                    Rec."Travel Generate" := FALSE;

                            END ELSE
                                ERROR('Contact Admin');
                        END;
                    end;
                }
                field("Application Closed"; Rec."Application Closed")
                {
                    Editable = false;
                }
                field("R194 Gift Issued"; Rec."R194 Gift Issued")
                {
                    Editable = False;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Print)
            {
                action("Commission Print")
                {
                    Image = Picture;
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin

                        ComEntry.RESET;
                        ComEntry.SETRANGE("Application No.", Rec."Application No.");
                        IF ComEntry.FINDFIRST THEN
                            REPORT.RUN(50061, TRUE, FALSE, ComEntry)
                        ELSE
                            MESSAGE('No Record Found');
                    end;
                }
            }
            group(Unit)
            {
                action("Payment Plan Details")
                {
                    Image = "1099Form";
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Payment Plan Details Master";
                    RunPageLink = "Document No." = FIELD("Application No."),
                                  "Project Code" = FIELD("Shortcut Dimension 1 Code");
                }
                action("Payment Milestones")
                {
                    Image = PaymentForecast;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Payment Terms Line Sale";
                    RunPageLink = "Document No." = FIELD("Application No."),
                                  "Transaction Type" = CONST(Sale);
                }
                action("Applicable Charges")
                {
                    Image = CheckLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Charge Type Applicable";
                    RunPageLink = "Item No." = FIELD("Unit Code"),
                                  "Project Code" = FIELD("Shortcut Dimension 1 Code"),
                                  "Document No." = FIELD("Application No.");
                }
            }
            group("Function")
            {
                action("Re-Open")
                {

                    trigger OnAction()
                    var
                        UpdateConforder: Record "New Confirmed Order";
                    begin

                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_CONFIRMREOPEN');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission');
                        Rec.TESTFIELD("Application Closed", FALSE);
                        Rec.Status := Rec.Status::Open;
                        Rec.MODIFY;

                        UpdateConforder.RESET;
                        UpdateConforder.SETRANGE("No.", Rec."No.");
                        IF UpdateConforder.FINDFIRST THEN BEGIN
                            UpdateConforder.Status := UpdateConforder.Status::Open;
                            UpdateConforder.MODIFY;
                        END;
                    end;
                }
                action(RestrictIssueGoldSilver)
                {
                    Caption = 'Restrict Issue for Gold/Silver';

                    trigger OnAction()
                    begin

                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Allow Gold/Silver Restriction", FALSE);
                        IF UserSetup.FINDFIRST THEN
                            ERROR('Contact to Admin');

                        IF Rec."Restriction Remark" = '' THEN
                            ERROR('Please enter Remark');

                        Selection := STRMENU(Text50004, 1);
                        IF Selection = 1 THEN
                            Rec."Restrict Issue for Gold/Silver" := Rec."Restrict Issue for Gold/Silver"::Gold
                        ELSE IF Selection = 2 THEN
                            Rec."Restrict Issue for Gold/Silver" := Rec."Restrict Issue for Gold/Silver"::Silver
                        ELSE IF Selection = 3 THEN
                            Rec."Restrict Issue for Gold/Silver" := Rec."Restrict Issue for Gold/Silver"::Both;
                        Rec.MODIFY;

                        NewConfirmedOrder_.RESET;
                        NewConfirmedOrder_.GET(Rec."No.");
                        NewConfirmedOrder_."Restrict Issue for Gold/Silver" := Rec."Restrict Issue for Gold/Silver";
                        NewConfirmedOrder_."Restriction Remark" := Rec."Restriction Remark";
                        NewConfirmedOrder_.MODIFY;
                    end;
                }
                action(RestrictionRemarks)
                {
                    Caption = 'Remarks';
                    Ellipsis = true;
                    Image = Entry;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Allow Gold/Silver Restriction", FALSE);
                        IF UserSetup.FINDFIRST THEN
                            ERROR('Contact to Admin');

                        EnterRemark := '';
                        Input_lFnc;
                        //MESSAGE('Enter RemaksRows   ---   ' + FORMAT(EnterRemark));
                    end;
                }
                action("Refresh the RestrictionGold")
                {
                    Caption = 'Refresh the Restriction of Gold / Silver';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Restriction Remark");

                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Allow Gold/Silver Restriction", FALSE);
                        IF UserSetup.FINDFIRST THEN
                            ERROR('Contact to Admin');

                        ArchiveConfirmedOrder.RESET;
                        ArchiveConfirmedOrder.SETRANGE("No.", Rec."No.");
                        IF ArchiveConfirmedOrder.FINDLAST THEN
                            LastVersion := ArchiveConfirmedOrder."Version No."
                        ELSE
                            LastVersion := 0;
                        ArchiveConfirmedOrder.INIT;
                        ArchiveConfirmedOrder.TRANSFERFIELDS(Rec);
                        ArchiveConfirmedOrder."Version No." := LastVersion + 1;
                        ArchiveConfirmedOrder."Amount Received" := Rec."Amount Received";
                        ArchiveConfirmedOrder.INSERT;

                        Rec."Restrict Issue for Gold/Silver" := Rec."Restrict Issue for Gold/Silver"::" ";
                        Rec."Restriction Remark" := '';

                        Rec.MODIFY;

                        NewConfirmedOrder_.RESET;
                        NewConfirmedOrder_.GET(Rec."No.");
                        NewConfirmedOrder_."Restrict Issue for Gold/Silver" := Rec."Restrict Issue for Gold/Silver"::" ";
                        NewConfirmedOrder_."Restriction Remark" := '';
                        NewConfirmedOrder_.MODIFY;
                    end;
                }
                action("Delete Old Application")
                {

                    trigger OnAction()
                    var
                        V_ConfOrders: Record "Confirmed Order";
                        V_Application: Record Application;
                    begin
                        IF V_Application.GET(Rec."No.") THEN BEGIN
                            V_Application.DELETE;
                            MESSAGE('Old Application Delete');
                        END;
                    end;
                }
                action("Application Close")
                {

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to close the application') THEN BEGIN
                            Rec.VALIDATE("Application Closed", TRUE);
                            Rec.MODIFY;
                        END;
                    end;
                }
                action("Application UnClose")
                {

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to Unclose the application') THEN BEGIN
                            Rec.VALIDATE("Application Closed", FALSE);
                            Rec.MODIFY;
                        END;
                    end;
                }
                action(Registration)
                {

                    trigger OnAction()
                    var
                        UpdateConforder: Record "New Confirmed Order";
                        ApplicationDevelopmentLine: Record "New Application DevelopmntLine";
                        TotalchargeAmt: Decimal;
                        NewConfirmedOrder: Record "New Confirmed Order";
                    begin

                        Rec.TESTFIELD("Application Closed", FALSE);
                        IF NOT (USERID IN ['100245', '100242', '100017', '1003', '100207']) THEN
                            Rec.TESTFIELD("Registration Bonus Hold(BSP2)", FALSE);

                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_UNITREGISTRATION');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of Role :A_UNITREGISTRATION');
                        IF CONFIRM(Text008, TRUE) THEN BEGIN

                            IF Rec."Posting Date" >= DMY2DATE(1, 3, 2013) THEN BEGIN
                                RcveAmt_1 := 0;
                                RecAPEtry.RESET;
                                RecAPEtry.SETRANGE("Document No.", Rec."No.");
                                RecAPEtry.SETRANGE(RecAPEtry."Cheque Status", RecAPEtry."Cheque Status"::Cleared);
                                IF RecAPEtry.FINDSET THEN
                                    REPEAT
                                        RcveAmt_1 := RcveAmt_1 + RecAPEtry.Amount;
                                    UNTIL RecAPEtry.NEXT = 0;
                                IF (Rec.Amount - RcveAmt_1) > 1 THEN
                                    ERROR('Received amount should be equal or greater than =' + FORMAT(Rec.Amount));
                                TotalchargeAmt := 0;
                                //BBG2.0
                                ApplicationDevelopmentLine.RESET;
                                ApplicationDevelopmentLine.SETRANGE("Document No.", Rec."No.");
                                ApplicationDevelopmentLine.SETFILTER("Cheque Status", '<>%1', ApplicationDevelopmentLine."Cheque Status"::Bounced);
                                IF ApplicationDevelopmentLine.FINDSET THEN
                                    REPEAT
                                        TotalchargeAmt := TotalchargeAmt + ApplicationDevelopmentLine.Amount;
                                    UNTIL ApplicationDevelopmentLine.NEXT = 0;
                                NewConfirmedOrder.GET(Rec."No.");
                                //  IF NewConfirmedOrder."Development Charges" > TotalchargeAmt THEN   code comment 250122
                                //  ERROR('Development Charge not received complete');   code comment 250122

                                //BBG2.0
                            END;
                            PostPayment.RegisterBond(Rec);
                            MESSAGE(Text009);
                            //ALLECK 050513 START

                            //  CurrPage."Registration No.".Enabled(FALSE);
                            // CurrForm."Registration Date".EDITABLE(FALSE);
                            // CurrForm."Reg. Office".EDITABLE(FALSE);
                            // CurrForm."Registration In Favour Of".EDITABLE(FALSE);
                            // CurrForm."Father/Husband Name".EDITABLE(FALSE);
                            // CurrForm."Registered/Office Name".EDITABLE(FALSE);
                            // CurrForm."Reg. Address".EDITABLE(FALSE);
                            // CurrForm."Branch Code".EDITABLE(FALSE);
                            // CurrForm."Registered City".EDITABLE(FALSE);
                            // CurrForm."Zip Code".EDITABLE(FALSE);  201119
                            //ALLECK 050513 END
                        END;
                        IF Rec.Status = Rec.Status::Registered THEN BEGIN
                            UpdateConforder.RESET;
                            UpdateConforder.SETRANGE("No.", Rec."No.");
                            IF UpdateConforder.FINDFIRST THEN BEGIN
                                UpdateConforder.Status := UpdateConforder.Status::Registered;
                                UpdateConforder."Registration No." := Rec."Registration No.";
                                UpdateConforder."Registration Date" := Rec."Registration Date";
                                UpdateConforder.MODIFY;
                            END;

                            Companywise.RESET;
                            Companywise.SETRANGE(Companywise."MSC Company", TRUE);
                            IF Companywise.FINDFIRST THEN BEGIN
                                CLEAR(RecUMaster);
                                RecUMaster.CHANGECOMPANY(Companywise."Company Code");
                                IF RecUMaster.GET(Rec."Unit Code") THEN BEGIN
                                    RespCenter.RESET;
                                    RespCenter.CHANGECOMPANY(Companywise."Company Code");
                                    IF RespCenter.GET(Rec."Shortcut Dimension 1 Code") THEN BEGIN
                                        IF RespCenter."Publish Plot Cost" THEN
                                            RecUMaster."Plot Cost" := RecUMaster."Total Value";
                                        IF RespCenter."Publish CustomerName" THEN BEGIN
                                            RecUMaster."Customer Name" := Rec."Registration In Favour Of";
                                        END;
                                        IF RespCenter."Publish Registration No." THEN BEGIN
                                            RecUMaster."Registration No." := Rec."Registration No.";
                                        END;

                                        RecUMaster."Regd Numbers" := Rec."Registration No.";
                                        RecUMaster."Regd date" := Rec."Registration Date";
                                        RecUMaster."Payment plan Code" := Rec."Unit Payment Plan";
                                        RecUMaster.Doj := Rec."Posting Date";
                                        NAPEntry.RESET;
                                        NAPEntry.SETRANGE("Document No.", Rec."No.");
                                        NAPEntry.SETFILTER(Amount, '>%1', 0);
                                        IF NAPEntry.FINDLAST THEN
                                            RecUMaster.Ldp := NAPEntry."Posting date";

                                        RecUMaster.MODIFY;
                                    END;
                                END;
                            END;
                        END;
                    end;
                }
                action("Create Sales Invoice & Post")
                {

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Application Closed", FALSE);
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'Sales_Invoice');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of Role :Sales_Invoice')
                        ELSE BEGIN
                            Companywise.RESET;
                            Companywise.SETRANGE(Companywise."MSC Company", TRUE);
                            IF Companywise.FINDFIRST THEN
                                Rec.TESTFIELD(Status, Rec.Status::Registered);
                            IF Rec."Registration Date" < 20160401D THEN
                                ERROR('Registration date should be greater than 31March2016');
                            IF CONFIRM('Do you want to Post Sales Invoice?') THEN BEGIN
                                CLEAR(SALESInvoiceData);
                                SALESInvoiceData.RUN;
                            END;
                        END;
                    end;
                }
                action("SMS for Aknowledgement of Reg.")
                {

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Application Closed", FALSE);
                        BBGSMS.SmsonAknowledgeofRegApp(Rec."No.");
                    end;
                }
                action("SMS post REGI. Collection")
                {

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Application Closed", FALSE);
                        ComInfo.GET;
                        Rec.TESTFIELD("Registration No.");
                        IF ComInfo."Send SMS" THEN BEGIN
                            IF Customer.GET(Rec."Customer No.") THEN BEGIN
                                IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                    CustMobileNo := Customer."BBG Mobile No.";
                                    CustSMSText :=
                                          'Dear : Mr/Ms' + Customer.Name + ',' + 'Congratulations ! We are pleased to inform you that your Registration Document'
                                   + ' is received from SRO, request you to kindly collect your Document from the Office. With best regards from BBG.';

                                    MESSAGE('%1', CustSMSText);
                                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                    //ALLEDK15112022 Start
                                    CLEAR(SMSLogDetails);
                                    SmsMessage := '';
                                    SmsMessage1 := '';
                                    SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                    SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'SMS post REGI. Collection', Rec."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."No.");
                                    //ALLEDK15112022 END

                                    Rec."Registration SMS Sent" := TRUE;
                                    //ALLEDK15112022 Start
                                    CLEAR(SMSLogDetails);
                                    SmsMessage := '';
                                    SmsMessage1 := '';
                                    SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                    SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'SMS Post REGI. Collection', Rec."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."No.");
                                    //ALLEDK15112022 END

                                    Rec.MODIFY;
                                END ELSE
                                    MESSAGE('%1', 'Mobile No. not Found');
                            END;
                        END;
                    end;
                }
                action("SMS to collect EC document")
                {

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Application Closed", FALSE);
                        ComInfo.GET;
                        IF ComInfo."Send SMS" THEN BEGIN
                            IF CONFIRM(Text50003, TRUE) THEN BEGIN
                                IF Customer.GET(Rec."Customer No.") THEN BEGIN
                                    IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                        CustMobileNo := Customer."BBG Mobile No.";
                                        CustSMSText := 'Dear Customer we are pleased to inform you that your EC has been received at BBG, we request you to kindly'
                                  + ' collect the same from our Transaction desk at Banjara Hills office. Its pleasure serving you .Hoping to continue business'
                                   + ' relationship further.';
                                        MESSAGE('%1', CustSMSText);
                                        PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                        //ALLEDK15112022 Start
                                        CLEAR(SMSLogDetails);
                                        SmsMessage := '';
                                        SmsMessage1 := '';
                                        SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                        SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                        SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Sms to collect EC Document', Rec."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."No.");
                                        //ALLEDK15112022 END

                                        Rec."Before Registration SMS Sent" := TRUE;
                                        Rec.MODIFY;
                                    END ELSE
                                        MESSAGE('%1', 'Mobile No. not Found');
                                END;
                            END;
                        END;
                    end;
                }
                action("Update Member Name")
                {

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Application Closed", FALSE);
                        IF USERID <> '100245' THEN
                            ERROR('You are not authorised to Rename the Member Name');
                        IF CONFIRM('Do you want to Modify the Member Name') THEN BEGIN
                            IF Rec."Customer No." <> '' THEN
                                Customer.GET(Rec."Customer No.");

                            Rec."Bill-to Customer Name" := Customer.Name;
                            Rec.MODIFY;
                        END;
                    end;
                }
                action("&UpLine")
                {

                    trigger OnAction()
                    begin

                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_UplineShow');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of role :A_UplineShow');

                        AssHierarcy.RESET;
                        AssHierarcy.SETRANGE("Application Code", Rec."No.");
                        IF AssHierarcy.FINDFIRST THEN
                            PAGE.RUNMODAL(PAGE::"Bottom Up Chain", AssHierarcy);
                    end;
                }
                action("TA Allotment / Reversal")
                {
                    RunObject = Page "TA Allotment / Reversal";
                    RunPageLink = "Application No." = FIELD("No.");

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Application Closed", FALSE);
                    end;
                }
                action("Update Clearance")
                {
                    Caption = 'Update Clearance';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Application Closed", FALSE);
                        IF (USERID = '1005') OR (USERID = '100242') OR (USERID = '100017') OR (USERID = 'BCUSER') THEN BEGIN
                            UpdateClearance;
                            MESSAGE('%1', 'Updated');
                        END;
                    end;
                }
                action("Create Sales Invoice New")
                {
                    Image = Sales;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Registered);
                        CreateSalesInvoiceNew;  //ALLESSS 04/01/24
                    end;
                }
                action("Create Purchase Invoice")
                {
                    Image = Purchase;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Registered);
                        CreatePurchaseInvoice;  //ALLESSS 04/01/24
                    end;
                }
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
                action("Change Collection Center")
                {

                    trigger OnAction()
                    begin
                        CLEAR(CollectionCenterChangInApp);
                        CollectionCenterChangInApp.FilterValue(Rec."No.");
                        CollectionCenterChangInApp.RUN;
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

    trigger OnAfterGetRecord()
    begin
        UpdateRefItemInventory;  //ALLESSS 02/02/24
        UpdateApplicationInfo;
        IF Rec.Status = Rec.Status::Registered THEN BEGIN
            EditablePIUnitCost := TRUE;
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
                                      //ALLESSS 14/03/24---Begin
            EditableCustNo := FALSE;
            EditableCommCode := FALSE;
            EditableUnitCode := FALSE;
            EditableUnitPaymentPlan := FALSE;
            EditableTotalAmt := FALSE;
            EditableTotalRcvdAmt := FALSE;
            EditablePostingDate := FALSE;
            EditableRemark := FALSE;
            EditablePIUnitCost := TRUE;
            EditableSIUnitPrice := TRUE;
            //ALLESSS 14/03/24---End
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
                                     //ALLESSS 14/03/24---Begin
            EditableCustNo := TRUE;
            EditableCommCode := TRUE;
            EditableUnitCode := TRUE;
            EditableUnitPaymentPlan := TRUE;
            EditableTotalAmt := TRUE;
            EditableTotalRcvdAmt := TRUE;
            EditablePostingDate := TRUE;
            EditableRemark := TRUE;
            EditablePIUnitCost := TRUE;
            EditableSIUnitPrice := TRUE;
            //ALLESSS 14/03/24---End
        END;

        IF Rec."Unit Code" <> '' THEN BEGIN
            UMaster_11.RESET;
            UMaster_11.SETRANGE("No.", Rec."Unit Code");
            IF UMaster_11.FINDFIRST THEN
                Rec."Unit Facing" := UMaster_11.Facing;
        END;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF NOT ModifypurchinvAmt THEN
            IF Rec.Status = Rec.Status::Registered THEN
                ERROR(Text50005);
    end;

    trigger OnOpenPage()
    begin
        //ALLESSS 14/03/24---BEGIN
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Allow PI SI Unit Price on CO" THEN
                VisibleUnitPrice := TRUE
            ELSE
                VisibleUnitPrice := FALSE;
        END;

        ModifypurchinvAmt := FALSE;  //220724

        IF Rec.Status = Rec.Status::Registered THEN
            EditablePIUnitCost := TRUE;
        //ALLESSS 14/03/24---END
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
        SALESInvoiceData: Report "Sales invoice DAta";
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
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        Text50004: Label 'Gold,Silver,Both';
        EnterRemark: Text[30];
        NewConfirmedOrder_: Record "New Confirmed Order";
        POUnitCost: Decimal;
        SIUnitPrice: Decimal;
        Window: Dialog;
        PurchaseGRNExists: Boolean;
        EditablePIUnitCost: Boolean;
        EditableSIUnitPrice: Boolean;
        EditableCommCode: Boolean;
        EditableUnitCode: Boolean;
        EditableUnitPaymentPlan: Boolean;
        EditableTotalAmt: Boolean;
        EditableTotalRcvdAmt: Boolean;
        EditablePostingDate: Boolean;
        EditableRemark: Boolean;
        EditableCustNo: Boolean;
        VisibleUnitPrice: Boolean;
        CollectionCenterChangInApp: Report "Collection Center Chang In App";
        ReservationEntry: Record "Reservation Entry";
        LastReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        WebAppService: Codeunit "Web App Service";
        TAApplicationwiseDetails: Record "TA Application wise Details";
        PIUnitCost: Decimal;
        Text50005: Label 'Order is already Registered.\Not allowed to modify or delete';
        ModifypurchinvAmt: Boolean;
        LandSalesDocumentTemp: Record "Land Sales Document Temp";
        OldLandSalesDocumentTemp: Record "Land Sales Document Temp";
        v_NConfirmedOrder: Record "New Confirmed Order";

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

    local procedure "-------------"()
    begin
    end;

    local procedure Input_lFnc()
    var
        ItemDetails: Text;
        RemarkInputPage: Page "Remark Input Page";
    begin
        Clear(RemarkInputPage);
        RemarkInputPage.GetValues(Rec."No.");
        RemarkInputPage.Run();

    end;

    local procedure CreateSalesInvoiceNew()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Job: Record Job;
        UnitPrice: Decimal;
        Text50008: Label 'Sales Invoice %1  already exists for Customer %2  , Confirmed Order %3. ';
    begin
        //ALLESSS 02/01/24
        Rec.TESTFIELD("Shortcut Dimension 1 Code");
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Application Sales No. Series");

        SalesHeader.RESET;
        SalesHeader.SETRANGE("Sell-to Customer No.", Rec."Customer No.");
        SalesHeader.SETRANGE("External Document No.", Rec."No.");
        IF SalesHeader.FINDFIRST THEN
            ERROR(Text50008, SalesHeader."No.", Rec."Customer No.", Rec."No.");

        SalesHeader.RESET;
        SalesHeader.INIT;
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := NoSeriesMgt.GetNextNo(UnitSetup."Application Sales No. Series", WORKDATE, TRUE);
        SalesHeader.INSERT(TRUE);
        SalesHeader.VALIDATE("Sell-to Customer No.", Rec."Customer No.");
        SalesHeader.VALIDATE("Posting Date", WORKDATE);
        SalesHeader.VALIDATE("External Document No.", Rec."No.");
        SalesHeader.VALIDATE("Location Code", Rec."Shortcut Dimension 1 Code");
        SalesHeader.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        SalesHeader."Assigned User ID" := USERID;
        SalesHeader.MODIFY(TRUE);

        SalesLine.INIT;
        SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := 10000;
        SalesLine.INSERT(TRUE);
        SalesLine.VALIDATE("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        SalesLine.VALIDATE(Type, SalesLine.Type::Item);
        Job.GET(Rec."Shortcut Dimension 1 Code");
        Job.CALCFIELDS("Land Item");
        Job.TESTFIELD("Land Item");
        SalesLine.VALIDATE("No.", Job."Land Item");
        SalesLine.VALIDATE(Quantity, Rec."Saleable Area");
        SalesLine.VALIDATE("Unit Price", Rec.Amount / Rec."Saleable Area");
        SalesLine.MODIFY(TRUE);

        //100524 New code added for Item Tracking Start
        LastReservationEntry.RESET;
        IF LastReservationEntry.FINDLAST THEN
            EntryNo := LastReservationEntry."Entry No.";

        ReservationEntry.INIT;
        ReservationEntry."Entry No." := EntryNo + 1;
        ReservationEntry."Item No." := SalesLine."No.";
        ReservationEntry."Location Code" := SalesLine."Location Code";
        ReservationEntry."Quantity (Base)" := -1 * SalesLine.Quantity;
        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
        ReservationEntry."Creation Date" := SalesHeader."Posting Date";
        ReservationEntry."Source Type" := 37;
        ReservationEntry."Source Subtype" := 2;
        ReservationEntry."Source ID" := SalesLine."Document No.";
        ReservationEntry."Source Ref. No." := SalesLine."Line No.";
        //ReservationEntry."Expected Receipt Date" :=
        ReservationEntry."Shipment Date" := TODAY;
        ReservationEntry."Created By" := USERID;
        ReservationEntry.Positive := FALSE;
        ReservationEntry."Qty. per Unit of Measure" := 1;
        ReservationEntry.Quantity := -1 * SalesLine.Quantity;
        ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
        ReservationEntry."Qty. to Handle (Base)" := -1 * SalesLine.Quantity;
        ReservationEntry."Qty. to Invoice (Base)" := -1 * SalesLine.Quantity;
        ReservationEntry."Lot No." := Rec."Unit Code";
        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
        ReservationEntry.INSERT;
        //100524 New code added for Item Tracking End

        MESSAGE('Sales Invoice generated successfully');
    end;

    local procedure CreatePurchaseInvoice()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        POVendor: Record Vendor;
        POUnitMaster: Record "Unit Master";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SICustomer: Record Customer;
        POCompInfo: Record "Company Information";
        Item: Record Item;
        Text50005: Label 'Unit Cost must have value in Ref. LLP Company %1 , Current Value is %2.';
        UnitCost: Decimal;
        RefLLPItemDetails: Record "Ref. LLP Item Details";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        Text50006: Label 'Purchase GRN is not yet done in Ref. LLP Company %1.';
        POVendorCode: Code[20];
        Text50007: Label 'Purchase Invoice %1  already exists for Vendor %2  , Confirmed Order %3. ';
    begin
        //ALLESSS 02/01/24
        CLEAR(NoSeriesMgt);
        CLEAR(PurchaseGRNExists);
        Rec.TESTFIELD("Shortcut Dimension 1 Code");
        Rec.TESTFIELD("Purchase Invoice Unit Cost");
        Rec.TESTFIELD("Sales Invoice Unit Price");

        POUnitMaster.RESET;
        POUnitMaster.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
        POUnitMaster.SETRANGE("No.", Rec."Unit Code");
        IF POUnitMaster.FINDFIRST THEN BEGIN
            Job.GET(Rec."Shortcut Dimension 1 Code");
            IF POUnitMaster."IC Partner Code" <> '' THEN BEGIN
                POVendor.RESET;
                POVendor.SETRANGE("BBG IC Partner Code", POUnitMaster."IC Partner Code");
                IF POVendor.FINDFIRST THEN
                    POVendorCode := POVendor."No."
                ELSE
                    ERROR('IC Parter Code %1  does not map for Vendor', POUnitMaster."IC Partner Code");
            END
            ELSE
                ERROR('IC Partner Code does not exist for Unit Code', POUnitMaster."No.");

            PurchaseHeader.RESET;
            PurchaseHeader.SETRANGE("Buy-from Vendor No.", POVendorCode);
            PurchaseHeader.SETRANGE("Vendor Invoice No.", Rec."No.");
            IF PurchaseHeader.FINDFIRST THEN
                ERROR(Text50007, PurchaseHeader."No.", POVendorCode, Rec."No.");

            /*ItemLedgerEntry.RESET;
            ItemLedgerEntry.SETCURRENTKEY("Entry No.");
            ItemLedgerEntry.CHANGECOMPANY(POUnitMaster."Ref. LLP Name");
            ItemLedgerEntry.SETRANGE("Item No.",POUnitMaster."Ref. LLP Item No.");
            ItemLedgerEntry.SETRANGE("Lot No.",POUnitMaster."No.");
            IF ItemLedgerEntry.FINDLAST THEN
              BEGIN
                ValueEntry.RESET;
                ValueEntry.CHANGECOMPANY(POUnitMaster."Ref. LLP Name");
                ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgerEntry."Entry No.");
                ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Purchase Invoice");
                IF ValueEntry.FINDFIRST THEN BEGIN
                  PurchaseGRNExists := TRUE;
                  //UnitCost := ValueEntry."Cost per Unit";
                  END;
              END
              ELSE BEGIN
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETCURRENTKEY("Entry No.");
                ItemLedgerEntry.CHANGECOMPANY(POUnitMaster."Ref. LLP Name");
                ItemLedgerEntry.SETRANGE("Item No.",POUnitMaster."Ref. LLP Item No.");
                ItemLedgerEntry.SETRANGE("Document Type",ItemLedgerEntry."Document Type"::"Purchase Receipt");
                IF ItemLedgerEntry.FINDLAST THEN
                  BEGIN
                    ValueEntry.RESET;
                    ValueEntry.CHANGECOMPANY(POUnitMaster."Ref. LLP Name");
                    ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgerEntry."Entry No.");
                    ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Purchase Receipt");
                    IF ValueEntry.FINDFIRST THEN BEGIN
                      PurchaseGRNExists := TRUE;
                      //UnitCost := ValueEntry."Cost per Unit";
                    END;
                  END
                  ELSE
                    ERROR(Text50005,POUnitMaster."Ref. LLP Name",UnitCost);
              END;
        
              //IF UnitCost = 0 THEN
                //ERROR(Text50005,POUnitMaster."Ref. LLP Name",UnitCost);
        
            IF NOT PurchaseGRNExists THEN
              ERROR(Text50006,POUnitMaster."Ref. LLP Name");*/

            UnitSetup.GET;
            UnitSetup.TESTFIELD("Intercompany Purch. NoSeries");
            PurchaseHeader.RESET;
            PurchaseHeader.INIT;
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
            PurchaseHeader."No." := NoSeriesMgt.GetNextNo(UnitSetup."Intercompany Purch. NoSeries", WORKDATE, TRUE);
            PurchaseHeader.INSERT(TRUE);

            PurchaseHeader.VALIDATE("Buy-from Vendor No.", POVendorCode);
            PurchaseHeader.VALIDATE("Posting Date", WORKDATE);
            PurchaseHeader.VALIDATE("Vendor Invoice No.", Rec."No.");
            PurchaseHeader.VALIDATE("Location Code", Rec."Shortcut Dimension 1 Code");
            PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            PurchaseHeader."Assigned User ID" := USERID;
            PurchaseHeader.MODIFY(TRUE);

            //Insert Purchase Line
            PurchaseLine.INIT;
            PurchaseLine."Document Type" := PurchaseLine."Document Type"::Invoice;
            PurchaseLine."Document No." := PurchaseHeader."No.";
            PurchaseLine."Line No." := 10000;
            PurchaseLine.INSERT(TRUE);
            PurchaseLine.VALIDATE("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
            PurchaseLine.VALIDATE(Type, PurchaseLine.Type::Item);

            Job.CALCFIELDS("Land Item");
            Job.TESTFIELD("Land Item");
            PurchaseLine.VALIDATE("No.", Job."Land Item");
            PurchaseLine.VALIDATE(Quantity, Rec."Saleable Area");
            PurchaseLine.VALIDATE("Direct Unit Cost", Rec."Purchase Invoice Unit Cost");
            PurchaseLine.MODIFY(TRUE);

            //100524 New code added for Item Tracking Start
            LastReservationEntry.RESET;
            IF LastReservationEntry.FINDLAST THEN
                EntryNo := LastReservationEntry."Entry No.";

            ReservationEntry.INIT;
            ReservationEntry."Entry No." := EntryNo + 1;
            ReservationEntry."Item No." := PurchaseLine."No.";
            ReservationEntry."Location Code" := PurchaseLine."Location Code";
            ReservationEntry."Quantity (Base)" := -1 * PurchaseLine.Quantity;
            ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
            ReservationEntry."Creation Date" := PurchaseHeader."Posting Date";
            ReservationEntry."Source Type" := 39;
            ReservationEntry."Source Subtype" := 2;
            ReservationEntry."Source ID" := PurchaseLine."Document No.";
            ReservationEntry."Source Ref. No." := PurchaseLine."Line No.";
            ReservationEntry."Expected Receipt Date" := TODAY;
            ReservationEntry."Created By" := USERID;
            ReservationEntry.Positive := FALSE;
            ReservationEntry."Qty. per Unit of Measure" := 1;
            ReservationEntry.Quantity := PurchaseLine.Quantity;
            ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
            ReservationEntry."Qty. to Handle (Base)" := PurchaseLine.Quantity;
            ReservationEntry."Qty. to Invoice (Base)" := PurchaseLine.Quantity;
            ReservationEntry."Lot No." := Rec."Unit Code";
            ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
            ReservationEntry.INSERT;
            //100524 New code added for Item Tracking END

            MESSAGE('Purchase Invoice generated successfully');

            //Create Sales Invoice for other company
            POCompInfo.GET;
            //POCompInfo.TESTFIELD("IC Partner Code");

            RefLLPItemDetails.RESET;
            RefLLPItemDetails.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
            RefLLPItemDetails.SETRANGE("Ref. LLP Name", POUnitMaster."Ref. LLP Name");
            RefLLPItemDetails.SETRANGE("Ref. LLP Item No.", POUnitMaster."Ref. LLP Item No.");
            IF RefLLPItemDetails.FINDFIRST THEN
                RefLLPItemDetails.TESTFIELD("Ref. LLP Item Project Code");

            LandSalesDocumentTemp.RESET;
            IF NOT LandSalesDocumentTemp.GET(Rec."No.") THEN BEGIN
                LandSalesDocumentTemp.INIT;
                LandSalesDocumentTemp."Application No." := Rec."No.";
                LandSalesDocumentTemp."Creation Date" := TODAY;
                LandSalesDocumentTemp."Posting Date" := WORKDATE;
                LandSalesDocumentTemp."Sales Invoice Unit Price" := Rec."Sales Invoice Unit Price";
                LandSalesDocumentTemp."Ref. LLP Name" := POUnitMaster."Ref. LLP Name";
                LandSalesDocumentTemp."IC Partner Code" := POCompInfo."BBG IC Partner Code";
                LandSalesDocumentTemp."Project Code" := RefLLPItemDetails."Ref. LLP Item Project Code";
                LandSalesDocumentTemp."Ref. LLP Item No." := POUnitMaster."Ref. LLP Item No.";
                LandSalesDocumentTemp."Ref. LLP Item Project Code" := RefLLPItemDetails."Ref. LLP Item Project Code";
                LandSalesDocumentTemp.Quantity := Rec."Saleable Area";
                LandSalesDocumentTemp.INSERT;
            END;

            /*
                //Create Sales Invoice for other company
                CLEAR(NoSeriesMgt);
                POCompInfo.GET;
                POCompInfo.TESTFIELD("IC Partner Code");
                UnitSetup.RESET;
                UnitSetup.CHANGECOMPANY(POUnitMaster."Ref. LLP Name");
                UnitSetup.GET;
                UnitSetup.TESTFIELD("Application Sales No. Series");

                SalesHeader.RESET;
                SalesHeader.CHANGECOMPANY(POUnitMaster."Ref. LLP Name");
                SalesHeader.INIT;
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                SalesHeader."No." := NoSeriesMgt.GetNextNo(UnitSetup."Application Sales No. Series",WORKDATE,TRUE);
                SalesHeader.INSERT(TRUE);

                SICustomer.RESET;
                SICustomer.CHANGECOMPANY(POUnitMaster."Ref. LLP Name");
                SICustomer.SETRANGE("IC Partner Code",POCompInfo."IC Partner Code");
                IF SICustomer.FINDFIRST THEN
                  SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.",SICustomer."No.")
                  //SalesHeader."Sell-to Customer No." := SICustomer."No."
                ELSE
                  ERROR('Customer does not map for IC Partner Code',POUnitMaster."IC Partner Code");

                SalesHeader.VALIDATE("Posting Date",WORKDATE);
                SalesHeader.VALIDATE("External Document No.",Rec."No.");

                RefLLPItemDetails.RESET;
                RefLLPItemDetails.SETRANGE("Project Code","Shortcut Dimension 1 Code");
                RefLLPItemDetails.SETRANGE("Ref. LLP Name",POUnitMaster."Ref. LLP Name");
                RefLLPItemDetails.SETRANGE("Ref. LLP Item No.",POUnitMaster."Ref. LLP Item No.");
                IF RefLLPItemDetails.FINDFIRST THEN
                  RefLLPItemDetails.TESTFIELD("Ref. LLP Item Project Code");

                SalesHeader.VALIDATE("Location Code",RefLLPItemDetails."Ref. LLP Item Project Code") ;
                SalesHeader.VALIDATE("Shortcut Dimension 1 Code",RefLLPItemDetails."Ref. LLP Item Project Code");
                SalesHeader."Project Code" := RefLLPItemDetails."Ref. LLP Item Project Code";
                SalesHeader."Responsibility Center" := RefLLPItemDetails."Ref. LLP Item Project Code";
                SalesHeader."Assigned User ID" := USERID;
                SalesHeader.MODIFY(TRUE);
                //COMMIT;

                //Create Sales Line
                SalesLine.RESET;
                SalesLine.CHANGECOMPANY(POUnitMaster."Ref. LLP Name");
                SalesLine.INIT;
                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := 10000;
                SalesLine."Sell-to Customer No.":= SalesHeader."Sell-to Customer No.";
                SalesLine."Location Code" := SalesHeader."Location Code";
                SalesLine.Type := SalesLine.Type::Item;
                SalesLine."No." := POUnitMaster."Ref. LLP Item No.";
                SalesLine.Quantity := Rec."Saleable Area";

                {Item.RESET;
                Item.CHANGECOMPANY(POUnitMaster."Ref. LLP Name");
                Item.SETRANGE("No.",POUnitMaster."Ref. LLP Item No.");
                IF Item.FINDFIRST THEN
                  SalesLine."Unit Price" := Item."Unit Cost";}

                SalesLine."Unit Price" := "Sales Invoice Unit Price";
               // SalesLine."Unit Price" := Rec.Amount/Rec."Saleable Area";  // Code added 300524
                SalesLine.INSERT;
                */
        END;

    end;

    local procedure UpdateRefItemInventory()
    var
        RefLLPItemDetails: Record "Ref. LLP Item Details";
        Item: Record Item;
        RefLLPItemDetails1: Record "Ref. LLP Item Details";
        CompanyInformation: Record "Company Information";
    begin
        RefLLPItemDetails.RESET;
        RefLLPItemDetails.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
        IF RefLLPItemDetails.FINDSET THEN
            REPEAT
                Item.RESET;
                Item.CHANGECOMPANY(RefLLPItemDetails."Ref. LLP Name");
                Item.SETRANGE("No.", RefLLPItemDetails."Ref. LLP Item No.");
                IF Item.FINDFIRST THEN BEGIN
                    RefLLPItemDetails1 := RefLLPItemDetails;
                    Item.CALCFIELDS(Inventory);
                    RefLLPItemDetails1."Available Inventory" := Item.Inventory;
                    RefLLPItemDetails1."Ref. LLP Item Project Code" := Item."Global Dimension 1 Code";

                    CompanyInformation.CHANGECOMPANY(RefLLPItemDetails."Ref. LLP Name");
                    CompanyInformation.GET();
                    //RefLLPItemDetails1."IC Partner Code" := CompanyInformation."IC Partner Code";
                    RefLLPItemDetails1.MODIFY;
                END;
            UNTIL RefLLPItemDetails.NEXT = 0;
        COMMIT;
    end;
}

