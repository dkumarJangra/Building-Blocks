pageextension 50016 "BBG Item Journal Ext" extends "Item Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {
            field("Current Stock"; Rec."Current Stock")
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