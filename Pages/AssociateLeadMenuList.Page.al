page 50240 "Associate Lead Menu List"
{
    CardPageID = "Associate Lead Menu Card";
    PageType = List;
    SourceTable = "Associate Lead Menu Master";
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Is for Customer"; Rec."Is for Customer")

                {

                }

            }
        }
    }

    actions
    {
    }
}

