tableextension 50009 "BBG Item Ext" extends Item
{
    fields
    {
        // Add changes to table fields here

        modify("Item Category Code")
        {
            trigger OnAfterValidate()
            begin
                //dds14Oct2008
                CheckMandatoryFields;  // RAHEE1.00
                TESTFIELD("FA Item", FALSE);
            end;
        }


        field(50001; "Sub Product Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ID 1 Group"."ID 1 Group Code" WHERE("Item Category Code" = FIELD("Item Category Code"),
                                                                  "Product Group Code" = FIELD("BBG Product Group Code"));//"Product Group Code" = FIELD("Product Group Code")

            trigger OnValidate()
            begin
                //dds14Oct2008
                TESTFIELD("FA Item", FALSE);
            end;
        }
        field(50028; "BBG Product Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "BBG Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));

        }

        field(50004; "Auto Indent"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'SC- For Auto Indenting flag--JPL';
        }
        field(50005; "Indent ReOrder Point"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'SC--JPL';
        }
        field(50006; "Indent ReOrder Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'SC--JPL';
        }
        field(50007; "Net Change - Open"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity" WHERE("Item No." = FIELD("No."),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Location Code" = FIELD("Location Filter"),
                                                                              "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                              "Posting Date" = FIELD("Date Filter"),
                                                                              "Variant Code" = FIELD("Variant Filter"),
                                                                              "Lot No." = FIELD("Lot No. Filter"),
                                                                              "Serial No." = FIELD("Serial No. Filter"),
                                                                              Open = FILTER(True)));
            DecimalPlaces = 0 : 5;
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "Qty on Indent"; Decimal)
        {
            CalcFormula = Sum("Purchase Request Line"."Quantity Base" WHERE(Type = FILTER(Item),
                                                                             "No." = FIELD("No."),
                                                                             "Indent Status" = FILTER(Open)));
            Description = 'SC--JPL';
            FieldClass = FlowField;
        }
        field(50009; "Quantity on GRN"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Accepted Quantity Base" WHERE(Type = FILTER(Item),
                                                                         "No." = FIELD("No."),
                                                                         Status = FILTER(Open)));
            Description = 'SC--JPL';
            FieldClass = FlowField;
        }


        field(50012; "Client Material"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'DDS for client material';

            trigger OnValidate()
            begin
                //dds27July09
                TESTFIELD("No.", '');
                IF "Client Material" THEN "Inventory Value Zero" := TRUE;
                IF NOT "Client Material" THEN "Inventory Value Zero" := FALSE;
            end;
        }
        field(50013; "Qty in Stock"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Mfg/sold Qty" WHERE("Item No." = FIELD("No."),
                                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                        "Location Code" = FIELD("Location Filter"),
                                                                        "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                        "Variant Code" = FIELD("Variant Filter"),
                                                                        "Lot No." = FIELD("Lot No. Filter"),
                                                                        "Serial No." = FIELD("Serial No. Filter")));
            Caption = 'Qty in Stock';
            DecimalPlaces = 0 : 5;
            Description = 'Ver001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50018; "Specification Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETG';
            TableRelation = "Specification Master";
        }
        field(50019; "Drawing Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETG';
            TableRelation = "FD Payment Schedule Posted";
        }
        field(50020; "Khasra 1"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AD020712:BBG1.00';
        }
        field(50021; "Khasra 2"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AD020712:BBG1.00';
        }
        field(50022; "Registered Doc. No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AD020712:BBG1.00';
        }
        field(50023; "Agreement SL. No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AD020712:BBG1.00';
        }
        field(50024; "Registration Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AD020712:BBG1.00';
        }
        field(50025; "Agreement SL. Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AD020712:BBG1.00';
        }
        field(50026; "Area Acre"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AD020712:BBG1.00';
        }
        field(50027; "Registry Doc Serial No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AD020712:BBG1.00';
        }



        field(80000; Capacity; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB-FA';
        }
        field(80001; "FA SubClass Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB-FA';
        }
        field(80002; "FA Sub Group"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB-FA';
        }
        field(80010; "Item-FA"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB-FA';
        }
        field(80011; Leased; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'dds - added for leased FA';
            Editable = false;
        }
        field(80012; "Item-FA Code"; Code[10])
        {
            Caption = 'Item-FA Code';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
            Editable = false;
            TableRelation = "Fixed Asset Sub Group"."FA Code";
        }

    }



    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        MasterSetup: Record "Master Mandatory Setup";
        RecRef: RecordRef;
        Item: Record Item;
        LastItem: Code[20];
        ItemCategoryCode: Code[20];
        ProductGroupCode: Code[20];
        SubProductGroupCode: Code[20];
        ItemCat: Record "Item Category";
        //ItemPG: Record "Product Group";
        ItemID1: Record "ID 1 Group";
        RecDefaultDimension: Record "Default Dimension";
        RecItemCategory: Record "Item Category";
        RecDimensionValue: Record "Dimension Value";
        ItemCM: Code[2];
        ItemDesc: Text[1024];
        ItemID2: Record "ID 2 Group";
        SpecMaster: Record "Specification Master";
        NewNo: Code[20];

    trigger OnAfterModify()
    begin
        //NDALLE 051107
        RecRef.GETTABLE(Rec);
        //added by dds to skip for FA Item
        IF NOT Rec."FA Item" THEN
            MasterSetup.MasterValidate(RecRef);
        //NDALLE 051107
    end;


    PROCEDURE PlanningReleaseQty() Sum: Decimal;
    VAR
        ReqLine: Record "Requisition Line";
    BEGIN
        ReqLine.SETCURRENTKEY(Type, "No.", "Variant Code", "Location Code");
        ReqLine.SETRANGE(Type, ReqLine.Type::Item);
        ReqLine.SETRANGE("No.", "No.");
        COPYFILTER("Variant Filter", ReqLine."Variant Code");
        COPYFILTER("Location Filter", ReqLine."Location Code");
        COPYFILTER("Date Filter", ReqLine."Starting Date");
        COPYFILTER("Global Dimension 1 Filter", ReqLine."Shortcut Dimension 1 Code");
        COPYFILTER("Global Dimension 2 Filter", ReqLine."Shortcut Dimension 2 Code");
        IF ReqLine.ISEMPTY THEN
            EXIT;

        IF ReqLine.FINDSET THEN
            REPEAT
                Sum += ReqLine."Quantity (Base)";
            UNTIL ReqLine.NEXT = 0;
    END;

    PROCEDURE CalcProjectUnitCost(): Decimal;
    VAR
        Job: Record Job;
        ProjectUnitCost: Decimal;
    BEGIN
        //AEREN105

        IF "Project Code" = '' THEN
            EXIT;

        Job.GET("Project Code");
        ProjectUnitCost := 0;
        ProjectUnitCost := ("Saleable Area (sq ft)" * Job."Cost/Sq. Ft.");
        EXIT(ProjectUnitCost);
    END;



    PROCEDURE CheckMandatoryFields();
    BEGIN
        // RAHEE1.00 230211 Start
        ItemCat.RESET;
        ItemCat.SETRANGE(Code, "Item Category Code");
        IF ItemCat.FINDFIRST THEN BEGIN
            IF ItemCat.Drawing THEN
                TESTFIELD("Drawing Code");
            IF ItemCat.Manufacturer THEN
                TESTFIELD("Manufacturer Code");
            IF ItemCat."Part No." THEN
                TESTFIELD("Qty in Stock");
        END;
        // RAHEE1.00 230211 End
    END;
}