page 97933 "Bonus Entry"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Bonus Entry";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Unit No."; Rec."Unit No.")
                {
                }
                field("Installment No."; Rec."Installment No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Base Amount"; Rec."Base Amount")
                {
                }
                field("Bonus %"; Rec."Bonus %")
                {
                }
                field("Bonus Amount"; Rec."Bonus Amount")
                {
                }
                field(Stopped; Rec.Stopped)
                {
                }
                field("Business Type"; Rec."Business Type")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Scheme Code"; Rec."Scheme Code")
                {
                }
                field("Project Type"; Rec."Project Type")
                {
                }
                field(Duration; Rec.Duration)
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Pmt Received From Code"; Rec."Pmt Received From Code")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        ComEntry: Record "Commission Entry";


    procedure SetRecord(BondNo: Code[20])
    var
        BonusEntry: Record "Bonus Entry";
        BonusPostingBuffer: Record "Bonus Posting Buffer";
        BondToken: Record "Vendor Enquiry Details";
    begin
        BonusEntry.SETCURRENTKEY("Unit No.", "Installment No.");
        BonusEntry.SETRANGE("Unit No.", BondNo);
        IF BonusEntry.FINDSET THEN
            REPEAT
                BonusPostingBuffer.SETRANGE("Entry No.", BonusEntry."Entry No.");
                BonusPostingBuffer.SETRANGE(Status, BonusPostingBuffer.Status::Posted);
                IF BonusPostingBuffer.FINDSET THEN BEGIN
                    REPEAT
                    //BondToken.GET(BonusPostingBuffer."Token No.");
                    //IF NOT BondToken."Enquiry no." THEN BEGIN
                    //TRANSFERFIELDS(BonusEntry);
                    //INSERT;
                    //END;
                    UNTIL BonusPostingBuffer.NEXT = 0;
                END ELSE BEGIN
                    Rec.TRANSFERFIELDS(BonusEntry);
                    Rec.INSERT;
                END;
            UNTIL BonusEntry.NEXT = 0;
    end;
}

