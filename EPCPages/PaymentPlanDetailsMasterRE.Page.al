page 97823 "Payment Plan Details Master RE"
{
    // BLK2.01 ALLEPG 250111 : Added "Due date calculation Date", "Actual Date".

    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Payment Plan Details";
    SourceTableView = SORTING("Milestone Code", "Payment Plan Code", "Charge Code", "Sale/Lease")
                      ORDER(Ascending);
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                    Visible = false;
                }
                field("Payment Plan Code"; Rec."Payment Plan Code")
                {
                    Editable = false;
                }
                field("Sale/Lease"; Rec."Sale/Lease")
                {
                    Editable = false;
                }
                field("Charge Code"; Rec."Charge Code")
                {
                }
                field("Sub Payment Plan"; Rec."Sub Payment Plan")
                {
                }
                field("Due Date Calculation"; Rec."Due Date Calculation")
                {
                }
                field("Buffer Days for AutoPlot Vacat"; Rec."Buffer Days for AutoPlot Vacat")
                {
                }
                field("Actual Date"; Rec."Actual Date")
                {
                }
                field("Group Code"; Rec."Group Code")
                {
                    Visible = false;
                }
                field("Milestone Code"; Rec."Milestone Code")
                {
                }
                field("Milestone Description"; Rec."Milestone Description")
                {
                }
                field("Fixed Amount"; Rec."Fixed Amount")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Percentage Cum"; Rec."Percentage Cum")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        PayTermLine: Record "Payment Terms Line Sale";
        a: Integer;
        ppdrec: Record "Payment Plan Details";
        ChargeTotal: Integer;
}

