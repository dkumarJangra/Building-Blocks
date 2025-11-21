page 97880 "Terms list Archived"
{
    // NDALLE 051207

    AutoSplitKey = true;
    Caption = 'Terms & Conditions';
    PageType = Card;
    SourceTable = "Terms Archived";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Term Type"; Rec."Term Type")
                {
                    Editable = false;
                }
                field(Narration; Rec.Narration)
                {
                    Caption = 'TERMS && CONDITION';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

