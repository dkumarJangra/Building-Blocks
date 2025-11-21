page 97879 "Terms list"
{
    // //AlleDK 110808 : This code is used for the not modification after the Order Approved :=  TRUE.

    AutoSplitKey = true;
    Caption = 'Terms & Conditions';
    PageType = CardPart;
    SourceTable = Terms;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Visible = false;
                }
                field("Term Type"; Rec."Term Type")
                {
                    Editable = false;
                }
                field(Narration; Rec.Narration)
                {
                    Caption = 'TERMS && CONDITION';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //AlleDK 110808
        PHeader.RESET;
        PHeader.SETRANGE(PHeader."No.", Rec."Document No.");
        PHeader.SETRANGE(PHeader.Approved, TRUE);
        IF PHeader.FINDFIRST THEN
            CurrPage.EDITABLE(FALSE);
        //AlleDK 110808

        //ALLEAA begin
        PHeader.RESET;
        PHeader.SETRANGE("No.", Rec."Document No.");
        PHeader.SETRANGE(Amended, TRUE);
        PHeader.SETRANGE("Amendment Approved", FALSE);
        IF PHeader.FINDFIRST THEN
            CurrPage.EDITABLE(TRUE);

        PHeader.RESET;
        PHeader.SETRANGE("No.", Rec."Document No.");
        PHeader.SETRANGE("Amendment Approved", TRUE);
        IF PHeader.FINDFIRST THEN
            CurrPage.EDITABLE(FALSE);
        //ALLEAA end
    end;

    var
        PHeader: Record "Purchase Header";
}

