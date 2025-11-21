page 60692 "Job Queue Log Details"
{
    Editable = false;
    PageType = List;
    SourceTable = "Job Queue Log Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Process Name"; Rec."Process Name")
                {
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Process Code"; Rec."Process Code")
                {
                }
                field("Process Date"; Rec."Process Date")
                {
                }
                field("Process Time"; Rec."Process Time")
                {
                }
                field("Error Message"; Rec."Error Message")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

