pageextension 50012 "BBG Item Card Ext" extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        modify("No.")
        {
            Visible = true;
            ApplicationArea = All;
            Editable = false;
        }
        modify("Item Category Code")
        {
            ShowMandatory = TRUE;
        }
        addafter(Item)
        {
            group("BBG Fields")
            {
                Caption = 'BBG Fields';
                field("Khasra 1"; Rec."Khasra 1")
                {
                    ApplicationArea = All;
                }
                field("Khasra 2"; Rec."Khasra 2")
                {
                    ApplicationArea = All;
                }
                field("Registered Doc. No."; Rec."Registered Doc. No.")
                {
                    ApplicationArea = All;
                }
                field("Agreement SL. No."; Rec."Agreement SL. No.")
                {
                    ApplicationArea = All;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                }
                field("Agreement SL. Date"; Rec."Agreement SL. Date")
                {
                    ApplicationArea = All;
                }
                field("Area Acre"; Rec."Area Acre")
                {
                    ApplicationArea = All;
                }
                field("Registry Doc Serial No."; Rec."Registry Doc Serial No.")
                {
                    ApplicationArea = All;
                }

            }
        }


        moveafter(Description; "Description 2")
        addafter("Description 2")
        {
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = All;
            }
            field("Description 4"; Rec."Description 4")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Description 4"; "Base Unit of Measure")
        moveafter("Base Unit of Measure"; AssemblyBOM)
        moveafter(AssemblyBOM; "Shelf No.")
        moveafter("Shelf No."; "Automatic Ext. Texts")
        moveafter("Automatic Ext. Texts"; "Created From Nonstock Item")
        moveafter("Created From Nonstock Item"; "Item Category Code")
        addafter("Item Category Code")
        {
            field("BBG Product Group Code"; Rec."BBG Product Group Code")
            {
                ShowMandatory = true;
                ApplicationArea = all;
            }
            field("Sub Product Group Code"; Rec."Sub Product Group Code")
            {
                ShowMandatory = true;
                ApplicationArea = All;
            }
            field("Specification Code"; Rec."Specification Code")
            {
                ApplicationArea = All;
            }
            field("Drawing Code"; Rec."Drawing Code")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Drawing Code"; "Search Description")
        addafter("Search Description")
        {
            field("Tolerance  Percentage"; Rec."Tolerance  Percentage")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Tolerance  Percentage"; "Manufacturer Code")
        addafter("Manufacturer Code")
        {
            field("Qty in Stock"; Rec."Qty in Stock")
            {
                ApplicationArea = All;
            }
            field("Auto Indent"; Rec."Auto Indent")
            {
                ApplicationArea = All;
            }
            field("Client Material"; Rec."Client Material")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ShowMandatory = true;
                ApplicationArea = All;
            }
        }
        moveafter("Global Dimension 2 Code"; Inventory)
        addafter(Inventory)
        {
            field("Type of Item"; Rec."Type of Item")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Type of Item"; "Qty. on Purch. Order")
        moveafter("Qty. on Purch. Order"; "Qty. on Prod. Order")
        moveafter("Qty. on Prod. Order"; "Qty. on Component Lines")
        moveafter("Qty. on Component Lines"; "Qty. on Sales Order")
        moveafter("Qty. on Sales Order"; "Qty. on Service Order")
        moveafter("Qty. on Service Order"; "Service Item Group")
        moveafter("Service Item Group"; "Qty. on Assembly Order")
        moveafter("Qty. on Assembly Order"; "Qty. on Asm. Component")
        moveafter("Qty. on Asm. Component"; Blocked)
        moveafter(Blocked; "Last Date Modified")
        moveafter("Last Date Modified"; StockoutWarningDefaultNo)
        moveafter(StockoutWarningDefaultNo; PreventNegInventoryDefaultNo)
        addafter(PreventNegInventoryDefaultNo)
        {
            field("Indent ReOrder Point"; Rec."Indent ReOrder Point")
            {
                ApplicationArea = All;
            }
            field("Indent ReOrder Quantity"; Rec."Indent ReOrder Quantity")
            {
                ApplicationArea = All;
            }
            field("Net Change - Open"; Rec."Net Change - Open")
            {
                ApplicationArea = All;
            }
            field("Qty on Indent"; Rec."Qty on Indent")
            {
                ApplicationArea = All;
            }
            field("Purchases (Qty.)"; Rec."Purchases (Qty.)")
            {
                ApplicationArea = All;
            }
            field("Purchases (LCY)"; Rec."Purchases (LCY)")
            {
                ApplicationArea = All;
            }
            field("No. of Documents"; Rec."No. of Documents")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Silver / Gold in Grams"; Rec."Silver / Gold in Grams")
            {
                ApplicationArea = All;
            }
            field("Land FG Item"; Rec."Land FG Item")
            {
                ApplicationArea = All;
            }
        }


        addafter(Item)
        {
            group("BBG Invoicing")
            {
                Caption = 'Invoicing';

            }
        }
        movefirst("BBG Invoicing"; "Costing Method", "Cost is Adjusted", "Cost is Posted to G/L", "Standard Cost", "Unit Cost", "Overhead Rate", "Indirect Cost %", "Last Direct Cost", "Price/Profit Calculation", "Profit %", "Unit Price", "Gen. Prod. Posting Group", "VAT Prod. Posting Group", "Tax Group Code", "GST Group Code", "GST Credit", "HSN/SAC Code", Exempted, "Inventory Posting Group", "Default Deferral Template Code", "Net Invoiced Qty.", "Allow Invoice Disc.", "Item Disc. Group", "Sales Unit of Measure")
    }

    actions
    {
        // Add changes to page actions here
        addafter(Approval)
        {
            action(Confirm)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    RecRef.GET(Rec.RecordId);
                    MasterSetup.MasterValidate(RecRef);
                end;
            }
            action(TurnOver)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    RecRef.GET(Rec.RecordId);
                    MasterSetup.MasterValidate(RecRef);
                end;
            }
        }
    }

    var
        myInt: Integer;
        Item: Record Item;
        LastItem: Code[20];
        ItemCategoryCode: Code[20];
        ProductGroupCode: Code[20];
        SubProductGroupCode: Code[20];
        ItemCat: Record "Item Category";
        //        ItemPG: Record 5723;
        // ItemSPG: Record 97738;
        MasterSetup: Record "Master Mandatory Setup";
        RecRef: RecordRef;
    // FOCForm: Page 97817;
    // FOC1: Record 97797;
    // FOC2: Record 97797;

    trigger OnOpenPage()
    begin
        SetSecurity(TRUE);
    end;

    trigger OnAfterGetRecord()
    Begin
        Rec.SETRANGE("No."); // Custom code
        SetSecurity(FALSE);
    End;

    LOCAL PROCEDURE SetSecurity(OpenForm: Boolean);
    BEGIN
        /*
        //ALLEDK 030313
        IF OpenForm THEN BEGIN
          IF NOT Security.GetSecurity(FORM::"Item Card") THEN
            EXIT;

          IF Security."Form General Permission" = Security."Form General Permission"::Visible THEN
            CurrForm.EDI(FALSE);

          Security.SetFieldFilters(Rec);
        END ELSE
          IF Security."Security for Form No." = 0 THEN
            EXIT;

        IF CurrForm."No.".EDI THEN
          CurrForm."No.".EDI(Security."No." = 0);
        CurrForm."No.".VISIBLE(Security."No." IN [0,1,3,4]);
        IF Security."No." IN [2,5] THEN
          SETRANGE("No.");
        IF CurrForm.Description.EDI THEN
          CurrForm.Description.EDI(Security.Description = 0);
        CurrForm.Description.VISIBLE(Security.Description IN [0,1,3,4]);
        IF Security.Description IN [2,5] THEN
          SETRANGE(Description);
        IF CurrForm."Search Description".EDI THEN
          CurrForm."Search Description".EDI(Security."Search Description" = 0);
        CurrForm."Search Description".VISIBLE(Security."Search Description" IN [0,1,3,4]);
        IF Security."Search Description" IN [2,5] THEN
          SETRANGE("Search Description");
        IF CurrForm."Description 2".EDI THEN
          CurrForm."Description 2".EDI(Security."Description 2" = 0);
        CurrForm."Description 2".VISIBLE(Security."Description 2" IN [0,1,3,4]);
        IF Security."Description 2" IN [2,5] THEN
          SETRANGE("Description 2");
        IF CurrForm."Bill of Materials".EDI THEN
          CurrForm."Bill of Materials".EDI(Security."Bill of Materials" = 0);
        CurrForm."Bill of Materials".VISIBLE(Security."Bill of Materials" IN [0,1,3,4]);
        IF Security."Bill of Materials" IN [2,5] THEN
          SETRANGE("Bill of Materials");
        IF CurrForm."Base Unit of Measure".EDI THEN
          CurrForm."Base Unit of Measure".EDI(Security."Base Unit of Measure" = 0);
        CurrForm."Base Unit of Measure".VISIBLE(Security."Base Unit of Measure" IN [0,1,3,4]);
        IF Security."Base Unit of Measure" IN [2,5] THEN
          SETRANGE("Base Unit of Measure");
        IF CurrForm."Inventory Posting Group".EDI THEN
          CurrForm."Inventory Posting Group".EDI(Security."Inventory Posting Group" = 0);
        CurrForm."Inventory Posting Group".VISIBLE(Security."Inventory Posting Group" IN [0,1,3,4]);
        IF Security."Inventory Posting Group" IN [2,5] THEN
          SETRANGE("Inventory Posting Group");
        IF CurrForm."Shelf No.".EDI THEN
          CurrForm."Shelf No.".EDI(Security."Shelf No." = 0);
        CurrForm."Shelf No.".VISIBLE(Security."Shelf No." IN [0,1,3,4]);
        IF Security."Shelf No." IN [2,5] THEN
          SETRANGE("Shelf No.");
        IF CurrForm."Item Disc. Group".EDI THEN
          CurrForm."Item Disc. Group".EDI(Security."Item Disc. Group" = 0);
        CurrForm."Item Disc. Group".VISIBLE(Security."Item Disc. Group" IN [0,1,3,4]);
        IF Security."Item Disc. Group" IN [2,5] THEN
          SETRANGE("Item Disc. Group");
        IF CurrForm."Allow Invoice Disc.".EDI THEN
          CurrForm."Allow Invoice Disc.".EDI(Security."Allow Invoice Disc." = 0);
        CurrForm."Allow Invoice Disc.".VISIBLE(Security."Allow Invoice Disc." IN [0,1,3,4]);
        IF Security."Allow Invoice Disc." IN [2,5] THEN
          SETRANGE("Allow Invoice Disc.");
        IF CurrForm."Unit Price".EDI THEN
          CurrForm."Unit Price".EDI(Security."Unit Price" = 0);
        CurrForm."Unit Price".VISIBLE(Security."Unit Price" IN [0,1,3,4]);
        IF Security."Unit Price" IN [2,5] THEN
          SETRANGE("Unit Price");
        IF CurrForm."Price/Profit Calculation".EDI THEN
          CurrForm."Price/Profit Calculation".EDI(Security."Price/Profit Calculation" = 0);
        CurrForm."Price/Profit Calculation".VISIBLE(Security."Price/Profit Calculation" IN [0,1,3,4]);
        IF Security."Price/Profit Calculation" IN [2,5] THEN
          SETRANGE("Price/Profit Calculation");
        IF CurrForm."Profit %".EDI THEN
          CurrForm."Profit %".EDI(Security."Profit %" = 0);
        CurrForm."Profit %".VISIBLE(Security."Profit %" IN [0,1,3,4]);
        IF Security."Profit %" IN [2,5] THEN
          SETRANGE("Profit %");
        IF CurrForm."Costing Method".EDI THEN
          CurrForm."Costing Method".EDI(Security."Costing Method" = 0);
        CurrForm."Costing Method".VISIBLE(Security."Costing Method" IN [0,1,3,4]);
        IF Security."Costing Method" IN [2,5] THEN
          SETRANGE("Costing Method");
        IF CurrForm."Unit Cost".EDI THEN
          CurrForm."Unit Cost".EDI(Security."Unit Cost" = 0);
        CurrForm."Unit Cost".VISIBLE(Security."Unit Cost" IN [0,1,3,4]);
        IF Security."Unit Cost" IN [2,5] THEN
          SETRANGE("Unit Cost");
        IF CurrForm."Standard Cost".EDI THEN
          CurrForm."Standard Cost".EDI(Security."Standard Cost" = 0);
        CurrForm."Standard Cost".VISIBLE(Security."Standard Cost" IN [0,1,3,4]);
        IF Security."Standard Cost" IN [2,5] THEN
          SETRANGE("Standard Cost");
        IF CurrForm."Last Direct Cost".EDI THEN
          CurrForm."Last Direct Cost".EDI(Security."Last Direct Cost" = 0);
        CurrForm."Last Direct Cost".VISIBLE(Security."Last Direct Cost" IN [0,1,3,4]);
        IF Security."Last Direct Cost" IN [2,5] THEN
          SETRANGE("Last Direct Cost");
        IF CurrForm."Indirect Cost %".EDI THEN
          CurrForm."Indirect Cost %".EDI(Security."Indirect Cost %" = 0);
        CurrForm."Indirect Cost %".VISIBLE(Security."Indirect Cost %" IN [0,1,3,4]);
        IF Security."Indirect Cost %" IN [2,5] THEN
          SETRANGE("Indirect Cost %");
        IF CurrForm."Cost is Adjusted".EDI THEN
          CurrForm."Cost is Adjusted".EDI(Security."Cost is Adjusted" = 0);
        CurrForm."Cost is Adjusted".VISIBLE(Security."Cost is Adjusted" IN [0,1,3,4]);
        IF Security."Cost is Adjusted" IN [2,5] THEN
          SETRANGE("Cost is Adjusted");
        IF CurrForm."Vendor No.".EDI THEN
          CurrForm."Vendor No.".EDI(Security."Vendor No." = 0);
        CurrForm."Vendor No.".VISIBLE(Security."Vendor No." IN [0,1,3,4]);
        IF Security."Vendor No." IN [2,5] THEN
          SETRANGE("Vendor No.");
        IF CurrForm."Vendor Item No.".EDI THEN
          CurrForm."Vendor Item No.".EDI(Security."Vendor Item No." = 0);
        CurrForm."Vendor Item No.".VISIBLE(Security."Vendor Item No." IN [0,1,3,4]);
        IF Security."Vendor Item No." IN [2,5] THEN
          SETRANGE("Vendor Item No.");
        IF CurrForm."Lead Time Calculation".EDI THEN
          CurrForm."Lead Time Calculation".EDI(Security."Lead Time Calculation" = 0);
        CurrForm."Lead Time Calculation".VISIBLE(Security."Lead Time Calculation" IN [0,1,3,4]);
        IF Security."Lead Time Calculation" IN [2,5] THEN
          SETRANGE("Lead Time Calculation");
        IF CurrForm."Reorder Point".EDI THEN
          CurrForm."Reorder Point".EDI(Security."Reorder Point" = 0);
        CurrForm."Reorder Point".VISIBLE(Security."Reorder Point" IN [0,1,3,4]);
        IF Security."Reorder Point" IN [2,5] THEN
          SETRANGE("Reorder Point");
        IF CurrForm."Maximum Inventory".EDI THEN
          CurrForm."Maximum Inventory".EDI(Security."Maximum Inventory" = 0);
        CurrForm."Maximum Inventory".VISIBLE(Security."Maximum Inventory" IN [0,1,3,4]);
        IF Security."Maximum Inventory" IN [2,5] THEN
          SETRANGE("Maximum Inventory");
        IF CurrForm."Reorder Quantity".EDI THEN
          CurrForm."Reorder Quantity".EDI(Security."Reorder Quantity" = 0);
        CurrForm."Reorder Quantity".VISIBLE(Security."Reorder Quantity" IN [0,1,3,4]);
        IF Security."Reorder Quantity" IN [2,5] THEN
          SETRANGE("Reorder Quantity");
        IF CurrForm."Gross Weight".EDI THEN
          CurrForm."Gross Weight".EDI(Security."Gross Weight" = 0);
        CurrForm."Gross Weight".VISIBLE(Security."Gross Weight" IN [0,1,3,4]);
        IF Security."Gross Weight" IN [2,5] THEN
          SETRANGE("Gross Weight");
        IF CurrForm."Net Weight".EDI THEN
          CurrForm."Net Weight".EDI(Security."Net Weight" = 0);
        CurrForm."Net Weight".VISIBLE(Security."Net Weight" IN [0,1,3,4]);
        IF Security."Net Weight" IN [2,5] THEN
          SETRANGE("Net Weight");
        IF CurrForm."Tariff No.".EDI THEN
          CurrForm."Tariff No.".EDI(Security."Tariff No." = 0);
        CurrForm."Tariff No.".VISIBLE(Security."Tariff No." IN [0,1,3,4]);
        IF Security."Tariff No." IN [2,5] THEN
          SETRANGE("Tariff No.");
        IF CurrForm.Blocked.EDI THEN
          CurrForm.Blocked.EDI(Security.Blocked = 0);
        CurrForm.Blocked.VISIBLE(Security.Blocked IN [0,1,3,4]);
        IF Security.Blocked IN [2,5] THEN
          SETRANGE(Blocked);
        IF CurrForm."Cost is Posted to G/L".EDI THEN
          CurrForm."Cost is Posted to G/L".EDI(Security."Cost is Posted to G/L" = 0);
        CurrForm."Cost is Posted to G/L".VISIBLE(Security."Cost is Posted to G/L" IN [0,1,3,4]);
        IF Security."Cost is Posted to G/L" IN [2,5] THEN
          SETRANGE("Cost is Posted to G/L");
        IF CurrForm."Last Date Modified".EDI THEN
          CurrForm."Last Date Modified".EDI(Security."Last Date Modified" = 0);
        CurrForm."Last Date Modified".VISIBLE(Security."Last Date Modified" IN [0,1,3,4]);
        IF Security."Last Date Modified" IN [2,5] THEN
          SETRANGE("Last Date Modified");
        IF CurrForm.Inventory.EDI THEN
          CurrForm.Inventory.EDI(Security.Inventory = 0);
        CurrForm.Inventory.VISIBLE(Security.Inventory IN [0,1,3,4]);
        IF Security.Inventory IN [2,5] THEN
          SETRANGE(Inventory);
        IF CurrForm."Net Invoiced Qty.".EDI THEN
          CurrForm."Net Invoiced Qty.".EDI(Security."Net Invoiced Qty." = 0);
        CurrForm."Net Invoiced Qty.".VISIBLE(Security."Net Invoiced Qty." IN [0,1,3,4]);
        IF Security."Net Invoiced Qty." IN [2,5] THEN
          SETRANGE("Net Invoiced Qty.");
        IF CurrForm."Purchases (Qty.)".EDI THEN
          CurrForm."Purchases (Qty.)".EDI(Security."Purchases (Qty.)" = 0);
        CurrForm."Purchases (Qty.)".VISIBLE(Security."Purchases (Qty.)" IN [0,1,3,4]);
        IF Security."Purchases (Qty.)" IN [2,5] THEN
          SETRANGE("Purchases (Qty.)");
        IF CurrForm."Purchases (LCY)".EDI THEN
          CurrForm."Purchases (LCY)".EDI(Security."Purchases (LCY)" = 0);
        CurrForm."Purchases (LCY)".VISIBLE(Security."Purchases (LCY)" IN [0,1,3,4]);
        IF Security."Purchases (LCY)" IN [2,5] THEN
          SETRANGE("Purchases (LCY)");
        IF CurrForm."Qty. on Purch. Order".EDI THEN
          CurrForm."Qty. on Purch. Order".EDI(Security."Qty. on Purch. Order" = 0);
        CurrForm."Qty. on Purch. Order".VISIBLE(Security."Qty. on Purch. Order" IN [0,1,3,4]);
        IF Security."Qty. on Purch. Order" IN [2,5] THEN
          SETRANGE("Qty. on Purch. Order");
        IF CurrForm."Qty. on Sales Order".EDI THEN
          CurrForm."Qty. on Sales Order".EDI(Security."Qty. on Sales Order" = 0);
        CurrForm."Qty. on Sales Order".VISIBLE(Security."Qty. on Sales Order" IN [0,1,3,4]);
        IF Security."Qty. on Sales Order" IN [2,5] THEN
          SETRANGE("Qty. on Sales Order");
        IF CurrForm."Gen. Prod. Posting Group".EDI THEN
          CurrForm."Gen. Prod. Posting Group".EDI(Security."Gen. Prod. Posting Group" = 0);
        CurrForm."Gen. Prod. Posting Group".VISIBLE(Security."Gen. Prod. Posting Group" IN [0,1,3,4]);
        IF Security."Gen. Prod. Posting Group" IN [2,5] THEN
          SETRANGE("Gen. Prod. Posting Group");
        IF CurrForm."Country/Region of Origin Code".EDI THEN
          CurrForm."Country/Region of Origin Code".EDI(Security."Country/Region of Origin Code" = 0);
        CurrForm."Country/Region of Origin Code".VISIBLE(Security."Country/Region of Origin Code" IN [0,1,3,4]);
        IF Security."Country/Region of Origin Code" IN [2,5] THEN
          SETRANGE("Country/Region of Origin Code");
        IF CurrForm."Automatic Ext. Texts".EDI THEN
          CurrForm."Automatic Ext. Texts".EDI(Security."Automatic Ext. Texts" = 0);
        CurrForm."Automatic Ext. Texts".VISIBLE(Security."Automatic Ext. Texts" IN [0,1,3,4]);
        IF Security."Automatic Ext. Texts" IN [2,5] THEN
          SETRANGE("Automatic Ext. Texts");
        IF CurrForm."Tax Group Code".EDI THEN
          CurrForm."Tax Group Code".EDI(Security."Tax Group Code" = 0);
        CurrForm."Tax Group Code".VISIBLE(Security."Tax Group Code" IN [0,1,3,4]);
        IF Security."Tax Group Code" IN [2,5] THEN
          SETRANGE("Tax Group Code");
        IF CurrForm."VAT Prod. Posting Group".EDI THEN
          CurrForm."VAT Prod. Posting Group".EDI(Security."VAT Prod. Posting Group" = 0);
        CurrForm."VAT Prod. Posting Group".VISIBLE(Security."VAT Prod. Posting Group" IN [0,1,3,4]);
        IF Security."VAT Prod. Posting Group" IN [2,5] THEN
          SETRANGE("VAT Prod. Posting Group");
        IF CurrForm.Reserve.EDI THEN
          CurrForm.Reserve.EDI(Security.Reserve = 0);
        CurrForm.Reserve.VISIBLE(Security.Reserve IN [0,1,3,4]);
        IF Security.Reserve IN [2,5] THEN
          SETRANGE(Reserve);
        IF CurrForm."Global Dimension 2 Code".EDI THEN
          CurrForm."Global Dimension 2 Code".EDI(Security."Global Dimension 2 Code" = 0);
        CurrForm."Global Dimension 2 Code".VISIBLE(Security."Global Dimension 2 Code" IN [0,1,3,4]);
        IF Security."Global Dimension 2 Code" IN [2,5] THEN
          SETRANGE("Global Dimension 2 Code");
        IF CurrForm."Lot Size".EDI THEN
          CurrForm."Lot Size".EDI(Security."Lot Size" = 0);
        CurrForm."Lot Size".VISIBLE(Security."Lot Size" IN [0,1,3,4]);
        IF Security."Lot Size" IN [2,5] THEN
          SETRANGE("Lot Size");
        IF CurrForm."Serial Nos.".EDI THEN
          CurrForm."Serial Nos.".EDI(Security."Serial Nos." = 0);
        CurrForm."Serial Nos.".VISIBLE(Security."Serial Nos." IN [0,1,3,4]);
        IF Security."Serial Nos." IN [2,5] THEN
          SETRANGE("Serial Nos.");
        IF CurrForm."Scrap %".EDI THEN
          CurrForm."Scrap %".EDI(Security."Scrap %" = 0);
        CurrForm."Scrap %".VISIBLE(Security."Scrap %" IN [0,1,3,4]);
        IF Security."Scrap %" IN [2,5] THEN
          SETRANGE("Scrap %");
        IF CurrForm."Inventory Value Zero".EDI THEN
          CurrForm."Inventory Value Zero".EDI(Security."Inventory Value Zero" = 0);
        CurrForm."Inventory Value Zero".VISIBLE(Security."Inventory Value Zero" IN [0,1,3,4]);
        IF Security."Inventory Value Zero" IN [2,5] THEN
          SETRANGE("Inventory Value Zero");
        IF CurrForm."Minimum Order Quantity".EDI THEN
          CurrForm."Minimum Order Quantity".EDI(Security."Minimum Order Quantity" = 0);
        CurrForm."Minimum Order Quantity".VISIBLE(Security."Minimum Order Quantity" IN [0,1,3,4]);
        IF Security."Minimum Order Quantity" IN [2,5] THEN
          SETRANGE("Minimum Order Quantity");
        IF CurrForm."Maximum Order Quantity".EDI THEN
          CurrForm."Maximum Order Quantity".EDI(Security."Maximum Order Quantity" = 0);
        CurrForm."Maximum Order Quantity".VISIBLE(Security."Maximum Order Quantity" IN [0,1,3,4]);
        IF Security."Maximum Order Quantity" IN [2,5] THEN
          SETRANGE("Maximum Order Quantity");
        IF CurrForm."Safety Stock Quantity".EDI THEN
          CurrForm."Safety Stock Quantity".EDI(Security."Safety Stock Quantity" = 0);
        CurrForm."Safety Stock Quantity".VISIBLE(Security."Safety Stock Quantity" IN [0,1,3,4]);
        IF Security."Safety Stock Quantity" IN [2,5] THEN
          SETRANGE("Safety Stock Quantity");
        IF CurrForm."Order Multiple".EDI THEN
          CurrForm."Order Multiple".EDI(Security."Order Multiple" = 0);
        CurrForm."Order Multiple".VISIBLE(Security."Order Multiple" IN [0,1,3,4]);
        IF Security."Order Multiple" IN [2,5] THEN
          SETRANGE("Order Multiple");
        IF CurrForm."Safety Lead Time".EDI THEN
          CurrForm."Safety Lead Time".EDI(Security."Safety Lead Time" = 0);
        CurrForm."Safety Lead Time".VISIBLE(Security."Safety Lead Time" IN [0,1,3,4]);
        IF Security."Safety Lead Time" IN [2,5] THEN
          SETRANGE("Safety Lead Time");
        IF CurrForm."Flushing Method".EDI THEN
          CurrForm."Flushing Method".EDI(Security."Flushing Method" = 0);
        CurrForm."Flushing Method".VISIBLE(Security."Flushing Method" IN [0,1,3,4]);
        IF Security."Flushing Method" IN [2,5] THEN
          SETRANGE("Flushing Method");
        IF CurrForm."Replenishment System".EDI THEN
          CurrForm."Replenishment System".EDI(Security."Replenishment System" = 0);
        CurrForm."Replenishment System".VISIBLE(Security."Replenishment System" IN [0,1,3,4]);
        IF Security."Replenishment System" IN [2,5] THEN
          SETRANGE("Replenishment System");
        IF CurrForm."Rounding Precision".EDI THEN
          CurrForm."Rounding Precision".EDI(Security."Rounding Precision" = 0);
        CurrForm."Rounding Precision".VISIBLE(Security."Rounding Precision" IN [0,1,3,4]);
        IF Security."Rounding Precision" IN [2,5] THEN
          SETRANGE("Rounding Precision");
        IF CurrForm."Sales Unit of Measure".EDI THEN
          CurrForm."Sales Unit of Measure".EDI(Security."Sales Unit of Measure" = 0);
        CurrForm."Sales Unit of Measure".VISIBLE(Security."Sales Unit of Measure" IN [0,1,3,4]);
        IF Security."Sales Unit of Measure" IN [2,5] THEN
          SETRANGE("Sales Unit of Measure");
        IF CurrForm."Purch. Unit of Measure".EDI THEN
          CurrForm."Purch. Unit of Measure".EDI(Security."Purch. Unit of Measure" = 0);
        CurrForm."Purch. Unit of Measure".VISIBLE(Security."Purch. Unit of Measure" IN [0,1,3,4]);
        IF Security."Purch. Unit of Measure" IN [2,5] THEN
          SETRANGE("Purch. Unit of Measure");
        IF CurrForm."Reorder Cycle".EDI THEN
          CurrForm."Reorder Cycle".EDI(Security."Reorder Cycle" = 0);
        CurrForm."Reorder Cycle".VISIBLE(Security."Reorder Cycle" IN [0,1,3,4]);
        IF Security."Reorder Cycle" IN [2,5] THEN
          SETRANGE("Reorder Cycle");
        IF CurrForm."Reordering Policy".EDI THEN
          CurrForm."Reordering Policy".EDI(Security."Reordering Policy" = 0);
        CurrForm."Reordering Policy".VISIBLE(Security."Reordering Policy" IN [0,1,3,4]);
        IF Security."Reordering Policy" IN [2,5] THEN
          SETRANGE("Reordering Policy");
        IF CurrForm."Include Inventory".EDI THEN
          CurrForm."Include Inventory".EDI(Security."Include Inventory" = 0);
        CurrForm."Include Inventory".VISIBLE(Security."Include Inventory" IN [0,1,3,4]);
        IF Security."Include Inventory" IN [2,5] THEN
          SETRANGE("Include Inventory");
        IF CurrForm."Manufacturing Policy".EDI THEN
          CurrForm."Manufacturing Policy".EDI(Security."Manufacturing Policy" = 0);
        CurrForm."Manufacturing Policy".VISIBLE(Security."Manufacturing Policy" IN [0,1,3,4]);
        IF Security."Manufacturing Policy" IN [2,5] THEN
          SETRANGE("Manufacturing Policy");
        IF CurrForm."Stockkeeping Unit Exists".EDI THEN
          CurrForm."Stockkeeping Unit Exists".EDI(Security."Stockkeeping Unit Exists" = 0);
        CurrForm."Stockkeeping Unit Exists".VISIBLE(Security."Stockkeeping Unit Exists" IN [0,1,3,4]);
        IF Security."Stockkeeping Unit Exists" IN [2,5] THEN
          SETRANGE("Stockkeeping Unit Exists");
        IF CurrForm."Manufacturer Code".EDI THEN
          CurrForm."Manufacturer Code".EDI(Security."Manufacturer Code" = 0);
        CurrForm."Manufacturer Code".VISIBLE(Security."Manufacturer Code" IN [0,1,3,4]);
        IF Security."Manufacturer Code" IN [2,5] THEN
          SETRANGE("Manufacturer Code");
        IF CurrForm."Item Category Code".EDI THEN
          CurrForm."Item Category Code".EDI(Security."Item Category Code" = 0);
        CurrForm."Item Category Code".VISIBLE(Security."Item Category Code" IN [0,1,3,4]);
        IF Security."Item Category Code" IN [2,5] THEN
          SETRANGE("Item Category Code");
        IF CurrForm."Created From Nonstock Item".EDI THEN
          CurrForm."Created From Nonstock Item".EDI(Security."Created From Nonstock Item" = 0);
        CurrForm."Created From Nonstock Item".VISIBLE(Security."Created From Nonstock Item" IN [0,1,3,4]);
        IF Security."Created From Nonstock Item" IN [2,5] THEN
          SETRANGE("Created From Nonstock Item");
        IF CurrForm."Product Group Code".EDI THEN
          CurrForm."Product Group Code".EDI(Security."Product Group Code" = 0);
        CurrForm."Product Group Code".VISIBLE(Security."Product Group Code" IN [0,1,3,4]);
        IF Security."Product Group Code" IN [2,5] THEN
          SETRANGE("Product Group Code");
        IF CurrForm."Item Tracking Code".EDI THEN
          CurrForm."Item Tracking Code".EDI(Security."Item Tracking Code" = 0);
        CurrForm."Item Tracking Code".VISIBLE(Security."Item Tracking Code" IN [0,1,3,4]);
        IF Security."Item Tracking Code" IN [2,5] THEN
          SETRANGE("Item Tracking Code");
        IF CurrForm."Lot Nos.".EDI THEN
          CurrForm."Lot Nos.".EDI(Security."Lot Nos." = 0);
        CurrForm."Lot Nos.".VISIBLE(Security."Lot Nos." IN [0,1,3,4]);
        IF Security."Lot Nos." IN [2,5] THEN
          SETRANGE("Lot Nos.");
        IF CurrForm."Expiration Calculation".EDI THEN
          CurrForm."Expiration Calculation".EDI(Security."Expiration Calculation" = 0);
        CurrForm."Expiration Calculation".VISIBLE(Security."Expiration Calculation" IN [0,1,3,4]);
        IF Security."Expiration Calculation" IN [2,5] THEN
          SETRANGE("Expiration Calculation");
        IF CurrForm."Special Equipment Code".EDI THEN
          CurrForm."Special Equipment Code".EDI(Security."Special Equipment Code" = 0);
        CurrForm."Special Equipment Code".VISIBLE(Security."Special Equipment Code" IN [0,1,3,4]);
        IF Security."Special Equipment Code" IN [2,5] THEN
          SETRANGE("Special Equipment Code");
        IF CurrForm."Put-away Template Code".EDI THEN
          CurrForm."Put-away Template Code".EDI(Security."Put-away Template Code" = 0);
        CurrForm."Put-away Template Code".VISIBLE(Security."Put-away Template Code" IN [0,1,3,4]);
        IF Security."Put-away Template Code" IN [2,5] THEN
          SETRANGE("Put-away Template Code");
        IF CurrForm."Put-away Unit of Measure Code".EDI THEN
          CurrForm."Put-away Unit of Measure Code".EDI(Security."Put-away Unit of Measure Code" = 0);
        CurrForm."Put-away Unit of Measure Code".VISIBLE(Security."Put-away Unit of Measure Code" IN [0,1,3,4]);
        IF Security."Put-away Unit of Measure Code" IN [2,5] THEN
          SETRANGE("Put-away Unit of Measure Code");
        IF CurrForm."Phys Invt Counting Period Code".EDI THEN
          CurrForm."Phys Invt Counting Period Code".EDI(Security."Phys Invt Counting Period Code" = 0);
        CurrForm."Phys Invt Counting Period Code".VISIBLE(Security."Phys Invt Counting Period Code" IN [0,1,3,4]);
        IF Security."Phys Invt Counting Period Code" IN [2,5] THEN
          SETRANGE("Phys Invt Counting Period Code");
        IF CurrForm."Last Counting Period Update".EDI THEN
          CurrForm."Last Counting Period Update".EDI(Security."Last Counting Period Update" = 0);
        CurrForm."Last Counting Period Update".VISIBLE(Security."Last Counting Period Update" IN [0,1,3,4]);
        IF Security."Last Counting Period Update" IN [2,5] THEN
          SETRANGE("Last Counting Period Update");
        IF CurrForm."Next Counting Period".EDI THEN
          CurrForm."Next Counting Period".EDI(Security."Next Counting Period" = 0);
        CurrForm."Next Counting Period".VISIBLE(Security."Next Counting Period" IN [0,1,3,4]);
        IF Security."Next Counting Period" IN [2,5] THEN
          SETRANGE("Next Counting Period");
        IF CurrForm."Last Phys. Invt. Date".EDI THEN
          CurrForm."Last Phys. Invt. Date".EDI(Security."Last Phys. Invt. Date" = 0);
        CurrForm."Last Phys. Invt. Date".VISIBLE(Security."Last Phys. Invt. Date" IN [0,1,3,4]);
        IF Security."Last Phys. Invt. Date" IN [2,5] THEN
          SETRANGE("Last Phys. Invt. Date");
        IF CurrForm."Use Cross-Docking".EDI THEN
          CurrForm."Use Cross-Docking".EDI(Security."Use Cross-Docking" = 0);
        CurrForm."Use Cross-Docking".VISIBLE(Security."Use Cross-Docking" IN [0,1,3,4]);
        IF Security."Use Cross-Docking" IN [2,5] THEN
          SETRANGE("Use Cross-Docking");
        IF CurrForm."Identifier Code".EDI THEN
          CurrForm."Identifier Code".EDI(Security."Identifier Code" = 0);
        CurrForm."Identifier Code".VISIBLE(Security."Identifier Code" IN [0,1,3,4]);
        IF Security."Identifier Code" IN [2,5] THEN
          SETRANGE("Identifier Code");
        IF CurrForm."Excise Prod. Posting Group".EDI THEN
          CurrForm."Excise Prod. Posting Group".EDI(Security."Excise Prod. Posting Group" = 0);
        CurrForm."Excise Prod. Posting Group".VISIBLE(Security."Excise Prod. Posting Group" IN [0,1,3,4]);
        IF Security."Excise Prod. Posting Group" IN [2,5] THEN
          SETRANGE("Excise Prod. Posting Group");
        IF CurrForm."Excise Accounting Type".EDI THEN
          CurrForm."Excise Accounting Type".EDI(Security."Excise Accounting Type" = 0);
        CurrForm."Excise Accounting Type".VISIBLE(Security."Excise Accounting Type" IN [0,1,3,4]);
        IF Security."Excise Accounting Type" IN [2,5] THEN
          SETRANGE("Excise Accounting Type");
        IF CurrForm."Assessable Value".EDI THEN
          CurrForm."Assessable Value".EDI(Security."Assessable Value" = 0);
        CurrForm."Assessable Value".VISIBLE(Security."Assessable Value" IN [0,1,3,4]);
        IF Security."Assessable Value" IN [2,5] THEN
          SETRANGE("Assessable Value");
        IF CurrForm."Capital Item".EDI THEN
          CurrForm."Capital Item".EDI(Security."Capital Item" = 0);
        CurrForm."Capital Item".VISIBLE(Security."Capital Item" IN [0,1,3,4]);
        IF Security."Capital Item" IN [2,5] THEN
          SETRANGE("Capital Item");
        IF CurrForm.Subcontracting.EDI THEN
          CurrForm.Subcontracting.EDI(Security.Subcontracting = 0);
        CurrForm.Subcontracting.VISIBLE(Security.Subcontracting IN [0,1,3,4]);
        IF Security.Subcontracting IN [2,5] THEN
          SETRANGE(Subcontracting);
        IF CurrForm."Sub. Comp. Location".EDI THEN
          CurrForm."Sub. Comp. Location".EDI(Security."Sub. Comp. Location" = 0);
        CurrForm."Sub. Comp. Location".VISIBLE(Security."Sub. Comp. Location" IN [0,1,3,4]);
        IF Security."Sub. Comp. Location" IN [2,5] THEN
          SETRANGE("Sub. Comp. Location");
        IF CurrForm."Fixed Asset".EDI THEN
          CurrForm."Fixed Asset".EDI(Security."Fixed Asset" = 0);
        CurrForm."Fixed Asset".VISIBLE(Security."Fixed Asset" IN [0,1,3,4]);
        IF Security."Fixed Asset" IN [2,5] THEN
          SETRANGE("Fixed Asset");
        IF CurrForm."Scrap Item".EDI THEN
          CurrForm."Scrap Item".EDI(Security."Scrap Item" = 0);
        CurrForm."Scrap Item".VISIBLE(Security."Scrap Item" IN [0,1,3,4]);
        IF Security."Scrap Item" IN [2,5] THEN
          SETRANGE("Scrap Item");
        IF CurrForm."MRP Price".EDI THEN
          CurrForm."MRP Price".EDI(Security."MRP Price" = 0);
        CurrForm."MRP Price".VISIBLE(Security."MRP Price" IN [0,1,3,4]);
        IF Security."MRP Price" IN [2,5] THEN
          SETRANGE("MRP Price");
        IF CurrForm."MRP Value".EDI THEN
          CurrForm."MRP Value".EDI(Security."MRP Value" = 0);
        CurrForm."MRP Value".VISIBLE(Security."MRP Value" IN [0,1,3,4]);
        IF Security."MRP Value" IN [2,5] THEN
          SETRANGE("MRP Value");
        IF CurrForm."Abatement %".EDI THEN
          CurrForm."Abatement %".EDI(Security."Abatement %" = 0);
        CurrForm."Abatement %".VISIBLE(Security."Abatement %" IN [0,1,3,4]);
        IF Security."Abatement %" IN [2,5] THEN
          SETRANGE("Abatement %");
        IF CurrForm."PIT Structure".EDI THEN
          CurrForm."PIT Structure".EDI(Security."PIT Structure" = 0);
        CurrForm."PIT Structure".VISIBLE(Security."PIT Structure" IN [0,1,3,4]);
        IF Security."PIT Structure" IN [2,5] THEN
          SETRANGE("PIT Structure");
        IF CurrForm."Price Inclusive of Tax".EDI THEN
          CurrForm."Price Inclusive of Tax".EDI(Security."Price Inclusive of Tax" = 0);
        CurrForm."Price Inclusive of Tax".VISIBLE(Security."Price Inclusive of Tax" IN [0,1,3,4]);
        IF Security."Price Inclusive of Tax" IN [2,5] THEN
          SETRANGE("Price Inclusive of Tax");
        IF CurrForm."Tolerance  Percentage".EDI THEN
          CurrForm."Tolerance  Percentage".EDI(Security."Tolerance  Percentage" = 0);
        CurrForm."Tolerance  Percentage".VISIBLE(Security."Tolerance  Percentage" IN [0,1,3,4]);
        IF Security."Tolerance  Percentage" IN [2,5] THEN
          SETRANGE("Tolerance  Percentage");
        IF CurrForm."Sub Product Group Code".EDI THEN
          CurrForm."Sub Product Group Code".EDI(Security."ID 1 Code" = 0);
        CurrForm."Sub Product Group Code".VISIBLE(Security."ID 1 Code" IN [0,1,3,4]);
        IF Security."ID 1 Code" IN [2,5] THEN
          SETRANGE("Sub Product Group Code");
        IF CurrForm."Description 3".EDI THEN
          CurrForm."Description 3".EDI(Security."Description 3" = 0);
        CurrForm."Description 3".VISIBLE(Security."Description 3" IN [0,1,3,4]);
        IF Security."Description 3" IN [2,5] THEN
          SETRANGE("Description 3");
        IF CurrForm."Description 4".EDI THEN
          CurrForm."Description 4".EDI(Security."Description 4" = 0);
        CurrForm."Description 4".VISIBLE(Security."Description 4" IN [0,1,3,4]);
        IF Security."Description 4" IN [2,5] THEN
          SETRANGE("Description 4");
        IF CurrForm."Auto Indent".EDI THEN
          CurrForm."Auto Indent".EDI(Security."Auto Indent" = 0);
        CurrForm."Auto Indent".VISIBLE(Security."Auto Indent" IN [0,1,3,4]);
        IF Security."Auto Indent" IN [2,5] THEN
          SETRANGE("Auto Indent");
        IF CurrForm."Indent ReOrder Point".EDI THEN
          CurrForm."Indent ReOrder Point".EDI(Security."Indent ReOrder Point" = 0);
        CurrForm."Indent ReOrder Point".VISIBLE(Security."Indent ReOrder Point" IN [0,1,3,4]);
        IF Security."Indent ReOrder Point" IN [2,5] THEN
          SETRANGE("Indent ReOrder Point");
        IF CurrForm."Indent ReOrder Quantity".EDI THEN
          CurrForm."Indent ReOrder Quantity".EDI(Security."Indent ReOrder Quantity" = 0);
        CurrForm."Indent ReOrder Quantity".VISIBLE(Security."Indent ReOrder Quantity" IN [0,1,3,4]);
        IF Security."Indent ReOrder Quantity" IN [2,5] THEN
          SETRANGE("Indent ReOrder Quantity");
        IF CurrForm."Net Change - Open".EDI THEN
          CurrForm."Net Change - Open".EDI(Security."Net Change - Open" = 0);
        CurrForm."Net Change - Open".VISIBLE(Security."Net Change - Open" IN [0,1,3,4]);
        IF Security."Net Change - Open" IN [2,5] THEN
          SETRANGE("Net Change - Open");
        IF CurrForm."Qty on Indent".EDI THEN
          CurrForm."Qty on Indent".EDI(Security."Qty on Indent" = 0);
        CurrForm."Qty on Indent".VISIBLE(Security."Qty on Indent" IN [0,1,3,4]);
        IF Security."Qty on Indent" IN [2,5] THEN
          SETRANGE("Qty on Indent");
        IF CurrForm."Client Material".EDI THEN
          CurrForm."Client Material".EDI(Security."Client Material" = 0);
        CurrForm."Client Material".VISIBLE(Security."Client Material" IN [0,1,3,4]);
        IF Security."Client Material" IN [2,5] THEN
          SETRANGE("Client Material");
        IF CurrForm."Specification Code".EDI THEN
          CurrForm."Specification Code".EDI(Security."Specification Code" = 0);
        CurrForm."Specification Code".VISIBLE(Security."Specification Code" IN [0,1,3,4]);
        IF Security."Specification Code" IN [2,5] THEN
          SETRANGE("Specification Code");
        IF CurrForm."Drawing Code".EDI THEN
          CurrForm."Drawing Code".EDI(Security."Drawing Code" = 0);
        CurrForm."Drawing Code".VISIBLE(Security."Drawing Code" IN [0,1,3,4]);
        IF Security."Drawing Code" IN [2,5] THEN
          SETRANGE("Drawing Code");
        IF CurrForm."No. of Documents".EDI THEN
          CurrForm."No. of Documents".EDI(Security."No. of Documents" = 0);
        CurrForm."No. of Documents".VISIBLE(Security."No. of Documents" IN [0,1,3,4]);
        IF Security."No. of Documents" IN [2,5] THEN
          SETRANGE("No. of Documents");
        IF CurrForm."Routing No.".EDI THEN
          CurrForm."Routing No.".EDI(Security."Routing No." = 0);
        CurrForm."Routing No.".VISIBLE(Security."Routing No." IN [0,1,3,4]);
        IF Security."Routing No." IN [2,5] THEN
          SETRANGE("Routing No.");
        IF CurrForm."Production BOM No.".EDI THEN
          CurrForm."Production BOM No.".EDI(Security."Production BOM No." = 0);
        CurrForm."Production BOM No.".VISIBLE(Security."Production BOM No." IN [0,1,3,4]);
        IF Security."Production BOM No." IN [2,5] THEN
          SETRANGE("Production BOM No.");
        IF CurrForm."Overhead Rate".EDI THEN
          CurrForm."Overhead Rate".EDI(Security."Overhead Rate" = 0);
        CurrForm."Overhead Rate".VISIBLE(Security."Overhead Rate" IN [0,1,3,4]);
        IF Security."Overhead Rate" IN [2,5] THEN
          SETRANGE("Overhead Rate");
        IF CurrForm."Order Tracking Policy".EDI THEN
          CurrForm."Order Tracking Policy".EDI(Security."Order Tracking Policy" = 0);
        CurrForm."Order Tracking Policy".VISIBLE(Security."Order Tracking Policy" IN [0,1,3,4]);
        IF Security."Order Tracking Policy" IN [2,5] THEN
          SETRANGE("Order Tracking Policy");
        IF CurrForm.Critical.EDI THEN
          CurrForm.Critical.EDI(Security.Critical = 0);
        CurrForm.Critical.VISIBLE(Security.Critical IN [0,1,3,4]);
        IF Security.Critical IN [2,5] THEN
          SETRANGE(Critical);
        IF CurrForm."Common Item No.".EDI THEN
          CurrForm."Common Item No.".EDI(Security."Common Item No." = 0);
        CurrForm."Common Item No.".VISIBLE(Security."Common Item No." IN [0,1,3,4]);
        IF Security."Common Item No." IN [2,5] THEN
          SETRANGE("Common Item No.");
       */
        //ALLEDK 030313
    END;

}