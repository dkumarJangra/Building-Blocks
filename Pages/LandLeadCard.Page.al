page 60667 "Land Lead Card"
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
                Editable = EditSubForm;
                field("Document No."; Rec."Document No.")
                {
                    Editable = AfterApprovedEditableFalse;
                }
                field("Creation Date"; Rec."Creation Date")
                {
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
                    Editable = AfterApprovedEditableFalse;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Visible = false;
                }
                field("Pending From USER ID"; Rec."Pending From USER ID")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Lead Status"; Rec."Lead Status")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Village Name"; Rec."Village Name")
                {
                    Editable = AfterApprovedEditableFalse;
                }
                field("Mandalam Name"; Rec."Mandalam Name")
                {
                    Editable = AfterApprovedEditableFalse;
                }
                field(City; Rec.City)
                {
                    Editable = AfterApprovedEditableFalse;
                }
                field("Post Code"; Rec."Post Code")
                {
                    Editable = AfterApprovedEditableFalse;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("State Code"; Rec."State Code")
                {
                    Editable = AfterApprovedEditableFalse;
                }
                field("Opportunity Document No."; Rec."Opportunity Document No.")
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
                field("Land Item No."; Rec."Land Item No.")
                {
                    Visible = false;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    Editable = false;
                }
                field("Area in Acres"; Rec."Area in Acres")
                {
                }
                field("Area in Guntas"; Rec."Area in Guntas")
                {
                }
                field("Area in Ankanan"; Rec."Area in Ankanan")
                {
                    Visible = false;
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
                }
            }
            part("1"; "Land Lead Sub Page")
            {
                Editable = EditSubForm;
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
                SubPageView = SORTING("Document Type", "Document No.", "Document Line No.", "Line No.");
            }
            part("Land Expense"; "Land Agreement Expens SubPage")
            {
                Provider = "1";
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                "Document Line No." = FIELD("Line No.");
                SubPageView = SORTING("Document No.", "Line No.");
            }
            part("Posted Land Vendor Payment/Ref"; "Posted Land Vendor Payment/Ref")
            {
                Caption = 'Posted Land Vendor Payment/Ref';
                Provider = "1";
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                "Document Line No." = FIELD("Line No.");
                SubPageView = SORTING("Document Type", "Document No.", "Document Line No.", "Line No.");
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
                action(CalculateArea)
                {

                    trigger OnAction()
                    begin
                        Rec.CalculatesArea(Rec);
                    end;
                }
                action(Release)
                {
                    Visible = false;

                    trigger OnAction()
                    var
                        LandLeadOppLine: Record "Land Lead/Opp Line";
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
                    var
                        LandLeadOppLine: Record "Land Lead/Opp Line";
                    begin
                        IF CONFIRM('Do you want to Re-Open the document.') THEN BEGIN
                            IF Rec."Lead Status" = Rec."Lead Status"::Completed THEN
                                ERROR('Document already Completed Stage');
                            Rec.Status := Rec.Status::Open;
                            Rec.MODIFY;

                            MESSAGE('Status Re-Open');
                        END;
                    end;
                }
                action("Change Lead Status")
                {
                    Visible = false;

                    trigger OnAction()
                    var
                        LandLeadOppLine: Record "Land Lead/Opp Line";
                        LandLeadOppHeader: Record "Land Lead/Opp Header";
                    begin
                        LandLeadOppHeader.RESET;
                        LandLeadOppHeader.SETCURRENTKEY("Lead Document No.");
                        LandLeadOppHeader.SETRANGE("Lead Document No.", Rec."Document No.");
                        IF LandLeadOppHeader.FINDFIRST THEN
                            ERROR('Land Opportunity already created against this document');

                        Selection := STRMENU(Text002);
                        IF Selection <> 0 THEN BEGIN
                            IF Selection = 1 THEN
                                Rec."Lead Status" := Rec."Lead Status"::Cancelled;
                            IF Selection = 2 THEN BEGIN
                                IF Rec.Status = Rec.Status::Approved THEN
                                    Rec."Lead Status" := Rec."Lead Status"::Completed
                                ELSE
                                    ERROR('Status must be Approved');
                            END;
                            IF Selection = 3 THEN
                                Rec."Lead Status" := Rec."Lead Status"::"Under-Process";
                            Rec.MODIFY;
                            LandLeadOppLine.RESET;
                            LandLeadOppLine.SETRANGE("Document Type", Rec."Document Type");
                            LandLeadOppLine.SETRANGE("Document No.", Rec."Document No.");
                            LandLeadOppLine.SETRANGE("Line Status", LandLeadOppLine."Line Status"::Open);
                            // LandLeadOppLine.SETRANGE("Lead Status",LandLeadOppLine."Lead Status"::" ");
                            IF LandLeadOppLine.FINDSET THEN
                                REPEAT
                                    LandLeadOppLine."Lead Status" := Rec."Lead Status";
                                    LandLeadOppLine.MODIFY;
                                UNTIL LandLeadOppLine.NEXT = 0;
                            MESSAGE('%1', 'Lead Status Changed');
                        END;
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
                    Visible = false;
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
                action("Sent For Approval")
                {
                    Image = SendApprovalRequest;
                    Visible = false;

                    trigger OnAction()
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

                            IF USERID = BBGSetups."Lead Approver 1" THEN BEGIN
                                Rec."Approval Status" := Rec."Approval Status"::"Pending For Approval";
                                Rec."Pending From USER ID" := BBGSetups."Lead Approver 2";
                                MESSAGE('Document under Pending for Approval');
                            END ELSE IF BBGSetups."Lead Approver 2" <> Rec."Pending From USER ID" THEN
                                    ERROR('Approver 1 must approve');

                            IF USERID = BBGSetups."Lead Approver 2" THEN BEGIN
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
                    begin

                        IF Rec."Approval Status" = Rec."Approval Status"::Open THEN
                            ERROR('Document is already open');

                        IF CONFIRM('Do you want to Re-open Request') THEN BEGIN
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

    trigger OnAfterGetCurrRecord()
    begin
        IF Rec.Status = Rec.Status::Approved THEN
            EditSubForm := FALSE
        ELSE
            EditSubForm := TRUE;

        IF Rec."Approval Status" <> Rec."Approval Status"::Open THEN
            AfterApprovedEditableFalse := FALSE
        ELSE
            AfterApprovedEditableFalse := TRUE;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec."Approval Status" <> Rec."Approval Status"::Open THEN
            AfterApprovedEditableFalse := FALSE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Document Type" := Rec."Document Type"::Lead;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Document Type" := Rec."Document Type"::Lead;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        IF Rec."Approval Status" <> Rec."Approval Status"::Open THEN
            AfterApprovedEditableFalse := FALSE;
    end;

    trigger OnOpenPage()
    begin
        EditSubForm := TRUE;
        AfterApprovedEditableFalse := TRUE;

        IF Rec."Approval Status" <> Rec."Approval Status"::Open THEN
            AfterApprovedEditableFalse := FALSE;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        /*LandLeadOppLine.RESET;
        LandLeadOppLine.SETRANGE("Document Type",Rec."Document Type");
        LandLeadOppLine.SETRANGE("Document No.",Rec."Document No.");
        IF LandLeadOppLine.FINDSET THEN
          REPEAT
            IF LandLeadOppLine."Vendor Code" <> '' THEN BEGIN
              IF LandLeadOppLine."Land Type" = LandLeadOppLine."Land Type"::" " THEN
                ERROR('Land Type is mandotary. Document No. %1 Line No. %2',LandLeadOppLine."Document No.",LandLeadOppLine."Line No.");
              IF LandLeadOppLine."Unit of Measure Code" = '' THEN
                ERROR('Unit of Measure code can not be blank is mandotary. Document No. %1 Line No. %2',LandLeadOppLine."Document No.",LandLeadOppLine."Line No.");
            END;
          UNTIL LandLeadOppLine.NEXT=0;
          */

    end;

    var
        LandDocumentMasterLine: Record "Land Agreement Line";
        EntryExists: Boolean;
        Item: Record Item;
        LandMasterCheckList: Record "Land Agreement Check List";
        NewLandMasterCheckList: Record "Land Agreement Check List";
        ExistLandMasterCheckList: Record "Land Agreement Check List";
        GeneralLedgerSetup: Record "General Ledger Setup";
        Text002: Label '&Cancelled,&Completed,&Under-Process';
        Selection: Integer;
        LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        RecLandPPRDocument: Record "Land R-2 PPR  Document List";
        EditSubForm: Boolean;
        LandLeadOppLine: Record "Land Lead/Opp Line";
        BBGSetups: Record "BBG Setups";
        AfterApprovedEditableFalse: Boolean;

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
}

