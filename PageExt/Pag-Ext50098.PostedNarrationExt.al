pageextension 50098 "BBG Posted Narration Ext" extends "Posted Narration"
{
    layout
    {
        // Add changes to page layout here  
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        Memberof: Record "Access Control";

    trigger OnOpenPage()
    begin
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETRANGE(Memberof."Role ID", 'A_NarrUpdate');
        IF NOT Memberof.FINDFIRST THEN
            CurrPage.EDITABLE(FALSE)
        ELSE
            CurrPage.EDITABLE(TRUE);
    end;

    trigger OnAfterGetRecord()
    begin

        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETRANGE(Memberof."Role ID", 'A_NarrUpdate');
        IF NOT Memberof.FINDFIRST THEN
            CurrPage.EDITABLE(FALSE)
        ELSE
            CurrPage.EDITABLE(TRUE);
    end;
}