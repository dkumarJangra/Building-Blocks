page 97805 "Transfer Order Receipt"
{
    // //ALLE-PKS ADDED A MENU BUTTON GET INDENT LINES FOR THE FUNCTIONALITY GET INDENT LINES ON TRANSFER ORDER
    // //ALLEAB Code to give access to Documents to INitiator and those in Heirarchy
    // //AllE-PKS13 COMMENTED CODE
    // //ALLE-PKS16 confirm box
    // //Alleab-FA: for flowing fields from Item to Ile specific to FA from GRN & Transfer Order
    // //ALLEND : Show location and Region Name
    // //RAHEE1.00 For check the PO Line no. not be blank in case of PO Code

    Caption = 'Transfer Order';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Transfer Header";
    //SourceTableView = WHERE("Captive Consumption" = FILTER(false));
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
                field("Posting Date"; Rec."Posting Date")
                {

                    trigger OnValidate()
                    begin
                        PostingDateC4OnAfterValidate;
                    end;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    Editable = false;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    Editable = true;
                }
                field("Transfer-from Name"; Rec."Transfer-from Name")
                {
                    Editable = false;
                }
                field("Transfer-to Name"; Rec."Transfer-to Name")
                {
                    Editable = false;
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        //may 1.0 for restricting cost centers that are blocked...

                        IF Rec."Shortcut Dimension 1 Code" = 'DUMMY' THEN
                            ERROR('You can not select DUMMY cost center..');

                        DimValue.RESET;
                        DimValue.SETRANGE(DimValue."Dimension Code", 'COST CENTER');
                        DimValue.SETRANGE(DimValue.Code, Rec."Shortcut Dimension 1 Code");
                        IF DimValue.FIND('-') THEN
                            IF DimValue.Blocked = TRUE THEN
                                ERROR('This cost center is blocked....');
                        ShortcutDimension1CodeOnAfterV
                    end;
                }
                field(Short1name; Short1name)
                {
                    Editable = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                field(Respname; Respname)
                {
                    Editable = false;
                }
                field("PO code"; Rec."PO code")
                {
                    Caption = 'WO / PO code';
                }
                field("Order Status"; Rec."Order Status")
                {
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                }
                // field(Structure; Structure)
                // {
                // }
                field(Remarks; Rec.Remarks)
                {
                }
            }
            part(TransferLines; "Transfer Order Subform")
            {
                SubPageLink = "Document No." = FIELD("No."),
                              "Derived From Line No." = CONST(0);
            }
            group("Transfer-from")
            {
                Caption = 'Transfer-from';
                field("Transfer-from Name 2"; Rec."Transfer-from Name 2")
                {
                }
                field("Transfer-from Address"; Rec."Transfer-from Address")
                {
                }
                field("Transfer-from Address 2"; Rec."Transfer-from Address 2")
                {
                }
                field("Transfer-from Post Code"; Rec."Transfer-from Post Code")
                {
                    Caption = 'Transfer-from Post Code/City';
                }
                field("Transfer-from Contact"; Rec."Transfer-from Contact")
                {
                }
                field("Transfer-from City"; Rec."Transfer-from City")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {

                    trigger OnValidate()
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
                }
                field("Outbound Whse. Handling Time"; Rec."Outbound Whse. Handling Time")
                {

                    trigger OnValidate()
                    begin
                        OutboundWhseHandlingTimeOnAfte
                    end;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {

                    trigger OnValidate()
                    begin
                        ShippingAgentCodeOnAfterValida
                    end;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {

                    trigger OnValidate()
                    begin
                        ShippingAgentServiceCodeOnAfte
                    end;
                }
                field("Shipping Time"; Rec."Shipping Time")
                {

                    trigger OnValidate()
                    begin
                        ShippingTimeOnAfterValidate;
                    end;
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                }
            }
            group("Transfer-to")
            {
                Caption = 'Transfer-to';
                field("Transfer-to Name 2"; Rec."Transfer-to Name 2")
                {
                }
                field("Transfer-to Address"; Rec."Transfer-to Address")
                {
                }
                field("Transfer-to Address 2"; Rec."Transfer-to Address 2")
                {
                }
                field("Transfer-to Post Code"; Rec."Transfer-to Post Code")
                {
                    Caption = 'Transfer-to Post Code/City';
                }
                field("Transfer-to Contact"; Rec."Transfer-to Contact")
                {
                }
                field("Transfer-to City"; Rec."Transfer-to City")
                {
                }
                field("Receipt Date"; Rec."Receipt Date")
                {

                    trigger OnValidate()
                    begin
                        ReceiptDateOnAfterValidate;
                    end;
                }
                field("Inbound Whse. Handling Time"; Rec."Inbound Whse. Handling Time")
                {

                    trigger OnValidate()
                    begin
                        InboundWhseHandlingTimeOnAfter
                    end;
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                }
                field("Transport Method"; Rec."Transport Method")
                {
                }
                field("Area"; Rec.Area)
                {
                }
                field("Entry/Exit Point"; Rec."Entry/Exit Point")
                {
                }
                field("Time of Removal"; Rec."Time of Removal")
                {
                    Caption = 'Time of Removal';
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                    Caption = 'Mode of Transport';
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    Caption = 'Vehicle No.';
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    Caption = 'LR/RR No.';
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                    Caption = 'LR/RR Date';
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                field(Initiator; Rec.Initiator)
                {
                    Editable = false;
                }
                part(""; "Document No Approval")
                {
                    SubPageLink = "Document Type" = FILTER("Transfer Order"),
                                  "Sub Document Type" = FIELD("Sub Document Type"),
                                  Initiator = FIELD(Initiator),
                                  "Document No" = FIELD("No.");
                    SubPageView = SORTING("Document Type", "Sub Document Type", "Document No", Initiator, "Key Responsibility Center", "Line No")
                                  ORDER(Ascending)
                                  WHERE("Document No" = FILTER(<> ''));
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                    Editable = false;
                }
                field(Approved; Rec.Approved)
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
                field("Sent for Approval Time"; Rec."Sent for Approval Time")
                {
                    Editable = false;
                }
                field("Approved Time"; Rec."Approved Time")
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
                        IF Rec.Initiator <> UPPERCASE(USERID) THEN
                            ERROR('Un-Authorized Initiator');

                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        //RAHEE1.00
                        TRLine.RESET;
                        TRLine.SETRANGE("Document No.", Rec."No.");
                        IF TRLine.FINDSET THEN
                            REPEAT
                                IF TRLine."PO CODE" <> '' THEN
                                    TRLine.TESTFIELD(TRLine."PO Line No.");
                            UNTIL TRLine.NEXT = 0;
                        //RAHEE1.00


                        TransLine.RESET;
                        TransLine.SETRANGE("Document No.", Rec."No.");
                        IF TransLine.FIND('-') THEN BEGIN
                            REPEAT
                                TransLine.TESTFIELD("Item No.");
                                TransLine.TESTFIELD(Quantity);
                                TransLine.TESTFIELD("Shortcut Dimension 1 Code");
                                //Alleab-FA:
                                ItemRec.RESET;
                                ItemRec.GET(TransLine."Item No.");
                                IF NOT ItemRec."FA Item" THEN
                                    //Alleab-FA:
                                    TransLine.TESTFIELD("Shortcut Dimension 2 Code");
                            UNTIL TransLine.NEXT = 0;
                        END ELSE
                            ERROR('Cannot send Blank Document!');



                        Rec.TESTFIELD("Sent for Approval", FALSE);
                        IF Rec."Sent for Approval" = FALSE THEN BEGIN
                            Rec.VALIDATE("Sent for Approval", TRUE);

                            //ALLE-PKS16
                            Accept := CONFIRM(Text007, TRUE, 'Transfer Order', Rec."No.");
                            IF NOT Accept THEN EXIT;
                            //ALLE-PKS16

                            Rec."Sent for Approval Date" := TODAY;
                            Rec."Sent for Approval Time" := TIME;
                            Rec.MODIFY;
                            UserTasksNew.AuthorizationTO(UserTasksNew."Transaction Type"::Purchase, UserTasksNew."Document Type"::"Transfer Order",
                            Rec."Sub Document Type", Rec."No.");


                        END;
                        //JPL STOP

                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                        //ND
                    end;
                }
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;

                    trigger OnAction()
                    begin



                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Transfer Order");
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Transfer Order");
                            UserTasksNew.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ApproveTO(UserTasksNew);
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
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Transfer Order");
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Transfer Order");
                            UserTasksNew.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ReturnTO(UserTasksNew);
                        END;
                    end;
                }
            }
            group("O&rder")
            {
                Caption = 'O&rder';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Transfer Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Inventory Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Transfer Order"),
                                  "No." = FIELD("No.");
                }
                action("S&hipments")
                {
                    Caption = 'S&hipments';
                    RunObject = Page "Posted Transfer Shipments";
                    RunPageLink = "Transfer Order No." = FIELD("No.");
                }
                action("Re&ceipts")
                {
                    Caption = 'Re&ceipts';
                    Image = PostedReceipts;
                    RunObject = Page "Posted Transfer Receipts";
                    RunPageLink = "Transfer Order No." = FIELD("No.");
                }
                action("Whse. Shi&pments")
                {
                    Caption = 'Whse. Shi&pments';
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type" = CONST(5741),
                                  "Source Subtype" = CONST(0),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
                action("&Whse. Receipts")
                {
                    Caption = '&Whse. Receipts';
                    RunObject = Page "Whse. Receipt Lines";
                    RunPageLink = "Source Type" = CONST(5741),
                                  "Source Subtype" = CONST(1),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
                action("In&vt. Put-away/Pick Lines")
                {
                    Caption = 'In&vt. Put-away/Pick Lines';
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document" = FILTER("Inbound Transfer" | "Outbound Transfer"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Document", "Source No.", "Location Code");
                }
                action("St&ructure")
                {
                    Caption = 'St&ructure';
                    // RunObject = Page 16305;
                    // RunPageLink = Type = FILTER(Transfer),
                    //               "Document No." = FIELD("No."),
                    //               "Structure Code" = FIELD(Structure);
                }
                action("Attached Gate Entry")
                {
                    Caption = 'Attached Gate Entry';
                    RunObject = Page "Gate Entry Attachment List";// 16481;
                    RunPageLink = "Source Type" = CONST("Transfer Receipt"),
                                  "Entry Type" = CONST(Inward),
                                  "Source No." = FIELD("No.");
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    action(Period)
                    {
                        Caption = 'Period';

                        trigger OnAction()
                        begin
                            //CurrPage.TransferLines.PAGE.ItemAvailability(0); // ALLE MM Code Commented
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(TransLine, ItemAvailFormsMgt.ByPeriod); // ALLE MM Code Added
                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';

                        trigger OnAction()
                        begin
                            //CurrPage.TransferLines.PAGE.ItemAvailability(1); // ALLE MM Code Commented
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(TransLine, ItemAvailFormsMgt.ByVariant); // ALLE MM Code Added
                        end;
                    }
                    action(Location)
                    {
                        Caption = 'Location';

                        trigger OnAction()
                        begin
                            //CurrPage.TransferLines.PAGE.ItemAvailability(2); // ALLE MM Code Commented
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(TransLine, ItemAvailFormsMgt.ByLocation); // ALLE MM Code Added
                        end;
                    }
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //CurrPage.TransferLines.PAGE.ShowDimensions;
                    end;
                }
                group("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    action(Shipment)
                    {
                        Caption = 'Shipment';

                        trigger OnAction()
                        begin
                            //CurrPage.TransferLines.PAGE.OpenItemTrackingLines(0);
                        end;
                    }
                    action(Receipt)
                    {
                        Caption = 'Receipt';

                        trigger OnAction()
                        begin
                            //CurrPage.TransferLines.PAGE.OpenItemTrackingLines(1);
                        end;
                    }
                }
                action("Str&ucture Details")
                {
                    Caption = 'Str&ucture Details';

                    trigger OnAction()
                    begin
                        //CurrPage.TransferLines.PAGE.ShowStrDetailsForm;
                    end;
                }
            }
        }
        area(processing)
        {
            action("Change Posting Date ")
            {
                Caption = 'Change Posting Date ';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin


                    Rec."Posting Date" := TODAY;
                    Rec.MODIFY;
                end;
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Reserve")
                {
                    Caption = '&Reserve';

                    trigger OnAction()
                    begin
                        //CurrPage.TransferLines.PAGE.ShowReservation;
                    end;
                }
                action("Create &Whse. Receipt")
                {
                    Caption = 'Create &Whse. Receipt';

                    trigger OnAction()
                    var
                        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    begin
                        GetSourceDocInbound.CreateFromInbndTransferOrder(Rec);
                    end;
                }
                action("Create Whse. S&hipment")
                {
                    Caption = 'Create Whse. S&hipment';

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
                    end;
                }
                action("Create Inventor&y Put-away / Pick")
                {
                    Caption = 'Create Inventor&y Put-away / Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;

                    trigger OnAction()
                    begin
                        Rec.CreateInvtPutAwayPick;
                    end;
                }
                action("Get Gate Entry Lines")
                {
                    Caption = 'Get Gate Entry Lines';

                    trigger OnAction()
                    begin
                        //GetGateEntryLines;
                    end;
                }
                action("Get Bin Content")
                {
                    Caption = 'Get Bin Content';
                    Ellipsis = true;
                    Image = GetBinContent;

                    trigger OnAction()
                    var
                        BinContent: Record "Bin Content";
                        GetBinContent: Report "Whse. Get Bin Content";
                    begin
                        BinContent.SETRANGE("Location Code", Rec."Transfer-from Code");
                        GetBinContent.SETTABLEVIEW(BinContent);
                        GetBinContent.InitializeTransferHeader(Rec);
                        GetBinContent.RUNMODAL;
                    end;
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    RunObject = Codeunit "Release Transfer Document";
                    ShortCutKey = 'Ctrl+F9';
                }
                action("Reo&pen")
                {
                    Caption = 'Reo&pen';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseTransferDoc: Codeunit "Release Transfer Document";
                    begin
                        ReleaseTransferDoc.Reopen(Rec);
                    end;
                }
                action("Calc&ulate Structure Values")
                {
                    Caption = 'Calc&ulate Structure Values';

                    trigger OnAction()
                    var
                        TransferLine: Record "Transfer Line";
                    begin
                        // TransferLine.CalculateStructures(Rec);
                        // TransferLine.AdjustStructureAmounts(Rec);
                        // TransferLine.UpdateTransLines(Rec);
                    end;
                }
                action("Get Indent Lines")
                {
                    Caption = 'Get Indent Lines';

                    trigger OnAction()
                    begin
                        //CurrPage.TransferLines.PAGE.GetIndentLineInfo; // ALLE MM Code Commented
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "TransferOrder-Post (Yes/No)";
                    ShortCutKey = 'F9';
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "TransferOrder-Post + Print";
                    ShortCutKey = 'Shift+F9';
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    DocPrint.PrintTransferHeader(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT Memberof.FIND('-') THEN BEGIN
            IF Rec.Amended = FALSE THEN BEGIN
                IF Rec.Approved = FALSE THEN BEGIN
                    IF Rec."Sent for Approval" = FALSE THEN BEGIN

                        IF USERID = Rec.Initiator THEN
                            CurrPage.EDITABLE := TRUE
                        ELSE
                            CurrPage.EDITABLE := FALSE;

                    END
                    ELSE BEGIN
                        DocApproval.RESET;
                        DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::"Transfer Order");
                        DocApproval.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        DocApproval.SETFILTER("Document No", '%1', Rec."No.");
                        DocApproval.SETRANGE(Initiator, Rec.Initiator);
                        DocApproval.SETRANGE(Status, DocApproval.Status::" ");
                        IF DocApproval.FIND('-') THEN BEGIN
                            IF (DocApproval."Approvar ID" = USERID) OR (DocApproval."Alternate Approvar ID" = USERID) THEN
                                CurrPage.EDITABLE := TRUE
                            ELSE
                                CurrPage.EDITABLE := FALSE;

                        END
                        ELSE BEGIN
                            CurrPage.EDITABLE := FALSE;
                        END;

                    END;

                END
                ELSE
                    CurrPage.EDITABLE := FALSE;

            END
            ELSE BEGIN
                IF Rec.Amended THEN BEGIN
                    IF Rec."Amendment Approved" = FALSE THEN BEGIN
                        DocApproval.RESET;
                        DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::"Purchase Order Amendment");
                        DocApproval.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        DocApproval.SETFILTER("Document No", '%1', Rec."No.");
                        DocApproval.SETRANGE(Initiator, Rec."Amendment Initiator");
                        DocApproval.SETRANGE(Status, DocApproval.Status::" ");
                        IF DocApproval.FIND('-') THEN BEGIN
                            IF (DocApproval."Approvar ID" = USERID) OR (DocApproval."Alternate Approvar ID" = USERID)
                               OR (Rec."Amendment Initiator" = USERID) THEN
                                CurrPage.EDITABLE := TRUE
                            ELSE
                                CurrPage.EDITABLE := FALSE;

                        END
                        ELSE BEGIN
                            CurrPage.EDITABLE := FALSE;
                        END;

                    END
                    ELSE
                        CurrPage.EDITABLE := FALSE;
                END;
            END;
        END;

        costname := '';
        dept := '';
        IF Rec."Shortcut Dimension 1 Code" <> '' THEN BEGIN
            IF DimValue.GET(GLSetup."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code") THEN
                costname := DimValue.Name;
        END;
        IF Rec."Shortcut Dimension 2 Code" <> '' THEN BEGIN
            IF DimValue.GET(GLSetup."Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code") THEN
                dept := DimValue.Name;
        END;

        //SC
        //ALLEND 191107
        Short1name := '';
        Respname := '';
        Locname := '';
        IF RecRespCenter.GET(Rec."Shortcut Dimension 1 Code") THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;
        //ALLEND 191107

        //ALLEAB
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        //ALLEAB
        Rec.TESTFIELD(Status, Rec.Status::Open);
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT Memberof.FIND('-') THEN BEGIN
            IF Rec.Amended = FALSE THEN BEGIN
                Rec.TESTFIELD(Approved, FALSE);
            END;
            IF Rec.Amended THEN BEGIN
                Rec.TESTFIELD(Approved, TRUE);
                Rec.TESTFIELD("Amendment Approved", FALSE);
            END;
        END;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //ALLEAB
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT Memberof.FIND('-') THEN BEGIN
            IF Rec.Amended = FALSE THEN BEGIN
                Rec.TESTFIELD(Approved, FALSE);
            END;
            IF Rec.Amended THEN BEGIN
                Rec.TESTFIELD(Approved, TRUE);
                Rec.TESTFIELD("Amendment Approved", FALSE);
            END;
        END;
    end;

    trigger OnOpenPage()
    begin
        //RAHEE1.00
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Transfer-to Code", UserMgt.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        END;
        //RAHEE1.00

        IF Rec.Approved = TRUE THEN
            CurrPage.EDITABLE(FALSE);

        //ALLEAB Code to give access to Documents to INitiator and those in Heirarchy
        //AllE-PKS13
        //ALLEND 191107
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;

        //AllE-PKS13
    end;

    var
        TransHead: Record "Transfer Header";
        vFlag: Boolean;
        Memberof: Record "Access Control";
        DocApproval: Record "Document Type Approval";
        ALLE: Integer;
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        UserMgt: Codeunit "User Setup Management";
        costname: Text[120];
        dept: Text[120];
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        Short1name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        TransLine: Record "Transfer Line";
        "Location code": Record Location;
        Accept: Boolean;
        Text007: Label 'Do you want to Send the %1 No.-%2 For Approval';
        ItemRec: Record Item;
        TRLine: Record "Transfer Line";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";

    local procedure PostingDateC4OnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShippingAgentServiceCodeOnAfte()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShippingAgentCodeOnAfterValida()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShippingTimeOnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure OutboundWhseHandlingTimeOnAfte()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ReceiptDateOnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure InboundWhseHandlingTimeOnAfter()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
    end;
}

