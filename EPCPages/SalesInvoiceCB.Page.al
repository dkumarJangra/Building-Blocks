page 97753 "Sales Invoice CB"
{
    // ALLESP BCL0016 27-08-2007: SourceTable View Added Invoice type = Normal to diff. from RA,Escalation Bill
    // ALLEAB
    // // Added new code forStandard Deduction Functionality on Sale TAx
    // ALLERP BugFix 03-12-2010: Location code made editable and sales tax base amount has been removed and code commented.
    //                         : Authorization and reauthorization menu
    // ALLETG RIL0100 16-06-2011: Bill Start Date, Bill End Date addedd
    // ALLEPG 271211 : Added code to verify job must be approved before get planning lines
    // 
    // //RAHEE1.00 090412 Check the Gen. Prod. Posting Group
    // //RAHEE1.00 030512 flow some fields

    Caption = 'Sales Invoice';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER(Invoice),
                            "Invoice Type1" = FILTER(RA));
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
                        JobRec.GET(Rec."Job No.");
                        IF Rec."Sell-to Customer No." <> JobRec."Bill-to Customer No." THEN
                            ERROR('Sell to customer no. should be same as defined in Job Card');
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Editable = false;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    Editable = false;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    Editable = false;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    Caption = 'Sell-to Post Code/City';
                    Editable = false;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    Editable = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    Editable = true;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                field(Respname; Respname)
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field(Short1name; Short1name)
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = true;
                }
                field(Locname; Locname)
                {
                    Editable = false;
                }
                field("Client Bill Status"; Rec."Client Bill Status")
                {
                    Editable = false;
                }
                field("Client Bill Type"; Rec."Client Bill Type")
                {
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
                //     Editable = true;
                // }
                field("Posting Description"; Rec."Posting Description")
                {
                    Caption = 'Narration';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Raised Client Bill Ref. No."; Rec."Raised Client Bill Ref. No.")
                {

                    trigger OnValidate()
                    begin
                        IF SHRec.GET(SLRec."Document Type"::Invoice, Rec."Raised Client Bill Ref. No.") THEN BEGIN
                            Rec."Sales Tax Base %" := SHRec."Sales Tax Base %";
                            Rec."External Document No." := SHRec."External Document No.";
                            //Rec.VALIDATE(Structure, SHRec.Structure);
                            Rec.VALIDATE("Ship-to Code", SHRec."Ship-to Code");
                            Rec."North Zone" := SHRec."North Zone";
                            Rec."South Zone" := SHRec."South Zone";
                            Rec."Percent of Steel" := SHRec."Percent of Steel";
                            Rec."Percent for Rest" := SHRec."Percent for Rest";
                            Rec."Labour Percent" := SHRec."Labour Percent";
                            //RAHEE1.00 030512
                            Rec."Mode of Transport" := SHRec."Mode of Transport";
                            Rec."Transporter Name" := SHRec."Transporter Name";
                            Rec."Vehicle No." := SHRec."Vehicle No.";
                            Rec."LR/RR No." := SHRec."LR/RR No.";
                            Rec."LR/RR Date" := SHRec."LR/RR Date";
                            //RAHEE1.00 030512
                            Rec.MODIFY;
                        END;
                        SLRec.RESET;
                        SLRec.SETRANGE("Document Type", SLRec."Document Type"::Invoice);
                        SLRec.SETRANGE("Document No.", Rec."Raised Client Bill Ref. No.");
                        IF SLRec.FINDFIRST THEN
                            REPEAT
                                SlRec1.RESET;
                                SlRec1.INIT;
                                SlRec1.TRANSFERFIELDS(SLRec);
                                SlRec1."Document Type" := SlRec1."Document Type"::Invoice;
                                SlRec1."Document No." := Rec."No.";
                                SlRec1."Invoice Type1" := SlRec1."Invoice Type1"::RA;
                                SlRec1.INSERT;
                            UNTIL SLRec.NEXT = 0;

                        SLRec.RESET;
                        SLRec.SETRANGE("Document Type", SLRec."Document Type"::Invoice);
                        SLRec.SETRANGE("Document No.", Rec."No.");
                        IF SLRec.FINDFIRST THEN
                            REPEAT
                                SLRec.VALIDATE(SLRec."Shortcut Dimension 1 Code");
                            UNTIL SLRec.NEXT = 0;

                        PTLSRec.RESET;
                        PTLSRec.SETRANGE("Document Type", SlRec1."Document Type"::Invoice);
                        PTLSRec.SETRANGE("Document No.", Rec."Raised Client Bill Ref. No.");
                        IF PTLSRec.FIND('-') THEN
                            REPEAT
                                PTLSRec1.RESET;
                                PTLSRec1.INIT;
                                PTLSRec1.TRANSFERFIELDS(PTLSRec);
                                PTLSRec1."Document Type" := PTLSRec1."Document Type"::Invoice;
                                PTLSRec1."Document No." := Rec."No.";
                                PTLSRec1.INSERT;
                            UNTIL PTLSRec.NEXT = 0;

                        CurrPage.SalesLines.PAGE.UpdatePAGE(TRUE);
                    end;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                }
                field("Bill Start Date"; Rec."Bill Start Date")
                {
                }
                field("Bill End Date"; Rec."Bill End Date")
                {
                }
            }
            part(SalesLines; "Sales Invoice Subform CB")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(CustInfoPanel)
            {
                Caption = 'Customer Information';
                label("1")
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
                label("2")
                {
                    CaptionClass = Text19069283;
                }
                // field("SalesInfoPaneMgt.CalcAvailableCredit(Rec.Bill-to Customer No.)";
                //     SalesInfoPaneMgt.CalcAvailableCredit(Rec."Bill-to Customer No."))
                // {
                //     DecimalPlaces = 0:0;
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
                    Editable = false;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    Editable = false;
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    Editable = false;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    Caption = 'Bill-to Post Code/City';
                    Editable = false;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    Editable = false;
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
                // field("Calc. Inv. Discount (%)"; "Calc. Inv. Discount (%)")
                // {
                // }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
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
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                }
                field(AppAmount; AppAmount)
                {
                    Caption = 'Applied Amount';
                    Editable = false;
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
            group(Others)
            {
                Caption = 'Others';
                field("Time of Removal"; Rec."Time of Removal")
                {
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                }
                field("Transporter Name"; Rec."Transporter Name")
                {
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                field("Creation Date"; Rec."Creation Date")
                {
                    Editable = false;
                }
                field("Sent for Approval Date"; Rec."Sent for Approval Date")
                {
                    Editable = false;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    Editable = false;
                }
                part(""; "Document No Approval")
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
            group("Client Billing")
            {
                Caption = 'Client Billing';
                field("North Zone"; Rec."North Zone")
                {
                }
                field("South Zone"; Rec."South Zone")
                {
                }
                field("Labour Percent"; Rec."Labour Percent")
                {
                }
                field("Percent of Steel"; Rec."Percent of Steel")
                {
                }
                field("Percent for Rest"; Rec."Percent for Rest")
                {
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
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Sale Order");
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::Invoice);
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

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
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Sale Order");
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::Invoice);
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

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
                        // Rec.CALCFIELDS("Price Inclusive of Taxes");
                        // IF SalesSetup."Calc. Inv. Discount" AND (NOT "Price Inclusive of Taxes") THEN BEGIN
                        //     CurrPage.SalesLines.PAGE.CalcInvDisc;
                        //     COMMIT;
                        // END;
                        // IF "Price Inclusive of Taxes" THEN BEGIN
                        //     SalesLine.InitStrOrdDetail(Rec);
                        //     SalesLine.GetSalesPriceExclusiveTaxes(Rec);
                        //     SalesLine.UpdateSalesLinesPIT(Rec);
                        //     COMMIT;
                        // END;

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
                    // RunObject = Page 16305;
                    // RunPageLink = Type = CONST(Sale),
                    //               "Document Type" = FIELD("Document Type"),
                    //               "Document No." = FIELD("No."),
                    //               "Structure Code" = FIELD(Structure);
                }
                action("Transit Documents")
                {
                    Caption = 'Transit Documents';
                    // RunObject = Page 13705;
                    // RunPageLink = Type = CONST(Sale),
                    //               "PO / SO No." = FIELD("No."),
                    //               "Vendor / Customer Ref." = FIELD("Sell-to Customer No.");
                }
                action("Authori&zation Information")
                {
                    Caption = 'Authori&zation Information';
                    // RunObject = Page 16344;
                    // RunPageLink = "Entry No." = FIELD("Document Type"),
                    //               Field2 = FIELD("No.");
                    // Visible = false;
                }
                action("Payment Milestones")
                {
                    Caption = 'Payment Milestones';
                    RunObject = Page "Payment Terms Line Sale";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "Document No." = FIELD("No."),
                                  "Transaction Type" = FILTER(Sale);
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                action(Structure)
                {
                    Caption = 'Structure';

                    trigger OnAction()
                    var
                        // StructureOrderDetail: Record 13794;
                        SalesLine2: Record "Sales Line";
                    begin
                        // SalesLine2.InitStrOrdDetail(Rec);
                        // COMMIT;
                        // CLEAR(SalesLine2);
                        // CurrPage.SalesLines.PAGE.GETRECORD(SalesLine2);
                        // StructureOrderDetail.RESET;
                        // StructureOrderDetail.SETRANGE(Type, StructureOrderDetail.Type::Sale);
                        // StructureOrderDetail.SETRANGE(Rec."Document Type", Rec."Document Type");
                        // StructureOrderDetail.SETRANGE("Document No.", Rec."No.");
                        // StructureOrderDetail.SETRANGE("Document Line No.", SalesLine2."Line No.");
                        // StructureOrderDetail.SETRANGE("Price Inclusive of Tax", TRUE);
                        // //ALLERP 30-11-2010:Start:
                        // PAGE.RUNMODAL(PAGE::"Structure Order Details PIT", StructureOrderDetail);
                        // //ALLERP 30-11-2010:End:
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Calculate &Invoice Discount")
                {
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        // Rec.CALCFIELDS("Price Inclusive of Taxes");
                        // IF NOT "Price Inclusive of Taxes" THEN
                        //     CurrPage.SalesLines.PAGE.ApproveCalcInvDisc
                        // ELSE
                        //     ERROR(STRSUBSTNO(Text16500, Rec.FIELDCAPTION("Price Inclusive of Taxes")));
                    end;
                }
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
                        //TESTFIELD(USERID,Initiator);
                        IF Rec.Initiator <> USERID THEN
                            ERROR('only USER %1 can move Negative Lines', Rec.Initiator);

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
                        // Rec.CALCFIELDS("Price Inclusive of Taxes");
                        // IF "Price Inclusive of Taxes" THEN BEGIN
                        //     SalesLine.InitStrOrdDetail(Rec);
                        //     SalesLine.GetSalesPriceExclusiveTaxes(Rec);
                        //     SalesLine.UpdateSalesLinesPIT(Rec);
                        // END;

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
                action("Calculate RIT")
                {
                    Caption = 'Calculate RIT';

                    trigger OnAction()
                    begin
                        /*//ALLEAB
                        SLRec.RESET;
                        SLRec.SETRANGE("Document Type","Document Type");
                        SLRec.SETRANGE("Document No.","No.");
                        SLRec.SETRANGE("Invoice Type",SLRec."Invoice Type"::RA);
                        //SLRec.SETRANGE("RIT Done",TRUE);
                        SLRec.SETRANGE("RIT Done",FALSE);
                        IF NOT SLRec.FIND('-') THEN
                          ERROR('RIT Already done for this document');
                        
                        SLRec.RESET;
                        SLRec.SETRANGE("Document Type","Document Type");
                        SLRec.SETRANGE("Document No.","No.");
                        SLRec.SETRANGE("Invoice Type",SLRec."Invoice Type"::RA);
                        SLRec.SETRANGE(SLRec."BOQ Rate Inclusive Tax",TRUE);
                        SLRec.SETRANGE("RIT Done",FALSE);
                        IF SLRec.FINDFIRST THEN
                        REPEAT
                         IF SLRec."Tax %"<>0 THEN
                         BEGIN
                         // SLRec."Unit Price":=ROUND((SLRec."Unit Price"*100)/(100+SLRec."Tax %"),1,'=');
                           IF SLRec."Unit Price"<>SLRec."Tax Base Amount" THEN  // Standard Deduction Functionality on Sale TAx
                              BEGIN
                                IF ("Sales Tax Base %" <> 0) AND ("Sales Tax Base %" <> 100) THEN BEGIN
                                  SLRec."Unit Price":=((SLRec."Unit Price"*"Sales Tax Base %")/100)-
                                   (((SLRec."Tax Base Amount")*SLRec."Tax %")/(100+SLRec."Tax %"))/SLRec.Quantity
                                   +(SLRec."Unit Price"*(100-"Sales Tax Base %")/100);
                                  SLRec."RIT Tax" :=  (((SLRec."Tax Base Amount")*SLRec."Tax %")/(100+SLRec."Tax %"));
                                END ELSE BEGIN
                                  SLRec."Unit Price":=((SLRec."Unit Price"*100)/100)-
                                   (((SLRec."Tax Base Amount")*SLRec."Tax %")/(100+SLRec."Tax %"))/SLRec.Quantity;
                                   //+(SLRec."Unit Price"*(100-"Sales Tax Base %")/100);
                                  //SLRec."RIT Tax" :=  (((SLRec."Tax Base Amount")*SLRec."Tax %")/(100+SLRec."Tax %"));
                                END;
                              END
                           ELSE
                        
                            SLRec."Unit Price":=(SLRec."Unit Price"*100)/(100+SLRec."Tax %");
                          SLRec.VALIDATE("Unit Price");
                        
                          SLRec."RIT Done":=TRUE;
                          SLRec.MODIFY;
                         END
                         ELSE
                         ERROR('Tax % not defined for line no. %1',SLRec."Line No.");
                        UNTIL SLRec.NEXT=0;
                        //ALLEAB
                         */
                        CurrPage.SalesLines.PAGE.CalculateRIT();

                    end;
                }

                action("Direct Debit To PLA / RG")
                {
                    Caption = 'Direct Debit To PLA / RG';

                    trigger OnAction()
                    begin
                        // SalesLine.CalculateStructures(Rec);
                        // SalesLine.AdjustStructureAmounts(Rec);
                        // SalesLine.UpdateSalesLines(Rec);
                        // OpenExciseCentvatClaimForm
                    end;
                }
                action("Get Job Lines")
                {
                    Caption = 'Get Job Lines';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sell-to Customer No.");
                        Rec.TESTFIELD("Sent for Approval", FALSE);
                        Rec.TESTFIELD(Approved, FALSE);
                        //IF "Client Bill Type"="Client Bill Type"::Raised THEN
                        //BEGIN
                        //ALLEAB
                        // ALLEPG 271211 Start
                        IF JobRec.GET(Rec."Job No.") THEN
                          //RAHEE1.00
                          // IF NOT JobRec.Approved THEN
                          //   ERROR('Project not yet approved')
                          // ELSE
                          //RAHEE1.00
                          BEGIN
                            IF ((JobRec.Amended) AND (NOT JobRec."Amendment Approved")) THEN
                                ERROR('Project is under amendment');
                            Rec.GetJobBudgetLines;
                        END;
                        // ALLEPG 271211 End
                        //ALLEAB
                        //END
                        //ELSE
                        //ERROR('This task can be performed only through Raised Client Bill');
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
                action("Client Bill")
                {
                    Caption = 'Client Bill';

                    trigger OnAction()
                    begin

                        Rec.RESET;
                        Rec.SETRANGE("No.", Rec."No.");
                        REPORT.RUN(Report::"New CommissionEligibility50082", TRUE, FALSE, Rec);
                    end;
                }
            }
            action(SalesHistoryBtn)
            {
                Caption = 'Sales Histo&ry';
                Promoted = true;
                PromotedCategory = Process;
                Visible = SalesHistoryBtnVisible;

                trigger OnAction()
                begin
                    //SalesInfoPaneMgt.LookupCustSalesHistory(Rec,"Bill-to Customer No.",TRUE); // ALLE MM
                end;
            }
            action("&Avail. Credit")
            {
                Caption = '&Avail. Credit';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // SalesInfoPaneMgt.LookupAvailCredit(Rec."Bill-to Customer No.");
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
                    //SalesInfoPaneMgt.LookupCustSalesHistory(Rec,"Sell-to Customer No.",FALSE); // ALLE MM
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
    begin


        //NDALLE
        Short1name := '';
        Short2name := '';
        Respname := '';
        Locname := '';
        IF RecRespCenter.GET(Rec."Responsibility Center") THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;

        AppAmount := 0;
        IF (Rec."Applies-to ID" <> '') OR (Rec."Applies-to Doc. No." <> '') THEN BEGIN
            CLE.RESET;
            CLE.SETCURRENTKEY("Customer No.", Open);
            CLE.SETRANGE("Customer No.", Rec."Sell-to Customer No.");
            CLE.SETRANGE(Open, TRUE);
            IF CLE.FIND('-') THEN
                REPEAT
                    IF CLE."Amount to Apply" <> 0 THEN
                        AppAmount := AppAmount + CLE."Amount to Apply";
                UNTIL CLE.NEXT = 0;
        END;

        /*IF Approved THEN
          CurrPAGE.EDITABLE(FALSE)
        ELSE
          CurrPAGE.EDITABLE(TRUE);
         */

        //ALLERP Bugfix 03-12-2010: Start:
        //IF "Client Bill Type"= "Client Bill Type" :: Certified THEN
        //CurrPAGE."Sales Tax Base %".EDITABLE(FALSE);
        //ALLERP Bugfix 03-12-2010: End:

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
        Rec."Invoice Type1" := Rec."Invoice Type1"::Normal; //ALLESP BCL0016 27-08-2007
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

        IF Rec.Approved THEN
            CurrPage.EDITABLE(FALSE)
        ELSE
            CurrPage.EDITABLE(TRUE);

        /*IF "Re-Dispatch" THEN
          CurrPAGE.ReturnOrderNo.EDITABLE := TRUE
        ELSE
          CurrPAGE.ReturnOrderNo.EDITABLE := FALSE;
        */

        IF Rec.Approved = TRUE THEN
            CurrPage.EDITABLE(FALSE);

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
        Text16500: Label 'To calculate invoice discount, check Cal. Inv. Discount on header when Price Inclusive of Tax = Yes.\This option cannot be used to calculate invoice discount when Price Inclusive Tax = Yes.';
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        RecRespCenter: Record "Responsibility Center 1";
        Short1name: Text[50];
        Short2name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        GLSetup: Record "General Ledger Setup";
        RecPurchRcptLine: Record "Purch. Rcpt. Line";
        RecPL: Record "Purchase Line";
        AppAmount: Decimal;
        CLE: Record "Cust. Ledger Entry";
        PTLSRec: Record "Payment Terms Line Sale";
        OKMILESTONE: Boolean;
        SLRec: Record "Sales Line";
        JobRec: Record Job;
        SlRec1: Record "Sales Line";
        SHRec: Record "Sales Header";
        SalesLine4: Record "Sales Line";
        PTLSRec1: Record "Payment Terms Line Sale";
        SLine: Record "Sales Line";

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
}

