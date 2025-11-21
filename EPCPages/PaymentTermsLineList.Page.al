page 97770 "Payment Terms Line List"
{
    // Alle GA : New Form created for multiple payment terms line for one purchase order.

    DelayedInsert = true;
    Editable = false;
    PageType = Card;
    SourceTable = "Payment Terms Line";
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
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Payment Term Code"; Rec."Payment Term Code")
                {
                }
                field(Sequence; Rec.Sequence)
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
                field("Milestone Code"; Rec."Milestone Code")
                {
                }
                field(Criteria; Rec.Criteria)
                {
                }
                field("Criteria Value / Base Amount"; Rec."Criteria Value / Base Amount")
                {
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                }
                field("Calculation Value"; Rec."Calculation Value")
                {
                }
                field("Due Date Calculation"; Rec."Due Date Calculation")
                {
                }
                field("Due Amount"; Rec."Due Amount")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Payment Made"; Rec."Payment Made")
                {
                }
                field(Adjust; Rec.Adjust)
                {
                }
            }
        }
    }

    actions
    {
    }
}

