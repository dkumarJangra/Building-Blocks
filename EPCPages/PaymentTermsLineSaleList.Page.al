page 97846 "Payment Terms Line Sale List"
{
    // 
    // Alle GA : New form created for multiple payment terms line for one purchase order.

    DelayedInsert = true;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Payment Terms Line Sale";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Sequence; Rec.Sequence)
                {
                }
                field("Payment Plan"; Rec."Payment Plan")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                }
                field("Payment Term Code"; Rec."Payment Term Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Due Amount"; Rec."Due Amount")
                {
                    Editable = false;
                }
                field("Received Amt"; Rec."Received Amt")
                {
                }
                field(RemainingAmt; RemainingAmt)
                {
                    Caption = 'Remaining Amt';
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Payment Made"; Rec."Payment Made")
                {
                    Visible = false;
                }
                field(Adjust; Rec.Adjust)
                {
                    Visible = false;
                }
                field("Broker No."; Rec."Broker No.")
                {
                    Caption = 'Broker Code';
                    Editable = false;
                    Visible = false;
                }
                field("Brokerage %"; Rec."Brokerage %")
                {
                }
                field("Brokerage Amount"; Rec."Brokerage Amount")
                {
                }
                field("Brokerage Paid Amt"; Rec."Brokerage Paid Amt")
                {
                    Editable = false;
                }
                field(BrokerageRemainingAmt; BrokerageRemainingAmt)
                {
                    Caption = 'Remaining Brokerage Amt';
                    Editable = false;
                }
                field("Related Vendor No."; Rec."Related Vendor No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Last Issued Reminder Level"; Rec."Last Issued Reminder Level")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::Sale;
        RemainingAmt := 0;
        ROIRemainingAmt := 0;
        BrokerageRemainingAmt := 0;
        IF Rec."Payment Type" <> Rec."Payment Type"::ROI THEN
            RemainingAmt := Rec."Due Amount" + Rec."Received Amt";
        BrokerageRemainingAmt := Rec."Brokerage Amount" - Rec."Brokerage Paid Amt";
        IF Rec."Payment Type" = Rec."Payment Type"::ROI THEN
            ROIRemainingAmt := Rec."Due Amount" - Rec."ROI Paid Amt";

        //MKS Code written for Enabling and disabling of the form
        SOHdr.GET(Rec."Document Type", Rec."Document No.");
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'SUPERSO');
        IF NOT Memberof.FIND('-') THEN BEGIN
            IF Rec.Approved = FALSE THEN BEGIN
                IF SOHdr."Sent for Approval" = FALSE THEN BEGIN
                    IF UPPERCASE(USERID) = SOHdr.Initiator THEN
                        CurrPage.EDITABLE := TRUE
                    ELSE
                        CurrPage.EDITABLE := FALSE;
                END
                ELSE BEGIN
                    DocApproval.RESET;
                    DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::"Sale Order");
                    DocApproval.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                    DocApproval.SETFILTER("Document No", '%1', SOHdr."No.");
                    DocApproval.SETRANGE(Initiator, SOHdr.Initiator);
                    DocApproval.SETRANGE(Status, DocApproval.Status::" ");
                    IF DocApproval.FIND('-') THEN BEGIN
                        IF (DocApproval."Approvar ID" = UPPERCASE(USERID)) OR (DocApproval."Alternate Approvar ID" = UPPERCASE(USERID)) THEN
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
        END;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::Sale;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::Sale;
        Rec."Payment Plan" := xRec."Payment Plan";
        Rec."Broker No." := xRec."Broker No.";
        Rec."Customer No." := xRec."Customer No.";
    end;

    trigger OnOpenPage()
    begin
        IF CurrPage.LOOKUPMODE THEN
            CurrPage.EDITABLE := FALSE;
    end;

    var
        SalesHeader: Record "Sales Header";
        PaymentTermLine: Record "Payment Terms Line Sale";
        OldMileStone: Code[10];
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        Customer: Record Customer;
        RemainingAmt: Decimal;
        BrokerageRemainingAmt: Decimal;
        ROIRemainingAmt: Decimal;
        Memberof: Record "Access Control";
        DocApproval: Record "Document Type Approval";
        SOHdr: Record "Sales Header";
}

