pageextension 50102 "BBG Debit Voucher Account Ext" extends "Voucher Posting Debit Accounts"
{
    layout
    {
        // Add changes to page layout here
        addafter("Account No.")
        {
            field("Maximum Amount"; Rec."Maximum Amount")
            {
                ApplicationArea = all;
            }
            field("ARM Account Type"; Rec."ARM Account Type")
            {
                ApplicationArea = all;
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = all;
            }
            field("Account Name"; Rec."Account Name")
            {
                ApplicationArea = all;
            }
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = all;
            }
            field("Bank Filter for Main Comp"; Rec."Bank Filter for Main Comp")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}