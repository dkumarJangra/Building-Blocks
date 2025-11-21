page 50131 "Cluster State Master"
{
    PageType = List;
    SourceTable = "Cluster State Master";
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("State Id"; Rec."State Id")
                {
                }
                field("State Name"; Rec."State Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

