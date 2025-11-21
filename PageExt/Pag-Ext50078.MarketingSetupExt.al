pageextension 50078 "BBG Marketing Setup Ext" extends "Marketing Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Opportunity Nos.")
        {
            field("Family Member No. Series"; Rec."Family Member No. Series")
            {
                ApplicationArea = All;

            }
            field("Visit Schedule No. Series"; Rec."Visit Schedule No. Series")
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