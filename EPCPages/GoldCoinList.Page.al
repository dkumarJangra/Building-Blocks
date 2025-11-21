page 97993 "Gold Coin List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Gold Coin Line";
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
                field("Effective Date"; Rec."Effective Date")
                {
                }
                field("Due Days"; Rec."Due Days")
                {
                }
                field("Min. No. of Gold Coins"; Rec."Min. No. of Gold Coins")
                {
                }
                field("Item Code"; Rec."Item Code")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field("No. of Gold Coins on Full Pmt."; Rec."No. of Gold Coins on Full Pmt.")
                {
                }
                field("No. of Extra Coins"; Rec."No. of Extra Coins")
                {
                }
                field("Plot Size"; Rec."Plot Size")
                {
                }
                field("Due Days for Min. Gold Coin"; Rec."Due Days for Min. Gold Coin")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

