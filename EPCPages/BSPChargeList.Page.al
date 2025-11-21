page 97961 "BSP Charge List"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Unit Charge & Payment Pl. Code";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(ExcessCode; Rec.ExcessCode)
                {
                }
                field("Priority Booking Code"; Rec."Priority Booking Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

