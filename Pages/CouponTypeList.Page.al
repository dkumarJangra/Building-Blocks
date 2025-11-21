page 60663 "Coupon Type List"
{
    PageType = List;
    SourceTable = "Coupon Type Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Coupon Type ID"; Rec."Coupon Type ID")
                {
                }
                field("Coupon Type Name"; Rec."Coupon Type Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

