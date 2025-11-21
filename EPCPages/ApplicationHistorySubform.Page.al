page 97891 "Application History Subform"
{
    PageType = List;
    SourceTable = "Unit History";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Unit No."; Rec."Unit No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Date(Today)"; Rec."Date(Today)")
                {
                }
                field(Time; Rec.Time)
                {
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Date(Workdate)"; Rec."Date(Workdate)")
                {
                }
            }
        }
    }

    actions
    {
    }
}

