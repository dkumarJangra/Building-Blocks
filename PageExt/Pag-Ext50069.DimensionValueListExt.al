pageextension 50069 "BBG Dimension Value List Ext" extends "Dimension Value List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Consolidation Code")
        {
            field(Trading; Rec.Trading)
            {
                ApplicationArea = All;

            }
            field("Non Trading"; Rec."Non Trading")
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