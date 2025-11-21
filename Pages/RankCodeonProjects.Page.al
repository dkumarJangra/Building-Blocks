page 50038 "Rank Code on Projects"
{
    Editable = false;
    PageType = Card;
    SourceTable = Job;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Region Code for Rank Hierarcy"; Rec."Region Code for Rank Hierarcy")
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

