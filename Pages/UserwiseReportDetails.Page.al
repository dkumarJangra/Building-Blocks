page 50175 "User wise Report Details"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Report Log Details";
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
                field("Report Name"; Rec."Report Name")
                {
                }
                field("Report ID"; Rec."Report ID")
                {
                }
                field("Report Run Start Date"; Rec."Report Run Start Date")
                {
                }
                field("Report Run Start Time"; Rec."Report Run Start Time")
                {
                }
                field("Report Run End Time"; Rec."Report Run End Time")
                {
                }
                field("Report Run End Date"; Rec."Report Run End Date")
                {
                }
                field("USER ID"; Rec."USER ID")
                {
                }
                field("USER Name"; Rec."USER Name")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Responsibility Center Name"; Rec."Responsibility Center Name")
                {
                }
                field("Report Filters"; Rec."Report Filters")
                {
                }
            }
        }
    }

    actions
    {
    }
}

