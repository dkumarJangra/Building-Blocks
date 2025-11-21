page 60712 "Mobile Report List"
{
    PageType = List;
    SourceTable = "Mobile Report List";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Report ID"; Rec."Report ID")
                {
                }
                field("Report Name"; Rec."Report Name")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Allow Report on Mobile"; Rec."Allow Report on Mobile")
                {
                }
                field("Date Filters Required"; Rec."Date Filters Required")
                {
                }
            }
        }
    }

    actions
    {
    }
}

