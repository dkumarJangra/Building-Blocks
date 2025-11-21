pageextension 50045 "BBG Post Codes Ext" extends "Post Codes"
{
    layout
    {
        // Add changes to page layout here
        addafter(County)
        {
            field("State Code"; Rec."State Code")
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