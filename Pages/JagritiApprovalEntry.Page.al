page 50214 "Jagriti Approval Entry"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Jagriti Approval Entry";
    SourceTableView = SORTING("Entry No.");
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    Editable = false;
                }
                field("Approver Name"; Rec."Approver Name")
                {
                    Editable = false;
                }
                field("Approved By"; Rec."Approved By")
                {
                }
                field("Date Sent for Approval"; Rec."Date Sent for Approval")
                {
                    Editable = false;
                }
                field("Time Sent for Approval"; Rec."Time Sent for Approval")
                {
                    Editable = false;
                }
                field("Approved / Rejected Date"; Rec."Approved / Rejected Date")
                {
                    Editable = false;
                }
                field("Approved / Rejected time"; Rec."Approved / Rejected time")
                {
                    Editable = false;
                }
                field("Associate ID"; Rec."Associate ID")
                {
                    Editable = false;
                }
                field("Associate Name"; Rec."Associate Name")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Status Comment"; Rec."Status Comment")
                {
                    Caption = 'Comment';
                }
                field("Mail Required"; Rec."Mail Required")
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
            action(Approved)
            {

                trigger OnAction()
                var
                    ApprovalPending: Boolean;
                begin

                    IF NOT Rec."Mail Required" THEN BEGIN
                        CheckApproverID;

                        Rec.TESTFIELD(Status, Rec.Status::Pending);
                        //TESTFIELD("Mail Required",FALSE);
                        Rec.TESTFIELD("Status Comment");
                        IF CONFIRM('Do you want to approve the Entry No.-' + FORMAT(Rec."Entry No.")) THEN BEGIN
                            Rec.Status := Rec.Status::Approved;
                            Rec."Approved / Rejected Date" := TODAY;
                            Rec."Approved / Rejected time" := TIME;
                            Rec."Approved By" := USERID;
                            Rec.MODIFY;
                            //  COMMIT;
                            UpdateRequestStatus;
                            UpdateDateAndTime;
                            //   SendMail("Entry No.");


                            MESSAGE('Entry Approved successfully');
                        END ELSE
                            MESSAGE('Nothing Done');
                    END;
                end;
            }
            action(Rejected)
            {

                trigger OnAction()
                var
                    v_JagritiCustomerDetails: Record "Jagriti Customer Details";
                    NewConfirmedOrder: Record "New Confirmed Order";
                    CustomerRefundSMS: Codeunit "Customer Refund SMS";
                    JagritiSitewiseApprovalsetup: Record "Jagriti Sitewise Approvalsetup";
                    SMSType: Text;
                begin
                    CheckApproverID;
                    Rec.TESTFIELD(Status, Rec.Status::Pending);
                    Rec.TESTFIELD("Status Comment");
                    IF CONFIRM('Do you want to Reject the Entry No.-' + FORMAT(Rec."Entry No.")) THEN BEGIN
                        Rec.Status := Rec.Status::Rejected;
                        Rec."Approved / Rejected Date" := TODAY;
                        Rec."Approved / Rejected time" := TIME;
                        Rec."Approved By" := USERID;
                        Rec.MODIFY;
                        COMMIT;

                        //ADDed new code 070824 Start-------------
                        JagritiAssoicateDetails.RESET;
                        JagritiAssoicateDetails.SETRANGE("Request No.", Rec."Ref. Entry No.");
                        IF JagritiAssoicateDetails.FINDFIRST THEN BEGIN
                            JagritiAssoicateDetails."Request Status" := 'Rejected';
                            JagritiAssoicateDetails."Request Pending From" := '';
                            JagritiAssoicateDetails.MODIFY;
                        END;
                        //UpdateRequestStatus;  //Code commented 070824

                        //ADDed new code 070824 END -------------




                        IF Rec."Document Type" = Rec."Document Type"::"PLOT CANCELLATION / REFUND" THEN BEGIN
                            v_JagritiCustomerDetails.RESET;
                            IF v_JagritiCustomerDetails.GET(Rec."Ref. Entry No.") THEN BEGIN
                                IF v_JagritiCustomerDetails."Customer Application No." <> '' THEN BEGIN
                                    NewConfirmedOrder.RESET;
                                    IF NewConfirmedOrder.GET(v_JagritiCustomerDetails."Customer Application No.") THEN BEGIN
                                        NewConfirmedOrder.TESTFIELD("Refund Initiate Amount");
                                        //NewConfirmedOrder."Refund Initiate Amount":= v_JagritiCustomerDetails."Refund Amount Paid";
                                        IF NewConfirmedOrder."Refund Rejection Remark" = '' THEN BEGIN
                                            IF Rec."Status Comment" = '' THEN
                                                NewConfirmedOrder."Refund Rejection Remark" := 'Ok'
                                            ELSE
                                                NewConfirmedOrder."Refund Rejection Remark" := Rec."Status Comment";
                                        END;
                                        NewConfirmedOrder.MODIFY;
                                        COMMIT;
                                        CLEAR(CustomerRefundSMS);
                                        SMSType := '';
                                        JagritiSitewiseApprovalsetup.RESET;
                                        JagritiSitewiseApprovalsetup.SETRANGE("Document Type", Rec."Document Type");
                                        JagritiSitewiseApprovalsetup.SETRANGE("Approver ID", Rec."Approver ID");
                                        IF JagritiSitewiseApprovalsetup.FINDFIRST THEN BEGIN

                                            SMSType := FORMAT(JagritiSitewiseApprovalsetup."Sms Type");
                                        END;
                                        CustomerRefundSMS."Refund Reject SMS"(NewConfirmedOrder, SMSType);
                                    END;
                                END;
                            END;
                        END;
                        MESSAGE('Entry Rejected successfully');
                    END ELSE
                        MESSAGE('Nothing Done');
                end;
            }
            action(Comment)
            {

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Pending);
                    Input_lFnc;
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
        JagritiAssoicateDetails: Record "Jagriti Assoicate Details";
        JagritiCustomerDetails: Record "Jagriti Customer Details";
        JagritiApprovalEntry: Record "Jagriti Approval Entry";
        CreateComments: Dialog;
        UserSetup: Record "User Setup";

    local procedure CheckApproverID()
    begin
        ApproverFound := FALSE;
        IF Rec."Approver ID" = USERID THEN
            ApproverFound := TRUE;

        UserSetup.RESET;
        IF NOT UserSetup.GET(Rec."Approver ID") THEN
            ERROR('This entry will be approved from Mobile App');

        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //  JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 1", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;

        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 2", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 3", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 4", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 5", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 6", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 7", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 8", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 9", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 10", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 11", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 12", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 13", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 14", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Alternative Approver ID 15", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
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
        /*
        JagratiApprovalEntry.RESET;
        IF JagratiApprovalEntry.GET(RecEntryNo) THEN BEGIN
          JagratiApprovalEntry.TESTFIELD(Status,JagratiApprovalEntry.Status::Approved);
          NextJagratiApprovalEntry.RESET;
          NextJagratiApprovalEntry.SETFILTER("Entry No.",'>%1',RecEntryNo);
          NextJagratiApprovalEntry.SETRANGE("Ref. Entry No.",JagratiApprovalEntry."Ref. Entry No.");
          NextJagratiApprovalEntry.SETRANGE(Status,NextJagratiApprovalEntry.Status::Pending);
          IF NextJagratiApprovalEntry.FINDSET THEN
            REPEAT
              Emailid := '';
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
                NextJagratiApprovalEntry.TESTFIELD(Status,NextJagratiApprovalEntry.Status::Approved);
            UNTIL NextJagratiApprovalEntry.NEXT = 0;
        
        END;
        */

    end;

    local procedure UpdateRequestStatus()
    var
        ApprovalPending: Boolean;
        JagritiApprovalEntry_L: Record "Jagriti Approval Entry";
        FindPendingEntry: Boolean;
    begin
        IF Rec."Form Type" = Rec."Form Type"::CustomerForm THEN BEGIN
            ApprovalPending := FALSE;
            JagritiCustomerDetails.RESET;
            JagritiCustomerDetails.SETRANGE("Request No.", Rec."Ref. Entry No.");
            IF JagritiCustomerDetails.FINDFIRST THEN BEGIN
                JagritiApprovalEntry.RESET;
                JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::CustomerForm);
                JagritiApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
                JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Pending);
                JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                JagritiApprovalEntry.SETFILTER("Entry No.", '>%1', Rec."Entry No.");
                JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
                IF JagritiApprovalEntry.FINDFIRST THEN BEGIN
                    JagritiCustomerDetails."Request Status" := 'Pending';
                    JagritiCustomerDetails."Request Pending From" := JagritiApprovalEntry."Approver Name";
                    JagritiCustomerDetails.MODIFY;
                    ApprovalPending := TRUE;
                END;
                IF NOT ApprovalPending THEN BEGIN
                    JagritiApprovalEntry.RESET;
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::CustomerForm);
                    JagritiApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
                    JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Rejected);
                    JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                    JagritiApprovalEntry.SETFILTER("Entry No.", '>%1', Rec."Entry No.");
                    JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
                    IF JagritiApprovalEntry.FINDFIRST THEN BEGIN
                        JagritiCustomerDetails."Request Status" := 'Rejected';
                        JagritiCustomerDetails."Request Pending From" := JagritiApprovalEntry."Approver Name";
                        JagritiCustomerDetails.MODIFY;
                        ApprovalPending := TRUE;
                    END;
                END;
                IF NOT ApprovalPending THEN BEGIN
                    JagritiApprovalEntry.RESET;
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::CustomerForm);
                    JagritiApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
                    JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Approved);
                    JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                    JagritiApprovalEntry.SETFILTER("Entry No.", '>%1', Rec."Entry No.");
                    JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
                    IF JagritiApprovalEntry.FINDFIRST THEN BEGIN
                        JagritiCustomerDetails."Request Status" := 'Completed';
                        JagritiCustomerDetails."Request Pending From" := '';
                        JagritiCustomerDetails.MODIFY;
                        ApprovalPending := TRUE;
                    END;
                END;
                IF ApprovalPending = FALSE THEN BEGIN
                    JagritiCustomerDetails."Request Status" := 'Completed';
                    JagritiCustomerDetails."Request Pending From" := '';
                    JagritiCustomerDetails.MODIFY;
                END;
                IF Rec.Status = Rec.Status::Rejected THEN BEGIN
                    JagritiCustomerDetails.RESET;
                    JagritiCustomerDetails.SETRANGE("Request No.", Rec."Ref. Entry No.");
                    IF JagritiCustomerDetails.FINDFIRST THEN BEGIN
                        JagritiCustomerDetails."Request Status" := 'Rejected';
                        JagritiCustomerDetails.MODIFY;
                    END;
                END;
            END;
            FindPendingEntry := FALSE;
            JagritiApprovalEntry_L.RESET;
            JagritiApprovalEntry_L.SETRANGE("Form Type", JagritiApprovalEntry_L."Form Type"::CustomerForm);
            JagritiApprovalEntry_L.SETFILTER("Entry No.", '>%1', Rec."Entry No.");
            JagritiApprovalEntry_L.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
            IF JagritiApprovalEntry_L.FINDFIRST THEN
                REPEAT
                    JagritiApprovalEntry_L."Date Sent for Approval" := TODAY;
                    JagritiApprovalEntry_L."Time Sent for Approval" := TIME;
                    IF JagritiApprovalEntry_L."Mail Required" THEN BEGIN
                        JagritiApprovalEntry_L."Approved / Rejected Date" := TODAY;
                        JagritiApprovalEntry_L."Approved / Rejected time" := TIME;
                    END;
                    JagritiApprovalEntry_L.MODIFY;
                    IF NOT JagritiApprovalEntry_L."Mail Required" THEN
                        FindPendingEntry := TRUE
                    ELSE
                        FindPendingEntry := FALSE;
                UNTIL (JagritiApprovalEntry_L.NEXT = 0) OR (FindPendingEntry);

        END ELSE IF Rec."Form Type" = Rec."Form Type"::AssociateForm THEN BEGIN
            ApprovalPending := FALSE;

            JagritiAssoicateDetails.RESET;
            JagritiAssoicateDetails.SETRANGE("Request No.", Rec."Ref. Entry No.");
            IF JagritiAssoicateDetails.FINDFIRST THEN BEGIN
                JagritiApprovalEntry.RESET;
                JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::AssociateForm);
                JagritiApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
                JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Pending);
                JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                JagritiApprovalEntry.SETFILTER("Entry No.", '>%1', Rec."Entry No.");
                JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
                IF JagritiApprovalEntry.FINDFIRST THEN BEGIN
                    JagritiAssoicateDetails."Request Status" := 'Pending';
                    JagritiAssoicateDetails."Request Pending From" := JagritiApprovalEntry."Approver Name";
                    JagritiAssoicateDetails.MODIFY;
                    ApprovalPending := TRUE;
                END;

                IF NOT ApprovalPending THEN BEGIN
                    JagritiApprovalEntry.RESET;
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::AssociateForm);
                    JagritiApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
                    JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Rejected);
                    JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                    JagritiApprovalEntry.SETFILTER("Entry No.", '>%1', Rec."Entry No.");
                    JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
                    IF JagritiApprovalEntry.FINDFIRST THEN BEGIN
                        JagritiAssoicateDetails."Request Status" := 'Rejected';
                        JagritiAssoicateDetails."Request Pending From" := JagritiApprovalEntry."Approver Name";
                        JagritiAssoicateDetails.MODIFY;
                        ApprovalPending := TRUE;
                    END;
                END;
                IF NOT ApprovalPending THEN BEGIN
                    JagritiApprovalEntry.RESET;
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::AssociateForm);
                    JagritiApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
                    JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Approved);
                    JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                    JagritiApprovalEntry.SETFILTER("Entry No.", '<>%1', Rec."Entry No.");
                    JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
                    IF JagritiApprovalEntry.FINDFIRST THEN BEGIN
                        JagritiAssoicateDetails."Request Status" := 'Completed';
                        JagritiAssoicateDetails."Request Pending From" := '';
                        JagritiAssoicateDetails.MODIFY;
                        ApprovalPending := TRUE;
                    END;
                END;
                IF ApprovalPending = FALSE THEN BEGIN
                    JagritiAssoicateDetails."Request Status" := 'Completed';
                    JagritiAssoicateDetails."Request Pending From" := '';
                    JagritiAssoicateDetails.MODIFY;
                END;
                IF Rec.Status = Rec.Status::Rejected THEN BEGIN
                    JagritiAssoicateDetails.RESET;
                    JagritiAssoicateDetails.SETRANGE("Request No.", Rec."Ref. Entry No.");
                    IF JagritiAssoicateDetails.FINDFIRST THEN BEGIN
                        JagritiAssoicateDetails."Request Status" := 'Rejected';
                        JagritiAssoicateDetails.MODIFY;
                    END;
                END;
            END;



            JagritiApprovalEntry_L.RESET;
            JagritiApprovalEntry_L.SETRANGE("Form Type", JagritiApprovalEntry_L."Form Type"::AssociateForm);
            JagritiApprovalEntry_L.SETFILTER("Entry No.", '>%1', Rec."Entry No.");
            JagritiApprovalEntry_L.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
            IF JagritiApprovalEntry_L.FINDSET THEN
                REPEAT
                    JagritiApprovalEntry_L."Date Sent for Approval" := TODAY;
                    JagritiApprovalEntry_L."Time Sent for Approval" := TIME;
                    IF JagritiApprovalEntry_L."Mail Required" THEN BEGIN
                        JagritiApprovalEntry_L."Approved / Rejected Date" := TODAY;
                        JagritiApprovalEntry_L."Approved / Rejected time" := TIME;
                    END;
                    JagritiApprovalEntry_L.MODIFY;
                    IF NOT JagritiApprovalEntry_L."Mail Required" THEN
                        FindPendingEntry := TRUE
                    ELSE
                        FindPendingEntry := FALSE;
                UNTIL (JagritiApprovalEntry_L.NEXT = 0) OR (FindPendingEntry);
        END ELSE IF Rec."Form Type" = Rec."Form Type"::SpecialRequest THEN BEGIN
            ApprovalPending := FALSE;

            JagritiAssoicateDetails.RESET;
            JagritiAssoicateDetails.SETRANGE("Request No.", Rec."Ref. Entry No.");
            IF JagritiAssoicateDetails.FINDFIRST THEN BEGIN
                JagritiApprovalEntry.RESET;
                JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::SpecialRequest);
                JagritiApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
                JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Pending);
                JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                JagritiApprovalEntry.SETFILTER("Entry No.", '>%1', Rec."Entry No.");
                JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
                IF JagritiApprovalEntry.FINDFIRST THEN BEGIN
                    JagritiAssoicateDetails."Request Status" := 'Pending';
                    JagritiAssoicateDetails."Request Pending From" := JagritiApprovalEntry."Approver Name";
                    JagritiAssoicateDetails.MODIFY;
                    ApprovalPending := TRUE;
                END;

                IF NOT ApprovalPending THEN BEGIN
                    JagritiApprovalEntry.RESET;
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::SpecialRequest);
                    JagritiApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
                    JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Rejected);
                    JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                    JagritiApprovalEntry.SETFILTER("Entry No.", '>%1', Rec."Entry No.");
                    JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
                    IF JagritiApprovalEntry.FINDFIRST THEN BEGIN
                        JagritiAssoicateDetails."Request Status" := 'Rejected';
                        JagritiAssoicateDetails."Request Pending From" := JagritiApprovalEntry."Approver Name";
                        JagritiAssoicateDetails.MODIFY;
                        ApprovalPending := TRUE;
                    END;
                END;
                IF NOT ApprovalPending THEN BEGIN
                    JagritiApprovalEntry.RESET;
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::SpecialRequest);
                    JagritiApprovalEntry.SETRANGE("Document Type", Rec."Document Type");
                    JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Approved);
                    JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                    JagritiApprovalEntry.SETFILTER("Entry No.", '<>%1', Rec."Entry No.");
                    JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
                    IF JagritiApprovalEntry.FINDFIRST THEN BEGIN
                        JagritiAssoicateDetails."Request Status" := 'Completed';
                        JagritiAssoicateDetails."Request Pending From" := '';
                        JagritiAssoicateDetails.MODIFY;
                        ApprovalPending := TRUE;
                    END;
                END;
                IF ApprovalPending = FALSE THEN BEGIN
                    JagritiAssoicateDetails."Request Status" := 'Completed';
                    JagritiAssoicateDetails."Request Pending From" := '';
                    JagritiAssoicateDetails.MODIFY;
                END;
                IF Rec.Status = Rec.Status::Rejected THEN BEGIN
                    JagritiAssoicateDetails.RESET;
                    JagritiAssoicateDetails.SETRANGE("Request No.", Rec."Ref. Entry No.");
                    IF JagritiAssoicateDetails.FINDFIRST THEN BEGIN
                        JagritiAssoicateDetails."Request Status" := 'Rejected';
                        JagritiAssoicateDetails.MODIFY;
                    END;
                END;
            END;



            JagritiApprovalEntry_L.RESET;
            JagritiApprovalEntry_L.SETRANGE("Form Type", JagritiApprovalEntry_L."Form Type"::SpecialRequest);
            JagritiApprovalEntry_L.SETFILTER("Entry No.", '>%1', Rec."Entry No.");
            JagritiApprovalEntry_L.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
            IF JagritiApprovalEntry_L.FINDSET THEN
                REPEAT
                    JagritiApprovalEntry_L."Date Sent for Approval" := TODAY;
                    JagritiApprovalEntry_L."Time Sent for Approval" := TIME;
                    IF JagritiApprovalEntry_L."Mail Required" THEN BEGIN
                        JagritiApprovalEntry_L."Approved / Rejected Date" := TODAY;
                        JagritiApprovalEntry_L."Approved / Rejected time" := TIME;
                    END;
                    JagritiApprovalEntry_L.MODIFY;
                    IF NOT JagritiApprovalEntry_L."Mail Required" THEN
                        FindPendingEntry := TRUE
                    ELSE
                        FindPendingEntry := FALSE;
                UNTIL (JagritiApprovalEntry_L.NEXT = 0) OR (FindPendingEntry);
        END;
    end;

    local procedure "---------------"()
    begin
    end;

    local procedure Input_lFnc()
    var
        ItemDetails: Text;
        JagratiCommentInputPage: Page "Jagrati comment Input Page";
    begin
        Clear(JagratiCommentInputPage);
        JagratiCommentInputPage.GetValues(Rec."Entry No.");
        JagratiCommentInputPage.Run();

    end;

    // local procedure Input_lFnc()
    // var

    // Prompt: DotNet Form;


    // FormBorderStyle: DotNet FormBorderStyle;

    // FormStartPosition: DotNet FormStartPosition;


    // LblRows: DotNet Label;

    // LblColumns: DotNet Label;


    // TxtRows: DotNet TextBox;

    // TxtColumns: DotNet TextBox;


    // ButtonOk: DotNet Button;

    // ButtonCancel: DotNet Button;


    // DialogResult: DotNet DialogResult;
    // TextLength: Integer;
    //  begin
    //Creating the Form - Starts
    // Prompt := Prompt.Form();
    // Prompt.Width := 350;
    // Prompt.Height := 180;
    // Prompt.FormBorderStyle := FormBorderStyle.FixedDialog;

    // Prompt.Text := 'Enter Details';
    // Prompt.StartPosition := FormStartPosition.CenterScreen;
    // //Creating the Form - Ends

    // //Adding Labels - Starts
    // LblRows := LblRows.Label();
    // LblRows.Text('Enter Comment');
    // LblRows.Left(20);
    // LblRows.Top(20);
    // Prompt.Controls.Add(LblRows);

    // //Adding Textboxes - Starts
    // TxtRows := TxtRows.TextBox();
    // TxtRows.Left(150);
    // TxtRows.Top(20);
    // TxtRows.Width(150);
    // Prompt.Controls.Add(TxtRows);

    // //Adding Button - Starts
    // ButtonOk := ButtonOk.Button();
    // ButtonOk.Text('OK');
    // ButtonOk.Left(50);
    // ButtonOk.Top(100);
    // ButtonOk.Width(100);
    // ButtonOk.DialogResult := DialogResult.OK;
    // Prompt.Controls.Add(ButtonOk);
    // Prompt.AcceptButton := ButtonOk;

    // ButtonCancel := ButtonCancel.Button();
    // ButtonCancel.Text('Cancel');
    // ButtonCancel.Left(200);
    // ButtonCancel.Top(100);
    // ButtonCancel.Width(100);
    // ButtonCancel.DialogResult := DialogResult.Cancel;
    // Prompt.Controls.Add(ButtonCancel);
    // Prompt.AcceptButton := ButtonCancel;
    // //Adding Button - Ends

    // // Getting the Result - Starts
    // IF (Prompt.ShowDialog().ToString() = DialogResult.OK.ToString()) THEN BEGIN
    //     IF TxtRows.Text <> '' THEN BEGIN
    //         TextLength := 0;
    //         TextLength := STRLEN(TxtRows.Text);
    //         IF TextLength > 200 THEN
    //             ERROR('Remarks can not be greater than 200 Characters');
    //         Rec."Status Comment" := TxtRows.Text;
    //         Rec.MODIFY;
    //     END;
    // END;
    // Prompt.Dispose();
    // // Getting the Result - Ends
    //    end;

    local procedure UpdateDateAndTime()
    var
        JagritiApprovalEntry_4: Record "Jagriti Approval Entry";
        JagritiAssoicateDetails_4: Record "Jagriti Assoicate Details";
        JagritiCustomerDetails_4: Record "Jagriti Customer Details";
    begin
        IF Rec."Form Type" = Rec."Form Type"::AssociateForm THEN BEGIN
            JagritiApprovalEntry_4.RESET;
            JagritiApprovalEntry_4.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
            JagritiApprovalEntry_4.SETFILTER("Approved / Rejected Date", '<>%1', 0D);
            JagritiApprovalEntry_4.SETFILTER("Approved / Rejected time", '<>%1', 0T);
            JagritiApprovalEntry_4.SETRANGE("Form Type", JagritiApprovalEntry_4."Form Type"::AssociateForm);
            IF JagritiApprovalEntry_4.FINDLAST THEN BEGIN
                JagritiAssoicateDetails_4.RESET;
                IF JagritiAssoicateDetails_4.GET(JagritiApprovalEntry_4."Ref. Entry No.") THEN BEGIN
                    JagritiAssoicateDetails_4."Last Approval / Reject Date" := JagritiApprovalEntry_4."Approved / Rejected Date";
                    JagritiAssoicateDetails_4."Last Approval / Reject Time" := JagritiApprovalEntry_4."Approved / Rejected time";
                    JagritiAssoicateDetails_4.MODIFY;
                END;
            END;
        END ELSE BEGIN
            JagritiApprovalEntry_4.RESET;
            JagritiApprovalEntry_4.SETRANGE("Ref. Entry No.", Rec."Ref. Entry No.");
            JagritiApprovalEntry_4.SETFILTER("Approved / Rejected Date", '<>%1', 0D);
            JagritiApprovalEntry_4.SETFILTER("Approved / Rejected time", '<>%1', 0T);
            JagritiApprovalEntry_4.SETRANGE("Form Type", JagritiApprovalEntry_4."Form Type"::CustomerForm);
            IF JagritiApprovalEntry_4.FINDLAST THEN BEGIN
                JagritiCustomerDetails_4.RESET;
                IF JagritiCustomerDetails_4.GET(JagritiApprovalEntry_4."Ref. Entry No.") THEN BEGIN
                    JagritiCustomerDetails_4."Last Approval / Reject Date" := JagritiApprovalEntry_4."Approved / Rejected Date";
                    JagritiCustomerDetails_4."Last Approval / Reject Time" := JagritiApprovalEntry_4."Approved / Rejected time";
                    JagritiCustomerDetails_4.MODIFY;
                END;
            END;
        END;
    end;
}

