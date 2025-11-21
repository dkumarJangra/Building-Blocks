page 60729 "Document Approval Details"
{
    AutoSplitKey = true;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Request to Approve Documents";
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
                field("Requester DateTime"; Rec."Requester DateTime")
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
                field("Status Date Time"; Rec."Status Date Time")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Reject Comment"; Rec."Reject Comment")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

