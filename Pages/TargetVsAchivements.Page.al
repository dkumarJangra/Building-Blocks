page 50196 "Target Vs Achivements"
{
    CardPageID = "Target Vs Achivements Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Target Vs Achivement Summary";
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
                field("Team Head Code"; Rec."Team Head Code")
                {
                }
                field("Target Amount"; Rec."Target Amount")
                {
                }
                field("Achived Amount"; Rec."Achived Amount")
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field("Period Duration"; Rec."Period Duration")
                {
                }
                field("Target Increament %"; Rec."Target Increament %")
                {
                }
            }
        }
    }

    actions
    {
    }
}

