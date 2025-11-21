page 50002 "Application Payment Entry List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Application Payment Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Payment Method"; Rec."Payment Method")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Cheque No./ Transaction No."; Rec."Cheque No./ Transaction No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                }
                field("Chq. Cl / Bounce Dt."; Rec."Chq. Cl / Bounce Dt.")
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
                field("Installment No."; Rec."Installment No.")
                {
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                }
                field("Not Refundable"; Rec."Not Refundable")
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
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Posting date"; Rec."Posting date")
                {
                }
                field(Reversed; Rec.Reversed)
                {
                }
                field("Milestone Code"; Rec."Milestone Code")
                {
                }
                field("Commision Applicable"; Rec."Commision Applicable")
                {
                }
                field("Direct Associate"; Rec."Direct Associate")
                {
                }
                field("Explode BOM"; Rec."Explode BOM")
                {
                }
                field("Reversal Document No."; Rec."Reversal Document No.")
                {
                }
                field("Order Ref No."; Rec."Order Ref No.")
                {
                }
                field("User Branch Code"; Rec."User Branch Code")
                {
                }
                field("Created From Application"; Rec."Created From Application")
                {
                }
                field("Deposit / Paid Bank Name"; Rec."Deposit / Paid Bank Name")
                {
                }
                field("Gold Coin Eligibility"; Rec."Gold Coin Eligibility")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

