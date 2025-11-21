page 97759 "FA Purchase Request Header"
{
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Purchase Request Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      WHERE("Document Type" = FILTER(Indent),
                            "Workflow Sub Document Type" = FILTER(FA));
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
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Importance = Additional;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                field("Location code"; Rec."Location code")
                {
                    Editable = false;
                }
                field("Indent Value"; Rec."Indent Value")
                {
                    Editable = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Initiator User ID"; Rec."Initiator User ID")
                {
                    Editable = false;
                }
                field("Indentor Name"; Rec."Indentor Name")
                {
                    Editable = false;
                    Enabled = true;
                }
                field("Workflow Approval Status"; Rec."Workflow Approval Status")
                {
                }
                group("Fixed Asset Details")
                {
                    Caption = 'Fixed Asset Details';
                    field("FA Sub Group"; Rec."FA Sub Group")
                    {
                        Importance = Additional;
                    }
                    field(Item; Rec.Item)
                    {
                        Importance = Additional;
                    }
                    field(Capacity; Rec.Capacity)
                    {
                        Importance = Additional;
                    }
                }
            }
            part("Indent lines"; "FA Purchase Request Subform")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No.");
                SubPageView = SORTING("Document Type", "Document No.", "Line No.")
                              ORDER(Ascending);
            }
            group(Approval)
            {
                Caption = 'Approval';
                part(""; "Document No Approval")
                {
                    SubPageLink = "Document Type" = FILTER(Indent),
                                  "Sub Document Type" = FIELD("Workflow Sub Document Type"),
                                  Initiator = FIELD("Initiator User ID"),
                                  "Document No" = FIELD("Document No.");
                    SubPageView = SORTING("Document Type", "Sub Document Type", "Document No", Initiator, "Key Responsibility Center", "Line No")
                                  WHERE("Document No" = FILTER(<> ''));
                }
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
        area(factboxes)
        {
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
        area(creation)
        {
            action(Indent)
            {
                Caption = 'Indent';
                Image = NewDocument;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    WorkFlowApprovalMgmt.CreatePurchaseIndentFA(FALSE, IndentHeader);
                    Rec.SETRANGE("Document No.", IndentHeader."Document No.");
                    IF Rec.FINDFIRST THEN;
                    //SETRANGE("Document No.");
                    CurrPage.UPDATE(FALSE);
                end;
            }
        }
        area(navigation)
        {
            group("&Indent")
            {
                Caption = '&Indent';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        //ApprovalEntries.Setfilters(DATABASE::"Purchase Request Header", Rec."Document Type", Rec."Document No.");
                        ApprovalEntries.RUN;
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                }
                action("Purchase Order Line")
                {
                    Caption = 'Purchase Order Line';
                    Image = ViewDocumentLine;
                    RunObject = Page "Purchase Lines";
                    RunPageLink = "Indent No" = FIELD("Document No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Change &Item Indent Status")
                {
                    Caption = 'Change &Item Indent Status';
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    var
                        Selection: Integer;
                    begin

                        Selection := STRMENU(Text002, 2);
                        IF Selection <> 0 THEN BEGIN
                            Rec.CloseIndent(Selection);
                        END;
                    end;
                }
                action("Change &FA Indent Status")
                {
                    Caption = 'Change &FA Indent Status';
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec."Indent Status" := Rec."Indent Status"::Closed;
                        Rec.MODIFY;
                    end;
                }
                action("Generate Enquiry")
                {
                    Caption = 'Generate Enquiry';
                    Image = CreateDocument;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Workflow Approval Status", Rec."Workflow Approval Status"::Released);
                        CLEAR(Enquiry);

                        IndentLine.RESET;
                        IndentLine.SETRANGE("Document Type", Rec."Document Type");
                        IndentLine.SETRANGE("Document No.", Rec."Document No.");
                        IndentLine.SETRANGE(IndentLine."Send for Enquiry", TRUE);
                        IF NOT IndentLine.FIND('-') THEN
                            ERROR('You must Select Atlest one Line Before Creating Inquiry');

                        Enquiry.SetPrHeader(Rec."Document Type", Rec."Document No.");
                        Enquiry.RUNMODAL;
                    end;
                }
            }
            group("&Release")
            {
                Caption = 'Release';
                Image = ReleaseDoc;

                action(Release)
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleasePurchIndentDoc: Codeunit "Release Purch. Indent Document";
                    begin
                        ReleasePurchIndentDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleasePurchIndentDoc: Codeunit "Release Purch. Indent Document";
                    begin
                        ReleasePurchIndentDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("&Approval")
            {
                Caption = '&Approval';
                Image = Approval;
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

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
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit MyCodeunit;
                    begin


                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');
                        IF Rec."Initiator User ID" <> UPPERCASE(USERID) THEN
                            ERROR('Un-Authorized Indentor');

                        Rec.TESTFIELD("Sent for Approval", FALSE);
                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        Rec.TESTFIELD("Shortcut Dimension 2 Code");
                        IndentLine.RESET;
                        IndentLine.SETRANGE("Document Type", Rec."Document Type");
                        IndentLine.SETRANGE("Document No.", Rec."Document No.");
                        IF IndentLine.FIND('-') THEN BEGIN
                            REPEAT
                                IF IndentLine.Type <> IndentLine.Type::"Fixed Asset" THEN BEGIN
                                    IndentLine.TESTFIELD("No.");
                                    IndentLine.TESTFIELD("Approved Qty");
                                    IndentLine.TESTFIELD("Indented Quantity");
                                END;
                                IndentLine.TESTFIELD("Shortcut Dimension 1 Code");
                                IndentLine.TESTFIELD("Shortcut Dimension 2 Code");
                                IndentLine.TESTFIELD("Job No.");
                                IndentLine.TESTFIELD("Job Task No.");
                                IF IndentLine."Job Planning Line No." = 0 THEN
                                    MESSAGE('Indent line created manually.');
                                IndentLine.TESTFIELD("Job Planning Line No.");
                            UNTIL IndentLine.NEXT = 0;
                        END ELSE
                            ERROR('Cannot send Blank Indent!');
                        IF ApprovalsMgmt.CheckPurchaseIndentApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmt.OnSendPurchaseIndentDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit MyCodeunit;
                    begin
                        ApprovalsMgmt.OnCancelPurchaseIndentApprovalRequest(Rec);
                    end;
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("Print")
                {
                    Caption = '&Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        IndentHeader.RESET;
                        IndentHeader.SETRANGE("Document No.", Rec."Document No.");
                        //IF IndentHeader.FIND('-') THEN
                        //REPORT.RUN(REPORT::"Purchase Indent", TRUE, FALSE, IndentHeader);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CALCFIELDS("Indent Value");
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CALCFIELDS("Indent Value");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserSetupMgmt.GetPurchasesFilter();
    end;

    trigger OnOpenPage()
    begin
        //SetSecurityFilterOnRespCenter;
    end;

    var
        PurAndPay: Record "Purchases & Payables Setup";
        IndentHeader: Record "Purchase Request Header";
        Text002: Label '&Cancel, &Short Closure';
        IndentLine: Record "Purchase Request Line";
        UserSetupMgmt: Codeunit "User Setup Management";
        Text007: Label 'Do you want to Send the %1 No.-%2 For Approval';
        Text50001: Label 'Enquiry cannot Be generated before approval';
        Enquiry: Page "Enquiry Vendor Lists";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        WorkFlowApprovalMgmt: Codeunit "Document Managment";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;
}

