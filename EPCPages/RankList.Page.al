page 97921 "Rank List"
{
    PageType = List;
    SourceTable = Rank;
    UsageCategory = Lists;
    ApplicationArea = All;

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
                field("Direct Entry"; Rec."Direct Entry")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unction")
            {
                Caption = 'F&unction';
                action("&Release")
                {
                    Caption = '&Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.EDITABLE(FALSE);
                        CurrPage.UPDATE;
                    end;
                }
                action("Re&Open")
                {
                    Caption = 'Re&Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.EDITABLE(TRUE);
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }
}

