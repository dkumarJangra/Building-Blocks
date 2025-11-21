page 97928 "Commission Entry"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Commission Entry";
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
                field("Application No."; Rec."Application No.")
                {
                }
                field("Installment No."; Rec."Installment No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Direct to Associate"; Rec."Direct to Associate")
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
                field(Posted; Rec.Posted)
                {
                }
                field(Reversal; Rec.Reversal)
                {
                }
                field("Remaining Amt of Direct"; Rec."Remaining Amt of Direct")
                {
                }
                field("Opening Entries"; Rec."Opening Entries")
                {
                }
                field("Commission %"; Rec."Commission %")
                {
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                }
                field("On Hold"; Rec."On Hold")
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
                field("Voucher No."; Rec."Voucher No.")
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
        CommissionEntry: Record "Commission Entry";
        CommVoucherPostingBuffer: Record "Comm. Voucher Posting Buffer";
    begin
        CommissionEntry.SETCURRENTKEY("Application No.", "Installment No.");
        CommissionEntry.SETRANGE("Application No.", BondNo);
        IF CommissionEntry.FINDSET THEN
            REPEAT
                IF NOT CommVoucherPostingBuffer.GET(CommissionEntry."Voucher No.") THEN BEGIN
                    Rec.TRANSFERFIELDS(CommissionEntry);
                    Rec.INSERT;
                END;
            UNTIL CommissionEntry.NEXT = 0;
    end;
}

