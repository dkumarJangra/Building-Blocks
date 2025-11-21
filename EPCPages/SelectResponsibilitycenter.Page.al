page 97898 "Select Responsibility center"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
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
                field("Responsibility Center Name"; Rec."Responsibility Center Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

