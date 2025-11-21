pageextension 50089 "BBG User Card Ext" extends "User Card"
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
        v_UserSetup: Record "User Setup";

    trigger OnOpenPage()
    begin
        v_UserSetup.RESET;
        v_UserSetup.SETRANGE("User ID", USERID);
        v_UserSetup.SETRANGE("Allow Users Modify", TRUE);
        IF NOT v_UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;
}