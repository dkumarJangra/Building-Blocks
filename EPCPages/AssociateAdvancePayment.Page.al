page 50123 "Associate Advance Payment"
{
    CardPageID = "Associate Advance Payment Form";
    PageType = List;
    SourceTable = "Assoc Pmt Voucher Header";
    SourceTableView = WHERE(Post = FILTER(false),
                            "Sub Type" = FILTER(AssociateAdvance));
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
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field(Type; Rec.Type)
                {
                }
            }
        }
    }

    actions
    {
    }
}

