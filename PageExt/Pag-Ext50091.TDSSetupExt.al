pageextension 50091 "BBG TDS Setup Ext" extends "TDS Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Tax Type")
        {
            field("206AB %"; Rec."206AB %")
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