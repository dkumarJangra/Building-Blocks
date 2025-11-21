table 97734 "Gate Pass Line"
{
    // //Alle-pks10 for the correct applies from entry and flow the Min no.
    // //ALLE-PKS15 for the credit note functionality
    // //SC : New fields added
    // //AlleBLk : New fields added
    // //NDALLE : Code commented
    // ALLEPG RIL1.15 080112 : Code added for flowing Costcode name.
    // 
    // ALLEDK 210212 GF0133  Added code for PO Line No.
    // //RAHEE1.00
    // ALLEPG RAHEE1.00 240212 : Created functions for tracking line.


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'MIN,Outward Gatepass,Material Return,Inward Gatepass,Consumption FOC,Consumption Chargable';
            OptionMembers = "MIN","Outward Gatepass","Material Return","Inward Gatepass","Consumption FOC","Consumption Chargable";
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(6; "Purchase Order No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Order));
        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                MODIFY;
            end;
        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                MODIFY;
                DimValue.RESET;
                DimValue.SETRANGE(Code, "Shortcut Dimension 2 Code");
                IF DimValue.FIND('-') THEN BEGIN
                    "Cost Centre Name" := DimValue.Name;
                    VALIDATE("Gen. Bus. Posting Group", DimValue."Gen. Business Posting Group");
                END
                ELSE
                    "Cost Centre Name" := '';
            end;
        }
        field(15; Status; Option)
        {
            OptionCaption = 'Open,Close';
            OptionMembers = Open,Close;
        }
        field(16; "Item No."; Code[20])
        {
            TableRelation = Item;

            trigger OnValidate()
            var
                GatePassHdrs: Record "Gate Pass Header";
                UnitSetup: Record "Unit setup";
            begin
                //150425 Code Added Start
                GatePassHdrs.RESET;
                IF GatePassHdrs.GET("Document Type", "Document No.") then
                    IF (GatePassHdrs.Type = GatePassHdrs.Type::Direct) AND (GatePassHdrs."Item Type" = GatePassHdrs."Item Type"::Gold_SilverVoucher) THEN begin
                        UnitSetup.RESET;
                        UnitSetup.GET;
                        UnitSetup.TestField("Gold/Silver Voucher Item Code");
                        If "Item No." <> UnitSetup."Gold/Silver Voucher Item Code" then
                            Error('Item no. must be' + UnitSetup."Gold/Silver Voucher Item Code");
                    END;

                //150425 Code Added End

                Item.RESET;
                IF Item.GET("Item No.") THEN BEGIN
                    Description := Item.Description;
                    "Description 2" := Item."Description 2";
                    "Description 3" := Item."Description 3";
                    "Description 4" := Item."Description 4";
                    "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                    "Unit of Measure" := Item."Base Unit of Measure";
                    "Unit Cost" := Item."Unit Cost";
                    "Silver / Gold in Grams" := Item."Silver / Gold in Grams";  //030524 Code added
                END;
                VALIDATE("Gen. Bus. Posting Group");
                VALIDATE("Gen. Prod. Posting Group");

                GPHdr1.RESET;
                GPHdr1.SETRANGE(GPHdr1."Document Type", "Document Type");
                GPHdr1.SETRANGE(GPHdr1."Document No.", "Document No.");
                IF GPHdr1.FIND('-') THEN BEGIN
                    "Gen. Bus. Posting Group" := GPHdr1."Gen. Business Posting Group";
                    "Shortcut Dimension 2 Code" := GPHdr1."Shortcut Dimension 2 Code";
                    "Job No." := GPHdr1."Job No.";  // ALLEAA
                    "Customer No." := GPHdr1."Customer No."; //BBG1.00 170613
                    IF GPHdr1."Application No." <> '' THEN
                        "Application No." := GPHdr1."Application No.";
                    IF GPHdr1."Item Type" = GPHdr1."Item Type"::Gold THEN
                        Item.TESTFIELD(Item."Type of Item", Item."Type of Item"::Gold);
                    IF GPHdr1."Item Type" = GPHdr1."Item Type"::Silver THEN BEGIN
                        Item.TESTFIELD(Item."Type of Item", Item."Type of Item"::Silver);
                        Item.TESTFIELD("Silver / Gold in Grams");  // 030524 Code added
                    END;

                END;
                GLSetup.GET;

                IF GPHdr1."Item Type" = GPHdr1."Item Type"::R194_Gift then  //290425 code added for R194 Gift setup
                    GPHdr1.TestField("Vendor No.");   //290425 code added for R194 Gift setup

                "Vendor No." := GPHdr1."Vendor No.";   //290425 code added for R194 Gift setup
                "Vendor Name" := GPHdr1."Vendor Name";  //290425 code added for R194 Gift setup

                DefDimRec.RESET;
                DefDimRec.GET(27, "Item No.", GLSetup."Global Dimension 2 Code");
                "Shortcut Dimension 2 Code" := DefDimRec."Dimension Value Code";
                DimValue.RESET;
                DimValue.SETRANGE("Dimension Code", GLSetup."Global Dimension 2 Code");  // RIL1.15 080112
                DimValue.SETRANGE(Code, "Shortcut Dimension 2 Code");
                IF DimValue.FIND('-') THEN BEGIN
                    "Cost Centre Name" := DimValue.Name;
                    //VALIDATE("Gen. Bus. Posting Group",DimValue."Gen. Business Posting Group");
                END
                ELSE
                    "Cost Centre Name" := '';
            end;
        }
        field(17; Description; Text[50])
        {
        }
        field(18; "Description 2"; Text[50])
        {
        }
        field(19; "Unit of Measure"; Code[20])
        {
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(20; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(21; "Gen. Bus. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                VALIDATE("Gen. Prod. Posting Group");
            end;
        }
        field(22; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group".Code;

            trigger OnValidate()
            begin
                GPHdr.GET("Document Type", "Document No.");
                GenPostSetup.RESET;
                GenPostSetup.SETRANGE("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
                GenPostSetup.SETRANGE("Gen. Prod. Posting Group", "Gen. Prod. Posting Group");
                IF GenPostSetup.FIND('-') THEN BEGIN
                    //"Account No." := GenPostSetup."Inventory Adjmt. Account";
                    IF GPHdr."Issue Type" = GPHdr."Issue Type"::Chargeable THEN
                        GenPostSetup.TESTFIELD("MIN Chargeable Account");
                    "Account No." := GenPostSetup."MIN Chargeable Account";
                END;
            end;
        }
        field(23; "Required Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                GatepassHdrs: Record "Gate Pass Header";
            begin
                GatepassHdrs.Reset();
                IF GatepassHdrs.GET(Rec."Document Type", Rec."Document No.") THEN begin
                    IF GatepassHdrs.Type = GatepassHdrs.Type::Regular then
                        VALIDATE(Qty, "Required Qty");
                    //CalcAmount;
                end;
            END;
        }
        field(24; Qty; Decimal)
        {
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                AvailableInventory: Decimal;
                MinQty: Decimal;
                ItemJnlLines: Record "Item Journal Line";
                GatePassHdrs: Record "Gate Pass Header";
                ItemJnl: Record "Item Journal Line";
                Unitsetup: Record "Unit setup";
                ItemJournal: Record "Item Journal Line";
                EndLineNo: Integer;
                ItemJournal2: Record "Item Journal Line";
            begin
                IF "Document Type" = "Document Type"::MIN THEN BEGIN
                    IF Qty > "Required Qty" THEN
                        ERROR('Issued Quantity must be Equal Or Less than to Required Quantity');
                    Item.GET("Item No.");
                    Item.CALCFIELDS(Inventory);
                    AvailableInventory := Item.Inventory;

                    MinQty := 0;
                    MinLine.RESET;
                    MinLine.SETCURRENTKEY("Item No.", Status);
                    MinLine.SETRANGE("Item No.", "Item No.");
                    MinLine.SETRANGE(Status, Status::Open);
                    MinLine.SETRANGE("Document Type", "Document Type"::MIN);
                    MinLine.SETFILTER("Document No.", '<>%1', "Document No.");
                    IF MinLine.FIND('-') THEN BEGIN
                        MinLine.CALCSUMS(Qty);
                        MinQty := MinLine.Qty;
                        AvailableInventory := AvailableInventory - MinQty;
                    END;

                    MinLine.RESET;
                    MinLine.SETCURRENTKEY("Item No.", Status);
                    MinLine.SETRANGE("Item No.", "Item No.");
                    MinLine.SETRANGE(Status, Status::Open);
                    MinLine.SETRANGE("Document Type", "Document Type"::MIN);
                    MinLine.SETRANGE("Document No.", "Document No.");
                    MinLine.SETFILTER("Line No.", '<>%1', "Line No.");
                    IF MinLine.FIND('-') THEN BEGIN
                        MinLine.CALCSUMS(Qty);
                        MinQty := MinQty + MinLine.Qty;
                        AvailableInventory := AvailableInventory - MinLine.Qty;
                    END;

                    IF (Qty > AvailableInventory) THEN BEGIN
                        // Qty := AvailableInventory; changes by surya rao 20.02.2007
                        MESSAGE('Inventory = %1, Qty in Open MIN = %2, Available Inventory = %3',
                          Item.Inventory, MinQty, AvailableInventory);
                    END;
                END;
                CalcAmount;
                //ALLEDK 210212
                IF "Purchase Order No." <> '' THEN
                    CheckIndent;
                //140425 Added new code for Gold/Silver voucher Start

                GatePassHdrs.RESET;
                IF GatePassHdrs.GET("Document Type", "Document No.") THEN begin

                end;
                IF (GatePassHdrs.Type = GatePassHdrs.Type::Regular) AND (GatePassHdrs."Item Type" = GatePassHdrs."Item Type"::Gold_SilverVoucher) THEN begin
                    ItemJnlLines.RESET;
                    ItemJnlLines.SetRange("Document No.", "Document No.");
                    ItemJnlLines.SetRange("Application No.", "Application No.");
                    ItemJnlLines.SetRange("Application Line No.", "Application Line No.");
                    if ItemJnlLines.FindFirst() then begin
                        ItemJnlLines.Validate(Quantity, Qty);
                        ItemJnlLines.Modify;
                    end;
                END ELSE begin

                    IF (GatePassHdrs.Type = GatePassHdrs.Type::Direct) AND (GatePassHdrs."Item Type" = GatePassHdrs."Item Type"::Gold_SilverVoucher) THEN begin
                        TestField("Application No.");


                        Unitsetup.GET;
                        Unitsetup.TestField("Gold/Silver Voucher Template");
                        Unitsetup.TestField("Gold/Silver Voucher Batch");

                        ItemJournal2.RESET;
                        ItemJournal2.SetRange("Journal Template Name", Unitsetup."Gold/Silver Voucher Template");
                        ItemJournal2.SetRange("Journal Batch Name", Unitsetup."Gold/Silver Voucher Batch");
                        ItemJournal2.SetRange("Document No.", "Document No.");
                        ItemJournal2.SetRange("Application Line No.", Rec."Line No.");
                        IF ItemJournal2.FindSet THEN
                            ItemJournal2.DeleteAll();

                        ItemJournal.RESET;
                        ItemJournal.SetRange("Journal Template Name", Unitsetup."Gold/Silver Voucher Template");
                        ItemJournal.SetRange("Journal Batch Name", Unitsetup."Gold/Silver Voucher Batch");
                        IF ItemJournal.FINDLAST THEN
                            EndLineNo := ItemJournal."Line No." + 10000
                        ELSE
                            EndLineNo := 10000;


                        ItemJnl.VALIDATE("Journal Template Name", Unitsetup."Gold/Silver Voucher Template");
                        ItemJnl.VALIDATE("Journal Batch Name", Unitsetup."Gold/Silver Voucher Batch");
                        ItemJnl.VALIDATE("Document No.", Rec."Document No.");
                        ItemJnl.VALIDATE("Line No.", EndLineNo);
                        ItemJnl.VALIDATE("Vendor No.", GatePassHdrs."Vendor No.");
                        ItemJnl.VALIDATE("PO No.", GatePassHdrs."Purchase Order No.");
                        ItemJnl.VALIDATE("Item Shpt. Entry No.", 0);
                        ItemJnl.INSERT(TRUE);

                        ItemJnl.VALIDATE("Posting Date", GatePassHdrs."Posting Date");
                        IF Rec."Document Type" = Rec."Document Type"::MIN then
                            ItemJnl.VALIDATE("Entry Type", ItemJnl."Entry Type"::"Negative Adjmt.")
                        ELSE IF Rec."Document Type" = Rec."Document Type"::"Material Return" then
                            ItemJnl.VALIDATE("Entry Type", ItemJnl."Entry Type"::"Positive Adjmt.");

                        ItemJnl.VALIDATE("Item No.", Rec."Item No.");
                        ItemJnl.VALIDATE("Location Code", Rec."Location Code");
                        ItemJnl.VALIDATE(Quantity, Rec.Qty);
                        IF Rec."Gen. Bus. Posting Group" <> '' THEN
                            ItemJnl.VALIDATE("Gen. Bus. Posting Group", Rec."Gen. Bus. Posting Group");
                        IF Rec."Gen. Prod. Posting Group" <> '' THEN
                            ItemJnl.VALIDATE("Gen. Prod. Posting Group", Rec."Gen. Prod. Posting Group");
                        ItemJnl.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                        ItemJnl.VALIDATE("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                        IF Rec."Applies-to Entry" <> 0 THEN
                            ItemJnl.VALIDATE("Applies-to Entry", Rec."Applies-to Entry");
                        ItemJnl.VALIDATE("Issue Type", GatePassHdrs."Issue Type");
                        ItemJnl."Reference No." := GatePassHdrs."Reference No.";
                        ItemJnl."Application No." := Rec."Application No.";
                        ItemJnl."Application Line No." := Rec."Line No.";
                        ItemJnl."Item Type" := GatePassHdrs."Item Type";

                        ItemJnl.VALIDATE("Bin Code", Rec."Bin Code");
                        ItemJnl.Narration := Rec.Description + ' Qty:' + FORMAT(Rec.Qty);
                        ItemJnl.MODIFY(TRUE);
                    END;

                end;
                //140425 Added new code for Gold/Silver voucher END;


                //ALLEDK 210212
            end;
        }
        field(25; "Return Due Date"; Date)
        {
        }
        field(27; "Outward Gatepass Entry No"; Integer)
        {

            trigger OnLookup()
            begin
                /*
                RetILE.RESET;
                RetILE.SETRANGE("Document Type",RetILE."Document Type"::"0");
                RetILE.SETRANGE(Open,TRUE);
                RetILE.SETFILTER("Remaining Qty",'>0');
                IF RetILE.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(0,RetILE)= ACTION::LookupOK THEN BEGIN
                      VALIDATE("Outward Gatepass Entry No",RetILE."Entry No.");
                      VALIDATE("Item No.",RetILE."Item No.");
                      VALIDATE("Unit of Measure",RetILE.Uom);
                      IF Qty = 0 THEN
                        VALIDATE(Qty,RetILE."Remaining Qty");
                      MODIFY(TRUE);
                  END;
                END;
                */

            end;
        }
        field(28; "Applies-from Entry"; Integer)
        {

            trigger OnLookup()
            begin
                SelectItemEntry(FIELDNO("Applies-from Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                VALIDATE(Chargeable, FALSE);

                IF "Applies-from Entry" <> 0 THEN BEGIN
                    TESTFIELD(Qty);
                    IF Signed(Qty) < 0 THEN BEGIN
                        IF Qty > 0 THEN
                            FIELDERROR(Qty, Text030);
                        IF Qty < 0 THEN
                            FIELDERROR(Qty, Text029);
                    END;
                    ItemLedgEntry.GET("Applies-from Entry");
                    ItemLedgEntry.TESTFIELD(Positive, FALSE);
                    GLSetup.GET;
                    // ALLE MM Code Added
                    DimSetEntry.RESET;
                    DimSetEntry.SETRANGE("Dimension Set ID", "Dimension Set ID");
                    DimSetEntry.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
                    IF DimSetEntry.FINDFIRST THEN
                        "Shortcut Dimension 8 Code" := DimSetEntry."Dimension Value Code";
                    // ALLE MM Code Added
                    // ALLE MM Code Commented
                    /*
                    LedgerEntryDimension.RESET;
                    LedgerEntryDimension.SETRANGE(LedgerEntryDimension."Table ID",32);
                    LedgerEntryDimension.SETRANGE(LedgerEntryDimension."Entry No.",ItemLedgEntry."Entry No.");
                    LedgerEntryDimension.SETRANGE(LedgerEntryDimension."Dimension Code",GLSetup."Shortcut Dimension 8 Code");
                    IF LedgerEntryDimension.FIND('-')THEN
                      "Shortcut Dimension 8 Code" := LedgerEntryDimension."Dimension Value Code";
                      */
                    // ALLE MM Code Commented
                    "Unit Cost" := CalcUnitCost(ItemLedgEntry."Entry No.");
                    "Min No." := ItemLedgEntry."Document No."; //Alle-pks10
                    "Job Task No." := ItemLedgEntry."Job Task No.";  // ALLEAA
                    IF ItemLedgEntry."Issue Type" = ItemLedgEntry."Issue Type"::Chargeable THEN BEGIN
                        VALIDATE(Chargeable, TRUE);
                    END;
                    CalcAmount;
                END;

            end;
        }
        field(29; "Unit Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcAmount;
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '// ALLE MM Field Added';
        }
        field(50000; "Cost Centre Name"; Text[60])
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50001; "Journal Line Created"; Boolean)
        {
            Description = 'AlleBLk';
        }
        field(50002; "Debit Note Created"; Boolean)
        {
            Description = 'AlleBLk';
        }
        field(50003; "Account No."; Code[20])
        {
            Description = 'AlleBLk';
        }
        field(50004; "Applies-to Entry"; Integer)
        {
            Caption = 'Applies-to Entry';
            Description = 'AlleBLk';

            trigger OnLookup()
            begin
                SelectItemEntry(FIELDNO("Applies-to Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
                PurchRcptLine: Record 121;
                PurchInvLine: Record 123;
                PurchInvLine_2: Record 123;
                TotalGiftValue: Decimal;

            begin
                IF "Applies-to Entry" <> 0 THEN BEGIN
                    ItemLedgEntry.GET("Applies-to Entry");
                    TotalGiftValue := 0;

                    TESTFIELD(Qty);
                    IF Signed(Qty) > 0 THEN BEGIN
                        IF Qty > 0 THEN
                            FIELDERROR(Qty, Text030);
                        IF Qty < 0 THEN
                            FIELDERROR(Qty, Text029);
                    END;
                    ItemLedgEntry.TESTFIELD(Open, TRUE);
                    ItemLedgEntry.TESTFIELD(Positive, TRUE);
                    "Location Code" := ItemLedgEntry."Location Code";
                    ItemLedgEntry.CalcFields("Cost Amount (Actual)");

                    IF (ItemLedgEntry."Invoiced Quantity" <> 0) AND (ItemLedgEntry."Cost Amount (Actual)" <> 0) then  //080225
                        validate("Unit Cost", ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry."Invoiced Quantity");  //080225

                    PurchRcptLine.RESET;
                    PurchRcptLine.SetRange("Document No.", ItemLedgEntry."Document No.");
                    PurchRcptLine.SetRange("No.", Rec."Item No.");
                    IF PurchRcptLine.FindFirst() THEN begin
                        PurchInvLine.RESET;
                        PurchInvLine.SetCurrentKey("Buy-from Vendor No.", "Receipt No.");
                        PurchInvLine.SetRange("Buy-from Vendor No.", PurchRcptLine."Buy-from Vendor No.");
                        PurchInvLine.SetRange("Receipt No.", PurchRcptLine."Document No.");
                        If PurchInvLine.FindFirst() then begin
                            PurchInvLine_2.RESET;
                            PurchInvLine_2.SetRange("Document No.", PurchInvLine."Document No.");
                            PurchInvLine_2.SetRange("Ref. Gift Item No.", Rec."Item No.");
                            IF PurchInvLine_2.FindSet() then begin
                                repeat
                                    TotalGiftValue := TotalGiftValue + PurchInvLine_2."Direct Unit Cost";
                                    "Ref. Invoice No." := PurchInvLine_2."Document No.";
                                until PurchInvLine_2.Next = 0;
                            END ELSE
                                Error('Purchase Invoice not found');

                            "Gift Control Amount" := TotalGiftValue * Rec.Qty;

                        end;
                    end;
                END;
            end;
        }
        field(50005; "Document Date"; Date)
        {
            CalcFormula = Lookup("Gate Pass Header"."Document Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                           "Document No." = FIELD("Document No.")));
            Description = 'SC Added';
            FieldClass = FlowField;
        }
        field(50006; "Posting Date"; Date)
        {
            CalcFormula = Lookup("Gate Pass Header"."Posting Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                          "Document No." = FIELD("Document No.")));
            Description = 'SC Added';
            FieldClass = FlowField;
        }
        field(50007; Amount; Decimal)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50008; "Current Stock"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = FIELD("Location Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLK';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Quantity on GRN"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Accepted Quantity Base" WHERE(Type = FILTER(Item),
                                                                         "No." = FIELD("Item No."),
                                                                         Status = FILTER(Open)));
            Description = 'SC';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Description 3"; Text[30])
        {
            Description = 'SC';
        }
        field(50011; "Description 4"; Text[30])
        {
            Description = 'SC';
        }
        field(50012; "Min No."; Code[20])
        {
            Description = 'ALLE-PKS10';
        }
        field(50013; "Credit Note Created"; Boolean)
        {
            Description = 'ALLE-PKS15';
        }
        field(50014; Chargeable; Boolean)
        {
            Description = 'ALLE-PKS15';

            trigger OnValidate()
            begin
                MinLine.RESET;
                MinLine.SETFILTER(MinLine."Document Type", 'MIN');
                MinLine.SETFILTER(MinLine."Document No.", "Min No.");
                MinLine.SETFILTER(MinLine."Item No.", "Item No.");
                MinLine.SETRANGE(MinLine."Line No.", "Line No.");
                IF MinLine.FIND('-') THEN BEGIN
                    "Unit Cost" := MinLine."Unit Cost";
                    MODIFY
                END
            end;
        }
        field(50015; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ALLEAA';
            Editable = true;
            TableRelation = Job;
        }
        field(50016; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Description = 'ALLEAA';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(50017; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            Description = 'AlleBLK';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('WORK CENTER'));
        }
        field(50018; "Bin Code"; Code[20])
        {
            Description = 'ALLEAA';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(50022; "Indent No."; Code[20])
        {
            Description = 'RAHEE1.00  180412';
        }
        field(50023; "Indent Line No."; Integer)
        {
            Description = 'RAHEE1.00  180412';
        }
        field(50025; "PO Line No."; Integer)
        {
            Description = 'GF0133 210212';
            TableRelation = "FOC/PO TABLE"."Line No.";

            trigger OnLookup()
            begin
                //RAHEE1.00
                cHK.SETRANGE(cHK."No.", "Purchase Order No.");
                cHK.SETRANGE(cHK."Item Code", "Item No.");
                IF PAGE.RUNMODAL(Page::"FOC LIST", cHK) = ACTION::LookupOK THEN BEGIN
                    VALIDATE("PO Line No.", cHK."Line No.");
                END;
                //RAHEE1.00
            end;
        }
        field(50026; "Application No."; Code[20])
        {
            Description = 'AlleBBG';
            TableRelation = "Confirmed Order" WHERE("Customer No." = FIELD("Customer No."));

            trigger OnValidate()
            var
                GatePassHdrs: Record "Gate Pass Header";

            begin
                //150425 Code Added Start
                GatePassHdrs.RESET;
                IF GatePassHdrs.GET("Document Type", "Document No.") then
                    IF (GatePassHdrs.Type = GatePassHdrs.Type::Direct) AND (GatePassHdrs."Item Type" = GatePassHdrs."Item Type"::Gold_SilverVoucher) THEN begin
                        "Application Line No." := Rec."Line No.";

                    END;

                //150425 Code Added End

            end;
        }
        field(50027; "Application Line No."; Integer)
        {
        }
        field(50075; "Issed Qty Third Party"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = FIELD("Location Code"),
                                                                  "PO No." = FIELD("Purchase Order No.")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Description = 'RAHEE1.00  180412';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50080; "Silver / Gold in Grams"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50081; "Issuing Weight"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(80013; "Fixed Asset No"; Code[20])
        {
            TableRelation = "Fixed Asset";
        }
        field(80014; "Gold Coin Qty"; Decimal)
        {
        }
        field(80015; "Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(80016; Update; Boolean)
        {
        }
        field(80017; "Data TRansfered"; Boolean)
        {
        }
        field(80018; "Application Project Code"; Code[20])
        {
            CalcFormula = Lookup("Confirmed Order"."Shortcut Dimension 1 Code" WHERE("No." = FIELD("Application No.")));
            FieldClass = FlowField;
        }
        field(80019; "Quantity Difference"; Boolean)
        {
        }
        field(80020; "App Transfer in LLp"; Boolean)
        {
            Editable = true;
        }
        field(80021; "Transfer from Company"; Text[50])
        {
            Editable = false;
        }
        field(80022; "Transfer LLP Name"; Text[50])
        {
            Editable = false;
        }
        field(80023; "Old Quantity"; Decimal)
        {
        }
        field(80024; "Old Amount"; Decimal)
        {
        }
        field(80025; "Old Unit Cost"; Decimal)
        {
        }
        field(80026; "Gold Posted Date"; Date)
        {
            CalcFormula = Lookup("Gate Pass Header"."Gold Post Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                            "Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(80027; "Associate Code"; Code[20])
        {
            TableRelation = Vendor."No.";
        }

        field(80028; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;
            Editable = false;

            // trigger OnValidate()
            // var
            //     Vendor: Record vendor;
            // begin
            //     Vendor.RESET;
            //     IF Vendor.GET("Vendor No.") THEN;
            //     "Vendor Name" := Vendor.Name;
            // end;
        }
        field(80029; "Vendor Name"; Text[50])
        {
            Description = 'ALLEPG Length changed from 30 to 50';
            Editable = false;
        }

        field(80030; "R194_Application No."; Text[500])
        {
            Editable = False;

            // trigger OnLookup()
            // var
            //     Conforder: Record "Confirmed Order";
            //     Conforder_2: Record "Confirmed Order";
            //     TotalClrAmt: Decimal;
            //     R194Giftsetup: Record "R194 Gift Setup";
            //     GatepassLines: Record "Gate Pass Line";
            //     R194UnitList: Page "R194 Unit List";

            // begin
            //     R194Giftsetup.RESET;
            //     IF R194Giftsetup.FindFirst THEN BEGIN
            //         Conforder.RESET;
            //         Conforder.SetCurrentKey("Introducer Code", "Posting Date");
            //         Conforder.SetRange("Introducer Code", "Vendor No.");
            //         Conforder.SetFilter("Posting Date", '>=%1', R194Giftsetup."Start Date");
            //         Conforder.SetRange("R194 Gift Issued", false);
            //         //Conforder.CalcFields(Conforder."Total Cleared Received Amount");
            //         IF Conforder.FindSet() then
            //             repeat
            //                 Conforder.CalcFields(Conforder."Total Cleared Received Amount");
            //                 IF Conforder."Total Cleared Received Amount" >= Conforder.Amount THEN BEGIN
            //                     Conforder."App. applicable for issue R194" := True;
            //                     Conforder.Modify;
            //                     Commit;
            //                 END;
            //             Until Conforder.Next = 0;
            //     END ELSE
            //         Message('Setup is missing');

            //     Clear(R194UnitList);

            //     R194UnitList.LookupMode(True);
            //     R194UnitList.SetRecord(Conforder_2);
            //     R194UnitList.SetAssociateValue(Rec."Vendor No.");
            //     IF R194UnitList.RUNMODAL = ACTION::LookupOK THEN
            //         Rec."R194_Application No." := R194UnitList.GetSelectionFilter;


            // end;


        }
        field(80032; "Gift Control Amount"; Decimal)
        {
            //Editable = false;
        }
        field(80033; "Extent"; Decimal)
        {
            Editable = false;
        }
        field(80050; "Ref. Invoice No."; Code[20])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; "Account No.")
        {
        }
        key(Key3; "Item No.", Status)
        {
            SumIndexFields = Qty;
        }
        key(Key4; "Shortcut Dimension 1 Code")
        {
        }
        key(Key5; "Document Type", "Indent No.", "Indent Line No.", Status)
        {
            SumIndexFields = Qty;
        }
        key(Key6; "Document No.", "Application No.", "Application Line No.")
        {
            SumIndexFields = Qty;
        }
        key(Key7; "Application No.", "App Transfer in LLp")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status, Status::Open);

        RecMemberof.RESET;
        RecMemberof.SETRANGE("User Name", USERID);
        RecMemberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT RecMemberof.FINDFIRST THEN BEGIN
            RecGPH.RESET;
            RecGPH.SETRANGE("Document No.", "Document No.");
            IF RecGPH.FINDFIRST THEN BEGIN
                IF RecGPH.Verified = TRUE THEN
                    ERROR('You Can not Delete Verified Documents');
            END;
        END;

        GoldCoinEligibility.RESET;
        GoldCoinEligibility.SETRANGE("Min Doc No.", "Document No.");
        IF GoldCoinEligibility.FINDSET THEN
            REPEAT
                GoldCoinEligibility."Min Doc No." := '';
                GoldCoinEligibility.MODIFY;
            UNTIL GoldCoinEligibility.NEXT = 0;
    end;

    trigger OnInsert()
    begin
        GPHdr.GET("Document Type", "Document No.");
        GPHdr.TESTFIELD(Status, GPHdr.Status::Open);

        //NDALLE 130308
        RecMemberof.RESET;
        RecMemberof.SETRANGE("User Name", USERID);
        RecMemberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT RecMemberof.FINDFIRST THEN BEGIN
            RecGPH.RESET;
            RecGPH.SETRANGE("Document No.", "Document No.");
            IF RecGPH.FINDFIRST THEN BEGIN
                IF RecGPH.Verified = TRUE THEN
                    ERROR('You Can not Insert in Verified Documents');
            END;
        END;

    end;

    trigger OnModify()
    begin
        TESTFIELD(Status, Status::Open);

        //NDALLE 130308
        RecMemberof.RESET;
        RecMemberof.SETRANGE("User Name", USERID);
        RecMemberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT RecMemberof.FINDFIRST THEN BEGIN
            RecGPH.RESET;
            RecGPH.SETRANGE("Document No.", "Document No.");
            IF RecGPH.FINDFIRST THEN BEGIN
                IF RecGPH.Verified = TRUE THEN
                    ERROR('You Can not Modify Verified Documents');
            END;
        END;
    end;

    var
        Item: Record Item;
        GPHdr: Record "Gate Pass Header";
        GenPostSetup: Record "General Posting Setup";
        Text029: Label 'must be positive';
        Text030: Label 'must be negative';
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        DimValue: Record "Dimension Value";
        MinLine: Record "Gate Pass Line";
        GPHdr1: Record "Gate Pass Header";
        dimmgt: Codeunit DimensionManagement;
        Gatepassheader: Record "Gate Pass Header";
        "PO no": Code[20];
        DefDimRec: Record "Default Dimension";
        RecGPH: Record "Gate Pass Header";
        GLSetup: Record "General Ledger Setup";
        cHK: Record "FOC/PO TABLE";
        FOCLine: Record "FOC/PO TABLE";
        GPassHeader: Record "Gate Pass Header";
        IndentLine: Record "Purchase Request Line";
        GPLineForm: Page "Purchase Request Lines List";
        ToLineRec: Record "Gate Pass Line";
        FOCListForm: Page "FOC LIST";
        GoldCoinEligibility: Record "Gold Coin Eligibility";
        RecMemberof: Record "Access Control";
        Text049: Label 'You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
        Text050: Label 'Cancelled.';
        DimSetEntry: Record "Dimension Set Entry";
        ConfirmedOrder: Record "Confirmed Order";


    procedure Signed(Value: Decimal): Decimal
    begin
        CASE "Document Type" OF
            "Document Type"::"Material Return":
                EXIT(Value);
            "Document Type"::MIN:
                EXIT(-Value);
        END;
    end;

    local procedure SelectItemEntry(CurrentFieldNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemJnlLine2: Record "Item Journal Line";
        GatePassLine2: Record "Gate Pass Line";
    begin
        //Alle-pks10
        Gatepassheader.SETFILTER(Gatepassheader."Document No.", "Document No.");
        IF Gatepassheader.FIND('-') THEN
            "PO no" := Gatepassheader."Purchase Order No.";
        ItemLedgEntry.SETCURRENTKEY("Item No.", "Variant Code", Open);
        ItemLedgEntry.SETRANGE("Item No.", "Item No.");
        ItemLedgEntry.SETRANGE(Correction, FALSE);
        ItemLedgEntry.SETFILTER(ItemLedgEntry."PO No.", "PO no");
        IF "Location Code" <> '' THEN
            ItemLedgEntry.SETRANGE("Location Code", "Location Code");
        IF CurrentFieldNo = FIELDNO("Applies-to Entry") THEN BEGIN
            ItemLedgEntry.SETRANGE(Positive, TRUE);
        END ELSE
            ItemLedgEntry.SETRANGE(Positive, FALSE);
        IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries", ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
            GatePassLine2 := Rec;
            IF CurrentFieldNo = FIELDNO("Applies-to Entry") THEN
                GatePassLine2.VALIDATE("Applies-to Entry", ItemLedgEntry."Entry No.")
            ELSE
                GatePassLine2.VALIDATE("Applies-from Entry", ItemLedgEntry."Entry No.");
            Rec := GatePassLine2;
        END;
    end;

    local procedure CalcUnitCost(ItemLedgEntryNo: Integer): Decimal
    var
        ValueEntry: Record "Value Entry";
    begin
        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.", "Expected Cost");
        ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
        ValueEntry.SETRANGE("Expected Cost", FALSE);
        ValueEntry.CALCSUMS("Invoiced Quantity", "Cost Amount (Actual)");
        //EXIT(ValueEntry."Cost Amount (Actual)" / ValueEntry."Invoiced Quantity" *"Qty. per unit of measure");
        EXIT(ValueEntry."Cost Amount (Actual)" / ValueEntry."Invoiced Quantity" * 1);
    end;

    local procedure CheckItemAvailable(CalledByFieldNo: Integer)
    begin
        /*
        IF (CurrFieldNo = 0) OR (CurrFieldNo <> CalledByFieldNo) THEN // Prevent two checks on quantity
          EXIT;
        
        IF (CurrFieldNo <> 0) AND ("Item No." <> '') AND (Qty <> 0) AND
           ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND ("Item Charge No." = '')
        THEN
          ItemCheckAvail.ItemJnlCheckLine(Rec);
        
        */

    end;


    procedure CalcAmount()
    begin
        Amount := Qty * "Unit Cost";
    end;


    procedure ValidateShortcutDimCode1(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        // ALLE MM Code Commented
        /*
        IF "Line No." <> 0 THEN BEGIN
          dimmgt.SaveDocDim(
            DATABASE::"Gate Pass Line","Document Type","Document No.",
            "Line No.",FieldNumber,ShortcutDimCode);
          MODIFY;
        END ELSE
          dimmgt.SaveTempDim(FieldNumber,ShortcutDimCode);
          */
        // ALLE MM Code Commented

    end;


    procedure GetIndentLines()
    begin
        //ALLE_PKS
        //JPL09 START
        GPassHeader.GET("Document Type", "Document No.");
        IndentLine.RESET;
        IndentLine.FILTERGROUP := 2;
        IndentLine.SETRANGE("Document Type", IndentLine."Document Type"::Indent);
        IndentLine.SETRANGE(Approved, TRUE);
        IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Open);
        //IndentLine.SETRANGE("Shortcut Dimension 3 Code",GPassHeader."Shortcut Dimension Code 3");
        IndentLine.FILTERGROUP := 0;
        IndentLine.CALCFIELDS("TO Qty");
        IF IndentLine.FIND('-') THEN
            REPEAT
                IndentLine.CALCFIELDS("TO Qty");
                IndentLine.CALCFIELDS("PO Qty");
                IndentLine.CALCFIELDS("Issued Qty.");

                IF (IndentLine."TO Qty" + IndentLine."PO Qty" + IndentLine."Issued Qty." < IndentLine."Quantity Base") THEN
                    IndentLine.MARK(TRUE);
            UNTIL IndentLine.NEXT = 0;
        IndentLine.MARKEDONLY(TRUE);
        IF IndentLine.FIND('-') THEN BEGIN
            CLEAR(GPLineForm);
            GPLineForm.SETTABLEVIEW(IndentLine);
            GPLineForm.LOOKUPMODE := TRUE;
            GPLineForm.SetGatePassHeader(GPassHeader);
            GPLineForm.SetMINMode(TRUE);
            GPLineForm.RUNMODAL;
        END;
        //JPL09 STOP
        //ALLE_PKS
    end;


    procedure FillIndentLines(var pIndentLine: Record "Purchase Request Line"; tGatepassHeader: Record "Gate Pass Header")
    var
        vLineNo: Integer;
    begin
        //ALLE_PKS
        //JPL09 START
        vLineNo := 0;
        ToLineRec.RESET;
        ToLineRec.SETRANGE("Document No.", tGatepassHeader."Document No.");
        IF ToLineRec.FIND('+') THEN
            vLineNo := ToLineRec."Line No.";

        IF pIndentLine.FIND('-') THEN BEGIN
            REPEAT
                vLineNo := vLineNo + 10000;
                ToLineRec.INIT;
                ToLineRec."Document No." := tGatepassHeader."Document No.";
                ToLineRec."Line No." := vLineNo + 10000;
                ToLineRec.INSERT;
                pIndentLine.CALCFIELDS("TO Qty");
                pIndentLine.CALCFIELDS("PO Qty");
                pIndentLine.CALCFIELDS("Qty in Issue");

                ToLineRec.VALIDATE("Item No.", pIndentLine."No.");
                ToLineRec.VALIDATE(ToLineRec."Shortcut Dimension 2 Code", tGatepassHeader."Shortcut Dimension 2 Code");
                ToLineRec.VALIDATE("Required Qty", (pIndentLine."Quantity Base" - pIndentLine."TO Qty" - pIndentLine."PO Qty"
                                                   - pIndentLine."Qty in Issue")
                / pIndentLine."Purch Qty Per Unit Of Measure");
                ToLineRec.Description := pIndentLine.Description;
                ToLineRec."Description 2" := pIndentLine."Description 2";
                ToLineRec."Indent No." := pIndentLine."Document No.";
                ToLineRec."Indent Line No." := pIndentLine."Line No.";
                ToLineRec.VALIDATE("Shortcut Dimension 1 Code", tGatepassHeader."Shortcut Dimension 1 Code");
                ToLineRec.VALIDATE("Shortcut Dimension 2 Code", pIndentLine."Shortcut Dimension 2 Code");
                ToLineRec.VALIDATE("Location Code", tGatepassHeader."Location Code");

                /*DefDimRec.RESET;
                DefDimRec.GET(27,pIndentLine."No.",'COST CENTER');
                ToLineRec."Shortcut Dimension 2 Code":=DefDimRec."Dimension Value Code";
                ToLineRec.VALIDATE(ToLineRec."Shortcut Dimension 2 Code");
                                 */
                ToLineRec.MODIFY;
            UNTIL pIndentLine.NEXT = 0;
        END;
        //JPL09 STOP
        //ALLE_PKS

    end;


    procedure GetFOCLines()
    begin
        //ALLE_PKS
        //JPL09 START
        GPassHeader.GET("Document Type", "Document No.");
        FOCLine.RESET;
        FOCLine.SETRANGE("No.", "Purchase Order No.");
        IF FOCLine.FIND('-') THEN BEGIN
            CLEAR(GPLineForm);
            FOCListForm.SETTABLEVIEW(FOCLine);
            FOCListForm.LOOKUPMODE := TRUE;
            FOCListForm.SetGatePassHeader(GPassHeader);
            FOCListForm.SetMINMode(TRUE);
            FOCListForm.RUNMODAL;
        END;
        //JPL09 STOP
        //ALLE_PKS
    end;


    procedure FillFOCLines(var pIndentLine: Record "FOC/PO TABLE"; tGatepassHeader: Record "Gate Pass Header")
    var
        vLineNo: Integer;
    begin
        //ALLE_PKS
        //JPL09 START
        vLineNo := 0;
        ToLineRec.RESET;
        ToLineRec.SETRANGE("Document No.", tGatepassHeader."Document No.");
        IF ToLineRec.FIND('+') THEN
            vLineNo := ToLineRec."Line No.";

        IF pIndentLine.FIND('-') THEN BEGIN
            REPEAT
                vLineNo := vLineNo + 10000;
                ToLineRec.INIT;
                ToLineRec."Document No." := tGatepassHeader."Document No.";
                ToLineRec."Document Type" := tGatepassHeader."Document Type";
                ToLineRec."Line No." := vLineNo + 10000;
                ToLineRec.INSERT;

                ToLineRec.VALIDATE("Item No.", pIndentLine."Item Code");
                /*
                //ToLineRec.VALIDATE(ToLineRec."Shortcut Dimension 2 Code",tGatepassHeader."Shortcut Dimension 2 Code");
                //ToLineRec.VALIDATE("Required Qty",(pIndentLine."Quantity Base"-pIndentLine."TO Qty"-pIndentLine."PO Qty"
                                                   -pIndentLine."Qty in Issue")
                /pIndentLine."Purch Qty Per Unit Of Measure");
                ToLineRec.Description :=pIndentLine.Description ;
                ToLineRec."Description 2":=pIndentLine."Description 2";
                ToLineRec."Indent No.":=pIndentLine."Document No.";
                ToLineRec."Indent Line No.":=pIndentLine."Line No.";
                */
                ToLineRec."Purchase Order No." := pIndentLine."No.";
                ToLineRec."PO Line No." := pIndentLine."Line No.";

                ToLineRec.VALIDATE("Shortcut Dimension 1 Code", tGatepassHeader."Shortcut Dimension 1 Code");
                /*
                ToLineRec.VALIDATE("Shortcut Dimension 2 Code",pIndentLine."Shortcut Dimension 2 Code");
                */
                ToLineRec.VALIDATE("Location Code", tGatepassHeader."Location Code");

                /*DefDimRec.RESET;
                DefDimRec.GET(27,pIndentLine."No.",'COST CENTER');
                ToLineRec."Shortcut Dimension 2 Code":=DefDimRec."Dimension Value Code";
                ToLineRec.VALIDATE(ToLineRec."Shortcut Dimension 2 Code");
                                 */
                ToLineRec.MODIFY;
            UNTIL pIndentLine.NEXT = 0;
        END;
        //JPL09 STOP
        //ALLE_PKS

    end;


    procedure CheckIndent()
    begin
        FOCLine.RESET;
        FOCLine.SETRANGE("Document Type", FOCLine."Document Type"::Order);
        FOCLine.SETRANGE("No.", "Purchase Order No.");
        FOCLine.SETRANGE("Line No.", "PO Line No.");
        IF FOCLine.FINDFIRST THEN BEGIN
            IF FOCLine.Type <> FOCLine.Type::Finished THEN BEGIN
                FOCLine.CALCFIELDS(FOCLine."Quantity Issued");
                IF (Qty - xRec.Qty) > FOCLine."Quantity Issued" THEN
                    ERROR('Total Quantity Can not be grater than' + '-' + FORMAT(FOCLine."Quantity Issued"));
            END;
        END;
    end;


    procedure OpenFreeSampleTrackingLines()
    var
        FreeSampleItmJnlLn: Record "Job Journal Line";
        ReserveItemJnlLine: Codeunit "Job Jnl. Line-Reserve";
    begin
        // RAHEE1.00 240212 Start
        TESTFIELD("Item No.");
        TESTFIELD(Qty);

        FreeSampleItmJnlLn.RESET;
        FreeSampleItmJnlLn.SETRANGE("Journal Template Name", 'MIN');
        FreeSampleItmJnlLn.SETRANGE("Journal Batch Name", 'MIN');
        FreeSampleItmJnlLn.SETRANGE("Document No.", "Document No.");
        FreeSampleItmJnlLn.SETRANGE("MIN Line No.", "Line No.");
        IF FreeSampleItmJnlLn.FINDFIRST THEN BEGIN
            //ReserveItemJnlLine.SetFreeSampleInfo("Document No.","Line No."); // ALLE MM Code Commented
            ReserveItemJnlLine.CallItemTracking(FreeSampleItmJnlLn, FALSE);
        END;
        // RAHEE1.00 240212 End
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        dimmgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        VerifyItemLineDim;
    end;

    local procedure VerifyItemLineDim()
    begin
        IF IsReceivedShippedItemDimChanged THEN
            ConfirmReceivedShippedItemDimChange;
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          dimmgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Document Type", "Document No.", "Line No."));
        VerifyItemLineDim;
        dimmgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure IsReceivedShippedItemDimChanged(): Boolean
    begin
        EXIT(("Dimension Set ID" <> xRec."Dimension Set ID"))
    end;


    procedure ConfirmReceivedShippedItemDimChange(): Boolean
    begin
        IF NOT CONFIRM(Text049, TRUE, TABLECAPTION) THEN
            ERROR(Text050);

        EXIT(TRUE);
    end;
}

