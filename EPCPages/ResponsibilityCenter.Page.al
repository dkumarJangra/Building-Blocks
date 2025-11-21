page 97785 "Responsibility Center"
{
    PageType = Card;
    SourceTable = "User Res. Center Setup";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Responsibility Center Name"; Rec."Responsibility Center Name")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;

    var
        ResName: Text[50];
        Resrec: Record "Responsibility Center 1";
}

