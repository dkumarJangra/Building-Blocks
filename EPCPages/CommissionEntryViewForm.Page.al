page 50019 "Commission Entry View Form"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Commission Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("No. of Records"; Rec.COUNT)
            {
            }
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Month_1; Rec.Month_1)
                {
                }
                field(Year_1; Rec.Year_1)
                {
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("TDS Base Amount"; Rec."TDS Base Amount")
                {
                }
                field("TDS Deducted on Invoice"; Rec."TDS Deducted on Invoice")
                {
                }
                field("Business Type"; Rec."Business Type")
                {
                }
                field("Base Amount"; Rec."Base Amount")
                {
                }
                field("Commission %"; Rec."Commission %")
                {
                }
                field("Remaining Amt of Direct"; Rec."Remaining Amt of Direct")
                {
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                }
                field(Posted; Rec.Posted)
                {
                }
                field("Direct to Associate"; Rec."Direct to Associate")
                {
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                }
                field("On Hold"; Rec."On Hold")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Project Type"; Rec."Project Type")
                {
                }
                field(Duration; Rec.Duration)
                {
                }
                field("Associate Rank"; Rec."Associate Rank")
                {
                }
                field("Voucher No."; Rec."Voucher No.")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Voucher Posting Date"; Rec."Voucher Posting Date")
                {
                }
                field(Reversal; Rec.Reversal)
                {
                }
                field(Reverse2; Rec.Reverse2)
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field(Discount; Rec.Discount)
                {
                }
                field("Opening Entries"; Rec."Opening Entries")
                {
                }
                field(Remark; Rec.Remark)
                {
                }
                field("Registration Bonus Hold(BSP2)"; Rec."Registration Bonus Hold(BSP2)")
                {
                }
                field("Check Comm Amt"; Rec."Check Comm Amt")
                {
                }
                field("Adjust Remaining Amt"; Rec."Adjust Remaining Amt")
                {
                }
            }
        }
    }

    actions
    {
    }
}

