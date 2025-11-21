page 98019 "New Voucher Accounts"
{
    // //AlleAB BLK 120508 For Cash Payment Voucher-Added new fieldAlleAB BLK - Adding new filed Maximum Amount
    // 
    // //BBG1.00 ALLEDK 070313 Code Added for form on Editable based on Role

    Caption = 'Voucher Account';
    DelayedInsert = true;
    Editable = false;
    PageType = Card;
    //SourceTable = 16547;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            // repeater(Group)
            // {
            //     // field("Location code"; "Location code")
            //     // {
            //     //     Editable = false;
            //     // }
            //     // field("Sub Type"; "Sub Type")
            //     // {
            //     // }
            //     // field("Account Type"; "Account Type")
            //     // {
            //     // }
            //     // field("Account No."; "Account No.")
            //     // {
            //     // }
            //     // field("Payment Method Code"; "Payment Method Code")
            //     // {
            //     // }
            //     // field("Account Name"; "Account Name")
            //     // {
            //     // }
            //     // field("Bank Filter for Main Comp"; "Bank Filter for Main Comp")
            //     // {
            //     // }
            //     // field("Maximum Amount"; "Maximum Amount")
            //     // {
            //     // }
            // }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // IF ("Sub Type" = "Sub Type"::"Cash Receipt Voucher") OR ("Sub Type" = "Sub Type"::"Cash Payment Voucher") THEN
        //     "Account Type" := "Account Type"::"G/L Account";
        // IF ("Sub Type" = "Sub Type"::"Bank Receipt Voucher") OR ("Sub Type" = "Sub Type"::"Bank Payment Voucher") THEN
        //     "Account Type" := "Account Type"::"Bank Account";
    end;
}

