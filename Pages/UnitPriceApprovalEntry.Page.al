page 50417 "Unit Price Approval"
{
    Caption = 'Unit Price Approval Entries';
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
                field("Ref. Document No."; Rec."Ref. Document No.")
                {

                    Caption = 'Unit Code';
                    Editable = false;
                }
                field("Project Id"; Rec."Project Id")
                {
                    Editable = false;
                }
                field("Project Name"; Rec."Project Name")
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
                Field("Requester ID"; Rec."Requester ID")
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

                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Status Comment"; Rec."Status Comment")
                {
                    Caption = 'Comment';
                }
                field("Status Comment 2"; Rec."Status Comment 2")
                {
                    Caption = 'Makrer Comment';
                    Editable = False;
                }
                field("Status Comment 3"; Rec."Status Comment 3")
                {
                    Caption = 'Checker Comment';
                    Editable = False;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approved)
            {

                trigger OnAction()
                var
                    ApprovalPending: Boolean;
                    DocumentMaster: Record "Document Master";
                    JagratiApprovalEntry: Record "Jagriti Approval Entry";
                    LastEntryNo: Integer;
                    JagratiApprovalSetup: Record "Jagriti Sitewise Approvalsetup";
                begin

                    Rec.TESTFIELD(Status, Rec.Status::Pending);
                    If Rec."Final Proj/Unit Price approver" = '' then begin
                        Checker_ApproverID();

                        //Rec.TESTFIELD("Status Comment");
                    END;
                    If Rec."Final Proj/Unit Price approver" <> '' then BEGIN
                        IF Rec."Approver ID" <> USERID then
                            Error('You are not Authorised person to Approve this Entry');
                    END;

                    IF CONFIRM('Do you want to approve the Entry No.-' + FORMAT(Rec."Entry No.")) THEN BEGIN

                        DocumentMaster.RESET;
                        DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);
                        IF Rec."Document Type" = Rec."Document Type"::"Unit Price Change" THEN BEGIN
                            DocumentMaster.SetRange("Unit Code", Rec."Ref. Document No.");
                        END;
                        IF DocumentMaster.FindFirst() then
                            DocumentMaster.TestField("Status", DocumentMaster."Status"::"Pending For Approval");

                        Rec.Status := Rec.Status::Approved;

                        Rec."Approved / Rejected Date" := TODAY;
                        Rec."Approved / Rejected time" := TIME;
                        Rec."Approved By" := USERID;
                        Rec.MODIFY;

                        IF Rec."Final Proj/Unit Price approver" = '' THEN begin
                            JagratiApprovalentry.RESET;
                            IF JagratiApprovalentry.FindLast() then
                                LastEntryNo := JagratiApprovalEntry."Entry No.";

                            JagratiApprovalSetup.RESET;
                            JagratiApprovalSetup.SetRange("Document Type", Rec."Document Type");
                            JagratiApprovalSetup.SetRange("Initiator ID", Rec."Requester ID");
                            If JagratiApprovalSetup.FindFirst() then begin
                                JagratiApprovalentry.Init;
                                JagratiApprovalentry."Entry No." := LastEntryNo + 1;
                                JagratiApprovalentry."Document Type" := Rec."Document Type";

                                JagratiApprovalentry."Ref. Document No." := REc."Ref. Document No.";
                                JagratiApprovalEntry."Project Id" := Rec."Project Id";
                                JagratiApprovalEntry."Project Name" := Rec."Project Name";
                                JagratiApprovalentry."Approver ID" := JagratiApprovalSetup."Approver ID";
                                JagratiApprovalSetup.CalcFields("Approver Name");
                                JagratiApprovalentry."Approver Name" := JagratiApprovalSetup."Approver Name";
                                JagratiApprovalentry."Date Sent for Approval" := Today;
                                JagratiApprovalentry."Time Sent for Approval" := Time;
                                JagratiApprovalentry."Final Proj/Unit Price approver" := JagratiApprovalSetup."Approver ID";
                                JagratiApprovalEntry."Status Comment 2" := Rec."Status Comment 2";
                                JagratiApprovalEntry."Status Comment 3" := Rec."Status Comment";
                                JagratiApprovalEntry."Requester ID" := Rec."Requester ID";
                                JagratiApprovalentry.Insert;
                            end;
                        END ELSE BEGIN

                            DocumentMaster.RESET;
                            DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);
                            IF Rec."Document Type" = Rec."Document Type"::"Unit Price Change" THEN BEGIN
                                DocumentMaster.SetRange("Unit Code", Rec."Ref. Document No.");
                            END;
                            IF DocumentMaster.Findset() then
                                repeat
                                    DocumentMaster."Status" := DocumentMaster."Status"::Release;
                                    DocumentMaster.Modify;
                                Until DocumentMaster.Next = 0;
                        END;
                        MESSAGE('Entry Approved successfully');
                    end ELSE
                        Message('Nothing to Process');
                END;


            }

            action(Rejected)
            {

                trigger OnAction()
                var
                    JagritiSitewiseApprovalsetup: Record "Jagriti Sitewise Approvalsetup";
                    DocumentMaster: Record "Document Master";

                begin
                    DocumentMaster.RESET;
                    DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);

                    IF Rec."Document Type" = Rec."Document Type"::"Project Price Change" THEN BEGIN
                        DocumentMaster.SetRange("Unit Code", '');
                        DocumentMaster.SetRange("Project Code", Rec."Ref. Document No.");
                    END;
                    IF Rec."Document Type" = Rec."Document Type"::"Unit Price Change" THEN BEGIN
                        DocumentMaster.SetRange("Unit Code", Rec."Ref. Document No.");
                    END;
                    IF DocumentMaster.Findset() then
                        DocumentMaster.TestField(Status, DocumentMaster.Status::"Pending for Approval");

                    //CheckApproverID;
                    Rec.TESTFIELD(Status, Rec.Status::Pending);
                    If Rec."Final Proj/Unit Price approver" = '' then begin
                        CheckApproverID;
                        Rec.TESTFIELD("Status Comment");
                    END;
                    If Rec."Final Proj/Unit Price approver" <> '' then BEGIN
                        IF Rec."Approver ID" <> USERID then
                            Error('You are not Authorised person to Reject this Entry');
                    END;

                    IF CONFIRM('Do you want to Reject the Entry No.-' + FORMAT(Rec."Entry No.")) THEN BEGIN
                        Rec.Status := Rec.Status::Rejected;
                        Rec."Approved / Rejected Date" := TODAY;
                        Rec."Approved / Rejected time" := TIME;
                        Rec."Approved By" := USERID;
                        Rec.MODIFY;
                        COMMIT;
                        DocumentMaster.RESET;
                        DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);
                        IF Rec."Document Type" = Rec."Document Type"::"Project Price Change" THEN BEGIN
                            DocumentMaster.SetRange("Unit Code", '');
                            DocumentMaster.SetRange("Project Code", Rec."Ref. Document No.");
                        END;
                        IF Rec."Document Type" = Rec."Document Type"::"Unit Price Change" THEN BEGIN
                            DocumentMaster.SetRange("Unit Code", Rec."Ref. Document No.");
                        END;
                        IF DocumentMaster.Findset() then
                            repeat
                                DocumentMaster."Status" := DocumentMaster."Status"::Rejected;
                                DocumentMaster.Modify;
                            Until DocumentMaster.Next = 0;

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

    local procedure Checker_ApproverID()
    begin

        ApproverFound := FALSE;

        IF Rec."Approver ID" = USERID THEN
            ApproverFound := TRUE;

        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //  JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Checker Approval ID", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;

        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Checker Approval ID 2", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Checker Approval ID 3", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;

        IF NOT ApproverFound THEN
            ERROR('Approver ID mismatch');
    end;

    local procedure CheckApproverID()
    begin

        ApproverFound := FALSE;
        IF Rec."Approver ID" = USERID THEN
            ApproverFound := TRUE;

        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //  JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");

            JagartiSitewiseApprovesetup.SETRANGE("Checker Approval ID", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;

        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Checker Approval ID 2", USERID);
            IF JagartiSitewiseApprovesetup.FINDFIRST THEN
                ApproverFound := TRUE;
        END;
        IF NOT ApproverFound THEN BEGIN
            JagartiSitewiseApprovesetup.RESET;
            JagartiSitewiseApprovesetup.SETRANGE("Document Type", Rec."Document Type");
            //JagartiSitewiseApprovesetup.SETRANGE("Site Code","Site Code");
            JagartiSitewiseApprovesetup.SETRANGE("Checker Approval ID 3", USERID);
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


}

