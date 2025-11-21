pageextension 50079 "BBG Fixed Asset Card Ext" extends "Fixed Asset Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("FA Block Code")
        {
            field("FA Code"; Rec."FA Code")
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