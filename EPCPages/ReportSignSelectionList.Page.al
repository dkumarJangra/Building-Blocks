page 97939 "Report Sign. Selection List"
{
    Caption = 'Report Signanture Selection List';
    PageType = Card;
    SourceTable = "Report Signature Selections";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Report ID"; Rec."Report ID")
                {
                }
                field("Report Name"; Rec."Report Name")
                {
                }
                // field("Signature.HASVALUE";
                // Signature.HASVALUE)
                // {
                //     Caption = 'Signature Exists';
                // }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Report Signature")
            {
                Caption = 'Report Signature';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Report Sign. Selection Card";
                    RunPageLink = "Report ID" = FIELD("Report ID");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }
}

