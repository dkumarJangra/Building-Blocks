page 50165 "Project wise Gold Proj. Setup"
{
    PageType = List;
    SourceTable = "Project wise Gold Proj Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                }
                field("From Extent"; Rec."From Extent")
                {
                }
                field("To Extent"; Rec."To Extent")
                {
                }
                field("Gold Eligibility (gm)"; Rec."Gold Eligibility (gm)")
                {
                }
                field(Days; Rec.Days)
                {
                }
            }
        }
    }

    actions
    {
    }
}

