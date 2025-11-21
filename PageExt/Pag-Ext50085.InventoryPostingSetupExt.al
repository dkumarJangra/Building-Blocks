pageextension 50085 "BBG Invento. Posting Setup Ext" extends "Inventory Posting Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Invt. Posting Group Code")
        {
            field(GLAccountName; GLAcc.Name)
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
        GLAcc: Record "G/L Account";

    LOCAL PROCEDURE UpdateGLAccName(AccNo: Code[20]);
    BEGIN
        IF NOT GLAcc.GET(AccNo) THEN
            CLEAR(GLAcc);
    END;
}