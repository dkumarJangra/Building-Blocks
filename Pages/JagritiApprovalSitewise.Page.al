page 50217 "Jagriti Approval Site wise"
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
                field("Sms Type"; Rec."Sms Type")
                {

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Approval Required", TRUE);
                        IF (Rec."Sms Type" = Rec."Sms Type"::Submission) OR (Rec."Sms Type" = Rec."Sms Type"::Approval) OR (Rec."Sms Type" = Rec."Sms Type"::Initiation) OR (Rec."Sms Type" = Rec."Sms Type"::Verification) THEN
                            Rec.TESTFIELD("Document Type", Rec."Document Type"::"PLOT CANCELLATION / REFUND");
                    end;
                }
                field("Alternative Approver ID 1"; Rec."Alternative Approver ID 1")
                {
                }
                field("Alternative Approver Name"; Rec."Alternative Approver Name")
                {
                }
                field("Approval Required"; Rec."Approval Required")
                {
                }
                field("Alternative Approver ID 2"; Rec."Alternative Approver ID 2")
                {
                }
                field("Alternative Approver Name 2"; Rec."Alternative Approver Name 2")
                {
                    Caption = 'Alternative Approver Name';
                }
                field("Alternative Approver ID 3"; Rec."Alternative Approver ID 3")
                {
                }
                field("Alternative Approver Name 3"; Rec."Alternative Approver Name 3")
                {
                    Caption = 'Alternative Approver Name';
                }
                field("Alternative Approver ID 4"; Rec."Alternative Approver ID 4")
                {
                }
                field("Alternative Approver Name 4"; Rec."Alternative Approver Name 4")
                {
                    Caption = 'Alternative Approver Name';
                }
                field("Alternative Approver ID 5"; Rec."Alternative Approver ID 5")
                {
                }
                field("Alternative Approver Name 5"; Rec."Alternative Approver Name 5")
                {
                    Caption = 'Alternative Approver Name';
                }
                field("Alternative Approver ID 6"; Rec."Alternative Approver ID 6")
                {
                }
                field("Alternative Approver Name 6"; Rec."Alternative Approver Name 6")
                {
                    Caption = 'Alternative Approver Name';
                }
                field("Alternative Approver ID 7"; Rec."Alternative Approver ID 7")
                {
                }
                field("Alternative Approver Name 7"; Rec."Alternative Approver Name 7")
                {
                    Caption = 'Alternative Approver Name';
                }
                field("Alternative Approver ID 8"; Rec."Alternative Approver ID 8")
                {
                }
                field("Alternative Approver Name 8"; Rec."Alternative Approver Name 8")
                {
                    Caption = 'Alternative Approver Name';
                }
                field("Alternative Approver ID 9"; Rec."Alternative Approver ID 9")
                {
                }
                field("Alternative Approver Name 9"; Rec."Alternative Approver Name 9")
                {
                    Caption = 'Alternative Approver Name';
                }
                field("Alternative Approver ID 10"; Rec."Alternative Approver ID 10")
                {
                }
                field("Alternative Approver Name 10"; Rec."Alternative Approver Name 10")
                {
                    Caption = 'Alternative Approver Name';
                }
                field("Alternative Approver ID 11"; Rec."Alternative Approver ID 11")
                {
                }
                field("Alternative Approver Name 11"; Rec."Alternative Approver Name 11")
                {
                }
                field("Alternative Approver ID 12"; Rec."Alternative Approver ID 12")
                {
                }
                field("Alternative Approver Name 12"; Rec."Alternative Approver Name 12")
                {
                }
                field("Alternative Approver ID 13"; Rec."Alternative Approver ID 13")
                {
                }
                field("Alternative Approver Name 13"; Rec."Alternative Approver Name 13")
                {
                }
                field("Alternative Approver ID 14"; Rec."Alternative Approver ID 14")
                {
                }
                field("Alternative Approver Name 14"; Rec."Alternative Approver Name 14")
                {
                }
                field("Alternative Approver ID 15"; Rec."Alternative Approver ID 15")
                {
                }
                field("Alternative Approver Name 15"; Rec."Alternative Approver Name 15")
                {
                }
            }
        }
    }

    actions
    {
    }
}

