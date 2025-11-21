page 60728 "Approval Workflow Process Audt"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Approval Workflow for Audit Pr";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Requester ID"; Rec."Requester ID")
                {
                }
                field("Approver ID"; Rec."Approver ID")
                {
                }
                field("Requester Name"; Rec."Requester Name")
                {
                }
                field("Approver Name"; Rec."Approver Name")
                {
                }
                field(Sequence; Rec.Sequence)
                {
                }
                field("Parallel Approval"; Rec."Parallel Approval")
                {
                }


            }
        }
    }

    actions
    {
    }
}

