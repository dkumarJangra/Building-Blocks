codeunit 97753 "Document Managment"
{

    trigger OnRun()
    begin
    end;

    var
        TxtDocumentType: Text;
        WfTransactionType: Option " ",Job,Indent,Enquiry,Purchase,"Gate Entry","Purchase Receipt","Gate Pass",Sales,Service,Transfer,QC,"General Journal","Item Journal","Award Note","Note Sheet";
        WfDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        WfSubDocumentType: Option " ",FA,Regular,Direct,WorkOrder,Inward,Outward;
        WfTemplateName: Code[20];
        WfBatchName: Code[20];
        WfResponsibilityCentre: Code[10];
        UserSetupMgmt: Codeunit "User Setup Management";
        ResponsibilityCenter: Record "Responsibility Center";
        IndentHeader: Record "Purchase Request Header";
        IndentLine: Record "Purchase Request Line";
        PurchHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Text001: Label 'There is no appover for this document.';
        Text002: Label 'Please check there is already a Blank Document No. %1 with Initiator User ID %2.';
        Text003: Label 'Are you sure you want to create %1?';
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TransferHeader: Record "Transfer Header";
        TranferLine: Record "Transfer Line";
        GRNHeader: Record "GRN Header";
        GRNLine: Record "GRN Line";
        Job: Record Job;
        CallHeader: Record "FD Payment Schedule Posted";
        InspectionHeader: Record "Project Price Group Details";
        InspectionLine: Record "Applicable Charges";
        AwardNote: Record "Confirmed Order";
        NoteSheet: Record Documentation;


    procedure CheckWFDocumentTypeSetup(pTransactionType: Option " ",Job,Indent,Enquiry,Purchase,"Gate Entry","Purchase Receipt","Gate Pass",Sales,Service,Transfer,QC,"General Journal","Item Journal","Award Note","Note Sheet"; pDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; pSubDocumentType: Option " ",FA,Regular,Direct,WorkOrder,Inward,Outward; pTemplateName: Code[20]; pBatchName: Code[20]; pResponsibilityCentre: Code[10]; pAmendment: Boolean)
    var
        CompanyInformation: Record "Company Information";
        WorkflowDocTypeSetup: Record "Workflow Doc. Type Setup";
        WorkflowDocTypeInitiator: Record "Workflow Doc. Type Initiator";
        WorkflowDocTypeApprovers: Record "Workflow Doc. Type Approvers";
    begin
        //CompanyInformation.GET;
        //IF NOT CompanyInformation."WorkFlow Approval Managment On" THEN
        //  EXIT;

        //WorkflowDocTypeSetup.GET(pTransactionType,pDocumentType,pSubDocumentType);
        /*
        IF NOT WorkflowDocTypeSetup.Enabled THEN
          EXIT;
        */ //alle ansh
        WorkflowDocTypeInitiator.GET(pTransactionType, pDocumentType, pSubDocumentType, pTemplateName, pBatchName, USERID, pResponsibilityCentre, pAmendment);

        WorkflowDocTypeApprovers.RESET;
        WorkflowDocTypeApprovers.SETRANGE("Transaction Type", pTransactionType);
        WorkflowDocTypeApprovers.SETRANGE("Document Type", pDocumentType);
        WorkflowDocTypeApprovers.SETRANGE("Sub Document Type", pSubDocumentType);
        WorkflowDocTypeApprovers.SETRANGE("Template Name", pTemplateName);
        WorkflowDocTypeApprovers.SETRANGE("Batch Name", pBatchName);
        WorkflowDocTypeApprovers.SETRANGE("Initiator User ID", USERID);
        WorkflowDocTypeApprovers.SETRANGE("Responsibility Center", pResponsibilityCentre);
        WorkflowDocTypeApprovers.FINDFIRST;
        WorkflowDocTypeApprovers.TESTFIELD("Approver ID");

    end;


    procedure CheckCommentLineBeforeAmendment(pTransactionType: Option " ",Job,Indent,Enquiry,Purchase,"Gate Entry","Purchase Receipt","Gate Pass",Sales,Service,Transfer,QC,"General Journal","Item Journal"; pDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; pDocumentNo: Code[20])
    var
        PurchCommentLine: Record "Purch. Comment Line";
    begin
        PurchCommentLine.RESET;
        IF pTransactionType = pTransactionType::Purchase THEN
            IF pDocumentType = pDocumentType::Order THEN BEGIN
                PurchCommentLine.RESET;
                PurchCommentLine.SETRANGE("Document Type", pDocumentType);
                PurchCommentLine.SETRANGE("No.", pDocumentNo);
                PurchCommentLine.SETRANGE(Date, WORKDATE);
                PurchCommentLine.FINDFIRST;
            END;
    end;


    procedure IsDocumentInitiar(pCode: Code[50])
    begin
        IF pCode <> USERID THEN
            ERROR('Initiator User ID must be %1.', pCode);
    end;


    procedure GetAssignedUserID(TransactionType: Option; DocumentType: Option; SubDocumentType: Option; TemplateName: Code[10]; BatchName: Code[10]; InitiatorUserID: Code[50]; RespCenterCode: Code[10]; Amendment: Boolean): Code[50]
    var
        WorkflowDocTypeInitiator: Record "Workflow Doc. Type Initiator";
    begin
        //Transaction Type,Document Type,Sub Document Type,Template Name,Batch Name,Initiator User ID,Responsibility Center,Amendment
        // ,Job,Indent,Enquiry,Purchase,Gate Entry,Purchase Receipt,Gate Pass,Sales,Service,Transfer,QC,General Journal,Item Journal
        IF WorkflowDocTypeInitiator.GET(TransactionType, DocumentType, SubDocumentType, TemplateName, BatchName, InitiatorUserID, RespCenterCode, Amendment) THEN
            EXIT(WorkflowDocTypeInitiator."Posting User ID");
    end;


    procedure "---PurchaseIndent---"()
    begin
    end;


    procedure CreatePurchaseIndent(OpenPage: Boolean; var PIndentHeader: Record "Purchase Request Header")
    begin
        TxtDocumentType := 'Purchase Indent';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Indent, WfDocumentType::Order, WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        IndentHeader.RESET;
        IndentHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", "Workflow Approval Status");
        IndentHeader.SETRANGE("Document Type", IndentHeader."Document Type"::Indent);
        IndentHeader.SETRANGE("Workflow Sub Document Type", IndentHeader."Workflow Sub Document Type"::" ");
        IndentHeader.SETRANGE("Initiator User ID", USERID);
        IndentHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        IndentHeader.SETRANGE("Workflow Approval Status", IndentHeader."Workflow Approval Status"::Open);
        IF IndentHeader.FINDSET THEN BEGIN
            REPEAT
                IndentLine.RESET;
                IndentLine.SETRANGE("Document Type", IndentHeader."Document Type");
                IndentLine.SETRANGE("Document No.", IndentHeader."Document No.");
                IF NOT IndentLine.FINDFIRST THEN
                    ERROR(Text002, IndentHeader."Document No.", USERID);
            UNTIL IndentHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            IndentHeader.INIT;
            IndentHeader."Document Type" := IndentHeader."Document Type"::Indent;
            IndentHeader."Workflow Sub Document Type" := IndentHeader."Workflow Sub Document Type"::" ";
            IndentHeader."Document No." := '';
            IndentHeader.INSERT(TRUE);
            PIndentHeader := IndentHeader;
            IF OpenPage THEN
                OpenPurchaseIndent;
        END;
    end;


    procedure OpenPurchaseIndent()
    begin
        PAGE.RUN(PAGE::"Purchase Request", IndentHeader);
    end;

    local procedure "---FAIndent---"()
    begin
    end;


    procedure CreatePurchaseIndentFA(OpenPage: Boolean; var PIndentHeader: Record "Purchase Request Header")
    begin
        TxtDocumentType := 'Purchase Indent Fixed Asset';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Indent, WfDocumentType::Order, WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        IndentHeader.RESET;
        IndentHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", "Workflow Approval Status");
        IndentHeader.SETRANGE("Document Type", IndentHeader."Document Type"::Indent);
        IndentHeader.SETRANGE("Workflow Sub Document Type", IndentHeader."Workflow Sub Document Type"::FA);
        IndentHeader.SETRANGE("Initiator User ID", USERID);
        IndentHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        IndentHeader.SETRANGE("Workflow Approval Status", IndentHeader."Workflow Approval Status"::Open);
        IF IndentHeader.FINDSET THEN BEGIN
            REPEAT
                IndentLine.RESET;
                IndentLine.SETRANGE("Document Type", IndentHeader."Document Type");
                IndentLine.SETRANGE("Document No.", IndentHeader."Document No.");
                IF NOT IndentLine.FINDFIRST THEN
                    ERROR(Text002, IndentHeader."Document No.", USERID);
            UNTIL IndentHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            IndentHeader.INIT;
            IndentHeader."Document Type" := IndentHeader."Document Type"::Indent;
            IndentHeader."Workflow Sub Document Type" := IndentHeader."Workflow Sub Document Type"::FA;
            IndentHeader."Sub Document Type" := IndentHeader."Sub Document Type"::FA;
            IndentHeader."Document No." := '';
            IndentHeader.INSERT(TRUE);
            PIndentHeader := IndentHeader;
            IF OpenPage THEN
                OpenPurchaseIndentFA;
        END;
    end;


    procedure OpenPurchaseIndentFA()
    begin
        PAGE.RUN(PAGE::"FA Purchase Request Header", IndentHeader);
    end;


    procedure "---PurchaseQuote---"()
    begin
    end;


    procedure CreatePurchaseQuote(OpenPage: Boolean; var PPurchHeader: Record "Purchase Header")
    begin
        TxtDocumentType := 'Purchase Quotation';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Purchase, WfDocumentType::Quote, WfSubDocumentType::Regular, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Quote);
        PurchHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::Regular);
        PurchHeader.SETRANGE("Initiator User ID", USERID);
        PurchHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        PurchHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF PurchHeader.FINDSET THEN BEGIN
            REPEAT
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
                IF NOT PurchaseLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL PurchHeader.NEXT = 0;
        END;
        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::Quote;
            PurchHeader."Workflow Sub Document Type" := PurchHeader."Workflow Sub Document Type"::Regular;
            PurchHeader."No." := '';
            PurchHeader.INSERT(TRUE);
            PPurchHeader := PurchHeader;
            IF OpenPage THEN
                OpenPurchQuote;
        END;
    end;


    procedure CreatePurchaseQuoteService(OpenPage: Boolean; var PPurchHeader: Record "Purchase Header")
    begin
        TxtDocumentType := 'Purchase Quotation Service';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Purchase, WfDocumentType::Quote, WfSubDocumentType::WorkOrder, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Quote);
        PurchHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::WorkOrder);
        PurchHeader.SETRANGE("Initiator User ID", USERID);
        PurchHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        PurchHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF PurchHeader.FINDSET THEN BEGIN
            REPEAT
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
                IF NOT PurchaseLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL PurchHeader.NEXT = 0;
        END;
        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::Quote;
            PurchHeader."Workflow Sub Document Type" := PurchHeader."Workflow Sub Document Type"::WorkOrder;
            PurchHeader."No." := '';
            PurchHeader.INSERT(TRUE);
            PPurchHeader := PurchHeader;
            IF OpenPage THEN
                OpenPurchQuote;
        END;
    end;


    procedure OpenPurchQuote()
    begin
        PAGE.RUN(PAGE::"Purchase Quote", PurchHeader);
    end;


    procedure "---PurchaseOrder---"()
    begin
    end;


    procedure CreatePurchaseOrderRegular(OpenPage: Boolean; var PPurchHeader: Record "Purchase Header")
    begin
        TxtDocumentType := 'Regular Purchase Order';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Purchase, WfDocumentType::Order, WfSubDocumentType::Regular, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::Regular);
        PurchHeader.SETRANGE("Initiator User ID", USERID);
        PurchHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        PurchHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF PurchHeader.FINDSET THEN BEGIN
            REPEAT
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
                IF NOT PurchaseLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL PurchHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
            PurchHeader."Workflow Sub Document Type" := PurchHeader."Workflow Sub Document Type"::Regular;
            PurchHeader."No." := '';
            PPurchHeader.INSERT(TRUE);
            PurchHeader := PurchHeader;
            IF OpenPage THEN
                OpenPurchaseOrder;
        END;
    end;


    procedure CreatePurchaseOrderDirect(OpenPage: Boolean; var PPurchHeader: Record "Purchase Header")
    begin
        TxtDocumentType := 'Direct Purchase Order';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Purchase, WfDocumentType::Order, WfSubDocumentType::Direct, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::Direct);
        PurchHeader.SETRANGE("Initiator User ID", USERID);
        PurchHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        PurchHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF PurchHeader.FINDSET THEN BEGIN
            REPEAT
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
                IF NOT PurchaseLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL PurchHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
            PurchHeader."Workflow Sub Document Type" := PurchHeader."Workflow Sub Document Type"::Direct;
            PurchHeader."Sub Document Type" := PurchHeader."Sub Document Type"::"Direct PO";
            PurchHeader."No." := '';
            PurchHeader.INSERT(TRUE);
            PurchHeader.Initiator := UserId;
            PurchHeader."Assigned User ID" := UserId;
            PurchHeader."Starting Date" := Today;
            PurchHeader."Ending Date" := CalcDate('1Y', Today);
            PurchHeader.Modify();
            PPurchHeader := PurchHeader;
            Commit();
            IF OpenPage THEN
                OpenPurchaseOrder;
        END;
    end;


    procedure CreatePurchaseOrderService(OpenPage: Boolean; var PPurchHeader: Record "Purchase Header")
    begin
        TxtDocumentType := 'Work Order';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Purchase, WfDocumentType::Order, WfSubDocumentType::WorkOrder, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::WorkOrder);
        PurchHeader.SETRANGE("Initiator User ID", USERID);
        PurchHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        PurchHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF PurchHeader.FINDSET THEN BEGIN
            REPEAT
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
                IF NOT PurchaseLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL PurchHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
            PurchHeader."Workflow Sub Document Type" := PurchHeader."Workflow Sub Document Type"::WorkOrder;
            PurchHeader."Order Type" := PurchHeader."Order Type"::"Work Order";
            PurchHeader."Sub Document Type" := PurchHeader."Sub Document Type"::"WO-NICB";
            PurchHeader."No." := '';
            PurchHeader.INSERT(TRUE);
            PurchHeader.Initiator := UserId;
            PurchHeader."Assigned User ID" := UserId;
            PurchHeader."Starting Date" := Today;
            PurchHeader."Ending Date" := CalcDate('1Y', Today);
            PurchHeader.Modify();
            PPurchHeader := PurchHeader;
            Commit();
            IF OpenPage THEN
                OpenPurchaseOrder;
        END;
    end;


    procedure OpenPurchaseOrder()
    begin
        PAGE.RUN(PAGE::"Purchase Order", PurchHeader);
    end;


    procedure "---GoodsReceipt---"()
    begin
    end;


    procedure CreateGRNRegular(OpenPage: Boolean; var PGRNHeader: Record "GRN Header")
    begin

        TxtDocumentType := 'Goods Receipt Note ( Regular )';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::"Purchase Receipt", WfDocumentType::Order, WfSubDocumentType::Regular, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        GRNHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", "Workflow Approval Status");
        GRNHeader.SETRANGE("Document Type", GRNHeader."Document Type"::GRN);
        GRNHeader.SETRANGE("Workflow Sub Document Type", GRNHeader."Workflow Sub Document Type"::Regular);
        GRNHeader.SETRANGE("Initiator User ID", USERID);
        GRNHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        GRNHeader.SETRANGE("Workflow Approval Status", GRNHeader."Workflow Approval Status"::Open);
        IF GRNHeader.FINDSET THEN BEGIN
            REPEAT
                GRNLine.RESET;
                GRNLine.SETRANGE("Document Type", GRNHeader."Document Type");
                GRNLine.SETRANGE("GRN No.", GRNHeader."GRN No.");
                IF NOT GRNLine.FINDFIRST THEN
                    ERROR(Text002, GRNHeader."GRN No.", USERID);
            UNTIL GRNHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            GRNHeader.INIT;
            GRNHeader."Document Type" := GRNHeader."Document Type"::GRN;
            GRNHeader."Workflow Sub Document Type" := GRNHeader."Workflow Sub Document Type"::Regular;
            //GRNHeader."Sub Document Type" := GRNHeader."Sub Document Type"::"Regular PO";
            GRNHeader."GRN No." := '';
            GRNHeader.INSERT(TRUE);
            PGRNHeader := GRNHeader;
            COMMIT;
            IF OpenPage THEN
                OpenGRN;
        END;
    end;


    procedure CreateGRNDirect(OpenPage: Boolean; var PGRNHeader: Record "GRN Header")
    begin
        TxtDocumentType := 'Goods Receipt Note ( Direct )';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::"Purchase Receipt", WfDocumentType::Order, WfSubDocumentType::Direct, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        GRNHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", "Workflow Approval Status");
        GRNHeader.SETRANGE("Document Type", GRNHeader."Document Type"::GRN);
        GRNHeader.SETRANGE("Workflow Sub Document Type", GRNHeader."Workflow Sub Document Type"::Direct);
        GRNHeader.SETRANGE("Initiator User ID", USERID);
        GRNHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        GRNHeader.SETRANGE("Workflow Approval Status", GRNHeader."Workflow Approval Status"::Open);
        GRNHeader.SETRANGE(Status, GRNHeader.Status::Open);
        IF GRNHeader.FINDSET THEN BEGIN
            REPEAT
                GRNLine.RESET;
                GRNLine.SETRANGE("Document Type", GRNHeader."Document Type");
                GRNLine.SETRANGE("No.", GRNHeader."GRN No.");
                IF NOT GRNLine.FINDFIRST THEN
                    ERROR(Text002, GRNHeader."GRN No.", USERID);
            UNTIL GRNHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, GRNHeader."Document Type"::GRN) THEN BEGIN
            GRNHeader.INIT;
            GRNHeader."Document Type" := GRNHeader."Document Type"::GRN;
            GRNHeader."Workflow Sub Document Type" := GRNHeader."Workflow Sub Document Type"::Direct;
            //GRNHeader."Sub Document Type" := GRNHeader."Sub Document Type"::"GRN-Direct Purchase";
            GRNHeader."GRN No." := '';
            GRNHeader.INSERT(TRUE);
            PGRNHeader := GRNHeader;
            COMMIT;
            IF OpenPage THEN
                OpenGRN;
        END;
    end;


    procedure CreateServiceReceiptNote(OpenPage: Boolean; var PGRNHeader: Record "GRN Header")
    begin
        TxtDocumentType := 'Service Receipt Note';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::"Purchase Receipt", WfDocumentType::Order, WfSubDocumentType::WorkOrder, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        GRNHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", "Workflow Approval Status");
        GRNHeader.SETRANGE("Document Type", GRNHeader."Document Type"::GRN);
        GRNHeader.SETRANGE("Workflow Sub Document Type", GRNHeader."Workflow Sub Document Type"::WorkOrder);
        GRNHeader.SETRANGE("Initiator User ID", USERID);
        GRNHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        GRNHeader.SETRANGE("Workflow Approval Status", GRNHeader."Workflow Approval Status"::Open);
        IF GRNHeader.FINDSET THEN BEGIN
            REPEAT
                GRNLine.RESET;
                GRNLine.SETRANGE("Document Type", GRNHeader."Document Type");
                GRNLine.SETRANGE("No.", GRNHeader."GRN No.");
                IF NOT GRNLine.FINDFIRST THEN
                    ERROR(Text002, GRNHeader."GRN No.", USERID);
            UNTIL GRNHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            GRNHeader.INIT;
            GRNHeader."Document Type" := GRNHeader."Document Type"::GRN;
            GRNHeader."Workflow Sub Document Type" := GRNHeader."Workflow Sub Document Type"::WorkOrder;
            GRNHeader."GRN No." := '';
            GRNHeader.INSERT(TRUE);
            PGRNHeader := GRNHeader;
            IF OpenPage THEN
                OpenSRN;
        END;
    end;


    procedure CreateGoodsReceiptWorkOrder(OpenPage: Boolean; var PGRNHeader: Record "GRN Header")
    begin
        TxtDocumentType := 'Job Entry Sheet';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::"Purchase Receipt", WfDocumentType::Order, WfSubDocumentType::WorkOrder, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);
        /*
        GRNHeader.SETCURRENTKEY("Document Type","Workflow Sub Document Type","Initiator User ID","Responsibility Center","Workflow Approval Status");
        GRNHeader.SETRANGE("Document Type",GRNHeader."Document Type"::GRN);
        GRNHeader.SETRANGE("Workflow Sub Document Type",GRNHeader."Workflow Sub Document Type"::WorkOrder);
        GRNHeader.SETRANGE("Initiator User ID",USERID);
        GRNHeader.SETRANGE("Responsibility Center",WfResponsibilityCentre);
        GRNHeader.SETRANGE("Workflow Approval Status",GRNHeader."Workflow Approval Status"::Open);
        IF GRNHeader.FINDSET THEN BEGIN
          REPEAT
            GRNLine.RESET;
            GRNLine.SETRANGE("Document Type",GRNHeader."Document Type");
            GRNLine.SETRANGE("No.",GRNHeader."No.");
            IF NOT GRNLine.FINDFIRST THEN
              ERROR(Text002,GRNHeader."No.",USERID);
            UNTIL GRNHeader.NEXT = 0;
        END;
        */
        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            GRNHeader.INIT;
            GRNHeader."Document Type" := GRNHeader."Document Type"::GRN;
            GRNHeader."Workflow Sub Document Type" := GRNHeader."Workflow Sub Document Type"::WorkOrder;
            GRNHeader."Sub Document Type" := GRNHeader."Sub Document Type"::"JES for WO";
            GRNHeader."GRN No." := '';
            GRNHeader.INSERT(TRUE);
            PGRNHeader := GRNHeader;
            IF OpenPage THEN
                OpenJES;
        END;

    end;


    procedure OpenGRN()
    begin
        PAGE.RUN(PAGE::"GRN Header", GRNHeader);
    end;


    procedure OpenSRN()
    begin
        //PAGE.RUN(PAGE::"Service Receipt Note",GRNHeader);
    end;


    procedure OpenJES()
    begin
        PAGE.RUN(PAGE::"GRN Header JES", GRNHeader);
    end;


    procedure "---PurchaseInoice---"()
    begin
    end;


    procedure CreatePurchaseInvoice(OpenPage: Boolean; var PPurchHeader: Record "Purchase Header")
    begin
        TxtDocumentType := 'Purchase Invoice';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Purchase, WfDocumentType::Invoice, WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::" ");
        PurchHeader.SETRANGE("Initiator User ID", USERID);
        PurchHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        PurchHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF PurchHeader.FINDFIRST THEN BEGIN
            REPEAT
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
                IF NOT PurchaseLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL PurchHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;
            PurchHeader."Workflow Sub Document Type" := PurchHeader."Workflow Sub Document Type"::" ";
            PurchHeader.Trading := ResponsibilityCenter.Trading;
            PurchHeader."No." := '';
            PurchHeader.INSERT(TRUE);
            PPurchHeader := PurchHeader;
            IF OpenPage THEN
                OpenPurchaseInvoice;
        END;
    end;


    procedure CreatePurchaseInvoiceService(OpenPage: Boolean; var PPurchHeader: Record "Purchase Header")
    begin
        TxtDocumentType := 'Purchase Invoice (Work Order)';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Purchase, WfDocumentType::Invoice, WfSubDocumentType::WorkOrder, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);
        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::WorkOrder);
        PurchHeader.SETRANGE("Initiator User ID", USERID);
        PurchHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        PurchHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF PurchHeader.FINDSET THEN BEGIN
            REPEAT
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
                IF NOT PurchaseLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL PurchHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;
            PurchHeader."Workflow Sub Document Type" := PurchHeader."Workflow Sub Document Type"::WorkOrder;
            PurchHeader."No." := '';
            PurchHeader.INSERT(TRUE);
            PPurchHeader := PurchHeader;
            IF OpenPage THEN
                OpenPurchaseInvoice;
        END;
    end;


    procedure OpenPurchaseInvoice()
    begin
        PAGE.RUN(PAGE::"Purchase Invoice", PurchHeader);
    end;


    procedure "---PurchaseCrMemo---"()
    begin
    end;


    procedure CreatePurchaseCreditMemo(OpenPage: Boolean; var PPurchHeader: Record "Purchase Header")
    begin
        TxtDocumentType := 'Purchase Credit Memo';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Purchase, WfDocumentType::"Credit Memo", WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);
        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::"Credit Memo");
        PurchHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::" ");
        PurchHeader.SETRANGE("Initiator User ID", USERID);
        PurchHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        PurchHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF PurchHeader.FINDSET THEN BEGIN
            REPEAT
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
                IF NOT PurchaseLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL PurchHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::"Credit Memo";
            PurchHeader."Workflow Sub Document Type" := PurchHeader."Workflow Sub Document Type"::" ";
            PurchHeader.Trading := ResponsibilityCenter.Trading;
            PurchHeader."No." := '';
            PurchHeader.INSERT(TRUE);
            PPurchHeader := PurchHeader;
            IF OpenPage THEN
                OpenPurchaseCrMemo;
        END;
    end;


    procedure CreatePurchaseCreditMemoService(OpenPage: Boolean; var PPurchHeader: Record "Purchase Header")
    begin
        TxtDocumentType := 'Purchase Credit Memo Service';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Purchase, WfDocumentType::"Credit Memo", WfSubDocumentType::WorkOrder, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);
        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::"Credit Memo");
        PurchHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::WorkOrder);
        PurchHeader.SETRANGE("Initiator User ID", USERID);
        PurchHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        PurchHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF PurchHeader.FINDSET THEN BEGIN
            REPEAT
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
                IF NOT PurchaseLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL PurchHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::"Credit Memo";
            PurchHeader."Workflow Sub Document Type" := PurchHeader."Workflow Sub Document Type"::WorkOrder;
            PurchHeader.Trading := ResponsibilityCenter.Trading;
            PurchHeader."No." := '';
            PurchHeader.INSERT(TRUE);
            PurchHeader := PurchHeader;
            IF OpenPage THEN
                OpenPurchaseCrMemo;
        END;
    end;


    procedure CreatePurchaseCrMemoWithExcise(OpenPage: Boolean; var PPurchHeader: Record "Purchase Header")
    begin
        TxtDocumentType := 'Purchase Credit Memo Excisebale';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');

        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Purchase, WfDocumentType::"Credit Memo", WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);
        PurchHeader.RESET;
        PurchHeader.SETCURRENTKEY("Document Type", "Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::"Credit Memo");
        PurchHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::" ");
        PurchHeader.SETRANGE("Initiator User ID", USERID);
        PurchHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        PurchHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF PurchHeader.FINDSET THEN BEGIN
            REPEAT
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
                IF NOT PurchaseLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL PurchHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::"Credit Memo";
            PurchHeader.Trading := ResponsibilityCenter.Trading;
            //PurchHeader."Purchase Return Type" := PurchHeader."Purchase Return Type"::"With Excise";
            PurchHeader."No." := '';
            PurchHeader.INSERT(TRUE);
            PPurchHeader := PurchHeader;
            IF OpenPage THEN
                OpenPurchaseCrMemo;
        END;
    end;


    procedure OpenPurchaseCrMemo()
    begin
        PAGE.RUN(PAGE::"Purchase Credit Memo", PurchHeader);
    end;


    procedure "----TransferOrder--"()
    begin
    end;


    procedure CreateRegularTransferOrder(OpenPage: Boolean; var PTransferHeader: Record "Transfer Header")
    begin
        TxtDocumentType := 'Regular Transfer Order';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Transfer, WfDocumentType::Order, WfSubDocumentType::Regular, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        TransferHeader.RESET;
        TransferHeader.SETCURRENTKEY("Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        TransferHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::Regular);
        TransferHeader.SETRANGE("Initiator User ID", USERID);
        TransferHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        TransferHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF TransferHeader.FINDSET THEN BEGIN
            REPEAT
                TranferLine.RESET;
                TranferLine.SETRANGE("Document No.", TransferHeader."No.");
                IF NOT TranferLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL TransferHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, FALSE, TxtDocumentType) THEN BEGIN
            TransferHeader.INIT;
            TransferHeader."Workflow Sub Document Type" := TransferHeader."Workflow Sub Document Type"::Regular;
            TransferHeader."No." := '';
            TransferHeader.INSERT(TRUE);
            PTransferHeader := TransferHeader;
            IF OpenPage THEN
                OpenTransferOrder;
        END;
    end;


    procedure CreateDirectTransferOrder(OpenPage: Boolean; var PTransferHeader: Record "Transfer Header")
    begin
        TxtDocumentType := 'Direct Transfer Order';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Transfer, WfDocumentType::Order, WfSubDocumentType::Direct, WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        TransferHeader.RESET;
        TransferHeader.SETCURRENTKEY("Workflow Sub Document Type", "Initiator User ID", "Responsibility Center", Status);
        TransferHeader.SETRANGE("Workflow Sub Document Type", PurchHeader."Workflow Sub Document Type"::Direct);
        TransferHeader.SETRANGE("Initiator User ID", USERID);
        TransferHeader.SETRANGE("Responsibility Center", WfResponsibilityCentre);
        TransferHeader.SETRANGE(Status, PurchHeader.Status::Open);
        IF TransferHeader.FINDSET THEN BEGIN
            REPEAT
                TranferLine.RESET;
                TranferLine.SETRANGE("Document No.", TransferHeader."No.");
                IF NOT TranferLine.FINDFIRST THEN
                    ERROR(Text002, PurchHeader."No.", USERID);
            UNTIL TransferHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, FALSE, TxtDocumentType) THEN BEGIN
            TransferHeader.INIT;
            TransferHeader."Workflow Sub Document Type" := TransferHeader."Workflow Sub Document Type"::Direct;
            TransferHeader."No." := '';
            TransferHeader.INSERT(TRUE);
            PTransferHeader := TransferHeader;
            IF OpenPage THEN
                OpenTransferOrder;
        END;
    end;


    procedure OpenTransferOrder()
    begin
        PAGE.RUN(PAGE::"Transfer Order", TransferHeader);
    end;


    procedure OpenInspectionCall()
    begin
        //PAGE.RUN(PAGE::"Call Header",CallHeader);
    end;


    procedure "---SalesQuote---"()
    begin
    end;


    procedure CreateSalesQuote(OpenPage: Boolean; var PSalesHeader: Record "Sales Header")
    begin
        TxtDocumentType := 'Sales Quotation';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(0, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Sales, WfDocumentType::Quote, WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        SalesHeader.RESET;
        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
            SalesHeader."Workflow Sub Document Type" := SalesHeader."Workflow Sub Document Type"::" ";
            SalesHeader."No." := '';
            SalesHeader.INSERT(TRUE);
            PSalesHeader := SalesHeader;
            IF OpenPage THEN
                OpenSalesQuote;
        END;
    end;


    procedure OpenSalesQuote()
    begin
        PAGE.RUN(PAGE::"Sales Quote", SalesHeader);
    end;


    procedure "---Sales Order---"()
    begin
    end;


    procedure CreateSalesOrderDomestic(OpenPage: Boolean; var PSalesHeader: Record "Sales Header")
    begin
        TxtDocumentType := 'Domestic Sales Order';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(0, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Sales, WfDocumentType::Order, WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Initiator User ID", "Shortcut Dimension 1 Code", "Document Type", "Order Status", "Workflow Sub Document Type");
        SalesHeader.SETRANGE("Initiator User ID", USERID);
        SalesHeader.SETRANGE(SalesHeader."Shortcut Dimension 1 Code", WfResponsibilityCentre);
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE("Workflow Sub Document Type", SalesHeader."Workflow Sub Document Type"::" ");
        //SalesHeader.SETRANGE("Dispatch Type",SalesHeader."Dispatch Type"::Domestic);
        //SalesHeader.SETRANGE("Invoice Type2",SalesHeader."Invoice Type2"::Normal);
        //SalesHeader.SETRANGE("Print Job",FALSE);
        IF SalesHeader.FINDSET THEN BEGIN
            REPEAT
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                IF NOT SalesLine.FINDFIRST THEN
                    ERROR(Text002, SalesHeader."No.", USERID);
            UNTIL SalesHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
            //SalesHeader."Dispatch Type":=SalesHeader."Dispatch Type"::Domestic;
            //SalesHeader."Invoice Type2":=SalesHeader."Invoice Type2"::Normal;
            SalesHeader.Trading := ResponsibilityCenter.Trading;
            SalesHeader."No." := '';
            SalesHeader.INSERT(TRUE);
            PSalesHeader := SalesHeader;
            IF OpenPage THEN
                OpenSalesOrder;
        END;
    end;


    procedure CreateSalesOrderExport(OpenPage: Boolean; var PSalesHeader: Record "Sales Header")
    begin
        TxtDocumentType := 'Export Sales Order';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(0, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Sales, WfDocumentType::Order, WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Initiator User ID", "Shortcut Dimension 1 Code", "Document Type", "Order Status", "Workflow Sub Document Type");
        SalesHeader.SETRANGE("Initiator User ID", USERID);
        SalesHeader.SETRANGE(SalesHeader."Shortcut Dimension 1 Code", WfResponsibilityCentre);
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE("Workflow Sub Document Type", SalesHeader."Workflow Sub Document Type"::" ");
        //SalesHeader.SETRANGE("Dispatch Type",SalesHeader."Dispatch Type"::Miscellaneous);
        //SalesHeader.SETRANGE("Invoice Type2",SalesHeader."Invoice Type2"::Normal);
        //SalesHeader.SETRANGE("Print Job",FALSE);
        IF SalesHeader.FINDSET THEN BEGIN
            REPEAT
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                IF NOT SalesLine.FINDFIRST THEN
                    ERROR(Text002, SalesHeader."No.", USERID);
            UNTIL SalesHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
            //SalesHeader."Dispatch Type":=SalesHeader."Dispatch Type"::Export;
            //SalesHeader."Invoice Type2":=SalesHeader."Invoice Type2"::Normal;
            SalesHeader.Trading := ResponsibilityCenter.Trading;
            SalesHeader."No." := '';
            SalesHeader.INSERT(TRUE);
            PSalesHeader := SalesHeader;
            IF OpenPage THEN
                OpenSalesOrder;
        END;
    end;


    procedure CreateSalesOrdeMisc(OpenPage: Boolean; var PSalesHeader: Record "Sales Header")
    begin
        TxtDocumentType := 'Misc. Sales Order';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(0, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Sales, WfDocumentType::Order, WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Initiator User ID", "Shortcut Dimension 1 Code", "Document Type", "Order Status", "Workflow Sub Document Type");
        SalesHeader.SETRANGE("Initiator User ID", USERID);
        SalesHeader.SETRANGE(SalesHeader."Shortcut Dimension 1 Code", WfResponsibilityCentre);
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE("Workflow Sub Document Type", SalesHeader."Workflow Sub Document Type"::" ");
        //SalesHeader.SETRANGE("Dispatch Type",SalesHeader."Dispatch Type"::Miscellaneous);
        //SalesHeader.SETRANGE("Invoice Type2",SalesHeader."Invoice Type2"::Normal);
        //SalesHeader.SETRANGE("Print Job",FALSE);
        IF SalesHeader.FINDSET THEN BEGIN
            REPEAT
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                IF NOT SalesLine.FINDFIRST THEN
                    ERROR(Text002, SalesHeader."No.", USERID);
            UNTIL SalesHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
            //SalesHeader."Dispatch Type":=SalesHeader."Dispatch Type"::Miscellaneous;
            //SalesHeader."Invoice Type2":=SalesHeader."Invoice Type2"::Normal;
            SalesHeader.Trading := ResponsibilityCenter.Trading;
            SalesHeader."No." := '';
            SalesHeader.INSERT(TRUE);
            PSalesHeader := SalesHeader;
            IF OpenPage THEN
                OpenSalesOrder;
        END;
    end;


    procedure OpenSalesOrder()
    begin
        PAGE.RUN(PAGE::"Sales Order", SalesHeader);
    end;


    procedure "---SalesInvoice---"()
    begin
    end;


    procedure CreateSalesInvoiceDomestic(OpenPage: Boolean; var PSalesHeader: Record "Sales Header")
    begin
        TxtDocumentType := 'Domestic Sales Invoice';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(0, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Sales, WfDocumentType::Invoice, WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Initiator User ID", "Shortcut Dimension 1 Code", "Document Type", "Order Status", "Workflow Sub Document Type");
        SalesHeader.SETRANGE("Initiator User ID", USERID);
        SalesHeader.SETRANGE(SalesHeader."Shortcut Dimension 1 Code", WfResponsibilityCentre);
        //SalesHeader.SETRANGE("Dispatch Type",SalesHeader."Dispatch Type"::Domestic);
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice);
        //SalesHeader.SETRANGE("Invoice Type2",SalesHeader."Invoice Type2"::Normal);
        IF SalesHeader.FINDSET THEN BEGIN
            REPEAT
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                IF NOT SalesLine.FINDFIRST THEN
                    ERROR(Text002, SalesHeader."No.", USERID);
            UNTIL SalesHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            SalesHeader.INIT;
            //SalesHeader."Dispatch Type":=SalesHeader."Dispatch Type"::Domestic;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            //SalesHeader."Invoice Type2":=SalesHeader."Invoice Type2"::Normal;
            SalesHeader.Trading := ResponsibilityCenter.Trading;
            SalesHeader."No." := '';
            SalesHeader.INSERT(TRUE);
            PSalesHeader := SalesHeader;
            IF OpenPage THEN
                OpenSalesInvoice;
        END;
    end;


    procedure CreateSalesInvoiceExport(OpenPage: Boolean; var PSalesHeader: Record "Sales Header")
    begin
        TxtDocumentType := 'Export Sales Invocie';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(0, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Sales, WfDocumentType::Invoice, WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Initiator User ID", "Shortcut Dimension 1 Code", "Document Type", "Order Status", "Workflow Sub Document Type");
        SalesHeader.SETRANGE("Initiator User ID", USERID);
        SalesHeader.SETRANGE(SalesHeader."Shortcut Dimension 1 Code", WfResponsibilityCentre);
        //SalesHeader.SETRANGE("Dispatch Type",SalesHeader."Dispatch Type"::Export);
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice);
        //SalesHeader.SETRANGE("Invoice Type2",SalesHeader."Invoice Type2"::Normal);
        IF SalesHeader.FINDSET THEN BEGIN
            REPEAT
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                IF NOT SalesLine.FINDFIRST THEN
                    ERROR(Text002, SalesHeader."No.", USERID);
            UNTIL SalesHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            SalesHeader.INIT;
            //SalesHeader."Dispatch Type":=SalesHeader."Dispatch Type"::Export;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            //SalesHeader."Invoice Type2":=SalesHeader."Invoice Type2"::Normal;
            SalesHeader."No." := '';
            SalesHeader.Trading := ResponsibilityCenter.Trading;
            SalesHeader.INSERT(TRUE);
            PSalesHeader := SalesHeader;
            IF OpenPage THEN
                OpenSalesInvoice;
        END;
    end;


    procedure CreateSalesInvoiceMisc(OpenPage: Boolean; var PSalesHeader: Record "Sales Header")
    begin
        TxtDocumentType := 'Misc. Sales Invoice';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(0, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Sales, WfDocumentType::Invoice, WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Initiator User ID", "Shortcut Dimension 1 Code", "Document Type", "Order Status", "Workflow Sub Document Type");
        SalesHeader.SETRANGE("Initiator User ID", USERID);
        SalesHeader.SETRANGE(SalesHeader."Shortcut Dimension 1 Code", WfResponsibilityCentre);
        //SalesHeader.SETRANGE("Dispatch Type",SalesHeader."Dispatch Type"::Miscellaneous);
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice);
        //SalesHeader.SETRANGE("Invoice Type2",SalesHeader."Invoice Type2"::Normal);
        IF SalesHeader.FINDSET THEN BEGIN
            REPEAT
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                IF NOT SalesLine.FINDFIRST THEN
                    ERROR(Text002, SalesHeader."No.", USERID);
            UNTIL SalesHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            SalesHeader.INIT;
            //SalesHeader."Dispatch Type":=SalesHeader."Dispatch Type"::Miscellaneous;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            //SalesHeader."Invoice Type2":=SalesHeader."Invoice Type2"::Normal;
            SalesHeader.Trading := ResponsibilityCenter.Trading;
            SalesHeader."No." := '';
            SalesHeader.INSERT(TRUE);
            PSalesHeader := SalesHeader;
            IF OpenPage THEN
                OpenSalesInvoice;
        END;
    end;


    procedure OpenSalesInvoice()
    begin
        PAGE.RUN(PAGE::"Sales Invoice", SalesHeader);
    end;

    local procedure "---SalesCrMemo---"()
    begin
    end;


    procedure CreateSalesCreditMemo(OpenPage: Boolean; var PSalesHeader: Record "Sales Header")
    begin
        TxtDocumentType := 'Sales Credit Memo';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(0, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Sales, WfDocumentType::"Credit Memo", WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Initiator User ID", "Shortcut Dimension 1 Code", "Document Type", "Order Status", "Workflow Sub Document Type");
        SalesHeader.SETRANGE("Initiator User ID", USERID);
        SalesHeader.SETRANGE(SalesHeader."Shortcut Dimension 1 Code", WfResponsibilityCentre);
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Credit Memo");
        SalesHeader.SETRANGE("Workflow Sub Document Type", SalesHeader."Workflow Sub Document Type"::" ");
        IF SalesHeader.FINDSET THEN BEGIN
            REPEAT
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                IF NOT SalesLine.FINDFIRST THEN
                    ERROR(Text002, SalesHeader."No.", USERID);
            UNTIL SalesHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
            SalesHeader.Trading := ResponsibilityCenter.Trading;
            SalesHeader."No." := '';
            SalesHeader.INSERT(TRUE);
            PSalesHeader := SalesHeader;
            IF OpenPage THEN
                OpenSalesCreditMemo;
        END;
    end;


    procedure OpenSalesCreditMemo()
    begin
        PAGE.RUN(PAGE::"Sales Credit Memo", SalesHeader);
    end;


    procedure "-Sales (Job) Offer-"()
    begin
    end;


    procedure CreateProjectQuote(OpenPage: Boolean; var pJob: Record Job)
    begin
        TxtDocumentType := 'Project (Job) Offer';
        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            Job.INIT;
            Job.Status := Job.Status::Quote;
            Job."No." := '';
            Job.INSERT(TRUE);
            pJob := Job;
            IF OpenPage THEN
                OpenJob;
        END;
    end;


    procedure CreateProjectOrder(OpenPage: Boolean; var pJob: Record Job)
    begin
        TxtDocumentType := 'Project (Job) Order';
        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            Job.INIT;
            Job.Status := Job.Status::Order;
            Job."No." := '';
            Job.INSERT(TRUE);
            pJob := Job;
            IF OpenPage THEN
                OpenJob;
        END;
    end;


    procedure OpenJob()
    begin
        PAGE.RUN(PAGE::"Job Card", Job);
    end;


    procedure "-Inspection-"()
    begin
    end;


    procedure CreateInspectionCall(OpenPage: Boolean; var pCallHeader: Record "FD Payment Schedule Posted")
    begin
        /*
        TxtDocumentType :='Inspection Call';
        IF CONFIRM(Text003,TRUE,TxtDocumentType) THEN BEGIN
          CallHeader.INIT;
          CallHeader."No.":='';
          CallHeader.INSERT(TRUE);
          pCallHeader := CallHeader;
          IF OpenPage THEN
            OpenInspectionCall;
        END;
        */

    end;


    procedure CreateICatVendor(OpenPage: Boolean; var pInspectionHeader: Record "Project Price Group Details")
    begin
        /*
        TxtDocumentType := FORMAT(InspectionHeader."Inspection Type"::"Vendor Location") + 'Inspection Document';
        IF CONFIRM(Text003,TRUE,TxtDocumentType) THEN BEGIN
          InspectionHeader.INIT;
          InspectionHeader."Inspection Type":=InspectionHeader."Inspection Type"::"Vendor Location";
          InspectionHeader."No.":='';
          InspectionHeader.INSERT(TRUE);
          pInspectionHeader := InspectionHeader;
          IF OpenPage THEN
            OpenVIC;
        END;
        */

    end;


    procedure CreateICatFactory(OpenPage: Boolean; var pInspectionHeader: Record "Project Price Group Details")
    begin
        /*
        TxtDocumentType := FORMAT(InspectionHeader."Inspection Type"::"Factory Location") + 'Inspection Document';
        IF CONFIRM(Text003,TRUE,TxtDocumentType) THEN BEGIN
          InspectionHeader.INIT;
          InspectionHeader."Inspection Type":=InspectionHeader."Inspection Type"::"Factory Location";
          InspectionHeader."No.":='';
          InspectionHeader.INSERT(TRUE);
          pInspectionHeader := InspectionHeader;
          IF OpenPage THEN
            OpenFIC;
        END;
        */

    end;


    procedure OpenVIC()
    begin
        //PAGE.RUN(PAGE::"Vendor Location Inspection",InspectionHeader);
    end;


    procedure OpenFIC()
    begin
        //PAGE.RUN(PAGE::"Factory Location Inspection",InspectionHeader);
    end;

    local procedure "---Award Note---"()
    begin
    end;


    procedure CreateAwardNote(OpenPage: Boolean; var PAwardNote: Record "Confirmed Order")
    begin
        //ALLE TS 17012017
        /*
        TxtDocumentType :='Award Note';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1,'');
        WfTemplateName :='';
        WfBatchName :='';
        //CheckWFDocumentTypeSetup(WfTransactionType::"Award Note",WfDocumentType::Order,WfSubDocumentType::" ",
          //WfTemplateName,WfBatchName,WfResponsibilityCentre,FALSE);
        
        IF CONFIRM(Text003,TRUE,TxtDocumentType) THEN BEGIN
          AwardNote.INIT;
          AwardNote."Workflow Sub Document Type" := AwardNote."Workflow Sub Document Type"::" ";
          AwardNote."Document No.":='';
          AwardNote.INSERT(TRUE);
          PAwardNote := AwardNote;
          IF OpenPage THEN
            PAGE.RUN(PAGE::"Award Note",AwardNote);
        END;
        //ALLE TS 17012017
        */

    end;


    procedure CreateNoteSheet(OpenPage: Boolean; var PAwardNote: Record Documentation)
    begin
        /*
        TxtDocumentType :='Note Sheet';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(1,'');
        WfTemplateName :='';
        WfBatchName :='';
        CheckWFDocumentTypeSetup(WfTransactionType::"Note Sheet",WfDocumentType::Order,WfSubDocumentType::" ",
          WfTemplateName,WfBatchName,WfResponsibilityCentre,FALSE);
        
        IF CONFIRM(Text003,TRUE,TxtDocumentType) THEN BEGIN
          NoteSheet.INIT;
          NoteSheet."Workflow Sub Document Type" := AwardNote."Workflow Sub Document Type"::" ";
          NoteSheet."Document No.":='';
          NoteSheet.INSERT(TRUE);
          PAwardNote := NoteSheet;
          IF OpenPage THEN
            PAGE.RUN(PAGE::"Note Sheet",NoteSheet);
        END;
        */

    end;

    local procedure "--Sales Proforma Inv--"()
    begin
    end;


    procedure CreateSalesInvoiceProforma(OpenPage: Boolean; var PrSalesHeader: Record "Sales Header")
    begin
        //ALLE ANSH
        TxtDocumentType := 'Proforma Sales Invoice';
        WfResponsibilityCentre := UserSetupMgmt.GetRespCenter(0, '');
        WfTemplateName := '';
        WfBatchName := '';
        CheckWFDocumentTypeSetup(WfTransactionType::Sales, WfDocumentType::Invoice, WfSubDocumentType::" ", WfTemplateName, WfBatchName, WfResponsibilityCentre, FALSE);

        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Initiator User ID", "Shortcut Dimension 1 Code", "Document Type", "Order Status", "Workflow Sub Document Type");
        SalesHeader.SETRANGE("Initiator User ID", USERID);
        SalesHeader.SETRANGE(SalesHeader."Shortcut Dimension 1 Code", WfResponsibilityCentre);
        //SalesHeader.SETRANGE("Dispatch Type",SalesHeader."Dispatch Type"::Miscellaneous);
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice);
        //SalesHeader.SETRANGE("Invoice Type2",SalesHeader."Invoice Type2"::Normal);
        IF SalesHeader.FINDSET THEN BEGIN
            REPEAT
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                IF NOT SalesLine.FINDFIRST THEN
                    ERROR(Text002, SalesHeader."No.", USERID);
            UNTIL SalesHeader.NEXT = 0;
        END;

        IF CONFIRM(Text003, TRUE, TxtDocumentType) THEN BEGIN
            SalesHeader.INIT;
            //SalesHeader."Dispatch Type":=SalesHeader."Dispatch Type"::Miscellaneous;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            //SalesHeader."Invoice Type2":=SalesHeader."Invoice Type2"::Proforma;
            SalesHeader.Trading := ResponsibilityCenter.Trading;
            SalesHeader."No." := '';
            SalesHeader.INSERT(TRUE);
            PrSalesHeader := SalesHeader;
            IF OpenPage THEN
                OpenSalesInvoiceProforma;

        END;
    end;

    local procedure OpenSalesInvoiceProforma()
    begin
        //PAGE.RUN(PAGE::"Sales Proforma Invoice",SalesHeader);
    end;
}

