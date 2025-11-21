page 50212 "Jagriti Pending Approval Entry"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Jagriti Approval Entry";
    SourceTableView = WHERE(Status = FILTER(Pending),
                            "Mail Required" = CONST(false));
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
                field("Ref. Entry No."; Rec."Ref. Entry No.")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Approver ID"; Rec."Approver ID")
                {
                }
                field("Approver Name"; Rec."Approver Name")
                {
                }
                field("Approved / Rejected Date"; Rec."Approved / Rejected Date")
                {
                }
                field("Approved / Rejected time"; Rec."Approved / Rejected time")
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Time Sent for Approval"; Rec."Time Sent for Approval")
                {
                }
                field("Date Sent for Approval"; Rec."Date Sent for Approval")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Associate Request Details")
            {
                RunObject = Page "Jagrati Assoicate Details List";
                RunPageLink = "Request No." = FIELD("Ref. Entry No.");
            }
            action("Customer Request Details")
            {
                RunObject = Page "Jagriti Customer Details List";
                RunPageLink = "Request No." = FIELD("Ref. Entry No.");
            }
            action(Approved)
            {

                trigger OnAction()
                begin
                    CheckApproverID;

                    Rec.TESTFIELD(Status, Rec.Status::Pending);
                    Rec.TESTFIELD("Mail Required", FALSE);
                    IF CONFIRM('Do you want to approve the Entry No.-' + FORMAT(Rec."Entry No.")) THEN BEGIN
                        Rec.Status := Rec.Status::Approved;
                        Rec."Approved / Rejected Date" := TODAY;
                        Rec."Approved / Rejected time" := TIME;
                        Rec.MODIFY;
                        SendMail(Rec."Entry No.");
                        MESSAGE('Entry Approved successfully');
                    END ELSE
                        MESSAGE('Nothing Done');
                end;
            }
            action(Rejected)
            {

                trigger OnAction()
                begin
                    CheckApproverID;
                    Rec.TESTFIELD(Status, Rec.Status::Pending);
                    IF CONFIRM('Do you want to Reject the Entry No.-' + FORMAT(Rec."Entry No.")) THEN BEGIN
                        Rec.Status := Rec.Status::Rejected;
                        Rec."Approved / Rejected Date" := TODAY;
                        Rec."Approved / Rejected time" := TIME;
                        Rec.MODIFY;

                        MESSAGE('Entry Rejected successfully');
                    END ELSE
                        MESSAGE('Nothing Done');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //SETRANGE("Approver ID",USERID);
    end;

    var
        WebAppService: Codeunit "Web App Service";
        JagartiSitewiseApprovesetup: Record "Jagriti Sitewise Approvalsetup";
        ApproverFound: Boolean;

    local procedure CheckApproverID()
    begin
        ApproverFound := FALSE;
        JagartiSitewiseApprovesetup.RESET;
        JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
        JagartiSitewiseApprovesetup.SETRANGE("Site Code", Rec."Site Code");
        JagartiSitewiseApprovesetup.SETRANGE("Approver ID", Rec."Approver ID");
        IF JagartiSitewiseApprovesetup.FINDFIRST THEN
            IF JagartiSitewiseApprovesetup."Approver ID" = USERID THEN
                ApproverFound := TRUE;

        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            JagartiSitewiseApprovesetup.SETRANGE("Site Code", Rec."Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 1", Rec."Approver ID");
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                IF JagartiSitewiseApprovesetup."Alternative Approver ID 1" <> USERID THEN
                    ApproverFound := TRUE;
        END;

        IF NOT ApproverFound THEN
            ERROR('Approver ID mismatch');
    end;

    local procedure SendMail(RecEntryNo: Integer)
    var
        JagratiApprovalEntry: Record "Jagriti Approval Entry";
        NextJagratiApprovalEntry: Record "Jagriti Approval Entry";
        JagratiAssocApprovalDetails: Record "Jagriti Assoc Approval Details";
        Emailid: Text;
        BodyText: Text;
        RequestSubject: Text;
    begin
        JagratiApprovalEntry.RESET;
        IF JagratiApprovalEntry.GET(RecEntryNo) THEN BEGIN
            JagratiApprovalEntry.TESTFIELD(Status, JagratiApprovalEntry.Status::Approved);
            NextJagratiApprovalEntry.RESET;
            NextJagratiApprovalEntry.SETFILTER("Entry No.", '>%1', RecEntryNo);
            NextJagratiApprovalEntry.SETRANGE("Ref. Entry No.", JagratiApprovalEntry."Ref. Entry No.");
            NextJagratiApprovalEntry.SETRANGE(Status, NextJagratiApprovalEntry.Status::Pending);
            IF NextJagratiApprovalEntry.FINDSET THEN
                REPEAT
                    Emailid := '';
                    /*
                    IF NextJagratiApprovalEntry."Mail Required" THEN BEGIN
                      JagratiAssocApprovalDetails.RESET;
                      JagratiAssocApprovalDetails.SETRANGE("Reporing Leader ID",NextJagratiApprovalEntry."Approver ID");
                      IF JagratiAssocApprovalDetails.FINDFIRST THEN
                        Emailid := JagratiAssocApprovalDetails."Reporing Leader E-mail ID";
                        BodyText := 'Hi';
                        RequestSubject := 'Jagrati Mail';
                      IF Emailid <> ''  THEN
                        WebAppService.SendMailforAssociateForm(Emailid,BodyText,RequestSubject);
                      NextJagratiApprovalEntry."Mail Sent" := TRUE;
                      NextJagratiApprovalEntry.Status := NextJagratiApprovalEntry.Status::Approved;
                      NextJagratiApprovalEntry."Mail Sent Date" := TODAY;
                      NextJagratiApprovalEntry."Mail Sent Time" := TIME;
                      NextJagratiApprovalEntry.MODIFY;
                    END ELSE
                    */


                    NextJagratiApprovalEntry.TESTFIELD(Status, NextJagratiApprovalEntry.Status::Approved);
                UNTIL NextJagratiApprovalEntry.NEXT = 0;

        END;

    end;
}

