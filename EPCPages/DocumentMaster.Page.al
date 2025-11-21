page 97798 "Document Master"
{
    DataCaptionExpression = FORMAT(Rec."Document Type") + ' ' + Rec.Code;
    PageType = Card;
    SourceTable = "Document Master";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Code; Rec.Code)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Description; Rec.Description)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
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

