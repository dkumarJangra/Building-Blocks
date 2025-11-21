tableextension 50069 "BBG No. Series Ext" extends "No. Series"
{
    fields
    {
        // Add changes to table fields here
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        UserSetup: Record "User Setup";

    trigger OnAfterDelete()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow No.Series Delete", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');

    end;
}