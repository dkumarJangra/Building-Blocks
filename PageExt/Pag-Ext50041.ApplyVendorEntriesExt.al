pageextension 50041 "BBG Apply Vendor Entries Ext" extends "Apply Vendor Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Remaining Amount")
        {
            // field("Region Dimension"; ApplyingVendLedgEntry."Global Dimension 1 Code")
            // {
            // }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}