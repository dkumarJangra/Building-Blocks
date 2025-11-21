pageextension 50036 "BBG Posted Purch. Receipts Ext" extends "Posted Purchase Receipts"
{
    layout
    {
        // Add changes to page layout here
        addafter("Ship-to Code")
        {
            field("Order No."; Rec."Order No.")
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