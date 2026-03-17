page 50616 "Lead Head Ass. Hierarchy Data"
{
    Caption = 'Lead Team Head Ass. Hierarchy Data';
    PageType = List;
    SourceTable = "Lead Team HeadAssHierarchy";
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
                field("Name"; Rec."Name")
                {
                }
                field("Region Code"; Rec."Region Code")
                {
                }
                field("Team Head ID"; Rec."Team Head ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

