page 50174 "Application Rate Change Setup"
{
    PageType = List;
    SourceTable = "Application Rate Change Setup";
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
                field("Payment Option"; Rec."Payment Option")
                {
                }
                field("No. of Days"; Rec."No. of Days")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}

