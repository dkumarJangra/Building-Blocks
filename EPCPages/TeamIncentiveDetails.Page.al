page 50040 "Team Incentive Details"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Team Incentive Allotment Temp";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Parent Code"; Rec."Parent Code")
                {
                }
                field("Self Extent"; Rec."Self Extent")
                {
                }
                field("Self Collection"; Rec."Self Collection")
                {
                }
                field(Extent; Rec.Extent)
                {
                }
                field(Collection; Rec.Collection)
                {
                }
                field("Extent Eligible Amount"; Rec."Extent Eligible Amount")
                {
                }
                field("Plot Eligible Amount"; Rec."Plot Eligible Amount")
                {
                }
                field("Payable Incentive Amount"; Rec."Payable Incentive Amount")
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
            }
        }
    }

    actions
    {
    }
}

