codeunit 97000 MyCodeunit
{
    trigger OnRun()
    begin

    end;

    PROCEDURE StoreJob2(VAR Job: Record Job);
    VAR
        JobArchive: Record "EPC Job Archive";
        JobTask: Record "Job Task";
        JobTaskArchive: Record "EPC Job Task Archive";
        JobPlanning: Record "Job Planning Line";
        JobPlanningArchive: Record "EPC Job Planning Line Archive";
        ArchiveManagement: Codeunit ArchiveManagement;
    BEGIN
        JobArchive.INIT;
        JobArchive.TRANSFERFIELDS(Job);
        JobArchive."Archived By" := USERID;
        JobArchive."Date Archived" := WORKDATE;
        JobArchive."Time Archived" := TIME;
        JobArchive."Version No." := ArchiveManagement.GetNextVersionNo(DATABASE::Job, 1, Job."No.", 1);
        JobArchive.INSERT;

        JobTask.RESET;
        JobTask.SETRANGE("Job No.", Job."No.");
        IF JobTask.FINDSET THEN
            REPEAT
                JobTaskArchive.INIT;
                JobTaskArchive.TRANSFERFIELDS(JobTask);
                JobTaskArchive."Version No." := JobArchive."Version No.";
                JobTaskArchive.INSERT;
            UNTIL JobTask.NEXT = 0;
        JobPlanning.RESET;
        JobPlanning.SETRANGE("Job No.", Job."No.");
        IF JobPlanning.FINDSET THEN
            REPEAT
                JobPlanningArchive.INIT;
                JobPlanningArchive.TRANSFERFIELDS(JobPlanning);
                JobPlanningArchive."Version No." := JobArchive."Version No.";
                JobPlanningArchive.INSERT;
            UNTIL JobPlanning.NEXT = 0;
    END;

    PROCEDURE CheckPostingType(GenJournalLine: Record "Gen. Journal Line");
    BEGIN
        IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer) OR
           (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor) THEN BEGIN
            IF GenJournalLine."Account No." <> '' THEN
                GenJournalLine.TESTFIELD("Posting Type");
        END;
        IF (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Customer) OR
           (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Vendor) THEN BEGIN
            IF GenJournalLine."Bal. Account No." <> '' THEN
                GenJournalLine.TESTFIELD("Posting Type");
        END;
    END;

    PROCEDURE CheckPurchaseIndentApprovalsWorkflowEnabled(VAR PurchaseIndentHeader: Record "Purchase Request Header"): Boolean;
    BEGIN
        IF NOT IsPurchaseIndentApprovalsWorkflowEnabled(PurchaseIndentHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    END;

    PROCEDURE IsPurchaseIndentApprovalsWorkflowEnabled(VAR PurchaseIndentHeader: Record "Purchase Request Header"): Boolean;
    BEGIN
        EXIT(WorkflowManagement.CanExecuteWorkflow(PurchaseIndentHeader, RunWorkflowOnSendPurchaseIndentDocForApprovalCode));
    END;

    PROCEDURE RunWorkflowOnSendPurchaseIndentDocForApprovalCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendPurchaseIndentDocForApproval'));
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendPurchaseIndentDocForApproval(VAR PurchaseIndentHeader: Record "Purchase Request Header");
    BEGIN
    END;


    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelPurchaseIndentApprovalRequest(VAR PurchaseIndentHeader: Record "Purchase Request Header");
    BEGIN
    END;

    PROCEDURE CheckPurchaseReceiptApprovalsWorkflowEnabled(VAR GoodsReceiptHeader: Record "GRN Header"): Boolean
    BEGIN
        IF NOT IsPurchaseReceiptApprovalsWorkflowEnabled(GoodsReceiptHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    END;

    PROCEDURE IsJobApprovalsWorkflowEnabled(VAR Job: Record Job): Boolean
    BEGIN
        EXIT(WorkflowManagement.CanExecuteWorkflow(Job, RunWorkflowOnSendJobForApprovalCode));
    END;

    PROCEDURE RunWorkflowOnSendJobForApprovalCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendJobForApproval'));
    END;

    PROCEDURE IsPurchaseReceiptApprovalsWorkflowEnabled(VAR GoodsReceiptHeader: Record "GRN Header"): Boolean
    BEGIN
        EXIT(WorkflowManagement.CanExecuteWorkflow(GoodsReceiptHeader, RunWorkflowOnSendPurchaseReceiptDocForApprovalCode));
    END;

    PROCEDURE RunWorkflowOnSendPurchaseReceiptDocForApprovalCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendPurchaseReceiptDocForApproval'));
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendPurchaseReceiptDocForApproval(VAR GoodsReceiptHeader: Record "GRN Header")
    BEGIN
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelPurchaseReceiptApprovalRequest(VAR GoodsReceiptHeader: Record "GRN Header")
    BEGIN
    END;

    PROCEDURE InsertBomCompSchedulJobPlaning(VAR JobPlanning: Record "Job Planning Line");
    VAR
        Selection: Integer;
        Item: Record Item;
    BEGIN
        JobPlanning.TESTFIELD(Type, JobPlanning.Type::Item);
        JobPlanning.TESTFIELD(Quantity);
        JobPlanning.TESTFIELD("Location Code");
        FromBOMComp.SETRANGE("Parent Item No.", JobPlanning."No.");
        NoOfBOMComp := FromBOMComp.COUNT;
        IF NoOfBOMComp = 0 THEN
            ERROR(
              Text001,
              JobPlanning."No.");

        Selection := STRMENU(Text004, 2);
        IF Selection = 0 THEN
            EXIT;

        ToJobPlanning.RESET;
        ToJobPlanning.SETRANGE("Job No.", JobPlanning."Job No.");
        ToJobPlanning.SETRANGE("Job Task No.", JobPlanning."Job Task No.");
        ToJobPlanning := JobPlanning;
        IF ToJobPlanning.FIND('>') THEN BEGIN
            LineSpacing := (ToJobPlanning."Line No." - JobPlanning."Line No.") DIV (1 + NoOfBOMComp);
            IF LineSpacing = 0 THEN
                ERROR(Text003);
        END ELSE
            LineSpacing := 10000;

        IF JobPlanning."Line Type" = JobPlanning."Line Type"::Schedule THEN BEGIN
            ToJobPlanning := JobPlanning;
            FromBOMComp.SETRANGE(Type, FromBOMComp.Type::Item);
            FromBOMComp.SETFILTER("No.", '<>%1', '');
            IF FromBOMComp.FINDSET THEN
                REPEAT
                    FromBOMComp.TESTFIELD(Type, FromBOMComp.Type::Item);
                    Item.GET(FromBOMComp."No.");
                    ToJobPlanning."Line No." := 0;
                    ToJobPlanning."No." := FromBOMComp."No.";
                    ToJobPlanning."Variant Code" := FromBOMComp."Variant Code";
                    ToJobPlanning."Unit of Measure Code" := FromBOMComp."Unit of Measure Code";
                    ToJobPlanning."Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, FromBOMComp."Unit of Measure Code");
                    ToJobPlanning.Quantity := ROUND(JobPlanning.Quantity * FromBOMComp."Quantity per", 0.00001);
                UNTIL FromBOMComp.NEXT = 0;
        END;

        IF JobPlanning."BOM Item No." = '' THEN
            BOMItemNo := JobPlanning."No."
        ELSE
            BOMItemNo := JobPlanning."BOM Item No.";

        ToJobPlanning := JobPlanning;

        ToJobPlanning.INIT;
        ToJobPlanning.Description := JobPlanning.Description;
        ToJobPlanning."Description 2" := JobPlanning."Description 2";
        ToJobPlanning."BOM Item No." := BOMItemNo;
        ToJobPlanning.Type := JobPlanning.Type;
        ToJobPlanning.MODIFY;
        ToJobPlanning.DELETE;

        FromBOMComp.RESET;
        FromBOMComp.SETRANGE("Parent Item No.", JobPlanning."No.");
        FromBOMComp.SETFILTER("No.", '<>%1', JobPlanning."No.");  //RAHEE1.00 050612
        NextLineNo := JobPlanning."Line No.";
        IF FromBOMComp.FINDSET THEN
            REPEAT
                ToJobPlanning.INIT;
                NextLineNo := NextLineNo + LineSpacing;
                ToJobPlanning."Line No." := NextLineNo;
                CASE FromBOMComp.Type OF
                    FromBOMComp.Type::Item:
                        ToJobPlanning.Type := ToJobPlanning.Type::Item;
                    FromBOMComp.Type::Resource:
                        ToJobPlanning.Type := ToJobPlanning.Type::Resource;
                END;
                ToJobPlanning.VALIDATE("No.", FromBOMComp."No.");
                IF ToJobPlanning.Type = ToJobPlanning.Type::Item THEN BEGIN
                    Item.GET(FromBOMComp."No.");
                    ToJobPlanning.VALIDATE("Unit of Measure Code", FromBOMComp."Unit of Measure Code");
                    ToJobPlanning."Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, ToJobPlanning."Unit of Measure Code");
                    ToJobPlanning.VALIDATE(Quantity,
                      ROUND(
                        JobPlanning.Quantity * FromBOMComp."Quantity per" *
                        UOMMgt.GetQtyPerUnitOfMeasure(Item, ToJobPlanning."Unit of Measure Code") /
                        ToJobPlanning."Qty. per Unit of Measure",
                        0.00001));
                END;
                ToJobPlanning."Location Code" := JobPlanning."Location Code";
                ToJobPlanning."Line Type" := JobPlanning."Line Type";
                ToJobPlanning."BOM Item No." := BOMItemNo;
                ToJobPlanning."BOQ Type" := JobPlanning."BOQ Type";
                IF BOMItemNo <> ToJobPlanning."No." THEN
                    ToJobPlanning."Explode Lines" := TRUE
                ELSE BEGIN
                    ToJobPlanning."Explode Lines" := FALSE;
                    ToJobPlanning."Unit Price" := JobPlanning."Unit Price";
                    ToJobPlanning.VALIDATE("Unit Price");
                    ToJobPlanning."Line Amount" := JobPlanning."Line Amount";
                    ToJobPlanning.VALIDATE("Line Amount");
                END;
                ToJobPlanning.INSERT(TRUE);
            UNTIL FromBOMComp.NEXT = 0;
    END;

    PROCEDURE "Don'tPostILE"("Don'tPost": Boolean);
    var
        "GDon'tPost": Boolean;
    BEGIN
        "GDon'tPost" := "Don'tPost"  // ALLEAA
    END;

    var
        myInt: Integer;
        WorkflowManagement: Codeunit "Workflow Management";
        NoWorkflowEnabledErr: Label 'This record is not supported by related approval workflow.';
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        FromBOMComp: Record "BOM Component";
        NoOfBOMComp: Integer;
        Text003: Label 'There is not enough space to explode the BOM.';
        Text000: Label 'The BOM cannot be exploded on the sales lines because it is associated with purchase order %1.';
        Text001: Label 'Item %1 is not a BOM.';
        Text004: Label '&Copy dimensions from BOM,&Retrieve dimensions from components';
        ToJobPlanning: Record "Job Planning Line";
        LineSpacing: Integer;
        BOMItemNo: Code[20];
        UOMMgt: Codeunit "Unit of Measure Management";
        NextLineNo: Integer;
}