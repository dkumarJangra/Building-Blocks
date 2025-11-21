page 50551 "Project wise PPLAN Comm. Setup"
{
    Caption = 'Project wise PPLAN Comm. Setup';

    PageType = List;
    SourceTable = "Project wise PPLAN Commission";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Effective From Date"; Rec."Effective From Date")
                {
                }
                field("Effective To Date"; Rec."Effective To Date")
                {
                }

            }
        }
    }

    actions
    {
        area(navigation)
        {
            // action(UpdateChequeStatus)
            // {

            //     trigger OnAction()
            //     begin
            // 
            //     end;
            // }
        }
    }

    var


}

