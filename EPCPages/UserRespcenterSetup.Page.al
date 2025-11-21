page 97787 "User Resp center Setup"
{
    PageType = List;
    SourceTable = "User Res. Center Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Responsibility Center Name"; Rec."Responsibility Center Name New")
                {
                    Editable = False;
                    Caption = 'Responsibility Center Name';
                }
            }
        }
    }

    actions
    {
    }
}

