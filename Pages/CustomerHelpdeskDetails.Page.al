page 50265 "Customer Helpdesk Details"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Customer HelpDesk TicketDetail";
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
                    Editable = false;
                }
                field("Customer ID"; Rec."Customer ID")
                {
                    Editable = false;
                }
                field("Request Date"; Rec."Request Date")
                {
                    Editable = false;
                }
                field("Request Time"; Rec."Request Time")
                {
                    Editable = false;
                }
                field("Request Description"; Rec."Request Description")
                {
                    Editable = false;
                }
                field("Request Description 2"; Rec."Request Description 2")
                {
                    Editable = false;
                }
                field("Request Description 3"; Rec."Request Description 3")
                {
                    Editable = false;
                }
                field("Request Description 4"; Rec."Request Description 4")
                {
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field(Comment; Rec.Comment)
                {
                }
                field(Subject; Rec.Subject)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

