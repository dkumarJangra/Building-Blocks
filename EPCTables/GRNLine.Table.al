table 97732 "GRN Line"
{
    // //JPL-OPt-01 - Optimized and added key
    // //ALLe-pks 07 for part rate funtionality
    // //AlleDK 250308 Flow of "Vendor No." in GRN Line
    // Some fields are flow fileds
    // //SC : New fields added
    // //AlleBLk : New fields added
    // //ALLe-pks 07 for part rate funtionality
    // //NDALLE : Code commented
    // //JPL04 : Write a code
    // ALLERP KRN 14-09-2010: Code added for not accepting -ve quantity
    // //ALLETG RIL0011 22-06-2011: Added field and functions
    // ALLEPG RAHEE1.00 240212 : Created functions for tracking line.

    DrillDownPageID = "GRN Lines";
    LookupPageID = "GRN Lines";

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'GRN';
            OptionMembers = GRN;
        }
        field(2; "GRN No."; Code[20])
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; Type; Option)
        {
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset";
        }
        field(5; "No."; Code[20])
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE IF (Type = CONST(Item)) Item
            ELSE IF (Type = CONST("Fixed Asset")) "Fixed Asset";

            trigger OnValidate()
            begin
                Item.RESET;
                IF Item.GET("No.") THEN BEGIN
                    Description := Item.Description;
                    "Tolerance Percentage" := Item."Tolerance  Percentage";
                END;
            end;
        }
        field(6; Description; Text[50])
        {
        }
        field(7; "Description 2"; Text[50])
        {
        }
        field(8; "Unit of Measure Code"; Code[20])
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE IF (Type = CONST("G/L Account")) "Unit of Measure".Code
            ELSE IF (Type = CONST("Fixed Asset")) "Unit of Measure".Code;
        }
        field(9; Status; Option)
        {
            OptionCaption = 'Open,Close';
            OptionMembers = Open,Close;
        }
        field(10; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(11; "Purchase Order No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Order),
                                                         Approved = FILTER(true));
        }
        field(12; "Purchase Order Line No."; Integer)
        {
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = FILTER(Order),
                                                              "Document No." = FIELD("Purchase Order No."));
        }
        field(13; "Order Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                VALIDATE("Challan Qty", "Order Qty");
                /*
                VALIDATE("Received Qty" ,"Order Qty");
                VAlidate("Accepted Qty", "Order Qty");
                VALIDATE("Rejected Qty",0);
                */

            end;
        }
        field(14; "Challan Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                VALIDATE("Received Qty", "Challan Qty");
                /*
                VALIDATE("Accepted Qty","Challan Qty");
                VALIDATE("Rejected Qty",0);
                */

            end;
        }
        field(15; "Received Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                TolerenceQty: Decimal;
            begin
                VALIDATE("Accepted Qty", "Received Qty");
                VALIDATE("Rejected Qty", 0);

                //AlleBLK
                IF "Tolerance Percentage" = 0 THEN
                    IF "Received Qty" > "Order Qty" THEN
                        ERROR('Received Qty must be Less than OR Equal to Order Qty');
                IF "Tolerance Percentage" <> 0 THEN BEGIN
                    PurchLine.RESET;
                    PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SETRANGE("Document No.", "Purchase Order No.");
                    IF PurchLine.FIND('-') THEN
                        TolerenceQty := (PurchLine.Quantity + (PurchLine.Quantity * "Tolerance Percentage" / 100) - PurchLine."Quantity Received");
                    //"Excess Qty" := PurchLine.Quantity + (PurchLine.Quantity * "Tolerance Percentage"/100) - "Received Qty";
                    "Excess Qty" := "Received Qty" - (PurchLine.Quantity - PurchLine."Quantity Received");
                    IF "Excess Qty" < 0 THEN
                        "Excess Qty" := 0;
                    //MESSAGE(FORMAT(TolerenceAmount));
                    IF "Received Qty" > TolerenceQty THEN
                        ERROR('Received Qty must not cross Tolerance Limit');
                END;
                VALIDATE("Excess Qty");
            end;
        }
        field(16; "Accepted Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                TolerenceQty: Decimal;
            begin
                //IF "Tolerance Percentage" = 0 THEN
                //IF "Accepted Qty" > "Order Qty" THEN
                // ERROR('Received Qty must be Less than OR Equal to Order Qty');

                IF Type = Type::Item THEN BEGIN

                    IF "Tolerance Percentage" = 0 THEN
                        IF "Accepted Qty" > "Received Qty" THEN
                            ERROR('Accepted Qty must be Less than OR Equal to Received Qty');
                    //ALLERP Start:
                    IF "Accepted Qty" < 0 THEN
                        ERROR(Text001);
                    //ALLERP End:
                    IF "Tolerance Percentage" <> 0 THEN BEGIN

                        PurchLine.RESET;
                        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
                        PurchLine.SETRANGE("Document No.", "Purchase Order No.");
                        PurchLine.SETRANGE("Line No.", "Purchase Order Line No.");
                        IF PurchLine.FIND('-') THEN
                            //Net Max Limit
                            TolerenceQty := (PurchLine.Quantity + (PurchLine.Quantity * "Tolerance Percentage" / 100) - PurchLine."Quantity Received");
                        //"Excess Qty" := "Received Qty"-(PurchLine.Quantity -  PurchLine."Quantity Received");
                        "Excess Qty" := "Accepted Qty" - (PurchLine.Quantity - PurchLine."Quantity Received");

                        // ALLEPG 081111 Start
                        /*
                        //ALLETG RIL0011 24-06-2011: START>>
                        PurchDeliverySch.RESET;
                        IF PurchDeliverySch.GET(PurchDeliverySch."Document Type"::Order,
                                                "Purchase Order No.",
                                                "Purchase Order Line No.",
                                                "Schedule Line No.") THEN BEGIN
                          //Net Max Limit
                          PurchDeliverySch.CALCFIELDS("Received Quantity");
                          TolerenceQty :=  PurchDeliverySch."Schedule Quantity" + (PurchDeliverySch."Schedule Quantity" * "Tolerance Percentage"/100)
                                           - PurchDeliverySch."Received Quantity";
                          "Excess Qty" := "Accepted Qty" - (PurchDeliverySch."Schedule Quantity" - PurchDeliverySch."Received Quantity");
                        //ALLETG RIL0011 24-06-2011: END<<
                        END;
                        */
                        // ALLEPG 081111 End
                        IF "Excess Qty" < 0 THEN
                            "Excess Qty" := 0;
                        IF "Accepted Qty" > TolerenceQty THEN
                            ERROR('Accepted Qty must not cross Tolerance Limit');
                    END;
                    //VALIDATE("Excess Qty");

                END;

                IF "Tolerance Percentage" = 0 THEN BEGIN
                    IF "Accepted Qty" > "Order Qty" THEN
                        ERROR('Accepted Qty must be Less than OR Equal to Pending Order Qty');
                    IF "Accepted Qty" > "Received Qty" THEN
                        ERROR('Accepted Qty must be Less than OR Equal to Received Qty');
                END;
                "Rejected Qty" := "Received Qty" - "Accepted Qty";
                IF "Rejected Qty" < 0 THEN
                    "Rejected Qty" := 0;
                //VALIDATE("Rejected Qty");

                "Accepted Quantity Base" := "Qty per Unit of Measure" * "Accepted Qty";
                "Rejected Quantity Base" := "Qty per Unit of Measure" * "Rejected Qty";

                //For Brick and Cement Std Consumption
                "Brick Std Cons. Qty" := "Brick Std Cons. Rate" * "Accepted Qty";
                "Cement Std Cons. Qty" := "Cement Std Cons. Rate" * "Accepted Qty";
                "Steel Std Cons. Qty" := "Steel Std Cons. Rate" * "Accepted Qty";

                CalculateDirectUnitCost;

            end;
        }
        field(17; "Rejected Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(23; "Rejection Note No."; Code[20])
        {
        }
        field(24; "Rejection Note Generated"; Boolean)
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '// ALLE MM Field Added';

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(50003; Approved; Boolean)
        {
            Description = 'AlleBLk';
        }
        field(50004; "Description 3"; Text[60])
        {
            Description = 'SC';
        }
        field(50005; "Description 4"; Text[60])
        {
            Description = 'SC';
        }
        field(50010; Initiator; Code[20])
        {
            Description = 'AlleBLk';
            TableRelation = Employee;
        }
        field(50016; "Sent for Approval"; Boolean)
        {
            Description = 'AlleBLk';
        }
        field(50017; "Reason for Rejection"; Text[30])
        {
            Description = 'AlleBLk';
        }
        field(50018; "Tolerance Percentage"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50019; "Excess Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50020; "Job Code"; Code[20])
        {
            Description = 'AlleBLk';
            TableRelation = "Job Master";

            trigger OnLookup()
            var
                JobMst: Record "Job Master";
            begin
            end;

            trigger OnValidate()
            var
                JobMst: Record "Job Master";
                DimVal: Record "Dimension Value";
            begin
            end;
        }
        field(50021; "Qty per Unit of Measure"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50022; "Accepted Quantity Base"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50023; "Rejected Quantity Base"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
        }
        field(50024; "Direct Unit Cost"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;

            trigger OnValidate()
            begin
                CalculateDirectUnitCost;
            end;
        }
        field(50025; "Line Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;

            trigger OnValidate()
            begin
                CalculateDirectUnitCost;
            end;
        }
        field(50030; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = 'AlleBLk';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode1(1, "Shortcut Dimension 1 Code");
                MODIFY;
            end;
        }
        field(50031; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'AlleBLk';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode1(2, "Shortcut Dimension 2 Code");
                MODIFY;
            end;
        }
        field(50098; "Workflow Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Released,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";
        }
        field(50099; "Workflow Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward';
            OptionMembers = " ",FA,Regular,Direct,WorkOrder,Inward,Outward;
        }
        field(50120; "Basic Rate"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
        }
        field(50121; "Basic Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50122; "Excise Percent"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
        }
        field(50123; "Excise Per Unit"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50124; "Tot Excise Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50125; "Sales Tax %"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
        }
        field(50126; "Sales Tax Per Unit"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50127; "Tot Sales Tax Amt"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50128; "Service Tax Percent-Freight"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
        }
        field(50129; "Service Tax Per Unit-Freight"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50130; "Tot Service Tax Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50131; "Entry Tax / Octroi Per Unit"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
        }
        field(50132; "Entry Tax / Octroi Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50133; "Insurance Rate"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
        }
        field(50134; "Insurance Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50135; "Packing & Forwarding %"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
        }
        field(50136; "Packing & Forwarding Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50137; "Freight Rate"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
        }
        field(50138; "Freight Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50139; "Other Rate"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'AlleBLk';
        }
        field(50140; "Other Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50142; "Packing & Forwarding per Unit"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50143; "Entry Tax/Octroi %"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50144; "Installation & Comm. Rate"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50145; "Installation & Comm. Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50146; "Service Tax on Inst. & Comm %"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50147; "ServiceTax-Inst.Comm per unit"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50148; "ServiceTax-Inst.Comm Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50149; "Bank Charges/DD Commision Rate"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50150; "Bank Charges/DD Commision Amt"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50151; "Inspection Rate"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50152; "Inspection Amount"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50153; "Other Rate 2"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50154; "Other Amount 2"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50155; "Weight Qty"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';

            trigger OnValidate()
            begin
                VALIDATE("Challan Qty", "Weight Qty" * "Weight Rate");
            end;
        }
        field(50156; "Weight Rate"; Decimal)
        {
            Description = 'AlleBLk';

            trigger OnValidate()
            begin
                VALIDATE("Challan Qty", "Weight Qty" * "Weight Rate");
            end;
        }
        field(50157; "Posting Date"; Date)
        {
            CalcFormula = Lookup("GRN Header"."Posting Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                    "GRN No." = FIELD("GRN No.")));
            Description = 'flow field';
            FieldClass = FlowField;
        }
        field(50158; "Creation Date"; Date)
        {
            CalcFormula = Lookup("GRN Header"."Creation Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                     "GRN No." = FIELD("GRN No.")));
            Description = 'flowfield';
            FieldClass = FlowField;
        }
        field(50159; "Brick Std Cons. Rate"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50160; "Cement Std Cons. Rate"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50161; "Brick Std Cons. Qty"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50162; "Cement Std Cons. Qty"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50163; "Brick Actual Cons. Qty"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50164; "Cement Actual Cons. Qty"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50165; "Total Brick Std Cons. Qty"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Brick Std Cons. Qty" WHERE("Purchase Order No." = FIELD("Purchase Order No.")));
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50166; "Total Cement Std Cons. Qty"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Cement Std Cons. Qty" WHERE("Purchase Order No." = FIELD("Purchase Order No.")));
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50167; "Total Brick Actual Cons. Qty"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Brick Actual Cons. Qty" WHERE("Purchase Order No." = FIELD("Purchase Order No.")));
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50168; "Total Cement Actual Cons. Qty"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Cement Actual Cons. Qty" WHERE("Purchase Order No." = FIELD("Purchase Order No.")));
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50169; "Steel Std Cons. Rate"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50170; "Steel Actual Cons. Qty"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50171; "Total Steel Actual Cons. Qty"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Steel Actual Cons. Qty" WHERE("Purchase Order No." = FIELD("Purchase Order No.")));
            Description = 'flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50172; "Steel Std Cons. Qty"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50173; "Total Steel Std Cons. Qty"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Steel Std Cons. Qty" WHERE("Purchase Order No." = FIELD("Purchase Order No.")));
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50174; "Discount %"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50175; "Discount Rate"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50176; "Discount Amt"; Decimal)
        {
            Description = 'AlleBLk';
            Editable = false;
        }
        field(50177; "Invoiced Qty"; Decimal)
        {
            CalcFormula = Sum("Purch. Rcpt. Line"."Quantity Invoiced" WHERE("Order No." = FIELD("Purchase Order No."),
                                                                             "Order Line No." = FIELD("Purchase Order Line No."),
                                                                             "Document No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(50178; "Qty Recd not Invoiced"; Decimal)
        {
            CalcFormula = Sum("Purch. Rcpt. Line"."Qty. Rcd. Not Invoiced" WHERE("Order No." = FIELD("Purchase Order No."),
                                                                                  "Order Line No." = FIELD("Purchase Order Line No."),
                                                                                  "Document No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(50179; "Invoiced Value"; Decimal)
        {
            Description = 'ALLe-pks 07 for part rate funtionality';
        }
        field(50180; "Vendor No."; Code[20])
        {
            Description = 'AlleDK 250308';
            TableRelation = Vendor;
        }
        field(50181; "Schedule Line No."; Integer)
        {
            Description = 'ALLETG RIL0011 22-06-2011';
        }
    }

    keys
    {
        key(Key1; "Document Type", "GRN No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Line Amount", "Basic Amount", "Tot Excise Amount", "Tot Sales Tax Amt", "Tot Service Tax Amount", "Entry Tax / Octroi Amount", "Insurance Amount", "Packing & Forwarding Amount", "Freight Amount", "Other Amount", "Installation & Comm. Amount", "ServiceTax-Inst.Comm Amount", "Bank Charges/DD Commision Amt", "Inspection Amount", "Other Amount 2";
        }
        key(Key2; "Purchase Order No.", "Purchase Order Line No.", Status)
        {
            SumIndexFields = "Order Qty", "Accepted Qty", "Rejected Qty", "Brick Std Cons. Qty", "Brick Actual Cons. Qty", "Cement Actual Cons. Qty", "Cement Std Cons. Qty", "Steel Std Cons. Rate", "Steel Actual Cons. Qty", "Steel Std Cons. Qty";
        }
        key(Key3; "No.")
        {
        }
        key(Key4; Type, "No.", Status)
        {
            SumIndexFields = "Accepted Quantity Base";
        }
        key(Key5; "Rejected Qty")
        {
        }
        key(Key6; "Shortcut Dimension 1 Code", "No.", Status, Approved)
        {
        }
        key(Key7; "Shortcut Dimension 1 Code", "Purchase Order No.", "Vendor No.", Status, Approved)
        {
        }
        key(Key8; "Shortcut Dimension 1 Code", "GRN No.", Type, "No.")
        {
        }
        key(Key9; "Purchase Order No.", "No.", "Purchase Order Line No.", Status)
        {
        }
        key(Key10; "Purchase Order No.", "Purchase Order Line No.", "Schedule Line No.", Status)
        {
            SumIndexFields = "Accepted Qty";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD("Sent for Approval", FALSE);

        //NDALLE 130308
        RecMemberof.RESET;
        RecMemberof.SETRANGE("User Name", USERID);
        RecMemberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT RecMemberof.FINDFIRST THEN BEGIN
            RecGH.RESET;
            RecGH.SETRANGE("GRN No.", "GRN No.");
            IF RecGH.FINDFIRST THEN BEGIN
                IF RecGH.Approved = TRUE THEN
                    ERROR('You Can not Delete Approved Documents');
            END;
        END;
        //NDALLE 130308
    end;

    trigger OnInsert()
    begin
        //NDALLE 130308
        RecMemberof.RESET;
        RecMemberof.SETRANGE("User Name", USERID);
        RecMemberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT RecMemberof.FINDFIRST THEN BEGIN
            RecGH.RESET;
            RecGH.SETRANGE("GRN No.", "GRN No.");
            IF RecGH.FINDFIRST THEN BEGIN
                IF RecGH.Approved = TRUE THEN
                    ERROR('You Can not Insert in Approved Documents');
            END;
        END;
        //NDALLE 130308
    end;

    trigger OnModify()
    begin
        //NDALLE 130308
        RecMemberof.RESET;
        RecMemberof.SETRANGE("User Name", USERID);
        RecMemberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT RecMemberof.FINDFIRST THEN BEGIN
            RecGH.RESET;
            RecGH.SETRANGE("GRN No.", "GRN No.");
            IF RecGH.FINDFIRST THEN BEGIN
                IF RecGH.Approved = TRUE THEN
                    ERROR('You Can not Modify Approved Documents');
            END;
        END;
        //NDALLE 130308
    end;

    var
        Item: Record Item;
        GRNLine: Record "GRN Line";
        PurchLine: Record "Purchase Line";
        JobMst: Record "Job Master";
        GRNLine2: Record "GRN Line";
        QtyOnGRN: Decimal;
        FromPurchHeader: Record "Purchase Header";
        DimMgt: Codeunit DimensionManagement;
        FromPurchLIne: Record "Purchase Line";
        RecGH: Record "GRN Header";
        Text001: Label 'Quantity should be greater than Zero';
        PurchDeliverySch: Record "Purch. Delivery Schedule";
        Text50001: Label 'Only one delivery schedule per purchase line no. %1 can be selected.';
        RecMemberof: Record "Access Control";
        Text049: Label 'You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
        Text050: Label 'Cancelled.';


    procedure InsertGRNLines(RecGRN: Record "GRN Header")
    var
        PurchLineL: Record "Purchase Line";
        PurchLineFrm: Page "Purchase Lines";
        ToGRNHeader: Record "GRN Header";
        GrnLinerec: Record "GRN Line";
    begin
        PurchLineL.FILTERGROUP := 2;
        PurchLineL.RESET;
        PurchLineL.SETRANGE("Document Type", PurchLineL."Document Type"::Order);
        PurchLineL.SETRANGE("Document No.", RecGRN."Purchase Order No.");
        PurchLineL.SETRANGE(Blocked, FALSE);
        PurchLineL.FILTERGROUP := 0;

        IF PurchLineL.FIND('-') THEN
            REPEAT
                IF PurchLineL.Quantity - PurchLineL."Quantity Received" <> 0 THEN
                    PurchLineL.MARK(TRUE);
            UNTIL PurchLineL.NEXT = 0;

        PurchLineL.MARKEDONLY(TRUE);

        IF PurchLineL.FIND('-') THEN BEGIN
            CLEAR(PurchLineFrm);
            PurchLineFrm.SETTABLEVIEW(PurchLineL);
            PurchLineFrm.LOOKUPMODE := TRUE;
            PurchLineFrm.SetGRNHeader(RecGRN);
            PurchLineFrm.SetGRNMode(TRUE);
            PurchLineFrm.RUNMODAL;
        END;
        // ALLE MM Code Commented
        /*
        //ashish for Dimension posting
        FromPurchHeader.RESET;
        FromPurchHeader.SETRANGE("Document Type",PurchLineL."Document Type"::Order);
        FromPurchHeader.SETFILTER("No.",RecGRN."Purchase Order No.");
        FromPurchHeader.FIND('-');
        DocDim.SETRANGE("Table ID",DATABASE::"GRN Header");
        //DocDim.SETRANGE("Document Type",RecGRN."Document Type");
        DocDim.SETRANGE("Document No.",RecGRN."GRN No.");
        DocDim.SETRANGE("Line No.",0);
        DocDim.DELETEALL;
        "Shortcut Dimension 1 Code" := FromPurchHeader."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := FromPurchHeader."Shortcut Dimension 2 Code";
        FromDocDim.SETRANGE("Table ID",DATABASE::"Purchase Header");
        FromDocDim.SETRANGE("Document Type",FromPurchHeader."Document Type");
        FromDocDim.SETRANGE("Document No.",FromPurchHeader."No.");
        IF FromDocDim.FIND('-') THEN BEGIN
          REPEAT
            DocDim.INIT;
            DocDim."Table ID" := DATABASE::"GRN Header";
            DocDim."Document Type" :=DocDim."Document Type"::Order;
            DocDim."Document No." := "GRN No.";
            DocDim."Line No." := 0;
            DocDim."Dimension Code" := FromDocDim."Dimension Code";
            DocDim."Dimension Value Code" := FromDocDim."Dimension Value Code";
            DocDim.INSERT;
          UNTIL FromDocDim.NEXT = 0;
        END;
        */
        // ALLE MM Code Commented

    end;


    procedure FillGRNLines(var PurchLineL: Record "Purchase Line"; recGRN: Record "GRN Header")
    var
        vLineNo: Integer;
    begin
        PurchLineL.SETRANGE("Document Type", PurchLineL."Document Type"::Order);
        PurchLineL.SETRANGE("Document No.", recGRN."Purchase Order No.");
        IF PurchLineL.FIND('-') THEN BEGIN
            REPEAT
                GRNLine.LOCKTABLE;
                GRNLine.INIT;
                GRNLine."Document Type" := recGRN."Document Type";
                GRNLine."GRN No." := recGRN."GRN No.";
                GRNLine."Line No." := PurchLineL."Line No.";
                GRNLine.Type := PurchLineL.Type.AsInteger();
                GRNLine."No." := PurchLineL."No.";
                GRNLine."Job Code" := PurchLineL."Job Code";
                IF PurchLineL.Type = PurchLineL.Type::Item THEN BEGIN
                    Item.RESET;
                    IF Item.GET(GRNLine."No.") THEN BEGIN
                        GRNLine."Tolerance Percentage" := Item."Tolerance  Percentage";
                    END;
                END;
                GRNLine.Description := PurchLineL.Description;
                GRNLine."Description 2" := PurchLineL."Description 2";
                //SC ->>11-02-06
                GRNLine."Description 3" := PurchLineL."Description 3";
                GRNLine."Description 4" := PurchLineL."Description 4";
                //SC <<-
                GRNLine."Unit of Measure Code" := PurchLineL."Unit of Measure Code";
                GRNLine.Status := recGRN.Status;
                GRNLine."Location Code" := PurchLineL."Location Code";
                GRNLine."Purchase Order No." := PurchLineL."Document No.";
                GRNLine."Purchase Order Line No." := PurchLineL."Line No.";
                GRNLine."Qty per Unit of Measure" := PurchLineL."Qty. per Unit of Measure";

                GRNLine.VALIDATE("Direct Unit Cost", PurchLineL."Direct Unit Cost");
                //SC ->>
                QtyOnGRN := 0;
                GRNLine2.RESET;
                GRNLine2.SETCURRENTKEY("Purchase Order No.", "Purchase Order Line No.", Status);
                GRNLine2.SETRANGE("Purchase Order No.", PurchLineL."Document No.");
                GRNLine2.SETRANGE("Purchase Order Line No.", PurchLineL."Line No.");
                GRNLine2.SETRANGE(Status, GRNLine2.Status::Open);
                IF GRNLine2.FIND('-') THEN BEGIN
                    REPEAT
                        QtyOnGRN := QtyOnGRN + GRNLine2."Accepted Qty";
                    UNTIL GRNLine2.NEXT = 0;
                END;

                GRNLine.VALIDATE("Order Qty", PurchLineL.Quantity - (PurchLineL."Quantity Received" + QtyOnGRN));

                //SC <<-
                /*GRNLine."Challan Qty" := PurchLinel.Quantity - PurchLinel."Quantity Received";
               GRNLine."Received Qty" := PurchLinel.Quantity - PurchLinel."Quantity Received";
               GRNLine."Accepted Qty" := GRNLine."Received Qty";*/

                //AlleDK 250308
                GRNLine."Vendor No." := PurchLineL."Buy-from Vendor No.";
                GRNLine."Shortcut Dimension 1 Code" := PurchLineL."Shortcut Dimension 1 Code";
                GRNLine."Shortcut Dimension 2 Code" := PurchLineL."Shortcut Dimension 2 Code";
                //AlleDK 250308

                GRNLine.Initiator := recGRN.Initiator;
                GRNLine.INSERT;
            UNTIL PurchLineL.NEXT = 0;

        END;

    end;


    procedure CalculateDirectUnitCost()
    begin
        //JPL04 START
        "Basic Amount" := "Basic Rate" * "Accepted Qty";
        "Discount Amt" := "Discount Rate" * "Accepted Qty";
        "Packing & Forwarding Amount" := "Packing & Forwarding per Unit" * "Accepted Qty";
        "Tot Excise Amount" := "Excise Per Unit" * "Accepted Qty";
        "Tot Sales Tax Amt" := "Sales Tax Per Unit" * "Accepted Qty";
        "Entry Tax / Octroi Amount" := "Entry Tax / Octroi Per Unit" * "Accepted Qty";
        "Freight Amount" := "Freight Rate" * "Accepted Qty";
        "Tot Service Tax Amount" := "Service Tax Per Unit-Freight" * "Accepted Qty";
        "Insurance Amount" := "Insurance Rate" * "Accepted Qty";
        "Installation & Comm. Amount" := "Installation & Comm. Rate" * "Accepted Qty";
        "ServiceTax-Inst.Comm Amount" := "ServiceTax-Inst.Comm per unit" * "Accepted Qty";
        "Bank Charges/DD Commision Amt" := "Bank Charges/DD Commision Rate" * "Accepted Qty";
        "Inspection Amount" := "Inspection Rate" * "Accepted Qty";
        "Other Amount" := "Other Rate" * "Accepted Qty";
        "Other Amount 2" := "Other Rate 2" * "Accepted Qty";
        "Line Amount" := "Direct Unit Cost" * "Accepted Qty";
        //VALIDATE("Direct Unit Cost");
        //JPL04 STOP
    end;


    procedure ShowDimensions1()
    begin
        // ALLE MM Code Commented
        /*
        TESTFIELD("GRN No.");
        TESTFIELD("Line No.");
        DocDim.SETRANGE("Table ID",DATABASE::"GRN Header");
        DocDim.SETRANGE("Document Type","Document Type");
        DocDim.SETRANGE("Document No.","GRN No.");
        DocDim.SETRANGE("Line No.","Line No.");
        DocDimensions.SETTABLEVIEW(DocDim);
        DocDimensions.RUNMODAL;
        */
        // ALLE MM Code Commented

    end;


    procedure ValidateShortcutDimCode1(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        // ALLE MM Code Commented
        /*
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        IF "GRN No." <> '' THEN BEGIN
          DimMgt.SaveDocDim(
            DATABASE::"Purchase Header","Document Type","GRN No.",0,FieldNumber,ShortcutDimCode);
          MODIFY;
        END ELSE
          DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);
        */
        // ALLE MM Code Commented

    end;


    procedure InsertGRNLinesfromSchedule(RecGRN: Record "GRN Header")
    var
        PurchScheduleLine: Record "Purch. Delivery Schedule";
        PurchScheduleForm: Page "Purchase Delivery List Form";
        ToGRNHeader: Record "GRN Header";
        GrnLinerec: Record "GRN Line";
    begin
        //ALLETG RIL0011 23-06-2011: START>>
        PurchScheduleLine.FILTERGROUP := 2;
        PurchScheduleLine.RESET;
        PurchScheduleLine.SETRANGE("Document Type", PurchScheduleLine."Document Type"::Order);
        PurchScheduleLine.SETRANGE("Document No.", RecGRN."Purchase Order No.");
        PurchScheduleLine.SETFILTER("Remaining Quantity", '<>%1', 0);
        PurchScheduleLine.FILTERGROUP := 0;
        IF PurchScheduleLine.FINDFIRST THEN
            REPEAT
                PurchScheduleLine.MARK(TRUE);
            UNTIL PurchScheduleLine.NEXT = 0;

        PurchScheduleLine.MARKEDONLY(TRUE);

        IF PurchScheduleLine.FINDFIRST THEN BEGIN
            CLEAR(PurchScheduleForm);
            PurchScheduleForm.SETTABLEVIEW(PurchScheduleLine);
            PurchScheduleForm.LOOKUPMODE := TRUE;
            PurchScheduleForm.SetGRNHeader(RecGRN);
            PurchScheduleForm.SetGRNMode(TRUE);
            PurchScheduleForm.RUNMODAL;
        END;

        // ALLE MM Code Added
        RecGRN."Shortcut Dimension 1 Code" := FromPurchHeader."Shortcut Dimension 1 Code";
        RecGRN."Shortcut Dimension 2 Code" := FromPurchHeader."Shortcut Dimension 2 Code";
        // ALLE MM Code Added

        FromPurchHeader.RESET;
        FromPurchHeader.SETRANGE("Document Type", PurchScheduleLine."Document Type"::Order);
        FromPurchHeader.SETFILTER("No.", RecGRN."Purchase Order No.");
        FromPurchHeader.FINDFIRST;
        // ALLE MM Code Commented
        /*
          DocDim.SETRANGE("Table ID",DATABASE::"GRN Header");
          DocDim.SETRANGE("Document No.",RecGRN."GRN No.");
          DocDim.SETRANGE("Line No.",0);
          DocDim.DELETEALL;

          "Shortcut Dimension 1 Code" := FromPurchHeader."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := FromPurchHeader."Shortcut Dimension 2 Code";

          FromDocDim.RESET;
          FromDocDim.SETRANGE("Table ID",DATABASE::"Purchase Header");
          FromDocDim.SETRANGE("Document Type",FromPurchHeader."Document Type");
          FromDocDim.SETRANGE("Document No.",FromPurchHeader."No.");
          IF FromDocDim.FINDSET THEN
            REPEAT
              DocDim.INIT;
              DocDim."Table ID" := DATABASE::"GRN Header";
              DocDim."Document Type" :=DocDim."Document Type"::Order;
              DocDim."Document No." := "GRN No.";
              DocDim."Line No." := 0;
              DocDim."Dimension Code" := FromDocDim."Dimension Code";
              DocDim."Dimension Value Code" := FromDocDim."Dimension Value Code";
              DocDim.INSERT;
            UNTIL FromDocDim.NEXT = 0;
            */
        // ALLE MM Code Commented

    end;


    procedure FillGRNLinesFromSchedule(var PurchScheduleLine: Record "Purch. Delivery Schedule"; RecGRN: Record "GRN Header")
    var
        vLineNo: Integer;
        ResetGRNLine: Record "GRN Line";
        LineNo: Integer;
        SchedulePurchLine: Record "Purchase Line";
    begin
        //ALLETG RIL0011 23-06-2011: START>>
        ResetGRNLine.RESET;
        ResetGRNLine.SETRANGE("Document Type", "Document Type");
        ResetGRNLine.SETRANGE("GRN No.", RecGRN."GRN No.");
        IF ResetGRNLine.FINDFIRST THEN
            ResetGRNLine.DELETEALL;

        LineNo := 10000;

        PurchScheduleLine.SETRANGE("Document Type", PurchScheduleLine."Document Type"::Order);
        PurchScheduleLine.SETRANGE("Document No.", RecGRN."Purchase Order No.");
        IF PurchScheduleLine.FINDSET THEN
            REPEAT
                SchedulePurchLine.GET(PurchScheduleLine."Document Type",
                  PurchScheduleLine."Document No.", PurchScheduleLine."Document Line No.");
                GRNLine.LOCKTABLE;
                GRNLine.INIT;
                GRNLine."Document Type" := RecGRN."Document Type";
                GRNLine."GRN No." := RecGRN."GRN No.";
                GRNLine."Line No." := LineNo;
                GRNLine.Type := PurchScheduleLine.Type;
                GRNLine."No." := PurchScheduleLine."No.";
                GRNLine."Job Code" := SchedulePurchLine."Job Code";
                IF SchedulePurchLine.Type = SchedulePurchLine.Type::Item THEN
                    IF Item.GET(GRNLine."No.") THEN
                        GRNLine."Tolerance Percentage" := Item."Tolerance  Percentage";
                GRNLine.Description := SchedulePurchLine.Description;
                GRNLine."Description 2" := SchedulePurchLine."Description 2";
                GRNLine."Description 3" := SchedulePurchLine."Description 3";
                GRNLine."Description 4" := SchedulePurchLine."Description 4";
                GRNLine."Unit of Measure Code" := SchedulePurchLine."Unit of Measure Code";
                GRNLine.Status := RecGRN.Status;
                GRNLine."Location Code" := SchedulePurchLine."Location Code";
                GRNLine."Purchase Order No." := SchedulePurchLine."Document No.";
                GRNLine."Purchase Order Line No." := SchedulePurchLine."Line No.";
                GRNLine."Qty per Unit of Measure" := SchedulePurchLine."Qty. per Unit of Measure";
                GRNLine.VALIDATE("Direct Unit Cost", SchedulePurchLine."Direct Unit Cost");

                GRNLine."Schedule Line No." := PurchScheduleLine."Line No.";

                QtyOnGRN := 0;

                GRNLine2.RESET;
                GRNLine2.SETRANGE("Document Type", GRNLine."Document Type");
                GRNLine2.SETRANGE(GRNLine2."GRN No.", GRNLine."GRN No.");
                GRNLine2.SETFILTER("Line No.", '<>%1', GRNLine."Line No.");
                GRNLine2.SETRANGE("Purchase Order No.", SchedulePurchLine."Document No.");
                GRNLine2.SETRANGE("Purchase Order Line No.", SchedulePurchLine."Line No.");
                IF GRNLine2.FIND('-') THEN
                    ERROR(Text50001, SchedulePurchLine."Line No.");

                GRNLine2.RESET;
                GRNLine2.SETCURRENTKEY("Purchase Order No.", "Purchase Order Line No.", Status);
                GRNLine2.SETRANGE("Purchase Order No.", SchedulePurchLine."Document No.");
                GRNLine2.SETRANGE("Purchase Order Line No.", SchedulePurchLine."Line No.");
                GRNLine2.SETRANGE("Schedule Line No.", PurchScheduleLine."Line No.");
                GRNLine2.SETRANGE(Status, GRNLine2.Status::Open);
                IF GRNLine2.FIND('-') THEN
                    REPEAT
                        QtyOnGRN := QtyOnGRN + GRNLine2."Accepted Qty";
                    UNTIL GRNLine2.NEXT = 0;

                GRNLine.VALIDATE("Order Qty", PurchScheduleLine."Remaining Quantity" - QtyOnGRN);

                GRNLine."Vendor No." := SchedulePurchLine."Buy-from Vendor No.";
                GRNLine."Shortcut Dimension 1 Code" := SchedulePurchLine."Shortcut Dimension 1 Code";
                GRNLine."Shortcut Dimension 2 Code" := SchedulePurchLine."Shortcut Dimension 2 Code";

                GRNLine.Initiator := RecGRN.Initiator;
                GRNLine.INSERT;
                LineNo := LineNo + 10000;
            UNTIL PurchScheduleLine.NEXT = 0;
    end;


    procedure OpenItemTrackingLines(Update: Boolean)
    var
        GRNHdr: Record "GRN Header";
        PurchaseLine: Record "Purchase Line";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
    begin
        // RAHEE1.00 240212 Start
        TESTFIELD(Type, Type::Item);
        TESTFIELD("No.");
        IF Update THEN BEGIN
            UpdatePurchaseLine;
            COMMIT;
        END;
        IF PurchaseLine.GET(PurchaseLine."Document Type"::Order, "Purchase Order No.", "Purchase Order Line No.") THEN BEGIN
            GRNHdr.GET("Document Type", "GRN No.");
            //ReservePurchLine.SetGRNQty("GRN No.","Line No."); // ALLE MM Code Commented as This function is not available in 2009 only
            ReservePurchLine.CallItemTracking(PurchaseLine);
        END;
        // RAHEE1.00 240212 End
    end;


    procedure UpdatePurchaseLine()
    var
        UpdatePurchLine: Record "Purchase Line";
    begin
        // RAHEE1.00 240212 Start
        UpdatePurchLine.GET(UpdatePurchLine."Document Type"::Order, "Purchase Order No.", "Purchase Order Line No.");
        UpdatePurchLine.VALIDATE(UpdatePurchLine."Qty. to Receive", "Received Qty");
        UpdatePurchLine.MODIFY;
        // RAHEE1.00 240212 End
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Document Type", "GRN No.", "Line No."));
        VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        VerifyItemLineDim;
    end;

    local procedure VerifyItemLineDim()
    begin
        IF IsReceivedShippedItemDimChanged THEN
            ConfirmReceivedShippedItemDimChange;
    end;


    procedure IsReceivedShippedItemDimChanged(): Boolean
    begin
        EXIT(("Dimension Set ID" <> xRec."Dimension Set ID") AND (Type = Type::Item) AND
          (("Qty Recd not Invoiced" <> 0)));
    end;


    procedure ConfirmReceivedShippedItemDimChange(): Boolean
    begin
        IF NOT CONFIRM(Text049, TRUE, TABLECAPTION) THEN
            ERROR(Text050);

        EXIT(TRUE);
    end;
}

