page 60691 "Gamification Team Hierarchy"
{
    Editable = false;
    PageType = List;
    SourceTable = "Gamification Team Hierarchy";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Team Top Head"; Rec."Team Top Head")
                {
                }
                field(DOJ; Rec.DOJ)
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

