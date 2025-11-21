table 97729 "Purchase Request Line"
{
    // //ALLE-PKS ADDED FIELDS FOR THE GET INDENT LINES ON TRANSFER ORDER FUNCTIONALITY
    // //NDALLE 280108 Code Added For Cost Centre
    // ALLESP BCL0024 : New fields added
    // //AlleBLK : New fields added and write a code
    // ALLEAB : New fields added
    // //SC : Write a Code
    // ALLERP KRN0015 09-09-2010: Code added to flow shortcut dimensions
    // ALLERP BugFix  24-11-2010: Caption of all indent fields has been changed to purchase request
    //        //Alledk 300412

    DrillDownPageID = "Purchase Request Lines List";
    LookupPageID = "Purchase Request Lines List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'Indent';
            OptionMembers = Indent;
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                // ALLEAA
                IF CheckStatus THEN
                    ERROR(Text50002);
                // ALLEAA

                DimValue.RESET;
                DimValue.SETRANGE(Code, "Shortcut Dimension 1 Code");
                IF DimValue.FIND('-') THEN
                    "Cost Centre Name" := DimValue.Name;
            end;
        }
        field(5; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                //MODIFY;
                DimValue.RESET;
                DimValue.SETRANGE(Code, "Shortcut Dimension 2 Code");
                IF DimValue.FIND('-') THEN
                    "Department Name" := DimValue.Name;
            end;
        }
        field(6; "Indent Date"; Date)
        {
            Caption = 'Purch. Req. Date';
            Editable = false;
        }
        field(8; "Indent Status"; Option)
        {
            Caption = 'Purch. Req. Status';
            Editable = false;
            OptionCaption = 'Open,Closed,Cancelled';
            OptionMembers = Open,Closed,Cancelled;
        }
        field(9; "Location code"; Code[20])
        {
            TableRelation = Location;
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,,Job Master';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)","Job Master";

            trigger OnValidate()
            begin
                TESTFIELD(Approved, FALSE);

                IF Type = Type::"Fixed Asset" THEN BEGIN
                END
                ELSE BEGIN
                    "FA SubGroup" := '';
                    Description := '';
                    "Description 2" := '';
                END
            end;
        }
        field(11; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE IF (Type = CONST(Item)) Item
            ELSE IF (Type = FILTER("Job Master")) "Job Master"
            ELSE IF (Type = FILTER("Fixed Asset")) "Fixed Asset";

            trigger OnValidate()
            var
                ICPartner: Record "IC Partner";
                //ItemCrossReference: Record "Item Cross Reference";// 5717;
                CompanyInfo: Record "Company Information";
                ILE: Record "Item Ledger Entry";
            begin
                TESTFIELD(Approved, FALSE);

                CASE Type OF
                    Type::" ":
                        BEGIN
                            StdTxt.GET("No.");
                            Description := StdTxt.Description;
                            "Last PO Reference No." := '';
                            "Last PO Price" := 0;
                            "Last PO Vendor" := '';

                        END;
                    Type::"G/L Account":
                        BEGIN
                            GLAcc.GET("No.");
                            GLAcc.CheckGLAcc;
                            GLAcc.TESTFIELD("Direct Posting", TRUE);
                            Description := GLAcc.Name;
                            VALIDATE("Indent UOM");
                            VALIDATE("Base UOM");
                            VALIDATE("Purchase UOM");
                            "Last PO Reference No." := '';
                            "Last PO Price" := 0;
                            "Last PO Vendor" := '';

                        END;
                    Type::Item:
                        BEGIN
                            Item.GET("No.");
                            IndHeader.RESET;
                            IndHeader.SETRANGE("Document Type", "Document Type");
                            IndHeader.SETRANGE("Document No.", "Document No.");
                            IF IndHeader.FIND('-') THEN;

                            Item.TESTFIELD(Blocked, FALSE);
                            Item.TESTFIELD("Inventory Posting Group");
                            Item.TESTFIELD("Gen. Prod. Posting Group");

                            Description := Item.Description;

                            "Description 2" := Item."Description 2";
                            //SC ->> 11-02-06
                            "Description 3" := Item."Description 3";
                            "Description 4" := Item."Description 4";
                            //SC <<-
                            "Item Category Code" := Item."Item Category Code";
                            "Product Group Code" := Item."BBG Product Group Code";
                            VALIDATE("Indent UOM", Item."Base Unit of Measure");
                            VALIDATE("Base UOM", Item."Base Unit of Measure");
                            VALIDATE("Purchase UOM", Item."Purch. Unit of Measure");
                            VALIDATE("Direct Unit Cost", Item."Last Direct Cost");
                            PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::Order);
                            PurchLine.SETRANGE(PurchLine.Type, Type::Item);
                            PurchLine.SETRANGE(PurchLine."No.", "No.");
                            PurchLine.SETCURRENTKEY(PurchLine."Document Type", PurchLine.Type, PurchLine."No.", PurchLine."Order Date");
                            IF PurchLine.FIND('+') THEN BEGIN
                                "Last PO Reference No." := PurchLine."Document No.";
                                //"Last PO date":=RgPurchaseRcptLine."Purch.Posting Date";
                                "Last PO Price" := PurchLine."Direct Unit Cost";
                                "Last PO Vendor" := PurchLine."Buy-from Vendor No.";
                            END;

                            /*//NDALLE 280108
                            DefDimRec.RESET;
                            DefDimRec.GET(27,"No.",'COST CENTER');
                            */
                            //NDALLE 280108
                            /*
                            IF (Item."Item Category Code"<>IndHeader."Item Category Code") THEN
                              ERROR(Text0001,IndHeader."Item Category Code");
                            */
                        END;
                    Type::"Fixed Asset":
                        BEGIN
                            FA.GET("No.");
                            Description := FA.Description;
                            "Description 2" := FA."Description 2";
                            "Last PO Reference No." := '';
                            "Last PO Price" := 0;
                            "Last PO Vendor" := '';

                        END;
                END;

                //NDALLE 191107
                IndHdr.RESET;
                IndHdr.SETRANGE(IndHdr."Document Type", "Document Type");
                IndHdr.SETRANGE(IndHdr."Document No.", "Document No.");
                IF IndHdr.FIND('-') THEN BEGIN
                    "Responsibility Center" := IndHdr."Responsibility Center";
                END;

                // ALLEAA
                ILE.RESET;
                ILE.SETCURRENTKEY("Location Code", "Item No.");
                ILE.SETRANGE("Location Code", "Responsibility Center");
                ILE.SETRANGE("Item No.", "No.");
                IF ILE.FINDFIRST THEN ILE.CALCSUMS(ILE.Quantity);
                "Qty. at Indent Creation" := ILE.Quantity;
                // ALLEAA
                CreateDim(
                  DimMgt.TypeToTableID2(Type), "No.",
                  DATABASE::Job, "Job No.",
                  DATABASE::"Responsibility Center", "Responsibility Center");

            end;
        }
        field(12; "Required By Date"; Date)
        {
            Caption = 'Required By Date';

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
            begin
                /* //AlleBLK
                IF Type = Type::Item THEN BEGIN
                  IndHeader.RESET;
                  IndHeader.SETRANGE("Document No.","Document No.");
                  IF IndHeader.FIND('-') THEN BEGIN
                    IF IndHeader."Item Category Code"<>'' THEN
                      Item.SETRANGE(Item."Item Category Code",IndHeader."Item Category Code");
                    IF Item.FIND('-')THEN BEGIN
                      IF PAGE.RUNMODAL(0,Item)= ACTION::LookupOK THEN
                        VALIDATE("No.",Item."No.");
                    END;
                  END;
                END;
                
                IF Type = Type::"Fixed Asset" THEN BEGIN
                  IF PAGE.RUNMODAL(0,FA)= ACTION::LookupOK THEN BEGIN
                    "No.":=FA."No.";
                    VALIDATE("No.");
                  END;
                END;
                
                IF Type = Type::"G/L Account" THEN BEGIN
                  IF PAGE.RUNMODAL(0,GLAcc)= ACTION::LookupOK THEN BEGIN
                    "No.":=GLAcc."No.";
                    VALIDATE("No.");
                  END;
                END;
                
                IF Type = Type::" " THEN BEGIN
                  IF PAGE.RUNMODAL(0,StdTxt)= ACTION::LookupOK THEN BEGIN
                    "No.":=StdTxt.Code;
                    VALIDATE("No.");
                  END;
                END;
                */

            end;
        }
        field(13; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(14; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(15; "Indented Quantity"; Decimal)
        {
            Caption = 'Purch. Req. Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TESTFIELD(Approved, FALSE);

                "Approved Qty" := "Indented Quantity";
                IndentQty := 0;
                PRLineRec1.RESET;
                //PRLineRec1.SETFILTER("Document No.","Document No.");
                PRLineRec1.SETFILTER(PRLineRec1."Job No.", "Job No.");
                PRLineRec1.SETFILTER(PRLineRec1."Job Task No.", "Job Task No.");
                PRLineRec1.SETRANGE(PRLineRec1."Job Planning Line No.", "Job Planning Line No.");
                IF PRLineRec1.FINDFIRST THEN
                    REPEAT
                        PRHeader.GET(PRLineRec1."Document Type", PRLineRec1."Document No.");
                        IF NOT (PRHeader."Indent Status" IN [PRHeader."Indent Status"::Cancelled, PRHeader."Indent Status"::"Short Closed"]) THEN
                            IndentQty := IndentQty + PRLineRec1."Approved Qty";
                    UNTIL PRLineRec1.NEXT = 0;

                IF JobPlanningLIne.GET("Job No.", "Job Task No.", "Job Planning Line No.") THEN BEGIN
                    IF (IndentQty - xRec."Approved Qty" + "Approved Qty") > JobPlanningLIne.Quantity THEN
                        //ALLERP BugFix 22-12-2010:Start:
                        ERROR(Text50001, JobPlanningLIne."Job Contract Entry No.");
                END;
                /* //ALLEDK 011512
                IF "Job Planning Line No." <> 0 THEN BEGIN
                IF CurrFieldNo = FIELDNO("Indented Quantity") THEN
                  IF "Indented Quantity" > "New Indent Quantity" THEN
                    ERROR('You can not enter more than'+FORMAT("New Indent Quantity"));
                END;
                //KLND1.00 150311
                 */ //ALLEDK 011512


                VALIDATE("Indent UOM");
                VALIDATE("Purchase UOM");

            end;
        }
        field(16; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';

            trigger OnValidate()
            begin
                Amount := "Approved Qty" * "Direct Unit Cost";
            end;
        }
        field(17; "Item Category Code"; Code[20])
        {
            TableRelation = "Item Category";
        }
        field(18; "Product Group Code"; Code[20])
        {
            TableRelation = "BBG Product Group" WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(19; "Indent UOM"; Code[20])
        {
            Caption = 'Purch. Req. UOM';
            TableRelation = IF (Type = CONST(" ")) "Unit of Measure".Code
            ELSE IF (Type = CONST("G/L Account")) "Unit of Measure".Code
            ELSE IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate()
            begin
                //NDALLE071205
                IF Type = Type::Item THEN BEGIN
                    ItemUOM.GET("No.", "Indent UOM");
                    "Qty Per Unit Of Measure" := ItemUOM."Qty. per Unit of Measure";
                END
                ELSE
                    "Qty Per Unit Of Measure" := 1;

                "Quantity Base" := 0;
                "Quantity Base" := "Qty Per Unit Of Measure" * "Approved Qty";
                Amount := "Approved Qty" * "Direct Unit Cost";

                //NDALLE071205
            end;
        }
        field(20; "Current Stock"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No.")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Avg Consumption"; Decimal)
        {
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                   "Entry Type" = FILTER("Negative Adjmt.")));
            FieldClass = FlowField;
        }
        field(22; Amount; Decimal)
        {
        }
        field(23; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate()
            begin
                IF "Variant Code" <> '' THEN
                    TESTFIELD(Type, Type::Item);

                TESTFIELD(Approved, FALSE);

                IF Type = Type::Item THEN BEGIN
                    ItemVariant.GET("No.", "Variant Code");
                    Description := ItemVariant.Description;
                    "Description 2" := ItemVariant."Description 2";
                END;
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(50003; Approved; Boolean)
        {
            Description = 'AlleBLk';
        }
        field(50010; Indentor; Code[20])
        {
            Caption = 'Requestor';
            Description = 'AlleBLk';
            Editable = false;
            TableRelation = User;
        }
        field(50016; "Sent for Approval"; Boolean)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50017; "PO Qty"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Quantity (Base)" WHERE("Indent No" = FIELD("Document No."),
                                                                       "Indent Line No" = FIELD("Line No."),
                                                                       "Document Type" = FILTER(Order)));
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50018; "Quantity Received"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Qty. Received (Base)" WHERE("Indent No" = FIELD("Document No."),
                                                                            "Indent Line No" = FIELD("Line No."),
                                                                            "Document Type" = FILTER(Order)));
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50019; "Quantity Invoiced"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Qty. Invoiced (Base)" WHERE("Indent No" = FIELD("Document No."),
                                                                            "Indent Line No" = FIELD("Line No."),
                                                                            "Document Type" = FILTER(Order)));
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50020; "Outstanding PO Qty"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE("Indent No" = FIELD("Document No."),
                                                                               "Indent Line No" = FIELD("Line No."),
                                                                               "Document Type" = FILTER(Order)));
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50021; "Outstanding PO Amount"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Amount" WHERE("Indent No" = FIELD("Document No."),
                                                                          "Indent Line No" = FIELD("Line No."),
                                                                          "Document Type" = FILTER(Order)));
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50022; "Cost Centre Name"; Text[60])
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50023; "Approved Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';

            trigger OnValidate()
            begin
                // ALLEAA
                IF CheckStatus THEN
                    ERROR(Text50002);
                // ALLEAA
                IF "Job Planning Line No." <> 0 THEN BEGIN
                    IF CurrFieldNo = FIELDNO("Indented Quantity") THEN
                        IF "Indented Quantity" > "New Indent Quantity" THEN
                            ERROR('You can not enter more than' + FORMAT("New Indent Quantity"));
                END;

                IF "Approved Qty" > "Indented Quantity" THEN
                    ERROR('Indent Quantity must be Equal Or Less than to Quantity');
                IF Type = Type::Item THEN BEGIN
                    ItemUOM.RESET;
                    ItemUOM.GET("No.", "Indent UOM");
                    "Qty Per Unit Of Measure" := ItemUOM."Qty. per Unit of Measure";
                END
                ELSE
                    "Qty Per Unit Of Measure" := 1;

                "Quantity Base" := 0;
                "Quantity Base" := "Qty Per Unit Of Measure" * "Approved Qty";
                Amount := "Approved Qty" * "Direct Unit Cost";
                VALIDATE("Purchase UOM");
            end;
        }
        field(50024; "Quantity Base"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50025; "Qty Per Unit Of Measure"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50026; "Physical Stock"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
        }
        field(50027; "Purchase UOM"; Code[20])
        {
            Description = 'AlleBLk';
            TableRelation = IF (Type = CONST(" ")) "Unit of Measure".Code
            ELSE IF (Type = CONST("G/L Account")) "Unit of Measure".Code
            ELSE IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate()
            begin
                IF Type = Type::Item THEN BEGIN
                    ItemUOM.GET("No.", "Purchase UOM");
                    "Purch Qty Per Unit Of Measure" := ItemUOM."Qty. per Unit of Measure";
                    "Quantity (Purchase UOM)" := 0;
                    IF "Purch Qty Per Unit Of Measure" = 0 THEN
                        "Purch Qty Per Unit Of Measure" := 1;
                END
                ELSE
                    "Purch Qty Per Unit Of Measure" := 1;

                "Quantity (Purchase UOM)" := "Quantity Base" / "Purch Qty Per Unit Of Measure";
                //NDALLE071205
            end;
        }
        field(50028; "Quantity (Purchase UOM)"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50029; "Purch Qty Per Unit Of Measure"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50030; "Base Qty on Indent Line"; Decimal)
        {
            CalcFormula = Sum("Purchase Request Line"."Quantity Base" WHERE("Indent Status" = FILTER(Open),
                                                                             Type = FIELD(Type),
                                                                             "No." = FIELD("No."),
                                                                             Approved = FILTER(true)));
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50031; "Base PO Qty on PO Line"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Quantity (Base)" WHERE("Document Type" = FILTER(Order),
                                                                       Type = FIELD(Type),
                                                                       "No." = FIELD("No."),
                                                                       "Indent No" = FILTER(<> ''),
                                                                       "Indent Line No" = FILTER(<> 0)));
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50032; "Purchaser Code"; Code[20])
        {
            Description = 'AlleBLk';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50033; "Base UOM"; Code[20])
        {
            Description = 'AlleBLk';
            Editable = false;
            TableRelation = "Unit of Measure".Code;
        }
        field(50034; "Description 3"; Text[60])
        {
            Description = 'AlleBLk';
        }
        field(50035; "Description 4"; Text[60])
        {
            Description = 'AlleBLk';
        }
        field(50036; "Department Name"; Text[60])
        {
            Description = 'AlleBLk';
        }
        field(50045; "Approval Status"; Option)
        {
            Description = 'ALLESP BCL0024 08-08-2007';
            OptionCaption = ' ,Sent for Approval,Approved,Returned,Rejected';
            OptionMembers = " ","Sent for Approval",Approved,Returned,Rejected;
        }
        field(50046; "Responsibility Center"; Code[10])
        {
            Description = 'AlleBLK';
            TableRelation = "Responsibility Center 1";
        }
        field(50047; "TO Qty"; Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Quantity (Base)" WHERE("Indent No." = FIELD("Document No."),
                                                                       "Indent Line No." = FIELD("Line No."),
                                                                       "Derived From Line No." = CONST(0)));
            DecimalPlaces = 0 : 5;
            Description = 'ALLE-PKS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50048; "Outstanding TO Qty"; Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Outstanding Qty. (Base)" WHERE("Indent No." = FIELD("Document No."),
                                                                               "Indent Line No." = FIELD("Line No.")));
            DecimalPlaces = 0 : 5;
            Description = 'ALLE-PKS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50049; "Quantity Received T.O"; Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Qty. Received (Base)" WHERE("Indent No." = FIELD("Document No."),
                                                                            "Indent Line No." = FIELD("Line No.")));
            DecimalPlaces = 0 : 5;
            Description = 'ALLE-PKS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050; "Quantity Shipped T.O"; Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Qty. Shipped (Base)" WHERE("Indent No." = FIELD("Document No."),
                                                                           "Indent Line No." = FIELD("Line No.")));
            DecimalPlaces = 0 : 5;
            Description = 'ALLE-PKS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50051; "FA SubGroup"; Code[10])
        {
            Description = 'ALLEAB';

            trigger OnLookup()
            begin

                IndHeader.RESET;
                IndHeader.SETRANGE("Document No.", "Document No.");
                IF IndHeader.FIND('-') THEN BEGIN

                    IF IndHeader."Sub Document Type" = IndHeader."Sub Document Type"::FA THEN BEGIN
                        IF PAGE.RUNMODAL(97783, FASubGroupRec) = ACTION::LookupOK THEN
                            VALIDATE("FA SubGroup", FASubGroupRec."FA Code");
                    END;
                END;
            end;

            trigger OnValidate()
            begin
                FASubGroupRec.RESET;
                FASubGroupRec.SETFILTER(FASubGroupRec."FA Code", "FA SubGroup");
                IF FASubGroupRec.FINDFIRST THEN BEGIN
                    Description := FASubGroupRec.Item;
                    "Description 2" := FASubGroupRec.Capacity;
                END;
            end;
        }
        field(50052; Designation; Code[20])
        {
            Description = 'ALLEAB';

            trigger OnLookup()
            begin
                /*
                IndHeader.RESET;
                IndHeader.SETRANGE("Document No.","Document No.");
                IF IndHeader.FIND('-') THEN BEGIN
                  IF IndHeader."Sub Document Type"=IndHeader."Sub Document Type"::"Man Power" THEN BEGIN
                    IF PAGE.RUNMODAL(60102,JobTitleRec) = ACTION::LookupOK THEN
                      VALIDATE(Designation,JobTitleRec."Job Code");
                  END;
                END;
                */

            end;

            trigger OnValidate()
            begin
                /*
                JobTitleRec.RESET;
                JobTitleRec.SETFILTER(JobTitleRec."Job Code",Designation);
                IF JobTitleRec.FINDFIRST THEN
                BEGIN
                Description:=JobTitleRec.Description;
                
                END;
                */

            end;
        }
        field(50053; "Qty. at Indent Creation"; Decimal)
        {
            Caption = 'Qty. at Req. Creation';
            Description = 'ALLEAA';
            Editable = false;
        }
        field(50054; "Qty. at Indent Approval"; Decimal)
        {
            Caption = 'Qty. at Req. Approval';
            Description = 'ALLEAA';
            Editable = false;
        }
        field(50055; "BBU No."; Code[20])
        {
            Description = 'ALLEKT NASL';

            trigger OnValidate()
            begin
                /*CheckStatus; // ALLEAA
                IF  (CallefromField <> FIELDNO("Send for Enquiry")) THEN BEGIN
                  GetHeader();
                  recDocumentHeader.TESTFIELD(recDocumentHeader."Indent Status",recDocumentHeader."Indent Status"::Open)
                END;
                 */

            end;
        }
        field(50056; "Job No."; Code[20])
        {
            TableRelation = Job;

            trigger OnValidate()
            begin
                //CheckStatus; // ALLEAA
            end;
        }
        field(50057; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

            trigger OnValidate()
            begin
                //CheckStatus; // ALLEAA
            end;
        }
        field(50058; "Job Planning Line No."; Integer)
        {

            trigger OnValidate()
            begin
                //CheckStatus; // ALLEAA
            end;
        }
        field(50059; "Send for Enquiry"; Boolean)
        {

            trigger OnValidate()
            begin
                CallefromField := FIELDNO("Send for Enquiry");
            end;
        }
        field(50060; "Last PO Reference No."; Code[20])
        {
            Editable = false;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(50061; "Last PO Vendor"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(50062; "Last PO Price"; Decimal)
        {
            Editable = false;
        }
        field(50098; "Workflow Approval Status"; Option)
        {
            Caption = 'Workflow Approval Status';
            DataClassification = ToBeClassified;
            Description = 'Alle1.00';
            OptionCaption = 'Open,Released,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";
        }
        field(50099; "Workflow Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Alle1.00';
            Editable = false;
            OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward';
            OptionMembers = " ",FA,Regular,Direct,WorkOrder,Inward,Outward;
        }
        field(50100; "New Indent Quantity"; Decimal)
        {
            Description = 'KLND1.00 150311';
        }
        field(50110; "Initiator User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User."User Name";

            trigger OnLookup()
            begin
                UserMgt.DisplayUserInformation("Initiator User ID");// LookupUserID("Initiator User ID");
            end;

            trigger OnValidate()
            begin
                UserMgt.DisplayUserInformation("Initiator User ID");//ValidateUserID("Initiator User ID");
            end;
        }
        field(90028; "Delivery Date"; Date)
        {
        }
        field(90029; "Inspection by"; Text[30])
        {
        }
        field(90030; Source; Code[20])
        {
            TableRelation = Vendor;
        }
        field(90031; "Job Master Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Job Master".Code;

            trigger OnValidate()
            begin
                IF JobMaster.GET("Job Master Code") THEN BEGIN
                    VALIDATE("Shortcut Dimension 2 Code", JobMaster."Default Cost Center Code");
                END;
            end;
        }
        field(90032; "WO / PO Code"; Code[20])
        {
            Description = 'MP1.0';
            Editable = false;
        }
        field(90033; "PO Line No."; Integer)
        {
            Description = 'MP1.0';
            TableRelation = "FOC/PO TABLE"."Line No.";

            trigger OnLookup()
            begin
                cHK.SETRANGE(cHK."No.", "WO / PO Code");
                cHK.SETRANGE(cHK."Item Code", "No.");
                IF PAGE.RUNMODAL(Page::"FOC LIST", cHK) = ACTION::LookupOK THEN BEGIN
                    VALIDATE("PO Line No.", cHK."Line No.");
                END;
            end;

            trigger OnValidate()
            begin
                VALIDATE("Indented Quantity", 0);
            end;
        }
        field(90034; "Issued Qty."; Decimal)
        {
            Description = 'RAHEE1.00 180412';
        }
        field(90035; "Qty in Issue"; Decimal)
        {
            Description = 'RAHEE1.00 180412';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; Type, "No.", "Indent Status", Approved)
        {
            SumIndexFields = "Quantity Base";
        }
        key(Key3; "Indent Date", "Document No.")
        {
        }
        key(Key4; "No.")
        {
        }
        key(Key5; "Document No.")
        {
        }
        key(Key6; "Shortcut Dimension 1 Code", "Document No.")
        {
        }
        key(Key7; Indentor, "Responsibility Center", "Document Type", "Indent Status")
        {
        }
        key(Key8; "Job No.", "Job Task No.", "Job Planning Line No.")
        {
            SumIndexFields = "Indented Quantity", "Approved Qty";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IndHeader.TESTFIELD("Sent for Approval", FALSE);
        TESTFIELD(Approved, FALSE);
        IF NOT (IndHeader."Indent Status" < IndHeader."Indent Status"::"Short Closed") THEN
            ERROR('Lines cannot be deleted since indent Status is %1', IndHeader."Indent Status");

        //NDALLE 130308
        RecMemberof.RESET;
        RecMemberof.SETRANGE("User Name", USERID);
        RecMemberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT RecMemberof.FINDFIRST THEN BEGIN
            RecIH.RESET;
            RecIH.SETRANGE("Document No.", "Document No.");
            IF RecIH.FINDFIRST THEN BEGIN
                IF RecIH.Approved = TRUE THEN
                    ERROR('You Can not Delete Approved Documents');
            END;
        END;
        //NDALLE 130308
    end;

    trigger OnInsert()
    begin
        //NDALLE061205
        IndHeader.RESET;
        IndHeader.SETRANGE("Document Type", "Document Type");
        IndHeader.SETRANGE("Document No.", "Document No.");
        IF IndHeader.FIND('-') THEN BEGIN

            IF NOT (IndHeader."Indent Status" < IndHeader."Indent Status"::"Short Closed") THEN
                ERROR('Lines cannot be inserted since indent Status is %1', IndHeader."Indent Status");

            VALIDATE("Shortcut Dimension 1 Code", IndHeader."Shortcut Dimension 1 Code");
            VALIDATE("Shortcut Dimension 2 Code", IndHeader."Shortcut Dimension 2 Code");
            "Indent Date" := IndHeader."Indent Date";
            "Indent Status" := IndHeader."Indent Status";
            "Location code" := IndHeader."Location code";
            "Required By Date" := IndHeader."Required By Date";
            "Location code" := IndHeader."Location code";
            "Purchaser Code" := IndHeader."Purchaser Code";
        END;
        //NDALLE061205

        //NDALLE 130308
        RecMemberof.RESET;
        RecMemberof.SETRANGE("User Name", USERID);
        RecMemberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT RecMemberof.FINDFIRST THEN BEGIN
            RecIH.RESET;
            RecIH.SETRANGE("Document No.", "Document No.");
            IF RecIH.FINDFIRST THEN BEGIN
                IF RecIH.Approved = TRUE THEN
                    ERROR('You Can not Insert in Approved Documents');
            END;
        END;
        //NDALLE 130308
    end;

    trigger OnModify()
    begin

        IF NOT (IndHeader."Indent Status" < IndHeader."Indent Status"::"Short Closed") THEN
            ERROR('Lines cannot be modified since indent Status is %1', IndHeader."Indent Status");
        //NDALLE 130308
        RecMemberof.RESET;
        RecMemberof.SETRANGE("User Name", USERID);
        RecMemberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT RecMemberof.FINDFIRST THEN BEGIN
            RecIH.RESET;
            RecIH.SETRANGE("Document No.", "Document No.");
            IF RecIH.FINDFIRST THEN BEGIN
                IF RecIH.Approved = TRUE THEN
                    ERROR('You Can not Modify Approved Documents');
            END;
        END;
        //NDALLE 130308
    end;

    var
        StdTxt: Record "Standard Text";
        GLAcc: Record "G/L Account";
        Item: Record Item;
        IndHeader: Record "Purchase Request Header";
        FA: Record "Fixed Asset";
        TempIndentLine: Record "Purchase Request Line";
        ItemUOM: Record "Item Unit of Measure";
        ICC: Code[20];
        Text0001: Label 'Item Category Code Must be %1';
        "G/LAcc": Record "G/L Account";
        DimValue: Record "Dimension Value";
        IndHdr: Record "Purchase Request Header";
        DefDimRec: Record "Default Dimension";
        RecIH: Record "Purchase Request Header";
        FASubGroupRec: Record "Fixed Asset Sub Group";
        PRLineRec: Record "Purchase Request Line";
        CallefromField: Integer;
        JobPlanningLIne: Record "Job Planning Line";
        IndentQty: Decimal;
        PRHeader: Record "Purchase Request Header";
        Difference: Decimal;
        PRLineRec1: Record "Purchase Request Line";
        Text50001: Label 'Total Qty is indented for Job Contract Entry No. %1';
        Text50002: Label 'Status must not be Approved.';
        PurchLine: Record "Purchase Line";
        TotalJobQty: Decimal;
        TotalIndQty: Decimal;
        RecJobPlanningLine: Record "Job Planning Line";
        PurchaseReqLine: Record "Purchase Request Line";
        OldValue: Decimal;
        FirstQuantity: Decimal;
        ItemVariant: Record "Item Variant";
        DimMgt: Codeunit DimensionManagement;
        JobMaster: Record "Job Master";
        cHK: Record "FOC/PO TABLE";
        RecMemberof: Record "Access Control";
        UserMgt: Codeunit "User Management";
        OldDimSetID: Integer;


    procedure FillJobPlanningLine(var pJobPlanLine: Record "Job Planning Line"; pIndentHeader: Record "Purchase Request Header")
    var
        vLineNo: Integer;
    begin
        //AlleDK  NTPC
        vLineNo := 0;
        PRLineRec.RESET;
        PRLineRec.SETRANGE(PRLineRec."Document Type", pIndentHeader."Document Type");
        PRLineRec.SETRANGE(PRLineRec."Document No.", pIndentHeader."Document No.");
        IF PRLineRec.FINDLAST THEN
            vLineNo := PRLineRec."Line No.";

        vLineNo := vLineNo + 10000;
        PRLineRec.INIT;
        PRLineRec."Document Type" := pIndentHeader."Document Type";
        PRLineRec."Document No." := pIndentHeader."Document No.";
        PRLineRec."Line No." := vLineNo;
        PRLineRec.INSERT;
        IF pJobPlanLine.Type = pJobPlanLine.Type::Text THEN
            PRLineRec.VALIDATE(Type, PRLineRec.Type::" ");
        IF pJobPlanLine.Type = pJobPlanLine.Type::"G/L Account" THEN
            PRLineRec.VALIDATE(Type, PRLineRec.Type::"G/L Account");
        IF pJobPlanLine.Type = pJobPlanLine.Type::Item THEN
            PRLineRec.VALIDATE(Type, PRLineRec.Type::Item);
        IF pJobPlanLine.Type = pJobPlanLine.Type::"G/L Account" THEN
            PRLineRec.VALIDATE(Type, PRLineRec.Type::"G/L Account");
        PRLineRec.VALIDATE("No.", pJobPlanLine."No.");
        PRLineRec.VALIDATE("Indent UOM", pJobPlanLine."Unit of Measure Code");
        PRLineRec.Description := pJobPlanLine.Description;
        PRLineRec."Description 2" := pJobPlanLine."Description 2";
        PRLineRec."Job No." := pJobPlanLine."Job No.";
        PRLineRec."Job Task No." := pJobPlanLine."Job Task No.";
        PRLineRec."Job Planning Line No." := pJobPlanLine."Line No.";
        //ALLERP KRN0015 Start:
        PRLineRec.VALIDATE("Shortcut Dimension 1 Code", pIndentHeader."Shortcut Dimension 1 Code");
        //PRLineRec.VALIDATE("Shortcut Dimension 2 Code",pIndentHeader."Shortcut Dimension 2 Code");
        //ALLERP KRN0015 End:
        PRLineRec.VALIDATE("Job Master Code", pJobPlanLine."Job Master Code"); // ALLEAA
        IndentQty := 0;
        PRLineRec1.RESET;
        PRLineRec1.SETFILTER(PRLineRec1."Job No.", pJobPlanLine."Job No.");
        PRLineRec1.SETFILTER(PRLineRec1."Job Task No.", pJobPlanLine."Job Task No.");
        PRLineRec1.SETRANGE(PRLineRec1."Job Planning Line No.", pJobPlanLine."Line No.");
        IF PRLineRec1.FINDFIRST THEN
            REPEAT
                PRHeader.GET(PRLineRec1."Document Type", PRLineRec1."Document No.");
                IF NOT (PRHeader."Indent Status" IN [PRHeader."Indent Status"::Cancelled, PRHeader."Indent Status"::"Short Closed"]) THEN
                    IndentQty := IndentQty + PRLineRec1."Approved Qty";
            UNTIL PRLineRec1.NEXT = 0;

        JobPlanningLIne.GET(PRLineRec."Job No.", PRLineRec."Job Task No.", PRLineRec."Job Planning Line No.");
        IF IndentQty >= JobPlanningLIne.Quantity THEN
            //ALLERP BugFix 22-12-2010:Start:
            ERROR(Text50001, JobPlanningLIne."Job Contract Entry No.");
        //ALLERP BugFix 22-12-2010:End:
        Difference := JobPlanningLIne.Quantity - IndentQty;
        PRLineRec.VALIDATE("Indented Quantity", Difference);
        PRLineRec."New Indent Quantity" := Difference;  //KLND1.00 150311
        PRLineRec.Amount := pJobPlanLine."Total Cost";
        //PRLineRec."BBU No." := pJobPlanLine."Vendor BBU No.";
        PRLineRec."Direct Unit Cost" := pJobPlanLine."Unit Cost";
        PRLineRec."Location code" := pIndentHeader."Location code";
        PRLineRec."Delivery Date" := pJobPlanLine."Delivery Date";
        PRLineRec."Inspection by" := pJobPlanLine."Inspection by";
        PRLineRec.Source := pJobPlanLine.Source;
        PRLineRec.MODIFY;
    end;


    procedure CheckStatus(): Boolean
    var
        PurchaseRequestHeader: Record "Purchase Request Header";
    begin
        // ALLEAA
        IF PurchaseRequestHeader.GET("Document Type", "Document No.") THEN
            IF Approved THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        // ALLEAA
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';

        // ALLE MM Code Commented
        /*
        DimMgt.GetPreviousDocDefaultDim(
          DATABASE::"Purchase Request Header","Document Type","Document No.",0,
          DATABASE::Item,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        DimMgt.GetDefaultDim(
          TableID,No,'',
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        IF "Line No." <> 0 THEN
          DimMgt.UpdateDocDefaultDim(
            DATABASE::"Purchase Request Line","Document Type","Document No.","Line No.",
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        */
        // ALLE MM Code Commented

    end;


    procedure ShowDimensions()
    begin
        //TESTFIELD("Shortcut Dimension 1 Code");
        //TESTFIELD("Shortcut Dimension 2 Code");
        //TESTFIELD("Dimension Set ID");

        OldDimSetID := "Dimension Set ID";

        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Document Type", "Document No.", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
        END;
    end;
}

