page 60674 "R-1 PRR List"
{
    CardPageID = "R-1 PRR Card";
    Editable = false;
    PageType = List;
    SourceTable = "Land R-1 PPR Document Lis_1";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Village Name"; Rec."Village Name")
                {
                }
                field("Mandalam Name"; Rec."Mandalam Name")
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field("Total Land Area"; Rec."Total Land Area")
                {
                }
                field("Type of the land"; Rec."Type of the land")
                {
                }
            }
        }
    }

    actions
    {
    }
}

