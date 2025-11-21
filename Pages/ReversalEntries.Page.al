page 50128 "Reversal Entries"
{
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    Permissions = TableData "Reversal Entry" = rimd;
    SourceTable = "Reversal Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("G/L Register No."; Rec."G/L Register No.")
                {
                }
                field("Source Code"; Rec."Source Code")
                {
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                }
                field("Source Type"; Rec."Source Type")
                {
                }
                field("Source No."; Rec."Source No.")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Account No."; Rec."Account No.")
                {
                }
                field("Account Name"; Rec."Account Name")
                {
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                }
                field("FA Posting Category"; Rec."FA Posting Category")
                {
                }
                field("FA Posting Type"; Rec."FA Posting Type")
                {
                }
                field("Reversal Type"; Rec."Reversal Type")
                {
                }
                // field("TDS Amount"; "TDS Amount")
                // {
                // }
                // field("TCS Amount"; "TCS Amount")
                // {
                // }
                field(AutoReverse; Rec.AutoReverse)
                {
                }
            }
        }
    }

    actions
    {
    }
}

