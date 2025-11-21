page 50419 "Project/Unit Price Setup"
{
    Caption = 'Project/Unit Price Approval Setup';
    PageType = List;
    SourceTable = "Jagriti Sitewise Approvalsetup";
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

                field("Document Type"; Rec."Document Type")
                {
                }
                field("Initiator ID"; Rec."Initiator ID")
                {

                }
                field("Initiator ID Name"; Rec."Initiator ID Name")
                {

                }
                field("Checker Approval ID"; Rec."Checker Approval ID")
                {

                }
                field("Checker Approval Name"; Rec."Checker Approval Name")
                {

                }

                field("Checker Approval ID 2"; Rec."Checker Approval ID 2")
                {

                }
                field("Checker Approval Name 2"; Rec."Checker Approval Name 2")
                {

                }
                field("Checker Approval ID 3"; Rec."Checker Approval ID 3")
                {

                }
                field("Checker Approval Name 3"; Rec."Checker Approval Name 3")
                {


                }
                field("Approver ID"; Rec."Approver ID")
                {
                }
                field("Approver Name"; Rec."Approver Name")
                {
                }

            }
        }
    }

    actions
    {
    }
}

