page 97754 "Sales Invoice Subform CB"
{
    // ALLESP BCL0016 17-07-2007: Added Control IPA Qty
    // ALLESP BCL0006 27-07-2007: Added Control 'Present Price Index','old Price Index'
    // ALLERP Bugfix  03-12-2010: Code added for not deleting the approved sales line

    AutoSplitKey = true;
    Caption = 'Sales Invoice Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER(Invoice),
                            "Invoice Type1" = FILTER(RA));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                    end;
                }
                field("No."; Rec."No.")
                {

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;
                    end;
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("BOQ Code"; Rec."BOQ Code")
                {
                    Visible = false;
                }
                // field("Project Code"; "Project Code")
                // {
                //     Visible = false;
                // }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida;
                    end;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                // field("Excise Bus. Posting Group"; "Excise Bus. Posting Group")
                // {
                // }
                // field("Excise Prod. Posting Group"; "Excise Prod. Posting Group")
                // {
                // }
                field("Escalation Account"; Rec."Escalation Account")
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Visible = false;
                }
                // field("MRP Price"; "MRP Price")
                // {
                //     Visible = false;
                // }
                // field(MRP; MRP)
                // {
                //     Visible = false;
                // }
                // field("Abatement %"; "Abatement %")
                // {
                //     Visible = false;
                // }
                // field("PIT Structure"; "PIT Structure")
                // {
                //     Visible = false;
                // }
                field("Price Inclusive of Tax"; Rec."Price Inclusive of Tax")
                {
                    Visible = false;
                }
                field("Unit Price Incl. of Tax"; Rec."Unit Price Incl. of Tax")
                {
                    Visible = false;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    BlankZero = true;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                    end;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field(PriceExists; Rec.PriceExists)
                {
                    Caption = 'Sales Price Exists';
                    Editable = false;
                    Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Price Inclusive of Tax", FALSE);
                    end;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Price Inclusive of Tax", FALSE);
                    end;
                }
                // field("Service Tax Registration No."; "Service Tax Registration No.")
                // {
                //     Visible = false;
                // }
                // field("Service Tax Group"; "Service Tax Group")
                // {
                // }
                // field("Service Tax Base"; "Service Tax Base")
                // {
                // }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                }
                field("Steel Works"; Rec."Steel Works")
                {
                }
                // field("Tax %"; "Tax %")
                // {
                // }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                }
                // field("Tax Base Amount"; "Tax Base Amount")
                // {
                // }
                // field("Tax Amount"; "Tax Amount")
                // {
                //     Visible = false;
                // }
                field("TCS Nature of Collection"; Rec."TCS Nature of Collection")
                {
                    Caption = 'TCS Nature of Collection';
                    Visible = false;
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                }
                field(LineDiscExists; Rec.LineDiscExists)
                {
                    Caption = 'Sales Line Disc. Exists';
                    Editable = false;
                    Visible = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    BlankZero = true;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    Visible = false;
                }
                // field("Assessable Value"; "Assessable Value")
                // {
                // }
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
                // field(Supplementary; Supplementary)
                // {
                //     Visible = false;
                // }
                // field("Source Document Type"; "Source Document Type")
                // {
                //     Visible = false;
                // }
                // field("Source Document No."; "Source Document No.")
                // {
                //     Visible = false;
                // }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Inv. Discount Amount"; Rec."Inv. Discount Amount")
                {
                    Visible = false;
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
                field("Job No."; Rec."Job No.")
                {

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field("Job Contract Entry No."; Rec."Job Contract Entry No.")
                {
                }
                field("Work Type Code"; Rec."Work Type Code")
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
                field("FA Posting Date"; Rec."FA Posting Date")
                {
                    Visible = false;
                }
                field("Depr. until FA Posting Date"; Rec."Depr. until FA Posting Date")
                {
                    Visible = false;
                }
                field("Depreciation Book Code"; Rec."Depreciation Book Code")
                {
                    Visible = false;
                }
                field("Use Duplication List"; Rec."Use Duplication List")
                {
                    Visible = false;
                }
                field("Duplicate in Depreciation Book"; Rec."Duplicate in Depreciation Book")
                {
                    Visible = false;
                }
                field("Appl.-from Item Entry"; Rec."Appl.-from Item Entry")
                {
                    Visible = false;
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    Visible = false;
                }
                // field("Process Carried Out"; "Process Carried Out")
                // {
                // }
                // field("Identification Mark"; "Identification Mark")
                // {
                // }
                // field("Re-Dispatch"; "Re-Dispatch")
                // {
                // }
                field("Return Receipt Line No."; Rec."Return Receipt Line No.")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
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
                field("RIT Done"; Rec."RIT Done")
                {
                }
            }
            group(ItemPanel)
            {
                Caption = 'Item Information';
                Visible = ItemPanelVisible;
                field("STRSUBSTNO('(%1)',SalesInfoPaneMgt.CalcAvailability(Rec))"; STRSUBSTNO('(%1)', SalesInfoPaneMgt.CalcAvailability(Rec)))
                {
                    Editable = false;
                }
                field("STRSUBSTNO('(%1)',SalesInfoPaneMgt.CalcNoOfSubstitutions(Rec))"; STRSUBSTNO('(%1)', SalesInfoPaneMgt.CalcNoOfSubstitutions(Rec)))
                {
                    Editable = false;
                }
                field("STRSUBSTNO('(%1)',SalesInfoPaneMgt.CalcNoOfSalesPrices(Rec))"; STRSUBSTNO('(%1)', SalesInfoPaneMgt.CalcNoOfSalesPrices(Rec)))
                {
                    Editable = false;
                }
                field("STRSUBSTNO('(%1)',SalesInfoPaneMgt.CalcNoOfSalesLineDisc(Rec))"; STRSUBSTNO('(%1)', SalesInfoPaneMgt.CalcNoOfSalesLineDisc(Rec)))
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    action(Period)
                    {
                        Caption = 'Period';

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                            /*CurrPage.SalesLines.PAGE.*/
                            _ItemAvailability(0);

                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                            /*CurrPage.SalesLines.PAGE.*/
                            _ItemAvailability(1);

                        end;
                    }
                    action(Location)
                    {
                        Caption = 'Location';

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                            /*CurrPage.SalesLines.PAGE.*/
                            _ItemAvailability(2);

                        end;
                    }
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        _ShowDimensions;

                    end;
                }
                action("Item Charge &Assignment")
                {
                    Caption = 'Item Charge &Assignment';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ItemChargeAssgnt;

                    end;
                }
                action("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        _OpenItemTrackingLines;

                    end;
                }
                action("Str&ucture Details")
                {
                    Caption = 'Str&ucture Details';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ShowStrDetailsPAGE;

                    end;
                }
                action("Detailed Tax Entry")
                {
                    Caption = 'Detailed Tax Entry';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ShowDetailedTaxEntryBuffer;

                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Get &Price")
                {
                    Caption = 'Get &Price';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ShowPrices

                    end;
                }
                action("Get Li&ne Discount")
                {
                    Caption = 'Get Li&ne Discount';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ShowLineDisc

                    end;
                }
                action("E&xplode BOM")
                {
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        ExplodeBOM;

                    end;
                }
                action("Insert &Ext. Texts")
                {
                    Caption = 'Insert &Ext. Texts';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        _InsertExtendedText(TRUE);

                    end;
                }
                action("Get &Shipment Lines")
                {
                    Caption = 'Get &Shipment Lines';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        GetShipment;

                    end;
                }
                action("Get &Phase/Task/Step")
                {
                    Caption = 'Get &Phase/Task/Step';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97753. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesLines.PAGE.*/
                        GetPhaseTaskStep;

                    end;
                }
            }
            action("Sales Line &Discounts")
            {
                Caption = 'Sales Line &Discounts';
                Image = SalesLineDisc;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowLineDisc;
                    CurrPage.UPDATE;
                end;
            }
            action("&Sales Prices")
            {
                Caption = '&Sales Prices';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowPrices;
                    CurrPage.UPDATE;
                end;
            }
            action("Substitutio&ns")
            {
                Caption = 'Substitutio&ns';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.ShowItemSub;
                    CurrPage.UPDATE;
                end;
            }
            action("Availa&bility")
            {
                Caption = 'Availa&bility';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ItemAvailability(0);
                end;
            }
            action("Ite&m Card")
            {
                Caption = 'Ite&m Card';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SalesInfoPaneMgt.LookupItem(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        //ALLERP 03-12-2010:Start:
        SalesHeader.GET(Rec."Document Type", Rec."Document No.");
        IF SalesHeader.Amended = FALSE THEN BEGIN
            SalesHeader.TESTFIELD(Approved, FALSE);
        END;
        IF SalesHeader.Amended THEN BEGIN
            SalesHeader.TESTFIELD(Approved, TRUE);
            SalesHeader.TESTFIELD("Amendment Approved", FALSE);
        END;
        //ALLERP 03-12-2010:End:
    end;

    trigger OnInit()
    begin
        ItemPanelVisible := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Invoice Type1" := Rec."Invoice Type1"::RA //ALLE KT
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := xRec.Type;
        CLEAR(ShortcutDimCode);
    end;

    var
        SalesHeader: Record "Sales Header";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        ShortcutDimCode: array[8] of Code[20];

        ItemPanelVisible: Boolean;


    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
    end;


    procedure CalcInvDisc()
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount", Rec);
    end;


    procedure ExplodeBOM()
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM", Rec);
    end;


    procedure GetShipment()
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Get Shipment", Rec);
    end;


    procedure GetPhaseTaskStep()
    begin
        //CODEUNIT.RUN(CODEUNIT::Codeunit65, Rec);
    end;


    procedure GetJobLedger()
    begin
        //GetJobUsage.SetCurrentSalesLine(Rec);
        //GetJobUsage.RUNMODAL;
        //CLEAR(GetJobUsage);
    end;


    procedure _InsertExtendedText(Unconditionally: Boolean)
    begin
        IF TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            TransferExtendedText.InsertSalesExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdatePAGE(TRUE);
    end;


    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        IF TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            TransferExtendedText.InsertSalesExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdatePAGE(TRUE);
    end;


    procedure _ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
        //Rec.ItemAvailability(AvailabilityType); // ALLE MM
    end;


    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
        //Rec.ItemAvailability(AvailabilityType);  // ALLE MM
    end;


    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure _OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;


    procedure OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;


    procedure ItemChargeAssgnt()
    begin
        Rec.ShowItemChargeAssgnt;
    end;


    procedure UpdatePAGE(SetSaveRecord: Boolean)
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;


    procedure ShowPrices()
    begin
        SalesHeader.GET(Rec."Document Type", Rec."Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader, Rec);
    end;


    procedure ShowLineDisc()
    begin
        SalesHeader.GET(Rec."Document Type", Rec."Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader, Rec);
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
        // StrOrderLineDetails.SETRANGE(Rec.Type, StrOrderLineDetails.Type::Sale);
        // StrOrderLineDetails.SETRANGE("Item No.", Rec."No.");
        // StrOrderLineDetails.SETRANGE(Rec."Line No.", Rec."Line No.");
        // StrOrderLineDetailsPAGE.SETTABLEVIEW(StrOrderLineDetails);
        // StrOrderLineDetailsPAGE.RUNMODAL;
    end;


    procedure CalculateRIT()
    begin
        CalculateRIT;
    end;


    procedure ShowDetailedTaxEntryBuffer()
    var
    //DetailedTaxEntryBuffer: Record "Detailed Tax Entry Buffer"; //16480;
    begin
        // DetailedTaxEntryBuffer.RESET;
        // DetailedTaxEntryBuffer.SETCURRENTKEY(Rec."Transaction Type", Rec."Document Type", Rec."Document No.", Rec."Line No.");
        // DetailedTaxEntryBuffer.SETRANGE(Rec."Transaction Type", DetailedTaxEntryBuffer."Transaction Type"::Sale);
        // DetailedTaxEntryBuffer.SETRANGE(Rec."Document Type", Rec."Document Type");
        // DetailedTaxEntryBuffer.SETRANGE(Rec."Document No.", Rec."Document No.");
        // DetailedTaxEntryBuffer.SETRANGE(Rec."Line No.", Rec."Line No.");
        // PAGE.RUNMODAL(PAGE::"Sale Detailed Tax", DetailedTaxEntryBuffer);
    end;

    local procedure TypeOnAfterValidate()
    begin
        ItemPanelVisible := Rec.Type = Rec.Type::Item;
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(FALSE);
        IF (Rec.Type = Rec.Type::"Charge (Item)") AND (Rec."No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        IF Rec.Reserve = Rec.Reserve::Always THEN BEGIN
            CurrPage.SAVERECORD;
            Rec.AutoReserve;
        END;
    end;

    local procedure QuantityOnAfterValidate()
    begin
        IF Rec.Reserve = Rec.Reserve::Always THEN BEGIN
            CurrPage.SAVERECORD;
            Rec.AutoReserve;
        END;
    end;
}

