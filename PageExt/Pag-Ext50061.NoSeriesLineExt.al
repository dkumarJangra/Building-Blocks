pageextension 50061 "BBG No. Series Lines Ext" extends "No. Series Lines"
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
        UserSetup: Record "User Setup";

    trigger OnOpenPage()
    begin
        //ALLETDK050413 >>>
        UserSetup.GET(USERID);
        IF UserSetup."Unlimited Request Approval" THEN
            CurrPage.EDITABLE(TRUE)
        ELSE
            CurrPage.EDITABLE(FALSE);
        //ALLETDK050413 <<<
    end;
}