page 50191 "Posted Associate Paymt List"
{
    CardPageID = "Posted Associate Paymt voucher";
    PageType = List;
    SourceTable = "Assoc Pmt Voucher Header";
    SourceTableView = WHERE(Post = CONST(true));
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Paid To"; Rec."Paid To")
                {
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                }
                field("Bank/G L Code"; Rec."Bank/G L Code")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

