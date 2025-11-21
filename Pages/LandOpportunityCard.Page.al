page 60670 "Land Opportunity Card"
{
    // ALLESSS 21/02/24 : Adedd Field "Joint Venture" for Project Accounting Joint Venture Functionality.

    PageType = Document;
    SourceTable = "Land Lead/Opp Header";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Agreement Document No."; Rec."Agreement Document No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Lead Document No."; Rec."Lead Document No.")
                {

                    trigger OnValidate()
                    begin
                        // IF (xRec."Lead Document No." <> Rec."Lead Document No.") AND (xRec."Lead Document No."<>'') THEN
                        //  BEGIN
                        //    DeleteAttachDocument(Rec."Document No.");
                        //  END;
                        //
                        // InsertAttachDocument(Rec."Lead Document No.");
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    Visible = false;
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field("Village Name"; Rec."Village Name")
                {
                }
                field("Mandalam Name"; Rec."Mandalam Name")
                {
                }
                field(City; Rec.City)
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("State Code"; Rec."State Code")
                {
                }
                field("Sale Deed No."; Rec."Sale Deed No.")
                {
                    Visible = false;
                }
                field("Date of Registration"; Rec."Date of Registration")
                {
                    Visible = false;
                }
                field("Area in Acres"; Rec."Area in Acres")
                {
                }
                field("Area in Guntas"; Rec."Area in Guntas")
                {
                }
                field("Area in Cents"; Rec."Area in Cents")
                {
                }
                field("Area in Sq. Yard"; Rec."Area in Sq. Yard")
                {
                }
                field("Total Value"; Rec."Total Value")
                {
                }
                field("Total Expense Value"; Rec."Total Expense Value")
                {
                    Visible = false;
                }
                field("Total Refund Value"; Rec."Total Refund Value")
                {
                    Visible = false;
                }
                field("Balance Value"; Rec."Total Value" + Rec."Total Expense Value" + Rec."Total Refund Value")
                {
                    Visible = false;
                }
                field("Joint Venture"; Rec."Joint Venture")
                {
                    Editable = false;
                }
            }
            part("1"; "Land Opportunity Sub Page")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No.");
            }
            part("Land Vendor Refund Entries"; "Land Vendor Receipt Payment")
            {
                Caption = 'Land Vendor Payment / Refund Entries';
                Provider = "1";
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Document Line No." = FIELD("Line No.");
            }
            part("Land Expense"; "Land Agreement Expens SubPage")
            {
                Provider = "1";
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Document Line No." = FIELD("Line No.");
            }
            part("Posted Land Vendor Payment/Ref"; "Posted Land Vendor Payment/Ref")
            {
                Caption = 'Posted Land Vendor Payment/Refund';
                Provider = "1";
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                "Document Line No." = FIELD("Line No.");
            }
            part("Posted Land Expense"; "Posted Land Expens SubPage")
            {
                Provider = "1";
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Document Line No." = FIELD("Line No.");
                SubPageView = SORTING("Document No.", "Line No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(InsertLines)
                {
                    Caption = 'Insert Lines';

                    trigger OnAction()
                    begin
                        LandLeadOppHeader.GET(Rec."Document Type", Rec."Document No.");

                        v_LandLeadOppLine.RESET;
                        v_LandLeadOppLine.SETRANGE("Document Type", v_LandLeadOppLine."Document Type"::Lead);
                        v_LandLeadOppLine.SETRANGE("Document No.", Rec."Lead Document No.");
                        v_LandLeadOppLine.SETRANGE("Approval Status", v_LandLeadOppLine."Approval Status"::Approved);
                        v_LandLeadOppLine.SETRANGE("Line Status", v_LandLeadOppLine."Line Status"::Open);
                        v_LandLeadOppLine.SETRANGE("Lead Status", v_LandLeadOppLine."Lead Status"::Completed);
                        v_LandLeadOppLine.CALCFIELDS("Quantity Transfered on Opp");
                        v_LandLeadOppLine.SETRANGE("Quantity Transfered on Opp", 0);
                        CLEAR(GetLandLead);
                        GetLandLead.SETTABLEVIEW(v_LandLeadOppLine);
                        GetLandLead.LOOKUPMODE := TRUE;
                        GetLandLead.SetLandOppHeader(LandLeadOppHeader);
                        GetLandLead.RUNMODAL;
                    end;
                }
                action(Release)
                {
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to Approve the document.') THEN BEGIN
                            Rec.Status := Rec.Status::Approved;
                            Rec.MODIFY;
                            MESSAGE('Status Approved');
                        END;
                    end;
                }
                action("Re-Open")
                {
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to Re-Open the document.') THEN BEGIN
                            IF Rec."Lead Status" = Rec."Lead Status"::Completed THEN
                                ERROR('Document already Won Stage');
                            Rec.Status := Rec.Status::Open;
                            Rec.MODIFY;
                            MESSAGE('Status Re-Open');
                        END;
                    end;
                }
                action("Change Opportunity Status")
                {
                    Visible = false;

                    trigger OnAction()
                    var
                        LandLeadOppLine: Record "Land Lead/Opp Line";
                        LandLeadOppHeader: Record "Land Lead/Opp Header";
                        LandAgreementHeader: Record "Land Agreement Header";
                    begin
                        /*
                        LandAgreementHeader.RESET;
                        LandAgreementHeader.SETRANGE("Opportunity Document No.","Document No.");
                        IF LandAgreementHeader.FINDFIRST THEN
                          ERROR('Land Agreement already created with Document No.-'+LandAgreementHeader."Document No.");
                          Selection := STRMENU(Text002);
                          IF Selection = 1 THEN
                            "Lead Status" := "Lead Status"::Cancelled;
                          IF Selection = 2 THEN
                            "Lead Status" := "Lead Status"::Completed;
                          IF Selection = 3 THEN
                            "Lead Status" := "Lead Status"::"Under-Process";
                          MODIFY;
                          LandLeadOppLine.RESET;
                          LandLeadOppLine.SETRANGE("Document Type","Document Type");
                          LandLeadOppLine.SETRANGE("Document No.","Document No.");
                          LandLeadOppLine.SETRANGE("Lead Status",LandLeadOppLine."Lead Status"::" ");
                          IF LandLeadOppLine.FINDSET THEN
                            REPEAT
                              LandLeadOppLine."Lead Status" := "Lead Status";
                              LandLeadOppLine.MODIFY;
                            UNTIL LandLeadOppLine.NEXT = 0;
                          MESSAGE('%1','Opportunity Status Changed');
                          */

                    end;
                }
                action("Land Payment Milestone")
                {
                    RunObject = Page "Land Payment Milestone";
                    RunPageLink = "Land Document No." = FIELD("Document No."),
                                  "Vendor No." = CONST('');
                    Visible = false;
                }
                action("Create Land Item")
                {
                    Visible = false;

                    trigger OnAction()
                    var
                        Item: Record Item;
                    begin

                        Rec.TESTFIELD("Land Item No.", '');

                        IF CONFIRM('Do you want to create Item') THEN BEGIN
                            Item.INIT;
                            Item.INSERT(TRUE);
                            Item."Land Item" := TRUE;
                            Item.MODIFY;

                            Rec."Land Item No." := Item."No.";
                            Rec.MODIFY;
                            MESSAGE('%1', 'Item Create with No. -' + Item."No.");
                        END;
                    end;
                }
                action("Create PO")
                {
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Land Item No.");
                        Rec.TESTFIELD("Location Code");
                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        GeneralLedgerSetup.GET;
                        GeneralLedgerSetup.TESTFIELD(GeneralLedgerSetup."Shortcut Dimension 5 Code");

                        Item.GET(Rec."Land Item No.");
                        Item.TESTFIELD("Gen. Prod. Posting Group");
                        Item.TESTFIELD("Inventory Posting Group");
                        Item.TESTFIELD("Global Dimension 2 Code");
                        LandDocumentMasterLine.RESET;
                        LandDocumentMasterLine.SETRANGE("Document No.", Rec."Document No.");
                        LandDocumentMasterLine.SETFILTER("Vendor Code", '<>%1', '');
                        LandDocumentMasterLine.SETFILTER("Land Value", '<>%1', 0);
                        IF NOT LandDocumentMasterLine.FINDFIRST THEN
                            ERROR('Detail not find');
                        IF CONFIRM('Do you want to create Purchase Order') THEN BEGIN
                            LandDocumentMasterLine.RESET;
                            LandDocumentMasterLine.SETRANGE("Document No.", Rec."Document No.");
                            LandDocumentMasterLine.SETFILTER("Vendor Code", '<>%1', '');
                            LandDocumentMasterLine.SETFILTER("Land Value", '<>%1', 0);
                            LandDocumentMasterLine.SETFILTER(Area, '<>%1', 0);
                            IF LandDocumentMasterLine.FINDSET THEN BEGIN
                                REPEAT
                                    LandDocumentMasterLine.CALCFIELDS("PO No.");
                                    IF LandDocumentMasterLine."PO No." = '' THEN
                                        CreatePO(LandDocumentMasterLine);
                                UNTIL LandDocumentMasterLine.NEXT = 0;
                                MESSAGE('%1', 'Process done');
                            END;
                        END;
                    end;
                }
                action("&Attach Documents")
                {
                    Caption = '&Attach Documents';
                    RunObject = Page Documents;
                    RunPageLink = "Table No." = CONST(50054),
                                  "Document No." = FIELD("Document No.");
                }
                action("Insert Document Check List")
                {
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to insert Check List') THEN BEGIN
                            LandMasterCheckList.RESET;
                            LandMasterCheckList.SETRANGE("Master Setup", TRUE);
                            IF LandMasterCheckList.FINDSET THEN BEGIN
                                REPEAT
                                    IF NOT ExistLandMasterCheckList.GET(Rec."Document No.", LandMasterCheckList."Line No.") THEN BEGIN
                                        NewLandMasterCheckList.INIT;
                                        NewLandMasterCheckList.TRANSFERFIELDS(LandMasterCheckList);
                                        NewLandMasterCheckList."Document No." := Rec."Document No.";
                                        NewLandMasterCheckList."Master Setup" := FALSE;
                                        NewLandMasterCheckList."Table No." := 50054;
                                        NewLandMasterCheckList.INSERT;
                                    END;
                                UNTIL LandMasterCheckList.NEXT = 0;
                            END ELSE
                                ERROR('Check list master not found');
                        END ELSE
                            ERROR('Nothing to Insert');
                    end;
                }
                action("&Check List")
                {
                    Caption = '&Check List';
                    RunObject = Page "Land Agreement Check List";
                    RunPageLink = "Table No." = CONST(50054),
                                  "Document No." = FIELD("Document No.");
                    Visible = false;
                }
                action(CalculateArea)
                {

                    trigger OnAction()
                    begin
                        Rec.CalculatesArea(Rec);
                    end;
                }
                action("Sent For Approval")
                {
                    Image = SendApprovalRequest;
                    Visible = false;

                    trigger OnAction()
                    var
                        LandLeadOppLine: Record "Land Lead/Opp Line";
                    begin
                        Rec.CalculatesArea(Rec);
                        COMMIT;


                        BBGSetups.GET;
                        IF CONFIRM('Do you want to Send this Document for Approval') THEN BEGIN
                            IF Rec."Approval Status" = Rec."Approval Status"::Rejected THEN
                                ERROR('Document already Rejected')
                            ELSE IF Rec."Approval Status" = Rec."Approval Status"::Approved THEN
                                ERROR('Document already approved.');

                            LandLeadOppLine.RESET;
                            LandLeadOppLine.SETRANGE("Document Type", Rec."Document Type");
                            LandLeadOppLine.SETRANGE("Document No.", Rec."Document No.");
                            IF LandLeadOppLine.FINDSET THEN
                                REPEAT
                                    IF LandLeadOppLine."Vendor Code" <> '' THEN BEGIN
                                        IF LandLeadOppLine."Land Type" = LandLeadOppLine."Land Type"::" " THEN
                                            ERROR('Land Type is mandotary. Document No. %1 Line No. %2', LandLeadOppLine."Document No.", LandLeadOppLine."Line No.");
                                        IF LandLeadOppLine."Unit of Measure Code" = '' THEN
                                            ERROR('Unit of Measure code can not be blank is mandotary. Document No. %1 Line No. %2', LandLeadOppLine."Document No.", LandLeadOppLine."Line No.");
                                    END;
                                UNTIL LandLeadOppLine.NEXT = 0;
                            Rec."Approval Status" := Rec."Approval Status"::"Pending For Approval";
                            Rec."Pending From USER ID" := BBGSetups."Lead Approver 1";
                            MESSAGE('Document under Pending for Approval');
                        END;
                    end;
                }
                action(Approve)
                {
                    Image = Approve;
                    Visible = false;

                    trigger OnAction()
                    var
                        LandLeadOppLine: Record "Land Lead/Opp Line";
                    begin
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::"Pending For Approval");

                        IF CONFIRM('Do you want to Approve this Document') THEN BEGIN
                            BBGSetups.GET();

                            IF USERID = BBGSetups."Oppurtinity Approver 1" THEN BEGIN
                                Rec."Approval Status" := Rec."Approval Status"::"Pending For Approval";
                                Rec."Pending From USER ID" := BBGSetups."Oppurtinity Approver 2";
                                MESSAGE('Document under Pending for Approval');
                            END ELSE IF BBGSetups."Oppurtinity Approver 2" <> Rec."Pending From USER ID" THEN
                                    ERROR('Approver 1 must approve');

                            IF USERID = BBGSetups."Oppurtinity Approver 2" THEN BEGIN
                                Rec."Approval Status" := Rec."Approval Status"::Approved;
                                Rec."Pending From USER ID" := '';

                                MESSAGE('Document Approved');
                            END;


                        END;
                    end;
                }
                action("Re-Open Requst")
                {
                    Image = Cancel;
                    Visible = false;

                    trigger OnAction()
                    var
                        LandLeadOppLine: Record "Land Lead/Opp Line";
                    begin
                        IF Rec."Approval Status" = Rec."Approval Status"::Open THEN
                            ERROR('Document is already open');

                        IF CONFIRM('Do you want to Re-Open this Document') THEN BEGIN
                            Rec."Approval Status" := Rec."Approval Status"::Open;
                            Rec."Pending From USER ID" := '';

                            MESSAGE('Document Open');
                        END;
                    end;
                }
                action(Reject)
                {
                    Image = Reject;
                    Visible = false;

                    trigger OnAction()
                    var
                        CommentLine: Record "Comment Line";
                    begin
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::"Pending For Approval");
                        IF CONFIRM('Do you want to Reject this Document') THEN BEGIN
                            IF Rec."Approval Status" = Rec."Approval Status"::Approved THEN
                                ERROR('Document already approved.');
                            IF Rec."Pending From USER ID" <> '' THEN
                                IF USERID <> Rec."Pending From USER ID" THEN
                                    ERROR('This user - ' + Rec."Pending From USER ID" + ' can only Reject this Document');
                            CommentLine.RESET;
                            CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::"G/L Entry");
                            CommentLine.SETRANGE("No.", Rec."Document No.");
                            CommentLine.SETRANGE("Creation Date", TODAY);
                            CommentLine.SETRANGE("User ID", USERID);
                            IF NOT CommentLine.FINDFIRST THEN
                                ERROR('Please Enter the Comments');


                            IF Rec."Approval Status" = Rec."Approval Status"::"Pending For Approval" THEN BEGIN
                                Rec."Approval Status" := Rec."Approval Status"::Rejected;
                                Rec."Pending From USER ID" := '';
                                MESSAGE('Document Rejected');
                            END;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Document Type" := Rec."Document Type"::Opportunity;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Type" := Rec."Document Type"::Opportunity;
    end;

    var
        LandDocumentMasterLine: Record "Land Agreement Line";
        EntryExists: Boolean;
        Item: Record Item;
        LandMasterCheckList: Record "Land Agreement Check List";
        NewLandMasterCheckList: Record "Land Agreement Check List";
        ExistLandMasterCheckList: Record "Land Agreement Check List";
        GeneralLedgerSetup: Record "General Ledger Setup";
        Selection: Integer;
        Text002: Label '&Cancelled,&Completed,&Under-Process';
        LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        RecLandPPRDocument: Record "Land R-2 PPR  Document List";
        BBGSetups: Record "BBG Setups";
        AfterApprovedEditableFalse: Boolean;
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        v_LandLeadOppLine: Record "Land Lead/Opp Line";
        GetLandLead: Page "Get Land Lead";

    local procedure CreatePO(P_LandDocumentMasterLine: Record "Land Agreement Line")
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        V_PurchaseLine: Record "Purchase Line";
    begin
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader."Sub Document Type" := PurchaseHeader."Sub Document Type"::"Direct PO";
        PurchaseHeader."Workflow Sub Document Type" := PurchaseHeader."Workflow Sub Document Type"::Direct;
        PurchaseHeader."No." := '';
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader.Initiator := USERID;
        PurchaseHeader."Initiator User ID" := USERID;
        PurchaseHeader."User ID" := USERID;
        PurchaseHeader."Land Document No." := P_LandDocumentMasterLine."Document No.";
        PurchaseHeader.VALIDATE("Buy-from Vendor No.", P_LandDocumentMasterLine."Vendor Code");
        PurchaseHeader.VALIDATE("Posting Date", TODAY);
        PurchaseHeader.VALIDATE("Location Code", Rec."Location Code");
        PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        PurchaseHeader."Job No." := Rec."Shortcut Dimension 1 Code";
        PurchaseHeader."Responsibility Center" := Rec."Shortcut Dimension 1 Code";
        PurchaseHeader."Assigned User ID" := USERID;
        PurchaseHeader.ValidateShortcutDimCode(5, P_LandDocumentMasterLine."Document No.");
        PurchaseHeader.MODIFY;


        V_PurchaseLine.RESET;
        V_PurchaseLine.SETRANGE("Document Type", V_PurchaseLine."Document Type"::Order);
        V_PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF V_PurchaseLine.FINDFIRST THEN
            EntryExists := TRUE;

        IF NOT EntryExists THEN
            PurchaseLine.INIT;
        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := 10000;
        IF NOT EntryExists THEN
            PurchaseLine.INSERT;
        PurchaseLine.VALIDATE(Type, PurchaseLine.Type::Item);
        PurchaseLine.VALIDATE("No.", Rec."Land Item No.");
        PurchaseLine.VALIDATE(Quantity, P_LandDocumentMasterLine.Area);
        PurchaseLine.VALIDATE("Direct Unit Cost", ROUND((P_LandDocumentMasterLine."Land Value" / P_LandDocumentMasterLine.Area), 0.01, '='));
        PurchaseLine."Land Agreement Line No." := P_LandDocumentMasterLine."Line No.";
        PurchaseLine."Land Agreement No." := P_LandDocumentMasterLine."Document No.";
        PurchaseLine.MODIFY;
    end;

    local procedure InsertAttachDocument(LeadDocNo: Code[20])
    var
        Document: Record Document;
        CreateDocument: Record Document;
    begin
        Document.RESET;
        Document.SETRANGE("Table No.", 50054);
        Document.SETRANGE("Document No.", LeadDocNo);
        IF Document.FINDSET THEN
            REPEAT
                CreateDocument.INIT;
                CreateDocument.TRANSFERFIELDS(Document);
                CreateDocument."No." := '';
                CreateDocument.SetupNew;
                CreateDocument."Document No." := Rec."Document No.";
                CreateDocument.INSERT;
            UNTIL Document.NEXT = 0;
    end;

    local procedure DeleteAttachDocument(DeleteLeadNo: Code[20])
    var
        Document: Record Document;
    begin
        Document.RESET;
        Document.SETRANGE("Table No.", 50054);
        Document.SETRANGE("Document No.", DeleteLeadNo);
        IF Document.FINDSET THEN
            REPEAT
                Document.DELETE;
            UNTIL Document.NEXT = 0;
    end;
}

