page 60724 "Get Land Opportunity"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Land Lead/Opp Line";
    SourceTableView = WHERE("Document Type" = CONST(Opportunity));
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
        v_LandAgreementHdr: Record "Land Agreement Header";
        LandAgreementLine: Record "Land Agreement Line";
        LandOldDocument: Record "Land Document Attachment";
        LandDocument: Record "Land Document Attachment";
        LandAgreementHeader: Record "Land Agreement Header";
        UserSetup: Record "User Setup";
        LandVendorReceiptPayment: Record "Land Vendor Receipt Payment";
        AgreementLandVendorReceiptPayment: Record "Land Vendor Receipt Payment";


    procedure SetLandOppHeader(P_LandAgreementhdr: Record "Land Agreement Header")
    begin
        v_LandAgreementHdr := P_LandAgreementhdr;
    end;

    local procedure InsertsLines()
    var
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        LandLeadOppLine: Record "Land Lead/Opp Line";
        LandAgreementHeader: Record "Land Agreement Header";
        LandAgreementLine: Record "Land Agreement Line";
        LandVendorPaymentTermsLine: Record "Land Vendor Payment Terms Line";
        v_LandVendorPaymentTermsLine: Record "Land Vendor Payment Terms Line";
        LandAgreementExpense: Record "Land Agreement Expense";
        AgreementLandAgreementExpense: Record "Land Agreement Expense";
        LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        v_LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        LandPPRDocumentList_1: Record "Land R-1 PPR Document Lis_1";
        v_LandPPRDocumentList_1: Record "Land R-1 PPR Document Lis_1";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocumentSetup: Record "Document Setup";
    begin
        IF CONFIRM('Do you want to insert these entries') THEN BEGIN
            CurrPage.SETSELECTIONFILTER(LandLeadOppLine);
            IF LandLeadOppLine.FINDSET THEN
                REPEAT
                    LandAgreementLine.INIT;
                    LandAgreementLine."Document No." := v_LandAgreementHdr."Document No.";
                    LandAgreementLine."Line No." := LandLeadOppLine."Line No.";
                    LandAgreementLine."Vendor Code" := LandLeadOppLine."Vendor Code";
                    LandAgreementLine."Vendor Name" := LandLeadOppLine."Vendor Name";
                    LandAgreementLine."Creation Date" := TODAY;
                    LandAgreementLine."Unit of Measure Code" := LandLeadOppLine."Unit of Measure Code";
                    LandAgreementLine."Unit Price" := LandLeadOppLine."Unit Price";
                    LandAgreementLine."Land Type" := LandLeadOppLine."Land Type";
                    LandAgreementLine."Co-Ordinates" := LandLeadOppLine."Co-Ordinates";
                    LandAgreementLine.Area := LandLeadOppLine.Area;
                    LandAgreementLine."Nature of Deed" := LandLeadOppLine."Nature of Deed";
                    LandAgreementLine."Transaction Type" := LandLeadOppLine."Transaction Type";
                    LandAgreementLine."Sale Deed No." := LandLeadOppLine."Sale Deed No.";
                    LandAgreementLine."Land Value" := LandLeadOppLine."Land Value";
                    LandAgreementLine."Area in Acres" := LandLeadOppLine."Area in Acres";
                    LandAgreementLine."Area in Cents" := LandLeadOppLine."Area in Cents";
                    LandAgreementLine."Area in Ankanan" := LandLeadOppLine."Area in Ankanan";
                    LandAgreementLine."Area in Guntas" := LandLeadOppLine."Area in Guntas";
                    LandAgreementLine."Area in Sq. Yard" := LandLeadOppLine."Area in Sq. Yard";
                    LandAgreementLine."Opportunity Document No." := LandLeadOppLine."Document No.";
                    LandAgreementLine."Opportunity Document Line No." := LandLeadOppLine."Line No.";
                    LandAgreementLine."Shortcut Dimension 1 Code" := LandLeadOppLine."Shortcut Dimension 1 Code";
                    LandAgreementLine."Land Document Dimension" := LandLeadOppLine."Land Document Dimension";
                    LandAgreementLine."Date of Registration" := LandLeadOppLine."Date of Registration";
                    LandAgreementLine."Quantity in SQYD" := LandLeadOppLine."Quantity In SQYD";
                    LandAgreementLine."Approval Status" := LandAgreementLine."Approval Status"::Open;
                    LandAgreementLine."Pending From USER ID" := '';
                    LandAgreementLine.INSERT;
                    LandVendorPaymentTermsLine.RESET;
                    LandVendorPaymentTermsLine.SETRANGE("Land Document No.", v_LandAgreementHdr."Opportunity Document No.");
                    LandVendorPaymentTermsLine.SETRANGE("Land Document Line No.", LandLeadOppLine."Line No.");
                    IF LandVendorPaymentTermsLine.FINDSET THEN
                        REPEAT
                            v_LandVendorPaymentTermsLine.INIT;
                            v_LandVendorPaymentTermsLine."Land Document No." := v_LandAgreementHdr."Document No.";
                            v_LandVendorPaymentTermsLine."Vendor No." := LandVendorPaymentTermsLine."Vendor No.";
                            v_LandVendorPaymentTermsLine."Land Document Line No." := LandVendorPaymentTermsLine."Land Document Line No.";
                            v_LandVendorPaymentTermsLine."Actual Milestone" := LandVendorPaymentTermsLine."Actual Milestone";
                            v_LandVendorPaymentTermsLine."Line No." := LandVendorPaymentTermsLine."Line No.";
                            v_LandVendorPaymentTermsLine."Payment Term Code" := LandVendorPaymentTermsLine."Payment Term Code";
                            v_LandVendorPaymentTermsLine."Base Amount" := LandVendorPaymentTermsLine."Base Amount";
                            v_LandVendorPaymentTermsLine."Calculation Type" := LandVendorPaymentTermsLine."Calculation Type";
                            v_LandVendorPaymentTermsLine."Calculation Value" := LandVendorPaymentTermsLine."Calculation Value";
                            v_LandVendorPaymentTermsLine.VALIDATE("Due Date Calculation", LandVendorPaymentTermsLine."Due Date Calculation");
                            v_LandVendorPaymentTermsLine."Due Amount" := LandVendorPaymentTermsLine."Due Amount";
                            v_LandVendorPaymentTermsLine.Description := LandVendorPaymentTermsLine.Description;
                            v_LandVendorPaymentTermsLine."Payment Type" := LandVendorPaymentTermsLine."Payment Type";
                            v_LandVendorPaymentTermsLine."Fixed Amount" := LandVendorPaymentTermsLine."Fixed Amount";
                            v_LandVendorPaymentTermsLine."Balance Amount" := LandVendorPaymentTermsLine."Balance Amount";
                            v_LandVendorPaymentTermsLine."Land Value" := LandVendorPaymentTermsLine."Land Value";
                            v_LandVendorPaymentTermsLine.INSERT;
                        UNTIL LandVendorPaymentTermsLine.NEXT = 0;

                    LandAgreementExpense.RESET;
                    LandAgreementExpense.SETRANGE("Document Type", LandAgreementExpense."Document Type"::Opportunity);
                    LandAgreementExpense.SETRANGE("Document No.", v_LandAgreementHdr."Opportunity Document No.");
                    LandAgreementExpense.SETRANGE("JV Posted", TRUE);
                    LandAgreementExpense.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                    IF LandAgreementExpense.FINDSET THEN
                        REPEAT
                            AgreementLandAgreementExpense.RESET;
                            IF NOT AgreementLandAgreementExpense.GET(AgreementLandAgreementExpense."Document Type"::Agreement, v_LandAgreementHdr."Document No.", LandAgreementExpense."Document Line No.", LandAgreementExpense."Line No.") THEN BEGIN
                                AgreementLandAgreementExpense.INIT;
                                AgreementLandAgreementExpense.TRANSFERFIELDS(LandAgreementExpense);
                                AgreementLandAgreementExpense."Document Type" := AgreementLandAgreementExpense."Document Type"::Agreement;
                                AgreementLandAgreementExpense."Document No." := v_LandAgreementHdr."Document No.";
                                AgreementLandAgreementExpense.INSERT;
                            END;
                        UNTIL LandAgreementExpense.NEXT = 0;

                    //-----151123 Vendor Payment / Refund Start
                    LandVendorReceiptPayment.RESET;
                    LandVendorReceiptPayment.SETRANGE("Document Type", LandVendorReceiptPayment."Document Type"::Opportunity);
                    LandVendorReceiptPayment.SETRANGE("Document No.", v_LandAgreementHdr."Opportunity Document No.");
                    LandVendorReceiptPayment.SETRANGE(Posted, TRUE);
                    LandVendorReceiptPayment.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                    IF LandVendorReceiptPayment.FINDSET THEN
                        REPEAT
                            AgreementLandVendorReceiptPayment.RESET;
                            IF NOT AgreementLandVendorReceiptPayment.GET(AgreementLandVendorReceiptPayment."Document Type"::Agreement, v_LandAgreementHdr."Document No.", LandVendorReceiptPayment."Document Line No.", LandVendorReceiptPayment."Line No.") THEN BEGIN
                                AgreementLandVendorReceiptPayment.INIT;
                                AgreementLandVendorReceiptPayment.TRANSFERFIELDS(LandVendorReceiptPayment);
                                AgreementLandVendorReceiptPayment."Document Type" := AgreementLandVendorReceiptPayment."Document Type"::Agreement;
                                AgreementLandVendorReceiptPayment."Document No." := v_LandAgreementHdr."Document No.";
                                AgreementLandVendorReceiptPayment.INSERT;
                            END;
                        UNTIL LandVendorReceiptPayment.NEXT = 0;
                    //-----151123 Vendor Payment / Refund END


                    //-----------Insert R-1 Check list START
                    v_LandPPRDocumentList.RESET;
                    v_LandPPRDocumentList.SETRANGE("Document No.", v_LandAgreementHdr."Document No.");
                    v_LandPPRDocumentList.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                    IF NOT v_LandPPRDocumentList.FINDFIRST THEN BEGIN
                        LandPPRDocumentList.RESET;
                        LandPPRDocumentList.SETRANGE("Document No.", v_LandAgreementHdr."Opportunity Document No.");
                        LandPPRDocumentList.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                        IF LandPPRDocumentList.FINDSET THEN BEGIN
                            v_LandPPRDocumentList.INIT;
                            v_LandPPRDocumentList.TRANSFERFIELDS(LandPPRDocumentList);
                            v_LandPPRDocumentList."Document No." := v_LandAgreementHdr."Document No.";
                            v_LandPPRDocumentList.INSERT;
                        END;
                    END;

                    //-----------Insert R-2 Check list END

                    //--------Insert R-1 Check list START
                    v_LandPPRDocumentList_1.RESET;
                    v_LandPPRDocumentList_1.SETRANGE("Document No.", v_LandAgreementHdr."Document No.");
                    v_LandPPRDocumentList_1.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                    IF NOT v_LandPPRDocumentList_1.FINDFIRST THEN BEGIN
                        LandPPRDocumentList_1.RESET;
                        LandPPRDocumentList_1.SETRANGE("Document No.", v_LandAgreementHdr."Opportunity Document No.");
                        LandPPRDocumentList_1.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                        IF LandPPRDocumentList_1.FINDSET THEN BEGIN
                            v_LandPPRDocumentList_1.INIT;
                            v_LandPPRDocumentList_1.TRANSFERFIELDS(LandPPRDocumentList_1);
                            v_LandPPRDocumentList_1."Document No." := v_LandAgreementHdr."Document No.";
                            v_LandPPRDocumentList_1.INSERT;
                        END;
                    END;
                    //--------Insert R-1 Check list END
                    DocumentSetup.GET;
                    LandOldDocument.RESET;
                    LandOldDocument.SETRANGE("Document No.", v_LandAgreementHdr."Opportunity Document No.");
                    LandOldDocument.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                    IF LandOldDocument.FINDSET THEN
                        REPEAT
                            LandDocument.RESET;
                            LandDocument.INIT;
                            LandDocument."Document Type" := LandDocument."Document Type"::Document;
                            LandDocument."No." := NoSeriesManagement.GetNextNo(DocumentSetup."Document Nos.", TODAY, TRUE);
                            LandDocument."Table No." := LandOldDocument."Table No.";
                            LandDocument."Reference No. 1" := LandOldDocument."Reference No. 1";
                            LandDocument."Reference No. 2" := LandOldDocument."Reference No. 2";
                            LandDocument."Reference No. 3" := LandOldDocument."Reference No. 3";
                            LandDocument."Template Name" := LandOldDocument."Template Name";
                            LandDocument.Description := LandOldDocument.Description;
                            LandDocument.Content := LandOldDocument.Content;
                            LandDocument."File Extension" := LandOldDocument."File Extension";
                            LandDocument."In Use By" := LandOldDocument."In Use By";
                            LandDocument.Special := LandOldDocument.Special;
                            LandDocument."Document Import Date" := LandOldDocument."Document Import Date";
                            LandDocument.Category := LandOldDocument.Category;
                            LandDocument.Indexed := LandOldDocument.Indexed;
                            LandDocument.GUID := LandOldDocument.GUID;
                            LandDocument."Line No." := LandOldDocument."Line No.";
                            LandDocument."Import Path" := LandOldDocument."Import Path";
                            LandDocument."Description 2" := LandOldDocument."Description 2";
                            LandDocument."Document Import By" := LandOldDocument."Document Import By";
                            LandDocument."Document Import Time" := LandOldDocument."Document Import Time";
                            LandDocument."Table Name" := LandOldDocument."Table Name";
                            LandDocument."Document No." := v_LandAgreementHdr."Document No.";
                            LandDocument."Document Line No." := LandOldDocument."Document Line No.";
                            LandDocument."Line No." := LandOldDocument."Line No.";
                            LandDocument.INSERT;
                        UNTIL LandOldDocument.NEXT = 0;

                UNTIL LandLeadOppLine.NEXT = 0;
        END;
    end;
}

