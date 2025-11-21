pageextension 50029 "BBG General Ledger Setup Ext" extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                Caption = 'BBG Fields';
                field("Unit-Amount Decimal Places"; Rec."Unit-Amount Decimal Places")
                {
                    ApplicationArea = All;
                }
                field("Unit-Amount Rounding Precision"; Rec."Unit-Amount Rounding Precision")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount Limit"; Rec."Maximum Amount Limit")
                {
                    ApplicationArea = All;
                }
                field("IAL No. Series"; Rec."IAL No. Series")
                {
                    ApplicationArea = All;
                }
                field("FD No. Series"; Rec."FD No. Series")
                {
                    ApplicationArea = All;
                }
                field("FD Account"; Rec."FD Account")
                {
                    ApplicationArea = All;
                }
                field("FD Template Name"; Rec."FD Template Name")
                {
                    ApplicationArea = All;
                }
                field("FD Liquidation Batch Name"; Rec."FD Liquidation Batch Name")
                {
                    ApplicationArea = All;
                }
                field("FD Liquidation Account Code"; Rec."FD Liquidation Account Code")
                {
                    ApplicationArea = All;
                }
                field("FD Placement Account Code"; Rec."FD Placement Account Code")
                {
                    ApplicationArea = All;
                }
                field("FD Placement Batch Name"; Rec."FD Placement Batch Name")
                {
                    ApplicationArea = All;
                }
                field("FD Liquidation Interest Acc."; Rec."FD Liquidation Interest Acc.")
                {
                    ApplicationArea = All;
                }
                field("FD Placement Dimension Code"; Rec."FD Placement Dimension Code")
                {
                    ApplicationArea = All;
                }
                field("FD Liquidation Dimension Code"; Rec."FD Liquidation Dimension Code")
                {
                    ApplicationArea = All;
                }
                field("Accounting Location Dimension"; Rec."Accounting Location Dimension")
                {
                    ApplicationArea = All;
                }
                field("Enable Branch wise User Access"; Rec."Enable Branch wise User Access")
                {
                    ApplicationArea = All;
                }
                field("Branch Is"; Rec."Branch Is")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}