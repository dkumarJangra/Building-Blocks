codeunit 70000 "BBG Table Event Mgnt."
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine_CustLedgerEntry(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    Begin
        //ALLEAS03  >>
        CustLedgerEntry."BBG App. No. / Order Ref No." := GenJournalLine."Order Ref No.";
        CustLedgerEntry."BBG Milestone Code" := GenJournalLine."Milestone Code";
        CustLedgerEntry."BBG Ref Document Type" := GenJournalLine."Ref Document Type";
        CustLedgerEntry."BBG Tranasaction Type" := GenJournalLine."Tranasaction Type"; //BBG1.00 110815
        CustLedgerEntry."BBG Posting Type" := GenJournalLine."Posting Type";
        //ALLEAS02 >>
        // Passing Narration //GKG START
        CustLedgerEntry."BBG Narration" := GenJournalLine.Narration;
        CustLedgerEntry."BBG Month" := DATE2DMY(GenJournalLine."Posting Date", 2);
        CustLedgerEntry."BBG Year" := DATE2DMY(GenJournalLine."Posting Date", 3);
        IF GenJournalLine."BBG Cheque No." = '' then
            CustLedgerEntry."BBG Cheque No." := GenJournalLine."Cheque No."
        Else
            CustLedgerEntry."BBG Cheque No." := GenJournalLine."BBG Cheque No.";
        CustLedgerEntry."BBG Cheque Date" := GenJournalLine."Cheque Date";
        CustLedgerEntry."BBG User Branch Code_1" := GenJournalLine."Project Code";
        //GKG STOP
        // ALLEAA 141209
        CustLedgerEntry."BBG Sales Order No." := GenJournalLine."Sales Order No.";
        CustLedgerEntry."BBG Project Unit No." := GenJournalLine."Project Unit No.";
        CustLedgerEntry."BBG Reason" := GenJournalLine.Reason;
        // ALLEAA 141209
        CustLedgerEntry."BBG User Branch Code" := GenJournalLine."Branch Code"; //ALLETDK141112
        CustLedgerEntry."BBG Payment Mode" := GenJournalLine."Payment Mode"; //ALLEDK 010313
    End;


    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine_VendorLedgerEntry(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        Conforder: Record "Confirmed Order";
        AssHierarcy: Record "Associate Hierarcy with App.";
        RecRank: Record Rank;
        RegionCodemaster: Record "Rank Code Master";
    Begin
        //ALLEAS02  <<
        VendorLedgerEntry."Order Ref No." := GenJournalLine."Order Ref No.";
        VendorLedgerEntry."Milestone Code" := GenJournalLine."Milestone Code";
        VendorLedgerEntry."Ref Document Type" := GenJournalLine."Ref Document Type";
        VendorLedgerEntry."Vendor Invoice Date" := GenJournalLine."Vendor Invoice Date";
        VendorLedgerEntry."Posting Type" := GenJournalLine."Posting Type";
        VendorLedgerEntry."Provisional Bill" := GenJournalLine."Provisional Bill";
        VendorLedgerEntry.Month := DATE2DMY(GenJournalLine."Posting Date", 2);
        VendorLedgerEntry.Year := DATE2DMY(GenJournalLine."Posting Date", 3);
        IF GenJournalLine."BBG Cheque No." = '' Then
            VendorLedgerEntry."Cheque No." := GenJournalLine."Cheque No."
        Else
            VendorLedgerEntry."Cheque No." := GenJournalLine."BBG Cheque No.";
        VendorLedgerEntry."Cheque Date" := GenJournalLine."Cheque Date";
        VendorLedgerEntry."Received Invoice Amount" := GenJournalLine."Received Invoice Amount";
        VendorLedgerEntry."ARM Invoice" := GenJournalLine."ARM Invoice";  //BBG1.00 280513
        VendorLedgerEntry."IC Land Purchase" := GenJournalLine."IC Land Purchase"; //BBG 280417
        VendorLedgerEntry."Application No." := GenJournalLine."Application No.";
        VendorLedgerEntry."Club 9 Entry" := GenJournalLine."Club 9 Entry";  //260225
        VendorLedgerEntry."Credit Memo from ARM" := GenJournalLine."TA/Comm Credit Memo";
        //ALLEAS02  >>
        VendorLedgerEntry."User Branch Code" := GenJournalLine."Branch Code"; //ALLETDK141112
        VendorLedgerEntry."Payment Mode" := GenJournalLine."Payment Mode"; //ALLEDK 010313
        VendorLedgerEntry."Tranasaction Type" := GenJournalLine."Tranasaction Type"; //110815
        VendorLedgerEntry."Ref. External Doc. No." := GenJournalLine."Ref. External Doc. No."; //Add new 
        //Code Added Start 01072025
        AssHierarcy.RESET;
        AssHierarcy.SetRange("Application Code", VendorLedgerEntry."Application No.");
        AssHierarcy.SetRange("Associate Code", VendorLedgerEntry."Vendor No.");
        //AssHierarcy.SetRange(Status, AssHierarcy.Status::Active);
        IF AssHierarcy.FindLast() THEN begin
            VendorLedgerEntry."Rank Code" := AssHierarcy."Rank Code";
            RecRank.RESET;
            If RecRank.GET(VendorLedgerEntry."Rank Code") then
                VendorLedgerEntry."Rank Description" := RecRank.Description;

            VendorLedgerEntry."Region Code" := AssHierarcy."Region/Rank Code";
            RegionCodemaster.RESET;
            IF RegionCodemaster.GET(VendorLedgerEntry."Region Code") then
                VendorLedgerEntry."Region Code Description" := RegionCodemaster.Description;
        end;
        //Code Added End 01072025
    End;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeLookupAppliesToDocNo', '', false, false)]
    local procedure OnBeforeLookupAppliesToDocNo_SalesHeader(var CustLedgEntry: Record "Cust. Ledger Entry"; var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    Begin
        //ALLE PS Added code for Filtering according to  Shorcut dimension code 1
        IF SalesHeader."Shortcut Dimension 1 Code" <> '' THEN
            CustLedgEntry.SETRANGE("Global Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
        //ALLE PS ENds
    End;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateJobContractEntryNo', '', false, false)]
    local procedure OnBeforeValidateJobContractEntryNo_SalesLine(sender: Record "Sales Line"; var IsHandled: Boolean; xSalesLine: Record "Sales Line")
    Begin
        IsHandled := true;
    End;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure OnAfterGetNoSeriesCode_PurchaseHeader(PurchSetup: Record "Purchases & Payables Setup"; var NoSeriesCode: Code[20]; var PurchHeader: Record "Purchase Header")
    var
        DocTypSetup: Record "Document Type Setup";
    Begin
        //ALLESR
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::Order Then begin
            IF NOT PurchHeader.Subcontracting THEN
                //JPL03 START
                BEGIN
                IF PurchHeader."Order Type" = PurchHeader."Order Type"::"Service Order" THEN
                    NoSeriesCode := PurchSetup."Service Order Nos.";
                //ALLESR
                DocTypSetup.GET(DocTypSetup."Document Type"::"Purchase Order", PurchHeader."Sub Document Type");
                DocTypSetup.TESTFIELD(DocTypSetup."PO No. Series");
                NoSeriesCode := DocTypSetup."PO No. Series";
                //EXIT(PurchSetup."Order Nos.")//commented JPL03
                //JPL03 STOP
            End
            ELSE
                NoSeriesCode := PurchSetup."Subcontracting Order Nos.";
        end;
    End;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnValidateBuyFromVendorNoBeforeRecreateLines', '', false, false)]
    local procedure OnValidateBuyFromVendorNoBeforeRecreateLines_PurchaseHeader(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor; CallingFieldNo: Integer)
    Begin
        //VALIDATE("Location Code",UserSetupMgt.GetLocation(1,Vend."Location Code","Responsibility Center"));
        PurchaseHeader.VALIDATE("Location Code", PurchaseHeader."Responsibility Center");
        PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", PurchaseHeader."Responsibility Center");
        PurchaseHeader.VALIDATE("Job No.", PurchaseHeader."Responsibility Center");
    End;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeLookupAppliesToDocNo', '', false, false)]
    local procedure OnBeforeLookupAppliesToDocNo_PurchaseHeader(var IsHandled: Boolean; var PurchaseHeader: Record "Purchase Header"; var VendorLedgEntry: Record "Vendor Ledger Entry")
    Begin
        //ALLE PS Added code for Filtering according to  Shorcut dimension code 1
        IF PurchaseHeader."Shortcut Dimension 1 Code" <> '' THEN
            VendorLedgEntry.SETRANGE("Global Dimension 1 Code", PurchaseHeader."Shortcut Dimension 1 Code");
        //ALLE PS ENds
    End;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCopyAddressInfoFromOrderAddress', '', false, false)]
    local procedure OnAfterCopyAddressInfoFromOrderAddress_PurchaseHeader(sender: Record "Purchase Header"; var OrderAddress: Record "Order Address"; var PurchHeader: Record "Purchase Header")
    Begin
        PurchHeader.State := OrderAddress."State Code"; // ALLEPG 160911
    End;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnValidateOrderAddressCodeOnBeforeCopyBuyFromVendorAddressFieldsFromVendor', '', false, false)]
    local procedure OnValidateOrderAddressCodeOnBeforeCopyBuyFromVendorAddressFieldsFromVendor_PurchaseHeader(var IsHandled: Boolean; var PurchaseHeader: Record "Purchase Header"; Vend: Record Vendor)
    Begin
        PurchaseHeader.State := Vend."State Code";  //1.1
    End;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues_PurchaseLine(Item: Record Item; var PurchLine: Record "Purchase Line")
    Begin
        PurchLine."Description 3" := Item."Description 3"; //dds
        PurchLine."Description 4" := Item."Description 4"; //dds
    End;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignFixedAssetValues', '', false, false)]
    local procedure OnAfterAssignFixedAssetValues_PurchaseLine(FixedAsset: Record "Fixed Asset"; var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    var
        PurLineRec: Record "Purchase Line";
    Begin
        //alleabFAcheck for FA Check in other Line
        FixedAsset.TESTFIELD("FA Opening", FALSE);
        PurLineRec.RESET;
        PurLineRec.SETRANGE("No.", PurchLine."No.");
        PurLineRec.SETRANGE("Document Type", PurchLine."Document Type");
        IF PurLineRec.FINDFIRST THEN
            REPEAT
                IF PurLineRec."Document No." <> PurchLine."Document No." THEN BEGIN
                    //         ERROR('FA No. %1 already exists in %2',"No.", PurLineRec."Document No."); ALLE 151015 code comment
                END;
            UNTIL PurLineRec.NEXT = 0;
        //alleab
        PurchLine."FA Code" := FixedAsset."FA Code";//ALLe PS
        PurchLine."Check FA item" := TRUE; //ALLEAB009
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetVendorBalAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetVendorBalAccount_GenJournalLine(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; CallingFieldNo: Integer)
    Begin
        GenJournalLine.CheckLandVendor(Vendor);  //BBG2.0
    End;



    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnLookUpAppliesToDocVendOnAfterUpdateDocumentTypeAndAppliesTo', '', false, false)]
    local procedure OnLookUpAppliesToDocVendOnAfterUpdateDocumentTypeAndAppliesTo_GenJournalLine(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
    Begin
        //DDSALLE23Jan2008
        GenJournalLine."Shortcut Dimension 1 Code" := VendorLedgerEntry."Global Dimension 1 Code";
        GenJournalLine.RegDimName := '';
        GLSetup.GET;
        IF GenJournalLine."Shortcut Dimension 1 Code" <> '' THEN BEGIN
            IF DimValue.GET(GLSetup."Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 1 Code") THEN
                GenJournalLine.RegDimName := DimValue.Name;
        END;
        //DDSALLE23Jan2008
    End;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnInsertInvLineFromRcptLineOnBeforeCheckPurchLineReceiptNo', '', false, false)]
    local procedure OnInsertInvLineFromRcptLineOnBeforeCheckPurchLineReceiptNo_PurchRcptLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchLine: Record "Purchase Line"; var TempPurchLine: Record "Purchase Line")
    var

        PurchInvHeader: Record "Purchase Header";
        RctHdr: Record "Purch. Rcpt. Header";
        Purchheader: Record "Purchase Header";
    begin
        IF PurchInvHeader."No." <> TempPurchLine."Document No." THEN
            PurchInvHeader.GET(TempPurchLine."Document Type", TempPurchLine."Document No.");
        //JPL31 START
        RctHdr.GET(PurchRcptLine."Document No.");
        PurchInvHeader.VALIDATE("Document Date", RctHdr."Document Date");
        //PurchInvHeader.MODIFY;
        //JPL31 STOP
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnAfterCopyFromPurchRcptLine', '', false, false)]
    local procedure OnAfterCopyFromPurchRcptLine_PurchRcptLine(PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchaseLine: Record "Purchase Line"; var TempPurchLine: Record "Purchase Line")
    var
        PurchInvLine: Record "Purch. Inv. Line";
    Begin
        //GKGR001
        PurchaseLine."GRN No." := PurchRcptLine."Document No.";
        PurchaseLine."GRN Line No." := PurchRcptLine."Line No.";
        PurchaseLine."PO No." := PurchRcptLine."Order No.";
        PurchaseLine."PO Line No." := PurchRcptLine."Order Line No.";
        //GKGR001

        // ALLEPG 290109 Start
        PurchInvLine.RESET;
        PurchInvLine.SETRANGE("Receipt No.", PurchRcptLine."Document No.");
        PurchInvLine.SETRANGE("Receipt Line No.", PurchRcptLine."Line No.");
        IF PurchInvLine.FINDFIRST THEN
            PurchaseLine."Part Rate" := TRUE;
        // ALLEPG 290109 End


        //ALLEAA
        PurchaseLine."Job No." := PurchRcptLine."Job No.";
        PurchaseLine."Job Task No." := PurchRcptLine."Job Task No.";
        //ALLEAA

    End;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnAfterInitFromPurchLine', '', false, false)]
    local procedure OnAfterInitFromPurchLine_PurchRcptLine(PurchLine: Record "Purchase Line"; PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    Begin
        //ALLEDDS26Mar2008-Start
        PurchRcptLine."Challan No" := PurchRcptHeader."Challan No";
        PurchRcptLine."Challan Date" := PurchRcptHeader."Challan Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Journal Line", 'OnBeforeValidateJobTaskNo', '', false, false)]
    local procedure OnBeforeValidateJobTaskNo_PurchRcptLine(var IsHandled: Boolean; var JobJournalLine: Record "Job Journal Line"; var xJobJournalLine: Record "Job Journal Line")
    var
        JobTask: Record "Job Task";
    Begin
        IsHandled := true;
        if (JobJournalLine."Job Task No." = '') or ((JobJournalLine."Job Task No." <> xJobJournalLine."Job Task No.") and (xJobJournalLine."Job Task No." <> '')) then begin
            JobJournalLine.Validate("No.", '');
            IF JobJournalLine."Job Task No." = '' THEN   //ALLETG RIL0100 16-06-2011
                exit;
        end;

        JobJournalLine.TestField("Job No.");
        JobTask.Get(JobJournalLine."Job No.", JobJournalLine."Job Task No.");
        JobTask.TestField("Job Task Type", JobTask."Job Task Type"::Posting);
        //ALLETG RIL0100 16-06-2011: START>>
        JobJournalLine."BOQ Code" := JobTask."BOQ Code";
        JobJournalLine."Entry No." := JobTask."Entry No.";
        JobJournalLine."Unit of Measure Code" := JobTask."BOQ Unit Of Measure";
        //ALLETG RIL0100 16-06-2011: END<<

        JobJournalLine.UpdateDimensions();
    End;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyFromGenJnlLine_PurchRcptLine(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    var
        GLSetup: Record "General Ledger Setup";
    Begin
        BankAccountLedgerEntry."Application No." := GenJournalLine."Order Ref No.";//ALLETDK
        BankAccountLedgerEntry."Receipt Line No." := GenJournalLine."Receipt Line No."; //ALLEDK 111116
        BankAccountLedgerEntry.Bounced := GenJournalLine.Bounced;//ALLETDK
        //BankAccountLedgerEntry."Location Code" := GenJournalLine."Location Code";
        GLSetup.GET;
        IF GLSetup."Activate Cheque No." THEN BEGIN
            BankAccountLedgerEntry.Month := DATE2DMY(GenJournalLine."Posting Date", 2);
            BankAccountLedgerEntry.Year := DATE2DMY(GenJournalLine."Posting Date", 3);
            BankAccountLedgerEntry."Cheque No." := CopyStr(GenJournalLine."Cheque No.", 1, 10);
            BankAccountLedgerEntry."Cheque No.1" := GenJournalLine."BBG Cheque No.";
            BankAccountLedgerEntry."Cheque Date" := GenJournalLine."Cheque Date";
        END;
        BankAccountLedgerEntry.Narration := GenJournalLine.Narration;
        BankAccountLedgerEntry."User Branch Code" := GenJournalLine."Branch Code";
        //ALLEMSN01 >>
    End;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnBeforeGetNoSeriesCode', '', false, false)]
    local procedure OnBeforeGetNoSeriesCode_TransferHeader(InventorySetup: Record "Inventory Setup"; var IsHandled: Boolean; var NoSeriesCode: Code[20]; var TransferHeader: Record "Transfer Header")
    var
    Begin
        //RAHEE1.00 010512
        IF TransferHeader."Transfer FG" THEN Begin
            InventorySetup.TestField("Material Transfer to Site Nos.");
            NoSeriesCode := InventorySetup."Material Transfer to Site Nos.";
            IsHandled := true;
        End;
    End;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues_TransferLine(Item: Record Item; TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line")
    var
        InvSetup: Record "Inventory Setup";
        RecItem: Record Item;
        AvailInventory: Decimal;
        RecTransOrder: Record "Transfer Header";
        Text50000: Label 'Item %1 is not in Inventory for Location %2';
    Begin
        //NDALLE 280508

        //IF NOT TransHeader."Transfer FG" THEN BEGIN  //RAHEE1.00
        RecTransOrder.RESET;
        RecTransOrder.SETRANGE(RecTransOrder."No.", TransferLine."Document No.");
        IF RecTransOrder.FINDFIRST THEN BEGIN
            RecItem.RESET;
            RecItem.SETRANGE(RecItem."No.", TransferLine."Item No.");
            RecItem.SETFILTER(RecItem."Location Filter", RecTransOrder."Transfer-from Code");
            IF RecItem.FINDFIRST THEN BEGIN
                RecItem.CALCFIELDS(Inventory);
                AvailInventory := RecItem.Inventory;
                IF AvailInventory = 0 THEN
                    ERROR(Text50000, TransferLine."Item No.", RecTransOrder."Transfer-from Code");
            END;
            TransferLine.VALIDATE("Shortcut Dimension 1 Code", RecTransOrder."Shortcut Dimension 1 Code");  //RAHEE1.00
        END;
        //END;  //RAHEE1.00
        //NDALLE 280508
    End;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromPurchHeader_GenJournalLine(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    Begin
        GenJournalLine."Branch Code" := PurchaseHeader."User Branch";  //ALLEDK 180113
        GenJournalLine."ARM Invoice" := PurchaseHeader.CommissionVoucher; //BBG1.00 280513
        GenJournalLine."IC Land Purchase" := PurchaseHeader."IC Land Purchase"; //BBG 280417
        IF PurchaseHeader."Associate Posting Type" <> PurchaseHeader."Associate Posting Type"::" " THEN
            GenJournalLine."Posting Type" := PurchaseHeader."Associate Posting Type"; //BBG1.00 030513
        GenJournalLine."Application No." := PurchaseHeader."Application No.";
        GenJournalLine."Special Incentive Bonanza" := PurchaseHeader."Special Incentive Bonanza";  //110924 Code added
                                                                                                   //ALLE-SR-081107 >>
        GenJournalLine."Posting Type" := GenJournalLine."Posting Type"::Running;
        GenJournalLine."Ref. External Doc. No." := PurchaseHeader."Ref. External Doc. No."; //Added new code 15122025

        //ALLETDK--BEGIN 081212
        IF (PurchaseHeader."Bal. Account Type" = PurchaseHeader."Bal. Account Type"::"Bank Account") AND (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) THEN BEGIN
            //GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";
            GenJournalLine."Cheque No." := PurchaseHeader."Cheque No.";
            GenJournalLine."Cheque Date" := PurchaseHeader."Cheque Date";
        END;
        //ALLETDK--END 081212
        IF PurchaseHeader."Associate Posting Type" <> PurchaseHeader."Associate Posting Type"::" " THEN
            GenJournalLine."Posting Type" := PurchaseHeader."Associate Posting Type"; //BBG1.00 030513

    end;


    var
        myInt: Integer;
}