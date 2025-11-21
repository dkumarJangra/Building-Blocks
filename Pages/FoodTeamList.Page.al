page 60665 "Food Team List"
{
    PageType = List;
    SourceTable = "Food Team Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Food Team ID"; Rec."Food Team ID")
                {
                }
                field("Food Team Name"; Rec."Food Team Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

