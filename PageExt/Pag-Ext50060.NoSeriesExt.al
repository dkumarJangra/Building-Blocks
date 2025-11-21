pageextension 50060 "BBG No. Series Ext" extends "No. Series"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Relationships)
        {
            action("No. Series Header Upload")
            {
                Caption = 'No. Series Header Upload';
                ApplicationArea = all;
                RunObject = xmlport "No. Series Header upload";
            }
            action("No. Series Line Upload")
            {
                Caption = 'No. Series Lines Upload';
                ApplicationArea = all;
                RunObject = xmlport "No Series Line Part";
            }
        }

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