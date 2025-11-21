page 80001 "Old Users"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Old User";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = all;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            // action(ActionName)
            // {

            //     trigger OnAction()
            //     begin

            //     end;
            // }
        }
    }
}