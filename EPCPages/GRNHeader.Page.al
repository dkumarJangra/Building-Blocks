page 97735 "GRN Header"
{
    // JPL-OPt-01 - Optimized and added key
    // //for BLK : Code commented
    // //ALLE-SR-051107 : Responsibilty center added
    // //ALLE-PKS16 confirm box
    // //ALLE-PKS 34 for the name for the dimension
    // //ALLEDDS26Mar2008 - to flow challan no + challan date to Purcg rcpt header
    // //AlleDK 140808 : for checking the "Document Date" should not be blank
    // ALLERP KRN0015 08-09-2010: Menu Item added
    // //KLND1.00 ALLEDK 140311 Code for confirmation Message and flow of two fields"Test Certificate Received",
    //  "Calibration Certificate Rec"
    // ALLETG RIL0011 22-06-2011: Added function Get Schedule Lines
    // ALLETG RIL0006 25-07-2011: Changed text constant, Text50007 and Text50008
    // ALLEPG RIL1.09 121011 : Applied validation for Weight Bill No.
    // ALLEPG RAHEE1.00 240212 : Added tracking line.

    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "GRN Header";
    SourceTableView = SORTING("Document Type", "GRN No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(GRN),
                            Status = FILTER(Open));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Workflow Sub Document Type"; Rec."Workflow Sub Document Type")
                {
                }
                field("GRN No."; Rec."GRN No.")
                {
                    Caption = 'GRN No.';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Caption = 'PO Number';
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        //PurchaseOrderNoOnAfterValidate;
                    end;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor name"; Rec."Vendor name")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field("Document Date"; Rec."Document Date")
                {
                    Caption = 'Document Rec Date';
                }
                field("Challan No"; Rec."Challan No")
                {
                    Caption = 'Challan No && Date';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Challan Date"; Rec."Challan Date")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                }
                field("Transporter Name"; Rec."Transporter Name")
                {
                }
                field("Total GRN Value"; Rec."Total GRN Value")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Way Bill No"; Rec."Way Bill No")
                {
                }
                field("CN/RR No."; Rec."CN/RR No.")
                {
                }
                field("CN/RR Date"; Rec."CN/RR Date")
                {
                }
                field("Workflow Approval Status"; Rec."Workflow Approval Status")
                {
                }
                field(Approved; Rec.Approved)
                {
                }
                field("Gate Entry No."; Rec."Gate Entry No.")
                {
                }
                field("Gate Entry Date"; Rec."Gate Entry Date")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                    MultiLine = false;
                }
            }
            part(GRNSubForm; "GRN Line Sub Form")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "GRN No." = FIELD("GRN No.");
                SubPageView = SORTING("Document Type", "GRN No.", "Line No.")
                              ORDER(Ascending);
            }
        }
        area(factboxes)
        {
            part("Item Replenishment FactBox"; "Item Replenishment FactBox")
            {
                SubPageLink = "No." = FIELD("Purchase Order No.");
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                Editable = false;
                Enabled = false;
                ShowFilter = false;
            }
            part("Approval FactBox"; "Approval FactBox")
            {
                SubPageLink = "Table ID" = CONST(38),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Purchase Order No.");
                Visible = false;
            }
            part("Vendor Details FactBox"; "Vendor Details FactBox")
            {
                SubPageLink = "No." = FIELD("Vendor No.");
                Visible = false;
            }
            part("Vendor Statistics FactBox"; "Vendor Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Vendor No.");
                Visible = true;
            }
            part("Vendor Hist. Buy-from FactBox"; "Vendor Hist. Buy-from FactBox")
            {
                SubPageLink = "No." = FIELD("Vendor No.");
                Visible = true;
            }
            part(""; "Vendor Hist. Pay-to FactBox")
            {
                SubPageLink = "No." = FIELD("Vendor No.");
                Visible = false;
            }
            systempart(Notes; Notes)
            {
            }
            systempart(Links; Links)
            {
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
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit MyCodeunit;
                        ApprovalsMgmt1: Codeunit 70002;
                    begin
                        Rec.CheckBeforeRelease;
                        PurchaseHeader.RESET;
                        PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                        PurchaseHeader.SETRANGE("No.", Rec."Purchase Order No.");
                        PurchaseHeader.SETRANGE("Shortcut Dimension 1 Code", Rec."Responsibility Center");
                        IF NOT PurchaseHeader.FINDFIRST THEN
                            ERROR('Project Cost Center must be same as Responsibility Center and Location Code.');
                        Rec.TESTFIELD("Posting Date");
                        Rec.TESTFIELD("Document Date");
                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        Rec.TESTFIELD("Shortcut Dimension 2 Code");
                        Rec.TESTFIELD("Responsibility Center");
                        Rec.TESTFIELD("Posting Date");
                        Rec.TESTFIELD("Vendor No.");


                        IF ApprovalsMgmt.CheckPurchaseReceiptApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmt1.OnSendPurchaseReceiptDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit 70002;
                    begin
                        ApprovalsMgmt.OnCancelPurchaseReceiptApprovalRequest(Rec);
                    end;
                }
            }
            group(Order)
            {
                Caption = 'Order';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim1
                    end;
                }
                action("&Documents")
                {
                    Caption = '&Documents';
                    RunObject = Page Documents;
                    RunPageLink = "Table No." = CONST(38),
                                  "Reference No. 1" = FIELD("GRN No.");
                }
            }
            group("&Post")
            {
                Caption = '&Post';
                action("Post")
                {
                    Caption = '&Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');

                        //TESTFIELD(Status,Status :: Open);
                        //TESTFIELD(Approved,TRUE);
                        Rec.TESTFIELD("Workflow Approval Status", Rec."Workflow Approval Status"::Released);
                        Rec.TESTFIELD("Posting Date");
                        Rec.TESTFIELD("Document Date");

                        Con := CONFIRM(Text50002);
                        IF NOT Con THEN EXIT;

                        //DocType.GET(DocType."Document Type"::GRN,"Sub Document Type");
                        //DocInitiator.GET(DocInitiator."Document Type"::GRN,"Sub Document Type",Initiator);
                        //DocInitiator.TESTFIELD(DocInitiator."Posting User Code");

                        //IF UPPERCASE(USERID)<> DocInitiator."Posting User Code" THEN
                        // ERROR(Text50003);

                        //IF "Workflow Sub Document Type" = "Workflow Sub Document Type"::"
                        WorkflowDocTypeInitiator.RESET;
                        WorkflowDocTypeInitiator.SETRANGE("Transaction Type", WorkflowDocTypeInitiator."Transaction Type"::"Purchase Receipt");
                        WorkflowDocTypeInitiator.SETRANGE("Document Type", WorkflowDocTypeInitiator."Document Type"::Order);
                        IF Rec."Workflow Sub Document Type" = Rec."Workflow Sub Document Type"::Direct THEN
                            WorkflowDocTypeInitiator.SETRANGE("Sub Document Type", WorkflowDocTypeInitiator."Sub Document Type"::Direct)
                        ELSE
                            IF Rec."Workflow Sub Document Type" = Rec."Workflow Sub Document Type"::Regular THEN
                                WorkflowDocTypeInitiator.SETRANGE("Sub Document Type", WorkflowDocTypeInitiator."Sub Document Type"::Regular);

                        WorkflowDocTypeInitiator.SETRANGE("Initiator User ID", Rec."Initiator User ID");
                        IF WorkflowDocTypeInitiator.FINDFIRST THEN BEGIN
                            IF UPPERCASE(USERID) <> WorkflowDocTypeInitiator."Posting User ID" THEN
                                ERROR('UnAuthorised User for posting this document.');
                        END;



                        Vendor.GET(Rec."Vendor No.");
                        GRNLine.RESET;
                        GRNLine.SETCURRENTKEY(Type, "No.", Status);
                        GRNLine.SETRANGE("Document Type", Rec."Document Type");
                        GRNLine.SETRANGE("GRN No.", Rec."GRN No.");
                        GRNLine.SETFILTER(Type, '<>%1', GRNLine.Type::" ");
                        IF GRNLine.FINDSET THEN
                            REPEAT
                                IF Rec."Purchase Order No." <> GRNLine."Purchase Order No." THEN
                                    ERROR(Text50005);
                                GRNLine.TESTFIELD("Location Code");
                                GRNLine.TESTFIELD("Shortcut Dimension 1 Code");
                                GRNLine.TESTFIELD("Shortcut Dimension 2 Code");
                                GRNLine.TESTFIELD("Unit of Measure Code");
                                GRNLine.TESTFIELD("Accepted Qty");
                            UNTIL GRNLine.NEXT = 0;

                        Vendor.GET(Rec."Vendor No.");
                        IF Vendor."BBG BHEL" THEN BEGIN
                            //TESTFIELD(Approved,TRUE);

                            Rec.CALCFIELDS("Total GRN Value");
                            IF Rec."Total GRN Value" = 0 THEN
                                ERROR('GRN Amount cannot be zero');

                            Rec.TESTFIELD("Commercial Invoice No");
                            Rec.TESTFIELD("Commercial Invoice Date");

                            Rec.TESTFIELD("Purchase Order No.");
                            Rec.TESTFIELD(Status, Rec.Status::Open);
                            Rec.TESTFIELD("Sent to Payment Tracking", TRUE);
                            Rec.TESTFIELD("MRC Invoice No -20%");
                            Rec.TESTFIELD("MRC Invoice Date");
                            Rec.CALCFIELDS("Total GRN Value");
                            IF Rec."Total GRN Value" = 0 THEN
                                ERROR(Text50006);
                        END;

                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        Rec.TESTFIELD("Shortcut Dimension 2 Code");
                        Rec.TESTFIELD("Responsibility Center");
                        Rec.TESTFIELD("Posting Date");
                        Rec.TESTFIELD("Vendor No.");
                        GRNLine.RESET;
                        GRNLine.SETCURRENTKEY("Rejected Qty");
                        GRNLine.SETRANGE("Document Type", Rec."Document Type");
                        GRNLine.SETRANGE("GRN No.", Rec."GRN No.");
                        GRNLine.SETFILTER("Rejected Qty", '<>%1', 0);
                        IF GRNLine.FINDFIRST THEN BEGIN
                            PurAndPay.GET;
                            PurAndPay.TESTFIELD("Rejection No. Series");
                            NoSeriesMgt.InitSeries(PurAndPay."Rejection No. Series",
                              xRec."Rejection No. Series",
                              WORKDATE,
                              Rec."Rejection Note No.",
                              Rec."Rejection No. Series");
                            REPEAT
                                GRNLine."Rejection Note No." := Rec."Rejection Note No.";
                                GRNLine."Rejection Note Generated" := TRUE;
                                GRNLine.MODIFY;
                            UNTIL GRNLine.NEXT = 0;
                        END;


                        PurchLine.RESET;
                        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
                        PurchLine.SETRANGE("Document No.", Rec."Purchase Order No.");
                        IF PurchLine.FINDSET THEN
                            REPEAT
                                PurchLine.VALIDATE("Qty. to Receive", 0);
                                PurchLine.VALIDATE("Qty. to Invoice", 0);
                                PurchLine.MODIFY;
                            UNTIL PurchLine.NEXT = 0;

                        GRNLine.RESET;
                        GRNLine.SETRANGE("Document Type", Rec."Document Type");
                        GRNLine.SETRANGE("GRN No.", Rec."GRN No.");
                        IF GRNLine.FINDSET THEN
                            REPEAT
                                PurchLine.RESET;
                                PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
                                PurchLine.SETRANGE("Document No.", GRNLine."Purchase Order No.");
                                PurchLine.SETRANGE("Line No.", GRNLine."Purchase Order Line No.");
                                IF PurchLine.FINDFIRST THEN BEGIN
                                    IF GRNLine."Excess Qty" > 0 THEN BEGIN
                                        PurchLine.SuspendStatusCheck(TRUE);
                                        PurchLine.VALIDATE(Quantity, PurchLine.Quantity + GRNLine."Excess Qty");
                                    END;

                                    PurchLine.VALIDATE("Qty. to Receive", GRNLine."Accepted Qty");
                                    PurchLine.VALIDATE("Qty. to Invoice", 0);
                                    //ALLETG RIL0011 23-06-2011: START>>
                                    PurchLine."GRN No." := GRNLine."GRN No.";
                                    PurchLine."GRN Line No." := GRNLine."Line No.";
                                    PurchLine."Schedule Line No." := GRNLine."Schedule Line No.";
                                    //ALLETG RIL0011 23-06-2011: END<<
                                    PurchLine."Rejected Qty" := GRNLine."Rejected Qty";
                                    PurchLine."Rejection Note No." := GRNLine."Rejection Note No.";
                                    //    PurchLine.TESTFIELD("Location Code");
                                    //  PurchLine.TESTFIELD("Shortcut Dimension 1 Code");
                                    //PurchLine.TESTFIELD("Shortcut Dimension 2 Code");
                                    PurchLine.MODIFY;
                                END;
                            UNTIL GRNLine.NEXT = 0;

                        PurchHdr.GET(PurchHdr."Document Type"::Order, Rec."Purchase Order No.");
                        PurchHdr."Vendor Shipment No." := Rec."Challan No";
                        PurchHdr.VALIDATE("Posting Date", Rec."Posting Date");
                        PurchHdr.VALIDATE("Document Date", Rec."Document Date");
                        PurchHdr."Receiving No." := '';
                        PurchHdr."Receiving No. Series" := Rec."GRN No. Series";
                        PurchHdr."Receiving No." := Rec."GRN No.";
                        PurchHdr."Challan No" := Rec."Challan No";
                        PurchHdr."Vehicle No.1" := Rec."Vehicle No.";
                        PurchHdr."UnPosted GRN No" := Rec."GRN No.";
                        PurchHdr.Receive := TRUE;
                        PurchHdr.MODIFY;
                        PucrhPost.RUN(PurchHdr);

                        Vendor.GET(Rec."Vendor No.");

                        //ALLETG RIL0011 23-06-2011: START>>
                        GRNLine.RESET;
                        GRNLine.SETRANGE("Document Type", Rec."Document Type");
                        GRNLine.SETRANGE("GRN No.", Rec."GRN No.");
                        IF GRNLine.FINDSET THEN
                            REPEAT
                                PurchSchedule.RESET;
                                IF PurchSchedule.GET(PurchSchedule."Document Type"::Order,
                                                     GRNLine."Purchase Order No.",
                                                     GRNLine."Purchase Order Line No.",
                                                     GRNLine."Schedule Line No.") THEN BEGIN
                                    PurchSchedule."Remaining Quantity" := PurchSchedule."Remaining Quantity" - GRNLine."Accepted Qty";
                                    PurchSchedule.MODIFY;
                                END;
                            UNTIL GRNLine.NEXT = 0;
                        //ALLETG RIL0011 23-06-2011: END<<

                        GRNLine.RESET;
                        GRNLine.SETRANGE("Document Type", Rec."Document Type");
                        GRNLine.SETRANGE("GRN No.", Rec."GRN No.");
                        IF GRNLine.FINDSET THEN
                            REPEAT
                                GRNLine.Status := GRNLine.Status::Close;
                                GRNLine.MODIFY;
                            UNTIL GRNLine.NEXT = 0;
                        Rec.Status := Rec.Status::Close;
                        Rec.MODIFY;

                        //ALLERP Start:
                        CurrPage.UPDATE(FALSE);
                        //ALLERP End:
                    end;
                }
            }
        }
        area(processing)
        {
            action("Change Posting Date")
            {
                Caption = 'Change Posting Date';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF (USERID = Rec.Initiator) OR (USERID = '100654') THEN BEGIN
                        Rec."Posting Date" := TODAY;
                        Rec.MODIFY;
                    END;
                end;
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Get PO Lines")
                {
                    Caption = 'Get PO Lines';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent to Payment Tracking", FALSE);
                        Rec.TESTFIELD(Approved, FALSE);
                        CurrPage.GRNSubForm.PAGE.GetPOLines(Rec);
                        //GRNLines.InsertGRNLines(Rec);
                    end;
                }
                action("Get Scheduled Lines")
                {
                    Caption = 'Get Scheduled Lines';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //ALLETG RIL0011 22-06-2011: START>>
                        Rec.TESTFIELD(Approved, FALSE);
                        CurrPage.GRNSubForm.PAGE.GetScheduleLines(Rec);
                        //ALLETG RIL0011 22-06-2011: END<<
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*
         //ALLE-PKS 34
          RecRespCenter.RESET;
          RecRespCenter.SETRANGE(Code,"Responsibility Center");
          IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            //Short1name := RecRespCenter."Region Name";
            Short1name := RecRespCenter.Name;  // ALLEPG 130911
            Locname := RecRespCenter."Location Name";
          END;
        //ALLE-PKS 34
        */
        /*
        DocType.GET(DocType."Document Type"::GRN,"Sub Document Type");
        DocInitiator.GET(DocType."Document Type"::GRN,"Sub Document Type",Initiator);
        IF DocType."Gate Entry Required" THEN BEGIN
          "Gate Entry No.Editable" :=TRUE;
          IF "Vendor No."<>'' THEN BEGIN
            Vendor.GET("Vendor No.");
            IF Vendor.BHEL THEN
              "Gate Entry No.Editable" :=FALSE;
          END;
          "Purchase Order No.Editable" :=TRUE;
          IF "Gate Entry No."<>'' THEN
            "Purchase Order No.Editable" :=FALSE
          ELSE
            "Purchase Order No.Editable" :=TRUE;
        END
        ELSE BEGIN
          "Gate Entry No.Editable" :=FALSE;
          //CurrPAGE."Purchase Order No.".EDITABLE:=TRUE;
        END;
        IF "Vendor No."<>'' THEN BEGIN
         Vendor.GET("Vendor No.");
        
         IF "Sent to Payment Tracking" AND Vendor.BHEL THEN BEGIN
          //CurrPAGE."Commercial Invoice No".EDITABLE:=FALSE;
          //CurrPAGE."Bill No".EDITABLE:=FALSE;
          //CurrPAGE."Bill Date".EDITABLE:=FALSE;
          //CurrPAGE."Material Despatched Date".EDITABLE:=FALSE;
          //CurrPAGE."Commercial Invoice Date".EDITABLE:=FALSE;
          //IF "Sub Document Type"="Sub Document Type"::"Freight Advice" THEN
           // CurrPAGE."Ref Mat. Comm Inv No".EDITABLE:=FALSE
          //ELSE
            //CurrPAGE."Ref Mat. Comm Inv No".EDITABLE:=TRUE;
          "Purchase Order No.Editable" :=FALSE;
         END;
        END
        ELSE BEGIN
          //CurrPAGE."Commercial Invoice No".EDITABLE:=TRUE;
          //CurrPAGE."Bill No".EDITABLE:=TRUE;
          //CurrPAGE."Bill Date".EDITABLE:=TRUE;
          //CurrPAGE."Commercial Invoice Date".EDITABLE:=TRUE;
          //CurrPAGE."Material Despatched Date".EDITABLE:=TRUE;
          //CurrPAGE."Ref Mat. Comm Inv No".EDITABLE:=TRUE;
          "Purchase Order No.Editable" :=TRUE;
        END;
        
        {
        IF Approved THEN
          CurrPAGE.EDITABLE:=FALSE
        ELSE
          CurrPAGE.EDITABLE:=TRUE;
        }
        
        //JPL55 START
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name",USERID);
        MemberOf.SETFILTER("Role ID",'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            IF Approved=FALSE THEN BEGIN
              IF "Sent for Approval"=FALSE THEN BEGIN
        
                IF USERID=Initiator THEN
                  CurrPage.EDITABLE:=TRUE
                ELSE
                  CurrPage.EDITABLE:=FALSE;
        
              END
              ELSE BEGIN
                DocApproval.RESET;
                DocApproval.SETRANGE("Document Type",DocApproval."Document Type"::GRN);
                DocApproval.SETRANGE("Sub Document Type","Sub Document Type");
                DocApproval.SETFILTER("Document No",'%1',"GRN No.");
                DocApproval.SETRANGE(Initiator,Initiator);
                DocApproval.SETRANGE(Status,DocApproval.Status::" ");
                IF DocApproval.FIND('-') THEN BEGIN
                  IF (DocApproval."Approvar ID"=USERID) OR (DocApproval."Alternate Approvar ID"=USERID) THEN
                    CurrPage.EDITABLE:=TRUE
                  ELSE
                    CurrPage.EDITABLE:=FALSE;
        
                END
                ELSE BEGIN
                  CurrPage.EDITABLE:=FALSE;
                END;
        
              END;
        
            END
            ELSE
              CurrPage.EDITABLE:=FALSE;
        END;
        //JPL55 STOP
        */
        //DiscountAmt:=0;
        //GetDiscountAmt(DiscountAmt);

    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TESTFIELD(Approved, FALSE);
    end;

    trigger OnInit()
    begin
        //"Purchase Order No.Editable" := TRUE;
        //"Gate Entry No.Editable" := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //TESTFIELD(Approved,FALSE);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //ALLE-SR-051107 >>
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //ALLE-SR-051107 <<
    end;

    trigger OnOpenPage()
    begin
        //CurrPAGE.CAPTION := FORMAT("Sub Document Type");
        // IF "Sub Document Type"="Sub Document Type"::"Freight Advice" THEN
        //   CurrPAGE.CAPTION:='Freight Advice '+ ' '+CurrPAGE.CAPTION;
        //Code to give access to Documents to INitiator and those in Heirarchy
        //JPL55 START

        /*//ALLE-SR-051107 >>
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
        //ALLE-SR-051107 <<
        
        GHdr:=Rec;
        IF FIND('-') THEN
        REPEAT
          vFlag:=FALSE;
          MemberOf.RESET;
          MemberOf.SETRANGE("User Name",USERID);
          MemberOf.SETFILTER("Role ID",'SUPERPO');
          IF NOT MemberOf.FIND('-') THEN
          BEGIN
            IF USERID=Initiator THEN
              vFlag:=TRUE;
        
        //SC 14/02/06->>
        GRNEmp.RESET;
        UsrEmp.RESET;
           IF GRNEmp.GET(Initiator) THEN BEGIN
            IF UsrEmp.GET(USERID) THEN BEGIN
             IF (GRNEmp."Global Dimension 2 Code" = UsrEmp."Global Dimension 2 Code") THEN
                vFlag:=TRUE;
            END;
           END;
        //SC <<-
           MemberOf.RESET;
           MemberOf.SETRANGE("User Name",USERID);
           MemberOf.SETFILTER("Role ID",'VIEW-GRN WFLOW');
           IF MemberOf.FIND('-') THEN
             vFlag:=TRUE;
        
        
            DocApproval.RESET;
            DocApproval.SETRANGE("Document Type",DocApproval."Document Type"::GRN);
            DocApproval.SETRANGE("Sub Document Type","Sub Document Type");
            DocApproval.SETFILTER("Document No",'%1',"GRN No.");
            DocApproval.SETRANGE(Initiator,Initiator);
            //DocApproval.SETRANGE(Status,DocApproval.Status::" ");
            IF DocApproval.FIND('-') THEN
            REPEAT
                IF (DocApproval."Approvar ID"=USERID) OR (DocApproval."Alternate Approvar ID"=USERID) THEN
                  vFlag:=TRUE;
            UNTIL DocApproval.NEXT=0;
            MARK(vFlag);
          END
          ELSE
            MARK(TRUE);
        
        UNTIL NEXT=0;
        Rec.MARKEDONLY(TRUE);
        */
        /*
        IF Rec.GET(GHdr."Document Type",GHdr."GRN No.") THEN;
        //ALLEND 191107
          RecRespCenter.RESET;
          RecRespCenter.SETRANGE(Code,"Responsibility Center");
          IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            //Short1name := RecRespCenter."Region Name";
            Short1name := RecRespCenter.Name;  // ALLEPG 130911
            Locname := RecRespCenter."Location Name";
          END;
          */

    end;

    var
        //GateEntry: Record 16552;
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        GRNLines: Record "GRN Line";
        tt: Code[20];
        PurchLine: Record "Purchase Line";
        GRNLine: Record "GRN Line";
        PurchHdr: Record "Purchase Header";
        PucrhPost: Codeunit "Purch.-Post";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurAndPay: Record "Purchases & Payables Setup";
        GRNHdr: Record "GRN Header";
        DocType: Record "Document Type Setup";
        Navigate: Page Navigate;
        PayTermLine: Record "Payment Terms Line";
        PayTerm: Record "Payment Terms";
        i: Integer;
        Vendor: Record Vendor;
        //GateEntryLine: Record 16553;
        DocInitiator: Record "Document Type Initiator";
        PurchSetup: Record "Purchases & Payables Setup";
        MemberOf: Record "Access Control";
        DocApproval: Record "Document Type Approval";
        GHdr: Record "GRN Header";
        vFlag: Boolean;
        DiscountAmt: Decimal;
        GRNEmp: Record Employee;
        UsrEmp: Record Employee;
        UserMgt: Codeunit "User Setup Management";
        Short1name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        Con: Boolean;
        Accept: Boolean;
        Text007: Label 'Do you want to Send the %1 No.-%2 For Approval';
        Document: Record Document;
        Text50001: Label 'Challan copy should be attached.';
        RecPurchHdr: Record "Purchase Header";
        Con1: Boolean;
        Con2: Boolean;
        Text50002: Label 'Do you want to Post the entries?';
        Text50003: Label 'You are not a authorised person to post this document.';
        Text50004: Label 'Please check!\Region Dimension code is different from Responsibility Center code.';
        Text50005: Label 'Purchase Order in header does not match with GRN Lines.';
        Text50006: Label 'GRN amount cannot be zero.';
        PurchSchedule: Record "Purch. Delivery Schedule";
        Text50007: Label 'Test Certificate is required for this PO. Do you want to continue?';
        Text50008: Label 'Calibration Certificate is required for this PO. Do you want to continue?';
        Text50009: Label 'Internal Certificate is required for this PO. Do you want to continue?';
        Con3: Boolean;

        "Gate Entry No.Editable": Boolean;

        "Purchase Order No.Editable": Boolean;
        PurchaseHeader: Record "Purchase Header";
        WorkflowDocTypeInitiator: Record "Workflow Doc. Type Initiator";

    local procedure PurchaseOrderNoOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

