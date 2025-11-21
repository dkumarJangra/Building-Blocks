page 97774 "Price Group Master"
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
                field("Sale/Lease"; Rec."Sale/Lease")
                {
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
        area(processing)
        {
            action("PPG Details")
            {
                Caption = 'PPG Details';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Project Price Group Details";
                RunPageLink = "Project Code" = FIELD("Project Code"),
                              "Project Price Group" = FIELD(Code);
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF CurrPage.LOOKUPMODE THEN
            CurrPage.EDITABLE := FALSE;
    end;
}

