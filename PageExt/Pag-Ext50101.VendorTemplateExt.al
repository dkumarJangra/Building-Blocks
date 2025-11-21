pageextension 50101 "BBG Vendor Template Ext" extends "Vendor Templ. Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("No. Series")
        {
            field("Vendor Category"; Rec."BBG Vendor Category")
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