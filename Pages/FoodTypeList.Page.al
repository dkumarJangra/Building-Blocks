page 60664 "Food Type List"
{
    PageType = List;
    SourceTable = "Food Type Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Food Type ID"; Rec."Food Type ID")
                {
                }
                field("Food Type Description"; Rec."Food Type Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}

