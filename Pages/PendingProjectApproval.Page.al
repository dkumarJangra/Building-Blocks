page 50430 "Pending Project Card"
{

    PageType = Card;
    SourceTable = "Jagriti Approval Entry";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."Entry No.")
                {
                }
                field("Ref. Document No."; Rec."Ref. Document No.")
                {
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Attach Documents")
            {
                Caption = '&Attachment Documents List';
                trigger OnAction()
                var
                    myInt: Integer;
                    RecDocument: Record Document;

                begin
                    RecDocument.RESET;
                    RecDocument.SetRange("Table No.", 97798);
                    RecDocument.SetRange("Document No.", Rec."Ref. Document No.");
                    IF RecDocument.FindFirst() then
                        Page.RunModal(50418, RecDocument);

                end;

            }
            action(Approved)
            {

                trigger OnAction()
                var
                    ApprovalPending: Boolean;
                    DocumentMaster: Record "Document Master";
                    JagratiApprovalEntry: Record "Jagriti Approval Entry";
                    JagApprovalEntry: Record "Jagriti Approval Entry";
                begin
                    IF CONFIRM('Do you want to approve the selected Entries') THEN BEGIN
                        CurrPage.SetSelectionFilter(JagApprovalEntry);
                        If JagApprovalEntry.FindSet() then
                            repeat
                                JagApprovalEntry.TESTFIELD(Status, JagApprovalEntry.Status::Pending);
                                IF JagApprovalEntry."Approver ID" <> USERID then
                                    Error('You are not authorised to perform this task');

                                DocumentMaster.RESET;
                                DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);
                                IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Project Price Change" THEN BEGIN
                                    DocumentMaster.SetRange("Unit Code", '');
                                    DocumentMaster.SetRange("Project Code", JagApprovalEntry."Ref. Document No.");
                                END;
                                IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Unit Price Change" THEN BEGIN
                                    DocumentMaster.SetRange("Unit Code", JagApprovalEntry."Ref. Document No.");
                                END;
                                IF DocumentMaster.FindFirst() then
                                    DocumentMaster.TestField("Status", DocumentMaster."Status"::"Pending For Approval");


                                JagApprovalEntry.Status := JagApprovalEntry.Status::Approved;

                                JagApprovalEntry."Approved / Rejected Date" := TODAY;
                                JagApprovalEntry."Approved / Rejected time" := TIME;
                                JagApprovalEntry."Approved By" := USERID;
                                JagApprovalEntry.MODIFY;



                                DocumentMaster.RESET;
                                DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);
                                IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Project Price Change" THEN BEGIN
                                    DocumentMaster.SetRange("Unit Code", '');
                                    DocumentMaster.SetRange("Project Code", JagApprovalEntry."Ref. Document No.");
                                END;
                                IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Unit Price Change" THEN BEGIN
                                    DocumentMaster.SetRange("Unit Code", JagApprovalEntry."Ref. Document No.");
                                END;
                                IF DocumentMaster.Findset() then
                                    repeat
                                        DocumentMaster."Status" := DocumentMaster."Status"::Release;
                                        DocumentMaster.Modify;
                                    Until DocumentMaster.Next = 0;



                            Until JagApprovalEntry.Next = 0;
                        MESSAGE('Entry Approved successfully');
                    END ELSE
                        MESSAGE('Nothing Done');

                END;

            }

            action(Rejected)
            {

                trigger OnAction()
                var
                    JagritiSitewiseApprovalsetup: Record "Jagriti Sitewise Approvalsetup";
                    DocumentMaster: Record "Document Master";
                    JagApprovalEntry: Record "Jagriti Approval Entry";

                begin

                    IF CONFIRM('Do you want to Reject the selected Entries') THEN BEGIN
                        CurrPage.SetSelectionFilter(JagApprovalEntry);
                        IF JagApprovalEntry.Findset then
                            repeat

                                If JagApprovalEntry."Approver ID" <> USERID then
                                    Error('You are not authorised to perform this task');

                                DocumentMaster.RESET;
                                DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);

                                IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Project Price Change" THEN BEGIN
                                    DocumentMaster.SetRange("Unit Code", '');
                                    DocumentMaster.SetRange("Project Code", JagApprovalEntry."Ref. Document No.");
                                END;
                                IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Unit Price Change" THEN BEGIN
                                    DocumentMaster.SetRange("Unit Code", JagApprovalEntry."Ref. Document No.");
                                END;
                                IF DocumentMaster.Findset() then
                                    DocumentMaster.TestField(Status, DocumentMaster.Status::"Pending for Approval");


                                JagApprovalEntry.TESTFIELD(Status, JagApprovalEntry.Status::Pending);


                                JagApprovalEntry.Status := JagApprovalEntry.Status::Rejected;
                                JagApprovalEntry."Approved / Rejected Date" := TODAY;
                                JagApprovalEntry."Approved / Rejected time" := TIME;
                                JagApprovalEntry."Approved By" := USERID;
                                JagApprovalEntry.MODIFY;
                                COMMIT;
                                DocumentMaster.RESET;
                                DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);
                                IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Project Price Change" THEN BEGIN
                                    DocumentMaster.SetRange("Unit Code", '');
                                    DocumentMaster.SetRange("Project Code", JagApprovalEntry."Ref. Document No.");
                                END;
                                IF JagApprovalEntry."Document Type" = JagApprovalEntry."Document Type"::"Unit Price Change" THEN BEGIN
                                    DocumentMaster.SetRange("Unit Code", JagApprovalEntry."Ref. Document No.");
                                END;
                                IF DocumentMaster.Findset() then
                                    repeat
                                        DocumentMaster."Status" := DocumentMaster."Status"::Rejected;
                                        DocumentMaster.Modify;
                                    Until DocumentMaster.Next = 0;
                            until JagApprovalEntry.Next = 0;
                        MESSAGE('Entry Rejected successfully');

                    END ELSE
                        MESSAGE('Nothing Done');
                END;

            }

        }
    }


    var
        WebAppService: Codeunit "Web App Service";
        JagartiSitewiseApprovesetup: Record "Jagriti Sitewise Approvalsetup";
        ApproverFound: Boolean;
        JagritiAssoicateDetails: Record "Jagriti Assoicate Details";
        JagritiCustomerDetails: Record "Jagriti Customer Details";
        JagritiApprovalEntry: Record "Jagriti Approval Entry";
        CreateComments: Dialog;
        UserSetup: Record "User Setup";


}

