page 97871 "App. Charge Code"
{
    PageType = Card;
    SourceTable = "App. Charge Code";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Charge Type"; Rec."Charge Type")
                {
                }
            }
        }
    }

}

