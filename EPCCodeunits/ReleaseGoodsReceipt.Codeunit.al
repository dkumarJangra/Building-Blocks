codeunit 97756 "Release Goods Receipt"
{
    TableNo = "GRN Header";

    trigger OnRun()
    var
        GoodsReceiptLine: Record "GRN Line";
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
        OnBeforeReleasePurchaseReceiptDoc(Rec);
        Rec.OnCheckPurchaseReleaseRestrictions;

        //TESTFIELD("Buy-from Vendor No.");

        GoodsReceiptLine.SETRANGE("Document Type", Rec."Document Type");
        GoodsReceiptLine.SETRANGE("GRN No.", Rec."GRN No.");
        GoodsReceiptLine.SETFILTER(Type, '>0');
        GoodsReceiptLine.SETFILTER("Accepted Qty", '<>0');
        IF NOT GoodsReceiptLine.FIND('-') THEN
            ERROR(Text001, Rec."Document Type", Rec."GRN No.");

        InvtSetup.GET;
        IF InvtSetup."Location Mandatory" THEN BEGIN
            GoodsReceiptLine.SETRANGE(Type, GoodsReceiptLine.Type::Item);
            IF GoodsReceiptLine.FIND('-') THEN
                REPEAT
                    //IF NOT PurchIndentLine.IsServiceItem THEN
                    GoodsReceiptLine.TESTFIELD("Location Code");
                UNTIL GoodsReceiptLine.NEXT = 0;
            GoodsReceiptLine.SETFILTER(Type, '>0');
        END;

        //PurchIndentLine.SETRANGE("Drop Shipment",FALSE);
        //NotOnlyDropShipment := PurchIndentLine.FIND('-');
        GoodsReceiptLine.RESET;

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

        GoodsReceiptLine.SETRANGE("Document Type", Rec."Document Type");
        GoodsReceiptLine.SETRANGE("GRN No.", Rec."GRN No.");
        GoodsReceiptLine.MODIFYALL("Workflow Approval Status", Rec."Workflow Approval Status"::Released);

        //MODIFY(TRUE);
        Rec.MODIFY;

        //IF NotOnlyDropShipment THEN
        //  IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
        //    WhsePurchRelease.Release(Rec);

        OnAfterReleasePurchaseReceiptDoc(Rec);
    end;

    var
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2.';
        PurchSetup: Record "Purchases & Payables Setup";
        InvtSetup: Record "Inventory Setup";
        WhsePurchRelease: Codeunit "Whse.-Purch. Release";
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        Text005: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';


    procedure Reopen(var GoodsReceiptHeader: Record "GRN Header")
    var
        PurchIndentLine: Record "Purchase Request Line";
    begin
        OnBeforeReopenPurchaseReceiptDoc(GoodsReceiptHeader);

        IF GoodsReceiptHeader."Workflow Approval Status" = GoodsReceiptHeader."Workflow Approval Status"::Open THEN
            EXIT;
        //IF "Document Type" IN ["Document Type"::Indent] THEN
        //  WhsePurchRelease.Reopen(GoodsReceiptHeader);
        GoodsReceiptHeader."Workflow Approval Status" := GoodsReceiptHeader."Workflow Approval Status"::Open;

        PurchIndentLine.SETRANGE("Document Type", GoodsReceiptHeader."Document Type");
        PurchIndentLine.SETRANGE("Document No.", GoodsReceiptHeader."GRN No.");
        PurchIndentLine.MODIFYALL("Workflow Approval Status", GoodsReceiptHeader."Workflow Approval Status"::Open);

        GoodsReceiptHeader.MODIFY(TRUE);

        OnAfterReopenPurchaseReceiptDoc(GoodsReceiptHeader);
    end;


    procedure PerformManualRelease(var GoodsReceiptHeader: Record "GRN Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalsMgmt: Codeunit MyCodeunit;// 1535;
    begin
        //WITH GoodsReceiptHeader DO
        //IF ("Document Type" = "Document Type"::Indent) AND PrepaymentMgt.TestPurchasePayment(GoodsReceiptHeader) THEN BEGIN
        //  IF "Workflow Approval Status" <> "Workflow Approval Status"::"Pending Prepayment" THEN BEGIN
        //    "Workflow Approval Status" := "Workflow Approval Status"::"Pending Prepayment";
        //    MODIFY;
        //    COMMIT;
        //  END;
        //  ERROR(STRSUBSTNO(Text005,"Document Type","No."));
        //END;

        IF ApprovalsMgmt.IsPurchaseReceiptApprovalsWorkflowEnabled(GoodsReceiptHeader) AND (GoodsReceiptHeader."Workflow Approval Status" = GoodsReceiptHeader."Workflow Approval Status"::Open) THEN
            ERROR(Text002);

        CODEUNIT.RUN(CODEUNIT::"Release Goods Receipt", GoodsReceiptHeader);
    end;


    procedure PerformManualReopen(var GoodsReceiptHeader: Record "GRN Header")
    begin
        IF GoodsReceiptHeader."Workflow Approval Status" = GoodsReceiptHeader."Workflow Approval Status"::"Pending Approval" THEN
            ERROR(Text003);

        Reopen(GoodsReceiptHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReleasePurchaseReceiptDoc(var GoodsReceiptHeader: Record "GRN Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleasePurchaseReceiptDoc(var GoodsReceiptHeader: Record "GRN Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenPurchaseReceiptDoc(var GoodsReceiptHeader: Record "GRN Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReopenPurchaseReceiptDoc(var GoodsReceiptHeader: Record "GRN Header")
    begin
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::97732, 'OnBeforeReleasePurchaseReceiptDoc', '', false, false)]
    // local procedure PerformOnBeforeReleasePurchaseReceiptDoc(var GoodsReceiptHeader: Record 97731)
    // begin
    //     GoodsReceiptHeader.CheckBeforeRelease;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::97732, 'OnAfterReleasePurchaseReceiptDoc', '', false, false)]
    // local procedure PerformOnAfterReleasePurchaseReceiptDoc(var GoodsReceiptHeader: Record 97731)
    // begin
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::97732, 'OnBeforeReopenPurchaseReceiptDoc', '', false, false)]
    // local procedure PerformOnBeforeReopenPurchaseReceiptDoc(var GoodsReceiptHeader: Record 97731)
    // begin
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::97732, 'OnAfterReopenPurchaseReceiptDoc', '', false, false)]
    // local procedure PerformOnAfterReopenPurchaseReceiptDoc(var GoodsReceiptHeader: Record 97731)
    // begin
    // end;
}

