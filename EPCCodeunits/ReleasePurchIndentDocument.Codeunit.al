codeunit 97754 "Release Purch. Indent Document"
{
    TableNo = "Purchase Request Header";

    trigger OnRun()
    var
        PurchIndentLine: Record "Purchase Request Line";
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        NotOnlyDropShipment: Boolean;
        PostingDate: Date;
        PrintPostedDocuments: Boolean;
    begin
        IF Rec."Workflow Approval Status" = Rec."Workflow Approval Status"::Released THEN
            EXIT;
        Rec.CheckBeforeRelease;
        OnBeforeReleasePurchaseDoc(Rec);
        Rec.OnCheckPurchaseReleaseRestrictions;

        //TESTFIELD("Buy-from Vendor No.");

        PurchIndentLine.SETRANGE("Document Type", Rec."Document Type");
        PurchIndentLine.SETRANGE("Document No.", Rec."Document No.");
        PurchIndentLine.SETFILTER(Type, '>0');
        PurchIndentLine.SETFILTER("Indented Quantity", '<>0');
        IF NOT PurchIndentLine.FIND('-') THEN
            ERROR(Text001, Rec."Document Type", Rec."Document No.");

        InvtSetup.GET;
        IF InvtSetup."Location Mandatory" THEN BEGIN
            PurchIndentLine.SETRANGE(Type, PurchIndentLine.Type::Item);
            IF PurchIndentLine.FIND('-') THEN
                REPEAT
                    //IF NOT PurchIndentLine.IsServiceItem THEN
                    PurchIndentLine.TESTFIELD("Location code");
                UNTIL PurchIndentLine.NEXT = 0;
            PurchIndentLine.SETFILTER(Type, '>0');
        END;

        //PurchIndentLine.SETRANGE("Drop Shipment",FALSE);
        //NotOnlyDropShipment := PurchIndentLine.FIND('-');
        PurchIndentLine.RESET;

        PurchSetup.GET;
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

        //PurchIndentLine.SetPurchIndentHeader(Rec);
        //PurchIndentLine.CalcVATAmountLines(0,Rec,PurchIndentLine,TempVATAmountLine0);
        //PurchIndentLine.CalcVATAmountLines(1,Rec,PurchIndentLine,TempVATAmountLine1);
        //PurchIndentLine.UpdateVATOnLines(0,Rec,PurchIndentLine,TempVATAmountLine0);
        //PurchIndentLine.UpdateVATOnLines(1,Rec,PurchIndentLine,TempVATAmountLine1);

        PurchIndentLine.SETRANGE("Document Type", Rec."Document Type");
        PurchIndentLine.SETRANGE("Document No.", Rec."Document No.");
        PurchIndentLine.MODIFYALL("Workflow Approval Status", Rec."Workflow Approval Status"::Released);

        //MODIFY(TRUE);
        Rec.MODIFY;

        //IF NotOnlyDropShipment THEN
        //  IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
        //    WhsePurchRelease.Release(Rec);

        OnAfterReleasePurchaseDoc(Rec);
    end;

    var
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2.';
        PurchSetup: Record "Purchases & Payables Setup";
        InvtSetup: Record "Inventory Setup";
        WhsePurchRelease: Codeunit "Whse.-Purch. Release";
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        Text005: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';


    procedure Reopen(var PurchIndentHeader: Record "Purchase Request Header")
    var
        PurchIndentLine: Record "Purchase Request Line";
    begin
        OnBeforeReopenPurchaseDoc(PurchIndentHeader);

        IF PurchIndentHeader."Workflow Approval Status" = PurchIndentHeader."Workflow Approval Status"::Open THEN
            EXIT;
        //IF "Document Type" IN ["Document Type"::Indent] THEN
        //  WhsePurchRelease.Reopen(PurchIndentHeader);
        PurchIndentHeader."Workflow Approval Status" := PurchIndentHeader."Workflow Approval Status"::Open;

        PurchIndentLine.SETRANGE("Document Type", PurchIndentHeader."Document Type");
        PurchIndentLine.SETRANGE("Document No.", PurchIndentHeader."Document No.");
        PurchIndentLine.MODIFYALL("Workflow Approval Status", PurchIndentHeader."Workflow Approval Status"::Open);

        PurchIndentHeader.MODIFY(TRUE);

        OnAfterReopenPurchaseDoc(PurchIndentHeader);
    end;


    procedure PerformManualRelease(var PurchIndentHeader: Record "Purchase Request Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalsMgmt: Codeunit MyCodeunit;
    begin
        //WITH PurchIndentHeader DO
        //IF ("Document Type" = "Document Type"::Indent) AND PrepaymentMgt.TestPurchasePayment(PurchIndentHeader) THEN BEGIN
        //  IF "Workflow Approval Status" <> "Workflow Approval Status"::"Pending Prepayment" THEN BEGIN
        //    "Workflow Approval Status" := "Workflow Approval Status"::"Pending Prepayment";
        //    MODIFY;
        //    COMMIT;
        //  END;
        //  ERROR(STRSUBSTNO(Text005,"Document Type","No."));
        //END;

        IF ApprovalsMgmt.IsPurchaseIndentApprovalsWorkflowEnabled(PurchIndentHeader) AND (PurchIndentHeader."Workflow Approval Status" = PurchIndentHeader."Workflow Approval Status"::Open) THEN
            ERROR(Text002);

        CODEUNIT.RUN(CODEUNIT::"Release Purch. Indent Document", PurchIndentHeader);
    end;


    procedure PerformManualReopen(var PurchIndentHeader: Record "Purchase Request Header")
    begin
        IF PurchIndentHeader."Workflow Approval Status" = PurchIndentHeader."Workflow Approval Status"::"Pending Approval" THEN
            ERROR(Text003);

        Reopen(PurchIndentHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Request Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Request Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenPurchaseDoc(var PurchaseHeader: Record "Purchase Request Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReopenPurchaseDoc(var PurchaseHeader: Record "Purchase Request Header")
    begin
    end;

    // [EventSubscriber(ObjectType::Codeunit, 97730, 'OnBeforeReleasePurchaseDoc', '', false, false)]
    // local procedure PerformOnBeforeReleasePurchaseDoc(var PurchaseHeader: Record 97728)
    // begin
    //     PurchaseHeader.CheckBeforeRelease;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 97730, 'OnAfterReleasePurchaseDoc', '', false, false)]
    // local procedure PerformOnAfterReleasePurchaseDoc(var PurchaseHeader: Record 97728)
    // begin
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 97730, 'OnBeforeReopenPurchaseDoc', '', false, false)]
    // local procedure PerformOnBeforeReopenPurchaseDoc(var PurchaseHeader: Record 97728)
    // begin
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 97730, 'OnAfterReopenPurchaseDoc', '', false, false)]
    // local procedure PerformOnAfterReopenPurchaseDoc(var PurchaseHeader: Record 97728)
    // begin
    // end;
}

