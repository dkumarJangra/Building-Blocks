page 50211 "Jagrati Approval Setup"
{
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
                field("Site Code"; Rec."Site Code")
                {
                }
                field("Approver ID"; Rec."Approver ID")
                {
                }
                field("Approver Name"; Rec."Approver Name")
                {
                }
                field("E-mail ID"; Rec."E-mail ID")
                {
                }
                field("Alternative Approver ID 1"; Rec."Alternative Approver ID 1")
                {
                }
                field("Alternative Approver Name"; Rec."Alternative Approver Name")
                {
                }
                field("Initiator ID"; Rec."Initiator ID")
                { }
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
            }
        }
    }

    actions
    {
    }
}

