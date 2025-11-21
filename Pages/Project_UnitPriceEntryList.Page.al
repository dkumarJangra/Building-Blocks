page 50432 "Project/Unit Approval List"
{
    Caption = 'Project/Unit Approval Lists';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    //CardPageId = "Pending Project Card";
    SourceTable = "Jagriti Approval Entry";
    SourceTableView = SORTING("Entry No.") where(
    "Document Type" = filter('Project Price Change' | 'Unit Price Change'));
    ApplicationArea = All;
    UsageCategory = Lists;
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
                Field("Ref. Document No."; Rec."Ref. Document No.")
                {
                    Editable = false;
                }
                Field("Project Id"; Rec."Project Id")
                {
                    Editable = False;
                }
                field("Project Name"; Rec."Project Name")
                {
                    Editable = False;
                }

                field("Approver ID"; Rec."Approver ID")
                {
                    Editable = false;
                }
                field("Approver Name"; Rec."Approver Name")
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
                    Editable = false;
                }
                field("Status Comment 2"; Rec."Status Comment 2")
                {
                    Editable = False;
                    Caption = 'Maker Comment';
                }
                field("Status Comment 3"; Rec."Status Comment 3")
                {
                    Editable = False;
                    Caption = 'Checker Comment';
                }
            }
        }
    }

    // actions
    // {
    //     area(processing)
    //     {
    //         action("&Attach Documents")
    //         {
    //             Caption = '&Attachment Documents List';
    //             Promoted = True;
    //             PromotedCategory = Process;
    //             trigger OnAction()
    //             var
    //                 myInt: Integer;
    //                 RecDocument: Record Document;

    //             begin
    //                 RecDocument.RESET;
    //                 RecDocument.SetRange("Table No.", 97798);
    //                 RecDocument.SetRange("Document No.", Rec."Ref. Document No.");
    //                 IF RecDocument.FindFirst() then
    //                     Page.RunModal(50418, RecDocument);

    //             end;

    //         }
    //         action(Approved)
    //         {
    //             Caption = 'Approved';
    //             Promoted = True;
    //             PromotedCategory = Process;

    //             trigger OnAction()
    //             var
    //                 ApprovalPending: Boolean;
    //                 DocumentMaster: Record "Document Master";
    //                 JagratiApprovalEntry: Record "Jagriti Approval Entry";
    //                 JagApprovalEntry: Record "Jagriti Approval Entry";
    //             begin
    //                 IF CONFIRM('Do you want to approve the selected Entries') THEN BEGIN
    //                     CurrPage.SetSelectionFilter(JagApprovalEntry);
    //                     If JagApprovalEntry.FindSet() then
    //                         repeat
    //                             JagApprovalEntry.TESTFIELD(Status, JagApprovalEntry.Status::Pending);
    //                             IF JagApprovalEntry."Approver ID" <> USERID then
    //                                 Error('You are not authorised to perform this task');

    //                             DocumentMaster.RESET;
    //                             DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);
    //                             IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Project Price Change" THEN BEGIN
    //                                 DocumentMaster.SetRange("Unit Code", '');
    //                                 DocumentMaster.SetRange("Project Code", JagApprovalEntry."Ref. Document No.");
    //                             END;
    //                             IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Unit Price Change" THEN BEGIN
    //                                 DocumentMaster.SetRange("Unit Code", JagApprovalEntry."Ref. Document No.");
    //                             END;
    //                             IF DocumentMaster.FindFirst() then
    //                                 DocumentMaster.TestField("Status", DocumentMaster."Status"::"Pending For Approval");


    //                             JagApprovalEntry.Status := JagApprovalEntry.Status::Approved;

    //                             JagApprovalEntry."Approved / Rejected Date" := TODAY;
    //                             JagApprovalEntry."Approved / Rejected time" := TIME;
    //                             JagApprovalEntry."Approved By" := USERID;
    //                             JagApprovalEntry.MODIFY;



    //                             DocumentMaster.RESET;
    //                             DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);
    //                             IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Project Price Change" THEN BEGIN
    //                                 DocumentMaster.SetRange("Unit Code", '');
    //                                 DocumentMaster.SetRange("Project Code", JagApprovalEntry."Ref. Document No.");
    //                             END;
    //                             IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Unit Price Change" THEN BEGIN
    //                                 DocumentMaster.SetRange("Unit Code", JagApprovalEntry."Ref. Document No.");
    //                             END;
    //                             IF DocumentMaster.Findset() then
    //                                 repeat
    //                                     DocumentMaster."Status" := DocumentMaster."Status"::Release;
    //                                     DocumentMaster.Modify;
    //                                 Until DocumentMaster.Next = 0;



    //                         Until JagApprovalEntry.Next = 0;
    //                     MESSAGE('Entry Approved successfully');
    //                 END ELSE
    //                     MESSAGE('Nothing Done');

    //             END;

    //         }

    //         action(Rejected)
    //         {
    //             Caption = 'Rejected';
    //             Promoted = True;
    //             PromotedCategory = Process;

    //             trigger OnAction()
    //             var
    //                 JagritiSitewiseApprovalsetup: Record "Jagriti Sitewise Approvalsetup";
    //                 DocumentMaster: Record "Document Master";
    //                 JagApprovalEntry: Record "Jagriti Approval Entry";

    //             begin

    //                 IF CONFIRM('Do you want to Reject the selected Entries') THEN BEGIN
    //                     CurrPage.SetSelectionFilter(JagApprovalEntry);
    //                     IF JagApprovalEntry.Findset then
    //                         repeat

    //                             If JagApprovalEntry."Approver ID" <> USERID then
    //                                 Error('You are not authorised to perform this task');

    //                             DocumentMaster.RESET;
    //                             DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);

    //                             IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Project Price Change" THEN BEGIN
    //                                 DocumentMaster.SetRange("Unit Code", '');
    //                                 DocumentMaster.SetRange("Project Code", JagApprovalEntry."Ref. Document No.");
    //                             END;
    //                             IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Unit Price Change" THEN BEGIN
    //                                 DocumentMaster.SetRange("Unit Code", JagApprovalEntry."Ref. Document No.");
    //                             END;
    //                             IF DocumentMaster.Findset() then
    //                                 DocumentMaster.TestField(Status, DocumentMaster.Status::"Pending for Approval");


    //                             JagApprovalEntry.TESTFIELD(Status, JagApprovalEntry.Status::Pending);


    //                             JagApprovalEntry.Status := JagApprovalEntry.Status::Rejected;
    //                             JagApprovalEntry."Approved / Rejected Date" := TODAY;
    //                             JagApprovalEntry."Approved / Rejected time" := TIME;
    //                             JagApprovalEntry."Approved By" := USERID;
    //                             JagApprovalEntry.MODIFY;
    //                             COMMIT;
    //                             DocumentMaster.RESET;
    //                             DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);
    //                             IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Project Price Change" THEN BEGIN
    //                                 DocumentMaster.SetRange("Unit Code", '');
    //                                 DocumentMaster.SetRange("Project Code", JagApprovalEntry."Ref. Document No.");
    //                             END;
    //                             IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Unit Price Change" THEN BEGIN
    //                                 DocumentMaster.SetRange("Unit Code", JagApprovalEntry."Ref. Document No.");
    //                             END;
    //                             IF DocumentMaster.Findset() then
    //                                 repeat
    //                                     DocumentMaster."Status" := DocumentMaster."Status"::Rejected;
    //                                     DocumentMaster.Modify;
    //                                 Until DocumentMaster.Next = 0;
    //                         until JagApprovalEntry.Next = 0;
    //                     MESSAGE('Entry Rejected successfully');

    //                 END ELSE
    //                     MESSAGE('Nothing Done');
    //             END;

    //         }

    //         action(Comment)
    //         {
    //             Caption = 'Comment';
    //             Promoted = True;
    //             PromotedCategory = Process;

    //             trigger OnAction()
    //             begin
    //                 Rec.TESTFIELD(Status, Rec.Status::Pending);
    //                 Input_lFnc;
    //             end;
    //         }
    //     }
    //    }

    trigger OnOpenPage()
    begin
        //  Rec.SETRANGE("Approver ID", USERID);
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

}

