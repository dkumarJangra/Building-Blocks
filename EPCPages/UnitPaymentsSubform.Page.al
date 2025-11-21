page 97901 "Unit Payments Subform"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Unit Payment Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment Mode"; Rec."Payment Mode")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Payment Method"; Rec."Payment Method")
                {
                }
                field(Type; Rec.Type)
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
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
                field("Posting date"; Rec."Posting date")
                {
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                    Editable = false;
                }
                field("Chq. Cl / Bounce Dt."; Rec."Chq. Cl / Bounce Dt.")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

