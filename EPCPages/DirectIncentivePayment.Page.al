page 50061 "Direct Incentive Payment"
{
    CardPageID = "Payable Form Direct Incentive";
    PageType = List;
    SourceTable = "Assoc Pmt Voucher Header";
    SourceTableView = WHERE(Post = FILTER(false),
                            "Sub Type" = CONST(Direct));
    ApplicationArea = All;
    UsageCategory = Documents;
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
                field(Type; Rec.Type)
                {
                }
                field("Incentive Type"; Rec."Incentive Type")
                {
                }
                field("Spl. Inct. Send for Approval"; Rec."Spl. Inct. Send for Approval")
                {
                    Caption = 'Send for Approval';
                }
                field("Special Inc. Rejected"; Rec."Special Inc. Rejected")
                {
                    Caption = 'Rejected';
                }
                field("Special Incentive Approved"; Rec."Special Incentive Approved")
                {
                    Caption = 'Approved';
                }
                field("Special Inc. Reject Comment"; Rec."Special Inc. Reject Comment")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Special Inc. Approver ID"; Rec."Special Inc. Approver ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

