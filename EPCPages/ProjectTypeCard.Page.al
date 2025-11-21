page 97884 "Project Type Card"
{
    PageType = Card;
    SourceTable = "Unit Type";
    SourceTableView = WHERE(Code = FILTER(<> ''));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
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

