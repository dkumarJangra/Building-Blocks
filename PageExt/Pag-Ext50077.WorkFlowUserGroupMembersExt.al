pageextension 50077 "BBG Workf. User Group Mem Ext" extends "Workflow User Group Members"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sequence No.")
        {
            field("Approval Amount Limit"; Rec."Approval Amount Limit")
            {
                ApplicationArea = All;

            }
            field("Sub Document Type"; Rec."Sub Document Type")
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