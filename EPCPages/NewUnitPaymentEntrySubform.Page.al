page 50082 "NewUnit Payment Entry  Subform"
{
    AutoSplitKey = true;
    Caption = 'Receipt';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "NewApplication Payment Entry";
    SourceTableView = WHERE("Payment Mode" = FILTER(Cash | Bank));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Visible = false;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    OptionCaption = ' ,Cash,Bank';

                    trigger OnValidate()
                    begin
                        IF Rec."Payment Mode" = Rec."Payment Mode"::Cash THEN BEGIN
                            ChequeNoTransactionNoEditable := FALSE;
                            "Cheque DateEditable" := FALSE;
                            "Cheque Bank and BranchEditable" := FALSE;
                            "Deposit/Paid BankEditable" := FALSE;
                        END ELSE BEGIN
                            ChequeNoTransactionNoEditable := TRUE;
                            "Cheque DateEditable" := TRUE;
                            "Cheque Bank and BranchEditable" := TRUE;
                            "Deposit/Paid BankEditable" := TRUE;
                        END;
                        /*
                          AppPaymentEntry.RESET;
                          AppPaymentEntry.SETRANGE("Document No.","Document No.");
                          AppPaymentEntry.SETRANGE(Posted,FALSE);
                          IF AppPaymentEntry.FINDFIRST THEN BEGIN
                            IF (AppPaymentEntry."Payment Mode" <> "Payment Mode"::Cash) AND (AppPaymentEntry."Payment Mode" <> "Payment Mode"::Bank) THEN
                              ERROR('You have already created another entry. Please post or Delete that for Payment Mode ='+
                              FORMAT(AppPaymentEntry."Payment Mode"));
                          END;
                         */

                    end;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    Editable = true;
                }
                field(Description; Rec.Description)
                {
                    Visible = false;
                }
                field(Narration; Rec.Narration)
                {
                }
                field("Provisional Rcpt. No."; Rec."Provisional Rcpt. No.")
                {
                    Visible = true;
                }
                field("User Branch Name"; Rec."User Branch Name")
                {
                    Caption = 'User Branch Name';
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Order Ref No."; Rec."Order Ref No.")
                {
                    Visible = false;
                }
                field("Bank Type"; Rec."Bank Type")
                {
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                    Editable = "Deposit/Paid BankEditable";
                    Visible = true;
                }
                field("Cheque No./ Transaction No."; Rec."Cheque No./ Transaction No.")
                {
                    Editable = ChequeNoTransactionNoEditable;
                    Visible = true;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    Editable = "Cheque DateEditable";
                    Visible = true;
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                    Editable = "Cheque Bank and BranchEditable";
                    Visible = true;
                }
                field("Deposit / Paid Bank Name"; Rec."Deposit / Paid Bank Name")
                {
                    Visible = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Posting date"; Rec."Posting date")
                {
                    Editable = false;
                    Visible = true;

                    trigger OnValidate()
                    begin
                        IF Rec."Posting date" > TODAY THEN
                            ERROR('Posting Date can not be greater than -' + FORMAT(TODAY));
                    end;
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Application No."; Rec."Application No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Send for Approval"; Rec."Send for Approval")
                {
                }
                field("Send for Approval DT"; Rec."Send for Approval DT")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function")
            {
                action("BBG Send for Approval")
                {
                    Caption = 'Send for Approval';
                    trigger OnAction()
                    var
                        LineNo: Integer;
                        v_RequesttoApproveDocuments_1: Record "Request to Approve Documents";
                    begin
                        IF CONFIRM('Do  you want to send Document Send for Approval') THEN BEGIN
                            Rec.TESTFIELD("Send for Approval", FALSE);
                            LineNo := 0;
                            RequesttoApproveDocuments.RESET;
                            RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::Receipt);
                            RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                            RequesttoApproveDocuments.SETRANGE("Document Line No.", Rec."Line No.");
                            IF RequesttoApproveDocuments.FINDLAST THEN
                                LineNo := RequesttoApproveDocuments."Line No.";

                            ApprovalWorkflowforAuditPr.RESET;
                            ApprovalWorkflowforAuditPr.SETRANGE("Document Type", ApprovalWorkflowforAuditPr."Document Type"::Receipt);
                            ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", USERID);
                            IF ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
                                REPEAT
                                    RequesttoApproveDocuments.RESET;
                                    RequesttoApproveDocuments.INIT;
                                    RequesttoApproveDocuments."Document Type" := RequesttoApproveDocuments."Document Type"::Receipt;
                                    RequesttoApproveDocuments."Document No." := Rec."Document No.";
                                    RequesttoApproveDocuments."Document Line No." := Rec."Line No.";
                                    RequesttoApproveDocuments."Line No." := LineNo + 10000;
                                    RequesttoApproveDocuments.Amount := Rec.Amount;
                                    RequesttoApproveDocuments."Posting Date" := Rec."Posting date";
                                    RequesttoApproveDocuments."Requester ID" := USERID;
                                    RequesttoApproveDocuments."Approver ID" := ApprovalWorkflowforAuditPr."Approver ID";
                                    RequesttoApproveDocuments.Sequence := ApprovalWorkflowforAuditPr.Sequence;
                                    RequesttoApproveDocuments."Requester DateTime" := CURRENTDATETIME;
                                    RequesttoApproveDocuments.INSERT;
                                    LineNo := RequesttoApproveDocuments."Line No."
                              UNTIL ApprovalWorkflowforAuditPr.NEXT = 0;
                                Rec."Send for Approval" := TRUE;
                                Rec."Send for Approval DT" := CURRENTDATETIME;
                                Rec.MODIFY;
                            END ELSE
                                ERROR('Approver not found against this Sender');
                        END ELSE
                            MESSAGE('Nothing Process');
                    end;
                }
                action("&Attach Documents")
                {
                    Caption = '&Attach Documents';
                    Promoted = true;
                    RunObject = Page "Document file Upload";
                    RunPageLink = "Table No." = CONST(50017),
                                  "Document No." = FIELD("Document No."),
                                  "Document Line No." = FIELD("Line No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Deposit/Paid BankEditable" := TRUE;
        "Cheque Bank and BranchEditable" := TRUE;
        "Cheque DateEditable" := TRUE;
        ChequeNoTransactionNoEditable := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
        BBGOnAfterGetCurrRecord;
    end;

    var
        TotalApplAmt2: Decimal;
        TotalRcvdAmt2: Decimal;
        AppPaymentEntry: Record "Application Payment Entry";
        Loc: Record Location;
        BName: Text[70];

        ChequeNoTransactionNoEditable: Boolean;

        "Cheque DateEditable": Boolean;

        "Cheque Bank and BranchEditable": Boolean;

        "Deposit/Paid BankEditable": Boolean;
        UserSetup: Record "User Setup";
        RequesttoApproveDocuments: Record "Request to Approve Documents";
        ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";


    procedure UpdatePAGE2()
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
    end;

    local procedure OnBeforePutRecord()
    begin
        Rec.GetAmounts2(TotalApplAmt2, TotalRcvdAmt2);
    end;
}

