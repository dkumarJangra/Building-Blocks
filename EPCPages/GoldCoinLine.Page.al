page 97954 "Gold Coin Line"
{
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Gold Coin Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Plot Size"; Rec."Plot Size")
                {
                    Editable = false;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Branch Name"; Rec."Branch Name")
                {
                }
                field("Min. No. of Gold Coins"; Rec."Min. No. of Gold Coins")
                {
                }
                field("No. of Gold Coins on Full Pmt."; Rec."No. of Gold Coins on Full Pmt.")
                {
                    Caption = 'No. of Gold Coins on Full Pmt. (Exclude)';
                }
                field("No. of Silver Coins on Reg."; Rec."No. of Silver Coins on Reg.")
                {
                }
                field("Due Days"; Rec."Due Days")
                {
                    Caption = 'Due Days for Gold Coin';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Due Days for Min. Gold Coin"; Rec."Due Days for Min. Gold Coin")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

