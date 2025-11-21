page 50126 "Modify Bank Acc. Ledg. Entries"
{
    DeleteAllowed = false;
    InsertAllowed = false;
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
                    Editable = false;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {

                    trigger OnValidate()
                    begin
                        IF Rec."Remaining Amount" <> 0 THEN
                            IF Rec."Remaining Amount" <> Rec.Amount THEN
                                ERROR('Remaining Amount should be equal to Amount');
                    end;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                }
                field(Open; Rec.Open)
                {
                }
                field(Positive; Rec.Positive)
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
                field("Cheque No."; Rec."Cheque No.")
                {
                    Editable = false;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    Editable = false;
                }
                field("Value Date"; Rec."Value Date")
                {
                    Editable = false;
                }
                field("Receipt Line No."; Rec."Receipt Line No.")
                {
                    Editable = false;
                }
                field("Application No."; Rec."Application No.")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.RESET;
        AccessControl.SETRANGE("User Name", USERID);
        AccessControl.SETRANGE("Role ID", 'BALENTRYMODIFICATION');
        IF NOT AccessControl.FINDFIRST THEN
            ERROR('Contact Admin');
    end;
}

