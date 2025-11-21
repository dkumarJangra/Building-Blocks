page 50160 "Update BLEntry"
{
    PageType = List;
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd,
                  TableData "Bank Account Statement Line" = rimd;
    SourceTable = "Bank Account Ledger Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Bank Account No."; Rec."Bank Account No.")
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
                field(Description; Rec.Description)
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                }
                field("Bank Acc. Posting Group"; Rec."Bank Acc. Posting Group")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Our Contact Code"; Rec."Our Contact Code")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Source Code"; Rec."Source Code")
                {
                }
                field(Open; Rec.Open)
                {
                }
                field(Positive; Rec.Positive)
                {
                }
                field("Closed by Entry No."; Rec."Closed by Entry No.")
                {
                }
                field("Closed at Date"; Rec."Closed at Date")
                {
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                }
                field("Reason Code"; Rec."Reason Code")
                {
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                }
                field("Statement Status"; Rec."Statement Status")
                {
                }
                field("Statement No."; Rec."Statement No.")
                {
                }
                field("Statement Line No."; Rec."Statement Line No.")
                {
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field(Reversed; Rec.Reversed)
                {
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                }
                field("Check Ledger Entries"; Rec."Check Ledger Entries")
                {
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                }
                // field("Location Code"; "Location Code")
                // {
                // }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Stale Cheque"; Rec."Stale Cheque")
                {
                }
                field("Stale Cheque Expiry Date"; Rec."Stale Cheque Expiry Date")
                {
                }
                field("Cheque Stale Date"; Rec."Cheque Stale Date")
                {
                }
                field("Issuing Bank"; Rec."Issuing Bank")
                {
                }
                field(Test; Rec.Test)
                {
                }
                field("Value Date"; Rec."Value Date")
                {
                }
                field("Receipt Line No."; Rec."Receipt Line No.")
                {
                }
                field("Cheque No.1"; Rec."Cheque No.1")
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field(Narration; Rec.Narration)
                {
                }
                field("TO Region Code"; Rec."TO Region Code")
                {
                }
                field("TO Region Name"; Rec."TO Region Name")
                {
                }
                field("User Branch Code"; Rec."User Branch Code")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field(Bounced; Rec.Bounced)
                {
                }
                field("Send SMS on Cheq bounce"; Rec."Send SMS on Cheq bounce")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //ERROR('Hi');
        If UserId <> 'BCUSER' then
            Error('You do not have permission');
    end;
}

