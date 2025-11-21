table 97731 "GRN Header"
{
    // //JPL08 GRN
    // //for BLK : Code Commented
    // //ALLE-SR-051107 : Responsibilty center added
    // Alle VK Field Added on the Blanket Order for Order Value
    // //AlleBLk : New fields added and write a code
    // ALLEAB : New fields added
    // //ALLEND : Write a code
    // ALLERP Bugfix 23-11-2010: Caption of Invoice reference No has been changed.
    // ALLEPG RIL1.09 121011 : Added field Weight Bill No
    // //ALLEDK 231211 Added code for the No. Series change in case of FBW.

    DataCaptionFields = "Sub Document Type", "GRN No.";
    DrillDownPageID = "GRN List";
    LookupPageID = "GRN List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'GRN';
            OptionMembers = GRN;

            trigger OnValidate()
            begin
                //IF "GRN No." = '' THEN
                //  PopulateNumber;
            end;
        }
        field(2; "GRN No."; Code[20])
        {
        }
        field(3; "Posting Date"; Date)
        {
            Editable = true;
        }
        field(4; "Sub Document Type"; Option)
        {
            OptionCaption = ' ,,,,,,,GRN for PO,GRN for JSPL,GRN for Packages,GRN for Fabricated Material for WO,JES for WO,GRN-Direct Purchase,Freight Advice';
            OptionMembers = " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice";
        }
        field(5; "GRN No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6; "Gate Entry No."; Code[20])
        {

            trigger OnLookup()
            begin
                GateEntryLines.RESET;
                GateEntryLines.CALCFIELDS(Used);
                GateEntryLines.SETRANGE("Entry Type", GateEntryLines."Entry Type"::Inward);
                IF "Purchase Order No." <> '' THEN
                    GateEntryLines.SETRANGE("PO No", "Purchase Order No.");
                GateEntryLines.SETRANGE(Used, FALSE);
                IF GateEntryLines.FIND('-') THEN BEGIN
                    IF PAGE.RUNMODAL(0, GateEntryLines) = ACTION::LookupOK THEN BEGIN
                        "Gate Entry No." := GateEntryLines."Gate Entry No.";
                        GateEntry.GET(GateEntry."Entry Type"::Inward, "Gate Entry No.");
                        "Gate Entry Date" := GateEntry."Document Date";
                        VALIDATE("Purchase Order No.", GateEntryLines."PO No");
                        "Vendor No." := GateEntryLines."Vendor No.";
                        "Vendor name" := GateEntryLines."Vendor Name";
                        "Challan No" := GateEntry."LR/RR No.";
                        "Challan Date" := GateEntry."LR/RR Date";
                        "Vehicle No." := GateEntry."Vehicle No.";
                        "CN/RR No." := GateEntry."RR No.";
                        "CN/RR Date" := GateEntry."RR Date";
                        Remarks := GateEntry.Remarks;
                        VALIDATE("Location Code", GateEntry."Location Code");
                        VALIDATE("Gate Entry No.", GateEntryLines."Gate Entry No.");
                        //GRNLines.InsertGRNLines(Rec);
                    END;
                END;


                /* //AlleBLK
                GateEntryLines.RESET;
                GateEntryLines.CALCFIELDS(Used);
                GateEntryLines.SETRANGE("Entry Type",GateEntryLines."Entry Type"::Inward);
                GateEntryLines.SETRANGE(Used,FALSE);
                IF GateEntryLines.FIND('-') THEN BEGIN
                  IF PAGE.RUNMODAL(0,GateEntryLines) = ACTION::LookupOK THEN BEGIN
                    "Gate Entry No.":=GateEntryLines."Gate Entry No";
                    GateEntry.GET(GateEntry."Entry Type"::Inward,"Gate Entry No.");
                    "Gate Entry Date":=GateEntry.Date;
                    VALIDATE("Purchase Order No.",GateEntryLines."PO No");
                    "Vendor No."     :=GateEntryLines."Vendor No." ;
                    "Vendor name"    :=GateEntryLines."Vendor Name";
                    "Challan No"     :=GateEntry."Challan No";
                    "Challan Date"   :=GateEntry."Challan Date";
                    "Vehicle No."    :=GateEntry."Truck/Lorry No";
                    "CN/RR No."      :=GateEntry."RR No.";
                    "CN/RR Date"     :=GateEntry."RR Date";
                    Remarks          :=GateEntry.Remarks;
                    VALIDATE("Gate Entry No.");
                    //GRNLines.InsertGRNLines(Rec);
                  END;
                END;
                */

            end;

            trigger OnValidate()
            begin
                /*  //AlleBLk
                IF ("Gate Entry No."='') THEN
                BEGIN
                
                  VALIDATE("Purchase Order No.",'');
                  "Gate Entry Date":=0D;
                  "Vendor No." :='' ;
                  "Vendor name" :='';
                
                  GRNLines.RESET;
                  GRNLines.SETRANGE("Document Type","Document Type");
                  GRNLines.SETRANGE("GRN No.","GRN No.");
                  IF GRNLines.FIND('-') THEN
                    ERROR('Purchase Order No cannot be blank');
                    //GRNLines.DELETEALL(TRUE);
                
                END;
                */

                /*
                //IF ("Gate Entry No."<>'') AND ("Purchase Order No."='') THEN
                //  ERROR('You cannot enter Gate Entry No Manually. PO No is blank');
                
                IF ("Gate Entry No."<>'') AND ("Purchase Order No."<>'') THEN BEGIN
                  GRNLines.RESET;
                  GRNLines.SETRANGE("GRN No.","GRN No.");
                  IF GRNLines.FIND('-') THEN BEGIN
                    IF "Purchase Order No." <> GRNLines."Purchase Order No." THEN
                    REPEAT
                     ERROR('Delete Lines Manually because PO No in lines is different from what has been selected');
                     //GRNLines.DELETE(TRUE);
                    UNTIL GRNLines.NEXT = 0;
                  END;
                END;
                */

            end;
        }
        field(7; "Gate Entry Date"; Date)
        {
            Editable = false;
        }
        field(8; Status; Option)
        {
            OptionCaption = 'Open,Close';
            OptionMembers = Open,Close;
        }
        field(9; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(10; "Vendor No."; Code[20])
        {
            Editable = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                Vendor.RESET;
                IF Vendor.GET("Vendor No.") THEN;
                "Vendor name" := Vendor.Name;
            end;
        }
        field(11; "Purchase Order No."; Code[20])
        {
            TableRelation = IF ("Workflow Sub Document Type" = FILTER(Regular | Direct)) "Purchase Header"."No." WHERE("Document Type" = FILTER(Order),
                                                                                                                Status = FILTER(Released),
                                                                                                                "Buy-from Vendor No." = FIELD("Vendor No."),
                                                                                                                "Responsibility Center" = FIELD("Responsibility Center"))
            ELSE IF ("Workflow Sub Document Type" = FILTER(WorkOrder)) "Purchase Header"."No." WHERE("Document Type" = FILTER(Order),
                                                                                                                                                                                                    Status = FILTER(Released),
                                                                                                                                                                                                    "Buy-from Vendor No." = FIELD("Vendor No."),
                                                                                                                                                                                                    "Responsibility Center" = FIELD("Responsibility Center"),
                                                                                                                                                                                                    "Order Status" = FILTER(' '),
                                                                                                                                                                                                    "Workflow Sub Document Type" = CONST(WorkOrder));

            trigger OnValidate()
            begin
                IF "Vendor No." <> '' THEN BEGIN
                    Vendor.GET("Vendor No.");
                    IF Vendor."BBG BHEL" THEN
                        TESTFIELD("Sent to Payment Tracking", FALSE);
                END;

                PurchHeader.RESET;
                PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
                PurchHeader.SETFILTER(PurchHeader."No.", '%1', "Purchase Order No.");
                IF PurchHeader.FIND('-') THEN BEGIN
                    "Vendor No." := PurchHeader."Buy-from Vendor No.";
                    "Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
                    IF PurchHeader.Amended THEN
                        PurchHeader.TESTFIELD("Amendment Approved");
                END;
                //VALIDATE("Vendor No.");

                GRNLines.RESET;
                GRNLines.SETRANGE("GRN No.", "GRN No.");
                IF GRNLines.FIND('-') THEN BEGIN
                    IF "Purchase Order No." <> GRNLines."Purchase Order No." THEN
                        REPEAT
                            ERROR('Delete Lines Manually because PO No in lines is different from what has been selected');
                        //GRNLines.DELETE(TRUE);
                        UNTIL GRNLines.NEXT = 0;
                END;

                IF "Vendor No." <> '' THEN BEGIN
                    Vendor.GET("Vendor No.");
                    IF Vendor."BBG BHEL" THEN
                        TESTFIELD("Sent to Payment Tracking", FALSE);
                END;
            end;
        }
        field(12; "Form 59A No"; Code[20])
        {
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            begin
                // recTranOrder.RESET;
                // recTranOrder.SETRANGE(recTranOrder."Vendor / Customer Ref.", "Vendor No.");
                // //recTranOrder.SETRANGE(recTranOrder."PO / SO No.","Purchase Order No.");
                // recTranOrder.SETFILTER(recTranOrder.Used, 'No');
                // //for BLK
                // //recTranOrder.SETFILTER(recTranOrder."Used-Ex Inv",'No');
                // //for BLK
                // IF recTranOrder.FIND('-') THEN BEGIN
                //     IF PAGE.RUNMODAL(0, recTranOrder) = ACTION::LookupOK THEN BEGIN
                //         "Form 59A No" := recTranOrder."Form No.";
                //     END;

                // END;
            end;
        }
        field(13; "Challan No"; Code[20])
        {

            trigger OnValidate()
            begin
                // ALLEAA
                GRNHeader.RESET;
                GRNHeader.SETRANGE("Vendor No.", Rec."Vendor No.");
                IF GRNHeader.FINDSET THEN
                    REPEAT
                        IF Rec."Challan No" <> xRec."Challan No" THEN
                            IF GRNHeader."Challan No" = Rec."Challan No" THEN
                                ERROR(Text50000, Rec."Vendor No.");
                    UNTIL GRNHeader.NEXT = 0;
                // ALLEAA
            end;
        }
        field(14; "Challan Date"; Date)
        {
        }
        field(15; "Bill No"; Code[20])
        {

            trigger OnValidate()
            begin
                IF Vendor.GET("Vendor No.") THEN BEGIN
                    IF Vendor."BBG BHEL" THEN BEGIN
                        GRNHdr.SETRANGE("Document Type", GRNHdr."Document Type"::GRN);
                        GRNHdr.SETRANGE("Vendor No.", "Vendor No.");
                        GRNHdr.SETRANGE("Bill No", "Bill No");
                        GRNHdr.SETFILTER("GRN No.", '<>%1', "GRN No.");
                        IF GRNHdr.FIND('-') THEN
                            ERROR('Excise Bill No. already entered for GRN No: %1', GRNHdr."GRN No.");
                    END;
                END;
            end;
        }
        field(16; "Bill Date"; Date)
        {
        }
        field(17; "CN/RR No."; Code[20])
        {
        }
        field(18; "CN/RR Date"; Date)
        {
        }
        field(19; "Mode of Transport"; Option)
        {
            OptionMembers = Road,Rail,Sea,Air;
        }
        field(20; "Vehicle No."; Text[30])
        {
        }
        field(21; Remarks; Text[50])
        {
        }
        field(22; "Reason for Rejection"; Text[50])
        {
        }
        field(23; "Rejection Note No."; Code[20])
        {
            Editable = false;
        }
        field(24; "Document Date"; Date)
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(50001; "Responsibility Center"; Code[10])
        {
            Description = 'AlleBLk';
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                //ALLE-SR-051107 >>
                IF NOT UserMgt.CheckRespCenter(1, "Responsibility Center") THEN
                    ERROR(
                      Text028,
                       RespCenter.TABLECAPTION, UserMgt.GetPurchasesFilter());

                VALIDATE("Location Code", UserMgt.GetLocation(1, '', "Responsibility Center"));

                //ALLE-SR-051107 <<
            end;
        }
        field(50003; Approved; Boolean)
        {
            Description = 'AlleBLk';

            trigger OnValidate()
            begin
                IF Approved THEN BEGIN
                    Vendor.GET("Vendor No.");
                    IF Vendor."BBG BHEL" THEN BEGIN
                        CALCFIELDS("Total GRN Value", "Total Excise amount", "Total Sales tax amount");
                        IF "Total GRN Value" = 0 THEN
                            ERROR('GRN Amount cannot be zero');

                        TESTFIELD("Commercial Invoice No");
                        TESTFIELD("Commercial Invoice Date");

                        IF "Sub Document Type" = "Sub Document Type"::"Freight Advice" THEN BEGIN
                            /*FrInvRec.RESET;
                            FrInvRec.SETRANGE("Document Type","Document Type");
                            FrInvRec.SETRANGE("GRN No.","GRN No.");
                            IF FrInvRec.FIND('-') THEN BEGIN
                              REPEAT
                                FrInvRec.TESTFIELD("Ref Material Comm Inv No");
                                FrInvRec.TESTFIELD("Ref Material MRC Inv  No");
                              UNTIL FrInvRec.NEXT=0;
                            END
                            ELSE BEGIN
                              TESTFIELD("Ref Mat. Comm Inv No");
                              TESTFIELD("Ref Mat. MRC Invoice No-20%");
                            END;
                            */
                        END;

                        TESTFIELD("Purchase Order No.");
                        TESTFIELD(Status, Status::Open);
                        TESTFIELD("Material Despatched Date");
                        TESTFIELD("Sent to Payment Tracking", TRUE);
                        TESTFIELD("MRC Invoice No -20%");
                        TESTFIELD("MRC Invoice Date");
                        TESTFIELD("Document Date");
                        TESTFIELD("Posting Date");

                        //for BLK
                        /*
                           IF "Sub Document Type"<>"Sub Document Type"::"Freight Advice" THEN BEGIN
                            ExInvRec.RESET;
                            ExInvRec.SETRANGE("Document Type","Document Type");
                            ExInvRec.SETRANGE("GRN No.","GRN No.");
                            IF NOT ExInvRec.FIND('-') THEN
                              ERROR('Excise Invoices not defined.');

                            REPEAT
                              ExInvRec.TESTFIELD("Excise Invoice No");
                              ExInvRec.TESTFIELD("Excise Invoice Date");
                              ExInvRec.TESTFIELD("Gate Entry No");
                              ExInvRec.TESTFIELD(Quantity);
                              ExInvRec.TESTFIELD("RR/LR No");
                              ExInvRec.TESTFIELD("RR/LR Date");
                              ExInvRec.TESTFIELD("Vehicle No.");
                              ExInvRec.TESTFIELD("Form 59 A");
                            UNTIL ExInvRec.NEXT=0;
                           END;
                        */
                        //for BLK
                    END;

                    GRNLines.RESET;
                    GRNLines.SETRANGE("Document Type", "Document Type");
                    GRNLines.SETRANGE("GRN No.", "GRN No.");
                    IF GRNLines.FIND('-') THEN BEGIN
                        REPEAT
                            GRNLines.Approved := TRUE;
                            ;
                            GRNLines.MODIFY(TRUE);
                        UNTIL GRNLines.NEXT = 0;
                    END;
                END;

            end;
        }
        field(50004; "Approved Date"; Date)
        {
            Description = 'AlleBLk';
        }
        field(50005; "Approved Time"; Time)
        {
            Description = 'AlleBLk';
        }
        field(50010; Initiator; Code[20])
        {
            Description = 'AlleBLk';
            TableRelation = User;
        }
        field(50016; "Sent for Approval"; Boolean)
        {
            Description = 'AlleBLk';

            trigger OnValidate()
            begin
                IF "Sent for Approval" THEN BEGIN
                    Vendor.GET("Vendor No.");
                    IF Vendor."BBG BHEL" THEN BEGIN
                        CALCFIELDS("Total GRN Value", "Total Excise amount", "Total Sales tax amount");
                        IF "Total GRN Value" = 0 THEN
                            ERROR('GRN Amount cannot be zero');

                        TESTFIELD("Commercial Invoice No");
                        TESTFIELD("Commercial Invoice Date");

                        /*  //AlleBLK
                       IF "Sub Document Type"<>"Sub Document Type"::"Freight Advice" THEN
                         TESTFIELD("Bill No");

                        */
                        IF "Sub Document Type" = "Sub Document Type"::"Freight Advice" THEN BEGIN
                            /*FrInvRec.RESET;
                            FrInvRec.SETRANGE("Document Type","Document Type");
                            FrInvRec.SETRANGE("GRN No.","GRN No.");
                            IF FrInvRec.FIND('-') THEN BEGIN
                              REPEAT
                                FrInvRec.TESTFIELD("Ref Material Comm Inv No");
                              UNTIL FrInvRec.NEXT=0;
                            END
                            ELSE
                              TESTFIELD("Ref Mat. Comm Inv No");
                            //TESTFIELD("Ref Mat. MRC Invoice No-20%");
                            */
                        END;

                        TESTFIELD("Purchase Order No.");
                        TESTFIELD(Status, Status::Open);
                        TESTFIELD("Material Despatched Date");
                        TESTFIELD("Sent to Payment Tracking", TRUE);
                        //TESTFIELD("MRC Invoice No -20%");
                        //TESTFIELD("Document Date");
                        TESTFIELD("Posting Date");
                    END;

                    DocType.GET(DocType."Document Type"::GRN, "Sub Document Type");
                    DocInitiator.GET(DocType."Document Type"::GRN, "Sub Document Type", Initiator);

                    IF NOT Vendor."BBG BHEL" THEN BEGIN
                        IF DocType."Gate Entry Required" THEN BEGIN
                            TESTFIELD("Gate Entry No.");
                            GateEntryLine.GET(GateEntryLine."Entry Type"::Inward, "Gate Entry No.", "Purchase Order No.");
                        END;
                    END;

                    GRNLines.RESET;
                    GRNLines.SETRANGE("Document Type", "Document Type");
                    GRNLines.SETRANGE("GRN No.", "GRN No.");
                    IF NOT GRNLines.FIND('-') THEN BEGIN
                        ERROR('GRN Lines not entered');
                    END;
                END;

            end;
        }
        field(50017; "Creation Date"; Date)
        {
            Description = 'AlleBLk';
        }
        field(50018; "Creation Time"; Time)
        {
            Description = 'AlleBLk';
        }
        field(50019; "Sent for Approval Date"; Date)
        {
            Description = 'AlleBLk';
        }
        field(50020; "Sent for Approval Time"; Time)
        {
            Description = 'AlleBLk';
        }
        field(50021; "Vendor name"; Text[60])
        {
            Description = 'AlleBLk';
        }
        field(50022; "Rejection No. Series"; Code[20])
        {
            Description = 'AlleBLk';
            TableRelation = "No. Series";
        }
        field(50023; "Posted GRN No. Series"; Code[20])
        {
            Description = 'AlleBLk';
            TableRelation = "No. Series";
        }
        field(50024; "Posted GRN No."; Code[20])
        {
            CalcFormula = Lookup("Purch. Rcpt. Header"."No." WHERE("UnPosted GRN No" = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
            TableRelation = "Purch. Rcpt. Header";
        }
        field(50025; "Commercial Invoice No"; Code[20])
        {
            Description = 'AlleBLk';
        }
        field(50026; "Bill Amount"; Decimal)
        {
            Description = 'AlleBLk';
        }
        field(50027; "Sent to Payment Tracking"; Boolean)
        {
            Description = 'AlleBLk';
        }
        field(50028; "Material Despatched Date"; Date)
        {
            Description = 'AlleBLk';
        }
        field(50029; "Total GRN Value"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Line Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                              "GRN No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(50030; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = 'AlleBLk';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
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
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                MODIFY;
            end;
        }
        field(50032; "Sub Document"; Option)
        {
            Description = 'ALLEAB';
            OptionCaption = ' ,WO-ICB,WO-NICB,Regular PO,Repeat PO,Confirmatory PO,Direct PO';
            OptionMembers = " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO";
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
        field(50100; "Initiator User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Manufacturer Certificate Recd"; Boolean)
        {
            Description = 'KLND1.00 140311';
        }
        field(50103; "Third Party Certificate Recd"; Boolean)
        {
            Description = 'KLND1.00 140311';
        }
        field(50105; "Internal Certificate Recd"; Boolean)
        {
            Description = 'KLND1.00 140311';
        }
        field(50106; "Way Bill No"; Text[30])
        {
        }
        field(70000; "Total Base Amount"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Basic Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                               "GRN No." = FIELD("GRN No.")));
            Description = 'Alle VK Field Added on the Blanket Order for Order Value';
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //"Total Order Value" := ("Total Order Value" + Rec."Total Base Amount")-xRec."Total Base Amount";
            end;
        }
        field(70001; "Total Excise amount"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Tot Excise Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                    "GRN No." = FIELD("GRN No.")));
            Description = 'Alle VK Field Added on the Blanket Order for Order Value';
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //"Total Order Value" := ("Total Order Value" + Rec."Total Excise amount")-xRec."Total Excise amount";
            end;
        }
        field(70002; "Total Sales tax amount"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Tot Sales Tax Amt" WHERE("Document Type" = FIELD("Document Type"),
                                                                    "GRN No." = FIELD("GRN No.")));
            Description = 'Alle VK Field Added on the Blanket Order for Order Value';
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //"Total Order Value" := ("Total Order Value" + Rec."Total Sales tax amount")-xRec."Total Sales tax amount";
            end;
        }
        field(70003; "Tot Service tax -Freight"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Tot Service Tax Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "GRN No." = FIELD("GRN No.")));
            Description = 'Alle VK Field Added on the Blanket Order for Order Value';
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //"Total Order Value" := ("Total Order Value" + Rec."Total Service tax amount")-xRec."Total Service tax amount";
            end;
        }
        field(70004; "Total Other Amount"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Other Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                               "GRN No." = FIELD("GRN No.")));
            Description = 'Alle VK Field Added on the Blanket Order for Order Value';
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //"Total Order Value" := ("Total Order Value" + Rec."Total Other tax/duties amount")-xRec."Total Other tax/duties amount";
            end;
        }
        field(70005; "Total Entry Tax/Octroi Amount"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Entry Tax / Octroi Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                            "GRN No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(70006; "Total Insurance Amount"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Insurance Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                   "GRN No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(70007; "Total Packing & For Amount"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Packing & Forwarding Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                              "GRN No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(70008; "Total Freight Amount"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Freight Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                 "GRN No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(70010; "Intallation & Comm Amount"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Installation & Comm. Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                              "GRN No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(70011; "Service Tax-Install & Comm Amt"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."ServiceTax-Inst.Comm Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                              "GRN No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(70012; "Bank Charges/DD Comm. Amt"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Bank Charges/DD Commision Amt" WHERE("Document Type" = FIELD("Document Type"),
                                                                                "GRN No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(70013; "Other 2 Amount"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Other Amount 2" WHERE("Document Type" = FIELD("Document Type"),
                                                                 "GRN No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(70014; "Inspection Amount"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Inspection Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                    "GRN No." = FIELD("GRN No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
        }
        field(70015; "MRC Invoice No -20%"; Code[20])
        {
            Description = 'AlleBLk';
        }
        field(70016; "Ref Mat. Comm Inv No"; Code[20])
        {
            Description = 'AlleBLk';

            trigger OnLookup()
            begin
                /*TrackPayment.SETRANGE("Document No.","Purchase Order No.");
                //TrackPayment.SETFILTER("Commercial Invoice No",'%1',"Ref Mat. Comm Inv No");
                TrackPayment.SETRANGE("Freight Bill",FALSE);
                IF PAGE.RUNMODAL(50007,TrackPayment) = ACTION::LookupOK THEN
                  "Ref Mat. Comm Inv No":=TrackPayment."Commercial Invoice No";
                */

            end;

            trigger OnValidate()
            begin
                IF "Sub Document Type" = "Sub Document Type"::"Freight Advice" THEN BEGIN
                    IF Vendor.GET("Vendor No.") THEN BEGIN
                        IF Vendor."BBG BHEL" AND ("Ref Mat. Comm Inv No" <> '') THEN BEGIN
                            GRNHdr.SETRANGE("Document Type", GRNHdr."Document Type"::GRN);
                            GRNHdr.SETRANGE("Vendor No.", "Vendor No.");
                            GRNHdr.SETFILTER("Ref Mat. Comm Inv No", '=%1', "Ref Mat. Comm Inv No");
                            GRNHdr.SETFILTER("GRN No.", '<>%1', "GRN No.");
                            IF GRNHdr.FIND('-') THEN
                                ERROR('Reference Supply Comm Inv No-60% has already entered for GRN No: %1', GRNHdr."GRN No.");
                        END;
                    END;
                END;
            end;
        }
        field(70017; "Ref Mat. MRC Invoice No-20%"; Code[20])
        {
            Description = 'AlleBLk';

            trigger OnLookup()
            begin
                /*TrackPayment.SETRANGE("Document No.","Purchase Order No.");
                TrackPayment.SETFILTER("Commercial Invoice No",'%1',"Ref Mat. Comm Inv No");
                //TrackPayment.SETFILTER("MRC Invoice No -20 %",'%1',"MRC Invoice No -20%");
                TrackPayment.SETRANGE("Freight Bill",FALSE);
                IF PAGE.RUNMODAL(50007,TrackPayment) = ACTION::LookupOK THEN
                  "Ref Mat. MRC Invoice No-20%":=TrackPayment."MRC Invoice No -20 %";
                 */

            end;

            trigger OnValidate()
            begin
                IF "Sub Document Type" = "Sub Document Type"::"Freight Advice" THEN BEGIN
                    IF Vendor.GET("Vendor No.") THEN BEGIN
                        IF Vendor."BBG BHEL" AND ("Ref Mat. MRC Invoice No-20%" <> '') THEN BEGIN
                            GRNHdr.SETRANGE("Document Type", GRNHdr."Document Type"::GRN);
                            GRNHdr.SETRANGE("Vendor No.", "Vendor No.");
                            GRNHdr.SETFILTER("Ref Mat. MRC Invoice No-20%", '=%1', "Ref Mat. MRC Invoice No-20%");
                            GRNHdr.SETFILTER("GRN No.", '<>%1', "GRN No.");
                            IF GRNHdr.FIND('-') THEN
                                ERROR('Reference Supply MRC Invoice No-20% has already entered for GRN No: %1', GRNHdr."GRN No.");
                        END;
                    END;
                END;
            end;
        }
        field(70018; "Transporter Name"; Text[50])
        {
            Description = 'SC Added';
        }
        field(70020; "Commercial Invoice Date"; Date)
        {
            Description = 'AlleBLk';
        }
        field(70021; "MRC Invoice Date"; Date)
        {
            Description = 'AlleBLk';
        }
        field(70022; "Sales Tax Not Applicable"; Boolean)
        {
            Description = 'AlleBLk';
        }
        field(70023; "Sent for Payment Tracking Date"; Date)
        {
            Description = 'AlleBLk';
        }
        field(70024; "Sent for Payment Tracking Time"; Time)
        {
            Description = 'AlleBLk';
        }
        field(80000; "Quality Certificate No."; Code[20])
        {
            Description = 'ALLEAB';
        }
        field(80001; "Invoice Ref. No."; Code[20])
        {
            Caption = 'Ref.No.';
            Description = 'ALLEAA';
        }
    }

    keys
    {
        key(Key1; "Document Type", "GRN No.")
        {
            Clustered = true;
        }
        key(Key2; "Purchase Order No.", "Creation Date")
        {
        }
        key(Key3; "GRN No.", "Creation Date")
        {
        }
        key(Key4; "Vendor name", "Creation Date")
        {
        }
        key(Key5; "Gate Entry No.")
        {
        }
        key(Key6; "Shortcut Dimension 1 Code")
        {
        }
        key(Key7; Initiator, "Shortcut Dimension 1 Code", "Document Type", "Sub Document Type", "Sub Document", Status)
        {
        }
        key(Key8; "Shortcut Dimension 1 Code", "Posting Date", "Vendor No.", Status, Approved)
        {
        }
        key(Key9; "Challan No")
        {
        }
        key(Key10; "Sub Document Type", "Shortcut Dimension 1 Code", "Approved Date", "GRN No.")
        {
        }
        key(Key11; "Document Type", "Challan No", "GRN No.", Status)
        {
        }
        key(Key12; "GRN No.", Status)
        {
        }
        key(Key13; Initiator, "Responsibility Center", "Document Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DocApproval: Record "Document Type Approval";
    begin
        TESTFIELD("Sent for Approval", FALSE);
        //ALLE-SR-051107 >>
        IF NOT UserMgt.CheckRespCenter(1, "Responsibility Center") THEN
            ERROR(
              Text023,
              RespCenter.TABLECAPTION, UserMgt.GetPurchasesFilter());
        //ALLE-SR-051107 <<

        TESTFIELD(Approved, FALSE);
        //TESTFIELD(Status,Status::Open);

        GRNLines.RESET;
        GRNLines.SETRANGE("Document Type", "Document Type");
        GRNLines.SETRANGE("GRN No.", "GRN No.");
        IF GRNLines.FIND('-') THEN
            GRNLines.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    var
        DocSetup: Record "Document Type Setup";
        DocInitiator: Record "Document Type Initiator";
        DocApproval: Record "Document Type Approval";
        DocumentApproval: Record "Document Type Approval";
    begin
        IF WORKDATE < 20080221D THEN
            ERROR('You can not work on this workdate');

        //JPL START
        Initiator := USERID;
        "Initiator User ID" := USERID;
        "Creation Date" := TODAY;
        "Creation Time" := TIME;

        IF "GRN No." = '' THEN BEGIN
            PopulateNumber;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."GRN No. Series", WORKDATE, "GRN No.", "GRN No. Series");
            "Posted GRN No. Series" := "GRN No. Series";
        END;


        //ALLE-SR-051107 >>
        "Responsibility Center" := UserMgt.GetRespCenter(1, "Responsibility Center");
        //ALLE-SR-051107 <<

        //ALLEND 191107
        RecUserSetup.RESET;
        RecUserSetup.SETRANGE("User ID", Initiator);
        IF RecUserSetup.FIND('-') THEN BEGIN
            //"Responsibility Center" := RecUserSetup."Purchase Resp. Ctr. Filter";
            RecRespCenter.RESET;
            RecRespCenter.SETRANGE(Code, RecUserSetup."Purchase Resp. Ctr. Filter");
            IF RecRespCenter.FIND('-') THEN BEGIN
                "Shortcut Dimension 1 Code" := RecRespCenter."Global Dimension 1 Code";
                "Location Code" := RecRespCenter."Location Code";
            END;
        END;
        //ALLEND 191107
    end;

    trigger OnModify()
    begin
        //TESTFIELD(Approved,FALSE);
        //TESTFIELD(Status,Status::Open);

        /*IF "Sub Document Type"="Sub Document Type"::"Freight Advice" THEN BEGIN
          FreightMRCRec.SETRANGE("Document Type","Document Type");
          FreightMRCRec.SETRANGE("GRN No.", "GRN No.");
          IF FreightMRCRec.FIND('-') THEN BEGIN
            REPEAT
              FreightMRCRec."Commercial Inv No":="Commercial Invoice No";
              FreightMRCRec."MRC Inv No":="MRC Invoice No -20%";
              FreightMRCRec."PO No":="Purchase Order No.";
              FreightMRCRec.MODIFY;
            UNTIL FreightMRCRec.NEXT=0;
          END;
        END;
         */

    end;

    var
        PurchHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        GRNLines: Record "GRN Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurAndPay: Record "Purchases & Payables Setup";
        GateEntryLines: Record "Gate Entry Line";// 16553;
        GateEntry: Record "Gate Entry Header";// 16552;
        GRNHdr: Record "GRN Header";
        DocType: Record "Document Type Setup";
        GateEntryLine: Record "Gate Entry Line";// 16553;
        DocInitiator: Record "Document Type Initiator";
        //recTranOrder: Record "Transit Document Order Details"; //13768;
        UserTaskNew: Record "User Tasks New";
        UserMgt: Codeunit "EPC User Setup Management";
        RespCenter: Record "Responsibility Center 1";
        Text023: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text028: Label 'Your identification is set up to process from %1 %2 only.';
        DimMgt: Codeunit DimensionManagement;
        Short1name: Text[30];
        Respname: Text[30];
        Locname: Text[30];
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        GRNHeader: Record "GRN Header";
        Text50000: Label 'Challan no. already exists for the vendor %1.';
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        HideValidationDialog: Boolean;
        PurchaseHeader2: Record "Purchase Header";
        WorkflowDocTypeSetup: Record "Workflow Doc. Type Setup";
        StatusCheckSuspended: Boolean;
        PurchSetup: Record "Purchases & Payables Setup";
        Location: Record Location;


    procedure PopulateNumber()
    var
        DocSetup: Record "Document Type Setup";
    begin
        PurchSetup.GET;
        RecUserSetup.GET(USERID);
        TESTFIELD("Workflow Sub Document Type");

        IF RespCenter.GET(RecUserSetup."Purchase Resp. Ctr. Filter") THEN BEGIN
            Location.GET(RespCenter.Code);
            IF "Workflow Sub Document Type" = "Workflow Sub Document Type"::Regular THEN BEGIN
                IF Location."Trading Location" THEN
                    RespCenter.TESTFIELD("GRN Nos. Trading")
                ELSE
                    RespCenter.TESTFIELD("Goods Receipt Nos.")
            END ELSE IF "Workflow Sub Document Type" = "Workflow Sub Document Type"::Direct THEN BEGIN
                IF RespCenter.Trading THEN
                    RespCenter.TESTFIELD("GRN Nos. Direct Trading")
                ELSE
                    RespCenter.TESTFIELD("GRN No. Series Direct");
            END ELSE IF "Workflow Sub Document Type" = "Workflow Sub Document Type"::WorkOrder THEN BEGIN
                IF Location."Trading Location" THEN
                    RespCenter.TESTFIELD("SRN Nos. Trading")
                ELSE
                    RespCenter.TESTFIELD("SRN Nos.");
            END
        END ELSE
            PurchSetup.TESTFIELD("Posted Receipt Nos.");
    end;


    procedure GetDiscountAmt(var pDiscountAmt: Decimal)
    var
        vGRNLine: Record "GRN Line";
    begin
        pDiscountAmt := 0;
        vGRNLine.RESET;
        vGRNLine.SETRANGE("Document Type", "Document Type");
        vGRNLine.SETRANGE("GRN No.", "GRN No.");
        vGRNLine.SETFILTER("Discount Amt", '<>0');
        IF vGRNLine.FIND('-') THEN BEGIN
            REPEAT
                pDiscountAmt := pDiscountAmt + vGRNLine."Discount Amt";
            UNTIL vGRNLine.NEXT = 0;
        END;
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


    procedure ShowDocDim1()
    begin
        // ALLE MM Code Commented
        /*
        DocDim.SETRANGE("Table ID",DATABASE::"GRN Header");
        //DocDim.SETRANGE("Document Type","Document Type");
        DocDim.SETRANGE("Document No.","GRN No.");
        DocDim.SETRANGE("Line No.",0);
        DocDims.SETTABLEVIEW(DocDim);
        DocDims.RUNMODAL;
        GET("Document Type","GRN No.");
        */
        // ALLE MM Code Commented

    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF "GRN No." <> '' THEN
            MODIFY;

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF PurchLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "Document Type", "GRN No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF PurchLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
        ReceivedShippedItemLineDimChangeConfirmed: Boolean;
    begin
        // Update all lines with changed dimensions.

        IF NewParentDimSetID = OldParentDimSetID THEN
            EXIT;
        IF NOT CONFIRM(Text051) THEN
            EXIT;

        GRNLines.RESET;
        GRNLines.SETRANGE("Document Type", "Document Type");
        GRNLines.SETRANGE("GRN No.", "GRN No.");
        GRNLines.LOCKTABLE;
        IF GRNLines.FIND('-') THEN
            REPEAT
                NewDimSetID := DimMgt.GetDeltaDimSetID(GRNLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                IF GRNLines."Dimension Set ID" <> NewDimSetID THEN BEGIN
                    GRNLines."Dimension Set ID" := NewDimSetID;

                    IF NOT HideValidationDialog AND GUIALLOWED THEN
                        VerifyReceivedShippedItemLineDimChange(ReceivedShippedItemLineDimChangeConfirmed);

                    DimMgt.UpdateGlobalDimFromDimSetID(
                      GRNLines."Dimension Set ID", GRNLines."Shortcut Dimension 1 Code", GRNLines."Shortcut Dimension 2 Code");
                    GRNLines.MODIFY;
                END;
            UNTIL GRNLines.NEXT = 0;
    end;


    procedure PurchLinesExist(): Boolean
    begin
        GRNLines.RESET;
        GRNLines.SETRANGE("Document Type", "Document Type");
        GRNLines.SETRANGE("GRN No.", "GRN No.");
        EXIT(GRNLines.FINDFIRST);
    end;

    local procedure VerifyReceivedShippedItemLineDimChange(var ReceivedShippedItemLineDimChangeConfirmed: Boolean)
    begin
        IF GRNLines.IsReceivedShippedItemDimChanged THEN
            IF NOT ReceivedShippedItemLineDimChangeConfirmed THEN
                ReceivedShippedItemLineDimChangeConfirmed := GRNLines.ConfirmReceivedShippedItemDimChange;
    end;

    [IntegrationEvent(TRUE, false)]

    procedure OnCheckPurchasePostRestrictions()
    begin
    end;

    [IntegrationEvent(TRUE, false)]

    procedure OnCheckPurchaseReleaseRestrictions()
    begin
    end;


    procedure CheckBeforeRelease()
    var
        DimSetEntry: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
    begin
        IF "Purchase Order No." <> '' THEN BEGIN
            PurchaseHeader2.GET(PurchaseHeader2."Document Type"::Order, "Purchase Order No.");
            //PurchaseHeader2.TESTFIELD(Status,PurchaseHeader2.Status::Released);
        END;

        TESTFIELD("Posting Date");

        IF WorkflowDocTypeSetup.GET(6, 1, "Workflow Sub Document Type") THEN
            IF WorkflowDocTypeSetup."Gate Entry Required" THEN BEGIN
                TESTFIELD("Gate Entry No.");
                GateEntryLine.GET(GateEntryLine."Entry Type"::Inward, "Gate Entry No.", "Purchase Order No.");
            END;

        GRNLines.RESET;
        GRNLines.SETRANGE("Document Type", "Document Type");
        GRNLines.SETRANGE("GRN No.", "GRN No.");
        GRNLines.FINDFIRST;
        REPEAT
            GRNLines.TESTFIELD("Accepted Qty");
        UNTIL GRNLines.NEXT = 0;
        /*
        GLSetup.GET;
        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID","Dimension Set ID");
        DimSetEntry.SETRANGE("Dimension Code",GLSetup."Global Dimension 1 Code");
        IF DimSetEntry.ISEMPTY THEN
          ERROR('Dimension %1 not specified.',GLSetup."Global Dimension 1 Code");
        
        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID","Dimension Set ID");
        DimSetEntry.SETRANGE("Dimension Code",GLSetup."Global Dimension 2 Code");
        IF DimSetEntry.ISEMPTY THEN
          ERROR('Dimension %1 not specified.',GLSetup."Global Dimension 2 Code");
          */

    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;


    procedure GetNoSeriesCode(): Code[10]
    var
        Location: Record Location;
    begin
        PurchSetup.GET;
        RecUserSetup.GET(USERID);
        TESTFIELD("Workflow Sub Document Type");

        IF RespCenter.GET(RecUserSetup."Purchase Resp. Ctr. Filter") THEN BEGIN
            Location.GET(RespCenter.Code);
            IF "Workflow Sub Document Type" = "Workflow Sub Document Type"::Regular THEN BEGIN
                IF Location."Trading Location" THEN
                    EXIT(RespCenter."GRN Nos. Trading")
                ELSE
                    EXIT(RespCenter."Goods Receipt Nos.")
            END ELSE IF "Workflow Sub Document Type" = "Workflow Sub Document Type"::Direct THEN BEGIN
                IF RespCenter.Trading THEN
                    EXIT(RespCenter."GRN Nos. Direct Trading")
                ELSE
                    EXIT(RespCenter."GRN No. Series Direct");
            END ELSE IF "Workflow Sub Document Type" = "Workflow Sub Document Type"::WorkOrder THEN BEGIN
                IF Location."Trading Location" THEN
                    EXIT(RespCenter."SRN Nos. Trading")
                ELSE
                    EXIT(RespCenter."SRN Nos.");
            END
        END ELSE
            EXIT(PurchSetup."Posted Receipt Nos.");
    end;
}

