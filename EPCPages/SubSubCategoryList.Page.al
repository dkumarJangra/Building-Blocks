page 97875 "Sub Sub Category List"
{
    PageType = Card;
    SourceTable = "Sub Sub Category";
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
                    RunObject = Page "Sub Sub Category";
                    RunPageLink = Code = FIELD(Code);
                    ShortCutKey = 'Shift+F7';
                }
                action(New)
                {
                    Caption = 'New';
                    RunObject = Page "Sub Sub Category";
                }
            }
        }
    }
}

