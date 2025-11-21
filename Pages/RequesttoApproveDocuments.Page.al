page 60727 "Request to Approve Documents"
{
    AutoSplitKey = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Request to Approve Documents";
    SourceTableView = WHERE(Status = CONST(" "));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Requester ID"; Rec."Requester ID")
                {
                }
                field("Requester DateTime"; Rec."Requester DateTime")
                {
                }
                field("Approver ID"; Rec."Approver ID")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Status Date Time"; Rec."Status Date Time")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Reject Comment"; Rec."Reject Comment")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function")
            {
                action(Approved)
                {

                    trigger OnAction()
                    var
                        ApprovedDocument: Boolean;
                        GatePassHeader: Record "Gate Pass Header";
                        V_GatePassHeader: Record "Gate Pass Header";
                        V_ConfirmedOrder: Record "Confirmed Order";
                        Vendor: Record Vendor;
                        Customer: Record Customer;
                        ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::" ");

                        IF USERID = Rec."Approver ID" THEN BEGIN
                            CurrPage.SETSELECTIONFILTER(ReqtoApproveDoc);
                            IF ReqtoApproveDoc.FINDSET THEN
                                REPEAT
                                    ApprovalWorkflowforAuditPr.RESET;
                                    ApprovalWorkflowforAuditPr.SETRANGE("Parallel Approval", TRUE);
                                    IF ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
                                        REPEAT
                                            H_RequesttoApproveDocuments.RESET;
                                            H_RequesttoApproveDocuments.SETRANGE("Document Type", ReqtoApproveDoc."Document Type");
                                            H_RequesttoApproveDocuments.SETRANGE("Document No.", ReqtoApproveDoc."Document No.");
                                            H_RequesttoApproveDocuments.SETRANGE(Status, H_RequesttoApproveDocuments.Status::" ");
                                            IF H_RequesttoApproveDocuments.FINDSET THEN
                                                REPEAT
                                                    H_RequesttoApproveDocuments.Status := H_RequesttoApproveDocuments.Status::Approved;
                                                    H_RequesttoApproveDocuments."Status Date Time" := CURRENTDATETIME;
                                                    H_RequesttoApproveDocuments."Actual Approved By" := USERID;
                                                    H_RequesttoApproveDocuments.MODIFY;
                                                UNTIL H_RequesttoApproveDocuments.NEXT = 0;
                                            IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Gold/Silver" THEN BEGIN
                                                V_GatePassHeader.RESET;
                                                V_GatePassHeader.SETRANGE("Document No.", ReqtoApproveDoc."Document No.");
                                                IF V_GatePassHeader.FINDFIRST THEN BEGIN
                                                    V_GatePassHeader."Approval Status" := V_GatePassHeader."Approval Status"::Approved;
                                                    V_GatePassHeader.MODIFY;
                                                END;
                                            END;

                                            IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Unit Vacate" THEN BEGIN
                                                V_ConfirmedOrder.RESET;
                                                V_ConfirmedOrder.SETRANGE("No.", ReqtoApproveDoc."Document No.");
                                                IF V_ConfirmedOrder.FINDFIRST THEN BEGIN
                                                    V_ConfirmedOrder."Approval Status (Unit Vacte)" := V_ConfirmedOrder."Approval Status (Unit Vacte)"::Approved;
                                                    V_ConfirmedOrder.MODIFY;
                                                END;
                                            END;
                                            IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Member Allocation" THEN BEGIN
                                                V_ConfirmedOrder.RESET;
                                                V_ConfirmedOrder.SETRANGE("No.", ReqtoApproveDoc."Document No.");
                                                IF V_ConfirmedOrder.FINDFIRST THEN BEGIN
                                                    V_ConfirmedOrder."Approval Status (Member)" := V_ConfirmedOrder."Approval Status (Member)"::Approved;
                                                    V_ConfirmedOrder.MODIFY;
                                                END;
                                            END;
                                            IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Unit Allocation" THEN BEGIN
                                                V_ConfirmedOrder.RESET;
                                                V_ConfirmedOrder.SETRANGE("No.", ReqtoApproveDoc."Document No.");
                                                IF V_ConfirmedOrder.FINDFIRST THEN BEGIN
                                                    V_ConfirmedOrder."Approval Status (Unit Allot)" := V_ConfirmedOrder."Approval Status (Unit Allot)"::Approved;
                                                    V_ConfirmedOrder.MODIFY;
                                                END;
                                            END;
                                            IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Plot Registration" THEN BEGIN
                                                PlotRegistrationDetails.RESET;
                                                PlotRegistrationDetails.SETRANGE("No.", ReqtoApproveDoc."Document No.");
                                                IF PlotRegistrationDetails.FINDFIRST THEN BEGIN
                                                    PlotRegistrationDetails."Approval Status" := PlotRegistrationDetails."Approval Status"::Approved;
                                                    PlotRegistrationDetails.MODIFY;
                                                END;
                                            END;
                                            IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::Vendor THEN BEGIN
                                                Vendor.RESET;
                                                Vendor.SETRANGE("No.", ReqtoApproveDoc."Document No.");
                                                IF Vendor.FINDFIRST THEN BEGIN
                                                    Vendor."BBG Approval Status" := Vendor."BBG Approval Status"::Approved;
                                                    Vendor.Blocked := Vendor.Blocked::" ";
                                                    Vendor.MODIFY;
                                                END;
                                            END;
                                            IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::Customer THEN BEGIN
                                                Customer.RESET;
                                                Customer.SETRANGE("No.", ReqtoApproveDoc."Document No.");
                                                IF Customer.FINDFIRST THEN BEGIN
                                                    Customer."BBG Approval Status" := Customer."BBG Approval Status"::Approved;
                                                    Customer.Blocked := Customer.Blocked::" ";
                                                    Customer.MODIFY;
                                                END;
                                            END;
                                            IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Vendor Black List" THEN BEGIN
                                                Vendor.RESET;
                                                Vendor.SETRANGE("No.", ReqtoApproveDoc."Document No.");
                                                IF Vendor.FINDFIRST THEN BEGIN
                                                    Vendor."BBG Approval Status BlackList" := Vendor."BBG Approval Status BlackList"::Approved;
                                                    Vendor.MODIFY;
                                                END;
                                            END;
                                        UNTIL ApprovalWorkflowforAuditPr.NEXT = 0;
                                    END ELSE BEGIN
                                        H_RequesttoApproveDocuments.RESET;
                                        H_RequesttoApproveDocuments.SETRANGE("Document Type", ReqtoApproveDoc."Document Type");
                                        H_RequesttoApproveDocuments.SETRANGE("Document No.", ReqtoApproveDoc."Document No.");
                                        IF ReqtoApproveDoc."Document Line No." <> 0 THEN
                                            H_RequesttoApproveDocuments.SETRANGE("Document Line No.", ReqtoApproveDoc."Document Line No.");
                                        H_RequesttoApproveDocuments.SETRANGE("Requester ID", ReqtoApproveDoc."Requester ID");
                                        H_RequesttoApproveDocuments.SETFILTER("Approver ID", '<>%1', ReqtoApproveDoc."Approver ID");
                                        IF H_RequesttoApproveDocuments.FINDFIRST THEN
                                            REPEAT
                                                IF ((H_RequesttoApproveDocuments.Sequence < ReqtoApproveDoc.Sequence) AND NOT (H_RequesttoApproveDocuments.Status = H_RequesttoApproveDocuments.Status::Approved)) THEN
                                                    ERROR('Document not approved from previous Approver.');
                                            UNTIL H_RequesttoApproveDocuments.NEXT = 0;
                                        //
                                        ReqtoApproveDoc.Status := ReqtoApproveDoc.Status::Approved;
                                        ReqtoApproveDoc."Status Date Time" := CURRENTDATETIME;
                                        ReqtoApproveDoc."Actual Approved By" := USERID;
                                        ReqtoApproveDoc.MODIFY;
                                        IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Gold/Silver" THEN BEGIN
                                            UpdateGold_SilverStatus(ReqtoApproveDoc);
                                        END;

                                        IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Unit Vacate" THEN BEGIN
                                            UpdateUnitVacateStatus(ReqtoApproveDoc);
                                        END;
                                        IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Member Allocation" THEN BEGIN
                                            UpdateMemberAllocationStatus(ReqtoApproveDoc);
                                        END;
                                        IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Unit Allocation" THEN BEGIN
                                            UpdateUnitAllocationStatus(ReqtoApproveDoc);
                                        END;
                                        IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Plot Registration" THEN BEGIN
                                            UpdatePlotRegistrationStatus(ReqtoApproveDoc);
                                        END;
                                        IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::Vendor THEN BEGIN
                                            UpdateVendorStatus(ReqtoApproveDoc);
                                        END;
                                        IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::Customer THEN BEGIN
                                            UpdateCustomerStatus(ReqtoApproveDoc);
                                        END;
                                        IF ReqtoApproveDoc."Document Type" = ReqtoApproveDoc."Document Type"::"Vendor Black List" THEN BEGIN
                                            UpdateVendorBlackListStatus(ReqtoApproveDoc);
                                        END;
                                    END;
                                UNTIL ReqtoApproveDoc.NEXT = 0;
                        END ELSE
                            ERROR('Approver id mismatch');
                    end;
                }
                action(Reject)
                {

                    trigger OnAction()
                    var
                        v_GatePassHeader: Record "Gate Pass Header";
                        V_ConfirmedOrder: Record "Confirmed Order";
                        Customer: Record Customer;
                        Vendor: Record Vendor;
                    begin
                        Rec.TESTFIELD("Reject Comment");
                        IF USERID = Rec."Approver ID" THEN BEGIN

                            IF Rec."Document Type" = Rec."Document Type"::Receipt THEN BEGIN
                                RequesttoApproveDocuments.RESET;
                                RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::Receipt);
                                RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                                RequesttoApproveDocuments.SETRANGE("Document Line No.", Rec."Document Line No.");
                                RequesttoApproveDocuments.SETFILTER("Line No.", '>=%1', Rec."Line No.");
                                IF RequesttoApproveDocuments.FINDSET THEN
                                    REPEAT
                                        RequesttoApproveDocuments.Status := RequesttoApproveDocuments.Status::Reject;
                                        RequesttoApproveDocuments.MODIFY;
                                    UNTIL RequesttoApproveDocuments.NEXT = 0;
                                NewApplicationPaymentEntry.RESET;
                                NewApplicationPaymentEntry.SETRANGE("Document Type", NewApplicationPaymentEntry."Document Type"::BOND);
                                NewApplicationPaymentEntry.SETRANGE("Document No.", Rec."Document No.");
                                NewApplicationPaymentEntry.SETRANGE("Line No.", Rec."Document Line No.");
                                IF NewApplicationPaymentEntry.FINDFIRST THEN BEGIN
                                    NewApplicationPaymentEntry."Send for Approval" := FALSE;
                                    NewApplicationPaymentEntry."Send for Approval DT" := 0DT;
                                    NewApplicationPaymentEntry.MODIFY;
                                END;
                            END ELSE
                                IF Rec."Document Type" = Rec."Document Type"::"Gold/Silver" THEN BEGIN
                                    RequesttoApproveDocuments.RESET;
                                    RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Gold/Silver");
                                    RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                                    RequesttoApproveDocuments.SETFILTER("Line No.", '>=%1', Rec."Line No.");
                                    IF RequesttoApproveDocuments.FINDSET THEN
                                        REPEAT
                                            RequesttoApproveDocuments.Status := RequesttoApproveDocuments.Status::Reject;
                                            RequesttoApproveDocuments.MODIFY;
                                        UNTIL RequesttoApproveDocuments.NEXT = 0;
                                    v_GatePassHeader.RESET;
                                    v_GatePassHeader.SETRANGE("Document No.", Rec."Document No.");
                                    IF v_GatePassHeader.FINDFIRST THEN BEGIN
                                        v_GatePassHeader."Approval Status" := v_GatePassHeader."Approval Status"::Rejected;
                                        v_GatePassHeader.MODIFY;
                                    END;
                                END ELSE
                                    IF Rec."Document Type" = Rec."Document Type"::"Member to Member Transfer" THEN BEGIN
                                        RequesttoApproveDocuments.RESET;
                                        RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Member to Member Transfer");
                                        RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                                        RequesttoApproveDocuments.SETRANGE("Document Line No.", Rec."Document Line No.");
                                        RequesttoApproveDocuments.SETFILTER("Line No.", '>=%1', Rec."Line No.");
                                        IF RequesttoApproveDocuments.FINDSET THEN
                                            REPEAT
                                                RequesttoApproveDocuments.Status := RequesttoApproveDocuments.Status::Reject;
                                                RequesttoApproveDocuments.MODIFY;
                                            UNTIL RequesttoApproveDocuments.NEXT = 0;
                                        NewApplicationPaymentEntry.RESET;
                                        NewApplicationPaymentEntry.SETRANGE("Document Type", NewApplicationPaymentEntry."Document Type"::BOND);
                                        NewApplicationPaymentEntry.SETRANGE("Document No.", Rec."Document No.");
                                        NewApplicationPaymentEntry.SETRANGE("Line No.", Rec."Document Line No.");
                                        IF NewApplicationPaymentEntry.FINDFIRST THEN BEGIN
                                            NewApplicationPaymentEntry."Send for Approval" := FALSE;
                                            NewApplicationPaymentEntry."Send for Approval DT" := 0DT;
                                            NewApplicationPaymentEntry.MODIFY;
                                        END;
                                    END ELSE
                                        IF Rec."Document Type" = Rec."Document Type"::"Unit Vacate" THEN BEGIN
                                            RequesttoApproveDocuments.RESET;
                                            RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Unit Vacate");
                                            RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                                            RequesttoApproveDocuments.SETFILTER("Line No.", '>=%1', Rec."Line No.");
                                            IF RequesttoApproveDocuments.FINDSET THEN
                                                REPEAT
                                                    RequesttoApproveDocuments.Status := RequesttoApproveDocuments.Status::Reject;
                                                    RequesttoApproveDocuments.MODIFY;
                                                UNTIL RequesttoApproveDocuments.NEXT = 0;
                                            V_ConfirmedOrder.RESET;
                                            V_ConfirmedOrder.SETRANGE("No.", Rec."Document No.");
                                            IF V_ConfirmedOrder.FINDFIRST THEN BEGIN
                                                V_ConfirmedOrder."Approval Status (Unit Vacte)" := V_ConfirmedOrder."Approval Status (Unit Vacte)"::Rejected;
                                                V_ConfirmedOrder.MODIFY;
                                            END;
                                        END ELSE
                                            IF Rec."Document Type" = Rec."Document Type"::"Member Allocation" THEN BEGIN
                                                RequesttoApproveDocuments.RESET;
                                                RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Member Allocation");
                                                RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                                                RequesttoApproveDocuments.SETFILTER("Line No.", '>=%1', Rec."Line No.");
                                                IF RequesttoApproveDocuments.FINDSET THEN
                                                    REPEAT
                                                        RequesttoApproveDocuments.Status := RequesttoApproveDocuments.Status::Reject;
                                                        RequesttoApproveDocuments.MODIFY;
                                                    UNTIL RequesttoApproveDocuments.NEXT = 0;
                                                V_ConfirmedOrder.RESET;
                                                V_ConfirmedOrder.SETRANGE("No.", Rec."Document No.");
                                                IF V_ConfirmedOrder.FINDFIRST THEN BEGIN
                                                    V_ConfirmedOrder."Approval Status (Member)" := V_ConfirmedOrder."Approval Status (Member)"::Rejected;
                                                    V_ConfirmedOrder.MODIFY;
                                                END;
                                            END ELSE
                                                IF Rec."Document Type" = Rec."Document Type"::"Unit Allocation" THEN BEGIN
                                                    RequesttoApproveDocuments.RESET;
                                                    RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Unit Allocation");
                                                    RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                                                    RequesttoApproveDocuments.SETFILTER("Line No.", '>=%1', Rec."Line No.");
                                                    IF RequesttoApproveDocuments.FINDSET THEN
                                                        REPEAT
                                                            RequesttoApproveDocuments.Status := RequesttoApproveDocuments.Status::Reject;
                                                            RequesttoApproveDocuments.MODIFY;
                                                        UNTIL RequesttoApproveDocuments.NEXT = 0;
                                                    V_ConfirmedOrder.RESET;
                                                    V_ConfirmedOrder.SETRANGE("No.", Rec."Document No.");
                                                    IF V_ConfirmedOrder.FINDFIRST THEN BEGIN
                                                        V_ConfirmedOrder."Approval Status (Unit Allot)" := V_ConfirmedOrder."Approval Status (Unit Allot)"::Rejected;
                                                        V_ConfirmedOrder.MODIFY;
                                                    END;
                                                END ELSE
                                                    IF Rec."Document Type" = Rec."Document Type"::"Plot Registration" THEN BEGIN
                                                        RequesttoApproveDocuments.RESET;
                                                        RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Plot Registration");
                                                        RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                                                        RequesttoApproveDocuments.SETFILTER("Line No.", '>=%1', Rec."Line No.");
                                                        IF RequesttoApproveDocuments.FINDSET THEN
                                                            REPEAT
                                                                RequesttoApproveDocuments.Status := RequesttoApproveDocuments.Status::Reject;
                                                                RequesttoApproveDocuments.MODIFY;
                                                            UNTIL RequesttoApproveDocuments.NEXT = 0;
                                                    END ELSE
                                                        IF Rec."Document Type" = Rec."Document Type"::Vendor THEN BEGIN
                                                            RequesttoApproveDocuments.RESET;
                                                            RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::Vendor);
                                                            RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                                                            RequesttoApproveDocuments.SETFILTER("Line No.", '>=%1', Rec."Line No.");
                                                            IF RequesttoApproveDocuments.FINDSET THEN
                                                                REPEAT
                                                                    RequesttoApproveDocuments.Status := RequesttoApproveDocuments.Status::Reject;
                                                                    RequesttoApproveDocuments.MODIFY;
                                                                UNTIL RequesttoApproveDocuments.NEXT = 0;
                                                            Vendor.RESET;
                                                            Vendor.SETRANGE("No.", Rec."Document No.");
                                                            IF Vendor.FINDFIRST THEN BEGIN
                                                                Vendor."BBG Approval Status" := Vendor."BBG Approval Status"::Rejected;
                                                                Vendor.Blocked := Vendor.Blocked::All;
                                                                Vendor.MODIFY;
                                                            END;
                                                        END ELSE
                                                            IF Rec."Document Type" = Rec."Document Type"::Customer THEN BEGIN
                                                                RequesttoApproveDocuments.RESET;
                                                                RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::Customer);
                                                                RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                                                                RequesttoApproveDocuments.SETFILTER("Line No.", '>=%1', Rec."Line No.");
                                                                IF RequesttoApproveDocuments.FINDSET THEN
                                                                    REPEAT
                                                                        RequesttoApproveDocuments.Status := RequesttoApproveDocuments.Status::Reject;
                                                                        RequesttoApproveDocuments.MODIFY;
                                                                    UNTIL RequesttoApproveDocuments.NEXT = 0;
                                                                Customer.RESET;
                                                                Customer.SETRANGE("No.", Rec."Document No.");
                                                                IF Customer.FINDFIRST THEN BEGIN
                                                                    Customer."BBG Approval Status" := Customer."BBG Approval Status"::Rejected;
                                                                    Customer.Blocked := Customer.Blocked::All;
                                                                    Customer.MODIFY;
                                                                END;
                                                            END ELSE
                                                                IF Rec."Document Type" = Rec."Document Type"::"Vendor Black List" THEN BEGIN
                                                                    RequesttoApproveDocuments.RESET;
                                                                    RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Vendor Black List");
                                                                    RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                                                                    RequesttoApproveDocuments.SETFILTER("Line No.", '>=%1', Rec."Line No.");
                                                                    IF RequesttoApproveDocuments.FINDSET THEN
                                                                        REPEAT
                                                                            RequesttoApproveDocuments.Status := RequesttoApproveDocuments.Status::Reject;
                                                                            RequesttoApproveDocuments.MODIFY;
                                                                        UNTIL RequesttoApproveDocuments.NEXT = 0;
                                                                    Vendor.RESET;
                                                                    Vendor.SETRANGE("No.", Rec."Document No.");
                                                                    IF Vendor.FINDFIRST THEN BEGIN
                                                                        Vendor."BBG Approval Status BlackList" := Vendor."BBG Approval Status BlackList"::Rejected;
                                                                        Vendor.MODIFY;
                                                                    END;
                                                                END;
                        END ELSE
                            ERROR('Approver id mismatch');
                    end;
                }
                action("Open Document")
                {

                    trigger OnAction()
                    var
                        V_GatePassHeader: Record "Gate Pass Header";
                        Vendor: Record Vendor;
                        Customer: Record Customer;
                    begin
                        IF Rec."Document Type" = Rec."Document Type"::Receipt THEN BEGIN
                            NewConfirmedOrder.RESET;
                            IF NewConfirmedOrder.GET(Rec."Document No.") THEN BEGIN
                                PAGE.RUNMODAL(Page::"New Unit Card", NewConfirmedOrder, NewConfirmedOrder."No.");
                            END;
                        END ELSE
                            IF Rec."Document Type" = Rec."Document Type"::"Gold/Silver" THEN BEGIN
                                V_GatePassHeader.RESET;
                                V_GatePassHeader.SETRANGE("Document No.", Rec."Document No.");
                                IF V_GatePassHeader.FINDFIRST THEN
                                    PAGE.RUNMODAL(Page::"MIN Header-Gold/Silver Direct", V_GatePassHeader, V_GatePassHeader."Document No.");
                            END;

                        IF Rec."Document Type" = Rec."Document Type"::"Unit Vacate" THEN BEGIN
                            ConfirmedOrder.RESET;
                            ConfirmedOrder.SETRANGE("No.", Rec."Document No.");
                            IF ConfirmedOrder.FINDFIRST THEN
                                PAGE.RUNMODAL(Page::"Unit Vacate /Member Allocation", ConfirmedOrder, ConfirmedOrder."No.");
                        END;

                        IF Rec."Document Type" = Rec."Document Type"::"Member Allocation" THEN BEGIN
                            ConfirmedOrder.RESET;
                            ConfirmedOrder.SETRANGE("No.", Rec."Document No.");
                            IF ConfirmedOrder.FINDFIRST THEN
                                PAGE.RUNMODAL(Page::"Unit Vacate /Member Allocation", ConfirmedOrder, ConfirmedOrder."No.");
                        END;
                        IF Rec."Document Type" = Rec."Document Type"::"Unit Allocation" THEN BEGIN
                            ConfirmedOrder.RESET;
                            ConfirmedOrder.SETRANGE("No.", Rec."Document No.");
                            IF ConfirmedOrder.FINDFIRST THEN
                                PAGE.RUNMODAL(Page::"Unit Allocation", ConfirmedOrder, ConfirmedOrder."No.");
                        END;

                        IF Rec."Document Type" = Rec."Document Type"::"Plot Registration" THEN BEGIN
                            PlotRegistrationDetails.RESET;
                            PlotRegistrationDetails.SETRANGE("No.", Rec."Document No.");
                            IF PlotRegistrationDetails.FINDFIRST THEN
                                PAGE.RUNMODAL(Page::"Plot Registration Details Card", PlotRegistrationDetails, PlotRegistrationDetails."No.");
                        END;

                        IF Rec."Document Type" = Rec."Document Type"::Vendor THEN BEGIN
                            Vendor.RESET;
                            Vendor.SETRANGE("No.", Rec."Document No.");
                            IF Vendor.FINDFIRST THEN
                                PAGE.RUNMODAL(Page::"Vendor Card", Vendor, Vendor."No.");
                        END;

                        IF Rec."Document Type" = Rec."Document Type"::Vendor THEN BEGIN
                            Customer.RESET;
                            Customer.SETRANGE("No.", Rec."Document No.");
                            IF Customer.FINDFIRST THEN
                                PAGE.RUNMODAL(Page::"Customer Card", Customer, Customer."No.");
                        END;
                    end;
                }

                action("Document Attachment")
                {
                    RunObject = Page "Document file Upload";
                    RunPageLink = "Document No." = FIELD("Document No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SETRANGE("Approver ID", USERID);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF Rec.Status = Rec.Status::Reject THEN
            Rec.TESTFIELD("Reject Comment");
    end;

    trigger OnOpenPage()
    begin
        IF USERID <> 'BBGIDNDIA\BCUSER' THEN
            Rec.SETRANGE("Approver ID", USERID);
    end;

    var
        NewConfirmedOrder: Record "New Confirmed Order";
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        RequesttoApproveDocuments: Record "Request to Approve Documents";
        ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        ConfirmedOrder: Record "Confirmed Order";
        PlotRegistrationDetails: Record "Plot Registration Details";
        H_RequesttoApproveDocuments: Record "Request to Approve Documents";
        ReqtoApproveDoc: Record "Request to Approve Documents";

    local procedure CheckApprovedReceiptEntries(P_RequesttoApproveDocuments: Record "Request to Approve Documents")
    var
        v_ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        ApprovedDocument: Boolean;
    begin

        /*
        v_ApprovalWorkflowforAuditPr.RESET;
        v_ApprovalWorkflowforAuditPr.SETRANGE("Document Type",v_ApprovalWorkflowforAuditPr."Document Type"::Receipt);
        v_ApprovalWorkflowforAuditPr.SETRANGE("Requester ID",P_RequesttoApproveDocuments."Requester ID");
        IF v_ApprovalWorkflowforAuditPr.FINDSET THEN
          REPEAT
            RequesttoApproveDocuments.RESET;
            RequesttoApproveDocuments.SETRANGE("Document Type",RequesttoApproveDocuments."Document Type"::Receipt);
            RequesttoApproveDocuments.SETRANGE("Document No.","Document No.");
            RequesttoApproveDocuments.SETRANGE("Document Line No.","Document Line No.");
            RequesttoApproveDocuments.SETRANGE("Requester ID",v_ApprovalWorkflowforAuditPr."Requester ID");
            RequesttoApproveDocuments.SETRANGE("Approver ID",v_ApprovalWorkflowforAuditPr."Approver ID");
            RequesttoApproveDocuments.SETRANGE(Status,RequesttoApproveDocuments.Status::Approved);
            IF NOT RequesttoApproveDocuments.FINDFIRST THEN
              ApprovedDocument := FALSE;
        UNTIL (v_ApprovalWorkflowforAuditPr.NEXT = 0) OR (ApprovedDocument = FALSE);
        
        
        NewApplicationPaymentEntry.RESET;
        NewApplicationPaymentEntry.SETRANGE("Document Type",NewApplicationPaymentEntry."Document Type"::BOND);
        NewApplicationPaymentEntry.SETRANGE("Document No.","Document No.");
        NewApplicationPaymentEntry.SETRANGE("Line No.","Document Line No.");
        IF NewApplicationPaymentEntry.FINDFIRST THEN BEGIN
          IF ApprovedDocument THEN
          NewApplicationPaymentEntry.MODIFY;
        END;
        */

    end;

    local procedure UpdateGold_SilverStatus(P_RequesttoApproveDocuments: Record "Request to Approve Documents")
    var
        V_GatePassHeader: Record "Gate Pass Header";
        V_ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        V_RequesttoApproveDocuments: Record "Request to Approve Documents";
        DocumentApproved: Boolean;
    begin
        DocumentApproved := TRUE;
        V_ApprovalWorkflowforAuditPr.RESET;
        V_ApprovalWorkflowforAuditPr.SETRANGE("Document Type", P_RequesttoApproveDocuments."Document Type");
        V_ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", P_RequesttoApproveDocuments."Requester ID");
        IF V_ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
            REPEAT
                V_RequesttoApproveDocuments.RESET;
                V_RequesttoApproveDocuments.SETRANGE("Document Type", V_RequesttoApproveDocuments."Document Type"::"Gold/Silver");
                V_RequesttoApproveDocuments.SETRANGE("Document No.", P_RequesttoApproveDocuments."Document No.");
                V_RequesttoApproveDocuments.SETRANGE("Approver ID", V_ApprovalWorkflowforAuditPr."Approver ID");
                V_RequesttoApproveDocuments.SETRANGE(Status, V_RequesttoApproveDocuments.Status::Approved);
                IF NOT V_RequesttoApproveDocuments.FINDFIRST THEN BEGIN
                    DocumentApproved := FALSE;
                END;
            UNTIL (V_ApprovalWorkflowforAuditPr.NEXT = 0) OR (DocumentApproved = FALSE);
            IF DocumentApproved THEN BEGIN
                V_GatePassHeader.RESET;
                V_GatePassHeader.SETRANGE("Document No.", P_RequesttoApproveDocuments."Document No.");
                IF V_GatePassHeader.FINDFIRST THEN BEGIN
                    V_GatePassHeader."Approval Status" := V_GatePassHeader."Approval Status"::Approved;
                    V_GatePassHeader.MODIFY;
                END;
            END;
            MESSAGE('Document Approved');

        END ELSE
            ERROR('Approver not found');
    end;

    local procedure UpdateUnitVacateStatus(P_RequesttoApproveDocuments: Record "Request to Approve Documents")
    var
        V_ConfirmedOrder: Record "Confirmed Order";
        V_ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        V_RequesttoApproveDocuments: Record "Request to Approve Documents";
        DocumentApproved: Boolean;
    begin
        DocumentApproved := TRUE;
        V_ApprovalWorkflowforAuditPr.RESET;
        V_ApprovalWorkflowforAuditPr.SETRANGE("Document Type", P_RequesttoApproveDocuments."Document Type");
        V_ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", P_RequesttoApproveDocuments."Requester ID");
        IF V_ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
            REPEAT
                V_RequesttoApproveDocuments.RESET;
                V_RequesttoApproveDocuments.SETRANGE("Document Type", V_RequesttoApproveDocuments."Document Type"::"Unit Vacate");
                V_RequesttoApproveDocuments.SETRANGE("Document No.", P_RequesttoApproveDocuments."Document No.");
                V_RequesttoApproveDocuments.SETRANGE("Approver ID", V_ApprovalWorkflowforAuditPr."Approver ID");
                V_RequesttoApproveDocuments.SETRANGE(Status, V_RequesttoApproveDocuments.Status::Approved);
                IF NOT V_RequesttoApproveDocuments.FINDFIRST THEN BEGIN
                    DocumentApproved := FALSE;
                END;
            UNTIL (V_ApprovalWorkflowforAuditPr.NEXT = 0) OR (DocumentApproved = FALSE);
            IF DocumentApproved THEN BEGIN
                V_ConfirmedOrder.RESET;
                V_ConfirmedOrder.SETRANGE("No.", P_RequesttoApproveDocuments."Document No.");
                IF V_ConfirmedOrder.FINDFIRST THEN BEGIN
                    V_ConfirmedOrder."Approval Status (Unit Vacte)" := V_ConfirmedOrder."Approval Status (Unit Vacte)"::Approved;
                    V_ConfirmedOrder.MODIFY;
                END;
            END;
            MESSAGE('Document Approved');

        END ELSE
            ERROR('Approver not found');
    end;

    local procedure UpdateMemberAllocationStatus(P_RequesttoApproveDocuments: Record "Request to Approve Documents")
    var
        V_ConfirmedOrder: Record "Confirmed Order";
        V_ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        V_RequesttoApproveDocuments: Record "Request to Approve Documents";
        DocumentApproved: Boolean;
    begin
        DocumentApproved := TRUE;
        V_ApprovalWorkflowforAuditPr.RESET;
        V_ApprovalWorkflowforAuditPr.SETRANGE("Document Type", P_RequesttoApproveDocuments."Document Type");
        V_ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", P_RequesttoApproveDocuments."Requester ID");
        IF V_ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
            REPEAT
                V_RequesttoApproveDocuments.RESET;
                V_RequesttoApproveDocuments.SETRANGE("Document Type", V_RequesttoApproveDocuments."Document Type"::"Member Allocation");
                V_RequesttoApproveDocuments.SETRANGE("Document No.", P_RequesttoApproveDocuments."Document No.");
                V_RequesttoApproveDocuments.SETRANGE("Approver ID", V_ApprovalWorkflowforAuditPr."Approver ID");
                V_RequesttoApproveDocuments.SETRANGE(Status, V_RequesttoApproveDocuments.Status::Approved);
                IF NOT V_RequesttoApproveDocuments.FINDFIRST THEN BEGIN
                    DocumentApproved := FALSE;
                END;
            UNTIL (V_ApprovalWorkflowforAuditPr.NEXT = 0) OR (DocumentApproved = FALSE);
            IF DocumentApproved THEN BEGIN
                V_ConfirmedOrder.RESET;
                V_ConfirmedOrder.SETRANGE("No.", P_RequesttoApproveDocuments."Document No.");
                IF V_ConfirmedOrder.FINDFIRST THEN BEGIN
                    V_ConfirmedOrder."Approval Status (Member)" := V_ConfirmedOrder."Approval Status (Member)"::Approved;
                    V_ConfirmedOrder.MODIFY;
                END;
            END;
            MESSAGE('Document Approved');

        END ELSE
            ERROR('Approver not found');
    end;

    local procedure UpdateUnitAllocationStatus(P_RequesttoApproveDocuments: Record "Request to Approve Documents")
    var
        V_ConfirmedOrder: Record "Confirmed Order";
        V_ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        V_RequesttoApproveDocuments: Record "Request to Approve Documents";
        DocumentApproved: Boolean;
    begin
        DocumentApproved := TRUE;
        V_ApprovalWorkflowforAuditPr.RESET;
        V_ApprovalWorkflowforAuditPr.SETRANGE("Document Type", P_RequesttoApproveDocuments."Document Type");
        V_ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", P_RequesttoApproveDocuments."Requester ID");
        IF V_ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
            REPEAT
                V_RequesttoApproveDocuments.RESET;
                V_RequesttoApproveDocuments.SETRANGE("Document Type", V_RequesttoApproveDocuments."Document Type"::"Unit Allocation");
                V_RequesttoApproveDocuments.SETRANGE("Document No.", P_RequesttoApproveDocuments."Document No.");
                V_RequesttoApproveDocuments.SETRANGE("Approver ID", V_ApprovalWorkflowforAuditPr."Approver ID");
                V_RequesttoApproveDocuments.SETRANGE(Status, V_RequesttoApproveDocuments.Status::Approved);
                IF NOT V_RequesttoApproveDocuments.FINDFIRST THEN BEGIN
                    DocumentApproved := FALSE;
                END;
            UNTIL (V_ApprovalWorkflowforAuditPr.NEXT = 0) OR (DocumentApproved = FALSE);
            IF DocumentApproved THEN BEGIN
                V_ConfirmedOrder.RESET;
                V_ConfirmedOrder.SETRANGE("No.", P_RequesttoApproveDocuments."Document No.");
                IF V_ConfirmedOrder.FINDFIRST THEN BEGIN
                    V_ConfirmedOrder."Approval Status (Unit Allot)" := V_ConfirmedOrder."Approval Status (Unit Allot)"::Approved;
                    V_ConfirmedOrder.MODIFY;
                END;
            END;
            MESSAGE('Document Approved');

        END ELSE
            ERROR('Approver not found');
    end;

    local procedure UpdatePlotRegistrationStatus(P_RequesttoApproveDocuments: Record "Request to Approve Documents")
    var
        V_ConfirmedOrder: Record "Confirmed Order";
        V_ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        V_RequesttoApproveDocuments: Record "Request to Approve Documents";
        DocumentApproved: Boolean;
    begin
        DocumentApproved := TRUE;
        V_ApprovalWorkflowforAuditPr.RESET;
        V_ApprovalWorkflowforAuditPr.SETRANGE("Document Type", P_RequesttoApproveDocuments."Document Type");
        V_ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", P_RequesttoApproveDocuments."Requester ID");
        IF V_ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
            REPEAT
                V_RequesttoApproveDocuments.RESET;
                V_RequesttoApproveDocuments.SETRANGE("Document Type", V_RequesttoApproveDocuments."Document Type"::"Plot Registration");
                V_RequesttoApproveDocuments.SETRANGE("Document No.", P_RequesttoApproveDocuments."Document No.");
                V_RequesttoApproveDocuments.SETRANGE("Approver ID", V_ApprovalWorkflowforAuditPr."Approver ID");
                V_RequesttoApproveDocuments.SETRANGE(Status, V_RequesttoApproveDocuments.Status::Approved);
                IF NOT V_RequesttoApproveDocuments.FINDFIRST THEN BEGIN
                    DocumentApproved := FALSE;
                END;
            UNTIL (V_ApprovalWorkflowforAuditPr.NEXT = 0) OR (DocumentApproved = FALSE);
            IF DocumentApproved THEN BEGIN
                PlotRegistrationDetails.RESET;
                PlotRegistrationDetails.SETRANGE("No.", P_RequesttoApproveDocuments."Document No.");
                IF PlotRegistrationDetails.FINDFIRST THEN BEGIN
                    PlotRegistrationDetails."Approval Status" := PlotRegistrationDetails."Approval Status"::Approved;
                    PlotRegistrationDetails.MODIFY;
                END;
            END;
            MESSAGE('Document Approved');

        END ELSE
            ERROR('Approver not found');
    end;

    local procedure UpdateVendorStatus(P_RequesttoApproveDocuments: Record "Request to Approve Documents")
    var
        V_ConfirmedOrder: Record "Confirmed Order";
        V_ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        V_RequesttoApproveDocuments: Record "Request to Approve Documents";
        DocumentApproved: Boolean;
        Vendor: Record Vendor;
    begin
        DocumentApproved := TRUE;
        V_ApprovalWorkflowforAuditPr.RESET;
        V_ApprovalWorkflowforAuditPr.SETRANGE("Document Type", P_RequesttoApproveDocuments."Document Type");
        V_ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", P_RequesttoApproveDocuments."Requester ID");
        IF V_ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
            REPEAT
                V_RequesttoApproveDocuments.RESET;
                V_RequesttoApproveDocuments.SETRANGE("Document Type", V_RequesttoApproveDocuments."Document Type"::Vendor);
                V_RequesttoApproveDocuments.SETRANGE("Document No.", P_RequesttoApproveDocuments."Document No.");
                V_RequesttoApproveDocuments.SETRANGE("Approver ID", V_ApprovalWorkflowforAuditPr."Approver ID");
                V_RequesttoApproveDocuments.SETRANGE(Status, V_RequesttoApproveDocuments.Status::Approved);
                IF NOT V_RequesttoApproveDocuments.FINDFIRST THEN BEGIN
                    DocumentApproved := FALSE;
                END;
            UNTIL (V_ApprovalWorkflowforAuditPr.NEXT = 0) OR (DocumentApproved = FALSE);
            IF DocumentApproved THEN BEGIN
                Vendor.RESET;
                Vendor.SETRANGE("No.", P_RequesttoApproveDocuments."Document No.");
                IF Vendor.FINDFIRST THEN BEGIN
                    Vendor."BBG Approval Status" := Vendor."BBG Approval Status"::Approved;
                    Vendor.Blocked := Vendor.Blocked::" ";
                    Vendor.MODIFY;
                END;
            END;
            MESSAGE('Document Approved');

        END ELSE
            ERROR('Approver not found');
    end;

    local procedure UpdateCustomerStatus(P_RequesttoApproveDocuments: Record "Request to Approve Documents")
    var
        V_ConfirmedOrder: Record "Confirmed Order";
        V_ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        V_RequesttoApproveDocuments: Record "Request to Approve Documents";
        DocumentApproved: Boolean;
        Customer: Record Customer;
    begin
        DocumentApproved := TRUE;
        V_ApprovalWorkflowforAuditPr.RESET;
        V_ApprovalWorkflowforAuditPr.SETRANGE("Document Type", P_RequesttoApproveDocuments."Document Type");
        V_ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", P_RequesttoApproveDocuments."Requester ID");
        IF V_ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
            REPEAT
                V_RequesttoApproveDocuments.RESET;
                V_RequesttoApproveDocuments.SETRANGE("Document Type", V_RequesttoApproveDocuments."Document Type"::Customer);
                V_RequesttoApproveDocuments.SETRANGE("Document No.", P_RequesttoApproveDocuments."Document No.");
                V_RequesttoApproveDocuments.SETRANGE("Approver ID", V_ApprovalWorkflowforAuditPr."Approver ID");
                V_RequesttoApproveDocuments.SETRANGE(Status, V_RequesttoApproveDocuments.Status::Approved);
                IF NOT V_RequesttoApproveDocuments.FINDFIRST THEN BEGIN
                    DocumentApproved := FALSE;
                END;
            UNTIL (V_ApprovalWorkflowforAuditPr.NEXT = 0) OR (DocumentApproved = FALSE);
            IF DocumentApproved THEN BEGIN
                Customer.RESET;
                Customer.SETRANGE("No.", P_RequesttoApproveDocuments."Document No.");
                IF Customer.FINDFIRST THEN BEGIN
                    Customer."BBG Approval Status" := Customer."BBG Approval Status"::Approved;
                    Customer.Blocked := Customer.Blocked::" ";
                    Customer.MODIFY;
                END;
            END;
            MESSAGE('Document Approved');

        END ELSE
            ERROR('Approver not found');
    end;

    local procedure UpdateVendorBlackListStatus(P_RequesttoApproveDocuments: Record "Request to Approve Documents")
    var
        V_ConfirmedOrder: Record "Confirmed Order";
        V_ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        V_RequesttoApproveDocuments: Record "Request to Approve Documents";
        DocumentApproved: Boolean;
        Vendor: Record Vendor;
    begin
        DocumentApproved := TRUE;
        V_ApprovalWorkflowforAuditPr.RESET;
        V_ApprovalWorkflowforAuditPr.SETRANGE("Document Type", P_RequesttoApproveDocuments."Document Type");
        V_ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", P_RequesttoApproveDocuments."Requester ID");
        IF V_ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
            REPEAT
                V_RequesttoApproveDocuments.RESET;
                V_RequesttoApproveDocuments.SETRANGE("Document Type", V_RequesttoApproveDocuments."Document Type"::"Vendor Black List");
                V_RequesttoApproveDocuments.SETRANGE("Document No.", P_RequesttoApproveDocuments."Document No.");
                V_RequesttoApproveDocuments.SETRANGE("Approver ID", V_ApprovalWorkflowforAuditPr."Approver ID");
                V_RequesttoApproveDocuments.SETRANGE(Status, V_RequesttoApproveDocuments.Status::Approved);
                IF NOT V_RequesttoApproveDocuments.FINDFIRST THEN BEGIN
                    DocumentApproved := FALSE;
                END;
            UNTIL (V_ApprovalWorkflowforAuditPr.NEXT = 0) OR (DocumentApproved = FALSE);
            IF DocumentApproved THEN BEGIN
                Vendor.RESET;
                Vendor.SETRANGE("No.", P_RequesttoApproveDocuments."Document No.");
                IF Vendor.FINDFIRST THEN BEGIN
                    Vendor."BBG Approval Status BlackList" := Vendor."BBG Approval Status BlackList"::Approved;
                    Vendor.MODIFY;
                END;
            END;
            MESSAGE('Document Approved');

        END ELSE
            ERROR('Approver not found');
    end;
}

