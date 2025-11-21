page 97835 "Unit credit Card"
{
    // Upgrade140118 code comment

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
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Dummay Unit Code"; Rec."Dummay Unit Code")
                {
                }
                field("User Id"; Rec."User Id")
                {
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
                field(Status; Rec.Status)
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
            }
            part("Receipt Lines"; "Credit App. Payment Entry")
            {
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(false));
                UpdatePropagation = Both;
            }
            part(PostedUnitPayEntrySubform; "Posted Unit Pay Entry Subform")
            {
                Caption = 'Posted Receipt';
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
                SubPageLink = "Table Name" = FILTER("Confirmed order"),
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
            group(Discount)
            {
                field("Commission Base Amount"; Rec."Commission Base Amount")
                {
                }
                field("Direct Associate Amount"; Rec."Direct Associate Amount")
                {
                }
                field("Commission Amount_1"; Rec."Commission Amount")
                {
                }
                field("Total Comm & Direct Assc. Amt."; Rec."Total Comm & Direct Assc. Amt.")
                {
                }
                field("Commission Paid"; Rec."Commission Paid")
                {
                }
                field("Due Amount_1"; Rec.Amount + Rec."Service Charge Amount" - Rec."Total Received Amount")
                {
                }
                field("Expexted Discount by BBG"; Rec."Expexted Discount by BBG")
                {
                }
                field("Comm. Base Amt. to be Adj."; Rec."Comm. Base Amt. to be Adj.")
                {
                }
                field("Amount Adj. Associate"; Rec."Amount Adj. Associate")
                {
                }
                field("BBG Discount"; Rec."BBG Discount")
                {
                }
                field("Net Due Amount"; Rec."Net Due Amount")
                {
                }
                field("Total Debit Amt on Ass. / BBG"; TotalNetPayable)
                {
                }
                field("Comm. Dis. Amt"; TotalCommissionDisAmt)
                {
                }
            }
            group("Forfeiture / Surplus")
            {
                field("Discount Payment Type"; Rec."Discount Payment Type")
                {
                }
                field("Forfeiture / Excess Amount"; Rec."Forfeiture / Excess Amount")
                {
                }
                field("Comm. Amt Adj. in case Forfeit"; Rec."Comm. Amt Adj. in case Forfeit")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Unit)
            {
                action("Payment Plan Details")
                {
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
                    RunObject = Page "Charge Type Applicable";
                    RunPageLink = "Item No." = FIELD("Unit Code"),
                                  "Project Code" = FIELD("Shortcut Dimension 1 Code"),
                                  "Document No." = FIELD("Application No.");
                }
            }
            group("Function")
            {
                action("Discount Entries Approval")
                {
                    RunObject = Page "MJV/AJVM Pending Entries";
                    RunPageView = WHERE("Payment Mode" = FILTER("Debit Note"),
                                        Posted = FILTER(false),
                                        Approved = FILTER(false));
                }
                action("Get Discount Lines")
                {
                    Image = GetLines;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        //TESTFIELD("Comm. Base Amt. to be Adj.");
                        UnitSetup.GET;
                        Rec.TESTFIELD(Type, Rec.Type::Normal);
                        Rec.TESTFIELD("Comm. Base Amt. to be Adj.", 0);
                        Rec.TESTFIELD("Amount Adj. Associate", 0);
                        Rec.TESTFIELD("BBG Discount", 0);
                        IF CONFIRM('Do you want to insert Commission Debit Entries?', FALSE) THEN BEGIN
                            AssociateHierarcywithApp.RESET;
                            AssociateHierarcywithApp.SETRANGE("Application Code", Rec."No.");
                            AssociateHierarcywithApp.SETRANGE(Status, AssociateHierarcywithApp.Status::Active);
                            IF AssociateHierarcywithApp.FINDSET THEN BEGIN
                                REPEAT
                                    ExistCreditAppEntry.RESET;
                                    ExistCreditAppEntry.SETRANGE("Document No.", Rec."No.");
                                    IF ExistCreditAppEntry.FINDLAST THEN
                                        LineNo := ExistCreditAppEntry."Line No."
                                    ELSE
                                        LineNo := 0;
                                    IF Chain.GET(AssociateHierarcywithApp."Associate Code") THEN;
                                    IF RecConfOrder.GET(Rec."No.") THEN;  //BBG1.6 311213
                                    InsertCreditAppPayEntry.INIT;
                                    InsertCreditAppPayEntry."Document Type" := InsertCreditAppPayEntry."Document Type"::BOND;
                                    InsertCreditAppPayEntry."Document No." := Rec."No.";
                                    InsertCreditAppPayEntry."Line No." := LineNo + 10000;
                                    InsertCreditAppPayEntry."Payment Method" := 'CASH';
                                    InsertCreditAppPayEntry."Payment Mode" := InsertCreditAppPayEntry."Payment Mode"::"Debit Note";
                                    InsertCreditAppPayEntry."Posting date" := WORKDATE;
                                    InsertCreditAppPayEntry."Introducer Code" := AssociateHierarcywithApp."Associate Code";
                                    InsertCreditAppPayEntry."Introducer Name" := Chain.Name;
                                    InsertCreditAppPayEntry."Base Amount" := Rec."Comm. Base Amt. to be Adj.";
                                    InsertCreditAppPayEntry."Commission Adj. Amount" := (Rec."Comm. Base Amt. to be Adj." *
                                                                             AssociateHierarcywithApp."Commission %" / 100);
                                    InsertCreditAppPayEntry."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                                    InsertCreditAppPayEntry."Net Payable Amt" := InsertCreditAppPayEntry."Commission Adj. Amount";
                                    InsertCreditAppPayEntry."Commission %" := AssociateHierarcywithApp."Commission %";
                                    InsertCreditAppPayEntry."User ID" := USERID;
                                    InsertCreditAppPayEntry."Member Code" := RecConfOrder."Customer No.";  //BBG1.6 311213
                                    InsertCreditAppPayEntry."Discount Payment Type" := RecConfOrder."Discount Payment Type";  //BBG1.6 311213
                                    UnitSetup.GET;
                                    CheckBBGVend.RESET;
                                    CheckBBGVend.SETRANGE("No.", AssociateHierarcywithApp."Associate Code");
                                    CheckBBGVend.SETFILTER("BBG Rank Code", '>%1', UnitSetup."Hierarchy Head");
                                    IF CheckBBGVend.FINDFIRST THEN BEGIN
                                        MESSAGE('%1..%2..%3', CheckBBGVend."BBG Rank Code", CheckBBGVend."No.", AssociateHierarcywithApp."Associate Code");
                                        //  InsertCreditAppPayEntry."Introducer Code" := BBGVend."No.";
                                        //  InsertCreditAppPayEntry."Introducer Name" := BBGVend.Name;
                                        IF AssociateHierarcywithApp."Associate Code" = 'IBA9999999' THEN
                                            InsertCreditAppPayEntry."BBG Discount" := TRUE;
                                    END;
                                    IF AssociateHierarcywithApp."Associate Code" = 'IBA9999999' THEN
                                        InsertCreditAppPayEntry."BBG Discount" := TRUE;

                                    InsertCreditAppPayEntry.INSERT;
                                UNTIL AssociateHierarcywithApp.NEXT = 0;
                            END;
                            MESSAGE('Entries Created successfully');
                        END;
                    end;
                }
                action(Post)
                {
                    Image = post;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        InsertAppLines: Record "Application Payment Entry";
                        AppPayEntry_1: Record "Application Payment Entry";
                        Cust_1: Record Customer;
                    begin
                        Rec.TESTFIELD("Registration Status", Rec."Registration Status"::" ");  //090921
                        Rec.TESTFIELD("Application Closed", FALSE);  //190820
                        Rec.TESTFIELD("Application Transfered", FALSE);
                        IF CONFIRM('Do you want to post the Entries?') THEN BEGIN
                            UserSetup.RESET;
                            UserSetup.SETRANGE("User ID", USERID);
                            UserSetup.SETRANGE("Discount Post", TRUE);
                            IF NOT UserSetup.FINDFIRST THEN
                                ERROR('Please contact Admin');


                            IF Rec."Discount Payment Type" = Rec."Discount Payment Type"::" " THEN BEGIN
                                NetAmt := 0;
                                CommAmt := 0;
                                AssAdjAmt := 0;
                                CommAmount := 0;

                                //ALLECK 200313 START
                                AppPayEntry.RESET;
                                AppPayEntry.SETRANGE("Document No.", Rec."No.");
                                AppPayEntry.SETRANGE(Posted, FALSE);
                                IF AppPayEntry.FINDLAST THEN;
                                //ALLECK 200313 END

                                //ALLECK 030313 START
                                UnitStup.GET;
                                DebApplPayEntry.RESET;
                                DebApplPayEntry.SETRANGE("Document Type", DebApplPayEntry."Document Type"::Application);
                                DebApplPayEntry.SETRANGE("Document No.", Rec."Application No.");
                                DebApplPayEntry.SETRANGE("Explode BOM", FALSE);
                                IF DebApplPayEntry.FINDSET THEN
                                    REPEAT
                                        //          IF Vndr.GET("No.") THEN
                                        //         IF Vndr."Rank Code" > UnitStup."Hierarchy Head" THEN
                                        IF DebApplPayEntry."Introducer Code" = 'IBA9999999' THEN
                                            BBGDis += DebApplPayEntry."Net Payable Amt"
                                        ELSE
                                            OthDis += DebApplPayEntry."Net Payable Amt";
                                    UNTIL DebApplPayEntry.NEXT = 0;

                                TDiscount := BBGDis + OthDis;
                                //ALLECK 030313 END

                                CreditAppPayEntry.RESET;
                                CreditAppPayEntry.SETRANGE("Document No.", Rec."No.");
                                CreditAppPayEntry.SETRANGE(Posted, FALSE);
                                IF CreditAppPayEntry.FINDSET THEN BEGIN
                                    REPEAT
                                        CheckVendor.RESET;
                                        CheckVendor.SETRANGE("No.", CreditAppPayEntry."Introducer Code");
                                        IF CheckVendor.FINDFIRST THEN
                                            CheckVendor.TESTFIELD(CheckVendor."BBG Black List", FALSE);

                                        AssAdjAmt := AssAdjAmt + CreditAppPayEntry."Principal Adj. Amount";
                                    UNTIL CreditAppPayEntry.NEXT = 0;
                                    IF CreditAppPayEntry."Base Amount" > Rec."Comm. Base Amt. to be Adj." THEN
                                        ERROR('Commission Base amount not matched');
                                    IF ROUND(AssAdjAmt, 1, '=') > (ROUND(Rec."Amount Adj. Associate", 1, '=') + Rec."BBG Discount") THEN
                                        ERROR('Asssociate Adj. Amount not matched');
                                END;


                                CreditAppPayEntry.RESET;
                                CreditAppPayEntry.SETRANGE("Document No.", Rec."No.");
                                CreditAppPayEntry.SETRANGE(Posted, FALSE);
                                IF CreditAppPayEntry.FINDSET THEN
                                    REPEAT
                                        IF CreditAppPayEntry."Net Payable Amt" = 0 THEN  //ALLEDK 11/02/13
                                            ERROR('Please define the Amount on Associate No -' + CreditAppPayEntry."Introducer Code"
                                             + 'OR Delete the line');   //ALLEDK 11/02/13
                                        NetAmt := NetAmt + CreditAppPayEntry."Net Payable Amt";
                                        CommAmt := CommAmt + CreditAppPayEntry."Commission Adj. Amount";
                                    UNTIL CreditAppPayEntry.NEXT = 0;

                                Rec.CALCFIELDS("Total Received Amount");

                                IF (Rec.Amount + CommAmt + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount") < NetAmt THEN
                                    ERROR('Net Payable Amt can not be greater than DUE AMOUNT');


                                IF CONFIRM(STRSUBSTNO(Text014, Rec.FIELDCAPTION("Application No."), Rec."Application No.",
                                   GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."Shortcut Dimension 1 Code", Rec."Unit Code",
                                   Rec."Introducer Code", Vend.Name, Rec."Customer No.", TotalNetPayable, Rec."BBG Discount", OthDis, AppPayEntry."Posting date")) THEN BEGIN
                                    IF CONFIRM(Text006) THEN BEGIN //ALLECK020313
                                                                   //ALLECK 020313 END


                                        IF CONFIRM(Text006, TRUE) THEN BEGIN
                                            PostPayment.CreateCreditBondGenJnlLines(Rec, 'Bond Post');
                                            MESSAGE(Text007);

                                            CreditAppPayEntry.RESET;
                                            CreditAppPayEntry.SETRANGE("Document No.", Rec."No.");
                                            CreditAppPayEntry.SETRANGE(Posted, FALSE);
                                            IF CreditAppPayEntry.FINDSET THEN
                                                REPEAT
                                                    // IF CreditAppPayEntry."Principal Adj. Amount" > 0 THEN BEGIN  //ALLEDK 310113
                                                    AppPaymentEntry.RESET;
                                                    AppPaymentEntry.SETRANGE("Document No.", Rec."No.");
                                                    IF AppPaymentEntry.FINDLAST THEN
                                                        LastLineNo := AppPaymentEntry."Line No.";

                                                    InsertAppLines.INIT;
                                                    InsertAppLines."Document Type" := InsertAppLines."Document Type"::BOND;
                                                    InsertAppLines."Document No." := Rec."No.";
                                                    InsertAppLines."Line No." := LastLineNo + 10000;
                                                    InsertAppLines.VALIDATE("Payment Mode", CreditAppPayEntry."Payment Mode"); //ALLEDK 110213
                                                    InsertAppLines."Payment Method" := CreditAppPayEntry."Payment Method";
                                                    InsertAppLines.Amount := CreditAppPayEntry."Net Payable Amt";   //ALLEDK 250113
                                                                                                                    // InsertAppLines.Amount := CreditAppPayEntry."Principal Adj. Amount"; //ALLEDK 250113
                                                    InsertAppLines.Posted := TRUE;
                                                    InsertAppLines."Unit Code" := Rec."Unit Code"; //ALLEDK 110213
                                                    InsertAppLines."Posted Document No." := CreditAppPayEntry."Posted Document No.";
                                                    InsertAppLines."Posting date" := CreditAppPayEntry."Posting date";
                                                    InsertAppLines."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                                                    InsertAppLines."Associate Code For Disc" := CreditAppPayEntry."Introducer Code";
                                                    InsertAppLines."Explode BOM" := TRUE;
                                                    InsertAppLines."Application No." := CreditAppPayEntry."Document No.";
                                                    NewLineNo := InsertAppLines."Line No.";
                                                    InsertAppLines.Narration := CreditAppPayEntry.Narration;//ALLECK 130413
                                                    InsertAppLines.INSERT;
                                                    CreateNewAppEntry();
                                                    //        PostPayment.SplitAppPaymnetEntries(InsertAppLines,NewLineNo);  //ALLEDK 110213
                                                    CreatUPEryfromConfOrderAPP.SplitAppPayEntriesforDiscount(InsertAppLines, NewLineNo);
                                                    //END ELSE BEGIN
                                                    IF CreditAppPayEntry."Commission Adj. Amount" > 0 THEN BEGIN
                                                        LastCommEntry.RESET;
                                                        IF LastCommEntry.FINDLAST THEN
                                                            LastEntryNo := LastCommEntry."Entry No.";

                                                        CommissionEntry.INIT;
                                                        CommissionEntry."Entry No." := LastEntryNo + 1;
                                                        CommissionEntry.VALIDATE("Application No.", CreditAppPayEntry."Document No.");
                                                        CommissionEntry."Posting Date" := CreditAppPayEntry."Posting date";
                                                        CommissionEntry."Associate Code" := CreditAppPayEntry."Introducer Code";
                                                        CommissionEntry."Base Amount" := -CreditAppPayEntry."Base Amount";
                                                        CommissionEntry."Commission Amount" := -(CreditAppPayEntry."Commission Adj. Amount");
                                                        CommissionEntry."Commission %" := CreditAppPayEntry."Commission %";
                                                        CommissionEntry."Remaining Amt of Direct" := FALSE;
                                                        CommissionEntry."Bond Category" := Rec."Bond Category";
                                                        IF Rec."Introducer Code" = CreditAppPayEntry."Introducer Code" THEN
                                                            CommissionEntry."Business Type" := CommissionEntry."Business Type"::SELF
                                                        ELSE
                                                            CommissionEntry."Business Type" := CommissionEntry."Business Type"::CHAIN;
                                                        CommissionEntry."Introducer Code" := Rec."Introducer Code";
                                                        CommissionEntry."Scheme Code" := Rec."Scheme Code";
                                                        CommissionEntry."Project Type" := Rec."Project Type";
                                                        CommissionEntry."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";  //ALLEDK 040113
                                                        CommissionEntry."Voucher No." := 'Disc001';
                                                        CommissionEntry.Discount := TRUE;
                                                        IF Vend.GET(CreditAppPayEntry."Introducer Code") THEN
                                                            CommissionEntry."Associate Rank" := Vend."BBG Rank Code";
                                                        CommissionEntry.Posted := TRUE;
                                                        CommissionEntry.INSERT;
                                                    END;
                                                    CreditAppPayEntry.Posted := TRUE;
                                                    CreditAppPayEntry.MODIFY;
                                                UNTIL CreditAppPayEntry.NEXT = 0;

                                            Rec."Comm. Base Amt. to be Adj." := 0;
                                            Rec."Amount Adj. Associate" := 0;
                                            Rec."BBG Discount" := 0;
                                            TotalNetPayable := 0;
                                            TotalCommissionDisAmt := 0;
                                            Rec.MODIFY;

                                        END;
                                    END;
                                END;
                            END ELSE IF (Rec."Discount Payment Type" = Rec."Discount Payment Type"::Forfeit) OR
                            (Rec."Discount Payment Type" = Rec."Discount Payment Type"::"Excess Payment") THEN BEGIN
                                Rec.TESTFIELD("Forfeiture / Excess Amount");
                                IF CONFIRM(STRSUBSTNO(Text015, Rec."Discount Payment Type")) THEN BEGIN
                                    IF Rec."Comm. Amt Adj. in case Forfeit" <> 0 THEN BEGIN
                                        NetAmt := 0;
                                        CommAmt := 0;
                                        AssAdjAmt := 0;
                                        CommAmount := 0;

                                        AppPayEntry.RESET;
                                        AppPayEntry.SETRANGE("Document No.", Rec."No.");
                                        AppPayEntry.SETRANGE(Posted, FALSE);
                                        IF AppPayEntry.FINDLAST THEN;
                                        UnitStup.GET;
                                        DebApplPayEntry.RESET;
                                        DebApplPayEntry.SETRANGE("Document Type", DebApplPayEntry."Document Type"::Application);
                                        DebApplPayEntry.SETRANGE("Document No.", Rec."Application No.");
                                        DebApplPayEntry.SETRANGE("Explode BOM", FALSE);
                                        IF DebApplPayEntry.FINDSET THEN
                                            REPEAT
                                                //IF Vndr.GET("No.") THEN
                                                //IF Vndr."Rank Code" > UnitStup."Hierarchy Head" THEN
                                                IF DebApplPayEntry."Introducer Code" = 'IBA9999999' THEN
                                                    BBGDis += DebApplPayEntry."Net Payable Amt"
                                                ELSE
                                                    OthDis += DebApplPayEntry."Net Payable Amt";
                                            UNTIL DebApplPayEntry.NEXT = 0;

                                        TDiscount := BBGDis + OthDis;

                                        CreditAppPayEntry.RESET;
                                        CreditAppPayEntry.SETRANGE("Document No.", Rec."No.");
                                        CreditAppPayEntry.SETRANGE(Posted, FALSE);
                                        IF CreditAppPayEntry.FINDSET THEN BEGIN
                                            REPEAT
                                                AssAdjAmt := AssAdjAmt + CreditAppPayEntry."Principal Adj. Amount";
                                            UNTIL CreditAppPayEntry.NEXT = 0;
                                            IF CreditAppPayEntry."Base Amount" > Rec."Comm. Base Amt. to be Adj." THEN
                                                ERROR('Commission Base amount not matched');
                                            IF ROUND(AssAdjAmt, 1, '=') > (ROUND(Rec."Amount Adj. Associate", 1, '=') + Rec."BBG Discount") THEN
                                                ERROR('Asssociate Adj. Amount not matched');
                                        END;


                                        CreditAppPayEntry.RESET;
                                        CreditAppPayEntry.SETRANGE("Document No.", Rec."No.");
                                        CreditAppPayEntry.SETRANGE(Posted, FALSE);
                                        IF CreditAppPayEntry.FINDSET THEN
                                            REPEAT
                                                IF CreditAppPayEntry."Net Payable Amt" = 0 THEN  //ALLEDK 11/02/13
                                                    ERROR('Please define the Amount on Associate No -' + CreditAppPayEntry."Introducer Code"
                                                     + 'OR Delete the line');   //ALLEDK 11/02/13
                                                NetAmt := NetAmt + CreditAppPayEntry."Net Payable Amt";
                                                CommAmt := CommAmt + CreditAppPayEntry."Commission Adj. Amount";
                                            UNTIL CreditAppPayEntry.NEXT = 0;

                                        Rec.CALCFIELDS("Total Received Amount");

                                        IF (Rec.Amount + CommAmt + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount") < NetAmt THEN
                                            ERROR('Net Payable Amt can not be greater than DUE AMOUNT');

                                        IF CONFIRM(STRSUBSTNO(Text014, Rec.FIELDCAPTION("Application No."), Rec."Application No.",
                                           GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."Shortcut Dimension 1 Code", Rec."Unit Code",
                                           Rec."Introducer Code", Vend.Name, Rec."Customer No.", TotalNetPayable, Rec."BBG Discount", OthDis, AppPayEntry."Posting date")) THEN BEGIN
                                            IF CONFIRM(Text006) THEN BEGIN //ALLECK020313
                                                                           //ALLECK 020313 END


                                                IF CONFIRM(Text006, TRUE) THEN BEGIN
                                                    PostPayment.CreateCreditBondGenJnlLines(Rec, 'Bond Post');
                                                    MESSAGE(Text007);

                                                    CreditAppPayEntry.RESET;
                                                    CreditAppPayEntry.SETRANGE("Document No.", Rec."No.");
                                                    CreditAppPayEntry.SETRANGE(Posted, FALSE);
                                                    IF CreditAppPayEntry.FINDSET THEN
                                                        REPEAT
                                                            // IF CreditAppPayEntry."Principal Adj. Amount" > 0 THEN BEGIN  //ALLEDK 310113
                                                            AppPaymentEntry.RESET;
                                                            AppPaymentEntry.SETRANGE("Document No.", Rec."No.");
                                                            IF AppPaymentEntry.FINDLAST THEN
                                                                LastLineNo := AppPaymentEntry."Line No.";

                                                            InsertAppLines.INIT;
                                                            InsertAppLines."Document Type" := InsertAppLines."Document Type"::BOND;
                                                            InsertAppLines."Document No." := Rec."No.";
                                                            InsertAppLines."Line No." := LastLineNo + 10000;
                                                            InsertAppLines.VALIDATE("Payment Mode", CreditAppPayEntry."Payment Mode"); //ALLEDK 110213
                                                            InsertAppLines."Payment Method" := CreditAppPayEntry."Payment Method";
                                                            InsertAppLines.Amount := CreditAppPayEntry."Net Payable Amt";   //ALLEDK 250113
                                                                                                                            // InsertAppLines.Amount := CreditAppPayEntry."Principal Adj. Amount"; //ALLEDK 250113
                                                            InsertAppLines.Posted := TRUE;
                                                            InsertAppLines."Unit Code" := Rec."Unit Code"; //ALLEDK 110213
                                                            InsertAppLines."Posted Document No." := CreditAppPayEntry."Posted Document No.";
                                                            InsertAppLines."Posting date" := CreditAppPayEntry."Posting date";
                                                            InsertAppLines."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                                                            InsertAppLines."Associate Code For Disc" := CreditAppPayEntry."Introducer Code";
                                                            InsertAppLines."Explode BOM" := TRUE;
                                                            InsertAppLines."Application No." := CreditAppPayEntry."Document No.";
                                                            NewLineNo := InsertAppLines."Line No.";
                                                            InsertAppLines.Narration := CreditAppPayEntry.Narration;//ALLECK 130413
                                                            InsertAppLines.INSERT;
                                                            CreateNewAppEntry();
                                                            //        PostPayment.SplitAppPaymnetEntries(InsertAppLines,NewLineNo);  //ALLEDK 110213
                                                            CreatUPEryfromConfOrderAPP.SplitAppPayEntriesforDiscount(InsertAppLines, NewLineNo);
                                                            //END ELSE BEGIN
                                                            IF CreditAppPayEntry."Commission Adj. Amount" > 0 THEN BEGIN
                                                                LastCommEntry.RESET;
                                                                IF LastCommEntry.FINDLAST THEN
                                                                    LastEntryNo := LastCommEntry."Entry No.";

                                                                CommissionEntry.INIT;
                                                                CommissionEntry."Entry No." := LastEntryNo + 1;
                                                                CommissionEntry.VALIDATE("Application No.", CreditAppPayEntry."Document No.");
                                                                CommissionEntry."Posting Date" := CreditAppPayEntry."Posting date";
                                                                CommissionEntry."Associate Code" := CreditAppPayEntry."Introducer Code";
                                                                CommissionEntry."Base Amount" := -CreditAppPayEntry."Base Amount";
                                                                CommissionEntry."Commission Amount" := -(CreditAppPayEntry."Commission Adj. Amount");
                                                                CommissionEntry."Commission %" := CreditAppPayEntry."Commission %";
                                                                CommissionEntry."Remaining Amt of Direct" := FALSE;
                                                                CommissionEntry."Bond Category" := Rec."Bond Category";
                                                                IF Rec."Introducer Code" = CreditAppPayEntry."Introducer Code" THEN
                                                                    CommissionEntry."Business Type" := CommissionEntry."Business Type"::SELF
                                                                ELSE
                                                                    CommissionEntry."Business Type" := CommissionEntry."Business Type"::CHAIN;
                                                                CommissionEntry."Introducer Code" := Rec."Introducer Code";
                                                                CommissionEntry."Scheme Code" := Rec."Scheme Code";
                                                                CommissionEntry."Project Type" := Rec."Project Type";
                                                                CommissionEntry."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";  //ALLEDK 040113
                                                                CommissionEntry."Voucher No." := 'Disc001';
                                                                CommissionEntry.Discount := TRUE;
                                                                IF Vend.GET(CreditAppPayEntry."Introducer Code") THEN
                                                                    CommissionEntry."Associate Rank" := Vend."BBG Rank Code";
                                                                CommissionEntry.Posted := TRUE;
                                                                CommissionEntry.INSERT;
                                                            END;
                                                            CreditAppPayEntry.Posted := TRUE;
                                                            CreditAppPayEntry.MODIFY;
                                                        UNTIL CreditAppPayEntry.NEXT = 0;

                                                    Rec."Comm. Base Amt. to be Adj." := 0;
                                                    Rec."Amount Adj. Associate" := 0;
                                                    Rec."BBG Discount" := 0;
                                                    TotalNetPayable := 0;
                                                    TotalCommissionDisAmt := 0;
                                                    Rec.MODIFY;
                                                END;
                                            END;
                                        END;
                                    END;
                                END;
                                IF (Rec."Discount Payment Type" = Rec."Discount Payment Type"::Forfeit) THEN
                                    PostPayment.CreateForfeitAppEntry(Rec, 'Forfeit Adjustment')
                                ELSE
                                    PostPayment.CreateForfeitAppEntry(Rec, 'Excess Adjustment');
                                Rec."Forfeiture / Excess Amount" := 0;
                                Rec."Discount Payment Type" := Rec."Discount Payment Type"::" ";
                                Rec."Comm. Amt Adj. in case Forfeit" := 0;
                                Rec."Comm. Base Amt. to be Adj." := 0;
                                Rec."Amount Adj. Associate" := 0;
                                Rec."BBG Discount" := 0;
                                TotalNetPayable := 0;
                                TotalCommissionDisAmt := 0;
                                Rec.MODIFY;
                                MESSAGE('Posting Done successfully');
                            END;
                            CreditAppPayEntry.RESET;
                            CreditAppPayEntry.SETRANGE("Document No.", Rec."No.");
                            CreditAppPayEntry.SETRANGE("BBG Discount", TRUE);

                            IF CreditAppPayEntry.FINDLAST THEN BEGIN
                                PostDiscountEntry.PostDiscountEntries(Rec."Customer No.", CreditAppPayEntry."Document No.",
                                                                       CreditAppPayEntry."Posting date", CreditAppPayEntry."Net Payable Amt");

                            END;
                        END;
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
                action("Refresh Amount")
                {
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        TotalRecord := 0;
                        NetAmt := 0;
                        "TotalDis%" := 0;
                        CreditAppPayEntry.RESET;
                        CreditAppPayEntry.SETRANGE("Document No.", Rec."No.");
                        CreditAppPayEntry.SETRANGE(Posted, FALSE);
                        CreditAppPayEntry.SETRANGE("BBG Discount", FALSE);  //ALLEDK 180213
                        CreditAppPayEntry.SETFILTER("Introducer Code", '<>%1', '');
                        IF CreditAppPayEntry.FINDSET THEN
                            REPEAT
                                TotalRecord := CreditAppPayEntry.COUNT;
                                "TotalDis%" := "TotalDis%" + CreditAppPayEntry."Commission %";
                            UNTIL CreditAppPayEntry.NEXT = 0;

                        UnitSetup.GET;
                        TDSPercentage := 0;
                        CommBaseAmt := 0;
                        TDSPercentage := PostPaymentCodeunit.CalculateTDSPercentage(Rec."Introducer Code", UnitSetup."TDS Nature of Deduction", '');

                        IF TotalCommissionDisAmt <> 0 THEN BEGIN
                            IF Rec."Comm. Base Amt. to be Adj." = 0 THEN
                                Rec."Comm. Base Amt. to be Adj." := (((100 * TotalCommissionDisAmt) / (100 - UnitSetup."Corpus %" - TDSPercentage)) / "TotalDis%" * 100);
                        END;

                        CommBaseAmt := Rec."Comm. Base Amt. to be Adj." - ((Rec."Comm. Base Amt. to be Adj." * TDSPercentage / 100) +
                        (Rec."Comm. Base Amt. to be Adj." * UnitSetup."Corpus %" / 100));

                        CreditAppPayEntry.RESET;
                        CreditAppPayEntry.SETRANGE("Document No.", Rec."No.");
                        CreditAppPayEntry.SETRANGE(Posted, FALSE);
                        CreditAppPayEntry.SETFILTER("Introducer Code", '<>%1', '');
                        IF CreditAppPayEntry.FINDSET THEN
                            REPEAT
                                IF CreditAppPayEntry."BBG Discount" = FALSE THEN BEGIN  //ALLEDK 180213
                                    CreditAppPayEntry."Base Amount" := Rec."Comm. Base Amt. to be Adj.";
                                    IF Rec."Comm. Base Amt. to be Adj." <> 0 THEN
                                        CreditAppPayEntry."Commission Adj. Amount" := (CommBaseAmt * CreditAppPayEntry."Commission %") / 100
                                    ELSE
                                        CreditAppPayEntry."Commission Adj. Amount" := 0;
                                    CreditAppPayEntry."Principal Adj. Amount" := Rec."Amount Adj. Associate" / TotalRecord;
                                END ELSE BEGIN
                                    CreditAppPayEntry."Principal Adj. Amount" := Rec."BBG Discount";
                                END;
                                CreditAppPayEntry."Net Payable Amt" := CreditAppPayEntry."Principal Adj. Amount" + CreditAppPayEntry."Commission Adj. Amount";
                                CreditAppPayEntry.MODIFY;
                            UNTIL CreditAppPayEntry.NEXT = 0;



                        TotalCommissionDisAmt := 0;

                        CreditAppPayEntry.RESET;
                        CreditAppPayEntry.SETRANGE("Document No.", Rec."No.");
                        CreditAppPayEntry.SETRANGE(Posted, FALSE);
                        IF CreditAppPayEntry.FINDSET THEN
                            REPEAT
                                NetAmt := NetAmt + CreditAppPayEntry."Net Payable Amt";
                                TotalCommissionDisAmt := TotalCommissionDisAmt + CreditAppPayEntry."Commission Adj. Amount";
                            UNTIL CreditAppPayEntry.NEXT = 0;

                        TotalNetPayable := NetAmt;

                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

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
        CommEntry: Record "Commission Entry";
        LastLineNo: Integer;
        CreditAppPayEntry: Record "Debit App. Payment Entry";
        InsertUnitAppLines: Record "Unit Payment Entry";
        UnitLastLineNo: Integer;
        UnitAppPaymentEntry: Record "Unit Payment Entry";
        NewLineNo: Integer;
        UnitReversal: Codeunit "Unit Reversal";
        NetAmt: Decimal;
        TotalNetPayable: Decimal;
        CommAmt: Decimal;
        LastCommEntry: Record "Commission Entry";
        CommissionEntry: Record "Commission Entry";
        LastEntryNo: Integer;
        TotalRecord: Integer;
        AssAdjAmt: Decimal;
        TotalComm: Decimal;
        CommAmount: Decimal;
        Vend: Record Vendor;
        CreatUPEryfromConfOrderAPP: Codeunit "Creat UPEry from ConfOrder/APP";
        CommBaseAmt: Decimal;
        PostPaymentCodeunit: Codeunit PostPayment;
        TDSPercentage: Decimal;
        TotalCommissionDisAmt: Decimal;
        "TotalDis%": Decimal;
        DebApplPayEntry: Record "Debit App. Payment Entry";
        BBGDis: Decimal;
        OthDis: Decimal;
        TDiscount: Decimal;
        Vndr: Record Vendor;
        UnitStup: Record "Unit Setup";
        AppPayEntry: Record "Debit App. Payment Entry";
        AssociateHierarcywithApp: Record "Associate Hierarcy with App.";
        ExistCreditAppEntry: Record "Debit App. Payment Entry";
        InsertCreditAppPayEntry: Record "Debit App. Payment Entry";
        Chain: Record Vendor;
        CheckBBGVend: Record Vendor;
        RecConfOrder: Record "Confirmed Order";
        PostDiscountEntry: Codeunit "UpdateCharges /Post/Rev AssPmt";
        CheckVendor: Record Vendor;
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
        Text014: Label 'Please verify the details below and confirm.\Do you want to post?\%1      :%2\Project Name         :%3  Project Code :%4\Unit No.                  :%5\Associate Code      :%6-%7 \Customer Name      :%8\Total Discount Amt : %9 \BBG Discount          : %10 \Associate Discount :%11\Posting Date           : %12.';
        Text015: Label 'Do you want to Post the Entries with Discount Payment Type- %1';


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


    procedure CreateNewAppEntry()
    var
        NewAppPmtEntry: Record "NewApplication Payment Entry";
        OldAppPmtEntry: Record "NewApplication Payment Entry";
    begin
        LastLineNo := 0;
        OldAppPmtEntry.RESET;
        OldAppPmtEntry.SETRANGE("Document No.", Rec."No.");
        IF OldAppPmtEntry.FINDLAST THEN
            LastLineNo := OldAppPmtEntry."Line No.";

        NewAppPmtEntry.INIT;
        NewAppPmtEntry."Document Type" := NewAppPmtEntry."Document Type"::BOND;
        NewAppPmtEntry."Document No." := Rec."No.";
        NewAppPmtEntry."Line No." := LastLineNo + 10000;
        NewAppPmtEntry."Payment Mode" := CreditAppPayEntry."Payment Mode"; //ALLEDK 110213
        NewAppPmtEntry."Payment Method" := CreditAppPayEntry."Payment Method";
        NewAppPmtEntry.Amount := CreditAppPayEntry."Net Payable Amt";   //ALLEDK 250113
        NewAppPmtEntry."Document Date" := CreditAppPayEntry."Posting date";
        NewAppPmtEntry."User ID" := USERID;
        NewAppPmtEntry.Posted := TRUE;
        NewAppPmtEntry."Cheque Status" := NewAppPmtEntry."Cheque Status"::Cleared;
        NewAppPmtEntry."Unit Code" := Rec."Unit Code"; //ALLEDK 110213
        NewAppPmtEntry."Posted Document No." := CreditAppPayEntry."Posted Document No.";
        NewAppPmtEntry."Posting date" := CreditAppPayEntry."Posting date";
        NewAppPmtEntry."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
        NewAppPmtEntry."Associate Code For Disc" := CreditAppPayEntry."Introducer Code";
        NewAppPmtEntry."Explode BOM" := TRUE;
        NewAppPmtEntry."Application No." := CreditAppPayEntry."Document No.";
        NewAppPmtEntry.Narration := CreditAppPayEntry.Narration;//ALLECK 130413
        NewAppPmtEntry."Create from MSC Company" := FALSE;
        NewAppPmtEntry.INSERT;
    end;
}

