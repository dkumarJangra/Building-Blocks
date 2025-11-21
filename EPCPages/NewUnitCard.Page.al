page 50081 "New Unit Card"
{
    // Upgrade140118 code comment
    // 270923 Approval Workflow
    //  230524 code comment

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
                field("Customer State Code"; Rec."Customer State Code")
                {
                    Editable = False;
                }
                field("Aadhar No."; Rec."Aadhar No.")
                {
                    Editable = false;
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
                field("UserId"; Rec."User Id")
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
                field("60 feet road"; Rec."60 feet road")
                {
                }
                field("100 feet road"; Rec."100 feet road")
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
                field("Version No."; Rec."Version No.")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                    Editable = false;
                }
                field("Company Name"; Rec."Company Name")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Total Amount';
                    Editable = false;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    Editable = false;
                }
                field("Net Amount"; Rec.Amount - Rec."Discount Amount")
                {
                    Editable = false;
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                    Editable = false;
                }
                field("Due Amount"; Rec.Amount + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount")
                {
                    Editable = false;
                }
                field("Received Amount in LLP"; Rec."Received Amount in LLP")
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
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Allow Auto Plot Vacate"; Rec."Allow Auto Plot Vacate")
                {
                }
                field("Project change Comment"; Rec."Project change Comment")
                {
                    Editable = false;
                }
                field("Verita Amount Received"; Rec."Verita Amount Received")
                {
                    Caption = 'For Silver Gift';
                }
                field("Refund Initiate Amount"; Rec."Refund Initiate Amount")
                {

                    trigger OnValidate()
                    begin
                        InsertRefundChangeLog(FALSE, FALSE);
                    end;
                }
                field("Refund SMS Status"; Rec."Refund SMS Status")
                {
                }
                field("Refund Rejection SMS Sent"; Rec."Refund Rejection SMS Sent")
                {
                }
                field("Refund Rejection Remark"; Rec."Refund Rejection Remark")
                {
                    Editable = RefundRejectionSMSSend;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Refund Rejection SMS Sent", FALSE);
                        InsertRefundChangeLog(FALSE, FALSE);
                    end;
                }
                field("Restrict Issue for Gold/Silver"; Rec."Restrict Issue for Gold/Silver")
                {
                }
                field("Restriction Remark"; Rec."Restriction Remark")
                {
                }
            }
            part("Receipt Lines"; "NewUnit Payment Entry  Subform")
            {
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(false));
                UpdatePropagation = Both;
            }
            part("Document Approval Details"; "Document Approval Details")
            {
                Provider = "Receipt Lines";
                SubPageLink = "Document No." = FIELD("Document No."),
                              "Document Line No." = FIELD("Line No.");
            }
            part(PostedUnitPayEntrySubform; "New Posted Unit Pay Entryfom")
            {
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(true));
            }
            part("Document Approval Details1"; "Document Approval Details")
            {
                Provider = PostedUnitPayEntrySubform;
                SubPageLink = "Document No." = FIELD("Document No."),
                              "Document Line No." = FIELD("Line No.");
            }
            part(History; "Unit History Subform")
            {
                SubPageLink = "Unit No." = FIELD("No.");
            }
            part(Comment; "Unit Comment Sheet")
            {
                SubPageLink = "Table Name" = FILTER('New Confirmed order'),
                              "No." = FIELD("No.");
            }
            part("Print Log"; "Unit Print Log Subform")
            {
                SubPageLink = "Unit No." = FIELD("No.");
            }
            group(Info)
            {
                Editable = false;
                field("Application Type"; Rec."Application Type")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
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
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Dummay Unit Code"; Rec."Dummay Unit Code")
                {
                    Caption = 'Priority Unit Code';
                }
                field("Pass Book No."; Rec."Pass Book No.")
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
                field("Maturity Date"; Rec."Maturity Date")
                {
                }
                field("Posted Doc No."; Rec."Posted Doc No.")
                {
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                }
                field("Commission Paid"; Rec."Commission Paid")
                {
                }
                field("Application Closed"; Rec."Application Closed")
                {
                }
                field(Barcode; Rec.Barcode)
                {
                    ApplicationArea = All;
                }
            }
            group(SMS)
            {
                field("Thumb Impression Form"; Rec."Thumb Impression Form")
                {
                }
                field("Thumb Imp Send UserID"; Rec."Thumb Imp Send UserID")
                {
                }
                field("Thumb Imp Send DateTime"; Rec."Thumb Imp Send DateTime")
                {
                }
                field("Registration to SRO"; Rec."Registration to SRO")
                {
                }
                field("Reg. To SRO Send UserID"; Rec."Reg. To SRO Send UserID")
                {
                }
                field("Reg. To SRO Send DateTime"; Rec."Reg. To SRO Send DateTime")
                {
                }
                field("Doc Issue from TR DESK"; Rec."Doc Issue from TR DESK")
                {
                }
                field("Doc. Issue TRDesk UserID"; Rec."Doc. Issue TRDesk UserID")
                {
                }
                field("Doc. Issue TRDesk Datetime"; Rec."Doc. Issue TRDesk Datetime")
                {
                }
                field("Sweet Box Issue from TR DESK"; Rec."Sweet Box Issue from TR DESK")
                {
                }
                field("SweetBox Issue Send UserID"; Rec."SweetBox Issue Send UserID")
                {
                }
                field("SweetBox Issue Send Datetime"; Rec."SweetBox Issue Send Datetime")
                {
                }
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
                field("Registration Status"; Rec."Registration Status")
                {
                }
                field("Registration Initiated Date"; Rec."Registration Initiated Date")
                {
                }
                field("Registration No."; Rec."Registration No.")
                {
                    Editable = false;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    Editable = false;
                }
                field("Actual Registration Date"; Rec."Actual Registration Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Reg. Office"; Rec."Reg. Office")
                {
                    Editable = false;
                }
                field("Registration In Favour Of"; Rec."Registration In Favour Of")
                {
                    Editable = false;
                }
                field("Registered/Office Name"; Rec."Registered/Office Name")
                {
                    Editable = false;
                }
                field("Reg. Address"; Rec."Reg. Address")
                {
                    Editable = false;
                }
                field("Father/Husband Name"; Rec."Father/Husband Name")
                {
                    Editable = false;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    Editable = false;
                }
                field("Registered City"; Rec."Registered City")
                {
                    Editable = false;
                }
                field("Zip Code"; Rec."Zip Code")
                {
                    Editable = false;
                }
                field("Registration Bonus Hold(BSP2)"; Rec."Registration Bonus Hold(BSP2)")
                {
                }
                field("Commission Hold on Full Pmt"; Rec."Commission Hold on Full Pmt")
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
        }
    }

    actions
    {
        area(navigation)
        {
            action("&Attach Documents")
            {
                Caption = '&Attach Documents';
                //                Promoted = true;
                RunObject = Page "Application Aadhaar Attachment";
                RunPageLink = "Table No." = CONST(50016),
                              "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            group(Print)
            {
                action("Unposted Receipt")
                {
                    Image = print;

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
                    Image = print;

                    trigger OnAction()
                    var
                        BarcodeText: Text;
                        Instream: InStream;
                        OutStream: OutStream;
                    begin
                        // BarcodeText := Rec.BarcodeConverter('*' + Rec."No." + '*');
                        // if BarcodeText <> '' Then begin
                        //     IF not Rec.Barcode.HasValue Then begin
                        //         Clear(OutStream);
                        //         OutStream.WriteText(BarcodeText);
                        //         Rec.Barcode.CreateOutStream(OutStream);
                        //         Rec.Modify();
                        //     end;
                        // end;
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
                action(CheckAmount)
                {

                    trigger OnAction()
                    var
                        v_ConfirmedOrder: Record "Confirmed Order";
                    begin
                        v_ConfirmedOrder.RESET;
                        v_ConfirmedOrder.CHANGECOMPANY(Rec."Company Name");
                        IF v_ConfirmedOrder.GET(Rec."No.") THEN BEGIN
                            Rec.Amount := v_ConfirmedOrder.Amount;
                            Rec.MODIFY;
                            MESSAGE('Amount Update');
                        END;
                    end;
                }
                action(Release)
                {
                    Image = Process;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                action(ReOpen)
                {
                    Image = Process;

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
                action(Post)
                {
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        AppPayEntry: Record "NewApplication Payment Entry";
                        NewAppEntry: Record "NewApplication Payment Entry";
                        OldConforder: Record "Confirmed Order";
                        AppPayEntry_1: Record "Application Payment Entry";
                        Updationofplotdetails: Codeunit "Updation of plot details";  //251124 Code 
                        webservice: Codeunit 50003;
                    begin

                        Rec.TESTFIELD("Registration Status", Rec."Registration Status"::" ");  //ALLEDK 090921
                        Rec.TESTFIELD("Application Closed", FALSE);  //190820

                        AppPayEntry_1.RESET;
                        AppPayEntry_1.CHANGECOMPANY(Rec."Company Name");
                        AppPayEntry_1.SETRANGE("Document No.", Rec."No.");
                        AppPayEntry_1.SETRANGE(Posted, TRUE);
                        AppPayEntry_1.SETRANGE("Discount Payment Type", AppPayEntry_1."Discount Payment Type"::Forfeit);
                        IF AppPayEntry_1.FINDFIRST THEN
                            ERROR('You have already done Forefit entry');

                        MemberOf.RESET;
                        MemberOf.SETRANGE("User Name", USERID);
                        MemberOf.SETRANGE("Role ID", 'A_Refund');
                        IF NOT MemberOf.FINDFIRST THEN BEGIN
                            AppPayEntry.RESET;
                            AppPayEntry.SETRANGE("Document No.", Rec."No.");
                            AppPayEntry.SETFILTER("Payment Mode", '%1|%2', AppPayEntry."Payment Mode"::"Refund Cash",
                            AppPayEntry."Payment Mode"::"Refund Bank");
                            AppPayEntry.SETFILTER("Cheque Status", '<>%1', AppPayEntry."Cheque Status"::Bounced);
                            AppPayEntry.SETRANGE(Posted, TRUE);
                            IF AppPayEntry.FINDFIRST THEN
                                ERROR('This application' + ' ' + AppPayEntry."Application No." +
                                'has Refund Entry. So you can not post receipt or other transaction');
                        END;

                        BondSetup.GET;
                        BondSetup.TESTFIELD(BondSetup."Bar Code no. Series");


                        IF Rec.Status = Rec.Status::Forfeit THEN
                            ERROR('Status can not be Forefit');

                        CLEAR(PaymentAmt);
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", Rec."No.");
                        AppPayEntry.SETRANGE(Posted, FALSE);
                        IF AppPayEntry.FINDSET THEN
                            REPEAT
                                // IF AppPayEntry."Payment Method" <> 'ONLINEPMT' THEN   // 230524 code comment
                                // IF (AppPayEntry."Cheque Bank and Branch" <> 'ONLINE') THEN  // 230524 code comment
                                Rec.CheckApprovalReceiptStatus(AppPayEntry);
                                AppPayEntry.TESTFIELD(Amount);
                                PaymentAmt += AppPayEntry.Amount;
                                IF AppPayEntry.COUNT > 1 THEN
                                    ERROR('Single receipt entry allowed');
                                IF AppPayEntry."Payment Mode" <> AppPayEntry."Payment Mode"::Cash THEN BEGIN
                                    AppPayEntry.TESTFIELD("Cheque No./ Transaction No.");
                                    AppPayEntry.TESTFIELD("Deposit/Paid Bank");
                                END;
                                IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Cash THEN
                                    IF AppPayEntry.Amount > BondSetup."Cash Amount Limit" THEN
                                        ERROR('You can not post receipt more than' + FORMAT(BondSetup."Cash Amount Limit"));
                            UNTIL AppPayEntry.NEXT = 0;

                        AmountToWords.InitTextVariable;
                        AmountToWords.FormatNoText(AmountText1, PaymentAmt, '');
                        //ALLECK 130313 START
                        CLEAR(AppPayEntry);
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", Rec."No.");
                        AppPayEntry.SETFILTER(Amount, '<>%1', 0);
                        AppPayEntry.SETRANGE(Posted, FALSE);
                        IF AppPayEntry.FINDLAST THEN
                            IF AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::" " THEN
                                ERROR('Please define the Payment Mode.');
                        //ALLECK 130313 END

                        NewAppEntry.RESET;
                        NewAppEntry.SETRANGE("Document No.", Rec."Application No.");
                        NewAppEntry.SETRANGE(Posted, FALSE);
                        IF NewAppEntry.FINDFIRST THEN
                            REPEAT
                                IF NewAppEntry."Payment Mode" = NewAppEntry."Payment Mode"::Bank THEN
                                    NewAppEntry.TESTFIELD("Bank Type", NewAppEntry."Bank Type"::ProjectCompany);
                            UNTIL NewAppEntry.NEXT = 0;

                        Amt1 := 0;
                        AppPaymentEntryNew.RESET;
                        AppPaymentEntryNew.SETRANGE("Document No.", Rec."No.");
                        AppPaymentEntryNew.SETFILTER("Cheque Status", '<>%1', AppPaymentEntryNew."Cheque Status"::Bounced);
                        IF AppPaymentEntryNew.FINDSET THEN
                            REPEAT
                                Amt1 := Amt1 + AppPaymentEntryNew.Amount;
                            UNTIL AppPaymentEntryNew.NEXT = 0;

                        IF Amt1 > Rec.Amount THEN
                            IF CONFIRM(STRSUBSTNO(Text50004, (Amt1 - Rec.Amount))) THEN BEGIN
                            END ELSE
                                EXIT;




                        IF CONFIRM(STRSUBSTNO(Text50002, Rec.FIELDCAPTION("Application No."), Rec."Application No.",
                           GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."Shortcut Dimension 1 Code", Rec."Unit Code", Customer.Name,
                           Rec."Customer No.", Rec."Introducer Code", Vend.Name,
                           PaymentAmt, AmountText1[1], AppPayEntry."Posting date")) THEN BEGIN
                            IF CONFIRM(Text006) THEN BEGIN //ALLECK020313
                                                           //ALLECK 020313 END
                                IF Rec."Application Type" = Rec."Application Type"::Trading THEN BEGIN
                                    OldConforder.RESET;
                                    OldConforder.SETRANGE("No.", Rec."No.");
                                    IF OldConforder.FINDFIRST THEN
                                        CreateReceiptEntry(OldConforder);
                                END ELSE BEGIN
                                    NewAppEntry.RESET;
                                    NewAppEntry.SETRANGE("Document No.", Rec."Application No.");
                                    NewAppEntry.SETRANGE(Posted, FALSE);
                                    IF NewAppEntry.FINDLAST THEN BEGIN
                                        PostPayment.NewPostBondPayment(Rec, 'Payment Received');
                                    END;
                                END;
                                MESSAGE(Text007);

                                ComInfo.GET;
                                IF ComInfo."Send SMS" THEN BEGIN
                                    IF Customer.GET(Rec."Customer No.") THEN BEGIN
                                        IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                            CustMobileNo := Customer."BBG Mobile No.";
                                            AppPayEntry.RESET;
                                            AppPayEntry.SETRANGE("Document No.", Rec."Application No.");
                                            AppPayEntry.SETRANGE(Posted, TRUE);
                                            IF AppPayEntry.FINDLAST THEN BEGIN
                                                IF (AppPayEntry.Amount <> 0) THEN BEGIN
                                                    IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Cash) THEN
                                                        CustSMSText :=
                                                        'Mr/Mrs/Ms:' + Customer.Name + 'Appl No:' + Rec."Application No." + ' ' +
                                                        'Recvd Rs.' + FORMAT(AppPayEntry.Amount) +
                                                        ' ' + 'Project: ' + GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' +
                                                        FORMAT(AppPayEntry."Posting date")
                                                    ELSE
                                                        CustSMSText :=
                                                        'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to BBG Family. Appl No:' + Rec."Application No." +
                                                        ' ' + 'Recvd Rs.' + FORMAT(AppPayEntry.Amount) +
                                                        ' ' + 'Project: ' + GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' +
                                                        FORMAT(AppPayEntry."Posting date") + 'Tx for payment(If Chq-Subject to Realization).BBGIND';

                                                    MESSAGE('%1', CustSMSText);
                                                    //210224 Added new code
                                                    CLEAR(CheckMobileNoforSMS);
                                                    ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                                                    IF ExitMessage THEN
                                                        PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                                    //ALLEDK15112022 Start
                                                    CLEAR(SMSLogDetails);
                                                    SmsMessage := '';
                                                    SmsMessage1 := '';
                                                    SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                                    SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Customer Receipt', Rec."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."No.");
                                                    //ALLEDK15112022 END

                                                END;
                                            END;
                                        END
                                        ELSE
                                            MESSAGE('%1', 'Mobile No. not Found');
                                    END;
                                END;
                            END;
                        END;
                        //251124 Code start
                        COMMIT;

                        CLEAR(Updationofplotdetails);
                        IF Rec."Unit Code" <> '' THEN BEGIN
                            Rec.CALCFIELDS(Rec."Total Received Amount");
                            IF (Rec.Amount - Rec."Total Received Amount") <= 0 THEN BEGIN   //280225
                                Updationofplotdetails.UpdateNoofDaysforOpenApplications(Rec."Unit Code");
                                Unitmaster.Reset;    //280225
                                IF Unitmaster.GET(Rec."Unit Code") THEN   //280225
                                    webservice.UpdateUnitStatus(Unitmaster);  //280225
                            END;
                        END;

                        //251124 Code END
                    end;
                }
                action("Allow Plot Vacate")
                {
                    Image = Process;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Allow Auto Plot Vacate Report";

                    trigger OnAction()
                    var
                        PayTermLineSale: Record "Payment Terms Line Sale";
                        PaymentPlanDetails_1: Record "Payment Plan Details";
                    begin
                        /*
                        TESTFIELD(Status,Status::Open);
                        IF NOT "Allow Auto Plot Vacate" THEN BEGIN
                          "Allow Auto Plot Vacate" := TRUE;
                        END ELSE IF "Allow Auto Plot Vacate" THEN
                          "Allow Auto Plot Vacate" := FALSE;

                        PayTermLineSale.RESET;
                        PayTermLineSale.CHANGECOMPANY("Company Name");
                        PayTermLineSale.SETRANGE("Document No.","No.");
                        PayTermLineSale.SETRANGE("Transaction Type",PayTermLineSale."Transaction Type"::Sale);
                        IF PayTermLineSale.FINDSET THEN BEGIN
                          REPEAT
                            PayTermLineSale."Allow Auto Plot Vacate" := TRUE;
                            PaymentPlanDetails_1.RESET;
                            PaymentPlanDetails_1.SETRANGE("Document No.",PayTermLineSale."Document No.");
                            PaymentPlanDetails_1.SETRANGE("Milestone Code",PayTermLineSale."Actual Milestone");
                            IF PaymentPlanDetails_1.FINDFIRST THEN BEGIN
                              PayTermLineSale."Buffer Days for AutoPlot Vacat" := PaymentPlanDetails_1."Buffer Days for AutoPlot Vacat";
                              PayTermLineSale."Auto Plot Vacate Due Date" := PaymentPlanDetails_1."Auto Plot Vacate Due Date";
                            END;
                            PayTermLineSale.MODIFY;
                          UNTIL PayTermLineSale.NEXT =0;

                        END;

                        MODIFY;
                        */

                    end;
                }
            }
            group(Unit)
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
                action("Delete Un-Posted Entry")
                {

                    trigger OnAction()
                    begin
                        V_AppEntryN.RESET;
                        V_AppEntryN.SETRANGE("Document No.", Rec."No.");
                        V_AppEntryN.SETRANGE(Posted, FALSE);
                        //V_AppEntryN.SETRANGE(Amount,0);
                        IF V_AppEntryN.FINDFIRST THEN BEGIN
                            //V_AppEntryN.TESTFIELD(Amount,0);
                            V_AppEntryN.DELETE;
                            MESSAGE('Process Done');
                        END;
                    end;
                }
            }
            group("Function")
            {
                action("Cancelle Receipt")
                {

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

                action("&Up Lines")
                {

                    trigger OnAction()
                    var
                        AssHierarcy: Record "Associate Hierarcy with App.";
                    begin

                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_UplineShow');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of role :A_UplineShow');

                        AssHierarcy.RESET;
                        AssHierarcy.CHANGECOMPANY(Rec."Company Name");
                        AssHierarcy.SETRANGE("Application Code", Rec."No.");
                        IF AssHierarcy.FINDFIRST THEN
                            PAGE.RUNMODAL(PAGE::"Bottom Up Chain", AssHierarcy);
                    end;
                }
                action("Rank Code")
                {

                    trigger OnAction()
                    begin

                        Job1.RESET;
                        Job1.CHANGECOMPANY(Rec."Company Name");
                        Job1.SETRANGE("No.", Rec."Shortcut Dimension 1 Code");
                        IF Job1.FINDFIRST THEN
                            PAGE.RUNMODAL(PAGE::"Job List", Job1);
                    end;
                }
                action("New Receipt")
                {
                    Image = print;

                    trigger OnAction()
                    begin

                        Bond := Rec;
                        Bond.SETRECFILTER;
                        CLEAR(ConfReport3);
                        AppPaymentEntry.RESET;
                        AppPaymentEntry.SETRANGE("Document No.", Rec."No.");
                        AppPaymentEntry.SETFILTER("Payment Mode", '<>%1', AppPaymentEntry."Payment Mode"::JV);
                        AppPaymentEntry.SETRANGE(Posted, TRUE);
                        IF AppPaymentEntry.FINDLAST THEN BEGIN
                            ConfReport3.SetPostFilter(Rec."No.", AppPaymentEntry."Posted Document No.");
                            ConfReport3.RUN;
                        END;
                        Bond.RESET;
                    end;
                }
                action("Generate IC Purchase Process")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //TESTFIELD(Status,Status::Registered); //BBG2.0
                        Rec.TESTFIELD("IC Sales Order Created", FALSE);
                        CreateNewSalesOrder(Rec); //BBG2.0
                    end;
                }
                action("Plot Registration")
                {

                    trigger OnAction()
                    var
                        v_NewConfirmedOrder_1: Record "New Confirmed Order";
                    begin
                        Rec.CALCFIELDS("Total Received Amount");
                        v_NewConfirmedOrder_1.RESET;
                        v_NewConfirmedOrder_1.GET(Rec."No.");
                        IF v_NewConfirmedOrder_1."Registration Status" = v_NewConfirmedOrder_1."Registration Status"::" " THEN
                            ERROR('Registration Status should have a value');

                        PlotRegistrationDetails.RESET;
                        PlotRegistrationDetails.SETRANGE("No.", Rec."No.");
                        IF PlotRegistrationDetails.FINDFIRST THEN
                            PAGE.RUN(Page::"Plot Registration Details Card", PlotRegistrationDetails, PlotRegistrationDetails."No.")
                        ELSE BEGIN
                            PlotRegistrationDetails.INIT;
                            PlotRegistrationDetails."No." := Rec."No.";
                            PlotRegistrationDetails."Customer No." := Rec."Customer No.";
                            PlotRegistrationDetails."Introducer Code" := Rec."Introducer Code";
                            PlotRegistrationDetails."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                            PlotRegistrationDetails.Amount := Rec.Amount;
                            PlotRegistrationDetails."Posting Date" := Rec."Posting Date";
                            PlotRegistrationDetails."Min. Allotment Amount" := Rec."Min. Allotment Amount";
                            PlotRegistrationDetails."Unit Code" := Rec."Unit Code";
                            PlotRegistrationDetails."Application Status" := Rec.Status;
                            PlotRegistrationDetails."Amount Received" := Rec."Total Received Amount";
                            PlotRegistrationDetails."Company Name" := Rec."Company Name";
                            PlotRegistrationDetails."User Code" := USERID;
                            PlotRegistrationDetails."Document Date" := TODAY;
                            PlotRegistrationDetails."Registration Bonus Hold(BSP2)" := TRUE;
                            PlotRegistrationDetails.INSERT;
                            PAGE.RUN(Page::"Plot Registration Details Card", PlotRegistrationDetails, PlotRegistrationDetails."No.");
                        END;
                    end;
                }
                action("Refund SMS Submission")
                {

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Refund SMS Submission", FALSE);
                        IF UserSetup.FINDFIRST THEN
                            ERROR('Contact Admin');

                        Rec.TESTFIELD("Refund Initiate Amount");
                        CLEAR(CustomerRefundSMS);
                        CustomerRefundSMS."Refund SMS Submission"(Rec);

                        /*
                        ComInfo.GET;
                        ComInfo.SETRANGE("Send SMS",TRUE);
                        IF ComInfo.FINDFIRST THEN BEGIN
                          Customer.RESET;
                          Customer.GET("Customer No.");
                          CustMobileNo := Customer."Mobile No.";
                        //  CustMobileNo := '9818076832';
                          IF CustMobileNo <> '' THEN BEGIN
                            CustSMSText1 := '';
                            CustSMSText1 := 'Dear Customer, Your PLOT REFUND Request Received at CRM Desk. Name: Mr /Ms '+Customer.Name+', Appl No:'+"No."+', Project:'+
                                            GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1)+', Amount: '+FORMAT("Refund Initiate Amount")+', Date: '+FORMAT(TODAY)+
                                            ' *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';
                            PostPayment.SendSMS(CustMobileNo,CustSMSText1);
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage:= COPYSTR(CustSMSText1,1,250);
                            SmsMessage1 := COPYSTR(CustSMSText1,251,250);
                            SMSLogDetails.SMSValue(SmsMessage,SmsMessage1,'Customer',Customer."No.",Customer.Name,'Refund Request',"Shortcut Dimension 1 Code",GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1),"No.");
                            COMMIT;
                          END;
                          Vendor1.RESET;
                          Vendor1.GET("Introducer Code");
                          IF Vendor1."Mob. No." <> '' THEN BEGIN
                            PostPayment.SendSMS(Vendor1."Mob. No.",CustSMSText1);
                            //PostPayment.SendSMS('8374999906',CustSMSText1);
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage:= COPYSTR(CustSMSText1,1,250);
                            SmsMessage1 := COPYSTR(CustSMSText1,251,250);
                            SMSLogDetails.SMSValue(SmsMessage,SmsMessage1,'Vendor',Vendor1."No.",Vendor1.Name,'Refund Request',"Shortcut Dimension 1 Code",GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1),"No.");
                          END;
                           "Refund SMS Status" := "Refund SMS Status"::Submission;
                          MODIFY;
                          InsertRefundChangeLog(TRUE,FALSE);
                          MESSAGE('SMS Sent');
                        END;
                        */

                    end;
                }
                action("Refund SMS Initiation")
                {

                    trigger OnAction()
                    var
                        CustSMSText1: Text;
                    begin
                        Rec.TESTFIELD("Refund SMS Status", Rec."Refund SMS Status"::Submission);
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Refund SMS Initiation", FALSE);
                        IF UserSetup.FINDFIRST THEN
                            ERROR('Contact Admin');
                        Rec.TESTFIELD("Refund Initiate Amount");

                        CLEAR(CustomerRefundSMS);
                        CustomerRefundSMS."Refund SMS Initiation"(Rec);
                        /*
                        ComInfo.GET;
                        ComInfo.SETRANGE("Send SMS",TRUE);
                        IF ComInfo.FINDFIRST THEN BEGIN
                          TESTFIELD("Refund Initiate Amount");
                        
                          Customer.RESET;
                          Customer.GET("Customer No.");
                          CustMobileNo := Customer."Mobile No.";
                          IF CustMobileNo <> '' THEN BEGIN
                            CustSMSText1 := '';
                            CustSMSText1 := 'Dear Customer, Your PLOT REFUND Process is Initiated. Name: Mr /Ms '+Customer.Name+', Appl No:'+"No."+', Project:'+
                                            GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1)+', Amount: '+FORMAT("Refund Initiate Amount")+', Date: '+FORMAT(TODAY)+
                                            ' *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';
                            PostPayment.SendSMS(CustMobileNo,CustSMSText1);
                            //ALLEDK05122022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage:= COPYSTR(CustSMSText1,1,250);
                            SmsMessage1 := COPYSTR(CustSMSText1,251,250);
                            SMSLogDetails.SMSValue(SmsMessage,SmsMessage1,'Customer',Customer."No.",Customer.Name,'Refund Initiation',"Shortcut Dimension 1 Code",GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1),"No.");
                            //ALLEDK05122022  END
                            COMMIT;
                          END;
                          Vendor1.RESET;
                          Vendor1.GET("Introducer Code");
                          IF Vendor1."Mob. No." <> '' THEN BEGIN
                            PostPayment.SendSMS(Vendor1."Mob. No.",CustSMSText1);
                            //ALLEDK05122022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage:= COPYSTR(CustSMSText1,1,250);
                            SmsMessage1 := COPYSTR(CustSMSText1,251,250);
                            SMSLogDetails.SMSValue(SmsMessage,SmsMessage1,'Vendor',Vendor1."No.",Vendor1.Name,'Refund Initiation',"Shortcut Dimension 1 Code",GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1),"No.");
                            //ALLEDK05122022  END
                          END;
                        
                          "Refund SMS Status" := "Refund SMS Status"::Initiated;
                          MODIFY;
                          InsertRefundChangeLog(FALSE,FALSE);
                          MESSAGE('SMS Sent');
                        END;
                        */
                        RefundInitiatAmt := FALSE;

                    end;
                }
                action("Refund SMS Verification")
                {

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Refund Initiate Amount");
                        Rec.TESTFIELD("Refund SMS Status", Rec."Refund SMS Status"::Initiated);
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Refund SMS Verification", FALSE);
                        IF UserSetup.FINDFIRST THEN
                            ERROR('Contact Admin');

                        CLEAR(CustomerRefundSMS);
                        CustomerRefundSMS."Refund SMS Verification"(Rec);
                        /*
                        ComInfo.GET;
                        ComInfo.SETRANGE("Send SMS",TRUE);
                        IF ComInfo.FINDFIRST THEN BEGIN
                        
                        Customer.RESET;
                        Customer.GET("Customer No.");
                        CustMobileNo := Customer."Mobile No.";
                        IF CustMobileNo <> '' THEN BEGIN
                          CustSMSText1 := '';
                          CustSMSText1 := 'Dear Customer, Your PLOT REFUND Request Is Verified. Name: Mr /Ms '+Customer.Name+', Appl No:'+"No."+', Project:'+
                                          GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1)+', Amount: '+FORMAT("Refund Initiate Amount")+', Date: '+FORMAT(TODAY)+
                                          ' *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';
                          PostPayment.SendSMS(CustMobileNo,CustSMSText1);
                          //ALLEDK05122022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage:= COPYSTR(CustSMSText1,1,250);
                            SmsMessage1 := COPYSTR(CustSMSText1,251,250);
                            SMSLogDetails.SMSValue(SmsMessage,SmsMessage1,'Customer',Customer."No.",Customer.Name,'Refund Verification',"Shortcut Dimension 1 Code",GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1),"No.");
                            //ALLEDK05122022  END
                          COMMIT;
                        END;
                        Vendor1.RESET;
                        Vendor1.GET("Introducer Code");
                        IF Vendor1."Mob. No." <> '' THEN BEGIN
                          PostPayment.SendSMS(Vendor1."Mob. No.",CustSMSText1);
                          //PostPayment.SendSMS('9381601731',CustSMSText1);
                          //ALLEDK05122022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage:= COPYSTR(CustSMSText1,1,250);
                            SmsMessage1 := COPYSTR(CustSMSText1,251,250);
                            SMSLogDetails.SMSValue(SmsMessage,SmsMessage1,'Vendor',Vendor1."No.",Vendor1.Name,'Refund Verification',"Shortcut Dimension 1 Code",GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1),"No.");
                            //ALLEDK05122022  END
                        END;
                        
                        "Refund SMS Status" := "Refund SMS Status"::Verified;
                        MODIFY;
                        InsertRefundChangeLog(FALSE,FALSE);
                        MESSAGE('SMS Sent');
                        END;
                        */

                    end;
                }
                action("Refund SMS Approval")
                {

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Refund SMS Status", Rec."Refund SMS Status"::Verified);
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Refund SMS Approval", FALSE);
                        IF UserSetup.FINDFIRST THEN
                            ERROR('Contact Admin');

                        Rec.TESTFIELD("Refund Initiate Amount");

                        CLEAR(CustomerRefundSMS);
                        CustomerRefundSMS."Refund SMS Approval"(Rec);

                        /*
                        ComInfo.GET;
                        ComInfo.SETRANGE("Send SMS",TRUE);
                        IF ComInfo.FINDFIRST THEN BEGIN
                          Customer.RESET;
                          Customer.GET("Customer No.");
                          CustMobileNo := Customer."Mobile No.";
                          IF CustMobileNo <> '' THEN BEGIN
                            CustSMSText1 := '';
                            CustSMSText1 := 'Dear Customer, Your PLOT REFUND Request Is Approved. Name: Mr /Ms '+Customer.Name+', Appl No:'+"No."+', Project:'+
                                            GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1)+', Amount: '+FORMAT("Refund Initiate Amount")+', Date: '+FORMAT(TODAY)+
                                            ' *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';
                            PostPayment.SendSMS(CustMobileNo,CustSMSText1);
                            //ALLEDK05122022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage:= COPYSTR(CustSMSText1,1,250);
                            SmsMessage1 := COPYSTR(CustSMSText1,251,250);
                            SMSLogDetails.SMSValue(SmsMessage,SmsMessage1,'Customer',Customer."No.",Customer.Name,'Refund Approval',"Shortcut Dimension 1 Code",GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1),"No.");
                            //ALLEDK05122022  END
                            COMMIT;
                          END;
                          Vendor1.RESET;
                          Vendor1.GET("Introducer Code");
                          IF Vendor1."Mob. No." <> '' THEN BEGIN
                            PostPayment.SendSMS(Vendor1."Mob. No.",CustSMSText1);
                            //PostPayment.SendSMS('9381601731',CustSMSText1);
                            //ALLEDK05122022 Start
                            CLEAR(SMSLogDetails);
                            SmsMessage := '';
                            SmsMessage1 := '';
                            SmsMessage:= COPYSTR(CustSMSText1,1,250);
                            SmsMessage1 := COPYSTR(CustSMSText1,251,250);
                            SMSLogDetails.SMSValue(SmsMessage,SmsMessage1,'Vendor',Vendor1."No.",Vendor1.Name,'Refund Approval',"Shortcut Dimension 1 Code",GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1),"No.");
                            //ALLEDK05122022  END
                          END;
                        
                          "Refund SMS Status" := "Refund SMS Status"::Approved;
                          MODIFY;
                          InsertRefundChangeLog(FALSE,FALSE);
                          MESSAGE('SMS Sent');
                        END;
                        */

                    end;
                }
                action("Refund Reject SMS")
                {

                    trigger OnAction()
                    var
                        Selection: Integer;
                        StageTxt: Text;
                    begin
                        // ,Submission,Initiation,Verification,Approval,Payment

                        Rec.TESTFIELD("Refund Rejection Remark");
                        Rec.TESTFIELD("Refund Initiate Amount");

                        CLEAR(CustomerRefundSMS);
                        CustomerRefundSMS."Refund Reject SMS"(Rec, '');

                        /*
                        StageTxt := '';
                        Selection := STRMENU(Text50005,1);
                        IF Selection <> 0 THEN BEGIN
                          IF Selection = 1 THEN BEGIN
                            UserSetup.RESET;
                            IF UserSetup.GET(USERID) THEN
                              UserSetup.TESTFIELD("Refund Reject Submission");
                             StageTxt := 'Submission';
                          END ELSE IF Selection = 2 THEN BEGIN
                            UserSetup.RESET;
                            IF UserSetup.GET(USERID) THEN
                              UserSetup.TESTFIELD("Refund Reject Initiation");
                            StageTxt := 'Initiation';
                          END ELSE IF Selection = 3 THEN BEGIN
                            UserSetup.RESET;
                            IF UserSetup.GET(USERID) THEN
                              UserSetup.TESTFIELD("Refund Reject Verification");
                            StageTxt := 'Verification';
                          END ELSE IF Selection = 4 THEN BEGIN
                            UserSetup.RESET;
                            IF UserSetup.GET(USERID) THEN
                              UserSetup.TESTFIELD("Refund Reject Approval");
                            StageTxt := 'Approval';
                          END ELSE IF Selection = 5 THEN BEGIN
                            UserSetup.RESET;
                            IF UserSetup.GET(USERID) THEN
                              UserSetup.TESTFIELD("Refund Reject Payment");
                            StageTxt := 'Payment';
                          END;
                        
                        
                          ComInfo.GET;
                          ComInfo.SETRANGE("Send SMS",TRUE);
                          IF ComInfo.FINDFIRST THEN BEGIN
                            Customer.RESET;
                            Customer.GET("Customer No.");
                            CustMobileNo := Customer."Mobile No.";
                           //CustMobileNo := '8374999906';
                            IF CustMobileNo <> '' THEN BEGIN
                              CustSMSText1 := '';
                              CustSMSText1 := 'Dear Customer, Your PLOT REFUND Request is Rejected at '+'('+StageTxt+') Stage. Name: Mr /Ms '+Customer.Name+', Appl No:'+"No."+', Project:'+
                                              GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1)+', Amount: '+FORMAT("Refund Initiate Amount")+', Date: '+FORMAT(TODAY)+
                                              ' *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';
                              PostPayment.SendSMS(CustMobileNo,CustSMSText1);
                              CLEAR(SMSLogDetails);
                              SmsMessage := '';
                              SmsMessage1 := '';
                              SmsMessage:= COPYSTR(CustSMSText1,1,250);
                              SmsMessage1 := COPYSTR(CustSMSText1,251,250);
                              SMSLogDetails.SMSValue(SmsMessage,SmsMessage1,'Customer',Customer."No.",Customer.Name,'Refund Reject',"Shortcut Dimension 1 Code",GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1),"No.");
                              COMMIT;
                            END;
                            Vendor1.RESET;
                            Vendor1.GET("Introducer Code");
                            IF Vendor1."Mob. No." <> '' THEN BEGIN
                              PostPayment.SendSMS(Vendor1."Mob. No.",CustSMSText1);
                              //PostPayment.SendSMS('8374999906',CustSMSText1);
                              CLEAR(SMSLogDetails);
                              SmsMessage := '';
                              SmsMessage1 := '';
                              SmsMessage:= COPYSTR(CustSMSText1,1,250);
                              SmsMessage1 := COPYSTR(CustSMSText1,251,250);
                              SMSLogDetails.SMSValue(SmsMessage,SmsMessage1,'Vendor',Vendor1."No.",Vendor1.Name,'Refund Reject',"Shortcut Dimension 1 Code",GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1),"No.");
                            END;
                            RefundRejectionSMSSend := TRUE;
                            "Refund Rejection SMS Sent" := TRUE;
                            "Refund SMS Status" := "Refund SMS Status"::Rejected;
                            MODIFY;
                            InsertRefundChangeLog(FALSE,TRUE);
                            MESSAGE('SMS Sent');
                          END;
                        END;
                        */

                    end;
                }
                action("Customer Coupon Details")
                {
                    Image = List;
                    RunObject = Page "Customer Coupon Details";
                    RunPageLink = "No." = FIELD("No.");
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
                action(Adjust)
                {

                    trigger OnAction()
                    begin
                        Bond := Rec;
                        Bond.SETRECFILTER;
                        CLEAR(ConfReport3);
                        AppPaymentEntry.RESET;
                        AppPaymentEntry.SETRANGE("Document No.", Rec."No.");
                        AppPaymentEntry.SETFILTER("Payment Mode", '<>%1', AppPaymentEntry."Payment Mode"::JV);
                        AppPaymentEntry.SETRANGE(Posted, TRUE);
                        IF AppPaymentEntry.FINDLAST THEN BEGIN
                            ConfReport4.SetPostFilter(Rec."No.", AppPaymentEntry."Posted Document No.");
                            ConfReport4.RUN;
                        END;
                        Bond.RESET;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        ApplicationPaymentEntry_2: Record "Application Payment Entry";
        LLPAmt: Decimal;
    begin
        UpdateApplicationInfo;
        Rec.SETRANGE("No.");
        LLPAmt := 0;
        ApplicationPaymentEntry_2.RESET;
        ApplicationPaymentEntry_2.CHANGECOMPANY(Rec."LLP Name");
        ApplicationPaymentEntry_2.SETRANGE("Document No.", Rec."No.");
        ApplicationPaymentEntry_2.SETFILTER("Cheque Status", '%1|%2', ApplicationPaymentEntry_2."Cheque Status"::" ", ApplicationPaymentEntry_2."Cheque Status"::Cleared);
        IF ApplicationPaymentEntry_2.FINDSET THEN
            REPEAT
                LLPAmt := LLPAmt + ApplicationPaymentEntry_2.Amount;
            UNTIL ApplicationPaymentEntry_2.NEXT = 0;
        Rec."Received Amount in LLP" := LLPAmt;

        IF Rec."Refund SMS Status" > 0 THEN
            RefundInitiatAmt := FALSE;

        IF Rec."Refund Rejection SMS Sent" THEN
            RefundRejectionSMSSend := FALSE;
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

        IF Rec."Refund SMS Status" > 0 THEN
            RefundInitiatAmt := FALSE;

        IF Rec."Refund Rejection SMS Sent" THEN
            RefundRejectionSMSSend := FALSE;
        //ALLECK 060513 END
    end;

    trigger OnOpenPage()
    begin
        Companywise.RESET;
        Companywise.SETRANGE(Companywise."MSC Company", TRUE);
        IF Companywise.FINDFIRST THEN
            IF COMPANYNAME <> Companywise."Company Code" THEN
                ERROR('This page will open in -' + Companywise."Company Code");

        RefundInitiatAmt := TRUE;
        IF Rec."Refund SMS Status" > 0 THEN
            RefundInitiatAmt := FALSE;

        RefundRejectionSMSSend := TRUE;

        IF Rec."Refund Rejection SMS Sent" THEN
            RefundRejectionSMSSend := FALSE;
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
        //UnitMasterRec: Record 50019;
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
        UnitCode: Code[20];
        Companywise: Record "Company wise G/L Account";
        Job1: Record Job;
        CreatUPEryfromConfOrder: Codeunit "Creat UPEry from ConfOrder/APP";
        LLPName: Text[30];
        RecJob1: Record "Responsibility Center 1";
        Amt1: Decimal;
        AppPaymentEntryNew: Record "NewApplication Payment Entry";
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
        V_AppEntryN: Record "NewApplication Payment Entry";
        ConfReport4: Report "Member Receipt_12_2";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        PlotRegistrationDetailsCard: Page "Plot Registration Details Card";
        PlotRegistrationDetails: Record "Plot Registration Details";
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        RefundInitiatAmt: Boolean;
        Vendor1: Record Vendor;
        CustSMSText1: Text;
        Text50005: Label ' ,Submission,Initiation,Verification,Approval,Payment';
        RefundRejectionSMSSend: Boolean;
        RefundChangeLogDetails: Record "Refund Change Log Details";
        v_RefundChangeLogDetails: Record "Refund Change Log Details";
        BBGSETUP: Record "BBG Setups";
        RankCodeMaster: Record "Rank Code Master";
        ConfReport_12: Report "Member Receipt080923";
        CustomerRefundSMS: Codeunit "Customer Refund SMS";
        CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";
        ExitMessage: Boolean;

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
        //XMLHTTP: Automation;
        //XMLResponse: Automation;
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
        
        *///Upgrade140118 code comment

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


    procedure CreateReceiptEntry(OldConfOrder_1: Record "Confirmed Order")
    var
        ExcessAmount: Decimal;
        AppPayEntry_1: Record "Application Payment Entry";
        NewAppEntry_1: Record "NewApplication Payment Entry";
        LineNo_1: Integer;
        AppPayEntry_2: Record "Application Payment Entry";
    begin
        LineNo_1 := 0;
        NewAppEntry_1.RESET;
        NewAppEntry_1.SETRANGE("Document No.", OldConfOrder_1."No.");
        NewAppEntry_1.SETRANGE("Receipt post on InterComp", FALSE);
        NewAppEntry_1.SETRANGE("User ID", USERID);
        IF NewAppEntry_1.FINDLAST THEN BEGIN
            AppPayEntry_1.RESET;
            AppPayEntry_1.SETRANGE("Document No.", OldConfOrder_1."No.");
            IF AppPayEntry_1.FINDLAST THEN
                LineNo_1 := AppPayEntry_1."Line No.";
            CLEAR(AppPayEntry_1);
            AppPayEntry_1.RESET;
            AppPayEntry_1.INIT;
            AppPayEntry_1."Document Type" := NewAppEntry_1."Document Type"::BOND;
            AppPayEntry_1."Document No." := NewAppEntry_1."Document No.";
            AppPayEntry_1."Line No." := LineNo_1 + 10000;
            AppPayEntry_1.INSERT;
            AppPayEntry_1."Adjmt. Line No." := NewAppEntry_1."Adjmt. Line No.";
            AppPayEntry_1.VALIDATE("Payment Mode", NewAppEntry_1."Payment Mode");
            AppPayEntry_1.VALIDATE("Payment Method", NewAppEntry_1."Payment Method");
            AppPayEntry_1.Description := NewAppEntry_1.Description;
            AppPayEntry_1."Cheque No./ Transaction No." := NewAppEntry_1."Cheque No./ Transaction No.";
            AppPayEntry_1."Cheque Date" := NewAppEntry_1."Cheque Date";
            AppPayEntry_1."Cheque Bank and Branch" := NewAppEntry_1."Cheque Bank and Branch";
            AppPayEntry_1."Deposit/Paid Bank" := NewAppEntry_1."Deposit/Paid Bank";
            AppPayEntry_1."User Branch Code" := NewAppEntry_1."User Branch Code";
            AppPayEntry_1."Bank Type" := NewAppEntry_1."Bank Type";
            AppPayEntry_1.VALIDATE(Amount, NewAppEntry_1.Amount);
            AppPayEntry_1.VALIDATE("Posting date", NewAppEntry_1."Posting date");
            AppPayEntry_1.VALIDATE("Document Date", NewAppEntry_1."Posting date");
            AppPayEntry_1.VALIDATE("Shortcut Dimension 1 Code", ConfOrder."Shortcut Dimension 1 Code");
            AppPayEntry_1."MSC Post Doc. No." := NewAppEntry_1."Posted Document No.";
            AppPayEntry_1."Reverse Commission" := NewAppEntry_1."Commmission Reverse";
            AppPayEntry_1."Application No." := NewAppEntry_1."Document No.";
            AppPayEntry_1."User ID" := NewAppEntry_1."User ID";
            AppPayEntry_1."Commission Reversed" := NewAppEntry_1."Commmission Reverse";  //ALLE240415
            AppPayEntry_1."Entry From MSC" := FALSE;
            AppPayEntry_1.Narration := NewAppEntry_1.Narration;
            AppPayEntry_1."Receipt Line No." := NewAppEntry_1."Line No."; //ALLEDK 10112016
            AppPayEntry_1.MODIFY;
            CLEAR(ExcessAmount);
            ExcessAmount := CreatUPEryfromConfOrder.CheckExcessAmount(OldConfOrder_1);
            IF ExcessAmount <> 0 THEN
                CreatUPEryfromConfOrder.CreateExcessPaymentTermsLine(OldConfOrder_1."No.", ExcessAmount);
            CreatUPEryfromConfOrder.RUN(OldConfOrder_1);
            PostPayment.PostBondPayment(OldConfOrder_1, FALSE);
            NewAppEntry_1."Receipt post on InterComp" := TRUE;
            NewAppEntry_1."Receipt post InterComp Date" := TODAY;
            AppPayEntry_2.RESET;
            AppPayEntry_2.SETRANGE("Document No.", Rec."No.");
            IF AppPayEntry_2.FINDLAST THEN
                NewAppEntry_1."Posted Document No." := AppPayEntry_2."Posted Document No.";
            NewAppEntry_1."BarCode No." := NoSeriesMgt.GetNextNo(BondSetup."Bar Code no. Series", TODAY, TRUE);
            NewAppEntry_1.Posted := TRUE;
            NewAppEntry_1.MODIFY;
        END;
    end;

    local procedure "------------------------"()
    begin
    end;


    procedure CreateNewSalesOrder(P_NewConfirmedOder1: Record "New Confirmed Order")
    var
        v_SalesHeader: Record "Sales Header";
        v_SalesLine: Record "Sales Line";
        v_Customer_1: Record Customer;
        v_SalesLine1: Record "Sales Line";
        LineNo: Integer;
        FirstEntry: Boolean;
        TotalShipCost: Decimal;
        TotalPOQty: Decimal;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ICInOutboxMgt: Codeunit ICInboxOutboxMgt;
        ICOutboxTransaction: Record "IC Outbox Transaction";
        ICOutboxExport: Codeunit "IC Outbox Export";
        UnitPrice: Decimal;
        TotalPOAmt: Decimal;
        RecConfORder: Record "New Confirmed Order";
    begin
        RecConfORder.RESET;
        IF RecConfORder.GET(Rec."No.") THEN BEGIN
            v_Customer_1.RESET;
            v_Customer_1.SETFILTER("IC Partner Code", '<>%1', '');
            IF NOT v_Customer_1.FINDFIRST THEN
                ERROR('IC Vendor Not define');

            v_SalesHeader.RESET;
            v_SalesHeader.INIT;
            v_SalesHeader."Document Type" := v_SalesHeader."Document Type"::Order;
            v_SalesHeader."No." := '';
            v_SalesHeader.INSERT(TRUE);
            v_Customer_1.RESET;
            v_Customer_1.SETFILTER("IC Partner Code", '<>%1', '');
            IF v_Customer_1.FINDFIRST THEN
                v_SalesHeader.VALIDATE("Sell-to Customer No.", v_Customer_1."No.");
            v_SalesHeader."Assigned User ID" := USERID;
            v_SalesHeader.VALIDATE("Document Date", TODAY);
            v_SalesHeader.VALIDATE("Posting Date", TODAY);
            v_SalesHeader."External Document No." := RecConfORder."No.";
            v_SalesHeader.VALIDATE("Shortcut Dimension 1 Code", RecConfORder."Shortcut Dimension 1 Code");
            v_SalesHeader.MODIFY;
            IF v_SalesHeader."No." <> '' THEN BEGIN
                v_SalesLine.INIT;
                v_SalesLine."Document Type" := v_SalesHeader."Document Type";
                v_SalesLine."Document No." := v_SalesHeader."No.";
                v_SalesLine."Line No." := 10000;
                v_SalesLine.VALIDATE(Type, v_SalesLine.Type::Item);
                v_SalesLine.VALIDATE("No.", '1401011010001');    //---------------------
                v_SalesLine.VALIDATE("Location Code", v_SalesHeader."Shortcut Dimension 1 Code");
                v_SalesLine.VALIDATE("Unit of Measure", 'No');
                v_SalesLine.VALIDATE(Quantity, RecConfORder."Saleable Area");
                v_SalesLine.VALIDATE("Unit Price", ROUND((RecConfORder.Amount / RecConfORder."Saleable Area"), 0.01, '='));
                v_SalesLine.VALIDATE("Shortcut Dimension 1 Code", RecConfORder."Shortcut Dimension 1 Code");
                v_SalesLine."Shortcut Dimension 2 Code" := RecConfORder."Shortcut Dimension 2 Code";
                v_SalesLine.INSERT;

                //CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount",v_SalesLine);
                //SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(v_SalesHeader);
                ReleaseSalesDoc.PerformManualRelease(v_SalesHeader);
            END;
            COMMIT;

            IF ApprovalsMgmt.PrePostApprovalCheckSales(v_SalesHeader) THEN
                ICInOutboxMgt.SendSalesDoc(v_SalesHeader, FALSE);
            ICOutboxTransaction.RESET;
            ICOutboxTransaction.SETCURRENTKEY("Document No.");
            ICOutboxTransaction.SETRANGE("Document No.", v_SalesHeader."No.");
            IF ICOutboxTransaction.FIND('-') THEN BEGIN
                REPEAT
                    ICOutboxTransaction.VALIDATE("Line Action", ICOutboxTransaction."Line Action"::"Send to IC Partner");
                    ICOutboxTransaction.MODIFY;
                UNTIL ICOutboxTransaction.NEXT = 0;
                CLEAR(ICOutboxExport);
                //ICOutboxExport.SetHideValidationDialog(TRUE);
                ICOutboxExport.RUN(ICOutboxTransaction);
                //  CODEUNIT.RUN(CODEUNIT::"IC Outbox Export",ICOutboxTransaction);

                MESSAGE('%1', 'Sales order created with No.- ' + v_SalesHeader."No.");
                Rec."IC Sales Order Created" := TRUE;
                Rec.MODIFY;
            END;
        END;
    end;

    local procedure "----------------------"()
    begin
    end;

    local procedure CreateSMSLogEntry()
    begin
    end;

    local procedure InsertRefundChangeLog(FromSubmission: Boolean; FromRejected: Boolean)
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
        RefundChangeLogDetails."Refund SMS Status" := Rec."Refund SMS Status";
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
        IF FromSubmission THEN
            RefundChangeLogDetails."Submission Date" := TODAY;
        IF FromRejected THEN BEGIN
            v_RefundChangeLogDetails.RESET;
            v_RefundChangeLogDetails.SETRANGE("No.", Rec."No.");
            v_RefundChangeLogDetails.SETFILTER("Submission Date", '<>%1', 0D);
            IF v_RefundChangeLogDetails.FINDFIRST THEN
                RefundChangeLogDetails."Submission Date" := v_RefundChangeLogDetails."Submission Date";
            RefundChangeLogDetails."Rejected Date" := TODAY;
        END;
        RefundChangeLogDetails.INSERT;
    end;

    local procedure CheckApprovalStatus(NewAppEntries: Record "NewApplication Payment Entry")
    var
        RequesttoApproveDocuments: Record "Request to Approve Documents";
    begin
        RequesttoApproveDocuments.RESET;
        RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::Receipt);
        RequesttoApproveDocuments.SETRANGE("Document No.", NewAppEntries."Document No.");
        RequesttoApproveDocuments.SETRANGE("Document Line No.", NewAppEntries."Line No.");
        RequesttoApproveDocuments.SETRANGE(Status, RequesttoApproveDocuments.Status::" ");
        IF RequesttoApproveDocuments.FINDFIRST THEN
            ERROR('Approval Pending');
    end;
}

