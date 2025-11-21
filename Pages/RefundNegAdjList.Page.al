page 50122 "Refund/Neg. Adj. List"
{
    CardPageID = "Refund/Negative Adj";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "New Confirmed Order";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
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
                field(Status; Rec.Status)
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Refund Initiate Amount"; Rec."Refund Initiate Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

