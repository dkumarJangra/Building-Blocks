page 60685 "Plot Registration Details Card"
{
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Plot Registration Details";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Importance = Promoted;
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Amount Received"; Rec."Amount Received")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Member Name"; Rec."Member Name")
                {
                    Editable = false;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Application Status"; Rec."Application Status")
                {
                }
                field("Open Stage"; Rec."Open Stage")
                {
                    Caption = 'Status';
                    Importance = Promoted;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Caption = 'Creation Date';
                }
                field("Version No."; Rec."Version No.")
                {
                }
                field("Send for Approval"; Rec."Send for Approval")
                {
                }
                field("Send for Approval Date"; Rec."Send for Approval Date")
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
            }
            part("Document Approval Details"; "Document Approval Details")
            {
                SubPageLink = "Document No." = FIELD("No."),
                              "Document Type" = CONST("Plot Registration");
            }
            group("Stage - 1")
            {
                Caption = 'Stage - 1 (Transaction Desk)';
                field("Form32 Thumb impression form-1"; Rec."Form32 Thumb impression form-1")
                {
                    Caption = 'Form32 Thumb impression form';
                }
                field("Plot Registration Req. form-1"; Rec."Plot Registration Req. form-1")
                {
                    Caption = 'Plot Registration Req. form';
                }
                field("Aadhar card details -1"; Rec."Aadhar card details -1")
                {
                    Caption = 'Aadhar card details';
                }
                field("PAN card details -1"; Rec."PAN card details -1")
                {
                    Caption = 'PAN card details';
                }
                field("Photo - 1"; Rec."Photo - 1")
                {
                    Caption = 'Photo';
                }
                field("Send for Approval (Stage-1)"; Rec."Send for Approval (Stage-1)")
                {
                    Caption = 'Send for Approval';
                }
                field("Sender USER Id (Stage-1)"; Rec."Sender USER Id (Stage-1)")
                {
                    Caption = 'Sender USER ID';
                }
                field("Send for Appl.Date(Stage-1)"; Rec."Send for Appl.Date(Stage-1)")
                {
                    Caption = 'Send for Appl. Date';
                }
                field("Approved (Stage-1)"; Rec."Approved (Stage-1)")
                {
                    Caption = 'Approved';
                }
                field("Approved By (Stage-1)"; Rec."Approved By (Stage-1)")
                {
                    Caption = 'Approved By';
                }
                field("Approved Date (Stage-1)"; Rec."Approved Date (Stage-1)")
                {
                    Caption = 'Approved Date';
                }
                field("Stage 1 Status"; Rec."Stage 1 Status")
                {
                    Caption = 'Status';
                    Importance = Promoted;
                }
                field("Send SMS Stage-1"; Rec."Send SMS Stage-1")
                {
                    Caption = 'Send SMS After receive the document at transaction desk';
                }
                field("Send SMS Stage-1 Date Time"; Rec."Send SMS Stage-1 Date Time")
                {
                    Caption = 'SMS Date Time';
                }
                field("Remarks 1"; Rec."Remarks 1")
                {
                    Caption = 'Remark';
                    Importance = Promoted;
                }
                field("Ageing Days 1"; Rec."Ageing Days 1")
                {
                    Caption = 'Ageing Days';
                }
            }
            group("Stage -2")
            {
                Caption = 'Stage - 2 (Accounts & Finance Audit)';
                field("Form32 Thumb imp. form -2"; Rec."Form32 Thumb imp. form -2")
                {
                    Caption = 'Form32 Thumb imp. form';
                }
                field("Plot Registration Req. form-2"; Rec."Plot Registration Req. form-2")
                {
                    Caption = 'Plot Registration Req. form';
                }
                field("Aadhar card details -2"; Rec."Aadhar card details -2")
                {
                    Caption = 'Aadhar card details';
                }
                field("PAN card details -2"; Rec."PAN card details -2")
                {
                    Caption = 'PAN card details';
                }
                field("Photo -2"; Rec."Photo -2")
                {
                    Caption = 'Photo';
                }
                field(Registration; Rec.Registration)
                {
                    Caption = 'Registration';
                }
                field("Send for Approval (Stage-2)"; Rec."Send for Approval (Stage-2)")
                {
                    Caption = 'Send for Approval';
                }
                field("Send for Appl.Date(Stage-2)"; Rec."Send for Appl.Date(Stage-2)")
                {
                    Caption = 'Send for Appl. Date';
                }
                field("Sender USER Id (Stage-2)"; Rec."Sender USER Id (Stage-2)")
                {
                    Caption = 'Sender USER Id';
                }
                field("Approved (Stage-2)"; Rec."Approved (Stage-2)")
                {
                    Caption = 'Approved';
                }
                field("Approved By (Stage-2)"; Rec."Approved By (Stage-2)")
                {
                    Caption = 'Approved By';
                }
                field("Approved Date (Stage-2)"; Rec."Approved Date (Stage-2)")
                {
                    Caption = 'Approved Date';
                }
                field("Stage 2 Status"; Rec."Stage 2 Status")
                {
                    Caption = 'Status';
                    Importance = Promoted;
                }
                field("Remarks 2"; Rec."Remarks 2")
                {
                    Caption = 'Remark';
                    Importance = Promoted;
                }
                field("Ageing Days 2"; Rec."Ageing Days 2")
                {
                    Caption = 'Ageing Days';
                }
            }
            group("Stage - 3")
            {
                Caption = 'Stage - 3 (Accounts and Finance)';
                field(Payment; Rec.Payment)
                {
                    Caption = 'Payment';
                }
                field("Send for Approval (Stage-3)"; Rec."Send for Approval (Stage-3)")
                {
                    Caption = 'Send for Approval';
                }
                field("Send for Appl.Date(Stage-3)"; Rec."Send for Appl.Date(Stage-3)")
                {
                    Caption = 'Send for Appl. Date';
                }
                field("Sender USER Id (Stage-3)"; Rec."Sender USER Id (Stage-3)")
                {
                    Caption = 'Sender USER Id';
                }
                field("Approved (Stage-3)"; Rec."Approved (Stage-3)")
                {
                    Caption = 'Approved';
                }
                field("Approved By (Stage-3)"; Rec."Approved By (Stage-3)")
                {
                    Caption = 'Approved By';
                }
                field("Approved Date (Stage-3)"; Rec."Approved Date (Stage-3)")
                {
                    Caption = 'Approved Date';
                }
                field("Stage 3 Status"; Rec."Stage 3 Status")
                {
                    Caption = 'Status';
                    Importance = Promoted;
                }
                field("Remarks 3"; Rec."Remarks 3")
                {
                    Caption = 'Remark';
                    Importance = Promoted;
                }
                field("Ageing Days 3"; Rec."Ageing Days 3")
                {
                    Caption = 'Ageing Days';
                }
            }
            group("Stage -4")
            {
                Caption = 'Stage - 4 (PRLC Initiated)';
                field("Customer info"; Rec."Customer info")
                {
                    Caption = 'Customer info';
                }
                field("Customer Name"; Rec."Member Name")
                {
                    Caption = 'Customer Name';
                }
                field("Customer PAN No."; Rec."Customer PAN No.")
                {
                }
                field("Customer Aadhar No."; Rec."Customer Aadhar No.")
                {
                }
                field("Organizational info"; Rec."Organizational info")
                {
                    Caption = 'Organizational info';
                }
                field("LLP Name"; Rec."LLP Name")
                {
                }
                field("LLP Address"; Rec."LLP Address")
                {
                }
                field("LLP Address 2"; Rec."LLP Address 2")
                {
                }
                field("Project info"; Rec."Project info")
                {
                    Caption = 'Project info';
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Plot No."; Rec."Plot No.")
                {
                }
                field("PlotExtent"; Rec."Plot Extent")
                {
                }
                field("Representative Code"; Rec."Representative Code")
                {
                }
                field("Representative Name"; Rec."Representative Name")
                {
                }
                field("LLP Registration Name"; Rec."LLP Registration Name")
                {
                }
                field("Sale deed info etc."; Rec."Sale deed info etc.")
                {
                    Caption = 'Sale deed info etc.';
                }
                field("Plot Dimension"; Rec."Plot Dimension")
                {
                }
                field("Send for Approval (Stage-4)"; Rec."Send for Approval (Stage-4)")
                {
                    Caption = 'Send for Approval';
                }
                field("Send for Appl.Date(Stage-4)"; Rec."Send for Appl.Date(Stage-4)")
                {
                    Caption = 'Send for Appl. Date';
                }
                field("Sender USER Id (Stage-4)"; Rec."Sender USER Id (Stage-4)")
                {
                    Caption = 'Sender USER Id';
                }
                field("Approved (Stage-4)"; Rec."Approved (Stage-4)")
                {
                    Caption = 'Approved';
                }
                field("Approved By (Stage-4)"; Rec."Approved By (Stage-4)")
                {
                    Caption = 'Approved By';
                }
                field("Approved Date (Stage-4)"; Rec."Approved Date (Stage-4)")
                {
                    Caption = 'Approved Date';
                }
                field("Stage 4 Status"; Rec."Stage 4 Status")
                {
                    Caption = 'Status';
                    Importance = Promoted;
                }
                field("Remarks 4"; Rec."Remarks 4")
                {
                    Caption = 'Remark';
                    Importance = Promoted;
                }
                field("Ageing Days 4"; Rec."Ageing Days 4")
                {
                    Caption = 'Ageing Days';
                }
            }
            group("Stage - 5")
            {
                Caption = 'Stage - 5 (PRLC Challan)';
                field("Generation of Challan"; Rec."Generation of Challan")
                {
                    Caption = 'Generation of Challan';
                }
                field("Generation of Challan No."; Rec."Generation of Challan No.")
                {
                    Caption = 'Challan No.';
                }
                field("Transaction ID"; Rec."Transaction ID")
                {
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                }
                field("Doc send to SRO for Reg."; Rec."Doc send to SRO for Reg.")
                {
                    Caption = 'Doc send to SRO for Reg.';
                }
                field("Send for Approval (Stage-5)"; Rec."Send for Approval (Stage-5)")
                {
                    Caption = 'Send for Approval';
                }
                field("Send for Appl.Date(Stage-5)"; Rec."Send for Appl.Date(Stage-5)")
                {
                    Caption = 'Send for Appl. Date';
                }
                field("Sender USER Id (Stage-5)"; Rec."Sender USER Id (Stage-5)")
                {
                    Caption = 'Sender USER Id';
                }
                field("Approved (Stage-5)"; Rec."Approved (Stage-5)")
                {
                    Caption = 'Approved';
                }
                field("Approved By (Stage-5)"; Rec."Approved By (Stage-5)")
                {
                    Caption = 'Approved By';
                }
                field("Approved Date (Stage-5)"; Rec."Approved Date (Stage-5)")
                {
                    Caption = 'Approved Date';
                }
                field("Stage 5 Status"; Rec."Stage 5 Status")
                {
                    Caption = 'Status';
                    Importance = Promoted;
                }
                field("Send SMS Generation of Challan"; Rec."Send SMS Generation of Challan")
                {
                    Caption = 'SMS FOR CHALLAN GENERATION';
                }
                field("Send SMS Challan Date Time"; Rec."Send SMS Challan Date Time")
                {
                    Caption = 'SMS Date Time';
                }
                field("Send SMS Doc send SRO for Reg."; Rec."Send SMS Doc send SRO for Reg.")
                {
                    Caption = 'SMS FOR REG FORM OUT FOR REGISTRATION TO SRO';
                }
                field("Send SMS Doc SRO Reg. DateTime"; Rec."Send SMS Doc SRO Reg. DateTime")
                {
                    Caption = 'SMS Date Time';
                }
                field("Remarks 5"; Rec."Remarks 5")
                {
                    Caption = 'Remark';
                    Importance = Promoted;
                }
                field("Ageing Days 5"; Rec."Ageing Days 5")
                {
                    Caption = 'Ageing Days';
                }
            }
            group("Stage -6")
            {
                Caption = 'Stage - 6 (PRLC Plot Registration details)';
                field("Application No."; Rec."No.")
                {
                    Caption = 'Application No.';
                }
                field(CustomerName; Rec."Member Name")
                {
                    Caption = 'Customer Name';
                    Editable = false;
                }
                field("Project Description"; Rec."Project Name")
                {
                    Caption = 'Project Description';
                }
                field("Plot Code"; Rec."Unit Code")
                {
                    Caption = 'Plot Code';
                }
                field(Plot_Extent; Rec."Plot Extent")
                {
                    Caption = 'Plot_Extent';
                }
                field("Unit Facing"; Rec."Unit Facing")
                {
                }
                field("Registration No."; Rec."Registration No.")
                {
                    Caption = 'Registration No.';
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
                field("Doc received from SRO"; Rec."Doc received from SRO")
                {
                    Caption = 'Doc received from SRO';
                }
                field("Send for Approval (Stage-6)"; Rec."Send for Approval (Stage-6)")
                {
                    Caption = 'Send for Approval';
                }
                field("Send for Appl.Date(Stage-6)"; Rec."Send for Appl.Date(Stage-6)")
                {
                    Caption = 'Send for Appl.Date';
                }
                field("Sender USER Id (Stage-6)"; Rec."Sender USER Id (Stage-6)")
                {
                    Caption = 'Sender USER Id';
                }
                field("Approved (Stage-6)"; Rec."Approved (Stage-6)")
                {
                    Caption = 'Approved';
                }
                field("Approved By (Stage-6)"; Rec."Approved By (Stage-6)")
                {
                    Caption = 'Approved By';
                }
                field("Approved Date (Stage-6)"; Rec."Approved Date (Stage-6)")
                {
                    Caption = 'Approved Date';
                }
                field("Stage 6 Status"; Rec."Stage 6 Status")
                {
                    Caption = 'Status';
                    Importance = Promoted;
                }
                field("Send SMS Doc received from SRO"; Rec."Send SMS Doc received from SRO")
                {
                    Caption = 'SMS FOR REGD DOC COLLECTION';
                }
                field("Send SMS Doc received SRO Dt.T"; Rec."Send SMS Doc received SRO Dt.T")
                {
                    Caption = 'SMS Date Time';
                }
                field("Remarks 6"; Rec."Remarks 6")
                {
                    Caption = 'Remark';
                    Importance = Promoted;
                }
                field("Ageing Days 6"; Rec."Ageing Days 6")
                {
                    Caption = 'Ageing Days';
                }
            }
            group("Stage - 7")
            {
                Caption = 'Stage - 7 (Transaction Desk)';
                field("Registration details in NAV"; Rec."Registration details in NAV")
                {
                    Caption = 'Registration details in NAV';
                }
                field("Customer Sale Deed"; Rec."Customer Sale Deed")
                {
                }
                field("Sale Deed Received Date"; Rec."Sale Deed Received Date")
                {
                }
                field("Link Book Received"; Rec."Link Book Received")
                {
                }
                field("Link Book Date"; Rec."Link Book Date")
                {
                    Caption = 'Date';
                }
                field("Link Book User ID"; Rec."Link Book User ID")
                {
                    Caption = 'User ID';
                }
                field("Reg. Doc. Customer Receipt"; Rec."Reg. Doc. Customer Receipt")
                {
                    Caption = 'Reg. Doc. Customer Receipt';
                }
                field("Send for Approval (Stage-7)"; Rec."Send for Approval (Stage-7)")
                {
                    Caption = 'Send for Approval';
                }
                field("Send for Appl.Date(Stage-7)"; Rec."Send for Appl.Date(Stage-7)")
                {
                    Caption = 'Send for Appl. Date';
                }
                field("Sender USER Id (Stage-7)"; Rec."Sender USER Id (Stage-7)")
                {
                    Caption = 'Sender USER Id';
                }
                field("Approved (Stage-7)"; Rec."Approved (Stage-7)")
                {
                    Caption = 'Approved';
                }
                field("Approved By (Stage-7)"; Rec."Approved By (Stage-7)")
                {
                    Caption = 'Approved By';
                }
                field("Approved Date (Stage-7)"; Rec."Approved Date (Stage-7)")
                {
                    Caption = 'Approved Date';
                }
                field("Stage 7 Status"; Rec."Stage 7 Status")
                {
                    Caption = 'Status';
                    Importance = Promoted;
                }
                field("Send SMS Reg. Doc. Cust Rcpt"; Rec."Send SMS Reg. Doc. Cust Rcpt")
                {
                    Caption = 'SMS For CUSTOMER REGD DOC ISSUE FROM TR DESK';
                }
                field("Send SMS Reg Doc Cust DateTime"; Rec."Send SMS Reg Doc Cust DateTime")
                {
                }
                field("Remarks 7"; Rec."Remarks 7")
                {
                    Caption = 'Remark';
                    Importance = Promoted;
                }
                field("Ageing Days 7"; Rec."Ageing Days 7")
                {
                    Caption = 'Ageing Days';
                }
            }
            group("Stage - 8")
            {
                Caption = 'Stage - 8 (PRLC Rectification / Cancellation  )';
                field("PRLC Status"; Rec."PRLC Status")
                {
                    Caption = 'PRLC Rectification / Cancellation';
                }
                field("Registration No_"; Rec."Registration No.")
                {
                    Caption = 'Registration No_';
                    Editable = false;
                }
                field("Registration Date_"; Rec."Registration Date")
                {
                    Caption = 'Registration Date_';
                    Editable = false;
                }
                field("Reg./Cancle Reg. No."; Rec."Reg./Cancle Reg. No.")
                {
                    Caption = 'Rectification / Cancellation Registration No';
                }
                field("Reg./Cancle Reg. Date"; Rec."Reg./Cancle Reg. Date")
                {
                    Caption = 'Rectification / Cancellation Registration Date';
                }
                field("Remarks 8"; Rec."Remarks 8")
                {
                    Caption = 'Remark';
                    Importance = Promoted;
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
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page Documents;
                RunPageLink = "Table No." = CONST(60675),
                              "Document No." = FIELD("No.");
            }
            action("&Send for Approval")
            {
                Caption = 'Send for Approval (For Plot Registration)';

                trigger OnAction()
                var
                    LineNo: Integer;
                    v_RequesttoApproveDocuments_1: Record "Request to Approve Documents";
                begin
                    // Plot Registration

                    Rec.TESTFIELD("Stage 1 Status", Rec."Stage 1 Status"::Open);
                    Rec.TESTFIELD("Approved (Stage-1)");
                    IF CONFIRM('Do  you want to send Document Send for Approval') THEN BEGIN
                        Rec.TESTFIELD("Send for Approval", FALSE);
                        LineNo := 0;
                        RequesttoApproveDocuments.RESET;
                        RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Plot Registration");
                        RequesttoApproveDocuments.SETRANGE("Document No.", Rec."No.");
                        //RequesttoApproveDocuments.SETRANGE("Document Line No.","Line No.");
                        IF RequesttoApproveDocuments.FINDLAST THEN
                            LineNo := RequesttoApproveDocuments."Line No.";

                        ApprovalWorkflowforAuditPr.RESET;
                        ApprovalWorkflowforAuditPr.SETRANGE("Document Type", ApprovalWorkflowforAuditPr."Document Type"::"Plot Registration");
                        ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", USERID);
                        IF ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
                            REPEAT
                                RequesttoApproveDocuments.RESET;
                                RequesttoApproveDocuments.INIT;
                                RequesttoApproveDocuments."Document Type" := RequesttoApproveDocuments."Document Type"::"Plot Registration";
                                RequesttoApproveDocuments."Document No." := Rec."No.";
                                //RequesttoApproveDocuments."Document Line No." := "Line No.";
                                RequesttoApproveDocuments."Line No." := LineNo + 10000;
                                RequesttoApproveDocuments.Amount := Rec.Amount;
                                RequesttoApproveDocuments."Posting Date" := Rec."Posting Date";
                                RequesttoApproveDocuments."Requester ID" := USERID;
                                RequesttoApproveDocuments."Approver ID" := ApprovalWorkflowforAuditPr."Approver ID";
                                RequesttoApproveDocuments.Sequence := ApprovalWorkflowforAuditPr.Sequence;
                                RequesttoApproveDocuments."Requester DateTime" := CURRENTDATETIME;
                                RequesttoApproveDocuments.INSERT;
                                LineNo := RequesttoApproveDocuments."Line No."
                          UNTIL ApprovalWorkflowforAuditPr.NEXT = 0;
                            Rec."Send for Approval" := TRUE;
                            Rec."Send for Approval Date" := TODAY;
                            Rec.MODIFY;
                        END ELSE
                            ERROR('Approver not found against this Sender');
                    END ELSE
                        MESSAGE('Nothing Process');
                end;
            }
            action("Release Stage 1")
            {
                Image = release;

                trigger OnAction()
                begin

                    Rec.TESTFIELD("Approval Status", Rec."Approval Status"::Approved);  //111023

                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec.TESTFIELD("Remarks 1");
                        Rec."Stage 1 Status" := Rec."Stage 1 Status"::Release;
                        UpdateOpenStatus;
                        UpdateDays;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Re-Open Stage 1")
            {
                Image = Reopen;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec."Stage 1 Status" := Rec."Stage 1 Status"::Open;
                        UpdateOpenStatus;
                        UpdateDays;
                        ArchiveDocument;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Release Stage 2")
            {
                Image = Release;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec.TESTFIELD("Remarks 2");
                        Rec."Stage 2 Status" := Rec."Stage 2 Status"::Release;
                        UpdateOpenStatus;
                        UpdateDays;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Re-Open Stage 2")
            {
                Image = Reopen;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec."Stage 2 Status" := Rec."Stage 2 Status"::Open;
                        UpdateOpenStatus;
                        UpdateDays;
                        ArchiveDocument;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Release Stage 3")
            {
                Image = Release;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec.TESTFIELD("Remarks 3");
                        Rec."Stage 3 Status" := Rec."Stage 3 Status"::Release;
                        UpdateOpenStatus;
                        UpdateDays;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Re-Open Stage 3")
            {
                Image = Reopen;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec."Stage 3 Status" := Rec."Stage 3 Status"::Open;
                        UpdateOpenStatus;
                        UpdateDays;
                        ArchiveDocument;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Release Stage 4")
            {
                Image = Release;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec.TESTFIELD("Remarks 4");
                        Rec."Stage 4 Status" := Rec."Stage 4 Status"::Release;
                        UpdateOpenStatus;
                        UpdateDays;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Re-Open Stage 4")
            {
                Image = Reopen;

                trigger OnAction()
                begin
                    Rec."Stage 4 Status" := Rec."Stage 4 Status"::Open;
                    UpdateOpenStatus;
                    UpdateDays;
                    ArchiveDocument;
                    Rec.MODIFY;
                end;
            }
            action("Release Stage 5")
            {
                Image = Release;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec.TESTFIELD("Remarks 5");
                        Rec."Stage 5 Status" := Rec."Stage 5 Status"::Release;
                        UpdateOpenStatus;
                        UpdateDays;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Re-Open Stage 5")
            {
                Image = Reopen;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec."Stage 5 Status" := Rec."Stage 5 Status"::Open;
                        UpdateOpenStatus;
                        UpdateDays;
                        ArchiveDocument;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Release Stage 6")
            {
                Image = Release;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec.TESTFIELD("Remarks 6");
                        Rec."Stage 6 Status" := Rec."Stage 6 Status"::Release;
                        UpdateOpenStatus;
                        UpdateDays;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Re-Open Stage 6")
            {
                Image = Reopen;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec."Stage 6 Status" := Rec."Stage 6 Status"::Open;
                        UpdateOpenStatus;
                        UpdateDays;
                        ArchiveDocument;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Release Stage 7")
            {
                Image = Release;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec.TESTFIELD("Remarks 7");
                        Rec."Stage 7 Status" := Rec."Stage 7 Status"::Release;
                        UpdateOpenStatus;
                        UpdateDays;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Re-Open Stage 7")
            {
                Image = Reopen;

                trigger OnAction()
                begin
                    IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
                        Rec."Stage 7 Status" := Rec."Stage 7 Status"::Open;
                        UpdateOpenStatus;
                        UpdateDays;
                        ArchiveDocument;
                        Rec.MODIFY;
                    END;
                end;
            }
            action("Process Hold")
            {

                trigger OnAction()
                begin
                    Rec."Open Stage" := 'HOLD';
                    ArchiveDocument;
                    Rec.MODIFY;
                end;
            }
            action("Process Open")
            {

                trigger OnAction()
                begin
                    Rec."Open Stage" := '';

                    UpdateOpenStatus;
                    ArchiveDocument;
                    //UpdateDays;
                    Rec.MODIFY;
                end;
            }
            action("&Registration")
            {

                trigger OnAction()
                begin
                    MemberOf.RESET;
                    MemberOf.SETRANGE(MemberOf."User Name", USERID);
                    MemberOf.SETRANGE(MemberOf."Role ID", 'A_UNITREGISTRATION');
                    IF NOT MemberOf.FINDFIRST THEN
                        ERROR('You do not have permission of Role :A_UNITREGISTRATION');
                    IF CONFIRM(Text008, TRUE) THEN BEGIN
                        Rec.TESTFIELD("Registration No.");
                        Rec.TESTFIELD("Registration Date");

                        pBond.RESET;
                        pBond.CHANGECOMPANY(Rec."Company Name");
                        pBond.GET(Rec."No.");
                        RcveAmt_1 := 0;
                        RecAPEtry.RESET;
                        RecAPEtry.CHANGECOMPANY(Rec."Company Name");
                        RecAPEtry.SETRANGE("Document No.", Rec."No.");
                        RecAPEtry.SETRANGE(RecAPEtry."Cheque Status", RecAPEtry."Cheque Status"::Cleared);
                        IF RecAPEtry.FINDSET THEN
                            REPEAT
                                RcveAmt_1 := RcveAmt_1 + RecAPEtry.Amount;
                            UNTIL RecAPEtry.NEXT = 0;
                        IF (pBond.Amount - RcveAmt_1) > 100 THEN
                            ERROR('Received amount should be equal or greater than =' + FORMAT(pBond.Amount));

                        CalculatedAmount := 0;
                        BondPaymentEntry.RESET;
                        BondPaymentEntry.CHANGECOMPANY(Rec."Company Name");
                        BondPaymentEntry.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
                        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::BOND);
                        BondPaymentEntry.SETRANGE("Document No.", pBond."No.");
                        BondPaymentEntry.SETRANGE(Posted, TRUE);
                        IF BondPaymentEntry.FINDSET THEN
                            REPEAT
                                CalculatedAmount += BondPaymentEntry.Amount;
                                IF BondPaymentEntry."Payment Mode" = BondPaymentEntry."Payment Mode"::Bank THEN BEGIN
                                    IF BondPaymentEntry."Cheque Status" <> BondPaymentEntry."Cheque Status"::Cleared THEN
                                        ERROR(Text013, BondPaymentEntry."Cheque No./ Transaction No.", pBond."No.");
                                END;
                            UNTIL BondPaymentEntry.NEXT = 0;
                        IF (CalculatedAmount + 100) < pBond.Amount THEN  //ALLEDK 250113 confirmed order
                            ERROR(Text012, pBond."No.");

                        IF (pBond.Status IN [pBond.Status::Cancelled, pBond.Status::Registered]) THEN
                            ERROR(Text011, pBond.Status);

                        BondHistory.RESET;
                        BondHistory.CHANGECOMPANY(Rec."Company Name");
                        BondHistory.SETRANGE("Unit No.", Rec."No.");
                        IF BondHistory.FINDLAST THEN
                            NewLineNo := BondHistory."Line No." + 1
                        ELSE
                            NewLineNo := 1;

                        BondHistory.INIT;
                        BondHistory."Unit No." := Rec."No.";
                        BondHistory."Line No." := NewLineNo;
                        BondHistory.Description := 'UNIT REGISTERED.';
                        BondHistory."User ID" := USERID;
                        BondHistory."Date(Today)" := GetDescription.GetDocomentDate;
                        BondHistory."Date(Workdate)" := WORKDATE;
                        BondHistory.Time := TIME;
                        BondHistory."Entry Type" := BondHistory."Entry Type"::Bond;
                        BondHistory."Entry No." := Rec."No.";
                        BondHistory.INSERT;


                        pBond.Status := pBond.Status::Registered;
                        pBond."Sales Invoice Applicable" := TRUE;
                        pBond.MODIFY;
                        UnitMaster.GET(pBond."Unit Code");
                        UnitMaster.Status := UnitMaster.Status::Registered;
                        UnitMaster.MODIFY;
                        Rec."Application Status" := Rec."Application Status"::Registered;
                        Rec.MODIFY;

                        WebAppService.UpdateUnitStatus(UnitMaster);  //210624

                        IF Rec."Application Status" = Rec."Application Status"::Registered THEN BEGIN
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
                        MESSAGE(Text009);
                    END ELSE
                        MESSAGE('Nothing Done');
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //UpdateDays;
    end;

    trigger OnOpenPage()
    begin
        UpdateDays;
        CurrPage.UPDATE;
    end;

    var
        Text008: Label 'Do you want to register the Unit?';
        Text009: Label 'Registration Done';
        RcveAmt_1: Decimal;
        PostPayment: Codeunit PostPayment;
        MemberOf: Record "Access Control";
        BondPaymentEntry: Record "Unit Payment Entry";
        CalculatedAmount: Decimal;
        Text013: Label 'Cheque No %1  is Pending against Order No. %2';
        pBond: Record "Confirmed Order";
        Text012: Label 'Payment is Pending against Order No. %1';
        Text011: Label 'Status Must not be %1';
        BondHistory: Record "Unit History";
        UnitMaster: Record "Unit Master";
        UpdateConforder: Record "New Confirmed Order";
        Companywise: Record "Company wise G/L Account";
        RespCenter: Record "Responsibility Center 1";
        NAPEntry: Record "NewApplication Payment Entry";
        NewLineNo: Integer;
        GetDescription: Codeunit GetDescription;
        RecUMaster: Record "Unit Master";
        RecAPEtry: Record "Application Payment Entry";
        ArchivedPlotRegDetails: Record "Archived Plot Reg Details";
        VersionNo_: Integer;
        RequesttoApproveDocuments: Record "Request to Approve Documents";
        ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        WebAppService: Codeunit "Web App Service";

    local procedure UpdateOpenStatus()
    begin
        IF Rec."Open Stage" <> 'HOLD' THEN BEGIN
            IF Rec."Stage 1 Status" = Rec."Stage 1 Status"::Open THEN BEGIN
                Rec."Open Stage" := 'Stage 1';
                Rec."Current Remarks" := Rec."Remarks 1";
                Rec."Current Days" := Rec."Ageing Days 1";
                EXIT;
            END ELSE IF Rec."Stage 2 Status" = Rec."Stage 2 Status"::Open THEN BEGIN
                Rec."Open Stage" := 'Stage 2';
                Rec."Current Remarks" := Rec."Remarks 2";
                Rec."Current Days" := Rec."Ageing Days 2";
                EXIT;
            END ELSE IF Rec."Stage 3 Status" = Rec."Stage 3 Status"::Open THEN BEGIN
                Rec."Open Stage" := 'Stage 3';
                Rec."Current Remarks" := Rec."Remarks 3";
                Rec."Current Days" := Rec."Ageing Days 3";
                EXIT;
            END ELSE IF Rec."Stage 4 Status" = Rec."Stage 4 Status"::Open THEN BEGIN
                Rec."Open Stage" := 'Stage 4';
                Rec."Current Remarks" := Rec."Remarks 4";
                Rec."Current Days" := Rec."Ageing Days 4";
                EXIT;
            END ELSE IF Rec."Stage 5 Status" = Rec."Stage 5 Status"::Open THEN BEGIN
                Rec."Open Stage" := 'Stage 5';
                Rec."Current Days" := Rec."Ageing Days 5";
                Rec."Current Remarks" := Rec."Remarks 5";
                EXIT;
            END ELSE IF Rec."Stage 6 Status" = Rec."Stage 6 Status"::Open THEN BEGIN
                Rec."Open Stage" := 'Stage 6';
                Rec."Current Days" := Rec."Ageing Days 6";
                Rec."Current Remarks" := Rec."Remarks 6";
                EXIT;
            END ELSE IF Rec."Stage 7 Status" = Rec."Stage 7 Status"::Open THEN BEGIN
                Rec."Open Stage" := 'Stage 7';
                Rec."Current Remarks" := Rec."Remarks 7";
                Rec."Current Days" := Rec."Ageing Days 7";
                EXIT;
            END ELSE
                Rec."Open Stage" := 'Complete';
        END;
    end;

    local procedure UpdateDays()
    begin
        IF (Rec."Open Stage" = '') OR (Rec."Open Stage" = 'STAGE 1') THEN BEGIN
            IF Rec."Document Date" <> 0D THEN BEGIN
                Rec."Ageing Days 1" := FORMAT(TODAY - Rec."Document Date") + 'D';
                Rec."Current Days" := Rec."Ageing Days 1";
                Rec."Current Remarks" := Rec."Remarks 1";
            END;
        END ELSE IF (Rec."Open Stage" = 'STAGE 2') THEN BEGIN
            IF Rec."Approved Date (Stage-1)" <> 0D THEN BEGIN
                Rec."Ageing Days 2" := FORMAT(TODAY - Rec."Approved Date (Stage-1)") + 'D';
                Rec."Current Days" := Rec."Ageing Days 2";
                Rec."Current Remarks" := Rec."Remarks 2";
            END;
        END ELSE IF (Rec."Open Stage" = 'STAGE 3') THEN BEGIN
            IF Rec."Approved Date (Stage-2)" <> 0D THEN BEGIN
                Rec."Ageing Days 3" := FORMAT(TODAY - Rec."Approved Date (Stage-2)") + 'D';
                Rec."Current Days" := Rec."Ageing Days 3";
                Rec."Current Remarks" := Rec."Remarks 3";
            END;
        END ELSE IF (Rec."Open Stage" = 'STAGE 4') THEN BEGIN
            IF Rec."Approved Date (Stage-3)" <> 0D THEN BEGIN
                Rec."Ageing Days 4" := FORMAT(TODAY - Rec."Approved Date (Stage-3)") + 'D';
                Rec."Current Days" := Rec."Ageing Days 4";
                Rec."Current Remarks" := Rec."Remarks 4";
            END;
        END ELSE IF (Rec."Open Stage" = 'STAGE 5') THEN BEGIN
            IF Rec."Approved Date (Stage-4)" <> 0D THEN BEGIN
                Rec."Ageing Days 5" := FORMAT(TODAY - Rec."Approved Date (Stage-4)") + 'D';
                Rec."Current Days" := Rec."Ageing Days 5";
                Rec."Current Remarks" := Rec."Remarks 5";
            END;
        END ELSE IF (Rec."Open Stage" = 'STAGE 6') THEN BEGIN
            IF Rec."Approved Date (Stage-5)" <> 0D THEN BEGIN
                Rec."Ageing Days 6" := FORMAT(TODAY - Rec."Approved Date (Stage-5)") + 'D';
                Rec."Current Days" := Rec."Ageing Days 6";
                Rec."Current Remarks" := Rec."Remarks 6";
            END;
        END ELSE IF (Rec."Open Stage" = 'STAGE 7') THEN BEGIN
            IF Rec."Approved Date (Stage-6)" <> 0D THEN BEGIN
                Rec."Ageing Days 7" := FORMAT(TODAY - Rec."Approved Date (Stage-6)") + 'D';
                Rec."Current Days" := Rec."Ageing Days 7";
                Rec."Current Remarks" := Rec."Remarks 7";
            END;
        END;
    end;

    local procedure ArchiveDocument()
    begin
        ArchivedPlotRegDetails.RESET;
        ArchivedPlotRegDetails.SETRANGE("No.", Rec."No.");
        IF ArchivedPlotRegDetails.FINDLAST THEN
            VersionNo_ := ArchivedPlotRegDetails."Archive No."
        ELSE
            VersionNo_ := 0;

        ArchivedPlotRegDetails.RESET;
        ArchivedPlotRegDetails.INIT;
        ArchivedPlotRegDetails.TRANSFERFIELDS(Rec);
        ArchivedPlotRegDetails."Archive No." := VersionNo_ + 1;
        ArchivedPlotRegDetails.INSERT;
    end;
}

