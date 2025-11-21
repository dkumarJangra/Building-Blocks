page 97864 "Category List"
{
    PageType = Card;
    SourceTable = Category;
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
                field(Name; Rec.Name)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Card)
            {
                Caption = 'Card';
                action(Edit)
                {
                    Caption = 'Edit';
                    RunObject = Page Category;
                    RunPageLink = Code = FIELD(Code);
                    ShortCutKey = 'Shift+F7';
                }
                action(New)
                {
                    Caption = 'New';
                    RunObject = Page Category;
                }
            }
        }
    }
}

