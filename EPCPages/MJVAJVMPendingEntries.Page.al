page 50066 "MJV/AJVM Pending Entries"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Application Payment Entry";
    SourceTableView = WHERE(Posted = FILTER(false));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
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
                        IF Rec."Payment Method" = 'AJVM' THEN
                            PAGE.RUNMODAL(Page::"Associate to Member", Conforder_1)
                        ELSE
                            IF Rec."Payment Method" = 'MJV' THEN
                                PAGE.RUNMODAL(Page::"Member to Member Transfer", Conforder_1)
                            ELSE
                                IF Rec."Payment Mode" = Rec."Payment Mode"::"Debit Note" THEN
                                    PAGE.RUNMODAL(Page::"Unit credit Card", Conforder_1);

                    END;
                end;
            }
        }
    }

    var
        Conforder_1: Record "Confirmed Order";
}

