page 50052 "TA SEtup Line list"
{
    PageType = List;
    SourceTable = "Travel Setup Line New";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Effective Date"; Rec."Effective Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field(Rate; Rec.Rate)
                {
                }
                field("TA Code"; Rec."TA Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

