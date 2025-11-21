page 97976 "MTM Transfer sub form"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Application Payment Entry";
    SourceTableView = WHERE("Payment Mode" = FILTER(MJVM));
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
                    OptionCaption = ' ,,,,MJVM';

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
                    end;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                }
                field(Narration; Rec.Narration)
                {
                }
                field("Provisional Rcpt. No."; Rec."Provisional Rcpt. No.")
                {
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Order Ref No."; Rec."Order Ref No.")
                {
                    Caption = 'Transfer From Appl. No.';
                    Visible = true;
                }
                field("Application No."; Rec."Application No.")
                {
                    Caption = 'Transfer to Appl. No';
                    Editable = false;
                    Visible = true;
                }
                field("Cheque No./ Transaction No."; Rec."Cheque No./ Transaction No.")
                {
                    Editable = ChequeNoTransactionNoEditable;
                    Visible = false;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    Editable = "Cheque DateEditable";
                    Visible = false;
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                    Editable = "Cheque Bank and BranchEditable";
                    Visible = false;
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                    Editable = "Deposit/Paid BankEditable";
                    Visible = false;
                }
                field("Deposit / Paid Bank Name"; Rec."Deposit / Paid Bank Name")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Posting date"; Rec."Posting date")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                    Visible = false;
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Chq. Cl / Bounce Dt."; Rec."Chq. Cl / Bounce Dt.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Explode BOM"; Rec."Explode BOM")
                {
                    Visible = false;
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
                action("Send for Approval")
                {

                    trigger OnAction()
                    var
                        LineNo: Integer;
                        v_RequesttoApproveDocuments_1: Record "Request to Approve Documents";
                    begin
                        IF CONFIRM('Do  you want to send Document Send for Approval') THEN BEGIN
                            Rec.TESTFIELD("Send for Approval", FALSE);
                            LineNo := 0;
                            RequesttoApproveDocuments.RESET;
                            RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Member to Member Transfer");
                            RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                            RequesttoApproveDocuments.SETRANGE("Document Line No.", Rec."Line No.");
                            IF RequesttoApproveDocuments.FINDLAST THEN
                                LineNo := RequesttoApproveDocuments."Line No.";

                            ApprovalWorkflowforAuditPr.RESET;
                            ApprovalWorkflowforAuditPr.SETRANGE("Document Type", ApprovalWorkflowforAuditPr."Document Type"::"Member to Member Transfer");
                            ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", USERID);
                            IF ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
                                REPEAT
                                    RequesttoApproveDocuments.RESET;
                                    RequesttoApproveDocuments.INIT;
                                    RequesttoApproveDocuments."Document Type" := RequesttoApproveDocuments."Document Type"::"Member to Member Transfer";
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
                    RunPageLink = "Table No." = CONST(97812),
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

        ChequeNoTransactionNoEditable: Boolean;

        "Cheque DateEditable": Boolean;

        "Cheque Bank and BranchEditable": Boolean;

        "Deposit/Paid BankEditable": Boolean;
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

