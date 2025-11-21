page 50127 "Bank Acc Statement Lines"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Bank Account Statement Line";
    SourceTableView = WHERE("Bank Account No." = FILTER(<> 'TEST-4' & <> 'TEST-5' & <> 'TEST-5'),
                            "Statement Amount" = FILTER(<> 0));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Account No."; Rec."Bank Account No.")
                {
                }
                field("Statement No."; Rec."Statement No.")
                {
                }
                field("Statement Line No."; Rec."Statement Line No.")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Statement Amount"; Rec."Statement Amount")
                {
                }
                field(Difference; Rec.Difference)
                {
                }
                field("Applied Amount"; Rec."Applied Amount")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Applied Entries"; Rec."Applied Entries")
                {
                }
                field("Value Date"; Rec."Value Date")
                {
                }
                field("Check No."; Rec."Check No.")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field(Bounced; Rec.Bounced)
                {
                }
                field("New Application No."; Rec."New Application No.")
                {
                }
                field(BouncedEntryPosted; Rec.BouncedEntryPosted)
                {
                }
                field("External Doc. No."; Rec."External Doc. No.")
                {
                }
                field(Reversed; Rec.Reversed)
                {
                }
                field("Bounce Type"; Rec."Bounce Type")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Receipt Line No."; Rec."Receipt Line No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

