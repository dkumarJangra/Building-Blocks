page 97912 "Incentive Setup"
{
    PageType = Card;
    SourceTable = "Incentive Setup";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
                field("WEF Date"; Rec."WEF Date")
                {
                }
                field(Active; Rec.Active)
                {
                }
                field("Business Amount"; Rec."Business Amount")
                {
                }
                field("Min. Achievement %"; Rec."Min. Achievement %")
                {
                }
                field("Incentive Amount"; Rec."Incentive Amount")
                {
                }
                field("Additional Business Per"; Rec."Additional Business Per")
                {
                }
                field("Additional Incentive Amount"; Rec."Additional Incentive Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

