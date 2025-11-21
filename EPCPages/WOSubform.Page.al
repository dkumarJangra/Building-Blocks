page 97750 "WO Subform"
{
    // ALLERP KRN0003 23-08-2010: Location Code control has been made editable
    // ALLERP KRN     13-09-2010: Property of Control "No." has been changed (editable-No,Enabled-yes)
    // ALLERP Allebugfix 24-11-2010: Commented Code removed

    AutoSplitKey = true;
    Caption = 'WO Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = Card;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = FILTER(Order));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {

                    trigger OnValidate()
                    begin
                        //GKG
                        IF Rec.Type = Rec.Type::"G/L Account" THEN BEGIN
                            DimVal.RESET;
                            PurchHeader.GET(Rec."Document Type"::Order, Rec."Document No.");
                            IF PurchHeader."Buy-from Vendor No." <> '' THEN BEGIN
                                DocSetup.GET(DocSetup."Document Type"::"Purchase Order", PurchHeader."Sub Document Type");
                                IF DocSetup."Control GL Account" <> '' THEN
                                    Rec.VALIDATE("No.", DocSetup."Control GL Account");
                                Rec."Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
                                Rec."Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
                                IF DocSetup."Def. Gen Prod Posting Group" <> '' THEN
                                    Rec."Gen. Prod. Posting Group" := DocSetup."Def. Gen Prod Posting Group";
                            END;
                        END;


                        //GKG
                    end;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Enabled = true;

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;
                    end;
                }
                field("Job Code"; Rec."Job Code")
                {
                }
                field("BOQ Code"; Rec."BOQ Code")
                {
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                    Visible = true;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                    Visible = true;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("Indent No"; Rec."Indent No")
                {
                }
                field("Indent Line No"; Rec."Indent Line No")
                {
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    Visible = true;
                }
                // field("Tax Base Amount"; "Tax Base Amount")
                // {
                // }
                // field("Service Tax Group"; "Service Tax Group")
                // {
                // }
                // field("Service Tax Base"; "Service Tax Base")
                // {
                // }
                field("Cross-Reference No."; Rec."Item Reference No.")
                {
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //CrossReferenceNoLookUp;
                        InsertExtendedText(FALSE);
                    end;

                    trigger OnValidate()
                    begin
                        CrossReferenceNoOnAfterValidat;
                    end;
                }
                field("IC Partner Ref. Type"; Rec."IC Partner Ref. Type")
                {
                    Visible = false;
                }
                field("IC Partner Reference"; Rec."IC Partner Reference")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field(Nonstock; Rec.Nonstock)
                {
                    Visible = false;
                }
                // field("Service Tax Registration No."; "Service Tax Registration No.")
                // {
                //     Visible = false;
                // }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Description 3"; Rec."Description 3")
                {
                }
                field("Description 4"; Rec."Description 4")
                {
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    Visible = false;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = true;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    BlankZero = true;
                }
                // field("Excise Loading on Inventory"; "Excise Loading on Inventory")
                // {
                //     Visible = false;
                // }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    BlankZero = true;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = true;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Visible = false;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    BlankZero = true;
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    BlankZero = true;
                }
                field("Invoiced Value"; Rec."Invoiced Value")
                {
                    Editable = false;
                    Enabled = true;
                }
                // field("Non ITC Claimable Usage %"; Rec."Non ITC Claimable Usage %")
                // {
                // }
                // field("Amount Loaded on Inventory"; "Amount Loaded on Inventory")
                // {
                //     Visible = false;
                // }
                // field("Input Tax Credit Amount"; "Input Tax Credit Amount")
                // {
                //     Visible = false;
                // }
                // field("VAT able Purchase Tax Amount"; "VAT able Purchase Tax Amount")
                // {
                //     Visible = false;
                // }
                // field("Assessable Value"; "Assessable Value")
                // {
                // }
                // field("Assessee Code"; "Assessee Code")
                // {
                // }
                // field("TDS Group"; "TDS Group")
                // {
                //     Editable = false;
                // }
                // field("TDS Base Amount"; "TDS Base Amount")
                // {
                // }
                field("TDS Nature of Deduction"; Rec."TDS Section Code")
                {
                }
                field("Work Tax Nature Of Deduction"; Rec."Work Tax Nature Of Deduction")
                {
                }
                // field("Service Tax Amount"; "Service Tax Amount")
                // {
                // }
                // field("Manual Work Tax"; "Manual Work Tax")
                // {
                // }
                // field("Work Tax Base Amount"; "Work Tax Base Amount")
                // {
                // }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    BlankZero = true;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    Visible = false;
                }
                // field("BED Amount"; "BED Amount")
                // {
                //     Visible = false;
                // }
                // field("eCess Amount"; "eCess Amount")
                // {
                //     Visible = false;
                // }
                // field("SHE Cess Amount"; "SHE Cess Amount")
                // {
                //     Visible = false;
                // }
                field(Supplementary; Rec.Supplementary)
                {
                    Visible = false;
                }
                field("Source Document Type"; Rec."Source Document Type")
                {
                    Visible = false;
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Inv. Discount Amount"; Rec."Inv. Discount Amount")
                {
                    Visible = false;
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    BlankZero = true;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    BlankZero = true;
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    BlankZero = true;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    BlankZero = true;
                }
                field("Allow Item Charge Assignment"; Rec."Allow Item Charge Assignment")
                {
                    Visible = false;
                }
                field("Qty. to Assign"; Rec."Qty. to Assign")
                {
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SAVERECORD;
                        Rec.ShowItemChargeAssgnt;
                        UpdatePAGE(FALSE);
                    end;
                }
                field("Qty. Assigned"; Rec."Qty. Assigned")
                {
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SAVERECORD;
                        Rec.ShowItemChargeAssgnt;
                        UpdatePAGE(FALSE);
                    end;
                }
                field("Order Date"; Rec."Order Date")
                {
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field("Planning Flexibility"; Rec."Planning Flexibility")
                {
                    Visible = false;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    Visible = false;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    Visible = false;
                }
                field("Operation No."; Rec."Operation No.")
                {
                    Visible = false;
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    Visible = false;
                }
                field(Finished; Rec.Finished)
                {
                    Visible = false;
                }
                field("Whse. Outstanding Qty. (Base)"; Rec."Whse. Outstanding Qty. (Base)")
                {
                    Visible = false;
                }
                field("Inbound Whse. Handling Time"; Rec."Inbound Whse. Handling Time")
                {
                    Visible = false;
                }
                field("Blanket Order No."; Rec."Blanket Order No.")
                {
                    Visible = false;
                }
                field("Blanket Order Line No."; Rec."Blanket Order Line No.")
                {
                    Visible = false;
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    Visible = false;
                }
                // field("Reason Code"; Rec."Reason Code")
                // {
                //     Visible = false;
                // }
                field(ShortcutDimCode_3; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        CurrPage.EDITABLE := TRUE;
        //JPL55 START
        IF PurchHeader.GET(Rec."Document Type", Rec."Document No.") THEN;
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            IF PurchHeader.Amended = FALSE THEN BEGIN
                IF PurchHeader.Approved = FALSE THEN BEGIN
                    IF PurchHeader."Sent for Approval" = FALSE THEN BEGIN

                        IF (USERID = PurchHeader.Initiator) THEN
                            CurrPage.EDITABLE := TRUE
                        ELSE
                            CurrPage.EDITABLE := FALSE;
                    END
                    ELSE BEGIN
                        DocApproval.RESET;
                        DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::"Purchase Order");
                        DocApproval.SETRANGE("Sub Document Type", PurchHeader."Sub Document Type");
                        DocApproval.SETFILTER("Document No", '%1', PurchHeader."No.");
                        DocApproval.SETRANGE(Initiator, PurchHeader.Initiator);
                        DocApproval.SETRANGE(Status, DocApproval.Status::" ");
                        IF DocApproval.FIND('-') THEN BEGIN
                            IF (DocApproval."Approvar ID" = USERID) OR (DocApproval."Alternate Approvar ID" = USERID) THEN
                                CurrPage.EDITABLE := FALSE //CurrPAGE.EDITABLE:=TRUE
                            ELSE
                                CurrPage.EDITABLE := FALSE;
                        END
                        ELSE BEGIN
                            CurrPage.EDITABLE := FALSE;
                        END;
                    END;
                END
                ELSE //10156
                    CurrPage.EDITABLE := FALSE; //ALLERP Allebugfix 24-11-2010
            END
            ELSE BEGIN
                IF PurchHeader.Amended THEN BEGIN
                    IF PurchHeader."Amendment Approved" = FALSE THEN BEGIN
                        DocApproval.RESET;
                        DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::"Purchase Order Amendment");
                        DocApproval.SETRANGE("Sub Document Type", PurchHeader."Sub Document Type");
                        DocApproval.SETFILTER("Document No", '%1', PurchHeader."No.");
                        DocApproval.SETRANGE(Initiator, PurchHeader."Amendment Initiator");
                        DocApproval.SETRANGE(Status, DocApproval.Status::" ");
                        IF DocApproval.FIND('-') THEN BEGIN
                            IF (DocApproval."Approvar ID" = USERID) OR (DocApproval."Alternate Approvar ID" = USERID)
                               OR (PurchHeader."Amendment Initiator" = USERID) THEN
                                CurrPage.EDITABLE := TRUE
                            ELSE
                                CurrPage.EDITABLE := FALSE;
                        END
                        ELSE BEGIN
                            CurrPage.EDITABLE := FALSE;
                        END;
                    END
                    ELSE
                        CurrPage.EDITABLE := FALSE;
                END;
            END;
        END;

        DepartmentName := '';
        CostCenterName := '';
        GenSetup.GET;
        IF Rec."Shortcut Dimension 1 Code" <> '' THEN BEGIN
            DimValue.GET(GenSetup."Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            CostCenterName := DimValue.Name;
        END;
        IF Rec."Shortcut Dimension 2 Code" <> '' THEN BEGIN
            DimValue.GET(GenSetup."Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
            DepartmentName := DimValue.Name;
        END;
        //JPL55 STOP
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        //JPL55
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            PurchHeader.GET(Rec."Document Type", Rec."Document No.");
            IF PurchHeader.Amended = FALSE THEN BEGIN
                PurchHeader.TESTFIELD(Approved, FALSE);
            END;
            IF PurchHeader.Amended THEN BEGIN
                PurchHeader.TESTFIELD(Approved, TRUE);
                PurchHeader.TESTFIELD("Amendment Approved", FALSE);
            END;
        END;
        //JPL05
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //JPL55
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            PurchHeader.GET(Rec."Document Type", Rec."Document No.");
            IF PurchHeader.Amended = FALSE THEN BEGIN
                PurchHeader.TESTFIELD(Approved, FALSE);
            END;
            IF PurchHeader.Amended THEN BEGIN
                PurchHeader.TESTFIELD(Approved, TRUE);
                PurchHeader.TESTFIELD("Amendment Approved", FALSE);
            END;
        END;

        CheckIndent;
        //JPL55
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := xRec.Type;
        CLEAR(ShortcutDimCode);

        //GKG
        IF Rec.Type = Rec.Type::"G/L Account" THEN BEGIN
            DimVal.RESET;
            PurchHeader.GET(Rec."Document Type"::Order, Rec."Document No.");
            IF PurchHeader."Buy-from Vendor No." <> '' THEN BEGIN
                DocSetup.GET(DocSetup."Document Type"::"Purchase Order", PurchHeader."Sub Document Type");
                IF DocSetup."Control GL Account" <> '' THEN
                    Rec.VALIDATE("No.", DocSetup."Control GL Account");
                Rec."Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
                Rec."Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
                IF DocSetup."Def. Gen Prod Posting Group" <> '' THEN
                    Rec."Gen. Prod. Posting Group" := DocSetup."Def. Gen Prod Posting Group";
            END;
        END;


        //GKG
    end;

    trigger OnOpenPage()
    begin
        GLSetup.GET;

        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'DDS-FA-FIXED ASSET');
        IF NOT MemberOf.FIND('-') THEN
            allowbudget := TRUE
        ELSE
            allowbudget := FALSE;


        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPER');
        IF MemberOf.FIND('-') THEN
            allowbudget := FALSE;
    end;

    var
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ShortcutDimCode: array[8] of Code[20];
        GLBudgetName: Record "G/L Budget Name";
        GLBudgetEntry: Record "G/L Budget Entry";
        IndentLine: Record "Purchase Request Line";
        PurchHeader: Record "Purchase Header";
        DimVal: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        DocSetup: Record "Document Type Setup";
        DocApproval: Record "Document Type Approval";
        DepartmentName: Text[50];
        CostCenterName: Text[50];
        DimValue: Record "Dimension Value";
        GenSetup: Record "General Ledger Setup";
        allowbudget: Boolean;
        MemberOf: Record "Access Control";


    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)", Rec);
    end;


    procedure CalcInvDisc()
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount", Rec);
    end;


    procedure ExplodeBOM()
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM", Rec);
    end;


    procedure GetPhaseTaskStep()
    begin
        //CODEUNIT.RUN(CODEUNIT::Codeunit75, Rec);
    end;


    procedure OpenSalesOrderPAGE()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order";
    begin
        Rec.TESTFIELD("Sales Order No.");
        SalesHeader.SETRANGE("No.", Rec."Sales Order No.");
        SalesOrder.SETTABLEVIEW(SalesHeader);
        SalesOrder.EDITABLE := FALSE;
        SalesOrder.RUN;
    end;


    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        IF TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            TransferExtendedText.InsertPurchExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdatePAGE(TRUE);
    end;


    procedure ShowReservation()
    begin
        Rec.FIND;
        Rec.ShowReservation;
    end;


    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
        //Rec.ItemAvailability(AvailabilityType);
    end;


    procedure ShowReservationEntries()
    begin
        Rec.ShowReservationEntries(TRUE);
    end;


    procedure ShowTracking()
    var
        TrackingPAGE: Page "Order Tracking";
    begin
        TrackingPAGE.SetPurchLine(Rec);
        TrackingPAGE.RUNMODAL;
    end;


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ItemChargeAssgnt()
    begin
        Rec.ShowItemChargeAssgnt;
    end;


    procedure OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;


    procedure OpenSpecOrderSalesOrderPAGE()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order";
    begin
        Rec.TESTFIELD("Special Order Sales No.");
        SalesHeader.SETRANGE("No.", Rec."Special Order Sales No.");
        SalesOrder.SETTABLEVIEW(SalesHeader);
        SalesOrder.EDITABLE := FALSE;
        SalesOrder.RUN;
    end;


    procedure UpdatePAGE(SetSaveRecord: Boolean)
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;


    procedure ShowStrDetailsPAGE()
    var
    //StrOrderLineDetails: Record 13795;
    //StrOrderLineDetailsPAGE: Page 16306;
    begin
        // StrOrderLineDetails.RESET;
        // StrOrderLineDetails.SETCURRENTKEY(Rec."Document Type", Rec."Document No.", Rec.Type);
        // StrOrderLineDetails.SETRANGE(Rec."Document Type", Rec."Document Type");
        // StrOrderLineDetails.SETRANGE(Rec."Document No.", Rec."Document No.");
        // StrOrderLineDetails.SETRANGE(Rec.Type, StrOrderLineDetails.Type::Purchase);
        // StrOrderLineDetails.SETRANGE("Item No.", Rec."No.");
        // StrOrderLineDetails.SETRANGE(Rec."Line No.", Rec."Line No.");
        // StrOrderLineDetailsPAGE.SETTABLEVIEW(StrOrderLineDetails);
        // StrOrderLineDetailsPAGE.RUNMODAL;
    end;


    procedure ShowSubOrderDetailsPAGE()
    var
        PurchaseLine: Record "Purchase Line";
    //SubOrderDetails: Page 16324;
    begin
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", Rec."Document Type"::Order);
        PurchaseLine.SETRANGE("Document No.", Rec."Document No.");
        PurchaseLine.SETRANGE("No.", Rec."No.");
        PurchaseLine.SETRANGE("Line No.", Rec."Line No.");
        // SubOrderDetails.SETTABLEVIEW(PurchaseLine);
        // SubOrderDetails.RUNMODAL;
    end;


    procedure "--ALLE"()
    begin
    end;


    procedure GetIndentLineInfo()
    begin
        //JPL09
        //GetIndentLines;
    end;


    procedure CheckIndent()
    begin
        //JPL09 START
        IF (Rec."Indent Line No" = 0) AND (Rec."Indent No" = '') THEN
            EXIT;

        IndentLine.RESET;
        IndentLine.SETRANGE("Document Type", IndentLine."Document Type"::Indent);
        IndentLine.SETRANGE("Document No.", Rec."Indent No");
        IndentLine.SETRANGE("Line No.", Rec."Indent Line No");
        IndentLine.SETFILTER(Type, '%1|%2|%3', IndentLine.Type::Item, IndentLine.Type::"G/L Account", IndentLine.Type::"Fixed Asset");
        IndentLine.SETRANGE(Approved, TRUE);
        IF Rec."No." <> '' THEN
            IndentLine.SETRANGE("No.", Rec."No.");
        IndentLine.CALCFIELDS("PO Qty");
        IF IndentLine.FIND('-') THEN BEGIN
            //REPEAT
            IndentLine.TESTFIELD("No.", Rec."No.");
            IndentLine.CALCFIELDS("PO Qty");
            IF (IndentLine."Line No." = xRec."Indent Line No") AND (IndentLine."Document No." = xRec."Indent No") THEN BEGIN
                IF (IndentLine."Quantity Base" - IndentLine."PO Qty" + xRec."Quantity (Base)" < Rec."Quantity (Base)") THEN
                    ERROR('Original Available Indent Qty is less than PO Line Base Qty');
            END
            ELSE BEGIN
                IF (IndentLine."Quantity Base" - IndentLine."PO Qty" < Rec."Quantity (Base)") THEN
                    ERROR('Available Indent Qty is less than PO Line Base Qty');
            END;
            //UNTIL IndentLine.NEXT=0;
        END;
        //JPL09 STOP
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(FALSE);
        IF (Rec.Type = Rec.Type::"Charge (Item)") AND (Rec."No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(FALSE);
    end;
}

