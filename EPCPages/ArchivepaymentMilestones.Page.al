page 50063 "Archive payment Milestones"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Archive Payment Terms Line";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Commision Applicable"; Rec."Commision Applicable")
                {
                }
                field("Direct Associate"; Rec."Direct Associate")
                {
                }
                field("Actual Milestone"; Rec."Actual Milestone")
                {
                }
                field("Charge Code"; Rec."Charge Code")
                {
                }
                field("Due Amount"; Rec."Due Amount")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("First Milestone %"; Rec."First Milestone %")
                {
                }
                field("Second Milestone %"; Rec."Second Milestone %")
                {
                }
                field("Payment Plan"; Rec."Payment Plan")
                {
                }
                field("Version No."; Rec."Version No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

