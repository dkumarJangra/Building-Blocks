page 50075 "Rank Card"
{
    PageType = Card;
    SourceTable = "Rank Code";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Rank Batch Code"; Rec."Rank Batch Code")
                {
                }
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Display Rank Code"; Rec."Display Rank Code")
                {

                }
                field("Direct Entry"; Rec."Direct Entry")
                {
                }
                field("Min. Direct Join"; Rec."Min. Direct Join")
                {
                }
                field(Category; Rec.Category)
                {
                }
            }
        }
    }

    actions
    {
    }
}

