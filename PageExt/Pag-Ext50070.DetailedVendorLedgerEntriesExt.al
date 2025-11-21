pageextension 50070 "BBG Dtd Vend Ledg. Entries Ext" extends "Detailed Vendor Ledg. Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document Type")
        {
            field("Posting Type"; Rec."Posting Type")
            {
                ApplicationArea = All;

            }
            field("Order Ref No."; Rec."Order Ref No.")
            {
                ApplicationArea = All;
            }
            field("Milestone Code"; Rec."Milestone Code")
            {
                ApplicationArea = All;
            }
            field("Ref Document Type"; Rec."Ref Document Type")
            {
                ApplicationArea = All;
            }
            field("Project Code"; Rec."Project Code")
            {
                ApplicationArea = All;
            }
            field("Broker Code"; Rec."Broker Code")
            {
                ApplicationArea = All;
            }
            field("Tran Type"; Rec."Tran Type")
            {
                ApplicationArea = All;
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