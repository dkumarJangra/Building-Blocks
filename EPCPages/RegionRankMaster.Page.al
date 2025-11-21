page 50071 "Region/Rank Master"
{
    PageType = Card;
    SourceTable = "Rank Code Master";
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
                field("Min Days"; Rec."Min Days")
                {
                }
                field("Max Days"; Rec."Max Days")
                {
                }
                field("Min. Amount"; Rec."Min. Amount")
                {
                }
                field(Extent; Rec.Extent)
                {
                }
                field("Max Amount"; Rec."Max Amount")
                {
                }
                field("No of Days"; Rec."No of Days")
                {
                }
                field("Use for CP only"; Rec."Use for CP only")
                {

                }
                field("Applicable New commission Str."; Rec."Applicable New commission Str.")
                {

                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Rank)
            {
                Caption = 'Rank';
                action("Rank List")
                {
                    Caption = 'Rank List';
                    RunObject = Page "Rank Code";
                    RunPageLink = "Rank Batch Code" = FIELD(Code);
                }
            }
        }
    }

    var
        RankCode: Record "Rank Code";
        RankCd: Code[10];
}

