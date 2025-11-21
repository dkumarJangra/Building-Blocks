pageextension 50068 "BBG Dimension Values Ext" extends "Dimension Values"
{
    layout
    {
        // Add changes to page layout here
        addafter(Code)
        {
            field("Global Dimension No."; Rec."Global Dimension No.")
            {
                ApplicationArea = All;

            }
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;

            }
            field("IS Project"; Rec."IS Project")
            {
                ApplicationArea = All;

            }
            field("Brand Code"; Rec."Brand Code")
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
        UserSetup: Record "User Setup";

    trigger OnOpenPage()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow User Setup Modify", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;
}