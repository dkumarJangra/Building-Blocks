page 97812 "RA Bill"
{
    // ALLESP BCL0016 27-08-2007: New Form Created for RA Bill
    // ALLESP BCL0014 17-07-2007: Control Added Invoice->payment milestones
    // ALLESP BCL0024 06-09-2007: Added Control Approval in Order Button,Approval Status in General

    Caption = 'RA Bill';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER(Invoice),
                            "Invoice Type1" = CONST(RA));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    Caption = 'Sell-to Post Code/City';
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    Caption = 'Job No.';
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                // field(Structure; Structure)
                // {
                // }
                field("Bill Start Date"; Rec."Bill Start Date")
                {
                }
                field("Bill End Date"; Rec."Bill End Date")
                {
                }
            }
            part(SalesLines; "RA Bill Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(CustInfoPanel)
            {
                Caption = 'Customer Information';
                label("")
                {
                    CaptionClass = Text19070588;
                }
                // field("STRSUBSTNO('(%1)',SalesInfoPaneMgt.CalcNoOfShipToAddr(Sell -to Customer No.))";
                // STRSUBSTNO('(%1)', SalesInfoPaneMgt.CalcNoOfShipToAddr(Rec."Sell-to Customer No.")))
                // {
                //     Editable = false;
                // }
                // field("STRSUBSTNO('(%1)',SalesInfoPaneMgt.CalcNoOfContacts(Rec))"; STRSUBSTNO('(%1)', SalesInfoPaneMgt.CalcNoOfContacts(Rec)))
                // {
                //     Editable = false;
                // }
                label("1")
                {
                    CaptionClass = Text19069283;
                }
                // field("SalesInfoPaneMgt.CalcAvailableCredit(Bill-to Customer No.)"; SalesInfoPaneMgt.CalcAvailableCredit(Rec."Bill-to Customer No."))
                // {
                //     DecimalPlaces = 0 : 0;
                //     Editable = false;
                // }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                {
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    Caption = 'Bill-to Post Code/City';
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                }
                // field("Form Code"; "Form Code")
                // {
                // }
                // field("Form No."; "Form No.")
                // {
                // }
                // field("LC No."; "LC No.")
                // {
                // }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                }
                // field("Export or Deemed Export"; "Export or Deemed Export")
                // {
                // }
                // field("VAT Exempted"; "VAT Exempted")
                // {
                // }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code/City';
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                }
                // field("Transit Document"; "Transit Document")
                // {
                // }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                }
                field("Package Tracking No."; Rec."Package Tracking No.")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                }
                field(Trading; Rec.Trading)
                {
                }
                // field("Re-Dispatch"; "Re-Dispatch")
                // {

                //     trigger OnValidate()
                //     begin
                //         IF "Re-Dispatch" THEN
                //             ReturnOrderNoEditable := TRUE
                //         ELSE
                //             ReturnOrderNoEditable := FALSE;
                //     end;
                // }
                // field(ReturnOrderNo; "Return Re-Dispatch Rcpt. No.")
                // {
                //     Caption = 'Return Receipt No.';
                //     Editable = ReturnOrderNoEditable;
                // }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {

                    trigger OnAssistEdit()
                    begin
                        CLEAR(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            Rec.VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                }
                field("Transport Method"; Rec."Transport Method")
                {
                }
                field("Exit Point"; Rec."Exit Point")
                {
                }
                field("Area"; Rec.Area)
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
            }
            group("Advance And Retention")
            {
                Caption = 'Advance And Retention';
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                }
                field("Total Order Value"; Rec."Total Order Value")
                {
                    Editable = false;
                }
                field("Retention Amount"; Rec."Retention Amount")
                {
                    Editable = false;
                }
                field("Retention Due Date"; Rec."Retention Due Date")
                {
                }
                field("Calc Mobilization Adv"; Rec."Calc Mobilization Adv")
                {
                }
                field("Mobilization Adv Amt"; Rec."Mobilization Adv Amt")
                {
                    Editable = true;
                }
                field("Calc Equipment Adv"; Rec."Calc Equipment Adv")
                {
                }
                field("Equipment Adv Amt"; Rec."Equipment Adv Amt")
                {
                    Editable = true;
                }
                field("Calc Secured Adv"; Rec."Calc Secured Adv")
                {
                }
                field("Secured Adv Amt"; Rec."Secured Adv Amt")
                {
                    Editable = true;
                }
                field("Calc Adhoc Adv"; Rec."Calc Adhoc Adv")
                {
                }
                field("Adhoc Adv Amt"; Rec."Adhoc Adv Amt")
                {
                    Editable = true;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                field("Creation Date"; Rec."Creation Date")
                {
                    Caption = 'Creation Date &&Time';
                    Editable = false;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    Editable = false;
                }
                field("Sent for Approval Date"; Rec."Sent for Approval Date")
                {
                    Editable = false;
                }
                field("Sent for Approval Time"; Rec."Sent for Approval Time")
                {
                    Editable = false;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    Caption = 'Approved Date &&Time';
                    Editable = false;
                }
                field("Approved Time"; Rec."Approved Time")
                {
                    Editable = false;
                }
                part("2"; "Document No Approval")
                {
                    SubPageLink = "Document Type" = FILTER("Sale Order"),
                                  "Sub Document Type" = FILTER(Invoice),
                                  Initiator = FIELD(Initiator),
                                  "Document No" = FIELD("No.");
                    SubPageView = SORTING("Document Type", "Sub Document Type", "Document No", Initiator, "Key Responsibility Center", "Line No")
                                  ORDER(Ascending)
                                  WHERE("Document No" = FILTER(<> ''));
                }
                field(Initiator; Rec.Initiator)
                {
                    Editable = false;
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                    Editable = false;
                }
                field(Approved; Rec.Approved)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Approval")
            {
                Caption = '&Approval';
                action("Send for Approval")
                {
                    Caption = 'Send for Approval';

                    trigger OnAction()
                    begin
                        //JPL START
                        IF Rec.Initiator <> UPPERCASE(USERID) THEN
                            ERROR('Un-Authorized Initiator');


                        Rec.TESTFIELD("Sent for Approval", FALSE);
                        IF Rec."Sent for Approval" = FALSE THEN BEGIN
                            Rec.VALIDATE("Sent for Approval", TRUE);
                            Rec."Sent for Approval Date" := TODAY;
                            Rec."Sent for Approval Time" := TIME;
                            Rec.MODIFY;
                            UserTasksNew.AuthorizationSO(UserTasksNew."Transaction Type"::Sale, UserTasksNew."Document Type"::"Sale Order",
                            UserTasksNew."Sub Document Type"::Invoice, Rec."No.");

                            //CurrPAGE.UPDATE(TRUE);
                        END;
                        //JPL STOP
                    end;
                }
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;

                    trigger OnAction()
                    begin
                        //Approved:=TRUE;
                        //MODIFY;

                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Sale Order");
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::Invoice);
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Sale);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Sale Order");
                            UserTasksNew.SETRANGE("Sub Document Type", UserTasksNew."Sub Document Type"::Invoice);
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ApproveSO(UserTasksNew);
                        END;
                        IF Rec.Approved = TRUE THEN
                            CurrPage.EDITABLE(FALSE);
                    end;
                }
                action(Return)
                {
                    Caption = 'Return';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Sale Order");
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::Invoice);
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Sale);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Sale Order");
                            UserTasksNew.SETRANGE("Sub Document Type", UserTasksNew."Sub Document Type"::Invoice);
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ReturnSO(UserTasksNew);
                        END;
                    end;
                }
            }
            group("&Invoice")
            {
                Caption = '&Invoice';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        SalesSetup.GET;
                        IF SalesSetup."Calc. Inv. Discount" THEN BEGIN
                            CurrPage.SalesLines.PAGE.CalcInvDisc;
                            COMMIT;
                        END;
                        // IF Rec.Structure <> '' THEN BEGIN
                        //     SalesLine.CalculateStructures(Rec);
                        //     SalesLine.AdjustStructureAmounts(Rec);
                        //     SalesLine.UpdateSalesLines(Rec);
                        //     SalesLine.CalculateTCS(Rec);
                        //     COMMIT;
                        // END ELSE BEGIN
                        //     SalesLine.CalculateTCS(Rec);
                        //     COMMIT;
                        // END;

                        PAGE.RUNMODAL(PAGE::"Sales Statistics", Rec);
                    end;
                }
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
                }
                action("St&ructure")
                {
                    Caption = 'St&ructure';
                    // RunObject = Page "Structure Order Details";// 16305;
                    // RunPageLink = Type = CONST(Sale),
                    //               "Document Type" = FIELD("Document Type"),
                    //               "Document No." = FIELD("No."),
                    //               "Structure Code" = FIELD(Structure);
                }
                action("Transit Documents")
                {
                    Caption = 'Transit Documents';
                    // RunObject = Page "Transit Document Order Details";// 13705;
                    // RunPageLink = Type = CONST(Sale),
                    //               "PO / SO No." = FIELD("No."),
                    //               "Vendor / Customer Ref." = FIELD("Sell-to Customer No.");
                }
                action("Authori&zation Information")
                {
                    Caption = 'Authori&zation Information';
                    // RunObject = Page "VAT Opening Detail";// 16344;
                    // RunPageLink = "Entry No." = FIELD("Document Type"),
                    //               Field2 = FIELD("No.");
                }
                action("Payment Milestones")
                {
                    Caption = 'Payment Milestones';
                    RunObject = Page "Payment Terms Line Sale";
                    RunPageLink = "Transaction Type" = CONST(Sale),
                                  "Document Type" = FIELD("Document Type"),
                                  "Document No." = FIELD("No.");
                }
                action("&Attach Document")
                {
                    Caption = '&Attach Document';
                    RunObject = Page Documents;
                    RunPageLink = "Table No." = CONST(36),
                                  "Reference No. 1" = FIELD("No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';

                action("Get St&d. Cust. Sales Codes")
                {
                    Caption = 'Get St&d. Cust. Sales Codes';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        StdCustSalesCode: Record "Standard Customer Sales Code";
                    begin
                        StdCustSalesCode.InsertSalesLines(Rec);
                    end;
                }
                action("Get &Job Usage")
                {
                    Caption = 'Get &Job Usage';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("No.");
                        CurrPage.SalesLines.PAGE.GetJobLedger;
                    end;
                }
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;

                    trigger OnAction()
                    begin
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RUNMODAL;
                        CLEAR(CopySalesDoc);
                    end;
                }
                action("Move Negative Lines")
                {
                    Caption = 'Move Negative Lines';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        CLEAR(MoveNegSalesLines);
                        MoveNegSalesLines.SetSalesHeader(Rec);
                        MoveNegSalesLines.RUNMODAL;
                        MoveNegSalesLines.ShowDocument;
                    end;
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    RunObject = Codeunit "Release Sales Document";
                    ShortCutKey = 'Ctrl+F9';
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.Reopen(Rec);
                    end;
                }
                action("Calculate Str&ucture Values")
                {
                    Caption = 'Calculate Str&ucture Values';

                    trigger OnAction()
                    begin
                        // SalesLine.CalculateStructures(Rec);
                        // SalesLine.AdjustStructureAmounts(Rec);
                        // SalesLine.UpdateSalesLines(Rec);
                    end;
                }
                action("Calculate TCS")
                {
                    Caption = 'Calculate TCS';

                    trigger OnAction()
                    begin
                        // SalesLine.CalculateStructures(Rec);
                        // SalesLine.AdjustStructureAmounts(Rec);
                        // SalesLine.UpdateSalesLines(Rec);
                        // SalesLine.CalculateTCS(Rec);
                    end;
                }
                action("Direct Debit To PLA")
                {
                    Caption = 'Direct Debit To PLA';

                    trigger OnAction()
                    begin
                        // SalesLine.CalculateStructures(Rec);
                        // SalesLine.AdjustStructureAmounts(Rec);
                        // SalesLine.UpdateSalesLines(Rec);
                        // OpenExciseCentvatClaimForm
                    end;
                }
                action("Get BOQ Lines")
                {
                    Caption = 'Get BOQ Lines';

                    trigger OnAction()
                    begin
                        Rec.GetJobBudgetLines; //ALLESP BCL0016 16-07-2007
                    end;
                }
                action("Suggest Advance & Retention")
                {
                    Caption = 'Suggest Advance & Retention';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Job No.");
                        Rec.CalculateAdvance;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Sales-Post (Yes/No)";
                    ShortCutKey = 'F9';
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Sales-Post + Print";
                    ShortCutKey = 'Shift+F9';
                }
                action("Post &Batch")
                {
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;

                    trigger OnAction()
                    begin
                        REPORT.RUNMODAL(REPORT::"Batch Post Sales Invoices", TRUE, TRUE, Rec);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.RESET;
                    SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    SalesHeader.SETRANGE("No.", Rec."No.");
                    SalesHeader.SETRANGE("Invoice Type", Rec."Invoice Type");
                    REPORT.RUN(97768, TRUE, TRUE, SalesHeader);
                end;
            }
            action(SalesHistoryBtn)
            {
                Caption = 'Sales Histo&ry';
                Promoted = true;
                PromotedCategory = Process;
                Visible = SalesHistoryBtnVisible;

                trigger OnAction()
                begin
                    //SalesInfoPaneMgt.LookupCustSalesHistory(Rec,"Bill-to Customer No.",TRUE); // ALLE MM Code Commented
                end;
            }
            action("&Avail. Credit")
            {
                Caption = '&Avail. Credit';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //SalesInfoPaneMgt.LookupAvailCredit(Rec."Bill-to Customer No.");
                end;
            }
            action(SalesHistoryStn)
            {
                Caption = 'Sales Histor&y';
                Promoted = true;
                PromotedCategory = Process;
                Visible = SalesHistoryStnVisible;

                trigger OnAction()
                begin
                    //SalesInfoPaneMgt.LookupCustSalesHistory(Rec,"Sell-to Customer No.",FALSE); // ALLE MM Code Commented
                end;
            }
            action("&Contacts")
            {
                Caption = '&Contacts';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //SalesInfoPaneMgt.LookupContacts(Rec);
                end;
            }
            action("Ship&-to Addresses")
            {
                Caption = 'Ship&-to Addresses';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //SalesInfoPaneMgt.LookupShipToAddr(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Project: Record Job;
    begin

        Rec.CALCFIELDS("Total Order Value");
        IF Project.GET(Rec."Job No.") THEN
            Rec."Retention Amount" := Rec."Total Order Value" * Project."Retention Amount %" / 100;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SAVERECORD;
        EXIT(Rec.ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        SalesHistoryStnVisible := TRUE;
        BillToCommentBtnVisible := TRUE;
        BillToCommentPictVisible := TRUE;
        SalesHistoryBtnVisible := TRUE;
        ReturnOrderNoEditable := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Invoice Type1" := Rec."Invoice Type1"::RA;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetSalesFilter();
    end;

    trigger OnOpenPage()
    begin
        IF UserMgt.GetSalesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetSalesFilter());
            Rec.FILTERGROUP(0);
        END;
        // IF "Re-Dispatch" THEN
        //     ReturnOrderNoEditable := TRUE
        // ELSE
        //     ReturnOrderNoEditable := FALSE;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        ChangeExchangeRate: Page "Change Exchange Rate";
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        SalesLine: Record "Sales Line";
        MLTransactionType: Option Purchase,Sale;
        "--Alle Var--": Integer;
        Project: Record Job;
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";


        ReturnOrderNoEditable: Boolean;

        SalesHistoryBtnVisible: Boolean;

        BillToCommentPictVisible: Boolean;

        BillToCommentBtnVisible: Boolean;

        SalesHistoryStnVisible: Boolean;
        Text19070588: Label 'Sell-to Customer';
        Text19069283: Label 'Bill-to Customer';

    local procedure UpdateInfoPanel()
    var
        DifferSellToBillTo: Boolean;
    begin
        DifferSellToBillTo := Rec."Sell-to Customer No." <> Rec."Bill-to Customer No.";
        SalesHistoryBtnVisible := DifferSellToBillTo;
        BillToCommentPictVisible := DifferSellToBillTo;
        BillToCommentBtnVisible := DifferSellToBillTo;
        //SalesHistoryStnVisible := SalesInfoPaneMgt.DocExist(Rec, Rec."Sell-to Customer No.");
        IF DifferSellToBillTo THEN;
        //  SalesHistoryBtnVisible := SalesInfoPaneMgt.DocExist(Rec, Rec."Bill-to Customer No.")
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.SalesLines.PAGE.UpdatePAGE(TRUE);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.SalesLines.PAGE.UpdatePAGE(TRUE);
    end;
}

