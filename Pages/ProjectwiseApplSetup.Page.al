page 50451 "Project wise Appl. Setup"
{
    Caption = 'Project and Rank Wise Setup';

    PageType = List;
    SourceTable = "Project wise Appl. Setup";
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
                field("Project Rank Code"; Rec."Project Rank Code")
                {
                }
                field("Project Rank Description"; Rec."Project Rank Description")
                {
                }
                field("Commission Structure Code"; Rec."Commission Structure Code")
                {

                }
                field("Travel Applicable"; Rec."Travel Applicable")
                {
                }
                field("Registration Bonus (BSP2)"; Rec."Registration Bonus (BSP2)")
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

