pageextension 50105 "BBG Bank Charge Ext" extends "Bank Charges"
{
    layout
    {
        // Add changes to page layout here
        addafter(Exempted)
        {
            field(Club9; Rec.Club9)
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