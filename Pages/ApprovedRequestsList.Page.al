page 50285 "Approved Requests List"
{
    PageType = List;
    SourceTable = "Request to Approve Documents";
    SourceTableView = WHERE(Status = FILTER(<> ' '));
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
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Requester ID"; Rec."Requester ID")
                {
                }
                field("Approver ID"; Rec."Approver ID")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Requester DateTime"; Rec."Requester DateTime")
                {
                }
                field("Status Date Time"; Rec."Status Date Time")
                {
                }
                field(Sequence; Rec.Sequence)
                {
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                }
                field("Reject Comment"; Rec."Reject Comment")
                {
                }
                field("Actual Approved By"; Rec."Actual Approved By")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Document Attachment")
            {
                RunObject = Page "Document file Upload";
                RunPageLink = "Document No." = FIELD("Document No.");
            }
        }
    }

    var
        Document: Record Document;
        ApprovedRequestsList: Page "Approved Requests List";
}

