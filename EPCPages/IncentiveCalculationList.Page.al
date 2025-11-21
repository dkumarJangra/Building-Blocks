page 97913 "Incentive Calculation List"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Incentive Calculation";
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
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
                field("Target Business Amount"; Rec."Target Business Amount")
                {
                }
                field("New Business Amount"; Rec."New Business Amount")
                {
                }
                field("Recurring Business Amount"; Rec."Recurring Business Amount")
                {
                }
                field("Business Amount"; Rec."Business Amount")
                {
                }
                field("Achievement (%)"; Rec."Achievement (%)")
                {
                }
                field("Min. Achievement (%)"; Rec."Min. Achievement (%)")
                {
                }
                field("Incentive Amount"; Rec."Incentive Amount")
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

