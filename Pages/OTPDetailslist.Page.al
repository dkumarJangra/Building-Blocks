page 60715 "OTP Details list"
{
    Editable = false;
    PageType = List;
    SourceTable = "Customer Lead OTP Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Lead Id"; Rec."Lead Id")
                {
                }
                field(OTP; Rec.OTP)
                {
                }
                field("Is used"; Rec."Is used")
                {
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
            }
        }
    }

    actions
    {
    }
}

