page 50208 "Jagriti Doc. Approval Entry"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Jagriti Approval Entry";
    SourceTableView = WHERE(Status = FILTER(<> Pending));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Ref. Entry No."; Rec."Ref. Entry No.")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Approver ID"; Rec."Approver ID")
                {
                }
                field("Approver Name"; Rec."Approver Name")
                {
                }
                field("Approved / Rejected Date"; Rec."Approved / Rejected Date")
                {
                }
                field("Approved / Rejected time"; Rec."Approved / Rejected time")
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Time Sent for Approval"; Rec."Time Sent for Approval")
                {
                }
                field("Date Sent for Approval"; Rec."Date Sent for Approval")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Associate Request Details")
            {
                RunObject = Page "Jagrati Assoicate Details List";
                RunPageLink = "Request No." = FIELD("Ref. Entry No.");
            }
        }
    }
}

