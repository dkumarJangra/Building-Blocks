pageextension 50014 "BBG Item Ledger Entries Ext" extends "Item Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Job Task No.")
        {
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
            }
            field("PO No."; Rec."PO No.")
            {
                ApplicationArea = All;
            }
            field("Indent No"; Rec."Indent No")
            {
                ApplicationArea = All;
            }
            field("Indent Line No"; Rec."Indent Line No")
            {
                ApplicationArea = All;
            }
            field("Return Date"; Rec."Return Date")
            {
                ApplicationArea = All;
            }
            field("Issue Type"; Rec."Issue Type")
            {
                ApplicationArea = All;
            }
            field("Reference No."; Rec."Reference No.")
            {
                ApplicationArea = All;
            }
            field("Mfg/sold Qty"; Rec."Mfg/sold Qty")
            {
                ApplicationArea = All;
            }
            field("Application No."; Rec."Application No.")
            {
                ApplicationArea = All;
            }
            field("Application Line No."; Rec."Application Line No.")
            {
                ApplicationArea = All;
            }
            field("Item Type"; Rec."Item Type")
            {
                ApplicationArea = All;
            }
            field(Capacity; Rec.Capacity)
            {
                ApplicationArea = All;
            }
            field("FA SubClass Code"; Rec."FA SubClass Code")
            {
                ApplicationArea = All;
            }
            field("FA Sub Group"; Rec."FA Sub Group")
            {
                ApplicationArea = All;
            }
            field("Item-FA"; Rec."Item-FA")
            {
                ApplicationArea = All;
            }
            field(Leased; Rec.Leased)
            {
                ApplicationArea = All;
            }
            field("Item-FA Code"; Rec."Item-FA Code")
            {
                ApplicationArea = All;
            }
            field("Fixed Asset No"; Rec."Fixed Asset No")
            {
                ApplicationArea = All;
            }
            field("Transfer FG"; Rec."Transfer FG")
            {
                ApplicationArea = All;
            }
            field("BBG Product Group Code"; Rec."BBG Product Group Code")
            {
                ApplicationArea = all;
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