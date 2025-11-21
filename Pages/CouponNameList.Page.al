page 60662 "Coupon Name List"
{
    PageType = List;
    SourceTable = "Coupon Name Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Coupon Name ID"; Rec."Coupon Name ID")
                {
                }
                field("Coupon Description"; Rec."Coupon Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}

