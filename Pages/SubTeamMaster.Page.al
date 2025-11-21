page 60681 "Sub Team Master"
{
    PageType = List;
    SourceTable = "Sub Team Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sub Team Code"; Rec."Sub Team Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

