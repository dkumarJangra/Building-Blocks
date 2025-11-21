page 97858 "Application Discount List"
{
    CardPageID = "Unit credit Card";
    PageType = List;
    SourceTable = "Confirmed Order";
    SourceTableView = WHERE("Application Transfered" = FILTER(false));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

