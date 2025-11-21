page 97934 "Bonus Entry Posted"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Bonus Entry Posted";
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
                field("Associate Rank"; Rec."Associate Rank")
                {
                }
                field("Bonus %"; Rec."Bonus %")
                {
                }
                field("Bonus Amount"; Rec."Bonus Amount")
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
                field("Paid To"; Rec."Paid To")
                {
                }
                field("Posted Doc. No."; Rec."Posted Doc. No.")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Unit Office Code(Paid)"; Rec."Unit Office Code(Paid)")
                {
                }
                field("Counter Code(Paid)"; Rec."Counter Code(Paid)")
                {
                }
                field("Pmt Received From Code"; Rec."Pmt Received From Code")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("G/L Posting Date"; Rec."G/L Posting Date")
                {
                }
                field("G/L Document Date"; Rec."G/L Document Date")
                {
                }
            }
        }
    }

    actions
    {
    }


    procedure SetRecord(BondNo: Code[20])
    var
        BonusEntryPosted: Record "Bonus Entry Posted";
        BonusPostingBuffer: Record "Bonus Posting Buffer";
        BonusEntry: Record "Bonus Entry";
        BondToken: Record "Vendor Enquiry Details";
    begin
        BonusEntryPosted.SETCURRENTKEY("Unit No.");
        BonusEntryPosted.SETRANGE("Unit No.", BondNo);
        IF BonusEntryPosted.FINDSET THEN
            REPEAT
                Rec.TRANSFERFIELDS(BonusEntryPosted);
                Rec.INSERT;
            UNTIL BonusEntryPosted.NEXT = 0;

        BonusPostingBuffer.SETCURRENTKEY("Unit No.");
        BonusPostingBuffer.SETRANGE("Unit No.", BondNo);
        BonusPostingBuffer.SETRANGE(Status, BonusPostingBuffer.Status::Posted);
        IF BonusPostingBuffer.FINDSET THEN
            REPEAT
                BondToken.GET(BonusPostingBuffer."Token No.");
            /*IF BondToken."Enquiry no." THEN
              IF BonusEntry.GET(BonusPostingBuffer."Entry No.") THEN BEGIN
                "Entry No."  := BonusEntry."Entry No.";
                "Bond No." := BonusEntry."Bond No.";
                "Posting Date" := BonusPostingBuffer."Posting Date";
                "MM Code" := BonusPostingBuffer."MM Code";
                "Base Amount" := BonusPostingBuffer."Base Amount";
                "Bonus %" := BonusEntry."Bonus %";
                "Bonus Amount" := BonusPostingBuffer."Bonus Amount";
                "Installment No." := BonusEntry."Installment No.";
                "Business Type" := BonusEntry."Business Type";
                "Introducer Code" := BonusEntry."Introducer Code";
                "Scheme Code" := BonusEntry."Scheme Code";
                "Bond Type" := BonusEntry."Bond Type";
                Duration := BonusEntry.Duration;
                "MM Rank" := BonusEntry."MM Rank";
                "Paid To" := BonusPostingBuffer."Paid To";
                "Posted Doc. No." := BonusPostingBuffer."Posted Doc. No.";
                "Shortcut Dimension 1 Code" := BonusPostingBuffer."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := BonusPostingBuffer."Shortcut Dimension 2 Code";
                "Unit Office Code(Paid)" := BonusPostingBuffer."Unit Office Code(Paid)";
                "Counter Code(Paid)" := BonusPostingBuffer."Counter Code(Paid)";
                "Pmt Received From Code" := BonusPostingBuffer."Pmt Received From Code";
                "Document Date" := BonusPostingBuffer."Document Date";
                "G/L Posting Date" := BonusPostingBuffer."G/L Posting Date";
                "G/L Document Date" := BonusPostingBuffer."G/L Document Date";
                INSERT;
              END;
              */
            UNTIL BonusPostingBuffer.NEXT = 0;

    end;
}

