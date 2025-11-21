page 97836 "Discount Entries Details"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Debit App. Payment Entry";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Payment Method"; Rec."Payment Method")
                {
                }
                field("Net Payable Amt"; Rec."Net Payable Amt")
                {
                }
                field("Commission Adj. Amount"; Rec."Commission Adj. Amount")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                }
                field(Posted; Rec.Posted)
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Posting date"; Rec."Posting date")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                    Caption = 'Associate Code';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Base Amount"; Rec."Base Amount")
                {
                }
                field("Principal Adj. Amount"; Rec."Principal Adj. Amount")
                {
                }
                field("Commission %"; Rec."Commission %")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("BBG Discount"; Rec."BBG Discount")
                {
                }
                field("Introducer Name"; Rec."Introducer Name")
                {
                    Caption = 'Associate Name';
                }
            }
        }
    }

    actions
    {
    }
}

