page 50070 "Project wise Milestone Details"
{
    CardPageID = "Project wise Milstone Header";
    Editable = false;
    PageType = List;
    SourceTable = "Project Milestone Header";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Effective From Date"; Rec."Effective From Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Effective To Date"; Rec."Effective To Date")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Creator Name"; Rec."Creator Name")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

