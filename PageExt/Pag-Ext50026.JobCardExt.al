pageextension 50026 "BBG Job Card Ext" extends "Job Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Last Date Modified")
        {
            field("New commission Str. Applicable"; Rec."New commission Str. Applicable")
            {
                ApplicationArea = All;
            }
            field("New commission Str. StartDate"; Rec."New commission Str. StartDate")
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