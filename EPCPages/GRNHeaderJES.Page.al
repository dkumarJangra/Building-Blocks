page 97739 "GRN Header JES"
{
    // JPL-OPt-01 - Optimized and added key
    // //for BLK : Code commented
    // //ALLE-SR-051107 : Responsibilty center added
    // //ALLE-PKS16 confirm box
    // //ALLE-PKS34 for the name of the dimensions
    // ALLERP KRN 22-09-2010:Control location code made editable
    //                      :Order button made invisible
    // ALLERP BugFix 22-11-2010: Code added for changing Posting date by initiator and its Approver

    InsertAllowed = false;
    PageType = Document;
    SourceTable = "GRN Header";
    SourceTableView = SORTING("Document Type", "GRN No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Open),
                            "Sub Document Type" = FILTER("JES for WO"));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("GRN No."; Rec."GRN No.")
                {
                    Caption = 'JES';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Caption = 'WO Number';
                    Editable = "Purchase Order No.Editable";
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        PHeadRec.GET(PHeadRec."Document Type"::Order, Rec."Purchase Order No.");
                        IF PHeadRec.Amended = TRUE THEN
                            PHeadRec.TESTFIELD(PHeadRec."Amendment Approved", TRUE);
                        PurchaseOrderNoOnAfterValidate;
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
                    Editable = true;
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
                    Editable = true;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field("Document Date"; Rec."Document Date")
                {
                    Caption = 'Document Rec Date';
                }
                field(Staus; Rec."Workflow Approval Status")
                {
                }
                field("Total GRN Value"; Rec."Total GRN Value")
                {
                    Caption = 'Total JES Value';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Invoice Ref. No."; Rec."Invoice Ref. No.")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                    MultiLine = true;
                }
            }
            part(GRNSubForm; "JES Line Sub Form")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "GRN No." = FIELD("GRN No."),
                              Approved = FIELD(Approved),
                              Status = FIELD(Status);
                SubPageView = SORTING("Document Type", "GRN No.", "Line No.")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Approval")
            {
                Caption = '&Approval';
                action("&Approve")
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
                Visible = false;
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Visible = true;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim1
                    end;
                }
            }
            group("&Approval")
            {
                Caption = '&Approval';
                Visible = false;
                action("Send for Approval")
                {
                    Caption = 'Send for Approval';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Invoice Ref. No.");  // ALLEAA
                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');

                        IF Rec.Initiator <> UPPERCASE(USERID) THEN
                            ERROR('Sorry,You are not Initiator of this document');


                        Vendor.GET(Rec."Vendor No.");
                        IF Vendor."BBG BHEL" THEN BEGIN
                            Rec.CALCFIELDS("Total GRN Value", "Total Excise amount", "Total Sales tax amount");
                            IF Rec."Total GRN Value" = 0 THEN
                                ERROR('GRN Amount cannot be zero');
                            Rec.TESTFIELD("Commercial Invoice No");
                            Rec.TESTFIELD("Commercial Invoice Date");

                            /*
                            IF "Sub Document Type"<>"Sub Document Type"::"Freight Advice" THEN
                              TESTFIELD("Bill No");
                            */


                            Rec.TESTFIELD("Purchase Order No.");
                            Rec.TESTFIELD(Status, Rec.Status::Open);
                            Rec.TESTFIELD("Material Despatched Date");
                            Rec.TESTFIELD("Sent to Payment Tracking", TRUE);
                            Rec.TESTFIELD("Document Date");
                            //for BLK
                            /*
                              IF "Sub Document Type"<>"Sub Document Type"::"Freight Advice" THEN BEGIN
                                ExInvRec.RESET;
                                ExInvRec.SETRANGE("Document Type","Document Type");
                                ExInvRec.SETRANGE("GRN No.","GRN No.");
                                IF NOT ExInvRec.FIND('-') THEN
                                  ERROR('Excise Invoices not defined.');

                                REPEAT
                                  ExInvRec.TESTFIELD("Excise Invoice No");
                                  ExInvRec.TESTFIELD("Excise Invoice Date");
                                  ExInvRec.TESTFIELD("Gate Entry No");
                                  ExInvRec.TESTFIELD(Quantity);
                                  ExInvRec.TESTFIELD("RR/LR No");
                                  ExInvRec.TESTFIELD("RR/LR Date");
                                  ExInvRec.TESTFIELD("Vehicle No.");
                                  ExInvRec.TESTFIELD("Form 59 A");
                                UNTIL ExInvRec.NEXT=0;
                              END;
                            */
                            //for BLK
                        END;

                        //DocType.GET(DocType."Document Type"::GRN,"Sub Document Type");
                        //DocInitiator.GET(DocType."Document Type"::GRN,"Sub Document Type",Initiator);

                        Vendor.GET(Rec."Vendor No.");
                        IF NOT Vendor."BBG BHEL" THEN BEGIN
                            IF DocType."Gate Entry Required" THEN BEGIN
                                Rec.TESTFIELD("Gate Entry No.");
                                GateEntryLine.GET(GateEntryLine."Entry Type"::Inward, Rec."Gate Entry No.", Rec."Purchase Order No.");
                            END;
                        END;


                        IF Rec.Initiator <> UPPERCASE(USERID) THEN
                            ERROR('Un-Authorized Initiator');
                        IF Rec."Sent for Approval" = FALSE THEN BEGIN
                            //ALLE-PKS16
                            Accept := CONFIRM(Text007, TRUE, 'JES', Rec."GRN No.");
                            IF NOT Accept THEN EXIT;
                            //ALLE-PKS16

                            Rec.VALIDATE("Sent for Approval", TRUE);
                            Rec."Sent for Approval Date" := TODAY;
                            Rec."Sent for Approval Time" := TIME;
                            Rec.MODIFY;
                            UserTasksNew.AuthorizationPO(UserTasksNew."Transaction Type"::Purchase, UserTasksNew."Document Type"::GRN,
                            Rec."Sub Document Type", Rec."GRN No.");

                            CurrPage.UPDATE(TRUE);
                        END;

                        //NDALLE 211205


                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."GRN No.");
                        //ND

                    end;
                }
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');


                        Rec.TESTFIELD("Sent for Approval", TRUE);

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::GRN);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."GRN No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::GRN);
                            UserTasksNew.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type");
                            UserTasksNew.SETRANGE("Document No", Rec."GRN No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ApprovePO(UserTasksNew);
                        END;
                        //ALLERP
                        CurrPage.UPDATE(FALSE);
                        //ALLERP
                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."GRN No.");
                        //ND
                    end;
                }
                action(Return)
                {
                    Caption = 'Return';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent for Approval", TRUE);

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::GRN);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."GRN No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::GRN);
                            UserTasksNew.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type");
                            UserTasksNew.SETRANGE("Document No", Rec."GRN No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ReturnPO(UserTasksNew);
                        END;


                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."GRN No.");
                        //ND
                    end;
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
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        Rec.TESTFIELD("Workflow Approval Status", Rec."Workflow Approval Status"::Released);
                        Rec.TESTFIELD("Posting Date");
                        Rec.TESTFIELD("Document Date");
                        Con := CONFIRM('Do you want to Post the entries');
                        IF NOT Con THEN EXIT;
                        PHeadRec.GET(PHeadRec."Document Type"::Order, Rec."Purchase Order No.");
                        IF PHeadRec.Amended = TRUE
                          THEN
                            PHeadRec.TESTFIELD(PHeadRec."Amendment Approved", TRUE);
                        //DocType.GET(DocType."Document Type"::GRN,"Sub Document Type");
                        //DocInitiator.GET(DocType."Document Type"::GRN,"Sub Document Type",Initiator);
                        //DocInitiator.TESTFIELD(DocInitiator."Posting User Code");

                        WorkflowDocTypeInitiator.RESET;
                        WorkflowDocTypeInitiator.SETRANGE("Transaction Type", WorkflowDocTypeInitiator."Transaction Type"::"Purchase Receipt");
                        WorkflowDocTypeInitiator.SETRANGE("Document Type", WorkflowDocTypeInitiator."Document Type"::Order);
                        WorkflowDocTypeInitiator.SETRANGE("Sub Document Type", WorkflowDocTypeInitiator."Sub Document Type"::WorkOrder);
                        WorkflowDocTypeInitiator.SETRANGE("Initiator User ID", Rec."Initiator User ID");
                        IF WorkflowDocTypeInitiator.FINDFIRST THEN BEGIN
                            IF UPPERCASE(USERID) <> WorkflowDocTypeInitiator."Posting User ID" THEN
                                ERROR('UnAuthorised User for posting this document.');
                        END;

                        Vendor.GET(Rec."Vendor No.");
                        IF NOT Vendor."BBG BHEL" THEN
                            IF DocType."Gate Entry Required" THEN BEGIN
                                Rec.TESTFIELD("Gate Entry No.");
                                GateEntryLine.GET(GateEntryLine."Entry Type"::Inward, Rec."Gate Entry No.", Rec."Purchase Order No.");
                            END;

                        GRNLine.RESET;
                        GRNLine.SETCURRENTKEY(Type, "No.", Status); //JPL-OPt-01
                        GRNLine.SETRANGE("Document Type", Rec."Document Type");
                        GRNLine.SETRANGE("GRN No.", Rec."GRN No.");
                        GRNLine.SETFILTER(Type, '<>%1', GRNLine.Type::" ");
                        IF GRNLine.FIND('-') THEN
                            REPEAT
                                IF Rec."Purchase Order No." <> GRNLine."Purchase Order No." THEN
                                    ERROR('Purchase Order in header does not match with GRN Lines.');
                                GRNLine.TESTFIELD("Location Code");
                                GRNLine.TESTFIELD("Shortcut Dimension 1 Code");
                                GRNLine.TESTFIELD("Shortcut Dimension 2 Code");
                                GRNLine.TESTFIELD("Unit of Measure Code");
                                GRNLine.TESTFIELD("Accepted Qty");

                            UNTIL GRNLine.NEXT = 0;

                        Vendor.GET(Rec."Vendor No.");
                        IF Vendor."BBG BHEL" THEN BEGIN
                            Rec.TESTFIELD(Approved, TRUE);
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
                        END;

                        //Update Rejection
                        GRNLine.RESET;
                        GRNLine.SETCURRENTKEY("Rejected Qty"); //JPL-OPt-01
                        GRNLine.SETRANGE("Document Type", Rec."Document Type");
                        GRNLine.SETRANGE("GRN No.", Rec."GRN No.");
                        GRNLine.SETFILTER("Rejected Qty", '<>0');
                        IF GRNLine.FIND('-') THEN BEGIN
                            PurAndPay.GET;
                            PurAndPay.TESTFIELD("Rejection No. Series");
                            NoSeriesMgt.InitSeries(PurAndPay."Rejection No. Series", xRec."Rejection No. Series", WORKDATE,
                              Rec."Rejection Note No.", Rec."Rejection No. Series");
                            REPEAT
                                GRNLine."Rejection Note No." := Rec."Rejection Note No.";
                                GRNLine."Rejection Note Generated" := TRUE;
                                GRNLine.MODIFY;
                            UNTIL GRNLine.NEXT = 0;
                        END;
                        PurchLine.RESET;
                        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
                        PurchLine.SETRANGE("Document No.", Rec."Purchase Order No.");
                        IF PurchLine.FIND('-') THEN
                            REPEAT
                                PurchLine.VALIDATE("Qty. to Receive", 0);
                                PurchLine.VALIDATE("Qty. to Invoice", 0);
                                PurchLine.MODIFY;
                            UNTIL PurchLine.NEXT = 0;

                        PurchHdr.VALIDATE("Posting Date", Rec."Posting Date");
                        PurchHdr.VALIDATE("Document Date", Rec."Document Date");

                        GRNLine.RESET;
                        GRNLine.SETRANGE("Document Type", Rec."Document Type");
                        GRNLine.SETRANGE("GRN No.", Rec."GRN No.");
                        IF GRNLine.FIND('-') THEN
                            REPEAT
                                PurchLine.RESET;
                                PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
                                PurchLine.SETRANGE("Document No.", GRNLine."Purchase Order No.");
                                PurchLine.SETRANGE("Line No.", GRNLine."Purchase Order Line No.");
                                IF PurchLine.FIND('-') THEN BEGIN
                                    IF GRNLine."Excess Qty" > 0 THEN BEGIN
                                        PurchLine.SuspendStatusCheck(TRUE);
                                        PurchLine.VALIDATE(Quantity, PurchLine.Quantity + GRNLine."Excess Qty");
                                    END;
                                    PurchLine.VALIDATE("Qty. to Receive", GRNLine."Accepted Qty");
                                    PurchLine.VALIDATE("Qty. to Invoice", 0);
                                    PurchLine."Rejected Qty" := GRNLine."Rejected Qty";
                                    PurchLine."Rejection Note No." := GRNLine."Rejection Note No.";
                                    PurchLine.MODIFY;
                                END;
                            UNTIL GRNLine.NEXT = 0;

                        //Post Rceeipt
                        PurchHdr.GET(PurchHdr."Document Type"::Order, Rec."Purchase Order No.");
                        PurchHdr."Vendor Shipment No." := Rec."Challan No";
                        PurchHdr."Receiving No." := '';
                        PurchHdr."Receiving No. Series" := Rec."GRN No. Series";
                        PurchHdr."Receiving No." := Rec."GRN No.";
                        PurchHdr."Vehicle No.1" := Rec."Vehicle No.";
                        PurchHdr."UnPosted GRN No" := Rec."GRN No.";
                        PurchHdr.Receive := TRUE;
                        PurchHdr.MODIFY;
                        PucrhPost.RUN(PurchHdr);

                        Vendor.GET(Rec."Vendor No.");
                        IF Vendor."BBG BHEL" THEN;
                        GRNLine.RESET;
                        GRNLine.SETRANGE("Document Type", Rec."Document Type");
                        GRNLine.SETRANGE("GRN No.", Rec."GRN No.");
                        IF GRNLine.FINDSET THEN BEGIN
                            REPEAT
                                GRNLine.Status := GRNLine.Status::Close;
                                GRNLine.MODIFY;
                            UNTIL GRNLine.NEXT = 0;
                        END;

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
            action("Change Posting Date ")
            {
                Caption = 'Change Posting Date ';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //ALLERP BugFix 22-11-2010:Start:
                    IF (USERID = Rec.Initiator) THEN BEGIN
                        Rec."Posting Date" := TODAY;
                        Rec.MODIFY;
                    END ELSE BEGIN
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::GRN);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."GRN No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                            IF (USERID = UPPERCASE(DocTypeApprovalRec."Approvar ID")) THEN BEGIN
                                Rec."Posting Date" := TODAY;
                                Rec.MODIFY;
                            END;
                        END;
                    END;
                    //ALLERP BugFix 22-11-2010:End:
                end;
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Get WO Lines")
                {
                    Caption = 'Get WO Lines';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent to Payment Tracking", FALSE);
                        Rec.TESTFIELD(Approved, FALSE);
                        CurrPage.GRNSubForm.PAGE.GetPOLines(Rec);
                        //GRNLines.InsertGRNLines(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //ALLE-PKS34
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;
        //ALLE-PKS34
        /*

      DocType.GET(DocType."Document Type"::GRN,"Sub Document Type");
      DocInitiator.GET(DocType."Document Type"::GRN,"Sub Document Type",Initiator);
      IF DocType."Gate Entry Required" THEN BEGIN
        IF "Vendor No."<>'' THEN BEGIN
          Vendor.GET("Vendor No.");
        END;
        "Purchase Order No.Editable" :=TRUE;
        IF "Gate Entry No."<>'' THEN
          "Purchase Order No.Editable" :=FALSE
        ELSE
          "Purchase Order No.Editable" :=TRUE;
      END;
      */
        IF Rec."Vendor No." <> '' THEN BEGIN
            Vendor.GET(Rec."Vendor No.");

            IF Rec."Sent to Payment Tracking" AND Vendor."BBG BHEL" THEN BEGIN
                "Purchase Order No.Editable" := FALSE;
            END;
        END
        ELSE BEGIN
            "Purchase Order No.Editable" := TRUE;
        END;

        /*
        IF Approved THEN
          CurrPAGE.EDITABLE:=FALSE
        ELSE
          CurrPAGE.EDITABLE:=TRUE;
        */

        /*
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
        */
        //JPL55 STOP
        DiscountAmt := 0;
        Rec.GetDiscountAmt(DiscountAmt);

    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TESTFIELD(Approved, FALSE);
    end;

    trigger OnInit()
    begin
        "Purchase Order No.Editable" := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TESTFIELD(Approved, FALSE);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //ALLE-SR-051107 >>
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //ALLE-SR-051107 <<
    end;

    trigger OnOpenPage()
    begin
        CurrPage.CAPTION := FORMAT(Rec."Sub Document Type");
        // IF "Sub Document Type"="Sub Document Type"::"Freight Advice" THEN
        //   CurrPAGE.CAPTION:='Freight Advice '+ ' '+CurrPAGE.CAPTION;
        //Code to give access to Documents to INitiator and those in Heirarchy
        //JPL55 START

        //ALLE-SR-051107 >>
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        END;
        //ALLE-SR-051107 <<
        /*
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
        IF Rec.GET(GHdr."Document Type", GHdr."GRN No.") THEN;
        //ALLEND 191107
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;

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
        GateEntryLine: Record "Gate Entry Line"; //16553;
        DocInitiator: Record "Document Type Initiator";
        PurchSetup: Record "Purchases & Payables Setup";
        MemberOf: Record "Access Control";
        DocApproval: Record "Workflow Doc. Type Approvers";
        GHdr: Record "GRN Header";
        vFlag: Boolean;
        DiscountAmt: Decimal;
        GRNEmp: Record Employee;
        UsrEmp: Record Employee;
        UserMgt: Codeunit "EPC User Setup Management";
        PurchList: Page "Purchase List";
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
        PHeadRec: Record "Purchase Header";

        "Purchase Order No.Editable": Boolean;
        PurchaseHeader: Record "Purchase Header";
        WorkflowDocTypeInitiator: Record "Workflow Doc. Type Initiator";

    local procedure PurchaseOrderNoOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

