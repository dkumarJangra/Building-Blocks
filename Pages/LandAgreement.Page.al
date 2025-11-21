page 50156 "Land Agreement"
{
    // ALLESSS 16/02/24 : Field added "Joint Venture" for Project Accounting, and added its related code
    // ALLESSS 18/03/24 : Added code to update "Quantity For PO" in CreatePO function

    PageType = Document;
    SourceTable = "Land Agreement Header";
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
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                }
                field("Opportunity Document No."; Rec."Opportunity Document No.")
                {
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
                field("Pending From USER ID"; Rec."Pending From USER ID")
                {
                    Visible = false;
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
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
                field("Date of Registration"; Rec."Date of Registration")
                {
                }
                field("Total Value"; Rec."Total Value")
                {
                    Caption = 'Total Project Cost - Direct';
                }
                field("Total Expense Value"; Rec."Total Expense Value")
                {
                    Caption = 'Total Project related cost';
                }
                field("Total Value + Total Expense Value"; Rec."Total Value" + Rec."Total Expense Value")
                {
                    Caption = 'Total Project Cost';
                }
                field("Other Expense Amount"; Rec."Other Expense Amount")
                {
                    Caption = 'Advances paid';
                }
                field("Total Refund Value"; Rec."Total Refund Value")
                {
                    Caption = 'Project Cost paid';
                }
                field("Project related cost paid"; Rec."Project related cost paid")
                {
                }
                field("Balance Value"; Rec."Total Value" - Rec."Total Refund Value" - Rec."Other Expense Amount")
                {
                    Caption = 'Balance Project Cost to be paid';
                }
                field("Total Expense Value - Project related cost paid"; Rec."Total Expense Value" - Rec."Project related cost paid")
                {
                    Caption = 'Balance Project releated Cost to be paid';
                }
                field("Total Value- Total Refund Value - Other Expense Amount + Total Expense Value - Project related cost paid"; Rec."Total Value" - Rec."Total Refund Value" - Rec."Other Expense Amount" + Rec."Total Expense Value" - Rec."Project related cost paid")
                {
                    Caption = 'Balance Total Project Cost to be paid';
                }
                field("Joint Venture"; Rec."Joint Venture")
                {
                }
                field("FG Item No."; Rec."FG Item No.")
                {
                }
            }
            part("Land Agreement Sub Page"; "Land Agreement Sub Page")
            {
                SubPageLink = "Document No." = FIELD("Document No.");
            }
            part("Project wise Gold Proj. Setup"; "Project wise Gold Proj. Setup")
            {
                Visible = false;
            }
            part("Land Vendor Refund Entries"; "Land Vendor Receipt Payment")
            {
                Provider = "Land Agreement Sub Page";
                SubPageLink = "Document Type" = CONST(Agreement),
                              "Document No." = FIELD("Document No."),
                              "Document Line No." = FIELD("Line No.");
            }
            part("Land Expense"; "Land Agreement Expens SubPage")
            {
                Provider = "Land Agreement Sub Page";
                SubPageLink = "Document Type" = CONST(Agreement),
                              "Document No." = FIELD("Document No."),
                              "Document Line No." = FIELD("Line No.");
                SubPageView = SORTING("Document No.", "Line No.");
            }
            part("Posted Land Vendor Payment/Ref"; "Posted Land Vendor Payment/Ref")
            {
                Provider = "Land Agreement Sub Page";
                SubPageLink = "Document Type" = CONST(Agreement),
                              "Document No." = FIELD("Document No."),
                              "Document Line No." = FIELD("Line No.");
            }
            part("Posted Land Expense"; "Posted Land Expens SubPage")
            {
                Provider = "Land Agreement Sub Page";
                SubPageLink = "Document Type" = CONST(Agreement),
                              "Document No." = FIELD("Document No."),
                              "Document Line No." = FIELD("Line No.");
                SubPageView = SORTING("Document No.", "Line No.");
            }
            part("Item Revaluation (FG Item)"; "Item Revalue on FG Item")
            {
                Caption = 'Item Revaluation (FG Item)';
                SubPageLink = "Document Type" = CONST(Agreement),
                              "Document No." = FIELD("Document No.");
                SubPageView = WHERE("Document Line No." = CONST(0),
                                    "Item Revaluation Processed" = CONST(false));
            }
            part("Posted Item Revaluation (FG Item)"; "Posted Item Revalue on FG Item")
            {
                Caption = 'Posted Item Revaluation (FG Item)';
                SubPageLink = "Document Type" = CONST(Agreement),
                              "Document No." = FIELD("Document No.");
                SubPageView = WHERE("Document Line No." = CONST(0),
                                    "Item Revaluation Processed" = CONST(true));
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
                        LandAgreementHeader.GET(Rec."Document No.");

                        v_LandLeadOppLine.RESET;
                        v_LandLeadOppLine.SETRANGE("Document Type", v_LandLeadOppLine."Document Type"::Opportunity);
                        v_LandLeadOppLine.SETRANGE("Document No.", Rec."Opportunity Document No.");
                        v_LandLeadOppLine.SETRANGE("Approval Status", v_LandLeadOppLine."Approval Status"::Approved);
                        v_LandLeadOppLine.SETRANGE("Line Status", v_LandLeadOppLine."Line Status"::Open);
                        v_LandLeadOppLine.SETRANGE("Lead Status", v_LandLeadOppLine."Lead Status"::Completed);
                        v_LandLeadOppLine.CALCFIELDS("Quantity Transfered on Agremnt");
                        v_LandLeadOppLine.SETRANGE("Quantity Transfered on Agremnt", 0);
                        CLEAR(GetLandLead);
                        GetLandLead.SETTABLEVIEW(v_LandLeadOppLine);
                        GetLandLead.LOOKUPMODE := TRUE;
                        GetLandLead.SetLandOppHeader(LandAgreementHeader);
                        GetLandLead.RUNMODAL;
                    end;
                }
                action("Land Payment Milestone")
                {
                    RunObject = Page "Land Payment Milestone";
                    RunPageLink = "Land Document No." = FIELD("Document No."),
                                  "Vendor No." = CONST('');
                }
                action("Create Land Item / FG Item")
                {

                    trigger OnAction()
                    var
                        Item: Record Item;
                        InventorySetup: Record "Inventory Setup";
                        LandAgreementLine: Record "Land Agreement Line";
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                        DimMgt: Codeunit DimensionManagement;
                    begin
                        //TESTFIELD("Approval Status","Approval Status"::Approved);
                        InventorySetup.GET;
                        InventorySetup.TESTFIELD("Global Dimension 2 Code");
                        InventorySetup.TESTFIELD("Global Dimension 1 Code");
                        InventorySetup.TESTFIELD("Gen. Prod. Posting Group");
                        InventorySetup.TESTFIELD("Inventory Posting Group");
                        InventorySetup.TESTFIELD("FG Item No. Series");
                        InventorySetup.TESTFIELD("Int. Post. Group Finished Item");
                        InventorySetup.TESTFIELD("FG Item Base Unit of Measure");
                        InventorySetup.TESTFIELD("FG Item Gen.Prod. Posting Gr.");
                        InventorySetup.TESTFIELD("FG Item Global Dim. 1 Code");
                        InventorySetup.TESTFIELD("FG Item Global Dim. 2 Code");

                        //ALLESSS 21/02/24---Begin
                        IF Rec."Joint Venture" THEN BEGIN
                            InventorySetup.TESTFIELD("Item Tracking for Joint Ventur");
                            InventorySetup.TESTFIELD("Item Lot No. Series");
                        END;
                        //ALLESSS 21/02/24---End

                        IF CONFIRM('Do you want to create Item') THEN BEGIN

                            IF Rec."FG Item No." = '' THEN BEGIN
                                Item.RESET;
                                Item.INIT;

                                Item."No." := NoSeriesMgt.GetNextNo(InventorySetup."FG Item No. Series", TODAY, TRUE);
                                DimMgt.UpdateDefaultDim(
                                DATABASE::Item, Item."No.",
                                Item."Global Dimension 1 Code", Item."Global Dimension 2 Code");
                                Item."Land FG Item" := TRUE;
                                Item."Global Dimension 2 Code" := InventorySetup."FG Item Global Dim. 2 Code";
                                Item.INSERT;
                                //Item."Base Unit of Measure" := InventorySetup."FG Item Base Unit of Measure";
                                Item.VALIDATE("Base Unit of Measure", InventorySetup."FG Item Base Unit of Measure");
                                Item."Sales Unit of Measure" := InventorySetup."FG Item Base Unit of Measure";
                                Item."Purch. Unit of Measure" := InventorySetup."FG Item Base Unit of Measure";
                                Item.Description := Rec.Description;
                                Item."Gen. Prod. Posting Group" := InventorySetup."FG Item Gen.Prod. Posting Gr.";
                                Item."Inventory Posting Group" := InventorySetup."Int. Post. Group Finished Item";
                                Item.VALIDATE("Base Unit of Measure", InventorySetup."FG Item Base Unit of Measure");
                                Item."Global Dimension 1 Code" := InventorySetup."FG Item Global Dim. 1 Code";
                                Item."Lot Nos." := InventorySetup."Item Lot No. Series";
                                Item."Item Tracking Code" := InventorySetup."Item Tracking for Joint Ventur";
                                Item.MODIFY;

                                Rec."FG Item No." := Item."No.";
                                Rec.MODIFY;
                                COMMIT;
                            END;


                            LandAgreementLine.RESET;
                            LandAgreementLine.SETRANGE("Document No.", Rec."Document No.");
                            LandAgreementLine.SETRANGE("Land Item No.", '');
                            LandAgreementLine.SETFILTER(Area, '<>%1', 0);
                            LandAgreementLine.SETRANGE("Approval Status", LandAgreementLine."Approval Status"::Approved);
                            IF LandAgreementLine.FINDSET THEN BEGIN
                                REPEAT
                                    Item.INIT;
                                    InventorySetup.TESTFIELD("Item Nos.");
                                    Item."No." := NoSeriesMgt.GetNextNo(InventorySetup."Item Nos.", TODAY, TRUE);
                                    DimMgt.UpdateDefaultDim(
                                    DATABASE::Item, Item."No.",
                                    Item."Global Dimension 1 Code", Item."Global Dimension 2 Code");
                                    Item.INSERT;
                                    Item."Land Item" := TRUE;
                                    Item.Description := Rec.Description;
                                    Item.VALIDATE("Global Dimension 2 Code", InventorySetup."Global Dimension 2 Code");
                                    Item."Gen. Prod. Posting Group" := InventorySetup."Gen. Prod. Posting Group";
                                    Item."Inventory Posting Group" := InventorySetup."Inventory Posting Group";
                                    Item.VALIDATE("Base Unit of Measure", LandAgreementLine."Unit of Measure Code");
                                    //ALLESSS 21/02/24---Begin
                                    IF Rec."Joint Venture" THEN BEGIN
                                        Item.VALIDATE("Item Tracking Code", InventorySetup."Item Tracking for Joint Ventur");
                                        Item.VALIDATE("Lot Nos.", InventorySetup."Item Lot No. Series");
                                        Item.VALIDATE("Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                                    END;
                                    //ALLESSS 21/02/24---End
                                    Item.MODIFY;
                                    LandAgreementLine."Land Item No." := Item."No.";
                                    LandAgreementLine.MODIFY;
                                UNTIL LandAgreementLine.NEXT = 0;

                                MESSAGE('%1', 'Item Created');
                            END ELSE
                                MESSAGE('Nothing to create');
                        END;
                    end;
                }
                action("Create Purchase Invoice")
                {

                    trigger OnAction()
                    var
                        PurchaseInvoiceNo: Code[20];
                    begin
                        GeneralLedgerSetup.GET;
                        GeneralLedgerSetup.TESTFIELD(GeneralLedgerSetup."Shortcut Dimension 5 Code");


                        //LandDocumentMasterLine.RESET;
                        //LandDocumentMasterLine.SETRANGE("Document No.","Document No.");
                        //LandDocumentMasterLine.SETFILTER("Vendor Code",'<>%1','');
                        //LandDocumentMasterLine.SETFILTER("Land Value",'<>%1',0);
                        //LandDocumentMasterLine.SETFILTER("Quantity to PO",'<>%1',0);  //120723 Code added
                        //LandDocumentMasterLine.SETRANGE("Approval Status",LandDocumentMasterLine."Approval Status"::Approved);
                        //IF NOT LandDocumentMasterLine.FINDFIRST THEN
                        //  ERROR('Detail not find');
                        IF CONFIRM('Do you want to create Purchase Order') THEN BEGIN
                            IF Rec."Joint Venture" THEN BEGIN
                                Rec.TESTFIELD("FG Item No.");  //090524 Added new code
                                LandDocumentMasterLine.RESET;
                                LandDocumentMasterLine.SETRANGE("Document No.", Rec."Document No.");
                                LandDocumentMasterLine.SETFILTER("Vendor Code", '<>%1', '');
                                LandDocumentMasterLine.SETFILTER("Land Value", '<>%1', 0);
                                LandDocumentMasterLine.SETFILTER(Area, '<>%1', 0);
                                LandDocumentMasterLine.SETFILTER("Quantity to PO", '<>%1', 0);
                                LandDocumentMasterLine.SETRANGE("Approval Status", LandDocumentMasterLine."Approval Status"::Approved);
                                //  LandDocumentMasterLine.SETFILTER("Land Item No.",'<>%1','');
                                IF LandDocumentMasterLine.FINDSET THEN BEGIN
                                    REPEAT
                                        Item.GET(Rec."FG Item No.");
                                        Item.TESTFIELD("Gen. Prod. Posting Group");
                                        Item.TESTFIELD("Inventory Posting Group");
                                        Item.TESTFIELD("Global Dimension 2 Code");

                                        LandDocumentMasterLine.CALCFIELDS("PO No.");
                                        //      IF LandDocumentMasterLine."PO No." = '' THEN
                                        LandDocumentMasterLine.CALCFIELDS("Quantity on PO");
                                        IF (LandDocumentMasterLine."Quantity to PO" + LandDocumentMasterLine."Quantity on PO") > LandDocumentMasterLine.Area THEN
                                            ERROR('Total Pending quantity for PI is =' + FORMAT(LandDocumentMasterLine.Area - LandDocumentMasterLine."Quantity on PO"));
                                        CreatePO(LandDocumentMasterLine);
                                        LandDocumentMasterLine."Quantity to PO" := 0;

                                        LandDocumentMasterLine.MODIFY;
                                    UNTIL LandDocumentMasterLine.NEXT = 0;
                                    MESSAGE('%1', 'Process done');
                                END ELSE
                                    MESSAGE('Detail not found');
                            END ELSE BEGIN

                                LandDocumentMasterLine.RESET;
                                LandDocumentMasterLine.SETRANGE("Document No.", Rec."Document No.");
                                LandDocumentMasterLine.SETFILTER("Vendor Code", '<>%1', '');
                                LandDocumentMasterLine.SETFILTER("Land Value", '<>%1', 0);
                                LandDocumentMasterLine.SETFILTER(Area, '<>%1', 0);
                                LandDocumentMasterLine.SETFILTER("Quantity to PO", '<>%1', 0);
                                LandDocumentMasterLine.SETRANGE("Approval Status", LandDocumentMasterLine."Approval Status"::Approved);
                                LandDocumentMasterLine.SETFILTER("Land Item No.", '<>%1', '');
                                IF LandDocumentMasterLine.FINDSET THEN BEGIN
                                    REPEAT
                                        Item.GET(LandDocumentMasterLine."Land Item No.");
                                        Item.TESTFIELD("Gen. Prod. Posting Group");
                                        Item.TESTFIELD("Inventory Posting Group");
                                        Item.TESTFIELD("Global Dimension 2 Code");
                                        LandDocumentMasterLine.CALCFIELDS("PO No.");
                                        //      IF LandDocumentMasterLine."PO No." = '' THEN
                                        LandDocumentMasterLine.CALCFIELDS("Quantity on PO");
                                        IF (LandDocumentMasterLine."Quantity to PO" + LandDocumentMasterLine."Quantity on PO") > LandDocumentMasterLine.Area THEN
                                            ERROR('Total Pending quantity for PI is =' + FORMAT(LandDocumentMasterLine.Area - LandDocumentMasterLine."Quantity on PO"));
                                        CreatePO(LandDocumentMasterLine);
                                        LandDocumentMasterLine."Quantity to PO" := 0;
                                        LandDocumentMasterLine.MODIFY;
                                    UNTIL LandDocumentMasterLine.NEXT = 0;
                                    MESSAGE('%1', 'Process done');
                                END ELSE
                                    MESSAGE('Detail not found');
                            END;
                        END;
                    end;
                }
                action("Purchase Invoice Lists")
                {
                    RunObject = Page "Purchase Invoices";
                    RunPageLink = "Land Document No." = FIELD("Document No.");
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
                }
                action(CalculateArea)
                {

                    trigger OnAction()
                    begin
                        //CalculatesArea(Rec);
                    end;
                }
                action("Sent For Approval")
                {
                    Image = SendApprovalRequest;
                    Visible = false;

                    trigger OnAction()
                    var
                        LandAgreementLine: Record "Land Agreement Line";
                    begin

                        BBGSetups.GET;
                        IF CONFIRM('Do you want to Send this Document for Approval') THEN BEGIN
                            IF Rec."Approval Status" = Rec."Approval Status"::Rejected THEN
                                ERROR('Document already Rejected')
                            ELSE IF Rec."Approval Status" = Rec."Approval Status"::Approved THEN
                                ERROR('Document already approved.');

                            LandAgreementLine.RESET;
                            LandAgreementLine.SETRANGE("Document No.", Rec."Document No.");
                            IF LandAgreementLine.FINDSET THEN
                                REPEAT
                                    IF LandAgreementLine."Vendor Code" <> '' THEN BEGIN
                                        IF LandAgreementLine."Land Type" = LandAgreementLine."Land Type"::" " THEN
                                            ERROR('Land Type is mandotary. Document No. %1 Line No. %2', LandAgreementLine."Document No.", LandAgreementLine."Line No.");
                                        IF LandAgreementLine."Unit of Measure Code" = '' THEN
                                            ERROR('Unit of Measure code can not be blank is mandotary. Document No. %1 Line No. %2', LandAgreementLine."Document No.", LandAgreementLine."Line No.");
                                    END;
                                UNTIL LandAgreementLine.NEXT = 0;
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
                        LandAgreementLine: Record "Land Agreement Line";
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
                        LandAgreementLine: Record "Land Agreement Line";
                    begin
                        IF Rec."Approval Status" = Rec."Approval Status"::Open THEN
                            ERROR('Document already in Open Stage');
                        IF CONFIRM('Do you want to Re-Open the Document') THEN BEGIN
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

    var
        LandDocumentMasterLine: Record "Land Agreement Line";
        EntryExists: Boolean;
        Item: Record Item;
        LandMasterCheckList: Record "Land Agreement Check List";
        NewLandMasterCheckList: Record "Land Agreement Check List";
        ExistLandMasterCheckList: Record "Land Agreement Check List";
        GeneralLedgerSetup: Record "General Ledger Setup";
        LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        RecLandPPRDocument: Record "Land R-2 PPR  Document List";
        BBGSetups: Record "BBG Setups";
        AfterApprovedEditableFalse: Boolean;
        LandAgreementHeader: Record "Land Agreement Header";
        v_LandLeadOppLine: Record "Land Lead/Opp Line";
        GetLandLead: Page "Get Land Opportunity";

    local procedure CreatePO(P_LandDocumentMasterLine: Record "Land Agreement Line")
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        V_PurchaseLine: Record "Purchase Line";
        InventorySetup: Record "Inventory Setup";
        PaymentTermsLine: Record "Payment Terms Line";
        LandVendorPaymentTermsLine: Record "Land Vendor Payment Terms Line";
        LandAgreementLine: Record "Land Agreement Line";
        QtyToPO: Decimal;
    begin
        InventorySetup.GET;
        InventorySetup.TESTFIELD("Global Dimension 1 Code");

        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
        PurchaseHeader."Sub Document Type" := PurchaseHeader."Sub Document Type"::" ";
        PurchaseHeader."Workflow Sub Document Type" := PurchaseHeader."Workflow Sub Document Type"::Direct;
        PurchaseHeader."No." := '';
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader.Initiator := USERID;
        PurchaseHeader."Initiator User ID" := USERID;
        PurchaseHeader."User ID" := USERID;
        PurchaseHeader."Land Document No." := P_LandDocumentMasterLine."Document No.";
        PurchaseHeader."Land Agreement Doc. Line No." := P_LandDocumentMasterLine."Line No.";
        PurchaseHeader.VALIDATE("Buy-from Vendor No.", P_LandDocumentMasterLine."Vendor Code");
        PurchaseHeader.VALIDATE("Posting Date", TODAY);
        PurchaseHeader.VALIDATE("Location Code", InventorySetup."Global Dimension 1 Code");
        PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", InventorySetup."Global Dimension 1 Code");
        PurchaseHeader.VALIDATE("Shortcut Dimension 2 Code", InventorySetup."Global Dimension 2 Code");
        PurchaseHeader."Job No." := InventorySetup."Global Dimension 1 Code";
        PurchaseHeader."Responsibility Center" := InventorySetup."Global Dimension 1 Code";
        PurchaseHeader."Assigned User ID" := USERID;
        PurchaseHeader.ValidateShortcutDimCode(5, P_LandDocumentMasterLine."Land Document Dimension");
        PurchaseHeader."Quantity for PO" := P_LandDocumentMasterLine."Quantity to PO"; //ALLESSS 18/03/24
        PurchaseHeader.MODIFY;


        V_PurchaseLine.RESET;
        V_PurchaseLine.SETRANGE("Document Type", V_PurchaseLine."Document Type"::Invoice);
        V_PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF V_PurchaseLine.FINDFIRST THEN
            EntryExists := TRUE;

        IF NOT EntryExists THEN
            PurchaseLine.INIT;
        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Invoice;
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := 10000;
        IF NOT EntryExists THEN
            PurchaseLine.INSERT;
        PurchaseLine.VALIDATE(Type, PurchaseLine.Type::Item);
        IF Rec."Joint Venture" THEN  //090524 Added new code
            PurchaseLine.VALIDATE("No.", Rec."FG Item No.")  //090524 Added new code
        ELSE
            PurchaseLine.VALIDATE("No.", P_LandDocumentMasterLine."Land Item No.");
        PurchaseLine."Unit of Measure Code" := P_LandDocumentMasterLine."Unit of Measure Code";
        //PurchaseLine.VALIDATE(Quantity,P_LandDocumentMasterLine.Area);  //120723 Code commented
        PurchaseLine.VALIDATE("Location Code", PurchaseHeader."Location Code");
        PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", PurchaseHeader."Shortcut Dimension 1 Code");
        PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", PurchaseHeader."Shortcut Dimension 2 Code");
        PurchaseLine.VALIDATE(Quantity, P_LandDocumentMasterLine."Quantity to PO");  //120723 Code Added
        PurchaseLine.VALIDATE("Direct Unit Cost", P_LandDocumentMasterLine."Unit Price");
        PurchaseLine.ValidateShortcutDimCode(5, P_LandDocumentMasterLine."Land Document Dimension");
        PurchaseLine."Land Agreement Line No." := P_LandDocumentMasterLine."Line No.";
        PurchaseLine."Land Agreement No." := P_LandDocumentMasterLine."Document No.";
        PurchaseLine."Sale Deed No." := P_LandDocumentMasterLine."Sale Deed No.";
        PurchaseLine."Date of Registration" := P_LandDocumentMasterLine."Date of Registration";
        PurchaseLine.MODIFY;

        LandVendorPaymentTermsLine.RESET;
        LandVendorPaymentTermsLine.SETRANGE("Land Document No.", P_LandDocumentMasterLine."Document No.");
        LandVendorPaymentTermsLine.SETRANGE("Land Document Line No.", P_LandDocumentMasterLine."Line No.");
        IF LandVendorPaymentTermsLine.FINDSET THEN
            REPEAT
                PaymentTermsLine.RESET;
                PaymentTermsLine.INIT;
                PaymentTermsLine."Document Type" := PaymentTermsLine."Document Type"::Invoice;
                PaymentTermsLine."Document No." := PurchaseHeader."No.";
                PaymentTermsLine."Milestone Code" := LandVendorPaymentTermsLine."Actual Milestone";
                PaymentTermsLine."Transaction Type" := PaymentTermsLine."Transaction Type"::Purchase;
                PaymentTermsLine."Criteria Value / Base Amount" := LandVendorPaymentTermsLine."Base Amount";
                PaymentTermsLine."Calculation Type" := LandVendorPaymentTermsLine."Calculation Type";
                PaymentTermsLine."Calculation Value" := LandVendorPaymentTermsLine."Calculation Value";
                PaymentTermsLine."Due Date Calculation" := LandVendorPaymentTermsLine."Due Date Calculation";
                PaymentTermsLine."Due Amount" := LandVendorPaymentTermsLine."Due Amount";
                PaymentTermsLine."Payment Type" := LandVendorPaymentTermsLine."Payment Type";
                PaymentTermsLine."Vendor Code" := LandVendorPaymentTermsLine."Vendor No.";
                PaymentTermsLine."Payment Term Code" := LandVendorPaymentTermsLine."Payment Term Code";
                PaymentTermsLine."Due Date" := LandVendorPaymentTermsLine."Due Date";
                PaymentTermsLine.INSERT;
            UNTIL LandVendorPaymentTermsLine.NEXT = 0;
    end;
}

