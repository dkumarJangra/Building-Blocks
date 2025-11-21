page 60661 "Food Court Details"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Food Court Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Editable = false;
                }
                field("Associate Name"; Rec."Associate Name")
                {
                    Editable = false;
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Location Name"; Rec."Location Name")
                {
                    Editable = false;
                }
                field("Other Location Name"; Rec."Other Location Name")
                {
                    Editable = false;
                }
                field("Coupon Name"; Rec."Coupon Name")
                {
                    Editable = false;
                }
                field("Coupon Type"; Rec."Coupon Type")
                {
                    Editable = false;
                }
                field("Team Name"; Rec."Team Name")
                {
                    Editable = false;
                }
                field("Food Type"; Rec."Food Type")
                {
                    Editable = false;
                }
                field("Coupon Req. Date"; Rec."Coupon Req. Date")
                {
                    Editable = false;
                }
                field("Requested Quantity"; Rec."Requested Quantity")
                {
                    Editable = false;
                }
                field("Actual Coupon Availed"; Rec."Actual Coupon Availed")
                {
                    Caption = 'Availed Quantity';
                    Editable = true;
                }
                field("Fullfillment of Coupons"; Rec."Fullfillment of Coupons")
                {
                    Caption = 'Fulfillment of Coupons';
                }
                field("Document Date"; Rec."Document Date")
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

