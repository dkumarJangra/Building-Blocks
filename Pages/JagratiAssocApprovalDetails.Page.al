page 50210 "Jagrati Assoc Approval Details"
{
    PageType = List;
    SourceTable = "Jagriti Assoc Approval Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Reporing Leader ID"; Rec."Reporing Leader ID")
                {
                }
                field("Reporing Leader Name"; Rec."Reporing Leader Name")
                {
                }
                field("Reporing Leader E-mail ID"; Rec."Reporing Leader E-mail ID")
                {
                }
                field("Team Head ID"; Rec."Team Head ID")
                {
                }
                field("Team Head Name"; Rec."Team Head Name")
                {
                }
                field("Team Head E-Mail ID"; Rec."Team Head E-Mail ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

