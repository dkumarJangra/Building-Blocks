page 97886 "Unit Maturity List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Unit Maturity";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Unit No."; Rec."Unit No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Maturity Type"; Rec."Maturity Type")
                {
                    Editable = false;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    Editable = false;
                }
                field(Duration; Rec.Duration)
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                }
                field("Interest Amount"; Rec."Interest Amount")
                {
                    Editable = false;
                }
                field("Marking Date"; Rec."Marking Date")
                {
                    Editable = false;
                }
                field("Return Payment Mode"; Rec."Return Payment Mode")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                }
                field("Death Claim"; Rec."Death Claim")
                {
                    Editable = false;
                }
                field("Unit Office Code(Paid)"; Rec."Unit Office Code(Paid)")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Counter Code(Paid)"; Rec."Counter Code(Paid)")
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

    trigger OnOpenPage()
    begin
        Rec.FILTERGROUP(10);
        Rec.SETFILTER("Effective Date", '<=%1', WORKDATE);
        Rec.FILTERGROUP(0);
    end;
}

