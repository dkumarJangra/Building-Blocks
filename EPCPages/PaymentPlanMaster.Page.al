page 97780 "Payment Plan Master"
{
    // BLK2.01 ALLEPG 250111 : Added Update Due Date Button

    DataCaptionExpression = FORMAT(Rec."Document Type") + ' ' + Rec.Code;
    PageType = Card;
    SourceTable = "Document Master";
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
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Code; Rec.Code)
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // ALLEPG 231012 Start
                        UnitChargePayPlan.RESET;
                        UnitChargePayPlan.SETRANGE(Type, UnitChargePayPlan.Type::"Payment Plan");
                        IF UnitChargePayPlan.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"BSP Charge List", UnitChargePayPlan) = ACTION::LookupOK THEN
                                Rec.Code := UnitChargePayPlan.Code;
                        END;
                        // ALLEPG 231012 End
                    end;
                }
                field("App. Charge Code"; Rec."App. Charge Code")
                {
                    Caption = 'Sub Payment Plan';
                }
                field(Description; Rec.Description)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Sale/Lease"; Rec."Sale/Lease")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Payment Plan Type"; Rec."Payment Plan Type")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Due Date")
            {
                Caption = 'Update &Due Date';
                Image = TileGreen;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    IF NOT CONFIRM(Text014) THEN
                        EXIT
                    ELSE BEGIN
                        RecPaymentPlanDetails.RESET;
                        RecPaymentPlanDetails.SETRANGE(RecPaymentPlanDetails."Project Code", Rec."Project Code");
                        RecPaymentPlanDetails.SETRANGE(RecPaymentPlanDetails."Payment Plan Code", Rec.Code);
                        REPORT.RUNMODAL(60077, TRUE, TRUE, RecPaymentPlanDetails);
                    END;
                end;
            }
            action(EnggUpdate)
            {
                Caption = '&Update Engg. Events';
                Image = UpdateXML;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Milestone Completed";
                RunPageLink = "Project Code" = FIELD("Project Code"),
                              "Payment Plan Code" = FIELD(Code),
                              "Document No." = FILTER('');
            }
            action("&Payment Plan Details")
            {
                Caption = '&Payment Plan Details';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Payment Plan Details Master RE";
                RunPageLink = "Sale/Lease" = FIELD("Sale/Lease"),
                              "Project Code" = FIELD("Project Code"),
                              "Payment Plan Code" = FIELD(Code),
                              "Document No." = FILTER(''),
                              "Sub Payment Plan" = FIELD("App. Charge Code");
                RunPageView = SORTING("Milestone Code", "Payment Plan Code", "Charge Code", "Sale/Lease");
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF CurrPage.LOOKUPMODE THEN
            CurrPage.EDITABLE := FALSE;
    end;

    var
        Memberof: Record "Access Control";
        Paymentplandetails: Page "Purchase Delivery Schedules";
        PPDRec: Record "Payment Plan Details";
        Text014: Label 'Do you want to change the payment Due Date Calculation Formula?';
        RecPaymentPlanDetails: Record "Payment Plan Details";
        UnitChargePayPlan: Record "Unit Charge & Payment Pl. Code";
}

