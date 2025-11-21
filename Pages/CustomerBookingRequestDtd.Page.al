page 50266 "Customer Booking Request Dtd."
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Customer Booking Request Dtd.";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request No."; Rec."Request No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field(Time; Rec.Time)
                {
                }
                field("Customer ID"; Rec."Customer ID")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Plot Code"; Rec."Plot Code")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Project Nam"; Rec."Project Nam")
                {
                }
                field("USER ID"; Rec."USER ID")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Comments; Rec.Comments)
                {
                }
            }
        }
    }

    actions
    {
    }
}

