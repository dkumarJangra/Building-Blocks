page 50181 "SMS Log Details"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "SMS Log Details";
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
                field("SMS Date"; Rec."SMS Date")
                {
                }
                field("SMS Time"; Rec."SMS Time")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field(Message; Rec.Message)
                {
                }
                field("Message 1"; Rec."Message 1")
                {
                }
                field("Party Type"; Rec."Party Type")
                {
                }
                field("Party Code"; Rec."Party Code")
                {
                }
                field("Party Name"; Rec."Party Name")
                {
                }
                field("Function/activity name"; Rec."Function/activity name")
                {
                }
                field("User Name"; Rec."User Name")
                {
                }
                field("Project ID"; Rec."Project ID")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("LLP Name"; Rec."LLP Name")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

