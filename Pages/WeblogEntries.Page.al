page 50100 "Web log Entries"
{
    Editable = false;
    PageType = List;
    SourceTable = "Web Log Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Request Date"; Rec."Request Date")
                {
                }
                field("Request Time"; Rec."Request Time")
                {
                }
                field("Request Description"; Rec."Request Description")
                {
                }
                field("Request Description 2"; Rec."Request Description 2")
                {
                }
                field("Request Description 3"; Rec."Request Description 3")
                {
                }
                field("Request Description 4"; Rec."Request Description 4")
                {
                }
                field("Response Date"; Rec."Response Date")
                {
                }
                field("Response Time"; Rec."Response Time")
                {
                }
                field("Response Description"; Rec."Response Description")
                {
                }
                field("Response Description 2"; Rec."Response Description 2")
                {
                }
                field("Function Name"; Rec."Function Name")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow Mobile App", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;
}

