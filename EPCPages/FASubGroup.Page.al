page 97752 "FA Sub Group"
{
    PageType = Card;
    SourceTable = "Fixed Asset Sub Group";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("FA Code"; Rec."FA Code")
                {
                }
                field(Item; Rec.Item)
                {
                }
                field(Capacity; Rec.Capacity)
                {
                }
                field("FA Sub Group"; Rec."FA Sub Group")
                {
                }
                field(Work; Rec.Work)
                {
                }
            }
        }
    }

    actions
    {
    }
}

