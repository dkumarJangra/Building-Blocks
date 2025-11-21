page 50153 "Project Wise Developmnt Charge"
{
    PageType = List;
    SourceTable = "Project wise Development Charg";
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
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        ProjectwiseDevelopmentCharg.RESET;
        ProjectwiseDevelopmentCharg.SETRANGE(Status, ProjectwiseDevelopmentCharg.Status::Open);
        ProjectwiseDevelopmentCharg.SETFILTER(Amount, '>%1', 0);
        IF ProjectwiseDevelopmentCharg.FINDFIRST THEN
            ERROR('Status must be release for document No.' + FORMAT(ProjectwiseDevelopmentCharg."Document No."));
    end;

    var
        ProjectwiseDevelopmentCharg: Record "Project wise Development Charg";
}

