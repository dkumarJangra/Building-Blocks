table 97775 "EPC Job Planning Line Archive"
{
    // ALLERP KRN0008 18-08-2010: Field 90026 and 90027 added and added them to sumindex fields

    Caption = 'Job Planning Line Archive';
    PasteIsValid = false;
    Permissions = TableData "Job Entry No." = rimd;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(2; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            TableRelation = Job;
        }
        field(3; "Planning Date"; Date)
        {
            Caption = 'Planning Date';

            trigger OnValidate()
            begin
                VALIDATE("Document Date", "Planning Date");
                IF ("Currency Date" = 0D) OR ("Currency Date" = xRec."Planning Date") THEN
                    VALIDATE("Currency Date", "Planning Date");
                IF (Type <> Type::Text) AND ("No." <> '') THEN
                    UpdateAllAmounts;
            end;
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,Item,G/L Account,Text,Group (Resource)';
            OptionMembers = Resource,Item,"G/L Account",Text,"Group (Resource)";

            trigger OnValidate()
            begin
                VALIDATE("No.", '');
                IF Type = Type::Item THEN BEGIN
                    GetLocation(Description);
                    Location.TESTFIELD("Directed Put-away and Pick", FALSE);
                END;
            end;
        }
        field(7; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE IF (Type = CONST(Text)) "Standard Text";

            trigger OnValidate()
            begin
                IF ("No." = '') OR ("No." <> xRec."No.") THEN BEGIN
                    Description := '';
                    "Unit of Measure Code" := '';
                    "Qty. per Unit of Measure" := 1;
                    "Variant Code" := '';
                    "Work Type Code" := '';
                    "Gen. Bus. Posting Group" := '';
                    "Gen. Prod. Posting Group" := '';
                    DeleteAmounts;
                    "Cost Factor" := 0;
                    CheckedAvailability := FALSE;
                    IF "No." <> '' THEN BEGIN
                        // Preserve quantities after resetting all amounts:
                        Quantity := xRec.Quantity;
                        "Quantity (Base)" := xRec."Quantity (Base)";
                    END ELSE
                        EXIT;
                END;

                GetJob;
                "Customer Price Group" := Job."Customer Price Group";

                CASE Type OF
                    Type::Resource:
                        BEGIN
                            Res.GET("No.");
                            Res.TESTFIELD(Blocked, FALSE);
                            Description := Res.Name;
                            "Description 2" := Res."Name 2";
                            "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                            "Resource Group No." := Res."Resource Group No.";
                            VALIDATE("Unit of Measure Code", Res."Base Unit of Measure");
                        END;
                    Type::Item:
                        BEGIN
                            GetItem;
                            Item.TESTFIELD(Blocked, FALSE);
                            Description := Item.Description;
                            "Description 2" := Item."Description 2";
                            IF Job."Language Code" <> '' THEN
                                GetItemTranslation;
                            "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                            VALIDATE("Unit of Measure Code", Item."Base Unit of Measure");
                        END;
                    Type::"G/L Account":
                        BEGIN
                            GLAcc.GET("No.");
                            GLAcc.CheckGLAcc;
                            GLAcc.TESTFIELD("Direct Posting", TRUE);
                            Description := GLAcc.Name;
                            "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
                            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                            "Unit of Measure Code" := '';
                            "Direct Unit Cost (LCY)" := 0;
                            "Unit Cost (LCY)" := 0;
                            "Unit Price" := 0;
                        END;
                    Type::Text:
                        BEGIN
                            StdTxt.GET("No.");
                            Description := StdTxt.Description;
                        END;
                END;

                IF Type <> Type::Text THEN
                    VALIDATE(Quantity);
            end;
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                CASE Type OF
                    Type::Item:
                        BEGIN
                            IF NOT Item.GET("No.") THEN
                                ERROR(Text004, Type, Item.FIELDCAPTION("No."));
                            CheckItemAvailable;
                        END;
                    Type::Resource:
                        IF NOT Res.GET("No.") THEN
                            ERROR(Text004, Type, Res.FIELDCAPTION("No."));
                    Type::"G/L Account":
                        IF NOT GLAcc.GET("No.") THEN
                            ERROR(Text004, Type, GLAcc.FIELDCAPTION("No."));
                END;

                "Quantity (Base)" := CalcBaseQty(Quantity);
                UpdateAllAmounts;
            end;
        }
        field(11; "Direct Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost (LCY)';
        }
        field(12; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                IF (Type = Type::Item) AND
                   Item.GET("No.") AND
                   (Item."Costing Method" = Item."Costing Method"::Standard) THEN
                    UpdateAllAmounts
                ELSE BEGIN
                    GetJob;
                    "Unit Cost" := ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          "Currency Date", "Currency Code",
                          "Unit Cost (LCY)", "Currency Factor"),
                        UnitAmountRoundingPrecision);
                    UpdateAllAmounts;
                END;
            end;
        }
        field(13; "Total Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost (LCY)';
            Editable = false;
        }
        field(14; "Unit Price (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                GetJob;
                "Unit Price" := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Currency Date", "Currency Code",
                      "Unit Price (LCY)", "Currency Factor"),
                    UnitAmountRoundingPrecision);
                UpdateAllAmounts;
            end;
        }
        field(15; "Total Price (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price (LCY)';
            Editable = false;
        }
        field(16; "Resource Group No."; Code[20])
        {
            Caption = 'Resource Group No.';
            Editable = false;
            TableRelation = "Resource Group";
        }
        field(17; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE IF (Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("No."))
            ELSE
            "Unit of Measure";

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                GetGLSetup;
                CASE Type OF
                    Type::Item:
                        BEGIN
                            Item.GET("No.");
                            "Qty. per Unit of Measure" :=
                              UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
                        END;
                    Type::Resource:
                        BEGIN
                            IF CurrFieldNo <> FIELDNO("Work Type Code") THEN
                                IF "Work Type Code" <> '' THEN BEGIN
                                    WorkType.GET("Work Type Code");
                                    IF WorkType."Unit of Measure Code" <> '' THEN
                                        TESTFIELD("Unit of Measure Code", WorkType."Unit of Measure Code");
                                END ELSE
                                    TESTFIELD("Work Type Code", '');
                            IF "Unit of Measure Code" = '' THEN BEGIN
                                Resource.GET("No.");
                                "Unit of Measure Code" := Resource."Base Unit of Measure";
                            END;
                            ResUnitofMeasure.GET("No.", "Unit of Measure Code");
                            "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                            "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
                        END;
                    Type::"G/L Account":
                        BEGIN
                            "Qty. per Unit of Measure" := 1;
                        END;
                END;

                VALIDATE(Quantity);
            end;
        }
        field(20; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            begin
                "Bin Code" := '';
                IF Type = Type::Item THEN BEGIN
                    GetLocation(Description);
                    Location.TESTFIELD("Directed Put-away and Pick", FALSE);
                    VALIDATE(Quantity);
                END;
            end;
        }
        field(29; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(30; "User ID"; Code[20])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(32; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";

            trigger OnValidate()
            begin
                TESTFIELD(Type, Type::Resource);
                VALIDATE("Line Discount %", 0);
                IF (Rec."Work Type Code" = '') AND (xRec."Work Type Code" <> '') THEN BEGIN
                    Res.GET("No.");
                    "Unit of Measure Code" := Res."Base Unit of Measure";
                    VALIDATE("Unit of Measure Code");
                END;
                IF WorkType.GET("Work Type Code") THEN BEGIN
                    IF WorkType."Unit of Measure Code" <> '' THEN BEGIN
                        "Unit of Measure Code" := WorkType."Unit of Measure Code";
                        IF ResUnitofMeasure.GET("No.", "Unit of Measure Code") THEN
                            "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                    END ELSE BEGIN
                        Res.GET("No.");
                        "Unit of Measure Code" := Res."Base Unit of Measure";
                        VALIDATE("Unit of Measure Code");
                    END;
                END;
                VALIDATE(Quantity);
            end;
        }
        field(33; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                    UpdateAllAmounts;
                END;
            end;
        }
        field(79; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Editable = false;
            TableRelation = "Country/Region";
        }
        field(80; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            Editable = false;
            TableRelation = "Gen. Business Posting Group";
        }
        field(81; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            Editable = false;
            TableRelation = "Gen. Product Posting Group";
        }
        field(83; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(1000; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Editable = false;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(1001; "Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                GetJob;
                "Line Amount" := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Currency Date", "Currency Code",
                      "Line Amount (LCY)", "Currency Factor"),
                    AmountRoundingPrecision);
                UpdateAllAmounts;
            end;
        }
        field(1002; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';

            trigger OnValidate()
            begin
                UpdateAllAmounts;
            end;
        }
        field(1003; "Total Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Total Cost';
            Editable = false;
        }
        field(1004; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                UpdateAllAmounts;
            end;
        }
        field(1005; "Total Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Total Price';
            Editable = false;
        }
        field(1006; "Line Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Amount';

            trigger OnValidate()
            begin
                UpdateAllAmounts;
            end;
        }
        field(1007; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';

            trigger OnValidate()
            begin
                UpdateAllAmounts;
            end;
        }
        field(1008; "Line Discount Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                GetJob;
                "Line Discount Amount" := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Currency Date", "Currency Code",
                      "Line Discount Amount (LCY)", "Currency Factor"),
                    AmountRoundingPrecision);
                UpdateAllAmounts;
            end;
        }
        field(1015; "Cost Factor"; Decimal)
        {
            Caption = 'Cost Factor';
            Editable = false;

            trigger OnValidate()
            begin
                UpdateAllAmounts;
            end;
        }
        field(1019; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            Editable = false;
        }
        field(1020; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            Editable = false;
        }
        field(1021; "Line Discount %"; Decimal)
        {
            BlankZero = true;
            Caption = 'Line Discount %';

            trigger OnValidate()
            begin
                UpdateAllAmounts;
            end;
        }
        field(1022; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Schedule,Contract,Both Schedule and Contract';
            OptionMembers = Schedule,Contract,"Both Schedule and Contract";

            trigger OnValidate()
            begin
                Job.GET("Job No.");
                // IF (Job."Job Type" = Job."Job Type"::"Capital WIP") THEN
                //     TESTFIELD("Line Type", "Line Type"::Schedule);
                "Schedule Line" := TRUE;
                "Contract Line" := TRUE;
                IF "Line Type" = "Line Type"::Schedule THEN
                    "Contract Line" := FALSE;
                IF "Line Type" = "Line Type"::Contract THEN
                    "Schedule Line" := FALSE;
            end;
        }
        field(1023; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                UpdateCurrencyFactor;
                UpdateAllAmounts;
            end;
        }
        field(1024; "Currency Date"; Date)
        {
            Caption = 'Currency Date';

            trigger OnValidate()
            begin
                UpdateCurrencyFactor;
                IF (CurrFieldNo <> FIELDNO("Planning Date")) AND ("No." <> '') THEN
                    UpdateFromCurrency;
            end;
        }
        field(1025; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text001, FIELDCAPTION("Currency Code")));
                UpdateAllAmounts;
            end;
        }
        field(1026; "Schedule Line"; Boolean)
        {
            Caption = 'Schedule Line';
            Editable = false;
            InitValue = true;
        }
        field(1027; "Contract Line"; Boolean)
        {
            Caption = 'Contract Line';
            Editable = false;
        }
        field(1028; Invoiced; Boolean)
        {
            Caption = 'Invoiced';
            Editable = false;
        }
        field(1029; Transferred; Boolean)
        {
            Caption = 'Transferred';
            Editable = false;
        }
        field(1030; "Job Contract Entry No."; Integer)
        {
            Caption = 'Job Contract Entry No.';
            Editable = false;
        }
        field(1031; "Invoice Type"; Option)
        {
            Caption = 'Invoice Type';
            Editable = false;
            OptionCaption = ' ,Invoice,Credit Memo,Posted Invoice,Posted Credit Memo';
            OptionMembers = " ",Invoice,"Credit Memo","Posted Invoice","Posted Credit Memo";
        }
        field(1032; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            Editable = false;
            TableRelation = IF ("Invoice Type" = CONST(Invoice),
                                "Invoice Type" = CONST("Credit Memo")) "Sales Invoice Header"
            ELSE IF ("Invoice Type" = CONST("Credit Memo")) "Sales Cr.Memo Header";

            trigger OnLookup()
            var
                JobCreateInvoice: Codeunit "Job Create-Invoice";
            begin
            end;
        }
        field(1033; "Transferred Date"; Date)
        {
            Caption = 'Transferred Date';
            Editable = false;
        }
        field(1034; "Invoiced Date"; Date)
        {
            Caption = 'Invoiced Date';
            Editable = false;
        }
        field(1035; "Invoiced Amount (LCY)"; Decimal)
        {
            Caption = 'Invoiced Amount (LCY)';
            Editable = false;
        }
        field(1036; "Invoiced Cost Amount (LCY)"; Decimal)
        {
            Caption = 'Invoiced Cost Amount (LCY)';
            Editable = false;
        }
        field(1037; "VAT Unit Price"; Decimal)
        {
            Caption = 'VAT Unit Price';
        }
        field(1038; "VAT Line Discount Amount"; Decimal)
        {
            Caption = 'VAT Line Discount Amount';
        }
        field(1039; "VAT Line Amount"; Decimal)
        {
            Caption = 'VAT Line Amount';
        }
        field(1041; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
        }
        field(1042; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(1043; "Job Ledger Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Job Ledger Entry No.';
            Editable = false;
            TableRelation = "Job Ledger Entry";
        }
        field(1044; "Inv. Curr. Unit Price"; Decimal)
        {
            AutoFormatExpression = "Invoice Currency Code";
            AutoFormatType = 2;
            Caption = 'Inv. Curr. Unit Price';
            Editable = false;
        }
        field(1045; "Inv. Curr. Line Amount"; Decimal)
        {
            AutoFormatExpression = "Invoice Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Curr. Line Amount';
            Editable = false;
        }
        field(1046; "Invoice Currency"; Boolean)
        {
            Caption = 'Invoice Currency';
            Editable = false;
        }
        field(1047; "Invoice Currency Code"; Code[10])
        {
            Caption = 'Invoice Currency Code';
            TableRelation = Currency;
        }
        field(1048; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            InitValue = "Order";
            OptionCaption = 'Planning,Quote,Order,Completed';
            OptionMembers = Planning,Quote,"Order",Completed;
        }
        field(1049; "Invoice Currency Factor"; Decimal)
        {
            Caption = 'Invoice Currency Factor';
            Editable = false;
        }
        field(1050; "Ledger Entry Type"; Option)
        {
            Caption = 'Ledger Entry Type';
            OptionCaption = ' ,Resource,Item,G/L Account';
            OptionMembers = " ",Resource,Item,"G/L Account";
        }
        field(1051; "Ledger Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Ledger Entry No.';
            TableRelation = IF ("Ledger Entry Type" = CONST(Resource)) "Res. Ledger Entry"
            ELSE IF ("Ledger Entry Type" = CONST(Item)) "Item Ledger Entry"
            ELSE IF ("Ledger Entry Type" = CONST("G/L Account")) "G/L Entry";
        }
        field(1052; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate()
            begin
                IF "Variant Code" = '' THEN BEGIN
                    IF Type = Type::Item THEN BEGIN
                        Item.GET("No.");
                        Description := Item.Description;
                        "Description 2" := Item."Description 2";
                        GetItemTranslation;
                    END;
                    EXIT;
                END;

                TESTFIELD(Type, Type::Item);

                ItemVariant.GET("No.", "Variant Code");
                Description := ItemVariant.Description;
                "Description 2" := ItemVariant."Description 2";

                VALIDATE(Quantity);
            end;
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));

            trigger OnValidate()
            begin
                TESTFIELD(Description);
                CheckItemAvailable;
            end;
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5410; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TESTFIELD("Qty. per Unit of Measure", 1);
                VALIDATE(Quantity, "Quantity (Base)");
            end;
        }
        field(5900; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
        }
        field(50000; "Total Quantity"; Decimal)
        {
            Description = 'ALLESP BCL0019 23-07-2007';
        }
        field(50001; "Total Amount"; Decimal)
        {
            Description = 'ALLESP BCL0019 23-07-2007';
        }
        field(50002; "Measure Qty"; Decimal)
        {
            Description = 'ALLESP BCL0019 23-07-2007';
        }
        field(50003; "Demo Quantity"; Decimal)
        {
            Description = 'ALLESP BCL0019 23-07-2007';
        }
        field(50004; "Target Cost per Unit"; Decimal)
        {
        }
        field(50005; "Target Cost Total"; Decimal)
        {
        }
        field(50006; "Task Status"; Option)
        {
            OptionMembers = " ","Not Started","In Progress",Completed;
        }
        field(50085; "Version No."; Integer)
        {
        }
        field(50086; "Archived By"; Code[20])
        {
        }
        field(50087; "Date Archived"; Date)
        {
        }
        field(50088; "Time Archived"; Time)
        {
        }
        field(90001; "BOQ Code"; Code[20])
        {
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(90003; "Ending Date"; Date)
        {
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(90004; "Unit of Measure"; Code[20])
        {
            Description = 'ALLESP BCL0011 10-07-2007';
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(90005; Material; Decimal)
        {
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                CalculateRate; //ALLESP BCL0011 11-07-2007
            end;
        }
        field(90006; Labor; Decimal)
        {
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                CalculateRate; //ALLESP BCL0011 11-07-2007
            end;
        }
        field(90007; Equipment; Decimal)
        {
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                CalculateRate; //ALLESP BCL0011 11-07-2007
            end;
        }
        field(90008; Other; Decimal)
        {
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                CalculateRate; //ALLESP BCL0011 11-07-2007
            end;
        }
        field(90009; "OverHead %"; Decimal)
        {
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                CalculateRate; //ALLESP BCL0011 11-07-2007
            end;
        }
        field(90012; "Phase Description"; Text[50])
        {
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(90013; "Entry No."; Integer)
        {
            Description = 'ALLESP BCL0011 10-07-2007';
            TableRelation = "BOQ Item"."Entry No." WHERE("Project Code" = FIELD("Job No."));

            trigger OnValidate()
            var
                BOQMst: Record "BOQ Item";
            begin
                //ALLESP BCL0011 11-07-2007 Start:
                IF BOQMst.GET("Job No.", "Entry No.") THEN;
                //ALLESP BCL0011 11-07-2007 End:
            end;
        }
        field(90014; Bold; Boolean)
        {
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(90016; Usage; Code[20])
        {
            Caption = 'Usage';
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                IF Usage = '' THEN
                    EXIT;

                CASE Type OF
                    Type::"G/L Account":
                        BEGIN
                            GLAcc.GET(Usage);
                            GLAcc.CheckGLAcc;
                            GLAcc.TESTFIELD("Direct Posting", TRUE);
                        END;
                END;
            end;
        }
        field(90017; Selected; Boolean)
        {
            Description = 'Alleab';

            trigger OnValidate()
            begin
                BEGIN
                    IF xRec.Selected = TRUE THEN
                        IF CONFIRM('Do you want to remove selection?', FALSE) THEN
                            Selected := FALSE
                        ELSE
                            Selected := TRUE;

                END;
            end;
        }
        field(90018; "This Bill Qty."; Decimal)
        {
            DecimalPlaces = 1 : 3;
            Description = 'Alleab';
        }
        field(90019; "BOQ Rate Inclusive Tax"; Boolean)
        {
            Description = 'ALLEAB20-03';
        }
        field(90020; "Rate Only"; Boolean)
        {
            Description = 'ALLEAB25-03';
        }
        field(90021; "Non Schedule"; Boolean)
        {
            Description = 'ALLEAB25-03';
        }
        field(90022; "BOQ Type"; Option)
        {
            Caption = 'BOQ Type';
            Description = 'ALLEAA';
            Editable = false;
            OptionCaption = ' ,Sale,Purchase';
            OptionMembers = " ",Sale,Purchase;
        }
        field(90023; "G/L Account"; Code[20])
        {
            Description = 'ALLEAA';
            TableRelation = "G/L Account" WHERE("Direct Posting" = FILTER(false));
        }
        field(90024; "Shortcut Dimension 2 Code"; Code[20])
        {
        }
        field(90025; "Posted Quantity"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job Contract Entry No." = FIELD("Job Contract Entry No.")));
            Caption = 'Posted Quantity';
            Description = 'ALLEAA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90026; "Tender Rate"; Decimal)
        {
            Caption = 'Tender Rate';
            Description = 'ALLERP KRN0008 18-08-2010:';
        }
        field(90027; "Premium/Discount Amount"; Decimal)
        {
            Caption = 'Premium/Discount Amount';
            Description = 'ALLERP KRN0008 18-08-2010:';
        }
        field(90128; "Tax Structure"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Job No.", "Job Task No.", "Line No.", "Version No.")
        {
            Clustered = true;
            SumIndexFields = "Total Price", Quantity, "Line Amount", "Total Cost", "Tender Rate", "Premium/Discount Amount";
        }
        key(Key2; "Job No.", "Job Task No.", "Schedule Line", "Planning Date")
        {
            SumIndexFields = "Total Price (LCY)", "Total Cost (LCY)", "Line Amount (LCY)";
        }
        key(Key3; "Job No.", "Job Task No.", "Contract Line", "Planning Date")
        {
            SumIndexFields = "Line Amount (LCY)", "Total Price (LCY)", "Total Cost (LCY)", "Invoiced Amount (LCY)", "Invoiced Cost Amount (LCY)";
        }
        key(Key4; "Job No.", "Job Task No.", "Schedule Line", "Currency Date")
        {
        }
        key(Key5; "Job No.", "Job Task No.", "Contract Line", "Currency Date")
        {
        }
        key(Key6; "Job No.", "Schedule Line", Type, "No.", "Planning Date")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key7; "Job No.", "Schedule Line", Type, "Resource Group No.", "Planning Date")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key8; Status, "Schedule Line", Type, "No.", "Planning Date")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key9; Status, "Schedule Line", Type, "Resource Group No.", "Planning Date")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key10; "Job Contract Entry No.")
        {
        }
        key(Key11; Type, "No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        GLAcc: Record "G/L Account";
        Location: Record Location;
        Item: Record Item;
        JobEntryNo: Record "Job Entry No.";
        JT: Record "Job Task";
        ItemVariant: Record "Item Variant";
        Res: Record Resource;
        ResCost: Record "Resource Cost";
        WorkType: Record "Work Type";
        Job: Record Job;
        ResUnitofMeasure: Record "Resource Unit of Measure";
        ItemJnlLine: Record "Item Journal Line";
        CurrExchRate: Record "Currency Exchange Rate";
        SKU: Record "Stockkeeping Unit";
        StdTxt: Record "Standard Text";
        Currency: Record Currency;
        ItemTranslation: Record "Item Translation";
        GLSetup: Record "General Ledger Setup";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt.";
        UOMMgt: Codeunit "Unit of Measure Management";
        ResFindUnitCost: Codeunit "Resource-Find Cost";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        Text001: Label 'cannot be specified without %1';
        Text002: Label 'You cannot rename a %1.';
        CurrencyDate: Date;
        DontUseCostFactor: Boolean;
        Text003: Label '%1 cannot be %2.';
        Text004: Label 'You must specify %1 %2 in planning line.';
        HasGotGLSetup: Boolean;
        UnitAmountRoundingPrecision: Decimal;
        AmountRoundingPrecision: Decimal;
        CheckedAvailability: Boolean;


    procedure FindResCost()
    begin
        GetGLSetup;
        ResCost.INIT;
        ResCost.Code := "No.";
        ResCost."Work Type Code" := "Work Type Code";
        ResFindUnitCost.RUN(ResCost);
        "Direct Unit Cost (LCY)" := ResCost."Direct Unit Cost" * "Qty. per Unit of Measure";
        VALIDATE("Unit Cost (LCY)", ROUND(ResCost."Unit Cost" * "Qty. per Unit of Measure", GLSetup."Unit-Amount Rounding Precision"));
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    local procedure CheckItemAvailable()
    begin
        IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND (Quantity > 0) AND NOT CheckedAvailability THEN BEGIN
            ItemJnlLine."Item No." := "No.";
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
            ItemJnlLine."Location Code" := Description;
            ItemJnlLine."Variant Code" := "Variant Code";
            ItemJnlLine."Bin Code" := "Bin Code";
            ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
            ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            ItemJnlLine.Quantity := Quantity;
            ItemCheckAvail.ItemJnlCheckLine(ItemJnlLine);
            CheckedAvailability := TRUE;
        END;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        IF LocationCode = '' THEN
            CLEAR(Location)
        ELSE
            IF Location.Code <> LocationCode THEN
                Location.GET(LocationCode);
    end;


    procedure UpdateAmounts()
    begin
        IF (CurrFieldNo <> FIELDNO(Type)) AND (CurrFieldNo <> 0) THEN
            IF Type = Type::Text THEN
                ERROR(Text003, FIELDCAPTION(Type), Type);
        GetCurrency;
        IF "Line Amount" <> ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") - "Line Discount Amount" THEN BEGIN
            "Line Amount" := ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") - "Line Discount Amount";
        END;
        IF "Line Amount (LCY)" <> ROUND(Quantity * "Unit Price (LCY)") - "Line Discount Amount (LCY)" THEN
            "Line Amount (LCY)" := ROUND(Quantity * "Unit Price (LCY)") - "Line Discount Amount (LCY)";
    end;


    procedure GetJob()
    begin
        TESTFIELD("Job No.");
        IF "Job No." <> Job."No." THEN BEGIN
            Job.GET("Job No.");
            IF Job."Currency Code" = '' THEN BEGIN
                GetGLSetup;
                Currency.InitRoundingPrecision;
                AmountRoundingPrecision := GLSetup."Amount Rounding Precision";
                UnitAmountRoundingPrecision := GLSetup."Unit-Amount Rounding Precision";
            END ELSE BEGIN
                GetCurrency;
                Currency.GET(Job."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
                AmountRoundingPrecision := Currency."Amount Rounding Precision";
                UnitAmountRoundingPrecision := Currency."Unit-Amount Rounding Precision";
            END;
        END;
    end;


    procedure UpdateCurrencyFactor()
    begin
        IF "Currency Code" <> '' THEN BEGIN
            IF "Currency Date" = 0D THEN
                CurrencyDate := WORKDATE
            ELSE
                CurrencyDate := "Currency Date";
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        END ELSE
            "Currency Factor" := 0;
    end;

    local procedure GetUnitCost()
    begin
        TESTFIELD(Type, Type::Item);
        TESTFIELD("No.");
        GetItem;
        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
        IF GetSKU THEN
            VALIDATE("Unit Cost (LCY)", SKU."Unit Cost" * "Qty. per Unit of Measure")
        ELSE
            VALIDATE("Unit Cost (LCY)", Item."Unit Cost" * "Qty. per Unit of Measure");
    end;

    local procedure GetItem()
    begin
        TESTFIELD("No.");
        IF "No." <> Item."No." THEN
            Item.GET("No.");
    end;

    local procedure GetSKU(): Boolean
    begin
        IF (SKU."Location Code" = Description) AND
           (SKU."Item No." = "No.") AND
           (SKU."Variant Code" = "Variant Code")
        THEN
            EXIT(TRUE);

        IF SKU.GET(Description, "No.", "Variant Code") THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    local procedure GetCurrency()
    begin
        IF "Currency Code" = '' THEN BEGIN
            CLEAR(Currency);
            Currency.InitRoundingPrecision
        END ELSE BEGIN
            Currency.GET("Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
            Currency.TESTFIELD("Unit-Amount Rounding Precision");
        END;
    end;


    procedure Caption(): Text[250]
    var
        Job: Record Job;
        JT: Record "Job Task";
    begin
        IF NOT Job.GET("Job No.") THEN
            EXIT('');
        IF NOT JT.GET("Job No.", "Job Task No.") THEN
            EXIT('');
        EXIT(STRSUBSTNO('%1 %2 %3 %4',
            Job."No.",
            Job.Description,
            JT."Job Task No.",
            JT.Description));
    end;


    procedure SetUpNewLine(LastJobPlanningLine: Record "Job Planning Line")
    begin
        "Document Date" := LastJobPlanningLine."Planning Date";
        "Document No." := LastJobPlanningLine."Document No.";
        Type := LastJobPlanningLine.Type.AsInteger();
        VALIDATE("Line Type", LastJobPlanningLine."Line Type");
        GetJob;
        "Currency Code" := Job."Currency Code";
        IF LastJobPlanningLine."Planning Date" <> 0D THEN
            VALIDATE("Planning Date", LastJobPlanningLine."Planning Date");
    end;


    procedure InitJobPlanningLine()
    begin
        Transferred := FALSE;
        Invoiced := FALSE;
        "Invoiced Amount (LCY)" := 0;
        "Invoiced Cost Amount (LCY)" := 0;
        "Invoice Type" := 0;
        "Invoice No." := '';
        "Transferred Date" := 0D;
        "Invoiced Date" := 0D;
        "VAT Unit Price" := 0;
        "VAT Line Discount Amount" := 0;
        "VAT Line Amount" := 0;
        "VAT %" := 0;
        "Job Ledger Entry No." := 0;
        "Inv. Curr. Unit Price" := 0;
        "Inv. Curr. Line Amount" := 0;
        "Invoice Currency Code" := '';
        "Invoice Currency" := FALSE;
    end;


    procedure DeleteAmounts()
    begin
        Quantity := 0;
        "Quantity (Base)" := 0;

        "Direct Unit Cost (LCY)" := 0;
        "Unit Cost (LCY)" := 0;
        "Unit Cost" := 0;

        "Total Cost (LCY)" := 0;
        "Total Cost" := 0;

        "Unit Price (LCY)" := 0;
        "Unit Price" := 0;

        "Total Price (LCY)" := 0;
        "Total Price" := 0;

        "Line Amount (LCY)" := 0;
        "Line Amount" := 0;

        "Line Discount %" := 0;

        "Line Discount Amount (LCY)" := 0;
        "Line Discount Amount" := 0;
    end;


    procedure UpdateFromCurrency()
    begin
        GetJob;
        UpdateAllAmounts;
    end;


    procedure GetItemTranslation()
    begin
        GetJob;
        IF ItemTranslation.GET("No.", "Variant Code", Job."Language Code") THEN BEGIN
            Description := ItemTranslation.Description;
            "Description 2" := ItemTranslation."Description 2";
        END;
    end;


    procedure GetGLSetup()
    begin
        IF HasGotGLSetup THEN
            EXIT;
        GLSetup.GET;
        HasGotGLSetup := TRUE;
    end;


    procedure UpdateAllAmounts()
    begin
    end;

    local procedure UpdateUnitCost()
    var
        RetrievedCost: Decimal;
    begin
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
            IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
                IF RetrieveCostPrice THEN BEGIN
                    IF GetSKU THEN
                        "Unit Cost (LCY)" := SKU."Unit Cost" * "Qty. per Unit of Measure"
                    ELSE
                        "Unit Cost (LCY)" := Item."Unit Cost" * "Qty. per Unit of Measure";
                    "Unit Cost" := ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          "Currency Date", "Currency Code",
                          "Unit Cost (LCY)", "Currency Factor"),
                              UnitAmountRoundingPrecision);
                END ELSE BEGIN
                    IF "Unit Cost" <> xRec."Unit Cost" THEN
                        "Unit Cost (LCY)" := ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(
                              "Currency Date", "Currency Code",
                              "Unit Cost", "Currency Factor"),
                            UnitAmountRoundingPrecision)
                    ELSE
                        "Unit Cost" := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      "Currency Date", "Currency Code",
                              "Unit Cost (LCY)", "Currency Factor"),
                            UnitAmountRoundingPrecision);
                END;
            END ELSE BEGIN
                IF RetrieveCostPrice THEN BEGIN
                    IF GetSKU THEN
                        RetrievedCost := SKU."Unit Cost" * "Qty. per Unit of Measure"
                    ELSE
                        RetrievedCost := Item."Unit Cost" * "Qty. per Unit of Measure";
                    "Unit Cost" := ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          "Currency Date", "Currency Code",
                          RetrievedCost, "Currency Factor"),
                        UnitAmountRoundingPrecision);
                    "Unit Cost (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Currency Date", "Currency Code",
                          "Unit Cost", "Currency Factor"),
                              UnitAmountRoundingPrecision);
                END ELSE BEGIN
                    "Unit Cost (LCY)" := ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    "Currency Date", "Currency Code",
                          "Unit Cost", "Currency Factor"),
                        UnitAmountRoundingPrecision);
                END;
            END;
        END ELSE
            IF (Type = Type::Resource) AND Res.GET("No.") THEN BEGIN
                IF RetrieveCostPrice THEN BEGIN
                    ResCost.INIT;
                    ResCost.Code := "No.";
                    ResCost."Work Type Code" := "Work Type Code";
                    ResFindUnitCost.RUN(ResCost);
                    "Direct Unit Cost (LCY)" := ResCost."Direct Unit Cost" * "Qty. per Unit of Measure";
                    RetrievedCost := ROUND(ResCost."Unit Cost" * "Qty. per Unit of Measure", UnitAmountRoundingPrecision);
                    "Unit Cost" := ROUND(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                    "Currency Date", "Currency Code",
                          RetrievedCost, "Currency Factor"),
                        UnitAmountRoundingPrecision);
                    "Unit Cost (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                    "Currency Date", "Currency Code",
                          "Unit Cost", "Currency Factor"),
                        UnitAmountRoundingPrecision);
                END ELSE BEGIN
                    "Unit Cost (LCY)" := ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    "Currency Date", "Currency Code",
                          "Unit Cost", "Currency Factor"),
                        UnitAmountRoundingPrecision);
                END;
            END ELSE BEGIN
                "Unit Cost (LCY)" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  "Currency Date", "Currency Code",
                      "Unit Cost", "Currency Factor"),
                    UnitAmountRoundingPrecision);
            END;
    end;


    procedure RetrieveCostPrice(): Boolean
    begin
        CASE Type OF
            Type::Item:
                IF ("No." <> xRec."No.") OR
                   (Description <> xRec.Description) OR
                   ("Variant Code" <> xRec."Variant Code") OR
                   ("Unit of Measure Code" <> xRec."Unit of Measure Code") THEN
                    EXIT(TRUE);
            Type::Resource:
                IF ("No." <> xRec."No.") OR
                   ("Work Type Code" <> xRec."Work Type Code") OR
                   ("Unit of Measure Code" <> xRec."Unit of Measure Code") THEN
                    EXIT(TRUE);
            Type::"G/L Account":
                IF "No." <> xRec."No." THEN
                    EXIT(TRUE);
            ELSE
                EXIT(FALSE);
        END;
        EXIT(FALSE);
    end;

    local procedure UpdateTotalCost()
    begin
        "Total Cost" := ROUND("Unit Cost" * Quantity, AmountRoundingPrecision);
        "Total Cost (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date", "Currency Code",
              "Total Cost", "Currency Factor"),
            AmountRoundingPrecision);
    end;


    procedure FindPriceAndDiscount(var JobPlanningLine: Record "Job Planning Line"; CalledByFieldNo: Integer)
    begin
        IF RetrieveCostPrice AND ("No." <> '') THEN BEGIN
            SalesPriceCalcMgt.FindJobPlanningLinePrice(JobPlanningLine, CalledByFieldNo);

            IF Type <> Type::"G/L Account" THEN
                PurchPriceCalcMgt.FindJobPlanningLinePrice(JobPlanningLine, CalledByFieldNo)
            ELSE BEGIN
                // Because the SalesPriceCalcMgt.FindJobJnlLinePrice function also retrieves costs for G/L Account,
                // cost and total cost need to get updated again.
                UpdateUnitCost;
                UpdateTotalCost;
            END;

        END;
    end;

    local procedure HandleCostFactor()
    begin
        IF ("Unit Cost" <> xRec."Unit Cost") OR ("Cost Factor" <> xRec."Cost Factor") THEN BEGIN
            IF "Cost Factor" <> 0 THEN
                "Unit Price" := ROUND("Unit Cost" * "Cost Factor", UnitAmountRoundingPrecision)
            ELSE
                IF xRec."Cost Factor" <> 0 THEN
                    "Unit Price" := 0;
        END;
    end;

    local procedure UpdateUnitPrice()
    begin
        "Unit Price (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date", "Currency Code",
              "Unit Price", "Currency Factor"),
            UnitAmountRoundingPrecision);
    end;

    local procedure UpdateTotalPrice()
    begin
        "Total Price" := ROUND(Quantity * "Unit Price", AmountRoundingPrecision);
        "Total Price (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date", "Currency Code",
              "Total Price", "Currency Factor"),
            AmountRoundingPrecision);
    end;

    local procedure UpdateAmountsAndDiscounts()
    begin
        IF "Total Price" <> 0 THEN BEGIN
            IF ("Line Amount" <> xRec."Line Amount") AND ("Line Discount Amount" = xRec."Line Discount Amount") THEN BEGIN
                "Line Amount" := ROUND("Line Amount", AmountRoundingPrecision);
                "Line Discount Amount" := "Total Price" - "Line Amount";
                "Line Discount %" :=
                  ROUND("Line Discount Amount" / "Total Price" * 100);
            END ELSE
                IF ("Line Discount Amount" <> xRec."Line Discount Amount") AND ("Line Amount" = xRec."Line Amount") THEN BEGIN
                    "Line Discount Amount" := ROUND("Line Discount Amount", AmountRoundingPrecision);
                    "Line Amount" := "Total Price" - "Line Discount Amount";
                    "Line Discount %" :=
                      ROUND("Line Discount Amount" / "Total Price" * 100);
                END ELSE BEGIN
                    "Line Discount Amount" :=
                      ROUND("Total Price" * "Line Discount %" / 100, AmountRoundingPrecision);
                    "Line Amount" := "Total Price" - "Line Discount Amount";
                END;
        END ELSE BEGIN
            "Line Amount" := 0;
            "Line Discount Amount" := 0;
        END;

        "Line Amount (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date", "Currency Code",
              "Line Amount", "Currency Factor"),
            AmountRoundingPrecision);

        "Line Discount Amount (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date", "Currency Code",
              "Line Discount Amount", "Currency Factor"),
            AmountRoundingPrecision);
    end;


    procedure CalculateRate()
    begin
        //ALLESP BCL0011 11-07-2007 Start:
        "Direct Unit Cost (LCY)" := (Material + Labor + Equipment + Other) * (1 + ("OverHead %" / 100));
        "Unit Cost" := (Material + Labor + Equipment + Other) * (1 + ("OverHead %" / 100));
        IF ("Unit Cost" <> xRec."Unit Cost") OR ("Unit Price" <> xRec."Unit Price") THEN;
        //  UpdateJobBudgetEntry;
        //ALLESP BCL0011 11-07-2007 End:
    end;
}

