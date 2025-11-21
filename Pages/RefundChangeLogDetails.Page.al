page 50182 "Refund Change Log Details"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Refund Change Log Details";
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
                field(Amount; Rec.Amount)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Refund SMS Status"; Rec."Refund SMS Status")
                {
                }
                field("Refund Initiate Amount"; Rec."Refund Initiate Amount")
                {
                }
                field("Refund Rejection Remark"; Rec."Refund Rejection Remark")
                {
                }
                field("Refund Rejection SMS Sent"; Rec."Refund Rejection SMS Sent")
                {
                }
                field("Submission Date"; Rec."Submission Date")
                {
                }
                field("Completed Date"; Rec."Completed Date")
                {
                }
                field("Rejected Date"; Rec."Rejected Date")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Modified By"; Rec."Modified By")
                {
                }
                field("Modify Date"; Rec."Modify Date")
                {
                }
                field("Modify Time"; Rec."Modify Time")
                {
                }
                field("Old Refund SMS Status"; Rec."Old Refund SMS Status")
                {
                }
                field("Old Refund Initiate Amount"; Rec."Old Refund Initiate Amount")
                {
                }
                field("Old Refund Rejection Remark"; Rec."Old Refund Rejection Remark")
                {
                }
                field("Old Refund Rejection SMS Sent"; Rec."Old Refund Rejection SMS Sent")
                {
                }
            }
        }
    }

    actions
    {
    }
}

