page 50615 "Lead Head Associate List"
{
    Caption = 'Lead Team Head associate Data';
    PageType = List;
    SourceTable = "Lead Team HeadAssociate list";
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
            }
        }
    }

    actions
    {
    }
}

