page 97923 "Reapproved Commission Voucher"
{
    PageType = Card;
    SourceTable = "Reapproved Commission Voucher";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Voucher No."; Rec."Voucher No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Posting Time"; Rec."Posting Time")
                {
                }
                field(Printed; Rec.Printed)
                {
                }
                field("Print Date"; Rec."Print Date")
                {
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Print")
            {
                Caption = '&Print';
                action("&Print Reapproved Comm. Voucher")
                {
                    Caption = '&Print Reapproved Comm. Voucher';

                    trigger OnAction()
                    begin
                        //CLEAR(CommVoucherPrint);
                        //CommVoucherPrint.SetValues("Voucher No.");
                        //CommVoucherPrint.RUNMODAL;
                    end;
                }
            }
        }
    }
}

