page 97726 "ID 2 Groups"
{
    DataCaptionFields = "ID 1 Group Code";
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "ID 2 Group";
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
                    Visible = false;
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    Visible = false;
                }
                field("ID 1 Group Code"; Rec."ID 1 Group Code")
                {
                    Visible = false;
                }
                field("ID 2 Group Code"; Rec."ID 2 Group Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&ID 3 Groups")
            {
                Caption = '&ID 3 Groups';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Commission Generation Temp";
                // RunPageLink = Field1 = FIELD("Item Category Code"),
                //               Field2=FIELD("Product Group Code"),
                //               Field3=FIELD("ID 1 Group Code"),
                //               Field4=FIELD("ID 2 Group Code");
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF CurrPage.LOOKUPMODE THEN
            CurrPage.EDITABLE := FALSE;
    end;
}

