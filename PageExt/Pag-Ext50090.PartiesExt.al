pageextension 50090 "BBG Parties Ext" extends Parties
{
    layout
    {
        // Add changes to page layout here
        addafter("ARN No.")
        {
            field("206AB"; Rec."206AB")
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