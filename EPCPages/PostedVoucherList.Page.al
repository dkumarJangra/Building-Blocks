page 97970 "Posted Voucher List"
{
    CardPageID = "Posted Payable Form";
    Editable = false;
    PageType = List;
    SourceTable = "Assoc Pmt Voucher Header";
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
                field("Eligible Amount"; Rec."Eligible Amount")
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                }
                field("Bank/G L Code"; Rec."Bank/G L Code")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Bank/G L Name"; Rec."Bank/G L Name")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                }
                field("No. Series"; Rec."No. Series")
                {
                }
                field("Incentive Type"; Rec."Incentive Type")
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

