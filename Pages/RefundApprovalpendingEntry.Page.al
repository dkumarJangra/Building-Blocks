page 50077 "Refund Approval pending Entry"
{
    Editable = false;
    PageType = Card;
    SourceTable = "NewApplication Payment Entry";
    SourceTableView = WHERE(Posted = FILTER(false));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                }
                field("Payment Method"; Rec."Payment Method")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Narration; Rec.Narration)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Posting date"; Rec."Posting date")
                {
                }
                field("User Branch Code"; Rec."User Branch Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Card")
            {
                Caption = '&Card';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Conforder_1.RESET;
                    Conforder_1.SETRANGE("No.", Rec."Document No.");
                    IF Conforder_1.FINDFIRST THEN BEGIN
                        PAGE.RUNMODAL(Page::"Refund/Negative Adj", Conforder_1)
                    END;
                end;
            }
        }
    }

    var
        Conforder_1: Record "New Confirmed Order";
}

