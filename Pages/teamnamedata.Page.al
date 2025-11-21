page 50195 "team name data"
{
    PageType = List;
    SourceTable = "Customers Lead_2";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Request From"; Rec."Request From")
                {
                }
                field("Lead Associate / Customer Id"; Rec."Lead Associate / Customer Id")
                {
                }
                field("Reporting Office Name"; Rec."Reporting Office Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

