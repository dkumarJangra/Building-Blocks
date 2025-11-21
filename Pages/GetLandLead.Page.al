page 60723 "Get Land Lead"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Land Lead/Opp Line";
    SourceTableView = WHERE("Document Type" = CONST(Lead));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("PO No."; Rec."PO No.")
                {
                }
                field("PO Date"; Rec."PO Date")
                {
                }
                field("PO Value"; Rec."PO Value")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("Land Type"; Rec."Land Type")
                {
                }
                field("Co-Ordinates"; Rec."Co-Ordinates")
                {
                }
                field("Area"; Rec.Area)
                {
                }
                field("Nature of Deed"; Rec."Nature of Deed")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Sale Deed No."; Rec."Sale Deed No.")
                {
                }
                field("Inspected By"; Rec."Inspected By")
                {
                }
                field("Inspected Date"; Rec."Inspected Date")
                {
                }
                field("Assigned To"; Rec."Assigned To")
                {
                }
                field("Considration Amount"; Rec."Considration Amount")
                {
                }
                field("Stamp Duty Amount"; Rec."Stamp Duty Amount")
                {
                }
                field("Registration Amount"; Rec."Registration Amount")
                {
                }
                field("Other Charges"; Rec."Other Charges")
                {
                }
                field("Amount Alloted to Agent"; Rec."Amount Alloted to Agent")
                {
                }
                field("Land Value"; Rec."Land Value")
                {
                }
                field(Note; Rec.Note)
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Lead Status"; Rec."Lead Status")
                {
                }
                field("Line Status"; Rec."Line Status")
                {
                }
                field("Modify By"; Rec."Modify By")
                {
                }
                field("Modify Date Time"; Rec."Modify Date Time")
                {
                }
                field("Area in Acres"; Rec."Area in Acres")
                {
                }
                field("Area in Guntas"; Rec."Area in Guntas")
                {
                }
                field("Area in Ankanan"; Rec."Area in Ankanan")
                {
                }
                field("Area in Cents"; Rec."Area in Cents")
                {
                }
                field("Area in Sq. Yard"; Rec."Area in Sq. Yard")
                {
                }
                field("Survey Nos."; Rec."Survey Nos.")
                {
                }
                field(Mutation; Rec.Mutation)
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Land Document Dimension"; Rec."Land Document Dimension")
                {
                }
                field("Total Expense to Vendor"; Rec."Total Expense to Vendor")
                {
                }
                field("Lead Document No."; Rec."Lead Document No.")
                {
                }
                field("Lead Document Line No."; Rec."Lead Document Line No.")
                {
                }
                field("Date of Registration"; Rec."Date of Registration")
                {
                }
                field("Pending From USER ID"; Rec."Pending From USER ID")
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
                field("Quantity In SQYD"; Rec."Quantity In SQYD")
                {
                }
                field("Expense Posted"; Rec."Expense Posted")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN
            InsertsLines;
    end;

    var
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        LandLeadOppLine: Record "Land Lead/Opp Line";
        LandOpprotunityHeader: Record "Land Lead/Opp Header";
        LandOpprotunityLine: Record "Land Lead/Opp Line";
        RecDocument: Record "Land Document Attachment";
        NewDocument: Record "Land Document Attachment";
        LandAgreementExpense: Record "Land Agreement Expense";
        OpportunityLandAgreementExpense: Record "Land Agreement Expense";
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        v_LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        OldDocument: Record "Land Document Attachment";
        DocumentSetup: Record "Document Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PostCode: Record "Post Code";
        InventorySetup: Record "Inventory Setup";
        LandPPRDocumentList_1: Record "Land R-1 PPR Document Lis_1";
        v_LandPPRDocumentList_1: Record "Land R-1 PPR Document Lis_1";
        v_LandLeadOppHeader: Record "Land Lead/Opp Header";
        LandVendorReceiptPayment: Record "Land Vendor Receipt Payment";
        OppLandVendorReceiptPayment: Record "Land Vendor Receipt Payment";


    procedure SetLandOppHeader(P_LandLeadOppHeader: Record "Land Lead/Opp Header")
    begin
        v_LandLeadOppHeader := P_LandLeadOppHeader;
    end;

    local procedure InsertsLines()
    begin
        IF CONFIRM('Do you want to insert these entries') THEN BEGIN
            CurrPage.SETSELECTIONFILTER(LandLeadOppLine);
            IF LandLeadOppLine.FINDSET THEN
                REPEAT
                    LandOpprotunityLine.INIT;
                    LandOpprotunityLine.TRANSFERFIELDS(LandLeadOppLine);
                    LandOpprotunityLine."Document Type" := LandOpprotunityLine."Document Type"::Opportunity;
                    LandOpprotunityLine."Document No." := v_LandLeadOppHeader."Document No.";
                    LandOpprotunityLine."Lead Status" := LandOpprotunityLine."Lead Status"::" ";
                    LandOpprotunityLine."Line Status" := LandOpprotunityLine."Line Status"::Open;
                    LandOpprotunityLine."Lead Document No." := LandLeadOppLine."Document No.";
                    LandOpprotunityLine."Lead Document Line No." := LandLeadOppLine."Line No.";
                    LandOpprotunityLine."Approval Status" := LandOpprotunityLine."Approval Status"::Open;
                    LandOpprotunityLine.INSERT;

                    LandAgreementExpense.RESET;
                    LandAgreementExpense.SETRANGE("Document Type", LandAgreementExpense."Document Type"::Lead);
                    LandAgreementExpense.SETRANGE("Document No.", v_LandLeadOppHeader."Lead Document No.");
                    LandAgreementExpense.SETRANGE("JV Posted", TRUE);
                    LandAgreementExpense.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                    IF LandAgreementExpense.FINDSET THEN
                        REPEAT
                            OpportunityLandAgreementExpense.RESET;
                            IF NOT OpportunityLandAgreementExpense.GET(v_LandLeadOppHeader."Document Type"::Opportunity, v_LandLeadOppHeader."Document No.", LandAgreementExpense."Document Line No.", LandAgreementExpense."Line No.") THEN BEGIN
                                OpportunityLandAgreementExpense.INIT;
                                OpportunityLandAgreementExpense.TRANSFERFIELDS(LandAgreementExpense);
                                OpportunityLandAgreementExpense."Document Type" := OpportunityLandAgreementExpense."Document Type"::Opportunity;
                                OpportunityLandAgreementExpense."Document No." := v_LandLeadOppHeader."Document No.";
                                OpportunityLandAgreementExpense.INSERT;
                            END;
                        UNTIL LandAgreementExpense.NEXT = 0;
                    //-----151123 Vendor Payment / Refund Start
                    LandVendorReceiptPayment.RESET;
                    LandVendorReceiptPayment.SETRANGE("Document Type", LandVendorReceiptPayment."Document Type"::Lead);
                    LandVendorReceiptPayment.SETRANGE("Document No.", v_LandLeadOppHeader."Lead Document No.");
                    LandVendorReceiptPayment.SETRANGE(Posted, TRUE);
                    LandVendorReceiptPayment.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                    IF LandVendorReceiptPayment.FINDSET THEN
                        REPEAT
                            OppLandVendorReceiptPayment.RESET;
                            IF NOT OppLandVendorReceiptPayment.GET(v_LandLeadOppHeader."Document Type"::Opportunity, v_LandLeadOppHeader."Document No.", LandVendorReceiptPayment."Document Line No.", LandVendorReceiptPayment."Line No.") THEN BEGIN
                                OppLandVendorReceiptPayment.INIT;
                                OppLandVendorReceiptPayment.TRANSFERFIELDS(LandVendorReceiptPayment);
                                OppLandVendorReceiptPayment."Document Type" := OppLandVendorReceiptPayment."Document Type"::Opportunity;
                                OppLandVendorReceiptPayment."Document No." := v_LandLeadOppHeader."Document No.";
                                OppLandVendorReceiptPayment.INSERT;
                            END;
                        UNTIL LandVendorReceiptPayment.NEXT = 0;
                    //-----151123 Vendor Payment / Refund END

                    //-----------Insert R-1 Check list START
                    v_LandPPRDocumentList.RESET;
                    v_LandPPRDocumentList.SETRANGE("Document No.", v_LandLeadOppHeader."Document No.");
                    v_LandPPRDocumentList.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                    IF NOT v_LandPPRDocumentList.FINDFIRST THEN BEGIN
                        LandPPRDocumentList.RESET;
                        LandPPRDocumentList.SETRANGE("Document No.", v_LandLeadOppHeader."Lead Document No.");
                        LandPPRDocumentList.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                        IF LandPPRDocumentList.FINDSET THEN BEGIN
                            v_LandPPRDocumentList.INIT;
                            v_LandPPRDocumentList.TRANSFERFIELDS(LandPPRDocumentList);
                            v_LandPPRDocumentList."Document No." := v_LandLeadOppHeader."Document No.";
                            v_LandPPRDocumentList.INSERT;
                        END;
                    END;

                    //-----------Insert R-2 Check list END

                    //--------Insert R-1 Check list START
                    v_LandPPRDocumentList_1.RESET;
                    v_LandPPRDocumentList_1.SETRANGE("Document No.", v_LandLeadOppHeader."Document No.");
                    v_LandPPRDocumentList_1.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                    IF NOT v_LandPPRDocumentList_1.FINDFIRST THEN BEGIN
                        LandPPRDocumentList_1.RESET;
                        LandPPRDocumentList_1.SETRANGE("Document No.", v_LandLeadOppHeader."Lead Document No.");
                        LandPPRDocumentList_1.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                        IF LandPPRDocumentList_1.FINDSET THEN BEGIN
                            v_LandPPRDocumentList_1.INIT;
                            v_LandPPRDocumentList_1.TRANSFERFIELDS(LandPPRDocumentList_1);
                            v_LandPPRDocumentList_1."Document No." := v_LandLeadOppHeader."Document No.";
                            v_LandPPRDocumentList_1.INSERT;
                        END;
                    END;
                    //--------Insert R-1 Check list END
                    DocumentSetup.GET;
                    OldDocument.RESET;
                    OldDocument.SETRANGE("Document No.", v_LandLeadOppHeader."Lead Document No.");
                    OldDocument.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                    IF OldDocument.FINDSET THEN
                        REPEAT

                            RecDocument.RESET;
                            RecDocument.INIT;
                            RecDocument."Document Type" := OldDocument."Document Type";
                            RecDocument."No." := NoSeriesManagement.GetNextNo(DocumentSetup."Document Nos.", TODAY, TRUE);
                            RecDocument."Document No." := v_LandLeadOppHeader."Document No.";
                            RecDocument."Document Line No." := OldDocument."Document Line No.";
                            RecDocument."Line No." := OldDocument."Line No.";
                            RecDocument."Table No." := OldDocument."Table No.";
                            RecDocument."Reference No. 1" := OldDocument."Reference No. 1";
                            RecDocument."Reference No. 2" := OldDocument."Reference No. 2";
                            RecDocument."Reference No. 3" := OldDocument."Reference No. 3";
                            RecDocument."Template Name" := OldDocument."Template Name";
                            RecDocument.Description := OldDocument.Description;
                            RecDocument.Content := OldDocument.Content;
                            RecDocument."File Extension" := OldDocument."File Extension";
                            RecDocument."In Use By" := OldDocument."In Use By";
                            RecDocument.Special := OldDocument.Special;
                            RecDocument."Document Import Date" := OldDocument."Document Import Date";
                            RecDocument.Category := OldDocument.Category;
                            RecDocument.Indexed := OldDocument.Indexed;
                            RecDocument.GUID := OldDocument.GUID;
                            RecDocument."Import Path" := OldDocument."Import Path";
                            RecDocument."Description 2" := OldDocument."Description 2";
                            RecDocument."Document Import By" := OldDocument."Document Import By";
                            RecDocument."Document Import Time" := OldDocument."Document Import Time";
                            RecDocument."Table Name" := OldDocument."Table Name";

                            RecDocument."Attachment Type" := OldDocument."Attachment Type";
                            RecDocument.Applicable := OldDocument.Applicable;

                            RecDocument.INSERT;
                        UNTIL OldDocument.NEXT = 0;
                UNTIL LandLeadOppLine.NEXT = 0;
        END;
    end;
}

