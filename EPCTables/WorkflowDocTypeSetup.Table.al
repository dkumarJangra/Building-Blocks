table 97877 "Workflow Doc. Type Setup"
{
    Caption = 'Workflow Doc. Type Setup';
    DataCaptionFields = "Transaction Type", "Document Type", "Sub Document Type";
    DrillDownPageID = "Job Planning Line Subform1";
    LookupPageID = "Job Planning Line Subform1";

    fields
    {
        field(1; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            Description = 'PK';
            NotBlank = true;
            OptionCaption = ' ,Job,Indent,Enquiry,Purchase,Gate Entry,Purchase Receipt,Gate Pass,Sales,Service,Transfer,QC,General Journal,Item Journal,Award Note,Note Sheet';
            OptionMembers = " ",Job,Indent,Enquiry,Purchase,"Gate Entry","Purchase Receipt","Gate Pass",Sales,Service,Transfer,QC,"General Journal","Item Journal","Award Note","Note Sheet";

            trigger OnValidate()
            begin
                AssignDocumentType;
            end;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Description = 'PK';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";

            trigger OnValidate()
            begin
                CheckDocumentType;
            end;
        }
        field(3; "Sub Document Type"; Option)
        {
            Caption = 'Sub Document Type';
            Description = 'PK';
            OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward,TypeD1,TypeD2,TypeD3,TypeD4,TypeD5,TypeD6,TypeD7,TypeD8,TypeD9,TypeD10,TypeD11,TypeD12,TypeD13,TypeD14,TypeD15,TypeFADS,TypeFADM,TypeD12M,TypeD12S,TypeD8S,TypeD8M,TypeD3S,TypeD3M,TypeC13,TypeC4,TypeC14';
            OptionMembers = " ",FA,Regular,Direct,WorkOrder,Inward,Outward,TypeD1,TypeD2,TypeD3,TypeD4,TypeD5,TypeD6,TypeD7,TypeD8,TypeD9,TypeD10,TypeD11,TypeD12,TypeD13,TypeD14,TypeD15,TypeFADS,TypeFADM,TypeD12M,TypeD12S,TypeD8S,TypeD8M,TypeD3S,TypeD3M,TypeC13,TypeC4,TypeC14;
        }
        field(4; Enabled; Boolean)
        {
            Caption = 'Enabled';

            trigger OnValidate()
            var
                CodeunitEventMgt: Codeunit "BBG Codeunit Event Mgnt.";
            begin
                IF Enabled THEN BEGIN
                    CheckDocumentType;
                    IF NOT DocInitiatorExists THEN
                        ERROR(Text002, FORMAT("Transaction Type"), FORMAT("Document Type"), FORMAT("Sub Document Type"));
                    CheckDocInitiator;

                    DocumentTypeInitiator.RESET;
                    DocumentTypeInitiator.SETRANGE("Transaction Type", "Transaction Type");
                    DocumentTypeInitiator.SETRANGE("Document Type", "Document Type");
                    DocumentTypeInitiator.SETRANGE("Sub Document Type", "Sub Document Type");
                    IF DocumentTypeInitiator.FINDSET THEN
                        REPEAT
                            IF (NOT Workflow.GET(DocumentTypeInitiator."Workflow Code")) OR (DocumentTypeInitiator."Workflow Code" = '') THEN BEGIN
                                CASE "Transaction Type" OF
                                    "Transaction Type"::" ":
                                        BEGIN
                                            FIELDERROR("Transaction Type");
                                        END;
                                    "Transaction Type"::Job:
                                        BEGIN
                                            CodeunitEventMgt.InsertJobApprovalWorkflowDTS(
                                              Workflow, 0, 2, 0, '', BlankDateFormula, 0, DocumentTypeInitiator."Responsibility Center", DocumentTypeInitiator."Initiator User ID", DocumentTypeInitiator.Amendment);//Need to check the code in UAT
                                        END;
                                    "Transaction Type"::Indent:
                                        BEGIN
                                            CodeunitEventMgt.InsertPurchaseIndentDocumentApprovalWorkflowDTS(
                                              Workflow, 0, 2, 0, '', BlankDateFormula, "Sub Document Type", DocumentTypeInitiator."Responsibility Center", DocumentTypeInitiator."Initiator User ID", DocumentTypeInitiator.Amendment);//Need to check the code in UAT
                                        END;
                                    "Transaction Type"::Enquiry:
                                        BEGIN
                                        END;
                                    "Transaction Type"::Purchase:
                                        BEGIN
                                            CodeunitEventMgt.InsertPurchaseDocumentApprovalWorkflowDTS(
                                               Workflow, "Document Type", 2, 0, '', BlankDateFormula, "Sub Document Type", DocumentTypeInitiator."Responsibility Center", DocumentTypeInitiator."Initiator User ID", DocumentTypeInitiator.Amendment);//Need to check the code in UAT
                                        END;
                                    "Transaction Type"::"Gate Entry":
                                        BEGIN
                                        END;
                                    "Transaction Type"::"Purchase Receipt":
                                        BEGIN
                                            CodeunitEventMgt.InsertPurchaseReceiptDocumentApprovalWorkflowDTS(
                                              Workflow, 0, 2, 0, '', BlankDateFormula, "Sub Document Type", DocumentTypeInitiator."Responsibility Center", DocumentTypeInitiator."Initiator User ID", DocumentTypeInitiator.Amendment);//Need to check the code in UAT
                                        END;
                                    "Transaction Type"::"Gate Pass":
                                        BEGIN
                                        END;
                                    "Transaction Type"::Sales:
                                        BEGIN
                                            CodeunitEventMgt.InsertSalesDocumentApprovalWorkflowDTS(
                                              Workflow, "Document Type", 2, 0, '', BlankDateFormula, "Sub Document Type", DocumentTypeInitiator."Responsibility Center", DocumentTypeInitiator."Initiator User ID", DocumentTypeInitiator.Amendment);//Need to check the code in UAT
                                        END;
                                    "Transaction Type"::Service:
                                        BEGIN
                                        END;
                                    "Transaction Type"::Transfer:
                                        BEGIN
                                            CodeunitEventMgt.InsertTransferOrderDocumentApprovalWorkflowDTS(
                                              Workflow, 0, 2, 0, '', BlankDateFormula, "Sub Document Type", DocumentTypeInitiator."Responsibility Center", DocumentTypeInitiator."Initiator User ID", DocumentTypeInitiator.Amendment);//Need to check the code in UAT
                                        END;
                                    "Transaction Type"::QC:
                                        BEGIN
                                        END;
                                    "Transaction Type"::"General Journal":
                                        BEGIN
                                            IF DocumentTypeInitiator."Batch Name" = '' THEN
                                                CodeunitEventMgt.InsertGeneralJournalLineApprovalWorkflowDTS(
                                                  Workflow, 0, 2, 0, '', BlankDateFormula, DocumentTypeInitiator."Responsibility Center", DocumentTypeInitiator."Initiator User ID")//Need to check the code in UAT
                                            ELSE
                                                CodeunitEventMgt.InsertGeneralJournalBatchApprovalWorkflowDTS(
                                                  Workflow, 0, 2, 0, '', BlankDateFormula, DocumentTypeInitiator."Template Name", DocumentTypeInitiator."Batch Name");//Need to check the code in UAT
                                        END;
                                    "Transaction Type"::"Item Journal":
                                        BEGIN
                                            // IF DocumentTypeInitiator."Batch Name" = '' THEN
                                            //  WorkflowSetup.InsertItemJournalLineApprovalWorkflowDTS(Workflow,0,2,0,'',BlankDateFormula,DocumentTypeInitiator."Responsibility Center",DocumentTypeInitiator."Initiator User ID")
                                            // ELSE
                                            //  WorkflowSetup.InsertItemJournalBatchApprovalWorkflowDTS(Workflow,0,2,0,'',BlankDateFormula,DocumentTypeInitiator."Template Name",'');
                                        END;
                                //ALLE TS 17012017
                                //          "Transaction Type"::"Award Note":
                                //          BEGIN
                                //          WorkflowSetup.InsertAwardNoteApprovalWorkflowDTS(
                                //          Workflow,0,2,0,'',BlankDateFormula,"Sub Document Type",DocumentTypeInitiator."Responsibility Center"
                                //          ,DocumentTypeInitiator."Initiator User ID",DocumentTypeInitiator.Amendment);
                                //  END;
                                //ALLE TS 17012017
                                //ALLE AP 030417
                                // "Transaction Type"::"Note Sheet":
                                // BEGIN
                                // WorkflowSetup.InsertNoteSheetApprovalWorkflowDTS(
                                // Workflow,0,2,0,'',BlankDateFormula,"Sub Document Type",DocumentTypeInitiator."Responsibility Center"
                                // ,DocumentTypeInitiator."Initiator User ID",DocumentTypeInitiator.Amendment);
                                // END;
                                //ALLE AP 030417

                                END;
                                WorkflowUserGroup.INIT;
                                WorkflowUserGroup.Code := Workflow.Code;
                                WorkflowUserGroup.Description := Workflow.Description;
                                WorkflowUserGroup.INSERT;

                                DocumentTypeInitiator."Workflow Code" := Workflow.Code;
                                DocumentTypeInitiator.MODIFY;
                            END;

                            WorkflowUserGroupMember.RESET;
                            WorkflowUserGroupMember.SETRANGE("Workflow User Group Code", DocumentTypeInitiator."Workflow Code");
                            WorkflowUserGroupMember.DELETEALL;

                            DocumentTypeApproval.RESET;
                            DocumentTypeApproval.SETRANGE("Transaction Type", DocumentTypeInitiator."Transaction Type");
                            DocumentTypeApproval.SETRANGE("Document Type", DocumentTypeInitiator."Document Type");
                            DocumentTypeApproval.SETRANGE("Sub Document Type", DocumentTypeInitiator."Sub Document Type");
                            DocumentTypeApproval.SETRANGE("Template Name", DocumentTypeInitiator."Template Name");
                            DocumentTypeApproval.SETRANGE("Batch Name", DocumentTypeInitiator."Batch Name");
                            DocumentTypeApproval.SETRANGE("Initiator User ID", DocumentTypeInitiator."Initiator User ID");
                            DocumentTypeApproval.SETRANGE("Responsibility Center", DocumentTypeInitiator."Responsibility Center");
                            DocumentTypeApproval.SETRANGE(Amendment, DocumentTypeInitiator.Amendment);
                            IF DocumentTypeApproval.FINDSET THEN
                                REPEAT
                                    WorkflowUserGroupMember.INIT;
                                    WorkflowUserGroupMember."Workflow User Group Code" := DocumentTypeInitiator."Workflow Code";
                                    WorkflowUserGroupMember.VALIDATE("User Name", DocumentTypeApproval."Approver ID");
                                    WorkflowUserGroupMember."Approval Amount Limit" := DocumentTypeApproval."Approval Amount Limit";
                                    // WorkflowUserGroupMember."Sub Document Type" := DocumentTypeApproval."Sub Document Type"; // Alle-AP 200120
                                    WorkflowUserGroupMember.INSERT;
                                UNTIL DocumentTypeApproval.NEXT = 0;

                            Workflow.VALIDATE(Enabled, TRUE);
                            Workflow.MODIFY;
                        UNTIL DocumentTypeInitiator.NEXT = 0;
                END ELSE BEGIN
                    DocumentTypeInitiator.RESET;
                    DocumentTypeInitiator.SETRANGE("Transaction Type", "Transaction Type");
                    DocumentTypeInitiator.SETRANGE("Document Type", "Document Type");
                    DocumentTypeInitiator.SETRANGE("Sub Document Type", "Sub Document Type");
                    IF DocumentTypeInitiator.FINDSET THEN
                        REPEAT
                            IF Workflow.GET(DocumentTypeInitiator."Workflow Code") THEN BEGIN
                                Workflow.VALIDATE(Enabled, FALSE);
                                Workflow.MODIFY;
                            END;
                        UNTIL DocumentTypeInitiator.NEXT = 0;
                END;
            end;
        }
        field(7; "Indent Required"; Boolean)
        {
        }
        field(8; "Gate Entry Required"; Boolean)
        {
        }
        field(9; "Job Allocation Required"; Boolean)
        {
        }
        field(10; "Milestone Mandatory"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "Document Type", "Sub Document Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestEnabled;
        DocInitiator.RESET;
        DocInitiator.SETRANGE("Transaction Type", "Transaction Type");
        DocInitiator.SETRANGE("Document Type", "Document Type");
        DocInitiator.SETRANGE("Sub Document Type", "Sub Document Type");
        DocInitiator.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    begin
        //"Document Type" := "Document Type"::Order;
    end;

    trigger OnRename()
    begin
        //ERROR(Text001,TABLECAPTION);
    end;

    var
        Text001: Label 'You cannot rename a %1.';
        DocInitiator: Record "Workflow Doc. Type Initiator";
        Text002: Label 'The document type setup %1 %2  %3 does not have any initiator lines.';
        Text003: Label 'The document type setup %1 %2 %3 does not have any approver lines for Initiator %4, Key Responsibility Center %5.';
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        WorkflowSetup: Codeunit "Workflow Setup";
        DocumentTypeInitiator: Record "Workflow Doc. Type Initiator";
        DocumentTypeApproval: Record "Workflow Doc. Type Approvers";
        WorkflowUserGroup: Record "Workflow User Group";
        WorkflowUserGroupMember: Record "Workflow User Group Member";
        Workflow: Record Workflow;
        BlankDateFormula: DateFormula;

    local procedure AssignDocumentType()
    begin
        //,Job,Indent,Enquiry,Purchase,Gate Entry,Purchase Receipt,Gate Pass,Sales,Service,Transfer,QC,General Journal,Item Journal
        IF "Transaction Type" IN ["Transaction Type"::Job, "Transaction Type"::"Gate Entry", "Transaction Type"::"Gate Entry",
          "Transaction Type"::"Purchase Receipt", "Transaction Type"::Transfer, "Transaction Type"::"Gate Pass", "Transaction Type"::QC] THEN
            "Document Type" := "Document Type"::Order;
        IF "Transaction Type" IN ["Transaction Type"::Indent, "Transaction Type"::Enquiry, "Transaction Type"::"General Journal", "Transaction Type"::"Item Journal"] THEN
            "Document Type" := "Document Type"::Order;
    end;

    local procedure CheckDocumentType()
    begin
        IF "Transaction Type" = "Transaction Type"::" " THEN
            FIELDERROR("Transaction Type");
        IF "Transaction Type" IN ["Transaction Type"::Job, "Transaction Type"::"Gate Entry", "Transaction Type"::"Purchase Receipt",
          "Transaction Type"::Transfer, "Transaction Type"::"Gate Pass", "Transaction Type"::QC] THEN
            TESTFIELD("Document Type", "Document Type"::Order);
        IF "Transaction Type" IN ["Transaction Type"::Indent, "Transaction Type"::Enquiry, "Transaction Type"::"General Journal",
          "Transaction Type"::"Item Journal", "Transaction Type"::"Award Note", "Transaction Type"::"Note Sheet"] THEN
            TESTFIELD("Document Type", "Document Type"::Order);
    end;

    local procedure TestEnabled()
    begin
        TESTFIELD(Enabled, FALSE);
    end;

    local procedure DocInitiatorExists(): Boolean
    var
        DocInitiator: Record "Workflow Doc. Type Initiator";
    begin
        DocInitiator.RESET;
        DocInitiator.SETRANGE("Transaction Type", "Transaction Type");
        DocInitiator.SETRANGE("Document Type", "Document Type");
        DocInitiator.SETRANGE("Sub Document Type", "Sub Document Type");
        EXIT(NOT DocInitiator.ISEMPTY);
    end;

    local procedure CheckDocInitiator()
    var
        DocInitiator: Record "Workflow Doc. Type Initiator";
    begin
        DocInitiator.RESET;
        DocInitiator.SETRANGE("Transaction Type", "Transaction Type");
        DocInitiator.SETRANGE("Document Type", "Document Type");
        DocInitiator.SETRANGE("Sub Document Type", "Sub Document Type");
        IF DocInitiator.FINDSET THEN
            REPEAT
                IF NOT DocInitiator.DocApproverExists THEN
                    ERROR(Text003, FORMAT("Transaction Type"), FORMAT("Document Type"), FORMAT("Sub Document Type"), DocInitiator."Initiator User ID", DocInitiator."Responsibility Center");
            UNTIL DocInitiator.NEXT = 0;
    end;
}

