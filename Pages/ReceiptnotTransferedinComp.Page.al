page 50095 "Receipt not Transfered in Comp"
{
    PageType = Card;
    SourceTable = "NewApplication Payment Entry";
    SourceTableView = WHERE("Receipt post on InterComp" = FILTER(false),
                            "Cheque Status" = FILTER(<> Cancelled));
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
                field("Line No."; Rec."Line No.")
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
                field(Posted; Rec.Posted)
                {
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Posting date"; Rec."Posting date")
                {
                }
                field("Receipt post InterComp Date"; Rec."Receipt post InterComp Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

