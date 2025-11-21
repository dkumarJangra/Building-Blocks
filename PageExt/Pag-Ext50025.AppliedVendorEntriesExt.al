pageextension 50025 "BBG Applied Vendor Entries Ext" extends "Applied Vendor Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
        {
            field("Application No."; Rec."Application No.")
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