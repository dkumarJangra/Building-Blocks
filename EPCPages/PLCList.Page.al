page 97839 "PLC List"
{
    Caption = 'Preferencial Location Charges List';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = PLC;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Description; Rec.Description)
                {
                }
                field("Fixed Amount"; Rec."Fixed Amount")
                {
                }
                field("Rate (sq ft)"; Rec."Rate (sq ft)")
                {
                    Caption = 'Rate (/UOM)';
                    MultiLine = true;
                }
                field("PLC %"; Rec."PLC %")
                {
                }
                field("PLC Dependency Code"; Rec."PLC Dependency Code")
                {
                }
                field("PLC % Amount"; Rec."PLC % Amount")
                {
                    Editable = false;
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
            CurrPage.EDITABLE(FALSE);
    end;
}

