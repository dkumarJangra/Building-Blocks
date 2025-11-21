page 50130 "ProjectWise R2 Gold_SilverList"
{
    PageType = List;
    SourceTable = "Projec Wise New Gold/Silver";
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
                field("Project Name"; Rec."Project Name")
                {
                }
                field(Extent; Rec.Extent)
                {
                }
                field("Gold Payment Plan"; Rec."Gold Payment Plan")
                {
                }
                field("Gold Coin"; Rec."Gold Coin")
                {
                }
                field("G_Valid Days for full payment"; Rec."G_Valid Days for full payment")
                {
                    Caption = 'Gold Valid Days for full payment';
                }
                field("Silver Payment Plan"; Rec."Silver Payment Plan")
                {
                }
                field("Silver Grams"; Rec."Silver Grams")
                {
                }
                field("S_Valid Days for full payment"; Rec."S_Valid Days for full payment")
                {
                    Caption = 'Silver Valid Days for full payment';
                }
            }
        }
    }

    actions
    {
    }
}

