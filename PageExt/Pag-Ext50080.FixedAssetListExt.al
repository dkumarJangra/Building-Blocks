pageextension 50080 "BBG Fixed Asset List Ext" extends "Fixed Asset List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;

            }
            field("FA Block Code"; Rec."FA Block Code")
            {
                ApplicationArea = All;

            }
            field(Capacity; Rec.Capacity)
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