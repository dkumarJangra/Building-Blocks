codeunit 97755 "Release Job"
{
    TableNo = Job;

    trigger OnRun()
    var
        JobPlanningLine: Record "Job Planning Line";
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        NotOnlyDropShipment: Boolean;
        PostingDate: Date;
        PrintPostedDocuments: Boolean;
        JobTask: Record "Job Task";
    begin
        IF Rec."Workflow Approval Status" = Rec."Workflow Approval Status"::Released THEN
            EXIT;
        Rec.CheckBeforeRelease;
        OnBeforeReleaseJob(Rec);
        Rec.OnCheckJobReleaseRestrictions;

        Rec.TESTFIELD("Bill-to Customer No.");

        //JobPlanningLine.SETRANGE("Document Type","Document Type");
        JobPlanningLine.SETRANGE("Job No.", Rec."No.");
        JobPlanningLine.SETFILTER(Type, '<>%1', JobPlanningLine.Type::Text);
        JobPlanningLine.SETFILTER(Quantity, '<>0');
        IF NOT JobPlanningLine.FIND('-') THEN
            ERROR(Text001, Rec.TABLECAPTION, Rec."No.");

        InvtSetup.GET;
        IF InvtSetup."Location Mandatory" THEN BEGIN
            //JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::Item);
            IF JobPlanningLine.FIND('-') THEN
                REPEAT
                    //IF NOT JobPlanningLine.IsServiceItem THEN
                    JobPlanningLine.TESTFIELD("Location Code");
                UNTIL JobPlanningLine.NEXT = 0;
            //JobPlanningLine.SETFILTER(Type,'>0');
        END;

        //JobPlanningLine.SETRANGE("Drop Shipment",FALSE);
        //NotOnlyDropShipment := JobPlanningLine.FIND('-');
        JobPlanningLine.RESET;

        //SalesSetup.GET;
        //IF PurchSetup."Calc. Inv. Discount" THEN BEGIN
        //PostingDate := "Posting Date";
        //PrintPostedDocuments := "Print Posted Documents";
        //CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount",PurchIndentLine);
        //GET("Document Type","No.");
        //"Print Posted Documents" := PrintPostedDocuments;
        //IF PostingDate <> "Posting Date" THEN
        //  VALIDATE("Posting Date",PostingDate);
        //END;

        //IF PrepaymentMgt.TestPurchasePrepayment(Rec) AND ("Document Type" = "Document Type"::Order) THEN BEGIN
        //  "Workflow Approval Status" := "Workflow Approval Status"::"Pending Prepayment";
        //  MODIFY(TRUE);
        //  EXIT;
        //END;

        Rec."Workflow Approval Status" := Rec."Workflow Approval Status"::Released;

        JobTask.SETRANGE("Job No.", Rec."No.");
        JobTask.MODIFYALL("Workflow Approval Status", Rec."Workflow Approval Status"::Released);

        JobPlanningLine.SETRANGE("Job No.", Rec."No.");
        JobPlanningLine.MODIFYALL("Workflow Approval Status", Rec."Workflow Approval Status"::Released);

        //JobPlanningLine.SetPurchIndentHeader(Rec);
        //JobPlanningLine.CalcVATAmountLines(0,Rec,PurchIndentLine,TempVATAmountLine0);
        //JobPlanningLine.CalcVATAmountLines(1,Rec,PurchIndentLine,TempVATAmountLine1);
        //JobPlanningLine.UpdateVATOnLines(0,Rec,PurchIndentLine,TempVATAmountLine0);
        //JobPlanningLine.UpdateVATOnLines(1,Rec,PurchIndentLine,TempVATAmountLine1);

        //MODIFY(TRUE);
        Rec.MODIFY;

        //IF NotOnlyDropShipment THEN
        //  IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
        //    WhsePurchRelease.Release(Rec);

        OnAfterReleaseJob(Rec);
    end;

    var
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2.';
        SalesSetup: Record "Sales & Receivables Setup";
        InvtSetup: Record "Inventory Setup";
        WhsePurchRelease: Codeunit "Whse.-Purch. Release";
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        Text005: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        Text001A: Label 'Payment Terms Due Dates are not in sequential order for %1 %2.';
        Text002A: Label 'Payment Terms amounts are not matching for %1 %2.';


    procedure Reopen(var Job: Record Job)
    var
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
    begin
        OnBeforeReopenJob(Job);

        IF Job."Workflow Approval Status" = Job."Workflow Approval Status"::Open THEN
            EXIT;

        //IF "Document Type" IN ["Document Type"::Indent] THEN
        //  WhsePurchRelease.Reopen(Job);
        Job."Workflow Approval Status" := Job."Workflow Approval Status"::Open;

        JobTask.SETRANGE("Job No.", Job."No.");
        JobTask.MODIFYALL("Workflow Approval Status", Job."Workflow Approval Status"::Open);

        JobPlanningLine.SETRANGE("Job No.", Job."No.");
        JobPlanningLine.MODIFYALL("Workflow Approval Status", Job."Workflow Approval Status"::Open);

        Job.MODIFY(TRUE);

        OnAfterReopenJob(Job);
    end;


    procedure PerformManualRelease(var Job: Record Job)
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalsMgmt: Codeunit MyCodeunit;// "Approvals Mgmt.";
    begin
        //WITH Job DO
        //IF ("Document Type" = "Document Type"::Indent) AND PrepaymentMgt.TestPurchasePayment(Job) THEN BEGIN
        //  IF "Workflow Approval Status" <> "Workflow Approval Status"::"Pending Prepayment" THEN BEGIN
        //    "Workflow Approval Status" := "Workflow Approval Status"::"Pending Prepayment";
        //    MODIFY;
        //    COMMIT;
        //  END;
        //  ERROR(STRSUBSTNO(Text005,"Document Type","No."));
        //END;

        IF ApprovalsMgmt.IsJobApprovalsWorkflowEnabled(Job) AND (Job."Workflow Approval Status" = Job."Workflow Approval Status"::Open) THEN
            ERROR(Text002);

        CODEUNIT.RUN(CODEUNIT::"Release Job", Job);
    end;


    procedure PerformManualReopen(var Job: Record Job)
    begin
        IF Job."Workflow Approval Status" = Job."Workflow Approval Status"::"Pending Approval" THEN
            ERROR(Text003);

        Reopen(Job);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReleaseJob(var Job: Record Job)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseJob(var Job: Record Job)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenJob(var Job: Record Job)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReopenJob(var Job: Record Job)
    begin
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::97731, 'OnBeforeReleaseJob', '', false, false)]
    // local procedure PerformOnBeforeReleaseJob(var Job: Record Job)
    // begin
    //     Job.CheckBeforeRelease;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::97731, 'OnAfterReleaseJob', '', false, false)]
    // local procedure PerformOnAfterReleaseJob(var Job: Record Job)
    // begin
    //     ReleaseJobPaymentTerms(Job);
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit:: 97731, 'OnBeforeReopenJob', '', false, false)]
    // local procedure PerformOnBeforeReopenJob(var Job: Record Job)
    // begin
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::97731, 'OnAfterReopenJob', '', false, false)]
    // local procedure PerformOnAfterReopenJob(var Job: Record Job)
    // begin
    //     ReopenJobPaymentTerms(Job);
    // end;

    local procedure ReleaseJobPaymentTerms(var Job: Record Job)
    var
        PaymentTermsLine: Record "Archive Applicable Charges";
        DueDate: Date;
        i: Integer;
        Amount: Decimal;
    begin
        //Job.TESTFIELD(Status,Job.Status::Open);
        /*
        PaymentTermsLine.RESET;
        PaymentTermsLine.SETRANGE("Table ID",DATABASE::Job);
        //PaymentTermsLine.SETRANGE("Document Type",Job."Document Type");
        PaymentTermsLine.SETRANGE("Document No.",Job."No.");
        PaymentTermsLine.SETRANGE("Doc. No. Occurrence",Job."Doc. No. Occurrence");
        PaymentTermsLine.SETRANGE("Version No.",0);
        PaymentTermsLine.SETRANGE("Transaction Type",PaymentTermsLine."Transaction Type"::Sale);
        IF PaymentTermsLine.FINDSET THEN BEGIN
          REPEAT
            PaymentTermsLine.TESTFIELD("Payment Terms Code");
            PaymentTermsLine.TESTFIELD("Due Date Calculation");
            PaymentTermsLine.TESTFIELD("Due Date");
            PaymentTermsLine.TESTFIELD("Calculation Value");
            PaymentTermsLine.TESTFIELD("Base Amount");
            PaymentTermsLine.TESTFIELD(Amount);
            IF PaymentTermsLine."Due Date" < DueDate THEN
              ERROR(Text001A,Job.FIELDCAPTION("No."),Job."No.");
            DueDate := PaymentTermsLine."Due Date";
            IF i = 0 THEN BEGIN
              Job.VALIDATE("Payment Terms Code",PaymentTermsLine."Payment Terms Code");
              i += 1;
            END;
            Amount += PaymentTermsLine.Amount;
          UNTIL PaymentTermsLine.NEXT = 0;
          Job.CALCFIELDS("Project Amount");
          IF Amount <> Job."Project Amount" THEN
            ERROR(Text002A,Job.FIELDCAPTION("No."),Job."No.");
          PaymentTermsLine.MODIFYALL(Status,PaymentTermsLine."Workflow Approval Status"::Released);
          Job.MODIFY;
        END;
        */

    end;

    local procedure ReopenJobPaymentTerms(var Job: Record Job)
    var
        PaymentTermsLine: Record "Archive Applicable Charges";
    begin
        /*
        PaymentTermsLine.SETRANGE("Table ID",DATABASE::Job);
        //PaymentTermsLine.SETRANGE("Document Type",Job."Document Type");
        PaymentTermsLine.SETRANGE("Document No.",Job."No.");
        PaymentTermsLine.SETRANGE("Doc. No. Occurrence",Job."Doc. No. Occurrence");
        PaymentTermsLine.SETRANGE("Version No.",0);
        PaymentTermsLine.SETRANGE("Transaction Type",PaymentTermsLine."Transaction Type"::Job);
        PaymentTermsLine.MODIFYALL(Status,PaymentTermsLine."Workflow Approval Status"::Open);
        */

    end;

    local procedure DeleteJobPaymentTerms(var Job: Record Job)
    var
        PaymentTermsLine: Record "Archive Applicable Charges";
    begin
        /*
        PaymentTermsLine.SETRANGE("Table ID",DATABASE::Job);
        //PaymentTermsLine.SETRANGE("Document Type",Job."Document Type");
        PaymentTermsLine.SETRANGE("Document No.",Job."No.");
        PaymentTermsLine.SETRANGE("Doc. No. Occurrence",Job."Doc. No. Occurrence");
        PaymentTermsLine.SETRANGE("Version No.",0);
        PaymentTermsLine.SETRANGE("Transaction Type",PaymentTermsLine."Transaction Type"::Job);
        PaymentTermsLine.DELETEALL;
        */

    end;
}

