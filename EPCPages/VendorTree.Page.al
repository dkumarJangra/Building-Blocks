page 50045 "Vendor Tree"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Vendor Tree";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Region/Rank Code"; Rec."Region/Rank Code")
                {
                    Editable = false;
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                    Editable = false;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    Editable = false;
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Editable = false;
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Parent Code"; Rec."Parent Code")
                {
                    Editable = false;
                }
                field("Rank Code"; Rec."Rank Code")
                {
                    Editable = false;
                }
                field("Rank Description"; Rec."Rank Description")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        VendTree.RESET;
                        VendTree.SETRANGE("Region/Rank Code", Rec."Region/Rank Code");
                        VendTree.SETRANGE("Introducer Code", Rec."Introducer Code");
                        PAGE.RUN(PAGE::"Vendor Tree Region wise", VendTree);
                    end;
                }
            }
        }
    }

    var
        VendTree: Record "Vendor Tree";
}

