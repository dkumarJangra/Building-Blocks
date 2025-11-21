page 50079 "New Application booking"
{
    // //ALLECK 220612 : Code Commented For "Investment Type", "Bond Duration", "Return Frequency","Investment Frequency",
    //                   "Service Charge Amount",Return "Interest Amount","Maturity Bonus Amount"
    // 
    // //ALLEDK 251212 Create confirmed order after application print
    // ALLEPG 280113 : Code added for SMS integration
    // ALLEDK 10112016 Added code for flow of Receipt line no.

    PageType = Card;
    SourceTable = "New Application Booking";
    SourceTableView = WHERE(Status = FILTER(Open | Released));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group("Application Card")
            {
                Caption = 'Application Card';
                field("Application No."; Rec."Application No.")
                {
                    Editable = "Application No.Editable";
                    ShowMandatory = true;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = ShortcutDimension1CodeEditable;
                    ShowMandatory = true;
                }
                Field("Rank Code"; Rec."Rank Code")
                {
                    TableRelation = "Rank Code Master".Code;
                    Caption = 'Region_Rank Code';

                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Member No.';
                    Editable = "Customer No.Editable";
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        IF xRec."Customer No." <> Rec."Customer No." THEN BEGIN
                            IF Rec."Customer No." <> '' THEN
                                IF Cust.GET(Rec."Customer No.") THEN
                                    Rec."Bill-to Customer Name" := Cust.Name;
                        END;

                        IF Rec."Bill-to Customer Name" = '' THEN BEGIN
                            IF Rec."Customer No." <> '' THEN
                                IF Cust.GET(Rec."Customer No.") THEN
                                    Rec."Bill-to Customer Name" := Cust.Name;
                        END;
                    end;
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                    Caption = 'Member Name';
                    Editable = true;
                    ShowMandatory = true;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        //NewValue := STRSUBSTNO(Text50001,"Bill-to Customer Name");  //Comment 310823
                        /* //250718 code comment
                        RecCust.RESET;
                        RecCust.SETFILTER(Name,NewValue);
                        IF RecCust.FINDSET THEN
                          REPEAT
                          UNTIL RecCust.NEXT =0;
                        IF RecCust.COUNT > 1 THEN BEGIN
                          CLEAR(RecCustList);
                          IF PAGE.RUNMODAL(22,RecCust) = ACTION::LookupOK THEN BEGIN
                            "Customer No." := RecCust."No.";
                            VALIDATE("Customer No.");
                            "Bill-to Customer Name" := RecCust.Name;
                            "Customer Name" := RecCust.Name;
                          END;
                        END ELSE BEGIN
                          "Bill-to Customer Name" := "Bill-to Customer Name";
                          "Customer Name" := "Bill-to Customer Name";
                         // "Customer No." := RecCust."No.";
                         // VALIDATE("Customer No.");
                        END;
                        */   //250718 code comment
                        Rec."Bill-to Customer Name" := Rec."Bill-to Customer Name";
                        Rec."Customer Name" := Rec."Bill-to Customer Name";
                        // "Customer No." := RecCust."No.";

                    end;
                }
                field("Member's D.O.B"; Rec."Member's D.O.B")
                {
                    ShowMandatory = true;
                }
                field("Father / Husband Name"; Rec."Father / Husband Name")
                {
                }

                field("Mobile No."; Rec."Mobile No.")
                {
                    ShowMandatory = true;

                    trigger OnValidate()
                    var
                        ExitMessage: Boolean;
                    begin
                        IF Rec."Mobile No." <> '' THEN
                            ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Rec."Mobile No.", TRUE);
                    end;
                }
                field("Customer State Code"; Rec."Customer State Code")
                {
                }
                field("District Code"; Rec."District Code")
                {
                }
                field("Mandal Code"; Rec."Mandal Code")
                {
                }
                field("Village Code"; Rec."Village Code")
                {
                    Caption = 'Village Name';
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Caption = 'IBA Code';
                    Editable = "Associate CodeEditable";
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        MMName := GetDescription.GetVendorName(Rec."Associate Code");
                        InvestmentFrequency := 0;
                        ReturnFrequency := 0;
                    end;
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Unit Code", '');
                    end;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Unit Payment Plan");

                        IF Rec."Unit Code" <> '' THEN
                            ShortcutDimension1CodeEditable := FALSE
                        ELSE
                            ShortcutDimension1CodeEditable := TRUE;
                    end;
                }
                field("GetDescription.GetDimensionName(Shortcut Dimension 1 Code,1)";
                GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1))
                {
                    Caption = 'Project Name';
                    DrillDown = false;
                    Editable = false;
                }
                field(MMName; MMName)
                {
                    Caption = 'IBA Name';
                    DrillDown = false;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                }
                field("60 feet road"; Rec."60 feet road")
                {
                }
                field("100 feet road"; Rec."100 feet road")
                {
                }
                field("Unit Facing"; Rec."Unit Facing")
                {
                }
                field("&Investment Amount"; Rec."Investment Amount")
                {
                    Caption = 'Total Unit Value';
                    Editable = false;
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Development Charges"; Rec."Development Charges")
                {
                    Visible = false;
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        IF Rec."Posting Date" > TODAY THEN
                            ERROR('Posting Date can not be greater than -' + FORMAT(TODAY));
                    end;
                }
                field("E-mail"; Rec."E-mail")
                {
                }
                field("Aadhar No."; Rec."Aadhar No.")
                {
                }

                field("Company Name"; Rec."Company Name")
                {
                    Caption = 'Company Name';
                    Editable = false;
                }
            }
            group("R&eceipts")
            {
                Caption = 'R&eceipts';
                part(PaymentsSubform; "NewApp Payment Entry Subform")
                {
                    SubPageLink = "Document Type" = FILTER(Application),
                                  "Document No." = FIELD("Application No."),
                                  "Application No." = FIELD("Application No."),
                                  Type = CONST(Received);
                }
            }
            group("Application Information")
            {
                Caption = 'Application Information';
                field("User Id"; Rec."User Id")
                {
                    Caption = 'USER ID';
                    Editable = false;
                }
                field("Application Type"; Rec."Application Type")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field("GetDescription.GetDimensionName(Shortcut Dimension 2 Code,2)";
                GetDescription.GetDimensionName(Rec."Shortcut Dimension 2 Code", 2))
                {
                    DrillDown = false;
                    Editable = false;
                    Visible = false;
                }
                field("Posted Doc No."; Rec."Posted Doc No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field("Pass Book No."; Rec."Pass Book No.")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = true;
                }
                field("Investment Amount +Rec.Service Charge Amount - Rec.Discount Amount - Rec.Total Received Amount"; Rec."Investment Amount" + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount")
                {
                    Caption = 'Due Amount';
                }
                field("Received From Code"; Rec."Received From Code")
                {
                    Editable = "Received From CodeEditable";
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReceivedFromName := GetDescription.GetVendorName(Rec."Received From Code");
                    end;
                }
                field("GetDescription.GetVendorName(Received From Code)";
                GetDescription.GetVendorName(Rec."Received From Code"))
                {
                    Caption = 'Received From Name';
                    DrillDown = false;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;
                }
            }
            group("&History")
            {
                Caption = '&History';
                part("Application History Subform"; "Application History Subform")
                {
                    Editable = false;
                    SubPageLink = "Unit No." = FIELD("Unit No.");
                }
            }
            group("&Comments")
            {
                Caption = '&Comments';
                part("Unit Comment Sheet"; "Unit Comment Sheet")
                {
                    SubPageLink = "Table Name" = FILTER("Activity Master"),
                                  "No." = FIELD("Application No.");
                }
            }
            group("P&rint Log")
            {
                Caption = 'P&rint Log';
                part("Unit Print Log Subform"; "Unit Print Log Subform")
                {
                    SubPageLink = "Unit No." = FIELD("Unit No.");
                }
            }
            group("&Bank Information")
            {
                Caption = '&Bank Information';
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    Editable = "Bank Account No.Editable";
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    Editable = "Branch NameEditable";
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Application")
            {
                Caption = '&Application';
                action("Bank Details")
                {
                    Caption = 'Bank Details';
                    Visible = false;

                    trigger OnAction()
                    begin
                        BankDetail;
                    end;
                }
                group("Bonus Entry")
                {
                    Caption = 'Bonus Entry';
                    Visible = false;
                    action(UnPosted)
                    {
                        Caption = 'UnPosted';
                        Visible = false;

                        trigger OnAction()
                        var
                            BonusEntry: Page "Bonus Entry";
                        begin
                            BonusEntry.SETRECORD(Rec);
                            BonusEntry.RUNMODAL;
                        end;
                    }
                    action(Posted)
                    {
                        Caption = 'Posted';
                        Visible = false;

                        trigger OnAction()
                        var
                            BonusEntryPosted: Page "Bonus Entry Posted";
                        begin
                            BonusEntryPosted.SETRECORD(Rec);
                            BonusEntryPosted.RUNMODAL;
                        end;
                    }
                }
                action("Payment Milestones")
                {
                    Caption = 'Payment Milestones';
                    Visible = false;

                    trigger OnAction()
                    var
                        PayTermLineSale: Record "Payment Terms Line Sale";
                    begin
                        PayTermLineSale.RESET;
                        PayTermLineSale.CHANGECOMPANY(Rec."Company Name");
                        PayTermLineSale.SETRANGE("Document No.", Rec."Application No.");
                        PayTermLineSale.SETRANGE("Transaction Type", PayTermLineSale."Transaction Type"::Sale);
                        IF PayTermLineSale.FINDSET THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Payment Terms Line Sale", PayTermLineSale) = ACTION::LookupOK THEN;
                        END;
                    end;
                }
                action("Payment Plan Details")
                {
                    Caption = 'Payment Plan Details';
                    Image = "1099Form";
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Payment Plan Details Master";
                    RunPageLink = "Document No." = FIELD("Application No.");

                    trigger OnAction()
                    var
                        PaymentPlanDetails: Record "Payment Plan Details";
                    begin
                        PaymentPlanDetails.RESET;
                        PaymentPlanDetails.CHANGECOMPANY(Rec."Company Name");
                        PaymentPlanDetails.SETRANGE("Document No.", Rec."Application No.");
                        PaymentPlanDetails.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
                        IF PaymentPlanDetails.FINDSET THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Payment Plan Details Master", PaymentPlanDetails) = ACTION::LookupOK THEN;
                        END;
                    end;
                }
                action("Applicable Charges")
                {
                    Caption = 'Applicable Charges';
                    RunObject = Page "Charge Type Applicable";
                    RunPageLink = "Project Code" = FIELD("Shortcut Dimension 1 Code"),
                                  "Document No." = FIELD("Application No.");
                    Visible = false;
                }

                action("&Attach Documents")
                {
                    Caption = '&Attach Documents';
                    //Promoted = true;
                    RunObject = Page "Application Aadhaar Attachment";
                    RunPageLink = "Table No." = CONST(50016),
                              "Document No." = FIELD("Application No.");
                    ApplicationArea = All;
                }
            }
        }
        area(processing)
        {
            group("&Print")
            {
                Caption = '&Print';
                Visible = true;
                action("&Acknowledgement")
                {
                    Caption = '&Acknowledgement';
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF Rec.Status <> Rec.Status::Open THEN BEGIN
                            Application := Rec;
                            Application.SETRECFILTER;
                            //REPORT.RUNMODAL(REPORT::"Incentive Detail Report Final", TRUE, FALSE, Application);
                            Rec := Application;
                            //ALLEDK 301212
                            /*

                              CreateConfirmedOrder.CreateBondfromApplication(Rec);
                              MESSAGE('Confirmed Order Create successfully');
                              IF ConfOrder.GET("Application No.") THEN
                                Rec.DELETE;
                             */
                            //ALLEDK 301212
                        END ELSE
                            ERROR('Application must be Release');

                    end;
                }
                action("Ack. P&rivew")
                {
                    Caption = 'Ack. P&rivew';
                    ShortCutKey = 'Shift+F9';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Application := Rec;
                        Application.SETRECFILTER;
                        //REPORT.RUNMODAL(REPORT::Report90253, TRUE, FALSE, Application);
                        Application.RESET;
                    end;
                }
                action("Member Receipt")
                {
                    Caption = 'Member Receipt';
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    begin
                        IF Rec.Status <> Rec.Status::Open THEN BEGIN
                            Application := Rec;
                            Application.SETRECFILTER;
                            CLEAR(ConfReport);
                            AppPaymentEntry.RESET;
                            AppPaymentEntry.SETRANGE("Document No.", Rec."Application No.");
                            IF AppPaymentEntry.FINDLAST THEN BEGIN
                                ConfReport.SetPostFilter(Rec."Application No.", AppPaymentEntry."Posted Document No.");
                                ConfReport.RUN;
                            END;
                            Application.RESET;
                        END ELSE
                            ERROR('Application must be Release');
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Cancell Receipt")
                {
                    Caption = 'Cancell Receipt';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Released);
                        IF CONFIRM('Do you want to Cancell the Receipt') THEN BEGIN
                            CurrPage.PaymentsSubform.PAGE.ReversalRcpt;
                            CLEAR(NewUnitMaster);
                            NewUnitMaster.RESET;
                            NewUnitMaster.SETRANGE("No.", Rec."Unit Code");
                            NewUnitMaster.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
                            IF NewUnitMaster.FINDFIRST THEN BEGIN
                                NewUnitMaster.Status := NewUnitMaster.Status::Open;
                                NewUnitMaster."Web Portal Status" := NewUnitMaster."Web Portal Status"::Available;
                                NewUnitMaster.Freeze := FALSE;
                                NewUnitMaster."Plot Cost" := 0;
                                NewUnitMaster."Customer Name" := '';
                                NewUnitMaster.MODIFY;
                            END;
                            RecUMaster.RESET;
                            RecUMaster.CHANGECOMPANY(Rec."Company Name");
                            IF RecUMaster.GET(Rec."Unit Code") THEN BEGIN
                                RecUMaster."Plot Cost" := 0;
                                RecUMaster."Customer Name" := '';
                                RecUMaster.MODIFY;
                            END;

                            Rec."Unit Code" := '';
                            Rec.Status := Rec.Status::Cancelled;
                            Rec.MODIFY;
                        END;
                    end;
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        InvestmentType: Integer;
                        NewApplicationpayentry: Record "NewApplication Payment Entry";
                        SendEmailtoCustomer: Codeunit "Send E-mail to Customer";
                        Vendor_2: Record Vendor;
                        Project_RankWisesetup: record "Project wise Appl. Setup";
                        ProjectwiseCommSetup: Record "Commission Structr Amount Base";
                        RecCustomer: Record Customer;
                        v_Documents: Record Document;

                    begin
                        //ERROR('WIP');
                        Rec.TESTFIELD("E-mail");
                        Rec.TestField("Customer State Code");
                        Rec.TestField("District Code");
                        Rec.TestField("Mandal Code");
                        Rec.TestField("Village Code");
                        //Code added Start 19082025
                        Rec.TestField("Aadhar No.");
                        v_Documents.RESET;
                        v_Documents.SetRange("Document Type", v_Documents."Document Type"::Document);
                        v_Documents.SetRange("Document No.", Rec."Application No.");
                        v_Documents.SetFilter(Description, '<>%1', '');
                        v_Documents.SetRange("Table No.", 50016);
                        IF NOT v_Documents.FindFirst() THEN
                            Error('Aadhaar attachment is missing');
                        //Code added END 19082025

                        BondSetup.GET;
                        BondSetup.TESTFIELD(BondSetup."Bar Code no. Series");
                        BondSetup.TESTFIELD("Cash Amount Limit");
                        REc.TestField("Rank Code");
                        //Code added start 01072025
                        Project_RankWisesetup.RESET;
                        Project_RankWisesetup.SetRange("Project Code", Rec."Shortcut Dimension 1 Code");
                        Project_RankWisesetup.SetFilter("Effective From Date", '<=%1', Rec."Posting Date");
                        Project_RankWisesetup.SetFilter("Effective To Date", '>=%1', Rec."Posting Date");
                        Project_RankWisesetup.SetRange("Project Rank Code", Rec."Rank Code");
                        //Project_RankWisesetup.SetFilter("Commission Structure Code", '<>%1', '');
                        IF Project_RankWisesetup.FindFirst() then begin
                            ProjectwiseCommSetup.RESET;
                            ProjectwiseCommSetup.SetRange("Project Code", Rec."Shortcut Dimension 1 Code");
                            ProjectwiseCommSetup.SetFilter("Start Date", '<=%1', Rec."Posting Date");
                            ProjectwiseCommSetup.SetFilter("End Date", '>=%1', Rec."Posting Date");
                            ProjectwiseCommSetup.SetRange("Payment Plan Code", Rec."Unit Payment Plan");
                            ProjectwiseCommSetup.SetFilter("% Per Square", '<>%1', 0);
                            ProjectwiseCommSetup.SetRange("Rank Code", Rec."Rank Code");  //Code added 01072025
                            IF Not ProjectwiseCommSetup.FindFirst() then
                                Error('Project wise commission structure not define.');
                        END;
                        //Code added END 01072025

                        //ALLECK 060313 START
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_APPPOSTING');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of role  :A_APPPOSTING');
                        //ALLECK 060313 End

                        //BBG2.00 310714
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.", Rec."Application No.");
                        AppPayEntry.SETRANGE(Posted, FALSE);
                        IF AppPayEntry.FINDFIRST THEN BEGIN
                            AppPayEntry.TESTFIELD(Amount);
                            AppPayEntry.TESTFIELD("Payment Mode");
                            IF AppPayEntry."Payment Mode" <> AppPayEntry."Payment Mode"::Cash THEN BEGIN
                                AppPayEntry.TESTFIELD("Cheque No./ Transaction No.");
                                AppPayEntry.TESTFIELD("Deposit/Paid Bank");
                            END;
                        END;
                        //BBG2.00 310714



                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        Rec.TESTFIELD("Bill-to Customer Name");
                        BondSetup.GET;
                        IF Rec."Customer No." = '' THEN
                            Rec.VALIDATE("Customer No.", Rec.CreateCustomer(Rec."Customer Name"));

                        IF (Rec."Customer Name" = '') AND (Rec."Customer No." = '') THEN BEGIN
                            ERROR(Text001, Rec.FIELDCAPTION("Bill-to Customer Name"), Rec.FIELDCAPTION("Customer No."));

                        END;
                        //Code Added Start 23072025
                        Customer.Reset();
                        IF Customer.GET(Rec."Customer No.") THEN BEGIN
                            Customer."District Code" := Rec."District Code";
                            Customer."Mandal Code" := Rec."Mandal Code";
                            Customer."Village Code" := Rec."Village Code";
                            Customer.Modify;
                        END;
                        //Code Added END 23072025


                        NewAppEntry.RESET;
                        NewAppEntry.SETRANGE("Document No.", Rec."Application No.");
                        NewAppEntry.SETRANGE(Posted, FALSE);
                        IF NewAppEntry.FINDFIRST THEN
                            REPEAT
                                IF NewAppEntry."Payment Mode" = NewAppEntry."Payment Mode"::Bank THEN
                                    NewAppEntry.TESTFIELD("Bank Type");
                                IF NewAppEntry.COUNT > 1 THEN
                                    ERROR('Single receipt entry allowed');
                                IF NewAppEntry."Payment Mode" = NewAppEntry."Payment Mode"::Cash THEN
                                    IF NewAppEntry.Amount > BondSetup."Cash Amount Limit" THEN
                                        ERROR('You can not post receipt more than' + FORMAT(BondSetup."Cash Amount Limit"));
                            UNTIL NewAppEntry.NEXT = 0;


                        //ALLECK 020313 START

                        IF Rec."Application Type" = Rec."Application Type"::Trading THEN BEGIN  //070815
                            AmountToWords.InitTextVariable;
                            AmountToWords.FormatNoText(AmountText1, CheckPaymentAmount(Rec."Application No."), '');
                            IF CONFIRM(STRSUBSTNO(Text002, Rec.FIELDCAPTION("Application No."), Rec."Application No.",
                               GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."Shortcut Dimension 1 Code", Rec."Unit Code", Rec."Customer Name",
                               Rec."Customer No.", Rec."Associate Code", MMName, CheckPaymentAmount(Rec."Application No."), AmountText1[1], Rec."Posting Date")) THEN BEGIN
                                IF CONFIRM(Text0010) THEN BEGIN //ALLECK020313
                                    AppPayEntry.RESET;
                                    AppPayEntry.SETRANGE("Document No.", Rec."Application No.");
                                    AppPayEntry.SETRANGE(Posted, FALSE);
                                    IF AppPayEntry.FINDFIRST THEN BEGIN
                                        AppPayEntry.TESTFIELD(Amount);
                                        AppPayEntry.Posted := TRUE;
                                        AppPayEntry."Create from MSC Company" := FALSE;
                                        AppPayEntry."BarCode No." := NoSeriesMgt.GetNextNo(BondSetup."Bar Code no. Series", TODAY, TRUE);
                                        AppPayEntry.MODIFY;
                                        Rec.Status := Rec.Status::Released;
                                        Rec.MODIFY;
                                    END;
                                    ComInfo.GET;
                                    IF ComInfo."Send SMS" THEN BEGIN
                                        IF Customer.GET(Rec."Customer No.") THEN BEGIN
                                            IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                                CustMobileNo := Customer."BBG Mobile No.";
                                                CLEAR(AppPayEntry);
                                                AppPayEntry.RESET;
                                                AppPayEntry.SETRANGE("Document No.", Rec."Application No.");
                                                AppPayEntry.SETRANGE(Posted, TRUE);
                                                AppPayEntry.SETFILTER(Amount, '<>%1', 0);
                                                IF AppPayEntry.FINDLAST THEN BEGIN
                                                    IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Cash) THEN
                                                        CustSMSText :=
                                              'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to Building Blocks Family. Please find attached details ID:'
                                              + FORMAT(AppPayEntry."Posted Document No.") + 'Dt.' + FORMAT(AppPayEntry."Posting date")
                                              + 'Appl No:' + Rec."Application No." + ' ' + 'Project: ' + GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1) +
                                              'Amt. Rs.' + FORMAT(AppPayEntry.Amount) + 'Thankyou and Assuring you of Best Property Services with Building'
                                              + 'Blocks Group'
                                                    ELSE
                                                        // CustSMSText :=
                                                        //   'Mr/Mrs/Ms:' + Customer.Name+'Welcome to BBG Family. Appl No:'+"Application No." +
                                                        //   ' '+'Recvd Rs.' + FORMAT(AppPayEntry.Amount) +
                                                        //   ' '+'Project: '+GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1)+' '+'Date: '+
                                                        //   FORMAT(AppPayEntry."Posting date") + 'Tx for payment(If Chq-Subject to Realization).';

                                                        CustSMSText :=
                                  'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to Building Blocks Family. Please find attached details ID:'
                                  + FORMAT(AppPayEntry."Posted Document No.") + 'Dt.' + FORMAT(AppPayEntry."Posting date")
                                  + 'Appl No:' + Rec."Application No." + ' ' + 'Project: ' + GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1) +
                                  'Amt. Rs.' + FORMAT(AppPayEntry.Amount) + 'Thankyou and Assuring you of Best Property Services with Building'
                                  + 'Blocks Group' + 'Tx for payment(If Chq-Subject to Realization).BBGIND';

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
                                                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Customer Receipt', Rec."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."Application No.");
                                                    //ALLEDK15112022 END
                                                    COMMIT;
                                                    CustSMSText := '';
                                                    CustSMSText := 'Dear ' + Customer.Name + ', Soon you will receive a welcome call from BBG Helpdesk team. For any query, contact 040-69032244.BBG Family';//BBGIND';// 110324 added BBG family

                                                    MESSAGE('%1', CustSMSText);
                                                    //210224 Added new code
                                                    CLEAR(CheckMobileNoforSMS);
                                                    ExitMessage := CheckMobileNoforSMS.CheckMobileNo(CustMobileNo, FALSE);
                                                    IF ExitMessage THEN
                                                        PostPayment.SendSMS(CustMobileNo, CustSMSText);

                                                END;
                                            END;
                                        END;
                                    END;
                                END;
                            END;
                        END ELSE BEGIN  //070815
                            AmountToWords.InitTextVariable;
                            AmountToWords.FormatNoText(AmountText1, CheckPaymentAmount(Rec."Application No."), '');
                            IF CONFIRM(STRSUBSTNO(Text002, Rec.FIELDCAPTION("Application No."), Rec."Application No.",
                               GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."Shortcut Dimension 1 Code", Rec."Unit Code", Rec."Customer Name",
                               Rec."Customer No.", Rec."Associate Code", MMName, CheckPaymentAmount(Rec."Application No."), AmountText1[1], Rec."Posting Date")) THEN BEGIN
                                IF CONFIRM(Text0010) THEN BEGIN //ALLECK020313


                                    IF Rec."Posted Doc No." = '' THEN BEGIN
                                        Rec."Posted Doc No." := NoSeriesMgt.GetNextNo(BondSetup."Pmt Sch. Posting No. Series", WORKDATE, TRUE);
                                        COMMIT;
                                    END;

                                    NewAppEntry.RESET;
                                    NewAppEntry.SETRANGE("Document No.", Rec."Application No.");
                                    NewAppEntry.SETRANGE(Posted, FALSE);
                                    NewAppEntry.SETFILTER(NewAppEntry."Bank Type", '<>%1', NewAppEntry."Bank Type"::ProjectCompany);
                                    IF NewAppEntry.FINDLAST THEN BEGIN
                                        PostPayment.NewCreateApplicationGenJnlLine(Rec, 'Initial Payment Received');
                                    END;
                                    NewApplicationpayentry.RESET;
                                    NewApplicationpayentry.SETRANGE(NewApplicationpayentry."Document No.", Rec."Application No.");
                                    IF NewApplicationpayentry.FINDSET THEN
                                        REPEAT
                                            NewApplicationpayentry."Posted Document No." := Rec."Posted Doc No.";
                                            NewApplicationpayentry.Posted := TRUE;
                                            NewApplicationpayentry."BarCode No." := NoSeriesMgt.GetNextNo(BondSetup."Bar Code no. Series", TODAY, TRUE);
                                            NewApplicationpayentry.MODIFY;
                                        UNTIL NewApplicationpayentry.NEXT = 0;

                                    Rec.Status := Rec.Status::Released;
                                    Rec.MODIFY;
                                    CLEAR(UnitMaster);
                                    IF UnitMaster.GET(Rec."Unit Code") THEN BEGIN
                                        UnitMaster.VALIDATE(Status, UnitMaster.Status::Booked);
                                        RespCenter.RESET;
                                        IF RespCenter.GET(Rec."Shortcut Dimension 1 Code") THEN BEGIN
                                            IF RespCenter."Publish Plot Cost" THEN
                                                UnitMaster."Plot Cost" := RecUMaster."Total Value";
                                            IF RespCenter."Publish CustomerName" THEN
                                                UnitMaster."Customer Name" := Rec."Bill-to Customer Name";
                                        END;
                                        UnitMaster.MODIFY;
                                    END;
                                    MESSAGE(Text003, Rec.FIELDCAPTION("Application No."), Rec."Application No.", Rec.FIELDCAPTION("Unit No."), Rec."Unit No.");
                                    // ALLEPG 280113 Start

                                    CLEAR(RecUMaster);
                                    RecUMaster.CHANGECOMPANY(Rec."Company Name");
                                    IF RecUMaster.GET(Rec."Unit Code") THEN BEGIN
                                        RespCenter.RESET;
                                        IF RespCenter.GET(Rec."Shortcut Dimension 1 Code") THEN BEGIN
                                            IF RespCenter."Publish Plot Cost" THEN
                                                RecUMaster."Plot Cost" := RecUMaster."Total Value";
                                            IF RespCenter."Publish CustomerName" THEN
                                                RecUMaster."Customer Name" := Rec."Bill-to Customer Name";
                                            RecUMaster.MODIFY;
                                        END;
                                    END;


                                    RegionCode := '';
                                    RecJob.RESET;
                                    RecJob.CHANGECOMPANY(Rec."Company Name");
                                    IF RecJob.GET(Rec."Shortcut Dimension 1 Code") THEN;
                                    //RegionCode := RecJob."Region Code for Rank Hierarcy";  //Code commented 01072025
                                    RegionCode := Rec."Rank Code";  //Code added 01072025
                                    //050924 Code added Start
                                    Vendor_2.RESET;
                                    IF Vendor_2.GET(Rec."Associate Code") THEN
                                        IF Vendor_2."BBG Vendor Category" = Vendor_2."BBG Vendor Category"::"CP(Channel Partner)" THEN
                                            RegionCode := Vendor_2."Sub Vendor Category";
                                    // RegionCode := 'R0003';
                                    //050924 Code added END


                                    unitpost.OnAppInsertTeamHierarcy(Rec, RegionCode);

                                    ComInfo.GET;
                                    IF ComInfo."Send SMS" THEN BEGIN
                                        IF Customer.GET(Rec."Customer No.") THEN BEGIN
                                            IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                                CustMobileNo := Customer."BBG Mobile No.";
                                                CLEAR(AppPayEntry);
                                                AppPayEntry.RESET;
                                                AppPayEntry.SETRANGE("Document No.", Rec."Application No.");
                                                AppPayEntry.SETRANGE(Posted, TRUE);
                                                IF AppPayEntry.FINDLAST THEN BEGIN
                                                    IF (AppPayEntry.Amount <> 0) THEN BEGIN
                                                        IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Cash) THEN
                                                            CustSMSText :=
                                                            'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to BBG Family. Appl No:' + Rec."Application No." + ' ' +
                                                            'Recvd Rs.' + FORMAT(AppPayEntry.Amount) +
                                                            ' ' + 'Project: ' + GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' +
                                                            FORMAT(AppPayEntry."Posting date") + '.BBGIND'
                                                        ELSE
                                                            CustSMSText :=
                                                            'Mr/Mrs/Ms:' + Customer.Name + 'Welcome to BBG Family. Appl No:' + Rec."Application No." +
                                                            ' ' + 'Recvd Rs.' + FORMAT(AppPayEntry.Amount) +
                                                            ' ' + 'Project: ' + GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1) + ' ' + 'Date: ' +
                                                            FORMAT(AppPayEntry."Posting date") + 'Tx for payment(If Chq-Subject to Realization).BBGIND';

                                                        MESSAGE('%1', CustSMSText);
                                                        PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                                        SmsMessage := '';
                                                        SmsMessage1 := '';
                                                        SmsMessage := COPYSTR(CustSMSText, 1, 250);
                                                        SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                                                        SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Customer Receipt', Rec."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), Rec."Application No.");
                                                        COMMIT;
                                                        CustSMSText := '';
                                                        CustSMSText := 'Dear ' + Customer.Name + ', Soon you will receive a welcome call from BBG Helpdesk team. For any query, contact 040-69032244.BBG Family';//BBGIND'; 110324 added BBG family
                                                        MESSAGE('%1', CustSMSText);


                                                        PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                                        CLEAR(SMSLogDetails);


                                                    END;
                                                END;
                                            END
                                            ELSE
                                                MESSAGE('%1', 'Mobile No. not Found');
                                        END;
                                    END;
                                    // ALLEPG 280113 End
                                    //080221 >>
                                    ComInfo.GET;
                                    IF ComInfo."Send Welcome Customer Letter" THEN BEGIN
                                        CLEAR(SendEmailtoCustomer);
                                        SendEmailtoCustomer.CustomerWelcomLetter(Rec."Customer No.");
                                    END;
                                    //080221  <<
                                END;
                            END;
                        END; //070815

                        WebAppService.UpdateUnitStatus(UnitMaster);  //210624
                    end;
                }
                action("Create Confirmed Order")
                {
                    Caption = 'Create Confirmed Order';
                    Image = CreateForm;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        PaymentPlanDtl: Record "Payment Plan Details";
                        APmtEntry_1: Record "Application Payment Entry";
                        NewAPmtEntry_1: Record "NewApplication Payment Entry";
                        DelApplication: Record Application;
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Released);
                        IF Rec."Application Type" = Rec."Application Type"::Trading THEN BEGIN
                            CreateApplicationInTrading(Rec);
                        END;
                        CreateBond.NewCreateBondfromApplication(Rec);

                        IF Rec."Application Type" = Rec."Application Type"::"Non Trading" THEN BEGIN
                            PaymentPlanDtl.RESET;
                            PaymentPlanDtl.SETRANGE("Document No.", Rec."Application No.");
                            PaymentPlanDtl.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
                            IF PaymentPlanDtl.FINDSET THEN
                                REPEAT
                                    PaymentPlanDtl.DELETE;
                                UNTIL PaymentPlanDtl.NEXT = 0;
                        END;

                        CreateUnitLifeCycle; //040919

                        APmtEntry_1.RESET;
                        APmtEntry_1.SETRANGE("Document No.", Rec."Application No.");
                        IF APmtEntry_1.FINDFIRST THEN BEGIN
                            NewAPmtEntry_1.RESET;
                            NewAPmtEntry_1.SETRANGE("Document No.", Rec."Application No.");
                            IF NewAPmtEntry_1.FINDFIRST THEN BEGIN
                                NewAPmtEntry_1."Posted Document No." := APmtEntry_1."Posted Document No.";
                                NewAPmtEntry_1.MODIFY;
                            END;
                        END;

                        DelApplication.RESET;
                        DelApplication.SETRANGE("Application No.", Rec."Application No.");
                        IF DelApplication.FINDFIRST THEN
                            DelApplication.DELETE;

                        Rec.DELETE;


                        MESSAGE('%1', 'Application has been Confirmed');
                    end;
                }
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page Navigate;
                Visible = false;

                trigger OnAction()
                begin
                    CurrPage.PaymentsSubform.PAGE.NavigateEntry;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //BBG1.3 201213
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETRANGE("Role ID", 'A_DELETEAPP');
        IF NOT MemberOf.FINDFIRST THEN
            Rec.SETRANGE("User Id", USERID);
        //BBG1.3 201213
        /*//050112
        IF Duration <> 0 THEN
          BondDuration := GetDescription.GetBondDuration(Duration)
        ELSE
          BondDuration := 0;
        
        SchemeDescription := GetDescription.GetSchemeDesc("Scheme Code","Scheme Version No.");
        MMName := GetDescription.GetVendorName("Associate Code");
        ReceivedFromName := GetDescription.GetVendorName("Received From Code");
        SETRANGE("Application No.");
        InvestmentFrequency := 0;
        CASE "Investment Frequency" OF
          "Investment Frequency"::Monthly : InvestmentFrequency := 1;
          "Investment Frequency"::Quarterly : InvestmentFrequency := 3;
          "Investment Frequency"::"Half Yearly" : InvestmentFrequency := 6;
          "Investment Frequency"::Annually : InvestmentFrequency := 12;
        END;
        
        ReturnFrequency := 0;
        CASE "Return Frequency" OF
          "Return Frequency"::Monthly : ReturnFrequency := 1;
          "Return Frequency"::Quarterly : ReturnFrequency := 3;
          "Return Frequency"::"Half Yearly" : ReturnFrequency := 6;
          "Return Frequency"::Annually : ReturnFrequency := 12;
        END;
        
        */  //050112
        //ALLETDK >>
        IF Rec."Unit Code" <> '' THEN
            ShortcutDimension1CodeEditable := FALSE
        ELSE
            ShortcutDimension1CodeEditable := TRUE;
        //ALLETDK <<

    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TESTFIELD(Rec.Status, Rec.Status::Open);
    end;

    trigger OnInit()
    begin
        "Branch NameEditable" := TRUE;
        "Bank Account No.Editable" := TRUE;
        "Customer No.Editable" := TRUE;
        "Application No.Editable" := TRUE;
        "Received From CodeEditable" := TRUE;
        "Associate CodeEditable" := TRUE;
        ShortcutDimension1CodeEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SchemeDescription := '';
        MMName := '';
        ReturnFrequency := 0;
        InvestmentFrequency := 0;

        Rec.Type := Rec.Type::Normal;
    end;

    trigger OnOpenPage()
    var
        GetDescription: Codeunit GetDescription;
    begin
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
        Companywise.RESET;
        Companywise.SETRANGE(Companywise."MSC Company", TRUE);
        IF Companywise.FINDFIRST THEN
            IF COMPANYNAME <> Companywise."Company Code" THEN
                ERROR('This page will open in -' + Companywise."Company Code");


        IF USERID <> '1005' THEN BEGIN
            MemberOf.RESET;
            MemberOf.SETRANGE("User Name", USERID);
            MemberOf.SETRANGE("Role ID", 'A_DELETEAPP');
            IF NOT MemberOf.FINDFIRST THEN BEGIN
                UserSetup.GET(USERID);
                Rec.SETRANGE("User Id", USERID);
                Rec.FILTERGROUP(10);
                Rec.FILTERGROUP(0);
            END ELSE BEGIN
                Rec.FILTERGROUP(0);
            END;
        END;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // ALLEPG 310812 Start
        IF (Rec."Unit Code" <> '') AND (Rec."Associate Code" = '') THEN
            ERROR('Please select Associate Code');
        // ALLEPG 310812 End
    end;

    var
        Application: Record "New Application Booking";
        ReleaseBondApplication: Codeunit "Release Unit Application";
        DueAmount: Decimal;
        UserSetup: Record "User Setup";
        SchemeDescription: Text[50];
        MMName: Text[50];
        GetDescription: Codeunit GetDescription;
        Text001: Label '%1 or %2 must be entered.';
        PostPayment: Codeunit PostPayment;
        Mode: Boolean;
        CallForChqClear: Boolean;
        ChequeClearring: Boolean;
        BondPost: Codeunit "Unit Post";
        CashDispute: Boolean;
        Text002: Label 'Please verify the details below and confirm. Do you want to post ? %1    :%2\Project Name       :%3  Project Code :%4\Unit No.               :%5\Customer Name   :%6-%7\Associate Code    :%8-%9 \Receiving Amount: %10 \Amount in Words : %11 \Posting Date        : %12.';
        InvestmentFrequency: Option " ","1",,"3",,,"6",,,,,,"12";
        ReturnFrequency: Option " ","1",,"3",,,"6",,,,,,"12";
        BondDuration: Option " ","36","60","72","75","84","120","300";
        ReceivedFromName: Text[50];
        CounterName: Text[50];
        Text003: Label '%1 %2 has been released.\%3 %4 has been assigned.';
        Text004: Label 'Do you want to manually create the %1 %2 ?';
        Text005: Label '%1 %2 already exists.';
        Text006: Label '%1 %2 has been created.';
        Text007: Label 'The status of the Unit is Open.';
        Text008: Label 'Are you sure want to reverse Application %1 ?';
        BondpaymentEntry: Record "Unit Payment Entry";
        LineNo: Integer;
        BondSetup: Record "Unit Setup";
        TotalApplAmt: Decimal;
        TotalRcvdAmt: Decimal;
        ExcessAmount: Decimal;
        RecAPP: Record "New Application Booking";
        APPEntry: Record "NewApplication Payment Entry";
        Vendor: Record Vendor;
        CreateConfirmedOrder: Codeunit "Unit and Comm. Creation Job";
        ConfOrder: Record "Confirmed Order";
        ApplicationPayEntry: Record "NewApplication Payment Entry";
        CreatUPEntryfromApplication: Codeunit "Creat UPEry from ConfOrder/APP";
        Bond: Record "New Confirmed Order";
        AppLication2: Record "New Application Booking";
        ConfReport: Report "Member Receipt_Application";
        AppPaymentEntry: Record "NewApplication Payment Entry";
        Customer: Record Customer;
        CustMobileNo: Text[30];
        CustSMSText: Text[700];
        CashAmt: Decimal;
        ChequeAmt: Decimal;
        NetBankingAmt: Decimal;
        AppPayEntry: Record "NewApplication Payment Entry";
        Flag: Boolean;
        Text009: Label 'Do you want to create a Confirmed Order ?';
        Text0010: Label 'Are you sure to post the entries?';
        AmountToWords: Codeunit "Amount To Words";
        AmountText1: array[2] of Text[300];
        Cust: Record Customer;
        GJCLine: Codeunit "Gen. Jnl.-Check Line";
        Text0011: Label 'is not within your range of allowed posting dates';
        unitpost: Codeunit "Unit Post";
        ComInfo: Record "Company Information";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CreateBond: Codeunit "Unit and Comm. Creation Job";
        NewUnitMaster: Record "Unit Master";
        NewAppEntry: Record "NewApplication Payment Entry";
        RegionCode: Code[10];
        RecJob: Record Job;
        UnitMaster: Record "Unit Master";
        NewUnitMaster1: Record "Unit Master";
        RecUMaster: Record "Unit Master";
        RespCenter: Record "Responsibility Center 1";
        NewValue: Text[50];
        RecCustList: Page "Customer List"; //22;
        RecCust: Record Customer;
        Text50001: Label '*@%1*';

        ShortcutDimension1CodeEditable: Boolean;

        "Investment AmountEditable": Boolean;

        "Associate CodeEditable": Boolean;

        "Received From CodeEditable": Boolean;

        "Application No.Editable": Boolean;

        "Customer No.Editable": Boolean;

        "Bank Account No.Editable": Boolean;

        "Branch NameEditable": Boolean;
        MemberOf: Record "Access Control";
        Companywise: Record "Company wise G/L Account";
        SendReceiptSMS: Codeunit "Send Receipt SMS";
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";
        ExitMessage: Boolean;
        WebAppService: Codeunit "Web App Service";
        BBGSetups: Record "BBG Setups";
        NewAppBooking: Record "New Application Booking";

    local procedure UpdateApplicationInfo()
    begin
        Rec.CALCFIELDS("Amount Received");
    end;

    local procedure UpdateControls()
    begin
        IF Rec.Status = Rec.Status::Open THEN
            Mode := TRUE
        ELSE
            Mode := FALSE;

        IF ChequeClearring THEN
            Mode := FALSE;

        "Associate CodeEditable" := Mode;
        "Received From CodeEditable" := Mode;
        "Investment AmountEditable" := Mode;
        "Application No.Editable" := Mode;
        //CurrPAGE."Customer Name".EDITABLE(Mode);
        "Customer No.Editable" := Mode;
        "Bank Account No.Editable" := Mode;
        "Branch NameEditable" := Mode;

        IF Rec.Status = Rec.Status::Open THEN BEGIN
            IF Rec."Investment Type" = Rec."Investment Type"::" " THEN BEGIN
                "Investment AmountEditable" := FALSE;
                Rec."Return Amount" := 0;
                Rec."Investment Frequency" := Rec."Investment Frequency"::" ";
                Rec."Return Payment Mode" := Rec."Return Payment Mode"::" ";
                Rec."Return Frequency" := Rec."Return Frequency"::" ";
                Rec."Return Amount" := 0;
            END ELSE IF Rec."Investment Type" = Rec."Investment Type"::RD THEN BEGIN
                "Investment AmountEditable" := TRUE;
                Rec."Return Payment Mode" := Rec."Return Payment Mode"::" ";
                Rec."Return Frequency" := Rec."Return Frequency"::" ";
                Rec."Return Amount" := 0;
            END ELSE IF Rec."Investment Type" = Rec."Investment Type"::FD THEN BEGIN
                IF Rec."Return Payment Mode" = Rec."Return Payment Mode"::" " THEN
                    Rec."Return Payment Mode" := Rec."Return Payment Mode"::Cash;
                Rec."Investment Frequency" := Rec."Investment Frequency"::" ";
                "Investment AmountEditable" := TRUE;
            END ELSE IF Rec."Investment Type" = Rec."Investment Type"::MIS THEN BEGIN
                "Investment AmountEditable" := TRUE;
                Rec."Investment Frequency" := Rec."Investment Frequency"::" ";
                IF Rec."Return Payment Mode" = Rec."Return Payment Mode"::" " THEN
                    Rec."Return Payment Mode" := Rec."Return Payment Mode"::Cash;
            END;
        END;

        IF Rec.Duration <> 0 THEN
            BondDuration := GetDescription.GetBondDuration(Rec.Duration)
        ELSE
            BondDuration := 0;

        //CurrPAGE.PaymentsSubPAGE.PAGE.UpdateForm; ALLEDK 210113
        //CurrPAGE.PaymentsSubPAGE.PAGE.UPDATECONTROLS; ALLEDK 210113
    end;


    procedure InsertRec()
    var
    //WScript: Automation;
    begin
        // ALLE MM Code Commented
        /*
        CREATE(WScript);
        WScript.SendKeys('{F3}');
        */
        // ALLE MM Code Commented

    end;


    procedure BankDetail()
    var
        CustomerBankAccount: Record "Customer Bank Account";
        BankCode: Code[20];
    begin
    end;


    procedure Navigate()
    begin
        //Cashier.Navigate("Posted Doc No.");
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


    procedure UpdatePAGE()
    begin
    end;


    procedure CheckPaymentAmount(DocumentNo: Code[20]) PayAmount: Decimal
    var
        ApplPayEntry: Record "NewApplication Payment Entry";
    begin
        ApplPayEntry.RESET;
        ApplPayEntry.SETRANGE("Document Type", ApplPayEntry."Document Type"::Application);
        ApplPayEntry.SETRANGE("Document No.", Rec."Application No.");
        ApplPayEntry.SETRANGE(Posted, FALSE);
        IF ApplPayEntry.FINDSET THEN
            REPEAT
                PayAmount += ApplPayEntry.Amount;
            UNTIL ApplPayEntry.NEXT = 0;
    end;


    procedure CreateApplicationInTrading(NewApplicationBook_1: Record "New Application Booking")
    var
        NewAppEntry_1: Record "NewApplication Payment Entry";
        LocalApplication: Record Application;
        AppEntry_1: Record "Application Payment Entry";
        AppRecord: Record Application;
        CompanywiseGL: Record "Company wise G/L Account";
        ExistsApp: Record Application;
        ExistAppPayentry: Record "Application Payment Entry";
        PaymentPlanDet_1: Record "Payment Plan Details";
        ExistApplication: Boolean;
    begin
        NewAppEntry_1.RESET;
        NewAppEntry_1.SETRANGE("Document No.", NewApplicationBook_1."Application No.");
        NewAppEntry_1.SETRANGE("Receipt post on InterComp", FALSE);
        IF NewAppEntry_1.FINDFIRST THEN BEGIN
            ExistApplication := FALSE;
            ExistsApp.RESET;
            ExistsApp.SETRANGE("Application No.", NewApplicationBook_1."Application No.");
            IF NOT ExistsApp.FINDFIRST THEN BEGIN
                PaymentPlanDet_1.RESET;
                PaymentPlanDet_1.SETRANGE("Document No.", NewApplicationBook_1."Application No.");
                IF PaymentPlanDet_1.FINDSET THEN
                    REPEAT
                        PaymentPlanDet_1.DELETE;
                    UNTIL PaymentPlanDet_1.NEXT = 0;
                LocalApplication.INIT;
                LocalApplication."Application No." := NewApplicationBook_1."Application No.";
                LocalApplication."Investment Type" := LocalApplication."Investment Type"::FD;
                LocalApplication.INSERT;
                LocalApplication.VALIDATE(Type, NewApplicationBook_1.Type);
                LocalApplication."Application Type" := LocalApplication."Application Type"::Trading;
                LocalApplication.VALIDATE("Shortcut Dimension 1 Code", NewApplicationBook_1."Shortcut Dimension 1 Code");
                LocalApplication.VALIDATE("Customer No.", NewApplicationBook_1."Customer No.");
                LocalApplication.VALIDATE("Posting Date", NewApplicationBook_1."Posting Date");
                LocalApplication.VALIDATE("Document Date", NewApplicationBook_1."Document Date");
                LocalApplication.VALIDATE("Associate Code", NewApplicationBook_1."Associate Code");
                LocalApplication.VALIDATE("Unit Payment Plan", NewApplicationBook_1."Unit Payment Plan");
                LocalApplication.VALIDATE("Unit Code", NewApplicationBook_1."Unit Code");
                CompanywiseGL.RESET;
                CompanywiseGL.SETRANGE("MSC Company", TRUE);
                IF CompanywiseGL.FINDFIRST THEN
                    LocalApplication."Company Name" := CompanywiseGL."Company Code";
                LocalApplication."User ID" := NewApplicationBook_1."User Id";
                LocalApplication."Registration Bonus Hold(BSP2)" := TRUE;
                LocalApplication.MODIFY;
                ExistApplication := TRUE;
            END;

            ExistAppPayentry.RESET;
            ExistAppPayentry.SETRANGE("Document No.", NewAppEntry_1."Document No.");
            ExistAppPayentry.SETRANGE("Line No.", NewAppEntry_1."Line No.");
            IF NOT ExistAppPayentry.FINDFIRST THEN BEGIN
                CLEAR(AppEntry_1);
                AppEntry_1.RESET;
                AppEntry_1.INIT;
                AppEntry_1."Document Type" := AppEntry_1."Document Type"::Application;
                AppEntry_1."Document No." := LocalApplication."Application No.";
                AppEntry_1."Line No." := NewAppEntry_1."Line No.";
                AppEntry_1.Type := AppEntry_1.Type::Received;
                AppEntry_1.INSERT;
                AppEntry_1.VALIDATE("Payment Mode", NewAppEntry_1."Payment Mode");
                AppEntry_1."Payment Method" := NewAppEntry_1."Payment Method";
                AppEntry_1.Description := NewAppEntry_1.Description;
                AppEntry_1."Cheque No./ Transaction No." := NewAppEntry_1."Cheque No./ Transaction No.";
                AppEntry_1."Cheque Date" := NewAppEntry_1."Cheque Date";
                AppEntry_1."Cheque Bank and Branch" := NewAppEntry_1."Cheque Bank and Branch";
                AppEntry_1."Deposit/Paid Bank" := NewAppEntry_1."Deposit/Paid Bank";
                AppEntry_1."User Branch Code" := NewAppEntry_1."User Branch Code";
                AppEntry_1.VALIDATE(Amount, NewAppEntry_1.Amount);
                AppEntry_1.VALIDATE("Posting date", NewAppEntry_1."Posting date");
                AppEntry_1.VALIDATE("Document Date", NewAppEntry_1."Posting date");
                AppEntry_1.VALIDATE("Shortcut Dimension 1 Code", NewAppEntry_1."Shortcut Dimension 1 Code");
                AppEntry_1."MSC Post Doc. No." := NewAppEntry_1."Posted Document No.";
                AppEntry_1."Reverse Commission" := NewAppEntry_1."Commmission Reverse";
                AppEntry_1."Application No." := NewAppEntry_1."Document No.";
                AppEntry_1."Bank Type" := NewAppEntry_1."Bank Type";
                AppEntry_1."Commission Reversed" := NewAppEntry_1."Commmission Reverse";  //ALLE240415
                AppEntry_1."User ID" := NewAppEntry_1."User ID";
                AppEntry_1."Entry From MSC" := TRUE;
                AppEntry_1.Narration := NewAppEntry_1.Narration;
                AppEntry_1."Receipt Line No." := NewAppEntry_1."Line No."; //ALLEDK 10112016
                AppEntry_1.MODIFY;
            END;
            IF ExistApplication THEN BEGIN
                CreatUPEntryfromApplication.CreateUPEntryfromApplication(LocalApplication);
                ReleaseBondApplication.ReleaseApplication(LocalApplication, FALSE);
                AppRecord.CreateConOrder(LocalApplication);
            END ELSE BEGIN
                CreatUPEntryfromApplication.CreateUPEntryfromApplication(ExistsApp);
                ReleaseBondApplication.ReleaseApplication(ExistsApp, FALSE);
                AppRecord.CreateConOrder(ExistsApp);

            END;
            NewAppEntry_1."Receipt post on InterComp" := TRUE;
            NewAppEntry_1."Receipt post InterComp Date" := TODAY;
            NewAppEntry_1.MODIFY;
        END;
    end;

    local procedure InvestmentAmountC1000000035OnA()
    begin
        UpdateControls;
    end;

    local procedure CreateUnitLifeCycle()
    var
        UnitLifeCycle: Record "Unit Life Cycle";
        OldUnitLifeCycle: Record "Unit Life Cycle";
        LineNo: Integer;
        ExistUnitLifeCycle: Record "Unit Life Cycle";
        UnitMaster_1: Record "Unit Master";
    begin
        LineNo := 0;
        OldUnitLifeCycle.RESET;
        OldUnitLifeCycle.SETRANGE("Unit Code", Rec."Unit Code");
        IF OldUnitLifeCycle.FINDLAST THEN
            LineNo := OldUnitLifeCycle."Line No.";

        UnitLifeCycle.INIT;
        UnitLifeCycle.TRANSFERFIELDS(OldUnitLifeCycle);
        UnitLifeCycle."Unit Code" := Rec."Unit Code";
        UnitLifeCycle."Line No." := LineNo + 1;
        UnitLifeCycle."Unit Allocation Date" := TODAY;
        UnitLifeCycle."Unit Allocation Time" := TIME;
        UnitLifeCycle."Unit Payment Plan" := Rec."Unit Payment Plan";
        IF UnitMaster_1.GET(Rec."Unit Code") THEN
            UnitLifeCycle."Unit Cost" := UnitMaster_1."Total Value";
        UnitLifeCycle."Application Unit Cost" := Rec."Investment Amount";
        UnitLifeCycle."Type of Transaction" := UnitLifeCycle."Type of Transaction"::"Unit Assigned";
        UnitLifeCycle.INSERT;
    end;
}

