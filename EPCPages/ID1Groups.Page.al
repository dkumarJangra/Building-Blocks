page 97848 "ID 1 Groups"
{
    DataCaptionFields = "Product Group Code";
    PageType = Card;
    SourceTable = "ID 1 Group";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Visible = true;
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    Visible = true;
                }
                field("ID 1 Group Code"; Rec."ID 1 Group Code")
                {
                    Caption = 'Sub Product Group Code';
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        IF CurrPage.LOOKUPMODE THEN
            CurrPage.EDITABLE := FALSE;
    end;
}

