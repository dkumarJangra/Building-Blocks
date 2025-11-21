page 97889 Application
{
    // //ALLECK 220612 : Code Commented For "Investment Type", "Bond Duration", "Return Frequency","Investment Frequency",
    //                   "Service Charge Amount",Return "Interest Amount","Maturity Bonus Amount"
    // 
    // //ALLEDK 251212 Create confirmed order after application print
    // ALLEPG 280113 : Code added for SMS integration

    PageType = Card;
    SourceTable = Application;
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
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Type; Rec.Type)
                {
                    Caption = 'Booking Type';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Project Code';
                    Editable = ShortcutDimension1CodeEditable;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Member No.';
                    Editable = "Customer No.Editable";

                    trigger OnValidate()
                    begin
                        IF Rec."Bill-to Customer Name" = '' THEN BEGIN
                            IF Rec."Customer No." <> '' THEN
                                IF Cust.GET(Rec."Customer No.") THEN
                                    Rec."Bill-to Customer Name" := Cust.Name;
                        END;
                    end;
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Caption = 'IBA Code';
                    Editable = "Associate CodeEditable";

                    trigger OnValidate()
                    begin
                        MMName := GetDescription.GetVendorName(Rec."Associate Code");
                        InvestmentFrequency := 0;
                        ReturnFrequency := 0;
                    end;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        //ALLETDK >>
                        IF Rec."Unit Code" <> '' THEN
                            ShortcutDimension1CodeEditable := FALSE
                        ELSE
                            ShortcutDimension1CodeEditable := TRUE;
                        //ALLETDK <<
                    end;
                }
                field("E-mail"; Rec."E-mail")
                {
                }
                field("Pass Book No."; Rec."Pass Book No.")
                {
                }
                field("User ID"; Rec."User ID")
                {
                    Caption = 'USER ID';
                    Editable = false;
                }
                field("GetDescription.GetDimensionName(Shortcut Dimension 1 Code1)";
                GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1))
                {
                    Caption = 'Project Name';
                    DrillDown = false;
                    Editable = false;
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                    Caption = 'Member Name';
                    Editable = true;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(MMName; MMName)
                {
                    Caption = 'IBA Name';
                    DrillDown = false;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Member's D.O.B"; Rec."Member's D.O.B")
                {
                }
            }
            group("&General")
            {
                Caption = '&General';
                field("Project Type"; Rec."Project Type")
                {
                    Caption = 'Commission Code';

                    trigger OnValidate()
                    begin
                        SchemeDescription := GetDescription.GetSchemeDesc(Rec."Scheme Code", Rec."Scheme Version No.");
                        InvestmentFrequency := 0;
                        ReturnFrequency := 0;
                        UpdateControls;
                    end;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                }
                field("Scheme Code"; Rec."Scheme Code")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        SchemeCodeOnAfterValidate;
                    end;
                }
                label("3")
                {
                    CaptionClass = FORMAT(SchemeDescription);
                    //DrillDown = false;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                    Caption = 'Amount Receipt(P)';
                }
                field("Investment Amount"; Rec."Investment Amount")
                {
                    Caption = 'Total Unit Value';
                    Editable = "Investment AmountEditable";
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        InvestmentAmountC1000000035OnA;
                    end;
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
                field("&Investment Amount"; Rec."Investment Amount" + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount")
                {
                    Caption = 'Due Amount';
                }
                field("Scheme Version No."; Rec."Scheme Version No.")
                {
                    Editable = false;
                    Lookup = false;
                    Visible = false;
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
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = true;
                }
                field("Payment Plan"; Rec."Payment Plan")
                {
                    Editable = false;
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                    Editable = false;
                }
            }
            group("R&eceipts")
            {
                Caption = 'R&eceipts';
                part(PaymentsSubform; "App Payment Entry Subform")
                {
                    SubPageLink = "Document Type" = FILTER(Application),
                                  "Document No." = FIELD("Application No."),
                                  "Application No." = FIELD("Application No."),
                                  Type = CONST(Received);
                }
            }
            field("Father / Husband Name"; Rec."Father / Husband Name")
            {
            }
            field("Mobile No."; Rec."Mobile No.")
            {
            }
            group("Application Information")
            {
                Caption = 'Application Information';
                field(Status; Rec.Status)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("GetDescription.GetDimensionName(Shortcut Dimension 2 Code2)";
                GetDescription.GetDimensionName(Rec."Shortcut Dimension 2 Code", 2))
                {
                    DrillDown = false;
                    Editable = false;
                }
                field("Posted Doc No."; Rec."Posted Doc No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
            }
            group("&History")
            {
                Caption = '&History';
                part("4"; "Application History Subform")
                {
                    Editable = false;
                    SubPageLink = "Unit No." = FIELD("Unit No.");
                }
            }
            group("&Comments")
            {
                Caption = '&Comments';
                part("1"; "Unit Comment Sheet")
                {
                    SubPageLink = "Table Name" = FILTER("Activity Master"),
                                  "No." = FIELD("Application No.");
                }
            }
            group("P&rint Log")
            {
                Caption = 'P&rint Log';
                part("2"; "Unit Print Log Subform")
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
                    RunObject = Page "Payment Terms Line Sale";
                    RunPageLink = "Document No." = FIELD("Application No."),
                                  "Transaction Type" = CONST(Sale);
                }
                action("Payment Plan Details")
                {
                    Caption = 'Payment Plan Details';
                    RunObject = Page "Payment Plan Details Master";
                    RunPageLink = "Document No." = FIELD("Application No."),
                                  "Project Code" = FIELD("Shortcut Dimension 1 Code");
                }

                action("Applicable Charges")
                {
                    Caption = 'Applicable Charges';
                    RunObject = Page "Charge Type Applicable";
                    RunPageLink = "Project Code" = FIELD("Shortcut Dimension 1 Code"),
                                  "Document No." = FIELD("Application No.");
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
                        /*
                        IF Status <> Status::Open THEN BEGIN
                          Application := Rec;
                          Application.SETRECFILTER;
                          CLEAR(ConfReport);
                          AppPaymentEntry.RESET;
                          AppPaymentEntry.SETRANGE("Document No.","Application No.");
                          IF AppPaymentEntry.FINDLAST THEN BEGIN
                        //    ConfReport.SetPostFilter("Application No.",AppPaymentEntry."Posted Document No.");
                            ConfReport.RUN;
                          END;
                          Application.RESET;
                        END ELSE
                          ERROR('Application must be Release');
                          */

                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        InvestmentType: Integer;
                    begin
                        /*
                        PLDetails.RESET;
                        PLDetails.SETRANGE("Document No.","Application No.");
                        IF NOT PLDetails.FINDFIRST THEN
                          ERROR('Please define the Payment Plan Detail');
                        
                        PTSLine.RESET;
                        PTSLine.SETRANGE("Document No.","Application No.");
                        IF NOT PTSLine.FINDFIRST THEN
                          ERROR('Please define the Payment Milestone');
                        
                        
                        
                        
                        //BBG2.00 310714
                        AppPayEntry.RESET;
                        AppPayEntry.SETRANGE("Document No.","Application No.");
                        AppPayEntry.SETRANGE(Posted,FALSE);
                        AppPayEntry.SETRANGE(Amount,0);
                        IF AppPayEntry.FINDFIRST THEN
                          AppPayEntry.DELETE;
                        //BBG2.00 310714
                        
                        
                        
                        //ALLECK 060313 START
                        Memberof.SETRANGE(Memberof."User ID",USERID);
                        Memberof.SETRANGE(Memberof."Role ID",'A_APPPOSTING');
                        IF NOT Memberof.FINDFIRST THEN
                          ERROR('You do not have permission of role  :A_APPPOSTING');
                        //ALLECK 060313 End
                        
                        
                        TESTFIELD(Status,Status::Open);
                        BondSetup.GET;
                        TESTFIELD("Payment Plan");
                        IF "Customer No." = '' THEN
                          VALIDATE("Customer No.",CreateCustomer("Customer Name"));
                        //InsertSMSText(Rec);  // ALLEPG
                        //ALLETDK081112..BEGIN
                        IF CheckExcessAmount(Rec) THEN BEGIN
                          IF CONFIRM('Do you want to post with the Excess Amount: %1',FALSE,ExcessAmount) THEN
                            CreateExcessPaymentTermsLine
                          ELSE
                            ERROR('Check the Excess Amount: %1',ExcessAmount);
                        END;
                        //ALLETDK081112..END;
                        
                        //SplitBondPaymentEntries; //ALLETDK081112
                        IF ("Customer Name" = '') AND ("Customer No." = '') THEN BEGIN
                          CurrPAGE."Bill-to Customer Name".ACTIVATE;
                          ERROR(Text001,FIELDCAPTION("Bill-to Customer Name"),FIELDCAPTION("Customer No."));
                        END;
                        
                        
                        //ALLECK 020313 START
                        
                        AmountToWords.InitTextVariable;
                        AmountToWords.FormatNoText(AmountText1,CheckPaymentAmount("Application No."),'');
                        IF CONFIRM(STRSUBSTNO(Text002,FIELDCAPTION("Application No."),"Application No.",
                           GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1),"Shortcut Dimension 1 Code","Unit Code","Customer Name",
                           "Customer No.","Associate Code",MMName,CheckPaymentAmount("Application No."),AmountText1[1],"Posting Date")) THEN BEGIN
                           IF CONFIRM(Text0010) THEN BEGIN //ALLECK020313
                        
                           CreatUPEntryfromApplication.CreateUPEntryfromApplication(Rec); //200113
                         // SplitBondPaymentEntries; //ALLDK 200113
                          ReleaseBondApplication.ReleaseApplication(Rec,FALSE);     //061214 added new parameter
                        
                          MESSAGE(Text003,FIELDCAPTION("Application No."),"Application No.",FIELDCAPTION("Unit No."),"Unit No.");
                          // ALLEPG 280113 Start
                          ComInfo.GET;
                        IF ComInfo."Send SMS" THEN BEGIN
                          IF Customer.GET("Customer No.") THEN BEGIN
                            IF Customer."Mobile No." <>'' THEN BEGIN
                            CustMobileNo := Customer."Mobile No.";
                            CLEAR(AppPayEntry);
                            AppPayEntry.RESET;
                            AppPayEntry.SETRANGE("Document No.","Application No.");
                            AppPayEntry.SETRANGE(Posted,TRUE);
                            IF AppPayEntry.FINDLAST THEN BEGIN
                                IF (AppPayEntry.Amount <> 0) THEN BEGIN
                                  IF (AppPayEntry."Payment Mode" = AppPayEntry."Payment Mode"::Cash) THEN
                                    CustSMSText :=
                                    'Mr/Mrs/Ms:' + Customer.Name+'Welcome to BBG Family. Appl No:'+ "Application No." +' '+
                                    'Recvd Rs.' + FORMAT(AppPayEntry.Amount) +
                                    ' '+'Project: '+GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1)+' '+'Date: '+
                                    FORMAT(AppPayEntry."Posting date")
                              ELSE
                                    CustSMSText :=
                                    'Mr/Mrs/Ms:' + Customer.Name+'Welcome to BBG Family. Appl No:'+"Application No." +
                                    ' '+'Recvd Rs.' + FORMAT(AppPayEntry.Amount) +
                                    ' '+'Project: '+GetDescription.GetDimensionName("Shortcut Dimension 1 Code",1)+' '+'Date: '+
                                    FORMAT(AppPayEntry."Posting date") + 'Tx for payment(If Chq-Subject to Realization).';
                        
                            MESSAGE('%1',CustSMSText);
                                  PostPayment.SendSMS(CustMobileNo,CustSMSText);
                               END;
                              END;
                            END
                               ELSE
                                MESSAGE('%1','Mobile No. not Found');
                          END;
                        END;
                          // ALLEPG 280113 End
                        END;
                        END;
                         */
                        //ERROR('Post this receipt to Batch');

                        Rec.ReleaseRcpt(Rec);

                    end;
                }
                action("&Create Unit")
                {
                    Caption = '&Create Unit';
                    ShortCutKey = 'Ctrl+F10';
                    Visible = false;

                    trigger OnAction()
                    var
                        Bond: Record "Confirmed Order";
                        BondCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
                        BondCommCreation: Codeunit "Unit and Comm. Creation Job";
                    begin
                        Rec.TESTFIELD("Investment Type", Rec."Investment Type"::RD);
                        IF CONFIRM(Text004, FALSE, Rec.FIELDCAPTION("Unit No."), Rec."Unit No.") THEN BEGIN
                            Rec.TESTFIELD(Status, Rec.Status::Printed);
                            Rec.TESTFIELD("Unit No.");
                            Rec.TESTFIELD("With Cheque", FALSE);
                            IF Bond.GET(Rec."Unit No.") THEN
                                ERROR(Text005, Rec.FIELDCAPTION("Unit No."), Rec."Unit No.");
                            //IF ("With Cheque") THEN
                            //  MESSAGE('Bond cannot be manually created if paid by cheque');
                            BondCommCreationBuffer.GET(Rec."Unit No.", 1);
                            IF (NOT Rec."With Cheque") THEN BEGIN
                                BondCommCreation.CreateBond(Rec, BondCommCreationBuffer, FALSE);
                                COMMIT;
                                MESSAGE(Text006, Rec.FIELDCAPTION("Unit No."), Rec."Unit No.");
                            END;
                        END;
                    end;
                }
                action(Reverse)
                {
                    Caption = 'Reverse';
                    Visible = false;

                    trigger OnAction()
                    var
                        ApplicationReverse: Codeunit "Unit Reversal";
                    begin
                        IF NOT CONFIRM(Text008, FALSE) THEN
                            EXIT;
                        IF Rec.Status = Rec.Status::Open THEN
                            ERROR(Text007);
                        ApplicationReverse.ApplicationReverse(Rec."Application No.");
                    end;
                }
                action("Suggest Payment Milestone")
                {
                    Caption = 'Suggest Payment Milestone';
                    Visible = false;

                    trigger OnAction()
                    var
                        AppPaymentEntry: Record "Application Payment Entry";
                        TempBondPaymentEntry: Record "Application Payment Entry" temporary;
                        DifferenceAmount: Decimal;
                        LoopingDifferAmount: Decimal;
                        BondPayLineAmt: Decimal;
                        TotalBondAmount: Decimal;
                    begin
                        SplitBondPaymentEntries;
                    end;
                }
                action("&Create Confirmed Order")
                {
                    Caption = '&Create Confirmed Order';
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        RespCenter: Record "Responsibility Center 1";
                        Region_RankwiseVendor: Record "Region wise Vendor";
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Released);
                        IF CONFIRM(Text009, TRUE) THEN BEGIN //ALLETDK160213
                            IF NOT Bond.GET(Rec."Application No.") THEN BEGIN
                                IF Rec.Type = Rec.Type::Normal THEN BEGIN  //230213
                                    UnitandCommCreationJob.UpdateMilestonePercentage(Rec."Application No.", TRUE);
                                    PaymentLine.RESET;
                                    PaymentLine.SETRANGE("Application No.", Rec."Application No.");
                                    IF PaymentLine.FINDSET THEN
                                        REPEAT
                                            IF NOT BondCreationBuffer.GET(Rec."Application No.", (PaymentLine."Line No." / 10000), PaymentLine.Sequence) THEN
                                                PostPayment.CreateStagingTableBondPayEntry(PaymentLine, (PaymentLine."Line No." / 10000), 1, PaymentLine.Sequence,
                                                PaymentLine."Commision Applicable", PaymentLine."Direct Associate", FALSE);
                                        UNTIL PaymentLine.NEXT = 0;


                                    // ReleaseBondApplication.InsertBondHistory("Application No.",'Application Printed.',0,"Application No.");
                                END; //230213
                                AppLication2 := Rec;
                                CreateConfirmedOrder.CreateBondfromApplication(Rec);
                                IF ConfOrder.GET(AppLication2."Application No.") THEN BEGIN

                                    //unitpost.InsertTeamHierarcy(ConfOrder);  //BBG1.00  050613
                                    IF RecJob.GET(ConfOrder."Shortcut Dimension 1 Code") THEN BEGIN
                                        Region_RankwiseVendor.RESET;
                                        Region_RankwiseVendor.SETRANGE("Region Code", RecJob."Region Code for Rank Hierarcy");
                                        Region_RankwiseVendor.SETRANGE("No.", ConfOrder."Introducer Code");
                                        IF Region_RankwiseVendor.FINDFIRST THEN
                                            unitpost.NewInsertTeamHierarcy(ConfOrder, Region_RankwiseVendor."Region Code", FALSE, FALSE);  //271114 DK01
                                    END;
                                    Rec.DELETE;
                                    MESSAGE('Confirmed Order has been created successfully');
                                END;
                            END;
                        END;
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

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //BBG1.3 201213
        //Memberof.RESET;
        //Memberof.SETRANGE("User ID",USERID);
        //Memberof.SETRANGE("Role ID",'A_DELETEAPP');
        //IF NOT Memberof.FINDFIRST THEN
        //   SETRANGE("User Id",USERID);  131214
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
        Findconforder.RESET;
        Findconforder.SETRANGE("No.", Rec."Application No.");
        IF Findconforder.FINDFIRST THEN BEGIN

        END ELSE
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
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // ALLEPG 310812 Start
        IF (Rec."Unit Code" <> '') AND (Rec."Associate Code" = '') THEN
            ERROR('Please select Associate Code');
        // ALLEPG 310812 End
    end;

    var
        Application: Record Application;
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
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        PaymentTermLines: Record "Payment Terms Line Sale";
        BondpaymentEntry: Record "Unit Payment Entry";
        LineNo: Integer;
        BondSetup: Record "Unit Setup";
        TotalApplAmt: Decimal;
        TotalRcvdAmt: Decimal;
        ExcessAmount: Decimal;
        RecAPP: Record Application;
        APPEntry: Record "Application Payment Entry";
        Vendor: Record Vendor;
        CreateConfirmedOrder: Codeunit "Unit and Comm. Creation Job";
        ConfOrder: Record "Confirmed Order";
        ApplicationPayEntry: Record "Application Payment Entry";
        CreatUPEntryfromApplication: Codeunit "Creat UPEry from ConfOrder/APP";
        Bond: Record "Confirmed Order";
        PaymentLine: Record "Unit Payment Entry";
        BondCreationBuffer: Record "Unit & Comm. Creation Buffer";
        AppLication2: Record Application;
        AppPaymentEntry: Record "Application Payment Entry";
        Customer: Record Customer;
        CustMobileNo: Text[30];
        CustSMSText: Text[300];
        CashAmt: Decimal;
        ChequeAmt: Decimal;
        NetBankingAmt: Decimal;
        AppPayEntry: Record "Application Payment Entry";
        Flag: Boolean;
        Text009: Label 'Do you want to create a Confirmed Order ?';
        Text0010: Label 'Are you sure to post the entries?';
        AmountToWords: Codeunit "Amount To Words";
        AmountText1: array[2] of Text[300];
        PLDetails: Record "Payment Plan Details";
        PTSLine: Record "Payment Terms Line Sale";
        Cust: Record Customer;
        GJCLine: Codeunit "Gen. Jnl.-Check Line";
        Text0011: Label 'is not within your range of allowed posting dates';
        unitpost: Codeunit "Unit Post";
        ComInfo: Record "Company Information";
        UnitandCommCreationJob: Codeunit "Unit and Comm. Creation Job";
        RecJob: Record Job;
        Findconforder: Record "Confirmed Order";

        ShortcutDimension1CodeEditable: Boolean;

        "Investment AmountEditable": Boolean;

        "Associate CodeEditable": Boolean;

        "Received From CodeEditable": Boolean;

        "Application No.Editable": Boolean;

        "Customer No.Editable": Boolean;

        "Bank Account No.Editable": Boolean;

        "Branch NameEditable": Boolean;

    local procedure UpdateApplicationInfo()
    begin
        Rec.CALCFIELDS("Amount Received");
        DueAmount := Rec.TotalApplicationAmount - Rec."Amount Received";
    end;

    local procedure UpdateControls()
    begin
        UpdateApplicationInfo;
        IF Rec.Status = Rec.Status::Open THEN
            Mode := TRUE
        ELSE
            Mode := FALSE;

        IF ChequeClearring THEN
            Mode := FALSE;

        //CurrPAGE.PaymentsSubForm.PAGE.ChangeEditMode(Mode,ChequeClearring);  //ALLEDK 210113
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

        //CurrPAGE.PaymentsSubform.PAGE.UpdatePAGE; ALLEDK 210113
        //CurrPAGE.PaymentsSubform.PAGE.UPDATECONTROLS; ALLEDK 210113
    end;


    procedure InsertRec()
    begin
        // ALLE MM Code Commented
        /*
        CREATE(WScript);
        WScript.SendKeys('{F3}');
        */
        // ALLE MM Code Commented

    end;


    procedure ForChequeClearance(ApplicationNo: Code[20])
    begin
        ChequeClearring := TRUE;
        Rec.FILTERGROUP(10);
        Rec.SETRANGE("Application No.", ApplicationNo);
        Rec.FILTERGROUP(0);
    end;


    procedure ForCashDispute(ApplicationNo: Code[20])
    begin
        CashDispute := TRUE;
        Rec.FILTERGROUP(10);
        Rec.SETRANGE("Application No.", ApplicationNo);
        Rec.FILTERGROUP(0);
    end;


    procedure BankDetail()
    var
        CustomerBankAccount: Record "Customer Bank Account";
        BankCode: Code[20];
    begin
    end;


    procedure Navigate()
    begin
    end;


    procedure SplitBondPaymentEntries()
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
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::Application);
        AppPaymentEntry.SETRANGE("Document No.", Rec."Application No.");
        AppPaymentEntry.SETRANGE("Explode BOM", FALSE);
        IF AppPaymentEntry.FINDSET THEN BEGIN
            AppliPaymentAmount := AppPaymentEntry.Amount;
            REPEAT
                IF AppPaymentEntry."Posting date" <> WORKDATE THEN
                    ERROR('Payment Entry Posting Date must be same as WORK DATE');
                TotalBondAmount := TotalBondAmount + AppPaymentEntry.Amount;
            UNTIL AppPaymentEntry.NEXT = 0;
        END
        ELSE
            ERROR('You need to enter the payment Lines');

        IF AppPaymentEntry.FINDSET THEN;
        GetLastLineNo(AppPaymentEntry);
        DifferenceAmount := 0;
        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", Rec."Application No.");
        IF PaymentTermLines.FIND('-') THEN
            REPEAT
                PaymentTermLines.CALCFIELDS("Received Amt");
                DifferenceAmount := PaymentTermLines."Due Amount" + PaymentTermLines."Received Amt";
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
        BPayEntry: Record "Unit Payment Entry";
    begin
        BondpaymentEntry.INIT;
        BondpaymentEntry."Document Type" := BondPaymentEntryRec."Document Type"::Application;
        BondpaymentEntry."Document No." := Rec."Application No.";
        BondpaymentEntry."Line No." := LineNo;
        LineNo := BondpaymentEntry."Line No." + 10000;
        BondpaymentEntry.VALIDATE("Unit Code", Rec."Unit Code"); //ALLETDK141112
        BondpaymentEntry.VALIDATE("Payment Mode", BondPaymentEntryRec."Payment Mode");
        BondpaymentEntry.VALIDATE("Payment Method", BondPaymentEntryRec."Payment Method");  // ALLEPG 231012
        BondpaymentEntry."Application No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Document Date" := BondPaymentEntryRec."Document Date";
        BondpaymentEntry."Posting date" := BondPaymentEntryRec."Posting date";
        BondpaymentEntry.Type := BondPaymentEntryRec.Type;
        BondpaymentEntry.Sequence := PaymentTermLines.Sequence; //ALLETDK231112
        BondpaymentEntry."Charge Code" := PaymentTermLines."Charge Code"; //ALLETDK081112
        BondpaymentEntry."Actual Milestone" := PaymentTermLines."Actual Milestone"; //ALLETDK221112
        BondpaymentEntry."Commision Applicable" := PaymentTermLines."Commision Applicable";
        BondpaymentEntry."Direct Associate" := PaymentTermLines."Direct Associate";
        BondpaymentEntry."Priority Payment" := BondPaymentEntryRec."Priority Payment";  //ALLEDK 231112
        IF BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::Bank THEN BEGIN
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
        // ALLEPG 221012 Start
        IF BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.C./C.C./Net Banking" THEN BEGIN
            BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            BondpaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            BondpaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            BondpaymentEntry.VALIDATE("Deposit/Paid Bank", BondPaymentEntryRec."Deposit/Paid Bank");
        END;
        // ALLEPG 221012 End
        BondpaymentEntry.Amount := Amt;
        UserSetup.GET(USERID);
        BondpaymentEntry."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        BondpaymentEntry."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        BondpaymentEntry."Branch Code" := BondPaymentEntryRec."User Branch Code"; //ALLETDK141112
        BondpaymentEntry."App. Pay. Entry Line No." := BondPaymentEntryRec."Line No."; //ALLETDK141112
        BondpaymentEntry."Explode BOM" := TRUE;
        BondpaymentEntry."User ID" := BondPaymentEntryRec."User ID";  //ALLEDK 2712
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


    procedure UpdatePAGE()
    begin
    end;


    procedure CheckExcessAmount(ApplicationOrder: Record Application): Boolean
    var
        RecDueAmount: Decimal;
        ApplPayEntry: Record "Application Payment Entry";
        CurrPayAmount: Decimal;
    begin
        CLEAR(RecDueAmount);
        CLEAR(ExcessAmount);
        CLEAR(CurrPayAmount);
        RecDueAmount := Rec."Investment Amount" + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount";
        IF RecDueAmount > 0 THEN BEGIN
            ApplPayEntry.RESET;
            ApplPayEntry.SETRANGE("Document Type", ApplPayEntry."Document Type"::Application);
            ApplPayEntry.SETRANGE("Document No.", Rec."Application No.");
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
        PaymentTermLines1.SETRANGE("Document No.", Rec."Application No.");
        IF PaymentTermLines1.FINDLAST THEN BEGIN
            IF PaymentTermLines1."Charge Code" <> ExcessCode THEN BEGIN
                PaymentTermLines.INIT;
                PaymentTermLines."Document Type" := PaymentTermLines1."Document Type";
                PaymentTermLines."Document No." := Rec."Application No.";
                PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
                PaymentTermLines.Sequence := INCSTR(PaymentTermLines1.Sequence); //ALLETDK231112
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


    procedure CheckPaymentAmount(DocumentNo: Code[20]) PayAmount: Decimal
    var
        ApplPayEntry: Record "Application Payment Entry";
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

    local procedure SchemeCodeOnAfterValidate()
    begin
        UpdateControls;
    end;

    local procedure InvestmentAmountC1000000035OnA()
    begin
        UpdateControls;
    end;
}

